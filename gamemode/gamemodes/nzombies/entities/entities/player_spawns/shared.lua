AddCSLuaFile( )

ENT.Type = "anim"

ENT.PrintName		= "player_spawns"
ENT.Author			= "Alig96"
ENT.Contact			= "Don't"
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.NZOnlyVisibleInCreative = true

function ENT:Initialize()
	self:SetModel( "models/player/odessa.mdl" )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self:SetColor(Color(0,0,255))
	self:DrawShadow( false )
end

if CLIENT then
	function ENT:Draw()
		if nzRound:InState( ROUND_CREATE ) then
			if GetConVar("nz_creative_preview"):GetBool() then
			--self:SetBodygroup(0,1)
			else
			self:DrawModel()
			end
			
		end
	end
end
