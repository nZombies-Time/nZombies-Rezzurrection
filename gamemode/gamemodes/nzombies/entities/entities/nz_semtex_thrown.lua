ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Semtex"
ENT.Author = "Hidden"

ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
	AddCSLuaFile("nz_semtex_thrown.lua")
end

function ENT:Initialize()
	self:SetModel("models/weapons/m67/w_bo2_semtex.mdl")
	
	if SERVER then
		util.SpriteTrail( self, 0, Color( 0, 168, 0 ), true, 16, 0, 0.6, 0.0078125, "trails/laser.vmt" )
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_PROJECTILE)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetSolidFlags(FSOLID_NOT_STANDABLE)
		phys = self:GetPhysicsObject()

		if phys and IsValid(phys) then
			phys:SetMass(8)
			phys:Wake()
			phys:SetAngleDragCoefficient(1000)
			--print(phys:GetMass())
		end
		
		self:CollisionRulesChanged()
		self:SetTrigger(true)
		self:EmitSound("nz/m67/semtex_alert.mp3")
		timer.Create(self:EntIndex().."semtex_beep", 0.25, 5, function()
			self:EmitSound("nz/m67/semtex_alert.mp3")
		end)
		timer.Simple(0.8, function() 
			if IsValid(self) then
				timer.Adjust(self:EntIndex().."semtex_beep", 0.1, 11, function()
					self:EmitSound("nz/m67/semtex_alert.mp3")
				end)
			end
		end)
	end
end

function ENT:StartTouch(ent)
	if not (ent:IsNPC() or ent:IsNextBot()) then return end
	self:OnCollide(ent, self:GetPos())
end

function ENT:PhysicsCollide(data)
	self:OnCollide(data.HitEntity, data.HitPos)
end

function ENT:OnCollide(ent, pos)
	local physobj = self:GetPhysicsObject()
	physobj:SetVelocity(Vector(0,0,0))
	--physobj:EnableMotion(false)
	physobj:Sleep()
	self:SetMoveType(MOVETYPE_NONE)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetTrigger(false)
		
	--self:SetAngles(data.HitNormal:Angle())
	
	if IsValid(ent) then
		self:SetPos(pos)
		self:SetParent(ent)
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
				util.BlastDamage(self, owner, pos, 350, 80)
			end
			
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

function ENT:OnRemove()
	timer.Remove(self:EntIndex().."semtex_beep")
end

function ENT:Draw()
	self:DrawModel()
	--render.SetMaterial(Material("particle/animglow02"))
	--render.DrawSprite( self:GetPos(), 4, 4, Color( 0, 255, 0 ) )
end
