ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Rocket_RPG7"
ENT.Category		= "None"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false


ENT.MyModel = "models/gears-of-war/weapons/locust/locust_boomshot_ammo2.mdl"
ENT.MyModelScale = 1
ENT.Damage = 75
ENT.Radius = 350
if SERVER then

	AddCSLuaFile()

	function ENT:Initialize()

		local model = self.MyModel and self.MyModel or  "models/gears-of-war/weapons/locust/locust_boomshot_ammo2.mdl"
		self.Class = self:GetClass()
		
		self:SetModel(model)
		ParticleEffectAttach("obj_gearsofwar_boomshot_projectile_tracer", PATTACH_ABSORIGIN_FOLLOW, self, 0)
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
	self:SetLocalVelocity(dir * 1500)
	self:SetAngles(((dir)):Angle())
	self.AutoReturnTime = CurTime() + 5
end

function ENT:StartTouch(ent)
local panzer = self:GetParent()
	local tr = {
            	start = pos,
            	filter = self,
            	mask = MASK_NPCSOLID_BRUSHONLY
        	}
if ent:IsPlayer() or ent:IsWorld() then
ParticleEffect("obj_gearsofwar_boomshot_projectile_explosion", self:GetPos(), Angle(0,0,0), nil)
self:EmitSound("enemies/bosses/boomer/explosion"..math.random(1,5)..".ogg",80,math.random(95,100))
		for k, v in pairs(ents.FindInSphere(self:GetPos(), 300)) do
            	if v:IsPlayer() or v:IsNPC() or v:IsNextBot() then
                	if v == self then continue end
                	if v:EntIndex() == self:EntIndex() then continue end
                	if v:Health() <= 0 then continue end
                	if !v:Alive() then continue end
                	tr.endpos = v:WorldSpaceCenter()
                	local tr1 = util.traceline(tr)
                	if tr1.HitWorld then continue end

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