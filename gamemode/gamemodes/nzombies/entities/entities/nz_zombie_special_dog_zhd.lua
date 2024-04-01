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

local walksounds = {
	Sound("nz_moo/zombies/vox/_devildog/_zhd/movement/zmb_hellhound_vocals_movement_00.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/movement/zmb_hellhound_vocals_movement_01.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/movement/zmb_hellhound_vocals_movement_02.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/movement/zmb_hellhound_vocals_movement_03.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/movement/zmb_hellhound_vocals_movement_04.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/movement/zmb_hellhound_vocals_movement_05.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/movement/zmb_hellhound_vocals_movement_06.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/movement/zmb_hellhound_vocals_movement_07.mp3"),
}

local runsounds = {
	Sound("nz_moo/zombies/vox/_devildog/vox/close/close_00.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/vox/close/close_01.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/vox/close/close_02.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/vox/close/close_03.mp3"),
}

ENT.AttackSounds = {
	Sound("nz_moo/zombies/vox/_devildog/_zhd/attack/zmb_hellhound_vocals_attack_00.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/attack/zmb_hellhound_vocals_attack_01.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/attack/zmb_hellhound_vocals_attack_02.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/attack/zmb_hellhound_vocals_attack_03.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/attack/zmb_hellhound_vocals_attack_04.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/attack/zmb_hellhound_vocals_attack_05.mp3"),
}

ENT.DeathSounds = {
	Sound("nz_moo/zombies/vox/_devildog/vox/death/death_00.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/vox/death/death_01.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/vox/death/death_02.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/vox/death/death_03.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/vox/death/death_04.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/vox/death/death_05.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/vox/death/death_06.mp3"),
}

ENT.SpiritSounds = {
	Sound("nz_moo/zombies/vox/_devildog/exp_bo3/spirit/exp_hellhound_spirit_00.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/exp_bo3/spirit/exp_hellhound_spirit_01.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/exp_bo3/spirit/exp_hellhound_spirit_02.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/exp_bo3/spirit/exp_hellhound_spirit_03.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/exp_bo3/spirit/exp_hellhound_spirit_04.mp3"),
}

ENT.AppearSounds = {
	Sound("nz_moo/zombies/vox/_devildog/_zhd/spawn/zmb_hellhound_spawn_00.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/spawn/zmb_hellhound_spawn_01.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/spawn/zmb_hellhound_spawn_02.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/spawn/zmb_hellhound_spawn_03.mp3"),
}

ENT.DogStepSounds = {
	Sound("nz_moo/zombies/vox/_devildog/_zhd/step/fly_hellhound_step_00.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/step/fly_hellhound_step_01.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/step/fly_hellhound_step_02.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/step/fly_hellhound_step_03.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/step/fly_hellhound_step_04.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/step/fly_hellhound_step_05.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/step/fly_hellhound_step_06.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/step/fly_hellhound_step_07.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/step/fly_hellhound_step_08.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/step/fly_hellhound_step_09.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/step/fly_hellhound_step_10.mp3"),
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
	end
	self:SetCollisionBounds(Vector(-9,-9, 0), Vector(9, 9, 72))
	self:SetSurroundingBounds(Vector(-20, -20, 0), Vector(20, 20, 72))
end

function ENT:OnSpawn()
	self:SetMaterial("invisible")
	self:SetInvulnerable(true)
	self:SetBlockAttack(true)
	self:SolidMaskDuringEvent(MASK_PLAYERSOLID)

	self:EmitSound("nz_moo/zombies/vox/_devildog/spawn/pre_spawn.mp3",511,100)
	ParticleEffect("hound_summon",self:GetPos(),self:GetAngles(),nil)
	--ParticleEffect("fx_hellhound_summon",self:GetPos(),self:GetAngles(),nil)

	self:TimeOut(0.85)
	
	self:EmitSound("nz_moo/zombies/vox/_devildog/spawn/strikes_00.mp3",511,100)

	self:EmitSound("nz_moo/zombies/vox/_devildog/spawn/spn_flux_l.mp3",100,100)
	self:EmitSound("nz_moo/zombies/vox/_devildog/spawn/spn_flux_r.mp3",100,100)

	ParticleEffectAttach("ins_skybox_lightning",PATTACH_ABSORIGIN_FOLLOW,self,0)
	
	self:SetMaterial("")
	self:SetInvulnerable(nil)
	self:SetBlockAttack(false)
	self:CollideWhenPossible()
	self:EmitSound(self.AppearSounds[math.random(#self.AppearSounds)], 511, math.random(85, 105), 1, 2)

	self:SetRunSpeed( 36 )
	self.loco:SetDesiredSpeed( 36 )
end

function ENT:PerformDeath(dmgInfo)
	self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
	if IsValid(self) then
		self:EmitSound(self.SpiritSounds[math.random(#self.SpiritSounds)], 511, math.random(95, 105), 1, 2)

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
			self:Flames(true)
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
		self:EmitSound(self.DogStepSounds[math.random(#self.DogStepSounds)], 65, math.random(95,105))
	end
end