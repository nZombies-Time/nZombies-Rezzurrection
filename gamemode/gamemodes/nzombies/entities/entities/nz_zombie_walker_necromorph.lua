AddCSLuaFile()

ENT.Base = "nz_zombiebase"
ENT.PrintName = "Deadspace Slasher"
ENT.Category = "Brainz"
ENT.Author = "Lolle"

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "EmergeSequenceIndex")
	self:NetworkVar("Bool", 1, "Decapitated")
end

ENT.Models = { "models/zombies/slasher_c2.mdl",
			   "models/zombies/slasher_cm2.mdl",
			   "models/zombies/slasher_c3.mdl",
			   "models/zombies/slasher_f6.mdl",
			   "models/zombies/slasher_g8.mdl",
			   "models/zombies/slasher_h9.mdl",
			   "models/zombies/slasher_m11.mdl",
			   "models/zombies/slasher_s14.mdl",
			   "models/zombies/slasher_a1.mdl",
			   "models/zombies/slasher_l10.mdl",
			   "models/zombies/slasher_n13.mdl",
			   "models/zombies/slasher_s15.mdl",
			   "models/zombies/slasher_fm7.mdl",
			   "models/zombies/slasher_f7.mdl",
			   "models/zombies/slasher_e5.mdl",
			   "models/zombies/slasher_d4.mdl",
			   "models/zombies/slasher_n12.mdl",
			   "models/zombies/slasher_t17.mdl",
			   "models/zombies/slasher_t16.mdl",
			   "models/zombies/slasher_z18.mdl"		
 }

local AttackSequences = {
	{seq = "attack", dmgtimes = {0.5}},
	{seq = "attack2", dmgtimes = {0.5}},
	{seq = "attack3", dmgtimes = {0.5}}
}
local WalkAttackSequences = {
	{seq = "attack", dmgtimes = {0.5}},
	{seq = "attack2", dmgtimes = {0.5}},
	{seq = "attack3", dmgtimes = {0.5}}
}
local RunAttackSequences = {
	{seq = "attack", dmgtimes = {0.5}},
	{seq = "attack2", dmgtimes = {0.5}},
	{seq = "attack3", dmgtimes = {0.5}}
}

ENT.AttackSounds = {
	"enemies/zombies/slasher/twitcher_security_097.ogg",
	"enemies/zombies/slasher/twitcher_security_098.ogg",
	"enemies/zombies/slasher/twitcher_security_099.ogg",
	"enemies/zombies/slasher/twitcher_security_100.ogg",
	"enemies/zombies/slasher/twitcher_security_101.ogg",
	"enemies/zombies/slasher/twitcher_security_087.ogg",
	"enemies/zombies/slasher/twitcher_security_089.ogg",
	"enemies/zombies/slasher/twitcher_security_090.ogg",
	"enemies/zombies/slasher/twitcher_security_091.ogg",
	"enemies/zombies/slasher/twitcher_security_092.ogg",
	"enemies/zombies/slasher/twitcher_security_095.ogg",
	"enemies/zombies/slasher/twitcher_security_096.ogg",
	"enemies/zombies/slasher/armor/slasher_armor_082.ogg",
	"enemies/zombies/slasher/armor/slasher_armor_083.ogg",
	"enemies/zombies/slasher/armor/slasher_armor_084.ogg",
	"enemies/zombies/slasher/slashertwister_091.ogg",
	"enemies/zombies/slasher/slashertwister_092.ogg",
	"enemies/zombies/slasher/slasher_gov_worker_054.ogg",
	"enemies/zombies/slasher/slasher_gov_worker_055.ogg",
	"enemies/zombies/slasher/slasher_male_civilian_054.ogg",
	"enemies/zombies/slasher/slasher_male_civilian_055.ogg",
}

local WalkSounds = {
	"enemies/zombies/slasher/slashertwister_088.ogg",
	"enemies/zombies/slasher/twitcher_security_077.ogg",
	"enemies/zombies/slasher/twitcher_security_097.ogg",
	"enemies/zombies/slasher/twitcher_security_098.ogg",
	"enemies/zombies/slasher/twitcher_security_099.ogg",
	"enemies/zombies/slasher/twitcher_security_100.ogg",
	"enemies/zombies/slasher/twitcher_security_101.ogg",
	"enemies/zombies/slasher/armor/slasher_armor_056.ogg",
	"enemies/zombies/slasher/armor/slasher_armor_084.ogg",
	"enemies/zombies/slasher/slasher_gov_worker_056.ogg",
	"enemies/zombies/slasher/slasher_gov_worker_057.ogg",
	"enemies/zombies/slasher/slasher_male_civilian_058.ogg",
	"enemies/zombies/slasher/slasher_male_civilian_056.ogg"
}

local RunSounds = {
	"enemies/zombies/slasher/slashertwister_088.ogg",
	"enemies/zombies/slasher/twitcher_security_074.ogg",
	"enemies/zombies/slasher/twitcher_security_075.ogg",
	"enemies/zombies/slasher/twitcher_security_076.ogg",
	"enemies/zombies/slasher/twitcher_security_077.ogg",
	"enemies/zombies/slasher/armor/slasher_armor_054.ogg",
	"enemies/zombies/slasher/armor/slasher_armor_055.ogg",
	"enemies/zombies/slasher/armor/slasher_armor_057.ogg",
	"enemies/zombies/slasher/armor/slasher_armor_084.ogg",
	"enemies/zombies/slasher/slasher_gov_worker_054.ogg",
	"enemies/zombies/slasher/slasher_gov_worker_055.ogg",
	"enemies/zombies/slasher/slasher_gov_worker_056.ogg",
	"enemies/zombies/slasher/slasher_male_civilian_054.ogg",
	"enemies/zombies/slasher/slasher_male_civilian_055.ogg",
	"enemies/zombies/slasher/slasher_male_civilian_056.ogg"

}

local JumpSequences = {
	{seq = "attack4", speed = 40, time = 0.8}
}
local SprintJumpSequences = {
	{seq = "attack4", speed = 40, time = 0.8}
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
		act = ACT_WALK,
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
		act = ACT_RUN,
		minspeed = 160,
		attackanims = RunAttackSequences,
		sounds = RunSounds,
		barricadejumps = SprintJumpSequences,
	},
}

ENT.ElectrocutionSequences = {
	"flinch"
}
ENT.EmergeSequences = {
	"weak"
}
ENT.AttackHitSounds = {
	"enemies/specials/pack/hit/pack_boy_09.ogg",
	"enemies/specials/pack/hit/pack_boy_10.ogg"
}
ENT.PainSounds = {
"physics/flesh/flesh_impact_bullet1.wav",
	"physics/flesh/flesh_impact_bullet2.wav",
	"physics/flesh/flesh_impact_bullet3.wav",
	"physics/flesh/flesh_impact_bullet4.wav",
	"physics/flesh/flesh_impact_bullet5.wav",
	"enemies/zombies/slasher/twitcher_security_082.ogg",
	"enemies/zombies/slasher/twitcher_security_084.ogg",
	"enemies/zombies/slasher/twitcher_security_085.ogg",
}
ENT.DeathSounds = {
	"enemies/zombies/slasher/twitcher_security_078.ogg",
	"enemies/zombies/slasher/twitcher_security_079.ogg",
	"enemies/zombies/slasher/twitcher_security_080.ogg",
	"enemies/zombies/slasher/twitcher_security_081.ogg",
	"enemies/zombies/slasher/slashertwister_096.ogg",
	"enemies/zombies/slasher/slashertwister_097.ogg",
	"enemies/zombies/slasher/armor/slasher_armor_057.ogg",
	"enemies/zombies/slasher/armor/slasher_armor_058.ogg",
	"enemies/zombies/slasher/armor/slasher_armor_059.ogg",
	"enemies/zombies/slasher/armor/slasher_armor_085.ogg",
	"enemies/zombies/slasher/armor/slasher_armor_086.ogg",
	"enemies/zombies/slasher/armor/slasher_armor_087.ogg",
	"enemies/zombies/slasher/slasher_gov_worker_057.ogg",
	"enemies/zombies/slasher/slasher_gov_worker_058.ogg",
	"enemies/zombies/slasher/slasher_gov_worker_059.ogg",
	"enemies/zombies/slasher/slasher_male_civilian_057.ogg",
	"enemies/zombies/slasher/slasher_male_civilian_058.ogg",
	"enemies/zombies/slasher/slasher_male_civilian_059.ogg"
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

	-- play emerge animation on spawn
	-- if we have a coroutine else just spawn the zombie without emerging for now.
	if coroutine.running() then
		self:PlaySequenceAndWait(seq)
	end
end

function ENT:OnZombieDeath(dmgInfo)
		self:EmitSound( self.DeathSounds[ math.random( #self.DeathSounds ) ], 100)
		ParticleEffect("baby_dead",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
		self:Remove()

end
