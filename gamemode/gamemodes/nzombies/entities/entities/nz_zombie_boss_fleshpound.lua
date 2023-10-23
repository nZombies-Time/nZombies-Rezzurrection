AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Killing Floor Fleshpound"
ENT.Type = "nextbot"
ENT.Category = "Brainz"
ENT.Author = "Wavy"
ENT.Spawnable = true

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = false
ENT.MooSpecialZombie = false -- They're a Special Zombie, but is still close enough to a normal zombie to be able to do normal zombie things.
ENT.IsMooSpecial = true

ENT.AttackRange = 110
ENT.DamageRange = 110
ENT.AttackDamage = 80

local weaktype = {
	[DMG_BLAST] = true,
}

ENT.Models = {
	{Model = "models/wavy/wavy_enemies/fleshpound/fleshpound_kf1.mdl", Skin = 0, Bodygroups = {0,0}},
}

local util_tracehull = util.TraceHull
local spawn = {"nz_fleshpound_stun"}

ENT.IdleSequence = "nz_fleshpound_idle"

ENT.BarricadeTearSequences = {
	"nz_fleshpound_stand_attack"
}

local StandAttackSequences = {
	{seq = "nz_fleshpound_stand_attack"},
}

local AttackSequences = {
	{seq = "nz_fleshpound_walk_attack1"},
	{seq = "nz_fleshpound_walk_attack2"},
	{seq = "nz_fleshpound_walk_attack3"},
}

local RunAttackSequences = {
	{seq = "nz_fleshpound_run_attack1"},
	{seq = "nz_fleshpound_run_attack2"},
	{seq = "nz_fleshpound_run_attack3"},
}

local JumpSequences = {
	{seq = "nz_fleshpound_traverse"},
}

local walksounds = {
	Sound("wavy_zombie/fleshpound/voiceidle/idle1.wav"),
	Sound("wavy_zombie/fleshpound/voiceidle/idle2.wav"),
	Sound("wavy_zombie/fleshpound/voiceidle/idle3.wav"),
	Sound("wavy_zombie/fleshpound/voiceidle/idle4.wav"),
	Sound("wavy_zombie/fleshpound/voiceidle/idle5.wav"),
	Sound("wavy_zombie/fleshpound/voiceidle/idle6.wav"),
	Sound("wavy_zombie/fleshpound/voiceidle/idle7.wav"),
	Sound("wavy_zombie/fleshpound/voiceidle/idle8.wav"),
	Sound("wavy_zombie/fleshpound/voiceidle/idle9.wav"),
}

local runsounds = {
	Sound("wavy_zombie/fleshpound/voicechase/chase1.wav"),
	Sound("wavy_zombie/fleshpound/voicechase/chase2.wav"),
	Sound("wavy_zombie/fleshpound/voicechase/chase3.wav"),
	Sound("wavy_zombie/fleshpound/voicechase/chase4.wav"),
	Sound("wavy_zombie/fleshpound/voicechase/chase5.wav"),
	Sound("wavy_zombie/fleshpound/voicechase/chase6.wav"),
	Sound("wavy_zombie/fleshpound/voicechase/chase7.wav"),
}

-- This is a very large and messy looking table... But it gets the job done.
ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawnslow},
			MovementSequence = {
				"nz_fleshpound_walk",
			},
			SpawnSequence = {spawn},
			AttackSequences = {AttackSequences},
			StandAttackSequences = {StandAttackSequences},

			JumpSequences = {JumpSequences},

			PassiveSounds = {walksounds},
		}
	}},
	{Threshold = 71, Sequences = {
		{
			SpawnSequence = {spawnrun},
			MovementSequence = {
				"nz_fleshpound_run",
			},
			SpawnSequence = {spawn},
			AttackSequences = {RunAttackSequences},
			StandAttackSequences = {StandAttackSequences},

			JumpSequences = {JumpSequences},

			PassiveSounds = {runsounds},
		}
	}}
}

ENT.DeathSounds = {
	"wavy_zombie/fleshpound/voicedeath/death1.wav",
	"wavy_zombie/fleshpound/voicedeath/death2.wav",
	"wavy_zombie/fleshpound/voicedeath/death3.wav",
	"wavy_zombie/fleshpound/voicedeath/death4.wav",
	"wavy_zombie/fleshpound/voicedeath/death5.wav",
}

ENT.AttackSounds = {
	"wavy_zombie/fleshpound/voicemelee/attack1.wav",
	"wavy_zombie/fleshpound/voicemelee/attack2.wav",
	"wavy_zombie/fleshpound/voicemelee/attack3.wav",
	"wavy_zombie/fleshpound/voicemelee/attack4.wav",
	"wavy_zombie/fleshpound/voicemelee/attack5.wav",
}

ENT.CustomWalkFootstepsSounds = {
	"wavy_zombie/fleshpound/tile1.wav",
	"wavy_zombie/fleshpound/tile2.wav",
	"wavy_zombie/fleshpound/tile3.wav",
	"wavy_zombie/fleshpound/tile4.wav",
	"wavy_zombie/fleshpound/tile5.wav",
	"wavy_zombie/fleshpound/tile6.wav",
}

ENT.CustomRunFootstepsSounds = {
	"wavy_zombie/fleshpound/tile1.wav",
	"wavy_zombie/fleshpound/tile2.wav",
	"wavy_zombie/fleshpound/tile3.wav",
	"wavy_zombie/fleshpound/tile4.wav",
	"wavy_zombie/fleshpound/tile5.wav",
	"wavy_zombie/fleshpound/tile6.wav",
}

ENT.CustomAttackImpactSounds = {
	"wavy_zombie/fleshpound/stronghit1.wav",
	"wavy_zombie/fleshpound/stronghit2.wav",
	"wavy_zombie/fleshpound/stronghit3.wav",
	"wavy_zombie/fleshpound/stronghit4.wav",
	"wavy_zombie/fleshpound/stronghit5.wav",
	"wavy_zombie/fleshpound/stronghit6.wav",
}

ENT.BehindSoundDistance = 1 -- When the zombie is within 200 units of a player, play these sounds instead
ENT.BehindSounds = {
	Sound("nz_moo/zombies/vox/mute_00.wav"),
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
		self:SetRunSpeed(36)
		--self:SetCollisionBounds(Vector(-20,-20, 0), Vector(20, 20, 92))
		
		self.ManIsMad = false
		self.Malding = false
	end
end

function ENT:SpecialInit()
	if CLIENT then
	end
end

function ENT:OnSpawn()
	--self:SetModelScale(0.95,0.00001)
	local seq = self:SelectSpawnSequence()
	local _, dur = self:LookupSequence(seq)

	self:SolidMaskDuringEvent(MASK_SOLID_BRUSHONLY)
	self:SetInvulnerable(true)
	self:SetSpecialAnimation(true)
	local effectData = EffectData()
	effectData:SetOrigin( self:GetPos() + Vector(0, 0, 50)  )
	effectData:SetMagnitude( 1 )
	effectData:SetEntity(nil)
	util.Effect("panzer_spawn_tp", effectData)
	
	if seq then
		self:PlaySequenceAndWait(seq)
		self:SetSpecialAnimation(false)
		self:SetInvulnerable(false)
		self:CollideWhenPossible()
	end
end

function ENT:PerformDeath(dmginfo)
	self:BecomeRagdoll(dmginfo)
	self:EmitSound(self.DeathSounds[math.random(#self.DeathSounds)], 500, math.random(95, 105), 1, 2)
end

function ENT:IsValidTarget( ent )
	if not ent then return false end
	return IsValid(ent) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
end

function ENT:OnTakeDamage(dmginfo)
	local attacker = dmginfo:GetAttacker()
	
	if IsValid(attacker) and attacker:IsPlayer() and !self.ManIsMad and !self:GetSpecialAnimation() then
		if math.random(4) == 4 then
			self.ManIsMad = true
			self:PoundingTime()
		end
	end
	if !weaktype[dmginfo:GetDamageType()] then
		dmginfo:ScaleDamage(0.5)
	end
end

function ENT:PoundingTime()
	self:EmitSound("wavy_zombie/fleshpound/voicerage/rage"..math.random(1,4)..".wav", 500, 100, 1, 2)
	self:EmitSound("wavy_zombie/fleshpound/malletrage"..math.random(1,2)..".wav", 500)
	self:SetSkin(1)
	self:TempBehaveThread(function(self)
		self:SetSpecialAnimation(true)
		self.Malding = true
		self:PlaySequenceAndMove("nz_fleshpound_rage", 1)
		self.Malding = false
		self:SetSpecialAnimation(false)
		self:SetRunSpeed(71)
		self:SpeedChanged()
	end)
end

function ENT:HandleAnimEvent(a,b,c,d,e) -- Moo Mark 4/14/23: You don't know how sad I am that I didn't know about this sooner.
	if e == "step_right_small" or e == "step_left_small" then
		util.ScreenShake(self:GetPos(),8,8,0.2,400)
		if self.CustomWalkFootstepsSounds then
			self:EmitSound(self.CustomWalkFootstepsSounds[math.random(#self.CustomWalkFootstepsSounds)], 75)
		else
			self:EmitSound("CoDZ_Zombie.StepWalk")
		end
	end
	if e == "step_right_large" or e == "step_left_large" then
		util.ScreenShake(self:GetPos(),8,8,0.2,600)
		if self.CustomRunFootstepsSounds then
			self:EmitSound(self.CustomRunFootstepsSounds[math.random(#self.CustomRunFootstepsSounds)], 75)
		else
			self:EmitSound("CoDZ_Zombie.StepRun")
		end
	end
	if e == "melee" then
		if self.AttackSounds then
			self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(95, 100), 1, 2)
		end
		self:DoAttackDamage()
	end
	if e == "death_ragdoll" then
		self:BecomeRagdoll(DamageInfo())
	end
	if e == "start_traverse" then
		--print("starttraverse")
		self.TraversalAnim = true
	end
	if e == "finish_traverse" then
		--print("finishtraverse")
		self.TraversalAnim = false
	end
	if e == "fleshpound_swing" then
		self:EmitSound("wavy_zombie/fleshpound/malletattack"..math.random(1,4)..".wav", 500)
	end
	if e == "fleshpound_spin" then
		self:EmitSound("wavy_zombie/fleshpound/malletrage"..math.random(1,2)..".wav", 500)
	end
end

--taken from Margwa, shrink collision box if stuck
if SERVER then
	-- Collide When Possible
	local collidedelay = 0.25
	local bloat = Vector(5,5,0)
	function ENT:Think()
		if (self:IsAllowedToMove() and !self:GetCrawler() and self.loco:GetVelocity():Length2D() >= 125 and self.SameSquare and !self:GetIsBusy() or self:IsAllowedToMove() and self:GetAttacking() ) then -- Moo Mark
        	self.loco:SetVelocity(self:GetForward() * self:GetRunSpeed())
        end
		if self.DoCollideWhenPossible then
			if not self.NextCollideCheck or self.NextCollideCheck < CurTime() then
				local mins,maxs = self:GetCollisionBounds()
				local tr = util_tracehull({
					start = self:GetPos(),
					endpos = self:GetPos(),
					filter = self,
					mask = MASK_NPCSOLID,
					mins = mins - bloat,
					maxs = maxs + bloat,
					ignoreworld = true
				})

				local b = tr.Entity
				if !IsValid(b) then 
					self:SetSolidMask(MASK_NPCSOLID)
					self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
					self.DoCollideWhenPossible = nil
					self.NextCollideCheck = nil
				else
					self.NextCollideCheck = CurTime() + collidedelay
				end
			end
		end


        if CurTime() > self.SpawnProtectionTime and self.SpawnProtection then
        	self.SpawnProtection = false
        	--print("Can be hurt")
        end
        
		self:StuckPrevention()
		self:ZombieStatusEffects()

		if not self.NextSound or self.NextSound < CurTime() then
			self:Sound()
		end

		self:DebugThink()
		self:OnThink()
	end
	function ENT:StuckPrevention()
		if !self:GetIsBusy() and !self:GetSpecialAnimation() and !self:GetAttacking() and self:GetLastPostionSave() + 0.25 < CurTime() then
			if self:GetPos():DistToSqr( self:GetStuckAt() ) < 75 then
				self:SetStuckCounter( self:GetStuckCounter() + 1)
				--print(self:GetStuckCounter())
			else
				self:SetStuckCounter( 0 )
				local tr1 = util_tracehull({
					start = self:GetPos(),
					endpos = self:GetPos(),
					maxs = Vector(20, 20, 92) + bloat,
					mins = Vector(-20,-20, 0) - bloat,
					filter = self
				})
				if !tr1.HitWorld then
					self:SetCollisionBounds(Vector(-20,-20, 0), Vector(20, 20, 92))
				end
			end

			if self:GetStuckCounter() >= 2 then

				self:SetCollisionBounds(Vector(-16,-16, 0), Vector(16, 16, 72))

				local tr = util_tracehull({
					start = self:GetPos(),
					endpos = self:GetPos(),
					maxs = self:OBBMaxs() + bloat,
					mins = self:OBBMins() - bloat,
					filter = self
				})
				if !tr.HitWorld then
				end
				if self:GetStuckCounter() > 25 then
					if self.NZBossType then
						local spawnpoints = {}
						for k,v in pairs(ents.FindByClass("nz_spawn_zombie_special")) do -- Find and add all valid spawnpoints that are opened and not blocked
							if (v.link == nil or nzDoors:IsLinkOpened( v.link )) and v:IsSuitable() then
								table.insert(spawnpoints, v)
							end
						end
						local selected = spawnpoints[math.random(#spawnpoints)] -- Pick a random one
						self:SetPos(selected:GetPos())
					else
						self:RespawnZombie()
					end
					self:SetStuckCounter( 0 )
				end
			end
			self:SetLastPostionSave( CurTime() )
			self:SetStuckAt( self:GetPos() )
		end
	end
end