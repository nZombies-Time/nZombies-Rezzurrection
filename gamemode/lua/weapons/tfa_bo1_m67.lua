SWEP.Base = "tfa_nade_cook_base"
SWEP.Category = "TFA Other"
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.UseHands = true
SWEP.Type_Displayed = "Grenade"
SWEP.Author = "FlamingFox"
SWEP.Slot = 5
SWEP.PrintName = "M67 Grenade"
SWEP.DrawCrosshair = true
SWEP.DrawCrosshairIronSights = false
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

--[Model]--
SWEP.ViewModel			= "models/nzr/2022/weapons/c_m67.mdl"
SWEP.ViewModelFOV = 65
SWEP.WorldModel			= "models/nzr/2022/weapons/w_m67.mdl"
SWEP.HoldType = "grenade"
SWEP.CameraAttachmentOffsets = {}
SWEP.CameraAttachmentScale = 1
SWEP.VMPos = Vector(0, 0, 0)
SWEP.VMAng = Vector(0, 0, 0)
SWEP.VMPos_Additive = true
SWEP.ShowWorldModel = false

SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
        Pos = {
        Up = -1,
        Right = 1,
        Forward = 3,
        },
        Ang = {
		Up = -180,
        Right = 190,
        Forward = 0
        },
		Scale = 1
}

--[Gun Related]--
SWEP.Primary.Sound = "nil"
SWEP.Primary.Ammo = "Grenade"
SWEP.Primary.Automatic = false
SWEP.Primary.RPM = 800
SWEP.Primary.Damage = 150
SWEP.Primary.AmmoConsumption = 0
SWEP.Primary.ClipSize = 999
SWEP.Primary.DefaultClip = 999
SWEP.Primary.Delay = 0.15
SWEP.DisableChambering = true
SWEP.SelectiveFire = false
SWEP.FiresUnderwater = true
SWEP.Cookable = true
SWEP.ThrowSpin = true
SWEP.Delay = 0.15

--[Firemode]--
SWEP.Primary.BurstDelay = nil
SWEP.DisableBurstFire = true
SWEP.SelectiveFire = false
SWEP.OnlyBurstFire = false
SWEP.BurstFireCount = nil

--[Range]--
SWEP.Primary.Range = -1
SWEP.Primary.RangeFalloff = -1
SWEP.Primary.DisplayFalloff = false
SWEP.DisplayFalloff = false

--[Projectiles]--
SWEP.Primary.Projectile = "bo1_m67_grenade"
SWEP.Primary.ProjectileModel = "models/nzr/2022/weapons/m67_projectile.mdl"
SWEP.Velocity = 850
SWEP.Underhanded = false
SWEP.AllowSprintAttack = true
SWEP.AllowUnderhanded = false
SWEP.DisableIdleAnimations = false

--[Spread Related]--
SWEP.Primary.Spread = .05

--[Iron Sights]--
SWEP.data = {}
SWEP.data.ironsights = 0

--[Shells]--
SWEP.LuaShellEject = false
SWEP.EjectionSmokeEnabled = false

--[Misc]--
SWEP.InspectPos = Vector(0, 0, 1.5)
SWEP.InspectAng = Vector(10, 0, 0)
SWEP.MoveSpeed = 1
SWEP.IronSightsMoveSpeed  = SWEP.MoveSpeed * 0.8
SWEP.SafetyPos = Vector(1, -2, -0.5)
SWEP.SafetyAng = Vector(-20, 35, -25)

--[Tables]--
SWEP.SequenceRateOverride = {
}

SWEP.RunSightsPos = Vector(0, 1, 2)
SWEP.RunSightsAng = Vector(-20, 0, 5)

SWEP.SpeedColaFactor = 1
SWEP.SpeedColaActivities = {
	[ACT_VM_RELOAD] = true,
	[ACT_VM_RELOAD_EMPTY] = true,
	[ACT_VM_RELOAD_SILENCED] = true,
}

SWEP.EventTable = {
[ACT_VM_DRAW] = {
{ ["time"] = 0, ["type"] = "lua", value = function(self) self.Bodygroups_V = self:GetOwner():HasPerk("widowswine") and {[0] = 1} or {[0] = 0} end, client = true, server = true},
{ ["time"] = 5 / 45, ["type"] = "sound", ["value"] = Sound("TFA.BO1.M67.Pin") },
},
[ACT_VM_THROW] = {
{ ["time"] = 5 / 45, ["type"] = "sound", ["value"] = Sound("TFA.BO1.M67.Throw") },
{ ["time"] = 0, ["type"] = "lua", value = function(self)
	local ply = self:GetOwner()
	if IsValid(ply) and ply.TFAVOX_Sounds then
	local sndtbl = ply.TFAVOX_Sounds['main']
		if sndtbl then
			TFAVOX_PlayVoicePriority(ply, sndtbl['jump'], 1)
		end
	end
end, client = false, server = true},
},
}

--[Shit]--
SWEP.AllowViewAttachment = true --Allow the view to sway based on weapon attachment while reloading or drawing, IF THE CLIENT HAS IT ENABLED IN THEIR CONVARS.
SWEP.Sprint_Mode = TFA.Enum.LOCOMOTION_ANI -- ANI = mdl, HYBRID = ani + lua, Lua = lua only
SWEP.Sights_Mode = TFA.Enum.LOCOMOTION_LUA -- ANI = mdl, HYBRID = lua but continue idle, Lua = stop mdl animation
SWEP.Idle_Mode = TFA.Enum.IDLE_BOTH --TFA.Enum.IDLE_DISABLED = no idle, TFA.Enum.IDLE_LUA = lua idle, TFA.Enum.IDLE_ANI = mdl idle, TFA.Enum.IDLE_BOTH = TFA.Enum.IDLE_ANI + TFA.Enum.IDLE_LUA
SWEP.Idle_Blend = 0.25 --Start an idle this far early into the end of a transition
SWEP.Idle_Smooth = 0.05 --Start an idle this far early into the end of another animation
SWEP.SprintBobMult = 0.5

SWEP.WElements = {
	["fakenade"] = { type = "Model", model = "models/nzr/2022/weapons/m67_projectile.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 2.5, -1), angle = Angle(180, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = false, active = true, bodygroup = {} },
}

SWEP.StatCache_Blacklist = {
	["Primary.Projectile"] = true,
}

--[Coding]--
DEFINE_BASECLASS( SWEP.Base )

function SWEP:Equip(ply, ...)
	if nzombies then
		ply:SetAmmo(4, GetNZAmmoID("grenade"))
	end

	return BaseClass.Equip(self, ply, ...)
end

function SWEP:WidowsWineSwap()
	self.Cookable = false
	self.Primary_TFA.Projectile = "bo1_semtex_grenade"
	self:ClearStatCache("Primary.Projectile")
end

function SWEP:GrenadeSwap()
	self.Cookable = true
	self.Primary_TFA.Projectile = "bo1_m67_grenade"
	self:ClearStatCache("Primary.Projectile")
end
