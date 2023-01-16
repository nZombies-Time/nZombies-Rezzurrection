local HealthRegen = {
	Amount = 10,
	Delay = 2.5,
	Rate = 0.05
}
local HealthRegenFast = {
	Amount = 15,
	Delay = 1.5,
	Rate = 0.07
}

hook.Add( "Think", "RegenHealth", function()
	for k,v in pairs( player.GetAll() ) do
		if v:HasPerk("revive") then
			if v:Alive() and v:GetNotDowned() and v:Health() < v:GetMaxHealth() and (!v.lastregen or CurTime() > v.lastregen + HealthRegenFast.Rate) and (!v.lasthit or CurTime() > v.lasthit + HealthRegenFast.Delay) then
				v.lastregen = CurTime()
				v:SetHealth( math.Clamp(v:Health() + HealthRegenFast.Amount, 0, v:GetMaxHealth() ) )
			end
		else
			if v:Alive() and v:GetNotDowned() and v:Health() < v:GetMaxHealth() and (!v.lastregen or CurTime() > v.lastregen + HealthRegen.Rate) and (!v.lasthit or CurTime() > v.lasthit + HealthRegen.Delay) then
				v.lastregen = CurTime()
				v:SetHealth( math.Clamp(v:Health() + HealthRegen.Amount, 0, v:GetMaxHealth() ) )
			end
		end
	end
end)

hook.Add( "EntityTakeDamage", "PreventHealthRegen", function(ent, dmginfo)
	if ent:IsPlayer() and ent:GetNotDowned() then
		ent.lasthit = CurTime()
	end
	if ent:IsPlayer() and dmginfo:IsDamageType( 8388608 ) then
		dmginfo:ScaleDamage( 0 )
	end
	
	if ent:IsPlayer() and dmginfo:IsDamageType( 262144 ) then
		if ent:HasPerk("mask") and ent:HasUpgrade("mask") then
			dmginfo:ScaleDamage( 0.01 )
		else
			dmginfo:ScaleDamage( 0.25 )
		end
	end

	attacker = dmginfo:GetAttacker()
	if ent:IsPlayer() and dmginfo:IsDamageType( 16 ) and !attacker:IsPlayer() then
		if ent:GetPerks() then
			perks = ent:GetPerks()
			if not table.IsEmpty(perks) then
				perkLost = perks[math.random(1, #perks)]
				ent:RemovePerk(perkLost, true)
			else
			end
		end
		dmginfo:SetDamage( ent:Health()- 25 )
		 -- Taken from whoswho.
        local pos = nil
		local spawns = {}
		local plypos = ent:GetPos()
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
				pos = pspawns[math.random(#pspawns)]:GetPos()
			else
				pos = spawns[math.random(#spawns)]:GetPos()
			end
		else
			-- There exists no special spawnpoints - Use regular player spawns
			local pspawns = ents.FindByClass("player_spawns")
			pos = pspawns[math.random(#pspawns)]:GetPos()
		end
	if pos then ent:SetPos(pos) end            
	end
end)
