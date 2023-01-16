
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
ENT.PrintName = "Vulture Stink Logic"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Author = "DBot, FlamingFox"
ENT.RenderGroup = RENDERGROUP_OTHER
local entMeta = FindMetaTable("Entity")

if SERVER then
	entMeta.VulturesStink = function(self, duration)
		if duration == nil then
			duration = 0
		end

		if IsValid(self.perk_vulturesstink_logic) then
			self.perk_vulturesstink_logic:UpdateDuration(duration)
			return self.perk_vulturesstink_logic
		end

		self.perk_vulturesstink_logic = ents.Create("status_effect_vultures_stink")
		self.perk_vulturesstink_logic:SetPos(self:WorldSpaceCenter())
		self.perk_vulturesstink_logic:SetParent(self)
		self.perk_vulturesstink_logic:SetOwner(self)

		self.perk_vulturesstink_logic:Spawn()
		self.perk_vulturesstink_logic:Activate()

		self.perk_vulturesstink_logic:SetOwner(self)
		self.perk_vulturesstink_logic:UpdateDuration(duration)
		self:SetNWEntity("PERK.VultureStinkLogic", self.perk_vulturesstink_logic)
		return self.perk_vulturesstink_logic
	end
	hook.Add("PlayerDeath", "PERK.VultureStinkLogic", function(self)
		if IsValid(self.perk_vulturesstink_logic) then
			return self.perk_vulturesstink_logic:Remove()
		end
	end)
end

entMeta.HasVultureStink = function(self)
	return IsValid(self:GetNWEntity("PERK.VultureStinkLogic"))
end

ENT.SetupDataTables = function(self)
end

ENT.Draw = function(self)
end

ENT.Initialize = function(self)
	self:SetNoDraw(true)
	self:SetNotSolid(true)
	self:SetMoveType(MOVETYPE_NONE)

	local p = self:GetParent()
	if IsValid(p) then
		p:EmitSound("NZ.Vulture.Stink.Start")
		p:EmitSound("NZ.Vulture.Stink.Loop")
		if SERVER then
			p:SetNoTarget(true)
			if p.SetTargetPriority then
				p:SetTargetPriority(TARGET_PRIORITY_NONE)
			end
		end
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
	if IsValid(p) then
		p:StopSound("NZ.Vulture.Stink.Loop")
		p:EmitSound("NZ.Vulture.Stink.Stop")
		if SERVER then
			p:SetNoTarget(false)
			p:StopParticles()
			if engine.ActiveGamemode() == "nzombies" then
				if IsValid(nzPowerUps.ActivePlayerPowerUps[p]) then
					if !nzPowerUps:IsPlayerPowerupActive(p, "zombieblood") then
						p:SetTargetPriority(TARGET_PRIORITY_PLAYER)
					end
				else
					p:SetTargetPriority(TARGET_PRIORITY_PLAYER)
				end
			end
		end
	end
end
