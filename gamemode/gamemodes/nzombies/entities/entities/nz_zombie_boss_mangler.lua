AddCSLuaFile()

ENT.Base = "nz_zombiebase"
ENT.PrintName = "Mangler"
ENT.Category = "Brainz"
ENT.Author = "Laby"

ENT.Models = { "models/bosses/manglerraz.mdl" }

ENT.AttackRange = 115
ENT.DamageLow = 65
ENT.DamageHigh = 70


ENT.AttackSequences = {
	{seq = "melee1"},
	{seq = "melee2"},
	{seq = "melee3"},
	{seq = "melee_uppercut"}
}

ENT.DeathSequences = {
	"death1",
	"death2",
	"death3"
}

ENT.AttackSounds = {
	"enemies/bosses/raz/vox_plr_1_exert_melee_01.ogg",
	"enemies/bosses/raz/vox_plr_1_exert_melee_02.ogg",
	"enemies/bosses/raz/vox_plr_1_exert_melee_03.ogg",
	"enemies/bosses/raz/vox_plr_1_exert_melee_04.ogg"

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
	"empty.wav"
}

ENT.ActStages = {
	[1] = {
		act = ACT_WALK,
		minspeed = 1,
	},
	[2] = {
		act = ACT_RUN,
		minspeed = 200,
	},
	[3] = {
		act = ACT_RUN,
		minspeed = 210
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

	self:SetCollisionBounds(Vector(-17,-17, 0), Vector(17, 17, 70))

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
		
		self.ouch = 0 -- Used to save how much damage the light has taken
		self:SetUsingClaw(false)
		
		self.NextAction = 0
		self.NextClawTime = 0
		self.NextFlameTime = 0
	end
	
	self.ZombieAlive = true

end

function ENT:StatsInitialize()
	if SERVER then
		self:SetRunSpeed(150)
		self:SetHealth(3000)
		self:SetMaxHealth(20000)
		shooting = false
		dying = false
		helmet = true
		counting = false
		hasTaunted = false
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
	local seq = "enrage"
	local tr = util.TraceLine({
		start = self:GetPos() + Vector(0,0,500),
		endpos = self:GetPos(),
		filter = self,
		mask = MASK_SOLID_BRUSHONLY,
	})
	if tr.Hit then seq = "enrage" end
	local _, dur = self:LookupSequence(seq)

	-- play emerge animation on spawn
	-- if we have a coroutine else just spawn the zombie without emerging for now.
	if coroutine.running() then
		
		local pos = self:GetPos() + (seq == "enrage" and Vector(0,0,100) or Vector(0,0,450))
		counting = true
		self:SetSpecialAnimation(true)
		self:SetNoDraw(true)
		ParticleEffect("summon_beam",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
		ParticleEffect("driese_tp_arrival_ambient",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
		ParticleEffect("driese_tp_arrival_ambient_lightning",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
		ParticleEffect("driese_tp_arrival_phase1",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
		self:EmitSound("enemies/bosses/raz/spawn_short.ogg")
		self:EmitSound("nz/hellhound/spawn/strike.wav")
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
			self:SetPos(self:GetPos() + Vector(0,0,0))
			ParticleEffect("driese_tp_arrival_phase2",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
			ParticleEffect("driese_tp_arrival_impact_fx02_a",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
			self:SetInvulnerable(false)
			local effectData = EffectData()
			effectData:SetStart( self:GetPos() )
			effectData:SetOrigin( self:GetPos() )
			effectData:SetMagnitude(1)
			counting = false
			self:StartActivity( ACT_WALK )
				self.loco:SetDesiredSpeed( self:GetRunSpeed() )
				self:SetSpecialAnimation(false)
				self:SetBlockAttack(false)
		end)
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
	self:ResetSequence(seq)
	self:SetCycle(0)
self:EmitSound("enemies/bosses/raz/vox_plr_1_exert_pain_03_alt01.ogg")
	timer.Simple(dur, function()
		if IsValid(self) then
			self:Remove()
			ParticleEffect("bo3_panzer_explosion",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
		end
	end)

end

function ENT:BodyUpdate()

	self.CalcIdeal = ACT_IDLE

	local velocity = self:GetVelocity()

	local len2d = velocity:Length2D()

	if ( len2d > 100 ) then self.CalcIdeal = ACT_RUN elseif ( len2d > 5 ) then self.CalcIdeal = ACT_RUN end

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
if math.random(0,7)==7 then
self.AttackSequences = {
	{seq = "melee_uppercut"}
	
}
  local atkData2 = {}
    atkData2.dmglow = 240
    atkData2.dmghigh = 240
    atkData2.dmgforce = Vector( 0, 0, 0 )
	atkData2.dmgdelay = 0.3
    self:Attack( atkData2 )
else
self.AttackSequences = {
	{seq = "melee1"},
	{seq = "melee2"},
	{seq = "melee3"}
	
}
    local atkData = {}
    atkData.dmglow = 45
    atkData.dmghigh = 55
    atkData.dmgforce = Vector( 0, 0, 0 )
	atkData.dmgdelay = 0.3
    self:Attack( atkData )
	end
end

function ENT:OnPathTimeOut()
	local target = self:GetTarget()
	if CurTime() < self.NextAction then return end
	
	if math.random(0,5) == 0 and CurTime() > self.NextClawTime then
	
	-- Claw
		if self:IsValidTarget(target) then
			local tr = util.TraceLine({
				start = self:GetPos() + Vector(0,50,0),
				endpos = target:GetPos() + Vector(0,0,50),
				filter = self,
			})
			
			if IsValid(tr.Entity) and self:IsValidTarget(tr.Entity) and !IsValid(self.ClawHook) then
			
			self:Stop()
			self:SetSpecialAnimation(true)
				self:EmitSound("enemies/bosses/raz/raz_gun_charge.ogg")
				for i=1,15 do ParticleEffectAttach("bo3_mangler_charge",PATTACH_POINT_FOLLOW,self,4) end
					local clawpos = self:GetAttachment(self:LookupAttachment("tag_pointandshooty")).Pos
				timer.Simple(1, function() self:EmitSound("enemies/bosses/raz/fire_0"..math.random(3)..".ogg")end)
				timer.Simple(1, function()self.ClawHook = ents.Create("nz_mangler_shot")end)
				timer.Simple(1, function()self.ClawHook:SetPos(clawpos)end)
				timer.Simple(1, function()self.ClawHook:Spawn()end)
				timer.Simple(1, function()self.ClawHook:Launch(((tr.Entity:GetPos() + Vector(0,0,50)) - self.ClawHook:GetPos()):GetNormalized())end)
				timer.Simple(1, function()self:SetClawHook(self.ClawHook)end)
				timer.Simple(1, function()self:StopParticles()end)
				
				self:SetAngles((target:GetPos() - self:GetPos()):Angle())
				
				self.loco:SetDesiredSpeed(0)
				
				self:PlaySequenceAndWait("shoot")
	
				--self:SetSequence(self:LookupSequence("nz_grapple_loop"))
				
				local seq = "shoot"
			local id, dur = self:LookupSequence(seq)
				self:StartActivity( ACT_WALK )
				self.loco:SetDesiredSpeed( self:GetRunSpeed() )
				self:SetSpecialAnimation(false)
				self:SetBlockAttack(false)
				self:StopFlames()
			
				self.NextAction = CurTime() + math.random(1, 5)
				self.NextClawTime = CurTime() + math.random(3, 15)
			end
			
		end
		
	end
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
	function ENT:Draw()
		self:DrawModel()
		
		local dlight = DynamicLight( self:EntIndex() )
		if ( dlight ) then
			local bone = self:LookupBone("j_spinelower")
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

function ENT:OnInjured( dmgInfo )
	local hitpos = dmgInfo:GetDamagePosition()
	
	if !self.HelmetLost then
		local bone = self:LookupBone("j_head")
		local pos, ang = self:GetBonePosition(bone)
		local finalpos = pos + ang:Forward()*8 + ang:Up()*11
		
		if hitpos:DistToSqr(finalpos) < 100 then
		--print("headshot")
			self.ouch = self.ouch + dmgInfo:GetDamage()
			print(self.ouch)
			if self.ouch > 300 then
			--print("lose helmet")
				self.HelmetLost = true
				--self:ManipulateBonePosition(bone, Vector(0,0,-75))
				self:EmitSound("enemies/bosses/newpanzer/mechz_faceplate.ogg",511)
				self:EmitSound("enemies/bosses/raz/vox_plr_1_exert_charge_0"..math.random(4)..".ogg",511)
				self:SetBodygroup(1,1)
				self:SetSpecialAnimation(true)
				self:SetBlockAttack(true)
				local id, dur = self:LookupSequence("destroy_helmet")
				self:ResetSequence(id)
				self:SetCycle(0)
				self:SetPlaybackRate(1)
				self.loco:SetDesiredSpeed(0)
				self:SetVelocity(Vector(0,0,0))
				self:TimedEvent(dur, function()
					self.loco:SetDesiredSpeed(self:GetRunSpeed()*1.5)
					self:SetSpecialAnimation(false)
					self:SetBlockAttack(false)
				end)
			end
		end
		
		dmgInfo:ScaleDamage(0.6) -- When the helmet isn't lost, all damage only deals 60%
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
			self.Malding = false
				self:StartActivity( ACT_RUN )
				self.loco:SetDesiredSpeed( self:GetRunSpeed() )
			end
			return
		end

		coroutine.yield()

	end

end

function ENT:OnThink()
self:RemoveAllDecals()

if !self:IsAttacking() then
if !counting and !dying and !shooting and self:Health() > 0 then
counting = true
timer.Simple(0.3,function()
self:EmitSound("enemies/bosses/raz/step_0"..math.random(1,5)..".ogg")
counting = false
end)
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
