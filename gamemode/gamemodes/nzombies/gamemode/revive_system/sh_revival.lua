-- Hooks
if SERVER then
	local cvar_downtime = GetConVar("nz_downtime")
	hook.Add("Think", "CheckDownedPlayersTime", function()
		for id, data in pairs(nzRevive.Players) do
			if data.ReviveTime and data.RevivePlayer and IsValid(data.RevivePlayer) then
				local ply = data.RevivePlayer
				local revivetime = ply:HasPerk("revive") and 2 or 4
				if (CurTime() - data.ReviveTime >= revivetime) then
					local ent = Entity(id)
					ent:RevivePlayer(ply)
					ply.Reviving = nil
				end
			end
			if CurTime() - data.DownTime >= cvar_downtime:GetFloat() and !data.ReviveTime then
				local ent = Entity(id)
				if ent.KillDownedPlayer then
					ent:KillDownedPlayer()
				else
					nzRevive.Players[id] = nil
				end
			end
		end
	end)
end

local ReviveClasses = {
	["whoswho_downed_clone"] = true,
}

hook.Add("FindUseEntity", "CheckRevive", function(ply, _) //wiki states this hook is functionally serverside
	if !nzRevive.Players[ply:EntIndex()] and not IsValid(ply:GetPlayerReviving()) then
		local tr = util.QuickTrace(ply:EyePos(), ply:GetAimVector()*100, ply)
		local dply = tr.Entity

		if IsValid(dply) and (dply:IsPlayer() or ReviveClasses[dply:GetClass()]) then
			local id = dply:EntIndex()
			if nzRevive.Players[id] and !nzRevive.Players[id].RevivePlayer then
				dply:StartRevive(ply)
			end
		end
	end
end)

hook.Add("PlayerPostThink", "CleanupRevive", function(ply)
	local revive = ply:GetPlayerReviving()
	if IsValid(revive) then
		local id = revive:EntIndex()
		local data = nzRevive.Players[id]

		if data then
			if SERVER and data.ReviveTime and (not ply:KeyDown(IN_USE) or ply:GetPos():DistToSqr(ply:GetPlayerReviving():GetPos()) > 10000) then //100^2 same as revive start distance
				revive:StopRevive()
				ply.Reviving = nil
			end
		else
			ply.Reviving = nil
		end
	end
end)

if SERVER then
	util.AddNetworkString("nz_TombstoneSuicide")

	net.Receive("nz_TombstoneSuicide", function(len, ply)
		if ply:GetDownedWithTombstone() then
			for _, mod in pairs(ply.OldUpgrades) do
				if mod ~= "tombstone" then continue end
				ply:GivePoints(6000)
			end

			local tombstone = ents.Create("drop_tombstone")
			tombstone:SetOwner(ply)
			tombstone:SetFunny(math.random(100) == 1)
			tombstone:SetPos(ply:GetPos() + Vector(0,0,24))
			tombstone:Spawn()

			local weps = {}
			for k, v in pairs(ply:GetWeapons()) do
				table.insert(weps, {class = v:GetClass(), pap = v:HasNZModifier("pap")})
			end

			if not tombstone.OwnerData then tombstone.OwnerData = {} end
			tombstone.OwnerData.weps = weps
			tombstone.OwnerData.perks = ply.OldPerks
			tombstone.OwnerData.upgrades = ply.OldUpgrades

			ply:KillDownedPlayer()
			tombstone:SetOwner(ply)
		end
	end)
end

if SERVER then
	util.AddNetworkString("nz_WhosWhoActive")
	util.AddNetworkString("nz_WhosWhoTeleRequest")

	net.Receive("nz_WhosWhoTeleRequest", function(len, ply)
		if IsValid(ply) and ply:HasUpgrade("whoswho") and ply:GetNW2Float("nz.ChuggaTeleDelay",0) < CurTime() then
			nzRevive:ChuggaBudTeleport(ply)
			ply:SetNW2Float("nz.ChuggaTeleDelay", CurTime() + (ply:HasPerk("time") and 8 or 10))
		end
	end)

	function nzRevive:CreateChuggaBud(ply, pos)
		if not IsValid(ply) or not ply:IsPlayer() then return end
		local pos = pos or ply:GetPos() + vector_up
		local ang = ply:GetAngles()
		local fwd = Angle(0,ang.yaw,ang.roll)

		if ply.ChuggaBudGhost and IsValid(ply.ChuggaBudGhost) then
			ply.ChuggaBudGhost:Remove()
		end

		local ghost = ents.Create("nz_chuggabud_ghost")
		ghost:SetOwner(ply)
		ghost:SetPos(pos)
		ghost:SetAngles(fwd)
		ghost:SetModel(ply:GetModel())
		ghost:SetSkin(ply:GetSkin())
		ghost:SetColor(ply:GetColor())
		ghost:SetModelScale(ply:GetModelScale())
		ghost:SetBloodColor(ply:GetBloodColor())

		local mins, maxs = ply:GetCollisionBounds()
		ghost:SetCollisionBounds(mins, maxs)

		for i = 1, #ply:GetBodyGroups() do
			ghost:SetBodygroup(i-1, ply:GetBodygroup(i-1))
		end

		ghost:Spawn()

		ply.ChuggaBudGhost = ghost

		return ghost
	end

	function nzRevive:ChuggaBudTeleport(ply, bool)
		if not IsValid(ply) then return end
		local available = ents.FindByClass("nz_spawn_zombie_special")
		local startpos = ply:GetPos()
		local pos = startpos
		local spawns = {}

		for k, v in nzLevel.GetSpecialSpawnArray() do
			if IsValid(v) and (v.link == nil or nzDoors:IsLinkOpened(v.link)) and v:IsSuitable() then
				table.insert(spawns, v)
			end
		end

		if table.IsEmpty(spawns) or !IsValid(spawns[1]) then
			local pspawns = ents.FindByClass("player_spawns")
			if !IsValid(pspawns[1]) then
				ply:ChatPrint("Couldnt find an escape boss, sorry 'bout that.")
			else
				pos = pspawns[math.random(#pspawns)]:GetPos()
			end
		else
			pos = spawns[math.random(#spawns)]:GetPos()
		end

		local moo = Entity(1) //10% chance to tp to host of lobby
		if ply:EntIndex() ~= moo:EntIndex() and math.random(10) == 1 then
			pos = moo:GetPos()
		end

		ply:EmitSound("NZ.ChuggaBud.Sweet")
		ply:ViewPunch(Angle(-4, math.random(-6, 6), 0))
		ply:SetPos(pos)

		timer.Simple(0, function()
			if not IsValid(ply) then return end

			if bool then //create ghost
				nzRevive:CreateChuggaBud(ply, startpos)
			end
			ply:SetPos(pos)
			ply:EmitSound("NZ.ChuggaBud.Teleport")
			ParticleEffect("nz_perks_chuggabud_tp", pos, angle_zero)

			nzSounds:Play("WhosWhoLooper", ply)

			local damage = DamageInfo()
			damage:SetAttacker(ply)
			damage:SetInflictor(ply:GetActiveWeapon())
			damage:SetDamageType(DMG_MISSILEDEFENSE)

			for k, v in pairs(ents.FindInSphere(ply:WorldSpaceCenter(), 150)) do
				if v:IsNPC() or v:IsNextBot() then
					if v.NZBossType then continue end
					damage:SetDamage(75)
					damage:SetDamagePosition(v:WorldSpaceCenter())
					v:TakeDamageInfo(damage)
				end
			end
		end)
	end
end

function nzRevive:CreateWhosWhoClone(ply, pos)
	local pos = pos or ply:GetPos()

	local wep = IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() != "nz_perk_bottle" and ply:GetActiveWeapon():GetClass() or ply.oldwep or nil

	local who = ents.Create("whoswho_downed_clone")
	who:SetPos(pos + Vector(0,0,10))
	who:SetAngles(ply:GetAngles())
	who:Spawn()
	who:GiveWeapon(wep)
	who:SetPerkOwner(ply)
	who:SetModel(ply:GetModel())
	who.OwnerData.perks = ply.OldPerks or ply:GetPerks()
	local weps = {}
	for k,v in pairs(ply:GetWeapons()) do
		table.insert(weps, {class = v:GetClass(), pap = v:HasNZModifier("pap"), speed = v:HasNZModifier("speed"), dtap = v:HasNZModifier("dtap")})
	end
	who.OwnerData.weps = weps

	timer.Simple(0.1, function()
		if IsValid(who) then
			local id = who:EntIndex()
			self.Players[id] = {}
			self.Players[id].DownTime = CurTime()

			hook.Call("PlayerDowned", nzRevive, who)
		end
	end)

	ply.WhosWhoClone = who
	ply.WhosWhoMoney = 0

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
			for k,v in ipairs(available) do
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
	player_manager.RunClass(ply, "Loadout") -- Rearm them

	if pos then ply:SetPos(pos) end

end
