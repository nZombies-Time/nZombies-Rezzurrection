AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "A bootleg lightning man who is fortunately not narcissistic"
ENT.Category = "Brainz"
ENT.Author = "Loonicity"

local meleetypes = {
	[DMG_CLUB] = true,
	[DMG_SLASH] = true,
	[DMG_CRUSH] = true,
	[DMG_GENERIC] = true,
}

function ENT:Draw()
	self:DrawModel()
end

if CLIENT then return end -- Client doesn't really need anything beyond the basics


--purple schmurple, eat my ass
ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = false
ENT.IsMooSpecial = true

ENT.AttackDamage = 75
ENT.AttackRange = 72


ENT.SoundDelayMin = 2
ENT.SoundDelayMax = 4

ENT.TraversalCheckRange = 40

ENT.Models = {
	{Model = "models/kate/codz/t9_zombies/outbreak/kate_t9_zmb_tempest.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"nz_temp_arrive"}

local AttackSequences = {
	{seq = "nz_temp_ranged_melee_v1"},
}

local JumpSequences = {
	{seq = "nz_temp_jump_across_120"},
}

local walksounds = {
	Sound("temp_noises/t9_tempest_walk_sound.wav"),
	Sound("temp_noises/t9_tempest_walk_sound2.wav"),
	Sound("temp_noises/t9_tempest_walk_sound3.wav"),
}

ENT.IdleSequence = "nz_temp_idle"

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			MovementSequence = {
				"nz_temp_walk",
			},
			SpawnSequence = {spawn},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 36, Sequences = {
		{
			MovementSequence = {
				"nz_temp_run",
			},
			SpawnSequence = {spawn},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 71, Sequences = {
		{
			MovementSequence = {
				"nz_temp_sprint",
			},
			SpawnSequence = {spawn},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
}

ENT.DeathSounds = {
	"temp_noises/t9_tempest_death.wav",
	"temp_noises/t9_tempest_death2.wav",
	"temp_noises/t9_tempest_death3.wav",
}

ENT.PhaseSequences = {
	"nz_temp_teleport_back_short",
	"nz_temp_teleport_back_med",
	"nz_temp_teleport_back_long",

	"nz_temp_teleport_forward_short",
	"nz_temp_teleport_forward_med",
	"nz_temp_teleport_forward_long",

	"nz_temp_teleport_left_short",
	"nz_temp_teleport_left_med",
	"nz_temp_teleport_left_long",

	"nz_temp_teleport_right_short",
	"nz_temp_teleport_right_med",
	"nz_temp_teleport_right_long",
}

ENT.BehindSoundDistance = 0 -- When the zombie is within 200 units of a player, play these sounds instead

function ENT:StatsInitialize()
	if SERVER then
		local count = #player.GetAllPlaying()

		if nzRound:InState( ROUND_CREATE ) then
			self:SetHealth(1250)
		else
			self:SetHealth( nzRound:GetZombieHealth() or 75 )
		end

		self.LastShot = CurTime() + 10
		self.LastTeleport = CurTime() + 5
		self.LastStun = CurTime() + 5

		self.ShockWave = CurTime() + 5

		self.ManIsMad = false

		self:SetRunSpeed(36)
	end
end

function ENT:SpecialInit()
	if CLIENT then
	end
end

function ENT:OnSpawn()
	local seq = self:SelectSpawnSequence()
	local _, dur = self:LookupSequence(seq)

	self:SolidMaskDuringEvent(MASK_SOLID_BRUSHONLY)
	self:SetInvulnerable(true)
	self:SetSpecialAnimation(true)

	self:EmitSound("enemies/bosses/avo/move_loop.wav", 65)
	self.NextSound = CurTime() + 7

	ParticleEffectAttach("t9_temp_glow",PATTACH_POINT_FOLLOW,self,5)

	if seq then
		self:PlaySequenceAndWait(seq)
		self:SetSpecialAnimation(false)
		self:SetInvulnerable(false)
		self:CollideWhenPossible()
	end
end

function ENT:HandleAnimEvent(a,b,c,d,e) -- Moo Mark 4/14/23: You don't know how sad I am that I didn't know about this sooner.
	if e == "melee" then
		if self.AttackSounds then
			self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2)
		end
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
	if e == "phase_in" then
		self:EmitSound("nz_moo/zombies/vox/_quad/teleport/warp_in.mp3", 100)
		if IsValid(self) then ParticleEffectAttach("t9_temp_warp", 3, self, 5) end
	end
	if e == "phase_out" then
		self:SetMaterial("")
		self:EmitSound("enemies/bosses/avo/tele.ogg", 100)
		if IsValid(self) then ParticleEffectAttach("t9_temp_warp", 3, self, 5) end
	end
end

function ENT:AvoPain()
	self:EmitSound("enemies/bosses/avo/pain"..math.random(2)..".ogg", 85)
	self:EmitSound(self.PainSounds[math.random(#self.PainSounds)], 100, math.random(95,105), 1, 2)

	self.NextSound = CurTime() + 7
	self.LastStun = CurTime() + 5

	self:SetInvulnerable(true)
	self:DoSpecialAnimation("nz_temp_pain_med", true, true)
	self:SetInvulnerable(false)
end

function ENT:OnPathTimeOut()
	local chance = math.random(4)
	if !self:IsAttackBlocked() then
		if chance == 1 then
			if CurTime() > self.LastTeleport then
				local seq = self.PhaseSequences[math.random(#self.PhaseSequences)]
				if self:SequenceHasSpace(seq) then
					self:SetMaterial("invisible")
					self:DoSpecialAnimation(seq, true, true)
				end
				self.LastTeleport = CurTime() + 5
			end
		elseif chance >= 2 then
			if CurTime() > self.LastShot then
				
				if IsValid(self) then ParticleEffectAttach("t9_temp_ranged", PATTACH_POINT_FOLLOW, self, 7) end
				if IsValid(self) then ParticleEffectAttach("t9_temp_ranged", PATTACH_POINT_FOLLOW, self, 6) end
				self:PlaySequenceAndMove("nz_temp_ranged_attack_v1_intro", 1, self.FaceEnemy)

				local larmfx_tag = self:LookupBone("j_wrist_le")
				local tr = util.TraceLine({
					start = self:GetPos() + Vector(0,50,0),
					endpos = self:GetTarget():GetPos() + Vector(0,0,50),
					filter = self,
					ignoreworld = true,
				})
			
				if IsValid(tr.Entity) then
					self:EmitSound("enemies/bosses/avo/att"..math.random(2)..".ogg",100,math.random(95, 105))
					self.ZapShot = ents.Create("nz_avo_shot")
					self.ZapShot:SetPos(self:EyePos() + self:GetForward() * 2)
					self.ZapShot:Spawn()
					self.ZapShot:Launch(((tr.Entity:GetPos() + Vector(0,0,50)) - self.ZapShot:GetPos()):GetNormalized())
				end

				self:PlaySequenceAndMove("nz_temp_ranged_attack_v1_end", 1, self.FaceEnemy)

				self.LastShot = CurTime() + math.random(2,4)
			end
		end
	end
end

function ENT:PerformDeath(dmgInfo)
	self:StopSound("enemies/bosses/avo/move_loop.wav")
	self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
	self:DoDeathAnimation("nz_temp_death")
	if IsValid(self) then ParticleEffectAttach("t9_temp_death", 3, self, 5) end
end

function ENT:DoDeathAnimation(seq)
	self.BehaveThread = coroutine.create(function()
		self:SetSpecialAnimation(true)
		self:PlaySequenceAndWait(seq)
		self:Remove(DamageInfo())
	end)
end

--Purple guy? more like purple GAY

function ENT:PostAdditionalZombieStuff()

	if self:Health() < self:Health() / 2 then
		if !self.ManIsMad then
			self.ManIsMad = true
			self:SetRunSpeed(100)
			self:SpeedChanged()
		end
	end

end

function ENT:OnRemove()
	self:StopSound("enemies/bosses/avo/move_loop.wav")
end

function ENT:IsValidTarget( ent )
	if !ent then return false end
	return IsValid(ent) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
	-- Won't go for special targets (Monkeys), but still MAX, ALWAYS and so on
end
