
include('shared.lua')

function ENT:Initialize()
	
	self.Color = Color( 255, 255, 255, 255 )
	
end

local Laser = Material( "cable/redlaser" )
 
function ENT:Draw()
 
	self:DrawModel() 
 
	local Vector1 = self:GetPos() + self:GetForward() * 2.8 + Vector(0,0,11)
	local Vector2 = self:GetPos() + self:GetRight() * -50 + self:GetForward() * 20 + Vector(0,0,11)
 
	render.SetMaterial( Laser )
	render.DrawBeam( Vector1, Vector2, 5, 1, 1, Color( 255, 255, 255, 255 ) ) 
 
	local Vector3 = self:GetPos() + self:GetForward() * -2.8 + Vector(0,0,11)
	local Vector4 = self:GetPos() + self:GetRight() * -50 + self:GetForward() * -20 + Vector(0,0,11)
 
	render.SetMaterial( Laser )
	render.DrawBeam( Vector3, Vector4, 5, 1, 1, Color( 255, 255, 255, 255 ) )  
 
end 