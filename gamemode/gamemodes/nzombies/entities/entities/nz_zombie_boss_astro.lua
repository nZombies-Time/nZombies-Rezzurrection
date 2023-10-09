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
				"nz_supersprint_lowg"
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

ENT.BehindSoundDistance = 0 -- When the zombie is within 200 units of a player, play these sounds instead

function ENT:StatsInitialize()
	if SERVER then
		local count = #player.GetAllPlaying()

		if nzRound:InState( ROUND_CREATE ) then
			self:SetHealth(5000)
			self:SetMaxHealth(5000)
		else
			if nzRound:InState( ROUND_PROG ) then
				self:SetHealth(math.Clamp(nzRound:GetNumber() * 500 + (500 * count), 1000, 10500 * count))
				self:SetMaxHealth(math.Clamp(nzRound:GetNumber() * 500 + (500 * count), 1000, 10500 * count))
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
