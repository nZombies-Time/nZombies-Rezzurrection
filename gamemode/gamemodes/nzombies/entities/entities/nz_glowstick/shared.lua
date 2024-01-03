AddCSLuaFile()

ENT.Base = "base_entity"
ENT.Type = "anim"
ENT.Author = "GhostlyMoo"
ENT.PrintName = "GLOWSTICKS! Find them at your nearest Party-City."
ENT.Contact = "No fuck off"

function ENT:Initialize()
    if SERVER then
        self:SetModel("models/weapons/w_eq_fraggrenade.mdl")
        ParticleEffectAttach("bo3_panzer_elec_nade",PATTACH_ABSORIGIN_FOLLOW,self,0)
        self:SetNoDraw(false)
        self:SetModelScale(1.25)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetTrigger(true)
        self:UseTriggerBounds(true, 0)
        self:GetPhysicsObject():SetMaterial("bloodyflesh")

        local gibLife = 3
        if gibLife >= 0 then
            timer.Simple(gibLife,function()
                if IsValid(self) then
                    self:GoBOOM()
                end
            end)
        end
        util.SpriteTrail(self, 0, Color(255, 255, 255, 255), false, 25, 15, 0.5, 1 / 40 * 0.3, "trails/electric")
    end
end

function ENT:StartTouch(ent)
    if !ent:IsPlayer() and ent.IsMooZombie then return end
    self:GoBOOM()
end

function ENT:GoBOOM()

    local dmg = 90

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
                v:NZSonicBlind(2)
            end
        end

        local effectdata = EffectData()
        effectdata:SetOrigin(self:GetPos())

        util.Effect("Explosion", effectdata)
        util.ScreenShake(self:GetPos(), 20, 255, 0.5, 100)

        self:Remove()
    end
end

--Below function credited to CmdrMatthew
function ENT:getvel(pos, pos2, time)    -- target, starting point, time to get there
    local diff = pos - pos2 --subtract the vectors
     
    local velx = diff.x/time -- x velocity
    local vely = diff.y/time -- y velocity
 
    local velz = (diff.z - 0.5*(-GetConVarNumber( "sv_gravity"))*(time^2))/time --  x = x0 + vt + 0.5at^2 conversion
     
    return Vector(velx, vely, velz)
end 
    
function ENT:LaunchArc(pos, pos2, time, t)  -- target, starting point, time to get there, fraction of jump
    local v = self:getvel(pos, pos2, time).z
    local a = (-GetConVarNumber( "sv_gravity"))
    local z = v*t + 0.5*a*t^2
    local diff = pos - pos2
    local x = diff.x*(t/time)
    local y = diff.y*(t/time)
    
    return pos2 + Vector(x, y, z)
end

function ENT:Draw()
    if CLIENT then
        self:DrawModel()
    end
end