
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
ENT.PrintName = "Winters Slow Logic"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Author = "DBot, FlamingFox"
ENT.RenderGroup = RENDERGROUP_OTHER

local nzombies = engine.ActiveGamemode() == "nzombies"
local entMeta = FindMetaTable("Entity")

if SERVER then
	entMeta.WintersWailSlow = function(self, duration, ratio)
		if self.IsAATTurned and self:IsAATTurned() then return end
		if self.NZBossType then return end
		if string.find(self:GetClass(), "nz_zombie_boss") then return end

		if duration == nil then
			duration = 0
		end
		if ratio == nil then
			ratio = 1
		end

		if IsValid(self.winters_wail_logic) then
			self.winters_wail_logic:UpdateDuration(duration)
			return self.winters_wail_logic
		end

		self.winters_wail_logic = ents.Create("status_effect_winterswail")
		self.winters_wail_logic:SetPos(self:WorldSpaceCenter())
		self.winters_wail_logic:SetParent(self)
		self.winters_wail_logic:SetOwner(self)
		self.winters_wail_logic:SetRatio(ratio)

		self.winters_wail_logic:Spawn()
		self.winters_wail_logic:Activate()

		self.winters_wail_logic:SetOwner(self)
		self.winters_wail_logic:UpdateDuration(duration)
		self:SetNWEntity("PERK.WintersWailLogic", self.winters_wail_logic)
		return self.winters_wail_logic
	end

	hook.Add("OnNPCKilled", "PERK.WintersWailLogic", function(self)
		if IsValid(self.winters_wail_logic) then
			return self.winters_wail_logic:Remove()
		end
	end)
	if nzombies then
		hook.Add("OnZombieKilled", "PERK.WintersWailLogic", function(self)
			if IsValid(self.winters_wail_logic) then
				return self.winters_wail_logic:Remove()
			end
		end)
	end
end

entMeta.IsWintersWailSlow = function(self)
	return IsValid(self:GetNWEntity("PERK.WintersWailLogic"))
end

ENT.SetupDataTables = function(self)
	self:NetworkVar("Float", 0, "Ratio")
end

ENT.Draw = function(self)
end

ENT.Initialize = function(self)
	self:SetNoDraw(true)
	self:SetNotSolid(true)
	self:SetMoveType(MOVETYPE_NONE)

	local p = self:GetParent()
	if IsValid(p) then
		ParticleEffectAttach("nz_perks_winters_zomb", PATTACH_POINT_FOLLOW, p, 0)
		if SERVER and nzombies and p:IsValidZombie() then
			p:SetBlockAttack(true)
		end
	end

	if CLIENT then return end
	self.statusStart = CurTime()
	self.duration = 0.1
	self.statusEnd = self.statusStart + 0.1
end

ENT.UpdateDuration = function(self, newtime)
	if newtime == nil then
		newtime = 0
	end

	if self.statusEnd - CurTime() > newtime then return end
    self.duration = newtime
    self.statusEnd = CurTime() + newtime

    local p = self:GetParent()
	if SERVER and IsValid(p) then
		if p:IsNextBot() then
			if not p.OldAccel then
				p.OldAccel = p.loco:GetAcceleration()
				p.OldSpeed = p.loco:GetDesiredSpeed()
			end

			p.loco:SetVelocity(vector_origin)
			p.loco:SetDesiredSpeed(0)
			p.loco:SetAcceleration(0)

			if p.Freeze then
				p:Freeze(newtime)
			end
		end

		if p:IsNPC() then
			if not p.OldSpeed then
				p.OldSpeed = p:GetMoveVelocity()
			end

			p:SetMoveVelocity(p:GetMoveVelocity() * self:GetRatio())
			self.npc_spd = p:GetMoveVelocity()
		end
	end
end

ENT.Think = function(self)
	if CLIENT then return false end

	local p = self:GetParent()
	if IsValid(p) and not p:BO4IsFrozen() then
		if p:IsNPC() then
			p:SetMoveVelocity(self.npc_spd)
		end

		if p:IsNextBot() then
			p.loco:SetDesiredSpeed(0)
			p.loco:SetAcceleration(0)
			if nzombies and p:IsValidZombie() then
				p:SetBlockAttack(true)
			end
		end
	end

	if self.statusEnd < CurTime() then
		self:Remove()
		return false
	end

	self:NextThink(CurTime())
	return true
end

ENT.OnRemove = function(self)
	local p = self:GetParent()
	if IsValid(p) then
		p:StopParticles()

		if p:IsNextBot() then
			if nzombies then
				p.loco:SetAcceleration(p.Acceleration)
				p.loco:SetDesiredSpeed(p:GetRunSpeed())
				if p:IsValidZombie() then
					p:SetBlockAttack(false)
				end
			else
				p.loco:SetAcceleration(p.OldAccel)
				p.loco:SetDesiredSpeed(p.OldSpeed)
			end
		end

		if p:IsNPC() then
			p:SetMoveVelocity(p.OldSpeed)
		end
	end
end
