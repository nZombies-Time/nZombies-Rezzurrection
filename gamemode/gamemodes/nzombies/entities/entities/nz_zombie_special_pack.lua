AddCSLuaFile()

ENT.Base = "nz_zombiebase"
ENT.PrintName = "The Pack"
ENT.Category = "Brainz"
ENT.Author = "Lolle"

ENT.Models = { "models/specials/pack.mdl" }

ENT.AttackRange = 80
ENT.DamageLow = 20
ENT.DamageHigh = 35

ENT.AttackSequences = {
	{seq = "attack1"},
	{seq = "attack2"}
}

ENT.DeathSequences = {
	"attack1"
}
ENT.AttackSounds = {
	"enemies/specials/pack/attack/pack_attack_00.ogg",
	"enemies/specials/pack/attack/pack_attack_01.ogg",
	"enemies/specials/pack/attack/pack_attack_02.ogg",
	"enemies/specials/pack/attack/pack_attack_03.ogg",
	"enemies/specials/pack/attack/pack_attack_04.ogg",
	"enemies/specials/pack/attack/pack_attack_05.ogg",
	"enemies/specials/pack/attack/pack_attack_06.ogg",
	"enemies/specials/pack/attack/pack_attack_07.ogg"
}

ENT.AttackHitSounds = {
	"nz/hellhound/bite/bite_00.wav",
	"nz/hellhound/bite/bite_01.wav",
	"nz/hellhound/bite/bite_02.wav",
	"nz/hellhound/bite/bite_03.wav",
}

ENT.WalkSounds = {
	"enemies/specials/pack/alert/pack_boy_52.ogg",
	"enemies/specials/pack/alert/pack_boy_51.ogg",
	"enemies/specials/pack/alert/pack_boy_50.ogg",
	"enemies/specials/pack/alert/pack_boy_49.ogg",
	"enemies/specials/pack/alert/pack_boy_48.ogg",
	"enemies/specials/pack/alert/pack_boy_47.ogg",
	"enemies/specials/pack/alert/pack_boy_46.ogg",
	"enemies/specials/pack/alert/pack_boy_45.ogg",
	"enemies/specials/pack/idle/pack_boy_31.ogg",
	"enemies/specials/pack/idle/pack_boy_32.ogg",
	"enemies/specials/pack/idle/pack_boy_33.ogg",
	"enemies/specials/pack/idle/pack_boy_34.ogg",
	"enemies/specials/pack/idle/pack_boy_35.ogg",
	"enemies/specials/pack/idle/pack_boy_36.ogg",
	"enemies/specials/pack/idle/pack_boy_37.ogg",
	"enemies/specials/pack/idle/pack_boy_38.ogg",
	"enemies/specials/pack/idle/pack_boy_39.ogg"
}

ENT.PainSounds = {
	"physics/flesh/flesh_impact_bullet1.wav",
	"physics/flesh/flesh_impact_bullet2.wav",
	"physics/flesh/flesh_impact_bullet3.wav",
	"physics/flesh/flesh_impact_bullet4.wav",
	"physics/flesh/flesh_impact_bullet5.wav"
}

ENT.DeathSounds = {
	"enemies/specials/pack/dead/pack_boy_20.ogg",
	"enemies/specials/pack/dead/pack_boy_21.ogg",
	"enemies/specials/pack/dead/pack_boy_22.ogg",
	"enemies/specials/pack/dead/pack_boy_23.ogg"
}

ENT.SprintSounds = {
	"feederCG/footstep1.mp3",
	"feederCG/footstep2.mp3",
	"feederCG/footstep3.mp3",
	"feederCG/footstep4.mp3",
	"feederCG/footstep5.mp3",
	"feederCG/footstep6.mp3"
}

ENT.JumpSequences = {seq = ACT_RUN, speed = 30}

ENT.ActStages = {
	[1] = {
		act = ACT_RUN,
		minspeed = 5,
	},
	[2] = {
		act = ACT_RUN,
		minspeed = 50,
	},
	[3] = {
		act = ACT_RUN,
		minspeed = 150,
	},
	[4] = {
		act = ACT_RUN,
		minspeed = 160,
	},
}

function ENT:StatsInitialize()
	if SERVER then
		self:SetRunSpeed(200)
		self:SetHealth(155)
		self:SetNoDraw(true)
	end
	self:SetSolid(SOLID_BBOX)

	--PrintTable(self:GetSequenceList())
end

function ENT:OnSpawn()

	--self:SetNoDraw(true) -- Start off invisible while in the prespawn effect
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS) -- Don't collide in this state
	self:Stop() -- Also don't do anything

	local effectData = EffectData()
	ParticleEffect("bo3_zombie_spawn",self:LocalToWorld(Vector(40,-20,0)),Angle(0,0,0),nil)
	self:SetNoDraw(true)
	self:SetInvulnerable(true)
	timer.Simple(1.4, function()
		if IsValid(self) then
		self:EmitSound("enemies/specials/pack/alert/pack_boy_"..math.random(45,52)..".ogg",100)
			self:SetNoDraw(false)
			self:SetCollisionGroup(COLLISION_GROUP_NONE)
			self:SetStop(false)

			self:SetTarget(self:GetPriorityTarget())
			self:SetInvulnerable(nil)
		end
	end)

	nzRound:SetNextSpawnTime(CurTime() + 2) -- This one spawning delays others by 3 seconds
end

function ENT:OnZombieDeath(dmgInfo)

	self:SetRunSpeed(0)
	self.loco:SetVelocity(Vector(0,0,0))
	self:Stop()
	local seqstr = self.DeathSequences[math.random(#self.DeathSequences)]
	local seq, dur = self:LookupSequence(seqstr)
	-- Delay it slightly; Seems to fix it instantly getting overwritten
	timer.Simple(0, function() 
		if IsValid(self) then
			self:ResetSequence(seq)
			self:SetCycle(0)
			self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		end 
	end)

	timer.Simple(dur + 1, function()
		if IsValid(self) then
			self:Remove()
		end
	end)
	self:EmitSound( self.DeathSounds[ math.random( #self.DeathSounds ) ], 100)

end

function ENT:BodyUpdate()

	self.CalcIdeal = ACT_IDLE

	local velocity = self:GetVelocity()

	local len2d = velocity:Length2D()

	if ( len2d > 150 ) then self.CalcIdeal = ACT_RUN elseif ( len2d > 50 ) then self.CalcIdeal = ACT_RUN elseif ( len2d > 5 ) then self.CalcIdeal = ACT_RUN end

	if self:IsJumping() and self:WaterLevel() <= 0 then
		self.CalcIdeal = ACT_RUN
	end

	--if self:GetActivity() != self.CalcIdeal and !self:IsAttacking() and !self:GetStop() then self:StartActivity(self.CalcIdeal) end

	if !self:GetSpecialAnimation() and !self:IsAttacking() then
		if self:GetActivity() != self.CalcIdeal and !self:GetStop() then self:StartActivity(self.CalcIdeal) end

		self:BodyMoveXY()
	end

	self:FrameAdvance()

end

function ENT:OnTargetInAttackRange()
    local atkData = {}
    atkData.dmglow = 25
    atkData.dmghigh = 35
    atkData.dmgforce = Vector( 0, 0, 0 )
	atkData.dmgdelay = 0.3
    self:Attack( atkData )
end

-- Hellhounds target differently
function ENT:GetPriorityTarget()

	if GetConVar( "nz_zombie_debug" ):GetBool() then
		print(self, "Retargeting")
	end

	self:SetLastTargetCheck( CurTime() )

	-- Well if he exists and he is targetable, just target this guy!
	if IsValid(self:GetTarget()) and self:GetTarget():GetTargetPriority() > 0 then
		local dist = self:GetRangeSquaredTo( self:GetTarget():GetPos() )
		if dist < 1000 then
			if !self.sprinting then
				self:EmitSound( self.SprintSounds[ math.random( #self.SprintSounds ) ], 100 )
				self.sprinting = true
			end
			self:SetRunSpeed(250)
			self.loco:SetDesiredSpeed( self:GetRunSpeed() )
		elseif !self.sprinting then
			self:SetRunSpeed(100)
			self.loco:SetDesiredSpeed( self:GetRunSpeed() )
		end
		return self:GetTarget()
	end

	-- Otherwise, we just loop through all to try and target again
	local allEnts = ents.GetAll()

	local bestTarget = nil
	local lowest

	--local possibleTargets = ents.FindInSphere( self:GetPos(), self:GetTargetCheckRange())

	for _, target in pairs(allEnts) do
		if self:IsValidTarget(target) then
			if target:GetTargetPriority() == TARGET_PRIORITY_ALWAYS then return target end
			if !lowest then
				lowest = target.hellhoundtarget -- Set the lowest variable if not yet
				bestTarget = target -- Also mark this for the best target so he isn't ignored
			end

			if lowest and (!target.hellhoundtarget or target.hellhoundtarget < lowest) then -- If the variable exists and this player is lower than that amount
				bestTarget = target -- Mark him for the potential target
				lowest = target.hellhoundtarget or 0 -- And set the new lowest to continue the loop with
			end

			if !lowest then -- If no players had any target values (lowest was never set, first ever hellhound)
				local players = player.GetAllTargetable()
				bestTarget = players[math.random(#players)] -- Then pick a random player
			end
		end
	end

	if self:IsValidTarget(bestTarget) then -- If we found a valid target
		local targetDist = self:GetRangeSquaredTo( bestTarget:GetPos() )
		if targetDist < 1000 then -- Under this distance, we will break into sprint
			self:EmitSound( self.SprintSounds[ math.random( #self.SprintSounds ) ], 100 )
			self.sprinting = true -- Once sprinting, you won't stop
			self:SetRunSpeed(250)
		else -- Otherwise we'll just search (towards him)
			self:SetRunSpeed(100)
			self.sprinting = nil
		end
		self.loco:SetDesiredSpeed( self:GetRunSpeed() )
		-- Apply the new target numbers
		bestTarget.hellhoundtarget = bestTarget.hellhoundtarget and bestTarget.hellhoundtarget + 1 or 1
		self:SetTarget(bestTarget) -- Well we found a target, we kinda have to force it

		return bestTarget
	else
		self:TimeOut(0.2)
	end
end
function ENT:IsValidTarget( ent )
	if not ent then return false end
	return IsValid( ent ) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
end