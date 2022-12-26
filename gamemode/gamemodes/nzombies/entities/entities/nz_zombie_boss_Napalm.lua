AddCSLuaFile()

ENT.Base = "nz_zombiebase"
ENT.PrintName = "Napalm_Zombie"
ENT.Category = "Brainz"
ENT.Author = "Laby"

ENT.Models = { "models/bosses/temple_zom.mdl" }

ENT.AttackRange = 115
ENT.DamageLow = 1
ENT.DamageHigh = 1


ENT.AttackSequences = {
	{seq = "suicide1"},
	{seq = "suicide2"},
	{seq = "suicide3"}
}

ENT.DeathSequences = {
	"death2",
	"suicide1",
	"suicide2",
	"suicide3"
}

ENT.AttackSounds = {
	"enemies/bosses/nap/spawn.ogg",
}

ENT.AttackHitSounds = {
	"enemies/bosses/nap/step3.ogg"
}

ENT.PainSounds = {
	"physics/flesh/flesh_impact_bullet1.wav",
	"physics/flesh/flesh_impact_bullet2.wav",
	"physics/flesh/flesh_impact_bullet3.wav",
	"physics/flesh/flesh_impact_bullet4.wav",
	"physics/flesh/flesh_impact_bullet5.wav"
}

ENT.WalkSounds = {
	"enemies/bosses/nap/amb1.ogg",
	"enemies/bosses/nap/amb2.ogg",
	"enemies/bosses/nap/amb3.ogg"
}

ENT.ActStages = {
	[1] = {
		act = ACT_WALK,
		minspeed = 1,
	}
}

-- We overwrite the Init function because we do not change bodygroups randomly!
function ENT:Initialize()

	self:Precache()

	self:SetModel( self.Models[math.random( #self.Models )] )

	self:SetJumping( false )
	self:SetLastLand( CurTime() + 1 ) --prevent jumping after spawn
	self:SetLastTargetCheck( CurTime() )
	self:SetLastTargetChange( CurTime() )

	--sounds
	self:SetNextMoanSound( CurTime() + 1 )

	--stuck prevetion
	self:SetLastPush( CurTime() )
	self:SetLastPostionSave( CurTime() )
	self:SetStuckAt( self:GetPos() )
	self:SetStuckCounter( 0 )
	
	self:SetAttacking( false )
	self:SetLastAttack( CurTime() )
	self:SetAttackRange( self.AttackRange )
	self:SetTargetCheckRange(1250) -- 0 for no distance restriction (infinite)

	--target ignore
	self:ResetIgnores()

	self:SetHealth( 75 ) --fallback

	self:SetRunSpeed( self.RunSpeed ) --fallback
	self:SetWalkSpeed( self.WalkSpeed ) --fallback

	self:SetCollisionBounds(Vector(-16,-16, 0), Vector(16, 16, 70))

	self:SetActStage(0)
	self:SetSpecialAnimation(false)

	self:StatsInitialize()
	self:SpecialInit()
	
	-- Fallback for buggy tool
	if !self:GetRunSpeed() then self:SetRunSpeed(150) end

	if SERVER then
		self.loco:SetDeathDropHeight( self.DeathDropHeight )
		self.loco:SetDesiredSpeed( self:GetRunSpeed() )
		self.loco:SetAcceleration( self.Acceleration )
		self.loco:SetJumpHeight( self.JumpHeight )
		if GetConVar("nz_zombie_lagcompensated"):GetBool() then
			self:SetLagCompensated(true)
		end
		
		self.HelmetDamage = 0 -- Used to save how much damage the light has taken
		self:SetUsingClaw(false)
		
		self.NextAction = 0
		self.NextClawTime = 0
		self.NextFlameTime = 0
	end
	
	self.ZombieAlive = true

end

function ENT:StatsInitialize()
	if SERVER then
		hasExploded = false
		self:SetRunSpeed(41)
		self:SetHealth(1000)
		self:SetMaxHealth(3000)
		dying = false
		counting = true
	end

	--PrintTable(self:GetSequenceList())
end

function ENT:SpecialInit()

	if CLIENT then
		--make them invisible for a really short duration to blend the emerge sequences
		self:SetNoDraw(true)
		self:TimedEvent( 0.5, function()
			self:SetNoDraw(false)
		end)

		self:SetRenderClipPlaneEnabled( true )
		self:SetRenderClipPlane(self:GetUp(), self:GetUp():Dot(self:GetPos()))

		self:TimedEvent( 2, function()
			self:SetRenderClipPlaneEnabled(false)
		end)

	end
end

function ENT:InitDataTables()
	self:NetworkVar("Entity", 0, "ClawHook")
	self:NetworkVar("Bool", 1, "UsingClaw")
	self:NetworkVar("Bool", 2, "Flamethrowing")
end

function ENT:OnSpawn()

	local seq = "drg_jump"
	local tr = util.TraceLine({
		start = self:GetPos() + Vector(0,0,500),
		endpos = self:GetPos(),
		filter = self,
		mask = MASK_SOLID_BRUSHONLY,
	})
    if tr.Hit then 
        seq = "drg_jump"
    end
    local _, dur = self:LookupSequence(seq)

    self.spawning = true
    timer.Simple(dur, function()
        self:ResetSequence( math.random(5, 7) )
        self.spawning = false
    end)

	-- play emerge animation on spawn
	-- if we have a coroutine else just spawn the zombie without emerging for now.
	if coroutine.running() then
	    local pos = self:GetPos() + (seq == "drg_jump" and Vector(0,0,100) or Vector(0,0,450))
		
		local effectData = EffectData()
		effectData:SetStart( pos )
		effectData:SetOrigin( pos )
		effectData:SetMagnitude(1)
		self:EmitSound("enemies/bosses/nap/spawn.ogg",511)
		local entParticle = ents.Create("info_particle_system")
		entParticle:SetKeyValue("start_active", "1")
		entParticle:SetKeyValue("effect_name", "napalm_emerge")
		entParticle:SetPos(self:GetPos())
		entParticle:SetAngles(self:GetAngles())
		entParticle:Spawn()
		entParticle:Activate()
		entParticle:Fire("kill","",2)
			self:EmitSound("nz/zombies/spawn/zm_spawn_dirt"..math.random(2)..".wav")
		ParticleEffectAttach("firestaff_victim_burning",PATTACH_ABSORIGIN_FOLLOW,self,0)
        self:SetInvulnerable(true)
		
		--[[effectData = EffectData()
		effectData:SetStart( pos + Vector(0, 0, 1000) )
		effectData:SetOrigin( pos )
		effectData:SetMagnitude( 0.75 )
		util.Effect("lightning_strike", effectData)]]
		
		self:TimedEvent(dur, function()
			--dust cloud
			self:SetInvulnerable(false)
			local effectData = EffectData()
			effectData:SetStart( self:GetPos() )
			effectData:SetOrigin( self:GetPos() )
			effectData:SetMagnitude(1)
	
			self.loco:SetDesiredSpeed(41)
			counting = false
		end)
		self:PlaySequenceAndWait(seq)
	end
end

function ENT:OnZombieDeath(dmgInfo)
	dying = true
	--self:ReleasePlayer()
	--self:StopFlames()
	self:SetRunSpeed(0)
	self.loco:SetVelocity(Vector(0,0,0))
	--self:Stop()
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

		if IsValid(self) then
			
			util.ScreenShake(self:GetPos(),12,400,3,1000)
			self:EmitSound("enemies/bosses/nap/explode.ogg",511)
            local ent = ents.Create("env_explosion")
        ent:SetPos(self:GetPos())
        ent:SetAngles(self:GetAngles())
        ent:Spawn()
        ent:SetKeyValue("imagnitude", "200")
        ent:Fire("explode")
            local entParticle = ents.Create("info_particle_system")
            entParticle:SetKeyValue("start_active", "1")
            entParticle:SetKeyValue("effect_name", "napalm_postdeath_napalm")
            entParticle:SetPos(self:GetPos())
            entParticle:SetAngles(self:GetAngles())
            entParticle:Spawn()
            entParticle:Activate()
            entParticle:Fire("kill","",20)
            local vaporizer = ents.Create("point_hurt")
            if !vaporizer:IsValid() then return end
            vaporizer:SetKeyValue("Damage", 22)
            vaporizer:SetKeyValue("DamageRadius", 150)
            vaporizer:SetKeyValue("DamageType",DMG_BURN)
            vaporizer:SetPos(self:GetPos())
            vaporizer:SetOwner(self)
            vaporizer:Spawn()
            vaporizer:Fire("TurnOn","",0)
            vaporizer:Fire("kill","",20)
			--util.Effect("Explosion", effectData)
			self:Remove()
		end
	

end

function ENT:BodyUpdate()
    
	self.CalcIdeal = ACT_WALK

	local velocity = self:GetVelocity()

	local len2d = velocity:Length2D()

    if ( len2d > 60 ) then 
        self.CalcIdeal = ACT_WALK 
    elseif ( len2d > 5 ) then 
        self.CalcIdeal = ACT_WALK 
    end

	if self:IsJumping() and self:WaterLevel() <= 0 then
		self.CalcIdeal = ACT_JUMP
	end

	if !self:GetSpecialAnimation() and !self:IsAttacking() then
        if self:GetActivity() != self.CalcIdeal and !self:GetStop() then 
            self:ResetSequence(5) 
            self:StartActivity(self.CalcIdeal) 
        end

        local curseq = self:GetSequence()
        if !self.spawning and (curseq != 5 and curseq != 6 and curseq != 7) then
            self:ResetSequence( math.random(5, 7) )
        end

        if self.ActStages[self:GetActStage()] then
			self:BodyMoveXY()
		end
    end
    
	self:FrameAdvance()

end

function ENT:IsValidTarget( ent )
	if !ent then return false end
	return IsValid( ent ) and ent:GetTargetPriority() != TARGET_PRIORITY_NONE and ent:GetTargetPriority() != TARGET_PRIORITY_SPECIAL
	-- Won't go for special targets (Monkeys), but still MAX, ALWAYS and so on
end

-- This function is run every time a path times out, once every 1 seconds of pathing

if CLIENT then
	local eyeGlow =  Material( "sprites/redglow1" )
	local white = Color( 255, 255, 255, 255 )
	local lightglow = Material( "sprites/physg_glow1_noz" )
	local lightyellow = Color( 255, 255, 200, 200 )
	local clawglow = Material( "sprites/orangecore1" )
	local clawred = Color( 255, 100, 100, 255 )
	function ENT:Draw()
		self:DrawModel()

	end
end

function ENT:StartFlames(time)
	self:Stop()
	if time then self:TimedEvent(time, function() self:StopFlames() end) end
end

function ENT:StopFlames()
	self:SetStop(false)
end

function ENT:KILLAQUEEN()
      --local effectdata = EffectData()
      --effectdata:SetOrigin( self:GetPos() )
      --util.Effect("hound_explosion", effectdata)
	  ParticleEffect("hound_explosion",self:GetPos() + Vector(0,0,40),self:GetAngles(),self)
	util.ScreenShake(self:GetPos(),12,400,3,1000)
			self:EmitSound("enemies/bosses/nap/explode.ogg",511)
            local ent = ents.Create("env_explosion")
        ent:SetPos(self:GetPos())
        ent:SetAngles(self:GetAngles())
        ent:Spawn()
		 ent:SetKeyValue("ignoredEntity", "self")
        ent:SetKeyValue("iRadiusOverride", "400")
		ent:SetKeyValue("imagnitude", "75")
        ent:Fire("explode")
		for k, v in pairs(ents.FindInSphere(self:GetPos(), 400)) do
					if v:IsPlayer() then
						v:Ignite(5)
					end
		end
		 self:TimedEvent(5, function()
self:SetBlockAttack(false)
 end)
end

function ENT:OnTargetInAttackRange()
dying = true
self:TimedEvent(1.9, function()
 self:KILLAQUEEN() 
 self:SetBlockAttack(true)
 end)

 local atkData = {}
    atkData.dmglow = 5
    atkData.dmghigh = 5
	atkData.dmgforce = Vector( -2, -2, 0 )
	atkData.dmgtype = DMG_BURN
    self:Attack( atkData )
end

function ENT:PlayAttackAndWait( name, speed )

	local len = self:SetSequence( name )
	speed = speed or 1

	self:ResetSequenceInfo()
	self:SetCycle( 0 )
	self:SetPlaybackRate( speed )

	local endtime = CurTime() + len / speed

	while ( true ) do

		if ( endtime < CurTime() ) then
			if !self:GetStop() then
				self:StartActivity( ACT_WALK )
				self.loco:SetDesiredSpeed( self:GetRunSpeed() )
			end
			return
		end

		coroutine.yield()

	end

end

function ENT:OnThink()
if !counting and !dying and self:Health() > 0 then
counting = true
timer.Simple(0.8,function()
self:EmitSound("enemies/bosses/nap/step"..math.random(1,3)..".ogg")
counting = false
end)
end
	
end

function ENT:OnBarricadeBlocking( barricade )
	if (IsValid(barricade) and barricade:GetClass() == "breakable_entry" ) then
		if barricade:GetNumPlanks() > 0 then
			timer.Simple(0.3, function()

				for i = 1, barricade:GetNumPlanks() do
					barricade:EmitSound("physics/wood/wood_plank_break" .. math.random(1, 4) .. ".wav", 100, math.random(90, 130))
					barricade:RemovePlank()
				end

			end)

			self:SetAngles(Angle(0,(barricade:GetPos()-self:GetPos()):Angle()[2],0))
			
			local seq, dur

			local attacktbl = self.ActStages[1] and self.ActStages[1].attackanims or self.AttackSequences
			local target = type(attacktbl) == "table" and attacktbl[math.random(#attacktbl)] or attacktbl
			
			if type(target) == "table" then
				seq, dur = self:LookupSequenceAct(target.seq)
			elseif target then -- It is a string or ACT
				seq, dur = self:LookupSequenceAct(target)
			else
				seq, dur = self:LookupSequence("swing")
			end
			
			self:SetAttacking(true)
			self:PlaySequenceAndWait(seq, 1)
			self:SetLastAttack(CurTime())
			self:SetAttacking(false)
			self:UpdateSequence()
			if coroutine.running() then
				coroutine.wait(2 - dur)
			end

			-- this will cause zombies to attack the barricade until it's destroyed
			local stillBlocked = self:CheckForBarricade()
			if stillBlocked then
				self:OnBarricadeBlocking(stillBlocked)
				return
			end

			-- Attacking a new barricade resets the counter
			self.BarricadeJumpTries = 0
		elseif barricade:GetTriggerJumps() and self.TriggerBarricadeJump then
			local dist = barricade:GetPos():DistToSqr(self:GetPos())
			if dist <= 3500 + (1000 * self.BarricadeJumpTries) then
				self:TriggerBarricadeJump()
				self.BarricadeJumpTries = 0
			else
				-- If we continuously fail, we need to increase the check range (if it is a bigger prop)
				self.BarricadeJumpTries = self.BarricadeJumpTries + 1
				-- Otherwise they'd get continuously stuck on slightly bigger props :(
			end
		else
			self:SetAttacking(false)
		end
	end
end
