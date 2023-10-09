local meleetypes = {
	[DMG_CLUB] = true,
	[DMG_SLASH] = true,
	[DMG_CRUSH] = true,
	[DMG_GENERIC] = true,
}

local blasttypes = {
	[DMG_BLAST] = true,
	[DMG_BLAST_SURFACE] = true,
	[DMG_AIRBOAT] = true,
}

local burntypes = {
	[DMG_BURN] = true,
	[DMG_SLOWBURN] = true,
}

local util_QuickTrace = util.QuickTrace

function nzEnemies:OnEnemyKilled(enemy, attacker, dmginfo, hitgroup)
	if enemy.MarkedForDeath then return end
	if not hitgroup then
		hitgroup = util_QuickTrace(dmginfo:GetDamagePosition(), dmginfo:GetDamagePosition()).HitGroup
	end

	if nzRound:InProgress() then
		nzRound:SetZombiesKilled( nzRound:GetZombiesKilled() + 1 )
        --print(nzRound:GetZombiesRemaining())
	end

	if enemy:IsValidZombie() and attacker:IsPlayer() and attacker:GetNotDowned() then
		attacker:AddFrags(1)

		local wep = dmginfo:GetInflictor()

		if attacker:HasPerk("vulture") then
			local chance = 12
			if attacker:HasUpgrade("vulture") then
				chance = 6
			end

			if math.random(chance) == 1 then
				local drop = ents.Create("drop_vulture")
				drop:SetOwner(attacker)
				drop:SetPos(enemy:WorldSpaceCenter())
				drop:SetAngles(enemy:GetForward():Angle())
				drop:Spawn()
			end
		end

		if attacker:HasPerk("everclear") then
			local zchance = 15
			local zduration = math.random(5, 15)

			local fchance = 50
			local fduration = 10

			if attacker:HasUpgrade("everclear") then
				fchance = 30
				fduration = 30

				zchance = 10
				zduration = math.random(10, 20)
			end

			if IsValid(wep) and math.random(fchance) == 1 then //pure rng
				local ent = ents.Create("nz_everclear_firepit")
				ent:SetPos(enemy:GetPos())
				ent:SetAngles(angle_zero)
				ent:SetAttacker(dmginfo:GetAttacker())
				ent:SetInflictor(wep)
				ent.Delay = fduration

				ent:Spawn()
			end

			if math.random(zchance) == 1 and attacker:GetNW2Float("nz.ZombShellDelay",0) < CurTime() then //rng w/ delay
				local zomb = ents.Create("zombshell_effect")
				zomb:SetPos(enemy:WorldSpaceCenter())
				zomb:SetOwner(attacker)
				zomb:SetAngles(angle_zero)
				zomb.Delay = zduration

				zomb:Spawn()

				attacker:SetNW2Float("nz.ZombShellDelay", CurTime() + (10 * attacker:GetNW2Int("nz.ZombShellCount",0)))
				attacker:SetNW2Int("nz.ZombShellCount", attacker:GetNW2Int("nz.ZombShellCount",0) + 1)
			end
		end

		if attacker:HasPerk("pop") and IsValid(wep) and wep.IsTFAWeapon and not wep.NZSpecialCategory then
			if attacker:GetNW2Float("nz.EPopDelay", 0) < CurTime() then
				if math.random(15) < attacker:GetNW2Int("nz.EPopChance", 0) then
					local upgrade = attacker:HasUpgrade("pop")

					attacker:SetNW2Float("nz.EPopDelay", CurTime() + (upgrade and 10 or 30))
					attacker:SetNW2Int("nz.EPopChance", 0)

					local eff = math.random(upgrade and 8 or 7)
					attacker:SetNW2Int("nz.EPopEffect", eff)
					attacker:SetNW2Float("nz.EPopDecay", CurTime() + 2)

					local aat = ents.Create("elemental_pop_effect_"..eff)
					aat:SetPos(enemy:GetPos())
					aat:SetParent(enemy)
					aat:SetOwner(attacker)
					aat:SetAttacker(dmginfo:GetAttacker())
					aat:SetInflictor(dmginfo:GetInflictor())
					aat:SetAngles(angle_zero)

					aat:Spawn()
				else
					attacker:SetNW2Int("nz.EPopChance", attacker:GetNW2Int("nz.EPopChance", 0) + 1)
				end
			end
		end

		if attacker:HasPerk("widowswine") and enemy.BO3IsWebbed and enemy:BO3IsWebbed() and math.random(7) == 1 and IsValid(wep) then
			local wido = ents.Create("drop_widows")
			wido:SetOwner(attacker)
			wido:SetPos(enemy:WorldSpaceCenter())
			wido:SetAngles(enemy:GetForward():Angle())
			wido:Spawn()
		end

		if meleetypes[dmginfo:GetDamageType()] then
			attacker:GivePoints(130)

			if attacker:HasUpgrade("sake") and math.random(100) <= 45 and attacker:GetNW2Float("nz.SakeDelay", 0) < CurTime() and IsValid(wep) then
				local arc = ents.Create("elemental_pop_effect_2")
				arc:SetModel("models/dav0r/hoverball.mdl")
				arc:SetPos(enemy:GetPos())
				arc:SetAngles(angle_zero)
				arc:SetOwner(attacker)
				arc:SetAttacker(attacker)
				arc:SetInflictor(wep)
				arc:SetNoDraw(true)

				arc.MaxChain = math.random(1,3)
				arc.ZapRange = 300
				arc.ArcDelay = 0.4

				arc:Spawn()

				attacker:SetNW2Float("nz.SakeDelay", CurTime() + 7)
			end
		elseif hitgroup == HITGROUP_HEAD and not dmginfo:IsDamageType(DMG_MISSILEDEFENSE) then
			attacker:EmitSound("nz_moo/effects/headshot_notif/headshot_notif_0"..math.random(2)..".mp3", SNDLVL_TALKING)
			attacker:GivePoints(100)
			if dmginfo:IsBulletDamage() and attacker:HasUpgrade("vigor") then
				attacker:GivePoints(50)
			end

			if attacker:HasPerk("deadshot") then
				if math.random(15) < attacker:GetNW2Int("nz.DeadshotChance", 0) then
					enemy:EmitSound("nzr/2022/effects/zombie/evt_kow_headshot.wav", 511, math.random(95,105), 1, CHAN_ITEM)
					attacker:EmitSound("nzr/2022/effects/zombie/head_0"..math.random(3)..".wav", 75, math.random(95,105), 1, CHAN_STATIC)
					ParticleEffect("divider_slash3", enemy:EyePos(), angle_zero)

					local round = nzRound:GetNumber() > 0 and nzRound:GetNumber() or 1
					local health = tonumber(nzCurves.GenerateHealthCurve(round))
					local scale = math.random(3) * 0.1
					local range = 160

					if attacker:HasUpgrade("deadshot") then
						scale = math.random(9) * 0.1
						range = 180
					end

					for k, v in pairs(ents.FindInSphere(enemy:EyePos(), range)) do
						if IsValid(v) and v:IsValidZombie() then
							if v:Health() <= 0 then continue end
							if v == enemy then continue end

							local damage = DamageInfo()
							damage:SetDamage((health * scale) + 200)
							damage:SetAttacker(attacker)
							damage:SetInflictor(enemy)
							damage:SetDamageType(DMG_MISSILEDEFENSE)
							damage:SetDamageForce(v:GetUp()*5000 + (v:GetPos() - enemy:GetPos()):GetNormalized()*10000)
							damage:SetDamagePosition(v:EyePos())
							v:TakeDamageInfo(damage)

							timer.Simple(0, function()
								if not IsValid(v) or v:Health() <= 0 then return end
								v:FleeTarget(3)
							end)
						end
					end

					attacker:SetNW2Float("nz.DeadshotDecay", CurTime() + 1)
					attacker:SetNW2Int("nz.DeadshotChance", 0)
				else
					attacker:SetNW2Int("nz.DeadshotChance", attacker:GetNW2Int("nz.DeadshotChance", 0) + (attacker:HasUpgrade("deadshot") and 2 or 1))
				end
			end
		elseif dmginfo:IsDamageType(DMG_MISSILEDEFENSE) then
			attacker:GivePoints(30)
		else
			attacker:GivePoints(50)
			if dmginfo:IsBulletDamage() and attacker:HasUpgrade("vigor") then
				attacker:GivePoints(math.random(5) * 10)
			end
		end
	end

	if nzRound:InProgress() then
		if !nzPowerUps:IsPowerupActive("insta") and IsValid(enemy) then -- Don't spawn powerups during instakill
			if !nzPowerUps:GetPowerUpChance() then nzPowerUps:ResetPowerUpChance() end
			if math.Rand(0, 100) < nzPowerUps:GetPowerUpChance() then
				nzPowerUps:SpawnPowerUp(enemy:GetPos())
				nzPowerUps:ResetPowerUpChance()
			else
				nzPowerUps:IncreasePowerUpChance()
			end
		end

		//print("Killed Enemy: " .. nzRound:GetZombiesKilled() .. "/" .. nzRound:GetZombiesMax() )

		if nzRound:IsSpecial() and nzRound:GetZombiesKilled() >= nzRound:GetZombiesMax() then
			nzPowerUps:SpawnPowerUp(enemy:GetPos(), "maxammo")
		end
	end

	enemy.MarkedForDeath = true
end

function GM:EntityTakeDamage(zombie, dmginfo)
	if zombie:IsPlayer() and dmginfo:IsDamageType(DMG_SLOWBURN) then return true end
	if zombie:GetClass() == "whoswho_downed_clone" then return true end
	if zombie.Alive and zombie:Health() <= 0 and zombie:Alive() and meleetypes[dmginfo:GetDamageType()] then zombie:Remove() end //failsafe for 0 health enemies (THAT DOESNT FUCKING WORK :DDDDDDDD)
	--if zombie.Alive and zombie:Health() <= 0 /*and zombie:Alive()*/ then zombie:Kill(dmginfo) end
	 -- Trying out stuff that doesn't use this dusty ass kill function.

	if zombie.IsMooZombie and zombie.SpawnProtection then return end

	local attacker = dmginfo:GetAttacker()
	if !attacker:IsValid() then return end

	if !attacker:IsPlayer() and IsValid(zombie) and zombie:IsValidZombie() and zombie:Health() > 0 then
		if attacker.IsAATTurned and attacker:IsAATTurned() then
			local turnedowner = attacker:GetNW2Entity("PERK.TurnedLogic"):GetAttacker()
			if IsValid(turnedowner) and turnedowner:IsPlayer() then
				dmginfo:SetDamageType(DMG_MISSILEDEFENSE)
				dmginfo:SetAttacker(turnedowner)
			end
			dmginfo:SetDamage(zombie:Health() + 666)
			nzEnemies:OnEnemyKilled(zombie, turnedowner, dmginfo, nil)
			return
		end

		if (attacker:GetClass() == "nz_trap_projectiles" or attacker:GetClass() == "nz_trap_turret") then 
			--zombie:Kill(dmginfo) -- Trying out stuff that doesn't use this dusty ass kill function.
			zombie:TakeDamage(zombie:Health() + 666, nil, nil)
			nzEnemies:OnEnemyKilled(zombie, turnedowner, dmginfo, nil)
		end
		return
	end

	if IsValid(zombie) then
		local round = nzRound:GetNumber() > 0 and nzRound:GetNumber() or 1
		local health = tonumber(nzCurves.GenerateHealthCurve(round))
		local hitgroup = util_QuickTrace(dmginfo:GetDamagePosition(), dmginfo:GetDamagePosition()).HitGroup
		local isplayer = attacker:IsPlayer()
		local dmgtype = dmginfo:GetDamageType()

		local headpos = zombie:EyePos()
		local headbone = zombie:LookupBone("ValveBiped.Bip01_Head1")
		if !headbone then headbone = zombie:LookupBone("j_head") end
		if headbone then headpos = zombie:GetBonePosition(headbone) end

		if zombie.NZBossType then
			if zombie.BossMeleeOnly and isplayer and not meleetypes[dmgtype] then return true end
			if zombie.IsInvulnerable and zombie:IsInvulnerable() then return true end

			if isplayer and dmginfo:IsExplosionDamage() then
				dmginfo:SetDamage(dmginfo:GetDamage() * (attacker:HasPerk("danger") and 2 or 1.2))
			end

			if isplayer and attacker:HasUpgrade("death") then
				dmginfo:ScaleDamage(3)
			end

			if isplayer and attacker:HasPerk("sake") and meleetypes[dmgtype] then
				dmginfo:SetDamageType(DMG_SHOCK)
				dmginfo:ScaleDamage(4)
			end

			local data = nzRound:GetBossData(zombie.NZBossType)
			if data then
				if zombie:Health() > dmginfo:GetDamage() then
					if data.onhit then data.onhit(zombie, attacker, dmginfo, hitgroup) end
				elseif !zombie.MarkedForDeath then
					if data.deathfunc then data.deathfunc(zombie, attacker, dmginfo, hitgroup) end
					hook.Call("OnBossKilled", nil, zombie)
					zombie.MarkedForDeath = true
				end
			end
		elseif zombie:IsValidZombie() then
			if zombie.IsAATTurned and zombie:IsAATTurned() then return true end
			if zombie.IsInvulnerable and zombie:IsInvulnerable() then return true end
			if zombie.BossMeleeOnly and isplayer and not meleetypes[dmgtype] then return true end

			local wep = dmginfo:GetInflictor()
			if not IsValid(wep) and isplayer then
				wep = attacker:GetActiveWeapon()
			end

			if isplayer and attacker:HasPerk("sake") and meleetypes[dmgtype] then
				dmginfo:SetDamageType(DMG_MISSILEDEFENSE)
				if attacker:HasUpgrade("sake") then
					zombie:EmitSound("NZ.POP.Deadwire.Shock")
					ParticleEffectAttach("bo3_waffe_electrocute", PATTACH_POINT_FOLLOW, zombie, 2)
					if zombie:OnGround() then
						ParticleEffectAttach("bo3_waffe_ground", PATTACH_ABSORIGIN_FOLLOW, zombie, 0)
					end
					dmginfo:SetDamageType(DMG_SHOCK)
				end

				if nzPowerUps:IsPowerupActive("insta") then
					dmginfo:SetDamagePosition(headpos)
				end
				dmginfo:SetDamage(zombie:Health() + 666)
				nzEnemies:OnEnemyKilled(zombie, attacker, dmginfo, hitgroup)
				return
			end

			if nzPowerUps:IsPowerupActive("insta") then
				dmginfo:SetDamagePosition(headpos)
				dmginfo:SetDamage(zombie:Health() + 666)
				nzEnemies:OnEnemyKilled(zombie, attacker, dmginfo, hitgroup)
				return
			end

			if isplayer and dmginfo:IsDamageType(DMG_DIRECT) then
				dmginfo:SetDamage(zombie:Health() + 666) 
				nzEnemies:OnEnemyKilled(zombie, attacker, dmginfo, hitgroup)
				return
			end

			if zombie:IsZombSlowed() then
				dmginfo:ScaleDamage(2)
			end

			if isplayer and IsValid(wep) and hitgroup == HITGROUP_HEAD and (zombie.GetDecapitated and !zombie:GetDecapitated()) then 
				if attacker:HasPerk("death") then
					dmginfo:SetDamage(dmginfo:GetDamage() * (attacker:HasUpgrade("death") and 1.5 or 1.25))
				end
				dmginfo:ScaleDamage(wep.NZHeadShotMultiplier or 2.5)
			end

			if isplayer and attacker:HasPerk("danger") and dmginfo:IsExplosionDamage() then
				if IsValid(wep) then
					if wep.Primary and (wep.Primary.Projectile or wep.Projectile) then
						dmginfo:ScaleDamage(2)
					end
				else
					dmginfo:ScaleDamage(2)
				end
			end

			if isplayer and dmginfo:IsDamageType(DMG_RADIATION) then
				dmginfo:SetDamage(dmginfo:GetDamage() + health*0.01) //1% of MAX zombie health
			end

			if isplayer and attacker:HasPerk("fire") then
				if burntypes[dmgtype] then
					dmginfo:ScaleDamage(attacker:HasUpgrade("fire") and 4 or 2)
				end
				if attacker:HasUpgrade("fire") and math.random(5) == 1 then
					dmginfo:SetDamageType(DMG_BURN)
					zombie:Ignite(math.Round(dmginfo:GetDamage()/6, 1))
				end
			end

			if zombie:Health() > dmginfo:GetDamage() then
				if zombie.HasTakenDamageThisTick then return end

				if isplayer then
					if burntypes[dmgtype] then
						zombie:Ignite(math.Round(dmginfo:GetDamage()/15))
					end

					if dmginfo:IsDamageType(DMG_DROWN) and math.random(30) == 1 and not zombie:IsATTCryoFreeze() then
						zombie:ATTCryoFreeze(math.Rand(1.4,1.6), dmginfo:GetAttacker(), dmginfo:GetInflictor())
					end

					if attacker:HasPerk("widowswine") and meleetypes[dmgtype] and zombie.BO3SpiderWeb then
						zombie:BO3SpiderWeb(10, attacker)
					end

					if attacker:GetNotDowned() and !hook.Call("OnZombieShot", nil, zombie, attacker, dmginfo, hitgroup) then
						attacker:GivePoints(10)
					end
				end

				zombie.HasTakenDamageThisTick = true
				timer.Simple(0, function() if IsValid(zombie) then zombie.HasTakenDamageThisTick = false end end)
			else
				nzEnemies:OnEnemyKilled(zombie, attacker, dmginfo, hitgroup)
			end
		end
	end
end

local function OnRagdollCreated(ent)
	if ent:GetClass() == "prop_ragdoll" then
		ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	end
end
hook.Add("OnEntityCreated", "nzEnemies_OnEntityCreated", OnRagdollCreated)

-- Increase max zombies alive per round
hook.Add("OnRoundPreparation", "NZIncreaseSpawnedZombies", function()
	if (!nzRound or !nzRound:GetNumber()) then return end
	if (nzRound:GetNumber() == 1 or nzRound:GetNumber() == -1) then return end -- Game just begun or it's round infinity

	local perround = nzMapping.Settings.spawnperround != nil and nzMapping.Settings.spawnperround or 0

	if (NZZombiesMaxAllowed == nil and nzMapping.Settings.startingspawns) then
		NZZombiesMaxAllowed = nzMapping.Settings.startingspawns
	end

	local startSpawns = nzMapping.Settings.startingspawns
	if !nzMapping.Settings.startingspawns then
		NZZombiesMaxAllowed = 35
		startSpawns = 35 
	end

	local maxspawns = nzMapping.Settings.maxspawns
	if (maxspawns == nil) then 
		maxspawns = 35 
	end

	local newmax = startSpawns + (nzRound:GetNumber() * perround)
	if (newmax < maxspawns) then
		NZZombiesMaxAllowed = newmax
		print("Max zombies allowed at once: " .. NZZombiesMaxAllowed)
	else
		if (NZZombiesMaxAllowed != maxspawns) then
			print("Max zombies allowed at once capped at: " .. maxspawns)
			NZZombiesMaxAllowed = maxspawns
		end
	end
end)
