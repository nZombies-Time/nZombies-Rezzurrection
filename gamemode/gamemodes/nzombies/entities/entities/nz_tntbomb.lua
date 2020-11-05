ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "TNT"
ENT.Author = "Zet0r"

ENT.Spawnable = false
ENT.AdminSpawnable = false

ENT.ExplosionSounds = {
	"nz/monkey/voice_explosion/explo_vox_00.wav",
	"nz/monkey/voice_explosion/explo_vox_01.wav",
	"nz/monkey/voice_explosion/explo_vox_02.wav",
	"nz/monkey/voice_explosion/explo_vox_03.wav",
	"nz/monkey/voice_explosion/explo_vox_04.wav",
	"nz/monkey/voice_explosion/explo_vox_05.wav",
	"nz/monkey/voice_explosion/explo_vox_06.wav",
	"nz/monkey/voice_explosion/explo_vox_07.wav",
	"nz/monkey/voice_explosion/explo_vox_08.wav",
	"nz/monkey/voice_explosion/explo_vox_09.wav",
	"nz/monkey/voice_explosion/explo_vox_10.wav",
	"nz/monkey/voice_explosion/explo_vox_11.wav",
}

if SERVER then
	AddCSLuaFile()
end

function ENT:Initialize()
	if SERVER then
		self:SetModel( "models/weapons/w_compb_allied.mdl" )
		self:PhysicsInitSphere(1, "metal_bouncy")
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_NONE)
		self:SetSolid(SOLID_VPHYSICS)
		phys = self:GetPhysicsObject()

		if phys and phys:IsValid() then
			phys:Wake()
		end
	end
end


function ENT:PhysicsCollide(data, physobj)
	if SERVER then
			self:SetMoveType(MOVETYPE_NONE)
			self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			self:SetExplosionTimer(4)
			physobj:SetVelocity(Vector(0,0,0) )
	end
end

function ENT:SetExplosionTimer( time )

	SafeRemoveEntityDelayed( self, time +1 ) --fallback

	timer.Simple(time - 1.5, function()
		if IsValid(self) then
			self:EmitSound( "Weapon_compositonB.Explode" )  
		end
	end)
	
	timer.Simple(time, function()
		if IsValid(self) then
			local pos = self:GetPos()
			local owner = self:GetOwner()

			util.BlastDamage(self, owner, pos, 400, 200)

			fx = EffectData()
			fx:SetOrigin(pos)
			fx:SetMagnitude(1)
			util.Effect("Explosion", fx)

			self:Remove()
		end
	end)
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:Think()
	
end