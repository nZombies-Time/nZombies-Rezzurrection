
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
ENT.Base = "tfa_exp_base"
ENT.PrintName = "Grenade"

--[Parameters]--
ENT.Delay = 2
ENT.Range = 220
ENT.BeepDelay = 0.35

DEFINE_BASECLASS( ENT.Base )

local nzombies = engine.ActiveGamemode() == "nzombies"
local blueflare = Material("effects/blueflare1")

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Activated")
	self:NetworkVar("Bool", 1, "Blinking")
	self:NetworkVar("Float", 0, "BeepTimer")
end

function ENT:Draw()
	self:DrawModel()

	local attpos = self:GetAttachment(1)
	render.SetMaterial(blueflare)
	if self:GetBlinking() then
		render.DrawSprite(attpos.Pos, 8, 8, Color(120,255,70,255))
	end
end

function ENT:PhysicsCollide(data, phys)
	if self:GetActivated() then return end
	self:SetActivated(true)

	local ent = data.HitEntity
	local ang = self:GetAngles()

	timer.Simple(0, function()
		if not IsValid(self) then return end
		self:SetAngles(ang)
		self:SetSolid(SOLID_NONE)
		self:SetMoveType(MOVETYPE_NONE)
		if IsValid(ent) and ent:IsValidZombie() then
			self:SetParent(ent)
			self:InflictDamage(ent, data.HitPos)
		end
	end)

	self.killtime = CurTime() + self.Delay
	self:EmitSound("TFA_BO3_SEMTEX.Stick")

	phys:EnableMotion(false)
	phys:Sleep()
end

function ENT:Initialize()
	BaseClass.Initialize(self)

	self:SetBodygroup(0, 1)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_PASSABLE_DOOR)
	self:SetBeepTimer(CurTime() + self.BeepDelay)
	self.killtime = CurTime() + 10

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
	end

	if CLIENT then return end
	self:SetTrigger(true)
	util.SpriteTrail(self, 0, Color(120, 120, 120), true, 6, 0, 0.5, 0.005, "cable/smoke.vmt")
end

function ENT:Think()
	if self:GetActivated() and CurTime() > self:GetBeepTimer() then
		if IsFirstTimePredicted() then self:EmitSound("TFA.BO1.SEMTEX.Alert") end

		self.BeepDelay = math.max(self.BeepDelay - 0.05, 0.1)
		self:SetBlinking(not self:GetBlinking())
		self:SetBeepTimer(CurTime() + self.BeepDelay)
	end

	if SERVER then
		if self.killtime < CurTime() then
			self:Explode()
			self:Remove()
			return false
		end
	end

	self:NextThink(CurTime())
	return true
end

function ENT:InflictDamage(ent, hitpos)
	if v.IsAATTurned and v:IsAATTurned() then return end

	local damage = DamageInfo()
	damage:SetDamage(5)
	damage:SetAttacker(IsValid(self:GetOwner()) and self:GetOwner() or self)
	damage:SetInflictor(IsValid(self.Inflictor) and self.Inflictor or self)
	damage:SetDamagePosition(hitpos)
	damage:SetDamageForce(ent:GetForward())
	damage:SetDamageType(DMG_GENERIC)

	ParticleEffect("blood_impact_red_01", hitpos, angle_zero)
	ent:TakeDamageInfo(damage)
end

function ENT:Explode()
	for k, v in pairs(ents.FindInSphere(self:GetPos(), self.Range)) do
		if (v:IsNPC() or v:IsNextBot()) then
			if nzombies and v.NZBossType then continue end
			if nzombies and v.IsAATTurned and v:IsAATTurned() then continue end

			v:BO3SpiderWeb(10, self:GetOwner())
		end
	end

	ParticleEffect("bo3_spider_impact", self:GetPos(), angle_zero)
	self:EmitSound("TFA_BO3_SPIDERNADE.Explode")

	self:Remove()
end
