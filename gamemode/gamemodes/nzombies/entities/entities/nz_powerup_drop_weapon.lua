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
ENT.PrintName = "Weapon Drop"
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Spawnable = false
ENT.AdminOnly = false

--[Parameters]--
ENT.Delay = 30

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "Gun")
end

function ENT:Use(ply)
	if IsValid(ply) and ply:IsPlayer() then
		self:EmitSound("nz_moo/powerups/powerup_pickup_zhd.mp3")
		self:Effect(ply)
		self:Remove()
	end
end

function ENT:Initialize()
	if SERVER then
		local wepmodel = ents.Create(self:GetGun())
		self:SetModel(wepmodel:GetWeaponWorldModel())
	end
	self:SetModelScale(1, 0)

	self:PhysicsInit(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_BBOX)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:UseTriggerBounds(true, 5)

	self:EmitSound("NZ.BO2.DigSite.Special")
	self:EmitSound("NZ.BO2.DigSite.SpecialLoop")

	ParticleEffectAttach("bo3_qed_powerup_local", PATTACH_ABSORIGIN_FOLLOW, self, 1)

	if CLIENT then return end
	self:SetTrigger(true)
	self:SetUseType(SIMPLE_USE)
	SafeRemoveEntityDelayed(self, self.Delay)
end

function ENT:Think()
	if CLIENT then
		if !self:GetRenderAngles() then self:SetRenderAngles(self:GetAngles()) end
		self:SetRenderAngles(self:GetRenderAngles() + Angle(2,50,5)*math.sin(CurTime()/10)*FrameTime())
	end

	self:NextThink(CurTime())
	return true
end

function ENT:Effect(ply)
	local wep = ply:GetWeapon(self:GetGun())
	if IsValid(wep) then
		wep:GiveMaxAmmo()
	else
		local gun = ply:Give(self:GetGun())
		gun:GiveMaxAmmo()
	end

	self:Remove()
end

function ENT:OnRemove()
	self:StopSound("NZ.BO2.DigSite.SpecialLoop")
end

if CLIENT then
	function ENT:GetNZTargetText()
		return "Press "..string.upper(input.LookupBinding("+USE")).." - Pickup "..weapons.Get(self:GetGun()).PrintName
	end
end