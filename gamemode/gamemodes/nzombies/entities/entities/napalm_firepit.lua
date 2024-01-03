
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
ENT.PrintName = "Contact Explosive"
ENT.HasTrail = true 

--[Sounds]--
ENT.BounceSound = Sound("TFA_CODWW2_MOLOTOV.Bounce")
ENT.LoopSound = Sound("TFA_CODWW2_MOLOTOV.Loop")
ENT.ShatterSound = Sound("TFA_CODWW2_MOLOTOV.Shatter")
ENT.ExplodeSound = Sound("TFA_CODWW2_MOLOTOV.Explode")
ENT.FizzleSound = Sound("TFA_CODWW2_MOLOTOV.End")

--[Parameters]--
ENT.Impacted = false
ENT.IsDetonated = false
ENT.TriggerSphere = false
local nzombies = engine.ActiveGamemode() == "nzombies"

DEFINE_BASECLASS(ENT.Base)

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:PhysicsCollide(data, phys)
	if self:GetNW2Bool("Impacted") then return end
	if data.HitNormal:Dot(Vector(0,0,-1))<0.75 then
		if data.Speed > 60 then
			self:EmitSound(self.BounceSound)
		end

		local impulse = (data.OurOldVelocity - 3 * data.OurOldVelocity:Dot(data.HitNormal) * data.HitNormal)*0.9
		phys:ApplyForceCenter(impulse)
	else
		self:StopParticles()
		self:Explode()
		self:SetNoDraw(true)
		self:DrawShadow(false)
		phys:EnableMotion(false)
		phys:Sleep()
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		self:SetNW2Bool("Impacted", true)
	end
end

function ENT:CreateRocketTrail()
	ParticleEffectAttach("ww2_molotov_trail",PATTACH_POINT_FOLLOW,self,1)
end

function ENT:Initialize(...)
	BaseClass.Initialize(self, ...)

	if self.HasTrail then
		self:CreateRocketTrail()
	end
end

local drawdlight = GetConVar("cl_tfa_codww2_dlights")

function ENT:Think()
	local ply = self:GetOwner()
	if CLIENT and self:GetNW2Bool("Impacted") and drawdlight:GetBool() then
		local dlight = DynamicLight(self:EntIndex())
		if (dlight) then
			dlight.pos = self:GetPos()
			dlight.dir = self:GetPos()
			dlight.r = 235
			dlight.g = 75
			dlight.b = 15
			dlight.brightness = 3
			dlight.Decay = 200
			dlight.Size = 400
			dlight.DieTime = CurTime() + 1
		end
	end
	if SERVER then
		if self:WaterLevel() > 0 then
			self:Remove()
			return false
		end

		if self:GetNW2Bool("TriggerSphere") then
			if not IsValid(self.Inflictor) then
				self.Inflictor = self
			end

			local tr = {
				start = self:GetPos(),
				filter = self,
				mask = MASK_SHOT_HULL
			}

			for k, v in pairs(ents.FindInSphere(self:GetPos(), 150)) do
				if IsValid(v) and nzombies then
					if v == self:GetOwner() then continue end
					if v:Health() <= 0 then continue end
					if v:BO4IsMagmaIgnited() then continue end
					if v.NZBossType or v.IsMooBossZombie then continue end
					tr.endpos = v:WorldSpaceCenter()
					local tr1 = util.TraceLine(tr)
					if tr1.HitWorld then continue end

					local firedmg = DamageInfo()
					firedmg:SetAttacker( self )
					firedmg:SetDamage( 20 )
					firedmg:SetDamageType( DMG_BURN )
					
					if v.IsMooZombie and !v.IsMooSpecial and !v.IsMooBossZombie then
						v:BO4Magma(math.Rand(1,2), self:GetOwner(), self.Inflictor, v:GetMaxHealth()/6)	
					else
						v:TakeDamageInfo(firedmg)
					end
				end
			end
		end
	end
	
	if not self:GetNW2Bool("Impacted") then
		self:NextThink(CurTime())
	else
		self:NextThink( CurTime() + math.Rand( 0.5, 0.6 ) )
	end
	return true
end

function ENT:DoExplosionEffect()
	self:EmitSound(self.LoopSound)
	ParticleEffect("ww2_molotov_explosion", self:GetPos(), Angle(-90,0,0))
end

function ENT:Explode()
	if not self:GetNW2Bool("TriggerSphere", false) then
		--self:EmitSound(self.ShatterSound)
		self:EmitSound(self.ExplodeSound)
		self:SetNW2Bool("TriggerSphere", true)
		self:DoExplosionEffect()
	end
	
	if not IsValid(self.Inflictor) then
		self.Inflictor = self
	end
	--[[local dmg = DamageInfo()
	dmg:SetInflictor(self.Inflictor)
	dmg:SetAttacker(IsValid(self:GetOwner()) and self:GetOwner() or self)
	dmg:SetDamage(2)
	dmg:SetDamageType(bit.bor(DMG_BURN, DMG_SLOWBURN))
	util.BlastDamageInfo(dmg, self:GetPos(), 150)]]

	SafeRemoveEntityDelayed(self,20) --removal of nade
end

function ENT:OnRemove()
	self:EmitSound(self.FizzleSound)
    self:StopSound(self.LoopSound)
end