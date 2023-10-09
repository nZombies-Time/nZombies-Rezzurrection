AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.Type = "nextbot"
ENT.PrintName = "Kevin Clamely"
ENT.Category = "Brainz"
ENT.Author = "Wavy"
ENT.Spawnable = true

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = false
ENT.MooSpecialZombie = false -- They're a Special Zombie, but is still close enough to a normal zombie to be able to do normal zombie things.
ENT.IsMooSpecial = true

ENT.Models = {
	{Model = "models/wavy/wavy_enemies/patriarch/patriarch_kf1.mdl", Skin = 0, Bodygroups = {0,0}},
}

local util_tracehull = util.TraceHull
local spawn = {"nz_patriarch_spawn"}

ENT.AttackRange = 110

ENT.DamageRange = 110

ENT.AttackDamage = 80

ENT.LongDamageRange = 160

ENT.IdleSequence = "nz_patriarch_idle"

ENT.BarricadeTearSequences = {
	"nz_patriarch_attack_stand",
}

local StandAttackSequences = {
	{seq = "nz_patriarch_attack_stand"},
}

local AttackSequences = {
	{seq = "nz_patriarch_attack_walk1"},
	{seq = "nz_patriarch_attack_walk2"},
	{seq = "nz_patriarch_attack_walk3"},
}

local RunAttackSequences = {
	{seq = "nz_patriarch_attack_run1"},
	{seq = "nz_patriarch_attack_run2"},
	{seq = "nz_patriarch_attack_run3"},
}

local JumpSequences = {
	{seq = "nz_patriarch_traverse"},
}

local walksounds = {
	Sound("wavy_zombie/patriarch/voicechase/chase1.wav"),
	Sound("wavy_zombie/patriarch/voicechase/chase2.wav"),
	Sound("wavy_zombie/patriarch/voicechase/chase3.wav"),
	Sound("wavy_zombie/patriarch/voicechase/chase4.wav"),
	Sound("wavy_zombie/patriarch/voicechase/chase5.wav"),
	Sound("wavy_zombie/patriarch/voicechase/chase6.wav"),
	Sound("wavy_zombie/patriarch/voicechase/chase7.wav"),
	Sound("wavy_zombie/patriarch/voicechase/chase8.wav"),
	Sound("wavy_zombie/patriarch/voicechase/chase9.wav"),
	Sound("wavy_zombie/patriarch/voicechase/chase10.wav"),
}

-- This is a very large and messy looking table... But it gets the job done.
ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawnslow},
			MovementSequence = {
				"nz_patriarch_walk",
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
				"nz_patriarch_run",
			},
			SpawnSequence = {spawn},
			AttackSequences = {RunAttackSequences},
			StandAttackSequences = {StandAttackSequences},

			JumpSequences = {JumpSequences},

			PassiveSounds = {walksounds},
		}
	}}
}

ENT.DeathSounds = {
	"wavy_zombie/patriarch/voicedeath/death1.wav",
	"wavy_zombie/patriarch/voicedeath/death2.wav",
	"wavy_zombie/patriarch/voicedeath/death3.wav",
	"wavy_zombie/patriarch/voicedeath/death4.wav",
	"wavy_zombie/patriarch/voicedeath/death5.wav",
	"wavy_zombie/patriarch/voicedeath/death6.wav",
}

ENT.AttackSounds = {
	"wavy_zombie/patriarch/voicemelee/melee1.wav",
	"wavy_zombie/patriarch/voicemelee/melee2.wav",
	"wavy_zombie/patriarch/voicemelee/melee3.wav",
	"wavy_zombie/patriarch/voicemelee/melee4.wav",
	"wavy_zombie/patriarch/voicemelee/melee5.wav",
	"wavy_zombie/patriarch/voicemelee/melee6.wav",
	"wavy_zombie/patriarch/voicemelee/melee7.wav",
	"wavy_zombie/patriarch/voicemelee/melee8.wav",
	"wavy_zombie/patriarch/voicemelee/melee9.wav",
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

ENT.LongAttackSounds = {
	"wavy_zombie/patriarch/voiceintro/scream1.wav",
	"wavy_zombie/patriarch/voiceintro/scream2.wav",
	"wavy_zombie/patriarch/voiceintro/scream3.wav",
	"wavy_zombie/patriarch/voiceintro/scream4.wav",
	"wavy_zombie/patriarch/voiceintro/scream5.wav",
	"wavy_zombie/patriarch/voiceintro/scream6.wav",
}

ENT.SpawnSounds = {
	"wavy_zombie/patriarch/voiceintro/intro1.wav",
	"wavy_zombie/patriarch/voiceintro/intro2.wav",
	"wavy_zombie/patriarch/voiceintro/intro3.wav",
	"wavy_zombie/patriarch/voiceintro/intro4.wav",
	"wavy_zombie/patriarch/voiceintro/intro5.wav",
	"wavy_zombie/patriarch/voiceintro/intro6.wav",
	"wavy_zombie/patriarch/voiceintro/intro7.wav",
}

ENT.PattyMusic = {
	"wavy_zombie/patriarch/music/DirgeRepulse1.wav",
	"wavy_zombie/patriarch/music/KF_Abandon.wav",
	"wavy_zombie/patriarch/music/KF_AbandonV3.wav",
	"wavy_zombie/patriarch/music/KF_Infectious_Cadaver.wav",
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
		
		self.MinigunCooldown = CurTime() + 5
		self.RocketCooldown = CurTime() + 5
		self.IsShooting = false
		self.CanShoot = false
		self.IsRocketing = false
		self.CanRocket = false
		self.ManIsMad = false
		self.Malding = false
		self.IsLaughing = false
		self.HasLaughed = false --nigga think he a comedian 
	end
end

function ENT:SpecialInit()
	if CLIENT then
	end
end

function ENT:OnSpawn()
	local seq = self:SelectSpawnSequence()
	local _, dur = self:LookupSequence(seq)

	self:EmitSound(self.SpawnSounds[math.random(#self.SpawnSounds)], 500, 100, 1, 2)
	self.NextSound = CurTime() + 8
	self:SolidMaskDuringEvent(MASK_SOLID_BRUSHONLY)
	self:SetInvulnerable(true)
	self:SetSpecialAnimation(true)
	local effectData = EffectData()
	effectData:SetOrigin( self:GetPos() + Vector(0, 0, 50)  )
	effectData:SetMagnitude( 1 )
	effectData:SetEntity(nil)
	util.Effect("panzer_spawn_tp", effectData)
	self:StartMusic()
	
	if seq then
		self:PlaySequenceAndWait(seq)
		self:SetSpecialAnimation(false)
		self:SetInvulnerable(false)
		self:CollideWhenPossible()
	end
end

function ENT:PerformDeath(dmginfo)
	self:EmitSound(self.DeathSounds[math.random(#self.DeathSounds)], 500, math.random(95, 105), 1, 2)
	self:StopSound("wavy_zombie/patriarch/wep_minigunloop.wav")
	self:StopSound("wavy_zombie/patriarch/wep_minigunshooting.wav")
	self:StopSound("wavy_zombie/patriarch/music/DirgeRepulse1.wav")
	self:StopSound("wavy_zombie/patriarch/music/KF_Abandon.wav")
	self:StopSound("wavy_zombie/patriarch/music/KF_AbandonV3.wav")
	self:StopSound("wavy_zombie/patriarch/music/KF_Infectious_Cadaver.wav")
	self:BecomeRagdoll(dmginfo)
end

function ENT:OnRemove()
	self:StopSound("wavy_zombie/patriarch/wep_minigunloop.wav")
	self:StopSound("wavy_zombie/patriarch/wep_minigunshooting.wav")
	self:StopSound("wavy_zombie/patriarch/music/DirgeRepulse1.wav")
	self:StopSound("wavy_zombie/patriarch/music/KF_Abandon.wav")
	self:StopSound("wavy_zombie/patriarch/music/KF_AbandonV3.wav")
	self:StopSound("wavy_zombie/patriarch/music/KF_Infectious_Cadaver.wav")
end

function ENT:IsValidTarget( ent )
	if !ent then return false end
	
	return IsValid(ent) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
	-- Won't go for special targets (Monkeys), but still MAX, ALWAYS and so on
end

function ENT:PostAdditionalZombieStuff()
	if SERVER then
	if self:GetSpecialAnimation() then return end
	if CurTime() > self.MinigunCooldown and !self.CanShoot then
		self.CanShoot = true
	end
	if CurTime() > self.RocketCooldown and !self.CanRocket then
		self.CanRocket = true
	end
	if self:TargetInRange(800) and !self:IsAttackBlocked() and self.CanShoot then
		if !self:GetTarget():IsPlayer() then return end
		if self:TargetInRange(175) then return end
		self:ShootGun()
	end
	if self:TargetInRange(1200) and !self:IsAttackBlocked() and self.CanRocket and math.random(3) == 3 then
		if !self:GetTarget():IsPlayer() then return end
		if self:TargetInRange(400) then return end
		self:FireRocket()
	end
	end
end

function ENT:OnTakeDamage()
	if self:Health() <= (self:GetMaxHealth()/2) and !self.ManIsMad and !self:GetSpecialAnimation() then
		self.ManIsMad = true
		self:NowYouPissedMeOff()
	end
end

function ENT:NowYouPissedMeOff()
	self:EmitSound("wavy_zombie/patriarch/voiceknock/knockdown"..math.random(1,7)..".wav", 500, 100, 1, 2)
	self:TempBehaveThread(function(self)
		self:SetSpecialAnimation(true)
		self.Malding = true
		self:PlaySequenceAndMove("nz_patriarch_stun", 1)
		self.Malding = false
		self:SetSpecialAnimation(false)
		self:SetRunSpeed(71)
		self:SpeedChanged()
	end)
end

function ENT:ShootGun()
	self:EmitSound("wavy_zombie/patriarch/wep_minigunstart.wav", 500)
	self:EmitSound("wavy_zombie/patriarch/voicegunready/minigun"..math.random(1,4)..".wav", 500, 100, 1, 2)
	self:TempBehaveThread(function(self)
		self:SetSpecialAnimation(true)
		self.IsShooting = true
		self:PlaySequenceAndMove("nz_patriarch_gun_start", 1, self.FaceEnemy)
		self:PlaySequenceAndMove("nz_patriarch_gun_attack", 1, self.FaceEnemy)
		self:PlaySequenceAndMove("nz_patriarch_gun_end", 1)
		self.IsShooting = false
		self.CanShoot = false
		self:SetSpecialAnimation(false)
		self.MinigunCooldown = CurTime() + math.random(9,14)
	end)
end

function ENT:FireRocket()
	self:EmitSound("wavy_zombie/patriarch/wep_rocketstart.wav", 500)
	self:EmitSound("wavy_zombie/patriarch/voicegunready/rocket"..math.random(1,2)..".wav", 500, 100, 1, 2)
	self:TempBehaveThread(function(self)
		self:SetSpecialAnimation(true)
		self.IsRocketing = true
		self:PlaySequenceAndMove("nz_patriarch_rocket", 1, self.FaceEnemy)
		self.IsRocketing = false
		self.CanRocket = false
		self:SetSpecialAnimation(false)
		self.RocketCooldown = CurTime() + math.random(6,10)
	end)
end

function ENT:StartMusic()
	local found = false
	for k, v in pairs(ents.FindByClass("nz_zombie_boss_patriarch")) do
		if IsValid(v) and !found and !v.Dying and v:Alive() then
			found = true
			v:EmitSound("nz_moo/zombies/vox/mute_00.wav", 1, 1, 1, -1)
			v:EmitSound(v.PattyMusic[math.random(#v.PattyMusic)], 577, 100, 1, -1)
		end
	end
end

-- HAHAHAHAHAHA, YOU SUCK!
function ENT:OnNoTarget()
	if nzRound:InState( ROUND_GO ) and !self.HasLaughed and !self.IsLaughing then
	self.HasLaughed = true
	self:TempBehaveThread(function(self)
		self:SetSpecialAnimation(true)
		self.IsLaughing = true
		self:PlaySequenceAndMove("nz_patriarch_victory", 1)
		self.IsLaughing = false
		self:SetSpecialAnimation(false)
	end)
	else
	self:TimeOut(0.1) -- Instead of being brain dead for a second, just search for a new target sooner.
	local newtarget = self:GetPriorityTarget()
	if self:IsValidTarget(newtarget) then
		self:SetTarget(newtarget)
	else
		if !self:IsInSight() and nzRound:InProgress() and not nzRound:InState( ROUND_GO ) then
			self:RespawnZombie()
		else
			self:TimeOut(0.1)
		end
	end
end
end

function ENT:DoLongAttackDamage() -- Moo Mark 4/14/23: Made the part that does damage during an attack its own function.
	local target = self:GetTarget()

	local damage = self.AttackDamage
	local dmgrange = self.LongDamageRange
	local range = self.AttackRange

	if self:GetIsBusy() then
		range = self.AttackRange + 45
		dmgrange = self.LongDamageRange + 45
	else
		range = self.AttackRange + 25
	end

	if self:WaterBuff() and self:BomberBuff() then
		damage = self.JumpAttackDamage * 3
	elseif self:WaterBuff() then
		damage = self.JumpAttackDamage * 2
	end

	if IsValid(target) and target:Health() and target:Health() > 0 then -- Doesn't matter if its a player... If the zombie is targetting it, they probably wanna attack it.
		if self:TargetInRange( range ) then

			local dmgInfo = DamageInfo()
			dmgInfo:SetAttacker( self )
			dmgInfo:SetDamage( damage )
			dmgInfo:SetDamageType( DMG_SLASH )
			dmgInfo:SetDamageForce( (target:GetPos() - self:GetPos()) * 7 + Vector( 0, 0, 16 ) )

			if self:TargetInRange( dmgrange ) then
				target:TakeDamageInfo(dmgInfo)
				if comedyday or math.random(500) == 1 then
					if self.GoofyahAttackSounds then target:EmitSound(self.GoofyahAttackSounds[math.random(#self.GoofyahAttackSounds)], SNDLVL_TALKING, math.random(95,105)) end
				else
					if self.CustomAttackImpactSounds then
						target:EmitSound(self.CustomAttackImpactSounds[math.random(#self.CustomAttackImpactSounds)], SNDLVL_TALKING, math.random(95,105))
					else
						target:EmitSound(self.AttackImpactSounds[math.random(#self.AttackImpactSounds)], SNDLVL_TALKING, math.random(95,105))
					end
				end
			end
		end
	end
end

function ENT:HandleAnimEvent(a,b,c,d,e) -- Moo Mark 4/14/23: You don't know how sad I am that I didn't know about this sooner.
	if e == "step_right_small" or e == "step_left_small" then
		if self.CustomWalkFootstepsSounds then
			self:EmitSound(self.CustomWalkFootstepsSounds[math.random(#self.CustomWalkFootstepsSounds)], 70)
		else
			self:EmitSound("CoDZ_Zombie.StepWalk")
		end
	end
	if e == "step_right_large" or e == "step_left_large" then
		if self.CustomRunFootstepsSounds then
			self:EmitSound(self.CustomRunFootstepsSounds[math.random(#self.CustomRunFootstepsSounds)], 70)
		else
			self:EmitSound("CoDZ_Zombie.StepRun")
		end
	end
	if e == "melee" then
		if self.AttackSounds then
			self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(95, 105), 1, 2)
		end
		self:DoAttackDamage()
	end
	if e == "melee_long" then
		self:EmitSound(self.LongAttackSounds[math.random(#self.LongAttackSounds)], 100, math.random(95, 105), 1, 2)
		self:DoLongAttackDamage()
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
	if e == "minigun_loop_start" then
		self:EmitSound("wavy_zombie/patriarch/wep_minigunloop.wav", 500)
		self:EmitSound("wavy_zombie/patriarch/wep_minigunshooting.wav", 500)
	end
	if e == "minigun_loop_stop" then
		self:EmitSound("wavy_zombie/patriarch/wep_minigunend.wav", 500)
		self:StopSound("wavy_zombie/patriarch/wep_minigunloop.wav")
		self:StopSound("wavy_zombie/patriarch/wep_minigunshooting.wav")
	end
	if e == "gun_shoot" then
		local target = self:GetTarget()
		local tr = util.TraceLine({
			start = self:GetPos() + Vector(0,50,0),
			endpos = self:GetTarget():GetPos() + Vector(0,0,50),
			filter = self,
			ignoreworld = true,
		})	
		if IsValid(tr.Entity) then
		local shootPos = self:GetAttachment(1).Pos
		local bullet = {}
		bullet.Num = 1
		bullet.Src = self:GetAttachment(1).Pos
		bullet.Dir = (target:GetPos() - self:GetPos()):GetNormalized()
		bullet.Spread = Vector(0.09,0.09,0.09)
		bullet.Tracer	= 1
		bullet.TracerName	= "AR2Tracer"
		bullet.HullSize	= 5
		bullet.Force = math.random(2)*math.random(4)
		bullet.Damage	= 15
		bullet.AmmoType = "AR2"
		bullet.Filter = {self}
		bullet.Callback = function(ent, tr, dmg)
			dmg:SetAttacker(self)
			dmg:SetInflictor(self)
		end
		self:FireBullets(bullet)
	end
	end
	if e == "rocket_shoot" then
		self:EmitSound("wavy_zombie/patriarch/wep_rocketshooting.wav", 500)
		local larmfx_tag = self:LookupBone("Missile")
		local tr = util.TraceLine({
			start = self:GetPos() + Vector(0,50,0),
			endpos = self:GetTarget():GetPos() + Vector(0,0,50),
			filter = self,
			ignoreworld = true,
		})	
		if IsValid(tr.Entity) then
		self.Skull = ents.Create("patty_rocket")
		self.Skull:SetPos(self:GetBonePosition(larmfx_tag))
		self.Skull:SetOwner(self:GetOwner())
		self.Skull:Spawn()
		self.Skull:Launch(((tr.Entity:GetPos() + Vector(0,0,50)) - self.Skull:GetPos()):GetNormalized())
		end
	end
	if e == "patriarch_roar" then
		self:EmitSound("wavy_zombie/patriarch/voiceintro/scream"..math.random(1,6)..".wav", 500, 100, 1, 2)
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