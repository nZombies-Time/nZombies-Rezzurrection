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
	if IsValid(wep) and wep.CanKnifeLunge and wep:GetLunging() and IsValid(ply:GetKnifingTarget()) then
		if ply:IsOnGround() then
			local lunge = (ply:GetKnifingTarget():GetPos() - ply:GetPos()):GetNormalized()
			mv:SetVelocity(lunge * (wep.KnifeLungeSpeed or 800))
		end

		local vel = mv:GetVelocity()
		if vel[3] > ply:GetJumpPower() then
			mv:SetVelocity(vel - (vector_up*math.abs(vel[3])))
		end

		if ply:GetPos():DistToSqr(ply:GetKnifingTarget():GetPos()) <= 1024 then
			mv:SetVelocity(vector_origin)
			wep:SetLunging(false)
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
		nzSpecialWeapons:AddDisplay("tfa_bo3_syrette", false, function(wep)
			if SERVER then
				local ply = wep:GetOwner()
				local revive = ply:GetPlayerReviving()
				local reviving = true
				if ply.IsRevivingPlayer then //dont take away if reviving someone else
					reviving = not ply:IsRevivingPlayer()
				end

				return reviving and (not IsValid(revive) or not revive:Alive() or revive:GetNotDowned()) or not wep:GetOwner():KeyDown(IN_USE)
			end
		end)
		nzSpecialWeapons:AddDisplay("tfa_bo2_syrette", false, function(wep)
			if SERVER then
				local ply = wep:GetOwner()
				local revive = ply:GetPlayerReviving()
				local reviving = true
				if ply.IsRevivingPlayer then //dont take away if reviving someone else
					reviving = not ply:IsRevivingPlayer()
				end

				return reviving and (not IsValid(revive) or not revive:Alive() or revive:GetNotDowned()) or not wep:GetOwner():KeyDown(IN_USE)
			end
		end)
		nzSpecialWeapons:AddDisplay("tfa_bo4_syrette", false, function(wep)
			if SERVER then
				local ply = wep:GetOwner()
				local revive = ply:GetPlayerReviving()
				local reviving = true
				if ply.IsRevivingPlayer then //dont take away if reviving someone else
					reviving = not ply:IsRevivingPlayer()
				end

				return reviving and (not IsValid(revive) or not revive:Alive() or revive:GetNotDowned()) or not wep:GetOwner():KeyDown(IN_USE)
			end
		end)
	end)
end

hook.Add("PlayerButtonDown", "nzKOBEEE", function(ply, but)
	if not IsValid(ply) then return end
	if but == ply:GetInfoNum("nz_key_grenade", KEY_G) then
		local wep = ply:GetWeapon("tfa_bo1_m67")
		if IsValid(wep) then
			for k, v in pairs(ents.FindInSphere(ply:GetPos(), 64)) do
				if v.NZNadeRethrow and v:GetCreationTime() + 0.25 < CurTime() then
					ply:SetAmmo(ply:GetAmmoCount("nz_grenade") + 1, "nz_grenade")
					ply:SelectWeapon("tfa_bo1_m67")

					timer.Simple(0.5, function() //uhh ohh stinky
						if not IsValid(wep) then return end
						wep:SetHeldTime(wep:GetHeldTime() - 2)
					end)

					if SERVER then
						v:Remove()
					end
					break
				end
			end
		end
	end
end)
