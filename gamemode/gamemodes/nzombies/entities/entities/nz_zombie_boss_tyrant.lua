AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Mr. Sex"
ENT.Category = "Brainz"
ENT.Author = "Wavy"

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = false
ENT.MooSpecialZombie = false -- They're a Special Zombie, but is still close enough to a normal zombie to be able to do normal zombie things.
ENT.IsMooSpecial = true

ENT.AttackDamage = 75
ENT.AttackRange = 110
ENT.DamageRange = 110

ENT.Models = {
	{Model = "models/wavy/wavy_enemies/redc_tyrant/tyrantphase1_redc.mdl", Skin = 0, Bodygroups = {0,0}},
}

local util_tracehull = util.TraceHull
local spawn = {"nz_tyrant_spawn"}

local StandAttackSequences = {
	{seq = "nz_tyrant_attack_stand1"},
	{seq = "nz_tyrant_attack_stand2"},
}

local AttackSequences = {
	{seq = "nz_tyrant_attack_walk1"},
	{seq = "nz_tyrant_attack_walk2"},
}

local RunAttackSequences = {
	{seq = "nz_tyrant_attack_kick"},
	{seq = "nz_tyrant_attack_elbow"},
}

local JumpSequences = {
	{seq = "nz_tyrant_traverse"},
}

ENT.BarricadeTearSequences = {
	"nz_tyrant_attack_stand1",
	"nz_tyrant_attack_stand2",
}

local walksounds = {
	Sound("nz_moo/zombies/vox/mute_00.wav"),
}

ENT.IdleSequence = "nz_tyrant_idle"

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"nz_tyrant_walk_slow",
			},
			StandAttackSequences = {StandAttackSequences},
			AttackSequences = {StandAttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 36, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"nz_tyrant_walk",
			},
			StandAttackSequences = {StandAttackSequences},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 71, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"nz_tyrant_run",
			},
			StandAttackSequences = {StandAttackSequences},
			AttackSequences = {RunAttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}}
}

ENT.AttackSounds = {
	"enemies/bosses/nemesis/swing1.ogg",
	"enemies/bosses/nemesis/swing2.ogg",
	"enemies/bosses/nemesis/swing3.ogg",
}

ENT.CustomWalkFootstepsSounds = {
	"enemies/bosses/nemesis/step1.ogg",
	"enemies/bosses/nemesis/step2.ogg",
	"enemies/bosses/nemesis/step3.ogg",
	"enemies/bosses/nemesis/step4.ogg",
	"enemies/bosses/nemesis/step5.ogg",
	"enemies/bosses/nemesis/step6.ogg",
}

ENT.CustomRunFootstepsSounds = {
	"enemies/bosses/nemesis/step1.ogg",
	"enemies/bosses/nemesis/step2.ogg",
	"enemies/bosses/nemesis/step3.ogg",
	"enemies/bosses/nemesis/step4.ogg",
	"enemies/bosses/nemesis/step5.ogg",
	"enemies/bosses/nemesis/step6.ogg",
}

ENT.CustomAttackImpactSounds = {
	"npc/zombie/claw_strike1.wav",
	"npc/zombie/claw_strike2.wav",
	"npc/zombie/claw_strike3.wav",
}

function ENT:StatsInitialize()
	if SERVER then
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		if nzRound:InState( ROUND_CREATE ) then
			self:SetHealth(1000)
			self:SetMaxHealth(1000)
		else
			self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
			self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		end
		
		--self:SetCollisionBounds(Vector(-19,-19, 0), Vector(19, 19, 96))
		
		self:SetRunSpeed(36)
		
		self.MaldTimer = 0
		self.Malding = false
		beginmald = false
	end
end

function ENT:OnSpawn()
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

function ENT:PerformDeath(dmgInfo)
	for k,v in pairs(player.GetAllPlaying()) do
		if TFA.BO3GiveAchievement then
			if !v.Mr_Sex_Has_Fallen_Sir then
				TFA.BO3GiveAchievement("Mr. Sex Has Fallen", "vgui/mr_sex_has_fallen.png", v)
				v.Mr_Sex_Has_Fallen_Sir = true
			end
		end
	end
	ParticleEffect("grenade_explosion_01", self:WorldSpaceCenter(), angle_zero)
	ParticleEffect("bo3_annihilator_blood", self:WorldSpaceCenter(), angle_zero)
	self:EmitSound("TFA_BO3_GRENADE.Dist")
	self:EmitSound("TFA_BO3_GRENADE.Exp")
	self:EmitSound("TFA_BO3_GENERIC.Gib")
	self:EmitSound("TFA_BO3_ANNIHILATOR.Exp")
	self:Remove(dmginfo)
end

function ENT:PostAdditionalZombieStuff()
	if SERVER then
		if self.Malding and beginmald then
			beginmald = false
			self:SetRunSpeed(71)
			self:SpeedChanged()
			self.MaldTimer = CurTime() + 25
		end
		if CurTime() > self.MaldTimer and self.Malding then
			self.Malding = false
			self:SetRunSpeed(36)
			self:SpeedChanged()
		end
	end
end

function ENT:OnTakeDamage(dmginfo)
	local attacker = dmginfo:GetAttacker()	
	if IsValid(attacker) and attacker:IsPlayer() and !self.Malding then
		if math.random(10) == 10 then
			self.Malding = true
			beginmald = true
		end
	end
	dmginfo:ScaleDamage(0.1)
end

function ENT:HandleAnimEvent(a,b,c,d,e) -- Moo Mark 4/14/23: You don't know how sad I am that I didn't know about this sooner.
	if e == "step_right_small" or e == "step_left_small" then
		util.ScreenShake(self:GetPos(),8,8,0.2,400)
		if self.CustomWalkFootstepsSounds then
			self:EmitSound(self.CustomWalkFootstepsSounds[math.random(#self.CustomWalkFootstepsSounds)], 80)
		else
			self:EmitSound("CoDZ_Zombie.StepWalk")
		end
	end
	if e == "step_right_large" or e == "step_left_large" then
		util.ScreenShake(self:GetPos(),8,8,0.2,600)
		if self.CustomRunFootstepsSounds then
			self:EmitSound(self.CustomRunFootstepsSounds[math.random(#self.CustomRunFootstepsSounds)], 80)
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
end

function ENT:IsValidTarget( ent )
	if not ent then return false end
	return IsValid(ent) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
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
					maxs = Vector(19, 19, 96) + bloat,
					mins = Vector(-19,-19, 0) - bloat,
					filter = self
				})
				if !tr1.HitWorld then
					self:SetCollisionBounds(Vector(-19,-19, 0), Vector(19, 19, 96))
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