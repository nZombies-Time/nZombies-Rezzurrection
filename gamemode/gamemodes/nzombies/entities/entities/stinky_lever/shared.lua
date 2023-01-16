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


	self:SetModel(  "models/nzr/2022/misc/maldometer.mdl" )
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
				PrintMessage(HUD_PRINTTALK, "THIS DUMB MOTHER FUCKER -->"..activator:Nick().."<-- JUST ACTIVATED THE MALDOMETER")
				self:SetSkin(1)
				v:Setohfuck(true)
			end
		self:Setohfuck(true)
		self:EmitSound("nzr/maldometer/xsound_5ea1ae90c6e3660.wav", 100, math.random(95,105))
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
