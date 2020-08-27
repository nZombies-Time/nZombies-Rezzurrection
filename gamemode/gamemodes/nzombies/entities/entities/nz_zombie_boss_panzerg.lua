AddCSLuaFile()

ENT.Base = "nz_zombiebase"
ENT.PrintName = "Birkin Stage 1"
ENT.Category = "Brainz"
ENT.Author = "Laby"

ENT.Models = { "models/roach/re2/g1.mdl" }

ENT.AttackRange = 100
ENT.DamageLow = 10
ENT.DamageHigh = 10


ENT.AttackSequences = {
	{seq = "att1", dmgtimes = {1.3}},
	{seq = "att2", dmgtimes = {1.4,1.9,2.9}},
{seq = "att3", dmgtimes = {1.15,1.8}},
{seq = "att11", dmgtimes = {1.2}},
{seq = "att12", dmgtimes = {1.2,1.9,2.6,3.3}}
}

ENT.DeathSequences = {
	"death"
}

ENT.AttackSounds = {
	"re2/em7000/attack1.mp3",
	"re2/em7000/attack2.mp3",
	"re2/em7000/attack3.mp3",
	"re2/em7000/attack4.mp3",
	"re2/em7000/attack5.mp3",
	"re2/em7000/attack6.mp3",
	"re2/em7000/vo/yell1.mp3",
	"re2/em7000/vo/yell2.mp3",
	"re2/em7000/vo/yell3.mp3",
	"re2/em7000/vo/yell4.mp3",
	"re2/em7000/vo/yell5.mp3",
	"re2/em7000/vo/yell6.mp3"
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
	"re2/em7000/hit_body5.mp3",
	"re2/em7000/hit_body6.mp3"
}

ENT.WalkSounds = {
	"re2/em7000/step1.wav"
}

ENT.ActStages = {
	[1] = {
		act = ACT_WALK,
		minspeed = 1,
	},
	[2] = {
		act = ACT_RUN,
		minspeed = 101,
	},
	[3] = {
		act = ACT_RUN,
		minspeed = 180
	}
}

-- We overwrite the Init function because we do not change bodygroups randomly!
function ENT:Initialize()

	self:Precache()

	for i=122,150 do self:ManipulateBoneJiggle(i, 1) end
	
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
		mutated=false
		counting = true
		dying = false
		taunting = true
		self:SetRunSpeed(100)
		self:SetHealth(5000)
		self:SetMaxHealth(50000)
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
	self:NetworkVar("Bool", 3, "Mutated")
end

function ENT:OnSpawn()
	local seq = "slow_flinch_head"
	local tr = util.TraceLine({
		start = self:GetPos() + Vector(0,0,500),
		endpos = self:GetPos(),
		filter = self,
		mask = MASK_SOLID_BRUSHONLY,
	})
	if tr.Hit then seq = "slow_flinch_head" end
	local _, dur = self:LookupSequence(seq)

	-- play emerge animation on spawn
	-- if we have a coroutine else just spawn the zombie without emerging for now.
	if coroutine.running() then
		
		local pos = self:GetPos() + (seq == "slow_flinch_head" and Vector(0,0,100) or Vector(0,0,450))
		for i=1,8 do
			ParticleEffect("bo3_panzer_landing",self:LocalToWorld(Vector(20+(i*2),20,0)),Angle(0,0,0),nil)
		end
		self:EmitSound("re2/em7000/hit_world4.mp3",511,100)
	self:SetInvulnerable(true)
		
		--[[effectData = EffectData()
		effectData:SetStart( pos + Vector(0, 0, 1000) )
		effectData:SetOrigin( pos )
		effectData:SetMagnitude( 0.75 )
		util.Effect("lightning_strike", effectData)]]
		
		self:TimedEvent(dur, function()
			--dust cloud
			self:SetPos(self:GetPos() + Vector(0,0,0))
			self:SetInvulnerable(false)
				self:EmitSound("re2/em7000/vo/help1.mp3",511,100)
			local effectData = EffectData()
			effectData:SetStart( self:GetPos() )
			effectData:SetOrigin( self:GetPos() )
			effectData:SetMagnitude(1)
			self:SetNWBool( "Mutated", false )
		end)
		counting = false
		taunting = false
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
	self:EmitSound("re2/em7000/pain"..math.random(6)..".mp3",511)
	self:ResetSequence(seq)
	self:SetCycle(0)
	timer.Simple(40/115, function()
		if IsValid(self) then
			self:EmitSound("re2/em7000/down_knee"..math.random(5)..".mp3")
		end
	end)
	timer.Simple(dur, function()
		if IsValid(self) then
				self.G2 = ents.Create("nz_zombie_boss_G2")
				self.G2:SetPos(self:GetPos())
				self.G2:Spawn()
		ents.Create("nz_zombie_boss_G2")
			self:Remove()
			ParticleEffect("nbnz_gib_explosion",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
		end
	end)

end

function ENT:BodyUpdate()

	self.CalcIdeal = ACT_IDLE

	local velocity = self:GetVelocity()

	local len2d = velocity:Length2D()

	if ( len2d >101 ) then self.CalcIdeal = ACT_RUN elseif ( len2d > 5 ) then self.CalcIdeal = ACT_WALK end

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

function ENT:bonescaleup(a)
	for i=0,9 do
		timer.Simple(0.1*i,function()
			self:ManipulateBoneScale(self:LookupBone("R_UpperArm_s_scale"), Vector(0.3+(0.05*i),0.5+(0.05*i),0.5+(0.1*i)))
			self:ManipulateBoneScale(self:LookupBone("R_UpperArm_scale"), Vector(0.5+(0.05*i),0.7+(0.05*i),0.7+(0.05*i)))
			self:ManipulateBoneScale(self:LookupBone("R_Forearm_scale"), Vector(0.5+(0.05*i),0.7+(0.05*i),0.7+(0.15*i)))
			self:ManipulateBoneScale(self:LookupBone("R_Palm_scale"), Vector(0.5+(0.05*i),0.7+(0.05*i),0.7+(0.15*i)))
		end)
	end
end

function ENT:OnInjured(dmg)
if math.random(0,1000) == 3 then
if mutated then
self:EmitSound("re2/em7000/pain"..math.random(6)..".mp3")
else
self:EmitSound("re2/em7000/vo/pain_big"..math.random(6)..".mp3")
end
end
	if self:Health()< 500 and self:GetNWBool( "Mutated" )==false then 
	self:ResetSequence("slow_change")
	self:SetRunSpeed(230)
	self.loco:SetDesiredSpeed(self:GetRunSpeed())
	self:Stop()
self:SetNWBool( "Mutated", true )
self:EmitSound("re2/em7000/vo/mutate"..math.random(6)..".mp3",511)
self:EmitSound("re2/em7000/mutate"..math.random(3)..".mp3",511)
local id, dur = self:LookupSequence("slow_change")
timer.Simple(4,function()
self:EmitSound("re2/em7000/mutate_finish"..math.random(6)..".mp3",511)
self:ResetSequence("fast_run")
self:SetStop(false)
end)
self:bonescaleup()
	end
end

function ENT:OnThink()
if self:IsAttacking() then
self.loco:SetDesiredSpeed(0)
end
if !dying and self:Health() > 0 and !counting and !self:IsAttacking() then
counting = true
if self:GetNWBool( "Mutated" ) then
timer.Simple(0.34,function()
self:EmitSound("re2/em7000/step"..math.random(1,6)..".mp3",511)
counting = false
end)
else
timer.Simple(0.65,function()
self:EmitSound("re2/em7000/step"..math.random(1,6)..".mp3",511)
counting = false
end)
end
end

if self:GetNWBool( "Mutated" ) then
self:SetRunSpeed(220)
if math.random(0,800) == 49 and !taunting then
taunting = true
timer.Simple(6,function()
taunting = false
end)
self:EmitSound("re2/em7000/idle"..math.random(6)..".mp3",400)
end
else
if math.random(0,1000) == 3 then
taunting = true
timer.Simple(6,function()
taunting = false
end)
local taunt =  math.random(0,5)
if taunt ==1 then
self:EmitSound("re2/em7000/vo/come_here"..math.random(3)..".mp3",400)
end
if taunt ==2 then
self:EmitSound("re2/em7000/vo/it_hurts"..math.random(4)..".mp3",400)
end
if taunt ==3 then
self:EmitSound("re2/em7000/vo/go_away"..math.random(3)..".mp3",400)
end
if taunt ==4 then
self:EmitSound("re2/em7000/vo/help"..math.random(4)..".mp3",400)
end
if taunt ==5 then
self:EmitSound("re2/em7000/vo/where_are_you.mp3",400)
end
end
end
	if self:GetFlamethrowing() then
		if !self.NextFireParticle or self.NextFireParticle < CurTime() then
			local bone = self:LookupBone("j_elbow_ri")
			local pos, ang = self:GetBonePosition(bone)
			pos = pos - ang:Forward() * 40 - ang:Up()*10
			if CLIENT then
				if !IsValid(self.FireEmitter) then self.FireEmitter = ParticleEmitter(self:GetPos(), false) end
				
				local p = self.FireEmitter:Add("particles/fire1.vmt", pos)
				if p then
					p:SetColor(math.random(30,60), math.random(40,70), math.random(0,50))
					p:SetStartAlpha(255)
					p:SetEndAlpha(0)
					p:SetVelocity(ang:Forward() * -150 + ang:Up()*math.random(-5,5) + ang:Right()*math.random(-5,5))
					p:SetLifeTime(0.25)

					p:SetDieTime(math.Rand(0.75, 1.5))

					p:SetStartSize(math.random(1, 5))
					p:SetEndSize(math.random(20, 30))
					p:SetRoll(math.random(-180, 180))
					p:SetRollDelta(math.Rand(-0.1, 0.1))
					p:SetAirResistance(50)

					p:SetCollide(false)

					p:SetLighting(false)
				end
			else
				if IsValid(self.GrabbedPlayer) then
					if self.GrabbedPlayer:GetPos():DistToSqr(self:GetPos()) > 10000 then
						self:ReleasePlayer()
						self:StopFlames()
						self.loco:SetDesiredSpeed(self:GetRunSpeed())
						self:SetSpecialAnimation(false)
						self:SetBlockAttack(false)	
						self:SetStop(false)
					else
						local dmg = DamageInfo()
						dmg:SetAttacker(self)
						dmg:SetInflictor(self)
						dmg:SetDamage(2)
						dmg:SetDamageType(DMG_BURN)
						
						self.GrabbedPlayer:TakeDamageInfo(dmg)
						self.GrabbedPlayer:Ignite(1, 0)
					end
				else
					local tr = util.TraceHull({
						start = pos,
						endpos = pos - ang:Forward()*150,
						filter = self,
						--mask = MASK_SHOT,
						mins = Vector( -5, -5, -10 ),
						maxs = Vector( 5, 5, 10 ),
					})
					
					debugoverlay.Line(pos, pos - ang:Forward()*150)
					
					if self:IsValidTarget(tr.Entity) then
						local dmg = DamageInfo()
						dmg:SetAttacker(self)
						dmg:SetInflictor(self)
						dmg:SetDamage(2)
						dmg:SetDamageType(DMG_BURN)
						
						tr.Entity:TakeDamageInfo(dmg)
						tr.Entity:Ignite(2, 0)
					end
				end
			end
			
			self.NextFireParticle = CurTime() + 0.05
		end
	elseif CLIENT and self.FireEmitter then
		self.FireEmitter:Finish()
		self.FireEmitter = nil
	end
	
	if SERVER and IsValid(self.GrabbedPlayer) and !self:IsValidTarget(self.GrabbedPlayer) then
		self:ReleasePlayer()
		self:StopFlames()
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
