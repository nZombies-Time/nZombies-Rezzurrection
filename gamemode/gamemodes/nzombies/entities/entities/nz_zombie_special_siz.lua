AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.Type = "nextbot"
ENT.PrintName = "Sizzlers"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo"
ENT.Spawnable = true

if CLIENT then 

	function ENT:DrawEyeGlow()
		local eyeColor = Color(0,0,0)
		local nocolor = Color(0,0,0)

		if eyeColor == nocolor then return end
	end

	return 
end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.IsMooSpecial = false

ENT.MinSoundPitch 			= 80
ENT.MaxSoundPitch 			= 110
ENT.SoundVolume 			= 90

ENT.Models = {
	{Model = "models/moo/_codz_ports/s2/zombie/moo_codz_s2_zom_sizzler_3arc.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"nz_ent_ground_01", "nz_ent_ground_02"}

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

local RunAttackSequences = {
	{seq = "nz_t8_attack_supersprint_larm_1"},
	{seq = "nz_t8_attack_supersprint_larm_2"},
	{seq = "nz_t8_attack_supersprint_rarm_1"},
	{seq = "nz_t8_attack_supersprint_rarm_2"},
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
	Sound("nz_moo/zombies/vox/mute_00.wav"),
}

local runsounds = {
	Sound("nz_moo/zombies/vox/_siz/zmb_vox_siz_shriek2_01.mp3"),
	Sound("nz_moo/zombies/vox/_siz/zmb_vox_siz_shriek2_02.mp3"),
	Sound("nz_moo/zombies/vox/_siz/zmb_vox_siz_shriek2_03.mp3"),
	Sound("nz_moo/zombies/vox/_siz/zmb_vox_siz_shriek2_04.mp3"),
	Sound("nz_moo/zombies/vox/_siz/zmb_vox_siz_shriek2_05.mp3"),
	Sound("nz_moo/zombies/vox/_siz/zmb_vox_siz_shriek2_06.mp3"),
	Sound("nz_moo/zombies/vox/_siz/zmb_vox_siz_shriek2_07.mp3"),
	Sound("nz_moo/zombies/vox/_siz/zmb_vox_siz_shriek2_08.mp3"),
	Sound("nz_moo/zombies/vox/_siz/zmb_vox_siz_shriek2_09.mp3"),
	Sound("nz_moo/zombies/vox/_siz/zmb_vox_siz_shriek2_10.mp3"),
}

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"nz_s2_core_walk_v10",
				"nz_s2_core_walk_v11",
				"nz_s2_core_walk_v12",
				"nz_firestaff_walk_v3",
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

			JumpSequences = {SprintJumpSequences},
			CrawlJumpSequences = {CrawlJumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 71, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"nz_s2_siz_slow_sprint_v1",
				"nz_s2_siz_slow_sprint_v2",
				"nz_s2_siz_slow_sprint_v3",
				"nz_s2_siz_slow_sprint_v4",
				"nz_s2_siz_sprint_v1",
				"nz_s2_siz_sprint_v2",
				"nz_s2_siz_sprint_v3",
				"nz_s2_siz_sprint_v4",
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

			JumpSequences = {SprintJumpSequences},
			CrawlJumpSequences = {CrawlJumpSequences},
			PassiveSounds = {runsounds},
		},
	}},
}

ENT.IdleSequence = "nz_iw7_cp_zom_stand_idle_01"

ENT.IdleSequenceAU = "nz_iw7_cp_zom_stand_idle_02"

ENT.TauntSequences = {
	"nz_taunt_v1",
	"nz_taunt_v2",
	"nz_taunt_v3",
	"nz_taunt_v4",
	"nz_taunt_v5",
	"nz_taunt_v6",
	"nz_taunt_v8",
	"nz_taunt_v9"
}


ENT.SizTauntSequences = {
	"nz_taunt_v7",
	"nz_l4d_violentalert_f",
	"nz_legacy_taunt_v1",
}

ENT.DeathSounds = {
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_death_01.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_death_02.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_death_03.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_death_04.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_death_05.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_death_06.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_death_07.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_death_08.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_death_09.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_death_10.mp3"),
}

ENT.ElecSounds = {
	Sound("nz_moo/zombies/vox/_siz/zmb_vox_siz_trans_shriek_01.mp3"),
	Sound("nz_moo/zombies/vox/_siz/zmb_vox_siz_trans_shriek_02.mp3"),
	Sound("nz_moo/zombies/vox/_siz/zmb_vox_siz_trans_shriek_03.mp3"),
	Sound("nz_moo/zombies/vox/_siz/zmb_vox_siz_trans_shriek_04.mp3"),
}

ENT.AttackSounds = {
	Sound("nz_moo/zombies/vox/_siz/zmb_vox_siz_attack_hit_01.mp3"),
	Sound("nz_moo/zombies/vox/_siz/zmb_vox_siz_stand_attack_v1_01.mp3"),
	Sound("nz_moo/zombies/vox/_siz/zmb_vox_siz_stand_attack_v1_02.mp3"),
	Sound("nz_moo/zombies/vox/_siz/zmb_vox_siz_stand_attack_v1_03.mp3"),
	Sound("nz_moo/zombies/vox/_siz/zmb_vox_siz_stand_attack_v1_04.mp3"),
}

ENT.SpawnSounds = {
	Sound("nz_moo/zombies/vox/_siz/zmb_vox_siz_convert_01.mp3"),
	Sound("nz_moo/zombies/vox/_siz/zmb_vox_siz_convert_02.mp3"),
	Sound("nz_moo/zombies/vox/_siz/zmb_vox_siz_convert_03.mp3"),
	Sound("nz_moo/zombies/vox/_siz/zmb_vox_siz_convert_04.mp3"),
}

ENT.FootstepsSounds = {
	"nz_moo/zombies/vox/_napalm/step/fly_step_napalm_close_00.mp3",
	"nz_moo/zombies/vox/_napalm/step/fly_step_napalm_close_01.mp3",
	"nz_moo/zombies/vox/_napalm/step/fly_step_napalm_close_02.mp3",
	"nz_moo/zombies/vox/_napalm/step/fly_step_napalm_close_03.mp3",
	"nz_moo/zombies/vox/_napalm/step/fly_step_napalm_close_04.mp3",
	"nz_moo/zombies/vox/_napalm/step/fly_step_napalm_close_05.mp3"
}

ENT.SWTFootstepsSounds = {
	"nz_moo/zombies/vox/_mutated/step/fire/step_00.mp3",
	"nz_moo/zombies/vox/_mutated/step/fire/step_01.mp3",
	"nz_moo/zombies/vox/_mutated/step/fire/step_02.mp3",
	"nz_moo/zombies/vox/_mutated/step/fire/step_03.mp3",
	"nz_moo/zombies/vox/_mutated/step/fire/step_04.mp3",
	"nz_moo/zombies/vox/_mutated/step/fire/step_05.mp3",
	"nz_moo/zombies/vox/_mutated/step/fire/step_06.mp3",
	"nz_moo/zombies/vox/_mutated/step/fire/step_07.mp3",
	"nz_moo/zombies/vox/_mutated/step/fire/step_08.mp3"
}

ENT.BehindSoundDistance = 0 -- When the zombie is within 200 units of a player, play these sounds instead
ENT.BehindSounds = {
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_sneak_attack_01.mp3"),
}

function ENT:StatsInitialize()
	if SERVER then
		self:SetRunSpeed( 1 )

		self.UseCustomAttackDamage = true
		self.HasSTaunted = true
		self.SizIgnite = false
		self.EnrageTime = CurTime() + math.random(2,7)

		self.TimesAttacks = 0

		local health = nzRound:GetZombieHealth()
		self:SetHealth( nzRound:GetZombieHealth() * 0.25 or 200)
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
	end

	if IsValid(self.SpawnIndex) then
		local stype = self.SpawnIndex:GetSpawnType()
		if stype == 0 or stype == 11 then
			self:EmitSound("ambient/energy/weld"..math.random(2)..".wav",100,math.random(95,105))
			self:EmitSound("nz_moo/zombies/gibs/head/_og/zombie_head_0"..math.random(0,2)..".mp3", 65, math.random(95,105))
			self:EmitSound("nz_moo/zombies/gibs/gib_0"..math.random(0,3)..".mp3", 100, math.random(95,105))
			if IsValid(self) then ParticleEffect("wwii_spawn_main", self:GetPos() + Vector(0,0,0), Angle(0,0,0), self) end
			if IsValid(self) then ParticleEffect("wwii_spawn_embers", self:GetPos() + Vector(0,0,0), Angle(0,0,0), self) end
			if IsValid(self) then ParticleEffect("wwii_spawn_blood", self:GetPos() + Vector(0,0,0), Angle(0,0,0), self) end
			if IsValid(self) then ParticleEffect("wwii_spawn_elec", self:GetPos() + Vector(0,0,20), Angle(0,0,0), self) end
		end
	else
		self:EmitSound("ambient/energy/weld"..math.random(2)..".wav",100,math.random(95,105))
		self:EmitSound("nz_moo/zombies/gibs/head/_og/zombie_head_0"..math.random(0,2)..".mp3", 65, math.random(95,105))
		self:EmitSound("nz_moo/zombies/gibs/gib_0"..math.random(0,3)..".mp3", 100, math.random(95,105))
		if IsValid(self) then ParticleEffect("wwii_spawn_main", self:GetPos() + Vector(0,0,0), Angle(0,0,0), self) end
		if IsValid(self) then ParticleEffect("wwii_spawn_embers", self:GetPos() + Vector(0,0,0), Angle(0,0,0), self) end
		if IsValid(self) then ParticleEffect("wwii_spawn_blood", self:GetPos() + Vector(0,0,0), Angle(0,0,0), self) end
		if IsValid(self) then ParticleEffect("wwii_spawn_elec", self:GetPos() + Vector(0,0,20), Angle(0,0,0), self) end
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

function ENT:AI()
	local tar = self:GetTarget()
	if IsValid(tar) then
		if (self:TargetInRange(950) and !self:IsAttackBlocked() or CurTime() > self.EnrageTime) and !self.SizIgnite then
			
			self.SizIgnite = true
			self:SetRunSpeed(71)
			self:SpeedChanged()

			self:DoSpecialAnimation(self.SizTauntSequences[math.random(#self.SizTauntSequences)], true, true)

			util.SpriteTrail(self, 9, Color(255, 45, 0, 255), true, 45, 20, 0.75, 1 / 40 * 0.3, "materials/trails/plasma")
		end
	end
end

function ENT:CustomAttackDamage(target, dmg) 
	local dmgInfo = DamageInfo()
	dmgInfo:SetAttacker( self )
	dmgInfo:SetDamage( dmg )
	dmgInfo:SetDamageType( DMG_BURN )

	target:TakeDamageInfo(dmgInfo)
	target:Ignite(1, 0)

	if math.random(100) > 50 and self.TimesAttacks > 3 then
		self:TakeDamage(self:Health() + 666, self, self)
	else
		self.TimesAttacks = self.TimesAttacks + 1
	end

end

function ENT:PostDeath(dmginfo)
	self:Explode(45, true)
end

function ENT:HandleAnimEvent(a,b,c,d,e) -- Moo Mark 4/14/23: You don't know how sad I am that I didn't know about this sooner.
	if e == "step_right_small" then
		self:EmitSound(self.FootstepsSounds[math.random(#self.FootstepsSounds)], 85)
		self:EmitSound(self.SWTFootstepsSounds[math.random(#self.SWTFootstepsSounds)], 70)
		ParticleEffectAttach("bo3_napalm_fs",PATTACH_POINT,self,12)
	end
	if e == "step_left_small" then
		self:EmitSound(self.FootstepsSounds[math.random(#self.FootstepsSounds)], 85)
		self:EmitSound(self.SWTFootstepsSounds[math.random(#self.SWTFootstepsSounds)], 70)
		ParticleEffectAttach("bo3_napalm_fs",PATTACH_POINT,self,11)
	end
	if e == "step_right_large" then
		self:EmitSound(self.FootstepsSounds[math.random(#self.FootstepsSounds)], 85)
		self:EmitSound(self.SWTFootstepsSounds[math.random(#self.SWTFootstepsSounds)], 70)
		ParticleEffectAttach("bo3_napalm_fs",PATTACH_POINT,self,12)
	end
	if e == "step_left_large" then
		self:EmitSound(self.FootstepsSounds[math.random(#self.FootstepsSounds)], 85)
		self:EmitSound(self.SWTFootstepsSounds[math.random(#self.SWTFootstepsSounds)], 70)
		ParticleEffectAttach("bo3_napalm_fs",PATTACH_POINT,self,11)
	end
	if e == "crawl_hand" then
		if self.CustomCrawlImpactSounds then
			self:EmitSound(self.CrawlImpactSounds[math.random(#self.CrawlImpactSounds)], 70)
		else
			self:EmitSound("CoDZ_Zombie.StepCrawl")
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
	if e == "base_ranged_rip" then
		ParticleEffectAttach("ins_blood_dismember_limb", 4, self, 5)
		self:EmitSound("nz_moo/zombies/gibs/gib_0"..math.random(0,3)..".mp3", 100, math.random(95,105))
		self:EmitSound("nz_moo/zombies/gibs/head/head_explosion_0"..math.random(4)..".mp3", 65, math.random(95,105))
	end
	if e == "base_ranged_throw" then
		self:EmitSound("nz_moo/zombies/fly/attack/whoosh/zmb_attack_med_0"..math.random(0,2)..".mp3", 95)

		local larmfx_tag = self:LookupBone("j_wrist_le")

		self.Guts = ents.Create("nz_gib")
		self.Guts:SetPos(self:GetBonePosition(larmfx_tag))
		self.Guts:Spawn()

		local phys = self.Guts:GetPhysicsObject()
		local target = self:GetTarget()
		local movementdir
		if IsValid(phys) and IsValid(target) then
			--[[if target:IsPlayer() then
				movementdir = target:GetVelocity():Normalize()
				print(movementdir)
			end]]
			phys:SetVelocity(self.Guts:getvel(target:EyePos() - Vector(0,0,7), self:EyePos(), 0.95))
		end
	end
	if e == "pull_plank" then
		if IsValid(self) and self:Alive() then
			if IsValid(self.BarricadePlankPull) and IsValid(self.Barricade) then
				self.Barricade:RemovePlank(self.BarricadePlankPull)
			end
		end
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

	-- WW2 Zobies	
	if e == "s2_gen_step" then
		self:EmitSound(self.StepSounds[math.random(#self.StepSounds)], 60, math.random(95, 105))
	end
	if e == "s2_taunt_vox" then
		self:EmitSound(self.TauntSounds[math.random(#self.TauntSounds)],95, math.random(95, 105), 1, 2)
	end

	-- Taunt Sounds, theres alot of these

	if e == "generic_taunt" then
		if self.TauntSounds and !self.Screamed then
			self.Screamed = true
			self:EmitSound(self.SpawnSounds[math.random(#self.SpawnSounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		end
	end
	if e == "special_taunt" then
		if self.CustomSpecialTauntSounds then
			self:EmitSound(self.CustomSpecialTauntSounds[math.random(#self.CustomSpecialTauntSounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		else
			self:EmitSound("nz_moo/zombies/vox/_classic/taunt/spec_taunt.mp3", 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		end
	end
	if e == "anim_taunt_v1" then
		if self.CustomTauntAnimV1Sounds then
			self:EmitSound(self.CustomTauntAnimV1Sounds[math.random(#self.CustomTauntAnimV1Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		else
			self:EmitSound(self.TauntAnimV1Sounds[math.random(#self.TauntAnimV1Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		end
	end
	if e == "anim_taunt_v2" then
		if self.CustomTauntAnimV2Sounds then
			self:EmitSound(self.CustomTauntAnimV2Sounds[math.random(#self.CustomTauntAnimV2Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		else
			self:EmitSound(self.TauntAnimV2Sounds[math.random(#self.TauntAnimV2Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		end
	end
	if e == "anim_taunt_v3" then
		if self.CustomTauntAnimV2Sounds then
			self:EmitSound(self.CustomTauntAnimV3Sounds[math.random(#self.CustomTauntAnimV3Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		else
			self:EmitSound(self.TauntAnimV3Sounds[math.random(#self.TauntAnimV3Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		end
	end
	if e == "anim_taunt_v4" then
		if self.CustomTauntAnimV4Sounds then
			self:EmitSound(self.CustomTauntAnimV4Sounds[math.random(#self.CustomTauntAnimV4Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		else
			self:EmitSound(self.TauntAnimV4Sounds[math.random(#self.TauntAnimV4Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		end
	end
	if e == "anim_taunt_v5" then
		if self.CustomTauntAnimV5Sounds then
			self:EmitSound(self.CustomTauntAnimV5Sounds[math.random(#self.CustomTauntAnimV5Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		else
			self:EmitSound(self.TauntAnimV5Sounds[math.random(#self.TauntAnimV5Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		end
	end
	if e == "anim_taunt_v6" then
		if self.CustomTauntAnimV6Sounds then
			self:EmitSound(self.CustomTauntAnimV6Sounds[math.random(#self.CustomTauntAnimV6Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		else
			self:EmitSound(self.TauntAnimV6Sounds[math.random(#self.TauntAnimV6Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		end
	end
	if e == "anim_taunt_v7" then
		if self.CustomTauntAnimV7Sounds then
			self:EmitSound(self.CustomTauntAnimV7Sounds[math.random(#self.CustomTauntAnimV7Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		else
			self:EmitSound(self.SpawnSounds[math.random(#self.SpawnSounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		end
	end
	if e == "anim_taunt_v8" then
		if self.CustomTauntAnimV8Sounds then
			self:EmitSound(self.CustomTauntAnimV8Sounds[math.random(#self.CustomTauntAnimV8Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		else
			self:EmitSound(self.TauntAnimV8Sounds[math.random(#self.TauntAnimV8Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		end
	end
	if e == "anim_taunt_v9" then
		if self.CustomTauntAnimV9Sounds then
			self:EmitSound(self.CustomTauntAnimV9Sounds[math.random(#self.CustomTauntAnimV9Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		else
			self:EmitSound(self.TauntAnimV9Sounds[math.random(#self.TauntAnimV9Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		end
	end
end