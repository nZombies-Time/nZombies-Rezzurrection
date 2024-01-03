ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "WW2 Bomber zombie bomb"
ENT.Author = "Your mom"
ENT.Health = 100
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.markedExplode = false

if SERVER then
	AddCSLuaFile()
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()
    end
end

function ENT:Initialize()
	self:SetModel( "models/moo/_codz_ports/s2/zombie/moo_codz_s2_bmb_bomb.mdl" )
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
    --self:GetPhysicsObject():SetMaterial("metal")

    --self:EmitSound("physics/metal/metal_box_impact_bullet"..math.random(1,3)..".wav",100,math.random(95, 105))
    self.RemoveTime = 0
    self.Dropped = false
end

function ENT:OnTakeDamage( dmginfo )
	if self.markedExplode == false then
		self.markedExplode = true

        suicide = suicide or true
        local dmg = 175

        local attacker = dmginfo:GetAttacker()
        local inflictor = dmginfo:GetInflictor()

        if SERVER then
            local pos = self:WorldSpaceCenter()

            local tr = {
                start = pos,
                filter = self,
                mask = MASK_NPCSOLID_BRUSHONLY
            }

            for k, v in pairs(ents.FindInSphere(pos, 200)) do
                if v:IsNPC() or v:IsNextBot() then
                    if v:GetClass() == self:GetClass() then continue end
                    if v == self then continue end
                    if v:Health() <= 0 then continue end
                    if v.NZBossType then continue end
                    if v.IsMooBossZombie then continue end
                    tr.endpos = v:WorldSpaceCenter()
                    local tr1 = util.TraceLine(tr)
                    if tr1.HitWorld then continue end

                    local zexpdamage = DamageInfo()
                    zexpdamage:SetAttacker(attacker)
                    zexpdamage:SetInflictor(inflictor)
                    zexpdamage:SetDamageType(DMG_BLAST)
                    zexpdamage:SetDamage(10000)
                    zexpdamage:SetDamageForce(v:GetUp()*5000 + (v:GetPos() - self:GetPos()):GetNormalized() * 10000)

                    if v:IsNPC() or v:IsNextBot() then
                        v:TakeDamageInfo(zexpdamage)
                    end
                else
                    local expdamage = DamageInfo()
                    expdamage:SetAttacker(attacker)
                    expdamage:SetInflictor(inflictor)
                    expdamage:SetDamageType(DMG_GENERIC)

                    local distfac = pos:Distance(v:WorldSpaceCenter())
                    distfac = 1 - math.Clamp((distfac/200), 0, 1)
                    expdamage:SetDamage(dmg * distfac)

                    expdamage:SetDamageForce(v:GetUp()*5000 + (v:GetPos() - self:GetPos()):GetNormalized() * 10000)

                    if v:IsPlayer() then
                        v:TakeDamageInfo(expdamage)
                    end
                end
            end

            local effectdata = EffectData()
            effectdata:SetOrigin(self:GetPos())

            util.Effect("HelicopterMegaBomb", effectdata)
            util.Effect("Explosion", effectdata)

            util.ScreenShake(self:GetPos(), 20, 255, 1.5, 400)

            self:Remove()
        end
	end
end

function ENT:PhysicsCollide(data, physobj) end

function ENT:StartSelfDestruct()
    self.RemoveTime = CurTime() + 30
    self.Dropped = true
end

function ENT:Think() 
    if CurTime() > self.RemoveTime and self.Dropped then
        self:TakeDamage(100, self, self)
    end
end
