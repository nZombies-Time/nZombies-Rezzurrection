-- 

hook.Add("Think", "CheckActivePowerups", function()
	for k,v in pairs(nzPowerUps.ActivePowerUps) do
		if CurTime() >= v then
			local func = nzPowerUps:Get(k).expirefunc
			if func then func(id) end
			nzPowerUps.ActivePowerUps[k] = nil
			nzPowerUps:SendSync()
		end
	end
	for k,v in pairs(nzPowerUps.ActivePlayerPowerUps) do
		if not IsValid(k) then
			nzPowerUps.ActivePlayerPowerUps[k] = nil
			nzPowerUps:SendPlayerSyncFull()
		else
			for id, time in pairs(v) do
				if CurTime() >= time then
					local func = nzPowerUps:Get(id).expirefunc
					if func then func(id, k) end
					nzPowerUps.ActivePlayerPowerUps[k][id] = nil
					nzPowerUps:SendPlayerSync(k)
				end
			end
		end
	end
end)


function nzPowerUps:Nuke(pos, nopoints, noeffect)
	-- Kill them all
	local highesttime = 0
	if pos and type(pos) == "Vector" then
		for k,v in pairs(ents.GetAll()) do
			if v:IsValidZombie() and !v.NZBossType then
				if IsValid(v) then
					v:SetBlockAttack(true) -- They cannot attack now!
					-- Delay the death by the distance from the position in milliseconds
					local time = v:GetPos():Distance(pos)/2000
					if time > highesttime then highesttime = time end
					timer.Simple(time, function()
						if IsValid(v) then
							v:Remove() --Zombies remove now cause nukes like to crash the game on the old method.
							if nzRound:InProgress() then
								nzRound:SetZombiesKilled( nzRound:GetZombiesKilled() + 1 ) -- Zombies dying from a nuke actually count towards the round now.
							end
						end
					end)
				end
			end
		end
	else
		for k,v in pairs(ents.GetAll()) do
			if v:IsValidZombie() and !v.NZBossType then
				print(v, IsValid(v))
				if IsValid(v) then
					timer.Simple(0.1, function()
						if IsValid(v) then
							v:Remove()
							if nzRound:InProgress() then
								nzRound:SetZombiesKilled( nzRound:GetZombiesKilled() + 1 ) -- Zombies dying from a nuke actually count towards the round now.
							end
						end
					end)
				end
			end
		end
	end
	
	-- Give the players a set amount of points
	if not nopoints then
		timer.Simple(highesttime, function()
			if nzRound:InProgress() then -- Only if the game is still going!
				for k,v in pairs(player.GetAll()) do
					if v:IsPlayer() then
						v:GivePoints(400)
					end
				end
			end
		end)
	end
	
	if not noeffect then
		net.Start("nzPowerUps.Nuke")
		net.Broadcast()
	end
end

-- Add the sound so we can stop it again
sound.Add( {
	name = "nz_firesale_jingle",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 75,
	pitch = { 100, 100 },
	sound = "nz_moo/powerups/firesale_jingle.mp3"
} )

function nzPowerUps:FireSale()
	--print("Running")
	-- Get all spawns
	local all = ents.FindByClass("random_box_spawns")
	
	for k,v in pairs(all) do
		if not IsValid(v.Box) then
			local box = ents.Create( "random_box" )
			local pos = v:GetPos()
			local ang = v:GetAngles()
			
			box:SetPos( pos + ang:Up()*10 + ang:Right()*7 )
			box:SetAngles( ang )
			box:Spawn()
			--box:PhysicsInit( SOLID_VPHYSICS )
			box.SpawnPoint = v
			v.FireSaleBox = box
			
			v:SetBodygroup(1,1)

			local phys = box:GetPhysicsObject()
			if phys:IsValid() then
				phys:EnableMotion(false)
			end
			
			box:EmitSound("nz_firesale_jingle")
		else
			local sound = ents.Create("nz_prop_effect_attachment")
			sound:SetNoDraw(true)
			sound:SetPos(v:GetPos())
			sound:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			sound:Spawn()
			sound:EmitSound("nz_firesale_jingle")
			v.FireSaleBox = sound
		end
	end
end

function nzPowerUps:CleanUp()
	-- Clear all powerups
	for k,v in pairs(ents.FindByClass("drop_powerup")) do
		v:Remove()
	end
	
	-- Turn off all modifiers
	table.Empty(self.ActivePowerUps)
	-- Sync
	self:SendSync()
end

function nzPowerUps:Carpenter(nopoints)
	-- Repair them all
	for k,v in pairs(ents.FindByClass("breakable_entry")) do
		if v:IsValid() then
			for i=1, GetConVar("nz_difficulty_barricade_planks_max"):GetInt() do
				if i > #v.Planks then -- The barricades actually use the animated function now... So they look extra fancy when a Carpenter is active.
					v:AddPlank()
				end
			end
		end	
	end
	
	-- Give the players a set amount of points
	if not nopoints then
		for k,v in pairs(player.GetAll()) do
			if v:IsPlayer() then
				v:GivePoints(200)
			end
		end
	end
end