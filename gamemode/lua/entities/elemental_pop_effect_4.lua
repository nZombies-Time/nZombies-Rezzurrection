
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
ENT.PrintName = "Thunderwall"
ENT.Spawnable = false
ENT.AdminOnly = false

ENT.Kills = 0
ENT.MaxKills = 20

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

	local ply = self:GetAttacker()
	local wep = self:GetInflictor()
	if IsValid(ply) and IsValid(wep) and wep.IsTFAWeapon then
		self:SetParent(nil)
		self:SetPos(ply:GetShootPos())

		wep:EmitGunfireSound("NZ.POP.Thunderwall.Shoot")

		if SERVER then
			local ball = ents.Create("bo3_ww_thundergun")
			ball:SetModel("models/dav0r/hoverball.mdl")
			ball:SetPos(ply:GetShootPos())
			ball:SetOwner(ply)
			ball:SetAngles(ply:GetAimVector():Angle())

			ball:Spawn()

			local dir = ply:GetAimVector()
			dir:Mul(1000)

			ball:SetVelocity(dir)

			local phys = ball:GetPhysicsObject()
			if IsValid(phys) then
				phys:SetVelocity(dir)
			end

			ball:SetOwner(ply)
			ball.Inflictor = wep
		end
	end

	if CLIENT then return end
	local ply = self:GetAttacker()
	local wep = self:GetInflictor()
	local ang = math.cos(math.rad(45))

	for _, ent in pairs(ents.FindInCone(ply:GetShootPos(), wep:GetAimVector(), 500, ang)) do
		if ent:IsValidZombie() then
			if ent == ply then continue end
			if ent:Health() <= 0 then continue end
			if self.Kills >= self.MaxKills then break end

			if SERVER then
				self:ThundergunDamage(ent)
			end
		end
	end
	self:Remove()
end

function ENT:ThundergunDamage(ent)
	if CLIENT then return end
	local ply = self:GetAttacker()
	local wep = self:GetInflictor()

	local damage = DamageInfo()
	damage:SetDamageType(DMG_MISSILEDEFENSE)
	damage:SetAttacker(ply)
	damage:SetInflictor(wep)
	damage:SetDamage(ent:Health() + 666)
	damage:SetDamageForce(ent:GetUp()*20000 + wep:GetAimVector()*50000)

	if nzombies and (ent.NZBossType or string.find(ent:GetClass(), "nz_zombie_boss")) then
		damage:SetDamage(math.max(2000, ent:GetMaxHealth() / 4))
		damage:ScaleDamage(math.Round(nzRound:GetNumber()/6))
	end

	ent:TakeDamageInfo(damage)
	self.Kills = self.Kills + 1
end
