AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "flying space chicken"
ENT.Category = "Brainz"
ENT.Author = "Laby"

game.AddParticles("particles/gigan_laser.pcf")
	PrecacheParticleSystem("gigan_laser")

if CLIENT then 

    function ENT:DrawEyeGlow()
        local eyeColor = Color(0,0,0)
        local nocolor = Color(0,0,0)

        if eyeColor == nocolor then return end
    end

    return 
end -- Client doesn't really need anything beyond the basics

local util_traceline = util.TraceLine
local util_tracehull = util.TraceHull

ENT.RedEyes = false
ENT.SpeedBasedSequences = true

ENT.IsMooZombie = true
ENT.IsMooSpecial = true
ENT.IsMooBossZombie = true

ENT.AttackRange = 130
ENT.DamageRange = 130

ENT.AttackDamage = 50
ENT.HeavyAttackDamage = 95

ENT.MinSoundPitch = 95
ENT.MaxSoundPitch = 105

ENT.SoundDelayMin = 10
ENT.SoundDelayMax = 12

ENT.Models = {
	{Model = "models/bosses/nz_gigan.mdl", Skin = 0, Bodygroups = {0,0}},
}

ENT.DeathSequences = {
	"nz_raz_death_collapse_fallback_1",
	"nz_raz_death_collapse_fallback_2",
	"nz_raz_death_collapse_fallforward_1",
}

ENT.BarricadeTearSequences = {}

local JumpSequences = {
	{seq = "nz_raz_mantle_over_36"},
}

local AttackSequences = {
	{seq = "nz_raz_attack_double_swing_1"},
	{seq = "nz_raz_attack_double_swing_2"},
	{seq = "nz_raz_attack_swing_l_to_r"},
	{seq = "nz_raz_attack_swing_r_to_l"},
	{seq = "nz_raz_attack_sickle_double_swing_1"},
	{seq = "nz_raz_attack_sickle_double_swing_2"},
	{seq = "nz_raz_attack_sickle_double_swing_3"},
	{seq = "nz_raz_attack_sickle_swing_down"},
	{seq = "nz_raz_attack_sickle_swing_l_to_r"},
	{seq = "nz_raz_attack_sickle_swing_r_to_l"},
	{seq = "nz_raz_attack_sickle_swing_uppercut"},
}

local RunAttackSequences = {
	{seq = "nz_raz_attack_sprint"},
}

local walksounds = {
	Sound("enemies/bosses/gigan/Roar 1.mp3"),
	Sound("enemies/bosses/gigan/Roar 2.mp3"),
	Sound("enemies/bosses/gigan/Roar 3.mp3"),
	Sound("enemies/bosses/gigan/Roar 4.mp3"),
	Sound("enemies/bosses/gigan/Roar 5.mp3"),
	Sound("enemies/bosses/gigan/Roar 6.mp3"),
	Sound("enemies/bosses/gigan/Roar 7.mp3"),
	Sound("enemies/bosses/gigan/Roar 8.mp3"),
	Sound("enemies/bosses/gigan/Roar 9.mp3"),
	Sound("enemies/bosses/gigan/Roar 10.mp3"),
	Sound("enemies/bosses/gigan/Roar 11.mp3"),
	Sound("enemies/bosses/gigan/Roar 12.mp3"),
	Sound("enemies/bosses/gigan/Roar 13.mp3"),
	Sound("enemies/bosses/gigan/Roar 14.mp3"),
	Sound("enemies/bosses/gigan/Roar 15.mp3"),
	Sound("enemies/bosses/gigan/Roar 16.mp3"),
	Sound("enemies/bosses/gigan/Roar 17.mp3"),
	Sound("enemies/bosses/gigan/Roar 18.mp3"),
}

ENT.NormalMantleOver48 = {
	"nz_raz_mantle_over_48",
}

ENT.NormalMantleOver72 = {
	"nz_raz_mantle_over_72",
}

ENT.NormalMantleOver96 = {
	"nz_raz_mantle_over_96",
}

ENT.NormalMantleOver128 = {
	"nz_raz_mantle_over_128",
}

ENT.NormalJumpUp128 = {
	"nz_raz_jump_up_128",
}

ENT.NormalJumpUp128Quick = {
	"nz_raz_jump_up_128",
}

ENT.NormalJumpDown128 = {
	"nz_raz_jump_down_128",
}

ENT.ShootSequences = {
	"nz_gigan_blast"
}

ENT.IdleSequence = "nz_raz_idle"
ENT.IdleSequenceAU = "nz_raz_idle_look_around"

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			MovementSequence = {
				"nz_raz_walk",
			},
			StandAttackSequences = {AttackSequences},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 71, Sequences = {
		{
			MovementSequence = {
				--"nz_raz_sprint",
				"nz_t9_raz_sprint",
			},
			StandAttackSequences = {AttackSequences},
			AttackSequences = {RunAttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}}
}

ENT.EnrageSounds = {
	Sound("enemies/bosses/gigan/Roar 3.mp3"),
}

ENT.CustomMeleeWhooshSounds = {
	Sound("nz_moo/zombies/vox/_raz/melee/swing/melee_swing_00.mp3"),
	Sound("nz_moo/zombies/vox/_raz/melee/swing/melee_swing_01.mp3"),
	Sound("nz_moo/zombies/vox/_raz/melee/swing/melee_swing_02.mp3"),
	Sound("nz_moo/zombies/vox/_raz/melee/swing/melee_swing_03.mp3"),
}

ENT.WalkFootstepsSounds = {
	Sound("enemies/bosses/gigan/Footstep 1.mp3"),
	Sound("enemies/bosses/gigan/Footstep 2.mp3"),
	Sound("enemies/bosses/gigan/Footstep 3.mp3")
}


ENT.ArmCannonShootSounds = {
	Sound("enemies/bosses/gigan/Laser.mp3")

}

ENT.PainSounds = {
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/pain/pain_00.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/pain/pain_01.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/pain/pain_02.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/pain/pain_03.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/pain/pain_04.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/pain/pain_05.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/pain/pain_06.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/pain/pain_07.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/pain/pain_08.mp3"),
	Sound("nz_moo/zombies/vox/_raz/_t9/voxt9/pain/pain_09.mp3"),
}

ENT.DeathSounds = {
	Sound("enemies/bosses/gigan/Death Roar.mp3")
}

ENT.DeathExploSounds = {
	Sound("nz_moo/zombies/vox/_raz/death/warlord_death_00.mp3"),
	Sound("nz_moo/zombies/vox/_raz/death/warlord_death_01.mp3"),
	Sound("nz_moo/zombies/vox/_raz/death/warlord_death_02.mp3"),
	Sound("nz_moo/zombies/vox/_raz/death/warlord_death_03.mp3"),
}


ENT.MangleTauntSounds = {
	Sound("enemies/bosses/gigan/Laugh 1.mp3"),
	Sound("enemies/bosses/gigan/Laugh 2.mp3"),
}


ENT.AttackSounds = {
	Sound("enemies/bosses/gigan/Fight 1.mp3"),
	Sound("enemies/bosses/gigan/Fight 2.mp3"),
	Sound("enemies/bosses/gigan/Fight 3.mp3"),
	Sound("enemies/bosses/gigan/Fight 4.mp3"),
	Sound("enemies/bosses/gigan/Fight 10.mp3"),
	Sound("enemies/bosses/gigan/Fight 11.mp3"),
	Sound("enemies/bosses/gigan/Fight 14.mp3"),
	Sound("enemies/bosses/gigan/Fight 15.mp3"),
	Sound("enemies/bosses/gigan/Fight 16.mp3"),
	Sound("enemies/bosses/gigan/Fight 17.mp3"),
	Sound("enemies/bosses/gigan/Fight 18.mp3"),
	Sound("enemies/bosses/gigan/Fight 21.mp3"),
	Sound("enemies/bosses/gigan/Fight 26.mp3"),
	Sound("enemies/bosses/gigan/Fight 27.mp3"),
	Sound("enemies/bosses/gigan/Fight 28.mp3"),
	Sound("enemies/bosses/gigan/Fight 29.mp3")
}


ENT.BehindSoundDistance = 0 -- When the zombie is within 200 units of a player, play these sounds instead

function ENT:StatsInitialize()
	if SERVER then
		local count = #player.GetAllPlaying()

		if nzRound:InState( ROUND_CREATE ) then
			self:SetHealth(1000)
			self:SetMaxHealth(1000)
		else
			if nzRound:InState( ROUND_PROG ) then
				self:SetHealth(math.Clamp(nzRound:GetNumber() * 950 + (500 * count), 1000, 55000 * count))
				self:SetMaxHealth(math.Clamp(nzRound:GetNumber() * 950 + (500 * count), 1000, 55000 * count))
			else
				self:SetHealth(5000)
				self:SetMaxHealth(5000)	
			end
		end

		self.NextShoot = CurTime() + 3
		self.ArmCannon = true
		self.ArmCannonHP = math.Clamp(self:GetMaxHealth() / 4, 250, 1500)

		self.Helmet = true
		self.HelmetHP = math.Clamp(self:GetMaxHealth() / 5, 250, 1000)

		self.Chest = true
		self.ChestHP = math.Clamp(self:GetMaxHealth() / 5, 250, 1000)

		self.ShouldEnrage = false
		self.Enraged = false

		self.RadioSoundTime = CurTime() + 5

		self.CannonInspect = CurTime() + 5

	

		self:SetRunSpeed(1)
	end
end

function ENT:SpecialInit()
	if CLIENT then
	end
end

function ENT:OnSpawn()
	self:SetCollisionBounds(Vector(-22,-22, 0), Vector(22, 22, 80))

	local effectData = EffectData()
	effectData:SetOrigin( self:GetPos() + Vector(0, 0, 50)  )
	effectData:SetMagnitude( 1 )
	effectData:SetEntity(nil)
	util.Effect("panzer_spawn_tp", effectData)
	
	self:SolidMaskDuringEvent(MASK_SOLID_BRUSHONLY)

	self:EmitSound("enemies/bosses/gigan/Awakens.mp3", 577)

	self:TimeOut(2)

	self:CollideWhenPossible()
end


function ENT:AI()
	if CurTime() > self.NextShoot and self.ArmCannon then
		if !self:IsAttackBlocked() and self:TargetInRange(500) and !self:TargetInRange(150) then
			self:TempBehaveThread(function(self)
				self.NextShoot = CurTime() + math.random(7,10)

				self:SetSpecialAnimation(true)
				self:PlaySequenceAndMove(self.ShootSequences[math.random(#self.ShootSequences)], 1, self.FaceEnemy)
				self:StopParticles()
				self:SetSpecialAnimation(false)
			end)
		end
	end


	-- Stim Inspect
	if CurTime() > self.CannonInspect and self.ArmCannon and !self:HasTarget() then
		self:EmitSound("enemies/bosses/gigan/Fight 26.mp3",75)
		self:DoSpecialAnimation("nz_raz_idle_twitch_check")
		self.CannonInspect = CurTime() + math.random(8,15)
	end
end

function ENT:Sound()
	if self:GetAttacking() or !self:Alive() or self:GetDecapitated() then return end

	local vol = self.SoundVolume

	local chance = math.random(100)

	for k,v in nzLevel.GetZombieArray() do -- FUCK YOU, ARRAYS ARE AWESOME!!!
		if k < 2 then vol = 511 else vol = self.SoundVolume end
	end

	if !self:HasTarget() then
		self:PlaySound(self.MangleTauntSounds[math.random(#self.MangleTauntSounds)],vol, math.random(self.MinSoundPitch, self.MaxSoundPitch), 1, 2)
	elseif chance < 25 then
		self:PlaySound(self.MangleTauntSounds[math.random(#self.MangleTauntSounds)],vol, math.random(self.MinSoundPitch, self.MaxSoundPitch), 1, 2)
	elseif self.PassiveSounds then
		self:PlaySound(self.PassiveSounds[math.random(#self.PassiveSounds)],vol, math.random(self.MinSoundPitch, self.MaxSoundPitch), 1, 2)
	else

		-- We still delay by max sound delay even if there was no sound to play
		self.NextSound = CurTime() + self.SoundDelayMax
	end
end

function ENT:PerformDeath(dmginfo)
		
	self.Dying = true

	local damagetype = dmginfo:GetDamageType()

	self:PostDeath(dmginfo)

	self:PlaySound(self.PainSounds[math.random(#self.PainSounds)], 90, math.random(85, 105), 1, 2)
	self:Explode(25)

	ParticleEffectAttach("bo3_explosion_micro", PATTACH_POINT_FOLLOW, self, 9)

	if damagetype == DMG_MISSILEDEFENSE or damagetype == DMG_ENERGYBEAM then
		self:BecomeRagdoll(dmginfo) -- Only Thundergun and Wavegun Ragdolls constantly.
	end
	if damagetype == DMG_REMOVENORAGDOLL then
		self:Remove(dmginfo)
	end
	if self.DeathRagdollForce == 0 or self:GetSpecialAnimation() then
		self:BecomeRagdoll(dmginfo)
	else
		self:DoDeathAnimation(self.DeathSequences[math.random(#self.DeathSequences)])
	end
end

function ENT:Explode(dmg)
    dmg = dmg or 50

    if SERVER then
        local pos = self:WorldSpaceCenter()
        local targ = self:GetTarget()

        local attacker = self
        local inflictor = self

       	if IsValid(targ) and targ.GetActiveWeapon then
            attacker = targ
            if IsValid(targ:GetActiveWeapon()) then
                inflictor = targ:GetActiveWeapon()
            end
        end

        local tr = {
            start = pos,
            filter = self,
            mask = MASK_NPCSOLID_BRUSHONLY
        }

        for k, v in pairs(ents.FindInSphere(pos, 200)) do
            if v:IsPlayer() or v:IsNPC() or v:IsNextBot() then
                if v:GetClass() == self:GetClass() then continue end
                if v == self then continue end
                if v:EntIndex() == self:EntIndex() then continue end
                if v:Health() <= 0 then continue end
                --if !v:Alive() then continue end
                tr.endpos = v:WorldSpaceCenter()
                local tr1 = util_traceline(tr)
                if tr1.HitWorld then continue end

                local expdamage = DamageInfo()
                expdamage:SetAttacker(attacker)
                expdamage:SetInflictor(inflictor)
                expdamage:SetDamageType(DMG_BLAST)

                local distfac = pos:Distance(v:WorldSpaceCenter())
                distfac = 1 - math.Clamp((distfac/200), 0, 1)
                expdamage:SetDamage(dmg * distfac)

                expdamage:SetDamageForce(v:GetUp()*5000 + (v:GetPos() - self:GetPos()):GetNormalized() * 10000)

                v:TakeDamageInfo(expdamage)
            end
        end

        local effectdata = EffectData()
        effectdata:SetOrigin(self:GetPos())

       util.Effect("HelicopterMegaBomb", effectdata)
        util.Effect("Explosion", effectdata)

        self:EmitSound(self.DeathSounds[math.random(#self.DeathSounds)],70)

        util.ScreenShake(self:GetPos(), 20, 255, 1.5, 400)
    end
end

function ENT:OnTakeDamage(dmginfo)
	local attacker = dmginfo:GetAttacker()
	local inflictor = dmginfo:GetInflictor()

	local hitpos = dmginfo:GetDamagePosition()
	local hitgroup = util.QuickTrace(hitpos, hitpos).HitGroup
	local hitforce = dmginfo:GetDamageForce()

	local damage = dmginfo:GetDamage()

	local armpos = self:GetBonePosition(self:LookupBone("j_weapon_spin"))
	local headpos = self:GetBonePosition(self:LookupBone("j_head_attach"))
	local chestpos = self:GetBonePosition(self:LookupBone("j_spine4_attach"))

	if (hitpos:DistToSqr(headpos) < 20^2) then
		if self.Helmet and self.HelmetHP > 0 then
			self.HelmetHP = self.HelmetHP - damage
			dmginfo:ScaleDamage(0.15)
		elseif self.Helmet and self.HelmetHP <= 0 then
			self.Helmet = false
			
        	self:EmitSound(self.DeathSounds[math.random(#self.DeathSounds)],70)

			self:ManipulateBoneScale(self:LookupBone("j_head_attach"), Vector(0.00001,0.00001,0.00001))
			ParticleEffectAttach("bo3_explosion_micro", PATTACH_POINT_FOLLOW, self, 10)


			self:TempBehaveThread(function(self)
				self:SetSpecialAnimation(true)
				self:PlaySequenceAndMove("nz_raz_pain_mangler", 1)
				self:PlaySequenceAndMove("nz_raz_enrage", 1)
				self:SetSpecialAnimation(false)
			end)
		else
			dmginfo:ScaleDamage(0.25)
		end
	end


end

function ENT:OnGameOver()
	if !self.yousuck then
		self.yousuck = true
		self:DoSpecialAnimation("nz_t9_raz_com_summon")
	end
end

function ENT:ArmCannonSpark() -- Copy and Paste of George's Stagelight spark code.
	local spark = ents.Create("env_spark")
	spark:SetOwner(self)
	spark:SetParent(self)
	spark:SetLocalPos(self:GetPos())
	spark:SetKeyValue("MaxDelay","3")
	spark:SetKeyValue("Magnitude","2")
	spark:SetKeyValue("TrailLength","2")
	spark:Fire("setparentattachment", "weapon_fx_tag")
	spark:Spawn()
	spark:Activate()
	spark:Fire("SparkOnce" ,"", 0)
	if IsValid(spark) then
		spark:Remove() -- Removes the spark when its done... Important because the spark entities wouldn't go away otherwise.
	end
end

function ENT:IsValidTarget( ent )
	if !ent then return false end
	return IsValid(ent) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
	-- Won't go for special targets (Monkeys), but still MAX, ALWAYS and so on
end

function ENT:HandleAnimEvent(a,b,c,d,e) -- Moo Mark 4/14/23: You don't know how sad I am that I didn't know about this sooner.
	if e == "step_right_small" or e == "step_left_small" or e == "step_right_large" or e == "step_left_large" then
		util.ScreenShake(self:GetPos(),1,1,0.2,450)
		self:EmitSound(self.WalkFootstepsSounds[math.random(#self.WalkFootstepsSounds)], 70)
	end
	if e == "melee_whoosh" then
		if self.CustomMeleeWhooshSounds then
			self:EmitSound(self.CustomMeleeWhooshSounds[math.random(#self.CustomMeleeWhooshSounds)], 80)
		else
			self:EmitSound(self.MeleeWhooshSounds[math.random(#self.MeleeWhooshSounds)], 80)
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

	if e == "raz_charge" then
		self:EmitSound(self.EnrageSounds[math.random(#self.EnrageSounds)], 100, math.random(85, 105), 1, 2)
		self:EmitSound("enemies/bosses/gigan/Chargeup.mp3")
	end
	if e == "raz_shoot" then
		
		self:EmitSound(self.ArmCannonShootSounds[math.random(#self.ArmCannonShootSounds)], 90)
		--ParticleEffectAttach("bo3_mangler_blast", PATTACH_POINT_FOLLOW, self, 13)

		self:Retarget()

		local visor = self:GetBonePosition(self:LookupBone("j_chin_jaw"))
		local target = self:GetTarget()

		if IsValid(target) then
				util.ParticleTracerEx("gigan_laser",
				(visor - Vector(50,0,0)),(target:GetPos() - Vector(0,0,20)),
				false,self:EntIndex(),13)
			
			 for k, v in pairs(ents.FindInSphere(target:GetPos() - Vector(0,0,20), 250)) do
            if v:IsPlayer() or v:IsNPC() or v:IsNextBot() then
                if v:GetClass() == self:GetClass() then continue end
                if v == self then continue end
                if v:EntIndex() == self:EntIndex() then continue end
                if v:Health() <= 0 then continue end
                --if !v:Alive() then continue end


                local expdamage = DamageInfo()
                expdamage:SetAttacker(self)
                expdamage:SetInflictor(self)
                expdamage:SetDamageType(DMG_BURN)

                
                expdamage:SetDamage(21)

                --expdamage:SetDamageForce(1000)

                v:TakeDamageInfo(expdamage)
            end
        end

        local effectdata = EffectData()
        effectdata:SetOrigin(target:GetPos() - Vector(0,0,20))

      -- util.Effect("HelicopterMegaBomb", effectdata)
        --util.Effect("Explosion", effectdata)

        util.ScreenShake(target:GetPos() - Vector(0,0,20), 20, 255, 1.5, 400)
		
			
		end

	end


	if e == "raz_enrage" then
		self:EmitSound(self.EnrageSounds[math.random(#self.EnrageSounds)], 100, math.random(85, 105), 1, 2)
		self:SetRunSpeed(71)
		self:SpeedChanged()
	end

	if e == "raz_taunt" then
		self.NextSound = CurTime() + self.SoundDelayMax
		self:EmitSound(self.MangleTauntSounds[math.random(#self.MangleTauntSounds)], 100, math.random(85, 105), 1, 2)
	end


	if e == "raz_idle_click" then
		ParticleEffectAttach("doom_mancu_blast", PATTACH_POINT_FOLLOW, self, 13)
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
	if e == "remove_zombie" then
		self:Remove()
	end
end