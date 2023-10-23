ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "UndeadSS Skull Projectile"
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
		self:SetModel("models/gibs/hgibs.mdl") -- Change later
		ParticleEffectAttach("doom_imp_fireball",PATTACH_ABSORIGIN_FOLLOW,self,0)
		ParticleEffectAttach("doom_mancu_blast",PATTACH_ABSORIGIN,self,0)
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
	self:SetLocalVelocity(dir * 1500)
	self:SetAngles((dir*-1):Angle())
end

function ENT:StartTouch(ent)
	if !ent:IsPlayer() and ent.IsMooZombie then return end

    if SERVER then
        local pos = self:WorldSpaceCenter()

        local tr = {
            start = pos,
            filter = self,
            mask = MASK_NPCSOLID_BRUSHONLY
        }

        for k, v in pairs(ents.FindInSphere(pos, 50)) do
            local expdamage = DamageInfo()
            expdamage:SetDamageType(DMG_BLAST)
            expdamage:SetAttacker(self)
            expdamage:SetDamage(75)
            expdamage:SetDamageForce(v:GetUp()*5000 + (v:GetPos() - self:GetPos()):GetNormalized() * 10000)

            if v:IsPlayer() then
                v:TakeDamageInfo(expdamage)
				v:NZSonicBlind(1)
				v:Ignite(3)
            end
        end

		ParticleEffect("doom_caco_blast",self:GetPos(),Angle(0,0,0),nil)
        util.ScreenShake(self:GetPos(), 20, 255, 0.5, 100)
		self:EmitSound("fx/explode"..math.random(7,9)..".wav", 400)

		self:Remove()
	end
end


function ENT:Think()
end

function ENT:OnRemove()
	self:StopSound("fx/missile_nozzle_lp.wav")
end
