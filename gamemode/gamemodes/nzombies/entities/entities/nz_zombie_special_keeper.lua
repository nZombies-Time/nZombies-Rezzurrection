AddCSLuaFile()

ENT.Base = "nz_zombiebase"
ENT.PrintName = "Keeper"
ENT.Category = "Brainz"
ENT.Author = "Ruko"

--ENT.Models = { "models/boz/killmeplease.mdl" }
ENT.Models = { "models/specials/goalkeeper.mdl" }

ENT.AttackRange = 60
ENT.DamageLow = 40
ENT.DamageHigh = 50

ENT.AttackSequences = {
	{seq = "melee_run"}
}

ENT.DeathSequences = {
	"nz_death1",
	"nz_death2",
	"nz_death3"
}

ENT.AttackSounds = {
	"nz/hellhound/attack/attack_00.wav",
	"nz/hellhound/attack/attack_01.wav",
	"nz/hellhound/attack/attack_02.wav",
	"nz/hellhound/attack/attack_03.wav",
	"nz/hellhound/attack/attack_04.wav",
	"nz/hellhound/attack/attack_05.wav",
	"nz/hellhound/attack/attack_06.wav"
}

ENT.AttackHitSounds = {
	"effects/hit/evt_zombie_hit_player_01.ogg",
	"effects/hit/evt_zombie_hit_player_02.ogg",
	"effects/hit/evt_zombie_hit_player_03.ogg",
	"effects/hit/evt_zombie_hit_player_04.ogg",
	"effects/hit/evt_zombie_hit_player_05.ogg",
}

ENT.WalkSounds = {
	"enemies/specials/keeper/vox_ambient_6.ogg"
}

ENT.PainSounds = {
	"enemies/specials/keeper/vox_ambient_2.ogg",
	"enemies/specials/keeper/vox_ambient_3.ogg"
}

ENT.DeathSounds = {
	"enemies/specials/keeper/vox_death_1.ogg",
	"enemies/specials/keeper/vox_death_2.ogg",
	"enemies/specials/keeper/vox_death_3.ogg"
}

ENT.JumpSequences = {seq = ACT_JUMP, speed = 30}

ENT.ActStages = {
	[1] = {
		act = ACT_RUN ,
		minspeed = 5,
	}
}

function ENT:StatsInitialize()
	if SERVER then
		self:SetRunSpeed(160)
		self:SetHealth(500)
	end

	--PrintTable(self:GetSequenceList())
end

function ENT:OnSpawn()

	--self:SetNoDraw(true) -- Start off invisible while in the prespawn effect
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS) -- Don't collide in this state
	self:Stop() -- Also don't do anything

	local effectData = EffectData()
	effectData:SetOrigin( self:GetPos() + Vector(0, 0, 100)  )
	effectData:SetMagnitude( 2 )
	effectData:SetEntity(nil)
	util.Effect("panzer_spawn_tp", effectData)
	self:SetNoDraw(true)
	self:SetInvulnerable(true)
	self:EmitSound("enemies/specials/keeper/keeper_ghost_appear.ogg")

	timer.Simple(1.4, function()
		if IsValid(self) then

			self:SetNoDraw(false)
			self:SetCollisionGroup(COLLISION_GROUP_NONE)
			self:SetStop(false)

			self:SetTarget(self:GetPriorityTarget())
			self:SetInvulnerable(nil)
		end
	end)

	nzRound:SetNextSpawnTime(CurTime() + 2) -- This one spawning delays others by 3 seconds
end

function ENT:OnZombieDeath(dmgInfo)

	self:SetRunSpeed(0)
	self.loco:SetVelocity(Vector(0,0,0))
	self:Stop()
	local seqstr = self.DeathSequences[math.random(#self.DeathSequences)]
	local seq, dur = self:LookupSequence(seqstr)
	-- Delay it slightly; Seems to fix it instantly getting overwritten
	timer.Simple(0, function() 
		if IsValid(self) then
			self:ResetSequence(seq)
			self:SetCycle(0)
			self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		end 
	end)

	timer.Simple(dur + 1, function()
		if IsValid(self) then
			self:Remove()
		end
	end)
	self:EmitSound( self.DeathSounds[ math.random( #self.DeathSounds ) ], 100)

end

function ENT:BodyUpdate()

	self.CalcIdeal = ACT_IDLE

	local velocity = self:GetVelocity()

	local len2d = velocity:Length2D()

	if ( len2d > 150 ) then self.CalcIdeal = ACT_RUN elseif ( len2d > 50 ) then self.CalcIdeal = ACT_RUN elseif ( len2d > 5 ) then self.CalcIdeal = ACT_RUN end

	if self:IsJumping() and self:WaterLevel() <= 0 then
		self.CalcIdeal = ACT_JUMP
	end

	--if self:GetActivity() != self.CalcIdeal and !self:IsAttacking() and !self:GetStop() then self:StartActivity(self.CalcIdeal) end

	if !self:GetSpecialAnimation() and !self:IsAttacking() then
		if self:GetActivity() != self.CalcIdeal and !self:GetStop() then self:StartActivity(self.CalcIdeal) end

		self:BodyMoveXY()
	end

	self:FrameAdvance()

end

function ENT:OnTargetInAttackRange()
    local atkData = {}
    atkData.dmglow = 40
    atkData.dmghigh = 99
    atkData.dmgforce = Vector( 0, 0, 0 )
	atkData.dmgdelay = 0.3
    self:Attack( atkData )
end



function ENT:IsValidTarget( ent )
	if !ent then return false end
	return IsValid( ent ) and ent:GetTargetPriority() != TARGET_PRIORITY_NONE and ent:GetTargetPriority() != TARGET_PRIORITY_SPECIAL
	-- Won't go for special targets (Monkeys), but still MAX, ALWAYS and so on
end