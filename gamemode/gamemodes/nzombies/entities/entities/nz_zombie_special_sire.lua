AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Hunchback of Halvo Bay"
ENT.Category = "Brainz"
ENT.Author = "Laby"

--This is what incest results in. STEP SIRE IM STUCK
if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true
ENT.IsMooSpecial = true
ENT.AttackRange = 90
ENT.DamageRange = 86
ENT.AttackDamage = 45

ENT.Models = {
	{Model = "models/specials/sire.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"getup_unarmed"}

local AttackSequences = {
	{seq = "attack_1", dmgtimes = {0.9}},
	{seq = "attack_2", dmgtimes = {0.6}}
}




ENT.BarricadeTearSequences = {
	--Leave this empty if you don't intend on having a special enemy use tear anims.
}

ENT.IdleSequence = "idle"

ENT.DeathSequences = {
	"death1","death2"
}

ENT.ElectrocutionSequences = {
	"executed_chainsaw",
}

ENT.AttackSounds = {
	"enemies/specials/sire/atk1.ogg",
	"enemies/specials/sire/atk2.ogg",
	"enemies/specials/sire/atk3.ogg",
	"enemies/specials/sire/atk4.ogg",
	"enemies/specials/sire/atk5.ogg",
	"enemies/specials/sire/atk6.ogg",
	"enemies/specials/sire/atk7.ogg",
	"enemies/specials/sire/atk8.ogg",
	"enemies/specials/sire/atk9.ogg",
	"enemies/specials/sire/atk10.ogg"
}

local walksounds = {
	Sound("enemies/specials/sire/amb1.ogg"),
	Sound("enemies/specials/sire/amb2.ogg"),
	Sound("enemies/specials/sire/amb3.ogg"),
	Sound("enemies/specials/sire/amb4.ogg"),
	Sound("enemies/specials/sire/amb5.ogg"),
	Sound("enemies/specials/sire/amb6.ogg"),
	Sound("enemies/specials/sire/amb7.ogg"),
	Sound("enemies/specials/sire/amb8.ogg"),
	Sound("enemies/specials/sire/amb9.ogg"),
	Sound("enemies/specials/sire/amb10.ogg"),
	Sound("enemies/specials/sire/amb11.ogg"),
	Sound("enemies/specials/sire/amb12.ogg"),
	Sound("enemies/specials/sire/amb13.ogg"),
	Sound("enemies/specials/sire/amb14.ogg"),
	Sound("enemies/specials/sire/amb15.ogg")

}

ENT.DeathSounds = {
	"enemies/specials/sire/death1.ogg",
	"enemies/specials/sire/death2.ogg",
	"enemies/specials/sire/death3.ogg",
	"enemies/specials/sire/death4.ogg",
	"enemies/specials/sire/death5.ogg",
	"enemies/specials/sire/death6.ogg",
	"enemies/specials/sire/death7.ogg",
	"enemies/specials/sire/death8.ogg",
	"enemies/specials/sire/death9.ogg",
	"enemies/specials/sire/death10.ogg"
}

ENT.AppearSounds = {
	"enemies/specials/sire/spawn1.ogg",
	"enemies/specials/sire/spawn2.ogg",
	"enemies/specials/sire/spawn3.ogg",
	"enemies/specials/sire/spawn4.ogg",
	"enemies/specials/sire/spawn5.ogg",
	"enemies/specials/sire/spawn6.ogg",
	"enemies/specials/sire/spawn7.ogg",
	"enemies/specials/sire/spawn8.ogg",
	"enemies/specials/sire/spawn9.ogg",
	"enemies/specials/sire/spawn10.ogg",
	"enemies/specials/sire/spawn11.ogg"
}


ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"run_unarmed",
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
		self:SetRunSpeed( math.random( 90, 350 ) )
		self.loco:SetDesiredSpeed( math.random( 90, 350 ))
	end
	self:SetCollisionBounds(Vector(-20,-20, 0), Vector(20, 20, 60))
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
	
	if e == "step" then
		self:EmitSound("nz_moo/zombies/footsteps/crawl/crawl_0"..math.random(0,3)..".mp3", 65, math.random(95,105))
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
				self.loco:SetDesiredSpeed(  math.random( 90, 350 ) )
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

if SERVER then
	function ENT:ResetMovementSequence()
			self:ResetSequence(self.MovementSequence)
			self.CurrentSeq = self.MovementSequence
		
		if self.UpdateSeq ~= self.CurrentSeq then -- Moo Mark 4/19/23: Finally got a system where the speed actively updates when the movement sequence set is changed.
			--print("update")
			self.UpdateSeq = self.CurrentSeq
			self.loco:SetDesiredSpeed(  math.random( 90, 350 ) )
		end
	end
	
	end
