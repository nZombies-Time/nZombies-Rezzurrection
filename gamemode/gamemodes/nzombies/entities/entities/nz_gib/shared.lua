AddCSLuaFile()

ENT.Base = "base_entity"
ENT.Type = "anim"
ENT.Author = "GhostlyMoo"
ENT.PrintName = "The old gib entity thats now a projectile the zombies throw at you."
ENT.Contact = "No fuck off"

local bloodMat = util.DecalMaterial("Blood")

function ENT:Initialize()
    if SERVER then
        self:SetModel("models/props_junk/watermelon01_chunk02a.mdl")
        self:SetMaterial("models/flesh")
        self:SetNoDraw(false)
        self:SetModelScale(2)
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_NONE)
        self:SetTrigger(true)
        self:UseTriggerBounds(true, 0)
        self:GetPhysicsObject():SetMaterial("bloodyflesh")

        local gibLife = 3
        if gibLife >= 0 then
            timer.Simple(gibLife,function()
                if IsValid(self) then
                    self:Remove()
                end
            end)
        end
        util.SpriteTrail(self, 0, Color(255, 0, 0, 100), false, 12, 0, 0.3, 1 / 40 * 0.3, "trails/plasma")
    end
end

function ENT:StartTouch(ent)
    local dmgInfo = DamageInfo()
    dmgInfo:SetAttacker(self)
    dmgInfo:SetDamage(45)
    dmgInfo:SetDamageType( DMG_DIRECT )
    dmgInfo:SetDamagePosition(self:GetPos())
    if ent:IsPlayer() and !ent:IsWorld() then
        self:EmitSound("physics/flesh/flesh_squishy_impact_hard"..math.random(1,4)..".wav")
        ent:EmitSound( "nz_moo/zombies/plr_impact/_zhd/evt_zombie_hit_player_0"..math.random(0,5)..".mp3", SNDLVL_TALKING, math.random(95,105))
        ent:TakeDamageInfo(dmgInfo)
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