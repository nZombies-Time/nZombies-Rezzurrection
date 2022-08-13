local meleetypes = {
	[DMG_CLUB] = true,
	[DMG_SLASH] = true,
	[DMG_CRUSH] = true,
	[DMG_GENERIC] = true,
}

function nzEnemies:OnEnemyKilled(enemy, attacker, dmginfo, hitgroup)
	--  Prevent multiple "dyings" by making sure the zombie has not already been "killed"
	if enemy.MarkedForDeath then return end
	if nzRound:InProgress() then
	nzRound:SetZombiesKilled( nzRound:GetZombiesKilled() + 1 )
	end
	if attacker:IsPlayer() then
		--attacker:GivePoints(90)
		attacker:AddFrags(1)
		if attacker:HasPerk("vulture") then
			if math.random(9) == 1 then
				local drop = ents.Create("drop_vulture")
				drop:SetPos(enemy:GetPos() + Vector(0,0,50))
				drop:Spawn()
			end
		end
		
	
		if attacker:HasPerk("everclear") then
		local chance = 14
		local damage = 50
		local duration = 8
		if attacker:HasUpgrade("everclear") then
		chance = 7
		damage = 72
		duration = 11
		end
		if math.random(chance) == 1 then
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
            entParticle:Fire("kill","",duration)
            local vaporizer = ents.Create("point_hurt")
            if !vaporizer:IsValid() then return end
            vaporizer:SetKeyValue("Damage", damage)
            vaporizer:SetKeyValue("DamageRadius", 100)
            vaporizer:SetKeyValue("DamageType",DMG_SLOWBURN)
			vaporizer:SetKeyValue("DamageDelay",0.5)
            vaporizer:SetPos(enemy:GetPos())
            vaporizer:SetOwner(enemy)
            vaporizer:Spawn()
            vaporizer:Fire("TurnOn","",0)
            vaporizer:Fire("kill","",duration)
			end
		end
			if dmginfo:IsDamageType( 131072 ) then
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
		end
		if dmginfo:IsDamageType( 1048576 ) then
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
		end
		

		
		
		
			if dmginfo:IsDamageType( 4096 ) then
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
	end



if attacker:HasPerk("pop") then
			local effect = math.random(16)
			 
			 if  effect == 7 then
			enemy:EmitSound("bo1_overhaul/n6/xplo"..math.random(2)..".mp3")
			ParticleEffect("novagas_xplo",enemy:GetPos(),enemy:GetAngles(),nil)
		local vaporizer = ents.Create("point_hurt")
		if !vaporizer:IsValid() then return end
		vaporizer:SetKeyValue("Damage", 40)
		vaporizer:SetKeyValue("DamageRadius", 100)
		vaporizer:SetKeyValue("DamageDelay", 1)
		vaporizer:SetKeyValue("DamageType",DMG_NERVEGAS)
		vaporizer:SetPos(enemy:GetPos())
		vaporizer:SetOwner(attacker)
		vaporizer:Spawn()
		vaporizer:Fire("TurnOn","",0)
		vaporizer:Fire("kill","",18)
			
			end
			if  effect == 6 then
						enemy:EmitSound("pop_acid.mp3",511)
		local vaporizer = ents.Create("point_hurt")
		   local gfx = ents.Create("pfx2_03")
        gfx:SetPos(enemy:GetPos())
        gfx:SetAngles(enemy:GetAngles())
        gfx:Spawn()
		if !vaporizer:IsValid() then return end
		vaporizer:SetKeyValue("Damage", 40)
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
			
			 if  effect == 5 then
						enemy:EmitSound("pop_antimatter.wav", 94, math.random(90,100))
            local ent = ents.Create("env_explosion")
        ent:SetPos(enemy:GetPos())
        ent:SetAngles(enemy:GetAngles())
        ent:Spawn()
         ent:SetKeyValue("imagnitude", "666")
		ent:SetKeyValue("iradiusoverride", "100")
        ent:Fire("explode")
		  local gfx = ents.Create("pfx8_01")
        gfx:SetPos(enemy:GetPos() + Vector(0,0,20))
        gfx:SetAngles(enemy:GetAngles())
        gfx:Spawn()
		timer.Simple(2, function()
					gfx:Remove()
				end)
			end
			 end
			 
	end

	-- Run on-killed function to give points if the hook isn't blocking it
	--if !hook.Call("OnZombieKilled", nil, enemy, attacker, dmginfo, hitgroup) then
		if enemy:IsValidZombie() then
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if meleetypes[dmginfo:GetDamageType()] then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
				enemy:EmitSound("nz/zombies/death/headshot_"..math.random(0,3)..".wav", 511)
					attacker:GivePoints(100)
					local chance = 7
					local damage = 200
					if attacker:HasUpgrade("deadshot") then
					chance = 4
					damage = 345
					end
					if attacker:HasPerk("deadshot") and math.random(chance) == 1 then
					enemy:EmitSound("bo1_overhaul/n6/xplo"..math.random(2)..".mp3")
					enemy:EmitSound("divider/divider_merge_18.wav", 94, math.random(90,100))
					enemy:EmitSound("divider/divider_merge_18.wav", 94, math.random(90,100))
					ParticleEffect("divider_slash3",enemy:GetPos()+Vector(0,0,50), enemy:GetAngles(), nil )
					local zombies = ents.FindInSphere(enemy:GetPos(), 150)
					for k,v in pairs(zombies) do
					if IsValid(v) and v:IsValidZombie() then
					if v == enemy then
					else
					local d = DamageInfo()
					d:SetDamage(damage )
					d:SetAttacker( attacker )
					d:SetDamageType(DMG_AIRBOAT) 
					v:TakeDamageInfo( d )
					end
					local d = DamageInfo()
					d:SetDamage(500 )
					d:SetAttacker( attacker )
					d:SetDamageType(DMG_PHYSGUN) 
					--v:TakeDamageInfo( d )
					end
				end
					end
				else
					attacker:GivePoints(50)
				end
			end
		end
	--end

	if nzRound:InProgress() then
		

		-- Chance a powerup spawning
		if !nzPowerUps:IsPowerupActive("insta") and IsValid(enemy) then -- Don't spawn powerups during instakill
			if !nzPowerUps:GetPowerUpChance() then nzPowerUps:ResetPowerUpChance() end
			if math.Rand(0, 100) < nzPowerUps:GetPowerUpChance() then
				--if(enemy:GetBarricade(false)) then
				--nzPowerUps:SpawnPowerUp(enemy:GetPos())
				--nzPowerUps:ResetPowerUpChance()
				--elseif enemy:GetPassedBarricade(true) then
				nzPowerUps:SpawnPowerUp(enemy:GetPos())
				nzPowerUps:ResetPowerUpChance()
				--end
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

  if !attacker:IsPlayer() then
        if IsValid(zombie) and zombie:IsValidZombie() and zombie:Health() > 0 then
            if (attacker:GetClass() == "nz_trap_projectiles" or attacker:GetClass() == "nz_trap_turret") then 
                zombie:Kill()
            end
        end
    return end
	
	if !attacker:IsValid() then return end
	if IsValid(zombie) then
		if zombie.NZBossType then
			if zombie.IsInvulnerable and zombie:IsInvulnerable() then return true end -- Bosses can still be invulnerable
			
			if dmginfo:IsDamageType( 134217728 )  then
				dmginfo:ScaleDamage( 1.5 )
			return end
			
			if attacker:IsPlayer() and attacker:HasUpgrade("sake") and (dmginfo:IsDamageType( 128 ) or dmginfo:IsDamageType( 4 )) then
				dmginfo:ScaleDamage(4) 
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
			
			if attacker:IsPlayer() and IsValid(attacker:GetActiveWeapon()) and hitgroup == HITGROUP_HEAD  then 
			local plywpn = attacker:GetActiveWeapon()
			if plywpn.NZHeadShotMultiplier then
			dmginfo:ScaleDamage(plywpn.NZHeadShotMultiplier) 
			else
			dmginfo:ScaleDamage(2) 
			end
			end
		

			if nzPowerUps:IsPowerupActive("insta") then
				dmginfo:ScaleDamage(zombie:Health()) --zombie:Kill(dmginfo)
				nzEnemies:OnEnemyKilled(zombie, attacker, dmginfo, hitgroup)
			return end
			
			if !zombie.NZBossType and attacker:IsPlayer() and attacker:HasPerk("sake") and (dmginfo:IsDamageType( 128 ) or dmginfo:IsDamageType( 4 )) then
				dmginfo:ScaleDamage(zombie:Health()) 
				nzEnemies:OnEnemyKilled(zombie, attacker, dmginfo, hitgroup)
			return end
			
			if attacker:IsPlayer() and attacker:HasPerk("danger") and dmginfo:IsDamageType( 64 ) then
			if attacker:HasUpgrade("danger") then
			dmginfo:ScaleDamage( 4 )
			else
			dmginfo:ScaleDamage( 2 )
			end
			end
			
			if attacker:IsPlayer() and dmginfo:IsDamageType( 262144 ) then
				dmginfo:SetDamage( dmginfo:GetDamage() + zombie:Health()*0.07) 
			 end
			
				
		
		
			 if attacker:IsPlayer() and IsValid(attacker:GetActiveWeapon()) and attacker:GetActiveWeapon():HasNZModifier("pap") then
			 local gun = attacker:GetActiveWeapon():GetClass()
			 local weapon = weapons.Get(gun)
			 if not weapon.NZPaPReplacement then
				dmginfo:ScaleDamage( 2 )
			 end
			 end
			
			
			
			
			if attacker:IsPlayer() and attacker:HasPerk("fire") and (dmginfo:IsDamageType( 2097152 ) or dmginfo:IsDamageType(  8 )) then
				dmginfo:ScaleDamage(2) 
			end
			
			
			if attacker:IsPlayer() and dmginfo:IsDamageType( 268435456 ) then
				dmginfo:ScaleDamage(zombie:Health()) 
				nzEnemies:OnEnemyKilled(zombie, attacker, dmginfo, hitgroup)
			return end
			
			
			if attacker:IsPlayer() and dmginfo:IsDamageType( 2097152 ) then
				zombie:Ignite((dmginfo:GetDamage()/16))
			 end
			
						if attacker:IsPlayer() and  dmginfo:IsDamageType( 16384 ) then
				--winters fury
		if math.random(9) == 6 then
		zombie:SetPlaybackRate( 0 ) -- Slow them down
		zombie:SetMaterial("effects/freeze_overlayeffect01")
		zombie:SetStop(true)
		zombie.loco:SetDesiredSpeed(1)
		zombie:SetBlockAttack(true)
		zombie:EmitSound("weapons/wintershowl/freeze"..math.random(0,2)..".ogg")
				timer.Simple(2, function()
				if zombie:IsValid() then
				zombie:EmitSound("weapons/wintershowl/shatter"..math.random(0,1)..".ogg")
				  zombie:TakeDamage(zombie:Health())
				  nzRound:SetZombiesKilled( nzRound:GetZombiesKilled() + 1 )
				--nzEnemies:OnEnemyKilled(zombie, attacker, dmginfo, hitgroup)
				end
				end)
			
				
				end
		end
		
			if attacker:IsPlayer() and attacker:HasUpgrade("fire")  and math.random(5) == 4  then
				zombie:Ignite((dmginfo:GetDamage()/9))
			 end
			
			if attacker:IsPlayer()  then
			if (attacker:HasPerk("dtap2") or attacker:HasPerk("vigor"))  and dmginfo:GetDamageType() == DMG_BULLET then 
			if (attacker:HasPerk("dtap2") and attacker:HasPerk("vigor")) then
			dmginfo:ScaleDamage(3)
			elseif attacker:HasPerk("dtap2") then
			dmginfo:ScaleDamage(2)
			elseif attacker:HasPerk("vigor") then
			dmginfo:ScaleDamage(3)
			end
			end -- dtap2 bullet damage buff
			end
			
			--  Pack-a-Punch doubles damage...hell no it doesnt
			if dmginfo:GetDamageType() == DMG_CRUSH then
				dmginfo:SetDamage(80)
			end
			
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