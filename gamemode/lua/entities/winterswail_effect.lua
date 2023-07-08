
-- Copyright (c) 2018-2020 TFA Base Devs

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

AddCSLuaFile()

--[Info]--
ENT.Type = "anim"
ENT.PrintName = "Frost Bite"
ENT.Spawnable = false
ENT.AdminOnly = false

ENT.Delay = 3
ENT.Kills = 0
ENT.MaxKills = 12
ENT.Range = 160
ENT.KillRange = 120
ENT.Duration = 10

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Attacker")
	self:NetworkVar("Entity", 1, "Inflictor")
end

function ENT:Initialize()
	local p = self:GetParent()
	if IsValid(p) then
		p:EmitSound("TFA_BO4_WINTERS.Break")
		if p:IsPlayer() then
			if p:HasUpgrade("winters") then
				self.KillRange = self.Range
				self.Delay = 8
				self.Duration = 54000 //~15 hours
			end
		else
			self:SetParent(nil)
		end
	else
		self:EmitSound("TFA_BO4_WINTERS.Break")
	end

	self:SetModel("models/dav0r/hoverball.mdl")

	self:SetNoDraw(true)
	self:DrawShadow(false)
	self:PhysicsInit(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)

	self:EmitSound("TFA_BO4_ALISTAIR.Charged.WindLoop")

	ParticleEffectAttach("nz_perks_winters", PATTACH_ABSORIGIN_FOLLOW, self, 0)

	self.killtime = CurTime() + self.Delay

	if CLIENT then return end
	for k, v in pairs(ents.FindInSphere(self:GetPos(), self.KillRange)) do
		if not v.BO4WintersFreeze then break end
		if self.Kills >= self.MaxKills then break end
		if not (v:IsNPC() or v:IsNextBot()) then continue end
		if v:Health() <= 0 then continue end
		if v:BO4IsFrozen() then continue end

		v:BO4WintersFreeze(math.Rand(3,5), self:GetAttacker(), self:GetInflictor())
		self.Kills = self.Kills + 1
	end

	self:SetTrigger(true)
end

function ENT:Think()
	if SERVER then
		local pos = self:GetPos()
		local ply = self:GetOwner()

		for k, v in pairs(ents.FindInSphere(self:GetPos(), self.Range)) do
			if not (v:IsNPC() or v:IsNextBot()) then continue end
			if v:Health() <= 0 then continue end
			if v:IsWintersWailSlow() then continue end

			v:WintersWailSlow(self.Duration, 0.1)
		end

		if self.killtime < CurTime() then
			self:StopSound("TFA_BO4_ALISTAIR.Charged.WindLoop")
			self:Remove()
			return false
		end
	end

	self:NextThink(CurTime())
	return true
end

function ENT:OnRemove()
	self:StopSound("TFA_BO4_ALISTAIR.Charged.WindLoop")
	local p = self:GetParent()
	if IsValid(p) then
		p:EmitSound("TFA_BO4_ALISTAIR.Charged.WindEnd")
	else
		self:EmitSound("TFA_BO4_ALISTAIR.Charged.WindEnd")
	end
end
