AddCSLuaFile()

game.AddParticles("particles/electrical_fx.pcf")
game.AddParticles("particles/advisor_fx.pcf")
game.AddParticles("particles/weapon_fx.pcf")
game.AddParticles("particles/grenade_fx.pcf")
PrecacheParticleSystem("electrical_arc_01")
PrecacheParticleSystem("grenade_explosion_01")

ENT.Base = "nz_zombiebase"
ENT.PrintName = "Stadtjaeger"
ENT.Category = "Brainz"
ENT.Author = "Laby"

ENT.Models = {"models/roach/codww2/bob.mdl"}

ENT.AttackRange = 135
ENT.DamageLow = 60
ENT.DamageHigh = 80


ENT.AttackSequences = {
{seq = "att", dmgtimes = {1.4}}
}

ENT.DeathSequences = {
	"death"
}

ENT.AttackSounds = {
	"roach/codww2/bob/vox/zvox_bob_attack_lrg_01.wav",
	"roach/codww2/bob/vox/zvox_bob_attack_lrg_02.wav",
	"roach/codww2/bob/vox/zvox_bob_attack_lrg_03.wav",
	"roach/codww2/bob/vox/zvox_bob_attack_lrg_04.wav",
	"roach/codww2/bob/vox/zvox_bob_attack_lrg_05.wav",
	"roach/codww2/bob/vox/zvox_bob_attack_lrg_06.wav",
	"roach/codww2/bob/vox/zvox_bob_attack_lrg_07.wav"

}

ENT.PainSounds = {
		"physics/flesh/flesh_impact_bullet1.wav",
	"physics/flesh/flesh_impact_bullet2.wav",
	"physics/flesh/flesh_impact_bullet3.wav",
	"physics/flesh/flesh_impact_bullet4.wav",
	"physics/flesh/flesh_impact_bullet5.wav"

}

ENT.AttackHitSounds = {
	"roach/bo3/_zhd_player_impacts/evt_zombie_hit_player_01.mp3",
	"roach/bo3/_zhd_player_impacts/evt_zombie_hit_player_02.mp3",
	"roach/bo3/_zhd_player_impacts/evt_zombie_hit_player_03.mp3",
	"roach/bo3/_zhd_player_impacts/evt_zombie_hit_player_04.mp3",
	
	
}

ENT.WalkSounds = {
	"roach/codww2/bob/vox/zvox_bob_snarl_01.wav",
	"roach/codww2/bob/vox/zvox_bob_snarl_02.wav",
	"roach/codww2/bob/vox/zvox_bob_snarl_03.wav",
	"roach/codww2/bob/vox/zvox_bob_snarl_04.wav",
	"roach/codww2/bob/vox/zvox_bob_snarl_05.wav",
	"roach/codww2/bob/vox/zvox_bob_snarl_06.wav",
	"roach/codww2/bob/vox/zvox_bob_snarl_07.wav"
}

ENT.ActStages = {
	[1] = {
		act = ACT_walk,
		minspeed = 1,
	},
	[2] = {
		act = ACT_RUN,
		minspeed = 250,
	},
	[3] = {
		act = ACT_RUN,
		minspeed = 50
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
		self:SetRunSpeed(100)
		self:SetHealth(100)
		shooting = false
		dying = false
		helmet = true
		counting = true
		hasTaunted = false
	end

	--PrintTable(self:GetSequenceList())
end

function ENT:SpecialInit()


	if CLIENT then
		--make them invisible for a really short duration to blend the emerge sequences
		self:SetNoDraw(true)
		self:TimedEvent( 2, function()
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
	local seq = "emerge"
	local tr = util.TraceLine({
		start = self:GetPos() + Vector(0,0,500),
		endpos = self:GetPos(),
		filter = self,
		mask = MASK_SOLID_BRUSHONLY,
	})
	if tr.Hit then seq = "emerge" end
	local _, dur = self:LookupSequence(seq)

	-- play emerge animation on spawn
	-- if we have a coroutine else just spawn the zombie without emerging for now.
	if coroutine.running() then
		
		local pos = self:GetPos() + (seq == "emerge" and Vector(0,0,100) or Vector(0,0,450))
		counting = true
		ParticleEffectAttach("smoke_exhaust_01",PATTACH_POINT_FOLLOW,self,3)
	self:SetInvulnerable(true)
		
		--[[effectData = EffectData()
		effectData:SetStart( pos + Vector(0, 0, 1000) )
		effectData:SetOrigin( pos )
		effectData:SetMagnitude( 0.75 )
		util.Effect("lightning_strike", effectData)]]
		
		self:TimedEvent(1, function()
			--dust cloud
			self:SetNoDraw(false)
			self:SetPos(self:GetPos() + Vector(0,0,0))
			self:SetInvulnerable(false)
			
		end)
		
		timer.Simple(56/30,function()
		self:EmitSound("roach/codww2/bob/zmb_bob_intro_land_main.wav")
		self:EmitSound("roach/codww2/bob/zmb_bob_intro_land_electricity.wav")
		self:ElectricalDischarge(0.2,math.random(2,4),3)
		self:ElectricalDischarge(0.2,math.random(2,4),13)
	end)
	timer.Simple(0.5,function()
		self:EmitSound("roach/codww2/bob/vox/zvox_bob_intro.wav",511)
	end)
	timer.Simple(102/30,function()
		self:EmitSound("roach/codww2/brenner/zvox_fir_intro_roar.wav",511)
	end)
	timer.Simple(102/30,function()util.ScreenShake(self:GetPos(),3,100,2,500)end)
		self:PlaySequenceAndWait(seq)
	end
	counting = false
	--self:ResetSequence("walk")
	self:SetCycle(0)
end

function ENT:ESS(delay,...)
	local tbl = ...
	timer.Simple(delay,function()self:EmitSound(tbl)end)
end

function ENT:OnZombieDeath(dmgInfo)
	dying = true
	self:StopParticles()
	self:ReleasePlayer()
	self:StopFlames()
	self:SetRunSpeed(0)
	self.loco:SetVelocity(Vector(0,0,0))
	self:Stop()
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	local seq, dur = self:LookupSequence(self.DeathSequences[math.random(#self.DeathSequences)])
	self:ResetSequence(seq)
	self:SetCycle(0)
	self:EmitSound("roach/codww2/bob/zmb_berl_bob_death_elec.wav")
	self:EmitSound("roach/codww2/bob/vox/zvox_bob_death_seq.wav")
	self:ElectricalDischarge(0.2,28,1)
	self:ElectricalDischarge(0.2,8,30)
	self:ElectricalDischarge(0.1,19,82)
	self:ElectricalDischarge(0.1,18,111)
	self:ESS(1,"roach/codww2/bob/zmb_bob_gun_buildup_0"..math.random(5)..".wav")
	self:ESS(50/30,"roach/codww2/bob/zmb_berl_bob_death_shot.wav")
	timer.Simple(55/30,function()
		ParticleEffect("bo3_mangler_blast",self:GetBonePosition(self:LookupBone("j_head")),Angle(0,0,0),self)
	end)
	
	self:ESS(220/30-0.8,"roach/codww2/bob/zmb_berl_bob_death_explo_a.wav")
	timer.Simple(220/30,function()
		ParticleEffect("grenade_explosion_01",
			self:GetPos() + self:GetRight()*-30 + self:GetUp()*100,
			self:GetAngles(),nil)
	end)
	self:ESS(282/30-0.8,"roach/codww2/bob/zmb_berl_bob_death_explo_b.wav")
	timer.Simple(282/30,function()
		ParticleEffect("grenade_explosion_01",
			self:GetPos() + self:GetRight()*-10 + self:GetUp()*100,
			self:GetAngles(),nil)
	end)
	self:ESS(318/30,"roach/codww2/bob/zmb_berl_bob_death_explo_c.wav")
	timer.Simple(318/30,function()
		ParticleEffect("grenade_explosion_01",
			self:GetPos() + self:GetRight()*20 + self:GetUp()*100,
			self:GetAngles(),nil)
	end)
	self:ESS(335/30,"roach/codww2/bob/zmb_berl_bob_death_explo_c.wav")
	timer.Simple(335/30,function()
		ParticleEffect("grenade_explosion_01",
			self:GetPos() + self:GetRight()*-20 + self:GetUp()*50,
			self:GetAngles(),nil)
	end)
	self:ESS(382/30,"roach/codww2/shared/zmb_fs_default_land_hv_03.wav")
	self:ESS(426/30,"roach/codww2/shared/zmb_death_bodyfall_04.wav")
	self:PlaySequenceAndMove("death")
	self:EmitSound("roach/codww2/bob/zmb_berl_bob_engine_turn_off.wav")
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

	if ( len2d > 240 ) then self.CalcIdeal = ACT_RUN elseif ( len2d > 5 ) then self.CalcIdeal = ACT_WALK end

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
    atkData.dmglow = 60
    atkData.dmghigh = 90
    atkData.dmgforce = Vector( 0, 0, 0 )
	atkData.dmgdelay = 2
    self:Attack( atkData )
end

function ENT:ElectricalDischarge(delay,reps,start)
	start = start or 0
	for i=start,start+reps do
		timer.Simple(delay*i,function()
		ParticleEffect("electrical_arc_01",self:GetAttachment(math.random(3,6)).Pos,self:GetAngles())
			util.ParticleTracerEx("electrical_arc_01",
				self:GetAttachment(math.random(3,6)).Pos,
				self:GetAttachment(math.random(3,6)).Pos,
				false, self:EntIndex(), math.random(3,6))
		end)
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
				shooting = true
				self:EmitSound("roach/codww2/bob/vox/zvox_bob_roar_0"..math.random(3)..".wav",511)
			timer.Simple(0.2,function()
				self:EmitSound("roach/codww2/bob/zmb_bob_gun_buildup_0"..math.random(5)..".wav")
				self:EmitSound("roach/codww2/bob/zmb_berl_bob_engine_rev_0"..math.random(5)..".wav")
			end)
		
				timer.Simple(68/45, function() 
				self:EmitSound("roach/codww2/bob/zmb_berl_bob_smoke_atk_end.wav")
				self:ElectricalDischarge(0.1,10,0)
				self:EmitSound("roach/codww2/bob/zmb_bob_gun_fire_0"..math.random(5)..".wav")
				end)
	local clawpos = self:GetAttachment(self:LookupAttachment("tag_cannon")).Pos
				timer.Simple(1.5, function()self.ClawHook = ents.Create("nz_mangler_shot")end)
				timer.Simple(1.5, function()self.ClawHook:SetPos(clawpos)end)
				timer.Simple(1.5, function()self.ClawHook:Spawn()end)
				timer.Simple(1.5, function()self.ClawHook:Launch(((tr.Entity:GetPos() + Vector(0,0,50)) - self.ClawHook:GetPos()):GetNormalized())end)
				timer.Simple(1.5, function()self:SetClawHook(self.ClawHook)end)
				self:SetAngles((target:GetPos() - self:GetPos()):Angle())
				self:PlaySequenceAndWait("att_shoot")
				self:EmitSound("roach/codww2/bob/zmb_berl_bob_smoke_atk_end.wav")
				self:ElectricalDischarge(0.1,10,0)
				self.loco:SetDesiredSpeed(0)
				--self:SetSequence(self:LookupSequence("nz_grapple_loop"))
				timer.Simple(0.1, function()
			self:SetCycle(0)
			self:SetPlaybackRate(1)
			self:SetVelocity(Vector(0,0,0))
			shooting = false
				self.loco:SetDesiredSpeed(self:GetRunSpeed())
				self:SetSpecialAnimation(false)
				self:SetBlockAttack(false)
				self:StopFlames()
				end)
				self.NextAction = CurTime() + math.random(1, 5)
				self.NextClawTime = CurTime() + math.random(3, 15)
			end
		end
	elseif  math.random(0,5) == 6 and CurTime() > self.NextFlameTime then
		-- Flamethrower
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

function ENT:OnInjured(dmg)
	if helmet then
	if self:Health() < 2000 then
	helmet = false
	end
	else
end
end


function ENT:OnThink()
if !self:IsAttacking() then
if !counting and !dying and !shooting and self:Health() > 0 then
counting = true
timer.Simple(0.4,function()
self:EmitSound("roach/codww2/libertine/zmb_fs_run_brute_default_0"..math.random(9)..".wav")
counting = false
end)
end
end
if self:IsAttacking() then
self.loco:SetDesiredSpeed(0)
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
