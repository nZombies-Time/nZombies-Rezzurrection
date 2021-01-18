AddCSLuaFile( )

ENT.Type = "anim"
 
ENT.PrintName		= "random_box_spawns"
ENT.Author			= "Zet0r"
ENT.Contact			= "Don't"
ENT.Purpose			= ""
ENT.Instructions	= ""
ENT.Rotated = false

function ENT:Initialize()
	if (nzMapping.Settings.boxtype =="Original") then
	self:SetModel( "models/nzprops/mysterybox_pile.mdl" )
	end
	if (nzMapping.Settings.boxtype =="Origins") then
	self:SetModel( "models/nzr/originsbox/base.mdl" )
	end
	if (nzMapping.Settings.boxtype =="Mob of the Dead") then
	self:SetModel( "models/nzr/motd/base.mdl" )
	self:SetModelScale( self:GetModelScale() * 0.6, 0 )
	end
	if (nzMapping.Settings.boxtype =="Dead Space") then
	self:SetModel( "models/nzr/deadspace/kiosk_base.mdl" )
	self:SetModelScale( self:GetModelScale() * 0.7, 0 )
	end
	if (nzMapping.Settings.boxtype =="Resident Evil") then
	self:SetModel( "models/nzr/re/missing.mdl" )
	end
	if (nzMapping.Settings.boxtype == nil) then
	self:SetModel( "models/nzprops/mysterybox_pile.mdl" )
	end
	--self:SetModelScale( self:GetModelScale() * 0.8, 0 )
	self:SetColor( Color(255, 255, 255) )
	--self:SetAngles( Color(255, 255, 255) )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	local ang = self:GetAngles()
	if !self.Rotated then
	--self:SetAngles(ang + Angle(0, 45, 0))
	self.Rotated = true
	end
	--self:SetNotSolid(true)
	--self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	--self:DrawShadow( false )
end

if CLIENT then
	
end