AddCSLuaFile()

ENT.Base = "nz_zombiebase"
ENT.PrintName = "Walker"
ENT.Category = "Brainz"
ENT.Author = "Lolle"

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "EmergeSequenceIndex")
	self:NetworkVar("Bool", 1, "Decapitated")
end

ENT.Models = {
	"models/nzr/nuketown_zombies1.mdl", "models/nzr/nuketown_zombies2.mdl", "models/nzr/nuketown_zombies3.mdl", "models/nzr/nuketown_zombies4.mdl"
}

local AttackSequences = {
		{seq = "nz_walk_attack1", dmgtimes = {0.3}},
	{seq = "nz_walk_attack2", dmgtimes = {0.4, 0.9}},
	{seq = "nz_walk_attack3", dmgtimes = {0.5}},
	{seq = "nz_walk_attack4", dmgtimes = {0.4, 0.75}}
}
local WalkAttackSequences = {
	{seq = "nz_walk_attack1", dmgtimes = {0.3}},
	{seq = "nz_walk_attack2", dmgtimes = {0.4, 0.9}},
	{seq = "nz_walk_attack3", dmgtimes = {0.5}},
	{seq = "nz_walk_attack4", dmgtimes = {0.4, 0.75}}
}
local RunAttackSequences = {
	{seq = "nz_run_attack1", dmgtimes = {0.3}},
	{seq = "nz_run_attack2", dmgtimes = {0.3, 0.65}},
	{seq = "nz_run_attack3", dmgtimes = {0.3, 0.7}},
	{seq = "nz_run_attack4", dmgtimes = {0.3, 0.8}}
}

ENT.AttackSounds = {
	"nz/zombies/attack/attack_00.wav",
	"nz/zombies/attack/attack_01.wav",
	"nz/zombies/attack/attack_02.wav",
	"nz/zombies/attack/attack_03.wav",
	"nz/zombies/attack/attack_04.wav",
	"nz/zombies/attack/attack_05.wav",
	"nz/zombies/attack/attack_06.wav",
	"nz/zombies/attack/attack_07.wav",
	"nz/zombies/attack/attack_08.wav",
	"nz/zombies/attack/attack_n_1.wav",
	"nz/zombies/attack/attack_n_2.wav",
	"nz/zombies/attack/attack_n_3.wav",
	"nz/zombies/attack/attack_n_4.wav",
	"nz/zombies/attack/attack_n_5.wav",
	"nz/zombies/attack/attack_14.wav",
	"nz/zombies/attack/attack_15.wav",
	"nz/zombies/attack/attack_16.wav",
	"nz/zombies/attack/attack_17.wav",
	"nz/zombies/attack/attack_18.wav",
	"nz/zombies/attack/attack_19.wav",
	"nz/zombies/attack/attack_n_6.wav",
	"nz/zombies/attack/attack_21.wav",
	"nz/zombies/attack/attack_22.wav"
}

local WalkSounds = {
	"nz/zombies/ambient/ambient_00.wav",
	"nz/zombies/ambient/ambient_01.wav",
	"nz/zombies/ambient/ambient_02.wav",
	"nz/zombies/ambient/ambient_n_1.wav",
	"nz/zombies/ambient/ambient_n_2.wav",
	"nz/zombies/ambient/ambient_05.wav",
	"nz/zombies/ambient/ambient_n_3.wav",
	"nz/zombies/ambient/ambient_n_4.wav",
	"nz/zombies/ambient/ambient_n_5.wav",
	"nz/zombies/ambient/ambient_09.wav",
	"nz/zombies/ambient/ambient_n_6.wav",
	"nz/zombies/ambient/ambient_n_7.wav",
	"nz/zombies/ambient/ambient_n_8.wav",
	"nz/zombies/ambient/ambient_13.wav",
	"nz/zombies/ambient/ambient_14.wav",
	"nz/zombies/ambient/ambient_15.wav",
	"nz/zombies/ambient/ambient_16.wav",
	"nz/zombies/ambient/ambient_17.wav",
	"nz/zombies/ambient/ambient_18.wav",
	"nz/zombies/ambient/ambient_19.wav",
	"nz/zombies/ambient/ambient_20.wav",
	"nz/zombies/ambient/ambient_21.wav",
	"nz/zombies/ambient/ambient_22.wav",
	"nz/zombies/ambient/ambient_23.wav",
	"nz/zombies/ambient/ambient_24.wav",
	"nz/zombies/ambient/ambient_25.wav",
	"nz/zombies/ambient/ambient_26.wav",
	"nz/zombies/ambient/ambient_27.wav",
	"nz/zombies/ambient/ambient_28.wav",
	"nz/zombies/ambient/ambient_29.wav",
	"nz/zombies/ambient/ambient_30.wav",
	"nz/zombies/ambient/ambient_31.wav",
	"nz/zombies/ambient/ambient_32.wav",
}

local RunSounds = {
	"nz/zombies/sprint2/sprint0.wav",
	"nz/zombies/sprint2/sprint1.wav",
	"nz/zombies/sprint2/sprint2.wav",
	"nz/zombies/sprint2/sprint3.wav",
	"nz/zombies/sprint2/sprint4.wav",
	"nz/zombies/sprint2/sprint5.wav",
	"nz/zombies/sprint2/sprint6.wav",
	"nz/zombies/sprint2/sprint7.wav",
	"nz/zombies/sprint2/sprint8.wav",
	"nz/zombies/sprint2/sprint9.wav",
	"nz/zombies/sprint2/sprint10.wav",
	"nz/zombies/sprint2/sprint12.wav",
	"nz/zombies/sprint2/sprint11.wav",
	"nz/zombies/sprint2/sprint13.wav",
	"nz/zombies/sprint2/sprint14.wav",
	"nz/zombies/sprint2/sprint15.wav",
	"nz/zombies/sprint2/sprint16.wav",
	"nz/zombies/sprint2/sprint17.wav",
	"nz/zombies/sprint2/sprint18.wav",
	"nz/zombies/sprint2/19.wav",
	"nz/zombies/sprint2/20.wav",
	"nz/zombies/sprint2/21.wav",
	"nz/zombies/sprint2/22.wav",
	"nz/zombies/sprint2/23.wav",
	"nz/zombies/sprint2/24.wav",
	"nz/zombies/sprint2/25.wav",
	"nz/zombies/sprint2/26.wav",
}

local JumpSequences = {
	{seq = "nz_barricade1", speed = 15, time = 2.7},
	{seq = "nz_barricade2", speed = 15, time = 2.4},
	{seq = "nz_barricade_fast1", speed = 15, time = 1.8},
	{seq = "nz_barricade_fast2", speed = 35, time = 4},
}
local SprintJumpSequences = {
	{seq = "nz_barricade_sprint1", speed = 50, time = 1.9},
	{seq = "nz_barricade_sprint2", speed = 35, time = 1.9},
}

ENT.ActStages = {
	[1] = {
		act = ACT_WALK,
		minspeed = 5,
		attackanims = WalkAttackSequences,
		-- no attackhitsounds, just use ENT.AttackHitSounds for all act stages
		sounds = WalkSounds,
		barricadejumps = JumpSequences,
	},
	[2] = {
		act = ACT_WALK_ANGRY,
		minspeed = 40,
		attackanims = WalkAttackSequences,
		sounds = WalkSounds,
		barricadejumps = JumpSequences,
	},
	[3] = {
		act = ACT_RUN,
		minspeed = 100,
		attackanims = RunAttackSequences,
		sounds = RunSounds,
		barricadejumps = SprintJumpSequences,
	},
	[4] = {
		act = ACT_SPRINT,
		minspeed = 160,
		attackanims = RunAttackSequences,
		sounds = RunSounds,
		barricadejumps = SprintJumpSequences,
	},
}

ENT.RedEyes = true

ENT.ElectrocutionSequences = {
	"nz_electrocuted1",
	"nz_electrocuted2",
	"nz_electrocuted3",
	"nz_electrocuted4",
	"nz_electrocuted5",
}
ENT.EmergeSequences = {
	"nz_emerge1",
	"nz_emerge2",
	"nz_emerge3",
	"nz_emerge4",
	"nz_emerge5",
}
ENT.AttackHitSounds = {
	"npc/zombie/zombie_hit.wav"
}
ENT.PainSounds = {
	"physics/flesh/flesh_impact_bullet1.wav",
	"physics/flesh/flesh_impact_bullet2.wav",
	"physics/flesh/flesh_impact_bullet3.wav",
	"physics/flesh/flesh_impact_bullet4.wav",
	"physics/flesh/flesh_impact_bullet5.wav"
}
ENT.DeathSounds = {
	"nz/zombies/death/death_00.wav",
	"nz/zombies/death/death_01.wav",
	"nz/zombies/death/death_02.wav",
	"nz/zombies/death/death_03.wav",
	"nz/zombies/death/death_04.wav",
	"nz/zombies/death/death_05.wav",
	"nz/zombies/death/death_06.wav",
	"nz/zombies/death/death_07.wav",
	"nz/zombies/death/death_08.wav",
	"nz/zombies/death/death_09.wav",
	"nz/zombies/death/death_10.wav"
}

function ENT:StatsInitialize()
	if SERVER then
		if nzRound:GetNumber() == -1 then
			self:SetRunSpeed( math.random(30, 300) )
			self:SetHealth( math.random(100, 1500) )
		else
			local speeds = nzRound:GetZombieSpeeds()
			if speeds then
				self:SetRunSpeed( nzMisc.WeightedRandom(speeds) )
			else
				self:SetRunSpeed( 100 )
			end
			self:SetHealth( nzRound:GetZombieHealth() or 75 )
		end

		--Preselect the emerge sequnces for clientside use
		self:SetEmergeSequenceIndex(math.random(#self.EmergeSequences))
		
	end
end

function ENT:SpecialInit()

	if CLIENT then
	if not self:GetModel() == "models/nzr/nuketown_zombies1.mdl" then
		self:SetBodygroup(1,  math.random(0,2))
		end
		
		--make them invisible for a really short duration to blend the emerge sequences
		self:TimedEvent(0.1, function() -- Tiny delay just to make sure they are fully initialized
			if string.find(self:GetSequenceName(self:GetSequence()), "nz_emerge") then
				self:SetNoDraw(true)
				self:TimedEvent( 0.15, function()
					self:SetNoDraw(false)
				end)

				self:SetRenderClipPlaneEnabled( true )
				self:SetRenderClipPlane(self:GetUp(), self:GetUp():Dot(self:GetPos()))

				--local _, dur = self:LookupSequence(self.EmergeSequences[self:GetEmergeSequenceIndex()])
				local _, dur = self:LookupSequence(self.EmergeSequences[self:GetEmergeSequenceIndex()])
				dur = dur - (dur * self:GetCycle()) -- Subtract the time we are already thruogh the animation
				-- The above is important if the zombie only appears in PVS mid-way through the animation

				self:TimedEvent( dur, function()
					self:SetRenderClipPlaneEnabled(false)
				end)
			end
		end)

	end
end

function ENT:OnSpawn()

	local seq = self.EmergeSequences[self:GetEmergeSequenceIndex()]
	local _, dur = self:LookupSequence(seq)

	--dust cloud
	local effectData = EffectData()
	effectData:SetStart( self:GetPos() )
	effectData:SetOrigin( self:GetPos() )
	effectData:SetMagnitude(dur)
	util.Effect("zombie_spawn_dust", effectData)

	-- play emerge animation on spawn
	-- if we have a coroutine else just spawn the zombie without emerging for now.
	if coroutine.running() then
		self:PlaySequenceAndWait(seq)
	end
end

function ENT:OnZombieDeath(dmgInfo)

	if dmgInfo:GetDamageType() == DMG_SHOCK then
		self:SetRunSpeed(0)
		self.loco:SetVelocity(Vector(0,0,0))
		self:Stop()
		local seq, dur = self:LookupSequence(self.ElectrocutionSequences[math.random(#self.ElectrocutionSequences)])
		self:ResetSequence(seq)
		self:SetCycle(0)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		-- Emit electrocution scream here when added
		timer.Simple(dur, function()
			if IsValid(self) then
				self:BecomeRagdoll(dmgInfo)
			end
		end)
	else
		self:EmitSound( self.DeathSounds[ math.random( #self.DeathSounds ) ], 100)
		self:BecomeRagdoll(dmgInfo)
	end

end
