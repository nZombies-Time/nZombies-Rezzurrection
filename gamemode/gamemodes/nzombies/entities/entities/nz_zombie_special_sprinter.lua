AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.Type = "nextbot"
ENT.PrintName = "ZomBEESSS"
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
ENT.IsMooSpecial = true

ENT.AttackDamage = 25

ENT.Models = {
	{Model = "models/moo/_codz_ports/s2/zombie/moo_codz_s2_sprinter.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"nz_s2_traverse_ground_floor_riser_v1", "nz_s2_traverse_ground_floor_riser_v2"}

ENT.DeathSequences = {
	"nz_s2_spr_stand_death",
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

ENT.BarricadeTearSequences = {}

local CrawlJumpSequences = {
	{seq = "nz_barricade_crawl_1"},
	{seq = "nz_barricade_crawl_2"},
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

local AttackSequences = {
	{seq = "nz_s2_spr_stand_attack_v1"},
	{seq = "nz_s2_spr_stand_attack_v2"},
	{seq = "nz_s2_spr_stand_attack_v3"},
}

local WalkAttackSequences = {
	{seq = "nz_s2_spr_sprint_attack_v1"},
	{seq = "nz_s2_spr_sprint_attack_v2"},
	{seq = "nz_s2_spr_sprint_attack_v3"},
}

local JumpSequences = {
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
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_charge_01.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_charge_02.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_charge_03.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_charge_04.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_charge_05.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_charge_06.mp3"),

	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_sprint_1_01.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_sprint_1_02.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_sprint_1_03.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_sprint_1_04.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_sprint_1_05.mp3"),

	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_sprint_2_01.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_sprint_2_02.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_sprint_2_03.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_sprint_2_04.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_sprint_2_05.mp3"),

	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_sprint_3_01.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_sprint_3_02.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_sprint_3_03.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_sprint_3_04.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_sprint_3_05.mp3"),
}

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"nz_s2_spr_sprint_v1",
				"nz_s2_spr_sprint_v2",
				"nz_s2_spr_sprint_v3",
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
}

ENT.IdleSequence = "nz_s2_spr_pass_idle_v1"
ENT.IdleSequenceAU = "nz_s2_spr_pass_idle_v1"

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

ENT.DeathSounds = {
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_death_01.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_death_02.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_death_03.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_death_04.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_death_05.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_death_06.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_death_07.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_death_08.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_death_09.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_death_10.mp3",
}

ENT.ElecSounds = {
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_death_01.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_death_02.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_death_03.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_death_04.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_death_05.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_death_06.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_death_07.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_death_08.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_death_09.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_death_10.mp3",
}

ENT.AttackSounds = {
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_sprint_attack_1_01.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_sprint_attack_1_02.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_sprint_attack_1_03.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_sprint_attack_1_04.mp3",

	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_sprint_attack_2_01.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_sprint_attack_2_02.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_sprint_attack_2_03.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_sprint_attack_2_04.mp3",

	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_sprint_attack_3_01.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_sprint_attack_3_02.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_sprint_attack_3_03.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_anm_sprint_attack_3_04.mp3",
}

ENT.SpawnSounds = {
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_spawn_01.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_spawn_02.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_spawn_03.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_spawn_04.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_spawn_05.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_spawn_06.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_spawn_07.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_spawn_08.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_spawn_09.mp3",
	"nz_moo/zombies/vox/_spr/zmb_vox_spr_spawn_10.mp3",
}

ENT.StepSounds = {
	"nz_moo/zombies/vox/_spr/flies_pan_01.mp3",
	"nz_moo/zombies/vox/_spr/flies_pan_02.mp3",
	"nz_moo/zombies/vox/_spr/flies_pan_03.mp3",
	"nz_moo/zombies/vox/_spr/flies_pan_04.mp3",
	"nz_moo/zombies/vox/_spr/flies_pan_05.mp3",
	"nz_moo/zombies/vox/_spr/flies_pan_06.mp3",
	"nz_moo/zombies/vox/_spr/flies_pan_07.mp3",
	"nz_moo/zombies/vox/_spr/flies_pan_08.mp3",
	"nz_moo/zombies/vox/_spr/flies_pan_09.mp3",
	"nz_moo/zombies/vox/_spr/flies_pan_10.mp3",
	"nz_moo/zombies/vox/_spr/flies_pan_11.mp3",
	"nz_moo/zombies/vox/_spr/flies_pan_12.mp3",
	"nz_moo/zombies/vox/_spr/flies_pan_13.mp3",
}

ENT.BehindSoundDistance = 200 -- When the zombie is within 200 units of a player, play these sounds instead
ENT.BehindSounds = {
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_sneak_attack_01.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_sneak_attack_02.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_sneak_attack_03.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_sneak_attack_04.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_sneak_attack_05.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_sneak_attack_06.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_sneak_attack_07.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_sneak_attack_08.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_sneak_attack_09.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_sneak_attack_10.mp3"),
	Sound("nz_moo/zombies/vox/_spr/zmb_vox_spr_sneak_attack_11.mp3"),
}

function ENT:StatsInitialize()
	if SERVER then
		self:SetRunSpeed( 1 )
		self:SetHealth( 200 )
	end
end

function ENT:SpecialInit()
	if CLIENT then
	end
end

function ENT:OnSpawn()
	local spawn
	local types = {
		["nz_spawn_zombie_normal"] = true,
		["nz_spawn_zombie_special"] = true,
		["nz_spawn_zombie_extra1"] = true,
		["nz_spawn_zombie_extra2"] = true,
		["nz_spawn_zombie_extra3"] = true,
		["nz_spawn_zombie_extra4"] = true,
	}
	for k,v in pairs(ents.FindInSphere(self:GetPos(), 10)) do
		if types[v:GetClass()] then
			if !v:GetMasterSpawn() then
				spawn = v
			end
		end
	end
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

	if IsValid(spawn) and spawn:GetSpawnType() == 1 then
		self:SolidMaskDuringEvent(MASK_PLAYERSOLID)
		self:CollideWhenPossible()
	else
		self:SolidMaskDuringEvent(MASK_PLAYERSOLID)

		self:SetSpecialAnimation(true)
		self:SetIsBusy(true)
		local seq = self:SelectSpawnSequence()

		if IsValid(spawn) and spawn:GetSpawnType() == 3 then
			seq = self.UndercroftSequences[math.random(#self.UndercroftSequences)]
		elseif IsValid(spawn) and spawn:GetSpawnType() == 4 then
			seq = self.WallSpawnSequences[math.random(#self.WallSpawnSequences)]
		elseif IsValid(spawn) and spawn:GetSpawnType() == 5 then
			if tr.Hit then
				local finalsound = SpawnMatSound[tr.MatType] or SpawnMatSound[0]
				self:EmitSound(finalsound)
			end
			ParticleEffect("bo3_zombie_spawn",self:GetPos()+Vector(0,0,1),self:GetAngles(),self)
			self:EmitSound("nz_moo/zombies/spawn/_generic/dirt/dirt_0"..math.random(0,2)..".mp3",100,math.random(95,105))

			seq = self.JumpSpawnSequences[math.random(#self.JumpSpawnSequences)]
		elseif IsValid(spawn) and spawn:GetSpawnType() == 6 then
			seq = self.BarrelSpawnSequences[math.random(#self.BarrelSpawnSequences)]
		elseif IsValid(spawn) and spawn:GetSpawnType() == 7 then
			seq = self.LowCeilingDropSpawnSequences[math.random(#self.LowCeilingDropSpawnSequences)]
		elseif IsValid(spawn) and spawn:GetSpawnType() == 8 then
			seq = self.HighCeilingDropSpawnSequences[math.random(#self.HighCeilingDropSpawnSequences)]
		elseif IsValid(spawn) and spawn:GetSpawnType() == 9 then
			seq = self.GroundWallSpawnSequences[math.random(#self.GroundWallSpawnSequences)]
		else
			if tr.Hit then
				local finalsound = SpawnMatSound[tr.MatType] or SpawnMatSound[0]
				self:EmitSound(finalsound)
			end
			ParticleEffect("bo3_zombie_spawn",self:GetPos()+Vector(0,0,1),self:GetAngles(),self)
			self:EmitSound("nz_moo/zombies/spawn/_generic/dirt/dirt_0"..math.random(0,2)..".mp3",100,math.random(95,105))
		end
		if seq then
			if IsValid(spawn) and 
				(spawn:GetSpawnType() == 3 
				or spawn:GetSpawnType() == 4 
				or spawn:GetSpawnType() == 6 
				or spawn:GetSpawnType() == 9) then
				self:PlaySequenceAndMove(seq, {gravity = false})
			else
				self:PlaySequenceAndMove(seq, {gravity = true})
			end
			self:SetSpecialAnimation(false)
			self:SetIsBusy(false)
			self:CollideWhenPossible()
		end
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
	if self.UpdateSeq ~= self.CurrentSeq then -- Moo Mark 4/19/23: Finally got a system where the speed actively updates when the movement sequence set is changed.
		--print("update")
		self.UpdateSeq = self.CurrentSeq
		self:UpdateMovementSpeed()
	end
end

function ENT:HandleAnimEvent(a,b,c,d,e)
	if e == "melee" then
		self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2)
		self:DoAttackDamage()
	end
	if e == "s2_gen_step" then
		self:EmitSound(self.StepSounds[math.random(#self.StepSounds)], 100, math.random(95, 105))
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
end

function ENT:Sound()
	if self.BehindSoundDistance > 0 -- We have enabled behind sounds
		and IsValid(self.Target)
		and self.Target:IsPlayer() -- We have a target and it's a player within distance
		and self:GetRangeTo(self.Target) <= self.BehindSoundDistance
		and (self.Target:GetPos() - self:GetPos()):GetNormalized():Dot(self.Target:GetAimVector()) >= 0 then -- If the direction towards the player is same 180 degree as the player's aim (away from the zombie)
			self:PlaySound(self.BehindSounds[math.random(#self.BehindSounds)], 100, math.random(80, 110), 1, 2) -- Play the behind sound, and a bit louder!
	elseif self.PassiveSounds then
		self:PlaySound(self.PassiveSounds[math.random(#self.PassiveSounds)],95, math.random(80, 110), 1, 2)
	else
		-- We still delay by max sound delay even if there was no sound to play
		self.NextSound = CurTime() + self.SoundDelayMax
	end
end