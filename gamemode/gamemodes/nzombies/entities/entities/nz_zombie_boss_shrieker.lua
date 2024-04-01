AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "The Shrieker aka The Hollering One"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo"

function ENT:DrawEyeGlow()
	local eyeglow =  Material("nz_moo/sprites/moo_glow1")
	local eyeColor = Color(255,255,255)
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
	{Model = "models/moo/_codz_ports/t7/temple/moo_codz_t7_sonic_napalm.mdl", Skin = 0, Bodygroups = {0,0}},
}

ENT.DeathSequences = {
	"nz_death_1",
	"nz_death_2",
	"nz_death_3",
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

local SprintAttackSequences = {
	{seq = "nz_t8_attack_sprint_larm_1"},
	{seq = "nz_t8_attack_sprint_larm_2"},
	{seq = "nz_t8_attack_sprint_larm_3"},
	{seq = "nz_t8_attack_sprint_larm_4"},
	{seq = "nz_t8_attack_sprint_rarm_1"},
	{seq = "nz_t8_attack_sprint_rarm_2"},
	{seq = "nz_t8_attack_sprint_rarm_3"},
	{seq = "nz_t8_attack_sprint_rarm_4"},
}

local walksounds = {
	Sound("nz_moo/zombies/vox/_sonic/amb/vox_sonic_zombie_ambient_00.mp3"),
	Sound("nz_moo/zombies/vox/_sonic/amb/vox_sonic_zombie_ambient_01.mp3"),
	Sound("nz_moo/zombies/vox/_sonic/amb/vox_sonic_zombie_ambient_02.mp3"),
	Sound("nz_moo/zombies/vox/_sonic/amb/vox_sonic_zombie_ambient_03.mp3"),
}

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawnfast},
			MovementSequence = {
				"nz_sonic_run_01",
				"nz_sonic_run_02",
				"nz_sonic_run_03",
				"nz_l4d_run_04",
			},
			BlackholeMovementSequence = {
				"nz_blackhole_1",
				"nz_blackhole_2",
				"nz_blackhole_3",
			},
			AttackSequences = {SprintAttackSequences},
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

ENT.SonicSideStepSequences = {
	"nz_sonic_sidestep_left_a",
	"nz_sonic_sidestep_left_b",
	"nz_sonic_sidestep_right_a",
	"nz_sonic_sidestep_right_b",
}

ENT.SonicScreamSequences = {
	"nz_sonic_attack_01",
	"nz_sonic_attack_02",
	"nz_sonic_attack_03",
}

ENT.DeathSounds = {
	"nz_moo/zombies/vox/_sonic/zmb_sonic_death.mp3",
}
ENT.AttackSounds = {
	"nz_moo/zombies/vox/_sonic/attack/vox_sonic_zombie_attack_00.mp3",
	"nz_moo/zombies/vox/_sonic/attack/vox_sonic_zombie_attack_01.mp3",
	"nz_moo/zombies/vox/_sonic/attack/vox_sonic_zombie_attack_02.mp3",
	"nz_moo/zombies/vox/_sonic/attack/vox_sonic_zombie_attack_03.mp3",
}
ENT.SpawnSounds = {
	"nz_moo/zombies/vox/_sonic/spawn/evt_sonic_spawn_00.mp3",
	"nz_moo/zombies/vox/_sonic/spawn/evt_sonic_spawn_01.mp3",
	"nz_moo/zombies/vox/_sonic/spawn/evt_sonic_spawn_02.mp3",
	"nz_moo/zombies/vox/_sonic/spawn/evt_sonic_spawn_03.mp3",
}

ENT.BehindSoundDistance = 0 -- When the zombie is within 200 units of a player, play these sounds instead

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

		self:SetRunSpeed(71)

		self:SetBodygroup(0,1)

		self.Cooldown = CurTime() + 7 -- Won't be allowed to explode right after spawning, so they'll attack normally until then.
		self.Screaming = false
		self.CanScream = false
	end
end

function ENT:SpecialInit()
	if CLIENT then
	end
end

function ENT:OnSpawn()
	self:PlaySound(self.SpawnSounds[math.random(#self.SpawnSounds)], 511, math.random(85, 105))

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

	local effectData = EffectData()
	effectData:SetStart( self:GetPos() )
	effectData:SetOrigin( self:GetPos() )
	effectData:SetMagnitude(1)
	local entParticle = ents.Create("info_particle_system")
	entParticle:SetKeyValue("start_active", "1")
	entParticle:SetKeyValue("effect_name", "sonic_emerge")
	entParticle:SetPos(self:GetPos())
	entParticle:SetAngles(self:GetAngles())
	entParticle:Spawn()
	entParticle:Activate()
	entParticle:Fire("kill","",2)

	if tr.Hit then
		local finalsound = SpawnMatSound[tr.MatType] or SpawnMatSound[0]
		self:EmitSound(finalsound)
	end

	self:SolidMaskDuringEvent(MASK_PLAYERSOLID)

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
		
	self.Dying = true

	local damagetype = dmginfo:GetDamageType()

	self:PostDeath(dmginfo)

	self:Explode(dmginfo)

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

function ENT:AdditionalZombieStuff()
	if self:GetSpecialAnimation() then return end
	if CurTime() > self.Cooldown and !self.CanScream then
		self.CanScream = true
	end
	if self:TargetInRange(325) and !self:IsAttackBlocked() and self.CanScream and !self.IsTurned then
		if !self:GetTarget():IsPlayer() then return end
		if self:TargetInRange(90) then return end
		self:SonicAttack()
	end
	if nzMapping.Settings.sidestepping then -- Commence thy tomfoolery.
		if self:GetCrawler() then return end -- But not if you're a cripple :man_in_manual_wheelchair:
		if self.Non3arcZombie then return end -- Or if you're a WW2 man.if !self:IsAimedAt() then return end

		if self:TargetInRange(500) and !self.AttackIsBlocked and math.random(20) <= 15 and CurTime() > self.LastSideStep then
			if !self:IsFacingTarget() then return end
			if !self:IsAimedAt() then return end
			if self:TargetInRange(70) then return end
			if self:GetRunSpeed() > 200 then return end
			if IsValid(self:GetTarget()) and self:GetTarget():IsPlayer() then
				local seq = self.SonicSideStepSequences[math.random(#self.SonicSideStepSequences)]
				if self:SequenceHasSpace(seq) then
					self:DoSpecialAnimation(seq, true, true)
				end
				self.LastSideStep = CurTime() + 3
			end
		end
	end
end

function ENT:SonicAttack()
	self:TempBehaveThread(function(self)
		self:SetSpecialAnimation(true)
		self.Screaming = true
		self:PlaySequenceAndMove(self.SonicScreamSequences[math.random(#self.SonicScreamSequences)], 1, self.FaceEnemy)
		self.Screaming = false
		self.CanScream = false
		self:SetSpecialAnimation(false)
		self.Cooldown = CurTime() + 7
	end)
end

function ENT:OnTargetInAttackRange()
	if !self:GetBlockAttack() or self.IsTurned then
		self:Attack()
	else
		self:TimeOut(2)
	end
end

function ENT:HandleAnimEvent(a,b,c,d,e)
	if e == "melee" then
		self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2)
		self:DoAttackDamage()
	end
	if e == "pull_plank" then
		if IsValid(self) and self:Alive() then
			if IsValid(self.BarricadePlankPull) and IsValid(self.Barricade) then
				self.Barricade:RemovePlank(self.BarricadePlankPull)
			end
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
	if e == "sonic_scream" then
		local me = self
		self:EmitSound("nz_moo/zombies/vox/_sonic/evt_sonic_attack_flux.mp3", 100, math.random(85, 105))
		self:EmitSound("nz_moo/zombies/vox/_sonic/zmb_sonic_scream.mp3", 65, math.random(85, 105))
		ParticleEffectAttach("screamer_scream", 4, self, 10)
		for k,v in pairs(ents.FindInSphere(self:GetPos(), 325)) do
			if IsValid(v) and !self:IsAttackEntBlocked(v) then
				if v:IsPlayer() then
					v:NZSonicBlind(3)
				end
			end
		end
	end
end

function ENT:Explode(dmg, suicide)
    for k, v in pairs(ents.FindInSphere(self:GetPos(), 250)) do
        if not v:IsWorld() and v:IsSolid() then
            v:SetVelocity(((v:GetPos() - self:GetPos()):GetNormalized()*10) + v:GetUp()*20)
            
            if v:IsValidZombie() then
                if v == self then continue end
                if v:EntIndex() == self:EntIndex() then continue end
                if v:Health() <= 0 then continue end
                if !v:Alive() then continue end
                local damage = DamageInfo()
                damage:SetAttacker(self)
                damage:SetDamageType(DMG_SHOCK)
                damage:SetDamage(v:Health() + 666)
                damage:SetDamageForce(v:GetUp()*1 + (v:GetPos() - self:GetPos()):GetNormalized() * 1)
                damage:SetDamagePosition(v:EyePos())
                v:TakeDamageInfo(damage)
            end

            if v:IsPlayer() then
            	v:SetGroundEntity(nil)
                v:ViewPunch(Angle(-25,math.random(-10, 10),0))
            end
        end
    end
	ParticleEffect("bo3_astronaut_pulse",self:LocalToWorld(Vector(0,0,50)),Angle(0,0,0),nil)
	self:EmitSound("nz_moo/zombies/vox/_sonic/zmb_sonic_explode.mp3", 75, math.random(85, 105))
	ParticleEffectAttach("screamer_scream_warp", 4, self, 10)
end