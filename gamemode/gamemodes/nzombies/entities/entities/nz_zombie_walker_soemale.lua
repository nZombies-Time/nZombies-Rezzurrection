AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.Type = "nextbot"
ENT.Category = "Brainz"
ENT.Author = "Lolle/Moo"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "EmergeSequenceIndex")
	self:NetworkVar("Bool", 1, "Decapitated")
	self:NetworkVar("Bool", 2, "Alive")
	self:NetworkVar("Bool", 3, "MooSpecial")
end

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true

ENT.Models = {
	--//Male\\--
	{Model = "models/moo/_codz_ports/t7/zod/male/moo_codz_t7_zod_male_1_a.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model = "models/moo/_codz_ports/t7/zod/male/moo_codz_t7_zod_male_1_b.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model = "models/moo/_codz_ports/t7/zod/male/moo_codz_t7_zod_male_1_c.mdl", Skin = 0, Bodygroups = {0,0}},

	{Model = "models/moo/_codz_ports/t7/zod/male/moo_codz_t7_zod_male_2_a.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model = "models/moo/_codz_ports/t7/zod/male/moo_codz_t7_zod_male_2_b.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model = "models/moo/_codz_ports/t7/zod/male/moo_codz_t7_zod_male_2_c.mdl", Skin = 0, Bodygroups = {0,0}},

	{Model = "models/moo/_codz_ports/t7/zod/male/moo_codz_t7_zod_male_3_a.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model = "models/moo/_codz_ports/t7/zod/male/moo_codz_t7_zod_male_3_b.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model = "models/moo/_codz_ports/t7/zod/male/moo_codz_t7_zod_male_3_c.mdl", Skin = 0, Bodygroups = {0,0}},

	--//Female\\--
	{Model = "models/moo/_codz_ports/t7/zod/female/moo_codz_t7_zod_female_1_a.mdl", Skin = 0, Bodygroups = {0,0}},

	{Model = "models/moo/_codz_ports/t7/zod/female/moo_codz_t7_zod_female_2_a.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model = "models/moo/_codz_ports/t7/zod/female/moo_codz_t7_zod_female_2_b.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model = "models/moo/_codz_ports/t7/zod/female/moo_codz_t7_zod_female_2_c.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model = "models/moo/_codz_ports/t7/zod/female/moo_codz_t7_zod_female_2_d.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawnslow = {"nz_spawn_ground_v1", "nz_spawn_ground_ad_v2", "nz_spawn_ground_v2", "nz_spawn_ground_v2_altb"}
local spawnrun = {"nz_spawn_ground_v1_run"}
local spawnfast = {"nz_spawn_ground_climbout_fast"}
local spawnsuperfast = {"nz_spawn_ground_quickrise_v1", "nz_spawn_ground_quickrise_v2", "nz_spawn_ground_quickrise_v3"}

ENT.DeathSequences = {
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

local CrawlAttackSequences = {
	{seq = "nz_crawl_attack_v1", dmgtimes = {0.75, 1.65}},
	{seq = "nz_crawl_attack_v2", dmgtimes = {0.65}},
}

local CrawlJumpSequences = {
	{seq = "nz_barricade_crawl_1", speed = 10, time = 3},
	{seq = "nz_barricade_crawl_2", speed = 10, time = 3},
}

local AttackSequences = {
	{seq = "nz_attack_stand_ad_1", dmgtimes = {0.75, 1.25}},
	{seq = "nz_attack_stand_au_1", dmgtimes = {0.75, 1.25}},
	{seq = "nz_fwd_ad_attack_v1", dmgtimes = {0.95, 1.35}},
	{seq = "nz_fwd_ad_attack_v2", dmgtimes = {0.85, 1.30}},
	{seq = "nz_legacy_attack_v3", dmgtimes = {0.25}},
	{seq = "nz_legacy_attack_v4", dmgtimes = {0.35}},
	{seq = "nz_legacy_attack_v11", dmgtimes = {1.00}},
	{seq = "nz_legacy_attack_superwindmill", dmgtimes = {0.50, 1.00, 1.50, 2.00}}, -- Just don't get Superwind Mill'd 5 head.
}

local WalkAttackSequences = {
	{seq = "nz_walking_attack_v1", dmgtimes = {1.45}},
	{seq = "nz_walking_attack_v2", dmgtimes = {1.4}},
	{seq = "nz_walking_attack_v3", dmgtimes = {0.75}},
	{seq = "nz_walking_attack_v4", dmgtimes = {1.65}},
	{seq = "nz_walking_attack_v5", dmgtimes = {1.85}},
}

local RunAttackSequences = {
	{seq = "nz_running_attack_v1", dmgtimes = {0.75}},
	{seq = "nz_running_attack_v2", dmgtimes = {0.75}},
	{seq = "nz_running_attack_v3", dmgtimes = {0.70}},
	{seq = "nz_running_attack_v4", dmgtimes = {0.80}},
	{seq = "nz_running_attack_v5", dmgtimes = {0.75}},
}

local SprintAttackSequences = {
	{seq = "nz_sprinting_attack_v1", dmgtimes = {0.40}},
	{seq = "nz_sprinting_attack_v2", dmgtimes = {0.85}},
	{seq = "nz_sprinting_attack_v3", dmgtimes = {0.50}},
	{seq = "nz_sprinting_attack_v4", dmgtimes = {0.40}},
	{seq = "nz_sprinting_attack_v5", dmgtimes = {0.35}},
}

local SuperSprintAttackSequences = {
	{seq = "nz_supersprinting_attack_v1", dmgtimes = {0.40}},
	{seq = "nz_supersprinting_attack_v2", dmgtimes = {0.35}},
	{seq = "nz_supersprinting_attack_v3", dmgtimes = {0.45}},
	{seq = "nz_supersprinting_attack_v4", dmgtimes = {0.40}},
}

local JumpSequences = {
	{seq = "nz_barricade_trav_walk_1", speed = 25, time = 2.7},
	{seq = "nz_barricade_trav_walk_2", speed = 25, time = 2.7},
	{seq = "nz_barricade_trav_walk_3", speed = 15, time = 2},
	{seq = "nz_barricade_trav_walk_4", speed = 15, time = 2},
}
local RunJumpSequences = {
	{seq = "nz_barricade_run_1", speed = 35, time = 1},
}
local SprintJumpSequences = {
	{seq = "nz_barricade_sprint_1", speed = 50, time = 1},
	{seq = "nz_barricade_sprint_2", speed = 30, time = 1},
}
local walksounds = {
	Sound("nz_moo/zombies/vox/_classic/amb/amb_00.mp3"),
	Sound("nz_moo/zombies/vox/_classic/amb/amb_01.mp3"),
	Sound("nz_moo/zombies/vox/_classic/amb/amb_02.mp3"),
	Sound("nz_moo/zombies/vox/_classic/amb/amb_03.mp3"),
	Sound("nz_moo/zombies/vox/_classic/amb/amb_04.mp3"),
	Sound("nz_moo/zombies/vox/_classic/amb/amb_05.mp3"),
}

local runsounds = {
	Sound("nz_moo/zombies/vox/_classic/sprint/sprint_00.mp3"),
	Sound("nz_moo/zombies/vox/_classic/sprint/sprint_01.mp3"),
	Sound("nz_moo/zombies/vox/_classic/sprint/sprint_02.mp3"),
	Sound("nz_moo/zombies/vox/_classic/sprint/sprint_03.mp3"),
	Sound("nz_moo/zombies/vox/_classic/sprint/sprint_04.mp3"),
	Sound("nz_moo/zombies/vox/_classic/sprint/sprint_05.mp3"),
	Sound("nz_moo/zombies/vox/_classic/sprint/sprint_06.mp3"),
	Sound("nz_moo/zombies/vox/_classic/sprint/sprint_07.mp3"),
	Sound("nz_moo/zombies/vox/_classic/sprint/sprint_08.mp3"),
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
			},
			AttackSequences = {WalkAttackSequences},
			StandAttackSequences = {AttackSequences},
			CrawlAttackSequences = {CrawlAttackSequences},

			JumpSequences = {JumpSequences},
			CrawlJumpSequences = {CrawlJumpSequences},

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
			},
			AttackSequences = {WalkAttackSequences},
			StandAttackSequences = {AttackSequences},
			CrawlAttackSequences = {CrawlAttackSequences},

			JumpSequences = {JumpSequences},
			CrawlJumpSequences = {CrawlJumpSequences},

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
			},
			AttackSequences = {RunAttackSequences},
			StandAttackSequences = {AttackSequences},
			CrawlAttackSequences = {CrawlAttackSequences},

			JumpSequences = {RunJumpSequences},
			CrawlJumpSequences = {CrawlJumpSequences},

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
			},
			AttackSequences = {RunAttackSequences},
			StandAttackSequences = {AttackSequences},
			CrawlAttackSequences = {CrawlAttackSequences},

			JumpSequences = {RunJumpSequences},
			CrawlJumpSequences = {CrawlJumpSequences},

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
				--"nz_sprint_ad3",
				--"nz_sprint_ad4",
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
			},
			AttackSequences = {SprintAttackSequences},
			StandAttackSequences = {AttackSequences},
			CrawlAttackSequences = {CrawlAttackSequences},

			JumpSequences = {SprintJumpSequences},
			CrawlJumpSequences = {CrawlJumpSequences},

			PassiveSounds = {runsounds},
		},
		{
			SpawnSequence = {spawnfast},
			MovementSequence = {
				--"nz_legacy_sprint_v5",
				--"nz_legacy_jap_run_v3",
				"nz_sprint_au1",
				"nz_sprint_au2",
				--"nz_sprint_au3",
				--"nz_sprint_au4",
				"nz_sprint_au20",
				"nz_sprint_au21",
				"nz_sprint_au22",
				"nz_sprint_au25",
				"nz_fast_sprint_v3",
				"nz_fast_sprint_v4",
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
			},
			AttackSequences = {SprintAttackSequences},
			StandAttackSequences = {AttackSequences},
			CrawlAttackSequences = {CrawlAttackSequences},

			JumpSequences = {SprintJumpSequences},
			CrawlJumpSequences = {CrawlJumpSequences},

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
			},
			AttackSequences = {SuperSprintAttackSequences},
			StandAttackSequences = {AttackSequences},
			CrawlAttackSequences = {CrawlAttackSequences},

			JumpSequences = {SprintJumpSequences},
			CrawlJumpSequences = {CrawlJumpSequences},

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
			},
			AttackSequences = {SuperSprintAttackSequences},
			StandAttackSequences = {AttackSequences},
			CrawlAttackSequences = {CrawlAttackSequences},

			JumpSequences = {SprintJumpSequences},
			CrawlJumpSequences = {CrawlJumpSequences},

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
ENT.DanceSequence = "nz_goofyah_v"..math.random(1,6).."" -- Yes this plays... Where and how, I will not tell you!
ENT.AttackHitSounds = {
	"nz/zombies/attack/player_hit_0.wav",
	"nz/zombies/attack/player_hit_1.wav",
	"nz/zombies/attack/player_hit_2.wav",
	"nz/zombies/attack/player_hit_3.wav",
	"nz/zombies/attack/player_hit_4.wav",
	"nz/zombies/attack/player_hit_5.wav"
}

ENT.PainSounds = {
	"nz/zombies/death/nz_flesh_impact_1.wav",
	"nz/zombies/death/nz_flesh_impact_2.wav",
	"nz/zombies/death/nz_flesh_impact_3.wav",
	"nz/zombies/death/nz_flesh_impact_4.wav"
}

ENT.DeathSounds = {
	"nz_moo/zombies/vox/_classic/death/death_00.mp3",
	"nz_moo/zombies/vox/_classic/death/death_01.mp3",
	"nz_moo/zombies/vox/_classic/death/death_02.mp3",
	"nz_moo/zombies/vox/_classic/death/death_03.mp3",
	"nz_moo/zombies/vox/_classic/death/death_04.mp3",
	"nz_moo/zombies/vox/_classic/death/death_05.mp3",
	"nz_moo/zombies/vox/_classic/death/death_06.mp3",
	"nz_moo/zombies/vox/_classic/death/death_07.mp3",
	"nz_moo/zombies/vox/_classic/death/death_08.mp3",
	"nz_moo/zombies/vox/_classic/death/death_09.mp3",
	"nz_moo/zombies/vox/_classic/death/death_10.mp3"
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
	"nz_moo/zombies/vox/_classic/attack/attack_00.mp3",
	"nz_moo/zombies/vox/_classic/attack/attack_01.mp3",
	"nz_moo/zombies/vox/_classic/attack/attack_02.mp3",
	"nz_moo/zombies/vox/_classic/attack/attack_03.mp3",
	"nz_moo/zombies/vox/_classic/attack/attack_04.mp3",
	"nz_moo/zombies/vox/_classic/attack/attack_05.mp3",
	"nz_moo/zombies/vox/_classic/attack/attack_06.mp3",
	"nz_moo/zombies/vox/_classic/attack/attack_07.mp3",
	"nz_moo/zombies/vox/_classic/attack/attack_08.mp3",
	"nz_moo/zombies/vox/_classic/attack/attack_09.mp3",
	"nz_moo/zombies/vox/_classic/attack/attack_10.mp3",
	"nz_moo/zombies/vox/_classic/attack/attack_11.mp3",
	"nz_moo/zombies/vox/_classic/attack/attack_12.mp3",
	"nz_moo/zombies/vox/_classic/attack/attack_13.mp3",
	"nz_moo/zombies/vox/_classic/attack/attack_14.mp3",
	"nz_moo/zombies/vox/_classic/attack/attack_15.mp3"
}

ENT.BehindSoundDistance = 200 -- When the zombie is within 200 units of a player, play these sounds instead
ENT.BehindSounds = {
	Sound("nz_moo/zombies/vox/_classic/behind/behind_00.mp3"),
	Sound("nz_moo/zombies/vox/_classic/behind/behind_01.mp3"),
	Sound("nz_moo/zombies/vox/_classic/behind/behind_02.mp3"),
	Sound("nz_moo/zombies/vox/_classic/behind/behind_03.mp3"),
	Sound("nz_moo/zombies/vox/_classic/behind/behind_04.mp3"),
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

		--Preselect the emerge sequnces for clientside use
		self:SetBodygroup( 1 ,math.random(0,2))
		self:SetBodygroup( 2 , math.random(0,4))
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
		[MAT_SLOSH] = "nz_moo/zombies/spawn/snow/pfx_zm_spawn_mud_00.mp3",
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

	self:SolidMaskDuringEvent(MASK_SOLID_BRUSHONLY)
	ParticleEffect("bo3_zombie_spawn",self:GetPos()+Vector(0,0,1),self:GetAngles(),self)
	ParticleEffect("impact_antlion",self:GetPos()+Vector(0,0,-4),self:GetAngles(),self)

	self:EmitSound("nz/zombies/spawn/zm_spawn_dirt"..math.random(1,2)..".wav",80,math.random(95,105))

	self:Sound()

	self:SetSpecialAnimation(true)
	local seq = self:SelectSpawnSequence()
	if seq then
		self:PlaySequenceAndWait(seq)
		self:SetSpecialAnimation(false)
		self:CollideWhenPossible()
	end
end
