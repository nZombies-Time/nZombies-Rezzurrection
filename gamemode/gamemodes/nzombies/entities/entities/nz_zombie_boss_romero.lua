AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "George Romero"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo"

function ENT:InitDataTables()
	self:NetworkVar("Bool", 5, "LowLightHP")
	self:NetworkVar("Entity", 6, "StageLight")
end

if CLIENT then 
	local eyeglow =  Material("nz/zlight")
	function ENT:Draw() //Runs every frame
		self:DrawModel()
		if self.RedEyes and self:Alive() and !self:GetDecapitated() then
			self:DrawEyeGlow()
			self:DrawSpotLight()
		end
		if GetConVar( "nz_zombie_debug" ):GetBool() then
			render.DrawWireframeBox(self:GetPos(), Angle(0,0,0), self:OBBMins(), self:OBBMaxs(), Color(255,0,0), true)
		end
	end

	function ENT:DrawEyeGlow()
		local eyeColor = Color(255, 175, 0, 255)
		local latt = self:LookupAttachment("lefteye")
		local ratt = self:LookupAttachment("righteye")

		local leye = self:GetAttachment(latt)
		local reye = self:GetAttachment(ratt)

		local righteyepos = leye.Pos + leye.Ang:Forward()*0.5
		local lefteyepos = reye.Pos + reye.Ang:Forward()*0.5

		if lefteyepos and righteyepos then
			render.SetMaterial(eyeglow)
			render.DrawSprite(lefteyepos, 6, 6, eyeColor)
			render.DrawSprite(righteyepos, 6, 6, eyeColor)
		end
	end
	function ENT:DrawSpotLight()
		local color
		if !self:GetLowLightHP() then
			color = Color(100,150,255)
		else
			color = Color(255,150,0)
		end

		local lighttag = self:LookupAttachment("light_fx_tag")
		local light = self:GetAttachment(lighttag)
		local lightpos = light.Pos + light.Ang:Forward()*0.5

		render.DrawSprite(lightpos, 75, 75, color)
	end
	return 
end -- Client doesn't really need anything beyond the basics

local util_tracehull = util.TraceHull

ENT.RedEyes = true
ENT.SpeedBasedSequences = true

ENT.IsMooZombie = true
ENT.IsMooSpecial = true
ENT.IsMooBossZombie = true

ENT.AttackRange = 105
ENT.DamageRange = 105

ENT.AttackDamage = 90
ENT.HeavyAttackDamage = 150

ENT.TraversalCheckRange = 40

ENT.SoundDelayMin = 8
ENT.SoundDelayMax = 15

ENT.MinSoundPitch = 98
ENT.MaxSoundPitch = 102


ENT.Models = {
	{Model = "models/moo/_codz_ports/t5/coast/moo_codz_t5_coast_director.mdl", Skin = 0, Bodygroups = {0,0}},
}

ENT.BarricadeTearSequences = {}

local spawn = {"nz_director_idle_01"}

local StandAttackSequences = {
	{seq = "nz_boss_attack_multiswing_01"},
	{seq = "nz_boss_attack_multiswing_02"},
}

local AttackSequences = {
	{seq = "nz_boss_attack_multiswing_01"},
	{seq = "nz_boss_attack_multiswing_02"},
}

local SprintAttackSequences = {
	{seq = "nz_boss_attack_sprint"},
}

local JumpSequences = {
	{seq = ACT_JUMP, speed = 500},
}

local walksounds = {
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_0_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_10_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_11_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_12_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_13_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_14_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_15_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_16_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_17_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_18_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_19_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_20_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_21_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_22_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_23_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_24_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_25_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_26_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_27_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_29_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_30_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_31_PCM.mp3"),
}

local runsounds = {
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_angry_0_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_angry_1_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_angry_2_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_angry_3_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_angry_4_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_angry_5_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_angry_6_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_angry_7_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_angry_8_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_angry_9_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_angry_10_PCM.mp3"),
}

ENT.IdleSequence = "nz_director_idle_02"
ENT.IdleSequenceAU = "nz_director_idle_01"

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			MovementSequence = {
				"nz_boss_walk_02",
			},
			SpawnSequence = {spawn},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 71, Sequences = {
		{
			MovementSequence = {
				"nz_boss_sprint_01",
			},
			SpawnSequence = {spawn},
			AttackSequences = {SprintAttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {runsounds},
		},
	}}
}

ENT.AttackSounds = {
	Sound("nz_moo/zombies/vox/_director/exert/vox_director_exert_00_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/exert/vox_director_exert_01_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/exert/vox_director_exert_03_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/exert/vox_director_exert_04_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/exert/vox_director_exert_05_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/exert/vox_director_exert_06_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/exert/vox_director_exert_07_PCM.mp3"),
}

ENT.AngeredSounds = {
	Sound("nz_moo/zombies/vox/_director/angered/vox_director_angered_00_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/angered/vox_director_angered_01_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/angered/vox_director_angered_02_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/angered/vox_director_angered_03_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/angered/vox_director_angered_04_PCM.mp3"),
}

ENT.LaughSounds = {
	Sound("nz_moo/zombies/vox/_director/laugh/vox_director_laugh_00_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/laugh/vox_director_laugh_01_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/laugh/vox_director_laugh_02_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/laugh/vox_director_laugh_03_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/laugh/vox_director_laugh_04_PCM.mp3"),
}

ENT.SlamSounds = {
	Sound("nz_moo/zombies/vox/_director/slam/vox_director_slam_00_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/slam/vox_director_slam_01_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/slam/vox_director_slam_02_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/slam/vox_director_slam_03_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/slam/vox_director_slam_04_PCM.mp3"),
}

ENT.ElecBuffSounds = {
	Sound("nz_moo/zombies/vox/_director/electric_buff/vox_director_elec_buff_00_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/electric_buff/vox_director_elec_buff_01_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/electric_buff/vox_director_elec_buff_02_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/electric_buff/vox_director_elec_buff_03_PCM.mp3"),
}

ENT.SpeedBuffSounds = {
	Sound("nz_moo/zombies/vox/_director/speed_buff/vox_director_speed_buff_00_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/speed_buff/vox_director_speed_buff_01_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/speed_buff/vox_director_speed_buff_02_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/speed_buff/vox_director_speed_buff_03_PCM.mp3"),
}

ENT.FindSounds = {
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_find_0_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_find_5_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_find_6_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_find_7_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_find_8_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_find_9_PCM.mp3"),
}

ENT.HumanSounds = {
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_human_0_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_human_1_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_human_2_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_human_3_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_human_4_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_human_5_PCM.mp3"),
}

ENT.KillSounds = {
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_kill_0_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_kill_1_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_kill_2_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_kill_3_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_kill_4_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_kill_5_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_kill_6_PCM.mp3"),
}

ENT.ReactSounds = {
	--Sound("nz_moo/zombies/vox/_director/lines/vox_romero_react_0_PCM.mp3"),
	--Sound("nz_moo/zombies/vox/_director/lines/vox_romero_react_1_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_react_2_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_react_3_PCM.mp3"),
	--Sound("nz_moo/zombies/vox/_director/lines/vox_romero_react_4_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_react_5_PCM.mp3"),
}

ENT.SearchSounds = {
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_search_0_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_search_1_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_search_2_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_search_3_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_search_4_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_search_5_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_search_6_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_search_7_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_0_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_10_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_11_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_12_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_13_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_14_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_15_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_16_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_17_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_18_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_19_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_20_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_21_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_22_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_23_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_24_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_25_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_26_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_27_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_29_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_30_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_taunt_31_PCM.mp3"),
}

ENT.WaterSounds = {
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_water_1_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_water_2_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_water_3_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_water_4_PCM.mp3"),
}

ENT.WeakenSounds = {
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_weaken_0_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_weaken_1_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_weaken_2_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_weaken_3_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_weaken_4_PCM.mp3"),
}

ENT.LucidSounds = {
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_lucid_0_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_lucid_1_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_lucid_2_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_lucid_3_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_lucid_4_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_lucid_5_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/lines/vox_romero_lucid_6_PCM.mp3"),
}

ENT.PainYellSounds = {
	Sound("nz_moo/zombies/vox/_director/pain_yell/vox_director_pain_yell_00_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/pain_yell/vox_director_pain_yell_01_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/pain_yell/vox_director_pain_yell_02_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/pain_yell/vox_director_pain_yell_03_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/pain_yell/vox_director_pain_yell_04_PCM.mp3"),
}

ENT.DeathSounds = {
	Sound("nz_moo/zombies/vox/_director/die/zmb_vox_director_die_00_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/die/zmb_vox_director_die_01_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/die/zmb_vox_director_die_02_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/die/zmb_vox_director_die_03_PCM.mp3"),
}

ENT.CustomRunFootstepsSounds = {
	Sound("nz_moo/zombies/vox/_director/_sfx/steps/zmb_director_step_00.mp3"),
	Sound("nz_moo/zombies/vox/_director/_sfx/steps/zmb_director_step_01.mp3"),
	Sound("nz_moo/zombies/vox/_director/_sfx/steps/zmb_director_step_02.mp3"),
	Sound("nz_moo/zombies/vox/_director/_sfx/steps/zmb_director_step_03.mp3"),
}

ENT.WaterFootstepsSounds = {
	Sound("nz_moo/zombies/vox/_director/_sfx/steps/water/zmb_director_step_water_00.mp3"),
	Sound("nz_moo/zombies/vox/_director/_sfx/steps/water/zmb_director_step_water_01.mp3"),
	Sound("nz_moo/zombies/vox/_director/_sfx/steps/water/zmb_director_step_water_02.mp3"),
	Sound("nz_moo/zombies/vox/_director/_sfx/steps/water/zmb_director_step_water_03.mp3"),
}

ENT.BehindSoundDistance = 300 -- When the zombie is within 200 units of a player, play these sounds instead
ENT.BehindSounds = {
	Sound("nz_moo/zombies/vox/_director/behind/vox_director_behind_00_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/behind/vox_director_behind_01_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/behind/vox_director_behind_02_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/behind/vox_director_behind_03_PCM.mp3"),
	Sound("nz_moo/zombies/vox/_director/behind/vox_director_behind_04_PCM.mp3"),
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

		self.SpotLightSoundlp = "ambient/energy/electric_loop.wav"

		self.Enraged = false
		self.EnrageCooldown = 0
		self.NextEnrageTime = CurTime() + 7

		self.CantEnrageYell = CurTime() + 5

		self:SetLowLightHP(false)

		self.SeeYou = false
		self.Search = false
		self.Spotted = false

		self.ElectricBuff = false
		self.ElectricBuffCooldown = CurTime() + 7

		self.SpeedBuff = false
		self.SpeedBuffCooldown = CurTime() + 2

		-- Spawn voicelines
		self.SpawnVoxLine = CurTime() + 7
		self.SpawnVoxLine2 = CurTime() + 10
		self.SpawnVox = true
		self.SpawnVox2 = true

		self:SetTargetCheckRange(60000) -- He will always know where you are.

		self:SetBodygroup(0,0)
		self:SetBodygroup(1,0)
		self:SetRunSpeed(1)
		self:SetCollisionBounds(Vector(-19,-19, 0), Vector(19, 19, 87))

		self.NextSound = CurTime() + 10

	end
end

function ENT:OnSpawn()

	self:SetNoDraw(true)
	self:SolidMaskDuringEvent(MASK_SOLID_BRUSHONLY)
	self:SetInvulnerable(true)
	self:SetSpecialAnimation(true)

	self:EmitSound("nz_moo/zombies/vox/_director/_sfx/zmb_director_yellow_beam_PCM.mp3",577)
	ParticleEffect("summon_beam",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
	ParticleEffect("driese_tp_arrival_ambient",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
	ParticleEffect("driese_tp_arrival_ambient_lightning",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)

	self:TimeOut(1.5)

	self:SetSpecialAnimation(false)
	self:SetInvulnerable(false)
	self:CollideWhenPossible()
	self:SetNoDraw(false)

	self:EmitSound("nz_moo/zombies/vox/_cellbreaker/slam/initial_zap_0"..math.random(0,3)..".mp3",100)
	self:EmitSound("nz_moo/zombies/vox/_cellbreaker/slam/rubble_0"..math.random(0,3)..".mp3",100,math.random(95,105))
	self:EmitSound("nz_moo/zombies/vox/_director/_sfx/zmb_director_electric_water_PCM.mp3",577)
	self:EmitSound("nz_moo/zombies/vox/_director/_sfx/zmb_director_beam_PCM.mp3", 577)
	ParticleEffect("driese_tp_arrival_phase2",self:LocalToWorld(Vector(60,-30,0)),Angle(0,0,0),nil)
	ParticleEffect("driese_tp_arrival_ambient",self:LocalToWorld(Vector(60,-30,0)),Angle(0,0,0),nil)

	self:EmitSound(self.SpotLightSoundlp,65)
	self:Director_DynamicLight(Color(100,150,255), 45, 9, 6)
	util.SpriteTrail(self, 12, Color(255, 255, 255, 255), false, 25, 15, 1, 1 / 40 * 0.3, "trails/electric")
end

function ENT:PerformDeath(dmgInfo)
	for k,v in pairs(player.GetAllPlaying()) do
		if TFA.BO3GiveAchievement then
			if !v.Quiet_on_the_set then
				TFA.BO3GiveAchievement("Quiet on the Set", "vgui/overlay/achievment/Quiet_on_the_Set_BO1.png", v)
				v.Quiet_on_the_set = true
			end
		end
	end

	if !nzRound:InState(ROUND_CREATE) then
		nzPowerUps:SpawnPowerUp(self:GetPos(), "bottle")
	end

	ParticleEffect("driese_tp_arrival_ambient",self:LocalToWorld(Vector(60,-30,0)),Angle(0,0,0),nil)
	ParticleEffectAttach("bo3_thrasher_aura", 5, self, 1)

	self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)],577, math.random(self.MinSoundPitch, self.MaxSoundPitch), 1, 2)
	self:DoDeathAnimation("nz_boss_death_coast")
end

function ENT:AI()

	-- Seeing Target
	if self:TargetInRange(950) and !self:IsAttackBlocked() and !self.SeeYou and self.Search then
		self.SeeYou = true
		if !self.Spotted and self.Search then
			self.Spotted = true
			self.Search = false
		end
	elseif self:IsAttackBlocked() then
		self.SeeYou = false
		self.Search = true
	end

	-- Calm
	if (CurTime() > self.EnrageCooldown or self:ZombieWaterLevel() > 0) and self.Enraged then
		self:DirectorCalm()
	end

	-- Chance a random buff for normal zombies
	if math.random(100) > 25 then
		-- Speed Buff
		if CurTime() > self.SpeedBuffCooldown then
			local staff = {}
			for k,v in nzLevel.GetZombieArray() do
				if self:GetRangeTo( v:GetPos() ) < 200 and v.IsMooZombie and !v.IsMooSpecial and v:GetRunSpeed() > 70 and v:GetRunSpeed() < 200 then
					table.insert(staff, v)
					if #staff >= 2 and CurTime() > self.SpeedBuffCooldown then
						self.SpeedBuff = true
						self:DoSpecialAnimation("nz_boss_enrage_start_scream")
						self.SpeedBuffCooldown = CurTime() + 10
						for k2,v2 in pairs(ents.FindInSphere(self:GetPos(), 175)) do
							if IsValid(v2) and v2.IsMooZombie and !v2.IsMooSpecial then
            					v2:SetRunSpeed(300)
								v2:SpeedChanged()
							end
						end
					end
				end
			end
		end
	else
		-- Electric Buff
		if CurTime() > self.ElectricBuffCooldown then
			local staff = {}
			for k,v in nzLevel.GetZombieArray() do
				if self:GetRangeTo( v:GetPos() ) < 200 and v.IsMooZombie and !v.IsMooSpecial and !v:WaterBuff() then
					table.insert(staff, v)
					if #staff >= 2 and CurTime() > self.ElectricBuffCooldown then
						self.ElectricBuff = true
						self:DoSpecialAnimation("nz_boss_enrage_start_scream")
						self.ElectricBuffCooldown = CurTime() + 20
						for k2,v2 in pairs(ents.FindInSphere(self:GetPos(), 175)) do
							if IsValid(v2) and v2.IsMooZombie and !v2.IsMooSpecial and !v2:WaterBuff() then
								v2:SetHealth( nzRound:GetZombieHealth() * 3 )
            					v2:SetWaterBuff(true)
							end
						end
					end
				end
			end
		end
	end


	-- Half Health
	if self:Health() < self:GetMaxHealth() / 2 and !self:GetLowLightHP() then
		self:SetLowLightHP(true)

		local oldlight = self:GetStageLight()
		if IsValid(oldlight) then
			oldlight:Remove()
		end
		self:Director_DynamicLight(Color(255,150,0), 45, 9, 6)
	end

	-- Random Spark
	if math.random(10) <= 3 then
		self:Director_LightSpark()
	end

	-- Entrance specific voiceline
	if CurTime() > self.SpawnVoxLine and self.SpawnVox then
		self:PlaySound("nz_moo/zombies/vox/_director/lines/vox_romero_start_0_PCM.mp3",577, math.random(self.MinSoundPitch, self.MaxSoundPitch), 1, 2)
		self.NextSound = CurTime() + 10
		self.SpawnVox = false
	end
	-- Entrance specific voiceline PT2
	if CurTime() > self.SpawnVoxLine2 and self.SpawnVox2 then
		self:PlaySound("nz_moo/zombies/vox/_director/lines/vox_romero_start_2_PCM.mp3",577, math.random(self.MinSoundPitch, self.MaxSoundPitch), 1, 2)
		self.NextSound = CurTime() + 10
		self.SpawnVox2 = false
	end
end

function ENT:DirectorEnrage()
	self.Enraged = true
	self.EnrageCooldown = CurTime() + 45
	self:DoSpecialAnimation("nz_boss_enrage_start_coast")

	self:SetBodygroup(0,1)

	self:SetRunSpeed(71)
	self:SpeedChanged()
end

function ENT:DirectorCalm()
	self.Enraged = false
	self.NextEnrageTime = CurTime() + 5
	self:DoSpecialAnimation("nz_boss_sprint_to_walk")

	self:SetBodygroup(0,0)

	self.NextSound = CurTime() + 5

	self:SetRunSpeed(1)
	self:SpeedChanged()
end

function ENT:Sound()
	if self:GetAttacking() or !self:Alive() or self:GetDecapitated() then return end

	local vol = 577

	if self.BehindSoundDistance > 0 -- We have enabled behind sounds
		and IsValid(self.Target)
		and self.Target:IsPlayer() -- We have a target and it's a player within distance
		and self:GetRangeTo(self.Target) <= self.BehindSoundDistance
		and (self.Target:GetPos() - self:GetPos()):GetNormalized():Dot(self.Target:GetAimVector()) >= 0 then -- If the direction towards the player is same 180 degree as the player's aim (away from the zombie)
			self:PlaySound(self.BehindSounds[math.random(#self.BehindSounds)], vol, math.random(self.MinSoundPitch, self.MaxSoundPitch), 1, 2) -- Play the behind sound, and a bit louder!
	elseif nzRound:InState(ROUND_GO) then
		if math.random(100) > 50 then
			self:PlaySound(self.LaughSounds[math.random(#self.LaughSounds)],vol, math.random(self.MinSoundPitch, self.MaxSoundPitch), 1, 2)
		else
			self:PlaySound(self.KillSounds[math.random(#self.KillSounds)],vol, math.random(self.MinSoundPitch, self.MaxSoundPitch), 1, 2)
		end
	elseif self.Search and !self.SeeYou then
		self:PlaySound(self.SearchSounds[math.random(#self.SearchSounds)],vol, math.random(self.MinSoundPitch, self.MaxSoundPitch), 1, 2)
	elseif self.Spotted then
		self:PlaySound(self.FindSounds[math.random(#self.FindSounds)],vol, math.random(self.MinSoundPitch, self.MaxSoundPitch), 1, 2)
		self.Spotted = false
	elseif self.PassiveSounds then
		self:PlaySound(self.PassiveSounds[math.random(#self.PassiveSounds)],vol, math.random(self.MinSoundPitch, self.MaxSoundPitch), 1, 2)
	else


		-- We still delay by max sound delay even if there was no sound to play
		self.NextSound = CurTime() + self.SoundDelayMax
	end
end

function ENT:OnTakeDamage(dmginfo)
	local attacker = dmginfo:GetAttacker()
	if IsValid(attacker) and attacker:IsPlayer() and !self.Enraged then
		if CurTime() > self.NextEnrageTime and self:ZombieWaterLevel() < 1 then
			self:DirectorEnrage()
		else
			if CurTime() > self.CantEnrageYell then
				self.CantEnrageYell = CurTime() + 7
				self:DoSpecialAnimation("nz_boss_nuke_react")
			end
		end
	end
	dmginfo:ScaleDamage(0.095)
end

function ENT:HandleAnimEvent(a,b,c,d,e) -- Moo Mark 4/14/23: You don't know how sad I am that I didn't know about this sooner.

	if e == "step_right_large" or e == "step_left_large" then
		if self:ZombieWaterLevel() > 0 then
			self:EmitSound(self.WaterFootstepsSounds[math.random(#self.WaterFootstepsSounds)], 88)
		else
			self:EmitSound(self.CustomRunFootstepsSounds[math.random(#self.CustomRunFootstepsSounds)], 92)
		end
		util.ScreenShake(self:GetPos(),5,5,0.2,475)
	end
	if e == "melee" or e == "melee_heavy" then
		if self.AttackSounds then
			self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 577, math.random(self.MinSoundPitch, self.MaxSoundPitch), 1, 2)
		end
		if e == "melee_heavy" then
			self.HeavyAttack = true
		end
		self:DoAttackDamage()
	end
	if e == "boss_vox_enrage" then
		util.ScreenShake(self:GetPos(),10000,5000,1,1000)
		self:EmitSound(self.AngeredSounds[math.random(#self.AngeredSounds)], 577, math.random(self.MinSoundPitch, self.MaxSoundPitch), 1, 2)
		self.NextSound = CurTime() + 10
		for k,v in pairs(player.GetAll()) do
			if v:Alive() and self:GetRangeTo( v:GetPos() ) < 575 then
				v:NZSonicBlind(1)
			end
		end
	end
	if e == "melee_whoosh" then
		self:EmitSound("nz_moo/zombies/fly/attack/whoosh/zmb_attack_med_0"..math.random(0,2)..".mp3", 95)
	end
	if e == "boss_vox_react" then
		self:EmitSound(self.ReactSounds[math.random(#self.ReactSounds)], 577, math.random(self.MinSoundPitch, self.MaxSoundPitch), 1, 2)
	end
	if e == "boss_vox_weak" then
		self:EmitSound(self.WaterSounds[math.random(#self.WaterSounds)], 577, math.random(self.MinSoundPitch, self.MaxSoundPitch), 1, 2)
	end
	if e == "boss_vox_yell" then
		if !self.ElectricBuff and !self.SpeedBuff then
			self.NextSound = CurTime() + 5
			self:EmitSound(self.PainYellSounds[math.random(#self.PainYellSounds)], 577, math.random(self.MinSoundPitch, self.MaxSoundPitch), 1, 2)
			util.ScreenShake(self:GetPos(),10000,5000,1,1000)
			for k,v in pairs(player.GetAll()) do
				if v:Alive() and self:GetRangeTo( v:GetPos() ) < 575 then
					v:NZSonicBlind(1)
				end
			end
		else
			if self.ElectricBuff then
				self.NextSound = CurTime() + 5
				self:EmitSound(self.ElecBuffSounds[math.random(#self.ElecBuffSounds)], 577, math.random(self.MinSoundPitch, self.MaxSoundPitch), 1, 2)
				self.ElectricBuff = false
			end
			if self.SpeedBuff then
				self.NextSound = CurTime() + 5
				self:EmitSound(self.SpeedBuffSounds[math.random(#self.SpeedBuffSounds)], 577, math.random(self.MinSoundPitch, self.MaxSoundPitch), 1, 2)
				self.SpeedBuff = false
			end
		end
	end
	if e == "boss_slam" then
		local target = self:GetTarget()
		self:EmitSound("nz_moo/zombies/vox/_cellbreaker/slam/initial_zap_0"..math.random(0,3)..".mp3",100)
		self:EmitSound("nz_moo/zombies/vox/_cellbreaker/slam/rubble_0"..math.random(0,3)..".mp3",100,math.random(95,105))
		ParticleEffect("driese_tp_arrival_phase2",self:LocalToWorld(Vector(60,-30,0)),Angle(0,0,0),nil)
		ParticleEffect("driese_tp_arrival_ambient",self:LocalToWorld(Vector(60,-30,0)),Angle(0,0,0),nil)
		util.ScreenShake(self:GetPos(),10000,5000,1,1000)
		self.HeavyAttack = true
		self:DoAttackDamage()
		for k,v in pairs(ents.FindInSphere(self:GetPos(), 100)) do
			if IsValid(v) and v.IsMooZombie and !v.IsMooSpecial and !v:WaterBuff() then
				v:SetHealth( nzRound:GetZombieHealth() * 3 )
            	v:SetWaterBuff(true)
			end
		end
		if target:IsPlayer() and self:TargetInRange(175) and target:IsOnGround() then
			target:NZSonicBlind(3)
		end
	end
	if e == "boss_boom" then
		ParticleEffect("driese_tp_arrival_ambient",self:LocalToWorld(Vector(60,-30,0)),Angle(0,0,0),nil)
		self:EmitSound("nz_moo/zombies/vox/_director/_sfx/zmb_director_beam_PCM.mp3", 577)
	end
	if e == "boss_remove" then

		local effectData = EffectData()
		effectData:SetOrigin( self:GetPos() + Vector(0, 0, 50)  )
		effectData:SetMagnitude( 1 )
		effectData:SetEntity(nil)
		util.Effect("panzer_spawn_tp", effectData)

		self:EmitSound("nz_moo/zombies/vox/_cellbreaker/slam/initial_zap_0"..math.random(0,3)..".mp3",100)
		self:EmitSound("nz_moo/zombies/vox/_cellbreaker/slam/rubble_0"..math.random(0,3)..".mp3",100,math.random(95,105))
		ParticleEffect("driese_tp_arrival_phase2",self:LocalToWorld(Vector(60,-30,0)),Angle(0,0,0),nil)
		ParticleEffect("driese_tp_arrival_ambient",self:LocalToWorld(Vector(60,-30,0)),Angle(0,0,0),nil)
		self:Remove()
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
end

function ENT:OnNoTarget()
	self:TimeOut(1) -- Instead of being brain dead for a second, just search for a new target sooner.
	local newtarget = self:GetPriorityTarget()
	if self:IsValidTarget(newtarget) then
		self:SetTarget(newtarget)
	end
end

function ENT:Director_DynamicLight(color, radius, brightness,style)
	if color == nil then color = Color(255, 255, 255) end
	if not isnumber(radius) then radius = 1000 end
	radius = math.Clamp(radius, 0, math.huge)
	if not isnumber(brightness) then brightness = 1 end
	brightness = math.Clamp(brightness, 0, math.huge)
	local light = ents.Create("light_dynamic")
	light:SetKeyValue("brightness", tostring(brightness))
	light:SetKeyValue("distance", tostring(radius))
	light:SetKeyValue("style", tostring(style))
	light:Fire("Color", tostring(color.r).." "..tostring(color.g).." "..tostring(color.b))
	light:SetLocalPos(self:GetPos())
	light:SetParent(self)
	light:Fire("setparentattachment","light_fx_tag")
	light:Spawn()
	light:Activate()
	light:Fire("TurnOn", "", 0)
	self:SetStageLight(light)
	self:DeleteOnRemove(light)
	return light
end

function ENT:Director_LightSpark()
	local spark = ents.Create("env_spark")
	spark:SetOwner(self)
	spark:SetParent(self)
	spark:SetLocalPos(self:GetPos())
	spark:SetKeyValue("MaxDelay","3")
	spark:SetKeyValue("Magnitude","2")
	spark:SetKeyValue("TrailLength","1")
	spark:Fire("setparentattachment", "light2_fx_tag")
	spark:Spawn()
	spark:Activate()
	spark:Fire("SparkOnce" ,"", 0)
	if IsValid(spark) then
		spark:Remove() -- Removes the spark when its done... Important because the spark entities wouldn't go away otherwise.
	end
end

function ENT:OnRemove()
	self:StopSound(self.SpotLightSoundlp)
end

if SERVER then
	-- Collide When Possible
	local collidedelay = 0.25
	local bloat = Vector(5,5,0)
	function ENT:StuckPrevention() -- Version of the stuck Prevention code for enemies with big collision boxes.(Shrinks their Obb when stuck.)
		if !self:GetIsBusy() and !self:GetSpecialAnimation() and !self:GetAttacking() and self:GetLastPostionSave() + 0.75 < CurTime() then
			if self:GetPos():DistToSqr( self:GetStuckAt() ) < 75 then
				self:SetStuckCounter( self:GetStuckCounter() + 1)
				--print(self:GetStuckCounter())
			else
				self:SetStuckCounter( 0 )
				local tr1 = util_tracehull({
					start = self:GetPos(),
					endpos = self:GetPos(),
					maxs = Vector(17, 17, 85) + bloat,
					mins = Vector(-17,-17, 0) - bloat,
					filter = self
				})
				if !tr1.HitWorld then
					self:SetCollisionBounds(Vector(-19,-19, 0), Vector(19, 19, 87))
				end
			end

			if self:GetStuckCounter() >= 2 then

				self:SetCollisionBounds(Vector(-15,-15, 0), Vector(15, 15, 74))

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

function ENT:IsValidTarget( ent )
	if !ent then return false end
	return IsValid(ent) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
	-- Won't go for special targets (Monkeys), but still MAX, ALWAYS and so on
end