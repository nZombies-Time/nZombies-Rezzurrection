-- New trap made by Ethorbit, using the trap template code 

AddCSLuaFile( )

-- Register teh trap
nzTraps:Register("nz_trap_propeller")

ENT.Author = "Ethorbit"
ENT.PrintName = "Propeller"
ENT.SpawnIcon = "models/props_c17/trappropeller_blade.mdl"
ENT.Description = "Scrap blade that rotates around a car engine to slice its victims."

ENT.Type = "anim"
ENT.Base = "nz_trapbase"

ENT.LoopSound = Sound("ambient/machines/spin_loop.wav")
ENT.SliceSounds = {"ambient/machines/slicer1.wav", "ambient/machines/slicer2.wav", "ambient/machines/slicer3.wav", "ambient/machines/slicer4.wav"}

ENT.NZEntity = true

DEFINE_BASECLASS("nz_trapbase")

function ENT:SetupDataTables()
    BaseClass.SetupDataTables(self)
end

function ENT:Initialize()
    if SERVER then
        self:SetModel("models/props_c17/trappropeller_engine.mdl")
        self:InitBlade()
    end
end

function ENT:Activation(activator, duration, cooldown, creativeMode)
    BaseClass.Activation(self, activator, duration, cooldown, creativeMode)
    
    self.SoundPlayer = CreateSound(self, self.LoopSound)
    if (self.SoundPlayer) then
        self.SoundPlayer:Play()
    end
end

function ENT:Deactivation(creativeMode)
    BaseClass.Deactivation(self, creativeMode)

    if (self.SoundPlayer) then
        self.SoundPlayer:FadeOut(0.8)
    end
end

function ENT:RemoveBlade()
    if (IsValid(self.BladeProp)) then
        self.BladeProp:Remove()
    end
end

function ENT:GetBlade()
    return self.BladeProp
end

function ENT:InitBlade()
    self:RemoveBlade()
    self.BladeProp = ents.Create("propellertrap_blade")
    if (IsValid(self.BladeProp)) then
        local bladeOffset = self:GetPos() + self:GetUp() * 27
        self.BladeProp:SetPos(bladeOffset)
        self.BladeProp:SetAngles(self:GetAngles())
        self.BladeProp:SetParent(self)
        self.BladeProp:SetLocalPos(Vector(-5.8,-2.15,27))
        self.BladeProp:Spawn()

        local phys = self.BladeProp:GetPhysicsObject()
        phys:EnableMotion(false)
    end
end

if SERVER then
    function ENT:Think()
        if (!IsValid(self.BladeProp)) then
            self:InitBlade()
        end
    end
end

function ENT:OnRemove()
    if (IsValid(self.BladeProp)) then
        self.BladeProp:Remove()
    end
end