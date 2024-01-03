
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
ENT.LoopSound = Sound("nz_moo/zombies/vox/_pyromech/napalmchargelp_xsound_3ca4bbea7443d06.wav")
ENT.ExplodeSound = {
	Sound("nz_moo/zombies/vox/_pyromech/molotov/explo/explo_00.mp3"),
	Sound("nz_moo/zombies/vox/_pyromech/molotov/explo/explo_01.mp3"),
	Sound("nz_moo/zombies/vox/_pyromech/molotov/explo/explo_02.mp3"),
	Sound("nz_moo/zombies/vox/_pyromech/molotov/explo/explo_03.mp3"),
}

--[Parameters]--
ENT.Impacted = false
ENT.IsDetonated = false
ENT.TriggerSphere = false

ENT.StartLP = false

local nzombies = engine.ActiveGamemode() == "nzombies"

DEFINE_BASECLASS(ENT.Base)

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS
end

function ENT:PhysicsCollide(data, phys)
	if self:GetNW2Bool("Impacted") then return end
	if data.HitNormal:Dot(Vector(0,0,-1))<0.75 then
		if data.Speed > 60 then
			--self:EmitSound(self.BounceSound)
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

function ENT:Think()
	local ply = self:GetOwner()
	if CLIENT and self:GetNW2Bool("Impacted") then
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

		if !self.StartLP and !self:GetNW2Bool("Impacted") then
			self.StartLP = true
			self:EmitSound(self.LoopSound, 70, math.random(95,105))
		end

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
					if v.IsMooZombie then continue end
					tr.endpos = v:WorldSpaceCenter()
					local tr1 = util.TraceLine(tr)
					if tr1.HitWorld then continue end

					local firedmg = DamageInfo()
					firedmg:SetAttacker( self )
					firedmg:SetDamage( 15 )
					firedmg:SetDamageType( DMG_GENERIC )

					v:TakeDamageInfo(firedmg)
					v:Ignite(2, 0)
				end
			end
		end
	end
	
	if not self:GetNW2Bool("Impacted") then
		self:NextThink(CurTime())
	else
    	self:StopSound(self.LoopSound)
		self:NextThink( CurTime() + math.Rand( 0.75, 0.9 ) )
	end
	return true
end

function ENT:DoExplosionEffect()
	ParticleEffect("ww2_molotov_explosion", self:GetPos(), Angle(-90,0,0))
end

function ENT:Explode()
	if not self:GetNW2Bool("TriggerSphere", false) then
		--self:EmitSound(self.ShatterSound)
		self:EmitSound(self.ExplodeSound[math.random(#self.ExplodeSound)])
    	self:StopSound(self.LoopSound)
		self:SetNW2Bool("TriggerSphere", true)
		self:DoExplosionEffect()
	end
	
	if not IsValid(self.Inflictor) then
		self.Inflictor = self
	end
	
	SafeRemoveEntityDelayed(self,6) --removal of nade
end

--Below function credited to CmdrMatthew
function ENT:getvel(pos, pos2, time)    -- target, starting point, time to get there
    local diff = pos - pos2 --subtract the vectors
     
    local velx = diff.x/time -- x velocity
    local vely = diff.y/time -- y velocity
 
    local velz = (diff.z - 0.5*(-GetConVarNumber( "sv_gravity"))*(time^2))/time --  x = x0 + vt + 0.5at^2 conversion
     
    return Vector(velx, vely, velz)
end 
    
function ENT:LaunchArc(pos, pos2, time, t)  -- target, starting point, time to get there, fraction of jump
    local v = self:getvel(pos, pos2, time).z
    local a = (-GetConVarNumber( "sv_gravity"))
    local z = v*t + 0.5*a*t^2
    local diff = pos - pos2
    local x = diff.x*(t/time)
    local y = diff.y*(t/time)
    
    return pos2 + Vector(x, y, z)
end

function ENT:OnRemove()
    self:StopSound(self.LoopSound)
end