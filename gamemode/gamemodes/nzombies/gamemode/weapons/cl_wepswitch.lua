local plyMeta = FindMetaTable( "Player" )
AccessorFunc( plyMeta, "iLastWeaponSlot", "LastWeaponSlot", FORCE_NUMBER)
AccessorFunc( plyMeta, "iCurrentWeaponSlot", "CurrentWeaponSlot", FORCE_NUMBER)
function plyMeta:SelectWeapon( class )
	if ( !self:HasWeapon( class ) ) then return end
	self.DoWeaponSwitch = self:GetWeapon( class )
end

function GM:CreateMove( cmd )
	local ply = LocalPlayer()
	if ( IsValid( ply.DoWeaponSwitch ) ) then
		cmd:SelectWeapon( ply.DoWeaponSwitch )

		if ( LocalPlayer():GetActiveWeapon() == ply.DoWeaponSwitch ) then
			ply:SetCurrentWeaponSlot(ply:GetActiveWeapon():GetNWInt("SwitchSlot", 1))
			ply.DoWeaponSwitch = nil
		end
	end
end

function GM:PlayerBindPress( ply, bind, pressed )
	if nzRound:InProgress() or nzRound:InState(ROUND_GO) then
		if !ply:GetCurrentWeaponSlot() then ply:SetCurrentWeaponSlot(ply:GetActiveWeapon():GetNWInt("SwitchSlot", 1)) end
		
		local slot
		local curslot = ply:GetCurrentWeaponSlot() or 1
		if string.find(bind, "slot1") then slot = 1 end
		if string.find(bind, "slot2") then slot = 2 end
		if string.find(bind, "slot3") then slot = 3 end
		if string.find(bind, "invnext") then 
			slot = curslot + 1
			if (ply:HasPerk("mulekick") and slot > 3) or (!ply:HasPerk("mulekick") and slot > 2) then
				slot = 1
			end
		end

		if string.find(bind, "invprev") then 
			slot = curslot - 1
			if slot < 1 then
				slot = ply:HasPerk("mulekick") and 3 or 2
			end
		end

		if !nzRound:InState(ROUND_CREATE) and (bind == "+menu" and pressed) then slot = ply:GetLastWeaponSlot() or 1 end

		if slot then
			ply:SetLastWeaponSlot(ply:GetActiveWeapon():GetNWInt("SwitchSlot", 1))
			if slot == 3 then
				for k, v in pairs(ply:GetWeapons()) do
					if v:GetNWInt("SwitchSlot") == slot then
						ply.DoWeaponSwitch = v
						//ply:SelectWeapon(v:GetClass())
						return true
					end
				end
				slot = 1
				for k, v in pairs(ply:GetWeapons()) do
					if v:GetNWInt("SwitchSlot") == slot then
						ply.DoWeaponSwitch = v
						//ply:SelectWeapon(v:GetClass())
						return true
					end
				end
			else
				for k, v in pairs(ply:GetWeapons()) do
					if v:GetNWInt("SwitchSlot") == slot then
						ply.DoWeaponSwitch = v
						//ply:SelectWeapon(v:GetClass())
						return true
					end
				end
			end
		end
		if string.find(bind, "slot") then return true end
	end
end
