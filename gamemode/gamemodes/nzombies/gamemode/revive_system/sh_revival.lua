--
local revivefailtime = 0.2

if SERVER then
	util.AddNetworkString("NZWhosWhoCurTime")
	util.AddNetworkString("NZWhosWhoReviving")

	hook.Add("Think", "CheckDownedPlayersTime", function()
		for k,v in pairs(nzRevive.Players) do
			-- The time it takes for a downed player to die - Prevent dying if being revived
			if CurTime() - v.DownTime >= GetConVar("nz_downtime"):GetFloat() and !v.ReviveTime then
				local ent = Entity(k)
				if ent.KillDownedPlayer then
					ent:KillDownedPlayer()
				else
					-- If it's a non-player entity, do the same thing just to clean up the table
					local revivor = v.RevivePlayer
					if IsValid(revivor) then
						revivor:StripWeapon("nz_revive_morphine")
					end
					nzRevive.Players[k] = nil
				end
			end
		end
	end)
end

function nzRevive.HandleRevive(ply, ent)
	-- Make sure other downed players can't revive other downed players next to them
	if !nzRevive.Players[ply:EntIndex()] then
		local tr = util.QuickTrace(ply:EyePos(), ply:GetAimVector()*100, ply)

		//local Maxs = Vector(ply:OBBMaxs().X / ply:GetModelScale(), ply:OBBMaxs().Y / ply:GetModelScale(), ply:OBBMaxs().Z / ply:GetModelScale()) 
		//local Mins = Vector(ply:OBBMins().X / ply:GetModelScale(), ply:OBBMins().Y / ply:GetModelScale(), ply:OBBMins().Z / ply:GetModelScale())

		-- Changed from line trace to view cone for reviving by: Ethorbit
		local dply = tr.Entity
		for k,v in pairs(ents.FindInCone(ply:EyePos(), ply:GetAimVector() * 120, 100, 100)) do
			if (v:IsPlayer() and v != ply) then
				dply = v
			end
		end

		local ct = CurTime()

		-- Added by Ethorbit (Don't allow reviving someone if they are already being revived!)
		-- If we do this it can cause bugs, confusion and also isn't like COD at all..
		local alreadyBeingRevived = false
		for k,v in pairs(player.GetAll()) do 		
			if (v != ply and v.Reviving == dply) then
				alreadyBeingRevived = true
				break
			end
		end
		if (alreadyBeingRevived) then return end

		-- Also added by Ethorbit (I'm pretty sure this was supposed to be in the gamemode)
		if (ply.Reviving and !IsValid(dply)) then 
			ply.Reviving:StopRevive()
			ply.Reviving = nil
		return end


		--if (ply:GetPos():Distance(dply:GetPos()) <= 20) then return end

		if IsValid(dply) and (dply:IsPlayer() or dply:GetClass() == "whoswho_downed_clone") then
			local id = dply:EntIndex()
			if nzRevive.Players[id] then
				if !nzRevive.Players[id].RevivePlayer then
					dply:StartRevive(ply)
					
					ply.WhosWhoReviving = dply:GetPerkOwner()
					if (dply:GetClass() == "whoswho_downed_clone") then
						if (IsValid(dply:GetPerkOwner())) then
							net.Start("NZWhosWhoReviving")
							net.WriteEntity(dply:GetPerkOwner())
							net.WriteBool(true)
							net.Broadcast()
						end
					end
				end

				-- print(CurTime() - nzRevive.Players[id].ReviveTime)

				if ply:HasPerk("revive") and ct - nzRevive.Players[id].ReviveTime >= 1.5 -- With quick-revive
				or ct - nzRevive.Players[id].ReviveTime >= 3.03 then	-- 3 is the time it takes to revive
					dply:RevivePlayer(ply)
					ply.Reviving = nil
				end
			end
		elseif ply.LastReviveTime ~= nil and IsValid(ply.Reviving) and ply.Reviving != dply -- Holding E on another player or no player
		and ct > ply.LastReviveTime + revivefailtime then -- and for longer than fail time window
			local id = ply.Reviving:EntIndex()
			if nzRevive.Players[id] then
				if nzRevive.Players[id].ReviveTime then
					--ply:SetMoveType(MOVETYPE_WALK)
					ply.Reviving:StopRevive()
					ply.Reviving = nil
				end
			end
		end

		-- When a player stops reviving
		if !ply:KeyDown(IN_USE) then -- If you have an old revival target
			if IsValid(ply.Reviving) and (ply.Reviving:IsPlayer() or ply.Reviving:GetClass() == "whoswho_downed_clone") then
				local id = ply.Reviving:EntIndex()
				if nzRevive.Players[id] then
					if nzRevive.Players[id].ReviveTime then
						--ply:SetMoveType(MOVETYPE_WALK)
						ply.Reviving:StopRevive()
						ply.Reviving = nil
						--nz.nzRevive.Functions.SendSync()
					
						net.Start("NZWhosWhoReviving")
						net.WriteEntity(ply.WhosWhoReviving)
						net.WriteBool(false)
						net.Broadcast()
					end
				end
			end
		end

	end
end

-- Hooks
hook.Add("FindUseEntity", "CheckRevive", nzRevive.HandleRevive)

if SERVER then
	util.AddNetworkString("nz_TombstoneSuicide")

	net.Receive("nz_TombstoneSuicide", function(len, ply)
		if ply:GetDownedWithTombstone() then
			local tombstone = ents.Create("drop_tombstone")
			tombstone:SetPos(ply:GetPos() + Vector(0,0,50))
			tombstone:Spawn()
			local weps = {}
			-- BIG NONO, doing this means they may not be given in the same order
			-- for k,v in pairs(ply:GetWeapons()) do
			-- 	table.insert(weps, {class = v:GetClass(), pap = v:HasNZModifier("pap")})
			-- end
			for i=1, #ply:GetWeapons() do -- Do this instead of a pairs loop
				local v = ply:GetWeapons()[i]
				table.insert(weps, {class = v:GetClass(), pap = v:HasNZModifier("pap")})
			end

			local perks = ply.OldPerks

			tombstone.OwnerData.weps = weps
			tombstone.OwnerData.perks = perks

			ply:KillDownedPlayer()
			tombstone:SetPerkOwner(ply)
		end
	end)
end

if SERVER then
	util.AddNetworkString("nz_WhosWhoActive")
end

function nzRevive:CreateWhosWhoClone(ply, pos)
	local pos = pos or ply:GetPos()

	local wep = IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() != "nz_perk_bottle" and ply:GetActiveWeapon():GetClass() or ply.oldwep or nil

	local who = ents.Create("whoswho_downed_clone")
	who:SetPos(pos + Vector(0, 0, 10))
	who:SetAngles(ply:GetAngles())
	who:Spawn()
	who:GiveWeapon(wep)
	who:SetPerkOwner(ply)
	who:SetModel(ply:GetModel())
	ply:NoFastSpeed() -- Added by Ethorbit to stop the "speed hack" bug

	who.OwnerData.perks = ply.OldPerks or ply:GetPerks()

	-- BIG NONO, doing this means they may not be given in the same order
	-- for k,v in SortedPairsByValue(ply:GetWeapons()) do
	-- 	table.insert(weps, {class = v:GetClass(), pap = v:HasNZModifier("pap"), speed = v:HasNZModifier("speed"), dtap = v:HasNZModifier("dtap")})
	-- end

	local weps = {}
	for i=1, #ply:GetWeapons() do -- Do this instead of a pairs loop
		local v = ply:GetWeapons()[i]
		table.insert(weps, {class = v:GetClass(), pap = v:HasNZModifier("pap"), speed = v:HasNZModifier("speed"), dtap = v:HasNZModifier("dtap")})
	end

	-- timer.Simple(1, function()
	-- 	player_manager.RunClass(ply, "Loadout") -- Rearm them
	-- end)

	who.OwnerData.weps = weps

	timer.Simple(0.1, function()
		if IsValid(who) then
			local id = who:EntIndex()

			if self then
				self.Players[id] = {}
				self.Players[id].DownTime = CurTime()
			end

			hook.Call("PlayerDowned", nzRevive, who)
		end
	end)

	ply.WhosWhoClone = who
	ply.WhosWhoMoney = 0

	net.Start("NZWhosWhoReviving")
	net.WriteEntity(ply)
	net.WriteBool(false)
	net.Broadcast()

	net.Start("nz_WhosWhoActive")
		net.WriteBool(true)
	net.Send(ply)
end

function nzRevive:RespawnWithWhosWho(ply, pos)
	local pos = pos or nil

	if !pos then
		local spawns = {}
		local plypos = ply:GetPos()
		local maxdist = 1500^2
		local mindist = 500^2

		local available = ents.FindByClass("nz_spawn_zombie_special")
		if IsValid(available[1]) then
			for k,v in pairs(available) do
				local dist = plypos:DistToSqr(v:GetPos())
				if v.link == nil or nzDoors:IsLinkOpened( v.link ) then -- Only for rooms that are opened (using links)
					if dist < maxdist and dist > mindist then -- Within the range we set above
						if v:IsSuitable() then -- And nothing is blocking it
							table.insert(spawns, v)
						end
					end
				end
			end
			if !IsValid(spawns[1]) then
				for k,v in pairs(available) do -- Retry, but without the range check (just use all of them)
					local dist = plypos:DistToSqr(v:GetPos())
					if v.link == nil or nzDoors:IsLinkOpened( v.link ) then
						if v:IsSuitable() then
							table.insert(spawns, v)
						end
					end
				end
			end
			if !IsValid(spawns[1]) then -- Still no open linked ones?! Spawn at a random player spawnpoint
				local pspawns = ents.FindByClass("player_spawns")
				if !IsValid(pspawns[1]) then
					ply:Spawn()
				else
					pos = pspawns[math.random(#pspawns)]:GetPos()
				end
			else
				pos = spawns[math.random(#spawns)]:GetPos()
			end
		else
			-- There exists no special spawnpoints - Use regular player spawns
			local pspawns = ents.FindByClass("player_spawns")
			if !IsValid(pspawns[1]) then
				ply:Spawn()
			else
				pos = pspawns[math.random(#pspawns)]:GetPos()
			end
		end
	end
	ply:RevivePlayer()
	ply:StripWeapons()
	
	timer.Simple(1, function()
		player_manager.RunClass(ply, "Loadout") -- Rearm them
	end)

	if pos then ply:SetPos(pos) end

	if (CLIENT) then
		ply.DownTime = CurTime()
		
	end

	if SERVER then
		net.Start("NZWhosWhoCurTime")
		net.WriteEntity(ply)
		--net.WriteFloat(CurTime(), 32)
		net.Broadcast() -- Everyone needs to know so their revive icons are correct
	end
end
