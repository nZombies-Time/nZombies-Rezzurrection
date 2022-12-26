AddCSLuaFile()

ENT.Base = "nz_zombiebase"
ENT.PrintName = "Birkin Stage 2"
ENT.Category = "Brainz"
ENT.Author = "Laby"

ENT.Models = { "models/bosses/fuckthisaliencunt.mdl" }

ENT.AttackRange = 125
ENT.DamageLow = 75
ENT.DamageHigh = 85


ENT.AttackSequences = {
	{seq = "melee"}
}

ENT.DeathSequences = {
	"death"
}

ENT.AttackSounds = {
	"enemies/bosses/margwa/whip_attack_1.ogg",
	"enemies/bosses/margwa/whip_attack_2.ogg",
	"enemies/bosses/margwa/whip_attack_3.ogg",
	"enemies/bosses/margwa/vox_attack_01.ogg",
	"enemies/bosses/margwa/vox_attack_02.ogg",
	"enemies/bosses/margwa/vox_attack_03.ogg",

}

ENT.PainSounds = {
	"enemies/bosses/margwa/vox/vox_pain_01.ogg",
	"renemies/bosses/margwa/vox/vox_pain_02.ogg",
	"enemies/bosses/margwa/vox/vox_pain_03.ogg",

}
ENT.AttackHitSounds = {
	"effects/hit/evt_zombie_hit_player_01.ogg",
	"effects/hit/evt_zombie_hit_player_02.ogg",
	"effects/hit/evt_zombie_hit_player_03.ogg",
	"effects/hit/evt_zombie_hit_player_04.ogg",
	"effects/hit/evt_zombie_hit_player_05.ogg",
}

ENT.WalkSounds = {
	"enemies/bosses/margwa/vox/vox_ambient_01.ogg",
	"enemies/bosses/margwa/vox/vox_ambient_02.ogg",
	"enemies/bosses/margwa/vox/vox_ambient_03.ogg",
	"enemies/bosses/margwa/vox/vox_ambient_04.ogg",
	"enemies/bosses/margwa/vox/vox_ambient_05.ogg",
	"enemies/bosses/margwa/vox/vox_ambient_06.ogg",
	"enemies/bosses/margwa/vox/vox_ambient_07.ogg",
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
	self:SetTargetCheckRange(2000) -- 0 for no distance restriction (infinite)

	--target ignore
	self:ResetIgnores()

	self:SetHealth( 75 ) --fallback
	self:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
	self:SetRunSpeed( self.RunSpeed ) --fallback
	self:SetWalkSpeed( self.WalkSpeed ) --fallback
	self:SetCollisionBounds(Vector(-35,-35, 0), Vector(35, 35, 100))
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
		head_L = 100
		head_M = 100
		head_R = 100
		self.GibbedHead = false
		self.GibbedLeft = false
		self.GibbedRight = false
		baseHealth = 0
		self:SetRunSpeed(90)
		self:SetHealth(10000)
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
	local seq = "jump_across"
	local tr = util.TraceLine({
		start = self:GetPos() + Vector(0,0,500),
		endpos = self:GetPos(),
		filter = self,
		mask = MASK_SOLID_BRUSHONLY,
	})
	if tr.Hit then seq = "jump_across" end
	local _, dur = self:LookupSequence(seq)

	-- play emerge animation on spawn
	-- if we have a coroutine else just spawn the zombie without emerging for now.
	if coroutine.running() then
		
				local pos = self:GetPos() + (seq == "jump_across" and Vector(0,0,100) or Vector(0,0,450))
		self:SetNoDraw(true)
		local effectData = EffectData()
		effectData:SetStart( pos )
		effectData:SetOrigin( pos )
		effectData:SetMagnitude(dur)
		util.Effect("panzer_spawn_tp", effectData)
		
		timer.Simple(0.7, function()
		self:SetNoDraw(false)
		end)
		self:EmitSound("enemies/bosses/margwa/spawn.ogg")
		self:EmitSound("enemies/bosses/margwa/teleport_in.ogg")
	self:SetInvulnerable(true)
		
		--[[effectData = EffectData()
		effectData:SetStart( pos + Vector(0, 0, 1000) )
		effectData:SetOrigin( pos )
		effectData:SetMagnitude( 0.75 )
		util.Effect("lightning_strike", effectData)]]
		
		self:TimedEvent(dur, function()
			--dust cloud
			
			self:EmitSound("enemies/bosses/margwa/vox/vox_spawn.ogg",511,100)
			self:SetInvulnerable(false)
			local effectData = EffectData()
			effectData:SetStart( self:GetPos() )
			effectData:SetOrigin( self:GetPos() )
			effectData:SetMagnitude(1)
			counting = false
		end)
		self:PlaySequenceAndWait(seq)
		counting = false
		taunting = false
		baseHealth = self:Health()
		head_L = baseHealth/10
		head_M = baseHealth/10
		head_R = baseHealth/10
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
	self:EmitSound("enemies/bosses/margwa/fall_knee.ogg")
	self:ResetSequence(seq)
	self:SetCycle(0)

	timer.Simple(dur - 0.5, function()
		if IsValid(self) then
			self:EmitSound("enemies/bosses/margwa/fall_body.ogg")
			self:EmitSound("enemies/bosses/margwa/vox/vox_death_01.ogg")
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

function ENT:IsValidTarget( ent )
	if !ent then return false end
	return IsValid( ent ) and ent:GetTargetPriority() != TARGET_PRIORITY_NONE and ent:GetTargetPriority() != TARGET_PRIORITY_SPECIAL
	-- Won't go for special targets (Monkeys), but still MAX, ALWAYS and so on
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

	self:Attack()

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
		    if math.random(0,2) == 1 then
			--self:PlaySequenceAndWait("att_ft")
			self:SetInvulnerable(true)
			self:SetSpecialAnimation(true)
				self:SetBlockAttack(true)
			local ang = (target:GetPos() - self:GetPos()):Angle()
			self:SetAngles(Angle(ang[1], ang[2] + 10, ang[3]))
			self:EmitSound("enemies/bosses/margwa/vox/vox_attack_raise_0"..math.random(3)..".ogg")
			timer.Simple(28/24,function()self:EmitSound("enemies/bosses/margwa/slam_attack_close.ogg")end)
				timer.Simple(28/24,function()self:EmitSound("enemies/bosses/margwa/slam_attack_far.ogg",511)end)
				timer.Simple(28/24,function()self:EmitSound("enemies/bosses/thrasher/dst_rock_quake_0"..math.random(5)..".mp3",511)end)
				timer.Simple(28/24,function()self:EmitSound("enemies/bosses/thrasher/teleport_in_01.ogg")end)
				timer.Simple(28/24,function()ParticleEffect("bo3_panzer_landing",self:LocalToWorld(Vector(100,50,0)),self:GetAngles(),nil)end)
				timer.Simple(28/24,function()ParticleEffect("bo3_panzer_landing",self:LocalToWorld(Vector(100,-50,0)),self:GetAngles(),nil)end)
				
				timer.Simple(28/24,function()util.ScreenShake(self:GetPos(),200,750,3,2048)
			local vaporizer = ents.Create("point_hurt")
        if !vaporizer:IsValid() then return end
        vaporizer:SetKeyValue("Damage", 25)
        vaporizer:SetKeyValue("DamageRadius", 300)
        vaporizer:SetKeyValue("DamageType",DMG_CRUSH)
        vaporizer:SetPos(self:GetPos())
        vaporizer:SetOwner(self)
        vaporizer:Spawn()
        vaporizer:Fire("TurnOn","",0)
        vaporizer:Fire("kill","",0.2)
			end)
			self:PlaySequenceAndWait("slam")
			 self:StartActivity( ACT_WALK )
				self.loco:SetDesiredSpeed(90)
				 self:SetRunSpeed(90)
				self:SetInvulnerable(false)
				self:SetSpecialAnimation(false)
				self:SetBlockAttack(false)
			
			self.NextAction = CurTime() + math.random(1, 5)
			self.NextClawTime = CurTime() + math.random(7, 13)
			else
			--self:Stop()
			self:SetInvulnerable(true)
			self:SetSpecialAnimation(true)
					self:SetBlockAttack(true)
				self:SetAngles((target:GetPos() - self:GetPos()):Angle())
		local pos = self:GetPos() +  Vector(0,0,100) 
		local effectData = EffectData()
		effectData:SetStart( pos )
		effectData:SetOrigin( pos )
		effectData:SetMagnitude(1)
		util.Effect("panzer_spawn_tp", effectData)
				
				timer.Simple(0.3, function()
				self:SetNoDraw(true)
			end)
			timer.Simple(2, function()
				self:SetNoDraw(false)
			end)
				self:PlaySequenceAndWait("teleport_out")
				
				self:SetPos( target:GetPos() + (Vector(60,60,0)) )
					local pos = self:GetPos() +  Vector(0,0,100) 
		local effectData = EffectData()
		effectData:SetStart( pos )
		effectData:SetOrigin( pos )
		effectData:SetMagnitude(1)
		util.Effect("panzer_spawn_tp", effectData)
			
				local ang1 = (target:GetPos() - self:GetPos()):Angle()
				self:SetAngles(Angle(ang1[1], ang1[2] + 10, ang1[3]))
				self:PlaySequenceAndWait("teleport_in")
				
				local ang2 = (target:GetPos() - self:GetPos()):Angle()
				self:SetAngles(Angle(ang2[1], ang2[2] + 10, ang2[3]))
				
				self:SetSpecialAnimation(false)
				self:SetBlockAttack(false)
				self:SetInvulnerable(false)
				self.loco:SetDesiredSpeed( 90 )
				timer.Simple(0, function()
				self:StartActivity( ACT_WALK )
				end)
				self.NextAction = CurTime() + math.random(5, 10)
				self.NextClawTime = CurTime() + math.random(5, 15)
			end
			end
		end
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
					
			end
			return
		end

		coroutine.yield()

	end

end


function ENT:OnInjured(dmg)
self:RemoveAllDecals()
local damageValue = dmg:GetDamage()
		if !dmg:GetAttacker():IsPlayer() then return end

			local hitpos = dmg:GetDamagePosition()
		
		local leftHead  = self:GetBonePosition(self:LookupBone("j_jaw_lower_1_le"))
		local midHead  = self:GetBonePosition(self:LookupBone("j_jaw_lower_1"))
		local rightHead  = self:GetBonePosition(self:LookupBone("j_jaw_lower_1_ri"))
		
		
		if  hitpos:DistToSqr(rightHead) < 400 and not self.GibbedRight then
		
			head_R = head_R - damageValue
			if head_R < 1 then
			self:SetInvulnerable(true)
			self:SetSpecialAnimation(true)
				self:SetBlockAttack(true)
				self:EmitSound("enemies/bosses/margwa/margwa_head_explo_"..math.random(3)..".ogg")
				ParticleEffectAttach("bo3_margwa_death",PATTACH_POINT_FOLLOW,self,4)
				self.GibbedRight = true
			self:SetBodygroup(3,1)
				local id, dur = self:LookupSequence("flinch_head_r")
				timer.Simple(0.2,function()
				self:ResetSequence(id)
				end)
				self:SetCycle(0)
				self:SetPlaybackRate(1)
				self.loco:SetDesiredSpeed(0)
				self:SetVelocity(Vector(0,0,0))
				self:TimedEvent(dur, function()
					self.loco:SetDesiredSpeed(90)
					self:SetRunSpeed(90)
					self:StartActivity( ACT_WALK)
					self:SetInvulnerable(false)
					self:SetSpecialAnimation(false)
					self:SetBlockAttack(false)
					
				end)
			end
		elseif hitpos:DistToSqr(midHead) < 400 and not self.GibbedHead then
		head_M = head_M - damageValue
		if head_M < 1 then
		
		self:SetInvulnerable(true)
			self:SetSpecialAnimation(true)
				self:SetBlockAttack(true)
				self:EmitSound("enemies/bosses/margwa/margwa_head_explo_"..math.random(3)..".ogg")
				ParticleEffectAttach("bo3_margwa_death",PATTACH_POINT_FOLLOW,self,2)
				self.GibbedHead = true
			self:SetBodygroup(2,1)
				local id, dur = self:LookupSequence("flinch_head_m")
				timer.Simple(0.2,function()
				self:ResetSequence(id)
				end)
				self:SetCycle(0)
				self:SetPlaybackRate(1)
				self.loco:SetDesiredSpeed(0)
				self:SetVelocity(Vector(0,0,0))
				self:TimedEvent(dur, function()
					self.loco:SetDesiredSpeed(90)
					self:SetRunSpeed(90)
					self:StartActivity( ACT_WALK)
					self:SetInvulnerable(false)
					self:SetSpecialAnimation(false)
					self:SetBlockAttack(false)
					
				end)
			end
		elseif hitpos:DistToSqr(leftHead) < 400 and not self.GibbedLeft then
		head_L = head_L - damageValue
		if head_L < 1 then
		
				self:SetInvulnerable(true)
			self:SetSpecialAnimation(true)
				self:SetBlockAttack(true)
				self:EmitSound("enemies/bosses/margwa/margwa_head_explo_"..math.random(3)..".ogg")
				ParticleEffectAttach("bo3_margwa_death",PATTACH_POINT_FOLLOW,self,3)
				self.GibbedLeft = true
			self:SetBodygroup(1,1)
				local id, dur = self:LookupSequence("flinch_head_l")
				timer.Simple(0.2,function()
				self:ResetSequence(id)
				end)
				self:SetCycle(0)
				self:SetPlaybackRate(1)
				self.loco:SetDesiredSpeed(0)
				self:SetVelocity(Vector(0,0,0))
				self:TimedEvent(dur, function()
					self.loco:SetDesiredSpeed(90)
					self:SetRunSpeed(90)
					self:StartActivity( ACT_WALK)
					self:SetInvulnerable(false)
					self:SetSpecialAnimation(false)
					self:SetBlockAttack(false)
					
				end)
			end
			else
		end
		if self.GibbedHead and self.GibbedLeft and self.GibbedRight and not dying then
		dying = true
				self:TakeDamage(baseHealth,dmg:GetAttacker(),dmg:GetInflictor())
				self:SetInvulnerable(true)
				
			end
	
end

function ENT:OnThink()
if !self:IsAttacking() and !counting and !dying then
counting = true
timer.Simple(0.6,function()
if self:IsValid() then
self:EmitSound("enemies/bosses/margwa/step_0"..math.random(1,6)..".ogg")
util.ScreenShake(self:GetPos(),3,1000,0.5,2048)
counting = false
end
end)
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
