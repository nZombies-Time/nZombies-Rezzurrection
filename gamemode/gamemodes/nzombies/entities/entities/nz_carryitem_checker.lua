
--AddCSLuaFile()
--DEFINE_BASECLASS( "base_anim" )
ENT.Type = "point"
ENT.Base = "base_point"

ENT.PrintName		= ""
ENT.Author			= "Hidden"
ENT.Contact			= "steamcommunity.com/id/LambdaHidden (tell me you came because of this ENT in the comments)"
ENT.Purpose			= "Lets you check if players are carrying this item. Will be removed if Map Extensions is not ticked in the loaded config."
ENT.Instructions	= ""

ENT.Spawnable			= false
ENT.AdminOnly			= false

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "ID")
end

function ENT:AcceptInput( inputName, activator, called, data )
	if (inputName == "Check") then
		self:Check(activator)
	end
	if (inputName == "CheckAndTake") then
		self:CheckAndTake(activator)
	end
	if (inputName == "Kill") then
		SafeRemoveEntity(self)
	end
end

function ENT:KeyValue( key, value )
	-- Key Values
	--print(key, value)
	if (key == "itemid") then
		self:SetID(value)
	end
	
	-- Outputs
	if ( string.Left( key, 2 ) == "On" ) then
		self:StoreOutput( key, value )
	end
end

function ENT:Check( ply )
	local success = false
	
	--PrintTable(ply:GetCarryItems())
	--print(self:GetID())
	for k,v in pairs(ply:GetCarryItems()) do
		if v == self:GetID() then 
			success = true 
			break 
		end
	end
	
	
	if success then
		self:TriggerOutput("OnCheckSuccess")
	else
		self:TriggerOutput("OnCheckFail")
	end
end

function ENT:CheckAndTake( ply )
	local success = false
	
	for k,v in pairs(ply:GetCarryItems()) do
		if v == self:GetID() then 
			success = true 
			break 
		end
	end
	
	
	if success then
		self:TriggerOutput("OnCheckSuccess")
		ply:RemoveCarryItem(self:GetID())
	else
		self:TriggerOutput("OnCheckFail")
	end
end
/*
function ENT:Initialize()
	
	self:SetModel( "models/MaxOfS2D/cube_tool.mdl" )
	self:SetNoDraw(true)
	--self:PhysicsInit(SOLID_NONE)
	--self.Entity:SetMoveType( MOVETYPE_NONE )
	--self.Entity:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	--self.Entity:SetSolid( SOLID_VPHYSICS )
	--self.Entity:DrawShadow( false )
	--self:SetNWBool("active", false)
	--self:SetNWInt("souls", 0)
end
*/