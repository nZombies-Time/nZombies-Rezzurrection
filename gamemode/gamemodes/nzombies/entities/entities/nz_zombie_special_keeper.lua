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

function ENT:Draw() //Runs every frame
	self:DrawModel()
end

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = false
ENT.IsMooSpecial = true

ENT.Models = {
	{Model = "models/moo/_codz_ports/t7/genesis/moo_codz_t7_genesis_keeper.mdl", Skin = 0, Bodygroups = {0,0}},
}

ENT.BarricadeTearSequences = {
}

local AttackSequences = {
	{seq = "nz_keeper_stand_attack_v1", dmgtimes = {0.75, 1.25}},
	{seq = "nz_keeper_stand_attack_v2", dmgtimes = {0.75, 1.25}},
	{seq = "nz_keeper_stand_attack_v3", dmgtimes = {0.95, 1.35}},
	{seq = "nz_keeper_stand_attack_v4", dmgtimes = {0.85, 1.30}},
}

local RunAttackSequences = {
	{seq = "nz_keeper_moving_attack_v1", dmgtimes = {0.45}},
	{seq = "nz_keeper_moving_attack_v2", dmgtimes = {0.45}},
	{seq = "nz_keeper_moving_attack_v3", dmgtimes = {0.25}},
	{seq = "nz_keeper_moving_attack_v4", dmgtimes = {0.25}},
}

local JumpSequences = {
	{seq = "nz_keeper_barricade_trav", speed = 25, time = 3},
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


ENT.ActStages = {
	[1] = {
		act = ACT_WALK,
		minspeed = 0,
		attackanims = AttackSequences,
		barricadejumps = JumpSequences,
	},
	[2] = {
		act = ACT_WALK_ANGRY,
		minspeed = 25,
		attackanims = RunAttackSequences,
		barricadejumps = JumpSequences,
	},
	[3] = {
		act = ACT_RUN,
		minspeed = 60,
		attackanims = RunAttackSequences,
		barricadejumps = JumpSequences,
	},
	[4] = {
		act = ACT_SPRINT,
		minspeed = 145,
		attackanims = RunAttackSequences,
		barricadejumps = JumpSequences,
	},
	[5] = {
		act = ACT_SUPERSPRINT,
		minspeed = 220,
		attackanims = RunAttackSequences,
		barricadejumps = JumpSequences,
	},
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

-- A standard attack you can use it or create something fancy yourself
function ENT:Attack( data )

	self:SetLastAttack(CurTime())

	data = data or {}
	
	data.attackseq = data.attackseq
	if !data.attackseq then
		local curstage = self:GetActStage()
		local actstage = self.ActStages[curstage]
		if !self:GetCrawler() and !actstage and curstage <= 0 then actstage = self.ActStages[1] end
		--if self:GetCrawler() then self.CrawlAttackSequences end
		
		local attacktbl = actstage and actstage.attackanims or self.AttackSequences
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
		for k,v in pairs(data.attackseq.dmgtimes) do
			self:TimedEvent( v, function()
				if self.AttackSounds then self:PlaySound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2) end
				self:EmitSound( "npc/vort/claw_swing1.wav", 90, math.random(95, 105))
				if !self:GetStop() and self:IsValidTarget( self:GetTarget() ) and self:TargetInRange( self:GetAttackRange() + 10 ) then
					local dmgInfo = DamageInfo()
					dmgInfo:SetAttacker( self )
					dmgInfo:SetDamage( 50 )
					dmgInfo:SetDamageType( DMG_SLASH )
					dmgInfo:SetDamageForce( (self:GetTarget():GetPos() - self:GetPos()) * 7 + Vector( 0, 0, 16 ) )
					self:GetTarget():TakeDamageInfo(dmgInfo)
					if !IsValid(self:GetTarget()) then return end
					self:GetTarget():EmitSound( "nz_moo/zombies/plr_impact/_zhd/evt_zombie_hit_player_0"..math.random(0,5)..".mp3", SNDLVL_TALKING, math.random(95,105))
					
					if self:GetTarget():IsPlayer() then
						self:GetTarget():ViewPunch( VectorRand():Angle() * 0.01 )
					end
				end
			end)
		end
	end

	self:TimedEvent(data.attackdur, function()
		self:SetAttacking(false)
		self:SetLastAttack(CurTime())
	end)

	self:PlayAttackAndWait(data.attackseq.seq, 1)
end

function ENT:OnRemove()
	self:StopSound("nz_moo/zombies/vox/_keeper/keeper_lp.wav")
end