if SERVER then
	AddCSLuaFile("nz_tnt.lua")
	SWEP.Weight			= 5
	SWEP.AutoSwitchTo	= false
	SWEP.AutoSwitchFrom	= true
end

if CLIENT then

	SWEP.PrintName     	    = "TNT Charge"			
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= true
	
	SWEP.Category			= "nZombies"

end


SWEP.Author			= "Zet0r"
SWEP.Contact		= "youtube.com/Zet0r"
SWEP.Purpose		= "Throws TNT if you have any"
SWEP.Instructions	= "Let the gamemode give you it"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.HoldType = "slam"

SWEP.ViewModelFOV			= 63
SWEP.ViewModel				= "models/nz_equipment/v_compb_allied.mdl"
SWEP.WorldModel				= "models/weapons/w_compb_allied.mdl"
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

	self:SetHoldType( "slam" )

end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_PULLBACK_LOW)
	if CLIENT then
	else
		self:CallOnClient("Deploy")
	end
end

function SWEP:PrimaryAttack()
	if SERVER then
		self:ThrowBomb(1000)
	end
end

function SWEP:ThrowBomb(force)
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self:SendWeaponAnim(ACT_VM_SECONDARYATTACK)
	
	local nade = ents.Create("nz_tntbomb")
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
