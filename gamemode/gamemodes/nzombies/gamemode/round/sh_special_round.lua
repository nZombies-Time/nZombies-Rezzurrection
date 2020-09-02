if SERVER then
	function nzRound:SetNextSpecialRound( num )
		self.NextSpecialRound = num
	end

	function nzRound:GetNextSpecialRound()
		return self.NextSpecialRound
	end

	function nzRound:MarkedForSpecial( num )
		return ((self.NextSpecialRound == num and self.SpecialRoundType and self.SpecialData[self.SpecialRoundType] and true) or (nzConfig.RoundData[ num ] and nzConfig.RoundData[ num ].special)) or false
	end
	
	function nzRound:SetSpecialRoundType(id)
		if id == "None" then
			self.SpecialRoundType = nil -- "None" makes a nil key
		else
			self.SpecialRoundType = id or "Hellhounds" -- A nil id defaults to "Hellhounds", otherwise id
		end
	end
	
	function nzRound:GetSpecialRoundType(id)
		return self.SpecialRoundType
	end
	
	function nzRound:GetSpecialRoundData()
		if !self.SpecialRoundType then return nil end
		return self.SpecialData[self.SpecialRoundType]
	end

	util.AddNetworkString("nz_hellhoundround")
	function nzRound:CallHellhoundRound()
		net.Start("nz_hellhoundround")
			net.WriteBool(true)
		net.Broadcast()
	end
end


nzRound.ZombieData = nzRound.ZombieData or {}
function nzRound:AddZombieType(id, class)
	if SERVER then
		if class then
			local data = {}
			-- Which entity to spawn
			data.class = class
			nzRound.ZombieData[id] = data
		else
			nzRound.ZombieData[id] = nil -- Remove it if no valid class was added
		end
	else
		-- Clients only need it for the dropdown, no need to actually know the data and such
		nzRound.ZombieData[id] = class
	end
end

nzRound:AddZombieType("Kino der Toten", "nz_zombie_walker", {
}) 

nzRound:AddZombieType("Ascension", "nz_zombie_walker_ascension", {
}) 

nzRound:AddZombieType("Call of the Dead", "nz_zombie_walker_cotd", {
}) 

nzRound:AddZombieType("FIVE", "nz_zombie_walker_five", {
}) 

nzRound:AddZombieType("Gorod Krovi", "nz_zombie_walker_gorodkrovi", {
}) 

nzRound:AddZombieType("Shadows of Evil", "nz_zombie_walker_soemale", {
}) 

nzRound:AddZombieType("Zetsubou no Shima", "nz_zombie_walker_zetsubou", {
}) 
nzRound:AddZombieType("Origins", "nz_zombie_walker_origins", {
}) 
nzRound:AddZombieType("Moon", "nz_zombie_walker_moon", {
}) 
nzRound:AddZombieType("Der Eisendrache", "nz_zombie_walker_eisendrache", {
}) 
nzRound:AddZombieType("Buried", "nz_zombie_walker_buried", {
}) 
nzRound:AddZombieType("Shangri-La", "nz_zombie_walker_shangrila", {
}) 
nzRound:AddZombieType("Shi no Numa", "nz_zombie_walker_sumpf", {
}) 
nzRound:AddZombieType("Xenomorph", "nz_zombie_walker_xeno", {
}) 
nzRound:AddZombieType("Necromorph", "nz_zombie_walker_necromorph", {
}) 

function nzRound:GetZombieType(id)
	if id == "Ascension" then
	return "nz_zombie_walker_ascension"
	end
	if id == "Call of the Dead" then
	return "nz_zombie_walker_cotd"
	end
	if id == "FIVE" then
	return "nz_zombie_walker_five"
	end
	if id == "Gorod Krovi" then
	return "nz_zombie_walker_gorodkrovi"
	end
	if id == "Shadows of Evil" then
	return "nz_zombie_walker_soemale"
	end
	if id == "Zetsubou no Shima" then
	return "nz_zombie_walker_zetsubou"
	end
	if id == "Xenomorph" then
	return "nz_zombie_walker_xeno"
	end
	if id == "Necromorph" then
	return "nz_zombie_walker_necromorph"
	end
	if id == "Kino der Toten" then
	return "nz_zombie_walker"
	end
	if id == "Origins" then
	return "nz_zombie_walker_origins"
	end
	if id == "Moon" then
	return "nz_zombie_walker_moon"
	end
	if id == "Buried" then
	return "nz_zombie_walker_buried"
	end
	if id == "Der Eisendrache" then
	return "nz_zombie_walker_eisendrache"
	end
	if id == "Shangri-La" then
	return "nz_zombie_walker_shangrila"
	end
	if id == "Shi no Numa" then
	return "nz_zombie_walker_sumpf"
	end
	if id == nil then
	return "nz_zombie_walker"
	end
end

nzRound.SpecialData = nzRound.SpecialData or {}
function nzRound:AddSpecialRoundType(id, data, spawnfunc, roundfunc, endfunc)
	if SERVER then
		nzRound.SpecialData[id] = {}
		-- Zombie data, like those in the configuration files
		nzRound.SpecialData[id].data = data
		-- Optional spawn function, runs when a zombie spawns (can be used to set health, speed, etc)
		if spawnfunc then nzRound.SpecialData[id].spawnfunc = spawnfunc end
		-- Optional round function, runs when the round starts (can be used to set amount, sounds, fog, etc)
		if roundfunc then nzRound.SpecialData[id].roundfunc = roundfunc end
		-- Optional end function, runs when the special round ends (can be used to clean up changes)
		if endfunc then nzRound.SpecialData[id].endfunc = endfunc end
	else
		-- Clients only need it for the dropdown, no need to actually know the data and such
		nzRound.SpecialData[id] = (data and true or nil)
	end
end

nzRound:AddSpecialRoundType("Hellhounds", {
	specialTypes = {
		["nz_zombie_special_dog"] = {chance = 100}
	},
	specialDelayMod = function() return math.Clamp(2 - #player.GetAllPlaying()*0.5, 0.5, 2) end, -- Dynamically change spawn speed depending on player count
	specialCountMod = function() return nzRound:GetNumber() * #player.GetAllPlaying() end, -- Modify the count
}, function(dog) -- We want to modify health
	local round = nzRound:GetNumber()
	if round == -1 then
		dog:SetHealth(math.random(120, 1200))
	else
		dog:SetHealth(math.Clamp(round * 20, 120, 1200))
	end
end) -- No round func or end func

nzRound:AddSpecialRoundType("Keepers", {
	specialTypes = {
		["nz_zombie_special_keeper"] = {chance = 100}
	},
	specialDelayMod = function() return math.Clamp(2 - #player.GetAllPlaying()*0.5, 0.5, 2) end, -- Dynamically change spawn speed depending on player count
	specialCountMod = function() return nzRound:GetNumber() * #player.GetAllPlaying() end, -- Modify the count
}, function(dog) -- We want to modify health
	local round = nzRound:GetNumber()
	if round == -1 then
		dog:SetHealth(math.random(120, 1200))
	else
		dog:SetHealth(math.Clamp(round * 20, 120, 1200))
	end
end) -- No round func or end func

nzRound:AddSpecialRoundType("Nova Crawlers", {
	specialTypes = {
		["nz_zombie_special_nova"] = {chance = 100}
	},
	specialDelayMod = function() return math.Clamp(2 - #player.GetAllPlaying()*0.5, 0.5, 2) end, -- Dynamically change spawn speed depending on player count
	specialCountMod = function() return nzRound:GetNumber() * #player.GetAllPlaying() end, -- Modify the count
}, function(dog) -- We want to modify health
	local round = nzRound:GetNumber()
	if round == -1 then
		dog:SetHealth(math.random(120, 1200))
	else
		dog:SetHealth(math.Clamp(round * 20, 120, 1200))
	end
end) -- No round func or end func

nzRound:AddSpecialRoundType("Lickers", {
	specialTypes = {
		["nz_zombie_special_licker"] = {chance = 100}
	},
	specialDelayMod = function() return math.Clamp(2 - #player.GetAllPlaying()*0.5, 0.5, 2) end, -- Dynamically change spawn speed depending on player count
	specialCountMod = function() return nzRound:GetNumber() * #player.GetAllPlaying() end, -- Modify the count
}, function(dog) -- We want to modify health
	local round = nzRound:GetNumber()
	if round == -1 then
		dog:SetHealth(math.random(120, 1200))
	else
		dog:SetHealth(math.Clamp(round * 32, 200, 2000))
	end
end) -- No round func or end func

nzRound:AddSpecialRoundType("Facehuggers", {
	specialTypes = {
		["nz_zombie_special_facehugger"] = {chance = 100}
	},
	specialDelayMod = function() return math.Clamp(2 - #player.GetAllPlaying()*0.5, 0.5, 2) end, -- Dynamically change spawn speed depending on player count
	specialCountMod = function() return nzRound:GetNumber() * #player.GetAllPlaying() end, -- Modify the count
}, function(dog) -- We want to modify health
	local round = nzRound:GetNumber()
	if round == -1 then
		dog:SetHealth(math.random(120, 1200))
	else
		dog:SetHealth(math.Clamp(round * 10, 60, 600))
	end
end) -- No round func or end func

nzRound:AddSpecialRoundType("The Pack (Dead Space)", {
	specialTypes = {
		["nz_zombie_special_pack"] = {chance = 100}
	},
	specialDelayMod = function() return math.Clamp(2 - #player.GetAllPlaying()*0.5, 0.5, 2) end, -- Dynamically change spawn speed depending on player count
	specialCountMod = function() return nzRound:GetNumber() * #player.GetAllPlaying() end, -- Modify the count
}, function(dog) -- We want to modify health
	local round = nzRound:GetNumber()
	if round == -1 then
		dog:SetHealth(math.random(120, 1200))
	else
		dog:SetHealth(math.Clamp(round * 25, 150, 1500))
	end
end) -- No round func or end func

nzRound:AddSpecialRoundType("Spiders", {
	specialTypes = {
		["nz_zombie_special_spooder"] = {chance = 100}
	},
	specialDelayMod = function() return math.Clamp(2 - #player.GetAllPlaying()*0.5, 0.5, 2) end, -- Dynamically change spawn speed depending on player count
	specialCountMod = function() return nzRound:GetNumber() * #player.GetAllPlaying() end, -- Modify the count
}, function(dog) -- We want to modify health
	local round = nzRound:GetNumber()
	if round == -1 then
		dog:SetHealth(math.random(120, 1200))
	else
		dog:SetHealth(math.Clamp(round * 13, 90, 900))
	end
end) -- No round func or end func

nzRound:AddSpecialRoundType("Burning Zombies", {
	normalTypes = {
		["nz_zombie_special_burning"] = {chance = 100}
	},
	normalDelay = 0.75,
	normalCountMod = function(original) return original * 0.5 end, -- Half the normal count here
}) -- No special functions or anything really