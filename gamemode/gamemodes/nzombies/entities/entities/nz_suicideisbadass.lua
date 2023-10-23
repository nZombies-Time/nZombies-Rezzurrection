ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Upset Gorod Bot"
ENT.Category		= "None"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false


ENT.MyModel = "models/nzr/enemies/sentinel/sentinel.mdl"
ENT.MyModelScale = 1
ENT.Damage = 50
ENT.Radius = 350
if SERVER then

	AddCSLuaFile()

	function ENT:Initialize()

		--local model = self.MyModel and self.MyModel or  "models/missiles/rpg_rocket_cod4rm.mdl"
		local model = self.MyModel and self.MyModel or  "models/nzr/enemies/sentinel/sentinel.mdl"
		self.Class = self:GetClass()
		
		self:SetModel(model)
		ParticleEffectAttach("rocket_smoke",PATTACH_ABSORIGIN_FOLLOW,self,0)
			self:SetSequence( "fly_suicide" )
		self:PhysicsInit(SOLID_OBB)
		self:SetSolid(SOLID_NONE)
		self:SetTrigger(true)
		self:SetAngles( Angle( 180,180,180 ))
		self:UseTriggerBounds(true, 0)
		self:SetMoveType(MOVETYPE_FLY)
		--self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		--self:SetSolid(SOLID_VPHYSICS)
		phys = self:GetPhysicsObject()
		if phys and phys:IsValid() then
			phys:Wake()
		end
		self:SetModelScale(self.MyModelScale,0)
		
		local phys = self:GetPhysicsObject()
		
		if (phys:IsValid()) then
			phys:Wake()
		end
	end
function ENT:Launch(dir)
	self:SetLocalVelocity(dir * 1250)
	self:SetAngles(((dir)):Angle())
	self.AutoReturnTime = CurTime() + 5
end

function ENT:OnContact(ent)
local panzer = self:GetParent()
if ent:IsPlayer() or ent:IsWorld() then
		self:EmitSound("ambient/explosions/explode_1.wav")
			local ent = ents.Create("env_explosion")
	ent:SetPos(self:GetPos())
	ent:SetAngles(self:GetAngles())
	ent:Spawn()
	ent:SetKeyValue("imagnitude", "40")
	ent:Fire("explode")
			self.ExplosionLight1 = ents.Create("light_dynamic")
		self.ExplosionLight1:SetKeyValue("brightness", "4")
		self.ExplosionLight1:SetKeyValue("distance", "1000")
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
	end
	
end

function ENT:StartTouch(ent)
local panzer = self:GetParent()
if ent:IsPlayer() or ent:IsWorld() then
		self:EmitSound("ambient/explosions/explode_1.wav")
			local ent = ents.Create("env_explosion")
	ent:SetPos(self:GetPos())
	ent:SetAngles(self:GetAngles())
	ent:Spawn()
	ent:SetKeyValue("imagnitude", "40")
	ent:Fire("explode")
			self.ExplosionLight1 = ents.Create("light_dynamic")
		self.ExplosionLight1:SetKeyValue("brightness", "4")
		self.ExplosionLight1:SetKeyValue("distance", "1000")
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
	end

if CLIENT then
	
	function ENT:Draw()
		self:DrawModel()
		ParticleEffectAttach("bo3_panzer_engine",PATTACH_POINT_FOLLOW,self,2)
			ParticleEffectAttach("bo3_panzer_engine",PATTACH_POINT_FOLLOW,self,3)
	end

end

function ENT:Return() -- Emptyhanded return - Grab is with player
	self.HasGrabbed = true

	local panzer = self:GetPanzer()
	if !IsValid(panzer) then self:Remove() return end

	self:SetMoveType(MOVETYPE_FLY)
	self:SetSolid(SOLID_NONE)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetNotSolid(true)
	self:SetCollisionBounds(Vector(0,0,0), Vector(0,0,0))
	
	local att = panzer:LookupAttachment("clawlight")
	local pos = att and panzer:GetAttachment(att).Pos or panzer:GetPos()
	self:SetLocalVelocity((pos - self:GetPos()):GetNormalized() * 1500)
end

function ENT:Release()
	if IsValid(self.GrabbedPlayer) then
		hook.Remove("SetupMove", "PanzerGrab"..self:EntIndex())
		
		if SERVER then
			net.Start("nz_panzer_grab")
				net.WriteBool(false)
				net.WriteEntity(self)
			net.Send(self.GrabbedPlayer)
			
			self:Return()
		end
	else
		if SERVER then
			net.Start("nz_panzer_grab")
				net.WriteBool(false)
				net.WriteEntity(self)
			net.Broadcast()
		end
	end
	self.GrabbedPlayer = nil
end