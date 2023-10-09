ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Rocket_RPG7"
ENT.Category		= "None"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false


ENT.MyModel = "models/weapons/gunkshot/s_imlusion_ball.mdl"
ENT.MyModelScale = 1
ENT.Damage = 75
ENT.Radius = 350
if SERVER then

	AddCSLuaFile()

	function ENT:Initialize()

		local model = self.MyModel and self.MyModel or "models/weapons/gunkshot/s_imlusion_ball.mdl"
		self.Class = self:GetClass()
		
		self:SetModel(model)
		 ParticleEffectAttach("obj_gearsofwar_gunk_tracer", PATTACH_ABSORIGIN_FOLLOW, self, 0)
			--self:SetSequence( "fly_suicide" )
		self:PhysicsInit(SOLID_OBB)
		self:SetSolid(SOLID_NONE)
		self:SetTrigger(true)
		self:SetAngles( Angle( 0,0,0 ))
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
	self:SetLocalVelocity(dir * 500)
	self:SetAngles(((dir)):Angle())
	self.AutoReturnTime = CurTime() + 5
end

function ENT:StartTouch(ent)
local panzer = self:GetParent()

if ent:IsPlayer() or ent:IsWorld() then
ParticleEffect("obj_gearsofwar_gunk_explosion", self:GetPos(), Angle(0,0,0), nil)
self:EmitSound("enemies/bosses/gunker/impact"..math.random(1,3)..".ogg",80,math.random(95,100))
		for k, v in pairs(ents.FindInSphere(self:GetPos(), 300)) do
            	if v:IsPlayer() or v:IsNPC() or v:IsNextBot() then
                	if v == self then continue end
                	if v:EntIndex() == self:EntIndex() then continue end
                	if v:Health() <= 0 then continue end
                	if !v:Alive() then continue end
                	

                	local expdamage = DamageInfo()
                	expdamage:SetAttacker(self)
                	expdamage:SetInflictor(self)
                	expdamage:SetDamageType(DMG_SLASH)

                	expdamage:SetDamage(125)

                	expdamage:SetDamageForce(v:GetUp()*5000 + (v:GetPos() - self:GetPos()):GetNormalized() * 10000)

                	v:TakeDamageInfo(expdamage)
            	end
        	end
			self:Remove()
		end
	end
	
end

if CLIENT then
	
	function ENT:Draw()
		self:DrawModel()
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