AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Timothy"
ENT.Type = "nextbot"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo"
ENT.Spawnable = true

function ENT:DrawEyeGlow()
	local eyeglow =  Material("nz_moo/sprites/moo_glow1")
	local eyeColor = Color(255,50,0)
	local latt = self:LookupAttachment("lefteye")
	local ratt = self:LookupAttachment("righteye")

	if latt == nil then return end
	if ratt == nil then return end

	local leye = self:GetAttachment(latt)
	local reye = self:GetAttachment(ratt)

	local righteyepos = leye.Pos + leye.Ang:Forward()*0.5
	local lefteyepos = reye.Pos + reye.Ang:Forward()*0.5

	if lefteyepos and righteyepos then
		render.SetMaterial(eyeglow)
		render.DrawSprite(lefteyepos, 4, 4, eyeColor)
		render.DrawSprite(righteyepos, 4, 4, eyeColor)
	end
end

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true
ENT.IsCatalyst = true
--ENT.IsMooSpecial = true

ENT.Models = {
	{Model = "models/moo/_codz_ports/t8/catalysts/moo_codz_t8_fire_catalyst.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawnslow = {"nz_spawn_ground_v1", "nz_spawn_ground_ad_v2", "nz_spawn_ground_v2", "nz_spawn_ground_v2_altb"}
local spawnrun = {"nz_spawn_ground_v1_run"}
local spawnfast = {"nz_spawn_ground_climbout_fast"}

ENT.DeathSequences = {
	"nz_death_v1",
	"nz_death_v2",
	"nz_death_v3",
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
	{seq = "nz_death_v1", dmgtimes = {0.75}},
	{seq = "nz_death_v2", dmgtimes = {0.75}},
	{seq = "nz_death_v3", dmgtimes = {0.75}},
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
}
local walksounds = {
	Sound("nz_moo/zombies/vox/_mutated/amb/fire/amb_00.mp3"),
	Sound("nz_moo/zombies/vox/_mutated/amb/fire/amb_01.mp3"),
	Sound("nz_moo/zombies/vox/_mutated/amb/fire/amb_02.mp3"),
	Sound("nz_moo/zombies/vox/_mutated/amb/fire/amb_03.mp3"),
	Sound("nz_moo/zombies/vox/_mutated/amb/fire/amb_04.mp3"),
	Sound("nz_moo/zombies/vox/_mutated/amb/fire/amb_05.mp3"),
	Sound("nz_moo/zombies/vox/_mutated/amb/fire/amb_06.mp3"),
	Sound("nz_moo/zombies/vox/_mutated/amb/fire/amb_07.mp3"),
	Sound("nz_moo/zombies/vox/_mutated/amb/fire/amb_08.mp3"),
	Sound("nz_moo/zombies/vox/_mutated/amb/fire/amb_09.mp3"),
	Sound("nz_moo/zombies/vox/_mutated/amb/fire/amb_10.mp3"),
}

ENT.IdleSequence = "nz_idle_v1"

-- This is a very large and messy looking table... But it gets the job done.
ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawnslow},
			MovementSequence = {
				"nz_walk_v1",
				"nz_walk_v2",
				"nz_walk_v3",
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
			},
			FireMovementSequence = {
				"nz_firestaff_walk_v1",
				"nz_firestaff_walk_v2",
				"nz_firestaff_walk_v3",
			},
			AttackSequences = {AttackSequences},
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
				"nz_run_v1",
				"nz_run_v2",
				"nz_run_v3",
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
			},
			FireMovementSequence = {
				"nz_firestaff_walk_v1",
				"nz_firestaff_walk_v2",
				"nz_firestaff_walk_v3",
			},
			AttackSequences = {AttackSequences},
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

			PassiveSounds = {walksounds},
		}
	}},
	{Threshold = 71, Sequences = {
		{
			SpawnSequence = {spawnfast},
			MovementSequence = {
				"nz_sprint_v1",
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
			},
			FireMovementSequence = {
				"nz_firestaff_walk_v1",
				"nz_firestaff_walk_v2",
				"nz_firestaff_walk_v3",
			},
			AttackSequences = {AttackSequences},
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
	}},
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
	"nz_moo/zombies/vox/mute_00.wav"
}

ENT.ElecSounds = {
	"nz_moo/zombies/vox/mute_00.wav"
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
	"nz_moo/zombies/vox/_mutated/attack/fire/scream_00.mp3",
	"nz_moo/zombies/vox/_mutated/attack/fire/scream_01.mp3",
	"nz_moo/zombies/vox/_mutated/attack/fire/scream_02.mp3",
	"nz_moo/zombies/vox/_mutated/attack/fire/scream_03.mp3",
}

ENT.CrawlerSounds = {
	Sound("nz_moo/zombies/vox/_mutated/amb/fire/amb_00.mp3"),
	Sound("nz_moo/zombies/vox/_mutated/amb/fire/amb_01.mp3"),
	Sound("nz_moo/zombies/vox/_mutated/amb/fire/amb_02.mp3"),
	Sound("nz_moo/zombies/vox/_mutated/amb/fire/amb_03.mp3"),
	Sound("nz_moo/zombies/vox/_mutated/amb/fire/amb_04.mp3"),
	Sound("nz_moo/zombies/vox/_mutated/amb/fire/amb_05.mp3"),
	Sound("nz_moo/zombies/vox/_mutated/amb/fire/amb_06.mp3"),
	Sound("nz_moo/zombies/vox/_mutated/amb/fire/amb_07.mp3"),
	Sound("nz_moo/zombies/vox/_mutated/amb/fire/amb_08.mp3"),
	Sound("nz_moo/zombies/vox/_mutated/amb/fire/amb_09.mp3"),
	Sound("nz_moo/zombies/vox/_mutated/amb/fire/amb_10.mp3"),
}

ENT.GoofyahSounds = {
	Sound("nz_moo/zombies/vox/_mutated/attack/fire/rather_rude_insult_00.mp3"),
	Sound("nz_moo/zombies/vox/_mutated/attack/fire/rather_rude_insult_01.mp3"),
}

ENT.MonkeySounds = {
	Sound("nz_moo/zombies/vox/mute_00.wav")
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
	ParticleEffectAttach("env_embers_medium_spread",PATTACH_ABSORIGIN_FOLLOW,self,0)
	ParticleEffectAttach("firestaff_victim_burning",PATTACH_ABSORIGIN_FOLLOW,self,0)

	self:EmitSound("nz_moo/zombies/vox/_mutated/spawn/spawn_0"..math.random(0,4)..".mp3", 80, math.random(95,105))
	
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

-- A standard attack you can use it or create something fancy yourself
function ENT:Attack( data )

	self:SetLastAttack(CurTime())

	data = data or {}
	
	data.attackseq = data.attackseq
	if !data.attackseq then

		local attacktbl = self.AttackSequences

		if self:GetCrawler() then
			attacktbl = self.CrawlAttackSequences
		end

		local target = type(attacktbl) == "table" and attacktbl[math.random(#attacktbl)] or attacktbl

		
		if type(target) == "table" then
			local id, dur = self:LookupSequenceAct(target.seq)
			if !target.dmgtimes then
			data.attackseq = {seq = id, dmgtimes =  {0.5} }
			else
			data.attackseq = {seq = id, dmgtimes = target.dmgtimes }
			end
			data.attackdur = dur
		elseif target then -- It is a string or ACT
			local id, dur = self:LookupSequenceAct(attacktbl)
			data.attackseq = {seq = id, dmgtimes = {dur/2}}
			data.attackdur = dur
		else
			local id, dur = self:LookupSequence("swing")
			data.attackseq = {seq = id, dmgtimes = {1}}
			data.attackdur = dur
		end
	end
	
	self:SetAttacking( true )
	if IsValid(self:GetTarget()) and self:GetTarget():Health() and self:GetTarget():Health() > 0 then -- Doesn't matter if its a player... If the zombie is targetting it, they probably wanna attack it.
		if self.AttackSounds then 
			if comedyday or math.random(1,50) == 1 then
				if self.GoofyahSounds then self:PlaySound(self.GoofyahSounds[math.random(#self.GoofyahSounds)], 511, math.random(85, 105), 1, 2)  end
			else
				self:PlaySound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2) 
			end
		end
	end

	self:TimedEvent(data.attackdur, function()
		self:SetAttacking(false)
		self:SetLastAttack(CurTime())
	end)

	self:PlayAttackAndWait(data.attackseq.seq, 1)
	if  self:GetCrawler() then
			print("penis")
			else
			ParticleEffect("exploder_boom",self:GetPos(),self:GetAngles(),nil)
        		self:EmitSound("nz_moo/zombies/vox/_mutated/attack/fire/explosion.mp3", 100, math.random(95, 105))
				self:Explode(125,true)
		end
	
end

function ENT:PlayAttackAndWait( name, speed )

	local len = self:SetSequence( name )
	speed = speed or 1

	self:ResetSequenceInfo()
	self:SetCycle( 0 )
	self:SetPlaybackRate( speed )

	local endtime = CurTime() + len / speed

	while ( true ) do

		if ( endtime < CurTime() ) then
			if !self:GetStop() then
				self:StartActivity( ACT_WALK )
				if !self:GetCrawler() then
					self.loco:SetDesiredSpeed( self:GetRunSpeed() )
				end
			end
			return
		end

		coroutine.yield()

	end

end

if SERVER then
	function ENT:PostDeath(dmginfo)
		--self:Explode(125, false)
	end

	function ENT:PerformDeath(dmginfo)

        ParticleEffect("exploder_boom",self:GetPos(),self:GetAngles(),nil)
        self:EmitSound("nz_moo/zombies/vox/_mutated/attack/fire/explosion.mp3", 100, math.random(95, 105))

		self:Remove(dmginfo)
	end
end