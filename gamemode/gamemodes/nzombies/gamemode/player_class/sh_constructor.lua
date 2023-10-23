-- Main Tables
nzPlayers = nzPlayers or AddNZModule("Players")
nzPlayers.Data = nzPlayers.Data or {}

-- Variables
local downedspeed = 30

-- Copy-pasted from the wiki, a nice little function
local CMoveData = FindMetaTable( "CMoveData" )
function CMoveData:RemoveKeys( keys )
	-- Using bitwise operations to clear the key bits.
	local newbuttons = bit.band( self:GetButtons(), bit.bnot( keys ) )
	self:SetButtons( newbuttons )
end

-- Stops players from moving if downed
hook.Add( "SetupMove", "nzFreezePlayersDowned", function( ply, mv, cmd )
	if !ply:GetNotDowned() then
		mv:SetMaxClientSpeed(downedspeed)
	end
end )

hook.Add("StartCommand", "nzPlayerDownFake", function(ply, cmd)
	if !ply:GetNotDowned() then
		cmd:RemoveKey(IN_SPEED)
		cmd:RemoveKey(IN_JUMP)
		cmd:SetButtons(bit.bor(cmd:GetButtons(), IN_DUCK))
	end
end)

hook.Add("PlayerSwitchWeapon", "nzPlayerWeaponSwap", function(ply, oldWep, newWep)
	if not IsValid(ply) or not IsValid(newWep) then return end

	if not ply:HasPerk("mulekick") then
		if newWep:GetNWInt("SwitchSlot", 0) == 3 then
			return true
		end
	end
end)

hook.Add("PlayerSpawn", "SetupHands", function(ply)
	local mdl = ply:GetInfo( "cl_playermodel" )
	ply:SetModel(mdl)
	
	local col = ply:GetInfo( "cl_playercolor" )
	ply:SetPlayerColor( Vector( col ) )

	local col = Vector( ply:GetInfo( "cl_weaponcolor" ) )
	if col:Length() == 0 then
		col = Vector( 0.001, 0.001, 0.001 )
	end
	ply:SetWeaponColor( col )
	
	local skin = ply:GetInfoNum( "cl_playerskin", 0 )
	ply:SetSkin( skin )

	local groups = ply:GetInfo( "cl_playerbodygroups" )
	if ( groups == nil ) then groups = "" end
	local groups = string.Explode( " ", groups )
	for k = 0, ply:GetNumBodyGroups() - 1 do
		ply:SetBodygroup( k, tonumber( groups[ k + 1 ] ) or 0 )
	end
	
	timer.Simple(0, function()
		if IsValid(ply) then ply:SetupHands() end
	end)
end)

hook.Add("OnPlayerHitGround", "nzPlayerHitGround", function(ply, inWater, onFloater, speed)
	if ply:HasPerk("phd") then
		if speed >= 400 then
			if IsFirstTimePredicted() then
				ply:ViewPunch(Angle(10, math.random(-5,5), math.random(-5,5)))

				ParticleEffect("nz_perks_phd", ply:GetPos() + vector_up*4, angle_zero)
				ply:EmitSound("NZ.PHD.Wubz")
				ply:EmitSound("NZ.PHD.Impact")
			end

			if SERVER then
				local mult = math.min(math.floor(speed/400), 3)
				util.BlastDamage(ply:GetActiveWeapon(), ply, ply:GetPos(), 150*mult, 2500*mult)
				util.ScreenShake(ply:GetPos(), 10*mult, 255, 1.5, 200*mult)
			end
		end
	end
end)

hook.Add("ScalePlayerDamage", "nzFriendlyFire", function(ply, hitgroup, dmginfo)
	local attacker = dmginfo:GetAttacker()
	if IsValid(attacker) and attacker:IsPlayer() then
		dmginfo:ScaleDamage(0)
		return true
	end
end)

hook.Add("EntityFireBullets", "nzFriendlyFire", function(ply, data)
	if IsValid(ply) and ply:IsPlayer() then
		local tr = util.QuickTrace(data.Src, data.Src + data.Dir * data.Distance, ply)
		local ent = tr.Entity
		if IsValid(ent) and ent:IsPlayer() then
			data.IgnoreEntity = ent
			return true
		end
	end
end)