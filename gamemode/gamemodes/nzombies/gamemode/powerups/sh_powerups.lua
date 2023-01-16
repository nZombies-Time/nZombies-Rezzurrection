-- 

if SERVER then

	local plyMeta = FindMetaTable("Player")
	
	function plyMeta:GivePowerUp(id, duration)
		if duration > 0 then
			if not nzPowerUps.ActivePlayerPowerUps[self] then nzPowerUps.ActivePlayerPowerUps[self] = {} end
			
			nzPowerUps.ActivePlayerPowerUps[self][id] = (nzPowerUps.ActivePlayerPowerUps[self][id] or CurTime()) + duration
			nzPowerUps:SendPlayerSync(self) -- Sync this player's powerups
		end
	end
	
	function plyMeta:RemovePowerUp(id, nosync)
		local PowerupData = nzPowerUps:Get(id)
		if PowerupData and PowerupData.expirefunc then
			PowerupData.expirefunc(id, self) -- Call expirefunc when manually removed
		end
	
		if not nzPowerUps.ActivePlayerPowerUps[self] then nzPowerUps.ActivePlayerPowerUps[self] = {} end
		nzPowerUps.ActivePlayerPowerUps[self][id] = nil
		if not nosync then nzPowerUps:SendPlayerSync(self) end -- Sync this player's powerups
	end
	
	function plyMeta:RemoveAllPowerUps()
		if not nzPowerUps.ActivePlayerPowerUps[self] then nzPowerUps.ActivePlayerPowerUps[self] = {} return end
		
		for k,v in pairs(nzPowerUps.ActivePlayerPowerUps[self]) do
			self:RemovePowerUp(k, true)
		end
		nzPowerUps:SendPlayerSync(self)
	end
	
	function nzPowerUps:Activate(id, ply, ent)
		if hook.Call("OnPlayerPickupPowerUp", nil, ply, id, ent) then return end
		
		local PowerupData = self:Get(id)

		if not PowerupData.global then
			if IsValid(ply) then
				if not nzPowerUps.ActivePlayerPowerUps[ply] or not nzPowerUps.ActivePlayerPowerUps[ply][id] then -- If you don't have the powerup
					PowerupData.func(id, ply)
				end
				ply:GivePowerUp(id, PowerupData.duration)
			end
		else
			if PowerupData.duration ~= 0 then
				-- Activate for a certain time
				if not self.ActivePowerUps[id] then
					PowerupData.func(id, ply)
				end
				self.ActivePowerUps[id] = (self.ActivePowerUps[id] or CurTime()) + PowerupData.duration
			else
				-- Activate Once
				PowerupData.func(id, ply)
			end
			-- Sync to everyone
			self:SendSync()
			
		end

		-- Notify
		
		if IsValid(ply) then 
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
		if not specific then
			for k,v in pairs(self.Data) do
				if k ~= "ActivePowerUps" then
					choices[k] = v.chance
					total = total + v.chance
				end
			end
		end

		local id = specific and specific or nzMisc.WeightedRandom(choices)
		local barricades = ents.FindByClass("breakable_entry")

		if not id or id == "null" then return end --  Back out
		if #player.GetAllPlaying() <= 1 and id == "zombieblood" then return end
		--if id == "bottle" then return end
		if id == "bonfiresale" and not nzPowerUps:GetHasPaped() then return end
		if id == "deathmachine" and #player.GetAll() <= 1 and (not Entity(1):HasPerk('revive')) then return end
		if id == "firesale" and not nzPowerUps:GetBoxMoved() then return end
		if id == "carpenter" and (#barricades < 5) then return end


		local ent = ents.Create("drop_powerup")
		id = hook.Call("OnPowerUpSpawned", nil, id, ent) or id
		if not IsValid(ent) then return end -- If a hook removed the powerup

		-- Spawn it
		local PowerupData = self:Get(id)

		local pos = pos+Vector(0,0,50)
		
		ent:SetPowerUp(id)
		pos.z = pos.z - ent:OBBMaxs().z
		ent:SetModel(PowerupData.model)
		ent:SetPos(pos)
		ent:SetAngles(PowerupData.angle)
		ent:Spawn()
	end

end

function nzPowerUps:IsPowerupActive(id)

	local time = self.ActivePowerUps[id]

	if time ~= nil then
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
	model = "models/powerups/w_double.mdl",
	global = true, -- Global means it will appear for any player and will refresh its own time if more
	angle = Angle(25,0,0),
	scale = 1,
	chance = 5,
	duration = 30,
	announcement = "nz/powerups/double_points.mp3",
	loopsound = "nz_moo/powerups/doublepoints_loop_zhd.wav",
	stopsound = "nz_moo/powerups/doublepoints_end.mp3",
	func = function(self, ply)
		--if nzMapping.Settings.negative then
			--if math.random(0,3) == 3 then
			--	ply:TakePoints(1150)
			--	ply:ChatPrint( "115 Tax" )
		--	end
		--end
	end,
})

-- Max Ammo
nzPowerUps:NewPowerUp("maxammo", {
	name = "Max Ammo",
	model = "models/powerups/w_maxammo.mdl",
	global = true,
	angle = Angle(0,0,25),
	scale = 1,
	chance = 5,
	duration = 0,
	func = (function(self, ply)
		nzSounds:Play("MaxAmmo")

		-- Give everyone ammo
		--if nzMapping.Settings.negative then
			--if math.random(3) == 3 then
			--	for k,v in pairs(player.GetAll()) do
				--	v:ChatPrint( "Thank Joe Biden for this" )
				--	v:RemoveAllAmmo()
				--end
			--else
				for k,v in pairs(player.GetAll()) do
					v:GiveMaxAmmo()
				end	
			--end
		--else
			--for k,v in pairs(player.GetAll()) do
			--	v:GiveMaxAmmo()
			--end
		--end
	end),
})

-- Insta Kill
nzPowerUps:NewPowerUp("insta", {
	name = "Insta Kill",
	model = "models/powerups/w_insta.mdl",
	global = true,
	angle = Angle(0,0,0),
	scale = 1,
	chance = 5,
	duration = 30,
	announcement = "nz/powerups/insta_kill.mp3",
	loopsound = "nz_moo/powerups/instakill_loop_zhd.wav",
	stopsound = "nz_moo/powerups/instakill_end.mp3",
	func = function(self, ply)
		--if nzMapping.Settings.negative then
			--if math.random(1) == 1 then
				--ply:SetHealth(1)
				--ply:ChatPrint( "FIGHT FOR YOUR LIFE" )
			--end
		--end
	end,
})

-- Nuke
nzPowerUps:NewPowerUp("nuke", {
	name = "Nuke",
	model = "models/powerups/w_nuke.mdl",
	global = true,
	angle = Angle(10,0,0),
	scale = 1,
	chance = 5,
	duration = 0,
	announcement = "nz/powerups/nuke.wav",
	func = (function(self, ply)
		--if nzMapping.Settings.negative then
		--	if math.random(1) == 1 then
			--	nzPowerUps:Nuke(ply:GetPos())
			--else
			--	for k,v in pairs(player.GetAll()) do
				--	v:ChatPrint( "Who didn't pay electric bill?!" )
				--end
			--	nzElec:Reset()
			--end
		--else
			nzPowerUps:Nuke(ply:GetPos())
		--end
	end),
})

-- Fire Sale
nzPowerUps:NewPowerUp("firesale", {
	name = "Fire Sale",
	model = "models/powerups/w_firesale.mdl",
	global = true,
	angle = Angle(45,0,0),
	scale = 0.75,
	chance = 1,
	duration = 30,
	announcement = "nz/powerups/fire_sale_announcer.wav",
	--loopsound = "nz_moo/powerups/firesale_jingle.mp3", -- This makes the Firesale Jingle 2d. Its also a good way to prank Youtubers by giving them a Copyright Claim! Now thats what I call goofy.
	stopsound = "nz_moo/powerups/doublepoints_end.mp3",
	func = (function(self, ply)
		--if nzMapping.Settings.negative then
			--if math.random(0,3) == 3 then
			--	nzPowerUps:FireSale()
			--else
			--	for k,v in pairs(player.GetAll()) do
				--	v:ChatPrint( "Stop Gambling Addictions Today" )
					--local tbl = ents.FindByClass("random_box_spawns")
					--for k,v in pairs(tbl) do
					--	if IsValid(v) then
						--	v:StopSound("nz_firesale_jingle")
						--	v:Remove()
						--end
					--end
				--end
			--end
		--else
			nzPowerUps:FireSale()
		--end
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
	model = "models/powerups/w_carpenter.mdl",
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
	model = "models/powerups/w_zombieblood.mdl",
	global = false, -- Only applies to the player picking it up and time is handled individually per player
	angle = Angle(0,0,0),
	scale = 1,
	chance = 2,
	duration = 30,
	announcement = "nz/powerups/zombie_blood.wav",
	loopsound = "nz_moo/powerups/zombieblood_loop.wav",
	stopsound = "nz_moo/powerups/zombieblood_stop.mp3",
	func = (function(self, ply)
		--if nzMapping.Settings.negative then
			--if math.random(1) == 1 then
				--ply:SetTargetPriority(TARGET_PRIORITY_SPECIAL)
				--local zombls = ents.FindInSphere(ply:GetPos(), 5000)
				--for k,v in pairs(zombls) do
					--if IsValid(v) and v:IsValidZombie() then
						--v:SetTarget(ply)
					--end
				--end
			--else
				--ply:SetTargetPriority(TARGET_PRIORITY_NONE)
			--end
		--else
			ply:SetTargetPriority(TARGET_PRIORITY_NONE)
		--end
	end),
	expirefunc = function(self, ply) -- ply is only passed if the powerup is non-global
		ply:SetTargetPriority(TARGET_PRIORITY_PLAYER)
	end,
})

-- Death Machine
nzPowerUps:NewPowerUp("deathmachine", {
	name = "Death Machine",
	model = "models/powerups/w_deathmachine.mdl",
	global = false, -- Only applies to the player picking it up and time is handled individually per player
	angle = Angle(0,0,0),
	scale = 1,
	chance = 2,
	duration = 30,
	announcement = "nz/powerups/deathmachine.mp3",
	func = (function(self, ply)
		ply:SetUsingSpecialWeapon(true)
		ply:Give("nz_death_machine")
		ply:SelectWeapon("nz_death_machine")
	end),
	expirefunc = function(self, ply) -- ply is only passed if the powerup is non-global
		ply:SetUsingSpecialWeapon(false)
		ply:StripWeapon("nz_death_machine")
		ply:EquipPreviousWeapon()
	end,
})

--Blood Money
nzPowerUps:NewPowerUp("bonuspoints", {
    name = "Bonus Points",
    model = "models/powerups/w_zmoney.mdl",
    global = true, --Bo4 enstated that Bonus Points are Rated E for everyone!
    angle = Angle(0,0,0),
    scale = 1,
    chance = 2,
    duration = 0,
    announcement = "nz/powerups/blood_money.wav",
    func = (function(self, ply)
        local BONUS = (math.random(25,150) * 10) -- Everyone should get the same amount.
        for k,v in pairs(player.GetAllPlaying()) do
            v:GivePoints(BONUS)
        end
    end),
})

--Perk Bottle
nzPowerUps:NewPowerUp("bottle", {
    name = "Perk Bottle",
    model = "models/powerups/w_perkbottle.mdl",
    global = false,
    angle = Angle(0,0,0),
    scale = 1,
    chance = 0,
    duration = 0,
    announcement = "",
    func = (function(self, ply)
    	local blockedperks = {
			["wunderfizz"] = true, -- lol, this would happen
			["pap"] = true,
		}
		local wunderfizzlist = {}
		for k,v in pairs(nzPerks:GetList()) do
			if k != "wunderfizz" and k != "pap" then
				wunderfizzlist[k] = {true, v}
			end
		end

		local available = nzMapping.Settings.wunderfizzperklist or wunderfizzlist
		local tbl = {}
		for k,v in pairs(available) do
			if !ply:HasPerk(k) and !blockedperks[k] then
				if (v[1] == nil || v[1] == true) then
					table.insert(tbl, k)
				end
			end
		end
		if #tbl <= 0 then print("too many perks idiot") end
		local outcome = tbl[math.random(#tbl)]
		ply:GivePerk(outcome)
    end),
})
--Bonfire Sale
nzPowerUps:NewPowerUp("bonfiresale", {
    name = "BonFire Sale",
    model = "models/powerups/w_bonfire.mdl",
    global = true,
    angle = Angle(0,0,0),
    scale = 1,
    chance = 1,
    duration = 60,
    announcement = "",
	loopsound = "nz_moo/powerups/omnov001l_1_l.wav",
	stopsound = "nz_moo/powerups/doublepoints_end.mp3",
    func = (function(self, ply)
    	--print("WOW, LOOKY LOOKY A FUNNY!!!")
    end),
})
