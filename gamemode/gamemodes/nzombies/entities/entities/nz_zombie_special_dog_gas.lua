AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Plaguehound"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo"

if CLIENT then
	function ENT:Draw() //Runs every frame
		self:DrawModel()
		self:PostDraw()
	end
	function ENT:PostDraw()
		self:EffectsAndSounds()
	end
	function ENT:EffectsAndSounds()
		if self:Alive() then
			-- Credit: FlamingFox for Code and fighting the PVS monster -- 
			if !IsValid(self) then return end
			if (!self.Draw_FX or !IsValid(self.Draw_FX)) then
				self.Draw_FX = CreateParticleSystem(self, "novagas_trail", PATTACH_POINT_FOLLOW, 2)
			end
		end
	end
end

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true
ENT.IsMooSpecial = true
ENT.AttackRange = 90
ENT.DamageRange = 90

ENT.Models = {
	{Model = "models/moo/_codz_ports/t9/silver/moo_codz_t9_malodorousdog.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"nz_t9_plague_air_spawn"}

local AttackSequences = {
	{seq = "nz_t9_plague_attack"},
}

local JumpSequences = {
	{seq = "nz_t9_plague_mantle_36"},
}

ENT.DeathSequences = {
	"nz_t9_plague_dth_f_01",
	"nz_t9_plague_dth_f_02",
}

ENT.BarricadeTearSequences = {
	--Leave this empty if you don't intend on having a special enemy use tear anims.
}

ENT.IdleSequence = "nz_t9_plague_idle"

ENT.AttackSounds = {
	Sound("nz_moo/zombies/vox/_devildog/_zhd/attack/zmb_hellhound_vocals_attack_00.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/attack/zmb_hellhound_vocals_attack_01.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/attack/zmb_hellhound_vocals_attack_02.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/attack/zmb_hellhound_vocals_attack_03.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/attack/zmb_hellhound_vocals_attack_04.mp3"),
	Sound("nz_moo/zombies/vox/_devildog/_zhd/attack/zmb_hellhound_vocals_attack_05.mp3"),
}

local walksounds = {
	Sound("nz_moo/zombies/vox/_gasdog/walk_loops/plaguehound_walk_01.mp3"),
	Sound("nz_moo/zombies/vox/_gasdog/walk_loops/plaguehound_walk_02.mp3"),
	Sound("nz_moo/zombies/vox/_gasdog/walk_loops/plaguehound_walk_03.mp3"),
	Sound("nz_moo/zombies/vox/_gasdog/walk_loops/plaguehound_walk_04.mp3"),
}

local runsounds = {
	Sound("nz_moo/zombies/vox/_gasdog/sprint_loops/plaguehound_sprint_01.mp3"),
	Sound("nz_moo/zombies/vox/_gasdog/sprint_loops/plaguehound_sprint_02.mp3"),
	Sound("nz_moo/zombies/vox/_gasdog/sprint_loops/plaguehound_sprint_03.mp3"),
	Sound("nz_moo/zombies/vox/_gasdog/sprint_loops/plaguehound_sprint_04.mp3"),
}

ENT.DeathSounds = {
	Sound("nz_moo/zombies/vox/_gasdog/death/plaguehound_death_01.mp3"),
	Sound("nz_moo/zombies/vox/_gasdog/death/plaguehound_death_02.mp3"),
	Sound("nz_moo/zombies/vox/_gasdog/death/plaguehound_death_03.mp3"),
	Sound("nz_moo/zombies/vox/_gasdog/death/plaguehound_death_04.mp3"),
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
				"nz_t9_plague_trot",
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
				"nz_t9_plague_run",
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
	self:SetNoDraw(true)
	self:SetBlockAttack(true)
	self:SolidMaskDuringEvent(MASK_PLAYERSOLID)

	self:EmitSound("nz_moo/zombies/vox/_quad/spawn/spawn_0"..math.random(0,3)..".mp3",511,100)

	self:TimeOut(0.85)

	self:SetNoDraw(false)
	
	if IsValid(self) then ParticleEffectAttach("novagas_trail", 4, self, 2) end

	self:EmitSound("nz_moo/zombies/vox/_quad/gas_cloud/cloud_0"..math.random(0,3)..".mp3",511,100)
	ParticleEffectAttach("hcea_flood_runner_death",PATTACH_ABSORIGIN_FOLLOW,self,0)

	self.NotVisible = false
	
	self:SetBlockAttack(false)
	self:CollideWhenPossible()
	self:EmitSound(self.AppearSounds[math.random(#self.AppearSounds)], 511, math.random(85, 105), 1, 2)

	
	self:SetRunSpeed( 71 )
	self.loco:SetDesiredSpeed( 71 )
end

function ENT:PostAdditionalZombieStuff()
	local target = self:GetTarget()

	if IsValid(target) and target:IsPlayer() and !self:IsAttackBlocked() then
		if !self:TargetInRange(175) then return end
		if CurTime() > self.LastLunge then
			-- Lunge does more damage than a normal attack.
			self:TempBehaveThread(function(self)
				self:FaceTowards(target:GetPos())

				self:SetSpecialAnimation(true)
				self:PlaySequenceAndMove("nz_t9_plague_lunge_attack", 1)
				self:SetSpecialAnimation(false)	
			end)
			self.LastLunge = CurTime() + 3
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
			--print("Stinky Child... Gross")

			self:EmitSound("nz_moo/zombies/vox/_quad/gas_cloud/cloud_0"..math.random(0,3)..".mp3",100,100)

			local fuckercloud = ents.Create("nova_gas_cloud")
			fuckercloud:SetPos(self:GetPos())
			fuckercloud:SetAngles(Angle(0,0,0))
			fuckercloud:Spawn()

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
			--print("Stinky Child... Gross")

			self:EmitSound("nz_moo/zombies/vox/_quad/gas_cloud/cloud_0"..math.random(0,3)..".mp3",100,100)

			local fuckercloud = ents.Create("nova_gas_cloud")
			fuckercloud:SetPos(self:GetPos())
			fuckercloud:SetAngles(Angle(0,0,0))
			fuckercloud:Spawn()

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
		self:EmitSound("nz_moo/zombies/vox/_hellhound/step/step_0"..math.random(0,9)..".mp3", 65, math.random(95,105))
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
