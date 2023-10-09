AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Frog OF DOOM"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo"

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true
ENT.IsMooSpecial = true
ENT.AttackRange = 120
ENT.DamageRange = 110
ENT.AttackDamage = 25

ENT.Models = {
	{Model = "models/specials/lurker.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"flinch"}

local AttackSequences = {
	{seq = "att1", dmgtimes = {0.5, 0.9}}
}


local JumpSequences = {
	{seq = "mantle", speed = 100},
}


ENT.BarricadeTearSequences = {
	--Leave this empty if you don't intend on having a special enemy use tear anims.
}

ENT.IdleSequence = "idle"

ENT.DeathSequences = {
	"death",
}

ENT.ElectrocutionSequences = {
	"death",
}

ENT.AttackSounds = {
	"enemies/specials/lurker/atk1.ogg",
	"enemies/specials/lurker/atkfunny.ogg",
	"enemies/specials/lurker/idle6.ogg",
	"enemies/specials/lurker/idle7.ogg"
}

local walksounds = {
	Sound("enemies/specials/lurker/idle1.ogg"),
	Sound("enemies/specials/lurker/idle2.ogg"),
	Sound("enemies/specials/lurker/idle3.ogg"),
	Sound("enemies/specials/lurker/idle4.ogg"),
	Sound("enemies/specials/lurker/idle5.ogg"),
	Sound("enemies/specials/lurker/idle6.ogg"),
	Sound("enemies/specials/lurker/idle7.ogg"),
	Sound("enemies/specials/lurker/idle8.ogg"),
	Sound("enemies/specials/lurker/idle9.ogg"),
	Sound("enemies/specials/lurker/idle10.ogg"),
	Sound("enemies/specials/lurker/idle11.ogg"),
	Sound("enemies/specials/lurker/idle12.ogg"),
}

ENT.DeathSounds = {
	"enemies/specials/lurker/death.ogg"
}

ENT.AppearSounds = {
	"enemies/specials/lurker/idle1.ogg",
	"enemies/specials/lurker/idle2.ogg",
	"enemies/specials/lurker/idle3.ogg",
	"enemies/specials/lurker/idle4.ogg",
}

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
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
		self:SetRunSpeed( 45 )
		self.loco:SetDesiredSpeed( 45 )
	end
	self:SetCollisionBounds(Vector(-30,-30, 0), Vector(30, 30, 40))
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
	self:ManipulateBoneScale(42,Vector(0.1,0.1,0.1))
	self:ManipulateBoneScale(43,Vector(0.1,0.1,0.1))
	self:ManipulateBoneScale(45,Vector(0.1,0.1,0.1))
	self:ManipulateBoneScale(46,Vector(0.5,0.5,0.5))
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




function ENT:HandleAnimEvent(a,b,c,d,e)
	if e == "attackhit" then
		self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2)
		self:DoAttackDamage()
	end
	if e == "step" then
		self:EmitSound("enemies/specials/lurker/step"..math.random(1,4)..".ogg",80,math.random(95,100))
	end
	
	if e == "down" then
		self:EmitSound("enemies/specials/lurker/spawn1.ogg",80,math.random(95,100))
		util.ScreenShake(self:GetPos(),100000,500000,0.2,1000)
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