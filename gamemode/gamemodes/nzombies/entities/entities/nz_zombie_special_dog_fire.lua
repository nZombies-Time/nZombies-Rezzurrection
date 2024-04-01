AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Plaguehound"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo"

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.EyeColorTable = {
	[0] = Material("models/moo/codz/t9_zombies/hellhound/mtl_c_t9_hellhound_eyes.vmt"),
}

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true
ENT.IsMooSpecial = true
ENT.AttackRange = 90
ENT.DamageRange = 90

ENT.Models = {
	{Model = "models/moo/_codz_ports/t9/gold/moo_codz_t9_firehazarddog.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"nz_t9_dog_air_spawn"}

local AttackSequences = {
	{seq = "nz_t9_dog_attack"},
}

local JumpSequences = {
	{seq = "nz_t9_dog_mantle_36"},
}

ENT.DeathSequences = {
	"nz_t9_dog_dth_f_01",
	"nz_t9_dog_dth_f_02",
}

ENT.BarricadeTearSequences = {
	--Leave this empty if you don't intend on having a special enemy use tear anims.
}

ENT.IdleSequence = "nz_t9_dog_idle"

ENT.AttackSounds = {
	Sound("nz_moo/zombies/vox/_devildog/_t9/attack/attack_00.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_t9/attack/attack_01.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_t9/attack/attack_02.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_t9/attack/attack_03.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_t9/attack/attack_04.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_t9/attack/attack_05.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_t9/attack/attack_06.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_t9/attack/attack_07.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_t9/attack/attack_08.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_t9/attack/attack_09.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_t9/attack/attack_10.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_t9/attack/attack_11.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_t9/attack/attack_12.mp3"),
}

local walksounds = {
	Sound("nz_moo/zombies/vox/_devildog/_t9/bark_v2/bark_000.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_t9/bark_v2/bark_001.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_t9/bark_v2/bark_002.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_t9/bark_v2/bark_003.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_t9/bark_v2/bark_004.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_t9/bark_v2/bark_005.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_t9/bark_v2/bark_006.mp3"),
}

ENT.DeathSounds = {
	Sound("nz_moo/zombies/vox/_devildog/_t9/death/death_00.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_t9/death/death_01.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_t9/death/death_02.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_t9/death/death_03.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_t9/death/death_04.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_t9/death/death_05.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_t9/death/death_06.mp3"),
}

ENT.AppearSounds = {
	Sound("nz_moo/zombies/vox/_devildog/_zhd/spawn/zmb_hellhound_spawn_00.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/spawn/zmb_hellhound_spawn_01.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/spawn/zmb_hellhound_spawn_02.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/spawn/zmb_hellhound_spawn_03.mp3"),
}

ENT.BiteSounds = {
	Sound("nz_moo/zombies/vox/_devildog/_zhd/bite/zmb_hellhound_vocals_bite_00.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/bite/zmb_hellhound_vocals_bite_01.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/bite/zmb_hellhound_vocals_bite_02.mp3"),
}

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"nz_t9_dog_trot",
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
				"nz_t9_dog_run_01",
				"nz_t9_dog_run_02",
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
				"nz_t9_dog_supersprint_01",
				"nz_t9_dog_supersprint_02",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}}
}

ENT.CustomMantleOver48 = {
	"nz_t9_dog_mantle_48",
}

ENT.CustomMantleOver72 = {
	"nz_t9_dog_mantle_72",
}

ENT.CustomMantleOver96 = {
	"nz_t9_dog_mantle_96",
}

ENT.CustomMantleOver128 = {
	"nz_t9_dog_mantle_128",
}

ENT.CustomNormalJumpUp128 = {
	"nz_t9_dog_mantle_up_128",
}

ENT.CustomNormalJumpUp128Quick = {
	"nz_t9_dog_mantle_up_128",
}

ENT.CustomNormalJumpDown128 = {
	"nz_t9_dog_mantle_dn_128",
}

ENT.CustomSlowTurnAroundSequences = {
	"nz_t9_dog_run_turn_180_l",
	"nz_t9_dog_run_turn_180_r",
}

ENT.CustomFastTurnAroundSequences = {
	"nz_t9_dog_run_turn_180_l",
	"nz_t9_dog_run_turn_180_r",
}

ENT.DogStepSounds = {
	Sound("nz_moo/zombies/vox/_devildog/step/step_00.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/step/step_01.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/step/step_02.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/step/step_03.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/step/step_04.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/step/step_05.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/step/step_06.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/step/step_07.mp3"),
}

function ENT:StatsInitialize()
	if SERVER then
		self.Sprinting = false
		self.Exploded = false

		self.Lunging = false
		self.LastLunge = CurTime() + 5

		self.SpawnProtection = true -- Zero Health Zombies tend to be created right as they spawn.
		self.SpawnProtectionTime = CurTime() + 1 -- So this is an experiment to see if negating any damage they take for a second will stop this.
	end
	self:SetCollisionBounds(Vector(-9,-9, 0), Vector(9, 9, 72))
	self:SetSurroundingBounds(Vector(-20, -20, 0), Vector(20, 20, 72))
end

function ENT:OnSpawn()
	self:SetMaterial("invisible")
	self:SetBlockAttack(true)
	self:SolidMaskDuringEvent(MASK_PLAYERSOLID)

	self:EmitSound("nz_moo/zombies/vox/_devildog/spawn/pre_spawn.mp3",511,100)
	ParticleEffect("hound_summon",self:GetPos(),self:GetAngles(),nil)

	self:TimeOut(0.85)

	self:EmitSound("nz_moo/zombies/vox/_devildog/spawn/strikes_00.mp3",511,100)

	self:EmitSound("nz_moo/zombies/vox/_devildog/spawn/spn_flux_l.mp3",100,100)
	self:EmitSound("nz_moo/zombies/vox/_devildog/spawn/spn_flux_r.mp3",100,100)

	ParticleEffectAttach("ins_skybox_lightning",PATTACH_ABSORIGIN_FOLLOW,self,0)

	self:SetMaterial("")

	self.NotVisible = false
	self:Flames(true)
	
	self:SetBlockAttack(false)
	self:CollideWhenPossible()
	self:EmitSound(self.AppearSounds[math.random(#self.AppearSounds)], 511, math.random(85, 105), 1, 2)

	
	self:SetRunSpeed( 71 )
	self.loco:SetDesiredSpeed( 71 )
end

function ENT:PostAdditionalZombieStuff()
	local target = self:GetTarget()

	if IsValid(target) and target:IsPlayer() and !self:IsAttackBlocked() then
		if CurTime() > self.LastLunge and self:TargetInRange(175) then
			-- Lunge does more damage than a normal attack.
			self:TempBehaveThread(function(self)
				self:FaceTowards(target:GetPos())

				self:SetSpecialAnimation(true)
				self:PlaySequenceAndMove("nz_t9_dog_lunge_attack", 1)
				self:SetSpecialAnimation(false)	
			end)
			self.LastLunge = CurTime() + 3
		end
		local distToTarget = self:GetPos():DistToSqr(self:GetTargetPosition())
		if !self.Sprinting and distToTarget < 1500^2 then
			self.Sprinting = true
			self:SetRunSpeed( 71 )
			self.loco:SetDesiredSpeed( 71 )
			self:SpeedChanged()
		end
	end
end 

function ENT:PerformDeath(dmginfo)
	local damagetype = dmginfo:GetDamageType()

	self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
	if self:GetSpecialAnimation() then
		if IsValid(self) then
			if self.Exploded then self:Remove() return end

			self.Exploded = true -- Prevent a possible infinite loop that causes crashes.
			
			local firepit = ents.Create("hellhound_firepit")
        	firepit:SetPos(self:WorldSpaceCenter())
			firepit:SetAngles(Angle(0,0,0))
        	firepit:Spawn()

			self:Explode( math.random( 25, 50 ))

			self:Remove()
		end
	else
		self:DoDeathAnimation(self.DeathSequences[math.random(#self.DeathSequences)])
	end
end

function ENT:DoDeathAnimation(seq)
	self.BehaveThread = coroutine.create(function()
		self:PlaySequenceAndMove(seq, 1)
		if IsValid(self) then
			if self.Exploded then self:Remove() return end

			self.Exploded = true -- Prevent a possible infinite loop that causes crashes.

			local firepit = ents.Create("hellhound_firepit")
        	firepit:SetPos(self:WorldSpaceCenter())
			firepit:SetAngles(Angle(0,0,0))
        	firepit:Spawn()

        	self:Explode( math.random( 25, 50 ))

			self:Remove()
		end
	end)
end

function ENT:IsValidTarget( ent )
	if not ent then return false end
	return IsValid(ent) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
end

function ENT:HandleAnimEvent(a,b,c,d,e) -- Moo Mark 4/14/23: You don't know how sad I am that I didn't know about this sooner.
	if e == "melee" or e == "melee_lunge" then
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
		self:EmitSound(self.DogStepSounds[math.random(#self.DogStepSounds)], 75, math.random(95,105))
	end
	if e == "lunge_alert" then
		self.Lunging = true
		self:EmitSound(self.BiteSounds[math.random(#self.BiteSounds)], 85, math.random(95,105), 1, 2)
	end
	if e == "appear" then
		self:EmitSound(self.AppearSounds[math.random(#self.AppearSounds)], 511, math.random(85, 105), 1, 2)
	end
end

if SERVER then
	function ENT:DoAttackDamage() -- Moo Mark 4/14/23: Made the part that does damage during an attack its own function.
		local target = self:GetTarget()
		if IsValid(target) and target:Health() and target:Health() > 0 then -- Doesn't matter if its a player... If the zombie is targetting it, they probably wanna attack it.
			if self:IsValid(target) and (self:GetIsBusy() and self:TargetInRange( self.AttackRange + 45 ) or self:TargetInRange( self.AttackRange + 25 )) then
				local dmgInfo = DamageInfo()
				dmgInfo:SetAttacker( self )
				if self.Lunging then
					self.Lunging = false
					dmgInfo:SetDamage( 75 )
				else
					dmgInfo:SetDamage( self.AttackDamage )
				end
				dmgInfo:SetDamageType( DMG_SLASH )
				dmgInfo:SetDamageForce( (target:GetPos() - self:GetPos()) * 7 + Vector( 0, 0, 16 ) )
				if self:TargetInRange( self.DamageRange ) then 
					if !IsValid(target) then return end
					target:TakeDamageInfo(dmgInfo)
					if comedyday or math.random(500) == 1 then
						if self.GoofyahAttackSounds then target:EmitSound(self.GoofyahAttackSounds[math.random(#self.GoofyahAttackSounds)], SNDLVL_TALKING, math.random(95,105)) end
					else
						target:EmitSound( "nz_moo/zombies/plr_impact/_zhd/evt_zombie_hit_player_0"..math.random(0,5)..".mp3", SNDLVL_TALKING, math.random(95,105))
					end

					if target:IsPlayer() then
						target:ViewPunch( VectorRand():Angle() * 0.01 )
					end
				end
			end
		end
	end
end
