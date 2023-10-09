AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Panzer Soldat(BO2)"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo"

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Decapitated")
	self:NetworkVar("Bool", 1, "Alive")
	self:NetworkVar("Bool", 2, "MooSpecial")
	self:NetworkVar("Bool", 3, "WaterBuff")
	self:NetworkVar("Bool", 4, "Helmet")
	self:NetworkVar("Bool", 5, "BomberBuff")

	if self.InitDataTables then self:InitDataTables() end
end

function ENT:ComedyGrab()
	if CLIENT then return end
	if !self.TheComedy then return end
	self:EmitSound("nz_moo/zombies/vox/_mechz/claw/comedy/comedy_0"..math.random(2)..".mp3", 511)
end

function ENT:FinishGrab()
	if CLIENT then return end
	--print("Finish")
	if self:GetStop() then
		--print("Stopped")
		self.WaitForClaw = true
	end
end

AccessorFunc( ENT, "fLastToast", "LastToast", FORCE_NUMBER)

function ENT:Draw()
	self:DrawModel()

	if self.RedEyes and self:Alive() and !self:GetDecapitated() and !self:GetMooSpecial() and !self.IsMooSpecial then
		self:DrawEyeGlow() 
	end
	if self:GetHelmet() then
		self:FacePlateLamp()
	end
		
	if GetConVar( "nz_zombie_debug" ):GetBool() then
		render.DrawWireframeBox(self:GetPos(), Angle(0,0,0), self:OBBMins(), self:OBBMaxs(), Color(255,0,0), true)
	end
end

function ENT:FacePlateLamp()

	local lightglow = Material( "sprites/physg_glow1_noz" )
	local lightyellow = Color( 255, 255, 200, 200 )
	local bone = self:GetAttachment(self:LookupAttachment("tag_headlamp_fx"))
	local pos, ang = bone.Pos, bone.Ang	
	local lightglow = Material( "sprites/physg_glow1_noz" )
	local lightyellow = Color( 255, 255, 200, 200 )
	local finalpos = pos

	cam.Start3D2D(finalpos, ang, 1)
		surface.SetAlphaMultiplier(1)
		surface.SetMaterial(lightglow)
		surface.SetDrawColor(lightyellow)
		surface.DrawTexturedRect(-25,-10,100,20)
	cam.End3D2D()
	
	ang:RotateAroundAxis(ang:Forward(),90)

	cam.Start3D2D(finalpos, ang, 1)
		surface.SetAlphaMultiplier(1)
		surface.SetMaterial(lightglow)
		surface.SetDrawColor(lightyellow)
		surface.DrawTexturedRect(-25,-10,100,20)
	cam.End3D2D()
end

if CLIENT then return end


local util_traceline = util.TraceLine

ENT.RedEyes = false
ENT.SpeedBasedSequences = true

ENT.IsMooZombie = true
ENT.IsMooSpecial = true
ENT.IsMooBossZombie = true

ENT.AttackRange = 115

ENT.TraversalCheckRange = 100
ENT.CrawlerForce = 9400

ENT.Models = {
	{Model = "models/moo/_codz_ports/t7/tomb/moo_codz_t7_tomb_mechz.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"nz_soldat_arrive"}

ENT.DeathSequences = {
	"nz_soldat_death_1",
	"nz_soldat_death_2"
}

local WalkAttackSequences = {
	{seq = "nz_soldat_run_melee", dmgtimes = {0.7}},
}

local AttackSequences = {
	{seq = "nz_soldat_melee_a", dmgtimes = {0.7}},
	{seq = "nz_soldat_melee_b", dmgtimes = {0.7}},
}

local JumpSequences = {
	{seq = "nz_soldat_mantle_over", speed = 50, time = 2.5},
}

local ClimbUp48 = {
	"nz_soldat_traverse_jump_up_48"
}
local ClimbUp72 = {
	"nz_soldat_traverse_jump_up_72"
}
local ClimbUp96 = {
	"nz_soldat_traverse_jump_up_96"
}

local walksounds = {
	Sound("enemies/bosses/newpanzer/vox/ambient_01.ogg"),
	Sound("enemies/bosses/newpanzer/vox/ambient_02.ogg"),
	Sound("enemies/bosses/newpanzer/vox/ambient_03.ogg"),
	Sound("enemies/bosses/newpanzer/vox/ambient_04.ogg")
}

ENT.AttackSounds = {
	"enemies/bosses/newpanzer/vox/swing_01.ogg",
	"enemies/bosses/newpanzer/vox/swing_02.ogg",
	"enemies/bosses/newpanzer/vox/swing_03.ogg",
	"enemies/bosses/newpanzer/vox/swing_04.ogg",
}

ENT.DeathSounds = {
	"enemies/bosses/newpanzer/vox/death_00.ogg",
	"nz_moo/zombies/vox/_mechz/death_nh/death_nh_00.mp3",
	"nz_moo/zombies/vox/_mechz/death_nh/death_nh_01.mp3",
	"nz_moo/zombies/vox/_mechz/death_nh/death_nh_02.mp3",
}

ENT.IdleSequence = "nz_soldat_idle"
ENT.JetPackIdleSequence = "nz_soldat_hover_loop"
ENT.RunePrisonSequence = "nz_soldat_runeprison_struggle_loop"
ENT.TeslaSequence = "nz_soldat_tesla_loop"

ENT.FatalSequences = {
	"nz_soldat_powercore_pain",
	"nz_soldat_pain_faceplate"
}

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"nz_soldat_walk_basic",
			},
			FlameMovementSequence = {
				"nz_soldat_ft_walk",
			},
			FlyMovementSequence = {
				"nz_soldat_launch_pad_move_loop",
			},
			AttackSequences = {WalkAttackSequences},
			StandAttackSequences = {AttackSequences},
			Climb48 = {ClimbUp48},
			Climb72 = {ClimbUp72},
			Climb96 = {ClimbUp96},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 36, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"nz_soldat_run",
			},
			FlameMovementSequence = {
				"nz_soldat_ft_walk",
			},
			FlyMovementSequence = {
				"nz_soldat_launch_pad_move_loop",
			},
			AttackSequences = {WalkAttackSequences},
			StandAttackSequences = {AttackSequences},
			Climb48 = {ClimbUp48},
			Climb72 = {ClimbUp72},
			Climb96 = {ClimbUp96},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}}
}

function ENT:StatsInitialize()
	if SERVER then
		local count = #player.GetAllPlaying()

		if nzRound:InState( ROUND_CREATE ) then
			self:SetHealth(3900)
			self:SetMaxHealth(3900)
		else
			if nzRound:InState( ROUND_PROG ) then
				self:SetHealth(math.Clamp(nzRound:GetNumber() * 400 + (700 * count), 3900, 8700 * count))
				self:SetMaxHealth(math.Clamp(nzRound:GetNumber() * 400 + (700 * count), 3900, 8700 * count))
			else
				self:SetHealth(3900)
				self:SetMaxHealth(3900)	
			end
		end

		self.HelmetDamage = 0

		self.SpawnProtection = true -- Zero Health Zombies tend to be created right as they spawn.
		self.SpawnProtectionTime = CurTime() + 5 -- So this is an experiment to see if negating any damage they take for a second will stop this.

		angering = false
		leftthetoasteron = false

		self.JetpackSnd = "nz_moo/zombies/vox/_mechz/rocket/loop.wav"

		-- It is a 100% known fact that bools control at least 90% of the world... This comment is now false.
		self.UsingFlamethrower = false
		self.DisallowFlamethrower = false
		self:SetLastToast(CurTime())

		self.UsingGlowstick = false
		self.Enraged = false
		self.Jetpacking = false
		self.StartFlying = false

		self.UsingClaw = false
		self.WaitForClaw = false
		self.NextShootTime = math.random(5, 25) -- The initial chances of shooting glowsticks can vary. We love math random.
		
		self.TheComedy = false
		self.AutoStopComedy = 0

		self:SetLastToast(CurTime())
		self:SetMooSpecial(true)
		self:SetHelmet(true)
		self:SetStop(false)
		self:SetCollisionBounds(Vector(-21,-21, 0), Vector(21, 21, 90))
		self:SetRunSpeed( 36 )
	end
end

function ENT:OnSpawn()
	local seq = self:SelectSpawnSequence()
	local _, dur = self:LookupSequence(seq)

	self:SolidMaskDuringEvent(MASK_SOLID_BRUSHONLY)
	self:SetInvulnerable(true)
	self:SetSpecialAnimation(true)

	self:SetBodygroup(1,0)

	self:EmitSound("nz/panzer/mech_alarm.wav",511)
	self:EmitSound("enemies/bosses/newpanzer/mechz_entrance.ogg",100,100)

	if seq then
		self:PlaySequenceAndWait(seq)
		self:SetSpecialAnimation(false)
		self:SetInvulnerable(false)
		self:CollideWhenPossible()
	end
end

function ENT:PerformDeath(dmgInfo)
	self:StopToasting()
	if IsValid(self.Claw) then self.Claw:Remove() end
	self:EmitSound("enemies/bosses/newpanzer/rise.ogg",100, math.random(85, 105))

	if self:GetSpecialAnimation() or self.PanzerDGLifted and self:PanzerDGLifted() then
		self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
		self:EmitSound("enemies/bosses/newpanzer/explode.ogg", 511)
   		self:Explode(50, false)
		self:BecomeRagdoll(dmginfo)
	else
		self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
		self:DoDeathAnimation(self.DeathSequences[math.random(#self.DeathSequences)])
	end
end

function ENT:OnTargetInAttackRange()
	if self.Jetpacking then
		self:EndJetpack()
		--print("It is time commence the ass beating.")
	else
		if self.UsingFlamethrower then
			self:StopToasting()
		end
		if !self:GetBlockAttack() and !self.Jetpacking then
			self:Attack()
		else
			self:TimeOut(2)
		end
	end
end

function ENT:AI()
	local target = self:GetTarget()
	if IsValid(target) and target:IsPlayer() then

		if !self:Alive() or self:GetIsBusy() then return end -- Not allowed to do anything.

		-- FLAMETHROWER
		if !self:IsAttackBlocked() and self:TargetInRange(250) then
			if self:GetSpecialAnimation() then return end
			if self.Jetpacking then return end
			if self.UsingGlowstick then return end
			if self.DisallowFlamethrower then return end
			self:StartToasting()
		else
			self:StopToasting()
		end

		-- CLAW
		if CurTime() > self.NextShootTime and self:TargetInRange(850) and !self:TargetInRange(350) then
			if self:IsAttackBlocked() then return end
			if !self.Target:Alive() then return end
			if self:GetSpecialAnimation() then return end
			if self.Jetpacking then return end
			if self.UsingFlamethrower then return end

			self:Retarget()

			self.UsingClaw = true
			self.NextShootTime = CurTime() + math.random(5, 12)

			local shootpos = self:GetAttachment(18)
			if self:IsValidTarget( self:GetTarget() ) then
				self.loco:FaceTowards( self:GetTarget():GetPos() )
			end
		
			--self:FaceTowards(self:GetTarget():GetPos())
			self:PlaySequenceAndMove("nz_soldat_chaingun_intro_sprint_to_aim", 1, self.FaceEnemy)
			self.KillClaw = CurTime() + 4


			if IsValid(self.Target) and self.Target:IsPlayer() then
				local tr = util_traceline({
					start = self:EyePos(),
					endpos = self.Target:EyePos(),
					filter = self,
					ignoreworld = true,
				})
				local b = tr.Entity

				debugoverlay.Line(self:EyePos(), self.Target:EyePos(), 5, Color( 255, 255, 255 ), false)
			
				if IsValid(b) then
					self.Claw = ents.Create("nz_panzer_claw")
					self.Claw:SetPos(shootpos.Pos)
					self.Claw:Spawn()
					self.Claw:SetPanzer(self)
					self.Claw:Launch(((b:GetPos() + Vector(0,0,50)) - self.Claw:GetPos()):GetNormalized())
				end
			end

			local comedyday = os.date("%d-%m") == "01-04"
			if math.random(500) == 1 or comedyday then
				self:EmitSound("nz_moo/zombies/vox/_mechz/claw/comedy/fire.mp3", 100, math.random(85, 105))
				self.AutoStopComedy = CurTime() + 2.5
				self.TheComedy = true
			else
				self:EmitSound("nz_moo/zombies/vox/_mechz/claw/fire.mp3", 100, math.random(85, 105))
				self.TheComedy = false
			end

			local selectcolor = Color(255,90,0,255)
			local selectcolorstring = "255 90 0 255"
		
			self.ClawGlow = ents.Create("env_sprite")
			self.ClawGlow:SetKeyValue("model","sprites/redglow1.vmt")
			self.ClawGlow:SetKeyValue("scale","0.2")
			self.ClawGlow:SetKeyValue("rendermode","5")
			self.ClawGlow:SetKeyValue("rendercolor",selectcolorstring)
			self.ClawGlow:SetKeyValue("spawnflags","1") -- If animated
			self.ClawGlow:SetParent(self)
			self.ClawGlow:Fire("SetParentAttachment","tag_claw",0)
			self.ClawGlow:Spawn()
			self.ClawGlow:Activate()
			self:DeleteOnRemove(self.ClawGlow)


			self:SetBodygroup(1,1)
			self:Stop()
			self:PlaySequenceAndWait("nz_soldat_chaingun_fire")
		end

		-- ENRAGE
		if angering and !self.Enraged then
			self.Enraged = true
			self:DoSpecialAnimation("nz_soldat_berserk_1")

			self:SetRunSpeed(71)
			self:SpeedChanged()
		end
	end
end

function ENT:OnThink()
	if not IsValid(self) then return end
	--print(self.WaitForClaw)
	if self.UsingFlamethrower and self:GetLastToast() + 0.1 < CurTime() then -- This controls how offten the trace for the flamethrower updates it's position. This shit is very costly so I wanted to try limit how much it does it.
		self:StartToasting()
	end
	if self.WaitForClaw and self:GetStop() then
		self:SetBodygroup(1,0)

		self:SetStop(false)

		self.WaitForClaw = false
		self.UsingClaw = false
		if IsValid(self.ClawGlow) then self.ClawGlow:Remove() end
	end
	if self.UsingClaw and !IsValid(self.Claw) then
		self:FinishGrab()
	end
	if !self.UsingFlamethrower then
		self:StopSound("nz_moo/zombies/vox/_mechz/flame/loop.wav")
	end
	if self.TheComedy and self.WaitForClaw and CurTime() > self.AutoStopComedy then
		self.TheComedy = false
	end
end

function ENT:OnInjured( dmgInfo )
	local hitpos = dmgInfo:GetDamagePosition()
	
	if self:GetHelmet() then
		local bone = self:LookupBone("j_faceplate")
		local pos, ang = self:GetBonePosition(bone)
		local finalpos = pos + ang:Forward()*8 + ang:Up()*11
		
		if hitpos:DistToSqr(finalpos) < 75 then
			self.HelmetDamage = self.HelmetDamage + dmgInfo:GetDamage()
			if self.HelmetDamage > (self:GetMaxHealth() * 0.1) then
				self:SetHelmet(false)
				self:DeflateBones({
					"j_faceplate",
				})
				self:EmitSound("enemies/bosses/newpanzer/mechz_faceplate.ogg",511, 100)
				if !self:Alive() then return end
				self:DoSpecialAnimation("nz_soldat_pain_faceplate")
				angering = true
			end
		end
		
		dmgInfo:ScaleDamage(0.25) -- When the helmet isn't lost, all damage only deals 25%
	else
		local bone = self:LookupBone("j_head")
		local pos, ang = self:GetBonePosition(bone)
		local finalpos = pos + ang:Up()*4
		
		if hitpos:DistToSqr(finalpos) < 150 then
			-- No damage scaling on headshot, we keep it at 1x
		else
			dmgInfo:ScaleDamage(0.25) -- When the helmet is lost, a non-headshot still only deals 25%
		end
	end
end

function ENT:ResetMovementSequence()
	if self.UsingFlamethrower then
		self:ResetSequence(self.FlameMovementSequence)
		self.CurrentSeq = self.FlameMovementSequence
	elseif self.Jetpacking then
		self:ResetSequence(self.FlyMovementSequence)
		self.CurrentSeq = self.FlyMovementSequence
	else
		self:ResetSequence(self.MovementSequence)
		self.CurrentSeq = self.MovementSequence
	end
	if self.UpdateSeq ~= self.CurrentSeq then
		self.UpdateSeq = self.CurrentSeq
		self:UpdateMovementSpeed()
	end
end

-- Called when the zombie wants to idle. Play an animation here
function ENT:PerformIdle()
	if !self.UsingClaw then
		if self.UsingFlamethrower then
			self:StopToasting()
		end
		if self.Jetpacking then
			self:ResetSequence(self.JetPackIdleSequence)
		elseif self.PanzerDGLifted and self:PanzerDGLifted() then
			self:ResetSequence(self.TeslaSequence)
		else
			self:ResetSequence(self.IdleSequence)
		end
	end
end

function ENT:DoDeathAnimation(seq)
	self.BehaveThread = coroutine.create(function()
		self:PlaySequenceAndWait(seq)
		self:EmitSound("enemies/bosses/newpanzer/explode.ogg", 511)
   		self:Explode(50, false)
		self:BecomeRagdoll(DamageInfo())
	end)
end

function ENT:StartToasting()
	self.UsingFlamethrower = true
	if self.UsingFlamethrower then
		--print("I'm Nintoasting!!!")

		if not leftthetoasteron then
			ParticleEffectAttach("asw_mnb_flamethrower",PATTACH_POINT_FOLLOW,self,5)
			self:EmitSound("nz_moo/zombies/vox/_mechz/flame/start.mp3",95, math.random(85, 105))
			self:EmitSound("nz_moo/zombies/vox/_mechz/flame/loop.wav",100, 100)
			leftthetoasteron = true
		end

		self:SetLastToast(CurTime())
		if !self.NextFireParticle or self.NextFireParticle < CurTime() then
			local bone = self:GetAttachment(self:LookupAttachment("tag_flamethrower_fx"))
			pos = bone.Pos
			local mins = Vector(0, -8, -15)
			local maxs = Vector(325, 20, 15)
			local tr = util.TraceHull({
				start = pos,
				endpos = pos + bone.Ang:Forward()*500,
				filter = self,
				mask = MASK_PLAYERSOLID,
				collisiongroup = COLLISION_GROUP_INTERACTIVE_DEBRIS,
				ignoreworld = true,
				mins = mins,
				maxs = maxs,
			})
		
			debugoverlay.BoxAngles(pos, mins, maxs, bone.Ang, 1, Color( 255, 255, 255, 10))
					
			if self:IsValidTarget(tr.Entity) then
				local dmg = DamageInfo()
				dmg:SetAttacker(self)
				dmg:SetInflictor(self)
				dmg:SetDamage(3)
				dmg:SetDamageType(DMG_BURN)
						
				tr.Entity:TakeDamageInfo(dmg)
				tr.Entity:Ignite(3, 0)
			end
		end
		self.NextFireParticle = CurTime() + 0.05
	end
end

function ENT:StopToasting()
	if self.UsingFlamethrower then
		--print("I'm no longer Nintoasting.")
		if leftthetoasteron then
			self:EmitSound("nz_moo/zombies/vox/_mechz/flame/end.mp3",100, math.random(85, 105))
			self:StopSound("nz_moo/zombies/vox/_mechz/flame/loop.wav")
			leftthetoasteron = false
		end
		self.UsingFlamethrower = false
		self:StopParticles()
	end
end

function ENT:OnRemove()
	self:StopSound(self.JetpackSnd)
	self:StopSound("nz_moo/zombies/vox/_mechz/flame/loop.wav")
	if IsValid(self.Claw) then self.Claw:Remove() end
	if IsValid(self.ClawGlow) then self.ClawGlow:Remove() end
	self:StopToasting()
end

function ENT:HandleAnimEvent(a,b,c,d,e)
	if e == "melee" then
		self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2)
		self:DoAttackDamage()
	end
	if e == "death_ragdoll" then
		self:BecomeRagdoll(DamageInfo())
	end
	if e == "start_traverse" then
		--print("starttraverse")
		self.TraversalAnim = true
	end
	if e == "finish_traverse" then
		--print("finishtraverse")
		self.TraversalAnim = false
	end

	if e == "mech_melee_whoosh" then
		self:EmitSound("enemies/bosses/newpanzer/melee_a.ogg",80)
	end
	if e == "mech_stomp_le" then
		self:EmitSound("enemies/bosses/newpanzer/anim_decepticon_lg_run_0"..math.random(1,4)..".ogg",80,math.random(95,100))
		self:EmitSound("nz/panzer/servo/mech_servo_0"..math.random(0,1)..".wav",65,math.random(95,100))
		util.ScreenShake(self:GetPos(),100000,500000,0.2,1000)
		ParticleEffectAttach("panzer_land_dust",PATTACH_POINT,self,13)
	end
	if e == "mech_stomp_ri" then
		self:EmitSound("enemies/bosses/newpanzer/anim_decepticon_lg_run_0"..math.random(1,4)..".ogg",80,math.random(95,100))
		self:EmitSound("nz/panzer/servo/mech_servo_0"..math.random(0,1)..".wav",65,math.random(95,100))
		util.ScreenShake(self:GetPos(),100000,500000,0.2,1000)
		ParticleEffectAttach("panzer_land_dust",PATTACH_POINT,self,14)
	end
	if e == "mech_land" then
		self:EmitSound("enemies/bosses/newpanzer/land_0"..math.random(0,2)..".ogg",80,math.random(95,100))
		util.ScreenShake(self:GetPos(),100000,500000,0.2,1000)
	end
	if e == "mech_jetflames_start" then
		ParticleEffectAttach("bo3_panzer_engine",PATTACH_POINT_FOLLOW,self,4)
		ParticleEffectAttach("bo3_panzer_engine",PATTACH_POINT_FOLLOW,self,3)
	end
	if e == "mech_jetflames_stop" then
		self:StopParticles()
	end
	if e == "mech_yell" then
		self:EmitSound("enemies/bosses/newpanzer/vox/angry_nh_0"..math.random(3)..".ogg", 95, math.random(95,105))
	end
end

function ENT:IsValidTarget( ent )
	if not ent then return false end
	return IsValid(ent) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
end

function ENT:HasHelmet() return self:GetHelmet() end

function ENT:TriggerBarricadeJump( barricade, dir )
	if not self:GetSpecialAnimation() and (not self.NextBarricade or CurTime() > self.NextBarricade) then

		self:StopToasting()

		self:SetSpecialAnimation(true)
		self:SetBlockAttack(true) -- Moo Mark BarricadeJump

		local id, dur, speed
		local animtbl = self.JumpSequences

		if self:GetCrawler() then
			animtbl = self.CrawlJumpSequences
		end
 
		if type(animtbl) == "number" then -- ACT_ is a number, this is set if it's an ACT
			id = self:SelectWeightedSequence(animtbl)
			dur = self:SequenceDuration(id)
			speed = self:GetSequenceGroundSpeed(id)
			if speed < 10 then
				speed = 20
			end
		else
			local targettbl = animtbl and animtbl[math.random(#animtbl)] or self.JumpSequences
			if targettbl then -- It is a table of sequences
				id, dur = self:LookupSequenceAct(targettbl.seq) -- Whether it's an ACT or a sequence string
				speed = targettbl.speed
			else
				id = self:SelectWeightedSequence(ACT_JUMP)
				dur = self:SequenceDuration(id)
				speed = 30
			end
		end
		self:SolidMaskDuringEvent(MASK_NPCSOLID_BRUSHONLY) -- Nocollide with props and other entities while we attempt to vault (Gets removed after event, or with CollideWhenPossible)

		self.loco:SetDesiredSpeed(speed)
		self:SetVelocity(self:GetForward() * speed)
		self:SetSequence(id)
		self:SetCycle(0)
		self:SetPlaybackRate(1)
		self:EmitSound("nz_moo/zombies/vox/_mechz/rocket/start.mp3",85)
		self:TimedEvent(dur, function()
			self.NextBarricade = CurTime() + 2
			self:SetSpecialAnimation(false)
			self:SetBlockAttack(false)
			self.loco:SetAcceleration( self.Acceleration )
			self.loco:SetDesiredSpeed(self:GetRunSpeed())
			self:ResetMovementSequence()
			self:CollideWhenPossible() -- Remove the mask as soon as we can
			self:SetIsBusy(false)
		end)
		local warppos = barricade:GetPos() + dir * 30
		self:SetPos(warppos)
		local pos = barricade:GetPos() - dir * 50 -- Moo Mark
		self:MoveToPos(pos, { -- Zombie will move through the barricade.
			lookahead = 1,
			tolerance = 1,
			draw = false,
			maxage = dur, 
			repath = dur, 
		})					
	end
end
