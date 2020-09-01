AddCSLuaFile()

ENT.Base = "nz_zombiebase"
ENT.PrintName = "Xenomorph"
ENT.Category = "Brainz"
ENT.Author = "Lolle"

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "EmergeSequenceIndex")
	self:NetworkVar("Bool", 1, "Decapitated")
end

ENT.Models = {
	"models/alien/alien.mdl",
}

local AttackSequences = {
	{seq = "Attack1", dmgtimes = {0.4}},
	{seq = "Attack3", dmgtimes = {0.2}},
	{seq = "Attack4", dmgtimes = {0.5}},
	{seq = "Attack13", dmgtimes = {0.5}}
}
local WalkAttackSequences = {
	{seq = "Attack1", dmgtimes = {0.4}},
	{seq = "Attack3", dmgtimes = {0.2}},
	{seq = "Attack4", dmgtimes = {0.5}},
	{seq = "Attack13", dmgtimes = {0.5}}
}
local RunAttackSequences = {
	{seq = "Attack6", dmgtimes = {0.7}},
	{seq = "Attack9", dmgtimes = {0.5}},
	{seq = "RunAttack1", dmgtimes = {0.3}},
	{seq = "RunAttack2", dmgtimes = {0.3}}
}

local AttackSounds = {
	"character/alien/vocals/aln_taunt_01",
	"character/alien/vocals/aln_taunt_02",
	"character/alien/vocals/aln_taunt_03",
	"character/alien/vocals/aln_taunt_04",
	"character/alien/vocals/aln_taunt_05",
	"character/alien/vocals/aln_taunt_06",
	"character/alien/vocals/aln_pain_small_1",
	"character/alien/vocals/aln_pain_small_2",
	"character/alien/vocals/aln_pain_small_3",
	"character/alien/vocals/aln_pain_small_4",
	"character/alien/vocals/aln_pain_small_5",
	"character/alien/vocals/aln_pain_small_6",
	"character/alien/vocals/aln_pain_small_7",
	"character/alien/vocals/aln_pain_small_8",
	"character/alien/vocals/aln_pain_small_9",
	"character/alien/vocals/aln_pain_small_10"
	
}

local WalkSounds = {
	"character/alien/vocals/alien_breathing_steady_01",
	"character/alien/footsteps/walk/prd_fs_dirt_1",
	"character/alien/footsteps/walk/prd_fs_dirt_2",
	"character/alien/footsteps/walk/prd_fs_dirt_3",
	"character/alien/footsteps/walk/prd_fs_dirt_4",
	"character/alien/footsteps/walk/prd_fs_dirt_5",
	"character/alien/footsteps/walk/prd_fs_dirt_6",
	"character/alien/footsteps/walk/prd_fs_dirt_7",
	"character/alien/footsteps/walk/prd_fs_dirt_8",
	"character/alien/footsteps/walk/prd_fs_dirt_9",
	"character/alien/footsteps/walk/prd_fs_dirt_10",
	"character/alien/footsteps/walk/prd_fs_dirt_11",
	"character/alien/footsteps/walk/prd_fs_dirt_12",
	"character/alien/footsteps/walk/prd_fs_dirt_13",
	"character/alien/footsteps/walk/prd_fs_dirt_14",
	"character/alien/footsteps/walk/prd_fs_dirt_15"
}

local RunSounds = {
	"character/alien/footsteps/walk/prd_fs_dirt_1",
	"character/alien/footsteps/walk/prd_fs_dirt_2",
	"character/alien/footsteps/walk/prd_fs_dirt_3",
	"character/alien/footsteps/walk/prd_fs_dirt_4",
	"character/alien/footsteps/walk/prd_fs_dirt_5",
	"character/alien/footsteps/walk/prd_fs_dirt_6",
	"character/alien/footsteps/walk/prd_fs_dirt_7",
	"character/alien/footsteps/walk/prd_fs_dirt_8",
	"character/alien/footsteps/walk/prd_fs_dirt_9",
	"character/alien/footsteps/walk/prd_fs_dirt_10",
	"character/alien/footsteps/walk/prd_fs_dirt_11",
	"character/alien/footsteps/walk/prd_fs_dirt_12",
	"character/alien/footsteps/walk/prd_fs_dirt_13",
	"character/alien/footsteps/walk/prd_fs_dirt_14",
	"character/alien/footsteps/walk/prd_fs_dirt_15"
}

local JumpSequences = {
	{seq = "Idle_2", speed = 15, time = 2.7}
}
local SprintJumpSequences = {
	{seq = "Idle_5", speed = 50, time = 1.9}
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


ENT.ElectrocutionSequences = {
	"Flinch_Leg_Left1",
	"Flinch_Leg_Left2"
}
ENT.EmergeSequences = {
	"Emerge1",
	"Emerge2",
	"Emerge3"
}
ENT.AttackHitSounds = {
	"weapons/alien/alien_clawhit_flesh_tp_1.mp3",
	"weapons/alien/alien_clawhit_flesh_tp_2.mp3",
	"weapons/alien/alien_clawhit_flesh_tp_3.mp3",
	"weapons/alien/alien_clawhit_flesh_tp_4.mp3",
	"weapons/alien/alien_clawhit_flesh_tp_5.mp3"
}
ENT.PainSounds = {
	"physics/flesh/flesh_impact_bullet1.wav",
	"physics/flesh/flesh_impact_bullet2.wav",
	"physics/flesh/flesh_impact_bullet3.wav",
	"physics/flesh/flesh_impact_bullet4.wav",
	"physics/flesh/flesh_impact_bullet5.wav"
}
ENT.DeathSounds = {
	"character/alien/vocals/alien_death_scream_iconic_elephant.mp3",
	"character/alien/vocals/aln_death_scream_20.mp3",
	"character/alien/vocals/aln_death_scream_21.mp3",
	"character/alien/vocals/aln_death_scream_22.mp3",
	"character/alien/vocals/aln_death_scream_23.mp3",
	"character/alien/vocals/aln_death_scream_24.mp3",
	"character/alien/vocals/aln_death_scream_25.mp3",
	"character/alien/vocals/aln_death_scream_26.mp3",
	"character/alien/vocals/aln_death_scream_27.mp3"
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
<<<<<<< Updated upstream:gamemode/gamemodes/nzombies/entities/entities/nz_zombie_walkerxeno4.lua
=======
		 self:SetBodygroup( 0, math.random(0,4) )
		 self:SetBodygroup( 1, math.random(0,1) )
>>>>>>> Stashed changes:gamemode/gamemodes/nzombies/entities/entities/nz_zombie_walker_five.lua
	end
end

function ENT:SpecialInit()

	if CLIENT then
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
	self:EmitSound("character/alien/vocals/aln_pain_small_" ..math.random(1,10)..".mp3", 75, 100, 1)

	-- play emerge animation on spawn
	-- if we have a coroutine else just spawn the zombie without emerging for now.
	if coroutine.running() then
		self:PlaySequenceAndWait(seq)
	end
end

function ENT:OnThink()
if math.random(0,1500) == 965 then
if math.random(0,1) == 0 then
self:EmitSound("character/alien/vocals/alien_growl_short_0" ..math.random(1,5)..".mp3", 70, 100, 1)
else
if math.random(0,1) == 0 then
self:EmitSound("character/alien/vocals/alien_hiss_long_0" ..math.random(1,2)..".mp3", 70, 100, 1)
else
self:EmitSound("character/alien/vocals/aln_taunt_0" ..math.random(1,6)..".mp3", 70, 100, 1)
end

end
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
