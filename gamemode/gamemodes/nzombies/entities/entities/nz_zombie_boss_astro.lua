AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Astronaut(Assdonut) or THE CYCLOPS"
ENT.Category = "Brainz"
ENT.Author = "Laby and GhostlyMoo"

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.RedEyes = false
ENT.SpeedBasedSequences = true

ENT.IsMooZombie = true
ENT.IsMooSpecial = true
ENT.MooSpecialZombie = true -- They're a Special Zombie, but is still close enough to a normal zombie to be able to do normal zombie things.
ENT.IsMooBossZombie = true

ENT.AttackRange = 72

ENT.TraversalCheckRange = 40

ENT.Models = {
	{Model = "models/moo/_codz_ports/t7/moon/moo_codz_t7_moon_assdonut.mdl", Skin = 0, Bodygroups = {0,0}},
}

ENT.BarricadeTearSequences = {
	"nz_legacy_door_tear_high",
	"nz_legacy_door_tear_low",
	"nz_legacy_door_tear_left",
	"nz_legacy_door_tear_right",
}

local JumpSequences = {
	{seq = "nz_barricade_trav_walk_1"},
	{seq = "nz_barricade_trav_walk_2"},
	{seq = "nz_barricade_trav_walk_3"},
}

local walksounds = {
	Sound("nz_moo/zombies/vox/_astro/amb_vox/amb_00.mp3"),
	Sound("nz_moo/zombies/vox/_astro/amb_vox/amb_01.mp3"),
	Sound("nz_moo/zombies/vox/_astro/amb_vox/amb_02.mp3"),
	Sound("nz_moo/zombies/vox/_astro/amb_vox/amb_03.mp3"),
}

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			MovementSequence = {
				"nz_astro_walk_v1",
				"nz_astro_walk_v2",
			},
			BlackholeMovementSequence = {
				"nz_blackhole_1",
				"nz_blackhole_2",
				"nz_blackhole_3",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 70, Sequences = {
		{
			MovementSequence = {
				"nz_supersprint_lowg",
				"nz_supersprint_lowg",
				"nz_supersprint_lowg",
				"nz_supersprint_lowg",
				"nz_supersprint_lowg",
				"nz_supersprint_lowg",
				"nz_supersprint_lowg",
				"nz_supersprint_lowg",
				"nz_supersprint_lowg",
				"nz_l4d_run_04",
				"nz_s1_zom_core_sprint_6",
			},
			BlackholeMovementSequence = {
				"nz_blackhole_1",
				"nz_blackhole_2",
				"nz_blackhole_3",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}}
}

ENT.DeathSounds = {
	"nz_moo/zombies/vox/mute_00.wav"
}

ENT.CustomWalkFootstepsSounds = {
	"nz_moo/zombies/vox/_astro/fly_step/step_00.mp3",
	"nz_moo/zombies/vox/_astro/fly_step/step_01.mp3",
	"nz_moo/zombies/vox/_astro/fly_step/step_02.mp3",
	"nz_moo/zombies/vox/_astro/fly_step/step_03.mp3",
	"nz_moo/zombies/vox/_astro/fly_step/step_04.mp3",
	"nz_moo/zombies/vox/_astro/fly_step/step_05.mp3",
	"nz_moo/zombies/vox/_astro/fly_step/step_06.mp3",
	"nz_moo/zombies/vox/_astro/fly_step/step_07.mp3",
	"nz_moo/zombies/vox/_astro/fly_step/step_08.mp3",
	"nz_moo/zombies/vox/_astro/fly_step/step_09.mp3"
}

ENT.CustomRunFootstepsSounds = {
	"nz_moo/zombies/vox/_astro/fly_step/step_00.mp3",
	"nz_moo/zombies/vox/_astro/fly_step/step_01.mp3",
	"nz_moo/zombies/vox/_astro/fly_step/step_02.mp3",
	"nz_moo/zombies/vox/_astro/fly_step/step_03.mp3",
	"nz_moo/zombies/vox/_astro/fly_step/step_04.mp3",
	"nz_moo/zombies/vox/_astro/fly_step/step_05.mp3",
	"nz_moo/zombies/vox/_astro/fly_step/step_06.mp3",
	"nz_moo/zombies/vox/_astro/fly_step/step_07.mp3",
	"nz_moo/zombies/vox/_astro/fly_step/step_08.mp3",
	"nz_moo/zombies/vox/_astro/fly_step/step_09.mp3"
}

ENT.BehindSoundDistance = 0 -- When the zombie is within 200 units of a player, play these sounds instead

function ENT:StatsInitialize()
	if SERVER then
		local count = #player.GetAllPlaying()
		local hp = nzRound:GetZombieHealth()

		if nzRound:InState( ROUND_CREATE ) then
			self:SetHealth(5000)
			self:SetMaxHealth(5000)
		else
			if nzRound:InState( ROUND_PROG ) then
				self:SetHealth(math.Clamp(hp * 4 * count, 1000, 60000 * count))
				self:SetMaxHealth(math.Clamp(hp * 4 * count, 1000, 60000 * count))
			else
				self:SetHealth(5000)
				self:SetMaxHealth(5000)	
			end
		end

		self:SetRunSpeed(35)

		grabbing = false
		gobyebye = false
		trexarms = 0
		malding = false
	end
end

function ENT:SpecialInit()
	if CLIENT then
	end
end

function ENT:OnSpawn()
	--self:EmitSound("nz_moo/zombies/vox/_astro/spawn_flux.mp3", 511, math.random(95, 105))
	self:EmitSound("nz_moo/zombies/vox/_astro/breath.wav", 75, math.random(95, 105), 1, 3)
	ParticleEffect("bo3_astronaut_pulse",self:LocalToWorld(Vector(0,0,50)),Angle(0,0,0),nil)
end

function ENT:PerformDeath(dmgInfo)
	self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
	self:StopSound("nz_moo/zombies/vox/_astro/breath.wav")
	self:Explode(0)
	self:Remove(dmgInfo)
end

function ENT:OnRemove()
	self:StopSound("nz_moo/zombies/vox/_astro/breath.wav")
end

function ENT:IsValidTarget( ent )
	if !ent then return false end
	return IsValid(ent) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
	-- Won't go for special targets (Monkeys), but still MAX, ALWAYS and so on
end

function ENT:OnThink()
	if self:TargetInAttackRange() then
		if SERVER then
		end
	end
end

if SERVER then
	function ENT:GetFleeDestination(target) -- Get the place where we are fleeing to, added by: Ethorbit
		return self:GetPos() + (self:GetPos() - target:GetPos()):GetNormalized() * (self.FleeDistance or 300)
	end

	function ENT:RunBehaviour()

		self:Retarget()
		self:SpawnZombie()

		while (true) do

			if self.EventMask and not self.DoCollideWhenPossible then
				self:SetSolidMask(MASK_NPCSOLID)
			end
			if !self:GetStop() and self:GetFleeing() then -- Admittedly this was rushed, I took no time to understand how this can be achieved with nextbot pathing so I just made a short navmesh algorithm for fleeing. Sorry. Created by Ethorbit.
				self:SetTimedOut(false)

				local target = self:GetTarget()
				if IsValid(target) then
					self:SetLastFlee(CurTime())
					self:ResetMovementSequence() -- They'll comically slide away if this isn't here.
					self:MoveToPos(self:GetFleeDestination(target), {lookahead = 0, maxage = 3})
					self:SetLastFlee(CurTime())
				end
			end
			if !self:GetFleeing() and !self:GetStop() and CurTime() > self:GetLastFlee() + 2 then
				self:SetTimedOut(false)
				local ct = CurTime()
				if ct >= self.NextRetarget then
					local oldtarget = self.Target
					self:Retarget() --The overall process of looking for targets is handled much like how it is in nZu. While it may not save much fps in solo... Turns out this can vastly help the performance of multiplayer games.
				end
				if not self:HasTarget() and not self:IsValidTarget(self:GetTarget()) then
					self:OnNoTarget()
				else
					local path = self:ChaseTarget()
					if path == "failed" then
						self:SetTargetUnreachable(true)
					end
					if path == "ok" then
						if self:TargetInAttackRange() then
							self:AstroGrab()
						else
							self:TimeOut(0.1)
						end
					elseif path == "timeout" then --asume pathing timedout, maybe we are stuck maybe we are blocked by barricades
						self:SetTargetUnreachable(true)
						self:OnPathTimeOut()
					else
						self:TimeOut(2)
					end
				end
			else
				self:TimeOut(2)
			end
			if not self.NextSound or self.NextSound < CurTime() and not self:GetAttacking() and self:Alive() then
				self:Sound() -- Moo Mark 12/7/22: Moved this out of the THINK function since I thought it was a little stupid.
			end
		end
	end
end

function ENT:AstroGrab()
	--print("Give me your assets.")
	if IsValid(self:GetTarget()) and self:GetTarget():IsPlayer() then
		if malding then
			self:GetTarget():NZAstroSlow(3)
		else
			self:GetTarget():NZAstroSlow(2)
		end
	end

	self:PlaySequenceAndWait("nz_astro_headbutt", 1, self.FaceEnemy)
	if self:TargetInAttackRange() then
		local target = self:GetTarget()

		--print("You go to brazil now.")
		if IsValid(target) then
			self:EmitSound("weapons/tfa_bo3/gersch/gersh_teleport.wav",511)
			local d = DamageInfo()
			d:SetDamage( target:Health() - 90 )
			d:SetAttacker( self )
			d:SetDamageType( DMG_VEHICLE ) 
			target:TakeDamageInfo( d )
		end
		if self:GetTarget():IsPlayer() then
			self:GetTarget():ViewPunch( VectorRand():Angle() * 0.1 )
		end
		if malding then
			--print("He's no longer malding.")
			self:SetRunSpeed(35)
			self:SpeedChanged()
			malding = false
			trexarms = 0
		end
	else
		self:PlaySequenceAndWait("nz_astro_headbutt_release")
		trexarms = trexarms + 1
		if trexarms > 2 and not malding then -- If you somehow manage to make him mald unintentionally... You're bad at video games.
			print("Look what you've done Yoshi... You've angered the Scuba Diver.")
			--print("F L I N T L O C K W O O D ! ! !")
			self:SetRunSpeed(70)
			self:SpeedChanged()
			malding = true
		end
	end
end


function ENT:Explode(dmg, suicide)
    for k, v in pairs(ents.FindInSphere(self:GetPos(), 250)) do
        if not v:IsWorld() and v:IsSolid() then
            v:SetVelocity(((v:GetPos() - self:GetPos()):GetNormalized()*175) + v:GetUp()*225)
            
            if v:IsValidZombie() then
                if v == self then continue end
                if v:EntIndex() == self:EntIndex() then continue end
                if v:Health() <= 0 then continue end
                if !v:Alive() then continue end
                local damage = DamageInfo()
                damage:SetAttacker(self)
                damage:SetDamageType(DMG_MISSILEDEFENSE)
                damage:SetDamage(v:Health() + 666)
                damage:SetDamageForce(v:GetUp()*22000 + (v:GetPos() - self:GetPos()):GetNormalized() * 10000)
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
	self:EmitSound("nz_moo/zombies/vox/_astro/death/astro_pop.mp3", 511, math.random(95, 105))
	self:EmitSound("nz_moo/zombies/vox/_astro/death/astro_flux.mp3", 511, math.random(95, 105))
    if suicide then self:TakeDamage(self:Health() + 666, self, self) end
end

function ENT:ZombieStatusEffects()
	if CurTime() > self.LastStatusUpdate then
		if !self:Alive() then return end
		if self:GetSpecialAnimation() then return end

		if self.IsAATTurned and self:IsAATTurned() then
			self:TimeOut(0)
			self:SetSpecialShouldDie(true)
			self:PlaySound(self.AstroDanceSounds[math.random(#self.AstroDanceSounds)], 511)
			self:DoSpecialAnimation(self.DanceSequences[math.random(#self.DanceSequences)])
		end

		self.LastStatusUpdate = CurTime() + 0.25
	end
end
ENT.AstroDanceSounds = {
	Sound("nz_moo/effects/aats/turned/drip.mp3"),
}

function ENT:HandleAnimEvent(a,b,c,d,e) -- Moo Mark 4/14/23: You don't know how sad I am that I didn't know about this sooner.
	if e == "step_right_small" or e == "step_left_small" then
		if self.CustomWalkFootstepsSounds then
			self:EmitSound(self.CustomWalkFootstepsSounds[math.random(#self.CustomWalkFootstepsSounds)], 75)
		else
			self:EmitSound("CoDZ_Zombie.StepWalk")
		end
	end
	if e == "step_right_large" or e == "step_left_large" then
		if self.CustomRunFootstepsSounds then
			self:EmitSound(self.CustomRunFootstepsSounds[math.random(#self.CustomRunFootstepsSounds)], 75)
		else
			self:EmitSound("CoDZ_Zombie.StepRun")
		end
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

	if e == "astro_grab" then
		self:EmitSound("nz_moo/zombies/vox/_astro/grab/grab_0"..math.random(0,1)..".mp3", 100)
	end
	if e == "astro_swell" then
		self:EmitSound("nz_moo/zombies/vox/_astro/grab/static_swell.mp3", 100)
	end
end
