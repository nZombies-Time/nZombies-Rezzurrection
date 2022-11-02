AddCSLuaFile()

ENT.Base = "nz_zombiebase"
ENT.PrintName = "Panzermordar"
ENT.Category = "Brainz"
ENT.Author = "Laby"

ENT.Models = { "models/roach/codz_megapack/ww2/panzermorder.mdl"}

ENT.AttackRange = 200
ENT.DamageLow = 90
ENT.DamageHigh = 95


ENT.AttackSequences = {
	{seq = "s2_zom_brt_walk_attack_ground_v1" , dmgtimes = {1.9}},
	{seq = "s2_zom_brt_walk_attack_v1" , dmgtimes = {1.7} },
	{seq = "s2_zom_brt_walk_attack_v2" , dmgtimes = {2.3}},
	{seq = "s2_zom_brt_stand_atk_v1" , dmgtimes = {0.9}},
	{seq = "s2_zom_brt_walk_attack_ground_v2" , dmgtimes = {1.5}}
}

ENT.DeathSequences = {
	"s2_zom_brt_stun_down_v1"
}


ENT.AttackSounds = {
	"codz_megapack/ww2/brute/vox/s2_zom_brt_walk_attack_ground_v1_01.wav",
	"codz_megapack/ww2/brute/vox/s2_zom_brt_walk_attack_ground_v1_02.wav",
	"codz_megapack/ww2/brute/vox/s2_zom_brt_walk_attack_ground_v1_03.wav",
	"codz_megapack/ww2/brute/vox/s2_zom_brt_walk_attack_ground_v2_01.wav",
	"codz_megapack/ww2/brute/vox/s2_zom_brt_walk_attack_ground_v2_02.wav",
	"codz_megapack/ww2/brute/vox/s2_zom_brt_walk_attack_ground_v2_03.wav",
	"codz_megapack/ww2/brute/vox/s2_zom_brt_walk_attack_v1_01.wav",
	"codz_megapack/ww2/brute/vox/s2_zom_brt_walk_attack_v1_02.wav",
	"codz_megapack/ww2/brute/vox/s2_zom_brt_walk_attack_v1_03.wav",
	"codz_megapack/ww2/brute/vox/s2_zom_brt_walk_attack_v2_01.wav",
	"codz_megapack/ww2/brute/vox/s2_zom_brt_walk_attack_v2_02.wav",
	"codz_megapack/ww2/brute/vox/s2_zom_brt_walk_attack_v2_03.wav"
}

ENT.PainSounds = {
	"physics/flesh/flesh_impact_bullet1.wav",
	"physics/flesh/flesh_impact_bullet2.wav",
	"physics/flesh/flesh_impact_bullet3.wav",
	"physics/flesh/flesh_impact_bullet4.wav",
	"physics/flesh/flesh_impact_bullet5.wav"
}

ENT.AttackHitSounds = {
	"roach/bo3/thrasher/bite_04.mp3",
	"roach/bo3/thrasher/bite_01.mp3",
	"roach/bo3/thrasher/bite_02.mp3",
	"roach/bo3/thrasher/bite_03.mp3",
}

ENT.WalkSounds = {
	"codz_megapack/ww2/brute/vox/s2_zom_brt_walk_trav_exit_v1_01.wav",
	"codz_megapack/ww2/brute/vox/s2_zom_brt_walk_trav_exit_v1_02.wav",
	"codz_megapack/ww2/brute/vox/s2_zom_brt_walk_trav_exit_v1_03.wav"
	
}

ENT.ActStages = {
	[1] = {
		act = ACT_WALK,
		minspeed = 1,
	},
	[2] = {
		act = ACT_WALK,
		minspeed = 130,
	},
	[3] = {
		act = ACT_RUN,
		minspeed = 200,
	},
	[4] = {
		act = ACT_RUN,
		minspeed = 200
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
	self:SetTargetCheckRange(2000) -- 0 for no distance restriction (infinite)

	--target ignore
	self:ResetIgnores()

	self:SetHealth( 75 ) --fallback

	self:SetRunSpeed( self.RunSpeed ) --fallback
	self:SetWalkSpeed( self.WalkSpeed ) --fallback

	self:SetCollisionBounds(Vector(-90,-40, 0), Vector(90, 40, 250))

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
		self.loco:SetDesiredSpeed(90)
		self:SetRunSpeed(90)
		self:SetHealth(200)
		self:SetMaxHealth(100000)
		counting = true
		dying = false
		fullHP = true
		halfHP = false
		lowHP = false
		scaledHP = 100
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
	local seq = "s2_zom_brt_roar"
	local tr = util.TraceLine({
		start = self:GetPos() + Vector(0,0,500),
		endpos = self:GetPos(),
		filter = self,
		mask = MASK_SOLID_BRUSHONLY,
	})
	if tr.Hit then seq = "s2_zom_brt_roar" end
	local _, dur = self:LookupSequence(seq)

	-- play emerge animation on spawn
	-- if we have a coroutine else just spawn the zombie without emerging for now.
	if coroutine.running() then
		self:SetSpecialAnimation(true)
		local pos = self:GetPos() + (seq == "s2_zom_brt_roar" and Vector(0,0,100) or Vector(0,0,450))
		
		local effectData = EffectData()
		effectData:SetStart( pos )
		effectData:SetOrigin( pos )
		effectData:SetMagnitude(1)
		for i=1,8 do
			ParticleEffect("bo3_panzer_landing",self:LocalToWorld(Vector(20+(i*2),20,0)),Angle(0,0,0),nil)
		end
		self:EmitSound("codz_megapack/ww2/brute/vox/s2_zom_brt_roar_0"..math.random(1,5)..".wav",511)
		self:EmitSound("roach/bo3/thrasher/tele_hand_up.mp3",511)
		self:EmitSound("roach/bo3/thrasher/dst_rock_quake_0"..math.random(1,5)..".mp3",511)
	self:SetInvulnerable(true)
		
		--[[effectData = EffectData()
		effectData:SetStart( pos + Vector(0, 0, 1000) )
		effectData:SetOrigin( pos )
		effectData:SetMagnitude( 0.75 )
		util.Effect("lightning_strike", effectData)]]
		
		self:TimedEvent(dur - 2.1, function()
			--dust cloud
			self:SetNoDraw(false)
			self:SetInvulnerable(false)
			local effectData = EffectData()
			effectData:SetStart( self:GetPos() )
			effectData:SetOrigin( self:GetPos() )
			effectData:SetMagnitude(1)
		end)
		self:TimedEvent(dur, function()
		self:SetSpecialAnimation(false)
		end)
		scaledHP = self:Health()
		print(scaledHP)
		counting = false
		self:PlaySequenceAndWait(seq)
		self.loco:SetDesiredSpeed(90)
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

		if IsValid(self) then
			self:EmitSound("codz_megapack/ww2/brute/vox/s2_zom_brt_stun_down_v1_0"..math.random(1,3)..".wav",511)
		end
	timer.Simple(dur, function()
		if IsValid(self) then
			self:Remove()
			local effectData = EffectData()
			effectData:SetStart( self:GetPos() )
			effectData:SetOrigin( self:GetPos() )
			effectData:SetMagnitude(2)
			ParticleEffect("nbnz_gib_explosion",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
		end
	end)

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

function ENT:OnTargetInAttackRange()
    local atkData = {}
    atkData.dmglow = 90
    atkData.dmghigh = 95
    atkData.dmgforce = Vector( 0, 0, 0 )
    self:Attack( atkData )
	
end

function ENT:OnPathTimeOut()

	local target = self:GetTarget()
	if CurTime() < self.NextAction then return end
	
	if math.random(0,5) == 6 and CurTime() > self.NextClawTime then
		-- Roar
		if self:IsValidTarget(target) then
			local tr = util.TraceLine({
				start = self:GetPos() + Vector(0,50,0),
				endpos = target:GetPos() + Vector(0,0,50),
				filter = self,
			})
		
			if IsValid(tr.Entity) and self:IsValidTarget(tr.Entity) and !IsValid(self.ClawHook) then
			 local atkData = {}
					self.AttackSequences = {
						{seq = "enrage"}
										}
			 
				atkData.dmglow = 40
				atkData.dmghigh = 60
				atkData.dmgforce = Vector( 0, 0, 0 )
				atkData.dmgdelay = 0.5
				self:Attack( atkData )
		
				--self:SetSequence(self:LookupSequence("nz_grapple_loop"))
					local id, dur = self:LookupSequence("enrage")
			
			self:SetCycle(0)
			self:SetPlaybackRate(1)
			self:SetVelocity(Vector(0,0,0))
			
			self:TimedEvent(dur, function()
			self:SetAttackRange(140)
			self.AttackSequences = {
						{seq = "melee1"},
						{seq = "melee2"}
										}
				self.loco:SetDesiredSpeed(350)
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
			self:ResetSequence(id)
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

function ENT:OnInjured( dmgInfo )
	local hitpos = dmgInfo:GetDamagePosition()
	
	if !self.HelmetLost then
		local bone = self:LookupBone("j_faceplate")
		local pos, ang = self:GetBonePosition(bone)
		local finalpos = pos + ang:Forward()*8 + ang:Up()*11
		
		if hitpos:DistToSqr(finalpos) < 50 then
			self.HelmetDamage = self.HelmetDamage + dmgInfo:GetDamage()
			if self.HelmetDamage > (self:GetMaxHealth() * 0.01) then
				self.HelmetLost = true
				--self:ManipulateBonePosition(bone, Vector(0,0,-75))
				self:EmitSound("codz_megapack/zmb/ai/mechz2/v2/mechz_faceplate.wav",511)
				self:SetBodygroup(2, 1)
				self:SetSpecialAnimation(true)
				self:SetBlockAttack(true)
				self:ReleasePlayer()
				self:StopFlames()
				local id, dur = self:LookupSequence("flinch_head_1")
				self:ResetSequence(id)
				self:SetCycle(0)
				self:SetPlaybackRate(1)
				self.loco:SetDesiredSpeed(0)
				self:SetVelocity(Vector(0,0,0))
				self:TimedEvent(dur, function()
					self.loco:SetDesiredSpeed(self:GetRunSpeed())
					self:SetSpecialAnimation(false)
					self:SetBlockAttack(false)
				end)
			end
		end
		
		dmgInfo:ScaleDamage(0.1) -- When the helmet isn't lost, all damage only deals 10%
	else
		local bone = self:LookupBone("j_head")
		local pos, ang = self:GetBonePosition(bone)
		local finalpos = pos + ang:Up()*4
		
		if hitpos:DistToSqr(finalpos) < 150 then
			-- No damage scaling on headshot, we keep it at 1x
		else
			dmgInfo:ScaleDamage(0.1) -- When the helmet is lost, a non-headshot still only deals 10%
		end
	end
	
end

function ENT:OnInjured(dmg)

if self:Health() < scaledHP/2 and self:Health()> scaledHP/5 then
self:EmitSound("codz_megapack/ww2/brute/vox/s2_zom_brt_roar_0"..math.random(1,5)..".wav")
fullHP = false
halfHP = true
self.loco:SetDesiredSpeed(210)
self:SetRunSpeed(210)
self.AttackSequences = {
	{seq = "s2_zom_brt_run_attack_v1" , dmgtimes = {0.75,1.2,1.5}}
}
self.AttackSounds  = {
	"codz_megapack/ww2/brute/vox/s2_zom_brt_run_attack_v1_01.wav",
	"codz_megapack/ww2/brute/vox/s2_zom_brt_run_attack_v1_02.wav",
	"codz_megapack/ww2/brute/vox/s2_zom_brt_run_attack_v1_03.wav",
	"codz_megapack/ww2/brute/vox/s2_zom_brt_run_attack_v1_04.wav",
	"codz_megapack/ww2/brute/vox/s2_zom_brt_run_attack_v1_05.wav"
}

self.WalkSounds = {
"codz_megapack/ww2/brute/vox/s2_zom_brt_run_01.wav",
"codz_megapack/ww2/brute/vox/s2_zom_brt_run_02.wav",
"codz_megapack/ww2/brute/vox/s2_zom_brt_run_03.wav",
"codz_megapack/ww2/brute/vox/s2_zom_brt_run_04.wav",
"codz_megapack/ww2/brute/vox/s2_zom_brt_run_05.wav"
}
				
else if self:Health() < scaledHP/5 and !lowHP then
lowHP = true
halfHP = false
fullHP = false
self:EmitSound("codz_megapack/ww2/brute/vox/s2_zom_brt_stun_down_v1_0"..math.random(1,3)..".wav")
self.loco:SetDesiredSpeed(95)
self:SetRunSpeed(95)
self:SetAttackRange(250)
self.AttackSequences = {
	{seq = "s2_zom_brt_stand_atk_lurch_v1" , dmgtimes = {1.2}}
}

self.WalkSounds = {
"codz_megapack/ww2/brute/vox/s2_zom_brt_stun_loop_v1_01.wav",
"codz_megapack/ww2/brute/vox/s2_zom_brt_stun_loop_v1_02.wav",
"codz_megapack/ww2/brute/vox/s2_zom_brt_stun_loop_v1_03.wav"
}

self.AttackSounds  = {
	"codz_megapack/ww2/brute/vox/s2_zom_brt_stand_atk_lurch_v1_01.wav",
	"codz_megapack/ww2/brute/vox/s2_zom_brt_stand_atk_lurch_v1_02.wav",
	"codz_megapack/ww2/brute/vox/s2_zom_brt_stand_atk_lurch_v1_03.wav"
}
end
end
end

function ENT:OnThink()
if !counting and !self:IsAttacking() and !dying and self:Health() > 0 and !self:GetSpecialAnimation() then
counting = true
--Walking MS
if halfHP then
timer.Simple(0.43,function()
self:EmitSound("codz_megapack/ww2/brute/zmb_fs_run_brute_default2_0"..math.random(1,9)..".wav")
util.ScreenShake(self:GetPos(),3,1000,0.5,2048)
counting = false
end)	
else
timer.Simple(0.91,function()
self:EmitSound("codz_megapack/ww2/brute/zmb_fs_walk_brute_default2_0"..math.random(1,9)..".wav")
util.ScreenShake(self:GetPos(),3,1000,0.5,2048)
counting = false
end)
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
