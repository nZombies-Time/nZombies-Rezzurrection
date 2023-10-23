--

function nzRandomBox.Spawn(exclude, first)
	--Get all spawns
	local all = ents.FindByClass("random_box_spawns")
	local possible = {}
	for k,v in pairs(all) do
		if (!IsValid(exclude) or exclude != v) and (!first or tobool(v.PossibleSpawn)) then
			table.insert(possible, v)
		end
	end
	-- No points with possible spawn set, we'll just use all then
	if #possible <= 0 then possible = all end

	local rand = possible[ math.random( #possible ) ]

	if rand != nil and !IsValid(rand.Box) then
		local box = ents.Create( "random_box" )
		local pos = rand:GetPos()
		local ang = rand:GetAngles()
		
		 -- new
        local BoxType = nzMapping.Settings.boxtype
        if (BoxType == "Original" or BoxType == nil) then
            box:SetPos( pos + ang:Up()*10 + ang:Right()*7 )
        else
            box:SetPos(pos)
        end
		box:SetAngles( ang )
		box:Spawn()
		--box:PhysicsInit( SOLID_VPHYSICS )
		box.SpawnPoint = rand
		rand.Box = box
		
		rand:SetBodygroup(1,1)
		if (nzMapping.Settings.boxtype =="Resident Evil" or nzMapping.Settings.boxtype =="Call of Duty: WW2" or nzMapping.Settings.boxtype =="DOOM" or nzMapping.Settings.boxtype =="Chaos" ) then
			rand:SetModelScale(0, 0 )
			end
		
		local phys = box:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
		end
	else
		print("No random box spawns have been set.")
	end
end

function nzRandomBox.Remove()
	--Get all spawns
	local all = ents.FindByClass("random_box")
	--Loop just incase
	for k,v in pairs(all) do
		v.SpawnPoint.Box = nil
		v:Remove()
	end
end

function nzRandomBox.DecideWep(ply)

	local teddychance = math.random(1, 15)
	if teddychance <= 1 and !nzPowerUps:IsPowerupActive("firesale") and table.Count(ents.FindByClass("random_box_spawns")) > 1 then
		return hook.Call("OnPlayerBuyBox", nil, ply, "nz_box_teddy") or "nz_box_teddy"
	end

	local guns = {}
	local blacklist = table.Copy(nzConfig.WeaponBlackList)

	--Add all our current guns to the black list
	if IsValid(ply) and ply:IsPlayer() then
		local found
		for k,v in pairs( ply:GetWeapons() ) do
			if v.ClassName then
				blacklist[v.ClassName] = true
				if v.ClassName == "nz_touchedlast" then found = true end
				
			end
		end
		if !found and ply.nz_InSteamGroup then guns["nz_touchedlast"] = 20 end
	end

	--Add all guns with no model or wonder weapons that are out to the blacklist
	for k,v in pairs( weapons.GetList() ) do
		if !blacklist[v.ClassName] and !v.NZPreventBox then
			if v.WorldModel == nil or nzWeps:IsWonderWeaponOut(v.ClassName) then
				blacklist[v.ClassName] = true
			end
		end
	end

	if GetConVar("nz_randombox_maplist"):GetBool() and nzMapping.Settings.rboxweps then
		for k,v in pairs(nzMapping.Settings.rboxweps) do
			if !blacklist[k] then
				guns[k] = v
			end
		end
	elseif GetConVar("nz_randombox_whitelist"):GetBool() then
		-- Load only weapons that have a prefix from the whitelist
		for k,v in pairs( weapons.GetList() ) do
			if !blacklist[v.ClassName] and !v.NZPreventBox and !v.NZTotalBlacklist then
				for k2,v2 in pairs(nzConfig.WeaponWhiteList) do
					if string.sub(v.ClassName, 1, #v2) == v2 then
						guns[v.ClassName] = 10
						break
					end
				end
			end
		end
	else
		-- No weapon list and not using whitelist only, add all guns
		for k,v in pairs( weapons.GetList() ) do
			if !blacklist[v.ClassName] and !v.NZPreventBox and !v.NZTotalBlacklist then
				guns[v.ClassName] = 10
			end
		end
	end

	local gun = nzMisc.WeightedRandom( guns ) -- Randomly decide by weight
	local wep = weapons.Get(gun)
	local upgrade = ""
	local upgrade2 =  ""
	if wep.NZPaPReplacement then
		local upgrade  = wep.NZPaPReplacement
		local wep2 =  weapons.Get( wep.NZPaPReplacement)
		if  wep2.NZPaPReplacement then
		local upgrade2 = wep2.NZPaPReplacement
		else
		end
		else
		end
	print(gun)
	local badRoll = false
	if  ply:HasWeapon( gun ) or ply:HasWeapon(upgrade) or ply:HasWeapon(upgrade2) then
	badRoll = true
	end
	while(badRoll) do
	gun = nzMisc.WeightedRandom( guns ) -- Randomly decide by weight
	wep = weapons.Get(gun)
	upgrade = wep.NZPaPReplacement
	wep2 = weapons.Get(upgrade)
	upgrade2 = wep2.NZPaPReplacement
	if  !ply:HasWeapon( gun ) and  !ply:HasWeapon( upgrade )and !ply:HasWeapon( upgrade2 ) then
	badRoll = false
	end
	end
	if  ply:HasWeapon( gun ) or ply:HasWeapon(upgrade) or ply:HasWeapon(upgrade2) then
	print("we did it")
	gun = nzMisc.WeightedRandom( guns ) -- Randomly decide by weight
	wep = weapons.Get(gun)
	upgrade = wep.NZPaPReplacement
	wep2 = weapons.Get(upgrade)
	upgrade2 = wep2.NZPaPReplacement
	else
	gun = hook.Call("OnPlayerBuyBox", nil, ply, gun) or gun
	end
	return gun
end
