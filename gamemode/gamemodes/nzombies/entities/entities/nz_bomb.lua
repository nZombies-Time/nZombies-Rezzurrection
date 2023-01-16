ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "WW2 Bomber zombie bomb"
ENT.Author = "Zet0r"
ENT.Health = 100
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.markedExplode = false

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
		self:SetModel( "models/roach/codz_megapack/ww2/bmb_bomb.mdl" )
		self:PhysicsInitSphere(1, "metal_bouncy")
		--self:SetCollisionBounds(Vector(20,20, 0), Vector(20, 20, 30))
		self:SetAngles( Angle(0, 0, 90))
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
	end
end

function ENT:OnTakeDamage( dmginfo )
print("bro")
if self.markedExplode == false then
self.markedExplode = true
self:EXUPLOSION()
end
end

function ENT:PhysicsCollide(data, physobj)
	if SERVER then
			self:SetMoveType(MOVETYPE_NONE)
			self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			--self:SetExplosionTimer(4)
			physobj:SetVelocity(Vector(0,0,0) )
	end
end


function ENT:EXUPLOSION()
		local ent = ents.Create("env_explosion")
	ent:SetPos(self:GetPos())
	ent:SetAngles(self:GetAngles())
	ent:Spawn()
	ent:SetKeyValue("imagnitude", "88")
	ent:Fire("explode")
		
			self.ExplosionLight1 = ents.Create("light_dynamic")
		self.ExplosionLight1:SetKeyValue("brightness", "4")
		self.ExplosionLight1:SetKeyValue("distance", "300")
		self.ExplosionLight1:SetLocalPos(self:GetPos())
		self.ExplosionLight1:SetLocalAngles(self:GetAngles())
		self.ExplosionLight1:Fire("Color", "255 150 0")
		self.ExplosionLight1:SetParent(self)
		self.ExplosionLight1:Spawn()
		self.ExplosionLight1:Activate()
		self.ExplosionLight1:Fire("TurnOn", "", 0)
		self:DeleteOnRemove(self.ExplosionLight1)
		
		SafeRemoveEntityDelayed(self,0.1)
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:Think()
	
end