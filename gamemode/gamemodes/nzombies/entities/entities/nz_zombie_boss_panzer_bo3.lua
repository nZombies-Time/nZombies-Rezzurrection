AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Panzer Soldat(Der Eisendrache)"
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

AccessorFunc( ENT, "fLastToast", "LastToast", FORCE_NUMBER)

function ENT:Draw()
	self:DrawModel()

	if self.RedEyes and self:Alive() and !self:GetDecapitated() then
		self:DrawEyeGlow() 
	end
	if self:GetHelmet() then
		self:FacePlateLamp()
	end
		
	if GetConVar( "nz_zombie_debug" ):GetBool() then
		render.DrawWireframeBox(self:GetPos(), Angle(0,0,0), self:OBBMins(), self:OBBMaxs(), Color(255,0,0), true)
	end
end

function ENT:DrawEyeGlow()
	local eyeglow = Material("nz/zlight")
	local eyeColor = Color(255, 150, 50, 255)
	local latt = self:LookupAttachment("lefteye")
	local ratt = self:LookupAttachment("righteye")

	if latt == nil then return end
	if ratt == nil then return end

	local leye = self:GetAttachment(latt)
	local reye = self:GetAttachment(ratt)

	if leye == nil then return end
	if reye == nil then return end

	local righteyepos = leye.Pos + leye.Ang:Forward()*1.5
	local lefteyepos = reye.Pos + reye.Ang:Forward()*1.5

	if lefteyepos and righteyepos then
		render.SetMaterial(eyeglow)
		render.DrawSprite(lefteyepos, 6, 6, eyeColor)
		render.DrawSprite(righteyepos, 6, 6, eyeColor)
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

ENT.RedEyes = false
ENT.SpeedBasedSequences = true

ENT.IsMooZombie = true
ENT.IsMooSpecial = true
ENT.IsMooBossZombie = true

ENT.AttackRange = 115

ENT.TraversalCheckRange = 100

ENT.Models = {
	{Model = "models/moo/_codz_ports/t7/castle/moo_codz_t7_mechz.mdl", Skin = 0, Bodygroups = {0,0}},
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
	{seq = "nz_soldat_melee_a"},
	{seq = "nz_soldat_melee_b"},
}

local JumpSequences = {
	{seq = "nz_soldat_mantle_36"},
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

ENT.BarricadeTearSequences = {
	"nz_soldat_melee_a",
	"nz_soldat_melee_b",
}

ENT.FatalSequences = {
	"nz_soldat_powercore_pain",
	"nz_soldat_pain_faceplate"
}

ENT.NormalMantleOver48 = {
	"nz_soldat_mantle_48",
}

ENT.NormalMantleOver72 = {
	"nz_soldat_mantle_72",
}

ENT.NormalMantleOver96 = {
	"nz_soldat_mantle_96",
}

ENT.NormalJumpUp128 = {
	"nz_soldat_jump_up_128",
}

ENT.NormalJumpUp128Quick = {
	"nz_soldat_jump_up_128",
}

ENT.NormalJumpDown128 = {
	"nz_soldat_jump_down_128",
}

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"nz_soldat_walk_basic",
			},
			FlameMovementSequence = {
				"nz_soldat_ft_run",
			},
			FlyMovementSequence = {
				"nz_soldat_launch_pad_move_loop",
			},
			AttackSequences = {AttackSequences},
			StandAttackSequences = {AttackSequences},
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
				"nz_soldat_ft_run",
			},
			FlyMovementSequence = {
				"nz_soldat_launch_pad_move_loop",
			},
			AttackSequences = {AttackSequences},
			StandAttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 71, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"nz_soldat_sprint",
			},
			FlameMovementSequence = {
				"nz_soldat_ft_run",
			},
			FlyMovementSequence = {
				"nz_soldat_launch_pad_move_loop",
			},
			AttackSequences = {AttackSequences},
			StandAttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}}
}

function ENT:StatsInitialize()
	if SERVER then
		local count = #player.GetAllPlaying()
		local playerhpmod = 1

		local basehealth = 1200
		local basehealthmax = 22500

		local bosshealth = basehealth

		local healthincrease = 1000
		local coopmultiplier = 0.75

		if count > 1 then
			playerhpmod = count * coopmultiplier
		end

		bosshealth = math.Round(playerhpmod * (basehealth + (healthincrease * nzRound:GetNumber())))

		if nzRound:InState( ROUND_CREATE ) then
			self:SetHealth(basehealth)
			self:SetMaxHealth(basehealth)
		else
			if nzRound:InState( ROUND_PROG ) then
				self:SetHealth(math.Clamp(bosshealth, basehealth, basehealthmax * playerhpmod))
				self:SetMaxHealth(math.Clamp(bosshealth, basehealth, basehealthmax * playerhpmod))
			else
				self:SetHealth(basehealth)
				self:SetMaxHealth(basehealth)	
			end
		end

		self.HelmetHP = self:GetMaxHealth() * 0.1

		self.SpawnProtection = true -- Zero Health Zombies tend to be created right as they spawn.
		self.SpawnProtectionTime = CurTime() + 5 -- So this is an experiment to see if negating any damage they take for a second will stop this.

		angering = false
		leftthetoasteron = false

		self.JetpackSnd = "nz_moo/zombies/vox/_mechz/rocket/loop.wav"

		-- It is a 100% known fact that bools control at least 90% of the world... This comment is now false.
		self.UsingFlamethrower = false
		self.DisallowFlamethrower = false
		self:SetLastToast(CurTime())
		
		self.CanCancelAttack = true

		self.UsingGlowstick = false
		self.Enraged = false
		self.Jetpacking = false
		self.StartFlying = false
		self.LastGlowstick = CurTime() + 3 -- The initial chances of shooting glowsticks can vary. We love math random.
		self:SetMooSpecial(true)
		self:SetHelmet(true)
		self:SetCollisionBounds(Vector(-21,-21, 0), Vector(21, 21, 90))
		self:SetRunSpeed( 36 )
	end
end

function ENT:OnSpawn()
	local seq = self:SelectSpawnSequence()
	local _, dur = self:LookupSequence(seq)

	self:SolidMaskDuringEvent(MASK_SOLID_BRUSHONLY)
	self:SetSpecialAnimation(true)

	self:EmitSound("enemies/bosses/newpanzer/incoming_alarm_new.ogg",511)
	self:EmitSound("enemies/bosses/newpanzer/mechz_entrance.ogg",100,100)


	if seq then
		self:PlaySequenceAndWait(seq)
		self:SetSpecialAnimation(false)
		self:CollideWhenPossible()
	end
end

function ENT:AI()
	local target = self:GetTarget()
	if IsValid(target) and target:IsPlayer() then

		if !self:Alive() or self:GetIsBusy() then return end -- Not allowed to do anything.

		-- FLAMETHROWER
		if !self:GetSpecialAnimation() and !self:IsAttackBlocked() and self:TargetInRange(250) then
			if self.Jetpacking then return end
			if self.UsingGlowstick then return end
			if self.DisallowFlamethrower then return end
			self:StartToasting()
		else
			self:StopToasting()
		end

		-- GLOWSTICK
		if !self:IsAttackBlocked() and self:TargetInRange(1250) and !self:TargetInRange(350) then
			if CurTime() > self.LastGlowstick then
				if self:GetSpecialAnimation() then return end
				if self.Jetpacking then return end
				if self.UsingFlamethrower then return end

				self:TempBehaveThread(function(self)
					self.UsingGlowstick = true
					self:SetSpecialAnimation(true)
					self:PlaySequenceAndMove("nz_soldat_chaingun_intro_sprint_to_aim", 1, self.FaceEnemy)
					for i = 1, 3 do 
						local larmfx_tag = self:LookupBone("tag_gun_spin")

						self.GlowStick = ents.Create("nz_glowstick")
						self.GlowStick:SetPos(self:GetBonePosition(larmfx_tag))
						self.GlowStick:Spawn()

						local phys = self.GlowStick:GetPhysicsObject()
						local target = self:GetTarget()
						if IsValid(phys) and IsValid(target) then
			 				phys:SetVelocity(self.GlowStick:getvel(target:GetPos(), self:EyePos(), 1.2))
						end

						self:EmitSound("weapons/ar2/ar2_reload_rotate.wav", 75, math.random(95,105))
						self:EmitSound("weapons/ar2/ar2_altfire.wav", 100, math.random(95,105))
						self:EmitSound("weapons/ar2/npc_ar2_altfire.wav", 85, math.random(95,105))

						ParticleEffectAttach("bo3_panzer_elec_blast",PATTACH_POINT,self,8)
						self:PlaySequenceAndMove("nz_soldat_chaingun_fire", 1, self.FaceEnemy)
					end
					self.LastGlowstick = CurTime() + math.random(5,12)
					self.UsingGlowstick = false
					self:SetSpecialAnimation(false)
				end)
			end
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

function ENT:PerformDeath(dmgInfo)
	self:EmitSound("enemies/bosses/newpanzer/rise.ogg",100, math.random(85, 105))

	self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
	self:DoDeathAnimation(self.DeathSequences[math.random(#self.DeathSequences)])
end

function ENT:OnTargetInAttackRange()
	if self.Jetpacking then
		self:EndJetpack()
		--print("It is time commence the ass beating.")
	else
		if self.UsingFlamethrower then
			self:StopToasting()
		end
		if !self:GetBlockAttack() then
			self:Attack()
		end
	end
end

function ENT:OnInjured( dmgInfo )
	local hitpos = dmgInfo:GetDamagePosition()
	
	if self:GetHelmet() then
		local bone = self:GetBonePosition(self:LookupBone("j_faceplate"))
		
		if hitpos:DistToSqr(bone) < 200 then
			if self.HelmetHP <= 0 and self:GetHelmet() then
				self:SetHelmet(false)
				self:DeflateBones({
					"j_faceplate",
				})
				self:EmitSound("enemies/bosses/newpanzer/mechz_faceplate.ogg",511, 100)
				if !self:Alive() then return end
				self:DoSpecialAnimation("nz_soldat_pain_faceplate")
				angering = true
			else
				self.HelmetHP = self.HelmetHP - dmgInfo:GetDamage()
			end
		end
		
		dmgInfo:ScaleDamage(0.25) -- When the helmet isn't lost, all damage only deals 25%
	else
		local bone = self:GetBonePosition(self:LookupBone("j_head"))
		
		if hitpos:DistToSqr(bone) < 150 then
			-- No damage scaling on headshot, we keep it at 1x
		else
			dmgInfo:ScaleDamage(0.5) -- When the helmet is lost, a non-headshot still only deals 50%
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
	if self:GetSequenceGroundSpeed(self:GetSequence()) ~= self:GetRunSpeed() or self.UpdateSeq ~= self.CurrentSeq then -- Moo Mark 4/19/23: Finally got a system where the speed actively updates when the movement sequence set is changed.
		--print("update")
		self.UpdateSeq = self.CurrentSeq
		self:UpdateMovementSpeed()
	end
end

-- Called when the zombie wants to idle. Play an animation here
function ENT:PerformIdle()
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
				dmg:SetDamage(2)
				dmg:SetDamageType(DMG_BURN)
						
				tr.Entity:TakeDamageInfo(dmg)
				tr.Entity:Ignite(2, 0)
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

function ENT:OnThink()
	if !IsValid(self) then return end

	if self.UsingFlamethrower and self:GetLastToast() + 0.1 < CurTime() then -- This controls how offten the trace for the flamethrower updates it's position. This shit is very costly so I wanted to try limit how much it does it.
		self:StartToasting()
	end
	if !self.UsingFlamethrower then
		self:StopSound("nz_moo/zombies/vox/_mechz/flame/loop.wav")
	end
	if self:GetAttacking() or self:GetSpecialAnimation() or self:GetIsBusy() then
		self:StopToasting()
	end
end

function ENT:OnRemove()
	self:StopSound(self.JetpackSnd)
	self:StopSound("nz_moo/zombies/vox/_mechz/flame/loop.wav")
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

--[[
function ENT:OnBarricadeBlocking( barricade, dir )
	if not self:GetSpecialAnimation() then

		self:StopToasting()
		if (IsValid(barricade) and barricade:GetClass() == "breakable_entry" ) then
				
			if barricade:GetNumPlanks() > 0 then
				local warppos = barricade:GetPos() + dir * 50
				local currentpos
				local currentb = barricade
				if !self:GetIsBusy() then -- When the zombie initially comes in contact with the barricade.
					self:MoveToPos(warppos, { lookahead = 20, tolerance = 20, draw = false, maxage = 3, repath = 3, })

					self:TimeOut(0.5) -- An intentional and W@W authentic stall.
					self:SolidMaskDuringEvent(MASK_NPCSOLID_BRUSHONLY)
				end
					
				self:SetIsBusy(true)
				currentpos = self:GetPos()
				if currentpos ~= warppos then
					self:SetPos(Vector(warppos.x,warppos.y,currentpos.z))
				end
				self:SetAngles(Angle(0,(barricade:GetPos()-self:GetPos()):Angle()[2],0))

				if IsValid(barricade.ZombieUsing) then -- Moo Mark 3/15/23: Trying out something where only one zombie can actively attack a barricade at a time.
					--local no, fuckoff = self:CheckForBarricade()
					self:TimeOut(1)
					if barricade then
						self:OnBarricadeBlocking(barricade, dir)
						return
					end
				else
					local seq, dur

					local attacktbl = self.AttackSequences
					if self:GetCrawler() then
						attacktbl = self.CrawlAttackSequences
					end

					local target = type(attacktbl) == "table" and attacktbl[math.random(#attacktbl)] or attacktbl
					local teartbl = self.BarricadeTearSequences[math.random(#self.BarricadeTearSequences)]
					local teartarget = type(teartbl) == "table" and teartbl[math.random(#teartbl)] or teartbl
					
					if not self.IsMooSpecial and not self:GetCrawler() then -- Don't let special zombies use the tear anims.
						if type(teartarget) == "table" then
							seq, dur = self:LookupSequenceAct(teartarget.seq)
						elseif teartarget then -- It is a string or ACT
							seq, dur = self:LookupSequenceAct(teartarget)
						else
							seq, dur = self:LookupSequence("swing")
						end
					else
						if type(target) == "table" then
							seq, dur = self:LookupSequenceAct(target.seq)
						elseif target then -- It is a string or ACT
							seq, dur = self:LookupSequenceAct(target)
						else
							seq, dur = self:LookupSequence("swing")
						end
					end

					local planktopull = barricade:BeginPlankPull(self)
					local planknumber -- fucking piece of shit
					if planktopull then
						planknumber = planktopull:GetFlags()
					end

					if !IsValid(barricade.ZombieUsing) then
						barricade:HasZombie(self) -- Blocks any other zombie from attacking the barricade.
					end

					if self.AttackSounds then self:PlaySound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2) end
					timer.Simple(dur/2, function() -- Moo Mark. This is very sinful but my dumbass can't think of anything else rn.
						if IsValid(self) and self:Alive() and IsValid(planktopull) then -- This is just so the plank being pulled looks nicer and will look like the zombie is actually pulling that bitch.
							barricade:RemovePlank(planktopull)
						end
					end)

					self:PlaySequenceAndWait(seq)

					self:SetLastAttack(CurTime())
					if math.random(100) <= 25 and !self:GetCrawler() and !self.IsMooSpecial then -- The higher the number, the more likely a zombie will taunt.
						self:SetStuckCounter( 0 ) --This is just to make sure a zombie won't despawn at a barricade.
						local seq,s = self:SelectTauntSequence()
						if seq then
							self:PlaySequenceAndWait(seq)
						end
					end

					-- this will cause zombies to attack the barricade until it's destroyed
					--local fuckyou, asshole = self:CheckForBarricade()
					if barricade then
						self:OnBarricadeBlocking(barricade, dir)
						return
					end
				end
			elseif barricade:GetTriggerJumps() and self.TriggerBarricadeJump then
				self:TimeOut(0.5)
				self:TriggerBarricadeJump(barricade, dir)
			else
				self:SolidMaskDuringEvent(MASK_NPCSOLID_BRUSHONLY)
				self:CollideWhenPossible()
				self:SetIsBusy(false)
			end
		end
	end
end
]]