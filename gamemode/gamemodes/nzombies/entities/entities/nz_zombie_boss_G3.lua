AddCSLuaFile()

ENT.Base = "nz_zombiebase"
ENT.PrintName = "Brutus"
ENT.Category = "Brainz"
ENT.Author = "Laby"

ENT.Models = { "models/bosses/g3v3.mdl" }

ENT.AttackRange = 160
ENT.DamageLow = 99
ENT.DamageHigh = 99


ENT.AttackSequences = {
{seq = "attack1", dmgtimes = {1}},
	{seq = "attack2", dmgtimes = {1.1}},
	{seq = "attack3", dmgtimes = {1.1}},
	{seq = "attack4", dmgtimes = {0.9}},
	{seq = "attack5", dmgtimes = {2,2.6,3,4}}
}

ENT.DeathSequences = {
	"death"
}

ENT.AttackSounds = {
	"re2/em7200/att1.mp3",
	"re2/em7200/att2.mp3",
	"re2/em7200/att3.mp3",
	"re2/em7200/reaction2.mp3"
	
}

ENT.PainSounds = {
"physics/flesh/flesh_impact_bullet1.wav",
	"physics/flesh/flesh_impact_bullet2.wav",
	"physics/flesh/flesh_impact_bullet3.wav",
	"physics/flesh/flesh_impact_bullet4.wav",
	"physics/flesh/flesh_impact_bullet5.wav"
}

ENT.AttackHitSounds = {
	"re2/em7000/hit_body1.mp3",
	"re2/em7000/hit_body2.mp3",
	"re2/em7000/hit_body3.mp3",
	"re2/em7000/hit_body4.mp3",
	"re2/em7000/hit_body5.mp3"
}

ENT.WalkSounds = {
	"re2/em7200/step1.mp3",
	"re2/em7200/step2.mp3",
	"re2/em7200/step3.mp3"
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
	self:SetTargetCheckRange(0) -- 0 for no distance restriction (infinite)

	--target ignore
	self:ResetIgnores()

	self:SetHealth( 75 ) --fallback

	self:SetRunSpeed( self.RunSpeed ) --fallback
	self:SetWalkSpeed( self.WalkSpeed ) --fallback

	self:SetCollisionBounds(Vector(-18,-18, 0), Vector(18, 18, 90))

	self:SetActStage(0)
	self:SetSpecialAnimation(false)

	self:StatsInitialize()
	self:SpecialInit()
	
	-- Fallback for buggy tool
	if !self:GetRunSpeed() then self:SetRunSpeed(145) end

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
		taunting = true
		counting = true
		dying = false
		self:SetRunSpeed(145)
		self:SetHealth(10000)
		self:SetMaxHealth(100000)
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
	local seq = "reaction"
	local tr = util.TraceLine({
		start = self:GetPos() + Vector(0,0,500),
		endpos = self:GetPos(),
		filter = self,
		mask = MASK_SOLID_BRUSHONLY,
	})
	if tr.Hit then seq = "reaction" end
	local _, dur = self:LookupSequence(seq)

	-- play emerge animation on spawn
	-- if we have a coroutine else just spawn the zombie without emerging for now.
	if coroutine.running() then
		
		local pos = self:GetPos() + (seq == "reaction" and Vector(0,0,100) or Vector(0,0,450))
		self:EmitSound("re2/em7200/idle3.mp3",511,100)
		util.ScreenShake(self:GetPos(),10,1000,dur,2048)
		--[[effectData = EffectData()
		effectData:SetStart( pos + Vector(0, 0, 1000) )
		effectData:SetOrigin( pos )
		effectData:SetMagnitude( 0.75 )
		util.Effect("lightning_strike", effectData)]]
		
		self:TimedEvent(dur, function()
			--dust cloud
			self:SetPos(self:GetPos() + Vector(0,0,0))
			local effectData = EffectData()
			effectData:SetStart( self:GetPos() )
			effectData:SetOrigin( self:GetPos() )
			effectData:SetMagnitude(1)
			
		end)
		taunting = false
		counting = false
		self:PlaySequenceAndWait(seq)
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
	self:EmitSound("re2/em7200/reaction1.mp3",511)
	self:ResetSequence(seq)
	self:SetCycle(0)
	timer.Simple(dur, function()
		if IsValid(self) then
		nzPowerUps:SpawnPowerUp(self:GetPos(), "bottle")
			self:Remove()
			ParticleEffect("nbnz_gib_explosion",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
		end
	end)

end

function ENT:BodyUpdate()

	self.CalcIdeal = ACT_IDLE

	local velocity = self:GetVelocity()

	local len2d = velocity:Length2D()

	if ( len2d >200 ) then self.CalcIdeal = ACT_WALK elseif ( len2d > 5 ) then self.CalcIdeal = ACT_WALK end

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

function ENT:OnInjured( dmgInfo )
dmgInfo:ScaleDamage(0.5)
if math.random(0,100) == 49 then
self:EmitSound("re2/em7200/pain"..math.random(3)..".mp3")
end

		
			if  dmgInfo:IsDamageType( 64 ) and dmgInfo:GetDamage() > 10  then
			self:SetInvulnerable(true)
				print("that was not very nice young man")
				hasMutated = true
				self:SetSpecialAnimation(true)
				self:SetBlockAttack(true)
				local id, dur = self:LookupSequence("reaction")
				self:ResetSequence(id)
				self:EmitSound("re2/em7200/reaction1.mp3",511)
				self:SetCycle(0)
				self:SetPlaybackRate(1)
				self.loco:SetDesiredSpeed(0)
				self:SetVelocity(Vector(0,0,0))
				self:TimedEvent(dur, function()
				fuckyoukid = false
					self.loco:SetDesiredSpeed(145)
					self:SetRunSpeed(145)
					self:StartActivity( ACT_WALK)
					self:SetInvulnerable(false)
					self:SetSpecialAnimation(false)
					self:SetBlockAttack(false)
					
				end)
			end
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
self:RemoveAllDecals()
if !dying and self:Health() > 0 and !counting and !self:IsAttacking() and !self:GetSpecialAnimation() then
counting = true
timer.Simple(0.5,function()
self:EmitSound("enemies/bosses/re2/em7100/step"..math.random(1,2)..".ogg",511)
counting = false
end)
end
if !taunting and math.random(0,800) == 49 then
taunting = true
timer.Simple(4,function()
taunting = false
end)
if  math.random(0,1) == 1 then
self:EmitSound("re2/em7200/idle"..math.random(3)..".mp3")
else
self:EmitSound("re2/em7200/breathe"..math.random(3)..".mp3")
end
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
