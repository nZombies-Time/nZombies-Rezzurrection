local PLAYER = FindMetaTable("Player")

if PLAYER then
	function PLAYER:GetKnifingTarget()
		return self:GetNW2Entity("nz.KnifingEnemy")
	end

	function PLAYER:SetKnifingTarget(ent)
		return self:SetNW2Entity("nz.KnifingEnemy", ent)
	end
end

-- M67 Grenade
TFA.AddWeaponSound("TFA.BO1.M67.Bounce.Earth", {"nzr/2022/weapons/tfa_bo1/m67/earth/earth_00.wav", "nzr/2022/weapons/tfa_bo1/m67/earth/earth_01.wav", "nzr/2022/weapons/tfa_bo1/m67/earth/earth_02.wav", "nzr/2022/weapons/tfa_bo1/m67/earth/earth_03.wav", "nzr/2022/weapons/tfa_bo1/m67/earth/earth_04.wav"})
TFA.AddWeaponSound("TFA.BO1.M67.Bounce.Metal", {"nzr/2022/weapons/tfa_bo1/m67/metal/metal_00.wav", "nzr/2022/weapons/tfa_bo1/m67/metal/metal_01.wav", "nzr/2022/weapons/tfa_bo1/m67/metal/metal_02.wav", "nzr/2022/weapons/tfa_bo1/m67/metal/metal_03.wav", "nzr/2022/weapons/tfa_bo1/m67/metal/metal_04.wav"})
TFA.AddWeaponSound("TFA.BO1.M67.Bounce.Wood", {"nzr/2022/weapons/tfa_bo1/m67/wood/wood_00.wav", "nzr/2022/weapons/tfa_bo1/m67/wood/wood_01.wav", "nzr/2022/weapons/tfa_bo1/m67/wood/wood_02.wav", "nzr/2022/weapons/tfa_bo1/m67/wood/wood_03.wav", "nzr/2022/weapons/tfa_bo1/m67/wood/wood_04.wav"})

TFA.AddWeaponSound("TFA.BO1.M67.Pin", "nzr/2022/weapons/tfa_bo1/m67/pin.wav")
TFA.AddWeaponSound("TFA.BO1.M67.Throw", "nzr/2022/weapons/tfa_bo1/m67/gren_throw.wav")

TFA.AddSound ("TFA.BO1.EXP.Dirt", CHAN_STATIC, 1, SNDLVL_NORM, 100, {"nzr/2022/weapons/tfa_bo1/m67/dirt_00.wav", "nzr/2022/weapons/tfa_bo1/m67/dirt_01.wav", "nzr/2022/weapons/tfa_bo1/m67/dirt_02.wav"},")")
TFA.AddSound ("TFA.BO1.EXP.Lfe", CHAN_STATIC, 1, SNDLVL_GUNFIRE, 100, "nzr/2022/weapons/tfa_bo1/m67/exp_grenade_lfe.wav", ")")
TFA.AddSound ("TFA.BO1.EXP.Explode", CHAN_WEAPON, 1, SNDLVL_GUNFIRE, 100, {"nzr/2022/weapons/tfa_bo1/m67/explode_00.wav", "nzr/2022/weapons/tfa_bo1/m67/explode_01.wav", "nzr/2022/weapons/tfa_bo1/m67/explode_02.wav"},")")
TFA.AddSound ("TFA.BO1.EXP.Flux", CHAN_ITEM, 1, SNDLVL_TALKING, 100, {"nzr/2022/weapons/tfa_bo1/m67/flux_00.wav", "nzr/2022/weapons/tfa_bo1/m67/flux_01.wav"},")")

-- Semtex
TFA.AddWeaponSound("TFA.BO1.SEMTEX.Pin", "nzr/2022/weapons/tfa_bo1/semtex/semtex_pin_pull.wav")
TFA.AddWeaponSound("TFA.BO1.SEMTEX.Charge", "nzr/2022/weapons/tfa_bo1/semtex/semtex_charge.wav")
TFA.AddSound ("TFA.BO1.SEMTEX.Alert", CHAN_ITEM, 1, SNDLVL_IDLE, 100, "nzr/2022/weapons/tfa_bo1/semtex/semtex_alert.wav",")")

-- Parabolic Knife
TFA.AddWeaponSound("TFA.BO1.KNIFE.Swing", "nzr/2022/weapons/tfa_bo1/knife/whoosh_00.wav")
TFA.AddWeaponSound("TFA.BO1.KNIFE.Hit", {"nzr/2022/weapons/tfa_bo1/knife/hit_object_00.wav", "nzr/2022/weapons/tfa_bo1/knife/hit_object_01.wav", "nzr/2022/weapons/tfa_bo1/knife/hit_object_02.wav", "nzr/2022/weapons/tfa_bo1/knife/hit_object_03.wav"})
TFA.AddWeaponSound("TFA.BO1.KNIFE.HitFlesh", {"nzr/2022/weapons/tfa_bo1/knife/knife_slash_00.wav", "nzr/2022/weapons/tfa_bo1/knife/knife_slash_01.wav", "nzr/2022/weapons/tfa_bo1/knife/knife_slash_02.wav"})

hook.Add("SetupMove", "nzknifeshmove", function(ply, mv, cmd)
	local wep = ply:GetActiveWeapon()
	if IsValid(wep) and wep.CanKnifeLunge then
		if ply:IsOnGround() and wep:GetLunging() and IsValid(ply:GetKnifingTarget()) then
			mv:SetVelocity((ply:GetKnifingTarget():GetPos() - ply:GetPos()):GetNormalized() * (wep.KnifeLungeSpeed or 800))
			if ply:GetPos():DistToSqr(ply:GetKnifingTarget():GetPos()) <= 32^2 then
				mv:SetVelocity(vector_origin)
				wep:SetLunging(false)
			end
		end
	end
end)

hook.Add("StartCommand", "nzknifemove", function(ply, cmd)
	local wep = ply:GetActiveWeapon()
	if IsValid(wep) and wep.CanKnifeLunge then
		if ply:IsOnGround() and wep:GetLunging() then
			cmd:RemoveKey(IN_SPEED)
			cmd:RemoveKey(IN_JUMP)
			cmd:RemoveKey(IN_DUCK)
			cmd:ClearMovement()
		end
	end
end)

if engine.ActiveGamemode() == "nzombies" then
	hook.Add("InitPostEntity", "nzfuckstuff", function()
		nzSpecialWeapons:AddKnife("tfa_bo1_knife", false, 0.7)
		nzSpecialWeapons:AddGrenade("tfa_bo1_m67", 4, false, 0.6, false, 0.4)
		nzSpecialWeapons:AddGrenade("tfa_bo1_semtex", 4, false, 0.6, false, 0.4)
		nzSpecialWeapons:AddDisplay("tfa_perk_bottle", false, function(wep)
			return SERVER and (wep.nzDeployTime + (wep:GetOwner():HasUpgrade("speed") and 1.65 or 2.2)) < CurTime()
		end)
		nzSpecialWeapons:AddDisplay("tfa_paparms", false, function(wep)
			return SERVER and (wep.nzDeployTime + (wep:GetOwner():HasPerk("time") and 1.5 or 2)) < CurTime()
		end)
		nzSpecialWeapons:AddDisplay("tfa_zomdeath", false, function(wep)
			return ply:GetNotDowned()
		end)
	end)
end

hook.Add("PlayerButtonDown", "nzKOBEEE", function(ply, but)
	if not IsValid(ply) then return end
	if but == ply:GetInfoNum("nz_key_grenade", KEY_G) then
		for k, v in pairs(ents.FindInSphere(ply:GetPos(), 64)) do
			if v:GetClass() == "bo1_m67_grenade" then
				local wep = ply:GetWeapon("tfa_bo1_m67")
				if IsValid(wep) then //if ur at full and pickup someone elses nade, youll still lose one
					ply:SetAmmo(ply:GetAmmoCount("nz_grenade") + 1, "nz_grenade") //but thats just the cost of doin buisness
					ply:SelectWeapon(wep:GetClass())

					timer.Simple(0.5, function() //uhh ohh stinky
						if not IsValid(wep) then return end
						wep:SetHeldTime(wep:GetHeldTime() - 2)
					end)
					if SERVER then
						v:Remove()
					end
				end

				break
			end
		end
	end
end)

if CLIENT then
	hook.Add("HUDPaint", "nzfucknade_hud", function()
		local ply = LocalPlayer()
		if not IsValid(ply) then return end

		local dents = {}
		local lookfor = {
			["bo1_m67_grenade"] = true,
		}

		for _, ent in pairs(ents.FindInSphere(ply:GetPos(), 400)) do
			if lookfor[ent:GetClass()] and (ent.spawntime + 1) < CurTime() and ply == ent:GetOwner() then
				local dir = ply:EyeAngles():Forward()
				local facing = (ply:GetPos() - ent:GetPos()):GetNormalized()
				if (facing:Dot(dir) + 1) / 2 > 0.45 then
					table.insert(dents, ent)
				end
			end
		end

		for _, ent in ipairs(dents) do
			local totaldist = 400^2
			local distfade = 400^2
			local playerpos = ply:GetPos():DistToSqr(ent:GetPos())
			local fadefac = 1 - math.Clamp((playerpos - totaldist + distfade) / distfade, 0, 1)

			local dir = (ent:GetPos() - ply:GetShootPos()):Angle()
			dir = dir - EyeAngles()
			local angle = dir.y + 90

			local x = (math.cos(math.rad(angle)) * ScreenScale(90)) + ScrW() / 2
			local y = (math.sin(math.rad(angle)) * -ScreenScale(90)) + ScrH() / 2

			surface.SetMaterial(Material("vgui/hud/hud_grenadeicon.png", "smooth unlitgeneric"))
			surface.SetDrawColor(255,255,255,255*fadefac)
			surface.DrawTexturedRect(x, y, ScreenScale(24), ScreenScale(24))
		end
	end)
end