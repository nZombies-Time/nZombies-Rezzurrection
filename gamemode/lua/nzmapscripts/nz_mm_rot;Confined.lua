util.AddNetworkString("LoganRunSound")

local skullspawns = {
    {pos = Vector(304.499237, 1010.673462, 284.557831), ang = Angle(44.986, 147.314, -0.003)}, --Corner of main room
    {pos = Vector(-820.094360, 2237.027832, -28.537106), ang = Angle(-0.000, -156.880, 45.000)}, --In fireplace
    {pos = Vector(1473.607910, 1561.651367, 144.410141), ang = Angle(-29.361, -155.950, 17.396)}, --Out of map, against against handrails
    {pos = Vector(796.942261, 1123.194824, 278.961273), ang = Angle(45.000, 146.000, 0.000)} --Corner above Jugg
}

local flavorskulls = {
    {pos = Vector(-12.794922, -472.857483, -61.672523), ang = Angle(-46.073, 93.528, -3.181)},
    {pos = Vector(0.457985, -469.424957, -60.480034), ang = Angle(-44.190, 41.347, 17.533)},
    {pos = Vector(-22.606207, -467.593475, -60.053642), ang = Angle(-44.648, 137.528, -27.707)}
}

local busts = {
    1372, 1373, destroyed = 0
}

local jars = {
    1753, 1745, 1707, 2024
}

local jardepository = {
    {pos = Vector(-1111.5, 1985, 130), ang = Angle(0.000, 0.000, 0.000), mdl = "models/props_c17/concrete_barrier001a.mdl"},
    {pos = Vector(-1143, 1985, 130), ang = Angle(0.000, 0.000, 0.000), mdl = "models/props_c17/concrete_barrier001a.mdl"},
    {pos = Vector(-1127.5, 1952, 174), ang = Angle(0.000, 0.000, -0.000), mdl = "models/props_junk/metalbucket02a.mdl", usable = true},
    {pos = Vector(-1127.5, 2018.5, 174), ang = Angle(0.000, 0.000, -0.000), mdl = "models/props_junk/metalbucket02a.mdl", usable = true},
    {pos = Vector(-1127.8, 1985.9, 154.8), ang = Angle(0.000, 90.000, 0.000), mdl = "models/props_lab/filecabinet02.mdl"},
    {pos = Vector(-1107.3, 1989.6, 256.5), ang = Angle(-90.000, -0.000, 180.000), mdl = "models/props_junk/trashdumpster02b.mdl"}
}
local placedjars = {
    {pos = Vector(-1127.5, 2026, 171), ang = Angle(0.000, 90.000, -0.000), mdl = "models/props/spookington/eyejar.mdl"},
    {pos = Vector(-1127.5, 2010.5, 171), ang = Angle(0.000, -177.360, 0.000), mdl = "models/props/spookington/eyejar.mdl"},
    {pos = Vector(-1127.5, 1960.5, 171), ang = Angle(0.000, 92.200, 0.000), mdl = "models/props/spookington/eyejar.mdl"},
    {pos = Vector(-1127.5, 1944, 171), ang = Angle(0.000, 63.460, 0.000), mdl = "models/props/spookington/eyejar.mdl"}
}
local hintbust = {pos = Vector(-1127, 1987, 184.7), ang = Angle(0.000, 0.000, 0.000), mdl = "models/props_combine/breenbust.mdl"}

local mapscript = {}

local eyeballs = nzItemCarry:CreateCategory("eyeballs")
	eyeballs:SetIcon("spawnicons/models/props_lab/jar01b_64.png")
	eyeballs:SetText("Press E to pick up the jar of eyes")
	eyeballs:SetDropOnDowned(false)
	eyeballs:SetShowNotification(true)
	eyeballs:SetResetFunction(function(self)
		for _, id in pairs(jars) do
			local ent = ents.GetMapCreatedEntity(id)
			self:RegisterEntity(ent)
		end
        for _, ply in pairs(player.GetAll()) do
            if ply:HasCarryItem("eyeballs") then
                ply:RemoveCarryItem("eyeballs")
            end
        end
	end)
	eyeballs:SetPickupFunction(function(self, ply, ent)
        ply:GiveCarryItem(self.id)
        ent:Remove()
	end)
	eyeballs:SetCondition( function(self, ply)
		return !ply:HasCarryItem("eyeballs")
	end)
eyeballs:Update()

function mapscript.OnGameBegin()
    mapscript.hintcount = 0
    eyeballs:Reset()

    for _, tab in pairs(skullspawns) do
        tab.destroyed = false
        local ent = ents.Create("nz_script_prop")
        ent:SetModel("models/monstermash/gibs/head_skull.mdl")
        ent:SetPos(tab.pos)
        ent:SetAngles(tab.ang)
        ent:Spawn()
        ent.OnTakeDamage = function(_, dmginfo)
            if !dmginfo or !dmginfo:GetAttacker():IsPlayer() or !dmginfo:IsBulletDamage() then return end
            ent:Remove()
            tab.destroyed = true

            for k, v in pairs(skullspawns) do
                if !v.destroyed then 
                    net.Start("LoganRunSound")
                        net.WriteString("ambient/creatures/town_moan1.wav")
                        net.WriteInt(90, 16)
                    net.Broadcast()
                    return
                end
            end
            
            nzElec:Activate()
        end
    end

    for _, tab in pairs(flavorskulls) do
        local ent = ents.Create("nz_script_prop")
        ent:SetModel("models/monstermash/gibs/head_skull.mdl")
        ent:SetPos(tab.pos)
        ent:SetAngles(tab.ang)
        ent:Spawn()
    end

    for _, tab in pairs(jardepository) do
        local ent = ents.Create("nz_script_prop")
        ent:SetModel(tab.mdl)
        ent:SetPos(tab.pos)
        ent:SetAngles(tab.ang)
        ent:Spawn()
        tab.ent = ent

        if tab.usable then
            ent:SetNWString("NZText", "")
            ent:SetNWString("NZRequiredItem", "eyeballs")
		    ent:SetNWString("NZHasText", "Press E to place the jar")

            ent.OnUsed = function(self, ply)
                if ply:HasCarryItem("eyeballs") then
                    local prevent = false

                    for k, v in pairs(placedjars) do
                        if !v.placed then
                            v.placed = true
                            
                            ply:Give("nz_packapunch_arms")
		                    timer.Simple(1.8, function()
                                local ent2 = ents.Create("nz_script_prop")
                                ent2:SetModel(v.mdl)
                                ent2:SetPos(v.pos)
                                ent2:SetAngles(v.ang)
                                ent2:Spawn()
                                v.ent = ent2
                                
                                for k2, v2 in pairs(placedjars) do
                                    if !v2.placed or v2.placed == nil then
                                        prevent = true
                                    end
                                end

                                if !prevent then
                                    ElectrifyBusts()
                                end
                            end)

                            break
                        end
                    end

                    ply:RemoveCarryItem("eyeballs")
                end
            end
        end
    end
end

local roundcount = 0
function mapscript.OnRoundStart()
    roundcount = roundcount + 1
    print("mapscript.RoundStart, round:" .. roundcount)

    if (roundcount == 5) then
        for _, tab in pairs(skullspawns) do
            if tab.destroyed == true then
                return
            end
        end

        PrintMessage(HUD_PRINTTALK, "Type '!hint' in chat to get hints on the easter egg to restore power! In order to access the PaP, you're on your own.")
    end
end

hook.Add("EntityTakeDamage", "BustTakesDamage", function(ent, dmginfo)
    -- this is quite overboard, but, I want to be sure there's 0 chance of any conflicts occurring
    if ent and IsValid(ent) and engine.ActiveGamemode() == "nzombies" and game.GetMap() == "mm_rot" and ent:GetModel() == "models/props_combine/breenbust.mdl" then
        if ent.bustdestructable and (dmginfo:IsDamageType(DMG_CRUSH) || dmginfo:IsDamageType(DMG_SLASH)) and dmginfo:GetInflictor():GetClass() == "nz_knife_bo1" then
            busts.destroyed = busts.destroyed + 1
            ent:EmitSound("physics/concrete/concrete_break2.wav", 90)
            ent:Remove()

            if busts.destroyed == #busts then
                UnlockPaP()
                UndoPermaElectrify(hintbust.ent)
            end
        else
            return false -- Don't let the busts be destroyed by other damage types
        end
    end
end)

hook.Add("PlayerSay", "RotHints", function(sender, text, wasTeamChat)
    if wasTeamChat then return end

    if string.StartWith(text, "!hint") then
        HintRequested()
        return false
    end
end)

function ElectrifyBusts()
    for k, v in ipairs(busts) do
        local ent = ents.GetMapCreatedEntity(v)
        ent.bustdestructable = true
        SetPermaElectrify(ent, true)
    end

    local ent = ents.Create("nz_script_prop")
    ent:SetModel(hintbust.mdl)
    ent:SetPos(hintbust.pos)
    ent:SetAngles(hintbust.ang)
    ent:Spawn()
    hintbust.ent = ent

    local effect = EffectData()
    effect:SetOrigin(hintbust.pos)
    util.Effect("vulture_gascloud", effect)

    timer.Simple(0.25, function()
        if ent and IsValid(ent) then
            SetPermaElectrify(ent)
        end
    end)
end

function UnlockPaP()
    nzDoors:OpenLinkedDoors("pap")

    timer.Simple(0.5, function()
        net.Start("LoganRunSound")
            net.WriteString("nz/randombox/poof.wav")
            net.WriteInt(90, 16)
        net.Broadcast()
    end)
    
    for _, tab in pairs(jardepository) do
        if tab.keep then continue end

        local ent = tab.ent
        ent:EmitSound("nz/effects/gone.wav")

        timer.Simple(0.5, function()
			if IsValid(ent) then
                ent:SetNoDraw(true)
                ent:Remove()
			end
		end)
		
		local e = EffectData()
		e:SetRadius(1)
		e:SetMagnitude(0.5)
		e:SetScale(1)
		e:SetEntity(ent)
		util.Effect("lightning_field", e)
    end

    for _, tab in pairs(placedjars) do
        timer.Simple(0, function()
            if tab.ent then
                tab.ent:SetNoDraw(true)
                tab.ent:Remove()
            end
        end)
    end

    timer.Simple(0, function()
        if hintbust.ent then
            hintbust.ent:SetNoDraw(true)
            hintbust.ent:Remove()
        end
    end)
end

function Electrify(ent, isMapSpawned)
    if !ent or !IsValid(ent) then return end

	local effect = EffectData()
	effect:SetScale(1)
    if isMapSpawned then
        effect:SetOrigin(ent:GetPos())
    else
	    effect:SetEntity(ent)
    end

	util.Effect("lightning_aura", effect)
end

function SetPermaElectrify(ent, isMapSpawned)
	ent.Think = function(self)
        if !ent or !self or !IsValid(ent) or !IsValid(self) then return end
        local effecttimer = 0
		if effecttimer < CurTime() and self and IsValid(self) then
			Electrify(self, isMapSpawned)
			effecttimer = CurTime() + 1
		end
    end
end

function UndoPermaElectrify(ent)
    ent.Think = nil
end

mapscript.hintcount = 0
function HintRequested()
    mapscript.hintcount = mapscript.hintcount + 1

    if mapscript.hintcount == 1 then
        PrintMessage(HUD_PRINTTALK, "Hint 1: shoot skulls hidden around the map to activate power.")
    elseif mapscript.hintcount == 2 then
        PrintMessage(HUD_PRINTTALK, "Hint 2: there are four skulls to shoot, three inside and one outisde.")
    elseif mapscript.hintcount == 3 then
        PrintMessage(HUD_PRINTTALK, "Hint 3: the skulls are particularly reflective of flashlight light.")
    elseif mapscript.hintcount == 4 then
        PrintMessage(HUD_PRINTTALK, "Hint 4: one can be found in the main foyer room.")
    elseif mapscript.hintcount == 5 then
        PrintMessage(HUD_PRINTTALK, "Hint 5: a second can be found near the Juggernog machine.")
    elseif mapscript.hintcount == 6 then
        PrintMessage(HUD_PRINTTALK, "Hint 6: a third can be found across from the MP5K.")
    elseif mapscript.hintcount == 7 then
        PrintMessage(HUD_PRINTTALK, "Hint 7: the final can be found sitting someplace very warm.")
    elseif mapscript.hintcount == 8 then
        PrintMessage(HUD_PRINTTALK, "Hint 8: two are behind cobwebs.")
    elseif mapscript.hintcount == 9 then
        PrintMessage(HUD_PRINTTALK, "Hint 9: you can always just look at the script, you know...")
    elseif mapscript.hintcount == 10 then
        PrintMessage(HUD_PRINTTALK, "No more hints")
    end
end

return mapscript