AddCSLuaFile( )

ENT.Type = "anim"
 
ENT.PrintName		= "anticheat_exclude"
ENT.Author			= "Zet0r & Ethorbit"
ENT.Contact			= "youtube.com/Zet0r"
ENT.Purpose			= "Stops Anti-Cheat from working in these zones"
ENT.Instructions	= "Place where you want players to cheat at"

function ENT:SetupDataTables()
	-- Min bound is for now just the position
	--self:NetworkVar("Vector", 0, "MinBound")
	self:NetworkVar("Vector", 0, "MaxBound")
end

function ENT:Initialize()
	--self:SetMoveType( MOVETYPE_NONE )
	self:DrawShadow( false )
	self:SetRenderMode( RENDERMODE_TRANSCOLOR )
	if self.SetRenderBounds then
		self:SetRenderBounds(Vector(0,0,0), self:GetMaxBound())
	end

	--self:SetCustomCollisionCheck(true)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetSolid(SOLID_NONE)
end

local mat = Material("color")
local white = Color(0, 119, 255, 30)

if CLIENT then

	if not ConVarExists("nz_creative_preview") then CreateClientConVar("nz_creative_preview", "0") end

	function ENT:Draw()
		if ConVarExists("nz_creative_preview") and !GetConVar("nz_creative_preview"):GetBool() and nzRound:InState( ROUND_CREATE ) then
			cam.Start3D()
				render.SetMaterial(mat)
				render.DrawBox(self:GetPos(), self:GetAngles(), Vector(0,0,0), self:GetMaxBound(), white, true)
			cam.End3D()
		end
	end
end

hook.Add("PhysgunPickup", "nzInvisWallNotPickup", function(ply, wall)
	return wall:GetClass() != "anticheat_exclude"
end)
