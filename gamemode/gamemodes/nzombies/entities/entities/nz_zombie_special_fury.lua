AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.Type = "nextbot"
ENT.Category = "Brainz"
ENT.Author = "Loonicity"
ENT.Spawnable = true

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = false
ENT.IsMooSpecial = true

ENT.Models = {
	{Model = "models/kate/_codz_ports/t7/genesis/kate_t7_apothicon_furry.mdl", Skin = 0, Bodygroups = {0,0}},
}

ENT.ElectrocutionSequences = {
	"nz_apothiconfury_elecdeath1",
	"nz_apothiconfury_elecdeath2",
}

ENT.BarricadeTearSequences = {
	--Leave this empty if you don't intend on having a special enemy use tear anims.
}

local AttackSequences = {
	{seq = "nz_apothiconfury_attack_l"},
	{seq = "nz_apothiconfury_attack_r"},
	{seq = "nz_apothiconfury_attack_double"},
}

local JumpSequences = {
	{seq = "nz_apothiconfury_barricade"},
}

local walksounds = {
	Sound("vox/amb/amb_vox_01.wav"),
	Sound("vox/amb/amb_vox_02.wav"),
	Sound("vox/amb/amb_vox_03.wav"),
	Sound("vox/amb/amb_vox_04.wav"),
}

ENT.PopSequences = {
	"nz_apothiconfury_tele_200",
	"nz_apothiconfury_tele_300",
	"nz_apothiconfury_tele_350",
	"nz_apothiconfury_tele_400",
	"nz_apothiconfury_tele_450",
	"nz_apothiconfury_tele_500",
	"nz_apothiconfury_tele_550",
	"nz_apothiconfury_tele_600",
	"nz_apothiconfury_tele_650",
	"nz_apothiconfury_tele_700",
	"nz_apothiconfury_tele_45_left",
	"nz_apothiconfury_tele_45_right",
	"nz_apothiconfury_tele_left",
	"nz_apothiconfury_tele_right",
	
}

ENT.IdleSequence = "nz_apothiconfury_idle"

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			MovementSequence = {
				"nz_apothiconfury_walk1",
				"nz_apothiconfury_walk2",
				"nz_apothiconfury_walk3",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 36, Sequences = {
		{
			MovementSequence = {
				"nz_apothiconfury_run_v1",
				"nz_apothiconfury_run_v2",
				"nz_apothiconfury_run_v3",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 71, Sequences = {
		{
			MovementSequence = {
				"nz_apothiconfury_sprint_v1",
				"nz_apothiconfury_sprint_v2",
				"nz_apothiconfury_sprint_v3",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}}
}

ENT.PopSounds = {
	"spawn/exp/pop/evt_fury_pop_00.wav",
	"spawn/exp/pop/evt_fury_pop_01.wav",
	"spawn/exp/pop/evt_fury_pop_02.wav",
}

ENT.PopExitSounds = {
	"spawn/exp/evt_fury_spawn_exp_00.wav",
	"spawn/exp/evt_fury_spawn_exp_01.wav",
	"spawn/exp/evt_fury_spawn_exp_02.wav",
	"spawn/exp/evt_fury_spawn_exp_03.wav",
}

ENT.PopTrailSounds = {
	"spawn/trail/evt_fury_spawn_trail_00.wav",
	"spawn/trail/evt_fury_spawn_trail_01.wav",
	"spawn/trail/evt_fury_spawn_trail_02.wav",
	"spawn/trail/evt_fury_spawn_trail_03.wav",
}

ENT.DeathSounds = {
	"vox/pain/pain_vox_01.wav",
	"vox/pain/pain_vox_02.wav",
	"vox/pain/pain_vox_03.wav",
	"vox/pain/pain_vox_04.wav",
}

ENT.AttackSounds = {
	"vox/attack/attack_vox_01.wav",
	"vox/attack/attack_vox_02.wav",
	"vox/attack/attack_vox_03.wav",
	"vox/attack/attack_vox_04.wav",
}

ENT.FuryFootstepSounds = {
	"step_sizzle/fury_step_sizzle_01.wav",
	"step_sizzle/fury_step_sizzle_02.wav",
	"step_sizzle/fury_step_sizzle_03.wav",
	"step_sizzle/fury_step_sizzle_04.wav",
	"step_sizzle/fury_step_sizzle_05.wav",
}

ENT.BehindSoundDistance = 0 -- When the zombie is within 200 units of a player, play these sounds instead
ENT.BehindSounds = {
	Sound("nz_moo/zombies/vox/_quad/behind/behind_00.mp3"),
	Sound("nz_moo/zombies/vox/_quad/behind/behind_01.mp3"),
}

function ENT:StatsInitialize()
	if SERVER then
		self:SetMooSpecial(true)
		if nzRound:GetNumber() == -1 then
			self:SetRunSpeed( math.random(20, 105) )
			self:SetHealth( math.random(100, 1500) )
		else
			local speeds = nzRound:GetZombieSpeeds()
			if speeds then
				self:SetRunSpeed( nzMisc.WeightedRandom(speeds) )
			else
				self:SetRunSpeed( 100 )
			end
			self:SetHealth( nzRound:GetZombieHealth() or 75 )
		end

		self.NextPhaseTime = CurTime() + 5
	end
end

function ENT:OnSpawn()
	self:SolidMaskDuringEvent(MASK_SOLID_BRUSHONLY)
	self:Sound()
	self:CollideWhenPossible()
	self:SetCollisionBounds(Vector(-16,-16, 0), Vector(16, 16, 65))

	local effectData = EffectData()
	effectData:SetOrigin( self:GetPos() + Vector(0, 0, 50)  )
	effectData:SetMagnitude( 1 )
	effectData:SetEntity(nil)
	util.Effect("panzer_spawn_tp", effectData)
	ParticleEffectAttach("env_embers_medium_spread",PATTACH_ABSORIGIN_FOLLOW,self,0)
end

function ENT:PerformDeath(dmgInfo)
	local dmgtype = dmgInfo:GetDamageType()
	self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
	if dmgtype == DMG_SHOCK then
		self:DoDeathAnimation(self.ElectrocutionSequences[math.random(#self.ElectrocutionSequences)])
	else
		ParticleEffect("doom_dissolve_flameburst",self:WorldSpaceCenter(),Angle(0,0,0),nil)
		self:Remove(dmgInfo)
	end
end

function ENT:DoDeathAnimation(seq)
	self.BehaveThread = coroutine.create(function()
		self:SetSpecialAnimation(true)
		self:PlaySequenceAndMove(seq, 1)
		self:Remove(DamageInfo())
		ParticleEffect("doom_dissolve_flameburst",self:WorldSpaceCenter(),Angle(0,0,0),nil)
	end)
end
--doom_avile_blast_largefade_xz

function ENT:AI()
	if CurTime() > self.NextPhaseTime then 
		local seq = self.PopSequences[math.random(#self.PopSequences)]
		local target = self:GetTarget() 
		if IsValid(target) and !self:IsAttackBlocked() and self:TargetInRange(700) then
			if self:SequenceHasSpace(seq) then
				self:FaceTowards(target:GetPos())
				self:DoSpecialAnimation(seq, true)
				self.NextPhaseTime = CurTime() + 8
			end
		end
	end 
end

function ENT:HandleAnimEvent(a,b,c,d,e) -- Moo Mark 4/14/23: You don't know how sad I am that I didn't know about this sooner.
	if e == "step_right_small" or e == "step_left_small" or e == "step_right_large" or e == "step_left_large" then
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
	if e == "crawl_hand" then
		if self.CustomCrawlImpactSounds then
			self:EmitSound(self.CustomCrawlImpactSounds[math.random(#self.CustomCrawlImpactSounds)], 70)
		else
			self:EmitSound(self.CrawlImpactSounds[math.random(#self.CrawlImpactSounds)], 70)
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
	if e == "tele_start" then
		self:EmitSound(self.PopSounds[math.random(#self.PopSounds)], 100)
		self:EmitSound(self.PopTrailSounds[math.random(#self.PopTrailSounds)], 100)
		self:SetMaterial("Invisible")
		ParticleEffectAttach("doom_caco_nade", 4, self, 3)
		ParticleEffect("doom_dissolve_flameburst",self:WorldSpaceCenter(),Angle(0,0,0),nil)
	end
	if e == "fury_step" then
		self:EmitSound(self.FuryFootstepSounds[math.random(#self.FuryFootstepSounds)], 100)
	end
	if e == "tele_end" then
		self:EmitSound(self.PopExitSounds[math.random(#self.PopExitSounds)], 100)
		self:SetMaterial("")
		self:StopParticles()
		ParticleEffect("doom_dissolve_flameburst",self:WorldSpaceCenter(),Angle(0,0,0),nil)
	end
end

function ENT:TriggerBarricadeJump( barricade, dir )
		if !self:GetSpecialAnimation() then

			local useswalkframes = false

			self:SetSpecialAnimation(true)
			self:SetBlockAttack(true)

			local id, dur, speed
			local animtbl = self.JumpSequences

			if self:GetCrawler() then
				animtbl = self.CrawlJumpSequences
			end
 
 			if self.JumpSequences then
				if type(animtbl) == "number" then -- ACT_ is a number, this is set if it's an ACT
					id = self:SelectWeightedSequence(animtbl)
					dur = self:SequenceDuration(id)
					speed = self:GetSequenceGroundSpeed(id)
					if speed < 10 then
						speed = 20
					end
				else
					local targettbl = animtbl and animtbl[math.random(#animtbl)] or self.JumpSequences
					if targettbl then -- It is a table of sequences
						id, dur = self:LookupSequenceAct(targettbl.seq) -- Whether it's an ACT or a sequence string
						speed = targettbl.speed
						if speed then
							useswalkframes = false
						else
							useswalkframes = true
						end
					else
						id = self:SelectWeightedSequence(ACT_JUMP)
						dur = self:SequenceDuration(id)
						speed = 30
					end
				end
			end

			self:SolidMaskDuringEvent(MASK_NPCSOLID_BRUSHONLY)

			if useswalkframes then
				local effectData = EffectData()
				effectData:SetOrigin( self:GetPos() + Vector(0, 0, 50)  )
				effectData:SetMagnitude( 1 )
				effectData:SetEntity(nil)
				util.Effect("panzer_spawn_tp", effectData)
				ParticleEffect("doom_dissolve_flameburst",self:WorldSpaceCenter(),Angle(0,0,0),nil)
	
				local pos = barricade:GetPos() - dir * 50
				self:SetPos(pos)
				self:PlaySequenceAndMove(id, {gravity = false})
				self:ResetMovementSequence()
			end
			self:SetBlockAttack(false)
			self:SetSpecialAnimation(false)
			self:SetIsBusy(false)
			self:CollideWhenPossible() -- Remove the mask as soon as we can
			self:TimeOut(0.1)
		end
	end