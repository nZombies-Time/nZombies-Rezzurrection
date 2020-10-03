if SERVER then
	AddCSLuaFile("nz_zweihander.lua")
	SWEP.Weight			= 5
	SWEP.AutoSwitchTo	= false
	SWEP.AutoSwitchFrom	= true
end

if CLIENT then

	SWEP.PrintName     	    = "Zweihander"	
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= true
	
	SWEP.Category			= "nZombies"

end


SWEP.Author			= "Laby"
SWEP.Contact		= "you make joke"
SWEP.Purpose		= "Stab Stab Stab!"
SWEP.Instructions	= "Let the gamemode give you it"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.HoldType = "melee2"

SWEP.ViewModel	= "models/weapons/tfa_kf2/c_zweihander.mdl"
SWEP.WorldModel	= "models/weapons/tfa_kf2/w_zweihander.mdl"
SWEP.UseHands = true
SWEP.vModel = true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.DamageType		= DMG_CLUB
SWEP.Primary.Force			= 0

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.NextReload				= 1

SWEP.Primary.Damage 		= 350
SWEP.Range					= 215


function SWEP:Initialize()

	self:SetHoldType( self.HoldType )

end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_RECOIL1)
	self.HolsterTime = CurTime() + 2.5
	timer.Simple(1, function()
		if IsValid(self) then
			self:EmitSound("weapons/nzr/zwei/unsheath_fast_"..math.random(1,2)..".wav")
		end
	end)
end

function SWEP:PrimaryAttack()
	local anim = math.random(0,1)
	if anim == 0 then
	self.Weapon:SendWeaponAnim(ACT_VM_HITLEFT)
	end
	if anim == 1 then
	self.Weapon:SendWeaponAnim(ACT_VM_HITRIGHT)
	end
	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 150 )
	tr.filter = self.Owner
	tr.mask = MASK_SHOT
	local trace = util.TraceLine( tr )

	self.Weapon:SetNextPrimaryFire(CurTime() + 1.5)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self:EmitSound("weapons/nzr/zwei/swing_hard_"..math.random(1,4)..".wav")
	if ( trace.Hit ) then
			
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = 450
			self.Owner:FireBullets(bullet) 
			self:EmitSound("weapons/nzr/zwei/hitflesh_"..math.random(1,3)..".wav")
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = 450
			self.Owner:FireBullets(bullet) 
			util.Decal("ManhackCut", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)
end
end

function SWEP:DrawAnim()
	
end

function SWEP:PostDrawViewModel()

end

function SWEP:DrawWorldModel()

end

function SWEP:OnRemove()
	
end

function SWEP:Think()
	
end

--function SWEP:GetViewModelPosition( pos, ang )
 
 	--local newpos = LocalPlayer():EyePos()
	--local newang = LocalPlayer():EyeAngles()
	--local up = newang:Up()
	
	--newpos = newpos + LocalPlayer():GetAimVector()*6 - up*65
	
	--return newpos, newang
 
--end