AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "The Napalm Zombie aka The NayNayPalm"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo"

function ENT:Draw() //Runs every frame
		self:DrawModel()
		if self.RedEyes and self:Alive() and !self:GetDecapitated() and !self:GetMooSpecial() and !self.IsMooSpecial then
			self:DrawEyeGlow() 
		end

		local elight = DynamicLight( self:EntIndex(), true )
		if ( elight ) then
			local bone = self:LookupBone("j_spineupper")
			local pos = self:GetBonePosition(bone)
			pos = pos 
			elight.pos = pos
			elight.r = 255
			elight.g = 50
			elight.b = 0
			elight.brightness = 8
			elight.Decay = 1000
			elight.Size = 40
			elight.DieTime = CurTime() + 1
			elight.style = 0
			elight.noworld = true
		end

	if GetConVar( "nz_zombie_debug" ):GetBool() then
		render.DrawWireframeBox(self:GetPos(), Angle(0,0,0), self:OBBMins(), self:OBBMaxs(), Color(255,0,0), true)
	end
end

function ENT:DrawEyeGlow()
	local eyeglow =  Material("nz/zlight")
	local eyeColor = Color(255,50,0)
	local latt = self:LookupAttachment("lefteye")
	local ratt = self:LookupAttachment("righteye")

	if latt == nil then return end
	if ratt == nil then return end

	local leye = self:GetAttachment(latt)
	local reye = self:GetAttachment(ratt)

	local righteyepos = leye.Pos + leye.Ang:Forward()*0.5
	local lefteyepos = reye.Pos + reye.Ang:Forward()*0.5

	if lefteyepos and righteyepos then
		render.SetMaterial(eyeglow)
		render.DrawSprite(lefteyepos, 5, 5, eyeColor)
		render.DrawSprite(righteyepos, 5, 5, eyeColor)
	end
end

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.RedEyes = true
ENT.SpeedBasedSequences = true

ENT.IsMooZombie = true
ENT.IsMooSpecial = true
ENT.MooSpecialZombie = true -- They're a Special Zombie, but is still close enough to a normal zombie to be able to do normal zombie things.
ENT.IsMooBossZombie = true

ENT.AttackRange = 72

ENT.TraversalCheckRange = 40

ENT.Models = {
	{Model = "models/moo/_codz_ports/t7/temple/moo_codz_t7_sonic_napalm.mdl", Skin = 1, Bodygroups = {0,0}},
}

ENT.DeathSequences = {
	"nz_napalm_death_01",
	"nz_napalm_death_02",
	"nz_napalm_death_03",
}

ENT.BarricadeTearSequences = {
	"nz_legacy_door_tear_high",
	"nz_legacy_door_tear_low",
	"nz_legacy_door_tear_left",
	"nz_legacy_door_tear_right",
}

local spawnfast = {"nz_ent_ground_01", "nz_ent_ground_02"}

local JumpSequences = {
	{seq = "nz_barricade_trav_walk_1"},
	{seq = "nz_barricade_trav_walk_2"},
	{seq = "nz_barricade_trav_walk_3"},
}

local SprintJumpSequences = {
	{seq = "nz_barricade_sprint_1"},
	{seq = "nz_barricade_sprint_2"},
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
	{seq = "nz_attack_stand_ad_1"},
	{seq = "nz_attack_stand_au_1"},
	{seq = "nz_legacy_attack_v3"},
	{seq = "nz_legacy_attack_v4"},
	{seq = "nz_legacy_attack_v11"},
	{seq = "nz_fwd_ad_attack_v1"},
	{seq = "nz_fwd_ad_attack_v2"},
	{seq = "nz_legacy_attack_superwindmill"},
	{seq = "nz_t8_attack_stand_larm_1"},
	{seq = "nz_t8_attack_stand_larm_2"},
	{seq = "nz_t8_attack_stand_larm_3"},
	{seq = "nz_t8_attack_stand_rarm_1"},
	{seq = "nz_t8_attack_stand_rarm_2"},
	{seq = "nz_t8_attack_stand_rarm_3"},
}

local WalkAttackSequences = {
	{seq = "nz_walk_ad_attack_v1"}, -- Quick single swipe
	{seq = "nz_walk_ad_attack_v2"}, -- Slowish double swipe
	{seq = "nz_walk_ad_attack_v3"}, -- Slowish single swipe
	{seq = "nz_walk_ad_attack_v4"}, -- Quickish double swipe
	{seq = "nz_t8_attack_walk_larm_1"},
	{seq = "nz_t8_attack_walk_rarm_3"},
	{seq = "nz_t8_attack_walk_larm_2"},
	{seq = "nz_t8_attack_walk_rarm_6"},
}

local SuperSprintAttackSequences = {
	{seq = "nz_t8_attack_supersprint_larm_1"},
	{seq = "nz_t8_attack_supersprint_larm_2"},
	{seq = "nz_t8_attack_supersprint_rarm_1"},
	{seq = "nz_t8_attack_supersprint_rarm_2"},
}

local walksounds = {
	Sound("nz_moo/zombies/vox/_napalm/amb/zmb_napalm_ambient_00.mp3"),
	Sound("nz_moo/zombies/vox/_napalm/amb/zmb_napalm_ambient_01.mp3"),
	Sound("nz_moo/zombies/vox/_napalm/amb/zmb_napalm_ambient_02.mp3"),
	Sound("nz_moo/zombies/vox/_napalm/amb/zmb_napalm_ambient_03.mp3"),
}

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawnfast},
			MovementSequence = {
				"nz_napalm_walk_01",
				"nz_napalm_walk_02",
				"nz_napalm_walk_03",
				"nz_s1_zom_core_walk_2",
				"nz_s1_zom_core_walk_4",
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
		},
	}},
	{Threshold = 36, Sequences = {
		{
			SpawnSequence = {spawnfast},
			MovementSequence = {
				"nz_legacy_run_v1",
				"nz_legacy_jap_run_v1",
				"nz_legacy_jap_run_v2",
				"nz_fast_sprint_v1",
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
		},
	}},
	{Threshold = 71, Sequences = {
		{
			SpawnSequence = {spawnfast},
			MovementSequence = {
				"nz_l4d_run_04",
				"nz_l4d_run_05",
				"nz_s1_zom_core_run_1",
				"nz_s1_zom_core_sprint_4",
				"nz_l4d_crouchrun",
				"nz_sprint_ad1",
				"nz_sprint_au2",
			},
			BlackholeMovementSequence = {
				"nz_blackhole_1",
				"nz_blackhole_2",
				"nz_blackhole_3",
			},
			AttackSequences = {SuperSprintAttackSequences},
			JumpSequences = {SprintJumpSequences},

			Climb36 = {FastClimbUp36},
			Climb48 = {FastClimbUp48},
			Climb72 = {FastClimbUp72},
			Climb96 = {FastClimbUp96},
			Climb120 = {SlowClimbUp128},
			Climb160 = {SlowClimbUp160},
			Climb200 = {ClimbUp200},

			PassiveSounds = {walksounds},
		},
	}}
}

ENT.ExplodeAttackSequences = {
	"nz_napalm_attack_01",
	"nz_napalm_attack_02",
	"nz_napalm_attack_03"
}

ENT.DeathSounds = {
	"nz_moo/zombies/vox/_napalm/pain/zmb_napalm_zombies_vocals_pain_00.mp3",
	"nz_moo/zombies/vox/_napalm/pain/zmb_napalm_zombies_vocals_pain_01.mp3",
	"nz_moo/zombies/vox/_napalm/pain/zmb_napalm_zombies_vocals_pain_02.mp3"
}
ENT.AttackSounds = {
	"nz_moo/zombies/vox/_napalm/attack/zmb_napalm_attack_00.mp3",
	"nz_moo/zombies/vox/_napalm/attack/zmb_napalm_attack_01.mp3",
	"nz_moo/zombies/vox/_napalm/attack/zmb_napalm_attack_02.mp3",
}
ENT.SpawnSounds = {
	"nz_moo/zombies/vox/_napalm/spawn/evt/evt_napalm_zombie_spawn_00.mp3",
	"nz_moo/zombies/vox/_napalm/spawn/evt/evt_napalm_zombie_spawn_01.mp3",
	"nz_moo/zombies/vox/_napalm/spawn/evt/evt_napalm_zombie_spawn_02.mp3",
	"nz_moo/zombies/vox/_napalm/spawn/evt/evt_napalm_zombie_spawn_03.mp3",
}
ENT.SpawnVoxSounds = {
	"nz_moo/zombies/vox/_napalm/spawn/evt_napalm_zombie_spawn_vocals_00.mp3",
	"nz_moo/zombies/vox/_napalm/spawn/evt_napalm_zombie_spawn_vocals_01.mp3",
	"nz_moo/zombies/vox/_napalm/spawn/evt_napalm_zombie_spawn_vocals_02.mp3",
}

ENT.FootstepsSounds = {
	"nz_moo/zombies/vox/_napalm/step/fly_step_napalm_close_00.mp3",
	"nz_moo/zombies/vox/_napalm/step/fly_step_napalm_close_01.mp3",
	"nz_moo/zombies/vox/_napalm/step/fly_step_napalm_close_02.mp3",
	"nz_moo/zombies/vox/_napalm/step/fly_step_napalm_close_03.mp3",
	"nz_moo/zombies/vox/_napalm/step/fly_step_napalm_close_04.mp3",
	"nz_moo/zombies/vox/_napalm/step/fly_step_napalm_close_05.mp3"
}

ENT.SWTFootstepsSounds = {
	"nz_moo/zombies/vox/_mutated/step/fire/step_00.mp3",
	"nz_moo/zombies/vox/_mutated/step/fire/step_01.mp3",
	"nz_moo/zombies/vox/_mutated/step/fire/step_02.mp3",
	"nz_moo/zombies/vox/_mutated/step/fire/step_03.mp3",
	"nz_moo/zombies/vox/_mutated/step/fire/step_04.mp3",
	"nz_moo/zombies/vox/_mutated/step/fire/step_05.mp3",
	"nz_moo/zombies/vox/_mutated/step/fire/step_06.mp3",
	"nz_moo/zombies/vox/_mutated/step/fire/step_07.mp3",
	"nz_moo/zombies/vox/_mutated/step/fire/step_08.mp3"
}

ENT.BehindSoundDistance = 200 -- When the zombie is within 200 units of a player, play these sounds instead
ENT.BehindSounds = {
	Sound("nz_moo/zombies/vox/_napalm/behind/zmb_napalm_zombies_vocals_behind_00.mp3"),
	Sound("nz_moo/zombies/vox/_napalm/behind/zmb_napalm_zombies_vocals_behind_01.mp3"),
	Sound("nz_moo/zombies/vox/_napalm/behind/zmb_napalm_zombies_vocals_behind_02.mp3"),
	Sound("nz_moo/zombies/vox/_napalm/behind/zmb_napalm_zombies_vocals_behind_03.mp3"),
	Sound("nz_moo/zombies/vox/_napalm/behind/zmb_napalm_zombies_vocals_behind_04.mp3"),
}

function ENT:StatsInitialize()
	if SERVER then
		local count = #player.GetAllPlaying()

		if nzRound:InState( ROUND_CREATE ) then
			self:SetHealth(2250)
			self:SetMaxHealth(2250)
		else
			if nzRound:InState( ROUND_PROG ) then
				self:SetHealth(math.Clamp(nzRound:GetNumber() * 250 + (250 * count), 2250, 5250 * count))
				self:SetMaxHealth(math.Clamp(nzRound:GetNumber() * 250 + (250 * count), 2250, 5250 * count))
			else
				self:SetHealth(2250)
				self:SetMaxHealth(2250)	
			end
		end

		self:SetRunSpeed(1)

		self:SetBodygroup(0,0)

		self.Cooldown = CurTime() + 3 -- Won't be allowed to explode right after spawning, so they'll attack normally until then.
		self.CanExplode = false
		self.Suicide = false
		self.Sprint = false
        self:Flames(true)
	end
end

function ENT:OnSpawn()
	self:PlaySound(self.SpawnSounds[math.random(#self.SpawnSounds)], 577, math.random(85, 105))
	self:PlaySound(self.SpawnVoxSounds[math.random(#self.SpawnVoxSounds)], 100, math.random(85, 105), 1, 2)
	self:EmitSound("nz_moo/zombies/vox/_napalm/evt_napalm_zombie_loop.wav", 75, math.random(95, 105), 1, 3)

	local SpawnMatSound = {
		[MAT_DIRT] = "nz_moo/zombies/spawn/dirt/pfx_zm_spawn_dirt_0"..math.random(0,1)..".mp3",
		[MAT_SNOW] = "nz_moo/zombies/spawn/snow/pfx_zm_spawn_snow_0"..math.random(0,1)..".mp3",
		[MAT_SLOSH] = "nz_moo/zombies/spawn/mud/pfx_zm_spawn_mud_00.mp3",
		[0] = "nz_moo/zombies/spawn/pfx_zm_spawn_default_00.mp3",
	}
	SpawnMatSound[MAT_GRASS] = SpawnMatSound[MAT_DIRT]
	SpawnMatSound[MAT_SAND] = SpawnMatSound[MAT_DIRT]

	local norm = (self:GetPos()):GetNormalized()
	local tr = util.QuickTrace(self:GetPos(), norm*10, self)

	if tr.Hit then
		local finalsound = SpawnMatSound[tr.MatType] or SpawnMatSound[0]
		self:EmitSound(finalsound)
	end

	self:SolidMaskDuringEvent(MASK_PLAYERSOLID)
	ParticleEffect("doom_hellunit_spawn_medium",self:GetPos(),self:GetAngles(),self)
	--ParticleEffectAttach("firestaff_victim_burning",PATTACH_ABSORIGIN_FOLLOW,self,0)
	
	self:SetSpecialAnimation(true)
	local seq = self:SelectSpawnSequence()
	if seq then
		self:PlaySequenceAndMove(seq)
		self:SetSpecialAnimation(false)
		self:CollideWhenPossible()
	end
end

function ENT:PerformDeath(dmginfo)
		
	self.Dying = true

	local damagetype = dmginfo:GetDamageType()

	self:PostDeath(dmginfo)

	if damagetype == DMG_MISSILEDEFENSE or damagetype == DMG_ENERGYBEAM then
		self:BecomeRagdoll(dmginfo) -- Only Thundergun and Wavegun Ragdolls constantly.
	end
	if damagetype == DMG_REMOVENORAGDOLL then
		self:Remove(dmginfo)
	end
	if self.DeathRagdollForce == 0 or self:GetSpecialAnimation() then
		if self.DeathSounds then
			self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
		end
		self:BecomeRagdoll(dmginfo)
	else
		if self.DeathSounds then
			self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
		end
		self:DoDeathAnimation(self.DeathSequences[math.random(#self.DeathSequences)])
	end
end

function ENT:PostDeath(dmginfo) 
	self:StopSound("nz_moo/zombies/vox/_napalm/evt_napalm_zombie_loop.wav")
	if !self.Suicide then
		self:NapalmDeathExplosion()
	end
end

function ENT:OnRemove()
	self:StopSound("nz_moo/zombies/vox/_napalm/evt_napalm_zombie_loop.wav")
end

function ENT:IsValidTarget( ent )
	if !ent then return false end

	-- Turned Zombie Targetting
	if self.IsTurned then return IsValid(ent) and ent:IsValidZombie() and !ent.IsTurned and !ent.IsMooSpecial and ent:Alive() end
	
	return IsValid(ent) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
	-- Won't go for special targets (Monkeys), but still MAX, ALWAYS and so on
end

function ENT:PostAdditionalZombieStuff()
	if CurTime() > self.Cooldown and !self.CanExplode then
		self.CanExplode = true
	end
	if self:TargetInRange(100) and !self:IsAttackBlocked() and self:IsFacingTarget() and self.CanExplode and !self.IsTurned then
		self.Suicide = true
		self:DoSpecialAnimation(self.ExplodeAttackSequences[math.random(#self.ExplodeAttackSequences)])
	end
	if self:Health() < self:GetMaxHealth() / 2 and !self.Sprint then
		self.Sprint = true
		self:SetRunSpeed(71)
		self:SpeedChanged()
	end
end

function ENT:OnTargetInAttackRange()
	if !self:GetBlockAttack() and !self.CanExplode or self.IsTurned then
		self:Attack()
	else
		self:TimeOut(1)
	end
end

function ENT:NapalmDeathExplosion()
	if IsValid(self) then	
		util.ScreenShake(self:GetPos(),12,400,3,1000)

		self:EmitSound("nz_moo/zombies/vox/_napalm/explosion/evt_napalm_zombie_explo.mp3",511)
		self:EmitSound("nz_moo/zombies/vox/_napalm/explosion/zmb_napalm_explode.mp3",511)
		self:EmitSound("nz_moo/zombies/vox/_napalm/explosion/evt_zombie_flare_0"..math.random(0,1)..".mp3",511)

        local entParticle = ents.Create("info_particle_system")
        entParticle:SetKeyValue("start_active", "1")
        entParticle:SetKeyValue("effect_name", "napalm_postdeath_napalm")
        entParticle:SetPos(self:GetPos())
        entParticle:SetAngles(self:GetAngles())
        entParticle:Spawn()
        entParticle:Activate()
        entParticle:Fire("kill","",20)

        local firepit = ents.Create("napalm_firepit")
        firepit:SetPos(self:WorldSpaceCenter())
		firepit:SetAngles(Angle(0,0,0))
        firepit:Spawn()

		self:Explode(200, false)
	end
end

function ENT:HandleAnimEvent(a,b,c,d,e) -- Moo Mark 4/14/23: You don't know how sad I am that I didn't know about this sooner.
	if e == "step_right_small" then
		self:EmitSound(self.FootstepsSounds[math.random(#self.FootstepsSounds)], 85)
		self:EmitSound(self.SWTFootstepsSounds[math.random(#self.SWTFootstepsSounds)], 70)
		ParticleEffectAttach("bo3_napalm_fs",PATTACH_POINT,self,12)
	end
	if e == "step_left_small" then
		self:EmitSound(self.FootstepsSounds[math.random(#self.FootstepsSounds)], 85)
		self:EmitSound(self.SWTFootstepsSounds[math.random(#self.SWTFootstepsSounds)], 70)
		ParticleEffectAttach("bo3_napalm_fs",PATTACH_POINT,self,11)
	end
	if e == "step_right_large" then
		self:EmitSound(self.FootstepsSounds[math.random(#self.FootstepsSounds)], 85)
		self:EmitSound(self.SWTFootstepsSounds[math.random(#self.SWTFootstepsSounds)], 70)
		ParticleEffectAttach("bo3_napalm_fs",PATTACH_POINT,self,12)
	end
	if e == "step_left_large" then
		self:EmitSound(self.FootstepsSounds[math.random(#self.FootstepsSounds)], 85)
		self:EmitSound(self.SWTFootstepsSounds[math.random(#self.SWTFootstepsSounds)], 70)
		ParticleEffectAttach("bo3_napalm_fs",PATTACH_POINT,self,11)
	end
	if e == "crawl_hand" then
		if self.CustomCrawlImpactSounds then
			self:EmitSound(self.CrawlImpactSounds[math.random(#self.CrawlImpactSounds)], 70)
		else
			self:EmitSound("CoDZ_Zombie.StepCrawl")
		end
	end
	if e == "melee" or e == "melee_heavy" then
		if self:BomberBuff() and self.GasAttack then
			self:EmitSound(self.GasAttack[math.random(#self.GasAttack)], 100, math.random(95, 105), 1, 2)
		else
			if self.AttackSounds then
				self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2)
			end
		end
		if e == "melee_heavy" then
			self.HeavyAttack = true
		end
		self:DoAttackDamage()
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
		local movementdir
		if IsValid(phys) and IsValid(target) then
			--[[if target:IsPlayer() then
				movementdir = target:GetVelocity():Normalize()
				print(movementdir)
			end]]
			phys:SetVelocity(self.Guts:getvel(target:EyePos() - Vector(0,0,7), self:EyePos(), 0.95))
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

	-- WW2 Zobies	
	if e == "s2_gen_step" then
		self:EmitSound(self.StepSounds[math.random(#self.StepSounds)], 60, math.random(95, 105))
	end
	if e == "s2_taunt_vox" then
		self:EmitSound(self.TauntSounds[math.random(#self.TauntSounds)],95, math.random(95, 105), 1, 2)
	end

	-- Taunt Sounds, theres alot of these

	if e == "generic_taunt" then
		if self.TauntSounds then
			self:EmitSound(self.TauntSounds[math.random(#self.TauntSounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		end
	end
	if e == "special_taunt" then
		if self.CustomSpecialTauntSounds then
			self:EmitSound(self.CustomSpecialTauntSounds[math.random(#self.CustomSpecialTauntSounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		else
			self:EmitSound("nz_moo/zombies/vox/_classic/taunt/spec_taunt.mp3", 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		end
	end
	if e == "anim_taunt_v1" then
		if self.CustomTauntAnimV1Sounds then
			self:EmitSound(self.CustomTauntAnimV1Sounds[math.random(#self.CustomTauntAnimV1Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		else
			self:EmitSound(self.TauntAnimV1Sounds[math.random(#self.TauntAnimV1Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		end
	end
	if e == "anim_taunt_v2" then
		if self.CustomTauntAnimV2Sounds then
			self:EmitSound(self.CustomTauntAnimV2Sounds[math.random(#self.CustomTauntAnimV2Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		else
			self:EmitSound(self.TauntAnimV2Sounds[math.random(#self.TauntAnimV2Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		end
	end
	if e == "anim_taunt_v3" then
		if self.CustomTauntAnimV2Sounds then
			self:EmitSound(self.CustomTauntAnimV3Sounds[math.random(#self.CustomTauntAnimV3Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		else
			self:EmitSound(self.TauntAnimV3Sounds[math.random(#self.TauntAnimV3Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		end
	end
	if e == "anim_taunt_v4" then
		if self.CustomTauntAnimV4Sounds then
			self:EmitSound(self.CustomTauntAnimV4Sounds[math.random(#self.CustomTauntAnimV4Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		else
			self:EmitSound(self.TauntAnimV4Sounds[math.random(#self.TauntAnimV4Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		end
	end
	if e == "anim_taunt_v5" then
		if self.CustomTauntAnimV5Sounds then
			self:EmitSound(self.CustomTauntAnimV5Sounds[math.random(#self.CustomTauntAnimV5Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		else
			self:EmitSound(self.TauntAnimV5Sounds[math.random(#self.TauntAnimV5Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		end
	end
	if e == "anim_taunt_v6" then
		if self.CustomTauntAnimV6Sounds then
			self:EmitSound(self.CustomTauntAnimV6Sounds[math.random(#self.CustomTauntAnimV6Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		else
			self:EmitSound(self.TauntAnimV6Sounds[math.random(#self.TauntAnimV6Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		end
	end
	if e == "anim_taunt_v7" then
		if self.CustomTauntAnimV7Sounds then
			self:EmitSound(self.CustomTauntAnimV7Sounds[math.random(#self.CustomTauntAnimV7Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		else
			self:EmitSound(self.TauntAnimV7Sounds[math.random(#self.TauntAnimV7Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		end
	end
	if e == "anim_taunt_v8" then
		if self.CustomTauntAnimV8Sounds then
			self:EmitSound(self.CustomTauntAnimV8Sounds[math.random(#self.CustomTauntAnimV8Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		else
			self:EmitSound(self.TauntAnimV8Sounds[math.random(#self.TauntAnimV8Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		end
	end
	if e == "anim_taunt_v9" then
		if self.CustomTauntAnimV9Sounds then
			self:EmitSound(self.CustomTauntAnimV9Sounds[math.random(#self.CustomTauntAnimV9Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		else
			self:EmitSound(self.TauntAnimV9Sounds[math.random(#self.TauntAnimV9Sounds)], 100, math.random(85, 105), 1, 2)
			self.NextSound = CurTime() + self.SoundDelayMax
		end
	end

	if e == "napalm_charge" then
		self:EmitSound("nz_moo/zombies/vox/_napalm/explosion/evt_napalm_charge.mp3", 100)
	end
	if e == "napalm_explode" then
		self:NapalmDeathExplosion()
	end
end


function ENT:PostTookDamage(dmginfo)
	if self:Health() < 100 then
		self.LastZombieMomento = true
	end
end
