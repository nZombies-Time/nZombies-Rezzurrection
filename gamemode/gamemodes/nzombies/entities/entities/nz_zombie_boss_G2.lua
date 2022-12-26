AddCSLuaFile()

ENT.Base = "nz_zombiebase"
ENT.PrintName = "Birkin Stage 2"
ENT.Category = "Brainz"
ENT.Author = "Laby"

ENT.Models = { "models/bosses/g2v2.mdl" }

ENT.AttackRange = 110
ENT.DamageLow = 75
ENT.DamageHigh = 85


ENT.AttackSequences = {
	{seq = "attack1", dmgtimes = {0.9}},
{seq = "atack_big2b", dmgtimes = {0.8}},
{seq = "attack_grab_1", dmgtimes = {1.1}},
 {seq = "attack_big3b", dmgtimes =  {1}}
}

ENT.DeathSequences = {
	"death"
}

ENT.AttackSounds = {
	"enemies/bosses/re2/em7100/att1.ogg",
	"enemies/bosses/re2/em7100/att2.ogg",
	"enemies/bosses/re2/em7100/att3.ogg",
	"enemies/bosses/re2/em7100/att4.ogg",
	"enemies/bosses/re2/em7100/att5.ogg",
	"enemies/bosses/re2/em7100/att6.ogg",
	"enemies/bosses/re2/em7100/yell1.ogg",
	"enemies/bosses/re2/em7100/yell2.ogg",
	"enemies/bosses/re2/em7100/yell3.ogg",
	"enemies/bosses/re2/em7100/yell4.ogg",
	"enemies/bosses/re2/em7100/yell5.ogg",
	"enemies/bosses/re2/em7100/yell6.ogg"
	
}

ENT.PainSounds = {
"physics/flesh/flesh_impact_bullet1.wav",
	"physics/flesh/flesh_impact_bullet2.wav",
	"physics/flesh/flesh_impact_bullet3.wav",
	"physics/flesh/flesh_impact_bullet4.wav",
	"physics/flesh/flesh_impact_bullet5.wav"
}

ENT.AttackHitSounds = {
	"enemies/bosses/re2/em7000/hit_body1.ogg",
	"enemies/bosses/re2/em7000/hit_body2.ogg",
	"enemies/bosses/re2/em7000/hit_body3.ogg",
	"enemies/bosses/re2/em7000/hit_body4.ogg",
	"enemies/bosses/re2/em7000/hit_body5.ogg",
	"enemies/bosses/re2/em7000/hit_body6.ogg",
}

ENT.WalkSounds = {
	"enemies/bosses/re2/em7000/step1.ogg",
}

ENT.ActStages = {
	[1] = {
		act = ACT_WALK,
		minspeed = 1,
	},
	[2] = {
		act = ACT_RUN,
		minspeed = 150,
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

	self:SetCollisionBounds(Vector(-16,-16, 0), Vector(16, 40, 90))
	

	self:SetActStage(0)
	self:SetSpecialAnimation(false)

	self:StatsInitialize()
	self:SpecialInit()
	
	-- Fallback for buggy tool
	if !self:GetRunSpeed() then self:SetRunSpeed(160) end

	if SERVER then
		self.loco:SetDeathDropHeight( self.DeathDropHeight )
		self.loco:SetDesiredSpeed( self:GetRunSpeed() )
		self.loco:SetAcceleration( self.Acceleration )
		self.loco:SetJumpHeight( self.JumpHeight )
		if GetConVar("nz_zombie_lagcompensated"):GetBool() then
			self:SetLagCompensated(true)
		end
		
		self.HelmetDamage = 0 -- Used to save how much damage the light has taken
		--self:SetUsingClaw(false)
		
		self.NextAction = 0
		self.NextClawTime = 0
		self.NextFlameTime = 0
	end
	
	self.ZombieAlive = true

end

function ENT:StatsInitialize()
	if SERVER then
		dying = false
		counting = true
		taunting = true
		fuckyoukid = false
		baseHealth = 0
		self:SetRunSpeed(90)
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

function ENT:OnSpawn()
	local seq = "attack_big3a"
	local tr = util.TraceLine({
		start = self:GetPos() + Vector(0,0,500),
		endpos = self:GetPos(),
		filter = self,
		mask = MASK_SOLID_BRUSHONLY,
	})
	if tr.Hit then seq = "attack_big3a" end
	local _, dur = self:LookupSequence(seq)

	-- play emerge animation on spawn
	-- if we have a coroutine else just spawn the zombie without emerging for now.
	if coroutine.running() then
		
		local pos = self:GetPos() + (seq == "attack_big3a" and Vector(0,0,100) or Vector(0,0,450))
		self:EmitSound("enemies/bosses/re2/em7100/yell5.ogg",511,100)
		
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
		self:PlaySequenceAndWait(seq)
		counting = false
		taunting = false
		baseHealth = self:Health()
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
	self:EmitSound("enemies/bosses/re2/em7100/pain"..math.random(6)..".ogg",511)
	self:ResetSequence(seq)
	self:SetCycle(0)
	timer.Simple(dur, function()
		if IsValid(self) then
				self.G2 = ents.Create("nz_zombie_boss_G3")
				self.G2:SetPos(self:GetPos())
				self.G2:Spawn()
				self.G2:SetHealth(nzRound:GetNumber() * 1000 + 3100)
			self:Remove()
			ParticleEffect("nbnz_gib_explosion",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
		end
	end)

end

function ENT:IsValidTarget( ent )
	if !ent then return false end
	return IsValid( ent ) and ent:GetTargetPriority() != TARGET_PRIORITY_NONE and ent:GetTargetPriority() != TARGET_PRIORITY_SPECIAL
	-- Won't go for special targets (Monkeys), but still MAX, ALWAYS and so on
end

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


function ENT:BodyUpdate()

	self.CalcIdeal = ACT_IDLE

	local velocity = self:GetVelocity()

	local len2d = velocity:Length2D()

	if ( len2d > 200 ) then self.CalcIdeal = ACT_RUN elseif ( len2d > 5 ) then self.CalcIdeal = ACT_WALK end

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

function ENT:StartFlames(time)
	
end

function ENT:StopFlames()
	
end

function ENT:OnTargetInAttackRange()
 if self:GetRunSpeed() > 200 then
  local atkData = {}
    atkData.dmglow = 140
    atkData.dmghigh = 140
    self:Attack( atkData )
	else
	self:Attack()
end
end

function ENT:OnPathTimeOut()
	local target = self:GetTarget()
	if CurTime() < self.NextAction then return end
	local distToTarget = self:GetPos():Distance(target:GetPos())
	if math.random(0,7) == 0 and CurTime() > self.NextClawTime then
		-- BRING ME THOSE CHEEKS
		if self:IsValidTarget(target) then
			local tr = util.TraceLine({
				start = self:GetPos() + Vector(0,50,0),
				endpos = target:GetPos() + Vector(0,0,50),
				filter = self,
			})
			if IsValid(tr.Entity) and self:IsValidTarget(tr.Entity) then
		    if math.random(0,2) == 2  then
			--self:PlaySequenceAndWait("att_ft")
			self:SetSpecialAnimation(true)
				self:SetBlockAttack(true)
			local ang = (target:GetPos() - self:GetPos()):Angle()
			self:SetAngles(Angle(ang[1], ang[2] + 10, ang[3]))
			
			timer.Simple(28/24,function()self:EmitSound("roach/bo3/margwa/slam_attack_close.mp3")end)
				timer.Simple(28/24,function()self:EmitSound("roach/bo3/margwa/slam_attack_far.mp3",511)end)
				timer.Simple(28/24,function()self:EmitSound("roach/bo3/thrasher/dst_rock_quake_0"..math.random(5)..".mp3",511)end)
				timer.Simple(28/24,function()self:EmitSound("roach/bo3/thrasher/teleport_in_01.mp3")end)
				timer.Simple(28/24,function()ParticleEffect("bo3_panzer_landing",self:LocalToWorld(Vector(100,50,0)),self:GetAngles(),nil)end)
				timer.Simple(28/24,function()ParticleEffect("bo3_panzer_landing",self:LocalToWorld(Vector(100,-50,0)),self:GetAngles(),nil)end)
				
				timer.Simple(28/24,function()util.ScreenShake(self:GetPos(),200,750,3,2048)
			local vaporizer = ents.Create("point_hurt")
        if !vaporizer:IsValid() then return end
        vaporizer:SetKeyValue("Damage", 30)
        vaporizer:SetKeyValue("DamageRadius", 200)
        vaporizer:SetKeyValue("DamageType",DMG_CRUSH)
        vaporizer:SetPos(self:GetPos())
        vaporizer:SetOwner(self)
        vaporizer:Spawn()
        vaporizer:Fire("TurnOn","",0)
        vaporizer:Fire("kill","",0.2)
			end)
			self:PlaySequenceAndWait("attack2")
			 self:StartActivity( ACT_WALK )
				self.loco:SetDesiredSpeed(90)
				 self:SetRunSpeed(90)
				
				self:SetSpecialAnimation(false)
				self:SetBlockAttack(false)
			
			self.NextAction = CurTime() + math.random(1, 5)
			self.NextClawTime = CurTime() + math.random(7, 13)
			else
			
				self:SetSpecialAnimation(true)
				self:SetInvulnerable(true)
				self:SetBlockAttack(true)
				self:EmitSound("enemies/bosses/re2/em7100/yell5.ogg",511,100)
				self:PlaySequenceAndWait("attack_big3a")
				self:StartActivity( ACT_RUN )
				print("thats it fuck you kid")
			
			fuckyoukid = true
			
				self.loco:SetDesiredSpeed(235)
			    self:SetRunSpeed(235)
				self:SetSpecialAnimation(false)
				self:SetInvulnerable(false)
				self:SetBlockAttack(false)
				
				self.NextAction = CurTime() + math.random(5, 10)
				self.NextClawTime = CurTime() + math.random(5, 15)
			end
			end
		end
		end
	end

function ENT:OnInjured( dmgInfo )
	local hitpos = dmgInfo:GetDamagePosition()
		
		local bone = self:LookupBone("ShoulderEyeball")
		local pos, ang = self:GetBonePosition(bone)
		
		if hitpos:DistToSqr(pos) < 1000 then
		print("ow that hurt asshole")
		dmgInfo:ScaleDamage(1.75)
		else
		dmgInfo:ScaleDamage(0.5)
		end
			if  hitpos:DistToSqr(pos) < 1000 and dmgInfo:GetDamage() > 100  then
			self:SetInvulnerable(true)
				print("ow that really hurt asshole")
				hasMutated = true
				self:SetSpecialAnimation(true)
				self:SetBlockAttack(true)
				local id, dur = self:LookupSequence("flinch1")
				self:ResetSequence(id)
				self:EmitSound("enemies/bosses/re2/em7100/yell5.ogg",511,100)
				self:SetCycle(0)
				self:SetPlaybackRate(1)
				self.loco:SetDesiredSpeed(0)
				self:SetVelocity(Vector(0,0,0))
				--self.loco:SetDesiredSpeed(199)
				self:TimedEvent(dur, function()
				self:EmitSound("enemies/bosses/re2/em7000/mutate_finish"..math.random(6)..".ogg",511)
				--self:bonescaleup()
				fuckyoukid = false
					self.loco:SetDesiredSpeed(90)
					self:SetRunSpeed(90)
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
			self.loco:SetDesiredSpeed(90)
			    self:SetRunSpeed(90)
				self:StartActivity( ACT_WALK)
				if fuckyoukid then
				fuckyoukid = false
				end
					
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
timer.Simple(0.46,function()
self:EmitSound("enemies/bosses/re2/em7100/step"..math.random(1,2)..".ogg",511)
counting = false
end)
end
if !taunting and math.random(0,800) == 49 then
taunting = true
timer.Simple(4,function()
taunting = false
end)
self:EmitSound("enemies/bosses/re2/em7100/yell"..math.random(6)..".ogg",400)
end
	
end

function ENT:GrabPlayer(ply)

end

function ENT:ReleasePlayer()
	
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
