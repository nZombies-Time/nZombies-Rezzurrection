AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Licker"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo"

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true
ENT.IsMooSpecial = true
ENT.AttackRange = 100
ENT.DamageRange = 90
ENT.AttackDamage = 20

ENT.Models = {
	{Model = "models/specials/licker.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"reaction"}

local AttackSequences = {
	{seq = "att1"},
	{seq = "att2"}
}


local JumpSequences = {
	{seq = ACT_JUMP, speed = 100},
}


ENT.BarricadeTearSequences = {
	--Leave this empty if you don't intend on having a special enemy use tear anims.
}

ENT.IdleSequence = "idle"

ENT.DeathSequences = {
	"flinch_kb_2",
}

ENT.ElectrocutionSequences = {
	"flinch_kb_2",
}

ENT.AttackSounds = {
	"enemies/specials/licker/atk1.ogg",
	"enemies/specials/licker/atk2.ogg",
	"enemies/specials/licker/atk3.ogg",
	"enemies/specials/licker/atk4.ogg",
	"enemies/specials/licker/atk5.ogg",
	"enemies/specials/licker/atk6.ogg",
}

local walksounds = {
	Sound("enemies/specials/licker/idle1.ogg"),
	Sound("enemies/specials/licker/idle2.ogg"),
	Sound("enemies/specials/licker/idle3.ogg"),
	Sound("enemies/specials/licker/idle4.ogg"),
	Sound("enemies/specials/licker/idle5.ogg"),
	Sound("enemies/specials/licker/idle6.ogg"),
	Sound("enemies/specials/licker/idle7.ogg"),
	Sound("enemies/specials/licker/idle8.ogg"),
	Sound("enemies/specials/licker/idle9.ogg"),
	Sound("enemies/specials/licker/idle10.ogg"),
	Sound("enemies/specials/licker/idle11.ogg"),
	Sound("enemies/specials/licker/idle12.ogg"),

}

ENT.DeathSounds = {
	"enemies/specials/licker/death1.ogg",
	"enemies/specials/licker/death2.ogg",
	"enemies/specials/licker/death3.ogg",
	"enemies/specials/licker/death4.ogg",
	"enemies/specials/licker/death5.ogg",
	"enemies/specials/licker/death6.ogg",
}

ENT.AppearSounds = {
	"enemies/specials/licker/spawn1.ogg",
	"enemies/specials/licker/spawn2.ogg",
	"enemies/specials/licker/spawn3.ogg",
	"enemies/specials/licker/spawn4.ogg",
	"enemies/specials/licker/spawn5.ogg",
	"enemies/specials/licker/spawn6.ogg",
}

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
	}},
	{Threshold = 100, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"run",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}}
}

function ENT:StatsInitialize()
	if SERVER then
		self.Sprinting = false
		self:SetRunSpeed( 25 )
		self.loco:SetDesiredSpeed( 25 )
	end
	self:SetCollisionBounds(Vector(-20,-20, 0), Vector(20, 20, 45))
end

function ENT:OnSpawn()
	self:SetMaterial("invisible")
	self:SetInvulnerable(true)
	self:SetBlockAttack(true)
	self:SolidMaskDuringEvent(MASK_PLAYERSOLID)

	self:EmitSound("nz/hellhound/spawn/prespawn.wav",511,100)
	ParticleEffect("hound_summon",self:GetPos(),self:GetAngles(),nil)
	--ParticleEffect("fx_hellhound_summon",self:GetPos(),self:GetAngles(),nil)

	self:TimeOut(0.85)
	self:SetBodygroup(2,0)
	self:EmitSound("nz/hellhound/spawn/strike.wav",511,100)
	ParticleEffectAttach("ins_skybox_lightning",PATTACH_ABSORIGIN_FOLLOW,self,0)
	
	self:SetMaterial("")
	self:SetInvulnerable(nil)
	self:SetBlockAttack(false)
	self:CollideWhenPossible()
	self:EmitSound(self.AppearSounds[math.random(#self.AppearSounds)], 511, math.random(85, 105), 1, 2)

	nzRound:SetNextSpawnTime(CurTime() + 3) -- This one spawning delays others by 3 seconds
end

function ENT:PerformDeath(dmgInfo)
		if IsValid(self) then
			self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
			self:DoDeathAnimation(self.DeathSequences[math.random(#self.DeathSequences)])
	end
end

function ENT:DoDeathAnimation(seq)
	self.BehaveThread = coroutine.create(function()
		self:PlaySequenceAndWait(seq)
		if IsValid(self) then
				self:Remove()
		end
	end)
end


function ENT:OnPathTimeOut()
	local distToTarget = self:GetPos():Distance(self:GetTargetPosition())
	if IsValid(self:GetTarget()) then
		if not self.Sprinting and distToTarget < 750 then
			self:EmitSound(self.AppearSounds[math.random(#self.AppearSounds)], 511, math.random(85, 105), 1, 2)
			self.Sprinting = true
			self:SetRunSpeed( 101 )
			self.loco:SetDesiredSpeed( 101 )
			self:SpeedChanged()
			--ParticleEffectAttach("fx_hellhound_aura_fire",PATTACH_ABSORIGIN_FOLLOW,self,0)
		end
	end
end

function ENT:HandleAnimEvent(a,b,c,d,e)
	if e == "attackhit" then
		self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2)
		self:DoAttackDamage()
	end
	if e == "step" then
		self:EmitSound("enemies/specials/licker/step"..math.random(1,6)..".ogg",80,math.random(95,100))
	end

end


function ENT:PlayAttackAndWait( name, speed )

	local len = self:SetSequence( name )
	speed = speed or 1

	self:ResetSequenceInfo()
	self:SetCycle( 0 )
	self:SetPlaybackRate( speed )

	local endtime = CurTime() + len / speed

	while ( true ) do

		if ( endtime < CurTime() ) then
			if !self:GetStop() then
				self:ResetMovementSequence()
				self.loco:SetDesiredSpeed( self:GetRunSpeed() )
			end
			return
		end
		if self:IsValidTarget( self:GetTarget() ) then
			self.loco:FaceTowards( self:GetTarget():GetPos() )
		end

		coroutine.yield()

	end

end

function ENT:IsValidTarget( ent )
	if not ent then return false end
	return IsValid( ent ) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
end