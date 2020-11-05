ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Frag Grenade2"
ENT.Author = "Hidden"

ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
	AddCSLuaFile("nz_grenaderpg_thrown.lua")
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:Initialize()
	self:SetModel( "models/weapons/w_nam_rgd5.mdl" )
	
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
		if data.Speed > 50 then
			if self:WaterLevel() == 0 then
				self:EmitSound("nz/m67/bounce_"..math.random(0,4)..".wav", 75, 100)
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

function ENT:SetExplosionTimer( time )

	SafeRemoveEntityDelayed( self, time +1 ) --fallback

	timer.Simple(time, function()
		if IsValid(self) then
			local pos = self:GetPos()
			local owner = self:GetOwner()
			
			util.BlastDamage(self, owner, pos, 350, 80)
			
			local fx = EffectData()
			fx:SetOrigin(pos)
			fx:SetMagnitude(1)
			if self:WaterLevel() >=1 then
				util.Effect("WaterSurfaceExplosion", fx)
			else
				util.Effect("Explosion", fx)
			end

			self:Remove()
		end
	end)
end


