SWEP.Base = "tfa_cod4rm_c4_base"
SWEP.Category = "Call of Duty: Modern Warfare Remastered SWEPS"
SWEP.Manufacturer = "N/A" --Gun Manufactrer (e.g. Hoeckler and Koch )
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Author				= "Krazy" --Author Tooltip
DEFINE_BASECLASS(SWEP.Base)
SWEP.Purpose 			= "A plastic explosive charge that is detonated via a remote detonator."

SWEP.Slot = 4

SWEP.Type = "Remote Explosive"
SWEP.PrintName = "C4"

SWEP.ViewModel			= "models/krazy/cod4rm/c4_v.mdl" --Viewmodel path
SWEP.ViewModelFOV = 60

SWEP.WorldModel			= "models/krazy/cod4rm/c4_w.mdl" --Viewmodel path
SWEP.HoldType = "slam"
SWEP.ThirdPersonReloadDisable = true
SWEP.CookTimer = 5
SWEP.UseHands = true --Use gmod c_arms system.

SWEP.Scoped = false

SWEP.Shotgun = false
SWEP.ShellTime = 0.75

SWEP.DisableChambering = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 4

SWEP.Primary.Ammo = "cod4rm_c4"
SWEP.Primary.Automatic = false
SWEP.Primary.RPM = 60
SWEP.Primary.Damage = 95
SWEP.Primary.NumShots = 1
SWEP.Primary.Spread		= .01					--This is hip-fire acuracy.  Less is more (1 is horribly awful, .0001 is close to perfect)
SWEP.Primary.IronAccuracy = .00	-- Ironsight accuracy, should be the same for shotguns
SWEP.SelectiveFire = false

SWEP.Primary.KickUp			= -0.90					-- This is the maximum upwards recoil (rise)
SWEP.Primary.KickDown			= -0.90					-- This is the maximum downwards recoil (skeet)
SWEP.Primary.KickHorizontal			= 0.0					-- This is the maximum sideways recoil (no real term)
SWEP.Primary.StaticRecoilFactor = 0.90 	--Amount of recoil to directly apply to EyeAngles.  Enter what fraction or percentage (in decimal form) you want.  This is also affected by a convar that defaults to 0.5.

SWEP.Primary.SpreadMultiplierMax = 4.5 --How far the spread can expand when you shoot.
SWEP.Primary.SpreadIncrement = 0.7 --What percentage of the modifier is added on, per shot.
SWEP.Primary.SpreadRecovery = 4.5 --How much the spread recovers, per second.

SWEP.Secondary.IronFOV = 60 --Ironsights FOV (90 = same)
SWEP.BoltAction = false --Un-sight after shooting?
SWEP.BoltTimerOffset = 0.25 --How long do we remain in ironsights after shooting?

SWEP.RunSightsPos = Vector(0.519, 0, -0.681)
SWEP.RunSightsAng = Vector(-21.994, 0, 0)


SWEP.InspectionPos = Vector(3.657, -5.283, -0.201)
SWEP.InspectionAng = Vector(0, 33.965, 0)

SWEP.Primary.Range = 882 -- The distance the bullet can travel in source units.  Set to -1 to autodetect based on damage/rpm.
SWEP.Primary.RangeFalloff = 1 -- The percentage of the range the bullet damage starts to fall off at.  Set to 0.8, for example, to start falling off after 80% of the range.

SWEP.MuzzleFlashEffect = ""
SWEP.Tracer = ""

SWEP.Primary.Round = "ent_cod4rm_c4"
SWEP.CanHold = true

function SWEP:Equip(NewOwner)
	if self.Owner.C4s == nil then self.Owner.C4s = {} end
end

function SWEP:OnRemove()
	self:SendWeaponAnim(ACT_VM_HOLSTER)
	if not IsFirstTimePredicted() then return end
end

function SWEP:Think2()
	BaseClass.Think2(self)
	if self.Owner:KeyPressed(IN_ATTACK2) then
			if not IsFirstTimePredicted() then return end

			self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)	

			timer.Simple(0.8,function() end)
			
			if self.Owner:Alive() and self.Owner:IsValid() then
			-- thanks chief tiger
				local Owner = self.Owner
				if SERVER then
					for k, v in pairs( Owner.C4s ) do
						timer.Simple( .05 * k, function()
							if IsValid( v ) then
								v:Explode()
								table.remove( Owner.C4s, k )	
								Owner.C4s[k] = null
								self:DoAmmoCheck()
							end				
						end )
					end
				end	
			end
		end
	end