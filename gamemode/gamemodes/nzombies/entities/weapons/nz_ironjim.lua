if SERVER then
	AddCSLuaFile("nz_ironjim.lua")
	SWEP.Weight			= 5
	SWEP.AutoSwitchTo	= false
	SWEP.AutoSwitchFrom	= true
end

if CLIENT then

	SWEP.PrintName     	    = "The Classic"	
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

SWEP.HoldType = "melee"

SWEP.ViewModel = "models/weapons/bo3/c_bo3_crowbar.mdl"
SWEP.WorldModel = "models/weapons/bo3/w_bo3_crowbar.mdl"
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

SWEP.Primary.Damage 		= 150
SWEP.Range					= 100


function SWEP:Initialize()

	self:SetHoldType( self.HoldType )

end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_FIDGET)
	self.HolsterTime = CurTime() + 1.8
	self:EmitSound("weapons/nzr/jim/crowbar_first_raise.wav")
end

function SWEP:PrimaryAttack()
	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 100 )
	tr.filter = self.Owner
	tr.mask = MASK_SHOT
	local trace = util.TraceLine( tr )

	self.Weapon:SetNextPrimaryFire(CurTime() + 0.25)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	self:EmitSound("weapons/nzr/jim/swing_1_0"..math.random(0,2)..".wav")
	if ( trace.Hit ) then
			
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = 200
			self.Owner:FireBullets(bullet) 
			self:EmitSound("weapons/nzr/jim/crowbar_impact_human_0"..math.random(0,1)..".wav")
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = 200
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