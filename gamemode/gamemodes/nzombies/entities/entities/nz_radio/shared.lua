ENT.Type = "anim"

ENT.PrintName		= "nz_radio"
ENT.Author			= "Alig96"
ENT.Contact			= "Don't"
ENT.Purpose			= ""
ENT.Instructions	= ""


AddCSLuaFile()


function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Radio")

end

function ENT:Initialize()
print(self:GetRadio())
	
	
	self:SetModel( "models/nzr/song_ee/army_radio.mdl" )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	if SERVER then
		self:SetUseType(SIMPLE_USE)
	end
end

function ENT:Use( activator, caller )
	if nzRound:InProgress() then
		--PrintMessage( HUD_PRINTTALK,"Assume all songs are copyrighted!")
		local mySound = self:GetRound()
		print(mySound)
		self:EmitSound(mySound,511)
	end
end

function ENT:Draw()
	self:DrawModel()
end
