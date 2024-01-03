AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Uh Oh Mario, I'm Gonna GOOP"
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


ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = false
ENT.IsMooSpecial = true

ENT.AttackDamage = 20
ENT.AttackRange = 72


ENT.SoundDelayMin = 2
ENT.SoundDelayMax = 4

ENT.TraversalCheckRange = 40

ENT.Models = {
	{Model = "models/t7_spider/kate_codz_t7_spooder.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"nz_spider_spawn"}

local AttackSequences = {
	{seq = "nz_spider_attack"},
}

local JumpSequences = {
	{seq = "nz_spider_traverse"},
}

local walksounds = {
	Sound("spider/spd_ambient_00.wav"),
	Sound("spider/spd_ambient_01.wav"),
	Sound("spider/spd_ambient_02.wav"),
	Sound("spider/spd_ambient_03.wav"),
	Sound("spider/spd_ambient_04.wav"),
	Sound("spider/spd_ambient_05.wav"),
	Sound("spider/spd_ambient_06.wav"),
	Sound("spider/spd_ambient_07.wav"),
	Sound("spider/spd_ambient_08.wav"),
}

ENT.SpiderStepSounds = {
	Sound("spider/spd_step_00.wav"),
	Sound("spider/spd_step_01.wav"),
	Sound("spider/spd_step_02.wav"),
	Sound("spider/spd_step_03.wav"),
	Sound("spider/spd_step_04.wav"),
	Sound("spider/spd_step_05.wav"),
	Sound("spider/spd_step_06.wav"),
	Sound("spider/spd_step_07.wav"),
	Sound("spider/spd_step_08.wav"),
}

ENT.SpiderCumSounds = {
	Sound("spider/spd_attack_00.wav"),
	Sound("spider/spd_attack_01.wav"),
	Sound("spider/spd_attack_02.wav"),
	Sound("spider/spd_attack_03.wav"),
}

ENT.IdleSequence = "nz_spider_idle"

ENT.SequenceTables = {

	{Threshold = 0, Sequences = {
		{
			MovementSequence = {
				"nz_spider_run",
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
				"nz_spider_run",
			},
			SpawnSequence = {spawn},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
}

ENT.AttackSounds = {
	"spider/spd_melee_00.wav",
	"spider/spd_melee_01.wav",
	"spider/spd_melee_02.wav",
	"spider/spd_melee_03.wav",
	"spider/spd_melee_04.wav",

}

ENT.DeathSounds = {
	"spider/spd_death_00.wav",
	"spider/spd_death_01.wav",
}

ENT.BehindSoundDistance = 0 -- When the zombie is within 200 units of a player, play these sounds instead

function ENT:StatsInitialize()
	if SERVER then
		local count = #player.GetAllPlaying()

		if nzRound:InState( ROUND_CREATE ) then
			self:SetHealth(800)
		else
			self:SetHealth( nzRound:GetZombieHealth() or 75 )
		end

		self.LastShot = CurTime() + 10
		self.UseSequenceSpeed = false
		self:SetRunSpeed(math.random(180, 300))
		self.SameSquare = false
	end
end

function ENT:SpecialInit()
	if CLIENT then
	end
end

function ENT:OnSpawn()
	ParticleEffect("bo3_zombie_spawn",self:LocalToWorld(Vector(0,-0,0)),Angle(0,0,0),nil)
	self:EmitSound("nz_moo/zombies/spawn/_generic/dirt/dirt_0"..math.random(0,2)..".mp3",100,math.random(95,105))
	local seq = self:SelectSpawnSequence()
	local _, dur = self:LookupSequence(seq)

	self:SolidMaskDuringEvent(MASK_SOLID_BRUSHONLY)
	self:SetInvulnerable(true)
	self:SetSpecialAnimation(true)



	if seq then
		self:PlaySequenceAndWait(seq)
		self:SetSpecialAnimation(false)
		self:SetInvulnerable(false)
		self:CollideWhenPossible()
	end
end

function ENT:HandleAnimEvent(a,b,c,d,e) -- Moo Mark 4/14/23: You don't know how sad I am that I didn't know about this sooner.
	if e == "step_right_small" or e == "step_left_small" or e == "step_right_large" or e == "step_left_large" then
		if self.loco:GetVelocity():Length2D() >= 75 then
			if self.CustomRunFootstepsSounds then
				self:EmitSound(self.CustomRunFootstepsSounds[math.random(#self.CustomRunFootstepsSounds)], 65)
			else
				self:EmitSound(self.NormalRunFootstepsSounds[math.random(#self.NormalRunFootstepsSounds)], 65)
			end
		else
			if self.CustomWalkFootstepsSounds then
				self:EmitSound(self.CustomWalkFootstepsSounds[math.random(#self.CustomWalkFootstepsSounds)], 65)
			else
				self:EmitSound(self.NormalWalkFootstepsSounds[math.random(#self.NormalWalkFootstepsSounds)], 65)
			end

		end
	end
	
	if e == "melee" or e == "melee_heavy" then
		if self:BomberBuff() and self.GasAttack then
			self:EmitSound(self.GasAttack[math.random(#self.GasAttack)], 100, math.random(95, 105), 1, 2)
		else
			if self.AttackSounds then
				self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2)
			end
		end
		if e == "melee_heavy" then
			self.HeavyAttack = true
		end
		self:DoAttackDamage()
	end
	if e == "start_traverse" then
		--print("starttraverse")
		self.TraversalAnim = true
	end
	if e == "finish_traverse" then
		--print("finishtraverse")
		self.TraversalAnim = false
	end
	if e == "remove_zombie" then
		self:Remove()
	end
	if e == "spider_step" then
		self:EmitSound(self.SpiderStepSounds[math.random(#self.SpiderStepSounds)], 100)
	end
	if e == "spider_cum" then
		self:EmitSound(self.SpiderStepSounds[math.random(#self.SpiderStepSounds)], 100)
		local larmfx_tag = self:LookupBone("spine_1_anim")
				local tr = util.TraceLine({
					start = self:GetPos() + Vector(0,50,0),
					endpos = self:GetTarget():GetPos() + Vector(0,0,50),
					filter = self,
					ignoreworld = true,
				})
				
				if IsValid(tr.Entity) then
					self:PlaySound(self.SpiderCumSounds[math.random(#self.SpiderCumSounds)], 90, math.random(85, 105), 1, 2)
					self.CumShot = ents.Create("nz_spider_goo") 
					self.CumShot:SetPos(self:EyePos() + self:GetForward() * 2)
					self.CumShot:Spawn()
					self.CumShot:Launch(((tr.Entity:GetPos() + Vector(0,0,50)) - self.CumShot:GetPos()):GetNormalized())
				end
	end
end

function ENT:OnPathTimeOut()
	local chance = math.random(4)
	if !self:IsAttackBlocked() then
	
	if chance >= 2 then
			if CurTime() > self.LastShot then

				self:PlaySequenceAndMove("nz_spider_shoot_intro", 1, self.FaceEnemy) --lord have mercy im bout to bust

				local larmfx_tag = self:LookupBone("spine_1_anim")
				local tr = util.TraceLine({
					start = self:GetPos() + Vector(0,50,0),
					endpos = self:GetTarget():GetPos() + Vector(0,0,50),
					filter = self,
					ignoreworld = true,
				})

				self:PlaySequenceAndMove("nz_spider_shoot", 1, self.FaceEnemy) --uh oh mario i've GOOPED
				self.LastShot = CurTime() + math.random(2,4)
			end
		end
	end
end

function ENT:PerformDeath(dmgInfo)
	self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
	self:DoDeathAnimation("nz_spider_death")
	if IsValid(self) then ParticleEffectAttach("baby_dead2", 3, self, 5) end
end

function ENT:DoDeathAnimation(seq)
	self.BehaveThread = coroutine.create(function()
		self:SetSpecialAnimation(true)
		self:PlaySequenceAndWait(seq)
		self:Remove(DamageInfo())
	end)
end

function ENT:PostAdditionalZombieStuff()

	if self:Health() < self:Health() / 2 then
		if !self.ManIsMad then
			self.ManIsMad = true
			self:SetRunSpeed(100)
			self:SpeedChanged()
		end
	end

end

function ENT:IsValidTarget( ent )
	if !ent then return false end
	return IsValid(ent) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
	-- Won't go for special targets (Monkeys), but still MAX, ALWAYS and so on
end
