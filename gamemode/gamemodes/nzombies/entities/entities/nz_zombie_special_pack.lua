AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Murder Babies"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo"

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true
ENT.IsMooSpecial = true
ENT.AttackRange = 75
ENT.DamageRange = 80
ENT.AttackDamage = 25

ENT.Models = {
	{Model = "models/specials/pack.mdl" , Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"idle"}

local AttackSequences = {
	{seq = "attack2"}
}


ENT.BarricadeTearSequences = {
	--Leave this empty if you don't intend on having a special enemy use tear anims.
}

ENT.IdleSequence = "idle"



ENT.AttackSounds = {
	"enemies/specials/pack/attack/pack_attack_00.ogg",
	"enemies/specials/pack/attack/pack_attack_01.ogg",
	"enemies/specials/pack/attack/pack_attack_02.ogg",
	"enemies/specials/pack/attack/pack_attack_03.ogg",
	"enemies/specials/pack/attack/pack_attack_04.ogg",
	"enemies/specials/pack/attack/pack_attack_05.ogg",
	"enemies/specials/pack/attack/pack_attack_06.ogg",
	"enemies/specials/pack/attack/pack_attack_07.ogg"
}
	
local walksounds = {
	Sound("enemies/specials/pack/alert/pack_boy_52.ogg"),
	Sound("enemies/specials/pack/alert/pack_boy_51.ogg"),
	Sound("enemies/specials/pack/alert/pack_boy_50.ogg"),
	Sound("enemies/specials/pack/alert/pack_boy_49.ogg"),
	Sound("enemies/specials/pack/alert/pack_boy_48.ogg"),
	Sound("enemies/specials/pack/alert/pack_boy_47.ogg"),
	Sound("enemies/specials/pack/alert/pack_boy_46.ogg"),
	Sound("enemies/specials/pack/alert/pack_boy_45.ogg"),
	Sound("enemies/specials/pack/idle/pack_boy_31.ogg"),
	Sound("enemies/specials/pack/idle/pack_boy_32.ogg"),
	Sound("enemies/specials/pack/idle/pack_boy_33.ogg"),
	Sound("enemies/specials/pack/idle/pack_boy_34.ogg"),
	Sound("enemies/specials/pack/idle/pack_boy_35.ogg"),
	Sound("enemies/specials/pack/idle/pack_boy_36.ogg"),
	Sound("enemies/specials/pack/idle/pack_boy_37.ogg"),
	Sound("enemies/specials/pack/idle/pack_boy_38.ogg"),
	Sound("enemies/specials/pack/idle/pack_boy_39.ogg")

}

ENT.DeathSounds = {
	"enemies/specials/pack/dead/pack_boy_20.ogg",
	"enemies/specials/pack/dead/pack_boy_21.ogg",
	"enemies/specials/pack/dead/pack_boy_22.ogg",
	"enemies/specials/pack/dead/pack_boy_23.ogg"
}

ENT.AppearSounds = {
	"enemies/specials/pack/alert/pack_boy_52.ogg",
	"enemies/specials/pack/alert/pack_boy_51.ogg",
	"enemies/specials/pack/alert/pack_boy_50.ogg",
	"enemies/specials/pack/alert/pack_boy_49.ogg",
	"enemies/specials/pack/alert/pack_boy_48.ogg",
	"enemies/specials/pack/alert/pack_boy_47.ogg",
	"enemies/specials/pack/alert/pack_boy_46.ogg",
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
	}},
}

function ENT:StatsInitialize()
	if SERVER then
		self.Sprinting = false
		self:SetRunSpeed( 250 )
		self.loco:SetDesiredSpeed( 250 )
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
				self:Remove()
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


function ENT:IsValidTarget( ent )
	if not ent then return false end
	return IsValid( ent ) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
end