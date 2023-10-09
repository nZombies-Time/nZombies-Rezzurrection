ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Xenomorph Spitter Projectile"
ENT.Author = "Wavy"

ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
	AddCSLuaFile()
end

function ENT:Draw()
end

function ENT:Initialize()
	if SERVER then
		self:EmitSound("character/alien/vocals/spitter/spitter_acid_loop_02.wav")
		self:SetModel("models/dav0r/hoverball.mdl")
		ParticleEffectAttach("bo3_mirg2k_trail",PATTACH_ABSORIGIN_FOLLOW,self,0)
		ParticleEffectAttach("bo3_mirg2k_muzzleflash",PATTACH_ABSORIGIN,self,0)
		self:SetNoDraw( true )
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		self:SetTrigger(true)
		self:UseTriggerBounds(true, 0)

		phys = self:GetPhysicsObject()

		if phys and phys:IsValid() then
			phys:Wake()
			phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
		end
	end
end

function ENT:PhysicsCollide(data, phys)
	if self.Impacted then return end
	self.Impacted = true

	self:Explode(self:GetPos())
	self:Remove()
end

function ENT:StartTouch(ent)
	if self.Impacted then return end
	if ent == self:GetOwner() then return end
	if ent:Health() <= 0 then return end
	if !ent:IsSolid() then return end
	if ent:IsNPC() then return end
	if ent:IsNextBot() then return end
	if ent:IsPlayer() then return end
	

	self.Impacted = true
	self:Explode(self:GetPos())
	self:Remove()
end

function ENT:Explode(pos)
	if SERVER then
    --local pos = self:WorldSpaceCenter()
	local vaporizer = ents.Create("point_hurt")
	local gfx = ents.Create("pfx2_03")
		ParticleEffectAttach("bo3_sliquifier_puddle_2", PATTACH_ABSORIGIN_FOLLOW, gfx, 0)
        gfx:SetPos(self:GetPos() + (Vector(0,0,1)))
        gfx:SetAngles(Angle(0,0,0))
		gfx:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        gfx:Spawn()
		if !vaporizer:IsValid() then return end
		vaporizer:SetKeyValue("Damage", 20)
		vaporizer:SetKeyValue("DamageRadius", 130)
		vaporizer:SetKeyValue("DamageDelay",0.35)
		vaporizer:SetKeyValue("DamageType", DMG_ACID)
		--vaporizer:SetKeyValue("DamageTarget", "player")
		vaporizer:SetPos(self:GetPos())
		vaporizer:SetOwner(self)
		vaporizer:Spawn()
		vaporizer:Fire("TurnOn","",0)
		vaporizer:Fire("kill","",10)
		timer.Simple(10, function()
		gfx:Remove()
		end)

	ParticleEffect("bo3_mirg2k_impact",self:GetPos(),Angle(0,0,0),nil)
	self:EmitSound("character/alien/vocals/spitter/spitter_miss_01.wav", 500)

	self:Remove()
	end
end


function ENT:Think()
end

function ENT:OnRemove()
	self:StopSound("character/alien/vocals/spitter/spitter_acid_loop_02.wav")
end

function ENT:getvel(pos, pos2, time)	-- target, starting point, time to get there
    	local diff = pos - pos2 --subtract the vectors
     
    	local velx = diff.x/time -- x velocity
    	local vely = diff.y/time -- y velocity
 
    	local velz = (diff.z - 0.5*(-GetConVarNumber( "sv_gravity"))*(time^2))/time --  x = x0 + vt + 0.5at^2 conversion
     
    	return Vector(velx, vely, velz)
end	
	
function ENT:LaunchArc(pos, pos2, time, t)	-- target, starting point, time to get there, fraction of jump
		local v = self:getvel(pos, pos2, time).z
		local a = (-GetConVarNumber( "sv_gravity"))
		local z = v*t + 0.5*a*t^2
		local diff = pos - pos2
		local x = diff.x*(t/time)
    	local y = diff.y*(t/time)
	
		return pos2 + Vector(x, y, z)
end