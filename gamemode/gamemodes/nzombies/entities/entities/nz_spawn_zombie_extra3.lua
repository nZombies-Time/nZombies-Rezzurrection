AddCSLuaFile( )

ENT.Base = "nz_spawn_zombie"
ENT.PrintName = "nz_spawn_zombie_extra3"

ENT.NZOnlyVisibleInCreative = true

function ENT:Initialize()
	self:SetModel( "models/kleiner.mdl" )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
    self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	self:SetColor(Color(163, 73, 164))
	self:DrawShadow( false )
	self:SetSpawnWeight(0)
	self:SetZombiesToSpawn(0)
	self:SetNextSpawn(CurTime())
    self:SetSpawnUpdateRate(0)

    if (self:GetSpawnType() == 0 or self:GetSpawnType() == nil) and !self:GetMasterSpawn() then
        self:AutoSpawnType() -- Spawns don't have the data set.
    end

    self.Spawns = {}

    self.CurrentSpawnType = "nil"
    self:UpdateSpawnType()
end