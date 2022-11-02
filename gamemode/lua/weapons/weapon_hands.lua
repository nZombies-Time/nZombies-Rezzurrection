if ( SERVER ) then
	SWEP.Weight          		= 0
	SWEP.AutoSwitchTo			= false
	SWEP.AutoSwitchFrom			= false
end

if ( CLIENT ) then
	SWEP.PrintName			= "Hands"
	SWEP.Slot				= 0
    SWEP.SlotPos         	= 0
    SWEP.DrawAmmo			= false
	SWEP.ViewModelFOV       = 10
	SWEP.DrawCrosshair		= false

	function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )

  		-- Set us up the texture
  		surface.SetDrawColor( 255, 255, 255, alpha )
  		surface.SetTexture( self.WepSelectIcon )

  		-- Lets get a sin wave to make it bounce
  		local fsin = 0

  			if ( self.BounceWeaponIcon == true ) then
    			fsin = math.sin( CurTime() * 10 ) * 5
  			end

  		-- Borders
 		 y = y + 10
  		x = x + 10
  		wide = wide - 20

  		-- Draw that mother
  		surface.DrawTexturedRect( x + (fsin), y - (fsin),  wide-fsin*2 , ( wide / 2 ) + (fsin) )

  		-- Draw weapon info box
  		self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )
	end
end

SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.HoldType				= "normal"
SWEP.Category			    = "Other"

SWEP.Spawnable              = true
SWEP.AdminSpawnable         = true

SWEP.ViewModel              = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel             = "models/weapons/w_crowbar.mdl"

SWEP.Primary.ClipSize       = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic      = false
SWEP.Primary.Ammo           = "None"
  
SWEP.Secondary.ClipSize     = -1
SWEP.Secondary.DefaultClip  = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo         = "None"


function SWEP:Initialize()
	if self.SetHoldType then
		self:SetHoldType( self.HoldType or "normal" )
	else
		self:SetWeaponHoldType( "normal" )
	end
end

function SWEP:Think()
end

function SWEP:OnDrop()
   self:Remove()
end

function SWEP:ShouldDropOnDie()
   return false
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:Deploy()
	if SERVER and IsValid(self.Owner) then
		self.Owner:DrawViewModel(false)
	end
   return true
end

function SWEP:Holster()
   return true
end

function SWEP:DrawWorldModel()
end

function SWEP:DrawWorldModelTranslucent()
end