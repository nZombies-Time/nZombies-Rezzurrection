
function nzMapping:LoadMapSettings(data)
	if !data then return end
	
	if data.startwep then
		nzMapping.Settings.startwep = weapons.Get(data.startwep) and data.startwep or "robotnik_bo1_1911"
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
	
	nzMapping.Settings.wunderfizzperklist = data.wunderfizzperklist
	
	if data.gamemodeentities then
		nzMapping.Settings.gamemodeentities = data.gamemodeentities or nil
	end

	if data.specialroundtype then
		nzMapping.Settings.specialroundtype = data.specialroundtype or "Hellhounds"
	end
	if data.zombietype then
		nzMapping.Settings.zombietype = data.zombietype or "Kino der Toten"
	end
	if data.perkmachinetype then
		nzMapping.Settings.perkmachinetype = data.perkmachinetype or "Original"
		else
		nzMapping.Settings.perkmachinetype = "Original"
	end
	if data.hudtype then
		nzMapping.Settings.hudtype = data.hudtype or "Origins (Black Ops 2)"
	end
	if data.boxtype then
		nzMapping.Settings.boxtype = data.boxtype or "Original"
	end
	if data.bosstype then
		nzMapping.Settings.bosstype = data.bosstype or "Panzer"
	end
	if data.newwave1 then
		nzMapping.Settings.newwave1 = tonumber(data.newwave1) or 20
	end
	if data.newtype1 then
		nzMapping.Settings.newtype1 = data.newtype1 or "Hellhounds"
	end
	if data.newratio1 then
		nzMapping.Settings.newratio1 = tonumber(data.newratio1) or 0.5
	end
	if data.newwave2 then
		nzMapping.Settings.newwave2 = tonumber(data.newwave2) or 0
	end
	if data.newtype2 then
		nzMapping.Settings.newtype2 = data.newtype2 or "None"
	end
	if data.newratio2 then
		nzMapping.Settings.newratio2 = tonumber(data.newratio2) or 0
	end
	if data.newwave3 then
		nzMapping.Settings.newwave3 = tonumber(data.newwave3) or 0
	end
	if data.newtype3 then
		nzMapping.Settings.newtype3 = data.newtype3 or "None"
	end
	if data.newratio3 then
		nzMapping.Settings.newratio3 = tonumber(data.newratio3) or 0
	end
		if data.newwave4 then
		nzMapping.Settings.newwave4 = tonumber(data.newwave4) or 0
	end
	if data.newtype4 then
		nzMapping.Settings.newtype4 = data.newtype4 or "None"
	end
	if data.newratio4 then
		nzMapping.Settings.newratio4 = tonumber(data.newratio4) or 0
	end
	if data.mainfont then
		nzMapping.Settings.mainfont = (data.mainfont) or "Default NZR"
	end
	if data.smallfont then
		nzMapping.Settings.smallfont = (data.smallfont) or "Default NZR"
	end
	if data.mediumfont then
		nzMapping.Settings.mediumfont = (data.mediumfont) or "Default NZR"
	end
	if data.roundfont then
		nzMapping.Settings.roundfont = (data.roundfont) or "Classic NZ"
	end
	if data.ammofont then
		nzMapping.Settings.ammofont = (data.ammofont) or "Default NZR"
	end
	if data.ammo2font then
		nzMapping.Settings.ammo2font = (data.ammo2font) or "Default NZR"
	end
	if data.fontthicc then
		nzMapping.Settings.fontthicc = tonumber(data.fontthicc) or 2
	end
	if data.icontype then
		nzMapping.Settings.icontype = (data.icontype) or "Rezzurrection"
	end


	nzMapping.Settings.startingspawns = data.startingspawns == nil and 35 or data.startingspawns
	nzMapping.Settings.spawnperround = data.spawnperround == nil and 0 or data.spawnperround
	nzMapping.Settings.maxspawns = data.maxspawns == nil and 35 or data.maxspawns
	nzMapping.Settings.zombiesperplayer = data.zombiesperplayer == nil and 0 or data.zombiesperplayer
	nzMapping.Settings.spawnsperplayer = data.spawnsperplayer == nil and 0 or data.spawnsperplayer
	NZZombiesMaxAllowed = nzMapping.Settings.startingspawns
	
	nzMapping.Settings.zombieeyecolor = data.zombieeyecolor == nil and Color(0, 255, 255, 255) or Color(data.zombieeyecolor.r, data.zombieeyecolor.g, data.zombieeyecolor.b)
	nzMapping.Settings.boxlightcolor = data.boxlightcolor == nil and Color(0, 150,200,255) or Color(data.boxlightcolor.r, data.boxlightcolor.g, data.boxlightcolor.b) 
	nzMapping.Settings.textcolor = data.textcolor == nil and Color(0, 255, 255, 255) or Color(data.textcolor.r, data.textcolor.g, data.textcolor.b) 
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