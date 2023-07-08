	--

function nzMapping:ZedSpawn(pos, link,animskip,barricade, ply)

	local ent = ents.Create("nz_spawn_zombie_normal")
	pos.z = pos.z - ent:OBBMaxs().z
	ent:SetPos( pos )
	
	ent:SetSkip( animskip )
	ent:SetBarricade(barricade)
	ent:Spawn()
	print(ent:GetSkip())
	-- For the link displayer
	if link != nil then
		ent:SetLink(tostring(link))
		ent.link = tostring(link)
	end

	if ply then
		undo.Create( "Zombie Spawnpoint" )
			undo.SetPlayer( ply )
			undo.AddEntity( ent )
		undo.Finish( "Effect (" .. tostring( model ) .. ")" )
	end
	return ent
end

function nzMapping:ZedSpecialSpawn(pos, link, ply)

	local ent = ents.Create("nz_spawn_zombie_special")
	pos.z = pos.z - ent:OBBMaxs().z
	ent:SetPos( pos )
	ent:Spawn()
	-- For the link displayer
	if link != nil then
		ent:SetLink(tostring(link))
		ent.link = tostring(link)
	end

	if ply then
		undo.Create( "Special Zombie Spawnpoint" )
			undo.SetPlayer( ply )
			undo.AddEntity( ent )
		undo.Finish( "Effect (" .. tostring( model ) .. ")" )
	end
	return ent
end

function nzMapping:ZedBossSpawn(pos, link, ply)

	local ent = ents.Create("nz_spawn_zombie_boss")
	pos.z = pos.z - ent:OBBMaxs().z
	ent:SetPos( pos )
	ent:Spawn()
	-- For the link displayer
	if link != nil then
		ent:SetLink(tostring(link))
		ent.link = tostring(link)
	end

	if ply then
		undo.Create( "Boss Zombie Spawnpoint" )
			undo.SetPlayer( ply )
			undo.AddEntity( ent )
		undo.Finish( "Effect (" .. tostring( model ) .. ")" )
	end
	return ent
end

function nzMapping:ZedExtraSpawn1(pos, link, ply)

	local ent = ents.Create("nz_spawn_zombie_extra1")
	pos.z = pos.z - ent:OBBMaxs().z
	ent:SetPos( pos )
	ent:Spawn()
	-- For the link displayer
	if link != nil then
		ent:SetLink(tostring(link))
		ent.link = tostring(link)
	end

	if ply then
		undo.Create( "Extra Zombie 1 Spawnpoint" )
			undo.SetPlayer( ply )
			undo.AddEntity( ent )
		undo.Finish( "Effect (" .. tostring( model ) .. ")" )
	end
	return ent
end

function nzMapping:ZedExtraSpawn2(pos, link, ply)

	local ent = ents.Create("nz_spawn_zombie_extra2")
	pos.z = pos.z - ent:OBBMaxs().z
	ent:SetPos( pos )
	ent:Spawn()
	-- For the link displayer
	if link != nil then
		ent:SetLink(tostring(link))
		ent.link = tostring(link)
	end

	if ply then
		undo.Create( "Extra Zombie 2 Spawnpoint" )
			undo.SetPlayer( ply )
			undo.AddEntity( ent )
		undo.Finish( "Effect (" .. tostring( model ) .. ")" )
	end
	return ent
end

function nzMapping:ZedExtraSpawn3(pos, link, ply)

	local ent = ents.Create("nz_spawn_zombie_extra3")
	pos.z = pos.z - ent:OBBMaxs().z
	ent:SetPos( pos )
	ent:Spawn()
	-- For the link displayer
	if link != nil then
		ent:SetLink(tostring(link))
		ent.link = tostring(link)
	end

	if ply then
		undo.Create( "Extra Zombie 3 Spawnpoint" )
			undo.SetPlayer( ply )
			undo.AddEntity( ent )
		undo.Finish( "Effect (" .. tostring( model ) .. ")" )
	end
	return ent
end

function nzMapping:ZedExtraSpawn4(pos, link, ply)

	local ent = ents.Create("nz_spawn_zombie_extra4")
	pos.z = pos.z - ent:OBBMaxs().z
	ent:SetPos( pos )
	ent:Spawn()
	-- For the link displayer
	if link != nil then
		ent:SetLink(tostring(link))
		ent.link = tostring(link)
	end

	if ply then
		undo.Create( "Extra Zombie 4 Spawnpoint" )
			undo.SetPlayer( ply )
			undo.AddEntity( ent )
		undo.Finish( "Effect (" .. tostring( model ) .. ")" )
	end
	return ent
end

function nzMapping:PlayerSpawn(pos, ply)

	local ent = ents.Create("player_spawns")
	pos.z = pos.z - ent:OBBMaxs().z
	ent:SetPos( pos )
	ent:Spawn()

	if ply then
		undo.Create( "Player Spawnpoint" )
			undo.SetPlayer( ply )
			undo.AddEntity( ent )
		undo.Finish( "Effect (" .. tostring( model ) .. ")" )
	end
	return ent

end

function nzMapping:EasterEgg(pos, ang, model, ply)
	local egg = ents.Create( "easter_egg" )
	egg:SetModel( model )
	egg:SetPos( pos )
	egg:SetAngles( ang )
	egg:Spawn()

	local phys = egg:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end

	if ply then
		undo.Create( "Easter Egg" )
			undo.SetPlayer( ply )
			undo.AddEntity( egg )
		undo.Finish( "Effect (" .. tostring( model ) .. ")" )
	end
	return egg
end

function nzMapping:AmmoBox(pos, ang, model, ply)
	local ammobox = ents.Create( "ammo_box" )
	ammobox:SetModel( model )
	ammobox:SetPos( pos )
	ammobox:SetPrice( 4500 )
	ammobox:SetAngles( ang )
	ammobox:Spawn()

	local phys = ammobox:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end

	if ply then
		undo.Create( "Ammo Box" )
			undo.SetPlayer( ply )
			undo.AddEntity( ammobox )
		undo.Finish( "Effect (" .. tostring( model ) .. ")" )
	end
	return ammobox
end

function nzMapping:StinkyLever(pos, ang, ply)
	local category5 = ents.Create( "stinky_lever" )
	category5:SetPos( pos )
	category5:Setohfuck( false )
	category5:SetAngles( ang )
	category5:Spawn()

	local phys = category5:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end

	if ply then
		undo.Create( "Suffering Amplification Device" )
			undo.SetPlayer( ply )
			undo.AddEntity( category5 )
		undo.Finish( "Effect" )
	end
	return category5
end

function nzMapping:Ending(pos, ang, price, ply)
	local ending = ents.Create( "buyable_ending" )
	ending:SetPos( pos )
	ending:SetAngles( ang )
	ending:SetPrice( price )
	ending:Spawn()

	local phys = ending:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end

	if ply then
		undo.Create( "Ending" )
			undo.SetPlayer( ply )
			undo.AddEntity( ending )
		undo.Finish( "Effect (" .. tostring( model ) .. ")" )
	end
	return ending
end

function nzMapping:WallBuy(pos, gun, price, angle, oldent, ply, flipped)

	if IsValid(oldent) then oldent:Remove() end

	local ent = ents.Create("wall_buys")
	ent:SetAngles(angle)
	pos.z = pos.z - ent:OBBMaxs().z
	ent:SetPos( pos )
	ent:SetWeapon(gun, price)
	ent:Spawn()
	--ent:PhysicsInit( SOLID_VPHYSICS )

	local phys = ent:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end

	if flipped != nil then
		ent:SetFlipped(flipped)
	end

	if ply then
		undo.Create( "Wall Gun" )
			undo.SetPlayer( ply )
			undo.AddEntity( ent )
		undo.Finish( "Effect (" .. tostring( model ) .. ")" )
	end
	return ent

end

function nzMapping:PropBuy(pos, ang, model, flags, ply)
	local prop = ents.Create( "prop_buys" )
	prop:SetModel( model )
	prop:SetPos( pos )
	prop:SetAngles( ang )
	prop:Spawn()
	prop:PhysicsInit( SOLID_VPHYSICS )

	-- REMINDER APPY FLAGS
	if flags != nil then
		nzDoors:CreateLink( prop, flags )
	end

	local phys = prop:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end

	if ply then
		undo.Create( "Prop" )
			undo.SetPlayer( ply )
			undo.AddEntity( prop )
		undo.Finish( "Effect (" .. tostring( model ) .. ")" )
	end
	return prop
end

function nzMapping:Electric(pos, ang,limited,aoe, ply)
	--THERE CAN ONLY BE ONE TRUE HERO, actually thats cap this is my zombie acadummya
	--local prevs = ents.FindByClass("power_box")
	--if prevs[1] != nil then
	--	prevs[1]:Remove()
	--end

	local ent = ents.Create( "power_box" )
	ent:SetPos( pos )
	ent:SetAngles( ang )
	ent:SetLimited(limited)
	ent:SetAOE(aoe or 1000)
	ent:Spawn()
	ent:PhysicsInit( SOLID_VPHYSICS )

	local phys = ent:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end

	if ply then
		undo.Create( "Power Switch" )
			undo.SetPlayer( ply )
			undo.AddEntity( ent )
		undo.Finish( "Effect (" .. tostring( model ) .. ")" )
	end
	return ent
end

function nzMapping:BlockSpawn(pos, ang, model, flags, ply)
	local block = ents.Create( "wall_block" )
	
	-- Replace with nZombies versions of the same model (if exist) which are grate-based (bullets go through)
	local model2 = string.Replace(model, "/hunter/plates/", "/nzombies_plates/")
	if !util.IsValidModel(model2) then
		model2 = model
	end
	print(model2)
	
	block:SetModel( model2 )
	block:SetPos( pos )
	block:SetAngles( ang )
	block:Spawn()
	block:PhysicsInit( SOLID_VPHYSICS )
	print(block:GetModel())

	-- REMINDER APPLY FLAGS
	if flags != nil then
		nzDoors:CreateLink( block, flags )
	end
	
	local phys = block:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end

	if ply then
		undo.Create( "Invisible Block" )
			undo.SetPlayer( ply )
			undo.AddEntity( block )
		undo.Finish( "Effect (" .. tostring( model ) .. ")" )
	end
	return block
end

function nzMapping:BoxSpawn(pos, ang, spawn, ply)
	local box = ents.Create( "random_box_spawns" )
	box:SetPos( pos )
	box:SetAngles( ang )
	box:Spawn()
	box:PhysicsInit( SOLID_VPHYSICS )
	box:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	box.PossibleSpawn = spawn

	if ply then
		undo.Create( "Random Box Spawnpoint" )
			undo.SetPlayer( ply )
			undo.AddEntity( box )
		undo.Finish( "Effect (" .. tostring( model ) .. ")" )
	end
	return box
end

function nzMapping:PerkMachine(pos, ang, id, ply)
	if id == "wunderfizz" then
		local perk = ents.Create("wunderfizz_machine")
		perk:SetPos(pos)
		perk:SetAngles(ang)
		perk:Spawn()
		perk:Activate()
		perk:PhysicsInit( SOLID_VPHYSICS )
		perk:TurnOff()

		local phys = perk:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
		end

		if ply then
			undo.Create( "Der Wunderfizz" )
				undo.SetPlayer( ply )
				undo.AddEntity( perk )
			undo.Finish( "Effect (" .. tostring( model ) .. ")" )
		end
		return perk
	else
		local perkData = nzPerks:Get(id)

		local perk = ents.Create("perk_machine")
		perk:SetPerkID(id)
		perk:TurnOff()
		perk:SetPos(pos)
		perk:SetAngles(ang)
		perk:Spawn()
		perk:Activate()
		perk:PhysicsInit( SOLID_VPHYSICS )

		local phys = perk:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
		end

		if ply then
			undo.Create( "Perk Machine" )
				undo.SetPlayer( ply )
				undo.AddEntity( perk )
			undo.Finish( "Effect (" .. tostring( model ) .. ")" )
		end
		return perk
	end
end
function nzMapping:LoadBench(pos,ang,reward,parts,craft)
print("loadbench")
		local bench = ents.Create("buildable_table")
		bench:SetPos(pos)
		bench:SetAngles(ang)
		bench:Spawn()
		bench:Activate()
		bench:PhysicsInit( SOLID_VPHYSICS )
		bench.Craftables = reward
		bench.ValidItems = parts
		
end
function nzMapping:Bench(postbl, angtbl, wepn, hudtext, modelreward, entbool, perkbool, code, itempos, entpos,id1,mat1a,mat1b,mat1c,id2,mat2a,mat2b,mat2c,id3,mat3a,mat3b,mat3c,angl,name,ply)
		local bench = ents.Create("buildable_table")
		bench:SetPos(postbl)
		bench:SetAngles(angtbl)
		bench:PhysicsInit( SOLID_VPHYSICS )
		if entbool and code then
		if perkbool then
		local buildabletbl = {
	model = modelreward,
	pos = itempos,
	ang = angl,
	parts = {
		[id1] = {mat1a},
		[id2] = {mat2a},
		[id3] = {mat3a},
		-- You can have as many as you want
	},
	usefunc = function(self, ply) -- When it's completed and a player presses E (optional)
	nzMapping:PerkMachine(entpos,Angle(0,0,0), code, ply)
	end,
	text = hudtext
}

		else
		local buildabletbl = {
	model = modelreward,
	pos = itempos,
	ang = angl,
	parts = {
		[id1] = {mat1a},
		[id2] = {mat2a},
		[id3] = {mat3a},
	},
	usefunc = function(self, ply) -- When it's completed and a player presses E (optional)
		if code =="power" then
		print("power switch")
		end
		if code == "teleporter" then
		print("teleporter")
		end
	end,
	text = hudtext
}
end
		
		else
		local wep = weapons.Get(wepn)
		local inputang = angl
		local angTBL = string.Explode( ",", inputang )
		local inputpos = itempos
		local posTBL = string.Explode( ",", inputpos )
		local buildabletbl = {
		
	model = wep.WorldModel,
	pos = Vector(tonumber(posTBL[1]),tonumber(posTBL[2]),tonumber(posTBL[3])),
	ang =Angle(tonumber(angTBL[1]),tonumber(angTBL[2]),tonumber(angTBL[3])),
	parts = {
		[id1] = {mat1a,mat1b,mat1c},
		[id2] = {mat2a,mat2b,mat2c},
		[id3] = {mat3a,mat3b,mat3c},
		-- You can have as many as you want
	},
	usefunc = function(self, ply) -- When it's completed and a player presses E (optional)
		if !ply:HasWeapon(wepn) then
			ply:Give(wepn)
		end
	end, 
	text = hudtext
}
bench:AddValidCraft(name, buildabletbl)
end

		
		local phys = bench:GetPhysicsObject()
		if phys:IsValid() then
			phys:EnableMotion(false)
		end
		bench:Spawn()
		if ply then
			undo.Create( "Bench" )
				undo.SetPlayer( ply )
				undo.AddEntity( bench )
			undo.Finish( "Effect (" .. tostring( model ) .. ")" )
		end
		return bench
	
end

function nzMapping:BreakEntry(pos, ang, planks, jump, boardtype, prop, ply)
	local planks = planks
	if planks == nil then planks = true else planks = tobool(planks) end
	local jump = jump
	if jump == nil then jump = false else jump = tobool(jump) end
	--[[local classic = classic
	if classic == nil then classic = false else classic = tobool(classic) end]]
	local boardtype = boardtype
	if boardtype == nil then boardtype = 1 else boardtype = boardtype end

	local entry = ents.Create( "breakable_entry" )
	entry:SetPos( pos )
	entry:SetAngles( ang )
	entry:SetHasPlanks(planks)
	entry:SetTriggerJumps(jump)
	--entry:SetClassicPatern(classic)
	entry:SetBoardType(boardtype)
	entry:SetProp( prop )
	entry:Spawn()
	entry:PhysicsInit( SOLID_VPHYSICS )


	local phys = entry:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end

	if ply then
		undo.Create( "Barricade" )
			undo.SetPlayer( ply )
			undo.AddEntity( entry )
		undo.Finish( "Effect (" .. tostring( model ) .. ")" )
	end
	return entry
end

function nzMapping:SpawnEffect( pos, ang, model, ply )

	local e = ents.Create("nz_prop_effect")
	e:SetModel(model)
	e:SetPos(pos)
	e:SetAngles( ang )
	e:Spawn()
	e:Activate()
	if ( !IsValid( e ) ) then return end

	if ply then
		undo.Create( "Effect" )
			undo.SetPlayer( ply )
			undo.AddEntity( e )
		undo.Finish( "Effect (" .. tostring( model ) .. ")" )
	end
	return e

end
	
function nzMapping:Teleporter( pos, ang,dest,id,price,modeltype,anim,cd,kino, kinodur,buyable, ply )
print(buyable)
	local tele = ents.Create("nz_teleporter")
	tele:SetPos(pos)
	tele:SetAngles( ang )
	tele:SetDestination(dest)
	tele:SetID(id)
	tele:SetPrice(price)
	tele:SetModelType(modeltype)
	tele:SetGifType(anim)
	tele:SetCooldownTime(cd)
	tele:SetKino(kino)
	tele:SetKinodelay(kinodur)
	tele:SetUsable(buyable)
	tele:TurnOff()
	tele:Spawn()
	local phys = tele:GetPhysicsObject()
	if phys:IsValid() then
		phys:EnableMotion(false)
	end

	if ply then
		undo.Create( "Teleporter" )
			undo.SetPlayer( ply )
			undo.AddEntity( tele )
		undo.Finish( "Teleporter (" .. tostring( model ) .. ")" )
	end
	return tele

end

function nzMapping:SpawnEntity(pos, ang, ent, ply)
	local entity = ents.Create( ent )
	entity:SetPos( pos )
	entity:SetAngles( ang )
	entity:Spawn()
	entity:PhysicsInit( SOLID_VPHYSICS )

	table.insert(nzQMenu.Data.SpawnedEntities, entity)

	entity:CallOnRemove("nzSpawnedEntityClean", function(ent)
		table.RemoveByValue(nzQMenu.Data.SpawnedEntities, ent)
	end)

	if ply then
		undo.Create( "Entity" )
			undo.SetPlayer( ply )
			undo.AddEntity( entity )
		undo.Finish( "Effect (" .. tostring( model ) .. ")" )
	end
	return entity
end

function nzMapping:CreateInvisibleWall(vec1, vec2, ply)
	local wall = ents.Create( "invis_wall" )
	wall:SetPos( vec1 ) -- Later we might make the position the center
	--wall:SetAngles( ang )
	--wall:SetMinBound(vec1) -- Just the position for now
	wall:SetMaxBound(vec2)
	wall:Spawn()
	wall:PhysicsInitBox( Vector(0,0,0), vec2 )

	local phys = wall:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end

	if ply then
		undo.Create( "Invis Wall" )
			undo.SetPlayer( ply )
			undo.AddEntity( wall )
		undo.Finish( "Effect (" .. tostring( model ) .. ")" )
	end
	return wall
end

function nzMapping:CreateAntiCheatExclusion(vec1, vec2, ply)
	local wall = ents.Create( "anticheat_exclude" )
	wall:SetPos( vec1 ) -- Later we might make the position the center
	--wall:SetAngles( ang )
	--wall:SetMinBound(vec1) -- Just the position for now
	wall:SetMaxBound(vec2)
	wall:Spawn()
	wall:PhysicsInitBox( Vector(0,0,0), vec2 )

	local phys = wall:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end

	if ply then
		undo.Create( "Anti-Cheat Exclusion" )
			undo.SetPlayer( ply )
			undo.AddEntity( wall )
		undo.Finish( "Effect (" .. tostring( model ) .. ")" )
	end
	return wall
end

function nzMapping:CreateInvisibleDamageWall(vec1, vec2, ply, dmg, delay, radiation, poison, tesla)
	local wall = ents.Create( "invis_damage_wall" )
	wall:SetPos( vec1 )
	wall:SetMaxBound(vec2)
	wall:Spawn()
	wall:PhysicsInitBox( Vector(0,0,0), vec2 )
	wall:SetNotSolid(true)
	wall:SetTrigger(true)
	wall:SetDamage(dmg)
	wall:SetDelay(delay)

	wall:SetRadiation(radiation)
	wall:SetPoison(poison)
	wall:SetTesla(tesla)

	local phys = wall:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end

	if ply then
		undo.Create( "Damage Wall" )
			undo.SetPlayer( ply )
			undo.AddEntity( wall )
		undo.Finish( "Effect (" .. tostring( model ) .. ")" )
	end
	return wall
end

-- Physgun Hooks
local ghostentities = {
    ["prop_buys"] = true,
    ["wall_block"] = true,
    ["breakable_entry"] = true,
    ["invis_wall"] = true,
    ["invis_wall_zombie"] = true,
    ["jumptrav_block"] = true,
    --["wall_buys"] = true,
}
local function onPhysgunPickup( ply, ent )
	local class = ent:GetClass()
	if ghostentities[class] or ent:ShouldPhysgunNoCollide() then
		-- Ghost the entity so we can put them in walls.
		local phys = ent:GetPhysicsObject()
		phys:EnableCollisions(false)
		phys:Wake()
	end

end

local function onPhysgunDrop( ply, ent )
	local class = ent:GetClass()
	if ghostentities[class] or ent:ShouldPhysgunNoCollide() then
		-- Unghost the entity so we can put them in walls.
		local phys = ent:GetPhysicsObject()
		phys:EnableCollisions(true)
		phys:EnableMotion(false)
		phys:Sleep()
	end

end

hook.Add( "PhysgunPickup", "nz.OnPhysPick", onPhysgunPickup )
hook.Add( "PhysgunDrop", "nz.OnDrop", onPhysgunDrop )
