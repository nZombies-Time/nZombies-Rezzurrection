AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Spawnable = false
ENT.FuseTime = 2
function ENT:Draw()
	self:DrawModel()
end

function ENT:SetKaboom(boom)
self.FuseTime = boom
end

function ENT:Initialize()
self.KaboomTime = self.KaboomTime or CurTime() + 1
	if SERVER then
	util.SpriteTrail( self, 0, Color( 168, 168, 168 ), true, 6, 0, 0.4, 0.0078125, "cable/smoke.vmt" )
		self:SetModel( "models/weapons/w_nam_geballteladung.mdl" )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetCollisionGroup( COLLISION_GROUP_NONE )
		self:DrawShadow( false )
	end
	--self.ExplodeTimer = CurTime() + 2.5
end

function ENT:Think()
	 if SERVER and CurTime() - self.KaboomTime >= self.FuseTime then
		self:Explode()
		self:Remove()
	end
end

function ENT:Explode()
	local effectdata = EffectData()
      effectdata:SetOrigin( self:GetPos() )
      util.Effect("nade_explode", effectdata)
      util.BlastDamage( self, self.Owner, self:GetPos(), 280, 650 )
        
        self:EmitSound( "TFA_Geballteladung.Explode" ) 
	self:Remove()
end

function ENT:PhysicsCollide( data )
	if SERVER and data.Speed > 150 then
	self:EmitSound( "Weapon_Stielhandgranate.Bounce" )
	end
end

