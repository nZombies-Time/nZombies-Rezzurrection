AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.Type = "nextbot"
ENT.PrintName = "Killing Floor Husk yet another enemy that shoots shit at you LMAO"
ENT.Category = "Brainz"
ENT.Author = "Wavy"
ENT.Spawnable = true

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = false
ENT.MooSpecialZombie = false -- They're a Special Zombie, but is still close enough to a normal zombie to be able to do normal zombie things.
ENT.IsMooSpecial = true

AccessorFunc( ENT, "fLastToast", "LastToast", FORCE_NUMBER)

ENT.Models = {
	{Model = "models/wavy/wavy_enemies/husk/husk_kf1.mdl", Skin = 0, Bodygroups = {0,0}},
}

ENT.AttackRange = 85

ENT.DamageRange = 85

ENT.AttackDamage = 75

ENT.IdleSequence = "nz_husk_idle"

ENT.BarricadeTearSequences = {
	"nz_husk_attack",
}

local AttackSequences = {
	{seq = "nz_husk_attack"},
}

local JumpSequences = {
	{seq = "nz_husk_traverse"},
}

local walksounds = {
	Sound("wavy_zombie/husk/voicechase/chase1.wav"),
	Sound("wavy_zombie/husk/voicechase/chase2.wav"),
	Sound("wavy_zombie/husk/voicechase/chase3.wav"),
	Sound("wavy_zombie/husk/voicechase/chase4.wav"),
	Sound("wavy_zombie/husk/voicechase/chase5.wav"),
	Sound("wavy_zombie/husk/voicechase/chase6.wav"),
	Sound("wavy_zombie/husk/voicechase/chase7.wav"),
	Sound("wavy_zombie/husk/voicechase/chase8.wav"),
	Sound("wavy_zombie/husk/voicechase/chase9.wav"),
	Sound("wavy_zombie/husk/voicechase/chase10.wav"),
	Sound("wavy_zombie/husk/voicechase/chase11.wav"),
	Sound("wavy_zombie/husk/voicechase/chase12.wav"),
	Sound("wavy_zombie/husk/voicechase/chase13.wav"),
	
	Sound("wavy_zombie/husk/voicechase/chase14.wav"),
	Sound("wavy_zombie/husk/voicechase/chase15.wav"),
	Sound("wavy_zombie/husk/voicechase/chase16.wav"),
	Sound("wavy_zombie/husk/voicechase/chase17.wav"),
	Sound("wavy_zombie/husk/voicechase/chase18.wav"),
	Sound("wavy_zombie/husk/voicechase/chase19.wav"),
	Sound("wavy_zombie/husk/voicechase/chase20.wav"),
	Sound("wavy_zombie/husk/voicechase/chase21.wav"),
	Sound("wavy_zombie/husk/voicechase/chase22.wav"),
	Sound("wavy_zombie/husk/voicechase/chase23.wav"),
	Sound("wavy_zombie/husk/voicechase/chase24.wav"),
	Sound("wavy_zombie/husk/voicechase/chase25.wav"),
	Sound("wavy_zombie/husk/voicechase/chase26.wav"),
}

-- This is a very large and messy looking table... But it gets the job done.
ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawnfast},
			MovementSequence = {
				"nz_husk_walk",
			},
			AttackSequences = {AttackSequences},

			JumpSequences = {JumpSequences},

			PassiveSounds = {walksounds},
		},
	}}
}

ENT.DeathSounds = {
	"wavy_zombie/husk/voicedeath/death1.wav",
	"wavy_zombie/husk/voicedeath/death2.wav",
	"wavy_zombie/husk/voicedeath/death3.wav",
	"wavy_zombie/husk/voicedeath/death4.wav",
	"wavy_zombie/husk/voicedeath/death5.wav",
	"wavy_zombie/husk/voicedeath/death6.wav",
	"wavy_zombie/husk/voicedeath/death7.wav",
}

ENT.AttackSounds = {
	"wavy_zombie/husk/voicemelee/attack1.wav",
	"wavy_zombie/husk/voicemelee/attack2.wav",
	"wavy_zombie/husk/voicemelee/attack3.wav",
	"wavy_zombie/husk/voicemelee/attack4.wav",
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
	"wavy_zombie/fleshpound/stronghit1.wav",
	"wavy_zombie/fleshpound/stronghit2.wav",
	"wavy_zombie/fleshpound/stronghit3.wav",
	"wavy_zombie/fleshpound/stronghit4.wav",
	"wavy_zombie/fleshpound/stronghit5.wav",
	"wavy_zombie/fleshpound/stronghit6.wav",
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
			self:SetHealth( nzRound:GetZombieHealth() + 1000)
		end
		
		self:SetCollisionBounds(Vector(-18,-18, 0), Vector(18, 18, 78))
		self:SetRunSpeed(36)
		
		self.ShootCooldown = CurTime() + 2
		self.FlameCooldown = CurTime() + 2
		self.CanFlame = false
		self.FlamingFox = false
		self.CanShoot = false
		self.Shooting = false
		leftthetoasteron = false
		self.UsingFlamethrower = false
		self:SetLastToast(CurTime())
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
	self:StopSound("nz_moo/zombies/vox/_mechz/flame/loop.wav")
	self:StopParticles()
	self:BecomeRagdoll(dmginfo)
end

function ENT:OnRemove()
	self:StopSound("nz_moo/zombies/vox/_mechz/flame/loop.wav")
	self:StopParticles()
end

function ENT:IsValidTarget( ent )
	if !ent then return false end
	
	return IsValid(ent) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
	-- Won't go for special targets (Monkeys), but still MAX, ALWAYS and so on
end

function ENT:PostAdditionalZombieStuff()
	if self:GetSpecialAnimation() then return end
	if CurTime() > self.ShootCooldown and !self.CanShoot then
		self.CanShoot = true
	end
	if CurTime() > self.FlameCooldown and !self.CanFlame then
		self.CanFlame = true
	end
	if self:TargetInRange(1000) and !self:IsAttackBlocked() and self.CanShoot then
		if !self:GetTarget():IsPlayer() then return end
		if self:TargetInRange(325) then return end
		self:ShootGun()
	end
	if self:TargetInRange(300) and !self:IsAttackBlocked() and self.CanFlame and math.random(3) == 3 then
		if !self:GetTarget():IsPlayer() then return end
		self:UseFlame()
	end
end

function ENT:ShootGun()
	self:EmitSound("wavy_zombie/husk/huskguncharge.wav", 500)
	self:EmitSound("wavy_zombie/husk/voiceranged/attack"..math.random(1,6)..".wav", 500, 100, 1, 2)
	self:TempBehaveThread(function(self)
		self:SetSpecialAnimation(true)
		self.Shooting = true
		self:PlaySequenceAndMove("nz_husk_shoot", 1, self.FaceEnemy)
		self.Shooting = false
		self.CanShoot = false
		self:SetSpecialAnimation(false)
		self.ShootCooldown = CurTime() + 4
	end)
end

function ENT:UseFlame()
	self:TempBehaveThread(function(self)
		self:SetSpecialAnimation(true)
		self.FlamingFox = true
		self:PlaySequenceAndMove("nz_husk_flamethrower", 1, self.FaceEnemy)
		self.FlamingFox = false
		self.CanFlame = false
		self:SetSpecialAnimation(false)
		self.FlameCooldown = CurTime() + 2
	end)
end

function ENT:OnThink()
	if not IsValid(self) then return end
	if self.UsingFlamethrower and self:GetLastToast() + 0.1 < CurTime() then -- This controls how offten the trace for the flamethrower updates it's position. This shit is very costly so I wanted to try limit how much it does it.
		self:StartToasting()
	end
	if !self.UsingFlamethrower then
		self:StopSound("nz_moo/zombies/vox/_mechz/flame/loop.wav")
	end
end

function ENT:StartToasting()
	self.UsingFlamethrower = true
	if self.UsingFlamethrower then
		--print("I'm Nintoasting!!!")

		if not leftthetoasteron then
			ParticleEffectAttach("asw_mnb_flamethrower",PATTACH_POINT_FOLLOW,self,1)
			self:EmitSound("nz_moo/zombies/vox/_mechz/flame/start.mp3",95, math.random(85, 105))
			self:EmitSound("nz_moo/zombies/vox/_mechz/flame/loop.wav",100, 100)
			leftthetoasteron = true
		end

		self:SetLastToast(CurTime())
		if !self.NextFireParticle or self.NextFireParticle < CurTime() then
			local bone = self:GetAttachment(self:LookupAttachment("HuskgunShoot"))
			pos = bone.Pos
			local mins = Vector(0, -8, -15)
			local maxs = Vector(325, 20, 15)
			local tr = util.TraceHull({
				start = pos,
				endpos = pos + bone.Ang:Forward()*500,
				filter = self,
				mask = MASK_PLAYERSOLID,
				collisiongroup = COLLISION_GROUP_INTERACTIVE_DEBRIS,
				ignoreworld = true,
				mins = mins,
				maxs = maxs,
			})
		
			debugoverlay.BoxAngles(pos, mins, maxs, bone.Ang, 1, Color( 255, 255, 255, 10))
					
			if self:IsValidTarget(tr.Entity) then
				local dmg = DamageInfo()
				dmg:SetAttacker(self)
				dmg:SetInflictor(self)
				dmg:SetDamage(4)
				dmg:SetDamageType(DMG_BURN)
						
				tr.Entity:TakeDamageInfo(dmg)
				tr.Entity:Ignite(3, 0)
			end
		end
		self.NextFireParticle = CurTime() + 0.05
	end
end

function ENT:StopToasting()
	if self.UsingFlamethrower then
		--print("I'm no longer Nintoasting.")
		if leftthetoasteron then
			self:EmitSound("nz_moo/zombies/vox/_mechz/flame/end.mp3",100, math.random(85, 105))
			self:StopSound("nz_moo/zombies/vox/_mechz/flame/loop.wav")
			leftthetoasteron = false
		end
		self.UsingFlamethrower = false
		self:StopParticles()
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
	if e == "husk_shoot" then
		self:EmitSound("wavy_zombie/husk/huskgunshoot.wav", 500)
		self:EmitSound("wavy_zombie/husk/huskgununcharge.wav", 500)
		local larmfx_tag = self:LookupBone("Barrel")
		local tr = util.TraceLine({
			start = self:GetPos() + Vector(0,50,0),
			endpos = self:GetTarget():GetPos() + Vector(0,0,50),
			filter = self,
			ignoreworld = true,
		})	
		if IsValid(tr.Entity) then
		self.Skull = ents.Create("husk_fireball")
		self.Skull:SetPos(self:GetBonePosition(larmfx_tag))
		self.Skull:SetOwner(self:GetOwner())
		self.Skull:Spawn()
		self.Skull:Launch(((tr.Entity:GetPos() + Vector(0,0,50)) - self.Skull:GetPos()):GetNormalized())
		end
	end
	if e == "husk_flame_start" then
		self:StartToasting()
	end
	if e == "husk_flame_end" then
		self:StopToasting()
	end
end