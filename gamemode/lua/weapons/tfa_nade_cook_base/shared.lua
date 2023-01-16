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

if SERVER then
	AddCSLuaFile()
end

DEFINE_BASECLASS("tfa_nade_base")

SWEP.CookTimer = 4
SWEP.Cookable = true
SWEP.ThrowSpin = true
SWEP.Primary.SpreadBiasPitch = 1
SWEP.Primary.SpreadBiasYaw = 1
SWEP.StatCache_Blacklist = {
	["Primary.SpreadBiasPitch"] = true,
	["Primary.SpreadBiasYaw"] = true,
}

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)
	
	self:NetworkVarTFA("Bool", "Cooking")
	self:NetworkVarTFA("Bool", "Detonated")
	self:NetworkVarTFA("Float", "HeldTime")
	self:NetworkVarTFA("Float", "Breathe")
end

function SWEP:Initialize(...)
	BaseClass.Initialize(self, ...)

	self:SetCooking(false)
	self:SetHeldTime(0)
	self.Breathe = CurTime()
	self.Shrink = CurTime()
end

function SWEP:Deploy(...)
	self:CookReset()
	if self.Cookable then
		self:SetCooking(true)
		self:SetHeldTime(CurTime() + self.CookTimer)
	end

	return BaseClass.Deploy(self, ...)
end

function SWEP:ThrowStart(...)
	if self:GetDetonated() then self:ResetCrosshair() return end
	self:CookReset()
	
	return BaseClass.ThrowStart(self, ...)
end

function SWEP:CookReset()
	self:SetDetonated(false)
	self:SetCooking(false)
	self.Breathe = CurTime()
	self:ResetCrosshair()
end

function SWEP:Think2(...)
	local stat = self:GetStatus()
	local statusend = CurTime() > self:GetStatusEnd()

	if self:GetCooking() and not self:GetDetonated() then
		if self.Shrink <= CurTime() then
			self:SetStatRawL("Primary.SpreadBiasPitch", self:GetStatL("Primary.SpreadBiasPitch") / 1.015)
			self:SetStatRawL("Primary.SpreadBiasYaw", self:GetStatL("Primary.SpreadBiasYaw") / 1.015)
			self.Shrink = CurTime() + 0.015
		end

		if self.Breathe <= CurTime() then
			self:ResetCrosshair()
			self.Breathe = CurTime() + 1
		end

		if self:GetHeldTime() ~= 0 and self:GetHeldTime() <= CurTime() then
			self:SelfDefense()
			self:SetDetonated(true)
		end
	end

	return BaseClass.Think2(self, ...)
end

function SWEP:PreSpawnProjectile(ent)
	if self.Cookable then
		ent.Delay = (self:GetHeldTime() - CurTime()) + 0.1 --here
	end
end

function SWEP:ResetCrosshair()
	self:SetStatRawL("Primary.SpreadBiasPitch", 1)
	self:SetStatRawL("Primary.SpreadBiasYaw", 1)
end

function SWEP:SelfDefense()
	local fx = EffectData()
	fx:SetOrigin(self:GetPos())

	util.Effect("HelicopterMegaBomb", fx)
	util.Effect("Explosion", fx)

	util.BlastDamage(self, self:GetOwner(), self:GetPos(), 200, 150)
	util.ScreenShake(self:GetPos(), 15, 255, 1, 350)
end

function SWEP:PostSpawnProjectile(ent)
	if self.ThrowSpin then
		local angvel = Vector(math.random(-2000,-500),math.random(-500,-2000),math.random(-500,-2000))
		angvel:Rotate(-1*ent:EyeAngles())
		angvel:Rotate(Angle(0,self.Owner:EyeAngles().y,0))

		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:AddAngleVelocity(angvel)
		end
	end
end
