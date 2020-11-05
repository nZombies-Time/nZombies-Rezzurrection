AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Spawnable = false

function ENT:Draw()
	self:DrawModel()
end

function ENT:Initialize()
	if SERVER then
		self:SetModel( "models/weapons/w_compb_allied.mdl" )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetCollisionGroup( COLLISION_GROUP_NONE )
		self:DrawShadow( false )
	end
	self.ExplodeTimer = CurTime() + 2.5
end


function ENT:Think()
	if SERVER and self.KaboomTime <= CurTime() then
		self:Explode()
		self:EmitSound( "Weapon_compositonB.Explode" ) 
		self:Remove()
	end
end

function ENT:Explode()
	local effectdata = EffectData()
      effectdata:SetOrigin( self:GetPos() )
      util.Effect("nade_explode", effectdata)
      util.BlastDamage( self, self.Owner, self:GetPos(), 400, 1000 )
	self:Remove()
end

function ENT:PhysicsCollide( data )
	if SERVER and data.Speed > 150 then
	self:EmitSound( "Weapon_compositonB.Bounce" )
	end
end

