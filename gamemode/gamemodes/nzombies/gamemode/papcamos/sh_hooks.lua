if SERVER then
	hook.Add("WeaponEquip", "nzCamo.ViewModel", function(wep, ply)
		if not IsValid(wep) then return end

		timer.Simple(engine.TickInterval(), function()
			if not IsValid(ply) then return end
			if not IsValid(wep) then return end

			if wep.IsTFAWeapon or wep.CW20Weapon or wep.IsFAS2Weapon then //nz compatible weapons
				if wep.NZSpecialCategory then return end

				print('Generated random pap camo from config table')
				print(nzCamos:Get(nzMapping.Settings.PAPcamo).name)

				nzCamos:RandomizeCamo( ply, wep )

				timer.Simple(engine.TickInterval(), function()
					if not IsValid(ply) then return end
					if not IsValid(wep) then return end

					if wep.PreDrawViewModel then
						local info = debug.getinfo(wep.PreDrawViewModel)
						local weapon = file.Read(info.short_src, true)
						local weptab = string.Split(weapon, '\n')

						for i=info.linedefined + 1, info.lastlinedefined - 1 do
							if string.find(weptab[i], "SetSubMaterial") then
								print('Already has pap camo groups')
								return
							end
						end
					end

					print("Generating pap camo groups for "..wep.PrintName)
					nzCamos:GenerateCamo( ply, wep )

					if wep.IsTFAWeapon and wep.VElements then
						for k, v in pairs(wep.VElements) do
							if not v.active then continue end

							print("Generating pap camo groups for VElement "..k)
							nzCamos:GenerateVElementCamo( ply, wep, k )
						end
					end
				end)
			end
		end)
	end)
end

if CLIENT then
	hook.Add("PreDrawViewModel", "nzCamo.AutoGenerator", function(vm, ply, wep)
		if not IsValid(vm) or not IsValid(wep) or not IsValid(ply) then return end
		if not GetConVar("nz_papcamo"):GetBool() then return end
		if not wep:HasNZModifier("pap") then return end
		if not (wep.IsTFAWeapon or wep.CW20Weapon or wep.IsFAS2Weapon) then vm:SetSubMaterial() return end
		if wep.NZCamoBlacklist then return end

		if wep.nzPaPCamo and wep.PaPOverrideMat then
			for k, v in pairs(wep.PaPOverrideMat) do
				vm:SetSubMaterial(k, wep.nzPaPCamo)
			end
		end

		if wep.VElements and wep.nzPaPCamo and wep.VPaPOverrideMat then
			for _, element in pairs(wep.VElements) do
				local model = element.curmodel
				if IsValid(model) then
					for k, v in pairs(wep.VPaPOverrideMat) do
						model:SetSubMaterial(k, wep.nzPaPCamo)
					end
				end
			end
		end
	end)
end