AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Hunter Beta"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo"

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true
ENT.IsMooSpecial = true
ENT.AttackRange = 100
ENT.DamageRange = 100
ENT.AttackDamage = 40

ENT.Models = {
	{Model = "models/specials/hunterb.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"getup_f"}

local AttackSequences = {
	{seq = "att1", dmgtimes = {0.5}},
	{seq = "att2", dmgtimes = {0.5}},
}

local AttackSequencesMAD = {
	{seq = "att4_neckhunt", dmgtimes = {0.9}},
}

local JumpSequences = {
	{seq = ACT_JUMP, speed = 100},
}


ENT.BarricadeTearSequences = {
	--Leave this empty if you don't intend on having a special enemy use tear anims.
}

ENT.IdleSequence = "idle"

ENT.DeathSequences = {
	"death",
	"death"
}

ENT.ElectrocutionSequences = {
	"elec2",
}

ENT.AttackSounds = {
	"enemies/specials/hunter/atk1.ogg",
	"enemies/specials/hunter/atk2.ogg",
	"enemies/specials/hunter/atk3.ogg",
	"enemies/specials/hunter/atk4.ogg",
}

local walksounds = {
	Sound("enemies/specials/hunter/idle1.ogg"),
	Sound("enemies/specials/hunter/idle2.ogg"),
	Sound("enemies/specials/hunter/idle3.ogg")
}



ENT.DeathSounds = {
	"enemies/specials/hunter/death1.ogg",
	"enemies/specials/hunter/death2.ogg",
	"enemies/specials/hunter/death3.ogg",
	"enemies/specials/hunter/death4.ogg",
	"enemies/specials/hunter/death5.ogg",
	"enemies/specials/hunter/death6.ogg",
}

ENT.AppearSounds = {
	"enemies/specials/hunter/spawn1.ogg",
	"enemies/specials/hunter/atk2.ogg",
	"enemies/specials/hunter/atk3.ogg",
	"enemies/specials/hunter/atk4.ogg",
}

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"walk_all",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 79, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"run",
			},
			AttackSequences = {AttackSequencesMAD},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}}
}

function ENT:StatsInitialize()
	if SERVER then
		self.Sprinting = false
		self:SetRunSpeed( 30 )
		self.loco:SetDesiredSpeed( 30 )
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

function ENT:PerformDeath(dmginfo)
	local damagetype = dmginfo:GetDamageType()
	if damagetype == DMG_MISSILEDEFENSE or damagetype == DMG_ENERGYBEAM then
		self:BecomeRagdoll(dmginfo) -- Only Thundergun and Wavegun Ragdolls constantly.
	end
	if damagetype == DMG_REMOVENORAGDOLL then
		self:Remove(dmginfo)
	end
	if self.DeathSounds then
	timer.Simple(5.5, function()
	self:Remove(dmgInfo)
	end)
				self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
				self:DoDeathAnimation(self.DeathSequences[math.random(#self.DeathSequences)])
				--self:Remove(dmgInfo)
	end
	
	
end




function ENT:OnPathTimeOut()
	local distToTarget = self:GetPos():Distance(self:GetTargetPosition())
	if IsValid(self:GetTarget()) then
	local getthatassbackhere = math.random(3)
		if not self.Sprinting and distToTarget < 750 and getthatassbackhere < 2 then
			self.Sprinting = true
			self.AttackRange = 125
			self.DamageRange = 150
			self.AttackDamage = 60
			self:SetRunSpeed( 80 )
			self.loco:SetDesiredSpeed( 80 )
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
		self:EmitSound("enemies/specials/hunter/step"..math.random(1,4)..".ogg",80,math.random(95,100))
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
			 if self.Sprinting then
			 self.Sprinting = false
			 self.AttackRange = 110
			 self.AttackDamage = 40
			self.DamageRange = 110
			 self:SetRunSpeed( 35 )
			self.loco:SetDesiredSpeed( 35 )
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

end

function ENT:IsValidTarget( ent )
	if not ent then return false end
	return IsValid( ent ) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
end