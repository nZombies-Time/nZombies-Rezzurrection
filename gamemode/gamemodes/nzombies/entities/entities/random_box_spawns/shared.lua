AddCSLuaFile( )

ENT.Type = "anim"
 
ENT.PrintName		= "random_box_spawns"
ENT.Author			= "Zet0r"
ENT.Contact			= "Don't"
ENT.Purpose			= ""
ENT.Instructions	= ""

function ENT:Initialize()
	--self:SetModel("models/moo/nzprops/moo_mysterybox_pile_bunny.mdl")
	
	
		if (nzMapping.Settings.boxtype =="Original") then
	 self:SetModel("models/nzprops/mysterybox_pile.mdl")
	end
	if (nzMapping.Settings.boxtype =="Origins") then
	self:SetModel( "models/nzr/2022/magicbox/bo2/tomb_box.mdl" )
	end
	if (nzMapping.Settings.boxtype =="Mob of the Dead") then
	self:SetModel( "models/nzr/2022/magicbox/motd_base.mdl" )
	end
	if (nzMapping.Settings.boxtype =="Dead Space") then
	self:SetModel( "models/nzr/2022/magicbox/kiosk_base.mdl" )
	self:SetModelScale( self:GetModelScale() * 0.7, 0 )
	end
	if (nzMapping.Settings.boxtype =="Resident Evil") then
	self:SetModel( "models/nzr/2022/magicbox/missing.mdl" )
	end
	
	if (nzMapping.Settings.boxtype == "Call of Duty: WW2") then
	self:SetModel( "models/nzr/2022/magicbox/ww2.mdl" )
	end
	if (nzMapping.Settings.boxtype == "DOOM") then
	self:SetModel( "models/nzr/2022/magicbox/doom.mdl" )
	end
	if (nzMapping.Settings.boxtype == "Chaos") then
	self:SetModel( "models/nzr/2022/magicbox/chaos_away.mdl" )
	end
	if (nzMapping.Settings.boxtype == "Shadows of Evil") then
	self:SetModel( "models/nzr/2022/magicbox/soe_base.mdl" )
	end
	if (nzMapping.Settings.boxtype == nil) then
	self:SetModel("models/nzprops/mysterybox_pile.mdl")
	end
	
	self:PhysicsInit(SOLID_NONE)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_OBB)

	if CLIENT then return end
	self:SetTrigger(true)
end

function ENT:PhysicsCollide(data, phys)
	self:SetMoveType(MOVETYPE_NONE)
end
