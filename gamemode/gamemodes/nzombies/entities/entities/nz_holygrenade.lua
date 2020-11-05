ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Frag Grenade"
ENT.Author = "Hidden"

ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
	AddCSLuaFile("nz_holygrenade.lua")
end

function ENT:Initialize()
	self.Entity:SetModel("models/freeman/holyhandgrenade.mdl")
	timer.Simple(0.0, function() 
		if self.WidowsWine then
			self:SetModel("models/weapons/w_bugbait.mdl")
		end
	end)
	
	if SERVER then
		util.SpriteTrail( self, 0, Color( 168, 168, 168 ), true, 6, 0, 0.4, 0.0078125, "cable/smoke.vmt" )
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
		self:SetSolid(SOLID_VPHYSICS)
		phys = self:GetPhysicsObject()

		if phys and IsValid(phys) then
			phys:SetMass(8)
			phys:Wake()
			phys:SetAngleDragCoefficient(1000)
			--print(phys:GetMass())
		end
		
		self:CollisionRulesChanged()
	end
end

function ENT:PhysicsCollide(data, physobj)
	if SERVER then
		if self.WidowsWine then
			physobj:SetVelocity(Vector(0,0,0))
			physobj:EnableMotion(false)
			physobj:Sleep()
			
			--self:SetAngles(data.HitNormal:Angle())
			
			if IsValid(data.HitEntity) then
				self:SetParent(data.HitEntity)
			end
		else
			if data.Speed > 50 then
				if self:WaterLevel() == 0 then
				self:EmitSound( "TFA_WW2_TYPE97.Bounce", 75, 100 )
				else
					self:EmitSound("player/footsteps/slosh"..math.random(1,4)..".wav", 75, 100)
				end
			end

			local LastSpeed = math.max( data.OurOldVelocity:Length(), data.Speed )
			local NewVelocity = physobj:GetVelocity()
			NewVelocity:Normalize()

			LastSpeed = math.max( NewVelocity:Length(), LastSpeed )

			local TargetVelocity = NewVelocity * LastSpeed * 0.75

			physobj:SetVelocity( TargetVelocity )
			--physobj:SetLocalAngularVelocity( AngleRand() )
		end
	end
end

function ENT:SetExplosionTimer( time )

	SafeRemoveEntityDelayed( self, time +1 ) --fallback

	timer.Simple(time, function()
		if IsValid(self) then
			local pos = self:GetPos()
			local owner = self:GetOwner()
			
			if self.WidowsWine then
				local zombls = ents.FindInSphere(pos, 350)
				
				local e = EffectData()
				e:SetMagnitude(1.5)
				e:SetScale(20) -- The time the effect lasts
				
				local fx = EffectData()
				fx:SetOrigin(pos)
				fx:SetMagnitude(1)
				util.Effect("web_explosion", fx)
				
				for k,v in pairs(zombls) do
					if IsValid(v) and v:IsValidZombie() then
						v:ApplyWebFreeze(20)
					end
				end
			else
			util.ScreenShake(self.Entity:GetPos(), 500, 800, 1.25, 500)
			     util.BlastDamage( self, owner, pos, 500, 1000 )
        self:EmitSound( "TFA_Geballteladung.Explode" )  
			end
			
			local fx = EffectData()
			fx:SetOrigin(pos)
			fx:SetMagnitude(1)
			if self:WaterLevel() >=1 then
				util.Effect("WaterSurfaceExplosion", fx)
			else
				local effectdata = EffectData()
		effectdata:SetOrigin(self.Entity:GetPos())
		effectdata:SetEntity(self.Entity)
		effectdata:SetStart(self.Entity:GetPos())
		effectdata:SetNormal(Vector(0,0,1))
		util.Effect("cball_explode", effectdata)
		util.Effect("Explosion", effectdata)
	local thumper = effectdata
		thumper:SetOrigin(self.Entity:GetPos())
		thumper:SetScale(1000)
		thumper:SetMagnitude(3000)
		util.Effect("ThumperDust", effectdata)
	local sparkeffect = effectdata
		sparkeffect:SetMagnitude(3)
		sparkeffect:SetRadius(8)
		sparkeffect:SetScale(5)
		util.Effect("Sparks", sparkeffect)
	local scorchstart = self.Entity:GetPos() + ((Vector(0,0,1)) * 5)
	local scorchend = self.Entity:GetPos() + ((Vector(0,0,-1)) * 5)
		util.Decal("Scorch", scorchstart, scorchend)
			end

			self:Remove()
		end
	end)
end

function ENT:Draw()
	self:DrawModel()
end
