AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "SPIDERMAN"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo"

function ENT:Draw()
	self:DrawModel()
end

if CLIENT then return end

ENT.RedEyes = false
ENT.SpeedBasedSequences = true

ENT.IsMooZombie = true
ENT.IsMooSpecial = true
ENT.IsMooBossZombie = true

ENT.AttackRange = 100
ENT.AttackDamage = 60

ENT.TraversalCheckRange = 40

ENT.Models = {
	{Model = "models/moo/_codz_ports/s2/zombie_island/moo_codz_s2_assassin.mdl", Skin = 0, Bodygroups = {0,0}},
}

ENT.DeathSequences = {
	"nz_asn_stand_death",
}

ENT.BarricadeTearSequences = {}

local spawnfast = {"nz_asn_spawn_idle"}

local JumpSequences = {
	{seq = "nz_asn_trav"},
}

local AttackSequences = {
	{seq = "nz_asn_stand_attack_v1"},
	{seq = "nz_asn_stand_attack_v2"},
	{seq = "nz_asn_stand_attack_v3"},
}

local WalkAttackSequences = {
	{seq = "nz_asn_walk_attack_v1"},
	{seq = "nz_asn_walk_attack_v2"},
	{seq = "nz_asn_walk_attack_v3"},
}

local SprintAttackSequences = {
	{seq = "nz_asn_sprint_attack_v1"},
	{seq = "nz_asn_sprint_attack_v2"},
	{seq = "nz_asn_sprint_attack_v3"},
	{seq = "nz_asn_sprint_attack_v4"},
	{seq = "nz_asn_sprint_attack_v5"},
}

local walksounds = {}

ENT.IdleSequence = "nz_asn_idle"

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawnfast},
			MovementSequence = {
				"nz_asn_walk_v1",
				"nz_asn_walk_v2",
				"nz_asn_walk_v3",
			},
			AttackSequences = {WalkAttackSequences},
			StandAttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			--PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 71, Sequences = {
		{
			SpawnSequence = {spawnfast},
			MovementSequence = {
				"nz_asn_sprint_v1",
				"nz_asn_sprint_v2",
				"nz_asn_sprint_v3",
				"nz_asn_sprint_v4",
				"nz_asn_sprint_v5",
			},
			AttackSequences = {SprintAttackSequences},
			StandAttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			--PassiveSounds = {walksounds},
		},
	}}
}

ENT.ChargeSounds = {
	"nz_moo/zombies/vox/_assassin/charge/zmb_vox_ass_charge_01.mp3",
	"nz_moo/zombies/vox/_assassin/charge/zmb_vox_ass_charge_02.mp3",
	"nz_moo/zombies/vox/_assassin/charge/zmb_vox_ass_charge_03.mp3",
	"nz_moo/zombies/vox/_assassin/charge/zmb_vox_ass_charge_04.mp3",
	"nz_moo/zombies/vox/_assassin/charge/zmb_vox_ass_charge_05.mp3",
}

ENT.ClickSounds = {
	"nz_moo/zombies/vox/_assassin/click/zmb_vox_ass_fog_click_01.mp3",
	"nz_moo/zombies/vox/_assassin/click/zmb_vox_ass_fog_click_02.mp3",
	"nz_moo/zombies/vox/_assassin/click/zmb_vox_ass_fog_click_03.mp3",
	"nz_moo/zombies/vox/_assassin/click/zmb_vox_ass_fog_click_04.mp3",
	"nz_moo/zombies/vox/_assassin/click/zmb_vox_ass_fog_click_05.mp3",
	"nz_moo/zombies/vox/_assassin/click/zmb_vox_ass_fog_click_06.mp3",
	"nz_moo/zombies/vox/_assassin/click/zmb_vox_ass_fog_click_07.mp3",
	"nz_moo/zombies/vox/_assassin/click/zmb_vox_ass_fog_click_08.mp3",
	"nz_moo/zombies/vox/_assassin/click/zmb_vox_ass_fog_click_09.mp3",
}

ENT.DeathSounds = {
	"nz_moo/zombies/vox/_assassin/death/zmb_vox_ass_death_01.mp3",
	"nz_moo/zombies/vox/_assassin/death/zmb_vox_ass_death_02.mp3",
	"nz_moo/zombies/vox/_assassin/death/zmb_vox_ass_death_03.mp3",
	"nz_moo/zombies/vox/_assassin/death/zmb_vox_ass_death_04.mp3",
	"nz_moo/zombies/vox/_assassin/death/zmb_vox_ass_death_05.mp3",
}

ENT.AttackSounds = {
	"nz_moo/zombies/vox/_assassin/melee/zmb_vox_ass_melee_hit_01.mp3",
	"nz_moo/zombies/vox/_assassin/melee/zmb_vox_ass_melee_hit_02.mp3",
	"nz_moo/zombies/vox/_assassin/melee/zmb_vox_ass_melee_hit_03.mp3",
	"nz_moo/zombies/vox/_assassin/melee/zmb_vox_ass_melee_hit_04.mp3",
	"nz_moo/zombies/vox/_assassin/melee/zmb_vox_ass_melee_hit_05.mp3",
	"nz_moo/zombies/vox/_assassin/melee/zmb_vox_ass_melee_hit_06.mp3",
	"nz_moo/zombies/vox/_assassin/melee/zmb_vox_ass_melee_hit_07.mp3",
	"nz_moo/zombies/vox/_assassin/melee/zmb_vox_ass_melee_hit_08.mp3",
}

ENT.SpawnSounds = {
	"nz_moo/zombies/vox/_assassin/awake/zmb_vox_ass_awaken_01.mp3",
	"nz_moo/zombies/vox/_assassin/awake/zmb_vox_ass_awaken_02.mp3",
	"nz_moo/zombies/vox/_assassin/awake/zmb_vox_ass_awaken_03.mp3",
	"nz_moo/zombies/vox/_assassin/awake/zmb_vox_ass_awaken_04.mp3",
	"nz_moo/zombies/vox/_assassin/awake/zmb_vox_ass_awaken_05.mp3",
}

ENT.BehindSoundDistance = 0

function ENT:StatsInitialize()
	if SERVER then
		local count = #player.GetAllPlaying()

		if nzRound:InState( ROUND_CREATE ) then
			self:SetHealth(3000)
			self:SetMaxHealth(3000)
		else
			if nzRound:InState( ROUND_PROG ) then
				self:SetHealth(math.Clamp(nzRound:GetNumber() * 500 + (3000 * count), 7000, 13000 * count))
				self:SetMaxHealth(math.Clamp(nzRound:GetNumber() * 500 + (3000 * count), 7000, 13000 * count))
			else
				self:SetHealth(3000)
				self:SetMaxHealth(3000)	
			end
		end

		self.Cooldown = CurTime() + 4 
		self.Retreat = false
		self.Flank = false
		self.FleeDistance = 750

		self:SetRunSpeed(71)
		self:SetCollisionBounds(Vector(-15,-15, 0), Vector(15, 15, 85))
	end
end

function ENT:SpecialInit()
	if CLIENT then
	end
end

function ENT:OnSpawn()
	self:PlaySound(self.SpawnSounds[math.random(#self.SpawnSounds)], 511, math.random(85, 105))

	self:SolidMaskDuringEvent(MASK_PLAYERSOLID)
	self:SetSpecialAnimation(true)
	local seq = self:SelectSpawnSequence()
	if seq then
		self:PlaySequenceAndMove(seq)
		self:SetSpecialAnimation(false)
		self:CollideWhenPossible()
	end
end

function ENT:PerformDeath(dmginfo)
	self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
	if self.DeathRagdollForce == 0 or dmginfo:GetDamageType() == DMG_REMOVENORAGDOLL or self:GetSpecialAnimation() then
		self:Remove(dmginfo)
	else
		self:DoDeathAnimation(self.DeathSequences[math.random(#self.DeathSequences)])
	end
end

function ENT:IsValidTarget( ent )
	if !ent then return false end
	return IsValid(ent) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
	-- Won't go for special targets (Monkeys), but still MAX, ALWAYS and so on
end

function ENT:AdditionalZombieStuff()
	if self:GetSpecialAnimation() then return end
	if self.Retreat then
		self:FleeTarget(1)
		self.Retreat = false
		self.Flank = true
	end
	if self.Flank and !self:GetFleeing() then
		if !self.Flank then return end
		self.Flank = false
		local target = self:GetTarget()
		self:SetBlockAttack(false)
		if IsValid(target) and target:IsPlayer() then
			self:TimeOut(0.1)
			self:SolidMaskDuringEvent(MASK_PLAYERSOLID)
			self:PlaySequenceAndMove("nz_asn_walk_2_crouch", 1)
			ParticleEffect("bo3_zombie_spawn",self:GetPos()+Vector(0,0,1),self:GetAngles(),self)
			self:EmitSound("nz/zombies/spawn/zm_spawn_dirt"..math.random(1,2)..".wav",80,math.random(95,105))

			local sspawn = self:FindNearestSpecialSpawner(target:GetPos())
			local spos
			if sspawn then
				spos = sspawn:GetPos()
			else
				spos = self:FindSpotBehindPlayer(target:GetPos(), 10)
				print("Uh oh Mario, Spiderman couldn't find a special spawn!")
			end
			if spos then
				self:SetPos(spos)
			else
				print("Uh oh Mario, Spiderman couldn't find a valid position!")
			end

			ParticleEffect("bo3_zombie_spawn",self:GetPos()+Vector(0,0,1),self:GetAngles(),self)
			self:EmitSound("nz/zombies/spawn/zm_spawn_dirt"..math.random(1,2)..".wav",80,math.random(95,105))

			self:PlaySequenceAndMove("nz_asn_spawn_attack", 1, self.FaceEnemy) -- BOO!
			self:SetSpecialAnimation(false)
			self:CollideWhenPossible()
		end
	end
end

function ENT:PostTookDamage(dmginfo)
	if CurTime() > self.Cooldown then
		self.Retreat = true
		self.Cooldown = CurTime() + 3 -- Won't try to flee again for around 3 seconds.
	end
end

function ENT:OnTargetInAttackRange()
	if !self:GetBlockAttack() then
		self:Attack()
	else
		self:TimeOut(0.1)
	end
end

function ENT:HandleAnimEvent(a,b,c,d,e)
	if e == "melee" then
		self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105))
		self:DoAttackDamage()
	end
	if e == "death_noragdoll" then
		self:Remove(DamageInfo())
	end
	if e == "start_traverse" then
		--print("starttraverse")
		self.TraversalAnim = true
	end
	if e == "finish_traverse" then
		--print("finishtraverse")
		self.TraversalAnim = false
	end
	if e == "asn_scream" then
		self:EmitSound(self.SpawnSounds[math.random(#self.SpawnSounds)], 511, math.random(85, 105), 1, 2)
	end
end

function ENT:Sound()
	if !self:TargetInRange(350) then
		self:PlaySound(self.ClickSounds[math.random(#self.ClickSounds)],511)
	elseif self.ChargeSounds then
		self:PlaySound(self.ChargeSounds[math.random(#self.ChargeSounds)],95, math.random(80, 110), 1, 2)
	else
		-- We still delay by max sound delay even if there was no sound to play
		self.NextSound = CurTime() + self.SoundDelayMax
	end
end
