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


	--[[ Moo Mark 7/14/23:
		Added a drop cycle system to closer mimic
		how drops are handled in the real games.
		This will insure that you only ever get
		one of each drop per cycle.
		A cycle will be completed once the core four
		drops have appeared, these include: Insta-Kill, Double Points, Nuke, and Max Ammo.
		There is still some RNG involved but this makes drops more predictable and can
		also allow players to manipulate it by meeting criteria that stop other drops from spawning.
	]]
	local dropsthisround = 0
	local maxdrops = 4
	local dropped = {}
	local possibledrops = {}
	local coredrops = {}

	hook.Add("OnRoundStart", "NODROPSFUCKU", function() 
		dropsthisround = 0
		if nzRound:IsSpecial() then
			maxdrops = 0 -- No drops on special rounds :wind_blowing_face:
		else
			maxdrops = 4
		end
		if nzRound:GetNumber() <= 1 then -- Reset everything on the first round... Or negative one... For some fucking reason idk, Justin Case.
			coredrops = {}
			dropped = {}
			possibledrops = {}
		end
	end)

	function nzPowerUps:SpawnPowerUp(pos, specific)
		if specific or dropsthisround < maxdrops then -- If the drop is specific then it should ALWAYS spawn no matter what.

			local barricades = ents.FindByClass("breakable_entry")
			local choices = {}

			-- Queue all possible powerups
			if not specific then
				for k, v in pairs(self.Data) do
					if k ~= "maxammo" and nzRound:IsSpecial() then continue end -- Only allow max ammos on special rounds.

					if k == "zombieblood" and #player.GetAllPlaying() <= 1 then continue end
					if k == "deathmachine" and player.GetCount() <= 1 and (not Entity(1):HasPerk('revive')) then continue end
					if k == "firesale" and !nzPowerUps:GetBoxMoved() then continue end
					if k == "bottle" then continue end -- Me when a chance of zero doesn't matter and will still drop anyways.
					if k == "bonfiresale" and !v.natural then continue end -- These no longer spawn naturally, only through bosses.
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

					if k ~= "ActivePowerUps" and !dropped[k] then
						table.insert(possibledrops, k) -- Only insert the ones that haven't dropped yet or met the criteria to drop.
					end
				end
			end

			local powup = possibledrops[math.random(#possibledrops)] -- Now select a random powerup.

			local id = specific and specific or powup
			if not id or id == "null" then return end --  Back out

			local ent = ents.Create("drop_powerup")
			id = hook.Call("OnPowerUpSpawned", nil, id, ent) or id
			if not IsValid(ent) then return end -- If a hook removed the powerup

			-- Spawn it
			local PowerupData = self:Get(id)

			local pos = pos + Vector(0, 0, 50)

			ent:SetPowerUp(id)
			pos.z = pos.z - ent:OBBMaxs().z
			ent:SetModel(PowerupData.model)
			ent:SetPos(pos)
			ent:SetAngles(PowerupData.angle)
			ent:Spawn()

			if id ~= specific and !specific then -- If the drop was specific/set, then it was probably important thus not having it count towards the cycle.
				if id == "insta" or id == "dp" or id == "maxammo" or id == "nuke" then
					table.insert(coredrops, id)
				end

				dropsthisround = dropsthisround + 1
				dropped[powup] = true

				if table.Count(coredrops) >= 4 then -- All of the core drops dropped... Reset the cycle.
					coredrops = {}
					dropped = {}
				end
			end

			PrintTable(possibledrops)
			possibledrops = {}

			-- PrintTable(coredrops)
			-- print(dropsthisround)
		end
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
	if not self.ActivePlayerPowerUps[ply] then self.ActivePlayerPowerUps[ply] = {} end
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
	natural = true,
	announcement = "nz/powerups/double_points.mp3",
	loopsound = "nz_moo/powerups/doublepoints_loop_zhd.wav",
	stopsound = "nz_moo/powerups/doublepoints_end.mp3",
	func = function(self, ply)
		if nzMapping.Settings.negative then
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
	model = "models/powerups/w_maxammo.mdl",
	global = true,
	angle = Angle(0,0,25),
	scale = 1,
	chance = 5,
	duration = 0,
	natural = true,
	func = (function(self, ply)
		nzSounds:Play("MaxAmmo")
		net.Start("nzPowerUps.PickupHud")
			net.WriteString("Max Ammo!")
			net.WriteBool(true)
		net.Broadcast()
		-- Give everyone ammo
		if nzMapping.Settings.negative then
			if math.random(3) == 3 then
				for k,v in pairs(player.GetAll()) do
					v:ChatPrint( "Thank Joe Biden for this" )
					v:RemoveAllAmmo()
				end
			else
				for k,v in pairs(player.GetAll()) do
					v:GiveMaxAmmo()
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
	model = "models/powerups/w_insta.mdl",
	global = true,
	angle = Angle(0,0,0),
	scale = 1,
	chance = 5,
	duration = 30,
	natural = true,
	announcement = "nz/powerups/insta_kill.mp3",
	loopsound = "nz_moo/powerups/instakill_loop_zhd.wav",
	stopsound = "nz_moo/powerups/instakill_end.mp3",
	func = function(self, ply)
		if nzMapping.Settings.negative then
			if math.random(1) == 1 then
				ply:SetHealth(1)
				ply:ChatPrint( "FIGHT FOR YOUR LIFE" )
			end
		end
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
	natural = true,
	announcement = "nz/powerups/nuke.wav",
	func = (function(self, ply)
		net.Start("nzPowerUps.PickupHud")
			net.WriteString("Ka-Boom!")
			net.WriteBool(false)
		net.Broadcast()

		if nzMapping.Settings.negative then
			if math.random(1) == 1 then
				nzPowerUps:Nuke(ply:GetPos())
			else
				PrintMessage( HUD_PRINTTALK, "Who didn't pay electric bill?!" )
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
	model = "models/powerups/w_firesale.mdl",
	global = true,
	angle = Angle(45,0,0),
	scale = 0.75,
	chance = 1,
	duration = 30,
	natural = true,
	announcement = "nz/powerups/fire_sale_announcer.wav",
	--loopsound = "nz_moo/powerups/firesale_jingle.mp3", -- This makes the Firesale Jingle 2d. Its also a good way to prank Youtubers by giving them a Copyright Claim! Now thats what I call goofy.
	stopsound = "nz_moo/powerups/doublepoints_end.mp3",
	func = (function(self, ply)
		if nzMapping.Settings.negative then
			if math.random(0,3) == 3 then
				nzPowerUps:FireSale()
			else
				for k,v in pairs(player.GetAll()) do
					v:ChatPrint( "Stop Gambling Addictions Today" )
					local tbl = ents.FindByClass("random_box_spawns")
					for k,v in pairs(tbl) do
						if IsValid(v) then
							v:StopSound("nz_firesale_jingle")
							v:Remove()
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
	model = "models/powerups/w_carpenter.mdl",
	global = true,
	angle = Angle(45,0,0),
	scale = 1,
	chance = 5,
	duration = 7,
	natural = true,
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
	natural = true,
	announcement = "nz/powerups/zombie_blood.wav",
	loopsound = "nz_moo/powerups/zombieblood_loop.wav",
	stopsound = "nz_moo/powerups/zombieblood_stop.mp3",
	func = (function(self, ply)
		if nzMapping.Settings.negative then
			if math.random(1) == 1 then
				ply:SetTargetPriority(TARGET_PRIORITY_SPECIAL)
				local zombls = ents.FindInSphere(ply:GetPos(), 5000)
				for k,v in pairs(zombls) do
					if IsValid(v) and v:IsValidZombie() then
						v:SetTarget(ply)
					end
				end
			else
				ply:SetTargetPriority(TARGET_PRIORITY_NONE)
			end
		else
			ply:SetTargetPriority(TARGET_PRIORITY_NONE)
		end
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
	chance = 2,
	duration = 30,
	natural = true,
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
	natural = true,
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
	natural = false,
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
	natural = false,
    announcement = "",
	loopsound = "nz_moo/powerups/omnov001l_1_l.wav",
	stopsound = "nz_moo/powerups/doublepoints_end.mp3",
    func = (function(self, ply)
    end),
})
