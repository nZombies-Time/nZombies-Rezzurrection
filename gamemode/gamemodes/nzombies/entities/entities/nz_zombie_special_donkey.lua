AddCSLuaFile()

ENT.Base = "nz_zombiebase"
ENT.PrintName = "Hellhound"
ENT.Category = "Brainz"
ENT.Author = "Lolle"

ENT.Models = { "models/specials/helldonkey.mdl" }

ENT.AttackRange = 80
ENT.DamageLow = 20
ENT.DamageHigh = 35

ENT.AttackSequences = {
	{seq = "nz_attack1"},
	{seq = "nz_attack2"},
	{seq = "nz_attack3"},
}

ENT.DeathSequences = {
	"nz_death1",
	"nz_death2",
	"nz_death3",
}

ENT.AttackSounds = {
	"nz/hellhound/attack/attack_00.wav",
	"nz/hellhound/attack/attack_01.wav",
	"nz/hellhound/attack/attack_02.wav",
	"nz/hellhound/attack/attack_03.wav",
	"nz/hellhound/attack/attack_04.wav",
	"nz/hellhound/attack/attack_05.wav",
	"nz/hellhound/attack/attack_06.wav"
}

ENT.AttackHitSounds = {
	"nz/hellhound/bite/bite_00.wav",
	"nz/hellhound/bite/bite_01.wav",
	"nz/hellhound/bite/bite_02.wav",
	"nz/hellhound/bite/bite_03.wav",
}

ENT.WalkSounds = {
	"nz/hellhound/dist_vox_a/dist_vox_a_00.wav",
	"nz/hellhound/dist_vox_a/dist_vox_a_01.wav",
	"nz/hellhound/dist_vox_a/dist_vox_a_02.wav",
	"nz/hellhound/dist_vox_a/dist_vox_a_03.wav",
	"nz/hellhound/dist_vox_a/dist_vox_a_04.wav",
	"nz/hellhound/dist_vox_a/dist_vox_a_05.wav",
	"nz/hellhound/dist_vox_a/dist_vox_a_06.wav",
	"nz/hellhound/dist_vox_a/dist_vox_a_07.wav",
	"nz/hellhound/dist_vox_a/dist_vox_a_08.wav",
	"nz/hellhound/dist_vox_a/dist_vox_a_09.wav",
	"nz/hellhound/dist_vox_a/dist_vox_a_10.wav",
	"nz/hellhound/dist_vox_a/dist_vox_a_11.wav"
}

ENT.PainSounds = {
	"physics/flesh/flesh_impact_bullet1.wav",
	"physics/flesh/flesh_impact_bullet2.wav",
	"physics/flesh/flesh_impact_bullet3.wav",
	"physics/flesh/flesh_impact_bullet4.wav",
	"physics/flesh/flesh_impact_bullet5.wav"
}

ENT.DeathSounds = {
	"nz/hellhound/death2/death0.wav",
	"nz/hellhound/death2/death1.wav",
	"nz/hellhound/death2/death2.wav",
	"nz/hellhound/death2/death3.wav",
	"nz/hellhound/death2/death4.wav",
	"nz/hellhound/death2/death5.wav",
	"nz/hellhound/death2/death6.wav",
}

ENT.SprintSounds = {
	"nz/hellhound/close/close_00.wav",
	"nz/hellhound/close/close_01.wav",
	"nz/hellhound/close/close_02.wav",
	"nz/hellhound/close/close_03.wav",
}

ENT.JumpSequences = {seq = ACT_JUMP, speed = 30}

ENT.ActStages = {
	[1] = {
		act = ACT_WALK,
		minspeed = 5,
	},
	[2] = {
		act = ACT_WALK_ANGRY,
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
		self:SetRunSpeed(250)
		self:SetHealth(100)
		self:SetNoDraw(true)
	end
	self:SetCollisionBounds(Vector(-14,-14, 0), Vector(14, 14, 48))
	self:SetSolid(SOLID_BBOX)

	--PrintTable(self:GetSequenceList())
end

function ENT:OnSpawn()

	--self:SetNoDraw(true) -- Start off invisible while in the prespawn effect
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS) -- Don't collide in this state
	self:Stop() -- Also don't do anything

	local effectData = EffectData()
	effectData:SetOrigin( self:GetPos() )
	effectData:SetMagnitude( 2 )
	effectData:SetEntity(nil)
	util.Effect("lightning_prespawn", effectData)
	self:SetNoDraw(true)
	self:SetInvulnerable(true)

	timer.Simple(1.4, function()
		if IsValid(self) then
			effectData = EffectData()
			-- startpos
			effectData:SetStart( self:GetPos() + Vector(0, 0, 1000) )
			-- end pos
			effectData:SetOrigin( self:GetPos() )
			-- duration
			effectData:SetMagnitude( 0.75 )
			--util.Effect("lightning_strike", effectData)
			util.Effect("lightning_strike", effectData)

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
	
	timer.Simple(0, function()
		--delay it slightly; Seems to fix it instantly getting overwritten
		if IsValid(self) then
			self:ResetSequence(seq)
			self:SetCycle(0)
			self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE) --we use this type so the dogs d
		end 
	end)

	timer.Simple(dur + 1, function()
		if IsValid(self) then
			self:Remove()
		end
	end)
	
	self:EmitSound(self.DeathSounds[math.random(#self.DeathSounds)], 100)
end

function ENT:BodyUpdate()
	self.CalcIdeal = ACT_IDLE
	
	local len2d = self:GetVelocity():Length2D()
	
	if len2d > 150 then self.CalcIdeal = ACT_RUN
	elseif len2d > 50 then self.CalcIdeal = ACT_WALK_ANGRY
	elseif len2d > 5 then self.CalcIdeal = ACT_WALK end
	
	if self:IsJumping() and self:WaterLevel() <= 0 then self.CalcIdeal = ACT_JUMP end
	
	if not self:GetSpecialAnimation() and not self:IsAttacking() then
		if self:GetActivity() ~= self.CalcIdeal and not self:GetStop() then self:StartActivity(self.CalcIdeal) end

		self:BodyMoveXY()
	end

	self:FrameAdvance()
end

function ENT:OnTargetInAttackRange()
    local attack_data = {}
    
    attack_data.dmglow = 35
    attack_data.dmghigh = 40
    attack_data.dmgforce = Vector(0, 0, 0)
	attack_data.dmgdelay = 0.3
	
    self:Attack(attack_data)
end


function ENT:GetPriorityTarget()
	--hellhounds target differently --it's who killed the most?
	if GetConVar("nz_zombie_debug"):GetBool() then print(self, "Retargeting") end
	
	self:SetLastTargetCheck(CurTime())
	
	-- Well if he exists and he is targetable, just target this guy!
	if IsValid(self:GetTarget()) and self:GetTarget():GetTargetPriority() > 0 then
		local dist = self:GetRangeSquaredTo( self:GetTarget():GetPos() )
		if dist < 100000000 then --if they are within 10000 units
			if not self.sprinting then
				self:EmitSound(self.SprintSounds[math.random(#self.SprintSounds)], 100)
				self.sprinting = true
			end
			
			self:SetRunSpeed(250)
			self.loco:SetDesiredSpeed(self:GetRunSpeed())
		elseif not self.sprinting then
			self:SetRunSpeed(100)
			self.loco:SetDesiredSpeed(self:GetRunSpeed())
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
	else self:TimeOut(0.2) end
end

function ENT:IsValidTarget( ent )
	if not ent then return false end
	return IsValid( ent ) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
end