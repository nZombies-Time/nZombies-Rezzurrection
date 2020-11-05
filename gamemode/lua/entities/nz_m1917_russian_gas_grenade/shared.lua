AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Spawnable = false
ENT.FuseTime = 2
ENT.FireTime = 10
ENT.NextDamageTick = CurTime() + 0.3

function ENT:Draw()
	self:DrawModel()
end

function ENT:SetupDataTables()
    self:NetworkVar( "Bool", 0, "Armed" )

    if SERVER then
        self:SetArmed(false)
    end
end

function ENT:SetKaboom(boom)
self.FuseTime = boom
end

function ENT:Initialize()
	self.KaboomTime = self.KaboomTime or CurTime() + 2
	if SERVER then
	util.SpriteTrail( self, 0, Color( 168, 168, 168 ), true, 6, 0, 0.4, 0.0078125, "cable/smoke.vmt" )
		self:SetModel( "models/weapons/w_m1917_russian.mdl" )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
		self:DrawShadow( true )
		--self:SetAngles( self:GetOwner():GetAngles() )
	end
end

function ENT:Think()
    if !self.KaboomTime then self.KaboomTime = CurTime() end

    if SERVER and CurTime() - self.KaboomTime >= self.FuseTime and !self.Armed then
        self:Detonate()
        self:SetArmed(true)
    end

    if self:GetArmed() then

        if SERVER then
            if self.NextDamageTick > CurTime() then return end

            local dmg = DamageInfo()
            dmg:SetDamageType(DMG_NERVEGAS)
            dmg:SetDamage(37)
            dmg:SetInflictor(self)
            dmg:SetAttacker(self.Owner)
            util.BlastDamageInfo(dmg, self:GetPos(), 250)

            self.NextDamageTick = CurTime() + 0.3
        end

    end
end

function ENT:OnRemove()
end

function ENT:Detonate()
    if !self:IsValid() then return end

    self.Armed = true
	
			self:EmitSound("TFA_WW1_GAS_RUSSIAN.Explode")

			local cloud = ents.Create( "tfa_m1917_russian_gas_grenade_gas" )

			if !IsValid(cloud) then return end

			cloud:SetPos(self:GetPos())
			cloud:Spawn()

    timer.Simple(self.FireTime, function()
        if !IsValid(self) then return end

        self:Remove()
    end)
end