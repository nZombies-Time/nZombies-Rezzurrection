AddCSLuaFile()

ENT.Base = "nz_zombiebase"
ENT.PrintName = "Raptor"
ENT.Category = "Brainz"
ENT.Author = "Laby"

ENT.Models = { "models/specials/turok_raptor.mdl" }

ENT.AttackRange = 75
ENT.DamageLow = 20
ENT.DamageHigh = 24

ENT.AttackSequences = {
	{seq = "attack", dmgtimes = {0.3}},
	{seq = "attack2", dmgtimes = {0.5}, 0.9}},
	{seq = "attack3", dmgtimes = {0.5}}



ENT.DeathSequences = {
	"stunnedidle"
}

ENT.AttackSounds = {
	"enemies/specials/turok raptor/attack1.ogg",
	"enemies/specials/turok raptor/attack2.ogg",
	"enemies/specials/turok raptor/attack3.ogg",
	"enemies/specials/turok raptor/attack4.ogg",
	"enemies/specials/turok raptor/attack5.ogg",
	"enemies/specials/turok raptor/attack6.ogg",
	"enemies/specials/turok raptor/attack7.ogg",
	"enemies/specials/turok raptor/biteattack1.ogg",
	"enemies/specials/turok raptor/biteattack2.ogg",
	"enemies/specials/turok raptor/biteattack3.ogg",

}

ENT.PainSounds = {
"physics/flesh/flesh_impact_bullet1.wav",
	"physics/flesh/flesh_impact_bullet2.wav",
	"physics/flesh/flesh_impact_bullet3.wav",
	"physics/flesh/flesh_impact_bullet4.wav",
	"physics/flesh/flesh_impact_bullet5.wav"
}

ENT.AttackHitSounds = {
	"effects/hit/evt_zombie_hit_player_01.ogg",
	"effects/hit/evt_zombie_hit_player_02.ogg",
	"effects/hit/evt_zombie_hit_player_03.ogg",
	"effects/hit/evt_zombie_hit_player_04.ogg",
	"effects/hit/evt_zombie_hit_player_05.ogg",
}

ENT.WalkSounds = {
	"enemies/specials/turok raptor/breath.ogg",
	"enemies/specials/turok raptor/breath2.ogg",
	"enemies/specials/turok raptor/breath3.ogg",
	"enemies/specials/turok raptor/breath4.ogg",
	"enemies/specials/turok raptor/breath5.ogg",
	"enemies/specials/turok raptor/breath6.ogg",
	"enemies/specials/turok raptor/breath7.ogg",
	"enemies/specials/turok raptor/breath8.ogg",
	"enemies/specials/turok raptor/breath9.ogg",
	"enemies/specials/turok raptor/breath10.ogg",
	"enemies/specials/turok raptor/breath11.ogg",
	"enemies/specials/turok raptor/breath12.ogg",
	"enemies/specials/turok raptor/breath13.ogg"

}


ENT.ActStages = {
	[1] = {
		act = ACT_WALK,
		minspeed = 0,
	},
	[2] = {
		act = ACT_RUN,
		minspeed = 250,
	},
	[3] = {
		act = ACT_RUN,
		minspeed = 325
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
		counting = true
		dying = false
		self:SetRunSpeed(225)
		self:SetHealth(300)
		self:SetMaxHealth(10000)
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
	local seq = "scream"
	local tr = util.TraceLine({
		start = self:GetPos() + Vector(0,0,500),
		endpos = self:GetPos(),
		filter = self,
		mask = MASK_SOLID_BRUSHONLY,
	})
	if tr.Hit then seq = "scream" end
	local _, dur = self:LookupSequence(seq)

	-- play emerge animation on spawn
	-- if we have a coroutine else just spawn the zombie without emerging for now.
	if coroutine.running() then
		
		local pos = self:GetPos() + (seq == "emerge" and Vector(0,0,100) or Vector(0,0,450))
		
		ParticleEffect("bo3_zombie_spawn",self:LocalToWorld(Vector(40,-20,0)),Angle(0,0,0),nil)
		self:EmitSound("enemies/specials/turok raptor/scream"..math.random(1,5)..".ogg",511)
	
		
		--[[effectData = EffectData()
		effectData:SetStart( pos + Vector(0, 0, 1000) )
		effectData:SetOrigin( pos )
		effectData:SetMagnitude( 0.75 )
		util.Effect("lightning_strike", effectData)]]
		
			
		self:PlaySequenceAndWait(seq)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		counting = false
	end
end

function ENT:OnZombieDeath(dmgInfo)
	dying = true
	self:ReleasePlayer()
	self:StopFlames()
	self:SetRunSpeed(0)
	self.loco:SetVelocity(Vector(0,0,0))
	self:Stop()
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	local seq, dur = self:LookupSequence(self.DeathSequences[math.random(#self.DeathSequences)])
	self:ResetSequence(seq)
	self:SetCycle(0)
	self:EmitSound("enemies/specials/turok raptor/death"..math.random(1,12)..".ogg",511)
ParticleEffect("bo3_margwa_death",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
	timer.Simple(dur, function()
		if IsValid(self) then
			self:Remove()
		end
	end)

end

function ENT:BodyUpdate()


	self.CalcIdeal = ACT_IDLE

	local velocity = self:GetVelocity()

	local len2d = velocity:Length2D()

	if ( len2d > 250 ) then self.CalcIdeal = ACT_RUN elseif ( len2d > 0 ) then self.CalcIdeal = ACT_WALK end

	if self:IsJumping() and self:WaterLevel() <= 0 then
		self.CalcIdeal = ACT_JUMP
	end

	if !self:GetSpecialAnimation() and !self:IsAttacking() then
		if self:GetActivity() != self.CalcIdeal and !self:GetStop() then self:StartActivity(self.CalcIdeal) end

		if self.ActStages[self:GetActStage()] then
			self:BodyMoveXY()
		end
	end

	self:FrameAdvance()

end

function ENT:OnPathTimeOut()
	
end

function ENT:IsValidTarget( ent )
	if not ent then return false end
	return IsValid( ent ) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
end

-- This function is run every time a path times out, once every 1 seconds of pathing

if CLIENT then
	local eyeGlow =  Material( "sprites/redglow1" )
	local white = Color( 255, 255, 255, 255 )
	local lightglow = Material( "sprites/physg_glow1_noz" )
	local lightyellow = Color( 255, 255, 200, 200 )
	local clawglow = Material( "sprites/orangecore1" )
	local clawred = Color( 255, 100, 100, 255 )
end

function ENT:OnRemove()
	if IsValid(self.ClawHook) then self.ClawHook:Remove() end
	if IsValid(self.GrabbedPlayer) then self.GrabbedPlayer:SetMoveType(MOVETYPE_WALK) end
	if IsValid(self.FireEmitter) then self.FireEmitter:Finish() end
end

function ENT:StartFlames(time)
	self:Stop()
	if time then self:TimedEvent(time, function() self:StopFlames() end) end
end

function ENT:StopFlames()
	self:SetStop(false)
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
				self:StartActivity( ACT_RUN )
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
timer.Simple(0.25,function()
if  self:IsValid() then
self:EmitSound("enemies/specials/turok raptor/foot"..math.random(1,7)..".ogg")
counting = false
end
end)
end
end

function ENT:GrabPlayer(ply)
	if CLIENT then return end
	
	
	self:SetUsingClaw(false)
	self:SetStop(false)
	self.loco:SetDesiredSpeed(self:GetRunSpeed())
	
	if self:IsValidTarget(ply) then
		self.GrabbedPlayer = ply
		
		self:TimedEvent(0, function()
			local att = self:GetAttachment(self:LookupAttachment("clawlight"))
			local pos = att.Pos + att.Ang:Forward()*10
			
			ply:SetPos(pos - Vector(0,0,50))
			ply:SetMoveType(MOVETYPE_NONE)
		end)
		
		
		self:SetSequence(self:LookupSequence("nz_grapple_flamethrower"))
		self:SetCycle(0)
		self:StartFlames()
	--[[elseif ply then
		self.loco:SetDesiredSpeed(self:GetRunSpeed())
		self:SetSpecialAnimation(false)
		self:SetBlockAttack(false)
		self:SetStop(false)]]
	else
		
	end
end

function ENT:ReleasePlayer()
	if IsValid(self.GrabbedPlayer) then
		self.GrabbedPlayer:SetMoveType(MOVETYPE_WALK)
	end
	if IsValid(self.ClawHook) then
		self.ClawHook:Release()
	end
	if !self:GetFlamethrowing() then
		self:SetStop(false)
	end
	self:SetUsingClaw(false)
	self:SetStop(false)
	self.loco:SetDesiredSpeed(self:GetRunSpeed())
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
