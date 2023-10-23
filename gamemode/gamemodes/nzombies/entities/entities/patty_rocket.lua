ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Patriarch Rocket"
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
		self:EmitSound("fx/missile_nozzle_lp.wav")
		self:SetModel("models/wavy/wavy_enemies/patriarch/kfpatriarchrocket.mdl") -- Change later
		ParticleEffectAttach("bo3_rockettrail",PATTACH_ABSORIGIN_FOLLOW,self,0)
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
		self:SetTrigger(true)
		self:UseTriggerBounds(true, 0)
		self:SetMoveType(MOVETYPE_FLY)

		phys = self:GetPhysicsObject()

		if phys and phys:IsValid() then
			phys:AddGameFlag(FVPHYSICS_NO_IMPACT_DMG)
			phys:Wake()
			--print(self:GetPhysicsObject())
		end
	end
end

function ENT:Launch(dir)
	self:SetLocalVelocity(dir * 2000)
	self:SetAngles((dir*-1):Angle())
end

function ENT:StartTouch(ent)
	if !ent:IsPlayer() and ent.IsMooZombie then return end

    if SERVER then
		local util_traceline = util.TraceLine
        local pos = self:WorldSpaceCenter()

        local tr = {
            start = pos,
            filter = self,
            mask = MASK_NPCSOLID_BRUSHONLY
        }

        for k, v in pairs(ents.FindInSphere(pos, 80)) do
            tr.endpos = v:WorldSpaceCenter()
            local tr1 = util_traceline(tr)
            if tr1.HitWorld then continue end
				
            local expdamage = DamageInfo()
            expdamage:SetDamageType(DMG_BLAST)
            expdamage:SetAttacker(self)
            expdamage:SetDamage(100)
            expdamage:SetDamageForce(v:GetUp()*5000 + (v:GetPos() - self:GetPos()):GetNormalized() * 10000)

            if v:IsPlayer() then
                v:TakeDamageInfo(expdamage)
            end
        end

		ParticleEffect("grenade_explosion_01",self:GetPos(),Angle(0,0,0),nil)
        util.ScreenShake(self:GetPos(), 20, 255, 0.5, 200)
		self:EmitSound("fx/explode"..math.random(7,9)..".wav", 400)

		self:Remove()
	end
end


function ENT:Think()
end

function ENT:OnRemove()
	self:StopSound("fx/missile_nozzle_lp.wav")
end
