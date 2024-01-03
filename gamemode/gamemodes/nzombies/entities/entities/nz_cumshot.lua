ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Spider Goo"
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
		ParticleEffectAttach("bo3_spider_projectile",PATTACH_ABSORIGIN_FOLLOW,self,0)
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
	self:SetLocalVelocity(dir * 1750)
	self:SetAngles((dir*-1):Angle())
end

function ENT:StartTouch(ent)
	if (!ent.IsMooZombie or ent.IsMooSpecial) and !ent:IsWorld() then return end

    if SERVER then
        local pos = self:WorldSpaceCenter()

        local tr = {
            start = pos,
            filter = self,
            mask = MASK_NPCSOLID_BRUSHONLY
        }

        for k, v in pairs(ents.FindInSphere(pos, 225)) do
            local expdamage = DamageInfo()
            expdamage:SetDamageType(DMG_POISON)

            expdamage:SetAttacker(self)
            expdamage:SetDamage(0)
            expdamage:SetDamageForce(v:GetUp()*5000 + (v:GetPos() - self:GetPos()):GetNormalized() * 10000)
			
			if v:IsPlayer() then
                v:TakeDamageInfo(expdamage)
				v:NZSonicBlind(2)--if this has the beep then change to
				--v:SetRunSpeed(50)
				--timer to reset to normal speed
				--mildy odious but tinnitus bad
            end

        end
--need more gross sound effect lol
		self:EmitSound("roach/bo3/spider/spd_attack_0"..math.random(3)..".mp3")
ParticleEffectAttach("bo3_spider_impact",PATTACH_ABSORIGIN,self,0)
        util.ScreenShake(self:GetPos(), 20, 255, 0.5, 100)

		self:Remove()
	end
end


function ENT:Think()
end

function ENT:OnRemove()
end
