local meleetypes = {
	[DMG_CLUB] = true,
	[DMG_SLASH] = true,
	[DMG_CRUSH] = true,
}

function nzEnemies:OnEnemyKilled(enemy, attacker, dmginfo, hitgroup)
	--  Prevent multiple "dyings" by making sure the zombie has not already been "killed"
	if enemy.MarkedForDeath then return end

	if attacker:IsPlayer() then
		--attacker:GivePoints(90)
		attacker:AddFrags(1)
		if attacker:HasPerk("vulture") then
			if math.random(10) == 1 then
				local drop = ents.Create("drop_vulture")
				drop:SetPos(enemy:GetPos() + Vector(0,0,50))
				drop:Spawn()
			end
		end
		if attacker:HasPerk("everclear") then
		if math.random(7) == 1 then
			enemy:EmitSound("bo1_overhaul/nap/explode.mp3",511)
            local ent = ents.Create("env_explosion")
        ent:SetPos(enemy:GetPos())
        ent:SetAngles(enemy:GetAngles())
        ent:Spawn()
        ent:SetKeyValue("imagnitude", "50")
        ent:Fire("explode")
            local entParticle = ents.Create("info_particle_system")
            entParticle:SetKeyValue("start_active", "1")
            entParticle:SetKeyValue("effect_name", "napalm_postdeath_napalm")
            entParticle:SetPos(enemy:GetPos())
            entParticle:SetAngles(enemy:GetAngles())
            entParticle:Spawn()
            entParticle:Activate()
            entParticle:Fire("kill","",9)
            local vaporizer = ents.Create("point_hurt")
            if !vaporizer:IsValid() then return end
            vaporizer:SetKeyValue("Damage", 87)
            vaporizer:SetKeyValue("DamageRadius", 100)
            vaporizer:SetKeyValue("DamageType",DMG_SLOWBURN)
            vaporizer:SetPos(enemy:GetPos())
            vaporizer:SetOwner(enemy)
            vaporizer:Spawn()
            vaporizer:Fire("TurnOn","",0)
            vaporizer:Fire("kill","",8)
			end
		end
	end

	-- Run on-killed function to give points if the hook isn't blocking it
	if !hook.Call("OnZombieKilled", nil, enemy, attacker, dmginfo, hitgroup) then
		if enemy:IsValidZombie() then
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if meleetypes[dmginfo:GetDamageType()] then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	end

	if nzRound:InProgress() then
		nzRound:SetZombiesKilled( nzRound:GetZombiesKilled() + 1 )

		-- Chance a powerup spawning
		if !nzPowerUps:IsPowerupActive("insta") and IsValid(enemy) then -- Don't spawn powerups during instakill
			if !nzPowerUps:GetPowerUpChance() then nzPowerUps:ResetPowerUpChance() end
			if math.Rand(0, 100) < nzPowerUps:GetPowerUpChance() then
				nzPowerUps:SpawnPowerUp(enemy:GetPos())
				nzPowerUps:ResetPowerUpChance()
			else
				nzPowerUps:IncreasePowerUpChance()
			end
		end

		print("Killed Enemy: " .. nzRound:GetZombiesKilled() .. "/" .. nzRound:GetZombiesMax() )
		if nzRound:IsSpecial() and nzRound:GetZombiesKilled() >= nzRound:GetZombiesMax() then
			nzPowerUps:SpawnPowerUp(enemy:GetPos(), "maxammo")
			--reset chance here?
		end
	end
	-- Prevent this function from running on this zombie again
	enemy.MarkedForDeath = true
end

function GM:EntityTakeDamage(zombie, dmginfo)
	if zombie:IsPlayer() and dmginfo:IsDamageType( 2097152 ) then return true end
	-- Who's Who clones can't take damage!
	if zombie:GetClass() == "whoswho_downed_clone" then return true end
	
	if zombie.Alive and zombie:Health() <= 0 then zombie:Kill(dmginfo) end -- No zombie should ever have under 0 health
	
	local attacker = dmginfo:GetAttacker()

	if !attacker:IsValid() then return end
	if IsValid(zombie) then
		if zombie.NZBossType then
			if zombie.IsInvulnerable and zombie:IsInvulnerable() then return true end -- Bosses can still be invulnerable
			
			if dmginfo:IsDamageType( 134217728 )  then
				dmginfo:ScaleDamage( 1.5 )
			return end
			
			local data = nzRound:GetBossData(zombie.NZBossType) -- Just in case it was switched mid-game, use the id stored on zombie
			if data then -- If we got the boss data
				local hitgroup = util.QuickTrace( dmginfo:GetDamagePosition(), dmginfo:GetDamagePosition() ).HitGroup
				if zombie:Health() > dmginfo:GetDamage() then
					if data.onhit then data.onhit(zombie, attacker, dmginfo, hitgroup) end
				elseif !zombie.MarkedForDeath then
					if data.deathfunc then data.deathfunc(zombie, attacker, dmginfo, hitgroup) end
					hook.Call("OnBossKilled", nil, zombie)
					zombie.MarkedForDeath = true
				end
			end
		elseif zombie:IsValidZombie() then
			if zombie.IsInvulnerable and zombie:IsInvulnerable() then return true end
			local hitgroup = util.QuickTrace( dmginfo:GetDamagePosition( ), dmginfo:GetDamagePosition( ) ).HitGroup

			if nzPowerUps:IsPowerupActive("insta") then
				dmginfo:ScaleDamage(zombie:Health()) --zombie:Kill(dmginfo)
				nzEnemies:OnEnemyKilled(zombie, attacker, dmginfo, hitgroup)
			return end
			
			if !zombie.NZBossType and attacker:IsPlayer() and attacker:HasPerk("sake") and (dmginfo:IsDamageType( 128 ) or dmginfo:IsDamageType( 4 )) then
				dmginfo:ScaleDamage(zombie:Health()) --zombie:Kill(dmginfo)
				nzEnemies:OnEnemyKilled(zombie, attacker, dmginfo, hitgroup)
			return end
			
			if attacker:IsPlayer() and attacker:HasPerk("danger") and dmginfo:IsDamageType( 64 ) then
				dmginfo:ScaleDamage( 1.5 )
			return end
			
			if dmginfo:IsDamageType( 2097152 ) then
				zombie:Ignite((dmginfo:GetDamage()/10))
			return end
			
			if attacker:IsPlayer()  and attacker:HasPerk("dtap2")  and dmginfo:GetDamageType() == DMG_BULLET then dmginfo:ScaleDamage(1.5) end -- dtap2 bullet damage buff

			if hitgroup == HITGROUP_HEAD and !dmginfo:IsDamageType( 128 ) and !dmginfo:IsDamageType( 4 ) then dmginfo:ScaleDamage(1.5) end

			--  Pack-a-Punch doubles damage...hell no it doesnt

			if zombie:Health() > dmginfo:GetDamage() then
				if zombie.HasTakenDamageThisTick then return end
				if attacker:IsPlayer() and attacker:GetNotDowned() and !hook.Call("OnZombieShot", nil, zombie, attacker, dmginfo, hitgroup) then
					if dmginfo:GetDamageType() == DMG_CLUB and attacker:HasPerk("widowswine") then
						zombie:ApplyWebFreeze(5)
					end
					attacker:GivePoints(10)
				end
				zombie.HasTakenDamageThisTick = true
				--  Prevent multiple damages in one tick (FA:S 2 Bullet penetration makes them hit 1 zombie 2-3 times per bullet)
				timer.Simple(0, function() if IsValid(zombie) then zombie.HasTakenDamageThisTick = false end end)
			else
				nzEnemies:OnEnemyKilled(zombie, attacker, dmginfo, hitgroup)
			end
		end
	end
end

local function OnRagdollCreated( ent )
	if ( ent:GetClass() == "prop_ragdoll" ) then
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