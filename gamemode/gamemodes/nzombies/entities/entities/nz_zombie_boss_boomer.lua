AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "BOOMER!"
ENT.Category = "Brainz"
ENT.Author = "Laby and GhostlyMoo"

--KILL HOMINID

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
	{Model = "models/bosses/locust_boomer.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"AR_Reload"}

ENT.DeathSequences = {
"Death_Reaching",
"Death_Blown_Rt",
"Death_Blown_Lt",
"Death_Back"
}

local JumpSequences = {
	{seq = "AR_Mantle_Start_New"}
}

local AttackSequences = {
	{seq = "AR_Swipe"},
}

ENT.BarricadeTearSequences = {
	--Leave this empty if you don't intend on having a special enemy use tear anims.
}

local walksounds = {
	Sound("enemies/bosses/boomer/ambi1.ogg"),
	Sound("enemies/bosses/boomer/ambi2.ogg"),
	Sound("enemies/bosses/boomer/ambi3.ogg"),
	Sound("enemies/bosses/boomer/ambi4.ogg"),
	Sound("enemies/bosses/boomer/ambi5.ogg"),
	Sound("enemies/bosses/boomer/ambi6.ogg"),
	Sound("enemies/bosses/boomer/ambi7.ogg"),
	Sound("enemies/bosses/boomer/ambi8.ogg"),
	Sound("enemies/bosses/boomer/ambi9.ogg"),
	Sound("enemies/bosses/boomer/ambi10.ogg"),
	Sound("enemies/bosses/boomer/ambi11.ogg"),
	Sound("enemies/bosses/boomer/ambi12.ogg"),
	Sound("enemies/bosses/boomer/ambi13.ogg"),
	Sound("enemies/bosses/boomer/ambi14.ogg"),
	Sound("enemies/bosses/boomer/ambi15.ogg"),
	Sound("enemies/bosses/boomer/ambi16.ogg"),
	Sound("enemies/bosses/boomer/ambi17.ogg"),
	Sound("enemies/bosses/boomer/ambi18.ogg"),
	Sound("enemies/bosses/boomer/ambi19.ogg"),
	Sound("enemies/bosses/boomer/ambi20.ogg"),
	Sound("enemies/bosses/boomer/ambi21.ogg"),
	Sound("enemies/bosses/boomer/ambi22.ogg"),
	Sound("enemies/bosses/boomer/ambi23.ogg")
}

ENT.AttackSounds = {
	"enemies/bosses/boomer/atk1.ogg",
	"enemies/bosses/boomer/atk2.ogg",
	"enemies/bosses/boomer/atk3.ogg",
	"enemies/bosses/boomer/atk4.ogg",
	"enemies/bosses/boomer/atk5.ogg",
	"enemies/bosses/boomer/atk6.ogg",
	"enemies/bosses/boomer/atk7.ogg",
}

ENT.PainSounds = {
	"nz/zombies/death/nz_flesh_impact_1.wav",
	"nz/zombies/death/nz_flesh_impact_2.wav",
	"nz/zombies/death/nz_flesh_impact_3.wav",
	"nz/zombies/death/nz_flesh_impact_4.wav"
}

ENT.DeathSounds = {
	"enemies/bosses/boomer/death1.ogg",
	"enemies/bosses/boomer/death2.ogg",
	"enemies/bosses/boomer/death3.ogg",
	"enemies/bosses/boomer/death4.ogg",
	"enemies/bosses/boomer/death5.ogg",
	"enemies/bosses/boomer/death6.ogg",
	"enemies/bosses/boomer/death7.ogg",
	"enemies/bosses/boomer/death8.ogg",
}

ENT.IdleSequence = "AR_Idle_Ready_Aim"

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"Walk_All",
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
		self:SetCollisionBounds(Vector(-20,-20, 0), Vector(20, 20, 100))
	end
end

function ENT:OnSpawn()

	self:SolidMaskDuringEvent(MASK_SOLID_BRUSHONLY)
	--self:EmitSound("enemies/bosses/boomer/ambi11.ogg",511)
	ParticleEffect("bo3_panzer_landing",self:GetPos()+Vector(0,0,1),Angle(0,0,0),nil)
	self:SetInvulnerable(true)
	self:SetSpecialAnimation(true)
	local seq = self:SelectSpawnSequence()
	if seq then
		self:PlaySequenceAndWait(seq)
	
		self:SetSpecialAnimation(false)
		self:SetInvulnerable(false)
		self:CollideWhenPossible()
	end
end

function ENT:PerformDeath(dmgInfo)
		if IsValid(self) then
			self:DoDeathAnimation()
		end

end

function ENT:DoDeathAnimation(seq)
	self.BehaveThread = coroutine.create(function()
	self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
		self:PlaySequenceAndWait(seq)
		if IsValid(self) then
			--ParticleEffect("bo3_margwa_death",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
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
				self:PlaySequenceAndMove("AR_Idle_Ready_Aim", 1, self.FaceEnemy)
				--print("TODAY IS FRIDAY IN CALIFORNIA")
				self:PlaySequenceAndMove("AR_Fire", 1, self.FaceEnemy)
				self:PlaySequenceAndMove("AR_Reload", 1, self.FaceEnemy)
				self.NextAction = CurTime() + math.random(10, 20)
			end
	end
end

function ENT:HandleAnimEvent(a,b,c,d,e)
	if e == "melee" then
		self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2)
		self:DoAttackDamage()
	end
	if e == "boomer_walk" then
		self:EmitSound("enemies/bosses/nemesis/step"..math.random(1,6)..".ogg",80,math.random(95,100))
		util.ScreenShake(self:GetPos(),100000,500000,0.2,1000)
	end
	if e == "boomer_yell" then
		self:EmitSound("enemies/bosses/boomer/boom"..math.random(1,6)..".ogg",80,100)
	end
	if e == "boomer_reload1" then
		self:EmitSound("enemies/bosses/boomer/reload1.ogg",80,100)
	end
	if e == "boomer_reload2" then
		self:EmitSound("enemies/bosses/boomer/reload2.ogg",80,100)
	end
	if e == "boomer_reload3" then
		self:EmitSound("enemies/bosses/boomer/reload3.ogg",80,100)
	end

	if e == "boomer_fire" then
	local target = self:GetTarget()
	local tr = util.TraceLine({
			start = self:GetPos() + Vector(0,50,0),
			endpos = self:GetTarget():GetPos() + Vector(0,0,50),
			filter = self,
		})
	self:EmitSound("enemies/bosses/nemesis/shoot.ogg", 95, math.random(95,105))
	self:EmitSound("enemies/bosses/boomer/fire.ogg", 95, math.random(95,105))
		local clawpos = self:GetBonePosition(self:LookupBone( "b_MF_Finger_12_L" ))
		--obj_gearsofwar_boomshot_projectile
				self.ClawHook = ents.Create("nz_boomshot")
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