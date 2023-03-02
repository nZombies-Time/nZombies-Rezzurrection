include("shared.lua")

local nzombies = engine.ActiveGamemode() == "nzombies"

function ENT:Draw()
	self:DrawModel()
end

function ENT:GetNZTargetText()
	local hurttypes = {
		[1] = function(self) return "Melee Damage" end,
		[2] = function(self) return "Explosive Damage" end,
		[3] = function(self) return "Fire Damage" end,
		[4] = function(self) return "Bullet Damage" end,
		[5] = function(self) return "Shock Damage" end,
	}

	if nzRound:InState(ROUND_CREATE) then
		return "Shootable - Requires "..hurttypes[self:GetHurtType()](self)
	end
end

function ENT:IsTranslucent()
	return true
end