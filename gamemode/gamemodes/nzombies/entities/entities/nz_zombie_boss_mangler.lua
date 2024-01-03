AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "The Mangle... er"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo"

if CLIENT then return end -- Client doesn't really need anything beyond the basics

local util_traceline = util.TraceLine
local util_tracehull = util.TraceHull

ENT.RedEyes = false
ENT.SpeedBasedSequences = true

ENT.IsMooZombie = true
ENT.IsMooSpecial = true
ENT.IsMooBossZombie = true

ENT.AttackRange = 95
ENT.DamageRange = 95

ENT.AttackDamage = 50
ENT.HeavyAttackDamage = 95

ENT.MinSoundPitch = 95
ENT.MaxSoundPitch = 105

ENT.SoundDelayMin = 10
ENT.SoundDelayMax = 12

ENT.Models = {
	{Model = "models/moo/_codz_ports/t7/stalingrad/moo_codz_t7_dlc3_raz.mdl", Skin = 0, Bodygroups = {0,0}},
}

ENT.DeathSequences = {
	"nz_raz_death_collapse_fallback_1",
	"nz_raz_death_collapse_fallback_2",
	"nz_raz_death_collapse_fallforward_1",
}

ENT.BarricadeTearSequences = {}

local JumpSequences = {
	{seq = "nz_raz_mantle_over_36"},
}

local AttackSequences = {
	{seq = "nz_raz_attack_double_swing_1"},
	{seq = "nz_raz_attack_double_swing_2"},
	{seq = "nz_raz_attack_swing_l_to_r"},
	{seq = "nz_raz_attack_swing_r_to_l"},
	{seq = "nz_raz_attack_sickle_double_swing_1"},
	{seq = "nz_raz_attack_sickle_double_swing_2"},
	{seq = "nz_raz_attack_sickle_double_swing_3"},
	{seq = "nz_raz_attack_sickle_swing_down"},
	{seq = "nz_raz_attack_sickle_swing_l_to_r"},
	{seq = "nz_raz_attack_sickle_swing_r_to_l"},
	{seq = "nz_raz_attack_sickle_swing_uppercut"},
}

local RunAttackSequences = {
	{seq = "nz_raz_attack_sprint"},
}

local walksounds = {
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/amb_00.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/amb_01.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/amb_02.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/amb_03.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/amb_04.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/amb_05.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/amb_06.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/amb_07.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/amb_08.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/amb_09.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/amb_10.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/amb_11.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/amb_12.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/amb_13.mp3"),
}

ENT.NormalMantleOver48 = {
	"nz_raz_mantle_over_48",
}

ENT.NormalMantleOver72 = {
	"nz_raz_mantle_over_72",
}

ENT.NormalMantleOver96 = {
	"nz_raz_mantle_over_96",
}

ENT.NormalMantleOver128 = {
	"nz_raz_mantle_over_128",
}

ENT.NormalJumpUp128 = {
	"nz_raz_jump_up_128",
}

ENT.NormalJumpUp128Quick = {
	"nz_raz_jump_up_128",
}

ENT.NormalJumpDown128 = {
	"nz_raz_jump_down_128",
}

ENT.ShootSequences = {
	--"nz_raz_attack_shoot",
	"nz_t9_raz_attack_shoot",
}

ENT.IdleSequence = "nz_raz_idle"
ENT.IdleSequenceAU = "nz_raz_idle_look_around"

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			MovementSequence = {
				"nz_raz_walk",
			},
			StandAttackSequences = {AttackSequences},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 71, Sequences = {
		{
			MovementSequence = {
				--"nz_raz_sprint",
				"nz_t9_raz_sprint",
			},
			StandAttackSequences = {AttackSequences},
			AttackSequences = {RunAttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}}
}

ENT.EnrageSounds = {
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/rage/rage_00.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/rage/rage_01.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/rage/rage_02.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/rage/rage_03.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/rage/rage_04.mp3"),
}

ENT.CustomMeleeWhooshSounds = {
	Sound("nz_moo/zombies/vox/_raz/melee/swing/melee_swing_00.mp3"),
	Sound("nz_moo/zombies/vox/_raz/melee/swing/melee_swing_01.mp3"),
	Sound("nz_moo/zombies/vox/_raz/melee/swing/melee_swing_02.mp3"),
	Sound("nz_moo/zombies/vox/_raz/melee/swing/melee_swing_03.mp3"),
}

ENT.WalkFootstepsSounds = {
	Sound("nz_moo/zombies/vox/_raz/step/step_00.mp3"),
	Sound("nz_moo/zombies/vox/_raz/step/step_01.mp3"),
	Sound("nz_moo/zombies/vox/_raz/step/step_02.mp3"),
}

ENT.WalkFootstepsGearSounds = {
	Sound("nz_moo/zombies/vox/_raz/gear/gear_00.mp3"),
	Sound("nz_moo/zombies/vox/_raz/gear/gear_01.mp3"),
	Sound("nz_moo/zombies/vox/_raz/gear/gear_02.mp3"),
	Sound("nz_moo/zombies/vox/_raz/gear/gear_03.mp3"),
	Sound("nz_moo/zombies/vox/_raz/gear/gear_04.mp3"),
	Sound("nz_moo/zombies/vox/_raz/gear/gear_05.mp3"),
	Sound("nz_moo/zombies/vox/_raz/gear/gear_06.mp3"),
	Sound("nz_moo/zombies/vox/_raz/gear/gear_07.mp3"),
	Sound("nz_moo/zombies/vox/_raz/gear/gear_08.mp3"),
	Sound("nz_moo/zombies/vox/_raz/gear/gear_09.mp3"),
}

ENT.ArmCannonShootSounds = {
	Sound("nz_moo/zombies/vox/_raz/mangler/shot/fire_00.mp3"),
	Sound("nz_moo/zombies/vox/_raz/mangler/shot/fire_01.mp3"),
	Sound("nz_moo/zombies/vox/_raz/mangler/shot/fire_02.mp3"),
	Sound("nz_moo/zombies/vox/_raz/mangler/shot/fire_03.mp3"),
}

ENT.PainSounds = {
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/pain/pain_00.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/pain/pain_01.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/pain/pain_02.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/pain/pain_03.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/pain/pain_04.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/pain/pain_05.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/pain/pain_06.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/pain/pain_07.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/pain/pain_08.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/pain/pain_09.mp3"),
}

ENT.DeathSounds = {
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/death/death_00.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/death/death_01.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/death/death_02.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/death/death_03.mp3"),
}

ENT.DeathExploSounds = {
	Sound("nz_moo/zombies/vox/_raz/death/warlord_death_00.mp3"),
	Sound("nz_moo/zombies/vox/_raz/death/warlord_death_01.mp3"),
	Sound("nz_moo/zombies/vox/_raz/death/warlord_death_02.mp3"),
	Sound("nz_moo/zombies/vox/_raz/death/warlord_death_03.mp3"),
}

ENT.ManglerLinesSounds = {
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/lines/I_will_destroy.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/lines/bleed_break_burn.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/lines/death_will_come.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/lines/eliminate_all_threats.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/lines/enemy_will_be_crushed.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/lines/exterminate_all_enemies.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/lines/find_them_kill_all.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/lines/will_not_be_destroyed.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/lines/find_them_kill_all.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/lines/you_are_weak_creatures.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/lines/your_land_will_be_our_land.mp3"),
}

ENT.MangleTauntSounds = {
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/lines/feast_minions.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/lines/bleed_them_dry.mp3"),
}

ENT.RadioSounds = {
	Sound("nz_moo/zombies/vox/_raz/_t9/ambient_radio/raz_ambient_00.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/ambient_radio/raz_ambient_01.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/ambient_radio/raz_ambient_02.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/ambient_radio/raz_ambient_03.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/ambient_radio/raz_ambient_04.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/ambient_radio/raz_ambient_05.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/ambient_radio/raz_ambient_06.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/ambient_radio/raz_ambient_07.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/ambient_radio/raz_ambient_08.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/ambient_radio/raz_ambient_09.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/ambient_radio/raz_ambient_10.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/ambient_radio/raz_ambient_11.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/ambient_radio/raz_ambient_12.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/ambient_radio/raz_ambient_13.mp3"),
}

ENT.AttackSounds = {
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_00.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_01.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_02.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_03.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_04.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_05.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_06.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_07.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_08.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_09.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_10.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_11.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_12.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_13.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_14.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_15.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_16.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_17.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_18.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_19.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_20.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_21.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_22.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_23.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_24.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_25.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_26.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_27.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_28.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_29.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_30.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_31.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_32.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_33.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_34.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_35.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_36.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_37.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_38.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_39.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_40.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_41.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_42.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_43.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/attack/attack_44.mp3"),
}

ENT.MumbleSounds = {
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_00.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_01.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_02.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_03.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_04.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_05.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_06.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_07.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_08.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_09.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_10.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_11.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_12.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_13.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_14.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_15.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_16.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_17.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_18.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_19.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_20.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_21.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_22.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_23.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_24.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_25.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_26.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_27.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_28.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_29.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_30.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_31.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_32.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_33.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_34.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_35.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_36.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_37.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_38.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_39.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_40.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_41.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_42.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/amb/mumble/mumble_43.mp3"),
}

ENT.BehindSoundDistance = 0 -- When the zombie is within 200 units of a player, play these sounds instead

function ENT:StatsInitialize()
	if SERVER then
		local count = #player.GetAllPlaying()

		if nzRound:InState( ROUND_CREATE ) then
			self:SetHealth(1000)
			self:SetMaxHealth(1000)
		else
			if nzRound:InState( ROUND_PROG ) then
				self:SetHealth(math.Clamp(nzRound:GetNumber() * 950 + (500 * count), 1000, 55000 * count))
				self:SetMaxHealth(math.Clamp(nzRound:GetNumber() * 950 + (500 * count), 1000, 55000 * count))
			else
				self:SetHealth(5000)
				self:SetMaxHealth(5000)	
			end
		end

		self.NextShoot = CurTime() + 3
		self.ArmCannon = true
		self.ArmCannonHP = math.Clamp(self:GetMaxHealth() / 4, 250, 1500)

		self.Helmet = true
		self.HelmetHP = math.Clamp(self:GetMaxHealth() / 5, 250, 1000)

		self.Chest = true
		self.ChestHP = math.Clamp(self:GetMaxHealth() / 5, 250, 1000)

		self.ShouldEnrage = false
		self.Enraged = false

		self.RadioSoundTime = CurTime() + 5

		self.CannonInspect = CurTime() + 5

		self.CanCancelAttack = true

		self:SetRunSpeed(1)
	end
end

function ENT:SpecialInit()
	if CLIENT then
	end
end

function ENT:OnSpawn()
	self:SetCollisionBounds(Vector(-22,-22, 0), Vector(22, 22, 80))

	local effectData = EffectData()
	effectData:SetOrigin( self:GetPos() + Vector(0, 0, 50)  )
	effectData:SetMagnitude( 1 )
	effectData:SetEntity(nil)
	util.Effect("panzer_spawn_tp", effectData)
	
	self:SolidMaskDuringEvent(MASK_SOLID_BRUSHONLY)

	self:EmitSound("nz_moo/zombies/vox/_raz/_t9/spawn.mp3", 577)

	self:TimeOut(2)

	self:CollideWhenPossible()
end

function ENT:AI()
	if CurTime() > self.NextShoot and self.ArmCannon then
		if !self:IsAttackBlocked() and self:TargetInRange(500) and !self:TargetInRange(150) then
			self:TempBehaveThread(function(self)
				self.NextShoot = CurTime() + math.random(7,10)

				self:SetSpecialAnimation(true)
				self:PlaySequenceAndMove(self.ShootSequences[math.random(#self.ShootSequences)], 1, self.FaceEnemy)
				self:StopParticles()
				self:SetSpecialAnimation(false)
			end)
		end
	end

	-- Radio Sounds
	if CurTime() > self.RadioSoundTime then
		local snd = self.RadioSounds[math.random(#self.RadioSounds)]
		local dur = SoundDuration(snd)

		self:EmitSound(snd, 55, math.random(95, 105))

		self.RadioSoundTime = CurTime() + dur + math.random(5)
	end

	-- Random Spark
	if math.random(10) <= 3 and !self.ArmCannon then
		self:ArmCannonSpark()
	end

	-- Stim Inspect
	if CurTime() > self.CannonInspect and self.ArmCannon and !self:HasTarget() then
		self:EmitSound("nz_moo/zombies/vox/_raz/_t9/flourish_cannon.mp3",75)
		self:DoSpecialAnimation("nz_raz_idle_twitch_check")
		self.CannonInspect = CurTime() + math.random(8,15)
	end
end

function ENT:Sound()
	if self:GetAttacking() or !self:Alive() or self:GetDecapitated() then return end

	local vol = self.SoundVolume

	local chance = math.random(100)

	for k,v in nzLevel.GetZombieArray() do -- FUCK YOU, ARRAYS ARE AWESOME!!!
		if k < 2 then vol = 511 else vol = self.SoundVolume end
	end

	if !self:HasTarget() then
		self:PlaySound(self.MumbleSounds[math.random(#self.MumbleSounds)],vol, math.random(self.MinSoundPitch, self.MaxSoundPitch), 1, 2)
	elseif chance < 25 then
		self:PlaySound(self.ManglerLinesSounds[math.random(#self.ManglerLinesSounds)],vol, math.random(self.MinSoundPitch, self.MaxSoundPitch), 1, 2)
	elseif self.PassiveSounds then
		self:PlaySound(self.PassiveSounds[math.random(#self.PassiveSounds)],vol, math.random(self.MinSoundPitch, self.MaxSoundPitch), 1, 2)
	else

		-- We still delay by max sound delay even if there was no sound to play
		self.NextSound = CurTime() + self.SoundDelayMax
	end
end

function ENT:PerformDeath(dmginfo)
		
	self.Dying = true

	local damagetype = dmginfo:GetDamageType()

	self:PostDeath(dmginfo)

	self:PlaySound(self.PainSounds[math.random(#self.PainSounds)], 90, math.random(85, 105), 1, 2)
	self:Explode(25)

	self:ManipulateBoneScale(self:LookupBone("j_head_attach"), Vector(0.00001,0.00001,0.00001))
	self:ManipulateBoneScale(self:LookupBone("j_spine4_attach"), Vector(0.00001,0.00001,0.00001))
	ParticleEffectAttach("bo3_explosion_micro", PATTACH_POINT_FOLLOW, self, 9)

	if damagetype == DMG_MISSILEDEFENSE or damagetype == DMG_ENERGYBEAM then
		self:BecomeRagdoll(dmginfo) -- Only Thundergun and Wavegun Ragdolls constantly.
	end
	if damagetype == DMG_REMOVENORAGDOLL then
		self:Remove(dmginfo)
	end
	if self.DeathRagdollForce == 0 or self:GetSpecialAnimation() then
		self:BecomeRagdoll(dmginfo)
	else
		self:DoDeathAnimation(self.DeathSequences[math.random(#self.DeathSequences)])
	end
end

function ENT:Explode(dmg)
    dmg = dmg or 50

    if SERVER then
        local pos = self:WorldSpaceCenter()
        local targ = self:GetTarget()

        local attacker = self
        local inflictor = self

       	if IsValid(targ) and targ.GetActiveWeapon then
            attacker = targ
            if IsValid(targ:GetActiveWeapon()) then
                inflictor = targ:GetActiveWeapon()
            end
        end

        local tr = {
            start = pos,
            filter = self,
            mask = MASK_NPCSOLID_BRUSHONLY
        }

        for k, v in pairs(ents.FindInSphere(pos, 200)) do
            if v:IsPlayer() or v:IsNPC() or v:IsNextBot() then
                if v:GetClass() == self:GetClass() then continue end
                if v == self then continue end
                if v:EntIndex() == self:EntIndex() then continue end
                if v:Health() <= 0 then continue end
                --if !v:Alive() then continue end
                tr.endpos = v:WorldSpaceCenter()
                local tr1 = util_traceline(tr)
                if tr1.HitWorld then continue end

                local expdamage = DamageInfo()
                expdamage:SetAttacker(attacker)
                expdamage:SetInflictor(inflictor)
                expdamage:SetDamageType(DMG_BLAST)

                local distfac = pos:Distance(v:WorldSpaceCenter())
                distfac = 1 - math.Clamp((distfac/200), 0, 1)
                expdamage:SetDamage(dmg * distfac)

                expdamage:SetDamageForce(v:GetUp()*5000 + (v:GetPos() - self:GetPos()):GetNormalized() * 10000)

                v:TakeDamageInfo(expdamage)
            end
        end

        local effectdata = EffectData()
        effectdata:SetOrigin(self:GetPos())

        util.Effect("HelicopterMegaBomb", effectdata)
        util.Effect("Explosion", effectdata)

        self:EmitSound(self.DeathExploSounds[math.random(#self.DeathExploSounds)],70)

        util.ScreenShake(self:GetPos(), 20, 255, 1.5, 400)
    end
end

function ENT:OnTakeDamage(dmginfo)
	local attacker = dmginfo:GetAttacker()
	local inflictor = dmginfo:GetInflictor()

	local hitpos = dmginfo:GetDamagePosition()
	local hitgroup = util.QuickTrace(hitpos, hitpos).HitGroup
	local hitforce = dmginfo:GetDamageForce()

	local damage = dmginfo:GetDamage()

	local armpos = self:GetBonePosition(self:LookupBone("j_weapon_spin"))
	local headpos = self:GetBonePosition(self:LookupBone("j_head_attach"))
	local chestpos = self:GetBonePosition(self:LookupBone("j_spine4_attach"))

	if (hitpos:DistToSqr(headpos) < 20^2) then
		if self.Helmet and self.HelmetHP > 0 then
			self.HelmetHP = self.HelmetHP - damage
			dmginfo:ScaleDamage(0.15)
		elseif self.Helmet and self.HelmetHP <= 0 then
			self.Helmet = false
			
        	self:EmitSound(self.DeathExploSounds[math.random(#self.DeathExploSounds)],70)

			self:ManipulateBoneScale(self:LookupBone("j_head_attach"), Vector(0.00001,0.00001,0.00001))
			ParticleEffectAttach("bo3_explosion_micro", PATTACH_POINT_FOLLOW, self, 10)

			self:TempBehaveThread(function(self)
				self:SetSpecialAnimation(true)
				self:PlaySequenceAndMove("nz_raz_pain_chest_armor", 1)
				self:SetSpecialAnimation(false)
			end)
		else
			dmginfo:ScaleDamage(0.25)
		end
	end

	if (hitpos:DistToSqr(chestpos) < 30^2) then
		if self.Chest and self.ChestHP > 0 then
			self.ChestHP = self.ChestHP - damage
			dmginfo:ScaleDamage(0.15)
		elseif self.Chest and self.ChestHP <= 0 then
			self.Chest = false
			
        	self:EmitSound(self.DeathExploSounds[math.random(#self.DeathExploSounds)],70)

			self:ManipulateBoneScale(self:LookupBone("j_spine4_attach"), Vector(0.00001,0.00001,0.00001))
			ParticleEffectAttach("bo3_explosion_micro", PATTACH_POINT_FOLLOW, self, 9)

			self:TempBehaveThread(function(self)
				self:SetSpecialAnimation(true)
				self:PlaySequenceAndMove("nz_raz_pain_chest_armor", 1)
				self:SetSpecialAnimation(false)
			end)
		else
			dmginfo:ScaleDamage(0.25)
		end
	end

	if (hitpos:DistToSqr(armpos) < 20^2) then
		if self.ArmCannon and self.ArmCannonHP > 0 then
			self.ArmCannonHP = self.ArmCannonHP - damage
		elseif self.ArmCannon and self.ArmCannonHP <= 0 then
			self.ArmCannon = false
			self:ArmCannonSpark()

			ParticleEffectAttach("bo3_explosion_micro", PATTACH_POINT_FOLLOW, self, 13)

			self:TempBehaveThread(function(self)
				self:SetSpecialAnimation(true)
				self:PlaySequenceAndMove("nz_raz_pain_mangler", 1)
				self:PlaySequenceAndMove("nz_raz_enrage", 1)
				self:SetSpecialAnimation(false)
			end)
		end
	end
end

function ENT:OnGameOver()
	if !self.yousuck then
		self.yousuck = true
		self:DoSpecialAnimation("nz_t9_raz_com_summon")
	end
end

function ENT:ArmCannonSpark() -- Copy and Paste of George's Stagelight spark code.
	local spark = ents.Create("env_spark")
	spark:SetOwner(self)
	spark:SetParent(self)
	spark:SetLocalPos(self:GetPos())
	spark:SetKeyValue("MaxDelay","3")
	spark:SetKeyValue("Magnitude","2")
	spark:SetKeyValue("TrailLength","2")
	spark:Fire("setparentattachment", "weapon_fx_tag")
	spark:Spawn()
	spark:Activate()
	spark:Fire("SparkOnce" ,"", 0)
	if IsValid(spark) then
		spark:Remove() -- Removes the spark when its done... Important because the spark entities wouldn't go away otherwise.
	end
end

function ENT:IsValidTarget( ent )
	if !ent then return false end
	return IsValid(ent) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
	-- Won't go for special targets (Monkeys), but still MAX, ALWAYS and so on
end

function ENT:HandleAnimEvent(a,b,c,d,e) -- Moo Mark 4/14/23: You don't know how sad I am that I didn't know about this sooner.
	if e == "step_right_small" or e == "step_left_small" or e == "step_right_large" or e == "step_left_large" then
		util.ScreenShake(self:GetPos(),1,1,0.2,450)
		self:EmitSound(self.WalkFootstepsSounds[math.random(#self.WalkFootstepsSounds)], 70)
		self:EmitSound(self.WalkFootstepsGearSounds[math.random(#self.WalkFootstepsGearSounds)], 70)
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

	if e == "raz_charge" then
		self:EmitSound(self.EnrageSounds[math.random(#self.EnrageSounds)], 100, math.random(85, 105), 1, 2)
		self:EmitSound("nz_moo/zombies/vox/_raz/_t9/mangler/raz_charge_oneshot.mp3", 90)
		ParticleEffectAttach("bo3_mangler_charge", PATTACH_POINT_FOLLOW, self, 13)
	end
	if e == "raz_shoot" then
		self:EmitSound(self.ArmCannonShootSounds[math.random(#self.ArmCannonShootSounds)], 90)
		ParticleEffectAttach("bo3_mangler_blast", PATTACH_POINT_FOLLOW, self, 13)

		self:Retarget()

		local rarmfx_tag = self:GetBonePosition(self:LookupBone("j_weapon_spin"))
		local target = self:GetTarget()

		if IsValid(target) then
			self.ZapShot = ents.Create("nz_mangler_shot")
			self.ZapShot:SetPos(rarmfx_tag)
			self.ZapShot:Spawn()
			self.ZapShot:Launch(((target:EyePos() - Vector(0,0,7)) - self.ZapShot:GetPos()):GetNormalized())
		end

	end

	if e == "raz_enrage" then
		self:EmitSound(self.EnrageSounds[math.random(#self.EnrageSounds)], 100, math.random(85, 105), 1, 2)
		self:SetRunSpeed(71)
		self:SpeedChanged()
	end

	if e == "raz_taunt" then
		self.NextSound = CurTime() + self.SoundDelayMax
		self:EmitSound(self.MangleTauntSounds[math.random(#self.MangleTauntSounds)], 100, math.random(85, 105), 1, 2)
	end

	if e == "raz_idle_click" then
		ParticleEffectAttach("doom_mancu_blast", PATTACH_POINT_FOLLOW, self, 13)
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
	if e == "remove_zombie" then
		self:Remove()
	end
end