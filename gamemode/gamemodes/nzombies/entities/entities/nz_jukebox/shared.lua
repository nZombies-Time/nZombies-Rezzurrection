ENT.Type = "anim"

ENT.PrintName		= "nz_jukebox"
ENT.Author			= "Alig96"
ENT.Contact			= "Don't"
ENT.Purpose			= ""
ENT.Instructions	= ""


AddCSLuaFile()



function ENT:Initialize()

	
	
	self:SetModel( "models/nzr/song_ee/jukebox.mdl" )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	if SERVER then
		self:SetUseType(SIMPLE_USE)
	end
end

function ENT:Use( activator, caller )
	if nzRound:InProgress() then
		PrintMessage( HUD_PRINTTALK,"Assume all songs are copyrighted!")
		nzSounds:Play("Music")
	end
end

function ENT:Draw()
	self:DrawModel()
end
