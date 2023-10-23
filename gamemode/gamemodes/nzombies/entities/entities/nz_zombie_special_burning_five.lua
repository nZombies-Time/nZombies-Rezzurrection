AddCSLuaFile()

ENT.Base = "nz_zombie_walker_five"
ENT.PrintName = "Burning Walker (FIVE)"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo"

function ENT:StatsInitialize()
    if SERVER then
        dying = false
		if nzRound:GetNumber() == -1 then
			self:SetRunSpeed( math.random(20, 260) )
			self:SetHealth( math.random(75, 1000) )
		else
			local speeds = nzRound:GetZombieSpeeds()
			if speeds then
				self:SetRunSpeed( nzMisc.WeightedRandom(speeds) + 35 ) -- A bit faster here
			end
			self:SetHealth( nzRound:GetZombieHealth() or 75 )
		end
        self:Flames( true )
    end
end

function ENT:Sound()
	if self.BehindSoundDistance > 0 -- We have enabled behind sounds
		and IsValid(self.Target)
		and self.Target:IsPlayer() -- We have a target and it's a player within distance
		and self:GetRangeTo(self.Target) <= self.BehindSoundDistance
		and (self.Target:GetPos() - self:GetPos()):GetNormalized():Dot(self.Target:GetAimVector()) >= 0 then -- If the direction towards the player is same 180 degree as the player's aim (away from the zombie)
			self:PlaySound(self.BehindSounds[math.random(#self.BehindSounds)], SNDLVL_140) -- Play the behind sound, and a bit louder!
	elseif self.PassiveSounds then
		self:PlaySound(self.PassiveSounds[math.random(#self.PassiveSounds)],100, math.random(65, 75)) --Lower pitched Vox cuz it sounds cooler
	else
		-- We still delay by max sound delay even if there was no sound to play
		self.NextSound = CurTime() + self.SoundDelayMax
	end
end

function ENT:OnTargetInAttackRange()
    local atkData = {}
    atkData.dmglow = 20
    atkData.dmghigh = 30
    atkData.dmgforce = Vector( 0, 0, 0 )
    self:Attack( atkData )
    if self:IsValidTarget( self:GetTarget() ) and self:TargetInRange( self.AttackRange + 10 ) then
       self:Explode( math.random( 50, 100 ) )
    end
end

function ENT:PerformDeath(dmgInfo)
    self:Explode( math.random( 25, 50 ))
	self:EmitSound(self.DeathSounds[ math.random( #self.DeathSounds ) ], 50, math.random(75, 130))
	self:BecomeRagdoll(dmgInfo)
end

