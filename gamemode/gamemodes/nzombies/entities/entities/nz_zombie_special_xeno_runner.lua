AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.Type = "nextbot"
ENT.PrintName = "Baboon Xenomorph"
ENT.Category = "Brainz"
ENT.Author = "Wavy"
ENT.Spawnable = true

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = false
ENT.MooSpecialZombie = false -- They're a Special Zombie, but is still close enough to a normal zombie to be able to do normal zombie things.
ENT.IsMooSpecial = true

ENT.Models = {
	{Model = "models/wavy/wavy_enemies/xenomorph/runner/xenomorph_runner.mdl", Skin = 0, Bodygroups = {0,0}},
}

ENT.AttackRange = 75
ENT.DamageRange = 75
ENT.AttackDamage = 45

ENT.JumpAttackDamage = 75
ENT.JumpDamageRange = 110

ENT.IdleSequence = "nz_xeno_runner_idle"

ENT.DeathSequences = {
	"nz_xeno_runner_death",
}

ENT.ElectrocutionSequences = {
	"nz_xeno_runner_death_elec",
}

ENT.BarricadeTearSequences = {
	"nz_xeno_runner_attack_stand2",
}

ENT.LeapAttackSequences = {
	"nz_xeno_runner_attack_leap1",
	"nz_xeno_runner_attack_leap2",
	"nz_xeno_runner_attack_leap3",
}

ENT.TGunSequences = {
	"nz_xeno_runner_knockdown",
}

ENT.LeapBackSequences = {
	"nz_xeno_runner_leapout1",
	"nz_xeno_runner_leapout2",
}

local AttackSequences = {
	{seq = "nz_xeno_runner_attack_stand1"},
	{seq = "nz_xeno_runner_attack_stand2"},
	{seq = "nz_xeno_runner_attack_stand3"},
}

local JumpSequences = {
	{seq = "nz_xeno_runner_traverse1"},
}

local walksounds = {
	Sound("character/alien/vocals/alien_growl_short_01.mp3"),
	Sound("character/alien/vocals/alien_growl_short_02.mp3"),
	Sound("character/alien/vocals/alien_growl_short_03.mp3"),
	Sound("character/alien/vocals/alien_growl_short_04.mp3"),
	Sound("character/alien/vocals/alien_growl_short_05.mp3"),
	Sound("character/alien/vocals/alien_growl_short_06.mp3"),
	Sound("character/alien/vocals/alien_growl_short_07.mp3"),
	
	Sound("character/alien/vocals/alien_hiss_long_01.mp3"),
	Sound("character/alien/vocals/alien_hiss_long_02.mp3"),
	Sound("character/alien/vocals/alien_hiss_long_03.mp3"),
	Sound("character/alien/vocals/alien_hiss_long_04.mp3"),
}

local runsounds = {
	Sound("character/alien/vocals/aln_taunt_01.mp3"),
	Sound("character/alien/vocals/aln_taunt_02.mp3"),
	Sound("character/alien/vocals/aln_taunt_03.mp3"),
	Sound("character/alien/vocals/aln_taunt_04.mp3"),
	Sound("character/alien/vocals/aln_taunt_05.mp3"),
	Sound("character/alien/vocals/aln_taunt_06.mp3"),
}

-- This is a very large and messy looking table... But it gets the job done.
ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			MovementSequence = {
				"nz_xeno_runner_walk",
			},
			AttackSequences = {AttackSequences},

			JumpSequences = {JumpSequences},

			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 36, Sequences = {
		{
			MovementSequence = {
				"nz_xeno_runner_run",
			},
			AttackSequences = {AttackSequences},

			JumpSequences = {JumpSequences},

			PassiveSounds = {runsounds},
		},
	}}
}

ENT.DeathSounds = {
	"character/alien/vocals/alien_death_scream_iconic_elephant.mp3",
	"character/alien/vocals/aln_death_scream_20.mp3",
	"character/alien/vocals/aln_death_scream_21.mp3",
	"character/alien/vocals/aln_death_scream_22.mp3",
	"character/alien/vocals/aln_death_scream_23.mp3",
	"character/alien/vocals/aln_death_scream_24.mp3",
	"character/alien/vocals/aln_death_scream_25.mp3",
	"character/alien/vocals/aln_death_scream_26.mp3",
	"character/alien/vocals/aln_death_scream_27.mp3",
}

ENT.AttackSounds = {
	"character/alien/vocals/aln_pain_small_1.mp3",
	"character/alien/vocals/aln_pain_small_2.mp3",
	"character/alien/vocals/aln_pain_small_3.mp3",
	"character/alien/vocals/aln_pain_small_4.mp3",
	"character/alien/vocals/aln_pain_small_5.mp3",
	"character/alien/vocals/aln_pain_small_6.mp3",
	"character/alien/vocals/aln_pain_small_7.mp3",
	"character/alien/vocals/aln_pain_small_8.mp3",
	"character/alien/vocals/aln_pain_small_9.mp3",
	"character/alien/vocals/aln_pain_small_10.mp3",
}

ENT.CustomWalkFootstepsSounds = {
	"character/alien/footsteps/walk/prd_fs_dirt_1.mp3",
	"character/alien/footsteps/walk/prd_fs_dirt_2.mp3",
	"character/alien/footsteps/walk/prd_fs_dirt_3.mp3",
	"character/alien/footsteps/walk/prd_fs_dirt_4.mp3",
	"character/alien/footsteps/walk/prd_fs_dirt_5.mp3",
	"character/alien/footsteps/walk/prd_fs_dirt_6.mp3",
	"character/alien/footsteps/walk/prd_fs_dirt_7.mp3",
	"character/alien/footsteps/walk/prd_fs_dirt_8.mp3",
	"character/alien/footsteps/walk/prd_fs_dirt_9.mp3",
	"character/alien/footsteps/walk/prd_fs_dirt_10.mp3",
	"character/alien/footsteps/walk/prd_fs_dirt_11.mp3",
	"character/alien/footsteps/walk/prd_fs_dirt_12.mp3",
	"character/alien/footsteps/walk/prd_fs_dirt_13.mp3",
	"character/alien/footsteps/walk/prd_fs_dirt_14.mp3",
	"character/alien/footsteps/walk/prd_fs_dirt_15.mp3",
}

ENT.CustomRunFootstepsSounds = {
	"character/alien/footsteps/walk/prd_fs_dirt_1.mp3",
	"character/alien/footsteps/walk/prd_fs_dirt_2.mp3",
	"character/alien/footsteps/walk/prd_fs_dirt_3.mp3",
	"character/alien/footsteps/walk/prd_fs_dirt_4.mp3",
	"character/alien/footsteps/walk/prd_fs_dirt_5.mp3",
	"character/alien/footsteps/walk/prd_fs_dirt_6.mp3",
	"character/alien/footsteps/walk/prd_fs_dirt_7.mp3",
	"character/alien/footsteps/walk/prd_fs_dirt_8.mp3",
	"character/alien/footsteps/walk/prd_fs_dirt_9.mp3",
	"character/alien/footsteps/walk/prd_fs_dirt_10.mp3",
	"character/alien/footsteps/walk/prd_fs_dirt_11.mp3",
	"character/alien/footsteps/walk/prd_fs_dirt_12.mp3",
	"character/alien/footsteps/walk/prd_fs_dirt_13.mp3",
	"character/alien/footsteps/walk/prd_fs_dirt_14.mp3",
	"character/alien/footsteps/walk/prd_fs_dirt_15.mp3",
}

ENT.CustomAttackImpactSounds = {
	"wavy_zombie/chainsaw/clawhit1.wav",
	"wavy_zombie/chainsaw/clawhit2.wav",
	"wavy_zombie/chainsaw/clawhit3.wav",
	"wavy_zombie/chainsaw/clawhit4.wav",
	"wavy_zombie/chainsaw/clawhit5.wav",
}

ENT.BehindSoundDistance = 1 -- When the zombie is within 200 units of a player, play these sounds instead
ENT.BehindSounds = {
	Sound("nz_moo/zombies/vox/mute_00.wav"),
}

function ENT:StatsInitialize()
	if SERVER then
		if nzRound:GetNumber() == -1 then
			self:SetRunSpeed( math.random(25, 220) )
			self:SetHealth( math.random(100, 1500) )
		else
			local speeds = nzRound:GetZombieCoDSpeeds()
			if speeds then
				self:SetRunSpeed( nzMisc.WeightedRandom(speeds) + math.random(0,35) )
			else
				self:SetRunSpeed( 100 )
			end
			self:SetHealth( nzRound:GetZombieHealth() or 75 )
		end
		
		self:SetCollisionBounds(Vector(-19,-19, 0), Vector(19, 19, 64))
		
		self.JumpCooldown = CurTime() + 3
		self.CanJump = false
		self.Jumping = false
	end
end

function ENT:SpecialInit()
	if CLIENT then
	end
end

function ENT:OnSpawn()
	self:SolidMaskDuringEvent(MASK_SOLID_BRUSHONLY)
	self:CollideWhenPossible()

	local effectData = EffectData()
	effectData:SetOrigin( self:GetPos() + Vector(0, 0, 50)  )
	effectData:SetMagnitude( 1 )
	effectData:SetEntity(nil)
	util.Effect("panzer_spawn_tp", effectData)
	self:CollideWhenPossible()
end

function ENT:PerformDeath(dmginfo)
	local damagetype = dmginfo:GetDamageType()
	if self.DeathRagdollForce == 0 or self:GetSpecialAnimation() or damagetype == DMG_MISSILEDEFENSE or damagetype == DMG_ENERGYBEAM then
		self:BecomeRagdoll(dmginfo)
	elseif damagetype == DMG_SHOCK then
		self:DoDeathAnimation(self.ElectrocutionSequences[math.random(#self.ElectrocutionSequences)])
	else
		self:DoDeathAnimation(self.DeathSequences[math.random(#self.DeathSequences)])
	end
	self:EmitSound(self.DeathSounds[math.random(#self.DeathSounds)], 500, math.random(95, 105), 1, 2)
end

function ENT:PostAdditionalZombieStuff()
	if self:GetSpecialAnimation() then return end
	if CurTime() > self.JumpCooldown and !self.CanJump then
		self.CanJump = true
	end
	if self:TargetInRange(200) and !self:IsAttackBlocked() and self.CanJump then
		if !self:GetTarget():IsPlayer() then return end
		self:JumpAttack()
	end
	if self:TargetInRange(500) and !self.AttackIsBlocked and math.random(100) <= 15 and CurTime() > self.LastSideStep then
		if !self:IsInSight() then return end
		if self:TargetInRange(75) then return end
		if IsValid(self:GetTarget()) and self:GetTarget():IsPlayer() then
			local seq = self.LeapBackSequences[math.random(#self.LeapBackSequences)]
			if self:SequenceHasSpace(seq) then
				self:DoSpecialAnimation(seq, true, true)
			end
			self.LastSideStep = CurTime() + 4
		end
	end
end

function ENT:PostTookDamage(dmginfo)
	local attacker = dmginfo:GetAttacker()
	local inflictor = dmginfo:GetInflictor()
	
	if dmginfo:GetDamage() == 75 and dmginfo:IsDamageType(DMG_MISSILEDEFENSE) and !self:GetSpecialAnimation() then
		self:DoSpecialAnimation(self.TGunSequences[math.random(#self.TGunSequences)])
		if inflictor:GetClass() == "nz_zombie_boss_hulk" then dmginfo:ScaleDamage(0) return end
	end
end

function ENT:JumpAttack()
	local leapseq = self.LeapAttackSequences[math.random(#self.LeapAttackSequences)]
	self:EmitSound("character/alien/vocals/aln_trophy_struggle_0"..math.random(1,2)..".mp3", 500, 100, 1, 2)
	self:TempBehaveThread(function(self)
		self:SetSpecialAnimation(true)
		self.Jumping = true
		self:PlaySequenceAndMove(leapseq, 1, self.FaceEnemy)
		self.Jumping = false
		self.CanJump = false
		self:SetSpecialAnimation(false)
		self.JumpCooldown = CurTime() + 3
	end)
end

function ENT:DoJumpAttackDamage() -- Moo Mark 4/14/23: Made the part that does damage during an attack its own function.
	local target = self:GetTarget()

	local damage = self.JumpAttackDamage
	local dmgrange = self.JumpDamageRange
	local range = self.AttackRange

	if self:GetIsBusy() then
		range = self.AttackRange + 45
		dmgrange = self.JumpDamageRange + 45
	else
		range = self.AttackRange + 25
	end

	if self:WaterBuff() and self:BomberBuff() then
		damage = self.JumpAttackDamage * 3
	elseif self:WaterBuff() then
		damage = self.JumpAttackDamage * 2
	end

	if IsValid(target) and target:Health() and target:Health() > 0 then -- Doesn't matter if its a player... If the zombie is targetting it, they probably wanna attack it.
		if self:TargetInRange( range ) then

			local dmgInfo = DamageInfo()
			dmgInfo:SetAttacker( self )
			dmgInfo:SetDamage( damage )
			dmgInfo:SetDamageType( DMG_SLASH )
			dmgInfo:SetDamageForce( (target:GetPos() - self:GetPos()) * 7 + Vector( 0, 0, 16 ) )

			if self:TargetInRange( dmgrange ) then
				target:TakeDamageInfo(dmgInfo)
				if comedyday or math.random(500) == 1 then
					if self.GoofyahAttackSounds then target:EmitSound(self.GoofyahAttackSounds[math.random(#self.GoofyahAttackSounds)], SNDLVL_TALKING, math.random(95,105)) end
				else
					if self.CustomAttackImpactSounds then
						target:EmitSound(self.CustomAttackImpactSounds[math.random(#self.CustomAttackImpactSounds)], SNDLVL_TALKING, math.random(95,105))
					else
						target:EmitSound(self.AttackImpactSounds[math.random(#self.AttackImpactSounds)], SNDLVL_TALKING, math.random(95,105))
					end
				end
			end
		end
	end
end

function ENT:HandleAnimEvent(a,b,c,d,e) -- Moo Mark 4/14/23: You don't know how sad I am that I didn't know about this sooner.
	if e == "step_right_small" or e == "step_left_small" then
		if self.CustomWalkFootstepsSounds then
			self:EmitSound(self.CustomWalkFootstepsSounds[math.random(#self.CustomWalkFootstepsSounds)], 75)
		else
			self:EmitSound("CoDZ_Zombie.StepWalk")
		end
	end
	if e == "step_right_large" or e == "step_left_large" then
		if self.CustomRunFootstepsSounds then
			self:EmitSound(self.CustomRunFootstepsSounds[math.random(#self.CustomRunFootstepsSounds)], 75)
		else
			self:EmitSound("CoDZ_Zombie.StepRun")
		end
	end
	if e == "melee" then
		if self.AttackSounds then
			self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(95, 105), 1, 2)
		end
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
	if e == "leap_attack" then
		self:DoJumpAttackDamage()
	end
end