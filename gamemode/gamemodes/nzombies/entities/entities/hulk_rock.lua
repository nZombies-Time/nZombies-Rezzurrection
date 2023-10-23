ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Hulk Rock that it throws"
ENT.Author = "Wavy"

ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
	AddCSLuaFile()
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:Initialize()
	if SERVER then
		self:EmitSound("wavy_zombie/hulk/thrown_missile_loop_1.wav")
		self:SetModel("models/props_debris/concrete_chunk01a.mdl")
		self:SetMoveType(MOVETYPE_VPHYSICS)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
		self:SetTrigger(true)
		self:UseTriggerBounds(true, 0)
		self:SetHealth( 150 )
		self:SetMaxHealth( 150 )

		phys = self:GetPhysicsObject()

		if phys and phys:IsValid() then
			phys:AddAngleVelocity(Vector(math.random(-300,-50),math.random(-50,-300),math.random(-50,-300)))
			phys:Wake()
			phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
		end
	end
end

function ENT:OnTakeDamage(dmginfo)
	local attacker = dmginfo:GetAttacker()
	if not IsValid(attacker) then return end
	
	self:SetHealth(self:Health() - dmginfo:GetDamage())
	
	if self:Health() <= 0 then
	if attacker:IsPlayer() and TFA.BO3GiveAchievement then
		if not attacker.ROCKY_HORROR_PICTURE_THROW then
			TFA.BO3GiveAchievement("ROCKY PICTURE THROW", "vgui/Achievement_Rocky_Horror_Picture_Throw.png", attacker)
		attacker.ROCKY_HORROR_PICTURE_THROW = true
		end
	end
	self:Explode(self:GetPos())
	self:Remove()
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
	if not ent:IsSolid() then return end
	if ent.IsMooZombie then return end

	self.Impacted = true
	self:Explode(self:GetPos())
	self:Remove()
end

function ENT:Explode(pos)

    if SERVER then
        local pos = self:WorldSpaceCenter()

        local tr = {
            start = pos,
            filter = self,
            mask = MASK_NPCSOLID_BRUSHONLY
        }

        for k, v in pairs(ents.FindInSphere(pos, 75)) do
            local expdamage = DamageInfo()
            expdamage:SetDamageType(DMG_CRUSH)
            expdamage:SetAttacker(self)
            expdamage:SetDamage(95)
            expdamage:SetDamageForce(v:GetUp()*5000 + (v:GetPos() - self:GetPos()):GetNormalized() * 10000)

            if v:IsPlayer() then
                v:TakeDamageInfo(expdamage)
				v:NZSonicBlind(2)
            end
        end

		ParticleEffect("tank_rock_throw_impact",self:GetPos(),Angle(0,0,0),nil)
        util.ScreenShake(self:GetPos(), 20, 255, 0.5, 300)
		self:EmitSound("wavy_zombie/hulk/thrown_projectile_hit_01.wav", 511)

		self:Remove()
	end
end


function ENT:Think()
end

function ENT:OnRemove()
	self:StopSound("wavy_zombie/hulk/thrown_missile_loop_1.wav")
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