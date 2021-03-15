ENT.Type = "anim"

ENT.PrintName		= "buyable_ending"
ENT.Author			= "Laby"
ENT.Contact			= "Don't"
ENT.Purpose			= ""
ENT.Instructions	= ""

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Price")
end


AddCSLuaFile()



function ENT:Initialize()

	--self:SetModel( "models/hoff/props/teddy_bear/teddy_bear.mdl" )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.Used = false
	if SERVER then
		self:SetUseType(SIMPLE_USE)
	end
end

function ENT:Use( activator, caller )
	if nzRound:InProgress() then
	local price = self:GetPrice()
	if activator:GetPoints() > price then
	activator:TakePoints(price)
		 nzRound:Win()
	end
end
end

function ENT:Draw()
	self:DrawModel()
end
