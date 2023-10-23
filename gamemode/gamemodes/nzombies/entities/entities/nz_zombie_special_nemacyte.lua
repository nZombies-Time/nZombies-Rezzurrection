AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Nemacyte"
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
	{Model = "models/specials/locust_nemaslug.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"NS_emerge"}

local AttackSequences = {
	{seq = "NS_AttackA"},
	{seq = "NS_AttackB"}
}


ENT.BarricadeTearSequences = {
	--Leave this empty if you don't intend on having a special enemy use tear anims.
}

ENT.IdleSequence = "NS_Idle", "NS_IdleB"

ENT.DeathSequences = {
	"reference"
}

ENT.AttackSounds = {
	"enemies/specials/nemacyte/atk1.ogg",
	"enemies/specials/nemacyte/atk2.ogg",
	"enemies/specials/nemacyte/atk3.ogg"
	
}

local walksounds = {
	Sound("enemies/specials/nemacyte/ambi1.ogg"),
	Sound("enemies/specials/nemacyte/ambi2.ogg"),
	Sound("enemies/specials/nemacyte/ambi3.ogg"),
	Sound("enemies/specials/nemacyte/ambi4.ogg"),
	Sound("enemies/specials/nemacyte/ambi5.ogg"),
	Sound("enemies/specials/nemacyte/ambi6.ogg"),
	Sound("enemies/specials/nemacyte/ambi7.ogg")
}


ENT.DeathSounds = {
	"enemies/specials/nemacyte/death1.ogg",
	"enemies/specials/nemacyte/death2.ogg",
	"enemies/specials/nemacyte/death3.ogg",
	"enemies/specials/nemacyte/death4.ogg",
	"enemies/specials/nemacyte/death5.ogg",
	"enemies/specials/nemacyte/death6.ogg",
	"enemies/specials/nemacyte/death7.ogg",
	"enemies/specials/nemacyte/death8.ogg"
	
	
}

ENT.AppearSounds = {
	"enemies/specials/nemacyte/spawn1.ogg",
	"enemies/specials/nemacyte/spawn2.ogg",
	"enemies/specials/nemacyte/spawn3.ogg",
	"enemies/specials/nemacyte/spawn4.ogg"
}

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"NS_RunFwd",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
}

function ENT:StatsInitialize()
	if SERVER then
		self:SetRunSpeed( 200 )
		self.loco:SetDesiredSpeed( 200 )
		self.racist = false
		self.eating = false
	end
	self:SetCollisionBounds(Vector(-13,-13, 0), Vector(13, 13, 45))
end

function ENT:OnSpawn()

	local nav = navmesh.GetNavArea(self:GetPos(), 50)
	self:EmitSound("nz_moo/zombies/vox/_quad/spawn/spawn_0"..math.random(3)..".mp3", 511, math.random(95, 105), 1, 2)

		local SpawnMatSound = {
			[MAT_DIRT] = "nz_moo/zombies/spawn/dirt/pfx_zm_spawn_dirt_0"..math.random(0,1)..".mp3",
			[MAT_SNOW] = "nz_moo/zombies/spawn/snow/pfx_zm_spawn_snow_0"..math.random(0,1)..".mp3",
			[MAT_SLOSH] = "nz_moo/zombies/spawn/mud/pfx_zm_spawn_mud_00.mp3",
			[0] = "nz_moo/zombies/spawn/default/pfx_zm_spawn_default_00.mp3",
		}
		SpawnMatSound[MAT_GRASS] = SpawnMatSound[MAT_DIRT]
		SpawnMatSound[MAT_SAND] = SpawnMatSound[MAT_DIRT]

		local norm = (self:GetPos()):GetNormalized()
		local tr = util.QuickTrace(self:GetPos(), norm*10, self)

		self:SolidMaskDuringEvent(MASK_PLAYERSOLID)

		if tr.Hit then
			local finalsound = SpawnMatSound[tr.MatType] or SpawnMatSound[0]
			self:EmitSound(finalsound)
		end

		ParticleEffect("bo3_zombie_spawn",self:GetPos()+Vector(0,0,1),self:GetAngles(),self)
		self:EmitSound("nz_moo/zombies/spawn/_generic/dirt/dirt_0"..math.random(0,2)..".mp3",100,math.random(95,105))

		self:SetSpecialAnimation(true)
		self:SetIsBusy(true)
		local seq = self:SelectSpawnSequence()

		if seq then
			self:PlaySequenceAndMove(seq, {gravity = true})
			self:SetSpecialAnimation(false)
			self:SetIsBusy(false)
			self.racist = false
			self.eating = false
			self:CollideWhenPossible()
		end
	
end

function ENT:HandleAnimEvent(a,b,c,d,e)

	if e == "munch" then
	local succ = self:GetTarget():GetPos()
		self:EmitSound("enemies/specials/nemacyte/bite"..math.random(1,2)..".ogg",80,math.random(95,100))
		ParticleEffect("ins_blood_dismember_limb",succ+Vector (0,0,25),Angle(0,0,0),nil)
		ParticleEffect("ins_blood_impact_headshot",succ+Vector (0,0,30),Angle(0,0,0),nil)
		--ParticleEffectAttach("ins_blood_impact_headshot", 4, self, 0)
		self:EmitSound("nz_moo/zombies/gibs/gib_0"..math.random(3)..".mp3",100)
	end
	if e == "melee" then
				self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2)
		self:DoAttackDamage()
	end

end

function ENT:PerformDeath(dmgInfo)
		self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
		if IsValid(self) then
				ParticleEffect("baby_dead",self:GetPos(),self:GetAngles(),self)
				self:Remove()
		end
	
end


function ENT:OnPathTimeOut()

	for k,v in pairs(player.GetAll()) do
			
				-- THERE IS AN ASS RIPE FOR THE FEASTING
				for k,v in pairs(player.GetAll()) do
					if v:GetNotDowned() then
					else
					print("I'm going to eat your ass")
						self:SetTarget(v)
						target = self:GetTarget()
						self.Target = target
						self:ResetMovementSequence()
						self.racist = true
						self:MoveToPos(self:GetTarget():GetPos())
						--this is so fuckign bad but curse you c call boundary you piece of fucking ass
						self:PlaySequenceAndWait("NS_Munch", 1, self.FaceEnemy)
						self:PlaySequenceAndWait("NS_Munch", 1, self.FaceEnemy)
						self:PlaySequenceAndWait("NS_Munch", 1, self.FaceEnemy)
						self:PlaySequenceAndWait("NS_Munch", 1, self.FaceEnemy)
						self:PlaySequenceAndWait("NS_Munch", 1, self.FaceEnemy)
						self:PlaySequenceAndWait("NS_Munch", 1, self.FaceEnemy)
						if self:Alive() and self:GetTarget():Alive()  then 
		self.racist = false
		self.eating  = false
		self:GetTarget():Kill()
		self:SetIsBusy(false)
		self:Retarget()
		self:SetSpecialAnimation(false)
		self:SetBlockAttack(false)
		self:ResetMovementSequence()
		end
					end
				end
end
end


function ENT:OnTargetInAttackRange()
		if !self:GetBlockAttack() then
			self:Attack()
		else
			self:TimeOut(2)
		end
	end
	
	

--function ENT:EatAss()

--end
	
	
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

if SERVER then
	function ENT:ResetMovementSequence()
			self:ResetSequence(self.MovementSequence)
			self.CurrentSeq = self.MovementSequence
		
		if self.UpdateSeq ~= self.CurrentSeq then -- Moo Mark 4/19/23: Finally got a system where the speed actively updates when the movement sequence set is changed.
			--print("update")
			self.UpdateSeq = self.CurrentSeq
			--self.loco:SetDesiredSpeed(  math.random( 90, 350 ) )
		end
	end
	
	end