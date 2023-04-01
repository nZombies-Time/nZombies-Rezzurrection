AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.Type = "nextbot"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Decapitated")
	self:NetworkVar("Bool", 1, "Alive")
	self:NetworkVar("Bool", 2, "MooSpecial")
	self:NetworkVar("Bool", 3, "StinkyGas") -- For both Bombers and Jacks
	self:NetworkVar("Bool", 4, "PhaseClan") -- Jacks can teleport
	self:NetworkVar("Bool", 5, "WaterBuff")
end

function ENT:Draw() -- The only odious code here.
	self:DrawModel()
	local elight = DynamicLight( self:EntIndex(), true )
	if ( elight ) then
		local bone = self:LookupBone("j_spinelower")
		local pos, ang = self:GetBonePosition(bone)
		pos = pos 
		elight.pos = pos
		elight.r = 0
		elight.g = 255
		elight.b = 255
		elight.brightness = 11
		elight.Decay = 1000
		elight.Size = 28
		elight.DieTime = CurTime() + 1
		elight.dir = ang:Right() + ang:Forward()
		elight.innerangle = 1
		elight.outerangle = 1
		elight.style = 0
		elight.noworld = false
	end
end

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = false
ENT.IsMooSpecial = true

ENT.Models = {
	{Model = "models/moo/_codz_ports/t8/ofc_quadcrawler/moo_codz_t8_nova_crawler.mdl", Skin = 0, Bodygroups = {0,0}},
	--{Model = "models/moo/_codz_ports/t8/ofc_quadcrawler/moo_codz_t8_nova_bomber.mdl", Skin = 0, Bodygroups = {0,0}},
}

ENT.DeathSequences = {
	"nz_death_v1",
	"nz_death_v2",
	"nz_death_v3",
	"nz_death_v4",
	"nz_death_v5",
	"nz_death_v6"
}

ENT.BarricadeTearSequences = {
	--Leave this empty if you don't intend on having a special enemy use tear anims.
}

local AttackSequences = {
	{seq = "nz_attack_v1", dmgtimes = {0.7}},
	{seq = "nz_attack_v2", dmgtimes = {0.5}},
	{seq = "nz_attack_v3", dmgtimes = {0.7}},
	{seq = "nz_attack_v4", dmgtimes = {0.5}},
	{seq = "nz_attack_v5", dmgtimes = {0.7}},
	{seq = "nz_attack_v6", dmgtimes = {0.7}},
}

local JumpSequences = {
	{seq = "nz_mantle", speed = 15, time = 2.5},
}

local walksounds = {
	Sound("nz_moo/zombies/vox/_quad/amb/amb_00.mp3"),
	Sound("nz_moo/zombies/vox/_quad/amb/amb_01.mp3"),
	Sound("nz_moo/zombies/vox/_quad/amb/amb_02.mp3"),
	Sound("nz_moo/zombies/vox/_quad/amb/amb_03.mp3"),
	Sound("nz_moo/zombies/vox/_quad/amb/amb_04.mp3"),
	Sound("nz_moo/zombies/vox/_quad/amb/amb_05.mp3"),
	Sound("nz_moo/zombies/vox/_quad/amb/amb_06.mp3"),
	Sound("nz_moo/zombies/vox/_quad/amb/amb_07.mp3"),
	Sound("nz_moo/zombies/vox/_quad/amb/amb_08.mp3"),
	Sound("nz_moo/zombies/vox/_quad/amb/amb_09.mp3"),
	Sound("nz_moo/zombies/vox/_quad/amb/amb_10.mp3"),
	Sound("nz_moo/zombies/vox/_quad/amb/amb_11.mp3"),
	Sound("nz_moo/zombies/vox/_quad/amb/amb_12.mp3"),
}

ENT.IdleSequence = "nz_idle_v1"

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			MovementSequence = {
				"nz_crawl_v1",
				"nz_crawl_v2",
				"nz_crawl_v3",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 36, Sequences = {
		{
			MovementSequence = {
				"nz_crawl_run_v1",
				"nz_crawl_run_v2",
				"nz_crawl_run_v3",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 71, Sequences = {
		{
			MovementSequence = {
				"nz_crawl_sprint_v1",
				"nz_crawl_sprint_v2",
				"nz_crawl_sprint_v3",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}}
}

ENT.AttackHitSounds = {
	"nz/zombies/attack/player_hit_0.wav",
	"nz/zombies/attack/player_hit_1.wav",
	"nz/zombies/attack/player_hit_2.wav",
	"nz/zombies/attack/player_hit_3.wav",
	"nz/zombies/attack/player_hit_4.wav",
	"nz/zombies/attack/player_hit_5.wav"
}

ENT.PainSounds = {
	"nz/zombies/death/nz_flesh_impact_1.wav",
	"nz/zombies/death/nz_flesh_impact_2.wav",
	"nz/zombies/death/nz_flesh_impact_3.wav",
	"nz/zombies/death/nz_flesh_impact_4.wav"
}

ENT.DeathSounds = {
	"nz_moo/zombies/vox/_quad/death/death_00.mp3",
	"nz_moo/zombies/vox/_quad/death/death_01.mp3",
	"nz_moo/zombies/vox/_quad/death/death_02.mp3",
	"nz_moo/zombies/vox/_quad/death/death_03.mp3",
	"nz_moo/zombies/vox/_quad/death/death_04.mp3",
	"nz_moo/zombies/vox/_quad/death/death_05.mp3",
	"nz_moo/zombies/vox/_quad/death/death_06.mp3",
	"nz_moo/zombies/vox/_quad/death/death_07.mp3",
}

ENT.AttackSounds = {
	"nz_moo/zombies/vox/_quad/attack/attack_00.mp3",
	"nz_moo/zombies/vox/_quad/attack/attack_01.mp3",
	"nz_moo/zombies/vox/_quad/attack/attack_02.mp3",
	"nz_moo/zombies/vox/_quad/attack/attack_03.mp3",
	"nz_moo/zombies/vox/_quad/attack/attack_04.mp3",
	"nz_moo/zombies/vox/_quad/attack/attack_05.mp3",
	"nz_moo/zombies/vox/_quad/attack/attack_06.mp3",
	"nz_moo/zombies/vox/_quad/attack/attack_07.mp3",
	"nz_moo/zombies/vox/_quad/attack/attack_08.mp3",
	"nz_moo/zombies/vox/_quad/attack/attack_09.mp3",
	"nz_moo/zombies/vox/_quad/attack/attack_10.mp3",
	"nz_moo/zombies/vox/_quad/attack/attack_11.mp3",
	"nz_moo/zombies/vox/_quad/attack/attack_12.mp3",
	"nz_moo/zombies/vox/_quad/attack/attack_13.mp3",
}

ENT.BehindSoundDistance = 200 -- When the zombie is within 200 units of a player, play these sounds instead
ENT.BehindSounds = {
	Sound("nz_moo/zombies/vox/_quad/behind/behind_00.mp3"),
	Sound("nz_moo/zombies/vox/_quad/behind/behind_01.mp3"),
}

function ENT:StatsInitialize()
	if SERVER then
		self.NextAction = 0
		self.NextGasTime = 0
		self.NextPhaseTime = 0
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
	end
end

function ENT:SpecialInit()
	if CLIENT then
	end
end

function ENT:OnSpawn()
	if self:GetRunSpeed() > 130 then -- Novas are slower than normal zombies so this makes sense.
		timer.Simple(engine.TickInterval(), function()
			--print("Little Gremlin")
			self:SetRunSpeed(130)
			self.loco:SetDesiredSpeed( self:GetRunSpeed() )
		end)
	end
	timer.Simple(engine.TickInterval(), function()
		if IsValid(self) then
			self:EmitSound("nz_moo/zombies/vox/_quad/spawn/spawn_0"..math.random(3)..".mp3", 100, math.random(95, 105), 1, 2)
			self:EmitSound("nz_moo/effects/teleport_in_00.mp3", 100)
			if IsValid(self) then ParticleEffectAttach("panzer_spawn_tp", 3, self, 2) end
		end
	end)
end

--[[ CUSTOM/MODIFIED THINGS FROM BASE HERE ]]--

function ENT:PerformDeath(dmgInfo)
	if dmgInfo:GetDamageType() == DMG_REMOVENORAGDOLL then self:Remove(dmgInfo) end
	if self.DeathRagdollForce == 0 or self.DeathRagdollForce <= dmgInfo:GetDamageForce():Length() and dmgInfo:GetDamageType() ~= DMG_REMOVENORAGDOLL or self:GetSpecialAnimation() then
		self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
		self:Remove(dmgInfo)
	else
		self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
		self:DoDeathAnimation(self.DeathSequences[math.random(#self.DeathSequences)])
	end
end


function ENT:DoDeathAnimation(seq) -- Modified death function to have a chance of spawning a gas cloud on death.
	local GasDeathChance = math.random(2)
	self.BehaveThread = coroutine.create(function()
		self:PlaySequenceAndWait(seq)
		if GasDeathChance == 2 then
			print("Stinky Child... Gross")
			local fuckercloud = ents.Create("nova_gas_cloud")
			fuckercloud:SetPos(self:GetPos())
			fuckercloud:SetAngles(Angle(0,0,0))
			fuckercloud:Spawn()
		end
		self:Remove(DamageInfo())
	end)
end

function ENT:PlayAttackAndWait( name, speed )

	local len = self:SetSequence( name )
	speed = speed or 1

	self:ResetSequenceInfo()
	self:SetCycle( 0 )
	self:SetPlaybackRate( speed )

	local endtime = CurTime() + len / speed

	while ( true ) do

		if ( endtime < CurTime() ) then
			if !self:GetStop() then
				self:StartActivity( ACT_WALK )
				self.loco:SetDesiredSpeed( self:GetRunSpeed() )
			end
			return
		end
		if self:IsValidTarget( self:GetTarget() ) then
			self.loco:FaceTowards( self:GetTarget():GetPos() )
		end

		coroutine.yield()

	end

end

--[[ JOLTING JACK/NOVA BOMBER RELATED FUNCTIONS HERE! ]]--

function ENT:OnPathTimeOut()
	local PhaseShoot = math.random(1, 2) -- A chance to either Shoot a Plasma Ball or Teleport.
	local target = self:GetTarget()
	local larmfx_tag = self:LookupBone("j_wrist_le")
	if CurTime() < self.NextAction then return end
	
	if PhaseShoot == 1 and CurTime() > self.NextGasTime then
	
		-- Ranged Attack/Plasma Ball or Gas Ball
		if self:IsValidTarget(target) then
			local tr = util.TraceLine({
				start = self:GetPos() + Vector(0,50,0),
				endpos = target:GetPos() + Vector(0,0,50),
				filter = self,
			})
			
			if IsValid(tr.Entity) and self:IsValidTarget(tr.Entity) and !IsValid(self.StinkyGas) then

				self:SetSpecialAnimation(true)
				for i=1,1 do ParticleEffectAttach("hcea_shield_recharged",PATTACH_POINT_FOLLOW,self,2) end
				timer.Simple(1, function() if IsValid(self) then self:EmitSound("nz_moo/zombies/vox/_quad/charge/charge_0"..math.random(2)..".mp3",100,math.random(95, 105)) end end)
				timer.Simple(1, function() if IsValid(self) then self.StinkyGas = ents.Create("nz_joltingjack_shot") end end)
				timer.Simple(1, function() if IsValid(self) then self.StinkyGas:SetPos(self:GetBonePosition(larmfx_tag)) end end)
				timer.Simple(1, function() if IsValid(self) then self.StinkyGas:Spawn() end end)
				timer.Simple(1, function() if IsValid(self) then self.StinkyGas:Launch(((tr.Entity:GetPos() + Vector(0,0,50)) - self.StinkyGas:GetPos()):GetNormalized()) end end)
				timer.Simple(1, function() if IsValid(self) then self:SetStinkyGas(self.StinkyGas) end end)
				timer.Simple(1, function() if IsValid(self) then self:StopParticles() end end)
				
				-- nZ likes it when YOU are VALID!!!

				self:SetAngles((target:GetPos() - self:GetPos()):Angle())
				
				self.loco:SetDesiredSpeed(0)
				
				self:PlaySequenceAndWait("nz_attack_v6")
				
				local seq = "nz_attack_v6"
				local id, dur = self:LookupSequence(seq)
				self.loco:SetDesiredSpeed( self:GetRunSpeed() )
				self:SetSpecialAnimation(false)
				self:SetBlockAttack(false)
				--print("TODAY IS FRIDAY IN CALIFORNIA")
			
				self.NextAction = CurTime() + math.random(1, 5)
				self.NextGasTime = CurTime() + math.random(3, 15)
			end
			
		end
	elseif PhaseShoot == 2 and CurTime() > self.NextPhaseTime then
		--Teleport/Phase

		--[[The Nova doesn't actually teleport... Instead, they move SUPER quickly to a new position... With effects to simulate teleporting.]]--

		self:EmitSound("nz_moo/zombies/vox/_quad/teleport/warp_in.mp3", 100)
		self:SetBlockAttack(true)
		self:SetSpecialAnimation(true)
		self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		self:SolidMaskDuringEvent(MASK_NPCSOLID_BRUSHONLY)
		if IsValid(self) then ParticleEffectAttach("hcea_shield_impact", 3, self, 2) end

		self:SetMaterial("invisible")
		self:TimeOut(0.1) -- Timeout so the Nova can move to the new position.
		self.loco:SetDesiredSpeed( 1000 ) -- Make them move extremely fast too.
		self:SetTeleporting(true)
		self:MoveToPos(self:GetPos() + Vector(math.random(-175, 175), math.random(-175, 175), 0), {
			draw = false,
			repath = 1,
			maxage = 0.5 -- There can be times where the Nova will teleport but will fly off a ledge... The low age makes it so the Nova doesn't stay in the teleport state for long and will fix itself.
		}) 				 -- But now imagine how goofy it is when a Nova does go flying... Very :)
		--print("trolled")

		self.loco:SetDesiredSpeed( self:GetRunSpeed() ) -- Restore everything after "teleport".
		self:CollideWhenPossible()
		self:SetMaterial("")
		self:SetTeleporting(false)
		if IsValid(self) then ParticleEffectAttach("hcea_shield_impact", 3, self, 2) end
		self:EmitSound("nz_moo/zombies/vox/_quad/teleport/warp_out.mp3", 100)
		self:SetBlockAttack(false)
		self:SetSpecialAnimation(false)
		self.NextAction = CurTime() + math.random(1, 5)
		self.NextPhaseTime = CurTime() + math.random(3, 9)
		--print("Teleported")
	end
end

function ENT:OnRemove()
	if IsValid(self.StinkyGas) then self.StinkyGas:Remove() end
end
