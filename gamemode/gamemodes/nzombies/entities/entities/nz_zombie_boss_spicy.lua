AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Fuel Junkie, sometimes known by his hood name of the Taki Eater"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo and Laby"

function ENT:Draw() //Runs every frame
		self:DrawModel()

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



if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.RedEyes = true
ENT.SpeedBasedSequences = true

ENT.IsMooZombie = true
ENT.IsMooSpecial = true
ENT.IsMooBossZombie = true

ENT.AttackRange = 72

ENT.TraversalCheckRange = 40

ENT.Models = {
	{Model = "models/bosses/takieater.mdl" , Skin = 0, Bodygroups = {0,0}},
}

ENT.DeathSequences = {
	"suicide3"
}

ENT.BarricadeTearSequences = {
	"shriek3"
}

local spawnfast = {"land"}

local AttackSequences = {
	{seq = "shriek3"},

}

local walksounds = {
	Sound("nz_moo/zombies/vox/_napalm/amb/zmb_napalm_ambient_00.mp3"),
	Sound("nz_moo/zombies/vox/_napalm/amb/zmb_napalm_ambient_01.mp3"),
	Sound("nz_moo/zombies/vox/_napalm/amb/zmb_napalm_ambient_02.mp3"),
	Sound("nz_moo/zombies/vox/_napalm/amb/zmb_napalm_ambient_03.mp3")
}

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawnfast},
			MovementSequence = {
				"walk1",
				"walk2",
				"walk3",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},

			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 100, Sequences = {
		{
			SpawnSequence = {spawnfast},
			MovementSequence = {
				"run1",
				"run2",
			},
			
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},

			

			PassiveSounds = {walksounds},
		},
	}},
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
	"nz_moo/zombies/vox/_sonic/spawn/evt_sonic_spawn_00.mp3",
	"nz_moo/zombies/vox/_sonic/spawn/evt_sonic_spawn_01.mp3",
	"nz_moo/zombies/vox/_sonic/spawn/evt_sonic_spawn_02.mp3",
	"nz_moo/zombies/vox/_sonic/spawn/evt_sonic_spawn_03.mp3",
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
				self:SetHealth(math.Clamp(nzRound:GetNumber() * 250 + (250 * count), 1800, 4900 * count))
				self:SetMaxHealth(math.Clamp(nzRound:GetNumber() * 250 + (250 * count), 1800, 4900 * count))
			else
				self:SetHealth(1800)
				self:SetMaxHealth(1800)	
			end
		end
		FIREFIRE = false
		self.UsingFlamethrower = false
		local speeds = nzRound:GetZombieCoDSpeeds()
		if speeds then
		self.loco:SetDesiredSpeed( nzMisc.WeightedRandom(speeds) + math.random(50) )
		else
		self.loco:SetDesiredSpeed( 200)
		end

		self:SetBodygroup(0,0)

		self.NextAction = CurTime() + 3 -- Won't be allowed to explode right after spawning, so they'll attack normally until then.
		
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
	--ParticleEffect("doom_hellunit_spawn_medium",self:GetPos(),self:GetAngles(),self)
	ParticleEffectAttach("firestaff_victim_burning",PATTACH_ABSORIGIN_FOLLOW,self,0)
	
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

	
	if damagetype == DMG_REMOVENORAGDOLL then
		self:Remove(dmginfo)
	end

		if self.DeathSounds then
			self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
		end
		self:DoDeathAnimation(self.DeathSequences[math.random(#self.DeathSequences)])
	
end

function ENT:OnPathTimeOut()
	local target = self:GetTarget()
	if CurTime() < self.NextAction then return end
	if !self:IsAttackBlocked() and self:TargetInRange(250)then
			if target:IsPlayer() then
				self:DoSpecialAnimation("shriek1")
				self.NextAction = CurTime() + math.random(5, 12)
			end
	end
end

function ENT:PostDeath(dmginfo) 
	self:StopSound("nz_moo/zombies/vox/_napalm/evt_napalm_zombie_loop.wav")
	
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
	if CurTime() > self.NextAction and !self.CanExplode then
		self.CanExplode = true
	end
	if self:TargetInRange(100) and !self:IsAttackBlocked() and self:IsFacingTarget() and self.CanExplode and !self.IsTurned and self:Health() < 200 then
		self.Suicide = true
		self:DoSpecialAnimation(self.ExplodeAttackSequences[math.random(#self.ExplodeAttackSequences)])
	end
	if self:Health() < 200 then
		self.Sprint = true
		self:SetRunSpeed(250)
		self:SpeedChanged()
	end
end

function ENT:OnTargetInAttackRange()
	if !self:GetBlockAttack() and !self.CanExplode and !self.UsingFlamethrower or self.IsTurned then
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
		self:Remove()
	end
end

function ENT:StartToasting()
	self.UsingFlamethrower = true
	if self.UsingFlamethrower then
		--print("THOSE TAKIS WERE HOOOOOOOOOOOOOOOOT")

		if not FIREFIRE then
		    ParticleEffectAttach("bo3_panzer_flame",PATTACH_POINT_FOLLOW,self,1)
			self:EmitSound("enemies/bosses/nap/spawn.ogg")
			self:EmitSound("enemies/bosses/shrieker/scream.ogg")
			self:EmitSound("nz_moo/zombies/vox/_mechz/flame/start.mp3",95, math.random(85, 105))
			self:EmitSound("nz_moo/zombies/vox/_mechz/flame/loop.wav",100, 100)
			FIREFIRE = true
		end

		
		if !self.NextFireParticle or self.NextFireParticle < CurTime() then
			local bone = self:GetAttachment(self:LookupAttachment("MADE_BY_ROACH"))
			pos = bone.Pos
			local mins = Vector(0, -8, -15)
			local maxs = Vector(325, 20, 15)
			local tr = util.TraceHull({
				start = pos,
				endpos = pos + bone.Ang:Forward()*500,
				filter = self,
				mask = MASK_PLAYERSOLID,
				collisiongroup = COLLISION_GROUP_INTERACTIVE_DEBRIS,
				ignoreworld = true,
				mins = mins,
				maxs = maxs,
			})
		
			debugoverlay.BoxAngles(pos, mins, maxs, bone.Ang, 1, Color( 255, 255, 255, 10))
					
			if self:IsValidTarget(tr.Entity) then
				local dmg = DamageInfo()
				dmg:SetAttacker(self)
				dmg:SetInflictor(self)
				dmg:SetDamage(3)
				dmg:SetDamageType(DMG_BURN)
						
				tr.Entity:TakeDamageInfo(dmg)
				tr.Entity:Ignite(5, 0)
			end
		end
		self.NextFireParticle = CurTime() + 0.05
	end
end

function ENT:StopToasting()
	if self.UsingFlamethrower then
		--print("I'm no longer Nintoasting.")
		if FIREFIRE then
			self:StopSound("nz_moo/zombies/vox/_mechz/flame/loop.wav")
			FIREFIRE = false
		end
		self.UsingFlamethrower = false
		self:StopParticles()
		ParticleEffectAttach("firestaff_victim_burning",PATTACH_ABSORIGIN_FOLLOW,self,0)
	end
end


function ENT:HandleAnimEvent(a,b,c,d,e) -- Moo Mark 4/14/23: You don't know how sad I am that I didn't know about this sooner.
	if e == "r" then
		self:EmitSound(self.FootstepsSounds[math.random(#self.FootstepsSounds)], 85)
		self:EmitSound(self.SWTFootstepsSounds[math.random(#self.SWTFootstepsSounds)], 70)
	end
	if e == "l" then
		self:EmitSound(self.FootstepsSounds[math.random(#self.FootstepsSounds)], 85)
		self:EmitSound(self.SWTFootstepsSounds[math.random(#self.SWTFootstepsSounds)], 70)
	end
	if e == "taki_fire" then
		self:StartToasting()
	end
	if e == "taki_cease" then
		self:StopToasting()
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
