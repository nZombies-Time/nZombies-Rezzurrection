DEFINE_BASECLASS(SWEP.Base)
SWEP.Base = "tfa_cod4rm_claymore_base"
SWEP.Category = "nZombies"
SWEP.Manufacturer = "N/A" --Gun Manufactrer (e.g. Hoeckler and Koch )
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Author				= "Krazy" --Author Tooltip
SWEP.Purpose 			= "A directional anti-personnel trip mine for use against infantry. Useful for defending an area. Triggers in a small proximity"

SWEP.Slot = 4

SWEP.Type = "Anti-Personnel Mine"
SWEP.PrintName = "M18A1 Claymore"

SWEP.ViewModel			= "models/krazy/cod4rm/claymore_v.mdl" --Viewmodel path
SWEP.ViewModelFOV = 60

SWEP.WorldModel			= "models/krazy/cod4rm/claymore_w.mdl" --Viewmodel path
SWEP.HoldType = "slam"
SWEP.ThirdPersonReloadDisable = true
SWEP.CookTimer = 5
SWEP.UseHands = true --Use gmod c_arms system.

SWEP.Scoped = false

SWEP.Shotgun = false
SWEP.ShellTime = 0.75

SWEP.DisableChambering = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 2

SWEP.Primary.Ammo = "cod4rm_claymore"
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

SWEP.RunSightsPos = Vector(0.56, 0, -0.801)
SWEP.RunSightsAng = Vector(-23.08, 0, -3.649)


SWEP.InspectionPos = Vector(3.657, -5.283, -0.201)
SWEP.InspectionAng = Vector(0, 33.965, 0)

SWEP.Primary.Range = 882 -- The distance the bullet can travel in source units.  Set to -1 to autodetect based on damage/rpm.
SWEP.Primary.RangeFalloff = 1 -- The percentage of the range the bullet damage starts to fall off at.  Set to 0.8, for example, to start falling off after 80% of the range.

SWEP.MuzzleFlashEffect = ""
SWEP.Tracer = ""

SWEP.Primary.Round = "ent_cod4rm_claymore"
SWEP.CanHold = true

SWEP.DisposeTimer = 0.5
SWEP.Stripping = false
SWEP.StripTimer = math.huge

function SWEP:OnRemove()
	if not IsFirstTimePredicted() then return end
end