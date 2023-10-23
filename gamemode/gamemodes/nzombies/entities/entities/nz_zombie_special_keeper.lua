AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.Type = "nextbot"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo"
ENT.Spawnable = true

--[[function ENT:Draw() //Runs every frame
	self:DrawModel()
end]]

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = false
ENT.IsMooSpecial = true

ENT.AttackRange = 65
ENT.DamageRange = 65

ENT.Models = {
	{Model = "models/moo/_codz_ports/t7/genesis/moo_codz_t7_genesis_keeper.mdl", Skin = 0, Bodygroups = {0,0}},
}

ENT.BarricadeTearSequences = {
}

local AttackSequences = {
	{seq = "nz_keeper_stand_attack_v1", dmgtimes = {0.75, 1.25}},
	{seq = "nz_keeper_stand_attack_v2", dmgtimes = {0.75, 2.35}},
	{seq = "nz_keeper_stand_attack_v3", dmgtimes = {0.65}},
	{seq = "nz_keeper_stand_attack_v4", dmgtimes = {0.15, 0.60, 1.10}},
}

local RunAttackSequences = {
	{seq = "nz_keeper_moving_attack_v1", dmgtimes = {0.4}},
	{seq = "nz_keeper_moving_attack_v2", dmgtimes = {0.6}},
	{seq = "nz_keeper_moving_attack_v3", dmgtimes = {0.25}},
	{seq = "nz_keeper_moving_attack_v4", dmgtimes = {0.25, 0.55}},
}

local JumpSequences = {
	{seq = "nz_keeper_barricade_trav", speed = 50, time = 3},
}
local walksounds = {
	Sound("nz_moo/zombies/vox/_keeper/vox_amb/amb_00.mp3"),
	Sound("nz_moo/zombies/vox/_keeper/vox_amb/amb_01.mp3"),
	Sound("nz_moo/zombies/vox/_keeper/vox_amb/amb_02.mp3"),
	Sound("nz_moo/zombies/vox/_keeper/vox_amb/amb_03.mp3"),
	Sound("nz_moo/zombies/vox/_keeper/vox_amb/amb_04.mp3"),
	Sound("nz_moo/zombies/vox/_keeper/vox_amb/amb_05.mp3"),
	Sound("nz_moo/zombies/vox/_keeper/vox_amb/amb_06.mp3"),
}

ENT.IdleSequence = "nz_keeper_idle"

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			MovementSequence = {
				"nz_keeper_walk_v1",
				"nz_keeper_walk_v2",
				"nz_keeper_walk_v3",
				"nz_keeper_walk_v4",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		}
	}},
	{Threshold = 35, Sequences = {
		{
			MovementSequence = {
				"nz_keeper_run_v1",
				"nz_keeper_run_v2",
				"nz_keeper_run_v3",
				"nz_keeper_run_v4",
			},
			AttackSequences = {RunAttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		}
	}},
	{Threshold = 70, Sequences = {
		{
			MovementSequence = {
				"nz_keeper_sprint_v1",
				"nz_keeper_sprint_v2",
				"nz_keeper_sprint_v3",
				"nz_keeper_sprint_v4",
			},
			AttackSequences = {RunAttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		}
	}}
}

ENT.DeathSounds = {
	"nz_moo/zombies/vox/_keeper/vox_death/death_00.mp3",
	"nz_moo/zombies/vox/_keeper/vox_death/death_01.mp3",
	"nz_moo/zombies/vox/_keeper/vox_death/death_02.mp3",
	"nz_moo/zombies/vox/_keeper/vox_death/death_03.mp3",
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
	"nz_moo/zombies/vox/_skele/attack/attack_00.mp3",
	"nz_moo/zombies/vox/_skele/attack/attack_01.mp3",
	"nz_moo/zombies/vox/_skele/attack/attack_02.mp3",
	"nz_moo/zombies/vox/_skele/attack/attack_03.mp3"
}

ENT.MonkeySounds = {
	Sound("nz_moo/zombies/vox/mute_00.wav"),
	Sound("nz_moo/zombies/vox/mute_00.wav"),
	Sound("nz_moo/zombies/vox/mute_00.wav"),
	Sound("nz_moo/zombies/vox/mute_00.wav"),
	Sound("nz_moo/zombies/vox/mute_00.wav"),
	Sound("nz_moo/zombies/vox/mute_00.wav"),
	Sound("nz_moo/zombies/vox/mute_00.wav"),
	Sound("nz_moo/zombies/vox/mute_00.wav"),
}

ENT.BehindSoundDistance = 200 -- When the zombie is within 200 units of a player, play these sounds instead
ENT.BehindSounds = {
	Sound("nz_moo/zombies/vox/_keeper/vox_behind/behind_00.mp3"),
	Sound("nz_moo/zombies/vox/_keeper/vox_behind/behind_01.mp3"),
	Sound("nz_moo/zombies/vox/_keeper/vox_behind/behind_02.mp3"),
	Sound("nz_moo/zombies/vox/_keeper/vox_behind/behind_03.mp3"),
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

		self:SetCollisionBounds(Vector(-12,-12, 0), Vector(12, 12, 77))

	end
end

function ENT:SpecialInit()
	if CLIENT then
	end
end

function ENT:OnSpawn()
	self:SolidMaskDuringEvent(MASK_SOLID_BRUSHONLY)
	self:Sound()
	self:CollideWhenPossible()

	local effectData = EffectData()
	effectData:SetOrigin( self:GetPos() + Vector(0, 0, 50)  )
	effectData:SetMagnitude( 1 )
	effectData:SetEntity(nil)
	util.Effect("panzer_spawn_tp", effectData)
	ParticleEffectAttach("env_embers_medium_spread",PATTACH_ABSORIGIN_FOLLOW,self,0)
	self:EmitSound("nz_moo/zombies/vox/_keeper/keeper_rise.mp3", 511)
	self:EmitSound("nz_moo/zombies/vox/_keeper/keeper_lp.wav", 65)
end

function ENT:PerformDeath(dmgInfo)
	self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
	self:StopSound("nz_moo/zombies/vox/_keeper/keeper_lp.wav")
	ParticleEffect("doom_dissolve_flameburst",self:WorldSpaceCenter(),Angle(0,0,0),nil)
	self:Remove(dmgInfo)
end

function ENT:OnRemove()
	self:StopSound("nz_moo/zombies/vox/_keeper/keeper_lp.wav")
end
