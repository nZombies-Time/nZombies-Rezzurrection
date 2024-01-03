AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Clever Girl"
ENT.Category = "Brainz"
ENT.Author = "Laby"

--If you dont like the model i used, lick my dinosaur sized balls
if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true
ENT.IsMooSpecial = true
ENT.AttackRange = 125
ENT.DamageRange = 130
ENT.AttackDamage = 15

ENT.Models = {
	{Model = "models/specials/turok_raptor.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model = "models/specials/turok_raptor.mdl", Skin = 1, Bodygroups = {0,0}},
}

local spawn = {"scream_backward"}

local ATKwalk = {
	{seq = "attack"},
	{seq = "attack3"}
}

local ATKrun = {
	{seq = "attack2"}

}
ENT.BarricadeTearSequences = {
	--Leave this empty if you don't intend on having a special enemy use tear anims.
}

ENT.IdleSequence = "idle"

ENT.DeathSequences = {
	"stunnedidle"
}


local walksounds = {
	Sound("enemies/specials/turok raptor/breath.ogg"),
	Sound("enemies/specials/turok raptor/breath2.ogg"),
	Sound("enemies/specials/turok raptor/breath3.ogg"),
	Sound("enemies/specials/turok raptor/breath4.ogg"),
	Sound("enemies/specials/turok raptor/breath5.ogg"),
	Sound("enemies/specials/turok raptor/breath6.ogg"),
	Sound("enemies/specials/turok raptor/breath7.ogg"),
	Sound("enemies/specials/turok raptor/breath8.ogg"),
	Sound("enemies/specials/turok raptor/breath9.ogg"),
	Sound("enemies/specials/turok raptor/breath10.ogg"),
	Sound("enemies/specials/turok raptor/breath11.ogg"),
	Sound("enemies/specials/turok raptor/breath12.ogg"),
	Sound("enemies/specials/turok raptor/breath13.ogg")

}

ENT.DeathSounds = {
	"enemies/specials/turok raptor/death1.ogg",
	"enemies/specials/turok raptor/death2.ogg",
	"enemies/specials/turok raptor/death3.ogg",
	"enemies/specials/turok raptor/death4.ogg",
	"enemies/specials/turok raptor/death5.ogg",
	"enemies/specials/turok raptor/death6.ogg",
	"enemies/specials/turok raptor/death7.ogg",
	"enemies/specials/turok raptor/death8.ogg",
	"enemies/specials/turok raptor/death9.ogg",
	"enemies/specials/turok raptor/death10.ogg",
	"enemies/specials/turok raptor/death11.ogg",
	"enemies/specials/turok raptor/death12.ogg",
}

ENT.AppearSounds = {
	"enemies/specials/turok raptor/scream1.ogg",
	"enemies/specials/turok raptor/scream2.ogg",
	"enemies/specials/turok raptor/scream3.ogg",
	"enemies/specials/turok raptor/scream4.ogg",
	"enemies/specials/turok raptor/scream5.ogg"
}

--CHECK RUN ANIMATION 
ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"walk",
			},
			AttackSequences = {ATKwalk},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
		{Threshold = 200, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"run",
			},
			AttackSequences = {ATKrun},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}}
}

function ENT:StatsInitialize()
	if SERVER then
		self.Sprinting = false
		--local speeds = nzRound:GetZombieCoDSpeeds()
		--self.loco:SetDesiredSpeed( nzMisc.WeightedRandom(speeds) + math.random(30,50) )
		self.loco:SetDesiredSpeed( 200)
	end
	self:SetCollisionBounds(Vector(-20,-20, 0), Vector(20, 20, 40))
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
	self:DoSpecialAnimation("scream_backward")
	self:EmitSound(self.AppearSounds[math.random(#self.AppearSounds)], 511, math.random(85, 105), 1, 2)
	self.NextAction = CurTime() + 5
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
	local target = self:GetTarget()
	if CurTime() < self.NextAction then return end
	if !self:IsAttackBlocked() then
			if target:IsPlayer() then
				--get that nigga
				self:DoSpecialAnimation("scream_forward")
				if math.random(1,100) > 85 then
				for k,v in pairs(ents.GetAll()) do
					if v:GetClass() == "nz_zombie_special_raptor" then
					v:SetTarget(target)
					end
				
				--Each raptor can only transfer priority once
			end
			end
			self.NextAction = CurTime() + 999
	end
end
end



function ENT:HandleAnimEvent(a,b,c,d,e)
	
	if e == "event_emit Bite" then
	self:EmitSound("enemies/specials/turok raptor/biteattack"..math.random(1,3)..".ogg")
	self:DoAttackDamage()
	end
	if e == "event_emit Swing" then
	self:EmitSound("enemies/specials/turok raptor/attack"..math.random(1,7)..".ogg")
	self:DoAttackDamage()
	end
	if e == "event_emit Foot" then
		self:EmitSound("enemies/specials/turok raptor/foot"..math.random(1,7)..".ogg")
	end
	
	if e == "event_emit Scream" then
		self:EmitSound(self.AppearSounds[math.random(#self.AppearSounds)], 511, math.random(85, 105), 1, 2)
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
				self.loco:SetDesiredSpeed(  300 )
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
			self.UpdateSeq = self.CurrentSeq
			--DO YOU HAVE ANY IDEA HOW FUCKING FAST I AM?
			--local speeds = nzRound:GetZombieCoDSpeeds()
			--self.loco:SetDesiredSpeed( nzMisc.WeightedRandom(speeds) + math.random(30,50) )
			self.loco:SetDesiredSpeed( 200)
		end
	end
	
	end
