AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Hellhound(BO4)"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo"

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true
ENT.IsMooSpecial = true
ENT.AttackRange = 80

ENT.Models = {
	{Model = "models/moo/_codz_ports/t8/escape/moo_codz_t8_devildoggo.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"nz_dog_idle"}

local AttackSequences = {
	{seq = "nz_dog_attack"},
}

local JumpSequences = {
	{seq = "nz_dog_jump_40"},
}


ENT.BarricadeTearSequences = {
	--Leave this empty if you don't intend on having a special enemy use tear anims.
}

ENT.IdleSequence = "nz_dog_idle"

ENT.ElectrocutionSequences = {
	"nz_dog_stun_in",
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

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"nz_dog_trot",
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
				"nz_dog_run_v1",
				"nz_dog_run_v2",
				"nz_dog_run_v3",
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
end

function ENT:PerformDeath(dmgInfo)
	self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
	if IsValid(self) then
		ParticleEffect("hound_explosion",self:GetPos(),self:GetAngles(),self)
		self:Explode( math.random( 25, 50 )) -- Doggy goes Kaboom! Since they explode on death theres no need for them to play death anims.
		self:Remove()
	end
end

function ENT:AI()
	if IsValid(self:GetTarget()) then
		local distToTarget = self:GetPos():DistToSqr(self:GetTargetPosition())
		if not self.Sprinting and distToTarget < 1500^2 then
			self.Sprinting = true
			self:SetRunSpeed( 71 )
			self.loco:SetDesiredSpeed( 71 )
			self:SpeedChanged()
			ParticleEffectAttach("firestaff_victim_burning",PATTACH_ABSORIGIN_FOLLOW,self,0)
		end
	end
end

function ENT:IsValidTarget( ent )
	if not ent then return false end
	return IsValid(ent) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
end

function ENT:HandleAnimEvent(a,b,c,d,e) -- Moo Mark 4/14/23: You don't know how sad I am that I didn't know about this sooner.
	if e == "melee" then
		self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2)
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
	if e == "dog_step" then
		self:EmitSound("nz_moo/zombies/vox/_hellhound/step/step_0"..math.random(0,9)..".mp3", 65, math.random(95,105))
	end
end