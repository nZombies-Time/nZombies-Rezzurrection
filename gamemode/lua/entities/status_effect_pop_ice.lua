
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
ENT.Type = "anim"
ENT.PrintName = "Cryofreeze Logic"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Author = "DBot, FlamingFox"
ENT.RenderGroup = RENDERGROUP_OTHER
local entMeta = FindMetaTable("Entity")

if SERVER then
	entMeta.ATTCryoFreeze = function(self, duration, attacker, inflictor)
		if duration == nil then
			duration = 0
		end

		if IsValid(self.perk_cryfreeze_logic) then
			self.perk_cryfreeze_logic:UpdateDuration(duration)
			return self.perk_cryfreeze_logic
		end

		self.perk_cryfreeze_logic = ents.Create("status_effect_pop_ice")
		self.perk_cryfreeze_logic:SetPos(self:GetPos())
		self.perk_cryfreeze_logic:SetParent(self)
		self.perk_cryfreeze_logic:SetOwner(self)

		self.perk_cryfreeze_logic:Spawn()
		self.perk_cryfreeze_logic:Activate()

		self.perk_cryfreeze_logic:SetAttacker(attacker)
		self.perk_cryfreeze_logic:SetInflictor(inflictor)

		self.perk_cryfreeze_logic:SetOwner(self)
		self.perk_cryfreeze_logic:UpdateDuration(duration)
		self:SetNWEntity("PERK.CryofreezeLogic", self.perk_cryfreeze_logic)
		return self.perk_cryfreeze_logic
	end

	hook.Add("OnZombieKilled", "PERK.CryofreezeLogic", function(self)
		if IsValid(self.perk_cryfreeze_logic) then
			return self.perk_cryfreeze_logic:Remove()
		end
	end)
end

entMeta.IsATTCryoFreeze = function(self)
	return IsValid(self:GetNWEntity("PERK.CryofreezeLogic"))
end

ENT.SetupDataTables = function(self)
	self:NetworkVar("Entity", 0, "Attacker")
	self:NetworkVar("Entity", 1, "Inflictor")
end

ENT.Draw = function(self)
end

ENT.Initialize = function(self)
	self:SetNoDraw(true)
	self:SetNotSolid(true)
	self:SetMoveType(MOVETYPE_NONE)

	local p = self:GetParent()
	if IsValid(p) then
		p.Old_Mat = p:GetMaterial()
		p:SetMaterial("models/overlay/freeze_overlay")
		p:EmitSound("NZ.POP.Cryofreeze.Freeze")

		ParticleEffect("bo3_aat_freeze_explode", p:WorldSpaceCenter(), Angle(0,0,0))
	end

	if CLIENT then return end
	self:TrapNextBot(p)
	self.statusStart = CurTime()
	self.duration = 1
	self.statusEnd = self.statusStart + 1
end

ENT.UpdateDuration = function(self, newtime)
	if newtime == nil then
		newtime = 0
	end
	if self.statusEnd - CurTime() > newtime then return end
	
	local p = self:GetParent()
	if p.Freeze then
		p:Freeze(newtime)
	end

    self.duration = newtime
    self.statusEnd = CurTime() + newtime
end

ENT.Think = function(self)
	if CLIENT then return false end

	local p = self:GetParent()
	if self.statusEnd < CurTime() then
		if IsValid(p) then
			self:InflictDamage(p)
		end
		self:Remove()
		return false
	end

	self:NextThink(CurTime())
	return true
end

ENT.InflictDamage = function(self, ent)
	local damage = DamageInfo()
	damage:SetDamageType(DMG_REMOVENORAGDOLL)
	damage:SetAttacker(IsValid(self:GetAttacker()) and self:GetAttacker() or self)
	damage:SetInflictor(IsValid(self:GetInflictor()) and self:GetInflictor() or self)
	damage:SetDamagePosition(ent:WorldSpaceCenter())
	damage:SetDamageForce(vector_origin)
	damage:SetDamage(ent:Health() + 666)

	ent:TakeDamageInfo(damage)
	ent:Remove()
end

ENT.TrapNextBot = function(self, bot)
	if bot:IsNextBot() then
		bot.loco:SetVelocity(vector_origin)
		bot.loco:SetAcceleration(0)
		bot.loco:SetDesiredSpeed(0)
		if bot:IsValidZombie() then
			bot:SetBlockAttack(true)
		end
	end
end

ENT.OnRemove = function(self)
	local p = self:GetParent()
	if IsValid(p) then
		p:EmitSound("NZ.POP.Cryofreeze.Shatter")
		ParticleEffect("bo3_aat_freeze", p:WorldSpaceCenter(), Angle(0,0,0))
	end
end
