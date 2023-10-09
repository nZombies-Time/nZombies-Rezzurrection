AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Chestburster"
ENT.Category = "Brainz"
ENT.Author = "Laby"

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true
ENT.IsMooSpecial = true
ENT.AttackDamage = 10
ENT.AttackRange = 75
ENT.DamageRange = 70

ENT.Models = {
	{Model = "models/specials/xeno_chestbursteranimated.mdl" , Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"idle"}

ENT.AttackSequences = {
	{seq = "idle"}
}


ENT.BarricadeTearSequences = {
	--Leave this empty if you don't intend on having a special enemy use tear anims.
}

ENT.IdleSequence = "idle"

ENT.DeathSequences = {
	"idle"
}

ENT.AttackSounds = {
	"npc/headcrab/attack1.wav",
	"npc/headcrab/attack2.wav",
	"npc/headcrab/attack3.wav"
}
	
local walksounds = {
	Sound("enemies/bosses/divider/component/footstep/divider_component_footstep-01.ogg"),
	Sound("enemies/bosses/divider/component/footstep/divider_component_footstep-02.ogg"),
	Sound("enemies/bosses/divider/component/footstep/divider_component_footstep-04.ogg"),
	Sound("enemies/bosses/divider/component/footstep/divider_component_footstep-07.ogg"),
	Sound("enemies/bosses/divider/component/footstep/divider_component_footstep-10.ogg"),
	Sound("enemies/bosses/divider/component/footstep/divider_component_footstep-08.ogg"),
	Sound("enemies/zombies/alien/vocals/aln_pain_small_7.ogg"),
	Sound("enemies/zombies/alien/vocals/aln_pain_small_8.ogg"),
	Sound("enemies/zombies/alien/vocals/aln_pain_small_9.ogg"),
	Sound("enemies/zombies/alien/vocals/aln_pain_small_10.ogg"),

}


ENT.DeathSounds = {
	"enemies/specials/spider/vox/death_01.ogg"
	
	
}

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"walk"
			},
			AttackSequences = {AttackSequences},
			PassiveSounds = {walksounds},
		},
	}},
}

function ENT:StatsInitialize()
	if SERVER then
		self:SetRunSpeed( 100 )
		self.loco:SetDesiredSpeed( 100 )
		self.NextAction = 0
		self.timerstarted = false
	end
	self:SetCollisionBounds(Vector(-22,-22, 0), Vector(22, 22, 30))
end

function ENT:OnSpawn()

		self:SolidMaskDuringEvent(MASK_PLAYERSOLID)


		self:SetSpecialAnimation(true)
		self:SetIsBusy(true)
		local seq = self:SelectSpawnSequence()
		self:EmitSound("enemies/zombies/alien/vocals/aln_pain_small_7.ogg",100)
		
		
		if seq then
			self:PlaySequenceAndMove(seq, {gravity = true})
			self:SetSpecialAnimation(false)
			self:SetIsBusy(false)
			self:CollideWhenPossible()
			self:SpawnXeno()
		end
	
end
function ENT:OnPathTimeOut()
self:FleeTarget(45)
end

function ENT:ChaseTarget( options )
self:FleeTarget(45)
end
function ENT:SpawnXeno()
	timer.Simple( 45, function() 
		if self:IsValid() then
		
	self:EmitSound("nz_moo/zombies/gibs/gib_0"..math.random(3)..".mp3",100)
		ParticleEffect("nbnz_gib_explosion",self:GetPos(),Angle(0,0,0),nil)
		if math.random(0,3) > 1 then
		self.child = ents.Create("nz_zombie_special_xeno_runner")
		elseif math.random(0,3) > 1 then
		self.child = ents.Create("nz_zombie_special_xeno_spitter")
		else
		self.child = ents.Create("nz_zombie_special_xeno_brute")
		end
				self.child:SetPos(self:GetPos())
				self.child:Spawn()	
				self:Remove();
				end
				end  )
	
end

function ENT:OnContact( ent )
	if  ent:IsWorld() then
	 self:GetPriorityTarget()
	end
end
	
function ENT:PerformDeath(dmgInfo)
		self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
		if IsValid(self) then
				ParticleEffect("ins_blood_impact_headshot",self:GetPos(),self:GetAngles(),self)
				self:Remove()
		end
	
end



function ENT:IsValidTarget( ent )
	if not ent then return false end
	return IsValid(ent) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
end

if SERVER then
	function ENT:ResetMovementSequence()
			self:ResetSequence(self.MovementSequence)
			self.CurrentSeq = self.MovementSequence
		
		if self.UpdateSeq ~= self.CurrentSeq then -- Moo Mark 4/19/23: Finally got a system where the speed actively updates when the movement sequence set is changed.
			--print("update")
			self.UpdateSeq = self.CurrentSeq
			self.loco:SetDesiredSpeed( 300)
		end
	end
	
	end