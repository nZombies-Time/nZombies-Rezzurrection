AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Divider Necromorph"
ENT.Category = "Brainz"
ENT.Author = "Laby"

--You've heard of The Thing, but have you heard of the Thang

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true
ENT.IsMooSpecial = true

ENT.DamageRange = 120
ENT.AttackDamage = 35
ENT.AttackRange = 115

ENT.TraversalCheckRange = 80


ENT.Models = {
	{Model =  "models/bosses/divider_necro.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"attack"}


ENT.BarricadeTearSequences = {
	--Leave this empty if you don't intend on having a special enemy use tear anims.
}

local AttackSequences = {
	{seq = "attack"},
}

local JumpSequences = {
	--stink
}

local walksounds = {
	Sound("enemies/bosses/divider/awareness_howl_01.ogg"),
	Sound("enemies/bosses/divider/awareness_howl_02.ogg"),
	Sound("enemies/bosses/divider/awareness_howl_03.ogg"),
	Sound("enemies/bosses/divider/awareness_howl_04.ogg"),
	Sound("enemies/bosses/divider/awareness_howl_05.ogg"),
	Sound("enemies/bosses/divider/awareness_howl_06.ogg"),


}

ENT.AttackSounds = {
	"enemies/bosses/divider/awareness_howl_01.ogg",
	"enemies/bosses/divider/awareness_howl_02.ogg",
	"enemies/bosses/divider/awareness_howl_03.ogg",
	"enemies/bosses/divider/awareness_howl_04.ogg",
	"enemies/bosses/divider/awareness_howl_05.ogg",
	"enemies/bosses/divider/awareness_howl_06.ogg"
	
}

ENT.PainSounds = {
	"nz/zombies/death/nz_flesh_impact_1.wav",
	"nz/zombies/death/nz_flesh_impact_2.wav",
	"nz/zombies/death/nz_flesh_impact_3.wav",
	"nz/zombies/death/nz_flesh_impact_4.wav"
}

ENT.DeathSounds = {
	"enemies/bosses/divider/ssfx_cfs_divider_snarl_03.ogg"
}

ENT.IdleSequence = "idle"

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"walk"
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
		self:SetMooSpecial(true)
		self:SetRunSpeed( 55 )
		self.loco:SetDesiredSpeed( 55 )
		self:SetCollisionBounds(Vector(-18,-18, 0), Vector(18, 18, 70))
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
	self:EmitSound("enemies/bosses/divider/awareness_howl_0"..math.random(6)..".ogg",511)
		self:PlaySequenceAndWait(seq)
	
		self:SetSpecialAnimation(false)
		self:SetInvulnerable(false)
		self:CollideWhenPossible()
	end
end

function ENT:PerformDeath(dmgInfo)
		self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
		if IsValid(self) then
			ParticleEffect("bo3_margwa_death",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
		ParticleEffect("nbnz_gib_explosion",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
		self:PlaySound("enemies/bosses/gunker/death_gore"..math.random(1,2)..".ogg", 90, math.random(85, 105), 1, 2)
		self:EmitSound("enemies/bosses/divider/divider_merge_18.ogg", 94, math.random(90,100))
		self:EmitSound("enemies/bosses/divider/divider_merge_18.ogg", 94, math.random(90,100))
				ParticleEffect("divider_slash2",self:LocalToWorld(Vector(20,20,0)),Angle(0,0,0),nil)
				ParticleEffect("divider_slash3",self:LocalToWorld(Vector(20,20,0)),Angle(0,0,0),nil)
				ParticleEffect("baby_dead",self:LocalToWorld(Vector(20,20,0)),Angle(0,0,0),nil)
				self.Head = ents.Create("nz_zombie_boss_Divider_Head")
				self.Head:SetPos(self:GetPos() + self:GetRight()*0 + self:GetForward()*30)
				self.Head:Spawn()
				self.Foot1 = ents.Create("nz_zombie_boss_Divider_Foot")
				self.Foot1:SetPos(self:GetPos() + self:GetRight()*16 + self:GetForward()*-40)
				self.Foot1:Spawn()
				self.Foot2 = ents.Create("nz_zombie_boss_Divider_Foot")
				self.Foot2:SetPos(self:GetPos() + self:GetRight()*-16 + self:GetForward()*-40)
				self.Foot2:Spawn()
				self.Hand1 = ents.Create("nz_zombie_boss_Divider_Hand")
				self.Hand1:SetPos(self:GetPos() + self:GetRight()*26 + self:GetForward()*10 + self:GetUp()*14)
				self.Hand1:Spawn()
				self.Hand2 = ents.Create("nz_zombie_boss_Divider_Hand")
				self.Hand2:SetPos(self:GetPos() + self:GetRight()*-26 + self:GetForward()*10+ self:GetUp()*14)
				self.Hand2:Spawn()
			self:Remove()
		end
end



function ENT:HandleAnimEvent(a,b,c,d,e)
	if e == "melee" then
		self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2)
		self:DoAttackDamage()
	end
	if e == "divider_stepl" then
		self:EmitSound("enemies/bosses/divider/footstep/divider_body_footstep-0"..math.random(1,9)..".ogg",80,math.random(95,100))
	end
	if e == "divider_stepr" then
		self:EmitSound("enemies/bosses/divider/footstep/divider_body_footstep-0"..math.random(1,9)..".ogg",80,math.random(95,100))
		
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