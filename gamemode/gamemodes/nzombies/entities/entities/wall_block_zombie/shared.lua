AddCSLuaFile( )

ENT.Type = "anim"
 
ENT.PrintName		= "wall_block_zombie"
ENT.Author			= "Ethorbit, Alig96 & Zet0r"
ENT.Contact			= "Don't"
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.NZOnlyVisibleInCreative = true

--[[function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "BlockPlayers")
	self:NetworkVar("Bool", 1, "BlockZombies")
end

function ENT:SetFilter(players, zombies)
	if players and zombies then
		self:SetBlockPlayers(true)
		self:SetBlockZombies(true)
		self:SetCustomCollisionCheck(false)
		self:SetColor(Color(255,255,255))
	elseif players and !zombies then
		self:SetBlockPlayers(true)
		self:SetBlockZombies(false)
		self:SetCustomCollisionCheck(true)
		self:SetColor(Color(100,100,255))
	elseif !players and zombies then
		self:SetBlockPlayers(false)
		self:SetBlockZombies(true)
		self:SetCustomCollisionCheck(true)
		self:SetColor(Color(255,100,100))
	end
end]]

function ENT:Initialize()
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow( false )
	self:SetRenderMode( RENDERMODE_TRANSCOLOR )
	self:SetCollisionGroup(COLLISION_GROUP_PLAYER_MOVEMENT)
	self:SetCustomCollisionCheck(true)
	self:SetColor(Color(0, 0, 0))

	-- YES! Finally found a way to make bullets pass through without disabling solidity!
	--self:AddSolidFlags(FSOLID_CUSTOMRAYTEST)
	--self:AddSolidFlags(FSOLID_CUSTOMBOXTEST)
	
end

local function GetBosses()
	local bosses = {}

	for k,v in pairs(nzRound.BossData) do
		local class = v["class"]

		if class != nil and type(class) == "string" then
			table.insert(bosses, class)
		end
	end

	return bosses
end

function ENT:Touch(ent)
	if (IsValid(ent) and nzConfig.ValidEnemies[ent:GetClass()] || IsValid(ent) and table.HasValue(GetBosses(), ent:GetClass())) then
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

if CLIENT then
	function ENT:Draw()
		if ConVarExists("nz_creative_preview") and !GetConVar("nz_creative_preview"):GetBool() and nzRound:InState( ROUND_CREATE ) then
			self:DrawModel()
		end
	end
end