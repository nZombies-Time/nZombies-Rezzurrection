
function nzPlayers.PlayerNoClip( ply, desiredState )
	if ply:Alive() and nzRound:InState( ROUND_CREATE ) then
		return ply:IsInCreative()
	end
end

function nzPlayers:FullSync( ply )
	-- A full sync module using the new rewrites
	if IsValid(ply) then
		ply:SendFullSync()
	end
end

local function initialSpawn( ply )
	timer.Simple(1, function()
		-- Fully Sync
		nzPlayers:FullSync( ply )
	end)
end

local function playerLeft( ply )
	-- this was previously hooked to PlayerDisconnected
	-- it will now detect leaving players via entity removed, to take kicking banning etc into account.
	if ply:IsPlayer() then
		ply:DropOut()
		if IsValid(ply.TimedUseEntity) then
			ply:StopTimedUse()
		end
	end
end

function GM:PlayerNoClip( ply, desiredState )
	return nzPlayers.PlayerNoClip(ply, desiredState)
end

hook.Add( "PlayerInitialSpawn", "nzPlayerInitialSpawn", initialSpawn )
hook.Add( "EntityRemoved", "nzPlayerLeft", playerLeft )

hook.Add("GetFallDamage", "nzFallDamage", function(ply, speed)
	if not IsValid(ply) then return end
	if ply:HasPerk("phd") then
		return 0
	end
	return (speed / 10)
end)

hook.Add("PlayerShouldTakeDamage", "nzPlayerIgnoreDamage", function(ply, ent)
	if not ply:GetNotDowned() then
		return false
	end

	if ent:IsValidZombie() and ply:HasPerk("widowswine") and ply:GetAmmoCount(GetNZAmmoID("grenade")) > 0 then
		for k, v in pairs(ents.FindInSphere(ply:GetPos(), ply:HasUpgrade("widowswine") and 300 or 200)) do
			if v:IsValidZombie() and ply:VisibleVec(v:EyePos()) and v.BO3SpiderWeb then
				v:BO3SpiderWeb(10, ply)
			end
		end

		local fx = EffectData()
		fx:SetOrigin(ply:GetPos())
		fx:SetEntity(ply)
		util.Effect("nz_spidernade_explosion", fx)

		local nade = GetNZAmmoID("grenade")
		ply:SetAmmo(ply:GetAmmoCount(nade) - 1, nade)

		return false
	end

	if ent:IsPlayer() then
		if ent == ply then
			return !ply:HasPerk("phd") and !ply.SELFIMMUNE
		else
			if ent:HasPerk("gum") then
				return true
			else
				return false
			end
		end
	end
end)

hook.Add("EntityTakeDamage", "nzPlayerTakeDamage", function(ply, dmginfo)
	if not IsValid(ply) then return end
	if not ply:IsPlayer() then return end

	local ent = dmginfo:GetAttacker()
	if IsValid(ent) and ent:GetClass() == "elemental_pop_effect_3" then
		dmginfo:SetAttacker(ent:GetAttacker())
		dmginfo:SetInflictor(ent:GetInflictor())

		if ply:IsPlayer() then
			dmginfo:SetDamage(0)
		end
	end

	if IsValid(ent) and ent:IsValidZombie() then
		if ply:HasPerk("winters") and (nzRound:InState(ROUND_CREATE) or ply:GetNW2Int("nz.WailCount", 0) > 0) and ply:GetNW2Float("nz.WailDelay", 0) < CurTime() and ply:Health() < ply:GetMaxHealth() then
			local upgrade = ply:HasUpgrade("winters")

			local class = "elemental_pop_effect_5"
			if upgrade then
				class = "winterswail_effect"
			end

			local freeze = ents.Create(class)
			freeze:SetPos(ply:WorldSpaceCenter())
			freeze:SetAngles(angle_zero)
			freeze:SetOwner(ply)
			freeze:SetParent(ply)
			freeze:SetAttacker(ply)
			freeze:SetInflictor(ply:GetActiveWeapon())

			if not upgrade then
				ply:EmitSound("NZ.Winters.Start")
				freeze.Range = 240
			end

			freeze:Spawn()

			ply:SetNW2Float("nz.WailDelay", CurTime() + 30)
			ply:SetNW2Int("nz.WailCount", math.max(ply:GetNW2Int("nz.WailCount",0) - 1, 0))
		end

		if ply:HasPerk("tortoise") and (ply.GetShield and not IsValid(ply:GetShield())) then
			local dot = (ent:GetPos() - ply:GetPos()):Dot(ply:GetAimVector())

			if dot < 0 then
				local scale = math.Clamp(ply:GetNW2Int("nz.TortCount", 0) / 10, 0, 1)
				dmginfo:ScaleDamage(0.5 + (scale * 0.5))

				ply:SetNW2Int("nz.TortCount", ply:GetNW2Int("nz.TortCount",0) + 1)
				ply:SetNW2Float("nz.TortDelay", CurTime() + 10)
			end
		end
	end

	if IsValid(ent) and not ent:IsPlayer() and dmginfo:IsDamageType(DMG_VEHICLE) then //assdonut teleport
		local perks = ply:GetPerks()
		if not table.IsEmpty(perks) then
			ply:RemovePerk(perks[math.random(#perks)], true)
		end

		dmginfo:SetDamage(ply:Health() - 25)

		local available = ents.FindByClass("nz_spawn_zombie_special")
		local pos = ply:GetPos()
		local spawns = {}

		if IsValid(available[1]) then
			for k, v in ipairs(available) do
				if v.link == nil or nzDoors:IsLinkOpened(v.link) then
					if v:IsSuitable() then
						table.insert(spawns, v)
					end
				end
			end
			if !IsValid(spawns[1]) then
				local pspawns = ents.FindByClass("player_spawns")
				if !IsValid(pspawns[1]) then
					ply:ChatPrint("Couldnt find an escape boss, sorry 'bout that.")
				else
					pos = pspawns[math.random(#pspawns)]:GetPos()
				end
			else
				pos = spawns[math.random(#spawns)]:GetPos()
			end
		else
			local pspawns = ents.FindByClass("player_spawns")
			if IsValid(pspawns[1]) then
				pos = pspawns[math.random(#pspawns)]:GetPos()
			end
		end

		local moo = Entity(1) //10% chance to tp to host of lobby
		if ply:EntIndex() ~= moo:EntIndex() and math.random(10) == 1 then
			pos = moo:GetPos()
		end

		ply:SetPos(pos)
	end

	if bit.band(dmginfo:GetDamageType(), bit.bor(DMG_RADIATION, DMG_POISON, DMG_SHOCK)) ~= 0 and ply:HasPerk("mask") then
		dmginfo:ScaleDamage(0.15)
	end

	if dmginfo:IsDamageType(DMG_NERVEGAS) and ply:HasPerk("mask") then
		dmginfo:ScaleDamage(0)
	end

	if bit.band(dmginfo:GetDamageType(), bit.bor(DMG_BURN, DMG_SLOWBURN)) ~= 0 and ply:HasPerk("fire") then
		dmginfo:ScaleDamage(0)
	end

	if dmginfo:IsDamageType(DMG_PHYSGUN) then
		dmginfo:ScaleDamage(0)
	end

	if dmginfo:IsExplosionDamage() and ply:HasPerk("phd") then
		dmginfo:ScaleDamage(0)
		return false
	end

	if dmginfo:IsFallDamage() and ply:HasPerk("phd") then
		dmginfo:ScaleDamage(0)
		return false
	end
end)

hook.Add("PostEntityTakeDamage", "nzPostPlayerTakeDamage", function(ply, dmginfo, took)
	if not IsValid(ply) then return end
	if not ply:IsPlayer() then return end

	if took and ply:GetNotDowned() then
		ply.lasthit = CurTime()
		ply:SetNW2Float("nz.LastHit", CurTime())

		local ent = dmginfo:GetAttacker()
		if IsValid(ent) and ent:IsValidZombie() then
			if ply:HasPerk("fire") and ply:GetNW2Float("nz.BurnDelay", 0) < CurTime() then
				local fire = ents.Create("elemental_pop_effect_1")
				fire:SetPos(ply:WorldSpaceCenter())
				fire:SetParent(ply)
				fire:SetOwner(ply)
				fire:SetAttacker(ply)
				fire:SetInflictor(ply:GetActiveWeapon())
				fire:SetAngles(angle_zero)

				fire:Spawn()

				local time = (ply:HasUpgrade("fire") and 10 or 20) * math.max(ply:GetNW2Int("nz.BurnCount", 1), 1)
				ply:SetNW2Float("nz.BurnDelay", CurTime() + time)
				ply:SetNW2Int("nz.BurnCount", math.min(ply:GetNW2Int("nz.BurnCount", 0) + 1), 10)
			end
		end
	end
end)

hook.Add("PlayerSpawn", "nzPlayerSpawnVars", function(ply, trans)
	ply:SetNW2Bool("nz.GinMod", false)

	ply:SetNW2Float("nz.DeadshotDecay", 1)
	ply:SetNW2Int("nz.DeadshotChance", 0)

	ply:SetNW2Float("nz.TortDelay", 1)
	ply:SetNW2Int("nz.TortCount", 1)

	ply:SetNW2Float("nz.ZombShellDelay", 1)
	ply:SetNW2Int("nz.ZombShellCount", 0)

	ply:SetNW2Float("nz.EPopDelay", 1)
	ply:SetNW2Int("nz.EPopChance", 0)

	ply:SetNW2Float("nz.BurnDelay", 1)
	ply:SetNW2Int("nz.BurnCount", 0)

	ply:SetNW2Float("nz.WailDelay", 1)
	ply:SetNW2Int("nz.WailCount", 3)
end)

hook.Add("OnRoundStart", "nz.ResetKillStats", function()
	for _, ply in ipairs(player.GetAll()) do
		if ply:HasPerk("everclear") then
			ply:SetNW2Float("nz.ZombShellDelay", 1)
			ply:SetNW2Int("nz.ZombShellCount", 0)
		end
		if ply:HasPerk("fire") then
			ply:SetNW2Float("nz.BurnDelay", 1)
			ply:SetNW2Int("nz.BurnCount", 0)
		end
		if ply:HasPerk("winters") then
			ply:SetNW2Float("nz.WailDelay", 1)
			ply:SetNW2Int("nz.WailCount", ply:HasUpgrade("winters") and 4 or 3)
		end
		if ply:HasUpgrade("jugg") then
			local bonus = math.max(200, ply:Armor())
			ply:SetArmor(bonus)
		end
	end
end)

hook.Add("PlayerDowned", "nzPlayerDown", function(ply)
	for key, perk in pairs(ply.OldPerks) do
		if tostring(perk) == "tortoise" then
			local pos = ply:GetPos()
			local damage = DamageInfo()
			damage:SetDamage(666)
			damage:SetAttacker(ply)
			damage:SetInflictor(IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon() or ply)
			damage:SetDamageType(DMG_DIRECT)

			for k, v in pairs(ents.FindInSphere(pos, 360)) do
				if v:IsValidZombie() then
					damage:SetDamagePosition(v:EyePos())
					damage:SetDamageForce(v:GetUp()*8000 + (v:GetPos() - pos):GetNormalized()*10000)

					if (v.NZBossType or string.find(v:GetClass(), "nz_zombie_boss")) then
						damage:SetDamage(math.max(2500, ent:GetMaxHealth() / 3))
						damage:ScaleDamage(math.Round(nzRound:GetNumber()/8))
					end

					v:TakeDamageInfo(damage)
				end
			end

			local fx = EffectData()
			fx:SetOrigin(pos)
			util.Effect("HelicopterMegaBomb", fx)
			util.Effect("Explosion", fx)

			util.ScreenShake(pos, 10, 255, 1.5, 600)

			if ply:IsOnGround() then
				util.Decal("Scorch", pos - vector_up, pos + vector_up)
			end

			ply:EmitSound("Perk.Tortoise.Exp")
			ply:EmitSound("Perk.Tortoise.Exp_Firey")
			ply:EmitSound("Perk.Tortoise.Exp_Decay")

			break
		end
	end
end)

hook.Add("PlayerPostThink", "nzStatsRestePlayer", function(ply)
	if ply:HasPerk("tortoise") then
		if ply:GetNW2Float("nz.TortDelay", 0) < CurTime() and ply:GetNW2Int("nz.TortCount", 0) > 0 then
			ply:SetNW2Int("nz.TortCount", 0)
		end
	end
	if ply:HasPerk("cherry") then
		if ply:GetNW2Float("nz.CherryDelay", 0) < CurTime() and ply:GetNW2Int("nz.CherryCount", 0) > 0 then
			ply:SetNW2Int("nz.CherryCount", 0)
		end
	end
end)

hook.Add("OnEntityCreated", "nodmglolfucku", function(ent)
	timer.Simple(0, function()
		if not IsValid(ent) then return end
		if IsValid(ent:GetOwner()) and ent:GetOwner():IsPlayer() then
			local phys = ent:GetPhysicsObject()
			if IsValid(phys) then
				phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
			end
		end
	end)
end)

hook.Add("WeaponEquip", "nzWeaponPickupString", function(wep, ply)
	if wep.NZPickupHintText then
		timer.Simple(0, function()
			if not IsValid(wep) or not IsValid(ply) then return end
			ply:PrintMessage(HUD_PRINTCENTER, wep.NZPickupHintText)
		end)
	end
end)
