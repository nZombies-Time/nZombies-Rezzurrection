AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "SHE....RYYYYYY"
ENT.Category = "Brainz"
ENT.Author = "Laby and GhostlyMoo"

--They call me a grower not a shower

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true
ENT.IsMooSpecial = true

ENT.AttackDamage = 60
ENT.AttackRange = 110
ENT.DamageRange = 105
ENT.TraversalCheckRange = 80

ENT.Models = {
	{Model = "models/bosses/g1.mdl" , Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"slow_flinch_head"}

ENT.DeathSequences = {
	"death"
}

local AttackSequences = {
	{seq = "att1"},
	{seq = "att2"},
	{seq = "att3"},
}

local MadAttackSequences = {
	{seq = "att11"},
	{seq = "att12"}
}

ENT.BarricadeTearSequences = {
	--Leave this empty if you don't intend on having a special enemy use tear anims.
}


if taunt ==2 then
self:EmitSound("enemies/bosses/re2/em7000/vo/it_hurts"..math.random(4)..".ogg",400)
end



local walksounds = {
	Sound("enemies/bosses/re2/em7000/vo/idle1.ogg"),
	Sound("enemies/bosses/re2/em7000/vo/idle2.ogg"),
	Sound("enemies/bosses/re2/em7000/vo/idle3.ogg"),
	Sound("enemies/bosses/re2/em7000/vo/idle4.ogg"),
	Sound("enemies/bosses/re2/em7000/vo/idle5.ogg"),
	Sound("enemies/bosses/re2/em7000/vo/idle6.ogg"),
	Sound("enemies/bosses/re2/em7000/vo/idle7.ogg"),
	Sound("enemies/bosses/re2/em7000/vo/idle8.ogg"),
	Sound("enemies/bosses/re2/em7000/vo/idle9.ogg"),

}

local madsounds = {
	Sound("enemies/bosses/re2/em7000/idle1.ogg"),
	Sound("enemies/bosses/re2/em7000/idle2.ogg"),
	Sound("enemies/bosses/re2/em7000/idle3.ogg"),
	Sound("enemies/bosses/re2/em7000/idle4.ogg"),
	Sound("enemies/bosses/re2/em7000/idle5.ogg"),
	Sound("enemies/bosses/re2/em7000/idle6.ogg"),
	Sound("enemies/bosses/re2/em7000/yell1.ogg"),
	Sound("enemies/bosses/re2/em7000/yell2.ogg"),
	Sound("enemies/bosses/re2/em7000/yell3.ogg"),
	Sound("enemies/bosses/re2/em7000/yell4.ogg"),
	Sound("enemies/bosses/re2/em7000/yell5.ogg"),
	Sound("enemies/bosses/re2/em7000/yell6.ogg"),
}

ENT.AttackSounds = {
	"enemies/bosses/re2/em7000/vo/mutate7.ogg",
	"enemies/bosses/re2/em7000/vo/mutate8.ogg",
	"enemies/bosses/re2/em7000/vo/idle4.ogg",
	"enemies/bosses/re2/em7000/vo/idle2.ogg",

}

ENT.AttackSoundsMAD = {
	"enemies/bosses/re2/em7000/attack1.ogg",
	"enemies/bosses/re2/em7000/attack2.ogg",
	"enemies/bosses/re2/em7000/attack3.ogg",
	"enemies/bosses/re2/em7000/attack4.ogg",
	"enemies/bosses/re2/em7000/attack5.ogg",
	"enemies/bosses/re2/em7000/attack6.ogg",
}

ENT.PainSounds = {
	"nz/zombies/death/nz_flesh_impact_1.wav",
	"nz/zombies/death/nz_flesh_impact_2.wav",
	"nz/zombies/death/nz_flesh_impact_3.wav",
	"nz/zombies/death/nz_flesh_impact_4.wav"
}

ENT.DeathSounds = {
	"enemies/bosses/re2/em7000/pain6.ogg"
}

ENT.IdleSequence = "idle"


ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"slow_walk"
			},
			AttackSequences = {AttackSequences},
			PassiveSounds = {walksounds},
		},
	}},
		{Threshold = 100, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"fast_walk",
				"fast_run"
			},
			AttackSequences = {MadAttackSequences},
			PassiveSounds = {madsounds},
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
			baseHealth = 500
		else
			self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
			self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
			baseHealth = nzRound:GetNumber() * data.scale + (data.health * count)
		end
		self.Mutated = false
		self:SetMooSpecial(true)
		self:SetRunSpeed( 50 )
		self.loco:SetDesiredSpeed( 50 )
		self:SetCollisionBounds(Vector(-16,-16, 0), Vector(16, 16, 70))
	end
end

function ENT:OnSpawn()

	self:SolidMaskDuringEvent(MASK_SOLID_BRUSHONLY)
	self:EmitSound("enemies/bosses/re2/em7000/hit_world4.ogg",511,100)
	ParticleEffect("bo3_panzer_landing",self:GetPos()+Vector(0,0,1),Angle(0,0,0),nil)
	self:SetInvulnerable(true)
	self:SetSpecialAnimation(true)
	local seq = self:SelectSpawnSequence()
	if seq then
		self:PlaySequenceAndWait(seq)
			self:EmitSound("enemies/bosses/re2/em7000/vo/idle1.ogg",511,100)
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


function ENT:bonescaleup(a)
	for i=0,9 do
		timer.Simple(0.1*i,function()
			self:ManipulateBoneScale(self:LookupBone("R_UpperArm_s_scale"), Vector(0.3+(0.05*i),0.5+(0.05*i),0.5+(0.1*i)))
			self:ManipulateBoneScale(self:LookupBone("R_UpperArm_scale"), Vector(0.5+(0.05*i),0.7+(0.05*i),0.7+(0.05*i)))
			self:ManipulateBoneScale(self:LookupBone("R_Forearm_scale"), Vector(0.5+(0.05*i),0.7+(0.05*i),0.7+(0.15*i)))
			self:ManipulateBoneScale(self:LookupBone("R_Palm_scale"), Vector(0.5+(0.05*i),0.7+(0.05*i),0.7+(0.15*i)))
		end)
	end
end

function ENT:OnInjured( dmgInfo )
	if not self.Mutated and self:Health()< (baseHealth/2) then
	self:EmitSound("enemies/bosses/re2/em7000/vo/pain_big"..math.random(6)..".ogg")
	self:SetInvulnerable(true)
	self.Mutated = true
			print("its time for me to beat your ass")
				self:EmitSound("enemies/bosses/re2/em7000/vo/mutate"..math.random(6)..".ogg",511)
				self:EmitSound("enemies/bosses/re2/em7000/mutate"..math.random(3)..".ogg",511)
				self:DoSpecialAnimation("slow_change")
				self:bonescaleup()
				self:EmitSound("enemies/bosses/re2/em7000/mutate_finish"..math.random(6)..".ogg",511)
				self.loco:SetDesiredSpeed(200)
					self:SetRunSpeed(200)
					self:UpdateMovementSequences()
					self:ResetMovementSequence()
					self:SetInvulnerable(false)
					
				end
			end

function ENT:HandleAnimEvent(a,b,c,d,e)
	if e == "attackhit" then
		self:EmitSound("enemies/bosses/re2/em7000/swing"..math.random(1,6)..".ogg",80,math.random(95,100))
		if self.Mutated then
		self:EmitSound(self.AttackSoundsMAD[math.random(#self.AttackSoundsMAD)], 100, math.random(85, 105), 1, 2)
		else
		self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2)
		end
		
		self:DoAttackDamage()
	end
	if e == "attackslam" then
		self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2)
		self:EmitSound("enemies/bosses/re2/em7000/hit_world"..math.random(1,6)..".ogg",80,math.random(95,100))
		self:DoAttackDamage()
	end
	if e == "step" then
		self:EmitSound("enemies/bosses/re2/em7000/step"..math.random(1,6)..".ogg",80,math.random(95,100))
	end
		if e == "steprun" then
		self:EmitSound("enemies/bosses/re2/em7000/step_run"..math.random(1,6)..".ogg",80,math.random(95,100))
	end
end





-- A standard attack you can use it or create something fancy yourself

function ENT:IsValidTarget( ent )
	if not ent then return false end
	return IsValid( ent ) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL
end

	