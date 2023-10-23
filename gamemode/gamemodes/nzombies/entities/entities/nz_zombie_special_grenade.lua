AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "FIRE IN THE HOLE!!!"
ENT.Type = "nextbot"
ENT.Category = "Brainz"
ENT.Author = "Wavy"
ENT.Spawnable = true

local resist = {
	[DMG_BULLET] = true,
}

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true
ENT.MooSpecialZombie = true
ENT.IsMooSpecial = true

ENT.Models = {
	{Model = "models/wavy/wavy_rigs/lethal_necrotics/bomber/wavy_zombie_bomber.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawnrun = {"nz_spawn_ground_v1_run", "nz_spawn_ground_climbout_fast"}

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

local JumpSequences = {
	{seq = "nz_barricade_trav_walk_1"},
	{seq = "nz_barricade_trav_walk_2"},
	{seq = "nz_barricade_trav_walk_3"},
}
local RunJumpSequences = {
	{seq = "nz_barricade_run_1"},
}
local SprintJumpSequences = {
	{seq = "nz_barricade_sprint_1"},
	{seq = "nz_barricade_sprint_2"},
	--{seq = "nz_mantle_over_128"}, -- Here for later...
}
local walksounds = {
	Sound("wavy_zombie/bomber/zombine_idle1.wav"),
	Sound("wavy_zombie/bomber/zombine_idle2.wav"),
	Sound("wavy_zombie/bomber/zombine_idle3.wav"),
	Sound("wavy_zombie/bomber/zombine_idle4.wav"),
}

local runsounds = {
	Sound("wavy_zombie/bomber/zombine_alert1.wav"),
	Sound("wavy_zombie/bomber/zombine_alert2.wav"),
	Sound("wavy_zombie/bomber/zombine_alert3.wav"),
	Sound("wavy_zombie/bomber/zombine_alert4.wav"),
	Sound("wavy_zombie/bomber/zombine_alert5.wav"),
	Sound("wavy_zombie/bomber/zombine_alert7.wav"),
}

-- This is a very large and messy looking table... But it gets the job done.
ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawnrun},
			MovementSequence = {
				"nz_walk_ad1",
				"nz_walk_ad19",
				"nz_walk_ad2",
				"nz_walk_ad25",
				"nz_walk_ad5",
				"nz_walk_au2",
				"nz_walk_au3",
				"nz_walk_au7",
				"nz_walk_fast_au2",
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
			AttackSequences = {WalkAttackSequences},
			StandAttackSequences = {AttackSequences},

			JumpSequences = {JumpSequences},

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
				"nz_legacy_jap_run_v6",
				"nz_run_ad2",
				"nz_run_ad22",
				"nz_run_ad7",
				"nz_run_au11",
				"nz_run_au5",
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
			AttackSequences = {RunAttackSequences},
			StandAttackSequences = {AttackSequences},

			JumpSequences = {RunJumpSequences},

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
			SpawnSequence = {spawnrun},
			MovementSequence = {
				"nz_legacy_sprint_v2",
				"nz_sprint_ad4",
				"nz_sprint_au4",
				"nz_t9_base_sprint_au_v01",
				"nz_t9_base_sprint_au_v21",
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
			AttackSequences = {SprintAttackSequences},
			StandAttackSequences = {AttackSequences},

			JumpSequences = {SprintJumpSequences},

			Climb36 = {FastClimbUp36},
			Climb48 = {FastClimbUp48},
			Climb72 = {FastClimbUp72},
			Climb96 = {FastClimbUp96},
			Climb120 = {SlowClimbUp128},
			Climb160 = {SlowClimbUp160},
			Climb200 = {ClimbUp200},

			PassiveSounds = {runsounds},
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
	"wavy_zombie/bomber/zombine_die1.wav",
	"wavy_zombie/bomber/zombine_die2.wav",
	"wavy_zombie/bomber/zombine_charge1.wav"
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
	"npc/zombie/zo_attack1.wav",
	"npc/zombie/zo_attack2.wav"
}

ENT.ReadyGrenadeSounds = {
	Sound("wavy_zombie/bomber/zombine_readygrenade1.wav"),
	Sound("wavy_zombie/bomber/zombine_readygrenade2.wav"),

}

ENT.CustomWalkFootstepsSounds = {
	"npc/combine_soldier/gear1.wav",
	"npc/combine_soldier/gear2.wav",
	"npc/combine_soldier/gear3.wav",
	"npc/combine_soldier/gear4.wav",
	"npc/combine_soldier/gear5.wav",
	"npc/combine_soldier/gear6.wav"
}

ENT.CustomRunFootstepsSounds = {
	"npc/combine_soldier/gear1.wav",
	"npc/combine_soldier/gear2.wav",
	"npc/combine_soldier/gear3.wav",
	"npc/combine_soldier/gear4.wav",
	"npc/combine_soldier/gear5.wav",
	"npc/combine_soldier/gear6.wav"
}

ENT.BehindSoundDistance = 0 -- When the zombie is within 200 units of a player, play these sounds instead
ENT.BehindSounds = {
	Sound("nz_moo/zombies/vox/mute_00.wav")
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
			self:SetHealth( nzRound:GetZombieHealth() * 2 or 75 )
		end
	end
		self.Cooldown = CurTime() + 5
		self.Throwing = false
		self.CanThrow = false
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

function ENT:OnTakeDamage(dmginfo)
	if resist[dmginfo:GetDamageType()] then
		dmginfo:ScaleDamage(0.5)
	end
end

function ENT:PostAdditionalZombieStuff()
	--print("angel_tone5")
	if self:GetSpecialAnimation() then return end
	if CurTime() > self.Cooldown and !self.CanThrow then
		self.CanThrow = true
	end
	if self:TargetInRange(600) and !self:IsAttackBlocked() and self.CanThrow and !self.IsTurned then
		if !self:GetTarget():IsPlayer() then return end
		if self:TargetInRange(150) then return end
		self:ThrowGrenade()
	end
end

function ENT:PostDeath(dmginfo)
	if math.random(2) == 2 then
	local grenade = ents.Create("bomber_grenade")
	grenade:SetPos(self:WorldSpaceCenter())
	grenade:SetOwner(self:GetOwner())
	grenade:Spawn()
	local dir = (self:GetAimVector())
	dir:Mul(1)

	local phys = grenade:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetVelocity(dir)
	end
end
end

function ENT:ThrowGrenade()
	self:TempBehaveThread(function(self)
		self:SetSpecialAnimation(true)
		self.Throwing = true
		self:PlaySequenceAndMove("nz_base_attack_ranged_react_left_01", 1, self.FaceEnemy)
		self:PlaySequenceAndMove("nz_base_attack_ranged_throw_left_01", 1, self.FaceEnemy)
		self.Throwing = false
		self.CanThrow = false
		self:SetSpecialAnimation(false)
		self.Cooldown = CurTime() + 5
	end)
end

function ENT:HandleAnimEvent(a,b,c,d,e) -- Moo Mark 4/14/23: You don't know how sad I am that I didn't know about this sooner.
	if e == "step_right_small" or e == "step_left_small" then
		if self.CustomWalkFootstepsSounds then
			self:EmitSound(self.CustomWalkFootstepsSounds[math.random(#self.CustomWalkFootstepsSounds)], 75)
		else
			self:EmitSound("CoDZ_Zombie.StepWalk")
		end
	end
	if e == "step_right_large" or e == "step_left_large" then
		if self.CustomRunFootstepsSounds then
			self:EmitSound(self.CustomRunFootstepsSounds[math.random(#self.CustomRunFootstepsSounds)], 75)
		else
			self:EmitSound("CoDZ_Zombie.StepRun")
		end
	end
	if e == "crawl_hand" then
		if self.CustomCrawlImpactSounds then
			self:EmitSound(self.CrawlImpactSounds[math.random(#self.CrawlImpactSounds)], 70)
		else
			self:EmitSound("CoDZ_Zombie.StepCrawl")
		end
	end
	if e == "melee" then
		if self.AttackSounds then
			self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2)
		end
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
	if e == "base_ranged_rip" then
		self:EmitSound(self.ReadyGrenadeSounds[math.random(#self.ReadyGrenadeSounds)], 500, math.random(95, 105), 1, 2)
	end
	if e == "base_ranged_throw" then
		self:EmitSound("TFA.BO1.M67.Throw")
		local larmfx_tag = self:LookupBone("j_spineupper")
		self.Grenade = ents.Create("bomber_grenade")
		self.Grenade:SetPos(self:GetBonePosition(larmfx_tag))
		self.Grenade:SetOwner(self:GetOwner())
		self.Grenade:Spawn()
		local phys = self.Grenade:GetPhysicsObject()
        local target = self:GetTarget()
        if IsValid(phys) and IsValid(target) then
             phys:SetVelocity(self.Grenade:getvel(target:EyePos() + Vector(0,0,15), self:EyePos(), 0.75))
        end
	end
end