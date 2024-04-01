AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Don't tell him about Hillturr"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo and (Seth Norris Originally)"

function ENT:InitDataTables()
	self:NetworkVar("Bool", 5, "IsIdle")
	self:NetworkVar("Bool", 6, "IsEnraged")
end

if CLIENT then 
	local eyeglow =  Material("nz/zlight")
	function ENT:Draw() //Runs every frame
		self:DrawModel()
		if self:Alive() then
			self:DrawEyeGlow()
		end

		self:EffectsAndSounds()

		if self:Alive() then
			local elight = DynamicLight( self:EntIndex(), true )
			if ( elight ) then
				local bone = self:LookupBone("j_spineupper")
				local pos = self:GetBonePosition(bone)
				pos = pos 
				elight.pos = pos
				elight.r = 0
				elight.g = 75
				elight.b = 255
				elight.brightness = 8
				elight.Decay = 1000
				elight.Size = 40
				elight.DieTime = CurTime() + 1
				elight.style = 0
				elight.noworld = true
			end
		end

		if GetConVar( "nz_zombie_debug" ):GetBool() then
			render.DrawWireframeBox(self:GetPos(), Angle(0,0,0), self:OBBMins(), self:OBBMaxs(), Color(255,0,0), true)
		end
	end

	function ENT:EffectsAndSounds()
		if self:Alive() then
			-- Credit: FlamingFox for Code and fighting the PVS monster -- 
			if !IsValid(self) then return end
			if !self.Draw_FX or !IsValid(self.Draw_FX) then -- PVS will no longer eat the particle effect.
				self.Draw_FX = CreateParticleSystem(self, "adorabolf_aura", PATTACH_POINT_FOLLOW, 1)
			end

			-- Ambient looping sounds.
			if self:GetIsIdle() and !self:GetIsEnraged() and (!self.IdleAmbience or !IsValid(self.IdleAmbience)) then
				self.IdleAmbience = "nz_moo/zombies/vox/_hilter/adolf_hitler_loop.wav"

				if self.EnragedAmbience or IsValid(self.EnragedAmbience) then
					self:StopSound(self.EnragedAmbience)
					self.EnragedAmbience = nil
					if self.SelectedRageAmb or IsValid(self.SelectedRageAmb) then
						self.SelectedRageAmb = false
					end
				end
				self:EmitSound(self.IdleAmbience, 70, math.random(95, 105), 1, 3)
			end
			if !self:GetIsIdle() and self:GetIsEnraged() and (!self.EnragedAmbience or !IsValid(self.EnragedAmbience)) then
				if !self.SelectedRageAmb then
					self.SelectedRageAmb = true
					self.EnragedAmbience = "nz_moo/zombies/vox/_hilter/the_chase_"..math.random(1,2)..".wav"
				end
				if self.IdleAmbience or IsValid(self.IdleAmbience) then
					self:StopSound(self.IdleAmbience)
					self.IdleAmbience = nil
				end
				self:EmitSound(self.EnragedAmbience, 80, math.random(95, 105), 1, 3)
			end
		else
			if self.IdleAmbience or self.IdleAmbience:IsValid() then
				self:StopSound(self.IdleAmbience)
				self.IdleAmbience = nil
			end
			if self.EnragedAmbience or self.EnragedAmbience:IsValid() then
				self:StopSound(self.EnragedAmbience)
				self.EnragedAmbience = nil
			end
		end
	end

	function ENT:DrawEyeGlow()
		local eyeColor = Color(200,255,255)

		local latt = self:LookupAttachment("lefteye")
		local ratt = self:LookupAttachment("righteye")

		if latt == nil then return end
		if ratt == nil then return end

		local leye = self:GetAttachment(latt)
		local reye = self:GetAttachment(ratt)

		if leye == nil then return end
		if reye == nil then return end

		local righteyepos = leye.Pos + leye.Ang:Forward()*0.49
		local lefteyepos = reye.Pos + reye.Ang:Forward()*0.49

		if lefteyepos and righteyepos then
			render.SetMaterial(eyeglow)
			render.DrawSprite(lefteyepos, 6, 6, eyeColor)
			render.DrawSprite(righteyepos, 6, 6, eyeColor)
		end
	end
	return 
end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = false
ENT.IsMooSpecial = true
ENT.MooSpecialZombie = true
ENT.IsMooBossZombie = true

ENT.AttackRange = 120

ENT.TraversalCheckRange = 40

ENT.Models = {
	{Model = "models/moo/_codz_ports/t7/_custommaps/returntoherrenhaus/moo_sethnorris_t7_adorabolf.mdl", Skin = 0, Bodygroups = {0,0}},
}

ENT.DeathSequences = {
	"nz_napalm_death_01",
	"nz_napalm_death_02",
	"nz_napalm_death_03",
}

ENT.SuperTauntSequences = {
	"nz_legacy_taunt_v11",
	"nz_legacy_taunt_v11",
}

local AttackSequences = {
	{seq = "nz_napalm_attack_01"},
	{seq = "nz_napalm_attack_02"},
	{seq = "nz_napalm_attack_03"},
}

local RunAttackSequences = {
	{seq = "nz_adorabolf_slam"},
}

local JumpSequences = {
	{seq = "nz_barricade_trav_walk_1"},
	{seq = "nz_barricade_trav_walk_2"},
	{seq = "nz_barricade_trav_walk_3"},
}

local SprintJumpSequences = {
	{seq = "nz_barricade_sprint_1"},
	{seq = "nz_barricade_sprint_2"},
}

local walksounds = {
	Sound("nz_moo/zombies/vox/_hilter/vox/adorabolf_ambient_00.mp3"),
	Sound("nz_moo/zombies/vox/_hilter/vox/adorabolf_ambient_01.mp3"),
	Sound("nz_moo/zombies/vox/_hilter/vox/adorabolf_ambient_02.mp3"),
	Sound("nz_moo/zombies/vox/_hilter/vox/adorabolf_ambient_03.mp3"),
	Sound("nz_moo/zombies/vox/_hilter/vox/adorabolf_ambient_04.mp3"),
	Sound("nz_moo/zombies/vox/_hilter/vox/adorabolf_ambient_05.mp3"),
	Sound("nz_moo/zombies/vox/_hilter/vox/adorabolf_ambient_06.mp3"),
	Sound("nz_moo/zombies/vox/_hilter/vox/adorabolf_ambient_07.mp3"),
	Sound("nz_moo/zombies/vox/_hilter/vox/adorabolf_ambient_08.mp3"),
	Sound("nz_moo/zombies/vox/_hilter/vox/adorabolf_ambient_09.mp3"),
}

local runsounds = {
	Sound("nz_moo/zombies/vox/mute_00.wav"),
}

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			MovementSequence = {
				"nz_napalm_walk_01",
				"nz_napalm_walk_02",
				"nz_napalm_walk_03",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 71, Sequences = {
		{
			MovementSequence = {
				"nz_sonic_run_01",
				"nz_sonic_run_02",
				"nz_sonic_run_03",
				"nz_t9_base_player_sprint_v01",
				"nz_t9_base_player_sprint_v03",
				"nz_t9_base_player_sprint_v07",
				"nz_t9_base_player_sprint_v08",
			},
			AttackSequences = {RunAttackSequences},
			JumpSequences = {SprintJumpSequences},
			PassiveSounds = {runsounds},
		},
	}}
}

ENT.DeathSounds = {
	"nz_moo/zombies/vox/mute_00.wav"
}

ENT.CustomSpecialTauntSounds = {
	Sound("nz_moo/zombies/vox/mute_00.wav"),
}

ENT.TauntSounds = {
	Sound("nz_moo/zombies/vox/mute_00.wav"),
	Sound("nz_moo/zombies/vox/mute_00.wav"),
	Sound("nz_moo/zombies/vox/mute_00.wav"),
	Sound("nz_moo/zombies/vox/mute_00.wav"),
	Sound("nz_moo/zombies/vox/mute_00.wav"),
	Sound("nz_moo/zombies/vox/mute_00.wav"),
	Sound("nz_moo/zombies/vox/mute_00.wav"),
}

ENT.BehindSoundDistance = 0 -- When the zombie is within 200 units of a player, play these sounds instead
ENT.BehindSounds = {
	Sound("nz_moo/zombies/vox/mute_00.wav"),
}

function ENT:StatsInitialize()
	if SERVER then
		local count = #player.GetAllPlaying()

		if nzRound:InState( ROUND_CREATE ) then
			self:SetHealth(5000)
			self:SetMaxHealth(5000)
		else
			if nzRound:InState( ROUND_PROG ) then
				self:SetHealth(math.Clamp(nzRound:GetNumber() * 500 + (97500 * count), 97500, 500000 * count))
				self:SetMaxHealth(math.Clamp(nzRound:GetNumber() * 500 + (97500 * count), 97500, 500000 * count))
			else
				self:SetHealth(5000)
				self:SetMaxHealth(5000)	
			end
		end

		self:SetRunSpeed(1)

		self:SetTargetCheckRange(60000) -- Much like George, Hillturr will know your location 24/7.

		self.MaldTime = CurTime()
		self.Malding = false
		beginmald = false

		self:SetIsIdle(true)
		self:SetIsEnraged(false)
	end
end

function ENT:SpecialInit()
	if CLIENT then
	end
end

function ENT:OnSpawn()
	self:SetBodygroup(0,0)
	self:EmitSound("nz/hellhound/spawn/strike.wav", 511, math.random(95, 105))
	ParticleEffect("bo3_astronaut_pulse",self:LocalToWorld(Vector(0,0,50)),Angle(0,0,0),nil)
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
		self:BecomeRagdoll(dmginfo)
	else
		self:DoDeathAnimation(self.DeathSequences[math.random(#self.DeathSequences)])
	end

	self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)

	self:SetBodygroup(0,1) -- Lost his drip
	self:StopSound(self.IdleMusic)
	self:StopSound(self.RageMusic)

	ParticleEffect("ds3_boss_dissolve",self:LocalToWorld(Vector(0,0,10)),Angle(0,0,0),nil)
	ParticleEffect("fo3_mirelurk_charge",self:LocalToWorld(Vector(0,0,50)),Angle(0,0,0),nil)
	self:EmitSound("nz_moo/zombies/vox/_astro/death/astro_pop.mp3", 511, math.random(95, 105))
	self:EmitSound("nz_moo/zombies/vox/_astro/death/astro_flux.mp3", 511, math.random(95, 105))

	if !nzRound:InState(ROUND_CREATE) then
		nzPowerUps:SpawnPowerUp(self:GetPos(), "bottle")
	end
end

function ENT:OnRemove()
	self:StopSound("nz_moo/zombies/vox/_hilter/the_chase_1.wav")
	self:StopSound("nz_moo/zombies/vox/_hilter/the_chase_2.wav")
	self:StopSound("nz_moo/zombies/vox/_hilter/adolf_hitler_loop.wav")
end

function ENT:IsValidTarget( ent )
	if !ent then return false end
	return IsValid(ent) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
	-- Won't go for special targets (Monkeys), but still MAX, ALWAYS and so on
end

function ENT:AI()
	if self.Malding and beginmald then

		beginmald = false

		--self:StopSound(self.IdleMusic)

		self:SetSpecialAnimation(true)
		self:PlaySequenceAndMove("nz_adorabolf_enrage",1)
		self:SetSpecialAnimation(false)

		self:SetRunSpeed(71)
		self:SpeedChanged()

		self:SetIsEnraged(true)
		self:SetIsIdle(false)

		self.MaldTime = CurTime() + 35
	end

	if CurTime() > self.MaldTime and self.Malding then
		self.Malding = false

		self:SetIsEnraged(false)
		self:SetIsIdle(true)

		self:SetRunSpeed(1)
		self:SpeedChanged()

		--self:StopSound(self.RageMusic)
		--self:EmitSound(self.IdleMusic, 70, math.random(95, 105), 1, 3)

		self:SetSpecialAnimation(true)
		self:PlaySequenceAndMove("nz_sonic_attack_01",1)
		self:SetSpecialAnimation(false)
	end
end

function ENT:OnTakeDamage(dmginfo)
	local attacker = dmginfo:GetAttacker()
	if IsValid(attacker) and attacker:IsPlayer() then
		if self:Health() > 0 and !self.Malding then
			self.Malding = true
			beginmald = true
		end
	end
	dmginfo:ScaleDamage(0.075)
end

function ENT:Explode(dmg, suicide)
	for k, v in pairs(ents.FindInSphere(self:GetPos(), 120)) do    
		if v:IsPlayer() and v:Alive() and v:GetNotDowned() then
			
			local points = v:GetPoints()
			local possibleamount = {250,500,750,1250,1750}
			local take = possibleamount[math.random(#possibleamount)]
			if (points - take) <= 0 then
				v:SetPoints(0) -- Obviously you don't wanna go in debt... But you will be broke.
			else
				v:TakePoints(take,true)
			end

			if self.Malding then
				dmg = v:Health() + 10
			else
				if v:Health() < 50 then
					dmg = v:Health() + 10
				else
					dmg = v:Health() - 1
				end
			end
			v:TakeDamage(dmg)
		end
		if v.IsMooZombie and !v.IsMooSpecial and !v:GetSpecialAnimation() then
			if v.SparkyAnim then
				v:DoSpecialAnimation(v.SparkyAnim, true, true)
				if !v:GetWaterBuff() then
					v:SetHealth( nzRound:GetZombieHealth() * 3 )
            		v:SetWaterBuff(true)
            		if v:GetRunSpeed() <= 145 then
            			v:SetRunSpeed(155)
            			v:SpeedChanged()

            			if v.ElecSounds then	
							v:PlaySound(v.ElecSounds[math.random(#v.ElecSounds)], 90, math.random(85, 105), 1, 2)
						end
            		end
				end
			end
		end
	end

	if self.Malding then
		ParticleEffect("adorabolf_explode",self:LocalToWorld(Vector(0,0,2)),Angle(0,0,0),nil)
		self:EmitSound("nz_moo/zombies/vox/_hilter/adorabolf_hit.mp3",511, math.random(98,102))
	else
		ParticleEffect("adorabolf_explode",self:LocalToWorld(Vector(0,0,50)),Angle(0,0,0),nil)
		ParticleEffect("bo3_astronaut_pulse",self:LocalToWorld(Vector(0,0,50)),Angle(0,0,0),nil)
		self:EmitSound("nz_moo/zombies/vox/_astro/death/astro_pop.mp3", 511, math.random(95, 105))
		self:EmitSound("nz_moo/zombies/vox/_astro/death/astro_flux.mp3", 511, math.random(95, 105))
		self:EmitSound("nz_moo/zombies/vox/_hilter/hitler_attack.mp3",511, math.random(98,102))
	end

	if suicide then self:TakeDamage(self:Health() + 666, self, self) end
end

function ENT:HandleAnimEvent(a,b,c,d,e) -- Moo Mark 4/14/23: You don't know how sad I am that I didn't know about this sooner.
	if e == "step_left_small" or e == "step_left_large" then
		ParticleEffectAttach("adorabolf_step",PATTACH_POINT,self,11)
		if self.loco:GetVelocity():Length2D() >= 75 then
			if self.CustomRunFootstepsSounds then
				self:EmitSound(self.CustomRunFootstepsSounds[math.random(#self.CustomRunFootstepsSounds)], 65)
			else
				self:EmitSound(self.NormalRunFootstepsSounds[math.random(#self.NormalRunFootstepsSounds)], 65)
			end
		else
			if self.CustomWalkFootstepsSounds then
				self:EmitSound(self.CustomWalkFootstepsSounds[math.random(#self.CustomWalkFootstepsSounds)], 65)
			else
				self:EmitSound(self.NormalWalkFootstepsSounds[math.random(#self.NormalWalkFootstepsSounds)], 65)
			end
		end
	end
	if e == "step_right_small" or e == "step_right_large" then
		ParticleEffectAttach("adorabolf_step",PATTACH_POINT,self,12)
		if self.loco:GetVelocity():Length2D() >= 75 then
			if self.CustomRunFootstepsSounds then
				self:EmitSound(self.CustomRunFootstepsSounds[math.random(#self.CustomRunFootstepsSounds)], 65)
			else
				self:EmitSound(self.NormalRunFootstepsSounds[math.random(#self.NormalRunFootstepsSounds)], 65)
			end
		else
			if self.CustomWalkFootstepsSounds then
				self:EmitSound(self.CustomWalkFootstepsSounds[math.random(#self.CustomWalkFootstepsSounds)], 65)
			else
				self:EmitSound(self.NormalWalkFootstepsSounds[math.random(#self.NormalWalkFootstepsSounds)], 65)
			end

		end
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

	if e == "adorabolf_enrage" then
		self.NextSound = CurTime() + 7
		self:EmitSound("nz_moo/zombies/vox/_hilter/vox/mald/hitler_angry.mp3",511,math.random(97, 103),1,2)	
	end

	if e == "napalm_explode" or e == "adorabolf_slam" then
		if !self.Dying then
			self:Explode(100,false)
		end
	end

	if e == "base_ranged_rip" then
		ParticleEffectAttach("ins_blood_dismember_limb", 4, self, 5)
		self:EmitSound("nz_moo/zombies/gibs/gib_0"..math.random(0,3)..".mp3", 100, math.random(95,105))
		self:EmitSound("nz_moo/zombies/gibs/head/_og/zombie_head_0"..math.random(0,2)..".mp3", 65, math.random(95,105))
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
	if e == "remove_zombie" then
		self:Remove()
	end

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
end