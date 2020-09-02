AddCSLuaFile()

ENT.Base = "nz_zombiebase"
ENT.PrintName = "Margwa"
ENT.Category = "Brainz"
ENT.Author = "Laby"

ENT.Models = { "models/roach/blackops3/fuckthisaliencunt.mdl" }

ENT.AttackRange = 150
ENT.DamageLow = 75
ENT.DamageHigh = 80


ENT.AttackSequences = {
	{seq = "melee"}
}

ENT.DeathSequences = {
	"death"
}

ENT.AttackSounds = {
	"roach/bo3/margwa/whip_attack_1",
	"roach/bo3/margwa/whip_attack_2",
	"roach/bo3/margwa/whip_attack_3",
	"roach/bo3/margwa/vox_attack_01",
	"roach/bo3/margwa/vox_attack_02",
	"roach/bo3/margwa/vox_attack_03"

}

ENT.PainSounds = {
	"roach/bo3/margwa/vox/vox_pain_01.mp3",
	"roach/bo3/margwa/vox/vox_pain_02.mp3",
	"roach/bo3/margwa/vox/vox_pain_03.mp3"

}
ENT.AttackHitSounds = {
	"roach/bo3/_zhd_player_impacts/evt_zombie_hit_player_01.mp3",
	"roach/bo3/_zhd_player_impacts/evt_zombie_hit_player_02.mp3",
	"roach/bo3/_zhd_player_impacts/evt_zombie_hit_player_03.mp3",
	"roach/bo3/_zhd_player_impacts/evt_zombie_hit_player_04.mp3"
	
	
}

ENT.WalkSounds = {
	"roach/bo3/margwa/vox/vox_ambient_01.mp3",
	"roach/bo3/margwa/vox/vox_ambient_02.mp3",
	"roach/bo3/margwa/vox/vox_ambient_03.mp3",
	"roach/bo3/margwa/vox/vox_ambient_04.mp3",
	"roach/bo3/margwa/vox/vox_ambient_05.mp3",
	"roach/bo3/margwa/vox/vox_ambient_06.mp3",
	"roach/bo3/margwa/vox/vox_ambient_07.mp3"
}

ENT.ActStages = {
	[1] = {
		act = ACT_WALK,
		minspeed = 1,
	},
	[2] = {
		act = ACT_WALK_ANGRY,
		minspeed = 50,
	},
	[3] = {
		act = ACT_RUN,
		minspeed = 250,
	},
	[4] = {
		act = ACT_RUN,
		minspeed = 260
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
	self:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
	self:SetRunSpeed( self.RunSpeed ) --fallback
	self:SetWalkSpeed( self.WalkSpeed ) --fallback

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
		slamming=false
		self:SetRunSpeed(170)
		self:SetHealth(100000)
		self:SetMaxHealth(500000)
		head_L = 100
		head_M = 100
		head_R = 100
		counting = true
		dying = false
		
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
	local seq = "teleport_in"
	local tr = util.TraceLine({
		start = self:GetPos() + Vector(0,0,500),
		endpos = self:GetPos(),
		filter = self,
		mask = MASK_SOLID_BRUSHONLY,
	})
	if tr.Hit then seq = "teleport_in" end
	local _, dur = self:LookupSequence(seq)

	-- play emerge animation on spawn
	-- if we have a coroutine else just spawn the zombie without emerging for now.
	if coroutine.running() then
		
		local pos = self:GetPos() + (seq == "teleport_in" and Vector(0,0,100) or Vector(0,0,450))
		
		local effectData = EffectData()
		effectData:SetStart( pos )
		effectData:SetOrigin( pos )
		effectData:SetMagnitude(dur)
		util.Effect("panzer_spawn_tp", effectData)
		
		self:SetNoDraw(true)
		self:EmitSound("roach/bo3/margwa/spawn.mp3")
		self:EmitSound("roach/bo3/margwa/teleport_in.mp3")
		self:SetNoDraw(true)
	self:SetInvulnerable(true)
		
		--[[effectData = EffectData()
		effectData:SetStart( pos + Vector(0, 0, 1000) )
		effectData:SetOrigin( pos )
		effectData:SetMagnitude( 0.75 )
		util.Effect("lightning_strike", effectData)]]
		
		self:TimedEvent(dur, function()
			--dust cloud
			self:SetNoDraw(false)
			
			self:EmitSound("roach/bo3/margwa/vox/vox_spawn.mp3",511,100)
			self:SetInvulnerable(false)
			local effectData = EffectData()
			effectData:SetStart( self:GetPos() )
			effectData:SetOrigin( self:GetPos() )
			effectData:SetMagnitude(1)
			counting = false
		end)
		self:PlaySequenceAndWait(seq)
	end
	self:ResetSequence("run")
			self:SetCycle(0)
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
	self:EmitSound("roach/bo3/margwa/fall_knee.mp3")
	self:ResetSequence(seq)
	self:SetCycle(0)

	timer.Simple(dur - 0.5, function()
		if IsValid(self) then
			self:EmitSound("roach/bo3/margwa/fall_body.mp3")
			self:EmitSound("roach/bo3/margwa/vox/vox_death_01.mp3")
		end
	end)
	timer.Simple(dur, function()
		if IsValid(self) then
			self:Remove()
			local effectData = EffectData()
			effectData:SetStart( self:GetPos() )
			effectData:SetOrigin( self:GetPos() )
			effectData:SetMagnitude(2)
			ParticleEffect("bo3_margwa_death",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
		end
	end)

end

function ENT:BodyUpdate()

	self.CalcIdeal = ACT_IDLE

	local velocity = self:GetVelocity()

	local len2d = velocity:Length2D()

	if ( len2d > 60 ) then self.CalcIdeal = ACT_RUN elseif ( len2d > 5 ) then self.CalcIdeal = ACT_WALK end

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

function ENT:OnTargetInAttackRange()
self.loco:SetDesiredSpeed(0)
self:SetAttackRange(175)
    local atkData = {}
	self.AttackSequences = {
						{seq = "melee"}
										}
    atkData.dmglow = 30
    atkData.dmghigh = 35
    atkData.dmgforce = Vector( 0, 0, 0 )
	atkData.dmgdelay = 0.2
    self:Attack( atkData )
	timer.Simple(1,function() 
		self:ResetSequence("run")
			self:SetCycle(0)
			end)
			
	end

function ENT:OnPathTimeOut()
	local target = self:GetTarget()
	if CurTime() < self.NextAction then return end
	
	if math.random(0,5) == 0 and CurTime() > self.NextClawTime then
		-- Slam
		if self:IsValidTarget(target) then
			local tr = util.TraceLine({
				start = self:GetPos() + Vector(0,50,0),
				endpos = target:GetPos() + Vector(0,0,50),
				filter = self,
			})
			if IsValid(tr.Entity) and self:IsValidTarget(tr.Entity) and !IsValid(self.ClawHook) and !slamming then
			slamming=true
			self:EmitSound("roach/bo3/margwa/vox/vox_attack_raise_0"..math.random(3)..".mp3")
			timer.Simple(55/55,function()util.ScreenShake(self:GetPos(),300,1000,5,2048)
			local vaporizer = ents.Create("point_hurt")
        if !vaporizer:IsValid() then return end
        vaporizer:SetKeyValue("Damage", 16)
        vaporizer:SetKeyValue("DamageRadius", 300)
        vaporizer:SetKeyValue("DamageType",DMG_CRUSH)
        vaporizer:SetPos(self:GetPos())
        vaporizer:SetOwner(self)
        vaporizer:Spawn()
        vaporizer:Fire("TurnOn","",0)
        vaporizer:Fire("kill","",0.3)
			end)
				timer.Simple(55/55,function()self:EmitSound("roach/bo3/margwa/slam_attack_close.mp3")end)
				timer.Simple(55/55,function()self:EmitSound("roach/bo3/margwa/slam_attack_far.mp3",511)end)
				timer.Simple(55/55,function()ParticleEffect("bo3_panzer_landing",self:LocalToWorld(Vector(100,50,0)),self:GetAngles(),nil)end)
				timer.Simple(55/55,function()ParticleEffect("bo3_panzer_landing",self:LocalToWorld(Vector(100,-50,0)),self:GetAngles(),nil)end)
				self:PlaySequenceAndWait("slam")
				
		self:ResetSequence("run")
			self:SetCycle(0)
			local id, dur = self:LookupSequence("slam")
			self:SetCycle(0)
			self:SetPlaybackRate(1)
			self:SetVelocity(Vector(0,0,0))
			self:TimedEvent(dur, function()
						self:SetAttackRange(150)
						slamming=false
				self.loco:SetDesiredSpeed(self:GetRunSpeed())
				self:SetSpecialAnimation(false)
				self:SetBlockAttack(false)
				self:StopFlames()
			end)
			
				self.NextAction = CurTime() + math.random(1, 5)
				self.NextClawTime = CurTime() + math.random(3, 15)
			end
		end
	elseif math.random(0,5) == 6 and CurTime() > self.NextFlameTime then
		-- Useless Removed flamethrower
		if self:IsValidTarget(target) and self:GetPos():DistToSqr(target:GetPos()) <= 75000 then	
			self:Stop()
			self:PlaySequenceAndWait("nz_flamethrower_aim")
			self.loco:SetDesiredSpeed(0)
			local ang = (target:GetPos() - self:GetPos()):Angle()
			self:SetAngles(Angle(ang[1], ang[2] + 10, ang[3]))
			
			self:StartFlames()
			local seq = math.random(0,1) == 0 and "nz_flamethrower_loop" or "nz_flamethrower_sweep"
			local id, dur = self:LookupSequence(seq)
			self:ResetSequence("run")
			self:SetCycle(0)
			self:SetPlaybackRate(1)
			self:SetVelocity(Vector(0,0,0))
			
			self:TimedEvent(dur, function()
				self.loco:SetDesiredSpeed(self:GetRunSpeed())
				self:SetSpecialAnimation(false)
				self:SetBlockAttack(false)
				self:StopFlames()
			end)
			
			self.NextAction = CurTime() + math.random(1, 5)
			self.NextFlameTime = CurTime() + math.random(1, 10)
		end
	end
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
		
		local dlight = DynamicLight( self:EntIndex() )
		if ( dlight ) then
			local bone = self:LookupBone("j_spine_1")
			local pos, ang = self:GetBonePosition(bone)
			pos = pos + ang:Right()*-8 + ang:Forward()*25
			dlight.pos = pos
			dlight.r = 255
			dlight.g = 255
			dlight.b = 255
			dlight.brightness = 10
			dlight.Decay = 1000
			dlight.Size = 16
			dlight.DieTime = CurTime() + 1
			dlight.dir = ang:Right() + ang:Forward()
			dlight.innerangle = 1
			dlight.outerangle = 1
			dlight.style = 0
			dlight.noworld = true
		end

	end
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

function ENT:OnInjured(dmg)
	if dmg:IsExplosionDamage() then
		self:PlaySequenceAndMove("flinch_blast")
	else
		if !dmg:GetAttacker():IsPlayer() and !dmg:GetAttacker():IsNPC() then return end
		local tr = util.TraceLine({
			start=dmg:GetAttacker():GetShootPos(),
			endpos=dmg:GetDamagePosition(),
			filter=dmg:GetAttacker()
		})
		local d = dmg:GetDamage()
		if tr.HitGroup == HITGROUP_RIGHTARM and not self.GibbedRight then
			head_R = head_R - dmg:GetDamage()
				print("R")
			print(head_R)
					print("M")
		print(head_M)
			print("L")
		print(head_L)
			if head_R < 1 then
			self.GibbedRight = true

			self:EmitSound("roach/bo3/margwa/margwa_head_explo_"..math.random(3)..".mp3")
			ParticleEffectAttach("bo3_margwa_death",PATTACH_POINT_FOLLOW,self,4)
			self:SetPlaybackRate(1)
			self:SetVelocity(Vector(0,0,0))
			
			if self.GibbedHead and self.GibbedLeft and self.GibbedRight then
				self:TakeDamage(200001,dmg:GetAttacker(),dmg:GetInflictor())
			else
				
			end
			end
		elseif tr.HitGroup == HITGROUP_HEAD and not self.GibbedHead then
		dmg:ScaleDamage(0.25 )
		head_M = head_M - dmg:GetDamage()
					print("R")
			print(head_R)
					print("M")
		print(head_M)
			print("L")
		print(head_L)
		if head_M < 1 then
			self.GibbedHead = true
			
			self:EmitSound("roach/bo3/margwa/margwa_head_explo_"..math.random(3)..".mp3")
			ParticleEffectAttach("bo3_margwa_death",PATTACH_POINT_FOLLOW,self,2)
			self:SetPlaybackRate(1)
			self:SetVelocity(Vector(0,0,0))
			
			if self.GibbedHead and self.GibbedLeft and self.GibbedRight then
				self:TakeDamage(200001,dmg:GetAttacker(),dmg:GetInflictor())
			else
			
			end
			end
		elseif tr.HitGroup == HITGROUP_LEFTARM and not self.GibbedLeft then
		head_L = head_L - dmg:GetDamage() 
					print("R")
			print(head_R)
					print("M")
		print(head_M)
			print("L")
		print(head_L)
		if head_L < 1 then
			self.GibbedLeft = true
			
			self:SetVelocity(Vector(0,0,0))
			self:EmitSound("roach/bo3/margwa/margwa_head_explo_"..math.random(3)..".mp3")
			ParticleEffectAttach("bo3_margwa_death",PATTACH_POINT_FOLLOW,self,3)
			self:SetPlaybackRate(1)
			self:SetVelocity(Vector(0,0,0))
			
			if self.GibbedHead and self.GibbedLeft and self.GibbedRight then
				self:TakeDamage(200001,dmg:GetAttacker(),dmg:GetInflictor())
			else
				
			end
			end
		end
	end
end
function ENT:OnThink()
if !self:IsAttacking() and !counting and !dying and !slamming then
counting = true
timer.Simple(0.42,function()
self:EmitSound("roach/bo3/margwa/step_0"..math.random(1,6)..".mp3")
util.ScreenShake(self:GetPos(),3,1000,0.5,2048)
counting = false
end)
end

if self.GibbedHead then
self:SetBodygroup(2,1)
end
if self.GibbedLeft then
self:SetBodygroup(1,1)
end
if self.GibbedRight then
self:SetBodygroup(3,1)
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
