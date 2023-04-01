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
	local comedyday = os.date("%d-%m") == "01-04"
		if id == "None" then
			self.BossType = nil -- "None" makes a nil key
		else
			if comedyday then
			self.BossType = "Larry the Lobster"
			else
			self.BossType = id or "Panzer" -- A nil id defaults to "Panzer", otherwise id
			end
		end
	end
	
	function nzRound:GetBossType(id)
		local comedyday = os.date("%d-%m") == "01-04"
		if comedyday then
		self.BossType = "Larry the Lobster"
		return self.BossType
		else
		return self.BossType
		end
	end
	
	function nzRound:GetBossData(id)
		local bosstype = id or self.BossType
		return bosstype and self.BossData[bosstype] or nil
	end
	
	function nzRound:SpawnBoss(id)
		local bosstype = id or self.BossType
		if bosstype then
			local data = nzRound:GetBossData(bosstype)
			local spawnpoint = data.specialspawn and "nz_spawn_zombie_special" or "nz_spawn_zombie_normal" or "nz_spawn_zombie_boss"  -- Check what spawnpoint type we're using
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
			if nzRound:IsSpecial() then nzRound:SetNextBossRound(round + 1) return end -- If special round, delay 1 more round and back out
			
			local spawntime = math.random(1, nzRound:GetZombiesMax() - 2) -- Set a random time to spawn
			nzRound:PrepareBoss( spawntime )
		end
	end)
	
	-- This function spawns a boss in after this many zombies has spawned
	-- If called multiple times, the latter will overwrite the prior (because of hook names)
	function nzRound:PrepareBoss( spawntime )
		local spawncount = 0
		hook.Add("OnZombieSpawned", "nzBossSpawnHandler", function() -- Add a hook for each zombie spawned
			if !nzRound:MarkedForBoss(nzRound:GetNumber()) then
				hook.Remove("OnZombieSpawned", "nzBossSpawnHandler") -- Cancel if we're no longer on a boss round!
			return end
			
			spawncount = spawncount + 1 -- Add 1 more zombie spawned since we started tracking
			
			--print("BOSS: "..spawncount.."/"..spawntime)
			
			if spawncount >= spawntime then -- If we've spawned the amount of zombies that we randomly set
				local data = nzRound:GetBossData() -- Check if we got boss data
				if !data then hook.Remove("OnZombieSpawned", "nzBossSpawnHandler") return end -- If not, remove and cancel
				
				local boss = nzRound:SpawnBoss()
				if IsValid(boss) then 
					hook.Remove("OnZombieSpawned", "nzBossSpawnHandler") -- Only remove the hook when we spawned the boss
				end
				-- If there is no valid spawnpoint to spawn at, it will try again next zombie that spawns
				-- until we get out of the boss round, then it gives up
			end
		end)
	end

	hook.Add("OnGameBegin", "nzBossInit", function()
		nzRound:SetBossType(nzMapping.Settings.bosstype)
		local data = nzRound:GetBossData()
		if data then
			data.initfunc()
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
			ply:GivePoints(1000)
		end

		local chance = math.random(10)
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

nzRound:AddBossType("Panzer", "nz_zombie_boss_panzer", {
	specialspawn = true,
	health = 1000,
	scale = 750,
	dmgmul = 0.1,
	initfunc = function()
		nzRound:SetNextBossRound(math.random(6,8)) -- Randomly spawn in rounds 6-8
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		nzRound:SetNextBossRound(nzRound:GetNumber() + math.random(3,5)) -- Delay further boss spawning by 3-5 rounds after its death
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(500) -- Give killer 500 points if not downed
		end
	end,
}) -- No onhit function, we don't give points on hit for this guy

nzRound:AddBossType("Panzer (Der Eisendrache)", "nz_zombie_boss_panzer_bo3", {
	specialspawn = true,
	health = 850,
	scale = 600,
	dmgmul = 0.1,
	initfunc = function()
		nzRound:SetNextBossRound(math.random(6,8)) -- Randomly spawn in rounds 6-8
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		nzRound:SetNextBossRound(nzRound:GetNumber() + math.random(3,5)) -- Delay further boss spawning by 3-5 rounds after its death
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(500) -- Give killer 500 points if not downed
		end
	end,
})

nzRound:AddBossType("Hitler", "nz_zombie_boss_hillturr", {
	specialspawn = true,
	health = 1500,
	scale = 800,
	dmgmul = 0.1,
	initfunc = function()
		nzRound:SetNextBossRound(math.random(8,9)) -- Randomly spawn in rounds 6-8
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		nzRound:SetNextBossRound(nzRound:GetNumber() + math.random(3,5)) -- Delay further boss spawning by 3-5 rounds after its death
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(500) -- Give killer 500 points if not downed
		end
	end,
})

nzRound:AddBossType("Pickpocket Gecko", "nz_zombie_boss_gex", {
	specialspawn = true,
	health = 700,
	scale = 1000,
	dmgmul = 0.1,
	initfunc = function()
		nzRound:SetNextBossRound(math.random(14,16)) -- Randomly spawn in rounds 6-8
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		nzRound:SetNextBossRound(nzRound:GetNumber() + math.random(3,5)) -- Delay further boss spawning by 3-5 rounds after its death
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(500) -- Give killer 500 points if not downed
		end
	end,
})

nzRound:AddBossType("Panzermorder", "nz_zombie_boss_panzermorder", {
	specialspawn = true,
	health = 3500,
	scale = 1500,
	dmgmul = 1,
	initfunc = function()
		nzRound:SetNextBossRound(math.random(11,13)) -- Randomly spawn in rounds 6-8
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		nzRound:SetNextBossRound(nzRound:GetNumber() + math.random(5,7)) -- Delay further boss spawning by 3-5 rounds after its death
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(500) -- Give killer 500 points if not downed
		end
	end,
}) -- No onhit function, we don't give points on hit for this guy

nzRound:AddBossType("Ubermorph", "nz_zombie_boss_ubermorph", {
	specialspawn = true,
	health = 3000,
	scale = 2000,
	dmgmul = 1,
	initfunc = function()
		nzRound:SetNextBossRound(math.random(6,9)) -- Randomly spawn in rounds 6-8
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		nzRound:SetNextBossRound(nzRound:GetNumber() + math.random(5,7)) -- Delay further boss spawning by 3-5 rounds after its death
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(500) -- Give killer 500 points if not downed
		end
	end,
}) -- No onhit function, we don't give points on hit for this guy

nzRound:AddBossType("Cosmonaut(Round 7-8)", "nz_zombie_boss_astro", {
	specialspawn = true,
	health = 4000,
	scale = 2000,
	dmgmul = 1,
	initfunc = function()
		nzRound:SetNextBossRound(math.random(6,8)) -- Randomly spawn in rounds 6-8
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		nzRound:SetNextBossRound(nzRound:GetNumber() + math.random(1,2)) -- Delay further boss spawning by 3-5 rounds after its death
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(500) -- Give killer 500 points if not downed
		end
	end,
}) -- No onhit function, we don't give points on hit for this guy

nzRound:AddBossType("Dilophosaurus", "nz_zombie_boss_dilophosaurus", {
	specialspawn = true,
	health = 1750,
	scale = 1150,
	dmgmul = 1,
	initfunc = function()
		nzRound:SetNextBossRound(math.random(7,9)) -- Randomly spawn in rounds 6-8
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		nzRound:SetNextBossRound(nzRound:GetNumber() + math.random(3,5)) -- Delay further boss spawning by 3-5 rounds after its death
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(500) -- Give killer 500 points if not downed
		end
	end,
}) -- No onhit function, we don't give points on hit for this guy

nzRound:AddBossType("Brute (Dead Space)", "nz_zombie_boss_brute", {
	specialspawn = true,
	health = 1000,
	scale = 1300,
	dmgmul = 1,
	initfunc = function()
		nzRound:SetNextBossRound(math.random(6,7)) -- Randomly spawn in rounds 6-8
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		nzRound:SetNextBossRound(nzRound:GetNumber() + math.random(2,3)) -- Delay further boss spawning by 3-5 rounds after its death
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(500) -- Give killer 500 points if not downed
		end
	end,
}) -- No onhit function, we don't give points on hit for this guy

nzRound:AddBossType("Brutus", "nz_zombie_boss_brutus", {
	specialspawn = true,
	health = 500,
	scale = 850,
	dmgmul = 0.5,
	initfunc = function()
		nzRound:SetNextBossRound(math.random(6,9)) -- Randomly spawn in rounds 6-8
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		nzRound:SetNextBossRound(nzRound:GetNumber() + math.random(3,5)) -- Delay further boss spawning by 3-5 rounds after its death
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(500) -- Give killer 500 points if not downed
		end
	end,
}) -- No onhit function, we don't give points on hit for this guy

nzRound:AddBossType("Avogadro", "nz_zombie_boss_avogadro", {
	specialspawn = true,
	health = 375,
	scale = 1000,
	dmgmul = 0.75,
	initfunc = function()
		nzRound:SetNextBossRound(math.random(6,8)) -- Randomly spawn in rounds 6-8
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		nzRound:SetNextBossRound(nzRound:GetNumber() + math.random(3,5)) -- Delay further boss spawning by 3-5 rounds after its death
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(500) -- Give killer 500 points if not downed
		end
	end,
}) -- No onhit function, we don't give points on hit for this guy

nzRound:AddBossType("Swamp Warden", "nz_zombie_boss_shrek", {
	specialspawn = true,
	health = 500,
	scale = 850,
	dmgmul = 0.5,
	initfunc = function()
		nzRound:SetNextBossRound(math.random(6,9)) -- Randomly spawn in rounds 6-8
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		nzRound:SetNextBossRound(nzRound:GetNumber() + math.random(3,5)) -- Delay further boss spawning by 3-5 rounds after its death
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(500) -- Give killer 500 points if not downed
		end
	end,
}) -- No onhit function, we don't give points on hit for this guy

nzRound:AddBossType("Divider (Dead Space)", "nz_zombie_boss_Divider", {
	specialspawn = true,
	health = 4000,
	scale = 300,
	dmgmul = 1,
	initfunc = function()
		nzRound:SetNextBossRound(math.random(4,6)) -- Randomly spawn in rounds 6-8
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		nzRound:SetNextBossRound(nzRound:GetNumber() + math.random(3,5)) -- Delay further boss spawning by 3-5 rounds after its death
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(500) -- Give killer 500 points if not downed
		end
	end,
}) -- No onhit function, we don't give points on hit for this guy

nzRound:AddBossType("William Birkin", "nz_zombie_boss_G1", {
	specialspawn = true,
	health = 2200,
	scale = 480,
	dmgmul = 1,
	initfunc = function()
		nzRound:SetNextBossRound(math.random(11,13)) -- Randomly spawn in rounds 6-8
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		nzRound:SetNextBossRound(nzRound:GetNumber() + math.random(7,8)) -- Delay further boss spawning by 3-5 rounds after its death
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(500) -- Give killer 500 points if not downed
		end
	end,
}) -- No onhit function, we don't give points on hit for this guy

nzRound:AddBossType("The Mangler", "nz_zombie_boss_mangler", {
	specialspawn = true,
	health = 800,
	scale = 650,
	dmgmul = 0.5,
	initfunc = function()
		nzRound:SetNextBossRound(math.random(7,9)) -- Randomly spawn in rounds 6-8
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		nzRound:SetNextBossRound(nzRound:GetNumber() + math.random(3,5)) -- Delay further boss spawning by 3-5 rounds after its death
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(500) -- Give killer 500 points if not downed
		end
	end,
}) -- No onhit function, we don't give points on hit for this guy

nzRound:AddBossType("Fuel Junkie", "nz_zombie_boss_spicy", {
	specialspawn = true,
	health = 750,
	scale = 600,
	dmgmul = 1,
	initfunc = function()
		nzRound:SetNextBossRound(math.random(7,9)) -- Randomly spawn in rounds 6-8
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		nzRound:SetNextBossRound(nzRound:GetNumber() + math.random(2,4)) -- Delay further boss spawning by 3-5 rounds after its death
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(500) -- Give killer 500 points if not downed
		end
	end,
})

nzRound:AddBossType("The Margwa", "nz_zombie_boss_margwa", {
	specialspawn = true,
	health = 2000,
	scale = 1000,
	dmgmul = 0.25,
	initfunc = function()
		nzRound:SetNextBossRound(math.random(8,11)) -- Randomly spawn in rounds 6-8
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		nzRound:SetNextBossRound(nzRound:GetNumber() + math.random(5,7)) -- Delay further boss spawning by 3-5 rounds after its death
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(500) -- Give killer 500 points if not downed
		end
	end,
}) -- No onhit function, we don't give points on hit for this guy

nzRound:AddBossType("Napalm Zombie", "nz_zombie_boss_Napalm", {
	specialspawn = true,
	health = 1350,
	scale = 410,
	dmgmul = 1,
	initfunc = function()
		nzRound:SetNextBossRound(math.random(6,8)) -- Randomly spawn in rounds 6-8
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		nzRound:SetNextBossRound(nzRound:GetNumber() + math.random(3,4)) -- Delay further boss spawning by 3-5 rounds after its death
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(500) -- Give killer 500 points if not downed
		end
	end,
}) -- No onhit function, we don't give points on hit for this guy

nzRound:AddBossType("Nemesis", "nz_zombie_boss_Nemesis", {
	specialspawn = true,
	health = 3200,
	scale = 800,
	dmgmul = 1,
	initfunc = function()
		nzRound:SetNextBossRound(math.random(8,9)) -- Randomly spawn in rounds 6-8
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		nzRound:SetNextBossRound(nzRound:GetNumber() + math.random(6,7)) -- Delay further boss spawning by 3-5 rounds after its death
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(500) -- Give killer 500 points if not downed
		end
	end,
}) -- No onhit function, we don't give points on hit for this guy

nzRound:AddBossType("George Romero", "nz_zombie_boss_romero", {
	specialspawn = true,
	health = 15625,
	scale = 1,
	dmgmul = 1,
	initfunc = function()
		nzRound:SetNextBossRound(math.random(2,8)) -- Randomly spawn in rounds 6-8
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		nzRound:SetNextBossRound(nzRound:GetNumber() + math.random(5,6)) -- Delay further boss spawning by 3-5 rounds after its death
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(500) -- Give killer 500 points if not downed
		end
	end,
}) -- No onhit function, we don't give points on hit for this guy

nzRound:AddBossType("George Romero (Round 1)", "nz_zombie_boss_romero", {
	specialspawn = true,
	health = 15625,
	scale = 1,
	dmgmul = 1,
	initfunc = function()
		nzRound:SetNextBossRound(1) -- Randomly spawn in rounds 6-8
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		nzRound:SetNextBossRound(nzRound:GetNumber() + math.random(6,8)) -- Delay further boss spawning by 3-5 rounds after its death
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(500) -- Give killer 500 points if not downed
		end
	end,
}) -- No onhit function, we don't give points on hit for this guy

nzRound:AddBossType("Cosmonaut (Round 2)", "nz_zombie_boss_astro", {
	specialspawn = true,
	health = 15625,
	scale = 1,
	dmgmul = 1,
	initfunc = function()
		nzRound:SetNextBossRound(2) -- Randomly spawn in rounds 6-8
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		nzRound:SetNextBossRound(nzRound:GetNumber() + math.random(1,2)) -- Delay further boss spawning by 3-5 rounds after its death
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(500) -- Give killer 500 points if not downed
		end
	end,
}) -- No onhit function, we don't give points on hit for this guy

nzRound:AddBossType("Shrieker Zombie", "nz_zombie_boss_shrieker", {
	specialspawn = true,
	health = 2000,
	scale = 300,
	dmgmul = 1,
	initfunc = function()
		nzRound:SetNextBossRound(math.random(6,8)) -- Randomly spawn in rounds 6-8
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		nzRound:SetNextBossRound(nzRound:GetNumber() + math.random(3,5)) -- Delay further boss spawning by 3-5 rounds after its death
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(500) -- Give killer 500 points if not downed
		end
	end,
}) -- No onhit function, we don't give points on hit for this guy

nzRound:AddBossType("Thrasher", "nz_zombie_boss_thrasher", {
	specialspawn = true,
	health = 3500,
	scale = 900,
	dmgmul = 1,
	initfunc = function()
		nzRound:SetNextBossRound(math.random(7,11)) -- Randomly spawn in rounds 6-8
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		nzRound:SetNextBossRound(nzRound:GetNumber() + math.random(3,5)) -- Delay further boss spawning by 3-5 rounds after its death
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(500) -- Give killer 500 points if not downed
		end
	end,
}) -- No onhit function, we don't give points on hit for this guy

nzRound:AddBossType("Larry the Lobster", "nz_zombie_boss_larry", {
	specialspawn = true,
	health = 3000,
	scale = 1000,
	dmgmul = 1,
	initfunc = function()
		nzRound:SetNextBossRound(math.random(2,9)) -- Randomly spawn in rounds 6-8
	end,
	spawnfunc = function(self)
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
	end,
	deathfunc = function(self, killer, dmginfo, hitgroup)
		nzRound:SetNextBossRound(nzRound:GetNumber() + math.random(3,5)) -- Delay further boss spawning by 3-5 rounds after its death
		if IsValid(attacker) and attacker:IsPlayer() and attacker:GetNotDowned() then
			attacker:GivePoints(500) -- Give killer 500 points if not downed
		end
	end,
}) -- No onhit function, we don't give points on hit for this guy
