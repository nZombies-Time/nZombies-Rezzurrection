AddCSLuaFile()

ENT.Base = "nz_zombiebase"
ENT.PrintName = "George Romero"
ENT.Category = "Brainz"
ENT.Author = "Laby"

ENT.Models = { "models/bosses/director.mdl" }

ENT.AttackRange = 140
ENT.DamageLow = 70
ENT.DamageHigh = 88

ENT.OnDeathSounds = {
	"enemies/bosses/dir/vox_director_die_01.ogg","enemies/bosses/dir/vox_director_die_02.ogg","enemies/bosses/dir/vox_director_die_03.ogg",
}

ENT.AttackSequences = {
	{seq = "att1"},
	{seq = "att2"},
	{seq = "att3"}
}

ENT.DeathSequences = {
	"death",
}

ENT.AttackSounds = {
	"enemies/bosses/dir/vox_director_pain_yell_01.ogg",
	"enemies/bosses/dir/vox_director_pain_yell_02.ogg",
	"enemies/bosses/dir/vox_director_pain_yell_03.ogg",
	
}

ENT.AttackHitSounds = {
	"enemies/bosses/dir/sfx/zmb_melee_light_00.ogg",
	"enemies/bosses/dir/sfx/zmb_melee_light_01.ogg",
	"enemies/bosses/dir/sfx/zmb_melee_light_02.ogg",
}

ENT.PainSounds = {
	"physics/flesh/flesh_impact_bullet1.wav",
	"physics/flesh/flesh_impact_bullet2.wav",
	"physics/flesh/flesh_impact_bullet3.wav",
	"physics/flesh/flesh_impact_bullet4.wav",
	"physics/flesh/flesh_impact_bullet5.wav"
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
		act = ACT_WALK,
		minspeed = 70,
	},
	[3] = {
		act = ACT_RUN,
		minspeed = 300,
	},
	[4] = {
		act = ACT_RUN,
		minspeed = 300
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
	self:SetTargetCheckRange(3000) -- 0 for no distance restriction (infinite)

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
	
		self:SetRunSpeed(69)
		self:SetHealth(4500)
		self:SetMaxHealth(4500)
		counting = true
		dying = false
		slamming = false
		taunting = true
		
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
self.Enraged = false
	self:NetworkVar("Entity", 0, "ClawHook")
	self:NetworkVar("Bool", 1, "UsingClaw")
	self:NetworkVar("Bool", 2, "Flamethrowing")
end

function ENT:OnSpawn()
self:SetInvulnerable(true)
	local seq = "teleport_out"
	local tr = util.TraceLine({
		start = self:GetPos() + Vector(0,0,500),
		endpos = self:GetPos(),
		filter = self,
		mask = MASK_SOLID_BRUSHONLY,
	})
	if tr.Hit then seq = "teleport_out" end
	local _, dur = self:LookupSequence(seq)

	-- play emerge animation on spawn
	-- if we have a coroutine else just spawn the zombie without emerging for now.
	if coroutine.running() then
	self.IsEmerging = true
		
		
		if self:WaterLevel() >= 1 then  
		self:EmitSound("enemies/bosses/dir/sfx/_bubbling.ogg",0)
		end
		self:EmitSound("enemies/bosses/dir/sfx/_yellow_beam.ogg",0.6)
		self:EmitSound("enemies/bosses/dir/sfx/_beam.ogg",1.4)
		self:EmitSound("enemies/bosses/dir/sfx/_electric_water.ogg",1.4)
		
		
		ParticleEffect("summon_beam",self:GetPos(),self:GetAngles(),nil)
		self:SetNoDraw(true)
		self:PlaySequenceAndWait("demerge",2.3)
	
		self:SetNoDraw(false)
		self:PlaySequenceAndWait("emerge")
		timer.Simple(0.4,function()self:EmitSound("enemies/bosses/dir/vox/vox_romero_start_0.ogg",511)end)
		timer.Simple(2.4,function()self:EmitSound("enemies/bosses/dir/vox/vox_romero_start_1.ogg",511)end)
		timer.Simple(14,function() taunting = false end)
		timer.Simple(2,function()self:SetInvulnerable(false)end)
		self.IsEmerging = false
		counting = false
		
		self.loco:SetDesiredSpeed(69)
		self:ResetSequence("walk")
		self:SetCycle(0)
end
end

function ENT:OnInjured(dmg, delay)
	if self:WaterLevel() < 1 and not self.Enraged then
		self.Enraged = true
			self.loco:SetDesiredSpeed(275)
		self:EmitSound("enemies/bosses/dir/vox_director_angered_0"..math.random(4)..".ogg",511)
		self:SetBodygroup(0,1)
		util.ScreenShake(self:GetPos(),10000,5000,3,1000)
		self:EmitSound("enemies/bosses/dir/sfx/_aggro_2d.ogg",511)
		timer.Simple(30,function()
		self.Enraged = false
		self:SetBodygroup(0,0)
		self:SetRunSpeed(69)
		self.loco:SetDesiredSpeed(69)
		self:EmitSound("enemies/bosses/dir/vox/vox_romero_water_"..math.random(2)..".ogg")
		end)
	elseif self:WaterLevel() >= 1 and not self.Enraged then
			local seq,dur = self:LookupSequence("yell_water")
			self:PlaySequenceAndWait("yell_water")
			self:EmitSound("enemies/bosses/dir/vox_director_speed_buff_03.ogg",1.4)
		end
	end


--[[function ENT:OnChaseEnemy(enemy) 
	self:EnragedWaterCodeInnit()
end

function ENT:EnragedWaterCodeInnit()
	if self:WaterLevel() > 0 and self.Enraged then
		self.Enraged = false
		self:SetBodygroup(0,0)
		self.loco:SetDesiredSpeed(69)
		
		local fx = EffectData()
			fx:SetOrigin(self:GetPos())
			fx:SetStart(self:GetPos())
			fx:SetScale(10)
			util.Effect("WaterSurfaceExplosion",fx)
		self:EmitSound("bo1_overhaul/dir/sfx/_beam.mp3",511)
		self:UpdateIdleSounds()
		
		
		self:EmitSound("bo1_overhaul/dir/vox/vox_romero_water_"..math.random(2)..".mp3")
	end
end]]

function ENT:OnZombieDeath(dmgInfo)
	dying = true
	self:ReleasePlayer()
	self:StopFlames()
		self.loco:SetDesiredSpeed(0)
	self:SetRunSpeed(0)
	self.loco:SetVelocity(Vector(0,0,0))
	self:Stop()
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	local seq, dur = self:LookupSequence(self.DeathSequences[math.random(#self.DeathSequences)])
	self:ResetSequence(seq)
	self:SetCycle(0)
	ParticleEffectAttach("thief_smog",PATTACH_ABSORIGIN_FOLLOW,self,0)

	timer.Simple(dur - 0.5, function()
		if IsValid(self) then
			self:EmitSound("enemies/bosses/dir/vox_director_die_0"..math.random(3)..".ogg")
		end
	end)
	timer.Simple(dur, function()
		if IsValid(self) then
			self:Remove()
			local effectData = EffectData()
			effectData:SetStart( self:GetPos() )
			effectData:SetOrigin( self:GetPos() )
			effectData:SetMagnitude(2)
				self:EmitSound("enemies/bosses/dir/sfx/_bubbling.ogg",511)
				local fx = EffectData()
			fx:SetOrigin(self:GetPos())
			fx:SetStart(self:GetPos())
			fx:SetScale(10)
			util.Effect("WaterSurfaceExplosion",fx)
	self:EmitSound("enemies/bosses/dir/sfx/_beam.ogg",511)
	self:ResetSequence("demerge")
		end
	end)

end


function ENT:BodyUpdate()

	self.CalcIdeal = ACT_IDLE

	local velocity = self:GetVelocity()

	local len2d = velocity:Length2D()

	if ( len2d > 75 ) then self.CalcIdeal = ACT_RUN elseif ( len2d > 5 ) then self.CalcIdeal = ACT_WALK end

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

function ENT:Director_DynamicLight(color, radius, brightness,style)
	if color == nil then color = Color(255, 255, 255) end
	if not isnumber(radius) then radius = 1000 end
	radius = math.Clamp(radius, 0, math.huge)
	if not isnumber(brightness) then brightness = 1 end
	brightness = math.Clamp(brightness, 0, math.huge)
	local light = ents.Create("light_dynamic")
	light:SetKeyValue("brightness", tostring(brightness))
	light:SetKeyValue("distance", tostring(radius))
	light:SetKeyValue("style", tostring(style))
	light:Fire("Color", tostring(color.r).." "..tostring(color.g).." "..tostring(color.b))
	light:SetLocalPos(self:GetPos())
	light:SetParent(self)
	light:Fire("setparentattachment","tag_club_light")
	light:Spawn()
	light:Activate()
	light:Fire("TurnOn", "", 0)
	self:DeleteOnRemove(light)
	return light
end

function ENT:OnTargetInAttackRange()
taunting = true
    local atkData = {}
    atkData.dmglow = 70
    atkData.dmghigh = 88
    atkData.dmgforce = Vector( 0, 0, 0 )
	atkData.dmgdelay = 0.2
    self:Attack( atkData )
		if self.Enraged then
					self.loco:SetDesiredSpeed(350)
				else
					self.loco:SetDesiredSpeed(69)
			end
end

function ENT:OnPathTimeOut()
	local target = self:GetTarget()
	if CurTime() < self.NextAction then return end
	
	if math.random(0,5) == 0 and CurTime() > self.NextClawTime then
		-- GEORGE SMASH
		if self:IsValidTarget(target) then
			local tr = util.TraceLine({
				start = self:GetPos() + Vector(0,50,0),
				endpos = target:GetPos() + Vector(0,0,50),
				filter = self,
			})
			
			if IsValid(tr.Entity) and self:IsValidTarget(tr.Entity) and !IsValid(self.ClawHook) then
			slamming = true
			
			taunting = true
			self:EmitSound("enemies/bosses/dir/sfx/zmb_ground_attack_0"..math.random(0,1)..".ogg",511)
			self:EmitSound("enemies/bosses/dir/sfx/zmb_ground_attack_flux.ogg")
			ParticleEffect("romero_club_hit",self:LocalToWorld(Vector(60,-30,0)),Angle(0,0,0),nil)
			ParticleEffectAttach("romero_club_glow",PATTACH_POINT_FOLLOW,self,4)
			util.ScreenShake(self:GetPos(),10000,5000,1,1000)
				self.loco:SetDesiredSpeed(0)
			 local atkData = {}
					self.AttackSequences = {
						{seq = "g_slamground"}
										}
			 self:SetAttackRange(300)
				atkData.dmglow = 60
				atkData.dmghigh = 76
				atkData.dmgforce = Vector( 0, 0, 0 )
				atkData.dmgdelay = 0.5
				self:Attack( atkData )
				--self:SetSequence(self:LookupSequence("nz_grapple_loop"))
					local id, dur = self:LookupSequence("g_slamground")
			self:SetCycle(0)
			self:SetPlaybackRate(1)
			self:SetVelocity(Vector(0,0,0))
			self:TimedEvent(dur, function()
			self:SetAttackRange(140)
			slamming = false
			if self.Enraged then
					self.loco:SetDesiredSpeed(350)
				else
					self.loco:SetDesiredSpeed(69)
			end
			self.AttackSequences = {
						{seq = "att1"},
						{seq = "att2"},
						{seq = "att3"}
										}
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

function ENT:OnThink()
if !dying and !slamming and self:Health() > 0 then
if !counting and !self:IsAttacking() then
counting = true
if self.Enraged then
timer.Simple(0.34,function()
self:EmitSound("enemies/bosses/dir/sfx/step_0"..math.random(1,4)..".ogg")
counting = false
end)
else
timer.Simple(0.8,function()
self:EmitSound("enemies/bosses/dir/sfx/step_0"..math.random(1,4)..".ogg")
counting = false
end)
end
end
if !taunting then
taunting = true
timer.Simple(11,function()
if self.Enraged then
self:EmitSound("enemies/bosses/dir/vox/vox_romero_angry_"..math.random(1,5)..".ogg")
taunting = false
else
self:EmitSound("enemies/bosses/dir/vox/vox_romero_taunt_"..math.random(1,14)..".ogg")
taunting = false
end
end)
end
end
if self:IsAttacking() then
self.loco:SetDesiredSpeed(0)
end
	if self:WaterLevel() > 0 and self.Enraged then
		self.Enraged = false
		self:SetBodygroup(0,0)
		self:SetRunSpeed(69)
		self.loco:SetDesiredSpeed(69)
		
		local fx = EffectData()
			fx:SetOrigin(self:GetPos())
			fx:SetStart(self:GetPos())
			fx:SetScale(10)
			util.Effect("WaterSurfaceExplosion",fx)
		self:EmitSound("enemies/bosses/dir/sfx/_beam.ogg",511)
		self:UpdateIdleSounds()
		
		self:EmitSound("enemies/bosses/dir/vox/vox_romero_water_"..math.random(2)..".ogg")
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
