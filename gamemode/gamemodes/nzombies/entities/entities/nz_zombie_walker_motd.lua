AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.Type = "nextbot"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo"
ENT.Spawnable = true

if CLIENT then 
	ENT.EyeColorTable = {
		[0] = Material("models/moo/codz/t8_zombies/common/mtl_c_t8_zmb_eyes_mob.vmt"),
		[1] = Material("models/moo/codz/t8_zombies/mob/xmaterial_47fccf5cc16e3e2.vmt"),
	}
	return 
end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true

ENT.Models = {
	{Model = "models/moo/_codz_ports/t8/escape/moo_codz_t8_mob_officer.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model = "models/moo/_codz_ports/t8/escape/moo_codz_t8_mob_prisoner.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawnslow = {"nz_spawn_ground_v1", "nz_spawn_ground_ad_v2", "nz_spawn_ground_v2", "nz_spawn_ground_v2_altb"}
local spawnrun = {"nz_spawn_ground_v1_run"}
local spawnfast = {"nz_spawn_ground_climbout_fast"}
local spawnsuperfast = {"nz_ent_ground_01", "nz_ent_ground_02"}

ENT.DeathSequences = {
	"nz_death_1",
	"nz_death_2",
	"nz_death_3",
	"nz_death_f_1",
	"nz_death_f_2",
	"nz_death_f_3",
	"nz_death_f_4",
	"nz_death_f_5",
	"nz_death_f_6",
	"nz_death_f_7",
	"nz_death_f_8",
	"nz_death_f_9",
	"nz_death_f_10",
	"nz_death_f_11",
	"nz_death_f_12",
	"nz_death_f_13",
	"nz_death_fallback",
	"nz_l4d_death_running_11a",
	"nz_l4d_death_running_11g",
	"nz_l4d_death_02a",
	"nz_l4d_death_11_02d",
}

ENT.ElectrocutionSequences = {
	"nz_death_elec_1",
	"nz_death_elec_2",
	"nz_death_elec_3",
	"nz_death_elec_4",
}

ENT.BarricadeTearSequences = {
	"nz_legacy_door_tear_high",
	"nz_legacy_door_tear_low",
	"nz_legacy_door_tear_left",
	"nz_legacy_door_tear_right",
}

ENT.CrawlDeathSequences = {
	"nz_crawl_death_v1",
	"nz_crawl_death_v2",
}

local CrawlAttackSequences = {
	{seq = "nz_crawl_attack_v1", dmgtimes = {0.75, 1.65}},
	{seq = "nz_crawl_attack_v2", dmgtimes = {0.65}},
}

local CrawlJumpSequences = {
	{seq = "nz_barricade_crawl_1"},
	{seq = "nz_barricade_crawl_2"},
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
	"nz_traverse_climbup128",
	"nz_l4d_traverse_climbup132_01",
	"nz_l4d_traverse_climbup132_02",
	"nz_l4d_traverse_climbup132_03",
}
local SlowClimbUp160 = {
	"nz_traverse_climbup160",
	"nz_l4d_traverse_climbup156_01",
	"nz_l4d_traverse_climbup156_02",
	"nz_l4d_traverse_climbup156_03",
}
local FastClimbUp36 = {
	"nz_traverse_fast_climbup36",
	"nz_l4d_traverse_climbup36_01",
	"nz_l4d_traverse_climbup36_02",
	"nz_l4d_traverse_climbup36_03",
}
local FastClimbUp48 = {
	"nz_traverse_fast_climbup48",
	"nz_l4d_traverse_climbup48_01",
	"nz_l4d_traverse_climbup48_02",
	"nz_l4d_traverse_climbup48_03",
	"nz_l4d_traverse_climbup48_04",
}
local FastClimbUp72 = {
	"nz_traverse_fast_climbup72",
	"nz_l4d_traverse_climbup72_01",
	"nz_l4d_traverse_climbup72_02",
	"nz_l4d_traverse_climbup72_03",
}
local FastClimbUp96 = {
	"nz_traverse_fast_climbup96",
	"nz_l4d_traverse_climbup96_01",
	"nz_l4d_traverse_climbup96_02",
	"nz_l4d_traverse_climbup96_03",
}
local ClimbUp200 = {
	"nz_traverse_climbup200"
}

local AttackSequences = {
	{seq = "nz_attack_stand_ad_1"},
	{seq = "nz_attack_stand_au_1"},
	{seq = "nz_legacy_attack_v3"},
	{seq = "nz_legacy_attack_v6"},
	{seq = "nz_legacy_attack_v4"},
	{seq = "nz_legacy_attack_v11"},
	{seq = "nz_legacy_attack_v12"},
	{seq = "nz_legacy_attack_superwindmill"},
	{seq = "nz_fwd_ad_attack_v1"},
	{seq = "nz_fwd_ad_attack_v2"},
	{seq = "nz_t8_attack_stand_larm_1"},
	{seq = "nz_t8_attack_stand_larm_2"},
	{seq = "nz_t8_attack_stand_larm_3"},
	{seq = "nz_t8_attack_stand_rarm_1"},
	{seq = "nz_t8_attack_stand_rarm_2"},
	{seq = "nz_t8_attack_stand_rarm_3"},
}

local WalkAttackSequences = {
	{seq = "nz_walk_ad_attack_v1"}, -- Quick single swipe
	{seq = "nz_walk_ad_attack_v2"}, -- Slowish double swipe
	{seq = "nz_walk_ad_attack_v3"}, -- Slowish single swipe
	{seq = "nz_walk_ad_attack_v4"}, -- Quickish double swipe
	{seq = "nz_t8_attack_walk_larm_1"},
	{seq = "nz_t8_attack_walk_rarm_3"},
	{seq = "nz_t8_attack_walk_larm_2"},
	{seq = "nz_t8_attack_walk_rarm_6"},
}

local RunAttackSequences = {
	{seq = "nz_t8_attack_run_larm_1"},
	{seq = "nz_t8_attack_run_larm_2"},
	{seq = "nz_t8_attack_run_larm_3"},
	{seq = "nz_t8_attack_run_larm_4"},
	{seq = "nz_t8_attack_run_rarm_1"},
	{seq = "nz_t8_attack_run_rarm_2"},
	{seq = "nz_t8_attack_run_rarm_3"},
	{seq = "nz_t8_attack_run_rarm_4"},
}

local StinkyRunAttackSequences = {
	{seq = "nz_run_ad_attack_v1"},
	{seq = "nz_run_ad_attack_v2"},
	{seq = "nz_run_ad_attack_v3"},
	{seq = "nz_run_ad_attack_v4"},

	-- The REAL Bad Attack Anims
	{seq = "nz_legacy_run_attack_v1"},
	{seq = "nz_legacy_run_attack_v2"},
	{seq = "nz_legacy_run_attack_v3"},
	{seq = "nz_legacy_run_attack_v4"},
}

local SprintAttackSequences = {
	{seq = "nz_t8_attack_sprint_larm_1"},
	{seq = "nz_t8_attack_sprint_larm_2"},
	{seq = "nz_t8_attack_sprint_larm_3"},
	{seq = "nz_t8_attack_sprint_larm_4"},
	{seq = "nz_t8_attack_sprint_rarm_1"},
	{seq = "nz_t8_attack_sprint_rarm_2"},
	{seq = "nz_t8_attack_sprint_rarm_3"},
	{seq = "nz_t8_attack_sprint_rarm_4"},
}

local SuperSprintAttackSequences = {
	{seq = "nz_t8_attack_supersprint_larm_1"},
	{seq = "nz_t8_attack_supersprint_larm_2"},
	{seq = "nz_t8_attack_supersprint_rarm_1"},
	{seq = "nz_t8_attack_supersprint_rarm_2"},
}

local JumpSequences = {
	{seq = "nz_barricade_trav_walk_1"},
	{seq = "nz_barricade_trav_walk_2"},
	{seq = "nz_barricade_trav_walk_3"},
}
local RunJumpSequences = {
	{seq = "nz_barricade_run_1"},
	{seq = "nz_l4d_mantle_over_36"},
}

local SprintJumpSequences = {
	{seq = "nz_barricade_sprint_1"},
	{seq = "nz_barricade_sprint_2"},
}
local walksounds = {
	Sound("nz_moo/zombies/vox/_zhd/amb/series_1/amb_00.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_1/amb_01.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_1/amb_02.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_1/amb_03.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_1/amb_04.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_1/amb_05.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_1/amb_06.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_1/amb_07.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_1/amb_08.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_1/amb_09.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_1/amb_10.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_1/amb_11.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_1/amb_12.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_1/amb_13.mp3"),

	Sound("nz_moo/zombies/vox/_zhd/amb/series_2/amb_00.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_2/amb_01.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_2/amb_02.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_2/amb_03.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_2/amb_04.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_2/amb_05.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_2/amb_06.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_2/amb_07.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_2/amb_08.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_2/amb_09.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_2/amb_10.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_2/amb_11.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_2/amb_12.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_2/amb_13.mp3"),

	Sound("nz_moo/zombies/vox/_zhd/amb/series_3/amb_00.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_3/amb_01.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_3/amb_02.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_3/amb_03.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_3/amb_04.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_3/amb_05.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_3/amb_06.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_3/amb_07.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_3/amb_08.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/amb/series_3/amb_09.mp3"),
}

local runsounds = {
	Sound("nz_moo/zombies/vox/_zhd/sprint/series_1/sprint_00.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/sprint/series_1/sprint_01.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/sprint/series_1/sprint_02.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/sprint/series_1/sprint_03.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/sprint/series_1/sprint_04.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/sprint/series_1/sprint_05.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/sprint/series_1/sprint_06.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/sprint/series_1/sprint_07.mp3"),

	Sound("nz_moo/zombies/vox/_zhd/sprint/series_2/sprint_00.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/sprint/series_2/sprint_01.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/sprint/series_2/sprint_02.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/sprint/series_2/sprint_03.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/sprint/series_2/sprint_04.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/sprint/series_2/sprint_05.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/sprint/series_2/sprint_06.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/sprint/series_2/sprint_07.mp3"),

	Sound("nz_moo/zombies/vox/_zhd/sprint/series_3/sprint_00.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/sprint/series_3/sprint_01.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/sprint/series_3/sprint_02.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/sprint/series_3/sprint_03.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/sprint/series_3/sprint_04.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/sprint/series_3/sprint_05.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/sprint/series_3/sprint_06.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/sprint/series_3/sprint_07.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/sprint/series_3/sprint_08.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/sprint/series_3/sprint_09.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/sprint/series_3/sprint_10.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/sprint/series_3/sprint_11.mp3"),
}

-- This is a very large and messy looking table... But it gets the job done.
ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawnslow},
			MovementSequence = {
				"nz_walk_ad1",
				"nz_walk_ad2",
				"nz_walk_ad3",
				"nz_walk_ad4",
				"nz_walk_ad7",
				"nz_walk_ad5",
				"nz_walk_ad6",
				"nz_walk_ad19",
				"nz_walk_ad20",
				"nz_walk_ad21",
				"nz_walk_ad22",
				"nz_walk_ad23",
				"nz_walk_ad24",
				"nz_walk_ad25",
				--"nz_walk_au_goose",
				--"nz_legacy_walk_dazed",
				--"nz_legacy_jap_walk_v1",
				--"nz_legacy_jap_walk_v2",
				--"nz_legacy_jap_walk_v3",
				--"nz_legacy_jap_walk_v4",
			},
			LowgMovementSequence = {
				"nz_walk_lowg_v1",
				"nz_walk_lowg_v2",
				"nz_walk_lowg_v3",
				"nz_walk_lowg_v4",
			},
			BlackholeMovementSequence = {
				"nz_blackhole_1",
				"nz_blackhole_2",
				"nz_blackhole_3",
			},
			CrawlMovementSequence = {
				"nz_crawl_slow_v1",
				"nz_crawl_slow_v2",
				"nz_crawl_slow_v3",
				"nz_crawl_v1",
				"nz_crawl_v2",
				"nz_crawl_v5",
				"nz_crawl_sprint_v1",
				"nz_crawl_on_hands",
				"nz_crawl_on_hands_c",
			},
			FireMovementSequence = {
				"nz_firestaff_walk_v1",
				"nz_firestaff_walk_v2",
				"nz_firestaff_walk_v3",
			},
			TurnedMovementSequence = {
				--"nz_pb_zombie_sprint_v6",
				--"nz_pb_zombie_sprint_v7",
				"nz_pb_zombie_sprint_v8", -- The Tranzit Sprinter one.
				--"nz_pb_zombie_sprint_v9",
				"nz_l4d_run_03",
				"nz_l4d_run_04",
				
				"nz_t9_base_player_sprint_v01",
				"nz_t9_base_player_sprint_v02",
				"nz_t9_base_player_sprint_v03",
				"nz_t9_base_player_sprint_v04",
				"nz_t9_base_player_sprint_v05",
				"nz_t9_base_player_sprint_v06",
				"nz_t9_base_player_sprint_v07",
				"nz_t9_base_player_sprint_v08",
			},
			AttackSequences = {WalkAttackSequences},
			StandAttackSequences = {AttackSequences},
			CrawlAttackSequences = {CrawlAttackSequences},

			JumpSequences = {JumpSequences},
			CrawlJumpSequences = {CrawlJumpSequences},

			Climb36 = {SlowClimbUp36},
			Climb48 = {SlowClimbUp48},
			Climb72 = {SlowClimbUp72},
			Climb96 = {SlowClimbUp96},
			Climb120 = {SlowClimbUp128},
			Climb160 = {SlowClimbUp160},
			Climb200 = {ClimbUp200},

			PassiveSounds = {walksounds},
		},
		{
			SpawnSequence = {spawnslow},
			MovementSequence = {
				"nz_walk_au1",
				"nz_walk_au2",
				"nz_walk_au3",
				"nz_walk_au4",
				"nz_walk_au5",
				"nz_walk_au6",
				"nz_walk_au7",
				"nz_walk_au8",
				"nz_walk_au10",
				"nz_walk_au11",
				"nz_walk_au12",
				"nz_walk_au13",
				"nz_walk_au15",
				"nz_walk_au20",
				"nz_walk_au21",
				"nz_walk_au23",
				--"nz_walk_au_goose", -- This is the goosestep walk aka marching anim that german soldier zombies use.
				--"nz_legacy_walk_dazed",
				--"nz_legacy_jap_walk_v1",
				--"nz_legacy_jap_walk_v2",
				--"nz_legacy_jap_walk_v3",
				--"nz_legacy_jap_walk_v4",
			},
			LowgMovementSequence = {
				"nz_walk_lowg_v1",
				"nz_walk_lowg_v2",
				"nz_walk_lowg_v3",
				"nz_walk_lowg_v4",
			},
			BlackholeMovementSequence = {
				"nz_blackhole_1",
				"nz_blackhole_2",
				"nz_blackhole_3",
			},
			CrawlMovementSequence = {
				"nz_crawl_slow_v1",
				"nz_crawl_slow_v2",
				"nz_crawl_slow_v3",
				"nz_crawl_v1",
				"nz_crawl_v2",
				"nz_crawl_v5",
				"nz_crawl_sprint_v1",
				"nz_crawl_on_hands",
				"nz_crawl_on_hands_c",
			},
			FireMovementSequence = {
				"nz_firestaff_walk_v1",
				"nz_firestaff_walk_v2",
				"nz_firestaff_walk_v3",
			},
			TurnedMovementSequence = {
				--"nz_pb_zombie_sprint_v6",
				--"nz_pb_zombie_sprint_v7",
				"nz_pb_zombie_sprint_v8", -- The Tranzit Sprinter one.
				--"nz_pb_zombie_sprint_v9",
				"nz_l4d_run_03",
				"nz_l4d_run_04",
				
				"nz_t9_base_player_sprint_v01",
				"nz_t9_base_player_sprint_v02",
				"nz_t9_base_player_sprint_v03",
				"nz_t9_base_player_sprint_v04",
				"nz_t9_base_player_sprint_v05",
				"nz_t9_base_player_sprint_v06",
				"nz_t9_base_player_sprint_v07",
				"nz_t9_base_player_sprint_v08",
			},
			AttackSequences = {WalkAttackSequences},
			StandAttackSequences = {AttackSequences},
			CrawlAttackSequences = {CrawlAttackSequences},

			JumpSequences = {JumpSequences},
			CrawlJumpSequences = {CrawlJumpSequences},

			Climb36 = {SlowClimbUp36},
			Climb48 = {SlowClimbUp48},
			Climb72 = {SlowClimbUp72},
			Climb96 = {SlowClimbUp96},
			Climb120 = {SlowClimbUp128},
			Climb160 = {SlowClimbUp160},
			Climb200 = {ClimbUp200},

			PassiveSounds = {walksounds},
		}
	}},
	{Threshold = 36, Sequences = {
		{
			SpawnSequence = {spawnrun},
			MovementSequence = {
				"nz_walk_fast_ad1",
				"nz_walk_fast_ad2",
				"nz_walk_fast_ad3",
				--"nz_legacy_run_v1",
				--"nz_legacy_run_v3",
				--"nz_legacy_jap_run_v1",
				--"nz_legacy_jap_run_v2",
				--"nz_legacy_jap_run_v4",
				--"nz_legacy_jap_run_v5",
				--"nz_legacy_jap_run_v6",
				"nz_run_ad1",
				"nz_run_ad2",
				"nz_run_ad3",
				"nz_run_ad4",
				"nz_run_ad7",
				"nz_run_ad8",
				"nz_run_ad11",
				"nz_run_ad12",
				"nz_run_ad14",
				"nz_run_ad20",
				"nz_run_ad21",
				"nz_run_ad22",
				"nz_run_ad23",
				"nz_run_ad24",
			},
			LowgMovementSequence = {
				"nz_run_lowg_v1",
				"nz_run_lowg_v2",
				"nz_run_lowg_v3",
				"nz_run_lowg_v4",
			},
			BlackholeMovementSequence = {
				"nz_blackhole_1",
				"nz_blackhole_2",
				"nz_blackhole_3",
			},
			CrawlMovementSequence = {
				"nz_crawl_slow_v1",
				"nz_crawl_slow_v2",
				"nz_crawl_slow_v3",
				"nz_crawl_v1",
				"nz_crawl_v2",
				"nz_crawl_v5",
				"nz_crawl_sprint_v1",
				"nz_crawl_on_hands",
				"nz_crawl_on_hands_c",
			},
			FireMovementSequence = {
				"nz_firestaff_walk_v1",
				"nz_firestaff_walk_v2",
				"nz_firestaff_walk_v3",
			},
			TurnedMovementSequence = {
				--"nz_pb_zombie_sprint_v6",
				--"nz_pb_zombie_sprint_v7",
				"nz_pb_zombie_sprint_v8", -- The Tranzit Sprinter one.
				--"nz_pb_zombie_sprint_v9",
				"nz_l4d_run_03",
				"nz_l4d_run_04",
				
				"nz_t9_base_player_sprint_v01",
				"nz_t9_base_player_sprint_v02",
				"nz_t9_base_player_sprint_v03",
				"nz_t9_base_player_sprint_v04",
				"nz_t9_base_player_sprint_v05",
				"nz_t9_base_player_sprint_v06",
				"nz_t9_base_player_sprint_v07",
				"nz_t9_base_player_sprint_v08",
			},
			AttackSequences = {RunAttackSequences},
			StandAttackSequences = {AttackSequences},
			Bo3AttackSequences = {StinkyRunAttackSequences},
			CrawlAttackSequences = {CrawlAttackSequences},

			JumpSequences = {RunJumpSequences},
			CrawlJumpSequences = {CrawlJumpSequences},

			Climb36 = {SlowClimbUp36},
			Climb48 = {SlowClimbUp48},
			Climb72 = {SlowClimbUp72},
			Climb96 = {SlowClimbUp96},
			Climb120 = {SlowClimbUp128},
			Climb160 = {SlowClimbUp160},
			Climb200 = {ClimbUp200},

			PassiveSounds = {runsounds},
		},
		{
			SpawnSequence = {spawnrun},
			MovementSequence = {
				"nz_walk_fast_au1",
				"nz_walk_fast_au2",
				"nz_walk_fast_au3",
				--"nz_legacy_run_v1",
				--"nz_legacy_run_v3",
				--"nz_legacy_jap_run_v1",
				--"nz_legacy_jap_run_v2",
				--"nz_legacy_jap_run_v4",
				--"nz_legacy_jap_run_v5",
				--"nz_legacy_jap_run_v6",
				"nz_run_au1",
				"nz_run_au2",
				"nz_run_au3",
				"nz_run_au4",
				"nz_run_au5",
				"nz_run_au9",
				"nz_run_au11",
				"nz_run_au13",
				"nz_run_au20",
				"nz_run_au21",
				"nz_run_au22",
				"nz_run_au23",
				"nz_run_au24",
			},
			LowgMovementSequence = {
				"nz_run_lowg_v1",
				"nz_run_lowg_v2",
				"nz_run_lowg_v3",
				"nz_run_lowg_v4",
			},
			BlackholeMovementSequence = {
				"nz_blackhole_1",
				"nz_blackhole_2",
				"nz_blackhole_3",
			},
			CrawlMovementSequence = {
				"nz_crawl_slow_v1",
				"nz_crawl_slow_v2",
				"nz_crawl_slow_v3",
				"nz_crawl_v1",
				"nz_crawl_v2",
				"nz_crawl_v5",
				"nz_crawl_sprint_v1",
				"nz_crawl_on_hands",
				"nz_crawl_on_hands_c",
			},
			FireMovementSequence = {
				"nz_firestaff_walk_v1",
				"nz_firestaff_walk_v2",
				"nz_firestaff_walk_v3",
			},
			TurnedMovementSequence = {
				--"nz_pb_zombie_sprint_v6",
				--"nz_pb_zombie_sprint_v7",
				"nz_pb_zombie_sprint_v8", -- The Tranzit Sprinter one.
				--"nz_pb_zombie_sprint_v9",
				"nz_l4d_run_03",
				"nz_l4d_run_04",
				
				"nz_t9_base_player_sprint_v01",
				"nz_t9_base_player_sprint_v02",
				"nz_t9_base_player_sprint_v03",
				"nz_t9_base_player_sprint_v04",
				"nz_t9_base_player_sprint_v05",
				"nz_t9_base_player_sprint_v06",
				"nz_t9_base_player_sprint_v07",
				"nz_t9_base_player_sprint_v08",
			},
			AttackSequences = {RunAttackSequences},
			StandAttackSequences = {AttackSequences},
			Bo3AttackSequences = {StinkyRunAttackSequences},
			CrawlAttackSequences = {CrawlAttackSequences},

			JumpSequences = {RunJumpSequences},
			CrawlJumpSequences = {CrawlJumpSequences},

			Climb36 = {SlowClimbUp36},
			Climb48 = {SlowClimbUp48},
			Climb72 = {SlowClimbUp72},
			Climb96 = {SlowClimbUp96},
			Climb120 = {SlowClimbUp128},
			Climb160 = {SlowClimbUp160},
			Climb200 = {ClimbUp200},

			PassiveSounds = {runsounds},
		}
	}},
	{Threshold = 71, Sequences = {
		{
			SpawnSequence = {spawnfast},
			MovementSequence = {
				--"nz_legacy_sprint_v5",
				--"nz_legacy_jap_run_v3",
				"nz_sprint_ad1",
				"nz_sprint_ad2",
				"nz_sprint_ad3",
				"nz_sprint_ad4",
				"nz_sprint_ad5",
				"nz_sprint_ad21",
				"nz_sprint_ad22",
				"nz_sprint_ad23",
				"nz_sprint_ad24",
				"nz_fast_sprint_v1",
				"nz_fast_sprint_v2",
			},
			LowgMovementSequence = {
				"nz_sprint_lowg_v1",
				"nz_sprint_lowg_v2",
				"nz_sprint_lowg_v3",
				"nz_sprint_lowg_v4",
			},
			BlackholeMovementSequence = {
				"nz_blackhole_1",
				"nz_blackhole_2",
				"nz_blackhole_3",
			},
			CrawlMovementSequence = {
				"nz_crawl_slow_v1",
				"nz_crawl_slow_v2",
				"nz_crawl_slow_v3",
				"nz_crawl_v1",
				"nz_crawl_v2",
				"nz_crawl_v5",
				"nz_crawl_sprint_v1",
				"nz_crawl_on_hands",
				"nz_crawl_on_hands_c",
			},
			FireMovementSequence = {
				"nz_firestaff_walk_v1",
				"nz_firestaff_walk_v2",
				"nz_firestaff_walk_v3",
			},
			TurnedMovementSequence = {
				--"nz_pb_zombie_sprint_v6",
				--"nz_pb_zombie_sprint_v7",
				"nz_pb_zombie_sprint_v8", -- The Tranzit Sprinter one.
				--"nz_pb_zombie_sprint_v9",
				"nz_l4d_run_03",
				"nz_l4d_run_04",
				
				"nz_t9_base_player_sprint_v01",
				"nz_t9_base_player_sprint_v02",
				"nz_t9_base_player_sprint_v03",
				"nz_t9_base_player_sprint_v04",
				"nz_t9_base_player_sprint_v05",
				"nz_t9_base_player_sprint_v06",
				"nz_t9_base_player_sprint_v07",
				"nz_t9_base_player_sprint_v08",
			},
			AttackSequences = {SprintAttackSequences},
			StandAttackSequences = {AttackSequences},
			Bo3AttackSequences = {StinkyRunAttackSequences},
			CrawlAttackSequences = {CrawlAttackSequences},

			JumpSequences = {SprintJumpSequences},
			CrawlJumpSequences = {CrawlJumpSequences},

			Climb36 = {FastClimbUp36},
			Climb48 = {FastClimbUp48},
			Climb72 = {FastClimbUp72},
			Climb96 = {FastClimbUp96},
			Climb120 = {SlowClimbUp128},
			Climb160 = {SlowClimbUp160},
			Climb200 = {ClimbUp200},

			PassiveSounds = {runsounds},
		},
		{
			SpawnSequence = {spawnfast},
			MovementSequence = {
				--"nz_legacy_sprint_v5",
				--"nz_legacy_jap_run_v3",
				"nz_sprint_au1",
				"nz_sprint_au2",
				"nz_sprint_au3",
				"nz_sprint_au4",
				"nz_sprint_au20",
				"nz_sprint_au21",
				"nz_sprint_au22",
				"nz_sprint_au25",
				"nz_fast_sprint_v1",
				"nz_fast_sprint_v2",
			},
			LowgMovementSequence = {
				"nz_sprint_lowg_v1",
				"nz_sprint_lowg_v2",
				"nz_sprint_lowg_v3",
				"nz_sprint_lowg_v4",
			},
			BlackholeMovementSequence = {
				"nz_blackhole_1",
				"nz_blackhole_2",
				"nz_blackhole_3",
			},
			CrawlMovementSequence = {
				"nz_crawl_slow_v1",
				"nz_crawl_slow_v2",
				"nz_crawl_slow_v3",
				"nz_crawl_v1",
				"nz_crawl_v2",
				"nz_crawl_v5",
				"nz_crawl_sprint_v1",
				"nz_crawl_on_hands",
				"nz_crawl_on_hands_c",
			},
			FireMovementSequence = {
				"nz_firestaff_walk_v1",
				"nz_firestaff_walk_v2",
				"nz_firestaff_walk_v3",
			},
			TurnedMovementSequence = {
				--"nz_pb_zombie_sprint_v6",
				--"nz_pb_zombie_sprint_v7",
				"nz_pb_zombie_sprint_v8", -- The Tranzit Sprinter one.
				--"nz_pb_zombie_sprint_v9",
				"nz_l4d_run_03",
				"nz_l4d_run_04",
				
				"nz_t9_base_player_sprint_v01",
				"nz_t9_base_player_sprint_v02",
				"nz_t9_base_player_sprint_v03",
				"nz_t9_base_player_sprint_v04",
				"nz_t9_base_player_sprint_v05",
				"nz_t9_base_player_sprint_v06",
				"nz_t9_base_player_sprint_v07",
				"nz_t9_base_player_sprint_v08",
			},
			AttackSequences = {SprintAttackSequences},
			StandAttackSequences = {AttackSequences},
			Bo3AttackSequences = {StinkyRunAttackSequences},
			CrawlAttackSequences = {CrawlAttackSequences},

			JumpSequences = {SprintJumpSequences},
			CrawlJumpSequences = {CrawlJumpSequences},

			Climb36 = {FastClimbUp36},
			Climb48 = {FastClimbUp48},
			Climb72 = {FastClimbUp72},
			Climb96 = {FastClimbUp96},
			Climb120 = {SlowClimbUp128},
			Climb160 = {SlowClimbUp160},
			Climb200 = {ClimbUp200},

			PassiveSounds = {runsounds},
		}
	}},
	{Threshold = 155, Sequences = {
		{
			SpawnSequence = {spawnsuperfast},
			MovementSequence = {
				"nz_supersprint_ad1",
				"nz_supersprint_ad2",
				"nz_supersprint_ad3",
				"nz_supersprint_ad4",
				"nz_supersprint_ad5",
				"nz_supersprint_ad6",
				"nz_supersprint_ad7",
				"nz_supersprint_ad8",
				"nz_supersprint_ad9",
				"nz_supersprint_ad10",
				"nz_supersprint_ad11",
				"nz_supersprint_ad12",
				"nz_supersprint_ad13",
			},
			LowgMovementSequence = {
				"nz_supersprint_lowg",
			},
			BlackholeMovementSequence = {
				"nz_blackhole_1",
				"nz_blackhole_2",
				"nz_blackhole_3",
			},
			CrawlMovementSequence = {
				"nz_crawl_slow_v1",
				"nz_crawl_slow_v2",
				"nz_crawl_slow_v3",
				"nz_crawl_v1",
				"nz_crawl_v2",
				"nz_crawl_v5",
				"nz_crawl_sprint_v1",
				"nz_crawl_on_hands",
				"nz_crawl_on_hands_c",
			},
			FireMovementSequence = {
				"nz_firestaff_walk_v1",
				"nz_firestaff_walk_v2",
				"nz_firestaff_walk_v3",
			},
			TurnedMovementSequence = {
				--"nz_pb_zombie_sprint_v6",
				--"nz_pb_zombie_sprint_v7",
				"nz_pb_zombie_sprint_v8", -- The Tranzit Sprinter one.
				--"nz_pb_zombie_sprint_v9",
				"nz_l4d_run_03",
				"nz_l4d_run_04",
				
				"nz_t9_base_player_sprint_v01",
				"nz_t9_base_player_sprint_v02",
				"nz_t9_base_player_sprint_v03",
				"nz_t9_base_player_sprint_v04",
				"nz_t9_base_player_sprint_v05",
				"nz_t9_base_player_sprint_v06",
				"nz_t9_base_player_sprint_v07",
				"nz_t9_base_player_sprint_v08",
				"nz_l4d_run_03",
				"nz_l4d_run_04",
			},
			AttackSequences = {SuperSprintAttackSequences},
			StandAttackSequences = {AttackSequences},
			Bo3AttackSequences = {StinkyRunAttackSequences},
			CrawlAttackSequences = {CrawlAttackSequences},

			JumpSequences = {SprintJumpSequences},
			CrawlJumpSequences = {CrawlJumpSequences},

			Climb36 = {FastClimbUp36},
			Climb48 = {FastClimbUp48},
			Climb72 = {FastClimbUp72},
			Climb96 = {FastClimbUp96},
			Climb120 = {SlowClimbUp128},
			Climb160 = {SlowClimbUp160},
			Climb200 = {ClimbUp200},

			PassiveSounds = {walksounds},
		},
		{
			SpawnSequence = {spawnsuperfast},
			MovementSequence = {
				"nz_supersprint_au1",
				"nz_supersprint_au2",
				"nz_supersprint_au3",
				"nz_supersprint_au4",
				"nz_supersprint_au6",
				"nz_supersprint_au8",
				"nz_supersprint_au9",
				"nz_supersprint_au12",
				"nz_supersprint_au20",
				"nz_supersprint_au21",
				"nz_supersprint_au25",
			},
			LowgMovementSequence = {
				"nz_supersprint_lowg",
			},
			BlackholeMovementSequence = {
				"nz_blackhole_1",
				"nz_blackhole_2",
				"nz_blackhole_3",
			},
			CrawlMovementSequence = {
				"nz_crawl_slow_v1",
				"nz_crawl_slow_v2",
				"nz_crawl_slow_v3",
				"nz_crawl_v1",
				"nz_crawl_v2",
				"nz_crawl_v5",
				"nz_crawl_sprint_v1",
				"nz_crawl_on_hands",
				"nz_crawl_on_hands_c",
			},
			FireMovementSequence = {
				"nz_firestaff_walk_v1",
				"nz_firestaff_walk_v2",
				"nz_firestaff_walk_v3",
			},
			TurnedMovementSequence = {
				--"nz_pb_zombie_sprint_v6",
				--"nz_pb_zombie_sprint_v7",
				"nz_pb_zombie_sprint_v8", -- The Tranzit Sprinter one.
				--"nz_pb_zombie_sprint_v9",
				"nz_l4d_run_03",
				"nz_l4d_run_04",
				
				"nz_t9_base_player_sprint_v01",
				"nz_t9_base_player_sprint_v02",
				"nz_t9_base_player_sprint_v03",
				"nz_t9_base_player_sprint_v04",
				"nz_t9_base_player_sprint_v05",
				"nz_t9_base_player_sprint_v06",
				"nz_t9_base_player_sprint_v07",
				"nz_t9_base_player_sprint_v08",
				"nz_l4d_run_03",
				"nz_l4d_run_04",
			},
			AttackSequences = {SuperSprintAttackSequences},
			StandAttackSequences = {AttackSequences},
			Bo3AttackSequences = {StinkyRunAttackSequences},
			CrawlAttackSequences = {CrawlAttackSequences},

			JumpSequences = {SprintJumpSequences},
			CrawlJumpSequences = {CrawlJumpSequences},

			Climb36 = {FastClimbUp36},
			Climb48 = {FastClimbUp48},
			Climb72 = {FastClimbUp72},
			Climb96 = {FastClimbUp96},
			Climb120 = {SlowClimbUp128},
			Climb160 = {SlowClimbUp160},
			Climb200 = {ClimbUp200},

			PassiveSounds = {walksounds},
		}
	}}
}

ENT.TauntSequences = {
	"nz_taunt_v1",
	"nz_taunt_v2",
	"nz_taunt_v3",
	"nz_taunt_v4",
	"nz_taunt_v5",
	"nz_taunt_v6",
	"nz_taunt_v7",
	"nz_taunt_v8",
	"nz_taunt_v9"
}

ENT.IdleSequence = "nz_idle_ad"

ENT.DeathSounds = {
	"nz_moo/zombies/vox/_zhd/death/death_00.mp3",
	"nz_moo/zombies/vox/_zhd/death/death_01.mp3",
	"nz_moo/zombies/vox/_zhd/death/death_02.mp3",
	"nz_moo/zombies/vox/_zhd/death/death_03.mp3",
	"nz_moo/zombies/vox/_zhd/death/death_04.mp3",
	"nz_moo/zombies/vox/_zhd/death/death_05.mp3",
	"nz_moo/zombies/vox/_zhd/death/death_06.mp3",
	"nz_moo/zombies/vox/_zhd/death/death_07.mp3",
	"nz_moo/zombies/vox/_zhd/death/death_08.mp3",
	"nz_moo/zombies/vox/_zhd/death/death_09.mp3",
	"nz_moo/zombies/vox/_zhd/death/death_10.mp3",
	"nz_moo/zombies/vox/_zhd/death/death_11.mp3",
	"nz_moo/zombies/vox/_zhd/death/death_12.mp3",
	"nz_moo/zombies/vox/_zhd/death/death_13.mp3",
	"nz_moo/zombies/vox/_zhd/death/death_14.mp3",
	"nz_moo/zombies/vox/_zhd/death/death_15.mp3"
}

ENT.ElecSounds = {
	"nz_moo/zombies/vox/_classic/elec/elec_00.mp3",
	"nz_moo/zombies/vox/_classic/elec/elec_01.mp3",
	"nz_moo/zombies/vox/_classic/elec/elec_02.mp3",
	"nz_moo/zombies/vox/_classic/elec/elec_03.mp3",
	"nz_moo/zombies/vox/_classic/elec/elec_04.mp3",
	"nz_moo/zombies/vox/_classic/elec/elec_05.mp3"
}

ENT.NukeDeathSounds = {
	"nz_moo/zombies/vox/nuke_death/soul_00.mp3",
	"nz_moo/zombies/vox/nuke_death/soul_01.mp3",
	"nz_moo/zombies/vox/nuke_death/soul_02.mp3",
	"nz_moo/zombies/vox/nuke_death/soul_03.mp3",
	"nz_moo/zombies/vox/nuke_death/soul_04.mp3",
	"nz_moo/zombies/vox/nuke_death/soul_05.mp3",
	"nz_moo/zombies/vox/nuke_death/soul_06.mp3",
	"nz_moo/zombies/vox/nuke_death/soul_07.mp3",
	"nz_moo/zombies/vox/nuke_death/soul_08.mp3",
	"nz_moo/zombies/vox/nuke_death/soul_09.mp3",
	"nz_moo/zombies/vox/nuke_death/soul_10.mp3"
}

ENT.AttackSounds = {
	"nz_moo/zombies/vox/_zhd/attack/series_1/attack_00.mp3",
	"nz_moo/zombies/vox/_zhd/attack/series_1/attack_01.mp3",
	"nz_moo/zombies/vox/_zhd/attack/series_1/attack_02.mp3",
	"nz_moo/zombies/vox/_zhd/attack/series_1/attack_03.mp3",
	"nz_moo/zombies/vox/_zhd/attack/series_1/attack_04.mp3",
	"nz_moo/zombies/vox/_zhd/attack/series_1/attack_05.mp3",
	"nz_moo/zombies/vox/_zhd/attack/series_1/attack_06.mp3",
	"nz_moo/zombies/vox/_zhd/attack/series_1/attack_07.mp3",
	"nz_moo/zombies/vox/_zhd/attack/series_1/attack_08.mp3",

	"nz_moo/zombies/vox/_zhd/attack/series_2/attack_00.mp3",
	"nz_moo/zombies/vox/_zhd/attack/series_2/attack_01.mp3",
	"nz_moo/zombies/vox/_zhd/attack/series_2/attack_02.mp3",
	"nz_moo/zombies/vox/_zhd/attack/series_2/attack_03.mp3",
	"nz_moo/zombies/vox/_zhd/attack/series_2/attack_04.mp3",
	"nz_moo/zombies/vox/_zhd/attack/series_2/attack_05.mp3",
	"nz_moo/zombies/vox/_zhd/attack/series_2/attack_06.mp3",
	"nz_moo/zombies/vox/_zhd/attack/series_2/attack_07.mp3",

	"nz_moo/zombies/vox/_zhd/attack/series_3/attack_00.mp3",
	"nz_moo/zombies/vox/_zhd/attack/series_3/attack_01.mp3",
	"nz_moo/zombies/vox/_zhd/attack/series_3/attack_02.mp3",
	"nz_moo/zombies/vox/_zhd/attack/series_3/attack_03.mp3",
	"nz_moo/zombies/vox/_zhd/attack/series_3/attack_04.mp3",
	"nz_moo/zombies/vox/_zhd/attack/series_3/attack_05.mp3",
	"nz_moo/zombies/vox/_zhd/attack/series_3/attack_06.mp3",
	"nz_moo/zombies/vox/_zhd/attack/series_3/attack_07.mp3"
}

ENT.CrawlerSounds = {
	Sound("nz_moo/zombies/vox/_classic/crawl/crawl_00.mp3"),
	Sound("nz_moo/zombies/vox/_classic/crawl/crawl_01.mp3"),
	Sound("nz_moo/zombies/vox/_classic/crawl/crawl_02.mp3"),
	Sound("nz_moo/zombies/vox/_classic/crawl/crawl_03.mp3"),
	Sound("nz_moo/zombies/vox/_classic/crawl/crawl_04.mp3"),
	Sound("nz_moo/zombies/vox/_classic/crawl/crawl_05.mp3"),
}

ENT.BehindSoundDistance = 200 -- When the zombie is within 200 units of a player, play these sounds instead
ENT.BehindSounds = {
	Sound("nz_moo/zombies/vox/_zhd/behind/behind_00.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/behind/behind_01.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/behind/behind_02.mp3"),
	Sound("nz_moo/zombies/vox/_zhd/behind/behind_03.mp3"),
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
ENT.PainSounds = {
	"nz_moo/zombies/vox/_zhd/pain/pain_00.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_01.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_02.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_03.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_04.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_05.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_06.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_07.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_08.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_09.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_10.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_11.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_12.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_13.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_14.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_15.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_16.mp3",
}

ENT.GasVox = {
	"nz_moo/zombies/vox/_gas/sprint/sprint_00.mp3",
	"nz_moo/zombies/vox/_gas/sprint/sprint_01.mp3",
	"nz_moo/zombies/vox/_gas/sprint/sprint_02.mp3",
	"nz_moo/zombies/vox/_gas/sprint/sprint_03.mp3",
	"nz_moo/zombies/vox/_gas/sprint/sprint_04.mp3",
	"nz_moo/zombies/vox/_gas/sprint/sprint_05.mp3",
	"nz_moo/zombies/vox/_gas/sprint/sprint_06.mp3",
	"nz_moo/zombies/vox/_gas/sprint/sprint_07.mp3",
	"nz_moo/zombies/vox/_gas/sprint/sprint_08.mp3",
	"nz_moo/zombies/vox/_gas/sprint/sprint_09.mp3",
	"nz_moo/zombies/vox/_gas/sprint/sprint_10.mp3",
	"nz_moo/zombies/vox/_gas/sprint/sprint_11.mp3",
	"nz_moo/zombies/vox/_gas/sprint/sprint_12.mp3",
	"nz_moo/zombies/vox/_gas/sprint/sprint_13.mp3",
	"nz_moo/zombies/vox/_gas/sprint/sprint_14.mp3",
	"nz_moo/zombies/vox/_gas/sprint/sprint_15.mp3",
	"nz_moo/zombies/vox/_gas/sprint/sprint_16.mp3",
	"nz_moo/zombies/vox/_gas/sprint/sprint_17.mp3",
	"nz_moo/zombies/vox/_gas/sprint/sprint_18.mp3",
	"nz_moo/zombies/vox/_gas/sprint/sprint_19.mp3",
	"nz_moo/zombies/vox/_gas/sprint/sprint_20.mp3",
	"nz_moo/zombies/vox/_gas/sprint/sprint_21.mp3",
	"nz_moo/zombies/vox/_gas/sprint/sprint_22.mp3",
	"nz_moo/zombies/vox/_gas/sprint/sprint_23.mp3",
	"nz_moo/zombies/vox/_gas/sprint/sprint_24.mp3",
	"nz_moo/zombies/vox/_gas/sprint/sprint_25.mp3",
	"nz_moo/zombies/vox/_gas/sprint/sprint_26.mp3",
	"nz_moo/zombies/vox/_gas/sprint/sprint_27.mp3",
}

ENT.GasAttack = {
	"nz_moo/zombies/vox/_gas/attack/attack_00.mp3",
	"nz_moo/zombies/vox/_gas/attack/attack_01.mp3",
	"nz_moo/zombies/vox/_gas/attack/attack_02.mp3",
	"nz_moo/zombies/vox/_gas/attack/attack_03.mp3",
	"nz_moo/zombies/vox/_gas/attack/attack_04.mp3",
	"nz_moo/zombies/vox/_gas/attack/attack_05.mp3",
	"nz_moo/zombies/vox/_gas/attack/attack_06.mp3",
	"nz_moo/zombies/vox/_gas/attack/attack_07.mp3",
	"nz_moo/zombies/vox/_gas/attack/attack_08.mp3",
	"nz_moo/zombies/vox/_gas/attack/attack_09.mp3",
	"nz_moo/zombies/vox/_gas/attack/attack_10.mp3",
	"nz_moo/zombies/vox/_gas/attack/attack_11.mp3",
	"nz_moo/zombies/vox/_gas/attack/attack_12.mp3",
	"nz_moo/zombies/vox/_gas/attack/attack_13.mp3",
	"nz_moo/zombies/vox/_gas/attack/attack_14.mp3",
	"nz_moo/zombies/vox/_gas/attack/attack_15.mp3",
	"nz_moo/zombies/vox/_gas/attack/attack_16.mp3",
	"nz_moo/zombies/vox/_gas/attack/attack_17.mp3",
	"nz_moo/zombies/vox/_gas/attack/attack_18.mp3",
	"nz_moo/zombies/vox/_gas/attack/attack_19.mp3",
	"nz_moo/zombies/vox/_gas/attack/attack_20.mp3",
	"nz_moo/zombies/vox/_gas/attack/attack_21.mp3",
	"nz_moo/zombies/vox/_gas/attack/attack_22.mp3",
	"nz_moo/zombies/vox/_gas/attack/attack_23.mp3",
	"nz_moo/zombies/vox/_gas/attack/attack_24.mp3",
}