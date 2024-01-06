AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "A god damn dinosaur"
ENT.Category = "Brainz"
ENT.Author = "Laby"

--If you dont like the model i used, lick my dinosaur sized balls
if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true
ENT.IsMooSpecial = true
ENT.AttackRange = 160
ENT.DamageRange = 162
ENT.AttackDamage = 35


ENT.Models = {
	{Model = "models/bosses/turok_dilophosaurus.mdl" , Skin = 0, Bodygroups = {0,0}},
}


local spawn = {"scream_backward"}

local ATKwalk = {
	{seq = "bite_stand"},
	{seq = "bite_walk"},
	{seq = "headbutt_stand"},
}

local ATKrun = {
	{seq = "bite_run"},
	{seq = "tailsmash"},
	{seq = "headbutt"},

}
ENT.BarricadeTearSequences = {
	--Leave this empty if you don't intend on having a special enemy use tear anims.
}

ENT.IdleSequence = "idle"

ENT.DeathSequences = {
	"death1", "death2"
}


local walksounds = {
	Sound("enemies/bosses/dildophossaurus/breath1.ogg"),
	Sound("enemies/bosses/dildophossaurus/breath2.ogg"),
	Sound("enemies/bosses/dildophossaurus/breath3.ogg"),
	Sound("enemies/bosses/dildophossaurus/breath4.ogg"),
	Sound("enemies/bosses/dildophossaurus/breath5.ogg"),
	Sound("enemies/bosses/dildophossaurus/breath6.ogg"),
	Sound("enemies/bosses/dildophossaurus/hiss1.ogg"),
	Sound("enemies/bosses/dildophossaurus/hiss2.ogg"),
	Sound("enemies/bosses/dildophossaurus/hiss3.ogg"),
	Sound("enemies/bosses/dildophossaurus/react1.ogg"),
	Sound("enemies/bosses/dildophossaurus/react2.ogg"),
	Sound("enemies/bosses/dildophossaurus/react3.ogg"),
	Sound("enemies/bosses/dildophossaurus/react4.ogg"),
	Sound("enemies/bosses/dildophossaurus/react5.ogg"),
	Sound("enemies/bosses/dildophossaurus/react6.ogg"),
	Sound("enemies/bosses/dildophossaurus/react7.ogg"),
	Sound("enemies/bosses/dildophossaurus/react8.ogg"),
	Sound("enemies/bosses/dildophossaurus/react9.ogg"),
	Sound("enemies/bosses/dildophossaurus/react10.ogg"),
	Sound("enemies/bosses/dildophossaurus/react11.ogg"),
	Sound("enemies/bosses/dildophossaurus/react12.ogg"),

}

ENT.DeathSounds = {
	"enemies/bosses/dildophossaurus/pain4.ogg"
}

ENT.AppearSounds = {
	"enemies/bosses/dildophossaurus/roar_short5.ogg"
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
		{Threshold = 175, Sequences = {
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
		local speeds = nzRound:GetZombieCoDSpeeds()
		if speeds then
		self.loco:SetDesiredSpeed( nzMisc.WeightedRandom(speeds) + math.random(50,75) )
		else
		self.loco:SetDesiredSpeed( 200)
		end
	end
	self:SetCollisionBounds(Vector(-35,-35, 0), Vector(35, 35, 100))
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
	self:DoSpecialAnimation("angryroar")
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
				self:DoSpecialAnimation("angryroar")
				ParticleEffect("bo3_astronaut_pulse",self:LocalToWorld(Vector(0,0,60)),Angle(0,0,0),nil)
		for k,v in pairs(ents.FindInSphere(self:GetPos(), 310)) do
			if IsValid(v) and v:IsPlayer() and !self:IsAttackEntBlocked(v) then
				v:NZSonicBlind(1)
			end
		end
		end
			self.NextAction = CurTime() + 13
	end
end



function ENT:HandleAnimEvent(a,b,c,d,e)
	
	if e == "event_emit Bite" then
	self:DoAttackDamage()
	end
	if e == "event_emit BiteWalk" then
	self:DoAttackDamage()
	end
	if e == "event_emit HeadSwing" then
	self:DoAttackDamage()
	end
	if e == "event_emit Swing" then
	self:DoAttackDamage()
	end
	if e == "event_emit Swing" then
	self:EmitSound("enemies/specials/turok raptor/attack"..math.random(1,7)..".ogg")
	self:DoAttackDamage()
	end
	if e == "event_emit FootLight"  then
		self:EmitSound("enemies/bosses/dildophossaurus/foot"..math.random(1,4)..".ogg")
	    util.ScreenShake(self:GetPos(),4,1000,0.5,2048)
	end
	if e == "event_emit Foot"  then
		self:EmitSound("enemies/bosses/dildophossaurus/foot"..math.random(1,4)..".ogg")
	    util.ScreenShake(self:GetPos(),6,1000,0.7,2048)
	end
	
	if e == "event_emit Roar" then
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
