-- 

if SERVER then

	local plyMeta = FindMetaTable("Player")
	
	function plyMeta:GivePowerUp(id, duration)
		if duration > 0 then
			if !nzPowerUps.ActivePlayerPowerUps[self] then nzPowerUps.ActivePlayerPowerUps[self] = {} end
			
			nzPowerUps.ActivePlayerPowerUps[self][id] = CurTime() + duration
			nzPowerUps:SendPlayerSync(self) -- Sync this player's powerups
		end
	end
	
	function plyMeta:RemovePowerUp(id, nosync)
		local PowerupData = nzPowerUps:Get(id)
		if PowerupData and PowerupData.expirefunc then
			PowerupData.expirefunc(id, self) -- Call expirefunc when manually removed
		end
	
		if !nzPowerUps.ActivePlayerPowerUps[self] then nzPowerUps.ActivePlayerPowerUps[self] = {} end
		nzPowerUps.ActivePlayerPowerUps[self][id] = nil
		if !nosync then nzPowerUps:SendPlayerSync(self) end -- Sync this player's powerups
	end
	
	function plyMeta:RemoveAllPowerUps()
		if !nzPowerUps.ActivePlayerPowerUps[self] then nzPowerUps.ActivePlayerPowerUps[self] = {} return end
		
		for k,v in pairs(nzPowerUps.ActivePlayerPowerUps[self]) do
			self:RemovePowerUp(k, true)
		end
		nzPowerUps:SendPlayerSync(self)
	end
	
	function nzPowerUps:Activate(id, ply, ent)
		if hook.Call("OnPlayerPickupPowerUp", nil, ply, id, ent) then return end
		
		local PowerupData = self:Get(id)

		if !PowerupData.global then
			if IsValid(ply) then
				if not nzPowerUps.ActivePlayerPowerUps[ply] or not nzPowerUps.ActivePlayerPowerUps[ply][id] then -- If you don't have the powerup
					PowerupData.func(id, ply)
				end
				ply:GivePowerUp(id, PowerupData.duration)
			end
		else
			if PowerupData.duration != 0 then
				-- Activate for a certain time
				if not self.ActivePowerUps[id] then
					PowerupData.func(id, ply)
				end
				self.ActivePowerUps[id] = CurTime() + PowerupData.duration
			else
				-- Activate Once
				PowerupData.func(id, ply)
			end
			-- Sync to everyone
			self:SendSync()
			
		end

		-- Notify
		
		if IsValid(ply) then 
			--ply:EmitSound("nz/powerups/power_up_grab.wav") 
			nzSounds:PlayEnt("Grab", ply)
		end

		-- if PowerupData.announcement then
		-- 	nzNotifications:PlaySound(PowerupData.announcement, 1)
		-- end
		if isstring(PowerupData.announcement) then
			local name = string.Replace(PowerupData.name, " ", "") -- Sound Events don't have spaces
			nzSounds:Play(name)
		end
	end

	function nzPowerUps:SpawnPowerUp(pos, specific)
		local choices = {}
		local total = 0

		-- Chance it
		if !specific then
			for k,v in pairs(self.Data) do
				if k != "ActivePowerUps" then
					choices[k] = v.chance
					total = total + v.chance
				end
			end
		end

		local id = specific and specific or nzMisc.WeightedRandom(choices)
		if !id or id == "null" then return end --  Back out
		if #player.GetAllPlaying() <= 1 and id == "zombieblood" then return end 

		
		
		local ent = ents.Create("drop_powerup")
		id = hook.Call("OnPowerUpSpawned", nil, id, ent) or id
		if !IsValid(ent) then return end -- If a hook removed the powerup

		-- Spawn it
		local PowerupData = self:Get(id)

		local pos = pos+Vector(0,0,50)
		
		ent:SetPowerUp(id)
		pos.z = pos.z - ent:OBBMaxs().z
		ent:SetModel(PowerupData.model)
		ent:SetPos(pos)
		ent:SetAngles(PowerupData.angle)
		ent:Spawn()
		--ent:EmitSound("nz/powerups/power_up_spawn.wav")
		nzSounds:PlayEnt("Spawn", ent)
	end

end

function nzPowerUps:IsPowerupActive(id)

	local time = self.ActivePowerUps[id]

	if time != nil then
		-- Check if it is still within the time.
		if CurTime() > time then
			-- Expired
			self.ActivePowerUps[id] = nil
		else
			return true
		end
	end

	return false

end

function nzPowerUps:IsPlayerPowerupActive(ply, id)

	local time = self.ActivePlayerPowerUps[ply][id]

	if time then
		-- Check if it is still within the time.
		if CurTime() > time then
			-- Expired
			self.ActivePlayerPowerUps[ply][id] = nil
		else
			return true
		end
	end

	return false

end

function nzPowerUps:AllActivePowerUps()

	return self.ActivePowerUps

end

function nzPowerUps:NewPowerUp(id, data)
	if SERVER then
		-- Sanitise any client data.
	else
		data.Func = nil
	end
	self.Data[id] = data
end

function nzPowerUps:Get(id)
	return self.Data[id]
end

-- Double Points
nzPowerUps:NewPowerUp("dp", {
	name = "Double Points",
	model = "models/poseurs/double_points.mdl",
	global = true, -- Global means it will appear for any player and will refresh its own time if more
	angle = Angle(25,0,0),
	scale = 1,
	chance = 5,
	duration = 30,
	announcement = "powerups/samantha/double_points.ogg",
	func = function(self, ply)
	if nzMapping.Settings.negative  then
		if math.random(0,3) == 3 then
	ply:TakePoints(1150)
	ply:ChatPrint( "115 Tax" )
	end
	end
	end,
})

-- Max Ammo
nzPowerUps:NewPowerUp("maxammo", {
	name = "Max Ammo",
	model = "models/poseurs/maxammo.mdl",
	global = true,
	angle = Angle(0,0,25),
	scale = 1.5,
	chance = 5,
	duration = 0,
	func = (function(self, ply)
		nzSounds:Play("MaxAmmo")
		--nzNotifications:PlaySound("nz/powerups/max_ammo.mp3", 2)
		-- Give everyone ammo
		if nzMapping.Settings.negative  then
		if math.random(0,3) == 3 then
		for k,v in pairs(player.GetAll()) do
			v:GiveMaxAmmo()
		end
		else
		for k,v in pairs(player.GetAll()) do
		v:ChatPrint( "Thank Joe Biden for this" )
		v:RemoveAllAmmo()
		end
		end
		else
		for k,v in pairs(player.GetAll()) do
			v:GiveMaxAmmo()
		end
		end
	end),
})

-- Insta Kill
nzPowerUps:NewPowerUp("insta", {
	name = "Insta Kill",
	model = "models/poseurs/instakill.mdl",
	global = true,
	angle = Angle(0,0,0),
	scale = 1,
	chance = 5,
	duration = 30,
	announcement = "nz/powerups/insta_kill.mp3",
	func = function(self, ply)
	if nzMapping.Settings.negative  then
	if math.random(0,1) == 1 then
	ply:SetHealth(1)
	ply:ChatPrint( "FIGHT FOR YOUR LIFE" )
	end
	end
	end,
})

-- Nuke
nzPowerUps:NewPowerUp("nuke", {
	name = "Nuke",
	model = "models/poseurs/nuke.mdl",
	global = true,
	angle = Angle(10,0,0),
	scale = 1,
	chance = 5,
	duration = 0,
	announcement = "powerups/samantha/nuke.ogg",
	func = (function(self, ply)
	
		
			if nzMapping.Settings.negative  then
		if math.random(0,3) == 3 then
			nzPowerUps:Nuke(ply:GetPos())
		else
		for k,v in pairs(player.GetAll()) do
		v:ChatPrint( "Who didn't pay electric bill?!" )
		end
		nzElec:Reset()
		end
		else
			nzPowerUps:Nuke(ply:GetPos())
		end
	end),
})

-- Fire Sale
nzPowerUps:NewPowerUp("firesale", {
	name = "Fire Sale",
	model = "models/poseurs/fire_sale.mdl",
	global = true,
	angle = Angle(45,0,0),
	scale = 0.75,
	chance = 1,
	duration = 30,
	announcement = "powerups/samantha/fire_sale_announcer.ogg",
	func = (function(self, ply)
		
		if nzMapping.Settings.negative  then
			if math.random(0,3) == 3 then
				nzPowerUps:FireSale()
				else
					for k,v in pairs(player.GetAll()) do
						v:ChatPrint( "Stop Gambling Addictions Today" )
							local tbl = ents.FindByClass("random_box_spawns")
							for k,v in pairs(tbl) do
								if IsValid(v) then
									v:StopSound("nz_firesale_jingle")
									v:MarkForRemoval()
								end
						end
				end
		end
		else
			nzPowerUps:FireSale()
		end
	end),
	expirefunc = function()
		local tbl = ents.FindByClass("random_box_spawns")
		for k,v in pairs(tbl) do
			local box = v.FireSaleBox
			if IsValid(box) then
				box:StopSound("nz_firesale_jingle")
				if box.MarkForRemoval then
					box:MarkForRemoval()
					box.FireSaling = false
				else
					box:Remove()
				end
			end
		end
	end,
})

-- Carpenter
nzPowerUps:NewPowerUp("carpenter", {
	name = "Carpenter",
	model = "models/poseurs/carpenter.mdl",
	global = true,
	angle = Angle(45,0,0),
	scale = 1,
	chance = 5,
	duration = 0,
	func = (function(self, ply)
		--nzNotifications:PlaySound("nz/powerups/carpenter.wav", 0)
		--nzNotifications:PlaySound("nz/powerups/carp_loop.wav", 1)
		nzSounds:Play("Carpenter")
		nzPowerUps:Carpenter()
	end),
})

-- Zombie Blood
nzPowerUps:NewPowerUp("zombieblood", {
	name = "Zombie Blood",
	model = "models/poseurs/zombie_blood.mdl",
	global = false, -- Only applies to the player picking it up and time is handled individually per player
	angle = Angle(0,0,0),
	scale = 1,
	chance = 2,
	duration = 30,
	announcement = "powerups/origins/zombie_blood.ogg",
	func = (function(self, ply)
	if nzMapping.Settings.negative  then
	if math.random(0,2) == 2 then
		ply:SetTargetPriority(TARGET_PRIORITY_NONE)
		else
		ply:SetTargetPriority(TARGET_PRIORITY_SPECIAL)
		local zombls = ents.FindInSphere(ply:GetPos(), 5000)
		for k,v in pairs(zombls) do
					if IsValid(v) and v:IsValidZombie() then
						v:SetTarget(ply)
					end
				end
			end
			else
			ply:SetTargetPriority(TARGET_PRIORITY_NONE)
		end
	end),
	expirefunc = function(self, ply) -- ply is only passed if the powerup is non-global
		ply:SetTargetPriority(TARGET_PRIORITY_PLAYER)
	end,
})

-- Death Machine
nzPowerUps:NewPowerUp("deathmachine", {
	name = "Death Machine",
	model = "models/poseurs/death_machine.mdl",
	global = false, -- Only applies to the player picking it up and time is handled individually per player
	angle = Angle(0,0,0),
	scale = 1,
	chance = 2,
	duration = 30,
	announcement = "powerups/samantha/deathmachine.ogg",
	func = (function(self, ply)
		
		if nzMapping.Settings.negative  then
		if math.random(0,3) == 4 then
		ply:SetUsingSpecialWeapon(true)
		ply:Give("nz_death_machine")
		ply:SelectWeapon("nz_death_machine")
		else
		
		ply:Give("nz_death_machine")
		ply:SelectWeapon("nz_death_machine")
		ply:SetUsingSpecialWeapon(true)
		end
	end
		ply:Give("nz_death_machine")
		ply:SelectWeapon("nz_death_machine")
		ply:SetUsingSpecialWeapon(true)
	end),
	expirefunc = function(self, ply) -- ply is only passed if the powerup is non-global
		ply:SetUsingSpecialWeapon(false)
		ply:StripWeapon("nz_death_machine")
		--ply:StripWeapon("nz_tomfoolery")
		ply:EquipPreviousWeapon()
	end,
})