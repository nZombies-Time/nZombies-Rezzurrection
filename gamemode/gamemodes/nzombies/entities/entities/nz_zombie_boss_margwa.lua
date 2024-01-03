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
	Sound("enemies/bosses/margwa/vox/vox_ambient_01.ogg"),
	Sound("enemies/bosses/margwa/vox/vox_ambient_02.ogg"),
	Sound("enemies/bosses/margwa/vox/vox_ambient_03.ogg"),
	Sound("enemies/bosses/margwa/vox/vox_ambient_04.ogg"),
	Sound("enemies/bosses/margwa/vox/vox_ambient_05.ogg"),
	Sound("enemies/bosses/margwa/vox/vox_ambient_06.ogg"),
	Sound("enemies/bosses/margwa/vox/vox_ambient_07.ogg"),
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
	Sound("enemies/bosses/margwa/vox/vox_attack_01.ogg"),
	Sound("enemies/bosses/margwa/vox/vox_attack_02.ogg"),
	Sound("enemies/bosses/margwa/vox/vox_attack_03.ogg"),
}

ENT.DeathSounds = {
	Sound("enemies/bosses/margwa/vox/vox_death_01.ogg"),
	Sound("enemies/bosses/margwa/vox/vox_death_02.ogg"),
	Sound("enemies/bosses/margwa/vox/vox_death_03.ogg"),
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

		self.MidHeadHP = self:Health() / 4
		self.LeftHeadHP = self:Health() / 4
		self.RightHeadHP = self:Health() / 4

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

	self:SetCollisionBounds(Vector(-40,-40, 0), Vector(40, 40, 100))
	--self:SetModelScale(0.9,0.00001)

	self:SolidMaskDuringEvent(MASK_SOLID_BRUSHONLY)
	self:SetInvulnerable(true)
	self:SetSpecialAnimation(true)

	self:SetNoDraw(true)

	self:EmitSound("enemies/bosses/margwa/spawn.ogg",511)
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
		self:EmitSound("enemies/bosses/margwa/whip_attack_"..math.random(3)..".ogg", 80, math.random(95,105))
	end
	if e == "slam_whoosh" then
		self:EmitSound("enemies/bosses/margwa/vox/vox_attack_raise_0"..math.random(3)..".ogg", 80, math.random(95,105))
	end
	if e == "slam_hit" then
		self:EmitSound("enemies/bosses/margwa/slam_attack_close.ogg", 100)
		self:EmitSound("enemies/bosses/margwa/slam_attack_far.ogg", 511)
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
		self:EmitSound("enemies/bosses/margwa/step_0"..math.random(6)..".ogg",80,math.random(95,100))
		--self:EmitSound("nz_moo/zombies/vox/_cellbreaker/fly/keys/rattle_0"..math.random(0,4)..".mp3",80,math.random(95,100))
		util.ScreenShake(self:GetPos(),100000,500000,0.2,1000)
		ParticleEffectAttach("shdw_margwa_footstep",PATTACH_POINT,self,5)
	end
	if e == "rstep" then
		self:EmitSound("enemies/bosses/margwa/step_0"..math.random(6)..".ogg",80,math.random(95,100))
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

	if hitpos:DistToSqr(middlehead) < 29.26^2 and self.MidHead and CurTime() > self.IFrames then
		if self.MidHeadHP > 0 then
			self.MidHeadHP = self.MidHeadHP - damage
		else
			self.IFrames = CurTime() + 3
			self.LostAHead = true
			self.MidHead = false
			self.HeadCount = self.HeadCount + 1
			self:SetBodygroup(2,1)
    		ParticleEffectAttach("hcea_hunter_shade_cannon_explode_ergy_fbl_trcr_ball_smk", 4, self, 2)
    		self:EmitSound("enemies/bosses/margwa/margwa_head_explo_"..math.random(3)..".ogg", 511)
    		self:EmitSound("enemies/bosses/margwa/vox/vox_pain_0"..math.random(1,3)..".ogg", 100, math.random(85,105))

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
	if hitpos:DistToSqr(lefthead) < 29.26^2 and self.LeftHead and CurTime() > self.IFrames then
		if self.LeftHeadHP > 0 then
			self.LeftHeadHP = self.LeftHeadHP - damage
		else
			self.IFrames = CurTime() + 3
			self.LostAHead = true
			self.LeftHead = false
			self.HeadCount = self.HeadCount + 1
			self:SetBodygroup(1,1)
    		ParticleEffectAttach("hcea_hunter_shade_cannon_explode_ergy_fbl_trcr_ball_smk", 4, self, 3)
    		self:EmitSound("enemies/bosses/margwa/margwa_head_explo_"..math.random(3)..".ogg", 511)
    		self:EmitSound("enemies/bosses/margwa/vox/vox_pain_0"..math.random(1,3)..".ogg", 100, math.random(85,105))

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
	if hitpos:DistToSqr(righthead) < 29.26^2 and self.RightHead and CurTime() > self.IFrames then
		if self.RightHeadHP > 0 then
			self.RightHeadHP = self.RightHeadHP - damage
		else
			self.IFrames = CurTime() + 3
			self.LostAHead = true
			self.RightHead = false
			self.HeadCount = self.HeadCount + 1
			self:SetBodygroup(3,1)
    		ParticleEffectAttach("hcea_hunter_shade_cannon_explode_ergy_fbl_trcr_ball_smk", 4, self, 4)
    		self:EmitSound("enemies/bosses/margwa/margwa_head_explo_"..math.random(3)..".ogg", 511)
    		self:EmitSound("enemies/bosses/margwa/vox/vox_pain_0"..math.random(1,3)..".ogg", 100, math.random(85,105))

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
	if self.LostAHead and !self.GainSpeed then
		self.GainSpeed = true
		self:SetRunSpeed(71)
		self:SpeedChanged()
	end
end

if SERVER then
	-- Collide When Possible
	local collidedelay = 0.25
	local bloat = Vector(5,5,0)
	function ENT:Think()
		if (self:IsAllowedToMove() and !self:GetCrawler() and self.loco:GetVelocity():Length2D() >= 125 and self.SameSquare and !self:GetIsBusy() or self:IsAllowedToMove() and self:GetAttacking() ) then -- Moo Mark
        	self.loco:SetVelocity(self:GetForward() * self:GetRunSpeed())
        end
		if self.DoCollideWhenPossible then
			if not self.NextCollideCheck or self.NextCollideCheck < CurTime() then
				local mins,maxs = self:GetCollisionBounds()
				local tr = util_tracehull({
					start = self:GetPos(),
					endpos = self:GetPos(),
					filter = self,
					mask = MASK_NPCSOLID,
					mins = mins - bloat,
					maxs = maxs + bloat,
					ignoreworld = true
				})

				local b = tr.Entity
				if !IsValid(b) then 
					self:SetSolidMask(MASK_NPCSOLID)
					self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
					self.DoCollideWhenPossible = nil
					self.NextCollideCheck = nil
				else
					self.NextCollideCheck = CurTime() + collidedelay
				end
			end
		end


        if CurTime() > self.SpawnProtectionTime and self.SpawnProtection then
        	self.SpawnProtection = false
        	--print("Can be hurt")
        end
        
		self:StuckPrevention()
		self:ZombieStatusEffects()

		if not self.NextSound or self.NextSound < CurTime() then
			self:Sound()
		end

		self:DebugThink()
		self:OnThink()
	end
	function ENT:StuckPrevention()
		if !self:GetIsBusy() and !self:GetSpecialAnimation() and !self:GetAttacking() and self:GetLastPostionSave() + 0.25 < CurTime() then
			if self:GetPos():DistToSqr( self:GetStuckAt() ) < 75 then
				self:SetStuckCounter( self:GetStuckCounter() + 1)
				--print(self:GetStuckCounter())
			else
				self:SetStuckCounter( 0 )
				local tr1 = util_tracehull({
					start = self:GetPos(),
					endpos = self:GetPos(),
					maxs = Vector(38, 38, 99) + bloat,
					mins = Vector(-38,-38, 0) - bloat,
					filter = self
				})
				if !tr1.HitWorld then
					self:SetCollisionBounds(Vector(-40,-40, 0), Vector(40, 40, 100))
				end
			end

			if self:GetStuckCounter() >= 2 then

				self:SetCollisionBounds(Vector(-20,-20, 0), Vector(20, 20, 85))

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
