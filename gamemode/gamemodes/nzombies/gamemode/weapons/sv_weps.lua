if not ConVarExists("nz_papattachments") then CreateConVar("nz_papattachments", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_NOTIFY}, "Whether Pack-a-Punching a CW2.0 weapon will attach random attachments for each category. Will also strip players of attachments at the beginning of the game.") end

hook.Add("PlayerSpawn", "RemoveCW2Attachments", function(ply)
	if GetConVar("nz_papattachments"):GetBool() and CustomizableWeaponry then
		for k,v in pairs(ply.CWAttachments) do
			CustomizableWeaponry:removeAttachment(ply, k)
		end
	end
end)

function GetPriorityWeaponSlot(ply)
	-- Create some variables to use
	local maxnum = ply:HasPerk("mulekick") and 3 or 2
	local tbl = {}
	local first
	
	-- Loop through weapons
	for k,v in pairs(ply:GetWeapons()) do
		local slot = v:GetNWInt("SwitchSlot")
		-- Mark this slot as being used
		tbl[slot] = true
		-- Also save whichever weapon has slot 1 in case the activeweapon doesnt have a slot
		if slot == 1 then first = v end
	end
	-- Now loop through the maxnumber we can have
	for i = 1, maxnum do
		-- If this slot hasn't been taken, return it
		if !tbl[i] then return i end
	end
	-- If we didn't return before (all slots taken), check the activeweapon
	local activewep = ply:GetActiveWeapon()
	local id = activewep:GetNWInt("SwitchSlot")
	-- Only replace it if it has an ID (default is 0)
	if id > 0 then
		return id, activewep
	end
	-- Else we should return the weapon stored in slot 1, if nothing at all just return slot 1 alone
	if first then return 1, first else return 1 end
end

local function OnWeaponAdded( wep )
	if wep:IsSpecial() then return end
	wep.Weight = 10000

	timer.Simple(engine.TickInterval(), function()
		if not IsValid(wep) then return end
		local ply = wep:GetOwner()
		if not IsValid(ply) then return end

		if !nzRound:InState( ROUND_CREATE ) then
			local slot, exists = GetPriorityWeaponSlot(ply)
			if IsValid(exists) then ply:StripWeapon(exists:GetClass()) end

			wep:SetNWInt("SwitchSlot", slot)

			local oldammo = wep.Primary.Ammo
			local newammo = wep:GetPrimaryAmmoType()
			if wep.IsTFAWeapon then
				wep.Primary_TFA.Ammo = game.GetAmmoName(newammo)
				wep.Primary_TFA.OldAmmo = oldammo
				wep:ClearStatCache("Primary.Ammo")
			else
				wep.Primary.Ammo = game.GetAmmoName(newammo)
				wep.Primary.OldAmmo = oldammo
			end

			wep.Weight = 10000
			ply:SelectWeapon(wep:GetClass())

			timer.Simple(engine.TickInterval(), function()
				if not IsValid(wep) then return end
				if not IsValid(ply) then return end

				/*if wep.NZSpecialCategory == "knife" and ply:HasPerk("sake") then
					wep:ApplyNZModifier("sake")
				end*/
				if not wep.NZSpecialCategory and ply:HasPerk("staminup") then
					wep:ApplyNZModifier("staminup")
				end
				if not wep.NZSpecialCategory and ply:HasPerk("deadshot") then
					wep:ApplyNZModifier("deadshot")
				end
				if not wep.NZSpecialCategory and ply:HasPerk("dtap2") then
					wep:ApplyNZModifier("dtap2")
				end
				if not wep.NZSpecialCategory and ply:HasPerk("dtap") then
					wep:ApplyNZModifier("dtap")
				end
				if not wep.NZSpecialCategory and ply:HasPerk("vigor") then
					wep:ApplyNZModifier("vigor")
				end
				if not wep.NZSpecialCategory and not wep:HasNZModifier("pap") and ply:HasPerk("wall") then
					wep:ApplyNZModifier("pap")

					if wep.NZPaPReplacement then
					local wep2 = ply:Give(wep.NZPaPReplacement)
						if IsValid(wep2) then
							wep2:ApplyNZModifier("pap")
							wep2:GiveMaxAmmo()
							/*if wep2.Ispackapunched then //what the actual fuck is this
								if !wep.Category == "NZ Rezzurrection" then
									wep2.Ispackapunched = 1
								end
								if wep2.NZPaPName then
									wep2.PrintName = wep2.NZPaPName
								end
							end*/
						end
					end
				end
				/*if wep.Ispackapunched then //this is cancer
					if !wep.Category == "NZ Rezzurrection" then
						wep.Ispackapunched = 1
					end
					if wep.NZPaPName then
						wep.PrintName = wep.NZPaPName
					end
				end*/

				if not wep.NoSpawnAmmo then
					wep:GiveMaxAmmo()
				else
					ply:SelectWeapon(wep:GetClass())
				end

				wep.Weight = 0
			end)
		end

		wep:ApplyNZModifier("equip")

		if wep.NearWallEnabled then wep.NearWallEnabled = false end
		if wep:IsFAS2() then wep.NoNearWall = true end

		if wep.ArcCW then
			ply:StripWeapon(wep:GetClass())
			ply:EmitSound("arccw.wav", 511)
			ply:ChatPrint("Maybe next time you'll follow directions. Go use TFA.")
		end
	end)
end

--Hooks
hook.Add("WeaponEquip", "nzOnWeaponAdded", OnWeaponAdded)

hook.Add("PlayerCanPickupWeapon", "PreventWhosWhoWeapons", function(ply, wep)
	if IsValid(wep:GetOwner()) and wep:GetOwner():GetClass() == "whoswho_downed_clone" then return false end
end)

-- Meta stuff
local meta = FindMetaTable("Player")
function meta:GiveNoAmmo(class)
	local wep = self:Give(class)
	if IsValid(wep) then wep.NoSpawnAmmo = true end
	return wep
end