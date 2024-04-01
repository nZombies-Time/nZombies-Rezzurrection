AddCSLuaFile( )

ENT.Type = "anim"

ENT.PrintName		= "random_box_windup_precache"
ENT.Author			= "GhostlyMoo"
ENT.Contact			= "Don't"
ENT.Purpose			= "A dumby Box windup entity that cycles through every weapon in order to reduce hitching during inital box spins."
ENT.Instructions	= ""

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Winding")
	self:NetworkVar("Float", 0, "ThinkRate")
	self:NetworkVar("String", 0, "WepClass")
end

function ENT:Initialize()

	self:SetMoveType(MOVETYPE_NOCLIP)
	--self:SetLocalVelocity(self:GetAngles():Up() * (speed and 19 or 6))
	self:SetSolid(SOLID_OBB)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:DrawShadow(false)

	self:SetWinding(true)

	self.KillTime = CurTime() + 5 -- Self remove after 5 seconds, that should be good enough.

	self:SetModel("models/weapons/w_rif_ak47.mdl")

	if SERVER then
		if nzMapping.Settings.rboxweps then
			self.ScrollWepList = table.GetKeys(nzMapping.Settings.rboxweps)
		end
	else
		local wep = weapons.Get(self:GetWepClass())
		if !wep then
			timer.Simple(1, function()
				if IsValid(self) then
					wep = weapons.Get(self:GetWepClass())
					if wep and wep.DrawWorldModel then self.WorldModelFunc = wep.DrawWorldModel end
				end
			end)
		elseif wep.DrawWorldModel then 
			self.WorldModelFunc = wep.DrawWorldModel
		end
	end
end
		
function ENT:WindUp( )
	local gun
	if self.ScrollWepList then
		gun = weapons.Get(self.ScrollWepList[math.random(#self.ScrollWepList)])
	else
		gun = table.Random(weapons.GetList())
	end

	if gun and gun.WorldModel != nil then
		self:SetModel(gun.WM or gun.WorldModel)
	end
end

function ENT:Think()
	if SERVER then
		if self.KillTime < CurTime() then
			self:Remove()
		end
		if self:GetWinding() then
			self:WindUp()
			self:NextThink(CurTime() + 0.05)
			return true 
		end
	end
end

if CLIENT then
	function ENT:Draw()
		-- If we've stopped winding
		if !self:GetWinding() then
			-- We can use the stored world model draw function from the original weapon, but if it doesn't exist or causes errors, then just draw model
			if !self.WorldModelFunc or !pcall(self.WorldModelFunc, self) then self:DrawModel() end
		else
			self:DrawModel()
		end
	end
end
