AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Hellhound"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo"

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true
ENT.IsMooSpecial = true
ENT.AttackRange = 115
ENT.DamageRange = 115
--SHREK IM LOOKIN DOWN
ENT.Models = {
	{Model =  "models/specials/helldonkey.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"idle"}

local AttackSequences = {
	{seq = "nz_attack1", dmgtimes = {0.6}},
	{seq = "nz_attack2", dmgtimes = {0.6}},
	{seq = "nz_attack3", dmgtimes = {0.6}}
}

local JumpSequences = {
	{seq = ACT_JUMP, speed = 100}, --i dont remember if donkey can jump xd
}


ENT.BarricadeTearSequences = {
	--Leave this empty if you don't intend on having a special enemy use tear anims.
}

ENT.IdleSequence = "nz_dog_idle"

ENT.DeathSequences = {
	"nz_death1",
	"nz_death2",
	"nz_death3",
}
--i know he has these but i forgot the names
ENT.ElectrocutionSequences = {
	"nz_electrocuted1",
	"nz_electrocuted2",
	"nz_electrocuted3",
	"nz_electrocuted4",
}

ENT.AttackSounds = {
	"nz_moo/zombies/vox/_hellhound/attack/attack_00.mp3",
	"nz_moo/zombies/vox/_hellhound/attack/attack_01.mp3",
	"nz_moo/zombies/vox/_hellhound/attack/attack_02.mp3",
	"nz_moo/zombies/vox/_hellhound/attack/attack_03.mp3",
	"nz_moo/zombies/vox/_hellhound/attack/attack_04.mp3",
	"nz_moo/zombies/vox/_hellhound/attack/attack_05.mp3"
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
--im not gonna pretend i remember the names of these animations
ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"nz_walk",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 36, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"nz_run3",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 71, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"nz_run1",
				"nz_run2",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {runsounds},
		},
	}}
}

function ENT:StatsInitialize()
	if SERVER then
		self.Sprinting = false
		self.IgnitedFoxy = false
		self:SetRunSpeed( 36 )
		self.loco:SetDesiredSpeed( 36 )
	end
	self:SetCollisionBounds(Vector(-13,-13, 0), Vector(13, 13, 45))
end

function ENT:OnSpawn()
	self:SetMaterial("invisible")
	self:SetInvulnerable(true)
	self:SetBlockAttack(true)
	self:SolidMaskDuringEvent(MASK_PLAYERSOLID)

	self:EmitSound("nz/hellhound/spawn/prespawn.wav",511,100)
	ParticleEffect("hound_summon",self:GetPos(),self:GetAngles(),nil)
	--ParticleEffect("fx_hellhound_summon",self:GetPos(),self:GetAngles(),nil)

	self:TimeOut(0.85)
	
	self:EmitSound("nz/hellhound/spawn/strike.wav",511,100)
	ParticleEffectAttach("ins_skybox_lightning",PATTACH_ABSORIGIN_FOLLOW,self,0)
	
	self:SetMaterial("")
	self:SetInvulnerable(nil)
	self:SetBlockAttack(false)
	self:CollideWhenPossible()
	self:EmitSound(self.AppearSounds[math.random(#self.AppearSounds)], 511, math.random(85, 105), 1, 2)

	nzRound:SetNextSpawnTime(CurTime() + 3) -- This one spawning delays others by 3 seconds
end

function ENT:PerformDeath(dmgInfo)
	if self:GetSpecialAnimation() then
		self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
		if IsValid(self) then
			if self.IgnitedFoxy then
				ParticleEffect("hound_explosion",self:GetPos(),self:GetAngles(),self)
				self:Explode( math.random( 25, 50 )) -- Doggy goes Kaboom! Since they explode on death theres no need for them to play death anims.
				self:Remove()
			else
				self:Remove()
			end
		end
	else
		if dmgInfo:GetDamageType() == DMG_SHOCK then
			self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
			self:DoDeathAnimation(self.ElectrocutionSequences[math.random(#self.ElectrocutionSequences)])
		else
			self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
			self:DoDeathAnimation(self.DeathSequences[math.random(#self.DeathSequences)])
		end
	end
end

function ENT:DoDeathAnimation(seq)
	self.BehaveThread = coroutine.create(function()
		self:PlaySequenceAndWait(seq)
		if IsValid(self) then
			if self.IgnitedFoxy then
				ParticleEffect("hound_explosion",self:GetPos(),self:GetAngles(),self)
				self:Explode( math.random( 25, 50 )) -- Doggy goes Kaboom! Since they explode on death theres no need for them to play death anims.
				self:Remove()
			else
				self:Remove()
			end
		end
	end)
end


function ENT:OnPathTimeOut()
	local distToTarget = self:GetPos():Distance(self:GetTargetPosition())
	if IsValid(self:GetTarget()) then
		if not self.Sprinting and distToTarget < 750 then
			self.Sprinting = true
			self.IgnitedFoxy = true
			self:SetRunSpeed( 71 )
			self.loco:SetDesiredSpeed( 71 )
			self:SpeedChanged()
			ParticleEffectAttach("firestaff_victim_burning",PATTACH_ABSORIGIN_FOLLOW,self,0)
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
	return IsValid(ent) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
end