
nzLevel = nzLevel or AddNZModule("Level")

nzLevel.TriggerCache = {}
nzLevel.ToggleCache = {}
nzLevel.ZombieCache = {}
nzLevel.ZBossCache = {}
nzLevel.ShieldCache = {}
nzLevel.CreativeCache = {}
nzLevel.VultureCache = {}
nzLevel.BarricadeCache = {}
nzLevel.JumpTravCache = {}
nzLevel.TargetCache = {}
nzLevel.HudEntityCache = {}
nzLevel.BrutusEntityCache = {}

nzLevel.PSpawnCache = {}
nzLevel.ZSpawnCache = {}
nzLevel.ESpawnCache = {}
nzLevel.SSpawnCache = {}

local inext = ipairs({})

local string_find = string.find

local zspawnerclasses = {
	["nz_spawn_zombie"] = true,
	["nz_spawn_zombie_boss"] = true,
	["nz_spawn_zombie_extra1"] = true,
	["nz_spawn_zombie_extra2"] = true,
	["nz_spawn_zombie_extra3"] = true,
	["nz_spawn_zombie_extra4"] = true,
	["nz_spawn_zombie_normal"] = true,
	["nz_spawn_zombie_special"] = true,
}

local espawnerclasses = {
	["nz_spawn_zombie_extra1"] = true,
	["nz_spawn_zombie_extra2"] = true,
	["nz_spawn_zombie_extra3"] = true,
	["nz_spawn_zombie_extra4"] = true,
}

local sspawnerclasses = {
	["nz_spawn_zombie_special"] = true,
}

local barricadeclasses = {
	["breakable_entry"] = true,
}

local scripttriggers = {
	["nz_script_triggerzone"] = true,
}

hook.Add("OnEntityCreated", "nzLevel.Iterator", function(ent)
	local class = ent:GetClass()

	timer.Simple(engine.TickInterval(), function()
		if not IsValid(ent) then return end
		if (ent.TurnOff and ent.TurnOn) then
			table.insert(nzLevel.ToggleCache, ent)
		end
		if ent.NZThrowIcon or ent.NZNadeRethrow then
			table.insert(nzLevel.HudEntityCache, ent)
		end
		if ent.bIsShield then
			table.insert(nzLevel.ShieldCache, ent)
		end
		if ent.BrutusDestructable then
			table.insert(nzLevel.BrutusEntityCache, ent)
		end
		if ent:IsValidZombie() then
			if ent.NZBossType or string.find(class, "zombie_boss") then
				table.insert(nzLevel.ZBossCache, ent)
			else
				table.insert(nzLevel.ZombieCache, ent)
			end
		end
	end)

	if barricadeclasses[class] then
		table.insert(nzLevel.BarricadeCache, ent)
	end

	if class == "jumptrav_block" then
		table.insert(nzLevel.JumpTravCache, ent)
	end

	if nzPerks.VultureClass[class] then
		table.insert(nzLevel.VultureCache, ent)
	end
	if class == "player_spawns" then
		table.insert(nzLevel.PSpawnCache, ent)
	end
	if zspawnerclasses[class] then
		table.insert(nzLevel.ZSpawnCache, ent)
	end
	if espawnerclasses[class] then
		table.insert(nzLevel.ESpawnCache, ent)
	end
	if sspawnerclasses[class] then
		table.insert(nzLevel.SSpawnCache, ent)
	end

	if scripttriggers[class] then
		table.insert(nzLevel.TriggerCache, ent)
	end
end)

hook.Add("EntityRemoved", "nzLevel.Iterator", function(ent)
	local class = ent:GetClass()

	if (ent.TurnOff and ent.TurnOn) then
		for i = 1, #nzLevel.ToggleCache do
			if nzLevel.ToggleCache[i] == ent then
				table.remove(nzLevel.ToggleCache, i)
				break
			end
		end
	end

	if ent.NZThrowIcon or ent.NZNadeRethrow then
		for i = 1, #nzLevel.HudEntityCache do
			if nzLevel.HudEntityCache[i] == ent then
				table.remove(nzLevel.HudEntityCache, i)
				break
			end
		end
	end

	if ent.BrutusDestructable then
		for i = 1, #nzLevel.BrutusEntityCache do
			if nzLevel.BrutusEntityCache[i] == ent then
				table.remove(nzLevel.BrutusEntityCache, i)
				break
			end
		end
	end

	if ent:IsValidZombie() then
		if ent.NZBossType or string.find(class, "zombie_boss") then
			for i = 1, #nzLevel.ZBossCache do
				if nzLevel.ZBossCache[i] == ent then
					table.remove(nzLevel.ZBossCache, i)
					break
				end
			end
		else
			for i = 1, #nzLevel.ZombieCache do
				if nzLevel.ZombieCache[i] == ent then
					table.remove(nzLevel.ZombieCache, i)
					break
				end
			end
		end
	end

	if nzPerks.VultureClass[class] then
		for i = 1, #nzLevel.VultureCache do
			if nzLevel.VultureCache[i] == ent then
				table.remove(nzLevel.VultureCache, i)
				break
			end
		end
	end

	if ent.bIsShield then
		for i = 1, #nzLevel.ShieldCache do
			if nzLevel.ShieldCache[i] == ent then
				table.remove(nzLevel.ShieldCache, i)
				break
			end
		end
	end

	if barricadeclasses[class] then
		for i = 1, #nzLevel.BarricadeCache do
			if nzLevel.BarricadeCache[i] == ent then
				table.remove(nzLevel.BarricadeCache, i)
				break
			end
		end
	end

	if class == "jumptrav_block" then
		for i = 1, #nzLevel.JumpTravCache do
			if nzLevel.JumpTravCache[i] == ent then
				table.remove(nzLevel.JumpTravCache, i)
				break
			end
		end
	end

	if class == "player_spawns" then
		for i = 1, #nzLevel.PSpawnCache do
			if nzLevel.PSpawnCache[i] == ent then
				table.remove(nzLevel.PSpawnCache, i)
				break
			end
		end
	end

	if zspawnerclasses[class] then
		for i = 1, #nzLevel.ZSpawnCache do
			if nzLevel.ZSpawnCache[i] == ent then
				table.remove(nzLevel.ZSpawnCache, i)
				break
			end
		end
	end
	if espawnerclasses[class] then
		for i = 1, #nzLevel.ESpawnCache do
			if nzLevel.ESpawnCache[i] == ent then
				table.remove(nzLevel.ESpawnCache, i)
				break
			end
		end
	end
	if sspawnerclasses[class] then
		for i = 1, #nzLevel.SSpawnCache do
			if nzLevel.SSpawnCache[i] == ent then
				table.remove(nzLevel.SSpawnCache, i)
				break
			end
		end
	end

	if scripttriggers[class] then
		for i = 1, #nzLevel.TriggerCache do
			if nzLevel.TriggerCache[i] == ent then
				table.remove(nzLevel.TriggerCache, i)
				break
			end
		end
	end

	if ent:GetTargetPriority() then
		for i = 1, #nzLevel.TargetCache do
			if nzLevel.TargetCache[i] == ent then
				table.remove(nzLevel.TargetCache, i)
				break
			end
		end
	end
end)

//vulture specific
if SERVER then
	util.AddNetworkString("nzUpdateVultureArray")

	function nzLevel:UpdateVultureArray(ent, reciever)
		if not IsValid(ent) then return end

		net.Start("nzUpdateVultureArray")
			net.WriteEntity(ent)
		return reciever and net.Send(reciever) or net.Broadcast()
	end

	FullSyncModules["nzLevel"] = function(ply)
		for _, ent in pairs(nzLevel.VultureCache) do
			nzLevel:UpdateVultureArray(ent, ply)
		end
	end
end

if CLIENT then
	local function RecieveVultureArrayUpdate( length )
		local ent = net.ReadEntity()
		if not table.HasValue(nzLevel.VultureCache, ent) then
			table.insert(nzLevel.VultureCache, ent)
		end
	end

	net.Receive("nzUpdateVultureArray", RecieveVultureArrayUpdate)
end

function nzLevel.GetVultureArray()
	return inext, nzLevel.VultureCache, 0
end

function nzLevel.GetZombieArray()
	return inext, nzLevel.ZombieCache, 0
end

function nzLevel.GetZombieBossArray()
	return inext, nzLevel.ZBossCache, 0
end

function nzLevel.GetPlayerSpawnArray()
	return inext, nzLevel.PSpawnCache, 0
end

function nzLevel.GetZombieSpawnArray()
	return inext, nzLevel.ZSpawnCache, 0
end

function nzLevel.GetExtraSpawnArray()
	return inext, nzLevel.ESpawnCache, 0
end

function nzLevel.GetSpecialSpawnArray()
	return inext, nzLevel.SSpawnCache, 0
end

function nzLevel.GetTurnOnTurnOffArray()
	return inext, nzLevel.ToggleCache, 0
end

function nzLevel.GetPlayerShieldArray()
	return inext, nzLevel.ShieldCache, 0
end

function nzLevel.GetTriggerZoneArray()
	return inext, nzLevel.TriggerCache, 0
end

function nzLevel.GetBarricadeArray()
	return inext, nzLevel.BarricadeCache, 0
end

function nzLevel.GetJumpTravArray()
	return inext, nzLevel.JumpTravCache, 0
end

function nzLevel.GetTargetableArray()
	return inext, nzLevel.TargetCache, 0
end

function nzLevel.GetHudEntityArray()
	return inext, nzLevel.HudEntityCache, 0
end

function nzLevel.GetBrutusEntityArray()
	return inext, nzLevel.BrutusEntityCache, 0
end