AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Killing Floor Scrake FOR REAL ACTUAL"
ENT.Category = "Brainz"
ENT.Author = "Wavy"

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = false
ENT.MooSpecialZombie = false -- They're a Special Zombie, but is still close enough to a normal zombie to be able to do normal zombie things.
ENT.IsMooSpecial = true

ENT.AttackRange = 95

ENT.DamageRange = 95

ENT.AttackDamage = 80

ENT.Models = {
	{Model = "models/wavy/wavy_enemies/scrake/scrake_kf1.mdl", Skin = 0, Bodygroups = {0,0}},
}

ENT.IdleSequence = "nz_scrake_idle"

ENT.BarricadeTearSequences = {
	"nz_scrake_stand_attack",
}

local spawn = {"nz_scrake_stun"}

local JumpSequences = {
	{seq = "nz_scrake_traverse"},
}

local StandAttackSequences = {
	{seq = "nz_scrake_stand_attack"},
}

local AttackSequences = {
	{seq = "nz_scrake_walk_attack1"},
	{seq = "nz_scrake_walk_attack2"},
}

local RunAttackSequences = {
	{seq = "nz_scrake_run_attack1"},
	{seq = "nz_scrake_run_attack2"},
}

local walksounds = {
	Sound("wavy_zombie/chainsaw/chase1.wav"),
	Sound("wavy_zombie/chainsaw/chase2.wav"),
	Sound("wavy_zombie/chainsaw/chase3.wav"),
	Sound("wavy_zombie/chainsaw/chase4.wav"),
	Sound("wavy_zombie/chainsaw/chase5.wav"),
	Sound("wavy_zombie/chainsaw/chase6.wav"),
	Sound("wavy_zombie/chainsaw/chase7.wav"),
	Sound("wavy_zombie/chainsaw/chase8.wav"),
}

local runsounds = {
	Sound("wavy_zombie/chainsaw/attack1.wav"),
	Sound("wavy_zombie/chainsaw/attack2.wav"),
	Sound("wavy_zombie/chainsaw/attack3.wav"),
	Sound("wavy_zombie/chainsaw/attack4.wav"),
}

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawnfast},
			MovementSequence = {
				"nz_scrake_walk",
			},
			SpawnSequence = {spawn},
			AttackSequences = {AttackSequences},
			StandAttackSequences = {StandAttackSequences},

			JumpSequences = {JumpSequences},

			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 71, Sequences = {
		{
			SpawnSequence = {spawnfast},
			MovementSequence = {
				"nz_scrake_run",
			},
			SpawnSequence = {spawn},
			AttackSequences = {RunAttackSequences},
			StandAttackSequences = {StandAttackSequences},

			JumpSequences = {JumpSequences},

			PassiveSounds = {runsounds},
		},
	}}
}

ENT.DeathSounds = {
	"wavy_zombie/chainsaw/death1.wav",
	"wavy_zombie/chainsaw/death2.wav",
	"wavy_zombie/chainsaw/death3.wav",
	"wavy_zombie/chainsaw/death4.wav",
	"wavy_zombie/chainsaw/death5.wav",
	"wavy_zombie/chainsaw/pain2.wav",
	"wavy_zombie/chainsaw/pain4.wav",
	"wavy_zombie/chainsaw/pain5.wav",
}

ENT.AttackSounds = {
	"nz_moo/zombies/vox/mute_00.wav",
}

ENT.CustomWalkFootstepsSounds = {
	"wavy_zombie/fleshpound/tile1.wav",
	"wavy_zombie/fleshpound/tile2.wav",
	"wavy_zombie/fleshpound/tile3.wav",
	"wavy_zombie/fleshpound/tile4.wav",
	"wavy_zombie/fleshpound/tile5.wav",
	"wavy_zombie/fleshpound/tile6.wav",
}

ENT.CustomRunFootstepsSounds = {
	"wavy_zombie/fleshpound/tile1.wav",
	"wavy_zombie/fleshpound/tile2.wav",
	"wavy_zombie/fleshpound/tile3.wav",
	"wavy_zombie/fleshpound/tile4.wav",
	"wavy_zombie/fleshpound/tile5.wav",
	"wavy_zombie/fleshpound/tile6.wav",
}

ENT.CustomAttackImpactSounds = {
	"wavy_zombie/fleshpound/stronghit1.wav",
	"wavy_zombie/fleshpound/stronghit2.wav",
	"wavy_zombie/fleshpound/stronghit3.wav",
	"wavy_zombie/fleshpound/stronghit4.wav",
	"wavy_zombie/fleshpound/stronghit5.wav",
	"wavy_zombie/fleshpound/stronghit6.wav",
}

ENT.BehindSoundDistance = 1 -- When the zombie is within 200 units of a player, play these sounds instead
ENT.BehindSounds = {
	Sound("nz_moo/zombies/vox/mute_00.wav"),
}

function ENT:StatsInitialize()
	if SERVER then
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		if nzRound:InState( ROUND_CREATE ) then
			self:SetHealth(1000)
			self:SetMaxHealth(1000)
		else
			self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
			self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		end
		
		self:SetCollisionBounds(Vector(-19,-19, 0), Vector(19, 19, 80))
		
		self:SetRunSpeed(36)
		
		self.Malding = false
		beginmald = false
	end
end

function ENT:SpecialInit()
	if CLIENT then
	end
end

function ENT:OnSpawn()
	self:EmitSound("wavy_zombie/chainsaw/chainsawidle.wav", 80, math.random(95, 105), 1, 3)
	ParticleEffectAttach("bo2_flinger_leak_smoke3", 4, self, 2)

	local seq = self:SelectSpawnSequence()
	local _, dur = self:LookupSequence(seq)

	self:SolidMaskDuringEvent(MASK_SOLID_BRUSHONLY)
	self:SetInvulnerable(true)
	self:SetSpecialAnimation(true)
	local effectData = EffectData()
	effectData:SetOrigin( self:GetPos() + Vector(0, 0, 50)  )
	effectData:SetMagnitude( 1 )
	effectData:SetEntity(nil)
	util.Effect("panzer_spawn_tp", effectData)
	
	if seq then
		self:PlaySequenceAndWait(seq)
		self:SetSpecialAnimation(false)
		self:SetInvulnerable(false)
		self:CollideWhenPossible()
	end
end

function ENT:PerformDeath(dmginfo)
	self:EmitSound(self.DeathSounds[math.random(#self.DeathSounds)], 500, math.random(95, 105), 1, 2)
	self:StopSound("wavy_zombie/chainsaw/chainsawidle.wav")
	self:StopParticles()
	self:BecomeRagdoll(dmginfo)
end

function ENT:OnRemove()
	self:StopSound("wavy_zombie/chainsaw/chainsawidle.wav")
	self:StopParticles()
end

function ENT:IsValidTarget( ent )
	if !ent then return false end

	-- Turned Zombie Targetting
	if self.IsTurned then return IsValid(ent) and ent:IsValidZombie() and !ent.IsTurned and !ent.IsMooSpecial and ent:Alive() end
	
	return IsValid(ent) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
	-- Won't go for special targets (Monkeys), but still MAX, ALWAYS and so on
end

function ENT:PostAdditionalZombieStuff()
	if SERVER then
	if self:Health() <= (self:GetMaxHealth()/2) and !self.Malding then
		self.Malding = true
		beginmald = true
	end
	if self.Malding and beginmald then
		beginmald = false
		self:EmitSound("wavy_zombie/chainsaw/scream"..math.random(1,4)..".mp3", 500, 100, 1, 2)
		self:SetRunSpeed(71)
		self:SpeedChanged()
	end
end
end

function ENT:HandleAnimEvent(a,b,c,d,e) -- Moo Mark 4/14/23: You don't know how sad I am that I didn't know about this sooner.
	if e == "step_right_small" or e == "step_left_small" then
		if self.CustomWalkFootstepsSounds then
			self:EmitSound(self.CustomWalkFootstepsSounds[math.random(#self.CustomWalkFootstepsSounds)], 70)
		else
			self:EmitSound("CoDZ_Zombie.StepWalk")
		end
	end
	if e == "step_right_large" or e == "step_left_large" then
		if self.CustomRunFootstepsSounds then
			self:EmitSound(self.CustomRunFootstepsSounds[math.random(#self.CustomRunFootstepsSounds)], 70)
		else
			self:EmitSound("CoDZ_Zombie.StepRun")
		end
	end
	if e == "melee" then
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
	if e == "scrake_swing" then
		self:EmitSound("wavy_zombie/chainsaw/chainsawswing"..math.random(1,2)..".wav", 400)
	end
	if e == "scrake_saw" then
		self:EmitSound("wavy_zombie/scrake/chainsawattackloop"..math.random(1,6)..".wav", 400)
	end
end
