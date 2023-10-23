AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.Type = "nextbot"
ENT.PrintName = "Killing Floor Crawler (no not a half body the jumping spider things)"
ENT.Category = "Brainz"
ENT.Author = "Wavy"
ENT.Spawnable = true

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = false
ENT.MooSpecialZombie = false -- They're a Special Zombie, but is still close enough to a normal zombie to be able to do normal zombie things.
ENT.IsMooSpecial = true

ENT.Models = {
	{Model = "models/wavy/wavy_enemies/crawler/crawler_kf1.mdl", Skin = 0, Bodygroups = {0,0}},
}

ENT.AttackRange = 80

ENT.DamageRange = 80

ENT.AttackDamage = 45

ENT.JumpAttackDamage = 75

ENT.JumpDamageRange = 120

ENT.IdleSequence = "nz_kfcrawler_idle"

ENT.BarricadeTearSequences = {
	"nz_kfcrawler_attack2",
}

local AttackSequences = {
	{seq = "nz_kfcrawler_attack1"},
	{seq = "nz_kfcrawler_attack2"},
}

local JumpSequences = {
	{seq = "nz_kfcrawler_traverse"},
}

local walksounds = {
	Sound("wavy_zombie/crawler/voiceidle/idle1.wav"),
	Sound("wavy_zombie/crawler/voiceidle/idle2.wav"),
	Sound("wavy_zombie/crawler/voiceidle/idle3.wav"),
	Sound("wavy_zombie/crawler/voiceidle/idle4.wav"),
}

-- This is a very large and messy looking table... But it gets the job done.
ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawnfast},
			MovementSequence = {
				"nz_kfcrawler_walk",
			},
			AttackSequences = {AttackSequences},

			JumpSequences = {JumpSequences},

			PassiveSounds = {walksounds},
		},
	}}
}

ENT.DeathSounds = {
	"wavy_zombie/crawler/voicedeath/death1.wav",
	"wavy_zombie/crawler/voicedeath/death2.wav",
	"wavy_zombie/crawler/voicedeath/death3.wav",
	"wavy_zombie/crawler/voicedeath/death4.wav",
	"wavy_zombie/crawler/voicedeath/death5.wav",
	"wavy_zombie/crawler/voicedeath/death6.wav",
	"wavy_zombie/crawler/voicedeath/death7.wav",
	"wavy_zombie/crawler/voicedeath/death8.wav",
}

ENT.AttackSounds = {
	"wavy_zombie/crawler/voicemelee/attack1.wav",
	"wavy_zombie/crawler/voicemelee/attack2.wav",
	"wavy_zombie/crawler/voicemelee/attack3.wav",
	"wavy_zombie/crawler/voicemelee/attack4.wav",
	"wavy_zombie/crawler/voicemelee/attack5.wav",
	"wavy_zombie/crawler/voicemelee/attack6.wav",
}

ENT.CustomWalkFootstepsSounds = {
	"wavy_zombie/husk/tile1.wav",
	"wavy_zombie/husk/tile2.wav",
	"wavy_zombie/husk/tile3.wav",
	"wavy_zombie/husk/tile4.wav",
	"wavy_zombie/husk/tile5.wav",
	"wavy_zombie/husk/tile6.wav",
}

ENT.CustomRunFootstepsSounds = {
	"wavy_zombie/husk/tile1.wav",
	"wavy_zombie/husk/tile2.wav",
	"wavy_zombie/husk/tile3.wav",
	"wavy_zombie/husk/tile4.wav",
	"wavy_zombie/husk/tile5.wav",
	"wavy_zombie/husk/tile6.wav",
}

ENT.CustomAttackImpactSounds = {
	"wavy_zombie/chainsaw/clawhit1.wav",
	"wavy_zombie/chainsaw/clawhit2.wav",
	"wavy_zombie/chainsaw/clawhit3.wav",
	"wavy_zombie/chainsaw/clawhit4.wav",
	"wavy_zombie/chainsaw/clawhit5.wav",
}

ENT.BehindSoundDistance = 1 -- When the zombie is within 200 units of a player, play these sounds instead
ENT.BehindSounds = {
	Sound("nz_moo/zombies/vox/mute_00.wav"),
}

function ENT:StatsInitialize()
	if SERVER then
		if nzRound:InState( ROUND_CREATE ) then
			self:SetHealth(100)
		else
			self:SetHealth( nzRound:GetZombieHealth() )
		end
		
		self:SetCollisionBounds(Vector(-20,-20, 0), Vector(20, 20, 70))
		self:SetRunSpeed(36)
		
		self.JumpCooldown = CurTime() + 2
		self.CanJump = false
		self.Jumping = false
	end
end

function ENT:SpecialInit()
	if CLIENT then
	end
end

function ENT:OnSpawn()
	self:SolidMaskDuringEvent(MASK_SOLID_BRUSHONLY)
	self:CollideWhenPossible()

	local effectData = EffectData()
	effectData:SetOrigin( self:GetPos() + Vector(0, 0, 50)  )
	effectData:SetMagnitude( 1 )
	effectData:SetEntity(nil)
	util.Effect("panzer_spawn_tp", effectData)
end

function ENT:PerformDeath(dmginfo)
	self:EmitSound(self.DeathSounds[math.random(#self.DeathSounds)], 500, math.random(95, 105), 1, 2)
	self:BecomeRagdoll(dmginfo)
end

function ENT:PostAdditionalZombieStuff()
	if self:GetSpecialAnimation() then return end
	if CurTime() > self.JumpCooldown and !self.CanJump then
		self.CanJump = true
	end
	if self:TargetInRange(220) and !self:IsAttackBlocked() and self.CanJump then
		if !self:GetTarget():IsPlayer() then return end
		self:JumpAttack()
	end
end

function ENT:JumpAttack()
	self:EmitSound("wavy_zombie/crawler/voicejump/jump"..math.random(1,6)..".wav", 500, 100, 1, 2)
	self:TempBehaveThread(function(self)
		self:SetSpecialAnimation(true)
		self.Jumping = true
		self:PlaySequenceAndMove("nz_kfcrawler_jumpattack", 1, self.FaceEnemy)
		self.Jumping = false
		self.CanJump = false
		self:SetSpecialAnimation(false)
		self.JumpCooldown = CurTime() + 3
	end)
end

function ENT:DoJumpAttackDamage() -- Moo Mark 4/14/23: Made the part that does damage during an attack its own function.
	local target = self:GetTarget()

	local damage = self.JumpAttackDamage
	local dmgrange = self.JumpDamageRange
	local range = self.AttackRange

	if self:GetIsBusy() then
		range = self.AttackRange + 45
		dmgrange = self.JumpDamageRange + 45
	else
		range = self.AttackRange + 25
	end

	if self:WaterBuff() and self:BomberBuff() then
		damage = self.JumpAttackDamage * 3
	elseif self:WaterBuff() then
		damage = self.JumpAttackDamage * 2
	end

	if IsValid(target) and target:Health() and target:Health() > 0 then -- Doesn't matter if its a player... If the zombie is targetting it, they probably wanna attack it.
		if self:TargetInRange( range ) then

			local dmgInfo = DamageInfo()
			dmgInfo:SetAttacker( self )
			dmgInfo:SetDamage( damage )
			dmgInfo:SetDamageType( DMG_SLASH )
			dmgInfo:SetDamageForce( (target:GetPos() - self:GetPos()) * 7 + Vector( 0, 0, 16 ) )

			if self:TargetInRange( dmgrange ) then
				target:TakeDamageInfo(dmgInfo)
				if comedyday or math.random(500) == 1 then
					if self.GoofyahAttackSounds then target:EmitSound(self.GoofyahAttackSounds[math.random(#self.GoofyahAttackSounds)], SNDLVL_TALKING, math.random(95,105)) end
				else
					if self.CustomAttackImpactSounds then
						target:EmitSound(self.CustomAttackImpactSounds[math.random(#self.CustomAttackImpactSounds)], SNDLVL_TALKING, math.random(95,105))
					else
						target:EmitSound(self.AttackImpactSounds[math.random(#self.AttackImpactSounds)], SNDLVL_TALKING, math.random(95,105))
					end
				end
			end
		end
	end
end

function ENT:HandleAnimEvent(a,b,c,d,e) -- Moo Mark 4/14/23: You don't know how sad I am that I didn't know about this sooner.
	if e == "step_right_small" or e == "step_left_small" then
		if self.CustomWalkFootstepsSounds then
			self:EmitSound(self.CustomWalkFootstepsSounds[math.random(#self.CustomWalkFootstepsSounds)], 70)
		else
			self:EmitSound("CoDZ_Zombie.StepWalk")
		end
	end
	if e == "step_right_large" or e == "step_left_large" then
		if self.CustomRunFootstepsSounds then
			self:EmitSound(self.CustomRunFootstepsSounds[math.random(#self.CustomRunFootstepsSounds)], 70)
		else
			self:EmitSound("CoDZ_Zombie.StepRun")
		end
	end
	if e == "melee" then
		if self.AttackSounds then
			self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(95, 105), 1, 2)
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
	if e == "jump_attack" then
		self:DoJumpAttackDamage()
	end
end