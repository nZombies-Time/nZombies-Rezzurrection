
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
ENT.PrintName = "ZombShell Logic"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Author = "DBot, FlamingFox"
ENT.RenderGroup = RENDERGROUP_OTHER
local entMeta = FindMetaTable("Entity")

if SERVER then
	entMeta.ZombSlow = function(self, duration, speed)
		if self.IsAATTurned and self:IsAATTurned() then return end
		if self.NZBossType then return end
		if string.find(self:GetClass(), "nz_zombie_boss") then return end

		if duration == nil then
			duration = 0
		end
		if speed == nil then
			speed = 20
		end

		if IsValid(self.perk_zombshell_logic) then
			self.perk_zombshell_logic:UpdateDuration(duration)
			return self.perk_zombshell_logic
		end

		self.perk_zombshell_logic = ents.Create("status_effect_zomb_slow")
		self.perk_zombshell_logic:SetPos(self:GetPos())
		self.perk_zombshell_logic:SetParent(self)
		self.perk_zombshell_logic:SetOwner(self)
		self.perk_zombshell_logic:SetSpeed(speed)

		self.perk_zombshell_logic:Spawn()
		self.perk_zombshell_logic:Activate()

		self.perk_zombshell_logic:SetOwner(self)
		self.perk_zombshell_logic:UpdateDuration(duration)
		self:SetNWEntity("PERK.ZombShellLogic", self.perk_zombshell_logic)
		return self.perk_zombshell_logic
	end

	hook.Add("OnZombieKilled", "PERK.ZombShellLogic", function(self)
		if IsValid(self.perk_zombshell_logic) then
			return self.perk_zombshell_logic:Remove()
		end
	end)
end

entMeta.IsZombSlowed = function(self)
	return IsValid(self:GetNWEntity("PERK.ZombShellLogic"))
end

ENT.SetupDataTables = function(self)
	self:NetworkVar("Float", 0, "Speed")
end

ENT.Draw = function(self)
end

ENT.Initialize = function(self)
	self:SetNoDraw(true)
	self:SetNotSolid(true)
	self:SetMoveType(MOVETYPE_NONE)

	local p = self:GetParent()
	if SERVER and IsValid(p) and p:IsValidZombie() then
		p.loco:SetAcceleration(self:GetSpeed())
		p.loco:SetDesiredSpeed(self:GetSpeed())
	end

	if CLIENT then return end
	self.statusStart = CurTime()
	self.duration = 1
	self.statusEnd = self.statusStart + 1
end

ENT.UpdateDuration = function(self, newtime)
	if newtime == nil then
		newtime = 0
	end

	if self.statusEnd - CurTime() > newtime then return end

    self.duration = newtime
    self.statusEnd = CurTime() + newtime
end

ENT.Think = function(self)
	if CLIENT then return false end

	if self.statusEnd < CurTime() then
		self:Remove()
		return false
	end

	self:NextThink(CurTime())
	return true
end

ENT.OnRemove = function(self)
	local p = self:GetParent()
	if IsValid(p) and p:IsValidZombie() then
		p.loco:SetAcceleration(p.Acceleration)
		p.loco:SetDesiredSpeed(p:GetRunSpeed())
	end
end
