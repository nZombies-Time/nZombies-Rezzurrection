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

	-- Who's Who clones can't take damage!
	if zombie:GetClass() == "whoswho_downed_clone" then return true end
	
	-- Fix zombie invincibility
	if (zombie:IsValidZombie()) then
		if zombie.Alive and zombie:Alive() and zombie:Health() <= 0 then zombie:Kill(dmginfo) end -- No zombie should ever have under 0 health
	end
	
	local attacker = dmginfo:GetAttacker()
	if !attacker:IsPlayer() then return end
	if IsValid(zombie) then
		if zombie.NZBossType then
			if zombie.IsInvulnerable and zombie:IsInvulnerable() then return true end -- Bosses can still be invulnerable
			
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
				zombie:Kill(dmginfo)
				nzEnemies:OnEnemyKilled(zombie, attacker, dmginfo, hitgroup)
			return end


			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(2) end

			--  Pack-a-Punch doubles damage
			if dmginfo:GetAttacker():GetActiveWeapon():HasNZModifier("pap") then dmginfo:ScaleDamage(2) end

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

-- Allow/disallow players to go through zombies (Set by the zombie collision option in the menu)
hook.Add("ShouldCollide", "NZSetCollisionGroupZombie", function(ent1, ent2)
	if (nzMapping and nzMapping.Settings and !nzMapping.Settings.zombiecollisions) then   
        if ent1.Type == "nextbot" && ent2.Type != "nextbot" then
            if ent2.Type == "nextbot" then
                ent1:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
				ent2:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
            return end

            if ent2:GetClass() == "breakable_entry" && ent1.Type == "nextbot" then
                ent1:SetCollisionGroup(COLLISION_GROUP_PLAYER)

                if ent1.fixingCol then return end 
                ent1.fixingCol = true
                timer.Simple(2, function() -- Let players pass through again
                    if !IsValid(ent1) then return end
                    ent1.fixingCol = false
                    ent1:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
                end)
            end

            if !ent1.fixingCol then -- It shouldn't have collisions still yet it does..
                ent1:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
            end
        end

        if ent2.Type == "nextbot" && ent1.Type != "nextbot" then
            if ent1:GetClass() == "breakable_entry" && ent2.Type == "nextbot" then
                ent2:SetCollisionGroup(COLLISION_GROUP_PLAYER)

                if ent2.fixingCol then return end 
                ent2.fixingCol = true       
                timer.Simple(2, function() -- Let players pass through again
                    if !IsValid(ent2) then return end
                    ent2.fixingCol = false
                    ent2:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
                end)
            end

            if !ent2.fixingCol then -- It shouldn't have collisions still yet it does..
                ent2:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
            end
        end
    end
end)

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

-- Reset max spawned zombies allowed on end of game
hook.Add("OnRoundEnd", "NZResetSpawnedZombies", function()
	if nzMapping.Settings.startingspawns then
		NZZombiesMaxAllowed = nzMapping.Settings.startingspawns
	else
		NZZombiesMaxAllowed = 35
	end
end)

local function GetBosses()
	local bosses = {}

	for k,v in pairs(nzRound.BossData) do
		local class = v["class"]

		if class != nil and type(class) == "string" then
			table.insert(bosses, class)
		end
	end

	return bosses
end

-- Allow bosses to pass through zombie walls
hook.Add("ShouldCollide", "AllowBossesThroughZombieStuff", function(ent1, ent2)
	if (SERVER) then
		if (ent1:IsValid() and ent2:IsValid()) then
			if (ent1:GetClass() == "invis_wall_zombie" then
				if (table.HasValue(GetBosses(), ent2:GetClass())) then
					return false
				end
			end
			
			if (ent2:GetClass() == "invis_wall_zombie" then
				if (table.HasValue(GetBosses(), ent1:GetClass())) then
					return false
				end
			end
		end
	end
end)