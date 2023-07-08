AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "The BRUHnner"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo"

AccessorFunc( ENT, "fLastToast", "LastToast", FORCE_NUMBER)

function ENT:Draw()
	self:DrawModel()

	if GetConVar( "nz_zombie_debug" ):GetBool() then
		render.DrawWireframeBox(self:GetPos(), Angle(0,0,0), self:OBBMins(), self:OBBMaxs(), Color(255,0,0), true)
	end
end

if CLIENT then return end

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true
ENT.IsMooSpecial = true

ENT.AttackRange = 115
ENT.DamageRange = 115

ENT.TraversalCheckRange = 80

ENT.Models = {
	{Model = "models/moo/_codz_ports/s2/zombie/moo_codz_s2_fireman.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"nz_s2_fireman_spawn"}

ENT.DeathSequences = {
	"nz_s2_fireman_death_v1",
	"nz_s2_fireman_death_v2"
}

local AttackSequences = {
	{seq = "nz_s2_fireman_stand_attack_v1"},
	{seq = "nz_s2_fireman_stand_attack_v2"},
}

local JumpSequences = {
	{seq = "nz_soldat_mantle_over", speed = 50, time = 2.5},
}

local walksounds = {
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_growl_lev1_01.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_growl_lev1_02.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_growl_lev1_03.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_growl_lev1_04.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_growl_lev1_05.mp3"),

	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_growl_lev2_01.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_growl_lev2_02.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_growl_lev2_03.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_growl_lev2_04.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_growl_lev2_05.mp3"),


	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_growl_lev3_01.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_growl_lev3_02.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_growl_lev3_03.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_growl_lev3_04.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_growl_lev3_05.mp3"),


	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_growl_lev4_01.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_growl_lev4_03.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_growl_lev4_04.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_growl_lev4_05.mp3"),

}

local runsounds = {
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_charge_01.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_charge_02.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_charge_03.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_charge_04.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_charge_05.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_charge_06.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_charge_07.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_charge_08.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_charge_09.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_charge_10.mp3"),

	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_taunt_01.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_taunt_02.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_taunt_03.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_taunt_04.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_taunt_05.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_taunt_06.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_taunt_07.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_taunt_08.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_taunt_09.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_taunt_10.mp3"),
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

ENT.AttackSounds = {
	"nz_moo/zombies/vox/_fireman/zvox_fir_melee_hit_01.mp3",
	"nz_moo/zombies/vox/_fireman/zvox_fir_melee_hit_02.mp3",
	"nz_moo/zombies/vox/_fireman/zvox_fir_melee_hit_03.mp3",
	"nz_moo/zombies/vox/_fireman/zvox_fir_melee_hit_04.mp3",
	"nz_moo/zombies/vox/_fireman/zvox_fir_melee_hit_05.mp3",
	"nz_moo/zombies/vox/_fireman/zvox_fir_melee_hit_06.mp3",
	"nz_moo/zombies/vox/_fireman/zvox_fir_melee_hit_07.mp3",
	"nz_moo/zombies/vox/_fireman/zvox_fir_melee_hit_08.mp3",
	"nz_moo/zombies/vox/_fireman/zvox_fir_melee_hit_09.mp3",
	"nz_moo/zombies/vox/_fireman/zvox_fir_melee_hit_10.mp3",
}

ENT.DeathSounds = {
	"nz_moo/zombies/vox/_fireman/zvox_fir_death_01.mp3",
	"nz_moo/zombies/vox/_fireman/zvox_fir_death_02.mp3",
	"nz_moo/zombies/vox/_fireman/zvox_fir_death_03.mp3",
	"nz_moo/zombies/vox/_fireman/zvox_fir_death_04.mp3",
	"nz_moo/zombies/vox/_fireman/zvox_fir_death_05.mp3",
	"nz_moo/zombies/vox/_fireman/zvox_fir_death_06.mp3",
	"nz_moo/zombies/vox/_fireman/zvox_fir_death_07.mp3",
	"nz_moo/zombies/vox/_fireman/zvox_fir_death_08.mp3",
	"nz_moo/zombies/vox/_fireman/zvox_fir_death_10.mp3",
}

ENT.IdleSequence = "nz_s2_fireman_idle"
ENT.RunePrisonSequence = "nz_soldat_runeprison_struggle_loop"
ENT.TeslaSequence = "nz_soldat_tesla_loop"

ENT.FatalSequences = {
	"nz_s2_fireman_stun_v1",
	"nz_s2_fireman_stun_v2"
}

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"nz_s2_fireman_walk",
			},
			FlameMovementSequence = {
				"nz_s2_fireman_walk_ft",
			},
			Climb48 = {ClimbUp48},
			Climb72 = {ClimbUp72},
			Climb96 = {ClimbUp96},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 36, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"nz_s2_fireman_run",
			},
			FlameMovementSequence = {
				"nz_s2_fireman_run",
			},
			Climb48 = {ClimbUp48},
			Climb72 = {ClimbUp72},
			Climb96 = {ClimbUp96},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {runsounds},
		},
	}}
}

ENT.PainSounds = {
	"nz_moo/zombies/vox/_fireman/zvox_fir_pain_01.mp3",
	"nz_moo/zombies/vox/_fireman/zvox_fir_pain_02.mp3",
	"nz_moo/zombies/vox/_fireman/zvox_fir_pain_03.mp3",
	"nz_moo/zombies/vox/_fireman/zvox_fir_pain_04.mp3",
	"nz_moo/zombies/vox/_fireman/zvox_fir_pain_05.mp3",
	"nz_moo/zombies/vox/_fireman/zvox_fir_pain_06.mp3",
	"nz_moo/zombies/vox/_fireman/zvox_fir_pain_07.mp3",
	"nz_moo/zombies/vox/_fireman/zvox_fir_pain_08.mp3",
	"nz_moo/zombies/vox/_fireman/zvox_fir_pain_09.mp3",
	"nz_moo/zombies/vox/_fireman/zvox_fir_pain_10.mp3",
}

ENT.BehindSoundDistance = 500 -- When the zombie is within 200 units of a player, play these sounds instead
ENT.BehindSounds = {
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_snarl_01.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_snarl_02.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_snarl_03.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_snarl_04.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_snarl_05.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_snarl_06.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_snarl_07.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_snarl_08.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_snarl_09.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_snarl_10.mp3"),
}

function ENT:StatsInitialize()
	if SERVER then
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		if nzRound:InState( ROUND_CREATE ) then
			self:SetHealth(4750)
			self:SetMaxHealth(4750)
		else
			self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
			self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		end

		enraged = false
		angering = false
		leftthetoasteron = false

		self.UsingFlamethrower = false
		self:SetLastToast(CurTime())
		self:SetMooSpecial(true)
		self:SetCollisionBounds(Vector(-20,-20, 0), Vector(20, 20, 85))
		self:SetRunSpeed( 36 )
	end
end

function ENT:OnSpawn()
	local seq = self:SelectSpawnSequence()
	local _, dur = self:LookupSequence(seq)

	self:SolidMaskDuringEvent(MASK_SOLID_BRUSHONLY)
	self:SetInvulnerable(true)
	self:SetSpecialAnimation(true)

	self:EmitSound("nz_moo/zombies/vox/_fireman/zvox_fir_spawn_01.mp3", 100, math.random(95,105), 1, 2)

	if seq then
		self:PlaySequenceAndWait(seq)
		self:SetSpecialAnimation(false)
		self:SetInvulnerable(false)
		self:CollideWhenPossible()
	end
end

function ENT:PerformDeath(dmgInfo)
	self:StopToasting()
	if self:GetSpecialAnimation() or self.PanzerDGLifted and self:PanzerDGLifted() then
		self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
		self:BecomeRagdoll(dmgInfo)
	else
		self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
		self:DoDeathAnimation(self.DeathSequences[math.random(#self.DeathSequences)])
	end
end

function ENT:OnTargetInAttackRange()
	if self.UsingFlamethrower then
		self:StopToasting()
	end
	if !self:GetBlockAttack() then
		self:Attack()
	else
		self:TimeOut(2)
	end
end

function ENT:AI()
	if IsValid(self:GetTarget()) then
		if !self:GetSpecialAnimation() and !self:GetAttacking() and !self:IsAttackBlocked() and self:TargetInRange(320) and !self:TargetInRange(self.AttackRange + 30) then	
			self:StartToasting()
		else
			self:StopToasting()
		end
		if self:TargetInRange(195) then
			if self:TargetInRange(self.AttackRange + 30) then return end
			if self:GetTarget():GetVelocity():LengthSqr() < 15 then
				self:TimeOut(0)
				self:StartToasting()
				self:TempBehaveThread(function(self)
					self:PlaySequenceAndWait("nz_s2_fireman_ft_sweep")
					self.UsingFlamethrower = false
					if self:TargetInRange(320) then return end
					self:StopToasting()
				end)
			end
		end
		if !self:IsAttackBlocked() and self:TargetInRange(275) then
			if self:GetRunSpeed() > 100 then
				self:SetRunSpeed(1)
				self:SpeedChanged()
			end
		else
			if self:GetRunSpeed() < 100 then
				self:SetRunSpeed(71)
				self:SpeedChanged()
			end
		end
	end
end

function ENT:PostTookDamage(dmginfo) 
	if self:CrawlerForceTest(hitforce) and not self:GetSpecialAnimation() then -- Don't mind the use of the crawler force here.
		if self.UsingFlamethrower then
			self:StopToasting()
		end
		self:EmitSound(self.PainSounds[math.random(#self.PainSounds)], 100, math.random(85, 105), 1, 2)
		self:DoSpecialAnimation(self.FatalSequences[math.random(#self.FatalSequences)])
	end
end

function ENT:ResetMovementSequence()
	if self.UsingFlamethrower then
		self:ResetSequence(self.FlameMovementSequence)
		self.CurrentSeq = self.FlameMovementSequence
	else
		self:ResetSequence(self.MovementSequence)
		self.CurrentSeq = self.MovementSequence
	end
	if self.UpdateSeq ~= self.CurrentSeq then
		self.UpdateSeq = self.CurrentSeq
		self:UpdateMovementSpeed()
	end
end

function ENT:PerformIdle()
	if self.UsingFlamethrower then
		self:StopToasting()
	end
	if self.PanzerDGLifted and self:PanzerDGLifted() then
		self:ResetSequence(self.TeslaSequence)
	else
		self:ResetSequence(self.IdleSequence)
	end
end

function ENT:DoDeathAnimation(seq)
	self.BehaveThread = coroutine.create(function()
		self:PlaySequenceAndWait(seq)
		self:BecomeRagdoll(DamageInfo())
	end)
end

function ENT:StartToasting()
	self.UsingFlamethrower = true
	if self.UsingFlamethrower then
		--print("I'm Nintoasting!!!")

		if not leftthetoasteron then
			ParticleEffectAttach("asw_mnb_flamethrower",PATTACH_POINT_FOLLOW,self,2)
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

	if e == "s2_fireman_step" then
		self:EmitSound("enemies/bosses/margwa/step_0"..math.random(1,6)..".ogg",80,math.random(95,100))
		util.ScreenShake(self:GetPos(),100000,500000,0.2,500)
	end
	if e == "panzer_land" then
		self:EmitSound("enemies/bosses/margwa/step_0"..math.random(1,6)..".ogg",100,math.random(95,100))
		util.ScreenShake(self:GetPos(),100000,500000,0.2,500)
			ParticleEffect("bo3_panzer_landing",self:LocalToWorld(Vector(0,20,0)),Angle(0,0,0),nil)
		for i=1,2 do
		end
	end
end

function ENT:OnThink()
	if not IsValid(self) then return end
	if self.UsingFlamethrower and self:GetLastToast() + 0.1 < CurTime() then -- This controls how offten the trace for the flamethrower updates it's position. This shit is very costly so I wanted to try limit how much it does it.
		self:StartToasting()
	end
end

function ENT:OnRemove()
	self:StopSound("nz_moo/zombies/vox/_mechz/flame/loop.wav")
	self:StopToasting()
end

function ENT:IsValidTarget( ent )
	if not ent then return false end
	return IsValid( ent ) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
end

if SERVER then
	-- Collide When Possible
	local collidedelay = 0.25
	local bloat = Vector(5,5,0)

	function ENT:Think()
		if (self:IsAllowedToMove() and !self:GetCrawler() and self.loco:GetVelocity():Length2D() >= 125 and self.SameSquare and !self:GetIsBusy() or self:IsAllowedToMove() and self:GetAttacking() ) then -- Moo Mark
        	self.loco:SetVelocity(self:GetForward() * self:GetRunSpeed())
        end
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

function ENT:Attack( data )

	self:StopToasting()

	self:SetLastAttack(CurTime())

	local useswalkframes = false

	data = data or {}
			
	data.attackseq = data.attackseq
	if !data.attackseq then

		local attacktbl = self.AttackSequences

		self:SetStandingAttack(false)

		if self:GetCrawler() then
			attacktbl = self.CrawlAttackSequences
		end

		if self:GetTarget():GetVelocity():LengthSqr() < 15 and self:TargetInRange( self.DamageRange ) and !self:GetCrawler() and !self.IsTurned then
			if self.StandAttackSequences then -- Incase they don't have standing attack anims.
				attacktbl = self.StandAttackSequences
			end
			self:SetStandingAttack(true)
		end

		local target = type(attacktbl) == "table" and attacktbl[math.random(#attacktbl)] or attacktbl

		
		if type(target) == "table" then
			local id, dur = self:LookupSequenceAct(target.seq)
			if target.dmgtimes then
				data.attackseq = {seq = id, dmgtimes = target.dmgtimes }
				useswalkframes = false
			else
				data.attackseq = {seq = id} -- Assume that if the selected sequence isn't using dmgtimes, its probably using notetracks.
				useswalkframes = true
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
		if data.attackseq.dmgtimes then
			for k,v in pairs(data.attackseq.dmgtimes) do
				self:TimedEvent( v, function()
					if self.AttackSounds then self:PlaySound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2) end
					self:EmitSound("nz_moo/zombies/fly/attack/whoosh/zmb_attack_med_0"..math.random(0,2)..".mp3", 75)
					self:DoAttackDamage()
				end)
			end
		end
	end

	self:TimedEvent(data.attackdur, function()
		self:SetAttacking(false)
		self:SetLastAttack(CurTime())
	end)

	if useswalkframes then
		self:PlaySequenceAndMove(data.attackseq.seq, 1, self.FaceEnemy)
	else
		self:PlayAttackAndWait(data.attackseq.seq, 1)
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
				if !self:GetCrawler() then
					self.loco:SetDesiredSpeed( self:GetRunSpeed() )
				end
			end
			return
		end
		if self:IsValidTarget( self:GetTarget() ) then
			self.loco:FaceTowards( self:GetTarget():GetPos() )
		end
		coroutine.yield()
	end
end

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
