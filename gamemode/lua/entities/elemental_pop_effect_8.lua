
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
ENT.PrintName = "Wunder Weapon"
ENT.Spawnable = false
ENT.AdminOnly = false

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

	self.WonderWeaponEffects = {
		[1] = self.ScavengerEffect,
		[2] = self.WaffeEffect,
		[3] = self.WavegunEffect,
		[4] = self.ShrinkrayEffect,
		[5] = self.MirgEffect,
		[6] = self.TundragunEffect,
		[7] = self.MagmagatEffect,
		[8] = self.AliShrinkEffect,
	}

	if CLIENT then return end
	self.WonderWeaponEffects[math.random(8)](self)
	self:Remove()
end

function ENT:ScavengerEffect()
	self:EmitSound("TFA_BO3_SCAVENGER.Explode")
	ParticleEffect("bo3_scavenger_explosion", self:GetPos(), Angle(0,0,0))

	util.ScreenShake(self:GetPos(), 20, 255, 1, 500)

	for k, v in pairs(ents.FindInSphere(self:GetPos(), 250)) do
		if not v:IsWorld() and v:IsSolid() then
			local damage = DamageInfo()
			damage:SetDamage(11500)

			if v:IsPlayer() then
				local distfac = self:GetPos():Distance(v:GetPos())
				distfac = 1 - math.Clamp(distfac/250, 0, 1)
				damage:SetDamage(200 * distfac)
			end

			damage:SetAttacker(self:GetAttacker())
			damage:SetInflictor(self:GetInflictor())
			damage:SetDamageForce(v:GetUp()*20000 + (v:GetPos() - self:GetPos()):GetNormalized() * 15000)
			damage:SetDamageType(bit.bor(DMG_BLAST, DMG_ALWAYSGIB))

			v:TakeDamageInfo(damage)
		end
	end
end

function ENT:WaffeEffect()
	local waff = ents.Create("bo3_ww_wunderwaffe")
	waff:SetModel("models/dav0r/hoverball.mdl")
	waff:SetPos(self:GetPos() + Vector(0,0,24))
	waff:SetAngles(Angle(90,0,0))
	waff:SetOwner(self:GetAttacker())
	waff.Inflictor = self:GetInflictor()

	waff.Damage = 115
	waff.mydamage = 115

	waff:Spawn()

	local ang = Angle(90,0,0)
	local dir = ang:Forward() 
	dir:Mul(500)

	waff:SetVelocity(dir)
	local phys = waff:GetPhysicsObject()
	if IsValid(phys) then
		phys:SetVelocity(dir)
	end

	waff:SetOwner(self:GetAttacker())
	waff.Inflictor = self:GetInflictor()
end

function ENT:WavegunEffect()
	self:EmitSound("TFA_BO3_ZAPGUN.Flux")
	ParticleEffect("bo3_zapgun_impact_pap", self:GetPos(), Angle(90,0,0))

	for k, v in pairs(ents.FindInSphere(self:GetPos(), 250)) do
		if (v:IsNPC() or v:IsNextBot()) and not v:BO3IsCooking() then
			v:BO3Microwave(math.Rand(2,3), self:GetAttacker(), self:GetInflictor())
		end
	end
end

function ENT:ShrinkrayEffect()
	self:EmitSound("TFA_BO3_JGB.Flux")
	ParticleEffect("bo3_jgb_impact", self:GetPos(), Angle(0,0,0))

	for k, v in pairs(ents.FindInSphere(self:GetPos(), 250)) do
		if (v:IsNPC() or v:IsNextBot()) and not v:BO3IsShrunk() then
			v:BO3Shrink(12, false)
		end
	end
end

function ENT:MirgEffect()
	self:EmitSound("TFA_BO3_MIRG.Impact")
	self:EmitSound("TFA_BO3_MIRG.ImpactSwt")
	ParticleEffect("bo3_mirg2k_impact", self:GetPos(), Angle(90,0,0))

	for k, v in pairs(ents.FindInSphere(self:GetPos(), 250)) do
		if (v:IsNPC() or v:IsNextBot()) and not v:BO3IsSpored() then
			v:BO3Spore(math.random(2,5)*0.5, self:GetAttacker(), self:GetInflictor(), false)
		end
	end
end

function ENT:TundragunEffect()
	self:EmitSound("TFA_BO4_TUNDRAGUN.Impact")
	self:EmitSound("TFA_BO3_GRENADE.ExpClose")
	self:EmitSound("TFA_BO3_GRENADE.Flux")
	ParticleEffect("bo4_tundragun_impact", self:GetPos(), Angle(90,0,0))

	for k, v in pairs(ents.FindInSphere(self:GetPos(), 250)) do
		if (v:IsNPC() or v:IsNextBot()) and not v:BO4IsFrozen() then
			ParticleEffect("bo4_tundragun_zomb", v:WorldSpaceCenter(), Angle(0,0,0))
			v:BO4WintersFreeze(math.Rand(4,5), self:GetAttacker(), self:GetInflictor())
		end
	end
end

function ENT:MagmagatEffect()
	self:EmitSound("TFA_BO4_BLUNDER.Magma.Explode")
	self:EmitSound("TFA_BO4_BLUNDER.Magma.Explode.Swt")
	ParticleEffect("bo4_magmagat_explode", self:GetPos(), Angle(90,0,0))

	for k, v in pairs(ents.FindInSphere(self:GetPos(), 250)) do
		if (v:IsNPC() or v:IsNextBot()) and not v:BO4IsMagmaIgnited() then
			v:BO4Magma(math.Rand(1,2), self:GetAttacker(), self:GetInflictor(), 54000)
		end
	end
end

function ENT:AliShrinkEffect()
	for k, v in pairs(ents.FindInSphere(self:GetPos(), 250)) do
		if (v:IsNPC() or v:IsNextBot()) and not v:BO4IsShrunk() then
			v:BO4Shrink(1, self:GetAttacker(), self:GetInflictor())
		end
	end
end

