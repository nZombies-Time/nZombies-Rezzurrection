ENT.Type = "anim"

ENT.PrintName		= "stinky_lever"
ENT.Author			= "Laby"
ENT.Contact			= "Don't"
ENT.Purpose			= ""
ENT.Instructions	= ""

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "ohfuck")
end


AddCSLuaFile()



function ENT:Initialize()


	self:SetModel(  "models/Combine_Helicopter/helicopter_bomb01.mdl" )
	self:Setohfuck(false)
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	if SERVER then
		self:SetUseType(SIMPLE_USE)
	end
end

function ENT:Use( activator, caller )
	if nzRound:InProgress() then
	if self:Getohfuck()  then
	else
	for k,v in pairs(ents.FindByClass("stinky_lever")) do
		v:Setohfuck(true)
	end
	self:Setohfuck(true)
	if math.random(0,500) == 420 then
	if math.random(0,1) == 1 then
	self:EmitSound("God_Cum_Zone.wav", 511)
	else
	self:EmitSound("Demon_Cum_Zone.wav", 511)
	end
	end
	end
end
end



function ENT:Draw()
	self:DrawModel()
end
