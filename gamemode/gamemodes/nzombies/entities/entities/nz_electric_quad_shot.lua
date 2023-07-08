ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Jolting Jack Shot"
ENT.Author = "GhostlyMoo"

ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
	AddCSLuaFile()
end

function ENT:Initialize()
	if SERVER then
		self:SetModel("models/weapons/w_eq_fraggrenade.mdl") -- Change later
		self:SetNoDraw(true)
		ParticleEffectAttach("bo3_mangler_pulse",PATTACH_ABSORIGIN_FOLLOW,self,0)
		ParticleEffectAttach("bo3_mangler_blast",PATTACH_ABSORIGIN,self,0)
		self:PhysicsInit(SOLID_OBB)
		self:SetSolid(SOLID_NONE)
		self:SetTrigger(true)
		self:UseTriggerBounds(true, 0)
		self:SetMoveType(MOVETYPE_FLY)

		phys = self:GetPhysicsObject()

		if phys and phys:IsValid() then
			phys:Wake()
		end
	end
end

function ENT:Launch(dir)
	self:SetLocalVelocity(dir * 1250)
	self:SetAngles((dir*-1):Angle())
end

function ENT:StartTouch(ent)
	if !ent:IsPlayer() and ent.IsMooZombie then return end

    local dmg = 50

    if SERVER then
        local pos = self:WorldSpaceCenter()

        local tr = {
            start = pos,
            filter = self,
            mask = MASK_NPCSOLID_BRUSHONLY
        }

        for k, v in pairs(ents.FindInSphere(pos, 50)) do
            local expdamage = DamageInfo()
            expdamage:SetDamageType(DMG_SHOCK)

            local distfac = pos:Distance(v:WorldSpaceCenter())
            distfac = 1 - math.Clamp((distfac/50), 0, 1)

            expdamage:SetAttacker(self)
            expdamage:SetDamage(dmg * distfac)
            expdamage:SetDamageForce(v:GetUp()*5000 + (v:GetPos() - self:GetPos()):GetNormalized() * 10000)

            if v:IsPlayer() then
                v:TakeDamageInfo(expdamage)
				v:NZSonicBlind(1.5)
            end
        end

        local effectdata = EffectData()
        effectdata:SetOrigin(self:GetPos())

        util.Effect("Explosion", effectdata)
        util.ScreenShake(self:GetPos(), 20, 255, 0.5, 100)

		self:Remove()
	end
end


function ENT:Think()
end

function ENT:OnRemove()
end
