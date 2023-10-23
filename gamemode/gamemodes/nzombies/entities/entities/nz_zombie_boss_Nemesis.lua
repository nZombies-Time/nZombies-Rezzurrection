AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "STAAAAAAAAAAARS"
ENT.Category = "Brainz"
ENT.Author = "Laby and GhostlyMoo"

--I'm like a creepy old man except I have a rocket launcher

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true
ENT.IsMooSpecial = true

ENT.AttackDamage = 88
ENT.AttackRange = 125
ENT.DamageRange = 110
ENT.TraversalCheckRange = 80

ENT.Models = {
	{Model = "models/bosses/ens1.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"stumble_3"}

ENT.DeathSequences = {

}

local AttackSequences = {
	{seq = "melee"},
}

ENT.BarricadeTearSequences = {
	--Leave this empty if you don't intend on having a special enemy use tear anims.
}

local walksounds = {
	Sound("enemies/bosses/nemesis/idle1.ogg"),
	Sound("enemies/bosses/nemesis/idle2.ogg"),
	Sound("enemies/bosses/nemesis/idle3.ogg"),
	Sound("enemies/bosses/nemesis/idle4.ogg"),
	Sound("enemies/bosses/nemesis/idle5.ogg"),
	Sound("enemies/bosses/nemesis/idle6.ogg"),
	Sound("enemies/bosses/nemesis/idle8.ogg"),
	Sound("enemies/bosses/nemesis/idle9.ogg")
	}

ENT.AttackSounds = {
	"enemies/bosses/nemesis/atk9.ogg",
	"enemies/bosses/nemesis/atk1.ogg",
	"enemies/bosses/nemesis/atk2.ogg",
	"enemies/bosses/nemesis/atk3.ogg",
	"enemies/bosses/nemesis/atk4.ogg",
	"enemies/bosses/nemesis/atk5.ogg",
	"enemies/bosses/nemesis/atk6.ogg",
	"enemies/bosses/nemesis/atk7.ogg",
	"enemies/bosses/nemesis/atk8.ogg",
}

ENT.PainSounds = {
	"nz/zombies/death/nz_flesh_impact_1.wav",
	"nz/zombies/death/nz_flesh_impact_2.wav",
	"nz/zombies/death/nz_flesh_impact_3.wav",
	"nz/zombies/death/nz_flesh_impact_4.wav"
}

ENT.DeathSounds = {
	"enemies/bosses/nemesis/madge.ogg"
}

ENT.IdleSequence = "idle"

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"walk",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}}
}

function ENT:StatsInitialize()
	if SERVER then
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		if nzRound:InState( ROUND_CREATE ) then
			self:SetHealth(500)
			self:SetMaxHealth(500)
		else
			self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
			self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		end
		
		self.NextAction = 0
		self.NextTeleporTime = 0
		self:SetMooSpecial(true)
		self:SetRunSpeed( 20 )
		self.loco:SetDesiredSpeed( 20 )
		self:SetCollisionBounds(Vector(-16,-16, 0), Vector(16, 16, 90))
	end
end

function ENT:OnSpawn()

	self:SolidMaskDuringEvent(MASK_SOLID_BRUSHONLY)
	self:EmitSound("enemies/bosses/nemesis/spawn1.ogg",511)
	ParticleEffect("bo3_panzer_landing",self:GetPos()+Vector(0,0,1),Angle(0,0,0),nil)
	self:SetInvulnerable(true)
	self:SetSpecialAnimation(true)
	local seq = self:SelectSpawnSequence()
	if seq then
		self:PlaySequenceAndWait(seq)
		self:EmitSound("enemies/bosses/nemesis/idle6.ogg",511)
		self:SetSpecialAnimation(false)
		self:SetInvulnerable(false)
		self:CollideWhenPossible()
	end
end

function ENT:PerformDeath(dmgInfo)
		if IsValid(self) then
			ParticleEffect("bo3_margwa_death",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
			self:Remove()
		end

end

function ENT:DoDeathAnimation(seq)
	self.BehaveThread = coroutine.create(function()
		self:PlaySequenceAndWait(seq)
		if IsValid(self) then
			ParticleEffect("bo3_margwa_death",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
			self:Remove()
		end
	end)
end

function ENT:OnPathTimeOut()
	--local PhaseShoot = math.random(2) -- A chance to either Shoot a Plasma Ball or Teleport.
	local target = self:GetTarget()
	if CurTime() < self.NextAction then return end
	if !self:IsAttackBlocked() then
			-- Ranged Attack/Plasma Ball or Gas Ball
			if target:IsPlayer() then
				--for i=1,1 do ParticleEffectAttach("hcea_shield_recharged",PATTACH_POINT_FOLLOW,self,2) end
				self:PlaySequenceAndMove("rpg_raise", 1, self.FaceEnemy)
				--print("TODAY IS FRIDAY IN CALIFORNIA")
				self:PlaySequenceAndMove("rpg_fire", 1, self.FaceEnemy)
				self.NextAction = CurTime() + math.random(5, 12)
			end
	end
end

function ENT:HandleAnimEvent(a,b,c,d,e)
	if e == "melee" then
		self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2)
		self:DoAttackDamage()
	end
	if e == "re_step_l" then
		self:EmitSound("enemies/bosses/nemesis/step"..math.random(1,6)..".ogg",80,math.random(95,100))
		util.ScreenShake(self:GetPos(),100000,500000,0.2,1000)
	end
	if e == "re_step_r" then
		self:EmitSound("enemies/bosses/nemesis/step"..math.random(1,6)..".ogg",80,math.random(95,100))
		util.ScreenShake(self:GetPos(),100000,500000,0.2,1000)
		
	end
	if e == "nms_launcher_aim" then
		self:EmitSound("enemies/bosses/nemesis/aim.ogg",80,100)
	end
	

	if e == "nms_launch" then
	local target = self:GetTarget()
	local tr = util.TraceLine({
			start = self:GetPos() + Vector(0,50,0),
			endpos = self:GetTarget():GetPos() + Vector(0,0,50),
			filter = self,
		})
	self:EmitSound("enemies/bosses/nemesis/shoot.ogg", 95, math.random(95,105))
		local clawpos = self:GetBonePosition(self:LookupBone( "L_yubi2_2" ))
				self.ClawHook = ents.Create("nz_nemesis_rocket")
				self.ClawHook:SetPos(clawpos)
				self.ClawHook:Spawn()
				self.ClawHook:Launch(((tr.Entity:GetPos() + Vector(0,0,50)) - self.ClawHook:GetPos()):GetNormalized())
				self:SetAngles((target:GetPos() - self:GetPos()):Angle())
	end 

end





-- A standard attack you can use it or create something fancy yourself

function ENT:IsValidTarget( ent )
	if not ent then return false end
	return IsValid( ent ) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
end