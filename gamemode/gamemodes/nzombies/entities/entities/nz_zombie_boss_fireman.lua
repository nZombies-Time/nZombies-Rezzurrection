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

local spawn = {"nz_soldat_arrive_fast"}

ENT.DeathSequences = {
	"nz_soldat_death_1",
	"nz_soldat_death_2"
}

local AttackSequences = {
	{seq = "nz_soldat_melee_a"},
	{seq = "nz_soldat_melee_b"},
}

local RunAttackSequences = {
	{seq = "nz_fireman_run_attack_v1"},
	{seq = "nz_fireman_run_attack_v2"},
}

local JumpSequences = {
	{seq = "nz_soldat_mantle_36"},
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
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_melee_hit_01.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_melee_hit_02.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_melee_hit_03.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_melee_hit_04.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_melee_hit_05.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_melee_hit_06.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_melee_hit_07.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_melee_hit_08.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_melee_hit_09.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_melee_hit_10.mp3"),
}

ENT.DeathSounds = {
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_death_01.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_death_02.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_death_03.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_death_04.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_death_05.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_death_06.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_death_07.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_death_08.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_death_10.mp3"),
}

ENT.IdleSequence = "nz_fireman_idle"
ENT.RunePrisonSequence = "nz_soldat_runeprison_struggle_loop"
ENT.TeslaSequence = "nz_soldat_tesla_loop"

ENT.FatalSequences = {
	"nz_fireman_hit_react_head",
	"nz_fireman_hit_react_left",
	"nz_fireman_hit_react_right",
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

ENT.ZombieLandSequences = {
	"nz_soldat_jump_land",
}

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"nz_fireman_walk",
			},
			FlameMovementSequence = {
				"nz_fireman_walk_ft",
			},
			Climb48 = {ClimbUp48},
			Climb72 = {ClimbUp72},
			Climb96 = {ClimbUp96},
			StandAttackSequences = {AttackSequences},
			AttackSequences = {RunAttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 36, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"nz_fireman_run",
			},
			FlameMovementSequence = {
				"nz_fireman_run",
			},
			Climb48 = {ClimbUp48},
			Climb72 = {ClimbUp72},
			Climb96 = {ClimbUp96},
			StandAttackSequences = {AttackSequences},
			AttackSequences = {RunAttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {runsounds},
		},
	}},
	{Threshold = 71, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"nz_soldat_sprint",
			},
			FlameMovementSequence = {
				"nz_fireman_run",
			},
			Climb48 = {ClimbUp48},
			Climb72 = {ClimbUp72},
			Climb96 = {ClimbUp96},
			StandAttackSequences = {AttackSequences},
			AttackSequences = {RunAttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {runsounds},
		},
	}}
}

ENT.PainSounds = {
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_pain_01.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_pain_02.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_pain_03.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_pain_04.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_pain_05.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_pain_06.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_pain_07.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_pain_08.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_pain_09.mp3"),
	Sound("nz_moo/zombies/vox/_fireman/zvox_fir_pain_10.mp3"),
}

ENT.CustomMeleeWhooshSounds = {
	Sound("nz_moo/zombies/fly/attack/whoosh/_og/swing_00.mp3"),
	Sound("nz_moo/zombies/fly/attack/whoosh/_og/swing_01.mp3"),
	Sound("nz_moo/zombies/fly/attack/whoosh/_og/swing_02.mp3"),
}

ENT.StompSounds = {
	Sound("nz_moo/zombies/vox/_margwa/step/step_00.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/step/step_01.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/step/step_02.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/step/step_03.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/step/step_04.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/step/step_05.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/step/step_06.mp3"),
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
		local count = #player.GetAllPlaying()
		local playerhpmod = 1

		local basehealth = 15500
		local basehealthmax = 97500

		local bosshealth = basehealth

		local healthincrease = 1000
		local coopmultiplier = 0.25

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

		leftthetoasteron = false

		self:SetCollisionBounds(Vector(-14,-14, 0), Vector(14, 14, 72))
		self:SetSurroundingBounds(Vector(-45, -45, 0), Vector(45, 45, 100))
	
		self.UsingFlamethrower = false
		self.Enraged = false
		self.LastStun = CurTime() + 1

		self:SetLastToast(CurTime())
		self:SetMooSpecial(true)
		self:SetRunSpeed( 36 )
	end
end

function ENT:OnSpawn()
	local seq = self:SelectSpawnSequence()
	local _, dur = self:LookupSequence(seq)

	self:SolidMaskDuringEvent(MASK_SOLID_BRUSHONLY)
	self:SetSpecialAnimation(true)

	self:EmitSound("nz_moo/zombies/vox/_fireman/zvox_fir_spawn_01.mp3", 100, math.random(95,105), 1, 2)

	debugoverlay.BoxAngles(self:GetPos() + self:GetUp() * 75, Vector(-5,-5,0), Vector(5,5,750), self:GetAngles(), 3, Color( 255, 255, 255, 10))

	local tr = util.TraceHull({
		start = self:GetPos(),
		endpos = self:GetPos(),
		filter = self,
		mask = MASK_NPCSOLID,
		ignoreworld = false,
		mins = min,
		maxs = Vector(5,5,750),
	})

	if tr.Hit then 
		seq = "nz_soldat_arrive_tomb_short" 
		self.HitRoof = true
	end

	if self.HitRoof then
        self:EmitSound("nz_moo/zombies/gibs/head/_og/zombie_head_0"..math.random(0,2)..".mp3", 65, math.random(95,105))
        self:EmitSound("nz_moo/zombies/gibs/gib_0"..math.random(0,3)..".mp3", 100, math.random(95,105))
        if IsValid(self) then ParticleEffect("brenner_spawn", self:GetPos() + Vector(0,0,0), Angle(0,0,0), self) end
        if IsValid(self) then ParticleEffect("wwii_spawn_embers", self:GetPos() + Vector(0,0,0), Angle(0,0,0), self) end
        if IsValid(self) then ParticleEffect("brenner_bloodsplosion", self:GetPos() + Vector(0,0,-100), Angle(0,0,0), self) end
        if IsValid(self) then ParticleEffect("wwii_spawn_elec", self:GetPos() + Vector(0,0,20), Angle(0,0,0), self) end
    end

	if seq then
		self:PlaySequenceAndWait(seq)
		self:SetSpecialAnimation(false)
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
	if !self:Alive() then return end
	if IsValid(self:GetTarget()) then
		if self:Health() <= self:GetMaxHealth() / 2 and !self.Enraged then
			self.Enraged = true

			self:DoSpecialAnimation("nz_fireman_stand_attack_berserk")

			self:SetRunSpeed(71)
			self:SpeedChanged()
		end

		if !self:GetSpecialAnimation() and !self:GetAttacking() and !self:IsAttackBlocked() and self:TargetInRange(335) and !self:TargetInRange(self.AttackRange + 30) then	
			self:StartToasting()
		else
			self:StopToasting()
		end
		if !self:IsAttackBlocked() and self:TargetInRange(275) and !self.Enraged then
			if self:GetRunSpeed() > 100 then
				self:SetRunSpeed(1)
				self:SpeedChanged()
			end
		else
			if self:GetRunSpeed() < 100 and !self.Enraged then
				self:SetRunSpeed(36)
				self:SpeedChanged()
			end
		end
	end
end

function ENT:PostTookDamage(dmginfo) 
	if !self:Alive() then return end

	local dmgtype = dmginfo:GetDamageType()

	local bullettypes = {
		[DMG_CLUB] = true,
		[DMG_SLASH] = true,
		[DMG_CRUSH] = true,
		[DMG_GENERIC] = true,

		[DMG_BULLET] = true,
	}
	if !bullettypes[dmgtype] then
		dmginfo:ScaleDamage(0.25)
	end

	if !self:GetSpecialAnimation() and math.Rand(1, 100) <= 5 and CurTime() > self.LastStun then
		if self.UsingFlamethrower then
			self:StopToasting()
		end

		local seq = self.FatalSequences[math.random(#self.FatalSequences)]
		if dmginfo:IsDamageType(DMG_MISSILEDEFENSE) then
			seq = "nz_soldat_knockgetup_blend"
		end

		self:EmitSound(self.PainSounds[math.random(#self.PainSounds)], 100, math.random(85, 105), 1, 2)
		self:DoSpecialAnimation(seq)

		self.LastStun = CurTime() + math.Rand(3.5, 10.5)
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
	if self:GetSequenceGroundSpeed(self:GetSequence()) ~= self:GetRunSpeed() or self.UpdateSeq ~= self.CurrentSeq then
		--print("update")
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
			ParticleEffectAttach("asw_mnb_flamethrower",PATTACH_POINT_FOLLOW,self,5)
			self:EmitSound("nz_moo/zombies/vox/_mechz/v2/flame/start.mp3",95, math.random(85, 105))
			self:EmitSound("nz_moo/zombies/vox/_mechz/v2/flame/loop.wav",100, 100)
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
			self:EmitSound("nz_moo/zombies/vox/_mechz/v2/flame/end.mp3",100, math.random(85, 105))
			self:StopSound("nz_moo/zombies/vox/_mechz/v2/flame/loop.wav")
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
		self:StopSound("nz_moo/zombies/vox/_mechz/v2/flame/loop.wav")
	end
	if self:GetAttacking() or (self:GetSpecialAnimation() and !self.BrennerIntro) or self:GetIsBusy() then
		self:StopToasting()
	end
end

function ENT:OnGameOver() 
	if !self.yousuck then
		self.yousuck = true
		self:DoSpecialAnimation("nz_fireman_intro")
	end
end

function ENT:IsValidTarget( ent )
	if not ent then return false end
	
	-- Turned Zombie Targetting
	if self.IsTurned then
		return IsValid(ent) and ent:GetTargetPriority() == TARGET_PRIORITY_MONSTERINTERACT and ent:IsValidZombie() and !ent.IsTurned and !ent.IsMooBossZombie and ent:Alive() 
	end
	
	return IsValid(ent) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
end

function ENT:OnRemove()
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
		self:EmitSound(self.CustomMeleeWhooshSounds[math.random(#self.CustomMeleeWhooshSounds)], 100, math.random(85, 105))
	end
	if e == "mech_stomp_le" then
		self:EmitSound(self.StompSounds[math.random(#self.StompSounds)], 80, math.random(95, 100))
		--self:EmitSound("nz/panzer/servo/mech_servo_0"..math.random(0,1)..".wav",65,math.random(95,100))
		util.ScreenShake(self:GetPos(),100000,500000,0.2,1000)
		ParticleEffectAttach("panzer_land_dust",PATTACH_POINT,self,13)
	end
	if e == "mech_stomp_ri" then
		self:EmitSound(self.StompSounds[math.random(#self.StompSounds)], 80, math.random(95, 100))
		--self:EmitSound("nz/panzer/servo/mech_servo_0"..math.random(0,1)..".wav",65,math.random(95,100))
		util.ScreenShake(self:GetPos(),100000,500000,0.2,1000)
		ParticleEffectAttach("panzer_land_dust",PATTACH_POINT,self,14)
	end
	if e == "panzer_land" then
		self:EmitSound(self.StompSounds[math.random(#self.StompSounds)],80,math.random(95,100))
		util.ScreenShake(self:GetPos(),100000,500000,0.2,500)
		for i=1,2 do
			ParticleEffect("bo3_panzer_landing",self:LocalToWorld(Vector(0,20,0)),Angle(0,0,0),nil)
		end
	end
	if e == "fireman_intro_flame_start" then
		self.BrennerIntro = true
		self:StartToasting()
	end
	if e == "fireman_intro_flame_end" then
		self.BrennerIntro = false
		self:StopToasting()
	end
	if e == "mech_spawn_land" then
		for i = 1, 3 do
			ParticleEffectAttach("panzer_land_dust",PATTACH_POINT,self,1)
		end

		-- Knock normal zombies aside
		for k,v in nzLevel.GetZombieArray() do
			if IsValid(v) and !v:GetSpecialAnimation() and v.IsMooZombie and !v.Non3arcZombie and !v.IsMooSpecial and v ~= self then
				if self:GetRangeTo( v:GetPos() ) < 10^2 then	
					if v.IsMooZombie and !v.IsMooSpecial and !v:GetSpecialAnimation() and self:GetRunSpeed() > 36 then
						if v.PainSequences then
							v:DoSpecialAnimation(v.PainSequences[math.random(#v.PainSequences)], true, true)
						end
					end
				end
			end
		end
	end
end
