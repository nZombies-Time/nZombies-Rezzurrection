if SERVER then
	AddCSLuaFile("nz_oren.lua")
	SWEP.Weight			= 5
	SWEP.AutoSwitchTo	= false
	SWEP.AutoSwitchFrom	= true
end

if CLIENT then

	SWEP.PrintName = "O'Ren Ishii Katana"
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

SWEP.ViewModel = "models/weapons/tfa_l4d2/c_oren_katana.mdl"
SWEP.WorldModel = "models/weapons/tfa_l4d2/w_oren_katana.mdl"
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

SWEP.Primary.Damage 		= 175
SWEP.Range					= 175


function SWEP:Initialize()

	self:SetHoldType( self.HoldType )

end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_RECOIL2)
	self.HolsterTime = CurTime() + 3
	self:EmitSound("weapons/nzr/oren/knife_deploy.wav")
	
	timer.Simple(0.9, function()
		if IsValid(self) then
			self:EmitSound("nz/bowie/draw/bowie_turn.wav")
		end
	end)
end

function SWEP:PrimaryAttack()
	local anim = math.random(0,2)
	if anim == 0 then
	self.Weapon:SendWeaponAnim(ACT_VM_HITLEFT)
	end
	if anim == 1 then
	self.Weapon:SendWeaponAnim(ACT_VM_HITRIGHT)
	end
	if anim == 2 then
	self.Weapon:SendWeaponAnim(ACT_VM_PULLBACK)
	end
	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 125 )
	tr.filter = self.Owner
	tr.mask = MASK_SHOT
	local trace = util.TraceLine( tr )

	self.Weapon:SetNextPrimaryFire(CurTime() + 0.8)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self:EmitSound("weapons/nzr/oren/katana_swing_miss"..math.random(1,4)..".wav")
	if ( trace.Hit ) then
			
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = 225
			bullet.DamageType		= DMG_CLUB
			self.Owner:FireBullets(bullet) 
			self:EmitSound("weapons/nzr/oren/melee_katana_0"..math.random(1,4)..".wav")
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = 225
			bullet.DamageType		= DMG_CLUB
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