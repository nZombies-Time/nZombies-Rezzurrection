
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
ENT.PrintName = "Bomber Grenade"
ENT.NZThrowIcon = Material("grenade-256.png", "smooth unlitgeneric")

--[Parameters]--
ENT.Delay = 2.5
ENT.Range = 200

local BounceSound = {
	[MAT_WOOD] = "TFA.BO1.M67.Bounce.Wood",
	[MAT_DIRT] = "TFA.BO1.M67.Bounce.Earth",
	[MAT_METAL] = "TFA.BO1.M67.Bounce.Metal",
	[0] = "TFA.BO1.M67.Bounce.Earth",
}

BounceSound[MAT_GRATE] = BounceSound[MAT_METAL]
BounceSound[MAT_VENT] = BounceSound[MAT_METAL]
BounceSound[MAT_GRASS] = BounceSound[MAT_DIRT]
BounceSound[MAT_SNOW] = BounceSound[MAT_DIRT]
BounceSound[MAT_SNOW] = BounceSound[MAT_DIRT]

DEFINE_BASECLASS( ENT.Base )

function ENT:Draw()
	self:DrawModel()
end

function ENT:PhysicsCollide(data, phys)
	if data.Speed > 60 then
		local norm = (data.HitPos - self:GetPos()):GetNormalized()
		local tr = util.QuickTrace(self:GetPos(), norm*10, self)

		if tr.Hit then
			local finalsound = BounceSound[tr.MatType] or BounceSound[0]
			self:EmitSound(finalsound)
		end
	end

	local LastSpeed = math.max( data.OurOldVelocity:Length(), data.Speed )
	local NewVelocity = phys:GetVelocity()
	NewVelocity:Normalize()

	LastSpeed = math.max( NewVelocity:Length(), LastSpeed )
	local TargetVelocity = NewVelocity * LastSpeed * 0.6
	phys:SetVelocity( TargetVelocity )
end

function ENT:Initialize()
	BaseClass.Initialize(self)
	self:SetModel("models/weapons/w_grenade.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	self.Damage = self.mydamage or self.Damage
	self.killtime = CurTime() + self.Delay
	self.spawntime = CurTime()
	self.RangeSqr = self.Range*self.Range
	self:SetMoveType(MOVETYPE_VPHYSICS)
	
	self:EmitSound("npc/scanner/scanner_siren2.wav")

	if CLIENT then return end
	self:SetTrigger(true)
	util.SpriteTrail(self, 1, Color(255,20,0,255), false, 5, 1, 0.2, 2, "effects/laser_citadel1.vmt")
	--print(self:GetPhysicsObject())
end

function ENT:Think()
	if CLIENT and DynamicLight then
	local dlight = DynamicLight(self:EntIndex())
	if (dlight) then
		dlight.pos = self:GetPos()
		dlight.r = 255
		dlight.g = 0
		dlight.b = 0
		dlight.brightness = 1
		dlight.Decay = 1000
		dlight.Size = 128
		dlight.DieTime = CurTime() + 1
		end
	end
	if SERVER then
		if self.killtime < CurTime() then
			self:Explode(self:GetPos())
			self:Remove()
			return false
		end
	end

	self:NextThink(CurTime())
	return true
end

function ENT:DoExplosionEffect()
	local tr = util.QuickTrace(self:GetPos(), Vector(0,0,-32), self)
	util.Decal("Scorch", tr.HitPos - tr.HitNormal, tr.HitPos + tr.HitNormal)

	self:EmitSound("TFA.BO1.EXP.Explode")
	self:EmitSound("TFA.BO1.EXP.Flux")
	self:EmitSound("TFA.BO1.EXP.Lfe")
	self:EmitSound("TFA.BO1.EXP.Dirt")

	local fx = EffectData()
	fx:SetOrigin(self:GetPos())

	util.Effect("HelicopterMegaBomb", fx)
	util.Effect("Explosion", fx)
end

function ENT:Explode()
	local zom = self:GetOwner()
	local tr = {
		start = self:GetPos(),
		filter = self,
		mask = MASK_SOLID_BRUSHONLY
	}

	local damage = DamageInfo()
	damage:SetAttacker(IsValid(zom) and zom or self)
	damage:SetInflictor(IsValid(self.Inflictor) and self.Inflictor or self)
	damage:SetDamageType(DMG_BLAST)

	for k, v in pairs(ents.FindInSphere(self:GetPos(), self.Range)) do
		if v:IsWorld() then continue end
		if v:IsNPC() or v:IsNextBot() then continue end
		tr.endpos = v:WorldSpaceCenter()
		local tr1 = util.TraceLine(tr)
		if tr1.HitWorld then continue end
		v:NZSonicBlind(1)

		local dist = self:GetPos():DistToSqr(v:GetPos())
		dist = 1 - math.Clamp(dist/self.RangeSqr, 0, 0.5)

		damage:SetDamage(105 * dist)

		damage:SetDamageForce(v:GetUp()*500 + (v:GetPos() - self:GetPos()):GetNormalized()*500)

		v:TakeDamageInfo(damage)

		damage:SetDamage(self.Damage)
	end

	util.ScreenShake(self:GetPos(), 10, 255, 1, self.Range*2)

	self:DoExplosionEffect()
	self:Remove()
end

function ENT:OnRemove()
	self:StopSound("npc/scanner/scanner_siren2.wav")
end

function ENT:getvel(pos, pos2, time)	-- target, starting point, time to get there
    	local diff = pos - pos2 --subtract the vectors
     
    	local velx = diff.x/time -- x velocity
    	local vely = diff.y/time -- y velocity
 
    	local velz = (diff.z - 0.5*(-GetConVarNumber( "sv_gravity"))*(time^2))/time --  x = x0 + vt + 0.5at^2 conversion
     
    	return Vector(velx, vely, velz)
end	
	
function ENT:LaunchArc(pos, pos2, time, t)	-- target, starting point, time to get there, fraction of jump
		local v = self:getvel(pos, pos2, time).z
		local a = (-GetConVarNumber( "sv_gravity"))
		local z = v*t + 0.5*a*t^2
		local diff = pos - pos2
		local x = diff.x*(t/time)
    	local y = diff.y*(t/time)
	
		return pos2 + Vector(x, y, z)
end
