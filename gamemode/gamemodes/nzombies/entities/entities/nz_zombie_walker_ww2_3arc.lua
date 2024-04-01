AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.Type = "nextbot"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo"
ENT.Spawnable = true

if CLIENT then 
	return 
end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = false

ENT.MinSoundPitch = 95
ENT.MaxSoundPitch = 105
ENT.SoundVolume = 95

ENT.Models = {
	{Model = "models/moo/_codz_ports/s2/zombie/moo_codz_s2_zom_infantrya_3arc.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model = "models/moo/_codz_ports/s2/zombie/moo_codz_s2_zom_snipera_3arc.mdl", Skin = 0, Bodygroups = {0,0}},
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

ENT.CrawlDeathSequences = {
	"nz_crawl_death_v1",
	"nz_crawl_death_v2",
}

ENT.SparkySequences = {
	"nz_s2_core_stunned_electrobolt_v1",
	"nz_s2_core_stunned_electrobolt_v2",
	"nz_s2_core_stunned_electrobolt_v3",
	"nz_s2_core_stunned_electrobolt_v4",
	"nz_s2_core_stunned_electrobolt_v5",
}

local CrawlAttackSequences = {
	{seq = "nz_iw7_cp_zom_prone_attack_2h_01"},
	{seq = "nz_iw7_cp_zom_prone_attack_l_01"},
	{seq = "nz_iw7_cp_zom_prone_attack_l_02"},
	{seq = "nz_iw7_cp_zom_prone_attack_r_01"},
}

local CrawlJumpSequences = {
	{seq = "nz_iw7_cp_zom_prone_run_window_over_40_01"},
	{seq = "nz_iw7_cp_zom_prone_run_window_over_40_02"},
	{seq = "nz_iw7_cp_zom_prone_run_window_over_40_03"},
	{seq = "nz_iw7_cp_zom_prone_walk_window_over_40_01"},
	{seq = "nz_iw7_cp_zom_prone_walk_window_over_40_02"},
	{seq = "nz_iw7_cp_zom_prone_walk_window_over_40_03"},
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
	{seq = "nz_iw7_cp_zom_stand_attack_l_01"},
	{seq = "nz_iw7_cp_zom_stand_attack_l_02"},
	{seq = "nz_iw7_cp_zom_stand_attack_r_01"},
	{seq = "nz_iw7_cp_zom_stand_attack_r_02"},
	{seq = "nz_zom_core_stand_attack_2h_01"},
	{seq = "nz_zom_core_stand_attack_2h_02"},
}

local WalkAttackSequences = {
	{seq = "nz_iw7_cp_zom_walk_attack_r_01"}, -- Quick single swipe
	{seq = "nz_iw7_cp_zom_walk_attack_r_02"}, -- Slowish double swipe
	{seq = "nz_iw7_cp_zom_walk_attack_l_01"}, -- Slowish single swipe
	{seq = "nz_iw7_cp_zom_walk_attack_l_02"}, -- Quickish double swipe
	{seq = "nz_zom_core_walk_atk_l_03"},
}

local RunAttackSequences = {
	{seq = "nz_zom_core_run_attack_l_01"},
	{seq = "nz_zom_core_run_attack_l_02"},
	{seq = "nz_zom_core_run_attack_r_01"},
	{seq = "nz_zom_core_run_attack_r_02"},
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
	{seq = "nz_zom_core_run_attack_l_01"},
	{seq = "nz_zom_core_run_attack_l_02"},
	{seq = "nz_zom_core_run_attack_r_01"},
	{seq = "nz_zom_core_run_attack_r_02"},
}

local SuperSprintAttackSequences = {
	{seq = "nz_zom_core_sprint_attack_2h_01"},
	{seq = "nz_zom_core_sprint_attack_2h_02"},
	{seq = "nz_zom_core_sprint_attack_l_01"},
	{seq = "nz_zom_core_sprint_attack_r_01"},
	{seq = "nz_zom_core_sprint_attack_r_02"},
}

local JumpSequences = {
	{seq = "nz_iw7_cp_zom_walk_window_over_40_01"},
	{seq = "nz_iw7_cp_zom_walk_window_over_40_02"},
	{seq = "nz_iw7_cp_zom_walk_window_over_40_03"},
	{seq = "nz_iw7_cp_zom_walk_window_over_40_04"},
}
local RunJumpSequences = {
	{seq = "nz_iw7_cp_zom_run_window_over_40_01"},
	{seq = "nz_iw7_cp_zom_run_window_over_40_02"},
	{seq = "nz_iw7_cp_zom_run_window_over_40_03"},
	{seq = "nz_iw7_cp_zom_run_window_over_40_04"},
	{seq = "nz_iw7_cp_zom_run_window_over_40_05"},
	{seq = "nz_l4d_mantle_over_36"},
}
local SprintJumpSequences = {
	{seq = "nz_zom_core_mantle_over_40"},
	{seq = "nz_zom_core_traverse_stepover_40"},
	{seq = "nz_zom_core_traverse_window_36_quick"},
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

	-- Speaking
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

ENT.IdleSequence = "nz_iw7_cp_zom_stand_idle_01"

ENT.IdleSequenceAU = "nz_iw7_cp_zom_stand_idle_02"

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
				"nz_legacy_walk_dazed",
				"nz_legacy_jap_walk_v1",
				"nz_legacy_jap_walk_v4",
				"nz_iw7_cp_zom_shamble_forward_01",
				"nz_iw7_cp_zom_shamble_forward_02",
				"nz_iw7_cp_zom_shamble_forward_03",
				"nz_iw7_cp_zom_shamble_forward_04",
				--"nz_walk_au_goose",
				--"nz_legacy_jap_walk_v2",
				--"nz_legacy_jap_walk_v3",
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
				"nz_iw7_cp_zom_prone_shamble_forward_01",
				"nz_iw7_cp_zom_prone_shamble_forward_02",
				--[["nz_crawl_slow_v1",
				"nz_crawl_slow_v2",
				"nz_crawl_slow_v3",
				"nz_crawl_v1",
				"nz_crawl_v2",
				"nz_crawl_v5",
				"nz_crawl_sprint_v1",
				"nz_crawl_on_hands",
				"nz_crawl_on_hands_c",]]
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
			Bo3AttackSequences = {StinkyRunAttackSequences},
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
				"nz_legacy_walk_dazed",
				"nz_legacy_jap_walk_v1",
				"nz_legacy_jap_walk_v4",
				"nz_iw7_cp_zom_shamble_forward_01",
				"nz_iw7_cp_zom_shamble_forward_02",
				"nz_iw7_cp_zom_shamble_forward_03",
				"nz_iw7_cp_zom_shamble_forward_04",
				--"nz_walk_au_goose", -- This is the goosestep walk aka marching anim that german soldier zombies use.
				--"nz_legacy_jap_walk_v2",
				--"nz_legacy_jap_walk_v3",
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
				"nz_iw7_cp_zom_prone_shamble_forward_01",
				"nz_iw7_cp_zom_prone_shamble_forward_02",
				--[["nz_crawl_slow_v1",
				"nz_crawl_slow_v2",
				"nz_crawl_slow_v3",
				"nz_crawl_v1",
				"nz_crawl_v2",
				"nz_crawl_v5",
				"nz_crawl_sprint_v1",
				"nz_crawl_on_hands",
				"nz_crawl_on_hands_c",]]
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
				"nz_legacy_jap_run_v1",
				"nz_legacy_jap_run_v4",
				"nz_legacy_jap_run_v6",
				"nz_iw7_cp_zom_run_forward_04",
				"nz_iw7_cp_zom_run_forward_05",
				"nz_run_ad1",
				"nz_run_ad2",
				"nz_run_ad3",
				"nz_run_ad4",
				--"nz_legacy_run_v1",
				--"nz_legacy_run_v3",
				--"nz_legacy_jap_run_v2",
				--"nz_legacy_jap_run_v5",
				--[["nz_run_ad7",
				"nz_run_ad8",
				"nz_run_ad11",
				"nz_run_ad12",
				"nz_run_ad14",
				"nz_run_ad20",
				"nz_run_ad21",
				"nz_run_ad22",
				"nz_run_ad23",
				"nz_run_ad24",]]
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
				"nz_iw7_cp_zom_prone_shamble_forward_01",
				"nz_iw7_cp_zom_prone_shamble_forward_02",
				--[["nz_crawl_slow_v1",
				"nz_crawl_slow_v2",
				"nz_crawl_slow_v3",
				"nz_crawl_v1",
				"nz_crawl_v2",
				"nz_crawl_v5",
				"nz_crawl_sprint_v1",
				"nz_crawl_on_hands",
				"nz_crawl_on_hands_c",]]
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
				"nz_legacy_jap_run_v1",
				"nz_legacy_jap_run_v4",
				"nz_legacy_jap_run_v6",
				"nz_iw7_cp_zom_run_forward_04",
				"nz_iw7_cp_zom_run_forward_05",
				"nz_run_au1",
				"nz_run_au2",
				"nz_run_au3",
				"nz_run_au4",
				--"nz_legacy_run_v1",
				--"nz_legacy_run_v3",
				--"nz_legacy_jap_run_v2",
				--"nz_legacy_jap_run_v5",
				--[["nz_run_au5",
				"nz_run_au9",
				"nz_run_au11",
				"nz_run_au13",
				"nz_run_au20",
				"nz_run_au21",
				"nz_run_au22",
				"nz_run_au23",
				"nz_run_au24",]]
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
				"nz_iw7_cp_zom_prone_shamble_forward_01",
				"nz_iw7_cp_zom_prone_shamble_forward_02",
				--[["nz_crawl_slow_v1",
				"nz_crawl_slow_v2",
				"nz_crawl_slow_v3",
				"nz_crawl_v1",
				"nz_crawl_v2",
				"nz_crawl_v5",
				"nz_crawl_sprint_v1",
				"nz_crawl_on_hands",
				"nz_crawl_on_hands_c",]]
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
				"nz_t9_base_sprint_ad_v01",
				"nz_t9_base_sprint_ad_v02",
				"nz_t9_base_sprint_ad_v05",
				"nz_t9_base_sprint_ad_v21",
				"nz_t9_base_sprint_ad_v22",
				"nz_t9_base_sprint_ad_v23",
				"nz_sprint_ad3",
				"nz_sprint_ad4",
				"nz_s1_zom_core_run_1",
				"nz_legacy_jap_run_v3",
				"nz_legacy_sprint_v5",
				"nz_s2_core_sprint_v10",
				"nz_s2_core_sprint_v10",
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
				"nz_iw7_cp_zom_prone_shamble_forward_01",
				"nz_iw7_cp_zom_prone_shamble_forward_02",
				--[["nz_crawl_slow_v1",
				"nz_crawl_slow_v2",
				"nz_crawl_slow_v3",
				"nz_crawl_v1",
				"nz_crawl_v2",
				"nz_crawl_v5",
				"nz_crawl_sprint_v1",
				"nz_crawl_on_hands",
				"nz_crawl_on_hands_c",]]
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
				--"nz_t9_base_sprint_au_v02",
				"nz_t9_base_sprint_au_v01",
				"nz_t9_base_sprint_au_v20",
				"nz_t9_base_sprint_au_v21",
				"nz_t9_base_sprint_au_v22",
				"nz_t9_base_sprint_au_v25",
				"nz_sprint_au3",
				"nz_sprint_au4",
				"nz_s1_zom_core_run_1",
				"nz_bo3_zombie_sprint_v2",
				"nz_legacy_jap_run_v3",
				"nz_legacy_sprint_v5",
				"nz_s2_core_sprint_v10",
				"nz_s2_core_sprint_v10",
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
				"nz_iw7_cp_zom_prone_shamble_forward_01",
				"nz_iw7_cp_zom_prone_shamble_forward_02",
				--[["nz_crawl_slow_v1",
				"nz_crawl_slow_v2",
				"nz_crawl_slow_v3",
				"nz_crawl_v1",
				"nz_crawl_v2",
				"nz_crawl_v5",
				"nz_crawl_sprint_v1",
				"nz_crawl_on_hands",
				"nz_crawl_on_hands_c",]]
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
				"nz_iw7_cp_zom_prone_shamble_forward_01",
				"nz_iw7_cp_zom_prone_shamble_forward_02",
				--[["nz_crawl_slow_v1",
				"nz_crawl_slow_v2",
				"nz_crawl_slow_v3",
				"nz_crawl_v1",
				"nz_crawl_v2",
				"nz_crawl_v5",
				"nz_crawl_sprint_v1",
				"nz_crawl_on_hands",
				"nz_crawl_on_hands_c",]]
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
				"nz_iw7_cp_zom_prone_shamble_forward_01",
				"nz_iw7_cp_zom_prone_shamble_forward_02",
				--[["nz_crawl_slow_v1",
				"nz_crawl_slow_v2",
				"nz_crawl_slow_v3",
				"nz_crawl_v1",
				"nz_crawl_v2",
				"nz_crawl_v5",
				"nz_crawl_sprint_v1",
				"nz_crawl_on_hands",
				"nz_crawl_on_hands_c",]]
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

	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_melee_miss_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_melee_miss_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_melee_miss_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_melee_miss_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_melee_miss_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_melee_miss_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_melee_miss_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_melee_miss_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_melee_miss_09.mp3"),

	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_melee_hit_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_melee_hit_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_melee_hit_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_melee_hit_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_melee_hit_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_melee_hit_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_melee_hit_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_melee_hit_09.mp3"),

	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_melee_miss_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_melee_miss_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_melee_miss_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_melee_miss_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_melee_miss_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_melee_miss_10.mp3"),
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

	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_spawn_vocal_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_spawn_vocal_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_spawn_vocal_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_spawn_vocal_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_spawn_vocal_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_spawn_vocal_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_spawn_vocal_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_spawn_vocal_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_spawn_vocal_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_spawn_vocal_10.mp3"),

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
			self:SetHealth( nzRound:GetZombieHealth() ) -- Since these zombies are overall slower, they hit harder and have more health.
			--self:SetHealth( nzRound:GetZombieHealth() * 1.5 or 75 ) -- Since these zombies are overall slower, they hit harder and have more health.
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

	if IsValid(self.SpawnIndex) then
		local stype = self.SpawnIndex:GetSpawnType()
		if stype == 11 then
			self:EmitSound("ambient/energy/weld"..math.random(2)..".wav",100,math.random(95,105))
			self:EmitSound("nz_moo/zombies/gibs/head/_og/zombie_head_0"..math.random(0,2)..".mp3", 65, math.random(95,105))
			self:EmitSound("nz_moo/zombies/gibs/gib_0"..math.random(0,3)..".mp3", 100, math.random(95,105))
			if IsValid(self) then ParticleEffect("wwii_spawn_main", self:GetPos() + Vector(0,0,0), Angle(0,0,0), self) end
			if IsValid(self) then ParticleEffect("wwii_spawn_embers", self:GetPos() + Vector(0,0,0), Angle(0,0,0), self) end
			if IsValid(self) then ParticleEffect("wwii_spawn_blood", self:GetPos() + Vector(0,0,0), Angle(0,0,0), self) end
			if IsValid(self) then ParticleEffect("wwii_spawn_elec", self:GetPos() + Vector(0,0,20), Angle(0,0,0), self) end
		end
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

ENT.CustomTauntAnimV1Sounds = {
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_10.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_11.mp3"),

	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_10.mp3"),
}

ENT.CustomTauntAnimV2Sounds = {
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_10.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_11.mp3"),

	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_10.mp3"),
}

ENT.CustomTauntAnimV3Sounds = {
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_10.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_11.mp3"),

	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_10.mp3"),
}

ENT.CustomTauntAnimV4Sounds = {
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_10.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_11.mp3"),

	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_10.mp3"),
}

ENT.CustomTauntAnimV5Sounds = {
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_10.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_11.mp3"),

	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_10.mp3"),
}

ENT.CustomTauntAnimV6Sounds = {
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_10.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_11.mp3"),

	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_10.mp3"),
}

ENT.CustomTauntAnimV7Sounds = {
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_10.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_11.mp3"),

	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_10.mp3"),
}

ENT.CustomTauntAnimV8Sounds = {
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_10.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_11.mp3"),

	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_10.mp3"),
}

ENT.CustomTauntAnimV9Sounds = {
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_10.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen2/zmb_vox_gen2_sneakattack_success_11.mp3"),

	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_05.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_06.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_07.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_08.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_09.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen_v2/zmb_vox_gen_sneakattack_success_10.mp3"),
}

ENT.CustomSpecialTauntSounds = {
	Sound("nz_moo/zombies/vox/_gen/gen/zmb_vox_gen_charge_01.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen/zmb_vox_gen_charge_02.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen/zmb_vox_gen_charge_03.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen/zmb_vox_gen_charge_04.mp3"),
	Sound("nz_moo/zombies/vox/_gen/gen/zmb_vox_gen_charge_05.mp3"),
}