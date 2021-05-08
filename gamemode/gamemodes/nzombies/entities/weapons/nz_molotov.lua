if SERVER then
	AddCSLuaFile("nz_molotov.lua")
	SWEP.Weight			= 5
	SWEP.AutoSwitchTo	= false
	SWEP.AutoSwitchFrom	= true
end

if CLIENT then

	SWEP.PrintName     	    = "Molotov"			
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= true
	
	SWEP.Category			= "nZombies"

end


SWEP.Author			= "Zet0r"
SWEP.Contact		= "youtube.com/Zet0r"
SWEP.Purpose		= "FIRE FIRE FIRE if you have any"
SWEP.Instructions	= "Let the gamemode give you it"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.HoldType = "grenade"

SWEP.ViewModelFOV = 50
SWEP.ViewModel = "models/nmrih/weapons/exp_molotov/v_exp_molotov.mdl"
SWEP.WorldModel = "models/nmrih/weapons/exp_molotov/w_exp_molotov.mdl"
SWEP.UseHands = true
SWEP.vModel = true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "nz_specialgrenade"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.NextReload				= 1

SWEP.PrimeSounds = {
	"nz/monkey/voice_prime/raise_vox_00.wav",
	"nz/monkey/voice_prime/raise_vox_01.wav",
	"nz/monkey/voice_prime/raise_vox_02.wav",
	"nz/monkey/voice_prime/raise_vox_03.wav",
	"nz/monkey/voice_prime/raise_vox_04.wav",
	"nz/monkey/voice_prime/raise_vox_05.wav",
	"nz/monkey/voice_prime/raise_vox_06.wav",
	"nz/monkey/voice_prime/raise_vox_07.wav",
	"nz/monkey/voice_prime/raise_vox_08.wav",
	"nz/monkey/voice_prime/raise_vox_09.wav",
	"nz/monkey/voice_prime/raise_vox_10.wav",
	"nz/monkey/voice_prime/raise_vox_11.wav",
}

function SWEP:Initialize()

	self:SetHoldType( "grenade" )

end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
	if CLIENT then
	
	else
		self:CallOnClient("Deploy")
	end
end

function SWEP:PrimaryAttack()
	if SERVER then
		self:ThrowBomb(5000)
	end
end

function SWEP:ThrowBomb(force)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SendWeaponAnim(ACT_VM_THROW)
	
	local nade = ents.Create("nz_nmrih_molotov_projectile")
	local pos = self.Owner:EyePos() + (self.Owner:GetAimVector() * 20)
	local ang = Angle(0,(self.Owner:GetPos() - pos):Angle()[2]-90,0)
	nade:SetPos(pos)
	nade:SetAngles(ang)
	nade:Spawn()
	nade:Activate()
	nade:SetOwner(self.Owner)
	
	local nadePhys = nade:GetPhysicsObject()
		if !IsValid(nadePhys) then return end
	nadePhys:ApplyForceCenter(self.Owner:GetAimVector():GetNormalized() * force + self.Owner:GetVelocity())
	--nade:EmitSound("nz/monkey/voice_throw/throw_0"..math.random(0,3)..".wav")
	
end

function SWEP:PostDrawViewModel()

end

function SWEP:DrawWorldModel()

end

function SWEP:OnRemove()
	
end
