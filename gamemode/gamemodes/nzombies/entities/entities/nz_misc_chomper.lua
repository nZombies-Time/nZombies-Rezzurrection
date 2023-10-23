
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
ENT.PrintName = "Chomper"

--[Parameters]--
ENT.Delay = 8
ENT.RangeSqr = 62500
ENT.Attacked = false

ENT.MoveSpeed = 120
ENT.CurveStrengthMin = 1
ENT.CurveStrengthMax = 2

DEFINE_BASECLASS( ENT.Base )

local nzombies = engine.ActiveGamemode() == "nzombies"

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "SoundDelay")
	self:NetworkVar("Entity", 0, "Victim")
end

function ENT:StartTouch(ply)
	if not ply:IsPlayer() then return end
	if not ply:GetNotDowned() or not ply:Alive() then return end
	if self.Attacked then return end
	self.Attacked = true

	local rand = VectorRand(-21,21)
	rand = Vector(rand.x, rand.y, 1)
	util.Decal("Blood", ply:GetPos() - rand, ply:GetPos() + rand) //floor blood

	local att = self:GetAttachment(2)

	local tr = util.QuickTrace(att.Pos, att.Ang:Forward()*64, {self, ply})
	if tr.Hit and tr.HitWorld then
		util.Decal("Blood", tr.HitPos - tr.HitNormal, tr.HitPos + tr.HitNormal) //wall blood
	end

	ParticleEffect("blood_impact_red_01", att.Pos, self:GetForward():Angle())
	self:EmitSound("TFA_BO3_DEMONBOW.Chomper.Bite")

	ply:TakeDamage(15, self, self)

	self:SetVictim(nil)

	SafeRemoveEntityDelayed(self, 0.5)
end

function ENT:Initialize(...)
	BaseClass.Initialize(self,...)

	self:SetModel("models/weapons/tfa_bo3/demonbow/chomper_prop.mdl")
	self.AutomaticFrameAdvance = true
	self:SetSolid(SOLID_NONE)
	self:UseTriggerBounds(true, 4)
	self:ResetSequence("fly")

	self:EmitSoundNet("TFA_BO3_DEMONBOW.Chomper.Loop")
	self:EmitSoundNet("TFA_BO3_DEMONBOW.Chomper.Appear")

	self:SetVictim(self:FindNearestEntity(self:GetPos(), self.RangeSqr))
	self:SetSoundDelay(CurTime() + math.Rand(0.35, 0.8))

	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableDrag(false)
		phys:EnableGravity(false)
	end

	//ParticleEffectAttach("bo3_keepersword_trail", PATTACH_ABSORIGIN_FOLLOW, self, 1)

	self.killtime = CurTime() + self.Delay

	if CLIENT then return end
	self:SetTrigger(true)
end

function ENT:Think()
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetVelocity(self:GetForward() * self.MoveSpeed)
		phys:AddAngleVelocity(VectorRand() * (math.sin(CurTime() * 30))* math.random(self.CurveStrengthMin, self.CurveStrengthMax))
		self:SetAngles(phys:GetVelocity():Angle())
	end

	if self:GetSoundDelay() < CurTime() then
		self:EmitSound("TFA_BO3_DEMONBOW.Chomper.Vox.Short")
		self:SetSoundDelay(CurTime() + math.Rand(1,2))
	end

	if SERVER then
		local ply = self:GetVictim()
		if (not IsValid(ply) or not ply:Alive() or not ply:GetNotDowned()) and not self.Attacked then
			self:SetVictim(self:FindNearestEntity(self:GetPos(), self.RangeSqr))
		end

		if IsValid(ply) and ply:Health() > 0 then
			local tang = (ply:GetShootPos() - self:GetPos()):GetNormalized()
			local finalang = LerpAngle(0.05, self:GetAngles(), tang:Angle())
			self:SetAngles(finalang)
		end

		if self.killtime < CurTime() or (self:GetCreationTime() + 1 < CurTime() and not self:IsInWorld()) then
			self:StopSound("TFA_BO3_DEMONBOW.Chomper.Loop")
			self:Remove()
			return false
		end
	end

	self:NextThink(CurTime())
	return true
end

function ENT:FindNearestEntity(pos, rangesqr)
	local ply

	for k, v in RandomPairs(player.GetAll()) do
		if (not v:Alive()) or (not v:GetNotDowned()) then continue end
		if v:GetPos():DistToSqr(self:GetPos()) > rangesqr then continue end
		ply = v
		break
	end

	return ply
end

function ENT:OnRemove()
	if CLIENT and IsValid(self) and DynamicLight then
		local dlight = DynamicLight(self:EntIndex())
		if dlight then
			dlight.pos = self:WorldSpaceCenter()
			dlight.r = 120
			dlight.g = 80
			dlight.b = 255
			dlight.brightness = 2
			dlight.Decay = 2000
			dlight.Size = 400
			dlight.DieTime = CurTime() + 0.5
		end
	end

	self:StopSound("TFA_BO3_DEMONBOW.Chomper.Loop")
	self:EmitSound("TFA_BO3_DEMONBOW.Chomper.Disappear")
end
