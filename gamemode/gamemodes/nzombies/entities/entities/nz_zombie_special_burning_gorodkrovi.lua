AddCSLuaFile()

ENT.Base = "nz_zombie_walker_gorodkrovi"
ENT.PrintName = "Burning Walker (Gorod Krovi)"
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

function ENT:OnTargetInAttackRange()
    local atkData = {}
    atkData.dmglow = 20
    atkData.dmghigh = 30
    atkData.dmgforce = Vector( 0, 0, 0 )
    self:Attack( atkData )
    self:TimedEvent( 0.45, function()
        if self:IsValidTarget( self:GetTarget() ) and self:TargetInRange( self.AttackRange + 10 ) then
            self:Explode( math.random( 50, 100 ) )
        end
    end)
end

function ENT:OnZombieDeath(dmgInfo)
    self:Explode( math.random( 25, 50 ))
	self:EmitSound(self.DeathSounds[ math.random( #self.DeathSounds ) ], 50, math.random(75, 130))
	self:BecomeRagdoll(dmgInfo)
end
