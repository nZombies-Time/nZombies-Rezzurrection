AddCSLuaFile()

ENT.Base = "nz_zombiebase"
ENT.PrintName = "nova"
ENT.Category = "Brainz"
ENT.Author = "Ruko"

--ENT.Models = { "models/boz/killmeplease.mdl" }
ENT.Models = { "models/roach/bo1_overhaul/quadcrawler.mdl" }

ENT.AttackRange = 80
ENT.DamageLow = 30
ENT.DamageHigh = 45

ENT.AttackSequences = {
	{seq = "attack1"},
	{seq = "attack2"},
	{seq = "attack3"},
	{seq = "attack4"},
	{seq = "attack5"},
}

ENT.DeathSequences = {
	"death1",
}

ENT.AttackSounds = {
	"bo1_overhaul/n6/att.mp3"
}

ENT.AttackHitSounds = {
	"bo1_overhaul/nz/evt_zombie_hit_player_0.mp3"
}

ENT.WalkSounds = {
	"bo1_overhaul/n6/crawl.mp3"
}

ENT.PainSounds = {
	"physics/flesh/flesh_impact_bullet1.wav",
	"physics/flesh/flesh_impact_bullet2.wav",
	"physics/flesh/flesh_impact_bullet3.wav",
	"physics/flesh/flesh_impact_bullet4.wav",
	"physics/flesh/flesh_impact_bullet5.wav"
}

ENT.DeathSounds = {
	"bo1_overhaul/n6/die1.mp3",
	"bo1_overhaul/n6/die2.mp3",
	"bo1_overhaul/n6/die3.mp3",
	"bo1_overhaul/n6/die4.mp3"
}

ENT.SprintSounds = {
	"bo1_overhaul/n6/crawl1.mp3"
}

ENT.JumpSequences = {seq = ACT_JUMP, speed = 30}

ENT.ActStages = {
	[1] = {
		act = ACT_WALK,
		minspeed = 5,
	},
	[2] = {
		act = ACT_WALK,
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
	hasExploded = false
		if nzRound:GetNumber() == -1 then
			self:SetRunSpeed( math.random(60, 600) )
			self:SetHealth( math.random(200, 30000) )
		else
			local speeds = nzRound:GetZombieSpeeds()
			if speeds then
				self:SetRunSpeed( nzMisc.WeightedRandom(speeds) )
			else
				self:SetRunSpeed( 200 )
			end
			self:SetHealth( nzRound:GetZombieHealth() or 200 )
		end
	end
end

function ENT:OnSpawn()

	--self:SetNoDraw(true) -- Start off invisible while in the prespawn effect
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS) -- Don't collide in this state
	self:Stop() -- Also don't do anything
	
	ParticleEffectAttach("novagas_trail",PATTACH_POINT_FOLLOW,self,1)

	ParticleEffect("strider_impale_ground",self:GetPos(),self:GetAngles(),self)
	self:EmitSound("bo1_overhaul/dirtintro"..math.random(2)..".mp3")
	self.IsIntroducing = true
		for i=1,40 do
			timer.Simple(0.1*i,function()
				ParticleEffect("advisor_healthcharger_break",self:LocalToWorld(Vector(20,0,-10)),self:GetAngles(),self)
			end)
		end
	self.IsIntroducing = false

	local effectData = EffectData()
	effectData:SetOrigin( self:GetPos() )
	effectData:SetMagnitude( 2 )
	effectData:SetEntity(nil)
	util.Effect("zombie_spawn_dust", effectData)
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
			util.Effect("zombie_spawn_dust", effectData)

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
	if (dmgInfo:IsDamageType( 2 ) and !hasExploded) then
			for k,v in pairs(ents.FindInSphere(self:GetPos(),100)) do
						if v:IsPlayer() then
						local walk = v:GetWalkSpeed()
						local run = v:GetRunSpeed()
						v:SetDSP(34, false)
							v:SetRunSpeed(25)
							v:SetWalkSpeed(25)
							timer.Simple(1.2,function()
								v:SetRunSpeed(run)
							v:SetWalkSpeed(walk)
							end)
						end
	end
        self:SetNoDraw(true)
        hasExploded = true
            local ent = ents.Create("env_explosion")
        ent:SetPos(self:GetPos())
        ent:SetAngles(self:GetAngles())
        ent:Spawn()
        ent:SetKeyValue("imagnitude", "20")
		ent:SetKeyValue("iradiusoverride", "67")
        ent:Fire("explode")
	self:EmitSound("bo1_overhaul/n6/xplo"..math.random(2)..".mp3")
	ParticleEffect("novagas_xplo",self:GetPos(),self:GetAngles(),nil)
		local vaporizer = ents.Create("point_hurt")
		if !vaporizer:IsValid() then return end
		vaporizer:SetKeyValue("Damage", 0.1)
		vaporizer:SetKeyValue("DamageRadius", 100)
		vaporizer:SetKeyValue("DamageDelay", 0.25)
		vaporizer:SetKeyValue("DamageType",DMG_NERVEGAS)
		vaporizer:SetPos(self:GetPos())
		vaporizer:SetOwner(self)
		vaporizer:Spawn()
		vaporizer:Fire("TurnOn","",0)
		vaporizer:Fire("kill","",18)
		end
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

	if ( len2d > 150 ) then self.CalcIdeal = ACT_RUN elseif ( len2d > 50 ) then self.CalcIdeal = ACT_WALK elseif ( len2d > 5 ) then self.CalcIdeal = ACT_WALK end

	if self:IsJumping() and self:WaterLevel() <= 0 then
		self.CalcIdeal = ACT_JUMP
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
    atkData.dmglow = 30
    atkData.dmghigh = 45
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
	if !ent then return false end
	return IsValid( ent ) and ent:GetTargetPriority() != TARGET_PRIORITY_NONE and ent:GetTargetPriority() != TARGET_PRIORITY_SPECIAL
	-- Won't go for special targets (Monkeys), but still MAX, ALWAYS and so on
end