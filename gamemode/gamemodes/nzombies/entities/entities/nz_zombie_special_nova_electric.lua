AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.Type = "nextbot"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo"
ENT.Spawnable = true

function ENT:Draw() -- The only odious code here.
	self:DrawModel()
	local elight = DynamicLight( self:EntIndex(), true )
	if ( elight ) then
		local bone = self:LookupBone("j_spineupper")
		local pos = self:GetBonePosition(bone)
		pos = pos 
		elight.pos = pos
		elight.r = 0
		elight.g = 150
		elight.b = 255
		elight.brightness = 10
		elight.Decay = 1000
		elight.Size = 40
		elight.DieTime = CurTime() + 1
		elight.style = 0
		elight.noworld = true
	end
end

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = false
ENT.IsMooSpecial = true

ENT.Models = {
	{Model = "models/moo/_codz_ports/t8/male_ofc/moo_codz_t8_quad.mdl", Skin = 0, Bodygroups = {0,0}},
}

ENT.DeathSequences = {
	"nz_quad_death_v1",
	"nz_quad_death_v2",
	"nz_quad_death_v3",
	"nz_quad_death_v4",
	"nz_quad_death_v5",
	"nz_quad_death_v6"
}

ENT.BarricadeTearSequences = {
	--Leave this empty if you don't intend on having a special enemy use tear anims.
}

local SpawnSequences = {"nz_quad_traverse_ground_fast"}

local AttackSequences = {
	{seq = "nz_quad_attack_v1"},
	{seq = "nz_quad_attack_v2"},
	{seq = "nz_quad_attack_v3"},
	{seq = "nz_quad_attack_v4"},
	{seq = "nz_quad_attack_v5"},
	{seq = "nz_quad_attack_v6"},
	{seq = "nz_quad_attack_double_v1"},
	{seq = "nz_quad_attack_double_v2"},
	{seq = "nz_quad_attack_double_v3"},
	{seq = "nz_quad_attack_double_v4"},
	{seq = "nz_quad_attack_double_v5"},
	{seq = "nz_quad_attack_double_v6"},
}

local JumpSequences = {
	{seq = "nz_quad_traverse_mantle_36"},
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

ENT.IdleSequence = "nz_quad_idle_v1"

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			MovementSequence = {
				"nz_quad_crawl_walk_v1",
				"nz_quad_crawl_walk_v2",
				"nz_quad_crawl_walk_v3",
			},
			SpawnSequence = {SpawnSequences},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 36, Sequences = {
		{
			MovementSequence = {
				"nz_quad_crawl_run_v2",
				"nz_quad_crawl_run_v3",
				"nz_quad_crawl_run_v5",
			},
			SpawnSequence = {SpawnSequences},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 71, Sequences = {
		{
			MovementSequence = {
				"nz_quad_crawl_sprint_v2",
				"nz_quad_crawl_sprint_v3", -- Theres a v1 sprint anim but it looks like shit so you don't get to have it.
			},
			SpawnSequence = {SpawnSequences},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}}
}

ENT.ElectrocutionSequences = "nz_quad_stunned_electrobolt"

ENT.UnawareSequences = {
	"nz_quad_idle_v2",
}

ENT.FreezeSequences = {
	"nz_quad_death_freeze_v1",
	"nz_quad_death_freeze_v2",
}

ENT.PhaseSequences = {
	"nz_quad_phaseforward_short_v1",
	"nz_quad_phaseforward_short_v2",
	"nz_quad_phaseright_short_v1",
	"nz_quad_phaseright_short_v2",
	"nz_quad_phaseleft_short_v1",
	"nz_quad_phaseleft_short_v2",
	"nz_quad_phaseforward_long_v1",
	"nz_quad_phaseforward_long_v2",
	"nz_quad_phaseright_long_v1",
	"nz_quad_phaseright_long_v2",
	"nz_quad_phaseleft_long_v1",
	"nz_quad_phaseleft_long_v2",
}

ENT.AttackHitSounds = {
	"nz/zombies/attack/player_hit_0.wav",
	"nz/zombies/attack/player_hit_1.wav",
	"nz/zombies/attack/player_hit_2.wav",
	"nz/zombies/attack/player_hit_3.wav",
	"nz/zombies/attack/player_hit_4.wav",
	"nz/zombies/attack/player_hit_5.wav"
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

		self.NextAction = CurTime() + 1
		self.NextGasTime = CurTime() + 5
		self.NextPhaseTime = CurTime() + 5
	end
end

function ENT:OnSpawn()

	local nav = navmesh.GetNavArea(self:GetPos(), 50)
	if IsValid(self) then ParticleEffectAttach("novagas_trail", 4, self, 2) end
	self:EmitSound("nz_moo/zombies/vox/_quad/spawn/spawn_0"..math.random(3)..".mp3", 511, math.random(95, 105), 1, 2)

	if IsValid(nav) and nav:HasAttributes(NAV_MESH_NO_JUMP) then
		if IsValid(self) then
			self:EmitSound("nz_moo/effects/teleport_in_00.mp3", 100)
			if IsValid(self) then ParticleEffect("panzer_spawn_tp", self:GetPos() + Vector(0,0,20), Angle(0,0,0), self) end

		end
		self:SolidMaskDuringEvent(MASK_PLAYERSOLID)
		self:CollideWhenPossible()
	else
		local SpawnMatSound = {
			[MAT_DIRT] = "nz_moo/zombies/spawn/dirt/pfx_zm_spawn_dirt_0"..math.random(0,1)..".mp3",
			[MAT_SNOW] = "nz_moo/zombies/spawn/snow/pfx_zm_spawn_snow_0"..math.random(0,1)..".mp3",
			[MAT_SLOSH] = "nz_moo/zombies/spawn/mud/pfx_zm_spawn_mud_00.mp3",
			[0] = "nz_moo/zombies/spawn/default/pfx_zm_spawn_default_00.mp3",
		}
		SpawnMatSound[MAT_GRASS] = SpawnMatSound[MAT_DIRT]
		SpawnMatSound[MAT_SAND] = SpawnMatSound[MAT_DIRT]

		local norm = (self:GetPos()):GetNormalized()
		local tr = util.QuickTrace(self:GetPos(), norm*10, self)

		self:SolidMaskDuringEvent(MASK_PLAYERSOLID)

		if tr.Hit then
			local finalsound = SpawnMatSound[tr.MatType] or SpawnMatSound[0]
			self:EmitSound(finalsound)
		end

		ParticleEffect("bo3_zombie_spawn",self:GetPos()+Vector(0,0,1),self:GetAngles(),self)
		self:EmitSound("nz/zombies/spawn/zm_spawn_dirt"..math.random(1,2)..".wav",80,math.random(95,105))

		self:SetSpecialAnimation(true)
		self:SetIsBusy(true)
		local seq = self:SelectSpawnSequence()

		if seq then
			self:PlaySequenceAndMove(seq, {gravity = true})
			self:SetSpecialAnimation(false)
			self:SetIsBusy(false)
			self:CollideWhenPossible()
		end
	end
end


function ENT:PerformDeath(dmginfo)
	local damagetype = dmginfo:GetDamageType()
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
		if self:RagdollForceTest(dmginfo:GetDamageForce()) then
			if self.DeathSounds then
				self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
			end
			self:BecomeRagdoll(dmginfo)
		elseif damagetype == DMG_SHOCK then
			if self.ElecSounds then
				self:PlaySound(self.ElecSounds[math.random(#self.ElecSounds)], 90, math.random(85, 105), 1, 2)
			end
			self:DoDeathAnimation(self.ElectrocutionSequences[math.random(#self.ElectrocutionSequences)])
		else
			if self.DeathSounds then
				self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
			end
			self:DoDeathAnimation(self.DeathSequences[math.random(#self.DeathSequences)])
		end
	end
end

function ENT:PostDeath(dmginfo)
	if math.random(2) == 2 then
		--print("Stinky Child... Gross")
		local fuckercloud = ents.Create("nova_gas_cloud")
		fuckercloud:SetPos(self:GetPos())
		fuckercloud:SetAngles(Angle(0,0,0))
		fuckercloud:Spawn()
	end
end

function ENT:HandleAnimEvent(a,b,c,d,e) -- Moo Mark 4/14/23: You don't know how sad I am that I didn't know about this sooner.
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
	if e == "melee_whoosh" then
		self:EmitSound("nz_moo/zombies/fly/attack/whoosh/zmb_attack_med_0"..math.random(0,2)..".mp3", 75, math.random(95,105))
	end
	if e == "quad_crawl" then
		self:EmitSound("nz_moo/zombies/footsteps/crawl/crawl_0"..math.random(0,3)..".mp3", 65, math.random(95,105))
	end
	if e == "quad_phase_in" then
		self:EmitSound("nz_moo/zombies/vox/_quad/teleport/warp_in.mp3", 100)
		if IsValid(self) then ParticleEffectAttach("hcea_shield_impact", 3, self, 2) end
		self:SetNoDraw(true)
	end
	if e == "quad_phase_out" then
		self:SetNoDraw(false)
		if IsValid(self) then ParticleEffectAttach("hcea_shield_impact", 3, self, 2) end
		self:EmitSound("nz_moo/zombies/vox/_quad/teleport/warp_out.mp3", 100)
	end
	if e == "spit_attack" then
		local larmfx_tag = self:LookupBone("j_wrist_le")
		local tr = util.TraceLine({
			start = self:GetPos() + Vector(0,50,0),
			endpos = self:GetTarget():GetPos() + Vector(0,0,50),
			filter = self,
		})
			
		if IsValid(tr.Entity) and !IsValid(self.ZapShot) then
			self:EmitSound("nz_moo/zombies/vox/_quad/charge/charge_0"..math.random(2)..".mp3",100,math.random(95, 105))
			self.ZapShot = ents.Create("nz_electric_quad_shot")
			self.ZapShot:SetPos(self:GetBonePosition(larmfx_tag))
			self.ZapShot:Spawn()
			self.ZapShot:Launch(((tr.Entity:GetPos() + Vector(0,0,50)) - self.ZapShot:GetPos()):GetNormalized())
			self:StopParticles()	
		end
	end
end

function ENT:OnRemove()
	if IsValid(self.ZapShot) then self.ZapShot:Remove() end
end

if SERVER then
	function ENT:OnTakeDamage(dmginfo)
		if (dmginfo:GetDamageType() == DMG_DISSOLVE and dmginfo:GetDamage() >= self:Health() and self:Health() > 0) then
			self:DissolveEffect()
		end

		if dmginfo:GetDamage() == 75 and dmginfo:IsDamageType(DMG_MISSILEDEFENSE) and !self:GetSpecialAnimation() then
			self:SetTarget(nil)
			--print("Uh oh Luigi, I'm about to commit insurance fraud lol.")
			self:TempBehaveThread(function(self)
				self:TimeOut(0)
				self:SetSpecialAnimation(true)

				self:SolidMaskDuringEvent(MASK_PLAYERSOLID, collision)
				self:PlaySequenceAndMove("nz_quad_knockdown_faceup")
				self:PlaySequenceAndMove("nz_quad_getup_faceup")
				if !self:GetSpecialShouldDie() and IsValid(self) and self:Alive() then
					self:CollideWhenPossible()
					self:SetSpecialAnimation(false)
				end
			end)
		end

		self:SetLastHurt(CurTime())
	end
	
	function ENT:PerformIdle()
		if self:GetSpecialAnimation() and !self.IsTornado then return end
		if (self.BO4IsShocked and self:BO4IsShocked() or self.BO4IsScorped and self:BO4IsScorped() or self.BO4IsSpinning and self:BO4IsSpinning() or self:GetNW2Bool("OnAcid")) and !self:GetCrawler() then
			self:ResetSequence(self.ElectrocutionSequences)
		elseif self.BO3IsMystified and self:BO3IsMystified() then
			self:ResetSequence(self.UnawareAnim)
		elseif self.BO4IsTornado and self:BO4IsTornado() and self.IsTornado then
			self:ResetSequence(self.ElectrocutionSequences)
		else
			self:ResetSequence(self.IdleSequence)
		end
	end

	function ENT:ZombieStatusEffects()
		if CurTime() > self.LastStatusUpdate then
			if self.IsTurned or !self:Alive() then return end

			if self:GetSpecialAnimation() and !self.CanCancelSpecial then return end
			if self.BO3IsSlipping and self:BO3IsSlipping() then
				--print("Uh oh Luigi, I've been played for a fool lol.")
				self:TempBehaveThread(function(self)
					self:TimeOut(0)
					self:SetSpecialAnimation(true)

					self:SolidMaskDuringEvent(MASK_PLAYERSOLID, collision)
					self:PlaySequenceAndMove("nz_quad_knockdown_facedown")
					self:PlaySequenceAndMove("nz_quad_getup_facedown")
					if !self:GetSpecialShouldDie() and IsValid(self) and self:Alive() then
						self:CollideWhenPossible()
						self:SetSpecialAnimation(false)
					end
				end)
			end
			if self.BO3IsSkullStund and self:BO3IsSkullStund() then
				--print("Uh oh Mario, I'm ASCENDING lol.")
				self:DoSpecialAnimation(self.ElectrocutionSequences[math.random(#self.ElectrocutionSequences)])
			end
			if self.BO3IsCooking and self:BO3IsCooking() then
				--print("Uh oh Mario, I'm about to fucking inflate lol.")
				self:SetSpecialShouldDie(true)
				self:DoSpecialAnimation(self.ElectrocutionSequences[math.random(#self.ElectrocutionSequences)])
			end
			if self.BO4IsFrozen and self:BO4IsFrozen() and !self:GetSpecialAnimation() then
				--print("Uh oh Mario, I'm frozen lol.")
				self:SetSpecialShouldDie(true)
				self:DoSpecialAnimation(self.FreezeSequences[math.random(#self.FreezeSequences)])
			end
			if self.BO4IsShrunk and self:BO4IsShrunk() then
				self:DoSpecialAnimation(self.DeathSequences[math.random(#self.DeathSequences)])
			end
			if self.IsATTCryoFreeze and self:IsATTCryoFreeze() then 
				self:SetSpecialShouldDie(true)
				self:DoSpecialAnimation(self.FreezeSequences[math.random(#self.FreezeSequences)])
			end
			self.LastStatusUpdate = CurTime() + 0.25
		end
	end
end

function ENT:OnPathTimeOut()
	local PhaseShoot = math.random(2) -- A chance to either Shoot a Plasma Ball or Teleport.
	local target = self:GetTarget()
	if CurTime() < self.NextAction then return end
	if !self:IsAttackBlocked() then
		if PhaseShoot == 1 and CurTime() > self.NextGasTime then
			-- Ranged Attack/Plasma Ball or Gas Ball
			if target:IsPlayer() then
				for i=1,1 do ParticleEffectAttach("hcea_shield_recharged",PATTACH_POINT_FOLLOW,self,2) end
				self:PlaySequenceAndMove("nz_quad_spit_attack", 1, self.FaceEnemy)
				--print("TODAY IS FRIDAY IN CALIFORNIA")
			
				self.NextAction = CurTime() + math.random(1, 5)
				self.NextGasTime = CurTime() + math.random(3, 15)
			end
		elseif PhaseShoot == 2 and CurTime() > self.NextPhaseTime then
			--Teleport/Phase
			local seq = self.PhaseSequences[math.random(#self.PhaseSequences)]
			if self:SequenceHasSpace(seq) then
				self:DoSpecialAnimation(seq, true, true)
			end

			self.NextAction = CurTime() + math.random(1, 5)
			self.NextPhaseTime = CurTime() + math.random(3, 9)
		end
	end
end

function ENT:OnRemove()
	if IsValid(self.ZapShot) then self.ZapShot:Remove() end
end
