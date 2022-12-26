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

	self:SetModel(  "models/codww2/other/zombielootcrate.mdl" )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.Used = false
	self:SetSkin(4)
	self:SetBodygroup(2,1)
	if SERVER then
		self:SetUseType(SIMPLE_USE)
	end
end


function ENT:Use( activator, caller )
	if nzRound:InProgress() then
	local currentWep = activator:GetActiveWeapon()
	local price = self:GetPrice()
	if activator:GetPoints() >=  price and !currentWep.NZWonderWeapon then
		activator:Buy(price, self, function()
		activator:TakePoints(price)
		self:EmitSound("effects/ammobox.ogg")
		currentWep:GiveMaxAmmo() 
		end)
		self:SetPrice((price) + (nzRound:GetNumber()/2 * 300))  
		 
	end
end
end


function ENT:Draw()
	self:DrawModel()
end
