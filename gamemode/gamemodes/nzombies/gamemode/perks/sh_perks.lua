
function nzPerks:NewPerk(id, data)
	if SERVER then 
		//Sanitise any client data.
	else
		data.Func = nil
	end
	nzPerks.Data[id] = data
end

function nzPerks:Get(id)
	return nzPerks.Data[id]
end

function nzPerks:GetByName(name)
	for _, perk in pairs(nzPerks.Data) do
		if perk.name == name then
			return perk
		end
	end

	return nil
end

function nzPerks:GetList()
	local tbl = {}

	for k,v in pairs(nzPerks.Data) do
		tbl[k] = v.name
	end

	return tbl
end

function nzPerks:GetIcons()
	local tbl = {}
	
	for k,v in pairs(nzPerks.Data) do
		tbl[k] = v.icon
	end
	
	return tbl
end

function nzPerks:GetBottleMaterials()
	local tbl = {}
	
	for k,v in pairs(nzPerks.Data) do
		tbl[k] = v.material
	end
	
	return tbl
end

function nzPerks:GetMachineType(id)
	if id == "Original" then
	return "OG"
	end
	if id == "Infinite Warfare" then
	return "IW"
	end
	if id == nil then
	return "OG"
	end
end

nzPerks:NewPerk("jugg", {
	name = "Juggernog",
	name_skin = "Tuff 'Nuff",
	model = "models/yolojoenshit/bo3perks/juggernog/mc_mtl_p7_zm_vending_jugg.mdl",
	skin = "models/IWperks/tuff/mc_mtl_p7_zm_vending_jugg.mdl",
	off_skin = 1,
	on_skin = 0,
	price = 2500,
	price_skin = 2500,
	material = "models/perk_bottle/c_perk_bottle_jugg",
	icon = Material("AF/juggular.png", "smooth unlitgeneric"),
	icon_skin = Material("AF/juggular.png", "smooth unlitgeneric"),
	color = Color(255, 100, 100),
	func = function(self, ply, machine)
			ply:SetMaxHealth(250)
			ply:SetHealth(250)
	end,
	lostfunc = function(self, ply)
		ply:SetMaxHealth(100)
		if ply:Health() > 100 then ply:SetHealth(100) end
	end,
})

nzPerks:NewPerk("gum", {
	name = "Gobblegum",
	name_skin = "Gobblegum",
	model = "models/nzr/aprilfools/gobble.mdl",
	skin = "models/nzr/aprilfools/gobble.mdl",
	off_skin = 1,
	on_skin = 0,
	price = 500,
	price_skin = 500,
	specialmachine = true,
	material = "models/perk_bottle/gum",
	icon = Material("perk_icons/chron/gum.png", "smooth unlitgeneric"),
	icon_skin = Material("perk_icons/chron/gum.png", "smooth unlitgeneric"),
	color = Color(255, 100, 100),
	func = function(self, ply, machine)
		local rand = math.random(3,20)
		--local rand = 19
		if rand == 3 then
		for i, playr in ipairs( player.GetAll() ) do
		playr:ChatPrint( "Jugger-not" )
		end
		ply:SetMaxHealth(50)
		ply:SetHealth(50)
		end
		if rand == 4 then
		for i, playr in ipairs( player.GetAll() ) do
		playr:ChatPrint( "Always Done Slowly" )
		end
		ply:SetRunSpeed(100)
		ply:SetMaxRunSpeed( 100 )
		ply:SetStamina( 50 )
		ply:SetMaxStamina( 50 )
		end
		if rand == 5 then
		for i, playr in ipairs( player.GetAll() ) do
		playr:ChatPrint( "Very Quenchable" )
		end
		GetConVar("nz_difficulty_perks_max"):SetInt(1)
		end	
		if rand == 6 then
		for i, playr in ipairs( player.GetAll() ) do
		playr:ChatPrint( "Insta-death" )
		end
		ply:Kill()
		end		
		if rand == 7 then
		for i, playr in ipairs( player.GetAll() ) do
		playr:ChatPrint( "No Stock Options" )
		end
		ply:GivePoints(500)
		ply:RemoveAllAmmo()
		end			
		if rand == 8 then
		for i, playr in ipairs( player.GetAll() ) do
		playr:ChatPrint( "Anklebreaker" )
		end
		ply:SetJumpPower(40)
		end	
		if rand == 9 then
		for i, playr in ipairs( player.GetAll() ) do
		playr:ChatPrint( "Alchemical Antichrist" )
		end
		local amount = ply:GetPoints()
		ply:TakePoints(amount)
		ply:GiveMaxAmmo()
		end	
		if rand == 10 then
		for i, playr in ipairs( player.GetAll() ) do
		playr:ChatPrint( "Dropsies" )
		end
		for k,v in pairs(ply:GetWeapons()) do
			if v:GetNWInt("SwitchSlot") == 1 then
				ply:StripWeapon(v:GetClass())
			end
		end
		end
		if rand == 11 then
		for i, playr in ipairs( player.GetAll() ) do
		playr:ChatPrint( "Always in sight" )
		end
		local zombls = ents.FindInSphere(ply:GetPos(), 3000)
		for k,v in pairs(zombls) do
					if IsValid(v) and v:IsValidZombie() then
						v:SetTarget(ply)
					end
				end
		end
		if rand == 12 then
		for i, playr in ipairs( player.GetAll() ) do
		playr:ChatPrint( "Chicken Down" )
		end
		for k,v in pairs(player.GetAll()) do
		if v == ply then
		
		else
			v:Kill()
			end
		end
		end	
		if rand == 13 then
		for i, playr in ipairs( player.GetAll() ) do
		playr:ChatPrint( "Oh shid oh fugg" )
		end
		nzPowerUps:Nuke(nil, true) 
			nzRound:SetNumber( 99 )
			local specint = GetConVar("nz_round_special_interval"):GetInt() or 6
			nzRound:SetNextSpecialRound( math.ceil(100/specint)*specint)
			nzRound:Prepare()
		end
		if rand == 14 then
		for i, playr in ipairs( player.GetAll() ) do
		playr:ChatPrint( "Ice Sale" )
		end
		local box = ents.FindByClass("random_box")
		for k,v in pairs(box) do
					v:Remove()
				end
		end
		if rand == 15 then
		for i, playr in ipairs( player.GetAll() ) do
		playr:ChatPrint( "Gas Attack" )
		end
		local boss = ents.Create( "nz_zombie_special_nova" )
		boss:SetPos(ply:GetPos() + Vector(0,150,0))
		boss:SetHealth(999999)
		boss:Spawn()
		end
		if rand == 16 then
		for i, playr in ipairs( player.GetAll() ) do
		playr:ChatPrint( "Crawling in my Crawl" )
		end
		local boss = ents.Create( "nz_zombie_special_spooder" )
		boss:SetPos(ply:GetPos() + Vector(0,150,0))
		boss:SetHealth(999999)
		boss:Spawn()
		end
		if rand == 17 then
		for i, playr in ipairs( player.GetAll() ) do
		playr:ChatPrint( "Housefire" )
		end
		local boss = ents.Create( "nz_zombie_boss_Napalm" )
		boss:SetPos(ply:GetPos() + Vector(0,150,0))
		boss:SetHealth(999999)
		boss:Spawn()
		end
		if rand == 18 then
		for i, playr in ipairs( player.GetAll() ) do
		playr:ChatPrint( "Octagonal Robber" )
		end
		local pspawns = ents.FindByClass("player_spawns")
					pos = pspawns[math.random(#pspawns)]:GetPos()
		local boss = ents.Create( "nz_zombie_boss_aprilfools" )
		boss:SetPos(ply:GetPos() + Vector(0,25,0))
		boss:SetHealth(999999)
		boss:Spawn()
		end
		if rand == 19 then
		for i, playr in ipairs( player.GetAll() ) do
		playr:ChatPrint( "Perkaholic" )
		end
		ply:GivePerk("jugg")
		ply:GivePerk("vigor")
		ply:GivePerk("fire")
		ply:GivePerk("staminup")
		ply:GivePerk("politan")
		ply:GivePerk("wall")
		ply:GivePerk("vulture")
		ply:GivePerk("widowswine")
		ply:GivePerk("cherry")
		ply:GivePerk("whoswho")
		ply:GivePerk("tombstone")
		ply:GivePerk("mulekick")
		ply:GivePerk("deadshot")
		ply:GivePerk("everclear")
		ply:GivePerk("danger")
		ply:GivePerk("phd")
		if  ply:GetPerks()  then
		 perks = ply:GetPerks()
			for i=1,#perks do 
				timer.Simple(5, function()
				heldPerks = ply:GetPerks()
				perkLost = heldPerks[math.random(1, #heldPerks)]
				print(perklost)
				ply:RemovePerk(perkLost, true)
				end)
				end
				if table.IsEmpty(heldPerks) then
				d:SetDamage( 99999 )
				d:SetAttacker( self )
				ply:TakeDamageInfo( d )
				--ply:Kill()
				end 
				end
				end
		if rand == 20 then
		for i, playr in ipairs( player.GetAll() ) do
		playr:ChatPrint( "Mexican Standoff" )
		end
		end
	end,
	lostfunc = function(self, ply)
		
	end,
})

nzPerks:NewPerk("dtap", {
	name = "Double Tap",
	name_skin = "Bang Bangs",
	model = "models/alig96/perks/doubletap/doubletap_on.mdl",
	model_off = "models/alig96/perks/doubletap/doubletap_off.mdl",
	skin = "models/IWperks/bang/mc_mtl_p7_zm_vending_doubletap2.mdl",
	off_skin = 1,
	on_skin = 0,
	price = 2000,
	price_skin = 2000,
	material = "models/perk_bottle/c_perk_bottle_dtap",
	icon = Material("AF/dtap.png", "smooth unlitgeneric"),
	icon_skin = Material("AF/dtap.png", "smooth unlitgeneric"),
	color = Color(255, 255, 100),
	func = function(self, ply, machine)
		local tbl = {}
		for k,v in pairs(ply:GetWeapons()) do
				table.insert(tbl, v)
		end
		if tbl[1] != nil then
			for k,v in pairs(tbl) do
				v:ApplyNZModifier("dtap")
			end
		end
	end,
	lostfunc = function(self, ply)
			local tbl = {}
			for k,v in pairs(ply:GetWeapons()) do
					table.insert(tbl, v)
			end
			if tbl[1] != nil then
				for k,v in pairs(tbl) do
					v:RevertNZModifier("dtap")
				end
			end
	end,
})

nzPerks:NewPerk("amish", {
	name = "Amish Ale",
	name_skin = "Hippie Hops",
	model = "models/alig96/perks/amish/amish_off.mdl",
	model_off = "models/alig96/perks/amish/amish_off.mdl",
	skin =  "models/alig96/perks/amish/amish_off.mdl",
	off_skin = 1,
	on_skin = 0,
	price = 1000,
	price_skin = 1000,
	material = "models/perk_bottle/c_perk_bottle_amish",
	icon = Material("perk_icons/chron/amish.png", "smooth unlitgeneric"),
	icon_skin = Material("perk_icons/chron/amish.png", "smooth unlitgeneric"),
	color = Color(255, 255, 100),
	func = function(self, ply, machine)
	end,
	lostfunc = function(self, ply)
	end,
})

nzPerks:NewPerk("dtap2", {
	name = "Double Tap II",
	off_model = "models/alig96/perks/doubletap2/doubletap2_off.mdl",
	on_model = "models/alig96/perks/doubletap2/doubletap2.mdl",
	skin = "models/IWperks/bang/mc_mtl_p7_zm_vending_doubletap2.mdl",
	off_skin = 1,
	on_skin = 0,
	price = 2000,
	price_skin = 2000,
	material = "models/perk_bottle/c_perk_bottle_dtap2",
	icon = Material("AF/dtap2.png", "smooth unlitgeneric"),
	icon_skin = Material("AF/dtap2.png", "smooth unlitgeneric"),
	color = Color(255, 255, 100),
	func = function(self, ply, machine)
		local tbl = {}
		for k,v in pairs(ply:GetWeapons()) do
				table.insert(tbl, v)
		end
		if tbl[1] != nil then
			for k,v in pairs(tbl) do
				v:ApplyNZModifier("dtap")
			end
		end
	end,
	lostfunc = function(self, ply)
		if !ply:HasPerk("dtap") then
			local tbl = {}
			for k,v in pairs(ply:GetWeapons()) do
					table.insert(tbl, v)
			end
			if tbl[1] != nil then
				for k,v in pairs(tbl) do
					v:RevertNZModifier("dtap")
				end
			end
		end
	end,
})

nzPerks:NewPerk("revive", {
	name = "Quick Revive",
	name_skin = "Up N' Atoms",
	model = "models/yolojoenshit/bo3perks/revivesoda/mc_mtl_p7_zm_vending_revive.mdl",
	skin = "models/IWperks/atoms/mc_mtl_p7_zm_vending_revive.mdl",
	off_skin = 1,
	on_skin = 0,
	price = 1500,
	price_skin = 1500,
	material = "models/perk_bottle/c_perk_bottle_revive",
	icon = Material("AF/quack.png", "smooth unlitgeneric"),
	icon_skin = Material("AF/quack.png", "smooth unlitgeneric"),
	color = Color(100, 100, 255),
	func = function(self, ply, machine)
			if #player.GetAllPlaying() <= 1 then
				if !ply.SoloRevive or ply.SoloRevive < 3 or !IsValid(machine) then
					ply:ChatPrint("You got Quick Revive (Solo)!")
				else
					ply:ChatPrint("You can only get Quick Revive Solo 3 times.")
					return false
				end
			end
	end,
	lostfunc = function(self, ply)

	end,
})

nzPerks:NewPerk("speed", {
	name = "Speed Cola",
	name_skin = "Quickies",
	model = "models/yolojoenshit/bo3perks/speedcola/mc_mtl_p7_zm_vending_speedcola.mdl",
	skin = "models/IWperks/quickies/mc_mtl_p7_zm_vending_speedcola.mdl",
	off_skin = 1,
	on_skin = 0,
	price = 3000,
	price_skin = 3000,
	material = "models/perk_bottle/c_perk_bottle_speed",
	icon = Material("AF/spud.png", "smooth unlitgeneric"),
	icon_skin = Material("AF/spud.png", "smooth unlitgeneric"),
	color = Color(100, 255, 100),
	func = function(self, ply, machine)
		local tbl = {}
		for k,v in pairs(ply:GetWeapons()) do
			if v:NZPerkSpecialTreatment() then
				table.insert(tbl, v)
			end
		end
		if tbl[1] != nil then
			--local str = ""
			for k,v in pairs(tbl) do
				v:ApplyNZModifier("speed")
				--str = str .. v.ClassName .. ", "
			end
		end
	end,
	lostfunc = function(self, ply)
		local tbl = {}
		for k,v in pairs(ply:GetWeapons()) do
			if v:NZPerkSpecialTreatment() then
				table.insert(tbl, v)
			end
		end
		if tbl[1] != nil then
			for k,v in pairs(tbl) do
				v:RevertNZModifier("speed")
			end
		end
	end,
})

nzPerks:NewPerk("pap", {
	name = "Pack-a-Punch",
	name_skin = "Pack-a-Punch",
	model = "models/yolojoenshit/extras/packapunch/mc_mtl_p7_packapunch.mdl",
	off_skin = 1,
	on_skin = 0,
	price = 0,
	price_skin = 0,
	specialmachine = true, -- Prevents players from getting the perk when they buy it
	nobuy = true, -- A "Buy" event won't run when this is used (we do that ourselves in its function)
	-- We don't use materials
	icon = Material("vulture_icons/pap.png", "smooth unlitgeneric"),
	icon_skin = Material("vulture_icons/pap.png", "smooth unlitgeneric"),
	color = Color(200, 220, 220),
	condition = function(self, ply, machine)
		local wep = ply:GetActiveWeapon()
		if (!wep:HasNZModifier("pap") or wep:CanRerollPaP()) and !machine:GetBeingUsed() then
			local reroll = false
			if wep:HasNZModifier("pap") and wep:CanRerollPaP() then
				reroll = true
			end
			local cost = reroll and 2000 or 5000
			return ply:GetPoints() >= cost
		else
			ply:PrintMessage( HUD_PRINTTALK, "This weapon is already Pack-a-Punched")
			
			return false
		end
	end,
	func = function(self, ply, machine)
		local wep = ply:GetActiveWeapon()
	
		local reroll = false
		if wep:HasNZModifier("pap") and wep:CanRerollPaP() then
			reroll = true
		end
		local cost = reroll and 2000 or 5000

		ply:Buy(cost, machine, function()
			hook.Call("OnPlayerBuyPackAPunch", nil, ply, wep, machine)
		
			ply:Give("nz_packapunch_arms")

			machine:SetBeingUsed(true)
			machine:EmitSound("nz/machines/pap_up.wav")
			local class = wep:GetClass()
			
			local e = EffectData()
			e:SetEntity(machine)
			local ang = machine:GetAngles()
			e:SetOrigin(machine:GetPos() + ang:Up()*35 + ang:Forward()*20 - ang:Right()*2)
			e:SetMagnitude(3)
			util.Effect("pap_glow", e, true, true)

			wep:Remove()
			local wep = ents.Create("pap_weapon_fly")
			local startpos = machine:GetPos() + ang:Forward()*30 + ang:Up()*25 + ang:Right()*-3
			wep:SetPos(startpos)
			wep:SetAngles(ang + Angle(0,90,0))
			wep.WepClass = class
			wep:Spawn()
			local weapon = weapons.Get(class)
			local model = (weapon and weapon.WM or weapon.WorldModel) or "models/weapons/w_rif_ak47.mdl"
			if !util.IsValidModel(model) then model = "models/weapons/w_rif_ak47.mdl" end
			wep:SetModel(model)
			wep.machine = machine
			wep.Owner = ply
			wep:SetMoveType( MOVETYPE_FLY )

			--wep:SetNotSolid(true)
			--wep:SetGravity(0.000001)
			--wep:SetCollisionBounds(Vector(0,0,0), Vector(0,0,0))
			timer.Simple(0.5, function()
				if IsValid(wep) then
					wep:SetLocalVelocity(ang:Forward()*-30)
				end
			end)
			timer.Simple(1.8, function()
				if IsValid(wep) then
					wep:SetMoveType(MOVETYPE_NONE)
					wep:SetLocalVelocity(Vector(0,0,0))
				end
			end)
			timer.Simple(3, function()
				if IsValid(wep) and IsValid(machine) then
					local weapon = weapons.Get(class)
					if weapon and weapon.NZPaPReplacement and weapons.Get(weapon.NZPaPReplacement) then
						local pos, ang = wep:GetPos(), wep:GetAngles()
						wep:Remove()
						wep = ents.Create("pap_weapon_fly") -- Recreate a new entity with the replacement class instead
						wep:SetPos(pos)
						wep:SetAngles(ang)
						wep.WepClass = weapon.NZPaPReplacement
						wep:Spawn()
						wep.TriggerPos = startpos
						
						local replacewep = weapons.Get(weapon.NZPaPReplacement)
						local model = (replacewep and replacewep.WM or replacewep.WorldModel) or "models/weapons/w_rif_ak47.mdl"
						if !util.IsValidModel(model) then model = "models/weapons/w_rif_ak47.mdl" end
						wep:SetModel(model) -- Changing the model and name
						wep.machine = machine
						wep.Owner = ply
						wep:SetMoveType( MOVETYPE_FLY )
					end
					
					--print(wep, wep.WepClass, wep:GetModel())
				
					machine:EmitSound("nz/machines/pap_ready.wav")
					wep:SetCollisionBounds(Vector(0,0,0), Vector(0,0,0))
					wep:SetMoveType(MOVETYPE_FLY)
					wep:SetGravity(0.000001)
					wep:SetLocalVelocity(ang:Forward()*30)
					--print(ang:Forward()*30, wep:GetVelocity())
					wep:CreateTriggerZone(reroll)
					--print(reroll)
				end
			end)
			timer.Simple(4.2, function()
				if IsValid(wep) then
					--print("YDA")
					--print(wep:GetMoveType())
					--print(ang:Forward()*30, wep:GetVelocity())
					wep:SetMoveType(MOVETYPE_NONE)
					wep:SetLocalVelocity(Vector(0,0,0))
				end
			end)
			timer.Simple(10, function()
				if IsValid(wep) then
					wep:SetMoveType(MOVETYPE_FLY)
					wep:SetLocalVelocity(ang:Forward()*-2)
				end
			end)
			timer.Simple(25, function()
				if IsValid(wep) then
					wep:Remove()
					if IsValid(machine) then
						machine:SetBeingUsed(false)
					end
				end
			end)

			timer.Simple(2, function() ply:RemovePerk("pap") end)
			return true
		end)
	end,
	lostfunc = function(self, ply)

	end,
})

nzPerks:NewPerk("vigor", {
	name = "Vigor Rush",
	name_skin = "Bang Bangs (Big Damage)",
	model = "models/nzr/vigor.mdl",
	skin = "models/IWperks/bang/mc_mtl_p7_zm_vending_doubletap2.mdl",
	off_skin = 1,
	on_skin = 0,
	price = 2500,
	price_skin = 2000,
	material = "models/perk_bottle/c_perk_bottle_vigor",
	icon = Material("AF/vigor.png", "smooth unlitgeneric"),
	icon_skin = Material("AF/vigor.png", "smooth unlitgeneric"),
	color = Color(128, 128, 64),
	func = function(self, ply, machine)
	end,
	lostfunc = function(self, ply)
	end,
})

nzPerks:NewPerk("fire", {
	name = "Napalm Nectar",
	name_skin = "Firestarter Fizzy",
	model = "models/nzr/firestarter/firestarter.mdl",
	model_off = "models/nzr/firestarter/firestarter_off.mdl",
	price = 2000,
	price_skin = 2000,
	material = "models/perk_bottle/c_perk_bottle_fire",
	icon = Material("AF/napalm.png", "smooth unlitgeneric"),
	icon_skin = Material("AF/napalm.png", "smooth unlitgeneric"),
	color = Color(222, 69, 2),
	func = function(self, ply, machine)
	end,
	lostfunc = function(self, ply)
	end,
})

nzPerks:NewPerk("staminup", {
	name = "Stamin-Up",
	name_skin = "Racin' Stripes",
	model = "models/yolojoenshit/bo3perks/staminup/mc_mtl_p7_zm_vending_marathon.mdl",
	skin = "models/IWperks/stripes/mc_mtl_p7_zm_vending_marathon.mdl",
	off_skin = 1,
	on_skin = 0,
	price = 2000,
	price_skin = 2000,
	material = "models/perk_bottle/c_perk_bottle_stamin",
	icon = Material("AF/dorito.png", "smooth unlitgeneric"),
	icon_skin = Material("AF/dorito.png", "smooth unlitgeneric"),
	color = Color(200, 255, 100),
	func = function(self, ply, machine)
		ply:SetRunSpeed(321)
		ply:SetMaxRunSpeed( 321 )
		ply:SetStamina( 200 )
		ply:SetMaxStamina( 200 )
	end,
	lostfunc = function(self, ply)
		ply:SetRunSpeed(300)
		ply:SetMaxRunSpeed( 300 )
		ply:SetStamina( 100 )
		ply:SetMaxStamina( 100 )
	end,
})

nzPerks:NewPerk("politan", {
	name = "Random-o-Politan",
	name_skin = "Random-o-Politan",
	model = "models/alig96/perks/random/random_on.mdl",
	model_off = "models/alig96/perks/random/random_off.mdl",
	price = 5000,
	price_skin = 5000,
	material = "models/perk_bottle/c_perk_bottle_random",
	icon = Material("AF/random.png", "smooth unlitgeneric"),
	icon_skin = Material("AF/random.png", "smooth unlitgeneric"),
	color = Color(255, 172, 224),
	func = function(self, ply, machine)
		local tbl = {}
		for k,v in pairs(ply:GetWeapons()) do
				table.insert(tbl, v)
		end
			for k,v in pairs(tbl) do
			if !v:IsSpecial() then
				v:ApplyNZModifier("rando")
				end
			end
	end,
	lostfunc = function(self, ply)
			local tbl = {}
			for k,v in pairs(ply:GetWeapons()) do
				if v:HasNZModifier("rando") then
					v:RevertNZModifier("rando")
			end
			end
		
	end,
})

nzPerks:NewPerk("sake", {
	name = "Slasher's Sake",
	name_skin = "Slappy Taffy",
	skin = "models/IWperks/taffy/sake.mdl",
	model = "models/alig96/perks/sake/sake.mdl",
	off_skin = 1,
	on_skin = 0,
	price = 6000,
	price_skin = 6000,
	material = "models/perk_bottle/c_perk_bottle_sake",
	icon = Material("AF/sake.png", "smooth unlitgeneric"),
	icon_skin = Material("AF/sake.png", "smooth unlitgeneric"),
	color = Color(185, 214, 0),
	func = function(self, ply, machine)
	end,
	lostfunc = function(self, ply)
	ply:StripWeapon( "nz_yamato" )
	ply:Give("nz_quickknife_crowbar")
	end,
})

nzPerks:NewPerk("wall", {
	name = "Wall Power Whiskey Sour",
	name_skin = "Wall Power Whiskey Sour",
	model_off = "models/alig96/perks/wall/wall_off.mdl",
	model = "models/alig96/perks/wall/wall.mdl",
	price = 8000,
	price_skin = 8000,
	material = "models/perk_bottle/c_perk_bottle_wall",
	icon = Material("AF/flaccid.png", "smooth unlitgeneric"),
	icon_skin = Material("AF/flaccid.png", "smooth unlitgeneric"),
	color = Color(230, 104, 167),
	func = function(self, ply, machine)
	end,
	lostfunc = function(self, ply)
	end,
})

nzPerks:NewPerk("danger", {
	name = "Danger Costa-Rican",
	name_skin = "Danger Costa-Rican",
	model_off = "models/alig96/perks/danger/danger_off.mdl",
	model = "models/alig96/perks/danger/danger_on.mdl",
	price = 2000,
	price_skin = 2000,
	material = "models/perk_bottle/c_perk_bottle_danger",
	icon = Material("AF/danger.png", "smooth unlitgeneric"),
	icon_skin = Material("AF/danger.png", "smooth unlitgeneric"),
	color = Color(232, 116, 116),
	func = function(self, ply, machine)
	end,
	lostfunc = function(self, ply)
	end,
})

nzPerks:NewPerk("everclear", {
	name = "Explosive Everclear",
	name_skin = "Trail Blazers",
	skin = "models/IWperks/trailblazer/everclear.mdl",
	off_skin = 1,
	on_skin = 0,
	model_off = "models/alig96/perks/everclear/everclear.mdl",
	model = "models/alig96/perks/everclear/everclear.mdl",
	price = 3000,
	price_skin = 3000,
	material = "models/perk_bottle/c_perk_bottle_everclear",
	icon = Material("AF/everclear.png", "smooth unlitgeneric"),
	icon_skin = Material("AF/everclear.png", "smooth unlitgeneric"),
	color = Color(222, 222, 222),
	func = function(self, ply, machine)
	end,
	lostfunc = function(self, ply)
	end,
})

nzPerks:NewPerk("gin", {
	name = "Juicer's Gin",
	name_skin = "Juicer's Gin",
	model_off = "models/alig96/perks/gin/gin.mdl",
	model = "models/alig96/perks/gin/gin.mdl",
	price = 2000,
	price_skin = 2000,
	material = "models/perk_bottle/c_perk_bottle_gin",
	icon = Material("perk_icons/chron/gin.png", "smooth unlitgeneric"),
	icon_skin = Material("perk_icons/chron/gin.png", "smooth unlitgeneric"),
	color = Color(75, 158, 188),
	func = function(self, ply, machine)
	if #player.GetAllPlaying() <= 1 then
	local perks =   GetConVar("nz_difficulty_perks_max"):GetInt()
	GetConVar("nz_difficulty_perks_max"):SetInt(perks+3)
	else
	local perks =   GetConVar("nz_difficulty_perks_max"):GetInt()
	GetConVar("nz_difficulty_perks_max"):SetInt(perks+1)
	end
	end,
	lostfunc = function(self, ply)
		if #player.GetAllPlaying() <= 1 then
	local perks =   GetConVar("nz_difficulty_perks_max"):GetInt()
	GetConVar("nz_difficulty_perks_max"):SetInt(perks-3)
	else
	local perks =   GetConVar("nz_difficulty_perks_max"):GetInt()
	GetConVar("nz_difficulty_perks_max"):SetInt(perks-1)
	end
	end,
})

nzPerks:NewPerk("phd", {
	name = "PhD Flopper",
	name_skin = "Bombstoppers",
	skin = "models/IWperks/bomb/phdflopper.mdl", 
	off_skin = 1,
	on_skin = 0,
	model_off = "models/alig96/perks/phd/phdflopper_off.mdl",
	model = "models/alig96/perks/phd/phdflopper.mdl",
	price = 2000,
	price_skin = 2000,
	material = "models/perk_bottle/c_perk_bottle_phd",
	icon = Material("AF/phd.png", "smooth unlitgeneric"),
	icon_skin = Material("AF/phd.png", "smooth unlitgeneric"),
	color = Color(255, 50, 255),
	func = function(self, ply, machine)
	end,
	lostfunc = function(self, ply)
	end,
})

nzPerks:NewPerk("deadshot", {
	name = "Deadshot Daiquiri",
	name_skin = "Deadeye Dewdrops",
	model = "models/yolojoenshit/bo3perks/deadshot/mc_mtl_p7_zm_vending_deadshot.mdl",
	skin = "models/IWperks/deadeye/mc_mtl_p7_zm_vending_deadshot.mdl",
	off_skin = 1,
	on_skin = 0,
	price = 2000,
	price_skin = 1500,
	material = "models/perk_bottle/c_perk_bottle_deadshot",
	icon =Material("AF/dragunov.png", "smooth unlitgeneric"),
	icon_skin = Material("AF/dragunov.png", "smooth unlitgeneric"),
	color = Color(150, 200, 150),
	func = function(self, ply, machine)
	end,
	lostfunc = function(self, ply)
	end,
})

nzPerks:NewPerk("mulekick", {
	name = "Mule Kick",
	name_skin = "Mule Munchies",
	model = "models/yolojoenshit/bo3perks/mulekick/mc_mtl_p7_zm_vending_mulekick.mdl",
	skin = "models/IWperks/munchies/mc_mtl_p7_zm_vending_mulekick.mdl",
	off_skin = 1,
	on_skin = 0,
	price = 4000,
	price_skin = 2000,
	material = "models/perk_bottle/c_perk_bottle_mulekick",
	icon = Material("AF/mule.png", "smooth unlitgeneric"),
	icon_skin = Material("AF/mule.png", "smooth unlitgeneric"),
	color = Color(100, 200, 100),
	func = function(self, ply, machine)
	end,
	lostfunc = function(self, ply)
		for k,v in pairs(ply:GetWeapons()) do
			if v:GetNWInt("SwitchSlot") == 3 then
				ply:StripWeapon(v:GetClass())
			end
		end
	end,
})

nzPerks:NewPerk("tombstone", {
	name = "Tombstone Soda",
	name_skin = "Tombstone Soda",
	model_off = "models/alig96/perks/tombstone/tombstone_off.mdl",
	model = "models/alig96/perks/tombstone/tombstone.mdl",
	price = 2000,
	price_skin = 2000,
	material = "models/perk_bottle/c_perk_bottle_tombstone",
	icon = Material("AF/tombstone.png", "smooth unlitgeneric"),
	icon_skin = Material("AF/tombstone.png", "smooth unlitgeneric"),
	color = Color(100, 100, 100),
	func = function(self, ply, machine)
	end,
	lostfunc = function(self, ply)
	end,
})

nzPerks:NewPerk("whoswho", {
	name = "Who's Who",
	name_skin = "Who's Who",
	model_off = "models/alig96/perks/whoswho/whoswho_off.mdl",
	model = "models/alig96/perks/whoswho/whoswho.mdl",
	price = 2000,
	price_skin = 2000,
	material = "models/perk_bottle/c_perk_bottle_whoswho",
	icon = Material("AF/who.png", "smooth unlitgeneric"),
	icon_skin = Material("AF/who.png", "smooth unlitgeneric"),
	color = Color(100, 100, 255),
	func = function(self, ply, machine)
	end,
	lostfunc = function(self, ply)
	end,
})

nzPerks:NewPerk("cherry", {
	name = "Electric Cherry",
	name_skin = "Blue Bolts",
	skin = "models/IWperks/bolts/cherry.mdl",
	off_skin = 1,
	on_skin = 0,
	model_off = "models/alig96/perks/cherry/cherry_off.mdl",
	model = "models/alig96/perks/cherry/cherry.mdl",
	price = 2000,
	price_skin = 1500,
	material = "models/perk_bottle/c_perk_bottle_cherry",
	icon = Material("AF/ec.png", "smooth unlitgeneric"),
	icon_skin = Material("AF/ec.png", "smooth unlitgeneric"),
	color = Color(50, 50, 200),
	func = function(self, ply, machine)
	end,
	lostfunc = function(self, ply)
	end,
})

nzPerks:NewPerk("vulture", {
	name = "Vulture Aid Elixir",
	name_skin = "Vulture Aid Elixir",
	model_off = "models/alig96/perks/vulture/vultureaid_off.mdl",
	model = "models/alig96/perks/vulture/vultureaid.mdl",
	price = 3000,
	price_skin = 3000,
	material = "models/perk_bottle/c_perk_bottle_vulture",
	icon = Material("AF/vultureaid.png", "smooth unlitgeneric"),
	icon_skin = Material("AF/vultureaid.png", "smooth unlitgeneric"),
	color = Color(255, 100, 100),
	func = function(self, ply, machine)
	end,
	lostfunc = function(self, ply)
	end,
})

nzPerks:NewPerk("wunderfizz", {
	name = "Der Wunderfizz", -- Nothing more is needed, it is specially handled
	specialmachine = true,
})

nzPerks:NewPerk("widowswine", {
	name = "Widow's Wine",
	name_skin = "Widow's Wine",
	model = "models/yolojoenshit/bo3perks/widows_wine/mc_mtl_p7_zm_vending_widows_wine.mdl",
	skin = "models/yolojoenshit/bo3perks/widows_wine/mc_mtl_p7_zm_vending_widows_wine.mdl",
	off_skin = 1,
	on_skin = 0,
	price = 4000,
	price_skin = 4000,
	material = "models/perk_bottle/c_perk_bottle_widowswine",
	icon = Material("AF/widowswine.png", "smooth unlitgeneric"),
	icon_skin = Material("AF/widowswine.png", "smooth unlitgeneric"),
	color = Color(255, 50, 200),
	func = function(self, ply, machine)
	end,
	lostfunc = function(self, ply)
	end,
})