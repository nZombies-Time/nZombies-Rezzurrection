local usekey = "" .. string.upper(input.LookupBinding( "+use", true )) .. " - "

local traceents = {
	["wall_buys"] = function(ent)
		local ply = LocalPlayer()
		if IsValid(ply:GetObserverTarget()) then ply = ply:GetObserverTarget() end

		local wepclass = ent:GetWepClass()
		local price = ent:GetPrice()
		local wep = weapons.Get(wepclass)
		if !wep then return "INVALID WEAPON" end

		local pap = false
		local hacked = false
		local upgrade
		local upgrade2

		if wep.NZPaPReplacement then
			upgrade = wep.NZPaPReplacement
			if ply:HasWeapon(upgrade) then
				pap = true
			end

			local wep2 = weapons.Get(wep.NZPaPReplacement)
			if wep2.NZPaPReplacement then
				upgrade2 = wep2.NZPaPReplacement
				if ply:HasWeapon(upgrade2) then
					pap = true
				end
			end
		end

		if ent.GetHacked and ent:GetHacked() then
			hacked = true
		end

		local name = wep.PrintName
		local ammo_price = hacked and 4500 or math.ceil((price - (price % 10))/2)
		local ammo_price_pap = hacked and math.ceil((price - (price % 10))/2) or 4500
		local text = ""

		if !ply:HasWeapon( wepclass ) then
			if !pap then
				text = "Press "..usekey..name.." [Cost: "..string.Comma(price).."]"
			else
				text = "Press "..usekey.."Upgraded Ammo ["..string.Comma(ammo_price_pap).."]"
			end
		else
			if ply:HasWeapon( wepclass ) then
				text = "Press "..usekey.."Ammo ["..string.Comma(ammo_price).."], Upgraded Ammo ["..string.Comma(ammo_price_pap).."]"
			else
				text = "You already have this Weapon"
			end
		end
		if nzRound:InState(ROUND_CREATE) then
			text = ""..name.." | "..string.upper(wepclass).." | Price "..string.Comma(price)..""
		end

		return text
	end,
	["breakable_entry"] = function(ent)
		if ent:GetHasPlanks() and ent:GetNumPlanks() < GetConVar("nz_difficulty_barricade_planks_max"):GetInt() then
			local text = "Hold " .. usekey .. "Rebuild Barricade"
			return text
		end
	end,
	["ammo_box"] = function(ent)
		local text = "Press " .. usekey .. "Ammo [" .. string.Comma(ent:GetPrice()) .. "]"
		return text
	end,
	["stinky_lever"] = function(ent)
		local text = "Press " .. usekey .. "Hasten your demise"
		return text
	end,
	["random_box"] = function(ent)
		if not ent:GetOpen() then
			local text = nzPowerUps:IsPowerupActive("firesale") and ("Press " .. usekey .. "Open Mystery Box [Cost: 10]") or ("Press " .. usekey .. "Open Mystery Box [Cost: 950]")
			return text
		end
	end,
	["random_box_windup"] = function(ent)
		if !ent:GetWinding() and ent:GetWepClass() != "nz_box_teddy" then
			local wepclass = ent:GetWepClass()
			local wep = weapons.Get(wepclass)
			local name = "UNKNOWN"
			if wep != nil then
				name = wep.PrintName
			end
			if name == nil then name = wepclass end
			name = usekey .. "Take " .. name

			return name
		end
	end,
	["perk_machine"] = function(ent)
		local nz_maxperks = GetConVar("nz_difficulty_perks_max")
		local ply = LocalPlayer()
		if IsValid(ply:GetObserverTarget()) then ply = ply:GetObserverTarget() end
		local text = ""

		if !ent:IsOn() then
			text = "You must turn on the electricity first!"
		elseif ent:GetBeingUsed() then
			text = "Currently in Use"
		elseif ent.BrutusLocked and ent:BrutusLocked() then
			text = "Press " .. usekey .. " Unlock " .. "[Cost: 2000]"
		else
			if ent:GetPerkID() == "pap" then
				local wep = ply:GetActiveWeapon()
				
				if IsValid(wep) and wep:HasNZModifier("pap") then
					if wep.NZRePaPText then
						text = nzPowerUps:IsPowerupActive("bonfiresale") and ("Press " .. usekey .. ""..wep.NZRePaPText.." [Cost: 500]") or ("Press " .. usekey .. ""..wep.NZRePaPText.." [Cost: 3,000]")
					elseif wep:CanRerollPaP() then
						text = nzPowerUps:IsPowerupActive("bonfiresale") and ("Press " .. usekey .. "Repack [Cost: 500]") or ("Press " .. usekey .. "Repack [Cost: 3,000]")
					else
						text = "This weapon cannot be upgraded any further"
					end
				else
					text = nzPowerUps:IsPowerupActive("bonfiresale") and ("Press " .. usekey .. "Pack-a-Punch Weapon [Cost: 1,000]") or ("Press " .. usekey .. "Pack-a-Punch Weapon [Cost: 5,000]")
				end
			else
				local perkData = nzPerks:Get(ent:GetPerkID())

				if nzPerks:GetMachineType(nzMapping.Settings.perkmachinetype) == "IW" then
					text = "Press " .. usekey .. perkData.name_skin .. " " .. "[Cost: " .. string.Comma(ent:GetPrice()) .. "]"
				elseif nzRound:GetIconType(nzMapping.Settings.icontype) == "Hololive" then
					text = "Press " .. usekey .. perkData.name_holo .. " " .. "[Cost: " .. string.Comma(ent:GetPrice()) .. "]"
				else
					text = "Press " .. usekey .. perkData.name .. " " .. "[Cost: " .. string.Comma(ent:GetPrice()) .. "]"
				end

				if #ply:GetPerks() >= nz_maxperks:GetInt() then
					text = "You may only carry " .. nz_maxperks:GetInt() .. " perks"
				end

				if ply:HasPerk(ent:GetPerkID()) and (ply:HasUpgrade(ent:GetPerkID()) or tobool(nzMapping.Settings.perkupgrades) == false) then
					text = "You already own this perk"
				elseif ply:HasPerk(ent:GetPerkID()) and !ply:HasUpgrade(ent:GetPerkID()) then
					if nzPerks:GetMachineType(nzMapping.Settings.perkmachinetype) == "IW" then
						text = "Press " .. usekey .. " Upgrade " .. perkData.name_skin .. " " .. "[Cost: " .. string.Comma(ent:GetPrice()*2) .. "]"
					elseif nzRound:GetIconType(nzMapping.Settings.icontype) == "Hololive" then
						text = "Press " .. usekey .. " Upgrade " .. perkData.name_holo .. " " .. "[Cost: " .. string.Comma(ent:GetPrice()*2) .. "]"
					else
						text = "Press " .. usekey .. " Upgrade " .. perkData.name .. " " .. "[Cost: " .. string.Comma(ent:GetPrice()*2) .. "]"
					end
				end
			end
		end
		return text
	end,
	["nz_teleporter"] = function(ent)
		local text = ""
		local price = ent:GetPrice()
		local enabled = ent:GetGifType()
		if price < 0 or enabled > 5 then
		text = ""
		elseif !ent:IsOn() then
			text = "No Power."
		elseif ent:GetBeingUsed() then
			text = "Currently in use."
		elseif ent:GetCooldown() then
			text = "Teleporter on cooldown!"
		else
			text = "Press E to Teleport for " .. ent:GetPrice() .. " points."
		end

		return text
	end,
	["buyable_ending"] = function(ent)
		local text = ""
		text = "Press " .. usekey .. "End game [Cost: " .. string.Comma(ent:GetPrice()) .. "]"
		return text
	end,
	["player_spawns"] = function() if nzRound:InState( ROUND_CREATE ) then return "Player Spawn" end end,
	["nz_spawn_zombie_normal"] = function() if nzRound:InState( ROUND_CREATE ) then return "Zombie Spawn" end end,
	["nz_spawn_zombie_special"] = function() if nzRound:InState( ROUND_CREATE ) then return "Zombie Special Spawn" end end,
	["nz_spawn_zombie_boss"] = function() if nzRound:InState( ROUND_CREATE ) then return "Zombie Boss Spawn" end end,
	["pap_weapon_trigger"] = function(ent)
		local wepclass = ent:GetWepClass()
		local wep = weapons.Get(wepclass)
		local name = "UNKNOWN"
		if wep != nil then
			name = nz.Display_PaPNames[wepclass] or nz.Display_PaPNames[wep.PrintName] or "Upgraded "..wep.PrintName
		end
		name = "Press " .. usekey .. " for " .. name .. ""

		return name
	end,
	["wunderfizz_machine"] = function(ent)
		local nz_maxperks = GetConVar("nz_difficulty_perks_max")
		local ply = LocalPlayer()
		if IsValid(ply:GetObserverTarget()) then ply = ply:GetObserverTarget() end
		local text = ""

		if not ent:IsOn() then
			text = "The Wunderfizz Orb is currently at another location"
		elseif ent:GetBeingUsed() and IsValid(ent:GetUser()) then
			if ent:GetUser() == ply then
				if ent:GetPerkID() ~= "" and not ent:GetIsTeddy() then
					if nzPerks:GetMachineType(nzMapping.Settings.perkmachinetype) == "IW" then
						text = "Press " ..usekey.. "for " ..nzPerks:Get(ent:GetPerkID()).name_skin
					else
						text = "Press " ..usekey.. "for " ..nzPerks:Get(ent:GetPerkID()).name
					end
				elseif ent:GetIsTeddy() then
					text = "Changing Location..."
				else
					text = "Selecting Beverage..."
				end
			else
				if ent:GetPerkID() ~= "" and not ent:GetIsTeddy() then
					if nzPerks:GetMachineType(nzMapping.Settings.perkmachinetype) == "IW" then
						text = tostring(nzPerks:Get(ent:GetPerkID()).name_skin)
					else
						text = tostring(nzPerks:Get(ent:GetPerkID()).name)
					end
				elseif ent:GetIsTeddy() then
					text = "You may now clown "..ent:GetUser():Nick()
				else
					text = "Selecting Beverage..."
				end
			end
		elseif not ent:GetBeingUsed() and ent:IsOn() then
			if #ply:GetPerks() >= nz_maxperks:GetInt() then
				text = "You may only carry " .. nz_maxperks:GetInt() .. " perks"
			else
				text = "Press " .. usekey .. "Use Wunderfizz Orb [Cost: " .. string.Comma(ent:GetPrice()) .. "]"
			end
		end

		return text
	end,
}

local ents = ents
local surface = surface
local draw = draw

local ents_FindByClass = ents.FindByClass
local ents_FindInSphere = ents.FindInSphere

local color_black_100 = Color(0, 0, 0, 100)
local color_nzwhite = Color(225, 235, 255,255)
local color_gold = Color(255, 255, 100, 255)

local cl_drawhud = GetConVar("cl_drawhud")
local nz_betterscaling = GetConVar("nz_hud_better_scaling")

local dahudz = {
	["Black Ops 3"] = true,
	["Shadows of Evil"] = true,
	["Black Ops 4"] = true,
}

if GetConVar("nz_hud_show_targeticon") == nil then
	CreateClientConVar("nz_hud_show_targeticon", 0, true, false, "Enable or disable displaying an entity's HUD icon above their hint string. (0 false, 1 true), Default is 0.", 0, 1)
end

local nz_showicons = GetConVar("nz_hud_show_targeticon")
local zmhud_icon_frame = Material("nz_moo/icons/perk_frame.png", "unlitgeneric smooth")
local zmhud_vulture_glow = Material("nz_moo/huds/t6/specialty_vulture_zombies_glow.png", "unlitgeneric smooth")

local function GetDoorText( ent )
	local door_data = ent:GetDoorData()
	local text = ""

	if door_data and tonumber(door_data.price) == 0 and nzRound:InState(ROUND_CREATE) then
		if tobool(door_data.elec) then
			text = "This door will open when electricity is turned on."
		else
			text = "This door will open on game start."
		end
	elseif door_data and tonumber(door_data.buyable) == 1 then
		local price = tonumber(door_data.price)
		local req_elec = tobool(door_data.elec)
		local link = door_data.link

		if ent:IsLocked() then
			if req_elec and !IsElec() then
				text = "You must turn on the electricity first!"
			elseif price > 0 then
				text = "Press " .. usekey .. "Clear Debris [Cost: " .. string.Comma(price) .. "]"
			elseif price < 0 then
				text = "Press " .. usekey .. "Salvage [+Cost: " .. string.Comma(price * -1) .. "]"
			else
				text = "Press " .. usekey .. "Clear Debris"
			end
		end
		elseif door_data and tonumber(door_data.buyable) != 1 and nzRound:InState( ROUND_CREATE ) then
		text = "This door is locked and cannot be bought in-game."
		--PrintTable(door_data)
	end

	return text
end

local function GetText( ent )
	if !IsValid(ent) then return "" end
	
	if ent.GetNZTargetText then return ent:GetNZTargetText() end

	local ply = LocalPlayer()
	if IsValid(ply:GetObserverTarget()) then ply = ply:GetObserverTarget() end
	local class = ent:GetClass()
	local text = ""

	local neededcategory, deftext, hastext = ent:GetNWString("NZRequiredItem"), ent:GetNWString("NZText"), ent:GetNWString("NZHasText")
	local itemcategory = ent:GetNWString("NZItemCategory")

	if neededcategory != "" then
		local hasitem = ply:HasCarryItem(neededcategory)
		text = hasitem and hastext != "" and hastext or deftext
	elseif deftext != "" then
		text = deftext
	elseif itemcategory != "" then
		local item = nzItemCarry.Items[itemcategory]
		local hasitem = ply:HasCarryItem(itemcategory)
		if hasitem then
			text = item and item.hastext or "You already have this"
		else
			text = usekey .. "Take"
		end
	elseif ent:IsPlayer() then
		if ent:GetNotDowned() then
			local health = ent:Health()
			local armor = ent:Armor()
			if armor <= 0 then
				armor = ""
			else
				armor = " | "..armor.." AP"
			end

			text = ent:Nick().." - "..health.." HP"..armor
		else
			text = usekey.."Revive "..ent:Nick()
		end
	elseif ent:IsDoor() or ent:IsButton() or ent:GetClass() == "class C_BaseEntity" or ent:IsBuyableProp() then
		text = GetDoorText(ent)
	else
		text = traceents[class] and traceents[class](ent)
	end

	return text
end

local function GetMapScriptEntityText()
	local text = ""
	local pos = EyePos()

	for k, v in nzLevel.GetTriggerZoneArray() do
		if IsValid(v) and v:NearestPoint(pos):DistToSqr(pos) <= 1 then
			text = GetDoorText(v)
			break
		end
	end

	return text
end

local perkmachineclasses = {
	["wunderfizz_machine"] = true,
	["perk_machine"] = true,
}

local function DrawTargetID(text, ent)
	if not text then return end
	if not cl_drawhud:GetBool() then return end

	local font = ("nz.small."..GetFontType(nzMapping.Settings.smallfont))
	local font2 = ("nz.points."..GetFontType(nzMapping.Settings.smallfont))

	local ply = LocalPlayer()
	if IsValid(ply:GetObserverTarget()) then ply = ply:GetObserverTarget() end

	local wep = ply:GetActiveWeapon()
	if IsValid(wep) and wep.IsSpecial and wep:IsSpecial() then return end

	if nzRevive.Players and nzRevive.Players[ply:EntIndex()] then
		local rply = nzRevive.Players[ply:EntIndex()].RevivePlayer
		if !ply:GetNotDowned() and IsValid(rply) and rply:IsPlayer() then return end
	end

	if !ply:GetNotDowned() and not ply:GetDownedWithTombstone() then return end

	local modern = dahudz[nzMapping.Settings.hudtype]
	local scw, sch = ScrW(), ScrH()
	local scale = (scw/1920 + 1)/2
	local lowres = scale < 0.96
	local pscale = 1
	if nz_betterscaling:GetBool() then
		pscale = scale
	end

	if lowres then
		font = ("nz.points."..GetFontType(nzMapping.Settings.smallfont))
		font2 = ("nz.ammo."..GetFontType(nzMapping.Settings.ammofont))
	end

	// grenade rethrow
	for k, v in pairs(ents_FindInSphere(ply:GetPos(), 64)) do
		if v.NZNadeRethrow and v:GetCreationTime() + 0.25 < CurTime() then
			local nadekey = GetConVar("nz_key_grenade"):GetInt()
			text = "Press "..string.upper(input.GetKeyName(nadekey)).." - Rethrow Grenade"
			ent = v
			break
		end
	end

	// tombstone
	if ply:GetDownedWithTombstone() then text = "Press & Hold "..usekey.." Feed the Zombies" end

	surface.SetFont(font)
	local tw, th = surface.GetTextSize(text)

	if IsValid(ent) then
		local showicons = nz_showicons:GetBool()
		// player perks
		if showicons and ent:IsPlayer() then
			local perks = ent:GetPerks()
			local size = 34
			local num, row = 0, 0

			for _, perk in pairs(perks) do
				local icon = GetPerkIconMaterial(perk)
				if not icon or icon:IsError() then
					icon = zmhud_icon_missing
				end

				local fuck = math.min(#perks, 8)

				surface.SetMaterial(icon)
				surface.SetDrawColor(color_white)
				surface.DrawTexturedRect(scw/2 + (num*(size + 2)*pscale) - (fuck/2)*size*pscale, (sch - 280*pscale - (th+12)) - size*row, size*pscale, size*pscale)

				if ent:HasUpgrade(perk) then
					surface.SetDrawColor(color_gold)
					surface.SetMaterial(zmhud_icon_frame)
					surface.DrawTexturedRect(scw/2 + (num*(size + 2)*pscale) - (fuck/2)*size*pscale, (sch - 280*pscale - (th+12)) - size*row, size*pscale, size*pscale)
				end

				if perk == "vulture" and ent:HasVultureStink() then
					surface.SetMaterial(zmhud_vulture_glow)
					surface.SetDrawColor(color_white)
					surface.DrawTexturedRect(scw/2 + (num*(size + 2)*pscale) - (fuck/2)*size*pscale - 15*pscale, (sch - 280*pscale - (th+12)) - size*row - 15*pscale, 64*pscale, 64*pscale)

					local stink = surface.GetTextureID("nz_moo/huds/t6/zm_hud_stink_ani_green")
					surface.SetTexture(stink)
					surface.SetDrawColor(color_white)
					surface.DrawTexturedRect(scw/2 + (num*(size + 2)*pscale) - (fuck/2)*size*pscale, (sch - 280*pscale - (th+12)) - size*row - 42*pscale, 42*pscale, 42*pscale)
				end

				num = num + 1
				if num%8 == 0 then row = row + 1 num = 0 end
			end
		end

		// hud icon
		if showicons and ent.NZHudIcon then
			surface.SetMaterial((modern and ent.NZHudIcon_t7) and ent.NZHudIcon_t7 or ent.NZHudIcon)
			surface.SetDrawColor(color_white)
			surface.DrawTexturedRect(scw/2 - 32, sch - 280*pscale - (th+48), 64, 64)
		end

		// perk machines
		if perkmachineclasses[ent:GetClass()] and (nzRound:InState(ROUND_CREATE) or (ent.IsOn and ent:IsOn() or IsElec())) then
			local perkData = nzPerks:Get(ent:GetPerkID())
			if perkData and perkData.desc then
				draw.SimpleTextOutlined("Effect: "..perkData.desc, font2, scw/2, sch - 230*pscale, perkData.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black_100)
				if perkData.desc2 then
					draw.SimpleTextOutlined("Modifier: "..perkData.desc2, font2, scw/2, sch - 200*pscale, perkData.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black_100)
				end

				if showicons then
					local icon = GetPerkIconMaterial(ent:GetPerkID())
					if icon and !icon:IsError() then
						surface.SetMaterial(icon)
						surface.SetDrawColor(color_white)
						surface.DrawTexturedRect(scw/2 - 32, sch - 280*pscale - (th+48), 64, 64)
					end
				end
			end
		end
	end

	// textbox background
	if text ~= "" and modern then
		surface.SetDrawColor(color_black_100)
		surface.DrawRect(scw/2 - ((tw/2)+12), sch - 280*pscale - (th/2), tw+24, th)
	end

	draw.SimpleTextOutlined(text, font, scw/2, sch - 280*pscale, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black_100)
end

function GM:HUDDrawTargetID()
	local ply = LocalPlayer()
	if IsValid(ply:GetObserverTarget()) then ply = ply:GetObserverTarget() end
	local tr = ply:GetEyeTrace()
	local ent = tr.Entity

	if IsValid(ent) and tr.HitPos:DistToSqr(ply:EyePos()) < 14400 then
		DrawTargetID(GetText(ent), ent)
	else
		DrawTargetID(GetMapScriptEntityText())
	end
end
