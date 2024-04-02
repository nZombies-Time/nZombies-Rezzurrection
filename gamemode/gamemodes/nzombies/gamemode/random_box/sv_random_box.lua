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
		
		if (nzMapping.Settings.boxtype == "Original" or nzMapping.Settings.boxtype == "Black Ops 3"  or nzMapping.Settings.boxtype == "Black Ops 3(Quiet Cosmos)") then
			box:SetPos( pos + ang:Up()*10 + ang:Right()*7 )
		else
			box:SetPos( pos + ang:Right()*7 )
		end
		
		box:SetAngles( ang )
		box:Spawn()
		box.SpawnPoint = rand
		rand.Box = box
		
		rand:SetBodygroup(1,1)

		local phys = box:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
			phys:Sleep()
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

	-- A copy of how 3arc did Teddybear chances in BO1 and most likely W@W.

	local random = math.random(100)
	local minuses = 4

	local chanceofjoker = 0

	if nzRandomBox:GetBoxUses() < minuses or nzPowerUps:IsPowerupActive("firesale") then
		chanceofjoker = -1 -- No teddy if the box was only used 3 times, or if theres a Firesale active.
	else
		chanceofjoker = nzRandomBox:GetBoxUses() + 20

		if !nzPowerUps:GetBoxMoved() and nzRandomBox:GetBoxUses() >= 8 then
			chanceofjoker = 100 -- Force Teddy after 8 uses.
		end

		if nzRandomBox:GetBoxUses() >= 4 and nzRandomBox:GetBoxUses() <= 8 then
			if random < 15 then -- 15% Chance of Teddy
				chanceofjoker = 100
			else
				chanceofjoker = -1
			end
		end

		if nzPowerUps:GetBoxMoved() then
			if nzRandomBox:GetBoxUses() >= 8 and nzRandomBox:GetBoxUses() <= 13 then
				if random < 30 then -- 30% Chance of Teddy
					chanceofjoker = 100
				else
					chanceofjoker = -1
				end
			end

			if nzRandomBox:GetBoxUses() >= 13 then
				if random < 50 then -- 50% Chance of Teddy
					chanceofjoker = 100
				else
					chanceofjoker = -1
				end
			end
		end
	end

	print("Total Box Spins: "..nzRandomBox:GetBoxUses().."")
	print("Joker Chance: "..chanceofjoker.."")

	if chanceofjoker > random and table.Count(ents.FindByClass("random_box_spawns")) > 1 then
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

	local badRoll = false

	print(gun)

	if ply:HasWeapon(gun) then
		badRoll = true
	end

	while(badRoll) do
		gun = nzMisc.WeightedRandom(guns) -- Randomly decide by weight
		wep = weapons.Get(gun)
		if !ply:HasWeapon(gun) then
			badRoll = false
		end
	end

	if ply:HasWeapon(gun) then
		gun = hook.Call("OnPlayerBuyBox", nil, ply, gun) or gun
	end
	
	return gun
end
