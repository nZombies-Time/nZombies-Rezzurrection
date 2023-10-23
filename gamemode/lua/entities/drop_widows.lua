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
ENT.PrintName = "Widows Refill"
ENT.Purpose = ""
ENT.Instructions = ""
ENT.Spawnable = false
ENT.AdminOnly = false

--[Parameters]--
ENT.Delay = 30
ENT.NextDraw = 0

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Blinking")
	self:NetworkVar("Float", 0, "KillTime")
	self:NetworkVar("Float", 1, "BlinkTime")
end

function ENT:StartTouch(ply)
	if ply:IsPlayer() and ply:HasPerk("widowswine") and ply:GetAmmoCount(GetNZAmmoID("grenade")) < 4 then
		self:StopSound("nz_moo/powerups/powerup_lp_zhd.wav")
		self:EmitSound("nz_moo/powerups/powerup_pickup_zhd.mp3")

		ply:SetAmmo(ply:GetAmmoCount(GetNZAmmoID("grenade")) + (ply:HasUpgrade("widowswine") and 2 or 1), GetNZAmmoID("grenade"))
		self:Remove()
	end
end

function ENT:Initialize(...)
	self:SetModel("models/nzr/2022/powerups/powerup_widows.mdl")
	self:SetModelScale(1, 0)

	self:PhysicsInit(SOLID_NONE)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	self:UseTriggerBounds(true, 8)

	self:EmitSound("nz_moo/powerups/powerup_spawn_zhd_"..math.random(1,3)..".mp3", 100)
	self:EmitSound("nz_moo/powerups/powerup_lp_zhd.wav", 75, 100, 1, 3)

	ParticleEffectAttach("nz_powerup_local", PATTACH_ABSORIGIN_FOLLOW, self, 1)

	self:SetKillTime(CurTime() + 30)
	self:SetBlinkTime(CurTime() + 25)

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

	if self:GetBlinking() and self.NextDraw < CurTime() then
		local time = self:GetKillTime() - self:GetBlinkTime()
		local final = math.Clamp(self:GetKillTime() - CurTime(), 0.1, 1)
		final = math.Clamp(final / time, 0.1, 1)

		self:SetNoDraw(not self:GetNoDraw())
		self.NextDraw = CurTime() + (1 * final)

		if not self:GetNoDraw() and final > 0.25 then
			ParticleEffectAttach("nz_powerup_local", PATTACH_ABSORIGIN_FOLLOW, self, 1)
		end
	end

	if not self:GetBlinking() and self:GetBlinkTime() < CurTime() then
		self:SetBlinking(true)
	end

	self:NextThink(CurTime())
	return true
end

function ENT:OnRemove()
	self:StopSound("nz_moo/powerups/powerup_lp_zhd.wav")
end
