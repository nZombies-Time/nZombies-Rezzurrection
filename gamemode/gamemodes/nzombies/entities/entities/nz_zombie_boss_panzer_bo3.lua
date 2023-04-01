AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Panzer Soldat(BO3)"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo"

AccessorFunc( ENT, "fLastToast", "LastToast", FORCE_NUMBER)

function ENT:Draw()
	self:DrawModel()

	if self.RedEyes and self:Alive() and !self:GetDecapitated() and !self:GetMooSpecial() and !self.IsMooSpecial then
		self:DrawEyeGlow() 
	end
	if !self.HelmetLost then
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

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true
ENT.IsMooSpecial = true

ENT.AttackRange = 115

ENT.TraversalCheckRange = 80

ENT.Models = {
	{Model = "models/moo/_codz_ports/t7/castle/moo_codz_t7_mechz.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"nz_soldat_arrive"}

ENT.DeathSequences = {
	"nz_soldat_death_1",
	"nz_soldat_death_2"
}

ENT.BarricadeTearSequences = {
	--Leave this empty if you don't intend on having a special enemy use tear anims.
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
			AttackSequences = {WalkAttackSequences},
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
			AttackSequences = {WalkAttackSequences},
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
			AttackSequences = {WalkAttackSequences},
			StandAttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 155, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"nz_soldat_launch_pad_move_loop",
			},
			AttackSequences = {WalkAttackSequences},
			StandAttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}}
}

function ENT:StatsInitialize()
	if SERVER then
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		if nzRound:InState( ROUND_CREATE ) then
			self:SetHealth(500)
			self:SetMaxHealth(500)
		else
			self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
			self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		end

		self.HelmetDamage = 0

		helmet = true
		enraged = false
		angering = false
		leftthetoasteron = false
		zoomingaround = false
		youraisemeup = false

		self.UsingFlamethrower = false
		self.UsingGlowstick = false
		self.Jetpacking = false
		self.StartFlying = false
		self.StopFlying = false
		self:SetLastToast(CurTime())
		self.NextShootTime = math.random(5, 25) -- The initial chances of shooting glowsticks can vary. We love math random.
		self:SetMooSpecial(true)
		self:SetRunSpeed( 36 )
		self:SetCollisionBounds(Vector(-20,-20, 0), Vector(20, 20, 85))
	end
end

function ENT:OnSpawn()
	local seq = self:SelectSpawnSequence()
	local _, dur = self:LookupSequence(seq)

	self:SolidMaskDuringEvent(MASK_SOLID_BRUSHONLY)
	self:SetInvulnerable(true)
	self:SetSpecialAnimation(true)

		self:EmitSound("enemies/bosses/newpanzer/incoming_alarm_new.ogg",511)
		ParticleEffectAttach("bo3_panzer_engine",PATTACH_POINT_FOLLOW,self,4)
		ParticleEffectAttach("bo3_panzer_engine",PATTACH_POINT_FOLLOW,self,3)
		self:EmitSound("enemies/bosses/newpanzer/mechz_entrance.ogg",100,100)
		self:TimedEvent(dur - 0.75, function()
			self:StopParticles()
		end)

	if seq then
		self:PlaySequenceAndWait(seq)
		self:SetSpecialAnimation(false)
		self:SetInvulnerable(false)
		self:CollideWhenPossible()
	end
end

function ENT:PerformDeath(dmgInfo)
	
	self.UsingFlamethrower = false
	self:StopSound("nz_moo/zombies/vox/_mechz/flame/loop.wav")
	self:StopToasting()

	self:EmitSound("enemies/bosses/newpanzer/rise.ogg",100, math.random(85, 105))

	if self:GetSpecialAnimation() or self.PanzerDGLifted and self:PanzerDGLifted() then
		self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
		self:EmitSound("enemies/bosses/newpanzer/explode.ogg", 511)
   		self:Explode( math.random( 45, 60 ))
		self:Remove(dmgInfo)
	else
		self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
		self:DoDeathAnimation(self.DeathSequences[math.random(#self.DeathSequences)])
	end
end

-- A standard attack you can use it or create something fancy yourself
function ENT:Attack( data )

	self.UsingFlamethrower = false
	self:StopSound("nz_moo/zombies/vox/_mechz/flame/loop.wav")
	self:StopToasting()

	self:SetLastAttack(CurTime())

	data = data or {}
	
	data.attackseq = data.attackseq
	if !data.attackseq then

		local attacktbl = self.AttackSequences

		self:SetStandingAttack(false)

		if self:GetCrawler() then
			attacktbl = self.CrawlAttackSequences
		end

		if self:GetTarget():GetVelocity():LengthSqr() < 5 and not self:GetCrawler() then
			if self.StandAttackSequences then -- Incase they don't have standing attack anims.
				attacktbl = self.StandAttackSequences
			end
			self:SetStandingAttack(true)
		end

		local target = type(attacktbl) == "table" and attacktbl[math.random(#attacktbl)] or attacktbl

		
		if type(target) == "table" then
			local id, dur = self:LookupSequenceAct(target.seq)
			if !target.dmgtimes then
			data.attackseq = {seq = id, dmgtimes =  {0.5} }
			else
			data.attackseq = {seq = id, dmgtimes = target.dmgtimes }
			end
			data.attackdur = dur
		elseif target then -- It is a string or ACT
			local id, dur = self:LookupSequenceAct(attacktbl)
			data.attackseq = {seq = id, dmgtimes = {dur/2}}
			data.attackdur = dur
		else
			local id, dur = self:LookupSequence("swing")
			data.attackseq = {seq = id, dmgtimes = {1}}
			data.attackdur = dur
		end
	end
	
	self:SetAttacking( true )
	if IsValid(self:GetTarget()) and self:GetTarget():Health() and self:GetTarget():Health() > 0 then -- Doesn't matter if its a player... If the zombie is targetting it, they probably wanna attack it.
		for k,v in pairs(data.attackseq.dmgtimes) do
			self:TimedEvent( v, function()
				if self.AttackSounds then self:PlaySound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2) end
				if !self:GetStop() and self:IsValidTarget( self:GetTarget() ) and self:TargetInRange( self:GetAttackRange() + 10 ) then
					local dmgInfo = DamageInfo()
					dmgInfo:SetAttacker( self )
					dmgInfo:SetDamage( 85 )
					dmgInfo:SetDamageType( DMG_SLASH )
					dmgInfo:SetDamageForce( (self:GetTarget():GetPos() - self:GetPos()) * 7 + Vector( 0, 0, 16 ) )
					self:GetTarget():TakeDamageInfo(dmgInfo)
					if !IsValid(self:GetTarget()) then return end
					self:GetTarget():EmitSound( "nz_moo/zombies/plr_impact/_zhd/evt_zombie_hit_player_0"..math.random(0,5)..".mp3", SNDLVL_TALKING, math.random(95,105))
					
					if self:GetTarget():IsPlayer() then
						self:GetTarget():ViewPunch( VectorRand():Angle() * 0.01 )
					end
				end
			end)
		end
	end

	self:TimedEvent(data.attackdur, function()
		self:SetAttacking(false)
		self:SetLastAttack(CurTime())
	end)

	self:PlayAttackAndWait(data.attackseq.seq, 1)
end

if SERVER then
	function ENT:RunBehaviour()

		self:Retarget()
		self:SpawnZombie()

		while (true) do

			if self.EventMask and not self.DoCollideWhenPossible then
				self:SetSolidMask(MASK_NPCSOLID)
			end
			if !self:GetStop() and self:GetFleeing() then -- Admittedly this was rushed, I took no time to understand how this can be achieved with nextbot pathing so I just made a short navmesh algorithm for fleeing. Sorry. Created by Ethorbit.
				self:SetTimedOut(false)

				local target = self:GetTarget()
				if IsValid(target) then
					self:SetLastFlee(CurTime())
					self:ResetMovementSequence() -- They'll comically slide away if this isn't here.
					self:MoveToPos(self:GetFleeDestination(target), {lookahead = 0, maxage = 3})
					self:SetLastFlee(CurTime())
				end
			end
			if !self:GetFleeing() and !self:GetStop() and CurTime() > self:GetLastFlee() + 2 then
				self:SetTimedOut(false)
				local ct = CurTime()
				if ct >= self.NextRetarget then
					local oldtarget = self.Target
					self:Retarget() --The overall process of looking for targets is handled much like how it is in nZu. While it may not save much fps in solo... Turns out this can vastly help the performance of multiplayer games.
				end
				if not self:HasTarget() and not self:IsValidTarget(self:GetTarget()) then
					self:OnNoTarget()
				else
					local path = self:ChaseTarget()
					if path == "failed" then
						self:SetTargetUnreachable(true)
					end
					if path == "ok" then
						if self:TargetInAttackRange() then -- Stop flying when you're in attack range.
							if self.Jetpacking then
								self.Jetpacking = false
								self.StopFlying = true
								--print("It is time commence the ass beating.")
							else
								if self.UsingFlamethrower then
									--print("I'm no longer Nintoasting.")
									self.UsingFlamethrower = false
									leftthetoasteron = false
									self:StopParticles()
								end
								self:OnTargetInAttackRange()
							end
						else
							self:TimeOut(0.1)
						end
					elseif path == "timeout" then --asume pathing timedout, maybe we are stuck maybe we are blocked by barricades
						self:SetTargetUnreachable(true)
						self:OnPathTimeOut()
					else
						self:TimeOut(0.5)
					end
				end
			else
				self:TimeOut(1)
			end
			if self.Jetpacking and self.StartFlying then
				self.StartFlying = false

				ParticleEffectAttach("bo3_panzer_engine",PATTACH_POINT_FOLLOW,self,4)
				ParticleEffectAttach("bo3_panzer_engine",PATTACH_POINT_FOLLOW,self,3)
				self:EmitSound("nz_moo/zombies/vox/_mechz/rocket/start.mp3",85)

				self:PlaySequenceAndWait("nz_soldat_launch_pad_takeoff")
				self:SetRunSpeed( 155 )
				self.loco:SetDesiredSpeed( 155 )
				self:SpeedChanged()
				self:ResetMovementSequence()
			elseif not self.Jetpacking and self.StopFlying then
				self.StopFlying = false
				self:StopParticles()
				self:StopSound("nz_moo/zombies/vox/_mechz/rocket/loop.wav")
				self:StopSound("nz_moo/zombies/vox/_mechz/rocket/joyride.wav")
				self:EmitSound("nz_moo/zombies/vox/_mechz/rocket/stop.mp3",85)

				self:PlaySequenceAndWait("nz_soldat_launch_pad_land")
				if enraged then
					self:SetRunSpeed( 71 )
					self.loco:SetDesiredSpeed( 71 )
				else
					self:SetRunSpeed( 36 )
					self.loco:SetDesiredSpeed( 36 )
				end
				self:TimeOut(0.05)
				self:SpeedChanged()
				self:ResetMovementSequence()
			end
			if angering then
				angering = false
				enraged = true

				self:EmitSound("enemies/bosses/newpanzer/mechz_faceplate.ogg",511, 100)
				self:PlaySequenceAndWait("nz_soldat_pain_faceplate")
				self:PlaySequenceAndWait("nz_soldat_berserk_1")

				self:SetRunSpeed( 71 )
				self.loco:SetDesiredSpeed( 71 )
				self:TimeOut(0.05)
				self:SpeedChanged()
				self:ResetMovementSequence()
			end
			if self.FatalForceAnim and not self.Jetpacking then
				self.FatalForceAnim = false
				self:StopToasting()
				self:SetTarget(nil)

				self:EmitSound("enemies/bosses/newpanzer/vox/angry_nh_0"..math.random(1,3)..".ogg", 100, math.random(85, 105))
				self:EmitSound("enemies/bosses/newpanzer/destruction_0"..math.random(2)..".ogg", 100, math.random(85, 105))
				--print("Uh oh Luigi, I'm about to commit insurance fraud lol.")
				self:DoSpecialAnimation(self.FatalSequences[math.random(#self.FatalSequences)])
			end
			if self.UsingGlowstick then

				local shootpos = self:GetAttachment(self:LookupAttachment("tag_gun_spin")).Pos
				if self:IsValidTarget( self:GetTarget() ) then
					self.loco:FaceTowards( self:GetTarget():GetPos() )
				end
				self:PlaySequenceAndWait("nz_soldat_chaingun_intro_sprint_to_aim")
				for i=1, 3 do
					-- He won't use this ability for the time being.
					self:EmitSound("enemies/bosses/newpanzer/wpn_grenade_fire_mechz.ogg", 100, math.random(85, 105))
					ParticleEffectAttach("bo3_panzer_elec_blast",PATTACH_POINT,self,8)
					self:PlaySequenceAndWait("nz_soldat_chaingun_fire")
				end
				self.UsingGlowstick = false
			end
			if not self.NextSound or self.NextSound < CurTime() and not self:GetAttacking() and self:Alive() then
				self:Sound() -- Moo Mark 12/7/22: Moved this out of the THINK function since I thought it was a little stupid.
			end
		end
	end
end

function ENT:OnPathTimeOut()
	local distToTarget = self:GetPos():DistToSqr(self:GetTargetPosition())
	if IsValid(self:GetTarget()) then
		if !self.Jetpacking and !self.UsingGlowstick and distToTarget > 750^2 then -- You're gonna fly over to the sorry bastard you're chasing and beat them to a pulp.
			self.Jetpacking = true -- Personally... I prefer the air!
			self.StartFlying = true
			local comedyday = os.date("%d-%m") == "01-04"
			if math.random(10) == 10 or comedyday then
				self:EmitSound("nz_moo/zombies/vox/_mechz/rocket/joyride.wav",95, 100) -- Don't worry about it.
			else
				self:EmitSound("nz_moo/zombies/vox/_mechz/rocket/loop.wav",85, 100, 1, 3)
			end
			--print("Where do you think you're goin Mario? You can hide but you can't hide!")
		end
		if self.Jetpacking and distToTarget < 300^2 then
			self.Jetpacking = false
			self.StopFlying = true
		end
		if !self.Climbing and !youraisemeup and !self:GetSpecialAnimation() and !angering and !self:GetAttacking() and !self.Jetpacking and !self.UsingGlowstick and distToTarget < 320^2 then	
			self.UsingFlamethrower = true
			if not leftthetoasteron then
				--ParticleEffectAttach("bo3_panzer_flame",PATTACH_POINT_FOLLOW,self,5)
				ParticleEffectAttach("asw_mnb_flamethrower",PATTACH_POINT_FOLLOW,self,5) -- This one just looks cooler.

				self:EmitSound("nz_moo/zombies/vox/_mechz/flame/start.mp3",95, math.random(85, 105))
				self:EmitSound("nz_moo/zombies/vox/_mechz/flame/loop.wav",100, 100)
				leftthetoasteron = true
			end
		elseif not self.Jetpacking then
			self.UsingFlamethrower = false
			if leftthetoasteron then
				self:EmitSound("nz_moo/zombies/vox/_mechz/flame/stop.mp3",100, math.random(85, 105))
				self:StopSound("nz_moo/zombies/vox/_mechz/flame/loop.wav")
				leftthetoasteron = false
			end
			self:StopParticles()
		end
		--[[if CurTime() > self.NextShootTime and !self:GetSpecialAnimation() and !angering and !self.Jetpacking and !self:GetAttacking() and !self.UsingFlamethrower and distToTarget > 500^2 then
			--print("I shall assault you with glow sticks.")
			self.UsingGlowstick = true
			self.NextShootTime = CurTime() + math.random(7, 18)
		end]]
	end
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
				angering = true
				self:DeflateBones({
					"j_faceplate",
				})
			end
		end
		
		dmgInfo:ScaleDamage(0.15) -- When the helmet isn't lost, all damage only deals 10%
	else
		local bone = self:LookupBone("j_head")
		local pos, ang = self:GetBonePosition(bone)
		local finalpos = pos + ang:Up()*4
		
		if hitpos:DistToSqr(finalpos) < 150 then
			-- No damage scaling on headshot, we keep it at 1x
		else
			dmgInfo:ScaleDamage(0.2) -- When the helmet is lost, a non-headshot still only deals 10%
		end
	end
	
end

function ENT:OnTakeDamage(dmginfo)
	if SERVER then
		local hitforce = dmginfo:GetDamageForce()

		if (dmginfo:GetDamageType() == DMG_DISSOLVE and dmginfo:GetDamage() >= self:Health() and self:Health() > 0) then
			self:DissolveEffect()
		end

		if self:CrawlerForceTest(hitforce) and not self:GetSpecialAnimation() and not self.Jetpacking then -- Don't mind the use of the crawler force here.
			self.FatalForceAnim = true
		end

		self:SetLastHurt(CurTime())
	end
end

function ENT:ResetMovementSequence()
	if self.UsingFlamethrower then
		self:ResetSequence(self.FlameMovementSequence)
	else
		self:ResetSequence(self.MovementSequence)
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


function ENT:OnBarricadeBlocking( barricade, dir )
		if not self:GetSpecialAnimation() then
			self.UsingFlamethrower = false

			self:StopSound("nz_moo/zombies/vox/_mechz/flame/loop.wav")
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
						if !self.IsMooSpecial then
							if planknumber ~= nil then
								if !self:GetCrawler() then
									self:PlaySequenceAndWait("nz_boardtear_aligned_m_"..planknumber.."_grab")
									if IsValid(self) and self:Alive() then
										if IsValid(planktopull) then
											barricade:RemovePlank(planktopull)
										end
									end
									self:PlaySequenceAndWait("nz_boardtear_aligned_m_"..planknumber.."_pull")
								else
									self:PlaySequenceAndWait("nz_crawl_boardtear_aligned_m_"..planknumber.."_grab")
									if IsValid(self) and self:Alive() then
										if IsValid(planktopull) then
											barricade:RemovePlank(planktopull)
										end
									end
									self:PlaySequenceAndWait("nz_crawl_boardtear_aligned_m_"..planknumber.."_pull")
								end
							end
						else
							timer.Simple(dur/2, function() -- Moo Mark. This is very sinful but my dumbass can't think of anything else rn.
								if IsValid(self) and self:Alive() and IsValid(planktopull) then -- This is just so the plank being pulled looks nicer and will look like the zombie is actually pulling that bitch.
									barricade:RemovePlank(planktopull)
								end
							end)

							self:PlaySequenceAndWait(seq)
						end

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

function ENT:TriggerBarricadeJump( barricade, dir )
	if not self:GetSpecialAnimation() and (not self.NextBarricade or CurTime() > self.NextBarricade) then

		self.UsingFlamethrower = false

		self:StopSound("nz_moo/zombies/vox/_mechz/flame/loop.wav")
		self:StopToasting()

		self:SetSpecialAnimation(true)
		self:SetBlockAttack(true) -- Moo Mark BarricadeJump

		ParticleEffectAttach("bo3_panzer_engine",PATTACH_POINT_FOLLOW,self,4)
		ParticleEffectAttach("bo3_panzer_engine",PATTACH_POINT_FOLLOW,self,3)

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
			if not self.Jetpacking then
				self:StopParticles()
			end
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

function ENT:DoDeathAnimation(seq)
	self.BehaveThread = coroutine.create(function()
		self:PlaySequenceAndWait(seq)
		self:EmitSound("enemies/bosses/newpanzer/explode.ogg", 511)
   		self:Explode( math.random( 45, 60 ))
		self:BecomeRagdoll(DamageInfo())
	end)
end

function ENT:StartToasting()
	if self.UsingFlamethrower then
		--print("I'm Nintoasting!!!")
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
		self.UsingFlamethrower = false
		if leftthetoasteron then
			self:EmitSound("nz_moo/zombies/vox/_mechz/flame/stop.mp3",100, math.random(85, 105))
			self:StopSound("nz_moo/zombies/vox/_mechz/flame/loop.wav")
			leftthetoasteron = false
		end
	end
	self:StopParticles()
end

function ENT:OnThink()
	if not IsValid(self) then return end
	if self.UsingFlamethrower and self:GetLastToast() + 0.1 < CurTime() then -- This controls how offten the trace for the flamethrower updates it's position. This shit is very costly so I wanted to try limit how much it does it.
		self:StartToasting()
	end
end

function ENT:OnRemove()
	self.UsingFlamethrower = false
	self:StopSound("nz_moo/zombies/vox/_mechz/flame/loop.wav")
	self:StopSound("nz_moo/zombies/vox/_mechz/rocket/loop.wav")
	self:StopSound("nz_moo/zombies/vox/_mechz/rocket/joyride.wav")
	self:StopToasting()
end

function ENT:IsValidTarget( ent )
	if not ent then return false end
	return IsValid( ent ) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
end

-- Panzer is getting more intense anti stuck measures since he can get stuck more easily.

if SERVER then
	-- Collide When Possible
	local collidedelay = 0.25
	local bloat = Vector(5,5,0)

	function ENT:Think()
		--[[if (self:IsAllowedToMove() and !self:GetAttacking() and !self:GetCrawler() and self.SameSquare) then -- Moo Mark
        	self.loco:SetVelocity(self:GetForward() * self:GetRunSpeed())
        end]]
		if self.DoCollideWhenPossible then
			if not self.NextCollideCheck or self.NextCollideCheck < CurTime() then
				local mins,maxs = self:GetCollisionBounds()
				local tr = util.TraceHull({
					start = self:GetPos(),
					endpos = self:GetPos(),
					filter = self,
					mask = MASK_SOLID,
					mins = mins - bloat,
					maxs = maxs + bloat,
					ignoreworld = false
				})

				local b = IsValid(tr.Entity)
				if not b then
					self:SetSolidMask(MASK_NPCSOLID)
					self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
					self:SetCollisionBounds(Vector(-20,-20, 0), Vector(20, 20, 85))
					self.DoCollideWhenPossible = nil
					self.NextCollideCheck = nil
				else
					self.NextCollideCheck = CurTime() + collidedelay
				end
			end
		end

		-- We don't want to say we're stuck if it's because we're attacking or timed out and !self:GetTimedOut() 
		if not self:GetSpecialAnimation() and not self:GetAttacking() and self:GetLastPostionSave() + 4 < CurTime() then
			if self:GetPos():DistToSqr( self:GetStuckAt() ) < 10 then
				self:SetStuckCounter( self:GetStuckCounter() + 1)
				--print(self:GetStuckCounter())
			else
				self:SetStuckCounter( 0 )
			end

			if self:GetStuckCounter() >= 1 then
				local tr = util.TraceHull({
					start = self:GetPos(),
					endpos = self:GetPos(),
					maxs = self:OBBMaxs(),
					mins = self:OBBMins(),
					filter = self
				})
				if !tr.HitNonWorld then
					--print("Stuck")
					self:ApplyRandomPush(750)
					self:SolidMaskDuringEvent(MASK_NPCSOLID_BRUSHONLY)
					self:CollideWhenPossible()
				end
				if self:GetStuckCounter() > 3 and not self.PanzerDGLifted and not self:PanzerDGLifted() then
					local spawnpoints = {}
					for k,v in pairs(ents.FindByClass("nz_spawn_zombie_special")) do -- Find and add all valid spawnpoints that are opened and not blocked
						if (v.link == nil or nzDoors:IsLinkOpened( v.link )) and v:IsSuitable() then
							table.insert(spawnpoints, v)
						end
					end
					local selected = spawnpoints[math.random(#spawnpoints)] -- Pick a random one
					self:SetPos(selected:GetPos())
					self:SetStuckCounter( 0 )
				end
			end
			self:SetLastPostionSave( CurTime() )
			self:SetStuckAt( self:GetPos() )
		end
		self:DebugThink()
		self:OnThink()
	end

	function ENT:SolidMaskDuringEvent(mask)  -- Changes the zombie's mask until the end of the event. If nil is passed, it immediately removes the mask
		if mask then
			self:SetSolidMask(mask)
			self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
			--self:SetCollisionBounds(Vector(-15,-15, 0), Vector(15, 15, 85))
			self.EventMask = true
		else
			self:SetSolidMask(MASK_NPCSOLID)
			self.EventMask = nil
		end
	end
end
