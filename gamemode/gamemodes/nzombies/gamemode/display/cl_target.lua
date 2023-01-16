--
local usekey = "" .. string.upper(input.LookupBinding( "+use", true )) .. " - "
local traceents = {
	["wall_buys"] = function(ent)
		local wepclass = ent:GetWepClass()
		local price = ent:GetPrice()
		local wep = weapons.Get(wepclass)
		local pap = false
		local flipped = ent:GetFlipped()
 
		upgrade= ""
		upgrade2=""

			if wep.NZPaPReplacement then
				upgrade = wep.NZPaPReplacement
				local wep2 =  weapons.Get(wep.NZPaPReplacement)
				if wep2.NZPaPReplacement then
		 			upgrade2 = wep2.NZPaPReplacement
				else
					upgrade2 = ""
				end
			else
				upgrade = ""
			end

			if !wep then return "INVALID WEAPON" end
			local name = wep.PrintName
			local ammo_price = math.Round((price - (price % 10))/2)
			local text = ""

			if LocalPlayer():HasWeapon( upgrade ) then
				pap = true
			end
			if LocalPlayer():HasWeapon( upgrade2 ) then
				pap = true
			end
		if !LocalPlayer():HasWeapon( wepclass ) then
			if !pap then
				text = "Press " .. usekey .. name .." [Cost: " .. string.Comma(price) .. "]"
				if wepclass == "nz_grenade" then
    				local nade = LocalPlayer():GetItem("grenade")
    				if (LocalPlayer():HasPerk("widowswine") and (!nade or nade and nade.price < 4000)) then
        				text = "Press " .. usekey .. "Grenades [4,000]"
    				elseif (nade and ammo_price < nade.price) then
	 					text = "Press " .. usekey .. "Grenades [" .. string.Comma(nade.price) .. "]"
    				else
	 					text = "Press " .. usekey .. "Grenades [" .. string.Comma(ammo_price) .. "]"
    				end
				end
			else
				if pap then
					if not flipped then
						text = "Press " .. usekey .. "Upgraded Ammo [" .. string.Comma(ammo_price) .. "]"
					else
						text = "Press " .. usekey .. "Upgraded Ammo [4,500]"
					end
				end
			end
		else
			if LocalPlayer():HasWeapon( wepclass ) then
				--[[if flipped then
					text = "Press " .. usekey .. " Ammo [4,500], Upgraded Ammo [" .. string.Comma(ammo_price) .. "]"
				else
					text = "Press " .. usekey .. " Ammo [" .. string.Comma(ammo_price) .. "], Upgraded Ammo [4,500]"
				end]]
				text = "Press " .. usekey .. " Ammo [" .. string.Comma(ammo_price) .. "], Upgraded Ammo [4,500]"
			else
				text = "You already have this Weapon"
			end
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
		local text = ""
		if !ent:IsOn() then
			text = "You must turn on the electricity first!"
		elseif ent:GetBeingUsed() then
			text = "Currently in Use"
		else
			if ent:GetPerkID() == "pap" then
				local wep = LocalPlayer():GetActiveWeapon()
				if wep:HasNZModifier("pap") then
					if wep.NZRePaPText then
						text = nzPowerUps:IsPowerupActive("bonfiresale") and ("Press " .. usekey .. ""..wep.NZRePaPText.." [Cost: 500]") or ("Press " .. usekey .. ""..wep.NZRePaPText.." [Cost: 500]")
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
				if LocalPlayer():HasPerk(ent:GetPerkID()) and (LocalPlayer():HasUpgrade(ent:GetPerkID()) or tobool(nzMapping.Settings.perkupgrades) == false) then
					text = "You already own this perk"
				elseif LocalPlayer():HasPerk(ent:GetPerkID()) and !LocalPlayer():HasUpgrade(ent:GetPerkID()) then
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
				-- Its on
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
		local text = ""
		if not ent:IsOn() then
			text = "The Wunderfizz Orb is currently at another location"
		elseif ent:GetBeingUsed() then
			if ent:GetUser() == LocalPlayer() and ent:GetPerkID() ~= "" and not ent:GetIsTeddy() then
				if nzPerks:GetMachineType(nzMapping.Settings.perkmachinetype) == "IW" then
					text = "Press " .. usekey .. "for " .. nzPerks:Get(ent:GetPerkID()).name_skin
				else
					text = "Press " .. usekey .. "for " .. nzPerks:Get(ent:GetPerkID()).name
				end
			else
				text = "Selecting Beverage..."
			end
		elseif not ent:GetBeingUsed() and ent:IsOn() then
			if #LocalPlayer():GetPerks() >= GetConVar("nz_difficulty_perks_max"):GetInt() then
				text = "You may only carry " .. GetConVar("nz_difficulty_perks_max"):GetInt() .. " Perks"
			else
				text = "Press " .. usekey .. "Use Wunderfizz Orb [Cost: " .. string.Comma(ent:GetPrice()) .. "]"
			end
		end

		return text
	end,
}

local function GetTarget()
	local tr =  {
		start = EyePos(),
		endpos = EyePos() + LocalPlayer():GetAimVector()*150,
		filter = LocalPlayer(),
	}
	local trace = util.TraceLine( tr )
	if (!trace.Hit) then return end
	if (!trace.HitNonWorld) then return end

	--print(trace.Entity:GetClass())
	return trace.Entity
end

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

	local class = ent:GetClass()
	local text = ""

	local neededcategory, deftext, hastext = ent:GetNWString("NZRequiredItem"), ent:GetNWString("NZText"), ent:GetNWString("NZHasText")
	local itemcategory = ent:GetNWString("NZItemCategory")

	if neededcategory != "" then
		local hasitem = LocalPlayer():HasCarryItem(neededcategory)
		text = hasitem and hastext != "" and hastext or deftext
	elseif deftext != "" then
		text = deftext
	elseif itemcategory != "" then
		local item = nzItemCarry.Items[itemcategory]
		local hasitem = LocalPlayer():HasCarryItem(itemcategory)
		if hasitem then
			text = item and item.hastext or "You already have this"
		else
			text = usekey .. "Take"
		end
	elseif ent:IsPlayer() then
		if ent:GetNotDowned() then
			text = ent:Nick() .. " - " .. ent:Health() .. " HP"
		else
			text = usekey .. "Revive " .. ent:Nick()
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

	for k,v in pairs(ents.FindByClass("nz_script_triggerzone")) do
		local dist = v:NearestPoint(EyePos()):Distance(EyePos())
		if dist <= 1 then
			text = GetDoorText(v)
			break
		end
	end

	return text
end

function GetFontType(id)
	if id == "Classic NZ" then
	return "classic"
	end
	if id == "Old Treyarch" then
	return "waw"
	end
	if id == "BO2/3" then
	return "blackops2"
	end
	if id == "BO4" then
	return "blackops4"
	end
	if id == "Black Ops 1" then
	return "bo1"
	end
		if id == "Comic Sans" then
	return "xd"
	end
		if id == "Warprint" then
	return "grit"
	end
		if id == "Road Rage" then
	return "rage"
	end
		if id == "Black Rose" then
	return "rose"
	end
		if id == "Reborn" then
	return "reborn"
	end
		if id == "Rio Grande" then
	return "rio"
	end
		if id == "Bad Signal" then
	return "signal"
	end
		if id == "Infection" then
	return "infected"
	end
		if id == "Brutal World" then
	return "brutal"
	end
		if id == "Generic Scifi" then
	return "ugly"
	end
		if id == "Tech" then
	return "tech"
	end
		if id == "Krabby" then
	return "krabs"
	end
		if id == "Default NZR" then
	return "default"
	end
	if id == nil then
	return "default"
	end
end

local function DrawTargetID( text )

	if not text then return end

	local font = ("nz.small."..GetFontType(nzMapping.Settings.smallfont))
	local font2 = ("nz.ammo."..GetFontType(nzMapping.Settings.smallfont))
	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )

	local MouseX, MouseY = gui.MousePos()

	if ( MouseX == 0 && MouseY == 0 ) then

		MouseX = ScrW() / 2
		MouseY = ScrH() / 1.5

	end

	local x = MouseX
	local y = MouseY

	x = x - w / 2
	y = y + 30
	local ply = LocalPlayer()
	local ent = ply:GetEyeTrace().Entity
	local hitpos = ply:GetEyeTrace().HitPos

	if IsValid(ent) and ent:GetClass() == "perk_machine" then
		local dist = hitpos:DistToSqr(ply:GetShootPos())
		if dist < 150^2 then
			local perkData = nzPerks:Get(ent:GetPerkID())
			if perkData.desc then
				draw.SimpleTextOutlined( "Effect : "..perkData.desc, font2, ScrW()/2, ScrH()/1.45 + (0*math.sin(CurTime())) + 50, perkData.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black )
			end
			if perkData.desc2 then
				draw.SimpleTextOutlined( "Modifier : "..perkData.desc2, font2, ScrW()/2, ScrH()/1.36 + (0*math.sin(CurTime())) + 50, perkData.color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black )
			end
		end
	end

	-- The fonts internal drop shadow looks lousy with AA on
	draw.SimpleTextOutlined( text, font, ScrW()/2, ScrH()/1.45  + (0*math.sin(CurTime())), Color(225, 235, 255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black )
end

function GM:HUDDrawTargetID()

	local ent = GetTarget()

	if ent ~= nil then
		DrawTargetID(GetText(ent))
	else
		DrawTargetID(GetMapScriptEntityText())
	end

end
