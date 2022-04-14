ENT.Type = "anim"

ENT.PrintName		= "ammo_box"
ENT.Author			= "Laby"
ENT.Contact			= "Don't"
ENT.Purpose			= ""
ENT.Instructions	= ""

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "Price")
end


AddCSLuaFile()



function ENT:Initialize()

	self:SetModel(  "models/codww2/other/carepackage.mdl" )
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
	if activator:GetPoints() >=  price then
		activator:Buy(price, self, function()
		activator:TakePoints(price)
		self:EmitSound("nz/effects/buy.wav")
		local currentWep = activator:GetActiveWeapon()
		if !currentWep.NZWonderWeapon then currentWep:GiveMaxAmmo() end
		end)
		 self:SetPrice(price + (nzRound:GetNumber()/4 * 1000))
		 
	end
end
end


function ENT:Draw()
	self:DrawModel()
end
