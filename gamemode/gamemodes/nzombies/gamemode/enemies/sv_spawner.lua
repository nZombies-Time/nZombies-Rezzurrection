-- Class for spawning zombies. This can be used t create different Spawners for different spawnpoints.
-- Warning! Creating multiple instances of this class for the same spawnpoint entity will overwrite prior instances.
-- Author: Lolle

if Spawner == nil then
	Spawner = nzClass({
		-- CONSTRUCTOR
		-- sPointClass: The class of spawnpoints this spawner will create entities from.
		--              A spawnpoint class should only be used by one spawner at a time.
		-- data: information about the entities that are spawned, required are a entity class and chance.
		-- zombiesToSpawn: the amount of zombies this type of spawner will spawn in total.
		-- spawnDelay: delays the next spawn by the amount set in this value
		-- roundNum: the round this spawner was created (after this round teh spawn will be removed)
		constructor = function(self, spointClass, data, zombiesToSpawn, spawnDelay, roundNum)
			local basedelay = 2 -- Moo Mark. Base Zombie spawn delay to be more like how 3arc did it.

			self.sSpointClass = spointClass or "nz_spawn_zombie_normal"
			self.tData = data or {[nzRound:GetZombieType(nzMapping.Settings.zombietype)] = {chance = 100}}
			self.iZombiesToSpawn = zombiesToSpawn or 5
			self.tSpawns = ents.FindByClass(self.sSpointClass)
			self.tValidSpawns = {}

			if nzRound:GetNumber() == -1 or nzRound:GetRampage() then
				basedelay = 0.01
			else
				for i=1,nzRound:GetNumber() do -- Moo Mark. I finally figured out how spawn delay is done in the real games... Turns out its a "for loop", for every round Base value is multiplied by 0.95.
					basedelay = math.Clamp(basedelay * 0.95, 0.05, 2)
				end
			end

			self:SetDelay(spawnDelay or basedelay or 0.75)


			self:SetNextSpawn(CurTime())
			self:SetZombieData(self.tData)
			-- not really sure if this is 100% unique but for our purpose it will be enough
			self.sUniqueName = self.sSpointClass .. "." .. CurTime()
			self.iRoundNumber = roundNum or nzRound:GetNumber()
			self:Activate()
		end
	})
end

AccessorFunc(Spawner, "dDelay", "Delay", FORCE_NUMBER)
AccessorFunc(Spawner, "dNextSpawn", "NextSpawn", FORCE_NUMBER)

function Spawner:Activate()
	for _, spawn in pairs(self.tSpawns) do
		spawn:SetSpawner(self)
	end
	timer.Create("nzZombieSpawnThink" .. self.sUniqueName, 2, 0, function() self:Update() end) -- Since it's process is overall simpler, I've shortened the time it takes for the spawn to update.
end

function Spawner:DecrementZombiesToSpawn()
	self.iZombiesToSpawn = self.iZombiesToSpawn - 1
end

function Spawner:IncrementZombiesToSpawn()
	self.iZombiesToSpawn = self.iZombiesToSpawn + 1
end

function Spawner:GetZombiesToSpawn()
	return nzRound:GetNumber() == -1 and 50 or self.iZombiesToSpawn -- Round Infinity always has 50 zombies to spawn (even after they spawn ;) )
end

function Spawner:SetZombiesToSpawn(value)
	self.iZombiesToSpawn = value
end

function Spawner:GetSpawns()
	return self.tSpawns
end

function Spawner:GetData()
	return self.tData
end

function Spawner:Update()
	-- garbage collect the spawner object if a round is over
	if (self.iRoundNumber != nzRound:GetNumber() or nzRound:InState(ROUND_GO)) and timer.Exists("nzZombieSpawnThink" .. self.sUniqueName) then
		self:Remove()
	end

	self:UpdateValidSpawns()
end

function Spawner:UpdateValidSpawns()

	if self:GetZombiesToSpawn() <= 0 then return end

	-- reset
	self.tValidSpawns = {}

	for _, spawn in pairs(self.tSpawns) do
		spawn:SetZombiesToSpawn(0)

		-- Don't put more than one Master, it'll cause issues and I don't wanna make failsafes for it right now.
		if spawn:GetMasterSpawn() then -- Find the master spawner and enable it.
            table.insert(self.tValidSpawns, spawn) -- Put it in the table.
		end
	end

	local zombiesToSpawn = self:GetZombiesToSpawn()
	local numspawns = table.Count(self.tValidSpawns)

	local vspawn = self.tValidSpawns[1]
	if IsValid(vspawn) then
		vspawn:SetZombiesToSpawn(zombiesToSpawn) -- Found the Master Spawner and its valid, time to give it the zombies to spawn for the round.
		debugoverlay.Text(vspawn:GetPos() + Vector(0,0,75), "ZombiesToSpawn: "..tostring(zombiesToSpawn)..", B: "..tostring(vspawn:IsSuitable())..", T: "..math.Round(vspawn:GetNextSpawn()-CurTime(), 2)..", ST: "..(vspawn:GetSpawner() and math.Round(vspawn:GetSpawner():GetNextSpawn() - CurTime(), 2) or "nil"), 4)
	end
end

function Spawner:GetValidSpawns()
	return self.tValidSpawns
end

function Spawner:SetZombieData(data)
	for _, spawn in pairs(self.tSpawns) do
		spawn:SetZombieData(data)
	end
end

function Spawner:Remove()
	timer.Remove("nzZombieSpawnThink" .. self.sUniqueName)
	for _, spawn in pairs(self.tSpawns) do
		if IsValid(spawn) then
			spawn:SetSpawner(nil)
		end
	end
	self = nil
end
