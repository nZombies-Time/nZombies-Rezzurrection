AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "I've adopted a funny little squid creature from Laby"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo"

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.RedEyes = false
ENT.SpeedBasedSequences = true

ENT.IsMooZombie = true
ENT.IsMooSpecial = true
ENT.IsMooBossZombie = true

ENT.AttackDamage = 75
ENT.AttackRange = 150
ENT.DamageRange = 150

ENT.TraversalCheckRange = 50

ENT.Models = {
	{Model = "models/moo/_codz_ports/t7/genesis/moo_codz_t7_genesis_margwa_shadow.mdl", Skin = 0, Bodygroups = {0,0}},
}

local util_tracehull = util.TraceHull
local spawn = {"nz_margwa_spawn"}

local SlamAttackSequences = {
	{seq = "nz_margwa_attack_slam"},
}

local AttackSequences = {
	{seq = "nz_margwa_attack_player"},
}

local JumpSequences = {
	{seq = "nz_margwa_trv_36"},
}

local walksounds = {
	Sound("nz_moo/zombies/vox/_margwa/vox/ambient/vox_ambient_00.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/vox/ambient/vox_ambient_01.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/vox/ambient/vox_ambient_02.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/vox/ambient/vox_ambient_03.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/vox/ambient/vox_ambient_04.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/vox/ambient/vox_ambient_05.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/vox/ambient/vox_ambient_06.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/vox/ambient/vox_ambient_07.mp3"),
}

ENT.IdleSequence = "nz_margwa_idle"

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			MovementSequence = {
				"nz_margwa_walk",
			},
			SpawnSequence = {spawn},
			AttackSequences = {AttackSequences},
			StandAttackSequences = {SlamAttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 71, Sequences = {
		{
			MovementSequence = {
				"nz_margwa_run",
			},
			SpawnSequence = {spawn},
			AttackSequences = {AttackSequences},
			StandAttackSequences = {SlamAttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}}
}

ENT.AttackSounds = {
	Sound("nz_moo/zombies/vox/_margwa/vox/attack/vox_attack_00.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/vox/attack/vox_attack_01.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/vox/attack/vox_attack_02.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/vox/attack/vox_attack_03.mp3"),
}

ENT.AttackRaiseSounds = {
	Sound("nz_moo/zombies/vox/_margwa/vox/attack_warn/vox_attack_raise_00.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/vox/attack_warn/vox_attack_raise_01.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/vox/attack_warn/vox_attack_raise_02.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/vox/attack_warn/vox_attack_raise_03.mp3"),
}

ENT.PainSounds = {
	Sound("nz_moo/zombies/vox/_margwa/vox/pain/vox_pain_00.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/vox/pain/vox_pain_01.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/vox/pain/vox_pain_02.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/vox/pain/vox_pain_03.mp3"),
}

ENT.DeathSounds = {
	Sound("nz_moo/zombies/vox/_margwa/vox/death/vox_death_00.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/vox/death/vox_death_01.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/vox/death/vox_death_02.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/vox/death/vox_death_03.mp3"),
}

ENT.StompSounds = {
	Sound("nz_moo/zombies/vox/_margwa/step/step_00.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/step/step_01.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/step/step_02.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/step/step_03.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/step/step_04.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/step/step_05.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/step/step_06.mp3"),
}

ENT.HeadExploSounds = {
	Sound("nz_moo/zombies/vox/_margwa/head_explo/margwa_head_explo_0.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/head_explo/margwa_head_explo_1.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/head_explo/margwa_head_explo_2.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/head_explo/margwa_head_explo_3.mp3"),
}

ENT.WhipAttackSounds = {
	Sound("nz_moo/zombies/vox/_margwa/whip_attack/whip_attack_0.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/whip_attack/whip_attack_1.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/whip_attack/whip_attack_2.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/whip_attack/whip_attack_3.mp3"),
}

ENT.BehindSoundDistance = 0 -- When the zombie is within 200 units of a player, play these sounds instead

function ENT:StatsInitialize()
	if SERVER then
		local count = #player.GetAllPlaying()

		if nzRound:InState( ROUND_CREATE ) then
			self:SetHealth(4500)
			self:SetMaxHealth(4500)
		else
			if nzRound:InState( ROUND_PROG ) then
				self:SetHealth(math.Clamp(nzRound:GetNumber() * 500 + (500 * count), 4500, 10500 * count))
				self:SetMaxHealth(math.Clamp(nzRound:GetNumber() * 500 + (500 * count), 4500, 10500 * count))
			else
				self:SetHealth(5000)
				self:SetMaxHealth(5000)	
			end
		end

		self.MidHeadHP = self:Health() / 10
		self.LeftHeadHP = self:Health() / 10
		self.RightHeadHP = self:Health() / 10

		self.MidHead = true
		self.LeftHead = true
		self.RightHead = true

		self.HeadCount = 0

		self.LostAHead = false
		self.GainSpeed = false

		self.IFrames = CurTime() + 3

		self:SetRunSpeed(36)
	end
end

function ENT:SpecialInit()
	if CLIENT then
	end
end

function ENT:OnSpawn()
	local seq = self:SelectSpawnSequence()
	local _, dur = self:LookupSequence(seq)

	local effectData = EffectData()
	effectData:SetOrigin( self:GetPos() + Vector(0, 0, 50)  )
	effectData:SetMagnitude( 5 )
	effectData:SetEntity(nil)
	util.Effect("panzer_spawn_tp", effectData)

	self:SetBodygroup(1,0)
	self:SetBodygroup(2,0)
	self:SetBodygroup(3,0)

	self:SetCollisionBounds(Vector(-14,-14, 0), Vector(14, 14, 72))
	self:SetSurroundingBounds(Vector(-50, -50, 0), Vector(50, 50, 100))
		
	self:SolidMaskDuringEvent(MASK_SOLID_BRUSHONLY)
	self:SetInvulnerable(true)
	self:SetSpecialAnimation(true)

	self:SetNoDraw(true)

	self:EmitSound("nz_moo/zombies/vox/_margwa/spawn/spawn.mp3",511)
	self:EmitSound("nz_moo/zombies/vox/_margwa/spawn/spawn_2d.mp3",511)
	ParticleEffect("hcea_hunter_shade_cannon_explode_flash",self:GetPos(),self:GetAngles(),nil)
	self:TimeOut(2.85)


	if seq then
		self:StopParticles()
		self:SetNoDraw(false)
    	ParticleEffect("hcea_hunter_shade_cannon_explode_ground",self:GetPos(),self:GetAngles(),nil)
		self:EmitSound("enemies/bosses/margwa/teleport_in.ogg", 80, math.random(95,105))
		self:PlaySequenceAndWait(seq)
		self:SetSpecialAnimation(false)
		self:SetInvulnerable(false)
		self:CollideWhenPossible()
	end
end

function ENT:HandleAnimEvent(a,b,c,d,e) -- Moo Mark 4/14/23: You don't know how sad I am that I didn't know about this sooner.
	if e == "swipe_whoosh" then
		self:EmitSound(self.WhipAttackSounds[math.random(#self.WhipAttackSounds)], 80, math.random(95,105))
	end
	if e == "slam_whoosh" then
		self:EmitSound(self.AttackRaiseSounds[math.random(#self.AttackRaiseSounds)], 80, math.random(95,105))
	end
	if e == "slam_hit" then
		self:EmitSound("nz_moo/zombies/vox/_margwa/slam_attack/slam_attack_close.mp3", 100)
		self:EmitSound("nz_moo/zombies/vox/_margwa/slam_attack/slam_attack_far.mp3", 511)
		ParticleEffect("bo3_margwa_slam",self:GetPos(),self:GetAngles(),nil)
		util.ScreenShake(self:GetPos(),100000,500000,0.4,2000)
		
		self:DoAttackDamage()
	end
	if e == "swipe_hit" then
		if self.AttackSounds then
			self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2)
		end
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
	if e == "lstep" then
		self:EmitSound(self.StompSounds[math.random(#self.StompSounds)],80,math.random(95,100))
		--self:EmitSound("nz_moo/zombies/vox/_cellbreaker/fly/keys/rattle_0"..math.random(0,4)..".mp3",80,math.random(95,100))
		util.ScreenShake(self:GetPos(),100000,500000,0.2,1000)
		ParticleEffectAttach("shdw_margwa_footstep",PATTACH_POINT,self,5)
	end
	if e == "rstep" then
		self:EmitSound(self.StompSounds[math.random(#self.StompSounds)],80,math.random(95,100))
		--self:EmitSound("nz_moo/zombies/vox/_cellbreaker/fly/keys/rattle_0"..math.random(0,4)..".mp3",80,math.random(95,100))
		util.ScreenShake(self:GetPos(),100000,500000,0.2,1000)
		ParticleEffectAttach("shdw_margwa_footstep",PATTACH_POINT,self,6)
	end
	if e == "teleport_in" then
		self:SetNoDraw(false)
	end
	if e == "teleport_out" then
		self:SetNoDraw(true)
		local effectData = EffectData()
		effectData:SetOrigin( self:GetPos() + Vector(0, 0, 50)  )
		effectData:SetMagnitude( 5 )
		effectData:SetEntity(nil)
		util.Effect("panzer_spawn_tp", effectData)
	end
end

function ENT:PerformDeath(dmgInfo)
	self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
	self:DoDeathAnimation("nz_margwa_death")
end

function ENT:DoDeathAnimation(seq)
	self.BehaveThread = coroutine.create(function()
		self:SetSpecialAnimation(true)
		self:PlaySequenceAndWait(seq)
        ParticleEffect("bo3_margwa_death",self:GetPos(),self:GetAngles(),nil)
		self:Remove(DamageInfo())
	end)
end

function ENT:OnInjured(dmginfo)
	if !self:Alive() then return end

	local hitpos = dmginfo:GetDamagePosition()
	local hitgroup = util.QuickTrace(dmginfo:GetDamagePosition(), dmginfo:GetDamagePosition()).HitGroup
	local hitforce = dmginfo:GetDamageForce()
	local damage = dmginfo:GetDamage()

	local attacker = dmginfo:GetAttacker()


	local middlehead = self:GetBonePosition(self:LookupBone("j_head"))

	local lefthead = self:GetBonePosition(self:LookupBone("j_head_le"))

	local righthead = self:GetBonePosition(self:LookupBone("j_head_ri"))

	if hitpos:DistToSqr(middlehead) < 31^2 and self.MidHead and CurTime() > self.IFrames then
		if self.MidHeadHP > 0 then
			self.MidHeadHP = self.MidHeadHP - damage
		else
			self.IFrames = CurTime() + 3
			self.LostAHead = true
			self.MidHead = false
			self.HeadCount = self.HeadCount + 1
			self:SetBodygroup(2,1)
    		ParticleEffectAttach("hcea_hunter_shade_cannon_explode_ergy_fbl_trcr_ball_smk", 4, self, 2)
    		self:EmitSound(self.HeadExploSounds[math.random(#self.HeadExploSounds)], 511)
    		self:EmitSound(self.PainSounds[math.random(#self.PainSounds)], 100, math.random(85,105))

    		if IsValid(attacker) then
    			attacker:GivePoints(500)
    		end
    		timer.Simple(engine.TickInterval(), function()
				if self.HeadCount >= 3 then
					self:OnKilled(dmginfo)
				else
					self:TempBehaveThread(function(self)
						self:SetSpecialAnimation(true)
						self:SolidMaskDuringEvent(MASK_PLAYERSOLID, collision)
						self:PlaySequenceAndMove("nz_margwa_shdw_mid_head_explode", {gravity = true})
						self:CollideWhenPossible()
						self:SetSpecialAnimation(false) -- Stops them from going back to idle.
					end)
				end
			end)
		end
	end
	if hitpos:DistToSqr(lefthead) < 31^2 and self.LeftHead and CurTime() > self.IFrames then
		if self.LeftHeadHP > 0 then
			self.LeftHeadHP = self.LeftHeadHP - damage
		else
			self.IFrames = CurTime() + 3
			self.LostAHead = true
			self.LeftHead = false
			self.HeadCount = self.HeadCount + 1
			self:SetBodygroup(1,1)
    		ParticleEffectAttach("hcea_hunter_shade_cannon_explode_ergy_fbl_trcr_ball_smk", 4, self, 3)
    		self:EmitSound(self.HeadExploSounds[math.random(#self.HeadExploSounds)], 511)
    		self:EmitSound(self.PainSounds[math.random(#self.PainSounds)], 100, math.random(85,105))

    		if IsValid(attacker) then
    			attacker:GivePoints(500)
    		end
    		timer.Simple(engine.TickInterval(), function()
				if self.HeadCount >= 3 then
					self:OnKilled(dmginfo)
				else
					self:TempBehaveThread(function(self)
						self:SetSpecialAnimation(true)
						self:SolidMaskDuringEvent(MASK_PLAYERSOLID, collision)
						self:PlaySequenceAndMove("nz_margwa_shdw_le_head_explode", {gravity = true})
						self:CollideWhenPossible()
						self:SetSpecialAnimation(false) -- Stops them from going back to idle.
					end)
				end
			end)
		end
	end
	if hitpos:DistToSqr(righthead) < 31^2 and self.RightHead and CurTime() > self.IFrames then
		if self.RightHeadHP > 0 then
			self.RightHeadHP = self.RightHeadHP - damage
		else
			self.IFrames = CurTime() + 3
			self.LostAHead = true
			self.RightHead = false
			self.HeadCount = self.HeadCount + 1
			self:SetBodygroup(3,1)
    		ParticleEffectAttach("hcea_hunter_shade_cannon_explode_ergy_fbl_trcr_ball_smk", 4, self, 4)
    		self:EmitSound(self.HeadExploSounds[math.random(#self.HeadExploSounds)], 511)
    		self:EmitSound(self.PainSounds[math.random(#self.PainSounds)], 100, math.random(85,105))

    		if IsValid(attacker) then
    			attacker:GivePoints(500)
    		end
    		timer.Simple(engine.TickInterval(), function()
				if self.HeadCount >= 3 then
					self:OnKilled(dmginfo)
				else
					self:TempBehaveThread(function(self)
						self:SetSpecialAnimation(true)
						self:SolidMaskDuringEvent(MASK_PLAYERSOLID, collision)
						self:PlaySequenceAndMove("nz_margwa_shdw_ri_head_explode", {gravity = true})
						self:CollideWhenPossible()
						self:SetSpecialAnimation(false) -- Stops them from going back to idle.
					end)
				end
			end)
		end
	end

	dmginfo:ScaleDamage(0.05) -- My fella here takes a small amount of damage normally... Shoot their heads.

end


function ENT:OnRemove()
end

function ENT:IsValidTarget( ent )
	if !ent then return false end
	return IsValid(ent) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
	-- Won't go for special targets (Monkeys), but still MAX, ALWAYS and so on
end

function ENT:AI()
	local target = self:GetTarget()

	-- TELEPORT
	if IsValid(target) and target:IsPlayer() then
		if !self:TargetInRange(1500) then
			local pos = self:FindSpotBehindPlayer(target:GetPos(), 10)
			self:TempBehaveThread(function(self)
				self:SetSpecialAnimation(true)

				self:SolidMaskDuringEvent(MASK_PLAYERSOLID, collision)
				self:PlaySequenceAndMove("nz_margwa_teleport_out", {gravity = true})

				self:PlaySequenceAndMove("nz_margwa_teleport_in", {gravity = true})

				ParticleEffect("hcea_hunter_shade_cannon_explode_ground",pos,self:GetAngles(),nil)
				self:EmitSound("enemies/bosses/margwa/teleport_in.ogg", 80, math.random(95,105))		

    			self:SetPos( pos )


				self:PlaySequenceAndMove("nz_margwa_spawn", {gravity = true})

				self:CollideWhenPossible()
				self:SetSpecialAnimation(false) -- Stops them from going back to idle.
			end)
		end
		if self:TargetInRange(1000) and !self:IsAttackBlocked() and math.random(10) == 10 then
			self:TempBehaveThread(function(self)
				self.IFrames = CurTime() + 3
				self:SetSpecialAnimation(true)
				self:SolidMaskDuringEvent(MASK_PLAYERSOLID, collision)
				for i = 1, 5 do 
					local pacman = ents.Create("nz_misc_chomper")
					pacman:SetPos(self:GetPos() + Vector(0,0,35))
					pacman:SetAngles((target:GetPos() - self:GetPos()):Angle())
					pacman:Spawn()
        			ParticleEffect("hcea_hunter_shade_cannon_explode_flash",self:GetPos(),self:GetAngles(),nil)
					self:PlaySequenceAndMove("nz_margwa_attack_player", {gravity = true})
				end
				self:CollideWhenPossible()
				self:SetSpecialAnimation(false) -- Stops them from going back to idle.
			end)
		end
	end

	-- ENRAGE
	if self.LostAHead and !self.GainSpeed then
		self.GainSpeed = true
		self:SetRunSpeed(71)
		self:SpeedChanged()
	end

	-- Knock normal zombies aside
	for k,v in nzLevel.GetZombieArray() do
		if IsValid(v) and !v:GetSpecialAnimation() and v.IsMooZombie and !v.Non3arcZombie and !v.IsMooSpecial and v ~= self then
			if self:GetRangeTo( v:GetPos() ) < 9^2 then	
				if v.IsMooZombie and !v.IsMooSpecial and !v:GetSpecialAnimation() then
					if v.PainSequences then
						v:DoSpecialAnimation(v.PainSequences[math.random(#v.PainSequences)], true, true)
					end
				end
			end
		end
	end
end
