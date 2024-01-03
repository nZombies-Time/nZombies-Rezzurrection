ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Mangler Shot"
ENT.Author = "Zet0r"

ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
	AddCSLuaFile()
	util.AddNetworkString("nz_panzer_grab")
end

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Panzer")
end

function ENT:Initialize()
	if SERVER then

		self:SetModel("models/weapons/w_eq_fraggrenade.mdl") -- Change later
		self:SetNoDraw(true)
		ParticleEffectAttach("bo3_spider_projectile",PATTACH_ABSORIGIN_FOLLOW,self,0)
		self:PhysicsInit(SOLID_OBB)
		self:SetSolid(SOLID_NONE)
		self:SetTrigger(true)
		self:UseTriggerBounds(true, 0)
		self:SetMoveType(MOVETYPE_FLY)
		--self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		--self:SetSolid(SOLID_VPHYSICS)
		phys = self:GetPhysicsObject()

		if phys and phys:IsValid() then
			phys:Wake()
		end
	end
end

function ENT:Launch(dir)
	self:SetLocalVelocity(dir * 1000)
	self:SetAngles((dir*-1):Angle())
	
	self.AutoReturnTime = CurTime() + 5
end

function ENT:Grab(ply, pos) -- Pos is used for clients who may not have the Panzer valid yet
local panzer = self:GetParent()
if ent:IsPlayer() or ent:IsWorld() then
self:EmitSound("roach/bo3/spider/spd_attack_0"..math.random(3)..".mp3")
ParticleEffectAttach("bo3_spider_impact",PATTACH_ABSORIGIN,self,0)
			local ent = ents.Create("env_explosion")
	ent:SetPos(self:GetPos())
	ent:SetAngles(self:GetAngles())
	ent:Spawn()
	ent:SetKeyValue("imagnitude", "15")
	ent:Fire("explode")
		
			self.ExplosionLight1 = ents.Create("light_dynamic")
		self.ExplosionLight1:SetKeyValue("brightness", "4")
		self.ExplosionLight1:SetKeyValue("distance", "100")
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

if CLIENT then
	net.Receive("nz_panzer_grab", function()
		local grab = net.ReadBool()
		local ent = net.ReadEntity()
		local pos
		if grab then pos = net.ReadVector() end
		
		if IsValid(ent) then
			if grab then
				ent:Grab(LocalPlayer(), pos)
			else
				if IsValid(ent) then ent:Release() end
			end
		end
	end)
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

function ENT:Reattach(removed)
	if !removed then self:Remove() end
	
	local panzer = self:GetPanzer()
	if !IsValid(panzer) then return end
	
	panzer:GrabPlayer(self.GrabbedPlayer)
end

function ENT:OnContact(ent)

local panzer = self:GetParent()
if ent:IsPlayer() or ent:IsWorld() then
		self:EmitSound("roach/bo3/spider/spd_attack_0"..math.random(3)..".mp3")
		ParticleEffectAttach("bo3_spider_impact",PATTACH_ABSORIGIN,self,0)
			local ent = ents.Create("env_explosion")
	ent:SetPos(self:GetPos())
	ent:SetAngles(self:GetAngles())
	ent:Spawn()
	ent:SetKeyValue("imagnitude", "15")
	ent:Fire("explode")
		
			self.ExplosionLight1 = ents.Create("light_dynamic")
		self.ExplosionLight1:SetKeyValue("brightness", "4")
		self.ExplosionLight1:SetKeyValue("distance", "100")
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
	
function ENT:StartTouch(ent)
local panzer = self:GetParent()
if ent:IsPlayer() or ent:IsWorld() then
self:EmitSound("roach/bo3/spider/spd_attack_0"..math.random(3)..".mp3")
		ParticleEffectAttach("bo3_spider_impact",PATTACH_ABSORIGIN,self,0)
			local ent = ents.Create("env_explosion")
	ent:SetPos(self:GetPos())
	ent:SetAngles(self:GetAngles())
	ent:Spawn()
	ent:SetKeyValue("imagnitude", "15")
	ent:Fire("explode")
		
			self.ExplosionLight1 = ents.Create("light_dynamic")
		self.ExplosionLight1:SetKeyValue("brightness", "4")
		self.ExplosionLight1:SetKeyValue("distance", "100")
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
	
end


function ENT:Think()
	
end

function ENT:OnRemove()
	self:Release()
	self:Reattach(true)
end
