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

function nzEnemies:OnEnemyKilled(enemy, attacker, dmginfo, hitgroup)
	local wep = dmginfo:GetInflictor()
	if enemy.MarkedForDeath then return end

	if nzRound:InProgress() then
		nzRound:SetZombiesKilled( nzRound:GetZombiesKilled() + 1 )
	end

	if attacker:IsPlayer() then
		attacker:AddFrags(1)
		if attacker:HasPerk("vulture") then
			local chance = 12
			if attacker:HasUpgrade("vulture") then
				chance = 6
			end

			if math.random(chance) == 1 then
				local drop = ents.Create("drop_vulture")
				drop:SetPos(enemy:WorldSpaceCenter())
				drop:Spawn()
			end
		end

		if attacker:HasPerk("everclear") then
			local chance = 50
			local duration = 10
			if attacker:HasUpgrade("everclear") then
				chance = 30
				duration = 30
			end

			if IsValid(wep) and math.random(chance) == 1 then
				local ent = ents.Create("nz_everclear_firepit")
				ent:SetPos(enemy:GetPos())
				ent:SetAngles(enemy:GetAngles())
				ent:SetAttacker(dmginfo:GetAttacker())
				ent:SetInflictor(dmginfo:GetInflictor())
				ent.Delay = duration

				ent:Spawn()
			end
		end

		--[[if dmginfo:IsDamageType( 131072 ) then
			if math.random(5) == 3 then
				enemy:EmitSound("bo1_overhaul/n6/xplo"..math.random(2)..".mp3")
				ParticleEffect("novagas_xplo",enemy:GetPos(),enemy:GetAngles(),nil)
				local vaporizer = ents.Create("point_hurt")
				if !vaporizer:IsValid() then return end
				vaporizer:SetKeyValue("Damage", 25)
				vaporizer:SetKeyValue("DamageRadius", 100)
				vaporizer:SetKeyValue("DamageDelay", 0.75)
				vaporizer:SetKeyValue("DamageType",DMG_NERVEGAS)
				vaporizer:SetPos(enemy:GetPos())
				vaporizer:SetOwner(attacker)
				vaporizer:Spawn()
				vaporizer:Fire("TurnOn","",0)
				vaporizer:Fire("kill","",15)
			end
		end]]

		--[[if dmginfo:IsDamageType( 1048576 ) then
			if math.random(7) == 6 then
				enemy:EmitSound("pop_acid.mp3",511)
				local vaporizer = ents.Create("point_hurt")
		   		local gfx = ents.Create("pfx2_03")
        		gfx:SetPos(enemy:GetPos())
        		gfx:SetAngles(enemy:GetAngles())
        		gfx:Spawn()
				if !vaporizer:IsValid() then return end
				vaporizer:SetKeyValue("Damage", 34)
				vaporizer:SetKeyValue("DamageRadius", 200)
				vaporizer:SetKeyValue("DamageDelay", 0.5)
				vaporizer:SetKeyValue("DamageType",DMG_NERVEGAS)
				vaporizer:SetPos(enemy:GetPos())
				vaporizer:SetOwner(attacker)
				vaporizer:Spawn()
				vaporizer:Fire("TurnOn","",0)
				vaporizer:Fire("kill","",10)
				timer.Simple(10, function()
					gfx:Remove()
				end)
			end
		end]]

		--[[if dmginfo:IsDamageType( 4096 ) then
			if math.random(10) == 6 then
				enemy:EmitSound("pop_antimatter.wav", 94, math.random(90,100))
				local ent = ents.Create("env_explosion")
				ent:SetPos(enemy:GetPos())
				ent:SetAngles(enemy:GetAngles())
				ent:Spawn()
				local baseDamage =  dmginfo:GetDamage() *5.5
				ent:SetKeyValue("imagnitude", baseDamage)
				ent:SetKeyValue("iradiusoverride", "80")
				ent:Fire("explode")
				local gfx = ents.Create("pfx8_01")
				gfx:SetPos(enemy:GetPos() + Vector(0,0,20))
				gfx:SetAngles(enemy:GetAngles())
				gfx:Spawn()
				timer.Simple(2, function()
					gfx:Remove()
				end)
			end
		end]]
	end

	if enemy:IsValidZombie() then
		if attacker:IsPlayer() and attacker:GetNotDowned() then
			if meleetypes[dmginfo:GetDamageType()] then
				attacker:GivePoints(130)
			elseif hitgroup == HITGROUP_HEAD and not dmginfo:IsDamageType(DMG_MISSILEDEFENSE) then
				attacker:EmitSound("nz_moo/effects/headshot_notif/headshot_notif_0"..math.random(2)..".mp3", SNDLVL_TALKING)
				attacker:GivePoints(100)
				if dmginfo:IsBulletDamage() and attacker:HasUpgrade("vigor") then
					attacker:GivePoints(50)
				end

				if attacker:HasPerk("deadshot") then
					if math.random(15) < attacker:GetNW2Int("nz.DeadshotChance", 0) then
						enemy:EmitSound("nzr/2022/effects/zombie/evt_kow_headshot.wav", 150)
						enemy:EmitSound("nzr/2022/effects/zombie/head_0"..math.random(3)..".wav", 511)
						ParticleEffect("divider_slash3", enemy:EyePos(), Angle(0,0,0))

						attacker:SetNW2Float("nz.DeadshotDecay", CurTime() + 1)

						local round = nzRound:GetNumber() > 0 and nzRound:GetNumber() or 1
						local health = tonumber(nzCurves.GenerateHealthCurve(round))
						local scale = math.random(3) * 0.1
						if attacker:HasUpgrade("deadshot") then
							scale = math.random(9) * 0.1
						end

						for k, v in pairs(ents.FindInSphere(enemy:EyePos(), 160)) do
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
									v:FleeTarget(2)
								end)
							end
						end

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

	local attacker = dmginfo:GetAttacker()
	if !attacker:IsValid() then return end

	if !attacker:IsPlayer() then
		if IsValid(zombie) and zombie:IsValidZombie() and zombie:Health() > 0 then
			if attacker.IsAATTurned and attacker:IsAATTurned() then
				local turnedowner = attacker:GetNW2Entity("PERK.TurnedLogic"):GetAttacker()
				if IsValid(turnedowner) and turnedowner:IsPlayer() then
					dmginfo:SetDamageType(DMG_MISSILEDEFENSE)
					dmginfo:SetAttacker(turnedowner)
				end
				dmginfo:SetDamage(zombie:Health() + 666)
				nzEnemies:OnEnemyKilled(zombie, turnedowner, dmginfo, hitgroup)
				return
			end

			if (attacker:GetClass() == "nz_trap_projectiles" or attacker:GetClass() == "nz_trap_turret") then 
				--zombie:Kill(dmginfo) -- Trying out stuff that doesn't use this dusty ass kill function.
				zombie:TakeDamage(zombie:Health(), nil, nil)
			end
		end
		return
	end

	if IsValid(zombie) then
		local round = nzRound:GetNumber() > 0 and nzRound:GetNumber() or 1
		local health = tonumber(nzCurves.GenerateHealthCurve(round))
		local hitgroup = util.QuickTrace(dmginfo:GetDamagePosition(), dmginfo:GetDamagePosition()).HitGroup
		local isplayer = attacker:IsPlayer()

		if zombie.NZBossType then
			if zombie.BossMeleeOnly and isplayer and not meleetypes[dmginfo:GetDamageType()] then return true end
			if zombie.IsInvulnerable and zombie:IsInvulnerable() then return true end

			if isplayer and dmginfo:IsExplosionDamage() then
				dmginfo:SetDamage(dmginfo:GetDamage() * (attacker:HasPerk("danger") and 2 or 1.2))
			end

			if isplayer and attacker:HasUpgrade("death") then
				dmginfo:ScaleDamage(3)
			end

			if isplayer and attacker:HasPerk("sake") and meleetypes[dmginfo:GetDamageType()] then
				dmginfo:SetDamageType(DMG_SHOCK)
				dmginfo:ScaleDamage(2)
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
			if zombie.BossMeleeOnly and isplayer and not meleetypes[dmginfo:GetDamageType()] then return true end

			local wep = dmginfo:GetInflictor()
			if not IsValid(wep) and isplayer then
				wep = attacker:GetActiveWeapon()
			end

			if zombie:IsZombSlowed() then
				dmginfo:ScaleDamage(2)
			end

			if isplayer and IsValid(wep) and hitgroup == HITGROUP_HEAD and (zombie.GetDecapitated and !zombie:GetDecapitated()) then 
				if attacker:HasPerk("death") then
					dmginfo:SetDamage(dmginfo:GetDamage() * (attacker:HasUpgrade("death") and 1.5 or 1.25))
				end
				dmginfo:ScaleDamage(wep.NZHeadShotMultiplier or 2)
			end

			if nzPowerUps:IsPowerupActive("insta") then
				local headbone = zombie:LookupBone("ValveBiped.Bip01_Head1")
				if !headbone then headbone = zombie:LookupBone("j_head") end
				if headbone then
					dmginfo:SetDamagePosition(zombie:GetBonePosition(headbone))
				end

				dmginfo:SetDamage(zombie:Health() + 666)
				nzEnemies:OnEnemyKilled(zombie, attacker, dmginfo, hitgroup)
				return
			end

			if !zombie.NZBossType and isplayer and attacker:HasPerk("sake") and meleetypes[dmginfo:GetDamageType()] then
				dmginfo:SetDamageType(DMG_MISSILEDEFENSE)
				if attacker:HasUpgrade("sake") then
					ParticleEffectAttach("bo3_waffe_electrocute", PATTACH_POINT_FOLLOW, zombie, 2)
					if zombie:OnGround() then
						ParticleEffectAttach("bo3_waffe_ground", PATTACH_ABSORIGIN_FOLLOW, zombie, 0)
					end
					dmginfo:SetDamageType(DMG_SHOCK)
				end
				dmginfo:SetDamage(zombie:Health() + 666) 
				nzEnemies:OnEnemyKilled(zombie, attacker, dmginfo, hitgroup)

				if attacker:HasUpgrade("sake") and math.random(100) <= 45 and attacker:GetNW2Float("nz.SakeDelay", 0) < CurTime() and IsValid(wep) then
					local waff = ents.Create("bo3_ww_wunderwaffe")
					waff:SetModel("models/dav0r/hoverball.mdl")
					waff:SetPos(zombie:WorldSpaceCenter())
					waff:SetAngles(Vector(0,0,-1):Angle())
					waff:SetOwner(attacker)
					waff:SetNoDraw(true)
					waff.Inflictor = wep

					waff.Damage = 115
					waff.mydamage = 115
					waff.MaxChain = math.random(1, 3)
					waff.ZapRange = 300
					waff.ArcDelay = 0.4

					waff:Spawn()

					waff:SetOwner(attacker)
					waff.Inflictor = wep

					waff:SetVelocity(Vector(0,0,-4000))
					local phys = waff:GetPhysicsObject()
					if IsValid(phys) then
						phys:SetVelocity(Vector(0,0,-4000))
					end

					attacker:SetNW2Float("nz.SakeDelay", CurTime() + 7)
				end

				return
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
				if burntypes[dmginfo:GetDamageType()] then
					dmginfo:ScaleDamage(attacker:HasUpgrade("fire") and 4 or 2)
				end
				if attacker:HasUpgrade("fire") and math.random(5) == 1 then
					dmginfo:SetDamageType(DMG_BURN)
					zombie:Ignite(dmginfo:GetDamage()/6)
				end
			end

			if isplayer and dmginfo:IsDamageType(DMG_DIRECT) then
				dmginfo:SetDamage(zombie:Health() + 666) 
				nzEnemies:OnEnemyKilled(zombie, attacker, dmginfo, hitgroup)
				return
			end

			if isplayer and burntypes[dmginfo:GetDamageType()] then
				zombie:Ignite(math.Round(dmginfo:GetDamage()/15))
			end

			if isplayer and dmginfo:IsDamageType(DMG_DROWN) then
				if math.random(12) == 1 then
					zombie:SetPlaybackRate(0)
					zombie:SetMaterial("effects/freeze_overlayeffect01")
					zombie:SetStop(true)
					zombie.loco:SetDesiredSpeed(1)
					zombie:SetBlockAttack(true)
					zombie:EmitSound("weapons/wintershowl/freeze"..math.random(0,2)..".ogg")
					timer.Simple(2, function()
						if IsValid(zombie) and not zombie.MarkedForDeath then
							zombie:EmitSound("weapons/wintershowl/shatter"..math.random(0,1)..".ogg")
					 		zombie:TakeDamage(zombie:Health() + 666, IsValid(attacker) and attacker or zombie, IsValid(wep) and wep or zombie)
					 		if not IsValid(attacker) then
					 			nzRound:SetZombiesKilled(nzRound:GetZombiesKilled() + 1)
					 		end
						end
					end)
				end
			end

			if zombie:Health() > dmginfo:GetDamage() then
				if zombie.HasTakenDamageThisTick then return end

				if isplayer and attacker:GetNotDowned() and !hook.Call("OnZombieShot", nil, zombie, attacker, dmginfo, hitgroup) then
					if attacker:HasPerk("widowswine") and meleetypes[dmginfo:GetDamageType()] and zombie.BO3SpiderWeb then
						zombie:BO3SpiderWeb(10)
					end
					attacker:GivePoints(10)
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

-- Resseting player stats on round start
hook.Add("OnRoundStart", "nz.ResetKillStats", function()
	for _, ply in ipairs(player.GetAll()) do
		if ply:HasPerk("everclear") then
			ply:SetNW2Int("nz.ZombShellDelay", 1)
			ply:SetNW2Int("nz.ZombShellCount", 0)
		end
		if ply:HasPerk("fire") then
			ply:SetNW2Float("nz.BurnDelay", 1)
			ply:SetNW2Int("nz.BurnCount", 0)
		end
		if ply:HasPerk("winters") then
			ply:SetNW2Float("nz.WailDelay", 1)
			ply:SetNW2Int("nz.WailCount", ply:HasUpgrade("winters") and 4 or 3)
		end
		if ply:HasUpgrade("jugg") then
			local armor = ply:Armor()
			local bonus = math.max(200, armor)
			ply:SetArmor(bonus)
		end
	end
end)

-- Custom kill drops and effects
hook.Add("OnZombieKilled", "nzZombieKill", function(ent, dmginfo)
	local ply = dmginfo:GetAttacker()
	if IsValid(ply) and ply:IsPlayer() then
		local wep = dmginfo:GetInflictor()

		if ply:HasPerk("pop") and IsValid(wep) and wep.IsTFAWeapon and not wep.NZSpecialCategory then
			if ply:GetNW2Float("nz.EPopDelay", 0) < CurTime() then
				if math.random(15) < ply:GetNW2Int("nz.EPopChance", 0) then
					ply:SetNW2Float("nz.EPopDelay", CurTime() + (ply:HasUpgrade("pop") and 10 or 30))
					ply:SetNW2Int("nz.EPopChance", 0)

					local eff = wep:SharedRandom(1, (ply:HasUpgrade("pop") and 8 or 7), "Chaos")
					ply:SetNW2Int("nz.EPopEffect", eff)
					ply:SetNW2Float("nz.EPopDecay", CurTime() + 2)

					local aat = ents.Create("elemental_pop_effect_"..eff)
					aat:SetPos(ent:GetPos())
					aat:SetParent(ent)
					aat:SetOwner(ply)
					aat:SetAttacker(dmginfo:GetAttacker())
					aat:SetInflictor(dmginfo:GetInflictor())
					aat:SetAngles(Angle(0,0,0))

					aat:Spawn()
				else
					ply:SetNW2Int("nz.EPopChance", ply:GetNW2Int("nz.EPopChance", 0) + (ply:HasUpgrade("pop") and 2 or 1))
				end
			end
		end

		if ply:HasPerk("everclear") then
			local chance = 15
			local duration = math.random(5, 15)

			if ply:HasUpgrade("everclear") then
				chance = 10
				duration = math.random(10, 20)
			end

			if math.random(chance) == 1 and ply:GetNW2Float("nz.ZombShellDelay",0) < CurTime() then
				local zomb = ents.Create("zombshell_effect")
				zomb:SetPos(ent:WorldSpaceCenter())
				zomb:SetOwner(ply)
				zomb:SetAngles(Angle(0,0,0))
				zomb.Delay = duration

				zomb:Spawn()

				ply:SetNW2Float("nz.ZombShellDelay", CurTime() + (10 * ply:GetNW2Int("nz.ZombShellCount",0)))
				ply:SetNW2Int("nz.ZombShellCount", ply:GetNW2Int("nz.ZombShellCount",0) + 1)
			end
		end

		if ply:HasPerk("widowswine") and ent.BO3IsWebbed and ent:BO3IsWebbed() then
			if math.random(7) == 1 then
				local wido = ents.Create("drop_widows")
				wido:SetPos(ent:WorldSpaceCenter())
				wido:SetOwner(ply)
				wido:SetAngles(ent:GetForward():Angle())

				wido:Spawn()
			end
		end
	end
end)