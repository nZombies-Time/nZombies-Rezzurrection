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
	local total = {}

	for _,v in nzLevel.GetZombieArray() do
		if v:IsValidZombie() and !v.NZBossType and !v.IsMooBossZombie then
			highesttime = highesttime + math.Rand(0.15, 0.45)

			v:SetRunSpeed(1)
			v:SpeedChanged()
			v.MarkedForDeath = true
			v:SetBlockAttack(true)

			-- In Serverside related stuff, timers are fine.
			timer.Simple(highesttime, function()
				if IsValid(v) then
					if math.random(5) <= 2 then
						if v.IsMooZombie and !v.IsMooSpecial then
							v:GibHead()
						end
					end

					local insta = DamageInfo()
					insta:SetAttacker(Entity(0))
					insta:SetDamageType(DMG_BLAST)
					insta:SetDamage(v:Health() + 666)
					
					v:TakeDamageInfo(insta)

					v:Ignite(5)
					v:EmitSound("nz_moo/powerups/nuke_ignite.mp3", 511)	
					v:EmitSound("nz_moo/zombies/vox/nuke_death/soul_0"..math.random(0,10)..".mp3", 75, math.random(85,115))	
					
					table.insert(total, v)
				end
			end)
		end
	end
	
	-- Give the players a set amount of points
	if not nopoints then
		timer.Simple(highesttime, function()
			for k,v in pairs(player.GetAllPlaying()) do
				if v:IsPlayer() then
					v:GivePoints(400)
					if #total == 1 then
						if !v.MOOS_FAV_THING_TO_SAY_ON_NUKES_TM and TFA.BO3GiveAchievement then
      						TFA.BO3GiveAchievement("Weapon of Minor Destruction", "vgui/overlay/achievment/Weapon_of_Minor_Destruction_WaW.png", v)
    						v.MOOS_FAV_THING_TO_SAY_ON_NUKES_TM = true
						end
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
	-- Repair them all, More nZU code? no way.
	local pos = pos or Vector()
	local barricades = ents.FindByClass("breakable_entry")
	local max = 0
	local repaired = 0
	local PowerupData = self:Get("carpenter")
	for k,v in pairs(barricades) do
		local t = v:GetPos():Distance(pos)/2000 -- 1 second for every 2,000 units
		if t > max then
			max = t
		end
		timer.Simple(t, function()
			if IsValid(v) then
				if !IsValid(v.ZombieUsing) then
					v:FullRepair()
					repaired = repaired + 1
					if repaired == #barricades then
						self.ActivePowerUps["carpenter"] = (self.ActivePowerUps["carpenter"] or CurTime()) - PowerupData.duration
						for k,v in pairs(player.GetAllPlaying()) do
							if v:IsPlayer() then
								v:GivePoints(200)
							end
						end
					end
				end
			end
		end)
	end
	
	-- Give the players a set amount of points
	--[[if not nopoints then
		for k,v in pairs(player.GetAll()) do
			if v:IsPlayer() then
				v:GivePoints(200)
			end
		end
	end]]
end