AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Hellhound"
ENT.Category = "Brainz"
ENT.Author = "Lolle and Moo"

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Decapitated")
	self:NetworkVar("Bool", 1, "Alive")
	self:NetworkVar("Bool", 2, "MooSpecial")
end

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true
ENT.IsMooSpecial = true
ENT.AttackRange = 80

ENT.Models = {
	{Model = "models/moo/pupper/moo_zombie_woofer.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"nz_sleep_wake_fast"}

local AttackSequences = {
	{seq = "nz_attack1", dmgtimes = {0.3}},
	{seq = "nz_attack2", dmgtimes = {0.3}},
	{seq = "nz_attack3", dmgtimes = {0.3}},
}

local JumpSequences = {
	{seq = ACT_JUMP, speed = 30},
}

ENT.IdleSequence = "nz_idle1"

ENT.DeathSequences = {
	"nz_death1",
	"nz_death2",
	"nz_death3",
}

ENT.AttackSounds = {
	"nz_moo/zombies/vox/_hellhound/attack/attack_00.mp3",
	"nz_moo/zombies/vox/_hellhound/attack/attack_01.mp3",
	"nz_moo/zombies/vox/_hellhound/attack/attack_02.mp3",
	"nz_moo/zombies/vox/_hellhound/attack/attack_03.mp3",
	"nz_moo/zombies/vox/_hellhound/attack/attack_04.mp3",
	"nz_moo/zombies/vox/_hellhound/attack/attack_05.mp3"
}

ENT.AttackHitSounds = {
	"nz_moo/zombies/vox/_hellhound/bite/bite_00.mp3",
	"nz_moo/zombies/vox/_hellhound/bite/bite_01.mp3",
	"nz_moo/zombies/vox/_hellhound/bite/bite_02.mp3"
}

ENT.WalkSounds = {
	"nz_moo/zombies/vox/_hellhound/movement/movement_00.mp3",
	"nz_moo/zombies/vox/_hellhound/movement/movement_01.mp3",
	"nz_moo/zombies/vox/_hellhound/movement/movement_02.mp3",
	"nz_moo/zombies/vox/_hellhound/movement/movement_03.mp3",
	"nz_moo/zombies/vox/_hellhound/movement/movement_04.mp3",
	"nz_moo/zombies/vox/_hellhound/movement/movement_05.mp3",
	"nz_moo/zombies/vox/_hellhound/movement/movement_06.mp3",
	"nz_moo/zombies/vox/_hellhound/movement/movement_07.mp3"
}

local walksounds = {
	Sound("nz_moo/zombies/vox/_hellhound/movement/movement_00.mp3"),
	Sound("nz_moo/zombies/vox/_hellhound/movement/movement_01.mp3"),
	Sound("nz_moo/zombies/vox/_hellhound/movement/movement_02.mp3"),
	Sound("nz_moo/zombies/vox/_hellhound/movement/movement_03.mp3"),
	Sound("nz_moo/zombies/vox/_hellhound/movement/movement_04.mp3"),
	Sound("nz_moo/zombies/vox/_hellhound/movement/movement_05.mp3"),
	Sound("nz_moo/zombies/vox/_hellhound/movement/movement_06.mp3"),
	Sound("nz_moo/zombies/vox/_hellhound/movement/movement_07.mp3"),
}

local runsounds = {
	Sound("nz/hellhound/close/close_00.wav"),
	Sound("nz/hellhound/close/close_01.wav"),
	Sound("nz/hellhound/close/close_02.wav"),
	Sound("nz/hellhound/close/close_03.wav"),
}

ENT.PainSounds = {
	"physics/flesh/flesh_impact_bullet1.wav",
	"physics/flesh/flesh_impact_bullet2.wav",
	"physics/flesh/flesh_impact_bullet3.wav",
	"physics/flesh/flesh_impact_bullet4.wav",
	"physics/flesh/flesh_impact_bullet5.wav"
}

ENT.DeathSounds = {
	"nz_moo/zombies/vox/_hellhound/death/death_00.mp3",
	"nz_moo/zombies/vox/_hellhound/death/death_01.mp3",
	"nz_moo/zombies/vox/_hellhound/death/death_02.mp3",
	"nz_moo/zombies/vox/_hellhound/death/death_03.mp3",
	"nz_moo/zombies/vox/_hellhound/death/death_04.mp3",
	"nz_moo/zombies/vox/_hellhound/death/death_05.mp3",
	"nz_moo/zombies/vox/_hellhound/death/death_06.mp3",
}

ENT.AppearSounds = {
	"nz_moo/zombies/vox/_hellhound/appear/appear_00.mp3",
	"nz_moo/zombies/vox/_hellhound/appear/appear_01.mp3",
	"nz_moo/zombies/vox/_hellhound/appear/appear_02.mp3",
	"nz_moo/zombies/vox/_hellhound/appear/appear_03.mp3"
}

ENT.SprintSounds = {
	"nz/hellhound/close/close_00.wav",
	"nz/hellhound/close/close_01.wav",
	"nz/hellhound/close/close_02.wav",
	"nz/hellhound/close/close_03.wav",
}

ENT.ActStages = {
	[1] = {
		act = ACT_WALK,
		minspeed = 0,
		attackanims = AttackSequences,
		barricadejumps = JumpSequences,
	}
}

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"nz_search",
				"nz_walk",
			},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 150, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"nz_run1",
			},
			PassiveSounds = {runsounds},
		},
	}}
}

function ENT:StatsInitialize()
	if SERVER then
		self.Sprinting = false
		self:SetRunSpeed( 125 )
		self.loco:SetDesiredSpeed( 125 )
		--[[if not nzRound:InState( ROUND_CREATE ) or nzRound:GetNumber() == -1 then
			self:SetHealth( nzRound:GetNumber() * 1.5 + 150 )
			print(self:Health())
		else
			self:SetHealth( math.random(120, 1200) ) -- Creative/Infinite Round Health
		end]]
	end
	self:SetCollisionBounds(Vector(-14,-14, 0), Vector(14, 14, 48))
end

function ENT:OnSpawn()
	self:SetNoDraw(true)
	self:SetInvulnerable(true)
	self:SetBlockAttack(true)
	self:SolidMaskDuringEvent(MASK_SOLID_BRUSHONLY)
	self:SetSpecialAnimation(true)

	self:EmitSound("bo1_overhaul/hhound/prespawn.mp3",511,100)
	ParticleEffect("hound_summon",self:GetPos(),self:GetAngles(),nil)

	local seq = self:SelectSpawnSequence()
	if seq then
		self:PlaySequenceAndWait(seq)
		self:EmitSound("bo1_overhaul/lgtstrike.mp3",511,100)
		self:SetNoDraw(false)
		self:SetInvulnerable(nil)
		self:SetBlockAttack(false)
		self:SetSpecialAnimation(false)
		self:CollideWhenPossible()
		self:ResetMovementSequence()
		ParticleEffectAttach("firestaff_victim_burning",PATTACH_ABSORIGIN_FOLLOW,self,0)
		self:EmitSound(self.AppearSounds[math.random(#self.AppearSounds)], 100, math.random(85, 105), 1, 2)
	end

	nzRound:SetNextSpawnTime(CurTime() + 3) -- This one spawning delays others by 3 seconds
end

function ENT:PerformDeath(dmgInfo)
	if self:GetSpecialAnimation() then
		self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
		if IsValid(self) then
			ParticleEffect("hound_explosion",self:GetPos(),self:GetAngles(),self)
			self:Explode( math.random( 25, 50 )) -- Doggy goes Kaboom! Since they explode on death theres no need for them to play death anims.
			self:Remove()
		end
	else
		self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
		self:DoDeathAnimation(self.DeathSequences[math.random(#self.DeathSequences)])
	end
end

function ENT:DoDeathAnimation(seq)
	self.BehaveThread = coroutine.create(function()
		self:PlaySequenceAndWait(seq)
		if IsValid(self) then
			ParticleEffect("hound_explosion",self:GetPos(),self:GetAngles(),self)
			self:Explode( math.random( 25, 50 )) -- Doggy goes Kaboom! Since they explode on death theres no need for them to play death anims.
			self:Remove()
		end
	end)
end


function ENT:OnPathTimeOut()
	local distToTarget = self:GetPos():Distance(self:GetTargetPosition())
	if IsValid(self:GetTarget()) then
		if not self.Sprinting and distToTarget < 750 then
			self.Sprinting = true
			self:SetRunSpeed( 275 )
			self.loco:SetDesiredSpeed( 275 )
			self:SpeedChanged()
			self:ResetMovementSequence()
			self:EmitSound("nz/hellhound/close/close_0"..math.random(3)..".wav",100,math.random(95,105),1,2)
		end
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
				self:ResetMovementSequence()
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

function ENT:IsValidTarget( ent )
	if not ent then return false end
	return IsValid( ent ) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL
end