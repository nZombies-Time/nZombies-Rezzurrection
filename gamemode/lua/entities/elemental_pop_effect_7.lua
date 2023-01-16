
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
ENT.PrintName = "Black Hole"
ENT.Spawnable = false
ENT.AdminOnly = false

ENT.MaxKills = 24
ENT.Kills = 0

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Attacker")
	self:NetworkVar("Entity", 1, "Inflictor")
end

function ENT:Initialize()
	self:SetParent(nil)
	self:SetModel("models/dav0r/hoverball.mdl")

	self:SetNoDraw(true)
	self:DrawShadow(false)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)

	if CLIENT then return end
	local bhole = ents.Create("nz_bo3_tac_gersch")
	bhole:SetModel("models/dav0r/hoverball.mdl")
	bhole:SetPos(self:GetPos())
	bhole:SetAngles(Angle(0,0,0))
	bhole:SetOwner(IsValid(self:GetAttacker()) and self:GetAttacker() or self)
	bhole.Inflictor = IsValid(self:GetInflictor()) and self:GetInflictor() or self
	bhole:SetNoDraw(true)
	bhole:DrawShadow(false)
	bhole.Delay = 3

	bhole:Spawn()

	bhole:SetSolid(SOLID_NONE)
	bhole:SetMoveType(MOVETYPE_NONE)
	bhole:SetCollisionGroup(COLLISION_GROUP_NONE)

	bhole:SetNoDraw(true)
	bhole:DrawShadow(false)
	bhole:ActivateCustom(bhole:GetPhysicsObject())

	bhole:SetOwner(IsValid(self:GetAttacker()) and self:GetAttacker() or self)
	bhole.Inflictor = IsValid(self:GetInflictor()) and self:GetInflictor() or self

	self:Remove()
end
