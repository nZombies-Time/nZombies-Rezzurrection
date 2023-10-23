AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Fire Skeleton that shoots spooky skulls at you"
ENT.Type = "nextbot"
ENT.Category = "Brainz"
ENT.Author = "Wavy"
ENT.Spawnable = true

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true
ENT.MooSpecialZombie = true -- They're a Special Zombie, but is still close enough to a normal zombie to be able to do normal zombie things.
ENT.IsMooSpecial = true
ENT.AttackRange = 150
ENT.DamageRange = 1

ENT.Models = {
	{Model = "models/wavy/wavy_rigs/skeleton_soldiers/fire_guy/wavy_zombie_undead_skeleton_fire.mdl", Skin = 5, Bodygroups = {0,0}},
}

local spawnslow = {"nz_spawn_ground_ad_v2"}

ENT.BarricadeTearSequences = {
	"nz_legacy_door_tear_high",
	"nz_legacy_door_tear_low",
	"nz_legacy_door_tear_left",
	"nz_legacy_door_tear_right"
}

local SlowClimbUp36 = {
	"nz_traverse_climbup36"
}
local SlowClimbUp48 = {
	"nz_traverse_climbup48"
}
local SlowClimbUp72 = {
	"nz_traverse_climbup72"
}
local SlowClimbUp96 = {
	"nz_traverse_climbup96"
}
local SlowClimbUp128 = {
	"nz_traverse_climbup128"
}
local SlowClimbUp160 = {
	"nz_traverse_climbup160"
}
local FastClimbUp36 = {
	"nz_traverse_fast_climbup36"
}
local FastClimbUp48 = {
	"nz_traverse_fast_climbup48"
}
local FastClimbUp72 = {
	"nz_traverse_fast_climbup72"
}
local FastClimbUp96 = {
	"nz_traverse_fast_climbup96"
}
local ClimbUp200 = {
	"nz_traverse_climbup200"
}

local AttackSequences = {
	{seq = "nz_napalm_attack_01"},
}

local RunAttackSequences = {
	{seq = "nz_napalm_attack_03"},
}

local JumpSequences = {
	{seq = "nz_barricade_trav_walk_1"},
	{seq = "nz_barricade_trav_walk_2"},
	{seq = "nz_barricade_trav_walk_3"},
}
local RunJumpSequences = {
	{seq = "nz_barricade_run_1"},
}

local walksounds = {
	Sound("nz_moo/zombies/vox/_za4/vox_zmb_za4_amb_00.mp3"),
	Sound("nz_moo/zombies/vox/_za4/vox_zmb_za4_amb_01.mp3"),
	Sound("nz_moo/zombies/vox/_za4/vox_zmb_za4_amb_02.mp3"),
	Sound("nz_moo/zombies/vox/_za4/vox_zmb_za4_amb_03.mp3"),
	Sound("nz_moo/zombies/vox/_za4/vox_zmb_za4_amb_04.mp3"),
	Sound("nz_moo/zombies/vox/_za4/vox_zmb_za4_amb_05.mp3"),
}

local runsounds = {
	Sound("nz_moo/zombies/vox/_za4/vox_zmb_za4_sprint_00.mp3"),
	Sound("nz_moo/zombies/vox/_za4/vox_zmb_za4_sprint_01.mp3"),
	Sound("nz_moo/zombies/vox/_za4/vox_zmb_za4_sprint_02.mp3"),
	Sound("nz_moo/zombies/vox/_za4/vox_zmb_za4_sprint_03.mp3"),
	Sound("nz_moo/zombies/vox/_za4/vox_zmb_za4_sprint_04.mp3"),
	Sound("nz_moo/zombies/vox/_za4/vox_zmb_za4_sprint_05.mp3"),
	Sound("nz_moo/zombies/vox/_za4/vox_zmb_za4_sprint_06.mp3"),
	Sound("nz_moo/zombies/vox/_za4/vox_zmb_za4_sprint_07.mp3"),
	Sound("nz_moo/zombies/vox/_za4/vox_zmb_za4_sprint_08.mp3"),
}

-- This is a very large and messy looking table... But it gets the job done.
ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawnslow},
			MovementSequence = {
				"nz_napalm_walk_01",
				"nz_napalm_walk_02",
				"nz_napalm_walk_03",
			},
			BlackholeMovementSequence = {
				"nz_blackhole_1",
				"nz_blackhole_2",
				"nz_blackhole_3",
			},
			AttackSequences = {AttackSequences},

			JumpSequences = {JumpSequences},

			Climb36 = {SlowClimbUp36},
			Climb48 = {SlowClimbUp48},
			Climb72 = {SlowClimbUp72},
			Climb96 = {SlowClimbUp96},
			Climb120 = {SlowClimbUp128},
			Climb160 = {SlowClimbUp160},
			Climb200 = {ClimbUp200},

			PassiveSounds = {walksounds},
		}
	}},
	{Threshold = 71, Sequences = {
		{
			SpawnSequence = {spawnslow},
			MovementSequence = {
				"nz_legacy_jap_run_v2",
				"nz_legacy_jap_run_v3",
				"nz_legacy_jap_run_v4",
				"nz_legacy_jap_run_v6",
				"nz_legacy_sprint_v5",
			},
			BlackholeMovementSequence = {
				"nz_blackhole_1",
				"nz_blackhole_2",
				"nz_blackhole_3",
			},
			AttackSequences = {RunAttackSequences},

			JumpSequences = {RunJumpSequences},

			Climb36 = {FastClimbUp36},
			Climb48 = {FastClimbUp48},
			Climb72 = {FastClimbUp72},
			Climb96 = {FastClimbUp96},
			Climb120 = {SlowClimbUp128},
			Climb160 = {SlowClimbUp160},
			Climb200 = {ClimbUp200},

			PassiveSounds = {runsounds},
		}
	}}
}

ENT.DeathSounds = {
	"nz_moo/zombies/vox/_za4/vox_zmb_za4_death_00.mp3",
	"nz_moo/zombies/vox/_za4/vox_zmb_za4_death_01.mp3",
	"nz_moo/zombies/vox/_za4/vox_zmb_za4_death_02.mp3",
	"nz_moo/zombies/vox/_za4/vox_zmb_za4_death_03.mp3",
	"nz_moo/zombies/vox/_za4/vox_zmb_za4_death_04.mp3",
	"nz_moo/zombies/vox/_za4/vox_zmb_za4_death_05.mp3",
	"nz_moo/zombies/vox/_za4/vox_zmb_za4_death_06.mp3",
	"nz_moo/zombies/vox/_za4/vox_zmb_za4_death_07.mp3",
	"nz_moo/zombies/vox/_za4/vox_zmb_za4_death_08.mp3",
	"nz_moo/zombies/vox/_za4/vox_zmb_za4_death_09.mp3",
	"nz_moo/zombies/vox/_za4/vox_zmb_za4_death_10.mp3"
}

ENT.AttackSounds = {
	"nz_moo/zombies/vox/_za4/vox_zmb_za4_attack_00.mp3",
	"nz_moo/zombies/vox/_za4/vox_zmb_za4_attack_01.mp3",
	"nz_moo/zombies/vox/_za4/vox_zmb_za4_attack_02.mp3",
	"nz_moo/zombies/vox/_za4/vox_zmb_za4_attack_03.mp3",
	"nz_moo/zombies/vox/_za4/vox_zmb_za4_attack_04.mp3",
	"nz_moo/zombies/vox/_za4/vox_zmb_za4_attack_05.mp3",
	"nz_moo/zombies/vox/_za4/vox_zmb_za4_attack_06.mp3",
	"nz_moo/zombies/vox/_za4/vox_zmb_za4_attack_07.mp3",
	"nz_moo/zombies/vox/_za4/vox_zmb_za4_attack_08.mp3",
	"nz_moo/zombies/vox/_za4/vox_zmb_za4_attack_09.mp3",
	"nz_moo/zombies/vox/_za4/vox_zmb_za4_attack_10.mp3",
	"nz_moo/zombies/vox/_za4/vox_zmb_za4_attack_11.mp3",
	"nz_moo/zombies/vox/_za4/vox_zmb_za4_attack_12.mp3",
	"nz_moo/zombies/vox/_za4/vox_zmb_za4_attack_13.mp3",
	"nz_moo/zombies/vox/_za4/vox_zmb_za4_attack_14.mp3",
	"nz_moo/zombies/vox/_za4/vox_zmb_za4_attack_15.mp3"
}

ENT.SpawnSounds = {
	"nz_moo/zombies/vox/_napalm/spawn/evt/evt_napalm_zombie_spawn_00.mp3",
	"nz_moo/zombies/vox/_napalm/spawn/evt/evt_napalm_zombie_spawn_01.mp3",
	"nz_moo/zombies/vox/_napalm/spawn/evt/evt_napalm_zombie_spawn_02.mp3",
	"nz_moo/zombies/vox/_napalm/spawn/evt/evt_napalm_zombie_spawn_03.mp3"
}

ENT.BehindSoundDistance = 200 -- When the zombie is within 200 units of a player, play these sounds instead
ENT.BehindSounds = {
	Sound("nz_moo/zombies/vox/_za4/vox_zmb_za4_behind_00.mp3"),
	Sound("nz_moo/zombies/vox/_za4/vox_zmb_za4_behind_01.mp3"),
	Sound("nz_moo/zombies/vox/_za4/vox_zmb_za4_behind_02.mp3"),
	Sound("nz_moo/zombies/vox/_za4/vox_zmb_za4_behind_03.mp3"),
	Sound("nz_moo/zombies/vox/_za4/vox_zmb_za4_behind_04.mp3"),
}

function ENT:StatsInitialize()
	if SERVER then
		if nzRound:GetNumber() == -1 then
			self:SetRunSpeed( math.random(25, 220) )
			self:SetHealth( math.random(100, 1500) )
		else
			local speeds = nzRound:GetZombieCoDSpeeds()
			if speeds then
				self:SetRunSpeed( nzMisc.WeightedRandom(speeds) + math.random(0,35) )
			else
				self:SetRunSpeed( 100 )
			end
			self:SetHealth( nzRound:GetZombieHealth() + 2000 or 1000 )
		end
		self.SpitCooldown = CurTime() + 6
		self.CanSpit = false
		self.Spitting = false
	end
end

function ENT:SpecialInit()
	if CLIENT then
	end
end

function ENT:OnSpawn()
	self:EmitSound(self.SpawnSounds[math.random(#self.SpawnSounds)], 100, math.random(85, 105), 1, 2)
	self:EmitSound("nz_moo/zombies/vox/_napalm/evt_napalm_zombie_loop.wav", 75, math.random(95, 105), 1, 3)
	self:EmitSound("nz_moo/zombies/vox/_za4/vox_zmb_za4_taunt_0"..math.random(0,6)..".mp3", 511, math.random(95, 105), 1, 2)
	ParticleEffect("doom_hellunit_spawn_medium",self:GetPos(),self:GetAngles(),self)
	ParticleEffectAttach("env_fire_small", 4, self, 8)
	local spawn
	local types = {
		["nz_spawn_zombie_normal"] = true,
		["nz_spawn_zombie_special"] = true,
		["nz_spawn_zombie_extra1"] = true,
		["nz_spawn_zombie_extra2"] = true,
		["nz_spawn_zombie_extra3"] = true,
		["nz_spawn_zombie_extra4"] = true,
	}
	for k,v in pairs(ents.FindInSphere(self:GetPos(), 10)) do
		if types[v:GetClass()] then
			if !v:GetMasterSpawn() then
				spawn = v
			end
		end
	end
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

	if IsValid(spawn) and spawn:GetSpawnType() == 1 then
		self:SolidMaskDuringEvent(MASK_PLAYERSOLID)
		self:CollideWhenPossible()
	else
		self:SolidMaskDuringEvent(MASK_PLAYERSOLID)

		self:SetSpecialAnimation(true)
		self:SetIsBusy(true)
		local seq = self:SelectSpawnSequence()

		if IsValid(spawn) and spawn:GetSpawnType() == 3 then
			seq = self.UndercroftSequences[math.random(#self.UndercroftSequences)]
		elseif IsValid(spawn) and spawn:GetSpawnType() == 4 then
			seq = self.WallSpawnSequences[math.random(#self.WallSpawnSequences)]
		elseif IsValid(spawn) and spawn:GetSpawnType() == 5 then
			if tr.Hit then
				local finalsound = SpawnMatSound[tr.MatType] or SpawnMatSound[0]
				self:EmitSound(finalsound)
			end
			ParticleEffect("bo3_zombie_spawn",self:GetPos()+Vector(0,0,1),self:GetAngles(),self)
			self:EmitSound("nz_moo/zombies/spawn/_generic/dirt/dirt_0"..math.random(0,2)..".mp3",100,math.random(95,105))

			seq = self.JumpSpawnSequences[math.random(#self.JumpSpawnSequences)]
		elseif IsValid(spawn) and spawn:GetSpawnType() == 6 then
			seq = self.BarrelSpawnSequences[math.random(#self.BarrelSpawnSequences)]
		elseif IsValid(spawn) and spawn:GetSpawnType() == 7 then
			seq = self.LowCeilingDropSpawnSequences[math.random(#self.LowCeilingDropSpawnSequences)]
		elseif IsValid(spawn) and spawn:GetSpawnType() == 8 then
			seq = self.HighCeilingDropSpawnSequences[math.random(#self.HighCeilingDropSpawnSequences)]
		elseif IsValid(spawn) and spawn:GetSpawnType() == 9 then
			seq = self.GroundWallSpawnSequences[math.random(#self.GroundWallSpawnSequences)]
		else
			if tr.Hit then
				local finalsound = SpawnMatSound[tr.MatType] or SpawnMatSound[0]
				self:EmitSound(finalsound)
			end
			ParticleEffect("bo3_zombie_spawn",self:GetPos()+Vector(0,0,1),self:GetAngles(),self)
			self:EmitSound("nz_moo/zombies/spawn/_generic/dirt/dirt_0"..math.random(0,2)..".mp3",100,math.random(95,105))
		end
		if seq then
			if IsValid(spawn) and 
				(spawn:GetSpawnType() == 3 
				or spawn:GetSpawnType() == 4 
				or spawn:GetSpawnType() == 6 
				or spawn:GetSpawnType() == 9) then
				self:PlaySequenceAndMove(seq, {gravity = false})
			else
				self:PlaySequenceAndMove(seq, {gravity = true})
			end
			self:SetSpecialAnimation(false)
			self:SetIsBusy(false)
			self:CollideWhenPossible()
		end
	end
end

function ENT:PerformDeath(dmginfo)
	self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(95, 105), 1, 2)
	self:StopSound("nz_moo/zombies/vox/_napalm/evt_napalm_zombie_loop.wav")
	self:BecomeRagdoll(dmginfo)
	self:Explode(100, false)
	self:StopParticles()
end

function ENT:OnRemove()
	self:StopSound("nz_moo/zombies/vox/_napalm/evt_napalm_zombie_loop.wav")
	self:StopParticles()
end

function ENT:PostAdditionalZombieStuff()
	if self:GetSpecialAnimation() then return end
	if CurTime() > self.SpitCooldown and !self.CanSpit then
		self.CanSpit = true
	end
	if self:TargetInRange(700) and !self:IsAttackBlocked() and self.CanSpit and !self.IsTurned and math.random(3) == 3 then
		if !self:GetTarget():IsPlayer() then return end
		if self:TargetInRange(200) then return end
		self:SkullSpit()
	end
end

function ENT:SkullSpit()
	self:TempBehaveThread(function(self)
		self:SetSpecialAnimation(true)
		self.Spitting = true
		self:PlaySequenceAndMove("nz_base_attack_ranged_01", 1, self.FaceEnemy)
		self.Spitting = false
		self.CanSpit = false
		self:SetSpecialAnimation(false)
		self.SpitCooldown = CurTime() + 6
	end)
end

function ENT:HandleAnimEvent(a,b,c,d,e) -- Moo Mark 4/14/23: You don't know how sad I am that I didn't know about this sooner.
	if e == "step_right_large" then
		self:EmitSound("CoDZ_Zombie.Fire_Step")
		self:EmitSound("CoDZ_Zombie.Napalm_Step")
		ParticleEffectAttach("bo3_napalm_fs", 4, self, 10)
	end
	if e == "step_left_large" then
		self:EmitSound("CoDZ_Zombie.Fire_Step")
		self:EmitSound("CoDZ_Zombie.Napalm_Step")
		ParticleEffectAttach("bo3_napalm_fs", 4, self, 9)
	end
	if e == "crawl_hand" then
		if self.CustomCrawlImpactSounds then
			self:EmitSound(self.CrawlImpactSounds[math.random(#self.CrawlImpactSounds)], 70)
		else
			self:EmitSound("CoDZ_Zombie.StepCrawl")
		end
	end
	if e == "melee" then
		if self.AttackSounds then
			self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2)
		end
		self:DoAttackDamage()
	end
	if e == "generic_taunt" then
		if self.TauntSounds then
			self:EmitSound(self.TauntSounds[math.random(#self.TauntSounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		end
	end
	if e == "special_taunt" then
		if self.TauntSounds then
			self:EmitSound("nz_moo/zombies/vox/_classic/taunt/spec_taunt.mp3", 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		end
	end
	if e == "base_ranged_rip" then
		ParticleEffectAttach("ins_blood_dismember_limb", 4, self, 5)
		self:EmitSound("nz_moo/zombies/gibs/gib_0"..math.random(0,3)..".mp3", 100, math.random(95,105))
		self:EmitSound("nz_moo/zombies/gibs/head/head_explosion_0"..math.random(4)..".mp3", 65, math.random(95,105))
	end
	if e == "base_ranged_throw" then
		self:EmitSound("nz_moo/zombies/fly/attack/whoosh/zmb_attack_med_0"..math.random(0,2)..".mp3", 95)

		local larmfx_tag = self:LookupBone("j_wrist_le")

		self.Guts = ents.Create("nz_gib")
		self.Guts:SetPos(self:GetBonePosition(larmfx_tag))
		self.Guts:Spawn()

		local phys = self.Guts:GetPhysicsObject()
		local target = self:GetTarget()
		if IsValid(phys) and IsValid(target) then
			 phys:SetVelocity(self.Guts:getvel(target:GetPos(), self:EyePos(), 0.95))
		end
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
	if e == "base_ranged_puke" then
		if math.random(20) == 20 then
		self:EmitSound("nz_moo/effects/skullemoji.wav", 500)
		else
		self:EmitSound("fx/fx_fire_gas_high0"..math.random(1,2)..".wav", 500)
		end
		local larmfx_tag = self:LookupBone("j_neck")
		local tr = util.TraceLine({
			start = self:GetPos() + Vector(0,50,0),
			endpos = self:GetTarget():GetPos() + Vector(0,0,50),
			filter = self,
			ignoreworld = true,
		})	
		if IsValid(tr.Entity) then
		self.Skull = ents.Create("ss_skull")
		self.Skull:SetPos(self:GetBonePosition(larmfx_tag))
		self.Skull:SetOwner(self:GetOwner())
		self.Skull:Spawn()
		self.Skull:Launch(((tr.Entity:GetPos() + Vector(0,0,50)) - self.Skull:GetPos()):GetNormalized())
		end
	end
	if e == "napalm_charge" then
		self:EmitSound("nz_moo/zombies/vox/_napalm/explosion/evt_napalm_charge.mp3", 100)
		self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2)
	end
	if e == "napalm_explode" then
		util.ScreenShake(self:GetPos(),12,400,3,1000)	
		self:EmitSound("nz_moo/zombies/vox/_napalm/explosion/evt_napalm_zombie_explo.mp3",511)
		self:EmitSound("nz_moo/zombies/vox/_napalm/explosion/zmb_napalm_explode.mp3",511)
		self:EmitSound("nz_moo/zombies/vox/_napalm/explosion/evt_zombie_flare_0"..math.random(0,1)..".mp3",511)
		ParticleEffect("hound_explosion",self:LocalToWorld(Vector(0,0,50)),Angle(0,0,0),nil)
		self.RangeSqr = 200*200
		local util_traceline = util.TraceLine		
		local pos = self:WorldSpaceCenter()
        local tr = {
            start = pos,
            filter = self,
           	mask = MASK_NPCSOLID_BRUSHONLY
        }
		for k,v in pairs(ents.FindInSphere(self:GetPos(), 200)) do
			if IsValid(v) and v:IsPlayer() and !self:IsAttackEntBlocked(v) then
               	if v:GetClass() == self:GetClass() then continue end
                if v == self then continue end
               	if v:EntIndex() == self:EntIndex() then continue end
               	if v:Health() <= 0 then continue end
                tr.endpos = v:WorldSpaceCenter()
               	local tr1 = util_traceline(tr)
                if tr1.HitWorld then continue end
				
			    local expdamage = DamageInfo()
				local dist = self:GetPos():DistToSqr(v:GetPos())
				dist = 1 - math.Clamp(dist/self.RangeSqr, 0, 0.5)
				expdamage:SetAttacker(self)
				expdamage:SetInflictor(self)
				expdamage:SetDamageType(DMG_BLAST)
				expdamage:SetDamage(75 * dist)
				v:TakeDamageInfo(expdamage)
				v:Ignite(4)
			end
		end
	end
end
