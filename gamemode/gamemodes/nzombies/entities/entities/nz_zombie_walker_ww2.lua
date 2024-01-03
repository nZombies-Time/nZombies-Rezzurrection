AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.Type = "nextbot"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo"
ENT.Spawnable = true

function ENT:Draw()
	self:DrawModel()
end

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true
ENT.Non3arcZombie = true

ENT.AttackDamage = 50
ENT.HeavyAttackDamage = 75

ENT.MinSoundPitch = 95
ENT.MaxSoundPitch = 105
ENT.SoundVolume = 95

ENT.Models = {
	{Model = "models/moo/_codz_ports/s2/zombie/moo_codz_s2_infantrya.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model = "models/moo/_codz_ports/s2/zombie/moo_codz_s2_snipera.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawnslow = {"nz_s2_traverse_ground_v1_walk", "nz_iw7_cp_zom_spawn_ground_02", "nz_iw7_cp_zom_spawn_ground_06", "nz_iw7_cp_zom_spawn_ground_walk_01", "nz_iw7_cp_zom_spawn_ground_walk_03", "nz_iw7_cp_zom_spawn_ground_walk_04",}
local spawnrun = {"nz_s2_traverse_ground_v1_run"}
local spawnfast = {"nz_s2_traverse_ground_climbout_fast"}
local spawn = {"nz_s2_traverse_ground_floor_riser_v1", "nz_s2_traverse_ground_floor_riser_v2", "nz_iw7_cp_zom_spawn_ground_run_01", "nz_iw7_cp_zom_spawn_ground_run_02", "nz_iw7_cp_zom_spawn_ground_run_03", "nz_iw7_cp_zom_spawn_ground_run_04"}

ENT.DeathSequences = {
	"nz_s2_dth_f_v1",
	"nz_s2_dth_f_v2",
	"nz_s2_dth_f_v3",
	"nz_s2_dth_f_v4",
	"nz_s2_dth_f_v5",
	"nz_s2_dth_f_v6",
	"nz_s2_dth_f_v7",
	"nz_s2_dth_f_v8",
	"nz_s2_dth_f_v9",
	"nz_s2_dth_f_v10",
	"nz_s2_dth_f_v11",
	"nz_s2_dth_f_v12",
	"nz_s2_dth_f_v13",
}

ENT.CrawlDeathSequences = {
	"nz_s2_crawl_dth_v1",
	"nz_s2_crawl_dth_v2",
	"nz_s2_crawl_dth_v3",
	"nz_s2_crawl_dth_v4",
	"nz_s2_crawl_dth_v5",
	"nz_s2_crawl_dth_v6",
	"nz_s2_crawl_dth_v7",
}

local CrawlAttackSequences = {
	{seq = "nz_s2_crawl_attack_v1"},
	{seq = "nz_s2_crawl_attack_v2"},
	{seq = "nz_s2_crawl_attack_v3"},
	{seq = "nz_s2_crawl_attack_v4"},
	{seq = "nz_s2_crawl_attack_v5"},
	{seq = "nz_s2_crawl_attack_v6"},
	{seq = "nz_s2_crawl_attack_v7"},
	{seq = "nz_s2_crawl_attack_v8"},
}

local CrawlJumpSequences = {
	{seq = "nz_barricade_crawl_1"},
	{seq = "nz_barricade_crawl_2"},
}

ENT.BarricadeTearSequences = {}

local AttackSequences = {
	{seq = "nz_s2_stand_attack_botharms_v1"},
	{seq = "nz_s2_stand_attack_botharms_v2"},
	{seq = "nz_s2_stand_attack_larm_v1"},
	{seq = "nz_s2_stand_attack_larm_v2"},
	{seq = "nz_s2_stand_attack_larm_v3"},
	{seq = "nz_s2_stand_attack_rarm_v1"},
	{seq = "nz_s2_stand_attack_rarm_v2"},
	{seq = "nz_s2_stand_attack_rarm_v3"},
}

local WalkAttackSequences = {
	{seq = "nz_s2_walk_attack_v1"},
	{seq = "nz_s2_walk_attack_v2"},
	{seq = "nz_s2_walk_attack_v3"},
	{seq = "nz_s2_walk_attack_v4"},
	{seq = "nz_s2_walk_attack_v5"},
	{seq = "nz_s2_walk_attack_v6"},
	{seq = "nz_s2_walk_attack_v7"},
	{seq = "nz_s2_walk_attack_v8"},
	{seq = "nz_s2_walk_attack_v9"},
	{seq = "nz_s2_walk_attack_v10"},
	{seq = "nz_s2_walk_attack_v11"},
	{seq = "nz_s2_walk_attack_v12"},
}

local RunAttackSequences = {
	{seq = "nz_s2_run_attack_v1"},
	{seq = "nz_s2_run_attack_v2"},
	{seq = "nz_s2_run_attack_v3"},
	{seq = "nz_s2_run_attack_v4"},
	{seq = "nz_s2_run_attack_v5"},
	{seq = "nz_s2_run_attack_v6"},
	{seq = "nz_s2_run_attack_v7"},
	{seq = "nz_s2_run_attack_v8"},
	{seq = "nz_s2_run_attack_v9"},
	{seq = "nz_s2_run_attack_v10"},
	{seq = "nz_s2_run_attack_v11"},
	{seq = "nz_s2_run_attack_v12"},
	{seq = "nz_s2_run_attack_v13"},
}

local SprintAttackSequences = {
	{seq = "nz_s2_sprint_attack_v1"},
	{seq = "nz_s2_sprint_attack_v2"},
	{seq = "nz_s2_sprint_attack_v3"},
	{seq = "nz_s2_sprint_attack_v4"},
	{seq = "nz_s2_sprint_attack_v5"},
	{seq = "nz_s2_sprint_attack_v6"},
	{seq = "nz_s2_sprint_attack_v7"},
	{seq = "nz_s2_sprint_attack_v8"},
	{seq = "nz_s2_sprint_attack_v9"},
	{seq = "nz_s2_sprint_attack_v10"},
	{seq = "nz_s2_sprint_attack_v11"},
	{seq = "nz_s2_sprint_attack_v12"},
	{seq = "nz_s2_sprint_attack_v13"},
	{seq = "nz_s2_sprint_attack_v14"},
	{seq = "nz_s2_sprint_attack_v15"},
	{seq = "nz_s2_sprint_attack_v16"},
}

local JumpSequences = {
	{seq = "nz_s2_walk_trav_win_v1"},
	{seq = "nz_s2_walk_trav_win_v2"},
	{seq = "nz_s2_walk_trav_win_v3"},
	{seq = "nz_s2_walk_trav_win_v4"},
	{seq = "nz_s2_walk_trav_win_v5"},
	{seq = "nz_s2_walk_trav_win_v6"},
	{seq = "nz_s2_walk_trav_win_v7"},
}
local RunJumpSequences = {
	{seq = "nz_s2_run_trav_win_v1"},
	{seq = "nz_s2_run_trav_win_v2"},
	{seq = "nz_s2_run_trav_win_v3"},
}
local SprintJumpSequences = {
	{seq = "nz_s2_sprint_trav_win_v1"},
	{seq = "nz_s2_sprint_trav_win_v2"},
	{seq = "nz_s2_sprint_trav_win_v3"},
	{seq = "nz_s2_sprint_trav_win_v4"},
}

local SlowClimbUp36 = {
	"nz_traverse_climbup36"
}
local SlowClimbUp48 = {
	"nz_traverse_climbup48"
}
local SlowClimbUp72 = {
	"nz_traverse_climbup72"
}
local SlowClimbUp96 = {
	"nz_traverse_climbup96"
}
local SlowClimbUp128 = {
	"nz_traverse_climbup128"
}
local SlowClimbUp160 = {
	"nz_traverse_climbup160"
}
local FastClimbUp36 = {
	"nz_traverse_fast_climbup36"
}
local FastClimbUp48 = {
	"nz_traverse_fast_climbup48"
}
local FastClimbUp72 = {
	"nz_traverse_fast_climbup72"
}
local FastClimbUp96 = {
	"nz_traverse_fast_climbup96"
}
local ClimbUp200 = {
	"nz_traverse_climbup200"
}

local walksounds = {
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_growl_lev1_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_growl_lev1_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_growl_lev1_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_growl_lev1_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_growl_lev1_05.mp3"),

	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_growl_lev2_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_growl_lev2_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_growl_lev2_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_growl_lev2_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_growl_lev2_05.mp3"),

	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_growl_lev3_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_growl_lev3_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_growl_lev3_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_growl_lev3_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_growl_lev3_05.mp3"),

	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_growl_lev4_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_growl_lev4_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_growl_lev4_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_growl_lev4_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_growl_lev4_05.mp3"),

	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_growl_lev1_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_growl_lev1_05.mp3"),

	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_growl_lev2_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_growl_lev2_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_growl_lev2_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_growl_lev2_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_growl_lev2_05.mp3"),

	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_growl_lev3_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_growl_lev3_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_growl_lev3_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_growl_lev3_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_growl_lev3_05.mp3"),

	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_growl_lev4_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_growl_lev4_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_growl_lev4_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_growl_lev4_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_growl_lev4_05.mp3"),
}

local runsounds = {
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_charge_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_charge_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_charge_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_charge_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_charge_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_charge_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_charge_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_charge_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_charge_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_charge_10.mp3"),

	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_charge_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_charge_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_charge_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_charge_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_charge_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_charge_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_charge_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_charge_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_charge_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_charge_10.mp3"),
}

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawnslow},
			MovementSequence = {
				"nz_s2_walk_v1",
				"nz_s2_walk_v2",
				"nz_s2_walk_v3",
				"nz_s2_walk_v4",
				"nz_s2_walk_v5",
				"nz_s2_walk_v6",
				"nz_s2_walk_v7",
				"nz_s2_walk_v8",
				"nz_s2_walk_v9",
				"nz_s2_walk_v10",
				"nz_s2_walk_v11",
				"nz_s2_walk_v12",
			},
			CrawlMovementSequence = {
				"nz_s2_crawl_v1",
				"nz_s2_crawl_v2",
			},
			BlackholeMovementSequence = {
				"nz_blackhole_1",
				"nz_blackhole_2",
				"nz_blackhole_3",
			},
			FireMovementSequence = {
				"nz_firestaff_walk_v1",
				"nz_firestaff_walk_v2",
				"nz_firestaff_walk_v3",
			},
			AttackSequences = {WalkAttackSequences},
			StandAttackSequences = {AttackSequences},
			CrawlAttackSequences = {CrawlAttackSequences},

			Climb36 = {SlowClimbUp36},
			Climb48 = {SlowClimbUp48},
			Climb72 = {SlowClimbUp72},
			Climb96 = {SlowClimbUp96},
			Climb120 = {SlowClimbUp128},
			Climb160 = {SlowClimbUp160},
			Climb200 = {ClimbUp200},

			JumpSequences = {JumpSequences},
			CrawlJumpSequences = {CrawlJumpSequences},

			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 36, Sequences = {
		{
			SpawnSequence = {spawnrun},
			MovementSequence = {
				"nz_s2_run_v1",
				"nz_s2_run_v2",
				"nz_s2_run_v3",
				"nz_s2_run_v4",
				"nz_s2_run_v5",
				"nz_s2_run_v6",
				"nz_s2_run_v7",
				"nz_s2_run_v8",
				"nz_s2_run_v9",
				"nz_s2_run_v10",
				"nz_s2_run_v11",
				"nz_s2_run_v12",
				"nz_s2_run_v13",
			},
			CrawlMovementSequence = {
				"nz_s2_crawl_v1",
				"nz_s2_crawl_v2",
			},
			BlackholeMovementSequence = {
				"nz_blackhole_1",
				"nz_blackhole_2",
				"nz_blackhole_3",
			},
			FireMovementSequence = {
				"nz_firestaff_walk_v1",
				"nz_firestaff_walk_v2",
				"nz_firestaff_walk_v3",
			},
			AttackSequences = {RunAttackSequences},
			StandAttackSequences = {AttackSequences},
			CrawlAttackSequences = {CrawlAttackSequences},

			Climb36 = {SlowClimbUp36},
			Climb48 = {SlowClimbUp48},
			Climb72 = {SlowClimbUp72},
			Climb96 = {SlowClimbUp96},
			Climb120 = {SlowClimbUp128},
			Climb160 = {SlowClimbUp160},
			Climb200 = {ClimbUp200},

			JumpSequences = {RunJumpSequences},
			CrawlJumpSequences = {CrawlJumpSequences},

			PassiveSounds = {runsounds},
		},
	}},
	{Threshold = 71, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"nz_s2_sprint_v1",
				"nz_s2_sprint_v2",
				"nz_s2_sprint_v3",
				"nz_s2_sprint_v4",
				"nz_s2_sprint_v5",
				"nz_s2_sprint_v6",
				"nz_s2_sprint_v7",
				"nz_s2_sprint_v8",
				"nz_s2_sprint_v9",
				"nz_s2_sprint_v10",
				"nz_s2_sprint_v11",
				"nz_s2_sprint_v12",
				"nz_s2_sprint_v13",
				"nz_s2_sprint_v14",
				"nz_s2_sprint_v15",
				"nz_s2_sprint_v16",
			},
			CrawlMovementSequence = {
				"nz_s2_crawl_v1",
				"nz_s2_crawl_v2",
			},
			BlackholeMovementSequence = {
				"nz_blackhole_1",
				"nz_blackhole_2",
				"nz_blackhole_3",
			},
			FireMovementSequence = {
				"nz_firestaff_walk_v1",
				"nz_firestaff_walk_v2",
				"nz_firestaff_walk_v3",
			},
			AttackSequences = {SprintAttackSequences},
			StandAttackSequences = {AttackSequences},
			CrawlAttackSequences = {CrawlAttackSequences},

			Climb36 = {FastClimbUp36},
			Climb48 = {FastClimbUp48},
			Climb72 = {FastClimbUp72},
			Climb96 = {FastClimbUp96},
			Climb120 = {SlowClimbUp128},
			Climb160 = {SlowClimbUp160},
			Climb200 = {ClimbUp200},

			JumpSequences = {SprintJumpSequences},
			CrawlJumpSequences = {CrawlJumpSequences},

			PassiveSounds = {runsounds},
		},
	}},
	{Threshold = 155, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"nz_s2_sprint_v7",
				"nz_s2_sprint_v8",
				"nz_s2_sprint_v9",
				"nz_s2_sprint_v10",
				"nz_s1_zom_core_run_1",
				--"nz_s1_zom_core_run_2",
				--"nz_s1_zom_core_run_3",
			},
			CrawlMovementSequence = {
				"nz_s2_crawl_v1",
				"nz_s2_crawl_v2",
			},
			BlackholeMovementSequence = {
				"nz_blackhole_1",
				"nz_blackhole_2",
				"nz_blackhole_3",
			},
			FireMovementSequence = {
				"nz_firestaff_walk_v1",
				"nz_firestaff_walk_v2",
				"nz_firestaff_walk_v3",
			},
			AttackSequences = {SprintAttackSequences},
			StandAttackSequences = {AttackSequences},
			CrawlAttackSequences = {CrawlAttackSequences},

			Climb36 = {FastClimbUp36},
			Climb48 = {FastClimbUp48},
			Climb72 = {FastClimbUp72},
			Climb96 = {FastClimbUp96},
			Climb120 = {SlowClimbUp128},
			Climb160 = {SlowClimbUp160},
			Climb200 = {ClimbUp200},

			JumpSequences = {SprintJumpSequences},
			CrawlJumpSequences = {CrawlJumpSequences},

			PassiveSounds = {runsounds},
		},
	}},
}

ENT.IdleSequence = "nz_s2_idle"
ENT.IdleSequenceAU = "nz_s2_idle"
ENT.CrawlIdleSequence = "nz_s2_crawl_idle"

ENT.ExoLeapAttackSequences = {
	"nz_zom_exo_lunge_atk_2h_01",
	"nz_zom_exo_lunge_atk_l_01",
	"nz_zom_exo_lunge_atk_r_01",
}

ENT.ProneLeapAttackSequences = {
	"nz_zom_exo_crawl_lunge",
	"nz_zom_exo_crawl_lunge_2",
	"nz_zom_exo_crawl_lunge_3",
}

ENT.TauntSequences = {
	"nz_s2_taunts_v1",
	"nz_s2_taunts_v2",
	"nz_s2_taunts_v3",
	"nz_s2_taunts_v4",
	"nz_s2_taunts_v5",
	"nz_s2_taunts_v6",
	"nz_s2_taunts_v7",
	"nz_s2_taunts_v8",
	"nz_s2_taunts_v9",
}

ENT.SparkySequences = {
	"nz_s2_stunned_electrobolt_v1",
	"nz_s2_stunned_electrobolt_v2",
	"nz_s2_stunned_electrobolt_v3",
	"nz_s2_stunned_electrobolt_v4",
	"nz_s2_stunned_electrobolt_v5",
}

ENT.ElectrocutionSequences = {
	"nz_s2_stunned_electrobolt_v1",
	"nz_s2_stunned_electrobolt_v2",
	"nz_s2_stunned_electrobolt_v3",
	"nz_s2_stunned_electrobolt_v4",
	"nz_s2_stunned_electrobolt_v5",
}

ENT.UnawareSequences = {
	"nz_s2_pass_idle_v1",
	"nz_s2_pass_idle_v2",
	"nz_s2_pass_idle_v3",
	"nz_s2_pass_idle_v4",
	"nz_s2_pass_idle_v5",
}

ENT.CrawlTeslaDeathSequences = {
	"nz_crawl_tesla_death_v1",
	"nz_crawl_tesla_death_v2",
}

ENT.PainSequences = {
	"nz_pain_head_v1",
	"nz_pain_head_v2",
	"nz_pain_left_v1",
	"nz_pain_left_v2",
	"nz_pain_right_v1",
	"nz_pain_right_v2",

	"nz_s2_pain_head",
	"nz_s2_pain_left",
	"nz_s2_pain_right",
}

ENT.HeadPainSequences = {
	"nz_pain_head_v1",
	"nz_pain_head_v2",

	"nz_s2_pain_head",
}

ENT.LeftPainSequences = {
	"nz_pain_left_v1",
	"nz_pain_left_v2",

	"nz_s2_pain_left",
}

ENT.RightPainSequences = {
	"nz_pain_right_v1",
	"nz_pain_right_v2",

	"nz_s2_pain_right",
}

ENT.DeathSounds = {
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_death_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_death_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_death_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_death_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_death_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_death_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_death_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_death_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_death_10.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_death_11.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_death_12.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_death_13.mp3"),

	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_death_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_death_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_death_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_death_07.mp3"),
}

ENT.NukeDeathSounds = {
	Sound("nz_moo/zombies/vox/nuke_death/soul_00.mp3"),
	Sound("nz_moo/zombies/vox/nuke_death/soul_01.mp3"),
	Sound("nz_moo/zombies/vox/nuke_death/soul_02.mp3"),
	Sound("nz_moo/zombies/vox/nuke_death/soul_03.mp3"),
	Sound("nz_moo/zombies/vox/nuke_death/soul_04.mp3"),
	Sound("nz_moo/zombies/vox/nuke_death/soul_05.mp3"),
	Sound("nz_moo/zombies/vox/nuke_death/soul_06.mp3"),
	Sound("nz_moo/zombies/vox/nuke_death/soul_07.mp3"),
	Sound("nz_moo/zombies/vox/nuke_death/soul_08.mp3"),
	Sound("nz_moo/zombies/vox/nuke_death/soul_09.mp3"),
	Sound("nz_moo/zombies/vox/nuke_death/soul_10.mp3")
}

ENT.ElecSounds = {
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_death_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_death_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_death_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_death_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_death_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_death_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_death_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_death_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_death_10.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_death_11.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_death_12.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_death_13.mp3"),

	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_death_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_death_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_death_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_death_07.mp3"),
}

ENT.AttackSounds = {
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_melee_hit_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_melee_hit_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_melee_hit_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_melee_hit_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_melee_hit_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_melee_hit_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_melee_hit_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_melee_hit_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_melee_hit_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_melee_hit_10.mp3"),

	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_melee_hit_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_melee_hit_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_melee_hit_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_melee_hit_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_melee_hit_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_melee_hit_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_melee_hit_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_melee_hit_09.mp3"),
}

ENT.SpeakSounds = {
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_zde_gen2_ml_taunt_27.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_zde_gen2_ml_taunt_28.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_zde_gen2_ml_taunt_29.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_zde_gen2_ml_taunt_30.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_zde_gen2_ml_taunt_31.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_zde_gen2_ml_taunt_32.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_zde_gen2_ml_taunt_33.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_zde_gen2_ml_taunt_34.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_zde_gen2_ml_taunt_35.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_zde_gen2_ml_taunt_36.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_zde_gen2_ml_taunt_37.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_zde_gen2_ml_taunt_38.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_zde_gen2_ml_taunt_39.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_zde_gen2_ml_taunt_40.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_zde_gen2_ml_taunt_41.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_zde_gen2_ml_taunt_42.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_zde_gen2_ml_taunt_43.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_zde_gen2_ml_taunt_44.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_zde_gen2_ml_taunt_45.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_zde_gen2_ml_taunt_46.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_zde_gen2_ml_taunt_47.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_zde_gen2_ml_taunt_48.mp3"),

	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_10.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_11.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_12.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_13.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_14.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_15.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_16.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_17.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_18.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_19.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_20.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_21.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_22.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_23.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_24.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_25.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_26.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_27.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_28.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_29.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_30.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_31.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_32.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_33.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_34.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_zde_ft_gen_taunt_35.mp3"),
}

ENT.TauntSounds = {
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_10.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_11.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_12.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_13.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_14.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_15.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_16.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_17.mp3"),

	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_taunt_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_taunt_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_taunt_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_taunt_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_taunt_08.mp3"),
}

ENT.CustomSpecialTauntSounds = {
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_10.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_11.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_12.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_13.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_14.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_15.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_16.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_taunt_17.mp3"),

	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_taunt_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_taunt_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_taunt_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_taunt_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_taunt_08.mp3"),
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

ENT.CrawlerSounds = {
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_busted_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_busted_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_busted_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_busted_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_busted_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_busted_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_busted_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_busted_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_busted_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_busted_10.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_busted_11.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_busted_12.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_busted_13.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_busted_14.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_busted_15.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_busted_16.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_busted_17.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_busted_18.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_busted_19.mp3"),

	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_busted_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_busted_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_busted_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_busted_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_busted_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_busted_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_busted_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_busted_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_busted_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_busted_10.mp3"),
}

ENT.PainSounds = {
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_pain_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_pain_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_pain_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_pain_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_pain_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_pain_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_pain_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_pain_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_pain_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_pain_10.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_pain_11.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_pain_12.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_pain_13.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_pain_14.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_pain_15.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_pain_16.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_pain_17.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_pain_18.mp3"),

	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_pain_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_pain_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_pain_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_pain_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_pain_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_pain_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_pain_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_pain_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_pain_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_pain_10.mp3"),
}

ENT.BehindSoundDistance = 200 -- When the zombie is within 200 units of a player, play these sounds instead
ENT.BehindSounds = {
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_spawn_hiss_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_spawn_hiss_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_spawn_hiss_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_spawn_hiss_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_spawn_hiss_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_spawn_hiss_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_spawn_hiss_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_spawn_hiss_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_spawn_hiss_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_spawn_hiss_10.mp3"),

	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_snarl_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_snarl_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_snarl_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_snarl_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_snarl_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_snarl_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_snarl_10.mp3"),
}

function ENT:StatsInitialize()
	if SERVER then
		if nzRound:GetNumber() == -1 then
			self:SetRunSpeed( math.random(25, 220) )
			self:SetHealth( math.random(100, 1500) )
		else
			local speeds = nzRound:GetZombieCoDSpeeds()
			local health = nzRound:GetZombieHealth()
			if speeds then
				self:SetRunSpeed( nzMisc.WeightedRandom(speeds) + math.random(0,35) )
			else
				self:SetRunSpeed( 100 )
			end
			self:SetHealth( nzRound:GetZombieHealth() * 1.5 or 75 ) -- Since these zombies are overall slower, they hit harder and have more health.
		end
	end
end

function ENT:SpecialInit()
	if CLIENT then
	end
end

function ENT:OnSpawn(animation, grav, dirt)
	animation = animation or self:SelectSpawnSequence()
	grav = grav
	dirt = dirt

	if dirt then
		local SpawnMatSound = {
			[MAT_DIRT] = "nz_moo/zombies/spawn/dirt/pfx_zm_spawn_dirt_0"..math.random(0,1)..".mp3",
			[MAT_SNOW] = "nz_moo/zombies/spawn/snow/pfx_zm_spawn_snow_0"..math.random(0,1)..".mp3",
			[MAT_SLOSH] = "nz_moo/zombies/spawn/mud/pfx_zm_spawn_mud_00.mp3",
			[0] = "nz_moo/zombies/spawn/default/pfx_zm_spawn_default_00.mp3",
		}
		SpawnMatSound[MAT_GRASS] = SpawnMatSound[MAT_DIRT]
		SpawnMatSound[MAT_SAND] = SpawnMatSound[MAT_DIRT]

		local norm = (self:GetPos()):GetNormalized()
		local tr = util.QuickTrace(self:GetPos(), norm*10, self)

		if tr.Hit then
			local finalsound = SpawnMatSound[tr.MatType] or SpawnMatSound[0]
			self:EmitSound(finalsound)
		end

		ParticleEffect("bo3_zombie_spawn",self:GetPos()+Vector(0,0,1),self:GetAngles(),self)
		self:EmitSound("nz_moo/zombies/spawn/_generic/dirt/dirt_0"..math.random(0,2)..".mp3",100,math.random(95,105))
	end

	if animation then
		self:SolidMaskDuringEvent(MASK_PLAYERSOLID)
		self:SetSpecialAnimation(true)
		self:SetIsBusy(true)

		self:PlaySequenceAndMove(animation, {gravity = grav})

		self:SetSpecialAnimation(false)
		self:SetIsBusy(false)
		self:CollideWhenPossible()
	end
end

function ENT:ResetMovementSequence()
	if self:GetCrawler() then
		self:ResetSequence(self.CrawlMovementSequence)
		self.CurrentSeq = self.CrawlMovementSequence
	elseif IsValid(self.Target) and self.Target:GetClass() == "nz_bo3_tac_gersch" and !self.IsMooSpecial then
		self:ResetSequence(self.BlackholeMovementSequence)
		self.CurrentSeq = self.BlackholeMovementSequence
	elseif (self.AATIsBlastFurnace and self:AATIsBlastFurnace() or self.BO4IsMagmaIgnited and self:BO4IsMagmaIgnited()) and !self.IsMooSpecial then
		self:ResetSequence(self.FireMovementSequence)
		self.CurrentSeq = self.FireMovementSequence
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

function ENT:PostAdditionalZombieStuff()
	if SERVER then
		if self:TargetInRange(150) and !self:IsAttackBlocked() and self:GetRunSpeed() >= 120 and !self:GetCrawler() and !self:GetSpecialAnimation() and math.random(10) == 1 then
			if self:TargetInRange(50) then return end
			self:ExoLeapAttack()
		end
		if self:TargetInRange(200) and !self:IsAttackBlocked() and self:GetCrawler() and !self:GetSpecialAnimation() and math.random(15) == 1 then
			if self:TargetInRange(75) then return end
			self:ProneLeapAttack()
		end
	end
end

function ENT:ExoLeapAttack()
	local exoleapseq = self.ExoLeapAttackSequences[math.random(#self.ExoLeapAttackSequences)]
	self:TempBehaveThread(function(self)
		self:SetSpecialAnimation(true)
		self.IsExoLeaping = true
		self:PlaySequenceAndMove(exoleapseq, 1, self.FaceEnemy)
		self.IsExoLeaping = false
		self:SetSpecialAnimation(false)
	end)
end

function ENT:ProneLeapAttack()
	local proneleapseq = self.ProneLeapAttackSequences[math.random(#self.ProneLeapAttackSequences)]
	self:TempBehaveThread(function(self)
		self:SetSpecialAnimation(true)
		self.IsProneLeaping = true
		self:PlaySequenceAndMove(proneleapseq, 1, self.FaceEnemy)
		self.IsProneLeaping = false
		self:SetSpecialAnimation(false)
	end)
end


if SERVER then

	function ENT:UpdateModel()
		local models = self.Models
		local choice = models[math.random(#models)]
		util.PrecacheModel( choice.Model )
		self:SetModel(choice.Model)
		if choice.Skin then self:SetSkin(choice.Skin) end

		self:SetBodygroup(0,math.random(0,self:GetBodygroupCount(0))) -- Randomize the possible hat
		self:SetBodygroup(1,math.random(0,self:GetBodygroupCount(1) - 2)) -- Randomize the possible head minus the blank
	end

	function ENT:GibHead()
		if self:GetDecapitated() then return end
		self:SetDecapitated(true)

		if IsValid(self.spritetrail) and IsValid(self.spritetrail2) then
			SafeRemoveEntity(self.spritetrail)
			SafeRemoveEntity(self.spritetrail2)
		end

		self:DeflateBones({
			"j_helmet",
		})
		self:SetBodygroup(1,3)

		self:EmitSound("nz_moo/zombies/gibs/head/head_explosion_0"..math.random(4)..".mp3",100, math.random(95,105))
		self:EmitSound("nz_moo/zombies/gibs/death_nohead/death_nohead_0"..math.random(2)..".mp3",85, math.random(95,105))
		ParticleEffectAttach("ins_blood_impact_headshot", 4, self, 10)
	end
end