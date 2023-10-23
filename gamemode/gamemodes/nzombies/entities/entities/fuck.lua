AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Divider Necromorph"
ENT.Category = "Brainz"
ENT.Author = "Laby and GhostlyMoo"

--You've heard of The Thing, but have you heard of the Thang

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true
ENT.IsMooSpecial = true

ENT.DamageRange = 140
ENT.AttackDamage = 70
ENT.AttackRange = 150

ENT.TraversalCheckRange = 80



ENT.Models = {
	{Model = "models/bosses/divider_necro.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"idle"}

ENT.DeathSequences = {
	"death"
}

ENT.BarricadeTearSequences = {
	--Leave this empty if you don't intend on having a special enemy use tear anims.
}

local AttackSequences = {
	{seq = "attack", dmgtimes = {0.5}},
	{seq = "attack2", dmgtimes = {0.5, 1.0}}
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
	}},
	{Threshold = 70, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"run"
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
		self:SetRunSpeed( 20 )
		self.loco:SetDesiredSpeed( 20 )
		self:SetCollisionBounds(Vector(-12,-12, 0), Vector(12, 12, 80))
	end
end

function ENT:OnSpawn()

	self:SolidMaskDuringEvent(MASK_SOLID_BRUSHONLY)
	self:SetNoDraw(false)
		ParticleEffect("bo3_panzer_landing",self:LocalToWorld(Vector(20+(1),20,0)),Angle(0,0,0),nil)
		
		util.ScreenShake(self:GetPos(),5,1000,1.2,2048)
	
		self:EmitSound("enemies/bosses/thrasher/tele_hand_up.ogg",511)
	self:SetSpecialAnimation(true)
	local seq = self:SelectSpawnSequence()
	if seq then
		self:PlaySequenceAndWait(seq)
		self:EmitSound("enemies/bosses/divider/awareness_howl_0"..math.random(6)..".ogg",511)
		self:SetSpecialAnimation(false)
		self:SetInvulnerable(false)
		self:CollideWhenPossible()
	end
end

function ENT:PerformDeath(dmgInfo)
		self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
		self:DoDeathAnimation(self.DeathSequences[math.random(#self.DeathSequences)])
end

function ENT:DoDeathAnimation(seq)
	self.BehaveThread = coroutine.create(function()
		self:PlaySequenceAndWait(seq)
		if IsValid(self) then
			ParticleEffect("bo3_margwa_death",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
		self:EmitSound("exploder/explode/brute_armour_slide_flesh_00.wav", 88, math.random(90,100))
		self:EmitSound("tubebeetle/explode/tubebeetle_pop_03.wav", 94, math.random(90,100))
		self:EmitSound("tubebeetle/explode/tubebeetle_pop_03.wav", 94, math.random(90,100))
		self:EmitSound("exploder/explode/brute_belly_puss_shared_01.wav", 88, math.random(90,100))
		self:EmitSound("exploder/explode/brute_puss_bomb_l_shared_00.wav", 88, math.random(90,100))
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
	end)
end

function ENT:PostTookDamage(dmginfo)
	self:SetRunSpeed( 70 )
			self.loco:SetDesiredSpeed( 70 )
			self:SpeedChanged()
end

function ENT:HandleAnimEvent(a,b,c,d,e)

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
			 self:SetRunSpeed( 30 )
			self.loco:SetDesiredSpeed( 30 )
			self:SpeedChanged()
			 end
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


function ENT:IsValidTarget( ent )
	if not ent then return false end
	return IsValid( ent ) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
end