AddCSLuaFile( )

ENT.Type = "anim"
 
ENT.PrintName		= "invis_wall_zombie"
ENT.Author			= "Ethorbit & Zet0r"
ENT.Contact			= "youtube.com/Zet0r"
ENT.Purpose			= "Block everything except zombies"
ENT.Instructions	= ""

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
	self:SetCustomCollisionCheck(true)
	self:SetCollisionGroup(COLLISION_GROUP_PLAYER_MOVEMENT)
	--self:SetCollisionGroup(COLLISION_GROUP_PLAYER_MOVEMENT)
	--self:SetFilter(true, true)
end

function ENT:Touch(ent) -- Let zombies walk through us like it's nothing
	if (IsValid(ent) and nzConfig.ValidEnemies[ent:GetClass()]) then
		if (ent:GetCollisionGroup() == COLLISION_GROUP_DEBRIS_TRIGGER) then return end -- They already have this
		ent.prevCollision = ent:GetCollisionGroup()
		ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	end

	ent.touchingzombiewall = true
	timer.Simple(0.1, function() 
		if !IsValid(ent) then return end
		ent.touchingzombiewall = false
	end)

	timer.Simple(0.3, function() -- Make sure they have their original collision again when they are passed
		if !IsValid(ent) then return end
		if (!ent.touchingzombiewall) then
			if (!ent.prevCollision) then return end
			ent:SetCollisionGroup(ent.prevCollision)
		end
	end)
end

local mat = Material("color")
local white = Color(0,0,0,200)

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

-- Causes collisions to completely disappear, not just traces :(
--[[function ENT:TestCollision(start, delta, hulltrace, bounds)
	return nil -- Traces pass through it!
end]]

hook.Add("PhysgunPickup", "nzInvisWallNotPickup", function(ply, wall)
	if wall:GetClass() == "invis_wall_zombie" or wall:GetClass() == "invis_wall" or wall:GetClass() == "invis_damage_wall" then return false end
end)
