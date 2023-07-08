
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
ENT.PrintName = "Turned"
ENT.Spawnable = false
ENT.AdminOnly = false

ENT.Delay = 25
ENT.Dance = false

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Attacker")
	self:NetworkVar("Entity", 1, "Inflictor")
end

function ENT:Initialize()
	self:SetModel("models/dav0r/hoverball.mdl")

	self:SetNoDraw(true)
	self:DrawShadow(false)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)

	if CLIENT then return end

	if math.random(100) >= 70 then
		self.Dance = true
		self.Delay = 12
	end

	for k, v in pairs(ents.FindInSphere(self:GetPos(), 250)) do
		if v:IsValidZombie() and v:Health() > 0 then
			if v:IsAATTurned() then continue end
			if v:GetClass() == "nz_zombie_boss_astro" then
				v:AATTurned(10, self:GetAttacker(), true)
				break
			end
			if v.IsMooSpecial and not v.MooSpecialZombie then continue end

			v:AATTurned(self.Delay, self:GetAttacker(), self.Dance)
			v:SetOwner(self:GetAttacker())
			break
		end
	end
	self:Remove()
end
