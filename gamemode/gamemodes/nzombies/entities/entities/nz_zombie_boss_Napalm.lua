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
	local eyeglow =  Material("nz_moo/sprites/moo_glow1")
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
		render.DrawSprite(lefteyepos, 4, 4, eyeColor)
		render.DrawSprite(righteyepos, 4, 4, eyeColor)
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

local spawnfast = {"nz_spawn_ground_climbout_fast"}

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
	{Threshold = 70, Sequences = {
		{
			SpawnSequence = {spawnfast},
			MovementSequence = {
				"nz_supersprint_au12"
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

		self.Cooldown = CurTime() + 7 -- Won't be allowed to explode right after spawning, so they'll attack normally until then.
		self.CanExplode = false
		self.Suicide = false
	end
end

function ENT:OnSpawn()
	--self:PlaySound(self.SpawnSounds[math.random(#self.SpawnSounds)], 511, math.random(85, 105))
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
	ParticleEffectAttach("firestaff_victim_burning",PATTACH_ABSORIGIN_FOLLOW,self,0)

	self:EmitSound("nz/zombies/spawn/zm_spawn_dirt"..math.random(1,2)..".wav",80,math.random(95,105))
	
	self:SetSpecialAnimation(true)
	local seq = self:SelectSpawnSequence()
	if seq then
		self:PlaySequenceAndMove(seq)
		self:SetSpecialAnimation(false)
		self:CollideWhenPossible()
	end
end

function ENT:PerformDeath(dmginfo)
	self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
	self:StopSound("nz_moo/zombies/vox/_napalm/evt_napalm_zombie_loop.wav")
	self:DoDeathAnimation(self.RagdollDeathSequences[math.random(#self.RagdollDeathSequences)])
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
	if self:TargetInRange(100) and !self:IsAttackBlocked() and self.CanExplode and !self.IsTurned then
		self.Suicide = true
		self:DoSpecialAnimation(self.ExplodeAttackSequences[math.random(#self.ExplodeAttackSequences)])
	end
end

function ENT:OnTargetInAttackRange()
	if !self:GetBlockAttack() and !self.CanExplode or self.IsTurned then
		self:Attack()
	else
		self:TimeOut(2)
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
        local vaporizer = ents.Create("point_hurt") -- Point Hurt is Laby's favorite breakfast, lunch, and dinner... HE LOVES!!! POINT_HURT!!!
        if !vaporizer:IsValid() then return end
        vaporizer:SetKeyValue("Damage", 22)
        vaporizer:SetKeyValue("DamageRadius", 150)
        vaporizer:SetKeyValue("DamageType",DMG_BURN)
        vaporizer:SetPos(self:GetPos())
        vaporizer:SetOwner(self)
        vaporizer:Spawn()
        vaporizer:Fire("TurnOn","",0)
        vaporizer:Fire("kill","",20)

		self:Explode(200, false)
		--self:Remove() -- Goodbye
	end
end

function ENT:HandleAnimEvent(a,b,c,d,e)
	if e == "melee" then
		self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2)
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
