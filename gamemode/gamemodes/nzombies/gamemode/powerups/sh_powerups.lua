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
				ply:GivePowerUp(id, PowerupData.duration * (ply:HasUpgrade("time") and 2 or 1))
			end
		else
			if PowerupData.duration ~= 0 then
				-- Activate for a certain time
				if not self.ActivePowerUps[id] then
					PowerupData.func(id, ply)
				end
				self.ActivePowerUps[id] = (self.ActivePowerUps[id] or CurTime()) + PowerupData.duration * ((IsValid(ply) and ply:HasUpgrade("time")) and 2 or 1)
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
		local barricades = ents.FindByClass("breakable_entry")
		local choices = {}
		local total = 0

		-- Chance it
		if not specific then
			for k, v in pairs(self.Data) do
				if k == "zombieblood" and #player.GetAllPlaying() <= 1 then continue end
				if k == "bonfiresale" and not nzPowerUps:GetHasPaped() then continue end
				if k == "deathmachine" and player.GetCount() <= 1 and (not Entity(1):HasPerk('revive')) then continue end
				if k == "firesale" and not nzPowerUps:GetBoxMoved() then continue end
				if k == "bottle" then continue end -- Me when a chance of zero doesn't matter and will still drop anyways.
				if k == "carpenter" then
					if #barricades >= 4 then
						local barricades_broken = 0
						for _,barricade in pairs(barricades) do 
							if barricade:GetHasPlanks() and (barricade:GetNumPlanks() <= 0) then
								barricades_broken = barricades_broken + 1
							end
						end

						if (barricades_broken < 5) then
							continue
						end
					else
						continue
					end
				end

				if k ~= "ActivePowerUps" then
					choices[k] = v.chance
					total = total + v.chance
				end
			end
		end

		local id = specific and specific or nzMisc.WeightedRandom(choices)
		if not id or id == "null" then return end --  Back out

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
		net.Start("nzPowerUps.PickupHud")
			net.WriteString("Max Ammo!")
			net.WriteBool(true)
		net.Broadcast()

		-- Give everyone ammo
		for k,v in pairs(player.GetAll()) do
			v:GiveMaxAmmo()
		end
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
		net.Start("nzPowerUps.PickupHud")
			net.WriteString("Ka-Boom!")
			net.WriteBool(false)
		net.Broadcast()

		nzPowerUps:Nuke(ply:GetPos())
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
		nzPowerUps:FireSale()
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
	duration = 7,
	loopsound = "nz_moo/powerups/carpenter_loop_classic.wav",
	stopsound = "nz_moo/powerups/carpenter_end_classic.mp3",
	func = (function(self, ply)
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
		ply:SetTargetPriority(TARGET_PRIORITY_NONE)
	end),
	expirefunc = function(self, ply) -- ply is only passed if the powerup is non-global
		if IsValid(ply) then
			ply:SetTargetPriority(TARGET_PRIORITY_PLAYER)
		end
	end,
})

//Lightning is power
nzPowerUps:NewPowerUp("deathmachine", {
	name = "Death Machine",
	model = "models/powerups/w_deathmachine.mdl",
	global = false,
	angle = Angle(0,0,0),
	scale = 1,
	chance = 5,
	duration = 30,
	announcement = "nz/powerups/deathmachine.mp3",
	func = (function(self, ply)
		if IsValid(ply) then
			ply:SetUsingSpecialWeapon(true)
			ply:Give("tfa_nz_bo3_minigun")
			ply:SelectWeapon("tfa_nz_bo3_minigun")
		end
	end),
	expirefunc = function(self, ply)
		if IsValid(ply) then
			ply:SetUsingSpecialWeapon(false)
			ply:EquipPreviousWeapon()
			timer.Simple(0, function()
				if not IsValid(ply) then return end
				ply:StripWeapon("tfa_nz_bo3_minigun")
			end)
		end
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
		for k, v in pairs(player.GetAllPlaying()) do
			v:GivePoints(BONUS)
		end
    end),
})

--Perk Bottle
--[[nzPowerUps:NewPowerUp("bottle", {
    name = "Perk Bottle",
    model = "models/powerups/w_perkbottle.mdl",
    global = true,
    angle = Angle(0,0,0),
    scale = 1,
    chance = 3,
    duration = 0,
    announcement = "",
    func = (function(self, ply)
    	local P = GetConVar("nz_difficulty_perks_max"):GetInt()
        GetConVar("nz_difficulty_perks_max"):SetInt(P+1)
    end),
})]]

-- Perk Bottle(The one that actually gives you a perk)
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
		net.Start("nzPowerUps.PickupHud")
			net.WriteString("Free Perk!")
			net.WriteBool(true)
		net.Send(ply)

		local available = nzMapping.Settings.wunderfizzperks or nzPerks:GetList()
		local blockedperks = {
			["wunderfizz"] = true,
			["pap"] = true,
			["gum"] = true,
		}

		local tbl = {}
		for k, v in pairs(available) do
			if not ply:HasPerk(k) and not blockedperks[k] then
				table.insert(tbl, k)
			end
		end
		if table.IsEmpty(tbl) then nzSounds:PlayEnt("Laugh", ply) end

		ply:GivePerk(tbl[math.random(#tbl)])
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
    end),
})
