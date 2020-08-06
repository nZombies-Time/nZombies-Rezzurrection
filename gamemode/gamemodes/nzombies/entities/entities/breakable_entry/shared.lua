AddCSLuaFile( )

ENT.Type = "anim"

ENT.PrintName		= "breakable_entry"
ENT.Author			= "Alig96"
ENT.Contact			= "Don't"
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.NZOnlyVisibleInCreative = true

-- models/props_interiors/elevatorshaft_door01a.mdl
-- models/props_debris/wood_board02a.mdl
function ENT:Initialize()

	self:SetModel("models/props_c17/fence01b.mdl")
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )

	--self:SetHealth(0)
	self:SetCustomCollisionCheck(true)
	self.NextPlank = CurTime()

	self.Planks = {}

	if SERVER then
		self:ResetPlanks(true)
	end
end

function ENT:SetupDataTables()

	self:NetworkVar( "Int", 0, "NumPlanks" )
	self:NetworkVar( "Bool", 0, "HasPlanks" )
	self:NetworkVar( "Bool", 1, "TriggerJumps" )

end

function ENT:AddPlank(nosound)
	if !self:GetHasPlanks() then return end
	self:SpawnPlank()
	self:SetNumPlanks( (self:GetNumPlanks() or 0) + 1 )
	if !nosound then
		self:EmitSound("nz/effects/board_slam_0"..math.random(0,5)..".wav")
	end
end

function ENT:RemovePlank()

	local plank = table.Random(self.Planks)
	
	if !IsValid(plank) and plank != nil then -- Not valid but not nil (NULL)
		table.RemoveByValue(self.Planks, plank) -- Remove it from the table
		self:RemovePlank() -- and try again
		return
	end
	
	if IsValid(plank) then
		-- Drop off
		plank:SetParent(nil)
		plank:PhysicsInit(SOLID_VPHYSICS)
		local entphys = plank:GetPhysicsObject()
		if entphys:IsValid() then
			 entphys:EnableGravity(true)
			 entphys:Wake()
		end
		plank:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
		-- Remove
		timer.Simple(2, function() if IsValid(plank) then plank:Remove() end end)
	end
	
	table.RemoveByValue(self.Planks, plank)
	self:SetNumPlanks( self:GetNumPlanks() - 1 )
    self.NextPlank = CurTime() + 2.5
end

function ENT:ResetPlanks(nosoundoverride)
	for i=1, table.Count(self.Planks) do
		self:RemovePlank()
	end
	self.Planks = {}
	self:SetNumPlanks(0)
	if self:GetHasPlanks() then
		for i=1, GetConVar("nz_difficulty_barricade_planks_max"):GetInt() do
			self:AddPlank(!nosoundoverride)
		end
	end
end

function ENT:Use( activator, caller )
	if CurTime() > self.NextPlank then
		if self:GetHasPlanks() and self:GetNumPlanks() < GetConVar("nz_difficulty_barricade_planks_max"):GetInt() then
			self:AddPlank()
                  activator:GivePoints(10)
				  hook.Call("XPFromBarrier", nil, activator, self)
				  activator:EmitSound("nz/effects/repair_ching.wav")
			self.NextPlank = CurTime() + 1
		end
	end
end

function ENT:SpawnPlank()
	-- Spawn
	local angs = {-60,-70,60,70}
	local plank = ents.Create("breakable_entry_plank")
	local min = self:GetTriggerJumps() and 0 or -45
	plank:SetPos( self:GetPos()+Vector(0,0, math.random( min, 45 )) )
	plank:SetAngles( Angle(0,self:GetAngles().y, table.Random(angs)) )
	plank:Spawn()
	plank:SetParent(self)
	plank:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
	table.insert(self.Planks, plank)
end

function ENT:Touch(ent)
	--if self:GetTriggerJumps() and self:GetNumPlanks() == 0 then
		--if ent.TriggerBarricadeJump then ent:TriggerBarricadeJump(self, self:GetTouchTrace().HitNormal) end
	--end
end

hook.Add("ShouldCollide", "zCollisionHook", function(ent1, ent2)
	if IsValid(ent1) and ent1:GetClass() == "breakable_entry" and nzConfig.ValidEnemies[ent2:GetClass()] and !ent1:GetTriggerJumps() and ent1:GetNumPlanks() <= 0 then
		if !ent1.CollisionResetTime then
			ent1:SetSolid(SOLID_NONE)
		end
		ent1.CollisionResetTime = CurTime() + 0.1
	end
	
	if IsValid(ent2) and ent2:GetClass() == "breakable_entry" and nzConfig.ValidEnemies[ent1:GetClass()] and !ent2:GetTriggerJumps() and ent2:GetNumPlanks() <= 0 then
		if !ent2.CollisionResetTime then
			ent2:SetSolid(SOLID_NONE)
		end
		ent2.CollisionResetTime = CurTime() + 0.1
	end
end)

if CLIENT then
	function ENT:Draw()
		if ConVarExists("nz_creative_preview") and !GetConVar("nz_creative_preview"):GetBool() and nzRound:InState( ROUND_CREATE ) then
			self:DrawModel()
		end
	end
else
	function ENT:Think()
		if self.CollisionResetTime and self.CollisionResetTime < CurTime() then
			self:SetSolid(SOLID_VPHYSICS)
			self.CollisionResetTime = nil
		end
	end
end

