AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.Type = "nextbot"
ENT.Category = "Brainz"
ENT.Author = "Lolle/Moo"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Decapitated")
	self:NetworkVar("Bool", 1, "Alive")
	self:NetworkVar("Bool", 2, "MooSpecial")
end

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = false
ENT.IsMooSpecial = true

ENT.Models = {
	{Model = "models/moo/_codz_ports/t8/ofc_quadcrawler/moo_codz_t8_nova_crawler.mdl", Skin = 0, Bodygroups = {0,0}},
	--{Model = "models/moo/_codz_ports/t8/ofc_quadcrawler/moo_codz_t8_nova_bomber.mdl", Skin = 0, Bodygroups = {0,0}},
}

ENT.DeathSequences = {
	"nz_death_v1",
	"nz_death_v2",
	"nz_death_v3",
	"nz_death_v4",
	"nz_death_v5",
	"nz_death_v6"
}

ENT.BarricadeTearSequences = {
	--Leave this empty if you don't intend on having a special enemy use tear anims.
}

local AttackSequences = {
	{seq = "nz_attack_v1", dmgtimes = {0.7}},
	{seq = "nz_attack_v2", dmgtimes = {0.5}},
	{seq = "nz_attack_v3", dmgtimes = {0.7}},
	{seq = "nz_attack_v4", dmgtimes = {0.5}},
	{seq = "nz_attack_v5", dmgtimes = {0.7}},
	{seq = "nz_attack_v6", dmgtimes = {0.7}},
}

local JumpSequences = {
	{seq = "nz_mantle", speed = 15, time = 2.5},
}

local walksounds = {
	Sound("nz_moo/zombies/vox/_quad/amb/amb_00.mp3"),
	Sound("nz_moo/zombies/vox/_quad/amb/amb_01.mp3"),
	Sound("nz_moo/zombies/vox/_quad/amb/amb_02.mp3"),
	Sound("nz_moo/zombies/vox/_quad/amb/amb_03.mp3"),
	Sound("nz_moo/zombies/vox/_quad/amb/amb_04.mp3"),
	Sound("nz_moo/zombies/vox/_quad/amb/amb_05.mp3"),
	Sound("nz_moo/zombies/vox/_quad/amb/amb_06.mp3"),
	Sound("nz_moo/zombies/vox/_quad/amb/amb_07.mp3"),
	Sound("nz_moo/zombies/vox/_quad/amb/amb_08.mp3"),
	Sound("nz_moo/zombies/vox/_quad/amb/amb_09.mp3"),
	Sound("nz_moo/zombies/vox/_quad/amb/amb_10.mp3"),
	Sound("nz_moo/zombies/vox/_quad/amb/amb_11.mp3"),
	Sound("nz_moo/zombies/vox/_quad/amb/amb_12.mp3"),
}

ENT.IdleSequence = "nz_idle_v1"

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			MovementSequence = {
				"nz_crawl_v1",
				"nz_crawl_v2",
				"nz_crawl_v3",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 36, Sequences = {
		{
			MovementSequence = {
				"nz_crawl_run_v1",
				"nz_crawl_run_v2",
				"nz_crawl_run_v3",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 71, Sequences = {
		{
			MovementSequence = {
				"nz_crawl_sprint_v1", -- This anim looks poo poo most the time. 1/24/23: Ok maybe not anymore since 1:1 speed exists now.
				"nz_crawl_sprint_v2",
				"nz_crawl_sprint_v3",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}}
}

ENT.AttackHitSounds = {
	"nz/zombies/attack/player_hit_0.wav",
	"nz/zombies/attack/player_hit_1.wav",
	"nz/zombies/attack/player_hit_2.wav",
	"nz/zombies/attack/player_hit_3.wav",
	"nz/zombies/attack/player_hit_4.wav",
	"nz/zombies/attack/player_hit_5.wav"
}

ENT.PainSounds = {
	"nz/zombies/death/nz_flesh_impact_1.wav",
	"nz/zombies/death/nz_flesh_impact_2.wav",
	"nz/zombies/death/nz_flesh_impact_3.wav",
	"nz/zombies/death/nz_flesh_impact_4.wav"
}

ENT.DeathSounds = {
	"nz_moo/zombies/vox/_quad/death/death_00.mp3",
	"nz_moo/zombies/vox/_quad/death/death_01.mp3",
	"nz_moo/zombies/vox/_quad/death/death_02.mp3",
	"nz_moo/zombies/vox/_quad/death/death_03.mp3",
	"nz_moo/zombies/vox/_quad/death/death_04.mp3",
	"nz_moo/zombies/vox/_quad/death/death_05.mp3",
	"nz_moo/zombies/vox/_quad/death/death_06.mp3",
	"nz_moo/zombies/vox/_quad/death/death_07.mp3",
}

ENT.AttackSounds = {
	"nz_moo/zombies/vox/_quad/attack/attack_00.mp3",
	"nz_moo/zombies/vox/_quad/attack/attack_01.mp3",
	"nz_moo/zombies/vox/_quad/attack/attack_02.mp3",
	"nz_moo/zombies/vox/_quad/attack/attack_03.mp3",
	"nz_moo/zombies/vox/_quad/attack/attack_04.mp3",
	"nz_moo/zombies/vox/_quad/attack/attack_05.mp3",
	"nz_moo/zombies/vox/_quad/attack/attack_06.mp3",
	"nz_moo/zombies/vox/_quad/attack/attack_07.mp3",
	"nz_moo/zombies/vox/_quad/attack/attack_08.mp3",
	"nz_moo/zombies/vox/_quad/attack/attack_09.mp3",
	"nz_moo/zombies/vox/_quad/attack/attack_10.mp3",
	"nz_moo/zombies/vox/_quad/attack/attack_11.mp3",
	"nz_moo/zombies/vox/_quad/attack/attack_12.mp3",
	"nz_moo/zombies/vox/_quad/attack/attack_13.mp3",
}

ENT.BehindSoundDistance = 200 -- When the zombie is within 200 units of a player, play these sounds instead
ENT.BehindSounds = {
	Sound("nz_moo/zombies/vox/_quad/behind/behind_00.mp3"),
	Sound("nz_moo/zombies/vox/_quad/behind/behind_01.mp3"),
}

function ENT:StatsInitialize()
	if SERVER then
		self:SetMooSpecial(true)
		if nzRound:GetNumber() == -1 then
			self:SetRunSpeed( math.random(20, 105) )
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
	end
end

function ENT:SpecialInit()
	if CLIENT then
	end
end

function ENT:OnSpawn()
	if self:GetRunSpeed() > 130 then -- Novas are slower than normal zombies so this makes sense.
		timer.Simple(engine.TickInterval(), function()
			--print("Little Gremlin")
			self:SetRunSpeed(130)
			self.loco:SetDesiredSpeed( self:GetRunSpeed() )
		end)
	end
	timer.Simple(engine.TickInterval(), function()
		if IsValid(self) then
			self:EmitSound("nz_moo/zombies/vox/_quad/spawn/spawn_0"..math.random(3)..".mp3", 100, math.random(95, 105), 1, 2)
			self:EmitSound("nz_moo/effects/teleport_in_00.mp3", 100)
			if IsValid(self) then ParticleEffectAttach("panzer_spawn_tp", 3, self, 2) end
			if IsValid(self) then ParticleEffectAttach("novagas_trail", 4, self, 2) end
		end
	end)
end


--[[ CUSTOM/MODIFIED THINGS FROM BASE HERE ]]--

function ENT:PerformDeath(dmgInfo)
	if dmgInfo:GetDamageType() == DMG_REMOVENORAGDOLL then self:Remove(dmgInfo) end
	if self.DeathRagdollForce == 0 or self.DeathRagdollForce <= dmgInfo:GetDamageForce():Length() and dmgInfo:GetDamageType() ~= DMG_REMOVENORAGDOLL or self:GetSpecialAnimation() then
		self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
		self:Remove(dmgInfo)
	else
		self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
		self:DoDeathAnimation(self.DeathSequences[math.random(#self.DeathSequences)])
	end
end


function ENT:DoDeathAnimation(seq) -- Modified death function to have a chance of spawning a gas cloud on death.
	local GasDeathChance = math.random(2)
	self.BehaveThread = coroutine.create(function()
		self:PlaySequenceAndWait(seq)
		if GasDeathChance == 2 then
			print("Stinky Child... Gross")
			local fuckercloud = ents.Create("nova_gas_cloud")
			fuckercloud:SetPos(self:GetPos())
			fuckercloud:SetAngles(Angle(0,0,0))
			fuckercloud:Spawn()
		end
		self:Remove(DamageInfo())
	end)
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
				self.loco:SetDesiredSpeed( self:GetRunSpeed() )
			end
			return
		end
		if self:IsValidTarget( self:GetTarget() ) then
			self.loco:FaceTowards( self:GetTarget():GetPos() )
		end

		coroutine.yield()

	end

end