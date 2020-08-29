
function nzMapping:LoadMapSettings(data)
	if !data then return end
	
	if data.startwep then
		nzMapping.Settings.startwep = weapons.Get(data.startwep) and data.startwep or nzConfig.BaseStartingWeapons[1]
	end
	if data.startpoints then
		nzMapping.Settings.startpoints = tonumber(data.startpoints) or 500
	end
	if data.eeurl then
		nzMapping.Settings.eeurl = data.eeurl or nil
	end
	if data.script then
		nzMapping.Settings.script = data.script or nil
	end
	if data.scriptinfo then
		nzMapping.Settings.scriptinfo = data.scriptinfo or nil
	end
	if data.rboxweps then
		if table.Count(data.rboxweps) > 0 then
			local tbl = {}
			for k,v in pairs(data.rboxweps) do
				local wep = weapons.Get(k)
				if wep and !wep.NZTotalBlacklist and !wep.NZPreventBox then -- Weapons are keys
					tbl[k] = tonumber(v) or 10 -- Set weight to value or 10
				else
					wep = weapons.Get(v) -- Weapons are values (old format)
					if wep and !wep.NZTotalBlacklist and !wep.NZPreventBox then
						tbl[v] = 10 -- Set weight to 10
					else
						-- No valid weapon on either key or value
						if tonumber(k) == nil then -- For every key that isn't a number (new format keys are classes)
							tbl[k] = 10
						end
						if tonumber(v) == nil then -- Or for every value that isn't a number (old format values are classes)
							tbl[v] = 10 -- Insert them anyway to make use of mismatch
						end
					end
				end
			end
			nzMapping.Settings.rboxweps = tbl
		else
			nzMapping.Settings.rboxweps = nil
		end
	end
	if data.wunderfizzperks then
		nzMapping.Settings.wunderfizzperks = table.Count(data.wunderfizzperks) > 0 and data.wunderfizzperks or nil
	end
	if data.gamemodeentities then
		nzMapping.Settings.gamemodeentities = data.gamemodeentities or nil
	end

	if data.specialroundtype then
		nzMapping.Settings.specialroundtype = data.specialroundtype or "Hellhounds"
	end
	if data.zombietype then
		nzMapping.Settings.zombietype = data.zombietype or "Kino der Toten"
	end
	if data.bosstype then
		nzMapping.Settings.bosstype = data.bosstype or "Panzer"
	end
	
	nzMapping.Settings.startingspawns = data.startingspawns == nil and 35 or data.startingspawns
	nzMapping.Settings.spawnperround = data.spawnperround == nil and 0 or data.spawnperround
	nzMapping.Settings.maxspawns = data.maxspawns == nil and 35 or data.maxspawns
	nzMapping.Settings.zombiesperplayer = data.zombiesperplayer == nil and 0 or data.zombiesperplayer
	nzMapping.Settings.spawnsperplayer = data.spawnsperplayer == nil and 0 or data.spawnsperplayer
	NZZombiesMaxAllowed = nzMapping.Settings.startingspawns

	-- More compact and less messy:
	for k,v in pairs(nzSounds.struct) do
		nzMapping.Settings[v] = data[v] or {}
	end

	nzMapping.Settings.ac = data.ac == nil and false or data.ac
	nzMapping.Settings.acwarn = data.acwarn == nil and true or data.acwarn
	nzMapping.Settings.acsavespot = data.acsavespot == nil and true or data.acsavespot
	nzMapping.Settings.acpreventboost = data.acpreventboost == nil and true or data.acpreventboost
	nzMapping.Settings.acpreventcjump = data.acpreventcjump == nil and false or data.acpreventcjump
	nzMapping.Settings.actptime = data.actptime == nil and 5 or data.actptime

	nzMapping:SendMapData()
	nzSounds:RefreshSounds()
end