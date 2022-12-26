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
	self:SetModel( "models/box/originsbox/base.mdl" )
	end
	if (nzMapping.Settings.boxtype =="Mob of the Dead") then
	self:SetModel( "models/box/motd/motd_base.mdl" )
	--self:SetModelScale( self:GetModelScale() * 0.6, 0 )
	end
	if (nzMapping.Settings.boxtype =="Dead Space") then
	self:SetModel( "models/box/dsr/kiosk_base.mdl" )
	self:SetModelScale( self:GetModelScale() * 0.7, 0 )
	end
	if (nzMapping.Settings.boxtype =="Resident Evil") then
	self:SetModel( "models/box/re/missing.mdl" )
	end
	
	if (nzMapping.Settings.boxtype == "Call of Duty: WW2") then
	self:SetModel( "models/box/ww2/ww2.mdl" )
	end
	if (nzMapping.Settings.boxtype == "DOOM") then
	self:SetModel( "models/box/doom/DOOM.mdl" )
	end
	if (nzMapping.Settings.boxtype == "Chaos") then
	self:SetModel( "models/box/chaos/chaos_away.mdl" )
	end
	if (nzMapping.Settings.boxtype == "Shadows of Evil") then
	self:SetModel( "models/box/soe/soe_base.mdl" )
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