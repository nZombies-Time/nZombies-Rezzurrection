if SERVER then
	function nzRound:SetNextBossRound( num )
		local round = self:GetNumber()
		if round == -1 then
			local diff = num - round
			if diff > 0 then -- If we're on infinity
				self:SetNextBossRound(round) -- Mark this round again
				self:PrepareBoss(diff * 10) -- Spawn the boss 10 zombies later for each round it was delayed with
			end
		else
			self.NextBossRound = num
		end
	end

	function nzRound:GetNextBossRound()
		return self.NextBossRound
	end
	
	function nzRound:MarkedForBoss( num )
		return self.NextBossRound == num and self.BossType and self.BossData[self.BossType] and true -- Valid boss
	end
	
	function nzRound:SetBossType(id)
		if id == "None" then
			self.BossType = nil -- "None" makes a nil key
		else
			self.BossType = id or "Panzer" -- A nil id defaults to "Panzer", otherwise id
		end
	end

	function nzRound:InitializeBossSpawnChance()
		if !self.BossSpawnChance then self.BossSpawnChance = 0 end
	end

	function nzRound:GetBossSpawnChance()
		return self.BossSpawnChance
	end

	function nzRound:SetBossSpawnsSoFar()
		if !self.BossSpawnsSoFar then self.BossSpawnsSoFar = 0 end
	end

	function nzRound:GetBossSpawnsSoFar()
		return self.BossSpawnsSoFar
	end

	function nzRound:GetBossType(id)
		return self.BossType
	end
	
	function nzRound:GetBossData(id)
		local bosstype = id or self.BossType
		return bosstype and self.BossData[bosstype] or nil
	end
	
	function nzRound:SpawnBoss(id)
		local bosstype = id or self.BossType
		if bosstype then
			local data = nzRound:GetBossData(bosstype)
			local spawnpoint = data.specialspawn and "nz_spawn_zombie_special" or "nz_spawn_zombie_boss" or "nz_spawn_zombie_normal"  -- Check what spawnpoint type we're using
			local spawnpoints = {}
			for k,v in pairs(ents.FindByClass(spawnpoint)) do -- Find and add all valid spawnpoints that are opened and not blocked
				if (v.link == nil or nzDoors:IsLinkOpened( v.link )) and v:IsSuitable() then
					table.insert(spawnpoints, v)
				end
			end

			local spawn = spawnpoints[math.random(#spawnpoints)] -- Pick a random one
			if IsValid(spawn) then -- If we this exists, spawn here
				local boss = ents.Create(data.class)
				boss:SetPos(spawn:GetPos())
				boss:Spawn()
				boss.NZBossType = bosstype
				data.spawnfunc(boss) -- Call this after in case it runs PrepareBoss to enable another boss this round
				return boss
			end
		end
	end
	
	-- This runs at the start of every round
	hook.Add("OnRoundStart", "nzBossRoundHandler", function(round)
		--print("next boss round "..nzRound:GetNextBossRound().."")
		if !nzRound:GetNextBossRound() then return end
		if round == -1 then -- Round infinity always spawn bosses
			local diff = nzRound:GetNextBossRound() - round
			if diff > 0 then
				nzRound:SetNextBossRound(round) -- Mark this round again
				nzRound:PrepareBoss(diff * 10) -- Spawn the boss 10 zombies later for each round it was delayed with
			end
			return
		end
		if nzRound:MarkedForBoss(round) then -- If this round is a boss round
			local data = nzRound:GetBossData()
			if !data then return end
			if nzRound:IsSpecial() then nzRound:SetNextBossRound(round + 1) return end -- If special round, delay 1 more round and back out
			
			--print("boss round")
			local count = #player.GetAllPlaying()
			local bossamount = math.floor(nzRound:GetNumber() * 0.065) + data.perplayer + count - 1

			nzRound:SetNextBossRound(nzRound:GetNumber() + data.intermission)
			nzRound:PrepareBoss(bossamount)
		end
	end)


	--[[
		Moo Mark 5/13/23:
		Completely redid the boss spawning system so it can spawn 
		multiple a round, spawn more per player, and have a cap 
		of how many can be alive at once.
	]]--
	function nzRound:PrepareBoss( bossamount )
		local spawnssofar = 0
		local spawnchance = 0
		--print("start boss spawning")
		--print(bossamount)
		hook.Add("OnZombieSpawned", "nzBossSpawnHandler", function() -- Add a hook for each zombie spawned
			local round = nzRound:GetNumber()
			local data = nzRound:GetBossData()
			--print("zombie spawned")
			if nzRound:GetNextBossRound() - data.intermission == round and spawnssofar < bossamount then
				if math.random(30) < spawnchance then -- 30 being max number of attempts
					--print("success")
    				local bosses = ents.FindByClass(data.class)
    				if #bosses >= data.amountatonce then
    					--print("boss cap")
    					spawnchance = spawnchance + 1 -- Further the chance of a boss spawning next possible chance.
    				else
    					local boss = nzRound:SpawnBoss()
    					--print("boss spawned")

    					spawnssofar = spawnssofar + 1
    					spawnchance = 0 --success, reset counter
    				end
				else
					--print("failed")
    				--failed, increase attempt counter
    				spawnchance = spawnchance + 1
				end
			else
				--print("Amount of Bosses reached or no longer boss round.")
				hook.Remove("OnZombieSpawned", "nzBossSpawnHandler")
				return
			end
		end)
	end

	hook.Add("OnGameBegin", "nzBossInit", function()
		nzRound:SetBossType(nzMapping.Settings.bosstype)
		local data = nzRound:GetBossData()
		if data then
			data.initfunc()
			nzRound:SetNextBossRound(data.initalrnd)
		end
	end)

	hook.Add("OnBossKilled", "nzInfinityBossReengange", function()
		local round = nzRound:GetNumber()
		if round == -1 then
			local diff = nzRound:GetNextBossRound() - round
			print("Diff here is", diff, diff > 0)
			if diff > 0 then -- If a new round for the boss has been set after the first one died
				nzRound:SetNextBossRound(round) -- Mark this round again
				nzRound:PrepareBoss(diff * 10) -- Spawn the boss 10 zombies later for each round it was delayed with
			end
		end
	end)

	hook.Add("OnBossKilled", "nzBossRewards", function(ent)
		local round = nzRound:GetNumber()
		if round == -1 then return end

		for _, ply in pairs(player.GetAll()) do
			ply:GivePoints(150)
		end

		local chance = math.random(20)
		if chance <= 1 then
			nzPowerUps:SpawnPowerUp(ent:GetPos(), "bonfiresale")
		elseif chance <= 5 then
			nzPowerUps:SpawnPowerUp(ent:GetPos(), "maxammo")
		end
	end)
end

nzRound.BossData = nzRound.BossData or {}
function nzRound:AddBossType(id, class, funcs)
	if SERVER then
		if class then
			local data = {}
			-- Which entity to spawn
			data.class = class
			-- Whether to spawn at special spawnpoints

			data.specialspawn = funcs.specialspawn
			-- Base health

			data.health = funcs.health
			-- Health scale multiplier (by round)

			data.scale = funcs.scale
			-- Damage received scale for enemies with a 'helmet'

			data.dmgmul = funcs.dmgmul
			-- Runs on game begin with this boss set, use to set first boss round

			data.amountatonce = funcs.amountatonce
			-- Amount of Bosses that can be alive at once during a Boss Round.

			data.initalrnd = funcs.initalrnd
			-- Initial round the Boss can start to appear on.

			data.intermission = funcs.intermission
			-- The amount of rounds until the next boss round.

			data.perplayer = funcs.perplayer
			-- Adds a boss per player in the game for the round(First player not counted).

			data.initfunc = funcs.initfunc
			-- Run when the boss spawns, arguments are (boss)

			data.spawnfunc = funcs.spawnfunc
			-- Run when the boss dies, arguments are (boss, attacker, dmginfo, hitgroup)

			data.deathfunc = funcs.deathfunc
			-- Whenever the boss is damaged, arguments are (boss, attacker, dmginfo, hitgroup) Called before damage applied (can scale dmginfo)
			
			data.onhit = funcs.onhit
			-- All functions are optional, but death/spawn func is needed to set next boss round! (Unless you got another way)
			nzRound.BossData[id] = data
		else
			nzRound.BossData[id] = nil -- Remove it if no valid class was added
		end
	else
		-- Clients only need it for the dropdown, no need to actually know the data and such
		nzRound.BossData[id] = class
	end
end

--[[nzRound:AddBossType("Margwa", "nz_zombie_boss_margwa", {
	specialspawn = true,
	health = 500,
	scale = 1,
	dmgmul = 1,
	amountatonce = 1,
	initalrnd = 8,
	intermission = 4,
	perplayer = 1,
	initfunc = function()
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(150) -- Give killer 500 points if not downed
		end
	end,
})]]

nzRound:AddBossType("Avogadro", "nz_zombie_boss_avogadro", {
	specialspawn = true,
	health = 1250,
	scale = 1,
	dmgmul = 1,
	amountatonce = 1, 	-- Amount of this enemy that can be alive at once.
	initalrnd = 8, 		-- The inital round this enemy can appear.
	intermission = 4, 	-- The amount of rounds that need to pass in order for the enemy to spawn again.
	perplayer = 1, 		-- The number of this enemy that can spawn depending on player count.
	initfunc = function()
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(150) -- Give killer 500 points if not downed
		end
	end,
})
nzRound:AddBossType("Brenner", "nz_zombie_boss_fireman", {
    specialspawn = true,
    health = 800,
    scale = 500,
    dmgmul = 1,
	amountatonce = 2,
	initalrnd = 8,
	intermission = 4,
	perplayer = 1,
    initfunc = function()
    end,
    spawnfunc = function(self)
		BroadcastLua("surface.PlaySound('nz_moo/zombies/vox/_fireman/zvox_fir_intro_roar.mp3')")

        local data = nzRound:GetBossData(self.NZBossType)
        local count = #player.GetAllPlaying()

        self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
        self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
    end,
    deathfunc = function(self, killer, dmginfo, hitgroup)
        if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
            attacker:GivePoints(150) -- Give killer 500 points if not downed
        end
    end,
})
nzRound:AddBossType("Meuchler", "nz_zombie_boss_assassin", {
	specialspawn = true,
	health = 2000,
	scale = 2000,
	dmgmul = 1,
	amountatonce = 2,
	initalrnd = 8,
	intermission = 4,
	perplayer = 2,
	initfunc = function()
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(150) -- Give killer 500 points if not downed
		end
	end,
})
nzRound:AddBossType("Adolf", "nz_zombie_boss_hillturr", {
    specialspawn = true,
    health = 25000,
    scale = 1,
    dmgmul = 1,
	amountatonce = 1,
	initalrnd = 2,
	intermission = 1,
	perplayer = 1,
    initfunc = function()
    end,
    spawnfunc = function(self)
        local data = nzRound:GetBossData(self.NZBossType)
        local count = #player.GetAllPlaying()

        self:SetHealth(data.scale + (data.health * count))
        self:SetMaxHealth(data.scale + (data.health * count))
    end,
    deathfunc = function(self, killer, dmginfo, hitgroup)
        if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
            attacker:GivePoints(150) -- Give killer 500 points if not downed
        end
    end,
})
nzRound:AddBossType("Panzer", "nz_zombie_boss_panzer", {
    specialspawn = true,
    health = 700,
    scale = 400,
    dmgmul = 0.75,
	amountatonce = 2,
	initalrnd = 8,
	intermission = 4,
	perplayer = 1,
    initfunc = function()
    end,
    spawnfunc = function(self)
		--BroadcastLua("surface.PlaySound('nz/panzer/mech_alarm.wav')")
		
        local data = nzRound:GetBossData(self.NZBossType)
        local count = #player.GetAllPlaying()

        self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
        self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
    end,
    deathfunc = function(self, killer, dmginfo, hitgroup)
        if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
            attacker:GivePoints(150) -- Give killer 500 points if not downed
        end
    end,
})
nzRound:AddBossType("Panzer (Der Eisendrache)", "nz_zombie_boss_panzer_bo3", {
    specialspawn = true,
    health = 700,
    scale = 500,
    dmgmul = 0.75,
	amountatonce = 2,
	initalrnd = 8,
	intermission = 4,
	perplayer = 1,
    initfunc = function()
    end,
    spawnfunc = function(self)
		BroadcastLua("surface.PlaySound('enemies/bosses/newpanzer/incoming_alarm_new.ogg')")
		
        local data = nzRound:GetBossData(self.NZBossType)
        local count = #player.GetAllPlaying()

        self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
        self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
    end,
    deathfunc = function(self, killer, dmginfo, hitgroup)
        if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
            attacker:GivePoints(150) -- Give killer 500 points if not downed
        end
    end,
})
nzRound:AddBossType("Cosmonaut(Round 7-8)", "nz_zombie_boss_astro", {
	specialspawn = true,
	health = 25000,
	scale = 1,
	dmgmul = 1,
	amountatonce = 1,
	initalrnd = 8,
	intermission = 1,
	perplayer = 1,
	initfunc = function()
	end,
	spawnfunc = function(self)
		BroadcastLua("surface.PlaySound('nz_moo/zombies/vox/_astro/spawn_flux.mp3')")

		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(150) -- Give killer 500 points if not downed
		end
	end,
})
nzRound:AddBossType("Cosmonaut (Round 2)", "nz_zombie_boss_astro", {
	specialspawn = true,
	health = 25000,
	scale = 1,
	dmgmul = 1,
	amountatonce = 1,
	initalrnd = 2,
	intermission = 1,
	perplayer = 1,
	initfunc = function()
	end,
	spawnfunc = function(self)
		BroadcastLua("surface.PlaySound('nz_moo/zombies/vox/_astro/spawn_flux.mp3')")

		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(150) -- Give killer 500 points if not downed
		end
	end,
})
nzRound:AddBossType("Brutus", "nz_zombie_boss_brutus", {
	specialspawn = true,
	health = 500,
	scale = 250,
	dmgmul = 0.75,
	amountatonce = 4,
	initalrnd = 8,
	intermission = 4,
	perplayer = 1,
	initfunc = function()
	end,
	spawnfunc = function(self)
		BroadcastLua("surface.PlaySound('nz_moo/zombies/vox/_cellbreaker/spawn_2d.mp3')")

		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(150) -- Give killer 500 points if not downed
		end
	end,
})
nzRound:AddBossType("Napalm Zombie", "nz_zombie_boss_Napalm", {
	specialspawn = true,
	health = 250,
	scale = 250,
	dmgmul = 1,
	amountatonce = 3,
	initalrnd = 8,
	intermission = 1,
	perplayer = 2,
	initfunc = function()
	end,
	spawnfunc = function(self)
		BroadcastLua("surface.PlaySound('nz_moo/zombies/vox/_napalm/spawn/evt/evt_napalm_zombie_spawn_00.mp3')")

		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(150) -- Give killer 500 points if not downed
		end
	end,
})
nzRound:AddBossType("Shrieker Zombie", "nz_zombie_boss_shrieker", {
	specialspawn = true,
	health = 250,
	scale = 250,
	dmgmul = 1,
	amountatonce = 3,
	initalrnd = 8,
	intermission = 1,
	perplayer = 2,
	initfunc = function()
	end,
	spawnfunc = function(self)
		BroadcastLua("surface.PlaySound('nz_moo/zombies/vox/_sonic/spawn/evt_sonic_spawn_00.mp3')")
		
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(150) -- Give killer 500 points if not downed
		end
	end,
})
nzRound:AddBossType("Thrasher", "nz_zombie_boss_thrasher", {
	specialspawn = true,
	health = 3500,
	scale = 900,
	dmgmul = 1,
	amountatonce = 2,
	initalrnd = 8,
	intermission = 4,
	perplayer = 1,
	initfunc = function()
		--nzRound:SetNextBossRound(8) -- Randomly spawn in rounds 6-8
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(150) -- Give killer 500 points if not downed
		end
	end,
})
nzRound:AddBossType("Larry the Lobster", "nz_zombie_boss_larry", {
	specialspawn = true,
	health = 3500,
	scale = 900,
	dmgmul = 1,
	amountatonce = 2,
	initalrnd = 8,
	intermission = 4,
	perplayer = 1,
	initfunc = function()
		--nzRound:SetNextBossRound(8) -- Randomly spawn in rounds 6-8
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(150) -- Give killer 500 points if not downed
		end
	end,
})

nzRound:AddBossType("Pickpocket Gecko", "nz_zombie_boss_gex", {
	specialspawn = true,
	health = 1000,
	scale = 1000,
	dmgmul = 1,
	amountatonce = 1,
	initalrnd = 11,
	intermission = 5,
	perplayer = 1,
	initfunc = function()
		--nzRound:SetNextBossRound(8) -- Randomly spawn in rounds 6-8
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(150) -- Give killer 500 points if not downed
		end
	end,
})

nzRound:AddBossType("Ubermorph", "nz_zombie_boss_ubermorph", {
	specialspawn = true,
	health = 3000,
	scale = 2000,
	dmgmul = 0.8,
	amountatonce = 2, 	-- Amount of this enemy that can be alive at once.
	initalrnd = 7, 		-- The inital round this enemy can appear.
	intermission = 2, 	-- The amount of rounds that need to pass in order for the enemy to spawn again.
	perplayer = 1, 		-- The number of this enemy that can spawn depending on player count.
	initfunc = function()
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(150) -- Give killer 500 points if not downed
		end
	end,
})

nzRound:AddBossType("Panzermorder", "nz_zombie_boss_panzermorder", {
	specialspawn = true,
	health = 4000,
	scale = 2500,
	dmgmul = 1,
	amountatonce = 1, 	-- Amount of this enemy that can be alive at once.
	initalrnd = 12, 		-- The inital round this enemy can appear.
	intermission = 6, 	-- The amount of rounds that need to pass in order for the enemy to spawn again.
	perplayer = 1, 		-- The number of this enemy that can spawn depending on player count.
	initfunc = function()
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(150) -- Give killer 500 points if not downed
		end
	end,
})

nzRound:AddBossType("Dilophosaurus", "nz_zombie_boss_dilophosaurus", {
	specialspawn = true,
	health = 1500,
	scale = 600,
	dmgmul = 1,
	amountatonce = 3, 	-- Amount of this enemy that can be alive at once.
	initalrnd = 6, 		-- The inital round this enemy can appear.
	intermission = 3, 	-- The amount of rounds that need to pass in order for the enemy to spawn again.
	perplayer = 1, 		-- The number of this enemy that can spawn depending on player count.
	initfunc = function()
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(150) -- Give killer 500 points if not downed
		end
	end,
})

nzRound:AddBossType("Brute (Dead Space)", "nz_zombie_boss_brute", {
	specialspawn = true,
	health = 3000,
	scale = 1000,
	dmgmul = 0.5,
	amountatonce = 2, 	-- Amount of this enemy that can be alive at once.
	initalrnd = 8, 		-- The inital round this enemy can appear.
	intermission = 5, 	-- The amount of rounds that need to pass in order for the enemy to spawn again.
	perplayer = 1, 		-- The number of this enemy that can spawn depending on player count.
	initfunc = function()
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(150) -- Give killer 500 points if not downed
		end
	end,
})

nzRound:AddBossType("Swamp Warden", "nz_zombie_boss_shrek", {
	specialspawn = true,
	health = 500,
	scale = 1000,
	dmgmul = 0.75,
	amountatonce = 1, 	-- Amount of this enemy that can be alive at once.
	initalrnd = 9, 		-- The inital round this enemy can appear.
	intermission = 3, 	-- The amount of rounds that need to pass in order for the enemy to spawn again.
	perplayer = 1, 		-- The number of this enemy that can spawn depending on player count.
	initfunc = function()
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(150) -- Give killer 500 points if not downed
		end
	end,
})

nzRound:AddBossType("Divider (Dead Space)", "nz_zombie_boss_Divider", {
	specialspawn = true,
	health = 4000,
	scale = 250,
	dmgmul = 1,
	amountatonce = 3, 	-- Amount of this enemy that can be alive at once.
	initalrnd = 11, 		-- The inital round this enemy can appear.
	intermission = 3, 	-- The amount of rounds that need to pass in order for the enemy to spawn again.
	perplayer = 1, 		-- The number of this enemy that can spawn depending on player count.
	initfunc = function()
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(150) -- Give killer 500 points if not downed
		end
	end,
})


nzRound:AddBossType("William Birkin", "nz_zombie_boss_G1", {
	specialspawn = true,
	health = 2000,
	scale = 510,
	dmgmul = 1,
	amountatonce = 1, 	-- Amount of this enemy that can be alive at once.
	initalrnd = 8, 		-- The inital round this enemy can appear.
	intermission = 6, 	-- The amount of rounds that need to pass in order for the enemy to spawn again.
	perplayer = 1, 		-- The number of this enemy that can spawn depending on player count.
	initfunc = function()
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(150) -- Give killer 500 points if not downed
		end
	end,
})


nzRound:AddBossType("William Birkin (2nd Form)", "nz_zombie_boss_G2", {
	specialspawn = true,
	health = 3500,
	scale = 700,
	dmgmul = 0.9,
	amountatonce = 1, 	-- Amount of this enemy that can be alive at once.
	initalrnd = 10, 		-- The inital round this enemy can appear.
	intermission = 6, 	-- The amount of rounds that need to pass in order for the enemy to spawn again.
	perplayer = 1, 		-- The number of this enemy that can spawn depending on player count.
	initfunc = function()
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(150) -- Give killer 500 points if not downed
		end
	end,
})


nzRound:AddBossType("William Birkin (Final Form)", "nz_zombie_boss_G3", {
	specialspawn = true,
	health = 4000,
	scale = 1500,
	dmgmul = 0.75,
	amountatonce = 1, 	-- Amount of this enemy that can be alive at once.
	initalrnd = 14, 		-- The inital round this enemy can appear.
	intermission = 6, 	-- The amount of rounds that need to pass in order for the enemy to spawn again.
	perplayer = 1, 		-- The number of this enemy that can spawn depending on player count.
	initfunc = function()
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(150) -- Give killer 500 points if not downed
		end
	end,
})

nzRound:AddBossType("The Mangler", "nz_zombie_boss_mangler", {
	specialspawn = true,
	health = 800,
	scale = 600,
	dmgmul = 0.8,
	amountatonce = 3, 	-- Amount of this enemy that can be alive at once.
	initalrnd = 7, 		-- The inital round this enemy can appear.
	intermission = 3, 	-- The amount of rounds that need to pass in order for the enemy to spawn again.
	perplayer = 2, 		-- The number of this enemy that can spawn depending on player count.
	initfunc = function()
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(150) -- Give killer 500 points if not downed
		end
	end,
})

nzRound:AddBossType("Fuel Junkie", "nz_zombie_boss_spicy", {
	specialspawn = true,
	health = 700,
	scale = 500,
	dmgmul = 1,
	amountatonce = 3, 	-- Amount of this enemy that can be alive at once.
	initalrnd = 8, 		-- The inital round this enemy can appear.
	intermission = 2, 	-- The amount of rounds that need to pass in order for the enemy to spawn again.
	perplayer = 2, 		-- The number of this enemy that can spawn depending on player count.
	initfunc = function()
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(150) -- Give killer 500 points if not downed
		end
	end,
})

nzRound:AddBossType("The Margwa", "nz_zombie_boss_margwa", {
	specialspawn = true,
	health = 2000,
	scale = 1000,
	dmgmul = 0.25,
	amountatonce = 2, 	-- Amount of this enemy that can be alive at once.
	initalrnd = 8, 		-- The inital round this enemy can appear.
	intermission = 4, 	-- The amount of rounds that need to pass in order for the enemy to spawn again.
	perplayer = 1, 		-- The number of this enemy that can spawn depending on player count.
	initfunc = function()
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(150) -- Give killer 500 points if not downed
		end
	end,
})

nzRound:AddBossType("Nemesis", "nz_zombie_boss_Nemesis", {
	specialspawn = true,
	health = 4000,
	scale = 2000,
	dmgmul = 0.75,
	amountatonce = 1, 	-- Amount of this enemy that can be alive at once.
	initalrnd = 12, 		-- The inital round this enemy can appear.
	intermission = 6, 	-- The amount of rounds that need to pass in order for the enemy to spawn again.
	perplayer = 1, 		-- The number of this enemy that can spawn depending on player count.
	initfunc = function()
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(150) -- Give killer 500 points if not downed
		end
	end,
})

nzRound:AddBossType("George Romero", "nz_zombie_boss_romero", {
	specialspawn = true,
	health = 15625,
	scale = 1,
	dmgmul = 1,
	amountatonce = 1, 	-- Amount of this enemy that can be alive at once.
	initalrnd = 2, 		-- The inital round this enemy can appear.
	intermission = 5, 	-- The amount of rounds that need to pass in order for the enemy to spawn again.
	perplayer = 1, 		-- The number of this enemy that can spawn depending on player count.
	initfunc = function()
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(150) -- Give killer 500 points if not downed
		end
	end,
})

nzRound:AddBossType("George Romero (Round 1)", "nz_zombie_boss_romero", {
	specialspawn = true,
	health = 15625,
	scale = 1,
	dmgmul = 1,
	amountatonce = 1, 	-- Amount of this enemy that can be alive at once.
	initalrnd = 1, 		-- The inital round this enemy can appear.
	intermission = 5, 	-- The amount of rounds that need to pass in order for the enemy to spawn again.
	perplayer = 1, 		-- The number of this enemy that can spawn depending on player count.
	initfunc = function()
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(150) -- Give killer 500 points if not downed
		end
	end,
})

nzRound:AddBossType("Licker (Boss)", "nz_zombie_special_licker", {
	specialspawn = true,
	health = 600,
	scale = 500,
	dmgmul = 1,
	amountatonce = 5, 	-- Amount of this enemy that can be alive at once.
	initalrnd = 7, 		-- The inital round this enemy can appear.
	intermission = 3, 	-- The amount of rounds that need to pass in order for the enemy to spawn again.
	perplayer = 2, 		-- The number of this enemy that can spawn depending on player count.
	initfunc = function()
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(150) -- Give killer 500 points if not downed
		end
	end,
})

nzRound:AddBossType("Hunter (Boss)", "nz_zombie_special_hunterbeta", {
	specialspawn = true,
	health = 800,
	scale = 550,
	dmgmul = 0.85,
	amountatonce = 4, 	-- Amount of this enemy that can be alive at once.
	initalrnd = 8, 		-- The inital round this enemy can appear.
	intermission = 4, 	-- The amount of rounds that need to pass in order for the enemy to spawn again.
	perplayer = 1, 		-- The number of this enemy that can spawn depending on player count.
	initfunc = function()
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(150) -- Give killer 500 points if not downed
		end
	end,
})

nzRound:AddBossType("Sentinel Bot (Boss)", "nz_zombie_special_bot", {
	specialspawn = true,
	health = 600,
	scale = 700,
	dmgmul = 0.6,
	amountatonce = 5, 	-- Amount of this enemy that can be alive at once.
	initalrnd = 7, 		-- The inital round this enemy can appear.
	intermission = 4, 	-- The amount of rounds that need to pass in order for the enemy to spawn again.
	perplayer = 1, 		-- The number of this enemy that can spawn depending on player count.
	initfunc = function()
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(150) -- Give killer 500 points if not downed
		end
	end,
})

nzRound:AddBossType("Raptor (Boss)", "nz_zombie_special_raptor", {
	specialspawn = true,
	health = 720,
	scale = 720,
	dmgmul = 1,
	amountatonce = 8, 	-- Amount of this enemy that can be alive at once.
	initalrnd = 6, 		-- The inital round this enemy can appear.
	intermission = 2, 	-- The amount of rounds that need to pass in order for the enemy to spawn again.
	perplayer = 1, 		-- The number of this enemy that can spawn depending on player count.
	initfunc = function()
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(150) -- Give killer 500 points if not downed
		end
	end,
})