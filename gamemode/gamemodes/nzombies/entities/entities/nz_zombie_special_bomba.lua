AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Bomber Zombie"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo"

function ENT:InitDataTables()
	self:NetworkVar("Entity", 5, "BoomDevice")
end

function ENT:Draw()
	self:DrawModel()
	if GetConVar( "nz_zombie_debug" ):GetBool() then
		render.DrawWireframeBox(self:GetPos(), Angle(0,0,0), self:OBBMins(), self:OBBMaxs(), Color(255,0,0), true)
	end
end

if CLIENT then return end

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.IsMooSpecial = true
ENT.RedEyes = false

ENT.AttackRange = 80
ENT.AttackDamage = 35
ENT.CrawlerForce = 1500
ENT.GibForce = 150

ENT.MinSoundPitch = 95
ENT.MaxSoundPitch = 105
ENT.SoundVolume = 125

ENT.TraversalCheckRange = 40

ENT.Models = {
	{Model = "models/moo/_codz_ports/s2/zombie/moo_codz_s2_bmb.mdl", Skin = 0, Bodygroups = {0,0}},
}

ENT.DeathSequences = {
	"nz_s2_run_death_v1",
	"nz_s2_run_death_v2",
	"nz_s2_run_death_v3",
}

ENT.BarricadeTearSequences = {}

local spawnfast = {"nz_s2_bmb_spawn"}

local JumpSequences = {
	{seq = "nz_s2_bmb_trav"},
}

local AttackSequences = {
	{seq = "nz_s2_stand_attack_2h_v1"},
}

local WalkAttackSequences = {
	{seq = "nz_s2_run_attack_v1"},
	{seq = "nz_s2_run_attack_v2"},
}

local walksounds = {
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_growl_lev1_01.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_growl_lev1_02.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_growl_lev1_03.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_growl_lev1_04.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_growl_lev1_05.mp3"),

	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_growl_lev2_01.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_growl_lev2_02.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_growl_lev2_03.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_growl_lev2_04.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_growl_lev2_05.mp3"),

	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_growl_lev3_01.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_growl_lev3_02.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_growl_lev3_03.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_growl_lev3_04.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_growl_lev3_05.mp3"),

	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_growl_lev4_01.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_growl_lev4_02.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_growl_lev4_03.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_growl_lev4_04.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_growl_lev4_05.mp3"),
}

local runsounds = {
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_charge_01.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_charge_02.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_charge_03.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_charge_04.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_charge_05.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_charge_06.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_charge_07.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_charge_08.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_charge_09.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_charge_10.mp3"),
}

ENT.IdleSequence = "nz_s2_bmb_idle_v1"
ENT.IdleNoFriendSequence = "nz_s2_bmb_idle_v2"

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawnfast},
			MovementSequence = {
				"nz_s2_bmb_walk_v1",
			},
			NoBombMovementSequence = {
				"nz_s2_bmb_run_h1",
			},
			TreasureMovementSequence = {
				"nz_s2_bmb_sprint_v1",
			},
			AttackSequences = {WalkAttackSequences},
			StandAttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 36, Sequences = {
		{
			SpawnSequence = {spawnfast},
			MovementSequence = {
				"nz_s2_bmb_run_v1",
				"nz_s2_bmb_run_v2",
			},
			NoBombMovementSequence = {
				"nz_s2_bmb_run_h1",
			},
			TreasureMovementSequence = {
				"nz_s2_bmb_sprint_v1",
			},
			AttackSequences = {WalkAttackSequences},
			StandAttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {runsounds},
		},
	}},
	{Threshold = 71, Sequences = {
		{
			SpawnSequence = {spawnfast},
			MovementSequence = {
				"nz_s2_bmb_sprint_fuse_v1",
			},
			NoBombMovementSequence = {
				"nz_s2_bmb_run_h1",
			},
			TreasureMovementSequence = {
				"nz_s2_bmb_sprint_v1",
			},
			AttackSequences = {WalkAttackSequences},
			StandAttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {runsounds},
		},
	}},
}

ENT.SparkySequences = {
	"nz_s2_bmb_stunned_electrobolt_v1",
	"nz_s2_bmb_stunned_electrobolt_v2",
}

ENT.UnawareSequences = {
	"nz_s2_bmb_pass_idle_v1",
}

ENT.UnawareNoBombSequences = {
	"nz_s2_bmb_pass_idle_v2",
}

ENT.DeathSounds = {
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_death_01.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_death_02.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_death_03.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_death_04.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_death_05.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_death_06.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_death_07.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_death_08.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_death_09.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_death_10.mp3"),
}

ENT.AttackSounds = {
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_melee_hit_01.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_melee_hit_02.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_melee_hit_03.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_melee_hit_04.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_melee_hit_05.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_melee_hit_06.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_melee_hit_07.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_melee_hit_08.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_melee_hit_09.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_melee_hit_10.mp3"),

	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_melee_hit_snarl_01.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_melee_hit_snarl_02.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_melee_hit_snarl_03.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_melee_hit_snarl_04.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_melee_hit_snarl_05.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_melee_hit_snarl_06.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_melee_hit_snarl_07.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_melee_hit_snarl_08.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_melee_hit_snarl_09.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_melee_hit_snarl_10.mp3"),
}

ENT.BonkSounds = {
	Sound("nz_moo/zombies/vox/_bmb/zmb_bomber_hit_head_01.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zmb_bomber_hit_head_02.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zmb_bomber_hit_head_03.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zmb_bomber_hit_head_04.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zmb_bomber_hit_head_05.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zmb_bomber_hit_head_06.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zmb_bomber_hit_head_07.mp3"),
}

ENT.TauntSounds = {
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_taunt_01.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_taunt_02.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_taunt_03.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_taunt_04.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_taunt_05.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_taunt_06.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_taunt_07.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_taunt_08.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_taunt_09.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_taunt_10.mp3"),
}

ENT.PainSounds = {
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_pain_01.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_pain_02.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_pain_03.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_pain_04.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_pain_05.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_pain_06.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_pain_07.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_pain_08.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_pain_09.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_pain_10.mp3"),
}

ENT.SpawnSounds = {
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_spawn_01.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_freezer_spawn_01.mp3"),

	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_snarl_01.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_snarl_02.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_snarl_03.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_snarl_04.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_snarl_05.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_snarl_06.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_snarl_07.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_snarl_08.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_snarl_09.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_snarl_10.mp3"),
}

ENT.CustomWalkFootstepsSounds = {
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_left_02.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_left_03.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_left_04.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_left_05.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_left_06.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_left_07.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_left_08.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_left_09.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_left_10.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_left_11.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_left_12.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_left_13.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_left_14.mp3"),

	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_right_01.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_right_02.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_right_03.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_right_04.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_right_05.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_right_06.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_right_07.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_right_08.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_right_09.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_right_10.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_right_11.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_right_12.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_right_13.mp3"),
}

ENT.CustomRunFootstepsSounds = {
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_left_02.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_left_03.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_left_04.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_left_05.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_left_06.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_left_07.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_left_08.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_left_09.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_left_10.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_left_11.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_left_12.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_left_13.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_left_14.mp3"),

	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_right_01.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_right_02.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_right_03.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_right_04.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_right_05.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_right_06.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_right_07.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_right_08.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_right_09.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_right_10.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_right_11.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_right_12.mp3"),
	Sound("nz_moo/zombies/footsteps/s2/zmb_fs_default_walk_right_13.mp3"),
}

ENT.CustomAttackImpactSounds = {
	Sound("nz_moo/zombies/plr_impact/_t4/melee_hit_00.mp3"),
	Sound("nz_moo/zombies/plr_impact/_t4/melee_hit_01.mp3"),
	Sound("nz_moo/zombies/plr_impact/_t4/melee_hit_02.mp3"),
	Sound("nz_moo/zombies/plr_impact/_t4/melee_hit_03.mp3"),
}

ENT.CustomMeleeWhooshSounds = {
	Sound("nz_moo/zombies/fly/attack/whoosh/_og/swing_00.mp3"),
	Sound("nz_moo/zombies/fly/attack/whoosh/_og/swing_01.mp3"),
	Sound("nz_moo/zombies/fly/attack/whoosh/_og/swing_02.mp3"),
}

ENT.BehindSoundDistance = 200 -- When the zombie is within 200 units of a player, play these sounds instead
ENT.BehindSounds = {
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_sneakattack_busted_01.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_sneakattack_busted_02.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_sneakattack_busted_03.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_sneakattack_busted_04.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_sneakattack_busted_05.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_sneakattack_busted_06.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_sneakattack_busted_07.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_sneakattack_busted_08.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_sneakattack_busted_09.mp3"),
	Sound("nz_moo/zombies/vox/_bmb/zvox_bmb_sneakattack_busted_10.mp3"),
}

function ENT:StatsInitialize()
	if SERVER then

		self:SetHealth( nzRound:GetZombieHealth() or 100 )

		self.Cooldown = CurTime() + 4 

		self.ManIsMad = false
		self.BombCharge = false

		self.KAMIKAZE = false
		self.KABOOM = false
		self.KAMIKAZETIME = CurTime() + 2

		self.LostBomb = false

		--self.BombDrop = CurTime() + 7 -- Simply used for testing which forces the bomber to drop his bomb after a set amount of time.

		if math.random(1000) == 1 then
			self.Treasure = true
			self:SetHealth( nzRound:GetZombieHealth() * 4 or 5000 )
		else
			self.Treasure = false
		end
		self.TreasureDropRate = CurTime() + 3 
		self.TreasureSuicide = 0

		self.Injury = "none"

		self:SetCollisionBounds(Vector(-17,-17, 0), Vector(17, 17, 78))

		if self.Treasure then
			self:SetSkin(1)
			self:SetRunSpeed(71)
			self:SetBodygroup(0,0)
		else
			self:SetSkin(0)
			self:SetRunSpeed(1)
			self:SetBodygroup(0,1)
		end
	end
end

function ENT:SpecialInit()
	if CLIENT then
	end
end

function ENT:OnSpawn()

	local SpawnMatSound = {
		[MAT_DIRT] = "nz_moo/zombies/spawn/dirt/pfx_zm_spawn_dirt_0"..math.random(0,1)..".mp3",
		[MAT_SNOW] = "nz_moo/zombies/spawn/snow/pfx_zm_spawn_snow_0"..math.random(0,1)..".mp3",
		[MAT_SLOSH] = "nz_moo/zombies/spawn/mud/pfx_zm_spawn_mud_00.mp3",
		[0] = "nz_moo/zombies/spawn/pfx_zm_spawn_default_00.mp3",
	}
	SpawnMatSound[MAT_GRASS] = SpawnMatSound[MAT_DIRT]
	SpawnMatSound[MAT_SAND] = SpawnMatSound[MAT_DIRT]

	local norm = (self:GetPos()):GetNormalized()
	local tr = util.QuickTrace(self:GetPos(), norm*10, self)

	if tr.Hit then
		local finalsound = SpawnMatSound[tr.MatType] or SpawnMatSound[0]
		self:EmitSound(finalsound)
	end

	self:SolidMaskDuringEvent(MASK_PLAYERSOLID)
	ParticleEffect("bo3_zombie_spawn",self:GetPos()+Vector(0,0,1),self:GetAngles(),self)

	self:EmitSound("nz/zombies/spawn/zm_spawn_dirt"..math.random(1,2)..".wav",80,math.random(95,105))
	self:PlaySound(self.SpawnSounds[math.random(#self.SpawnSounds)],95, math.random(95, 105), 1, 2)

	if !self.Treasure then
		self:CreateBomb()
	end

	self:SetSpecialAnimation(true)
	local seq = self:SelectSpawnSequence()
	if seq then
		self:PlaySequenceAndMove(seq)
		self:SetSpecialAnimation(false)
		self:CollideWhenPossible()
	end

end

function ENT:PerformDeath(dmginfo)
		
	self.Dying = true

	local damagetype = dmginfo:GetDamageType()

	self:PostDeath(dmginfo)

	self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)

	if self.Treasure then
		local attacker = dmginfo:GetAttacker()
		if attacker:IsPlayer() then
			if math.random(100) == 1 then
				nzPowerUps:SpawnPowerUp(self:GetPos(), "bottle")
			else
				nzPowerUps:SpawnPowerUp(self:GetPos(), "bonuspoints")
			end
		end
	else
		self:SetBodygroup(0,1)
	end

	if IsValid(self:GetBoomDevice()) and !self.Treasure then
		self:DropBomb()
	end

	if damagetype == DMG_MISSILEDEFENSE or damagetype == DMG_ENERGYBEAM then
		self:BecomeRagdoll(dmginfo) -- Only Thundergun and Wavegun Ragdolls constantly.
	end
	if damagetype == DMG_REMOVENORAGDOLL then
		self:Remove(dmginfo)
	end
	if self.DeathRagdollForce == 0 or self:GetSpecialAnimation() then
		self:BecomeRagdoll(dmginfo)
	elseif dmginfo:GetDamageType() == DMG_SHOCK then
		self:DoDeathAnimation(self.SparkySequences[math.random(#self.SparkySequences)])
	else
		self:DoDeathAnimation(self.DeathSequences[math.random(#self.DeathSequences)])
	end
end

function ENT:PostTookDamage(dmginfo)
	if CurTime() > self.Cooldown then
		local hitgroup = util.QuickTrace(dmginfo:GetDamagePosition(), dmginfo:GetDamagePosition()).HitGroup
		local hitforce = dmginfo:GetDamageForce()

		if self:GibForceTest(hitforce) and hitgroup == HITGROUP_STOMACH and !self.ManIsMad and self:Alive() then
			if self.Injury ~= "none" then return end
			if self.Treasure then return end
			if !IsValid(self:GetBoomDevice()) then return end

			self:DropBomb()

			self.Injury = "back"
			self.Cooldown = CurTime() + 3
		end
	end
end

function ENT:OnTargetInAttackRange()
	if self.IsMooBossZombie and !self:GetBlockAttack() or self.IsTurned or self.Target:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and !self:GetBlockAttack() and !self.Treasure and self.LostBomb and !nzPowerUps:IsPowerupActive("timewarp") then
		self:Attack()
	else
		self:TimeOut(0.15)
	end
end

function ENT:AdditionalZombieStuff()
	if self.Treasure then
		self:FleeTarget(6)
		if CurTime() > self.TreasureDropRate then
			local ISMELLPENNIES = ents.Create("drop_treasure")
			ISMELLPENNIES:SetPos(self:WorldSpaceCenter())
			ISMELLPENNIES:SetAngles(self:GetAngles())
			ISMELLPENNIES:Spawn()
			self.TreasureSuicide = self.TreasureSuicide + 1
			self.TreasureDropRate = CurTime() + 3
		end
	end
	if self.Treasure and self.TreasureSuicide >= 12 then
		local heartattack = DamageInfo()
		heartattack:SetAttacker(Entity(0))
		heartattack:SetDamageType(DMG_GENERIC)
		heartattack:SetDamage(self:Health() + 666)
		self:TakeDamageInfo(heartattack)
	end
	if self.BO4IsToxic and self:BO4IsToxic() then
		self:SetRunSpeed(1)
		self:SpeedChanged()
		self:FleeTarget(3)
	end
	if self:GetRunSpeed() < 100 and nzRound:InProgress() and nzRound:GetNumber() >= 4 and !nzRound:IsSpecial() and nzRound:GetZombiesKilled() >= nzRound:GetZombiesMax() - 3 then
		if self:GetCrawler() then return end
		self.LastZombieMomento = true
	end
	if self.LastZombieMomento and !self:GetSpecialAnimation() and !self.ManIsMad then
		--print("Uh oh Mario, I'm about to beat your fucking ass lol.")
		self.LastZombieMomento = false
		self:SetRunSpeed(100)
		self:SpeedChanged()
	end

	if !IsValid(self:GetBoomDevice()) and !self.ManIsMad then
		self.ManIsMad = true

		self:EmitSound(self.PainSounds[math.random(#self.PainSounds)], 100, math.random(85, 105), 1, 2)
		self:DoSpecialAnimation("nz_s2_bmb_bomb_drop")
		self:SetRunSpeed(100)
		self:SpeedChanged()
	end
	if self:TargetInRange(350) and !self.ManIsMad and !self.Treasure then
		if self:GetRunSpeed() < 100 then
			self:SetRunSpeed(100)
			self:SpeedChanged()
		end
	else
		if self.ManIsMad then return end
		if self.Treasure then return end
		if self:GetRunSpeed() > 100 then
			self:SetRunSpeed(1)
			self:SpeedChanged()
		end
	end
	if self:TargetInRange(150) and IsValid(self:GetBoomDevice()) and !self.Treasure and !self:IsAttackBlocked() then
		self.KAMIKAZE = true
	else
		self.KAMIKAZE = false
		self.KAMIKAZETIME = CurTime() + 1
	end
end

function ENT:ResetMovementSequence()
	if self.ManIsMad then
		self:ResetSequence(self.NoBombMovementSequence)
		self.CurrentSeq = self.NoBombMovementSequence
	elseif self.Treasure then
		self:ResetSequence(self.TreasureMovementSequence)
		self.CurrentSeq = self.TreasureMovementSequence
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

function ENT:PerformIdle()
	if (self.BO4IsShocked and self:BO4IsShocked() or self.BO4IsScorped and self:BO4IsScorped() or self.BO4IsSpinning and self:BO4IsSpinning() or self:GetNW2Bool("OnAcid")) and self:GetCrawler() and !self.IsMooSpecial then
		self:ResetSequence(self.SparkySequences[math.random(#self.SparkySequences)])
	elseif self.BO3IsMystified and self:BO3IsMystified() then
		self:ResetSequence(self.UnawareSequences[math.random(#self.UnawareSequences)])
	elseif self.BO3IsMystified and self:BO3IsMystified() and self.ManIsMad then
		self:ResetSequence(self.UnawareSequences[math.random(#self.UnawareNoBombSequences)])
	elseif self.ManIsMad then
		self:ResetSequence(self.IdleNoFriendSequence)
	else
		self:ResetSequence(self.IdleSequence)
	end
end

function ENT:CreateBomb() -- 12/8/23: Bomb is now an entity thats actually attachted to the bomber himself, instead of using a bodygroup.
	if self.Treasure then return end

	local bomb = ents.Create("nz_bomb")
	local chestpos = self:GetBonePosition(self:LookupBone("tag_weapon_chest"))

	bomb:SetPos(chestpos)
	bomb:SetAngles(self:GetAngles())
	bomb:SetParent(self, 5)

	self:SetBoomDevice(bomb)
	bomb:Spawn()
end

function ENT:DropBomb()
	if !IsValid(self) then return end
	if self.LostBomb then return end

	self.LostBomb = true

	self:EmitSound("physics/metal/metal_box_impact_bullet"..math.random(1,3)..".wav",100,math.random(95, 105))

	local bomb = self:GetBoomDevice()
	local bmbphys = bomb:GetPhysicsObject()

	local chestpos = self:GetBonePosition(self:LookupBone("tag_weapon_chest"))

	bomb:SetParent(nil)
	self:SetBoomDevice(nil)

	bomb:StartSelfDestruct()

	if IsValid(bmbphys) then
		bomb:PhysWake()
		bomb:SetPos(chestpos)
		bomb:SetAngles(self:GetAngles())
	end
end

function ENT:OnThink()
	--[[if CurTime() > self.BombDrop then
		if !self.LostBomb then
			self:DropBomb()
		end
	end]]
	if IsValid(self:GetBoomDevice()) and self.KAMIKAZE and CurTime() > self.KAMIKAZETIME and !self.KABOOM then
		self.KABOOM = true

		local bomb = self:GetBoomDevice()
		if IsValid(bomb) then
			local dmg = DamageInfo()
			dmg:SetAttacker(self)
			dmg:SetInflictor(self)
			dmg:SetDamage(1)
			dmg:SetDamageType(DMG_GENERIC)

			bomb:TakeDamageInfo(dmg)
		end
	end
end

function ENT:HandleAnimEvent(a,b,c,d,e)
	if e == "step_right_small" or e == "step_left_small" or e == "step_right_large" or e == "step_left_large" then
		if self.loco:GetVelocity():Length2D() >= 75 then
			if self.CustomRunFootstepsSounds then
				self:EmitSound(self.CustomRunFootstepsSounds[math.random(#self.CustomRunFootstepsSounds)], 65)
			else
				self:EmitSound(self.NormalRunFootstepsSounds[math.random(#self.NormalRunFootstepsSounds)], 65)
			end
		else
			if self.CustomWalkFootstepsSounds then
				self:EmitSound(self.CustomWalkFootstepsSounds[math.random(#self.CustomWalkFootstepsSounds)], 65)
			else
				self:EmitSound(self.NormalWalkFootstepsSounds[math.random(#self.NormalWalkFootstepsSounds)], 65)
			end

		end
	end
	if e == "crawl_hand" then
		if self.CustomCrawlImpactSounds then
			self:EmitSound(self.CustomCrawlImpactSounds[math.random(#self.CustomCrawlImpactSounds)], 70)
		else
			self:EmitSound(self.CrawlImpactSounds[math.random(#self.CrawlImpactSounds)], 70)
		end
	end
	if e == "melee_whoosh" then
		if self.CustomMeleeWhooshSounds then
			self:EmitSound(self.CustomMeleeWhooshSounds[math.random(#self.CustomMeleeWhooshSounds)], 80)
		else
			self:EmitSound(self.MeleeWhooshSounds[math.random(#self.MeleeWhooshSounds)], 80)
		end
	end
	if e == "melee" or e == "melee_heavy" then
		if self:BomberBuff() and self.GasAttack then
			self:EmitSound(self.GasAttack[math.random(#self.GasAttack)], 100, math.random(95, 105), 1, 2)
		else
			if self.AttackSounds then
				self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2)
			end
		end
		if e == "melee_heavy" then
			self.HeavyAttack = true
		end
		self:DoAttackDamage()
	end
	if e == "bmb_bonk" then
		self:EmitSound(self.BonkSounds[math.random(#self.BonkSounds)], 80, math.random(95, 105))
	end
	--[[if e == "bomb_spawn" then
		self:DropBomb()
	end]]
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
end
