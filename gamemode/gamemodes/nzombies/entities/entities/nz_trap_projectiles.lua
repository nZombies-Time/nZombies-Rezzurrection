-- New trap made by Ethorbit, using the trap template code 

-- It is up to the developers to make sure the projectile entity they provide know how to:
    -- A: Remove themselves
    -- B: Not cause lua errors under common conditions (if for example the owner isn't a player)
    -- C: Function correctly when created under unusual circumstances (THIS)

AddCSLuaFile( )

-- Register teh trap
nzTraps:Register("nz_trap_projectiles")

ENT.Author = "Ethorbit"
ENT.PrintName = "Projectiles"
ENT.SpawnIcon = "models/props_combine/combine_mine01.mdl"
ENT.Description = "Launches objects towards where it is facing."

ENT.LaunchSound = "weapons/irifle/irifle_fire2.wav" --"ambient/machines/catapult_throw.wav"
ENT.ShootSprite = Material("sprites/physg_glow1")
ENT.BeamSprite = Material("sprites/physbeama")
ENT.SpriteColor = Color(0,0,255)
ENT.PortalDistance = 15

ENT.Type = "anim"
ENT.Base = "nz_trapbase"

ENT.NZEntity = true

DEFINE_BASECLASS("nz_trapbase")

function ENT:SetupDataTables()
    BaseClass.SetupDataTables(self)

    local available_entities = {} -- All scripted entities that can be used as projectiles
    for k,_ in pairs(scripted_ents.GetList()) do 
        available_entities[k] = k
    end

    self:NetworkVar( "String", 1, "ProjectileEntity", {KeyName = "nz_projectile_entity", Edit = {title = "Projectile Entity", order = 20, type = "Combo", values = available_entities}} )
    self:NetworkVar( "Bool", 7, "ProjectileHarmPlayers", {KeyName = "nz_projectile_friendly", Edit = {title = "Hurt Players?", order = 21, type = "Boolean"}} )
    self:NetworkVar( "Float", 3, "ProjectileVelocity", {KeyName = "nz_projectile_amount_velocity", Edit = {title = "Projectile Velocity", order = 23, type = "Float", min = 0, max = 100000}} )
	self:NetworkVar( "Float", 4, "ProjectileSpreadMin", {KeyName = "nz_projectile_amount_spread_min", Edit = {title = "Projectile Spread Min", order = 26, type = "Float", min = 0, max = 100000}} )
	self:NetworkVar( "Float", 5, "ProjectileSpreadMax", {KeyName = "nz_projectile_amount_spread_max", Edit = {title = "Projectile Spread Max", order = 27, type = "Float", min = 0, max = 100000}} )
    self:NetworkVar( "Int", 4, "ProjectileAmountMin", {KeyName = "nz_projectile_amount_min", Edit = {title = "Projectile Amount Min", order = 24, type = "Int", min = 1, max = 100000}} )
	self:NetworkVar( "Int", 5, "ProjectileAmountMax", {KeyName = "nz_projectile_amount_max", Edit = {title = "Projectile Amount Max", order = 25, type = "Int", min = 1, max = 100000}} )
    self:NetworkVar( "Int", 6, "ProjectileMaxShots", {KeyName = "nz_projectile_maxshots", Edit = {title = "Max Projectile Attacks", order = 28, type = "Int", min = 1, max = 1000000}})
    self:NetworkVar( "Float", 6, "ProjectileDelay", {KeyName = "nz_projectile_delay", Edit = {title = "Projectile Fire Delay", order = 22, type = "Float", min = 0, max = 10000}})
    self:NetworkVar( "Int", 7, "ProjectilesFired")
    self:NetworkVar( "Float", 8, "NextProjectile")
    self:NetworkVar( "Float", 9, "LastEffectTime")

    self:SetProjectileEntity("nz_m67grenade") 
    self:SetProjectileHarmPlayers(false)
    self:SetProjectileVelocity(4000)
    self:SetProjectileSpreadMin(0.0)
    self:SetProjectileSpreadMax(100.0)
    self:SetProjectileAmountMin(1)
    self:SetProjectileAmountMax(1)
    self:SetProjectileDelay(4)
    self:SetProjectileMaxShots(1000000)
end

function ENT:Initialize()
    if SERVER then
        self:SetModel("models/props_combine/combine_mine01.mdl")
        self:SetLastEffectTime(CurTime() + 0.1)
    end
end

function ENT:Activation(activator, duration, cooldown, creativeMode)
    self:SetProjectilesFired(0)

    if (self:GetNextProjectile() - CurTime() > self:GetProjectileDelay()) then
        self:SetNextProjectile(0)
    end

    BaseClass.Activation(self, activator, duration, cooldown, creativeMode)
end

function ENT:GetRandomSpread()
    return math.Rand(self:GetProjectileSpreadMin(), self:GetProjectileSpreadMax())
end

function ENT:CanShowEffect()
    return self.bAllowEffect
end

function ENT:FireProjectile()
    if SERVER then
        self:EmitSound(self.LaunchSound)
    end

    if (self:GetProjectilesFired() < self:GetProjectileMaxShots()) then
        self:SetProjectilesFired(self:GetProjectilesFired() + 1)
        local clsname = self:GetProjectileEntity()
        local amount = math.random(self:GetProjectileAmountMin(), self:GetProjectileAmountMax())
        local newents = {}
        for i = 1,amount do 
            if SERVER then
                newents[i] = ents.Create(clsname)
            end

            timer.Simple(0.015 * i, function() -- Just so it all doesn't appear at the same exact time
                -- if CLIENT then
                --     self.LastEffectTime = CurTime() + 0.15
                -- end
                
                if (SERVER and IsValid(self) and IsValid(newents[i])) then
                    newents[i]:SetPos(self:GetPos() + self:GetUp() * self.PortalDistance)
                    newents[i]:SetOwner(self)
                    newents[i]:Spawn()
        
                    local phys = newents[i]:GetPhysicsObject()
                    if (IsValid(phys)) then
                        -- Get spread
                        local RightSpread = self:GetRandomSpread()
                        local ForwardSpread = self:GetRandomSpread()
                        local spreads = {
                            math.Rand(-RightSpread, RightSpread),
                            math.Rand(-ForwardSpread, ForwardSpread)
                        }
    
                        -- Push projectile
                        local dest = self:GetUp() * self:GetProjectileVelocity()
                        --self:SetProjectileDistance(self:GetPos():DistToSqr(dest))
                        phys:ApplyForceCenter(dest + (self:GetRight() * spreads[1]) + self:GetForward() * spreads[2])

                        self:SetLastEffectTime(CurTime() + 0.2)
                    end
                end
            end)
        end
    else
        self:Deactivation(false) -- We've used up our allowed shots, no reason to stay active
    end
end

function ENT:Think()
    if (self:GetActive() and CurTime() > self:GetNextProjectile()) then
        self:SetNextProjectile(CurTime() + self:GetProjectileDelay())
        
        -- Shoot:
        self:FireProjectile()
    end
end

if CLIENT then
    function ENT:Draw()
        self:DrawModel()

        -- Sprite effect (for projectile firing)
        if (CurTime() < self:GetLastEffectTime()) then
            -- Entity glow
            if (self.ShootSprite and !self.ShootSprite:IsError()) then
                render.SetMaterial(self.ShootSprite)
                render.DrawSprite(self:GetPos() + self:GetUp() * self.PortalDistance, 40, 40, self.SpriteColor)
            end

            -- Portal effect
            effects.BeamRingPoint(self:GetPos() + self:GetUp() * (self.PortalDistance + 10), 0.2, 10, 0, 5, 5, self.SpriteColor)
        end

    end
end

-- Disable player damage from Projectile trap (if set to)
-- (This will not and CANNOT stop damage if the entity creates other deadly entities and such, sorry!):
hook.Add("PlayerShouldTakeDamage", "NZProjectileTrapHarmPlayers", function(ply, attacker) 
    if IsValid(ply) and IsValid(attacker) then
        if (IsValid(attacker) and attacker:GetClass() == "nz_trap_projectiles" and attacker.GetProjectileHarmPlayers and attacker:GetProjectileHarmPlayers() == false) then 
            return false 
        end 
    end
end)