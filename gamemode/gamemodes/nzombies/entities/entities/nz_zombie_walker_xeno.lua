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
	"models/zombies/alien.mdl",
}

local AttackSequences = {
	{seq = "Attack1", dmgtimes = {0.4}},
	{seq = "Attack3", dmgtimes = {0.2}},
	{seq = "Attack4", dmgtimes = {0.5}},
	{seq = "Attack13", dmgtimes = {0.5}}
}
local WalkAttackSequences = {
	{seq = "Attack1", dmgtimes = {0.4}},
	{seq = "Attack2", dmgtimes = {0.35, 0.85}},
	{seq = "Attack3", dmgtimes = {0.2}},
	{seq = "Attack4", dmgtimes = {0.5}},
	{seq = "Attack7", dmgtimes = {0.3, 0.6, 0.9, 1.2}},
	{seq = "Attack13", dmgtimes = {0.5}}
}
local RunAttackSequences = {
	{seq = "Attack6", dmgtimes = {0.7}},
	{seq = "Attack8", dmgtimes = {0.45}},
	{seq = "Attack9", dmgtimes = {0.5}},
	{seq = "Runatk2", dmgtimes = {0.3}}
}

local AttackSounds = {
	"enemies/zombies/alien/vocals/aln_taunt_01",
	"enemies/zombies/alien/vocals/aln_taunt_02",
	"enemies/zombies/alien/vocals/aln_taunt_03",
	"enemies/zombies/alien/vocals/aln_taunt_04",
	"enemies/zombies/alien/vocals/aln_taunt_05",
	"enemies/zombies/alien/vocals/aln_taunt_06",
	"enemies/zombies/alien/vocals/aln_pain_small_1",
	"enemies/zombies/alien/vocals/aln_pain_small_2",
	"enemies/zombies/alien/vocals/aln_pain_small_3",
	"enemies/zombies/alien/vocals/aln_pain_small_4",
	"enemies/zombies/alien/vocals/aln_pain_small_5",
	"enemies/zombies/alien/vocals/aln_pain_small_6",
	"enemies/zombies/alien/vocals/aln_pain_small_7",
	"enemies/zombies/alien/vocals/aln_pain_small_8",
	"enemies/zombies/alien/vocals/aln_pain_small_9",
	"enemies/zombies/alien/vocals/aln_pain_small_10"
	
}

local WalkSounds = {
	"enemies/zombies/alien/vocals/alien_breathing_steady_01",
	"enemies/zombies/alien/footsteps/walk/prd_fs_dirt_1",
	"enemies/zombies/alien/footsteps/walk/prd_fs_dirt_2",
	"enemies/zombies/alien/footsteps/walk/prd_fs_dirt_3",
	"enemies/zombies/alien/footsteps/walk/prd_fs_dirt_4",
	"enemies/zombies/alien/footsteps/walk/prd_fs_dirt_5",
	"enemies/zombies/alien/footsteps/walk/prd_fs_dirt_6",
	"enemies/zombies/alien/footsteps/walk/prd_fs_dirt_7",
	"enemies/zombies/alien/footsteps/walk/prd_fs_dirt_8",
	"enemies/zombies/alien/footsteps/walk/prd_fs_dirt_9",
	"enemies/zombies/alien/footsteps/walk/prd_fs_dirt_10",
	"enemies/zombies/alien/footsteps/walk/prd_fs_dirt_11",
	"enemies/zombies/alien/footsteps/walk/prd_fs_dirt_12",
	"enemies/zombies/alien/footsteps/walk/prd_fs_dirt_13",
	"enemies/zombies/alien/footsteps/walk/prd_fs_dirt_14",
	"enemies/zombies/alien/footsteps/walk/prd_fs_dirt_15"
}

local RunSounds = {
	"enemies/zombies/alien/footsteps/walk/prd_fs_dirt_1",
	"enemies/zombies/alien/footsteps/walk/prd_fs_dirt_2",
	"enemies/zombies/alien/footsteps/walk/prd_fs_dirt_3",
	"enemies/zombies/alien/footsteps/walk/prd_fs_dirt_4",
	"enemies/zombies/alien/footsteps/walk/prd_fs_dirt_5",
	"enemies/zombies/alien/footsteps/walk/prd_fs_dirt_6",
	"enemies/zombies/alien/footsteps/walk/prd_fs_dirt_7",
	"enemies/zombies/alien/footsteps/walk/prd_fs_dirt_8",
	"enemies/zombies/alien/footsteps/walk/prd_fs_dirt_9",
	"enemies/zombies/alien/footsteps/walk/prd_fs_dirt_10",
	"enemies/zombies/alien/footsteps/walk/prd_fs_dirt_11",
	"enemies/zombies/alien/footsteps/walk/prd_fs_dirt_12",
	"enemies/zombies/alien/footsteps/walk/prd_fs_dirt_13",
	"enemies/zombies/alien/footsteps/walk/prd_fs_dirt_14",
	"enemies/zombies/alien/footsteps/walk/prd_fs_dirt_15"
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
	"enemies/zombies/alien/alien_clawhit_flesh_tp_1.ogg",
	"enemies/zombies/alien/alien_clawhit_flesh_tp_2.ogg",
	"enemies/zombies/alien/alien_clawhit_flesh_tp_3.ogg",
	"enemies/zombies/alien/alien_clawhit_flesh_tp_4.ogg",
	"enemies/zombies/alien/alien_clawhit_flesh_tp_5.ogg"
}
ENT.PainSounds = {
	"physics/flesh/flesh_impact_bullet1.wav",
	"physics/flesh/flesh_impact_bullet2.wav",
	"physics/flesh/flesh_impact_bullet3.wav",
	"physics/flesh/flesh_impact_bullet4.wav",
	"physics/flesh/flesh_impact_bullet5.wav"
}
ENT.DeathSounds = {
	"enemies/zombies/alien/vocals/alien_death_scream_iconic_elephant.ogg",
	"enemies/zombies/alien/vocals/aln_death_scream_20.ogg",
	"enemies/zombies/alien/vocals/aln_death_scream_21.ogg",
	"enemies/zombies/alien/vocals/aln_death_scream_22.ogg",
	"enemies/zombies/alien/vocals/aln_death_scream_23.ogg",
	"enemies/zombies/alien/vocals/aln_death_scream_24.ogg",
	"enemies/zombies/alien/vocals/aln_death_scream_25.ogg",
	"enemies/zombies/alien/vocals/aln_death_scream_26.ogg",
	"enemies/zombies/alien/vocals/aln_death_scream_27.ogg"
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
		self:EmitSound("enemies/zombies/alien/vocals/aln_pain_small_" ..math.random(1,10)..".ogg", 75, 100, 1)

	-- play emerge animation on spawn
	-- if we have a coroutine else just spawn the zombie without emerging for now.
	if coroutine.running() then
		self:PlaySequenceAndWait(seq)
	end
end

function ENT:OnThink()
if math.random(0,1500) == 965 then
if math.random(0,1) == 0 then
self:EmitSound("enemies/zombies/alien/vocals/alien_growl_short_0" ..math.random(1,5)..".ogg", 70, 100, 1)
else
if math.random(0,1) == 0 then
self:EmitSound("enemies/zombies/alien/vocals/alien_hiss_long_0" ..math.random(1,2)..".ogg", 70, 100, 1)
else
self:EmitSound("enemies/zombies/alien/vocals/aln_taunt_0" ..math.random(1,6)..".ogg", 70, 100, 1)
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

function ENT:OnTargetInAttackRange()
    local atkData = {}
    atkData.dmgforce = Vector( 0, 0, 0 )
    self:Attack( atkData )
end
