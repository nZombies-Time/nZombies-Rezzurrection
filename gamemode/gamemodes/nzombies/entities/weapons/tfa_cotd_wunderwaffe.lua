local nzombies = engine.ActiveGamemode() == "nzombies"
local dlight_cvar = GetConVar("cl_tfa_fx_wonderweapon_dlights")

SWEP.Base = "tfa_gun_base"
SWEP.Category = "TFA Wonder Weapons"
SWEP.Spawnable = TFA_BASE_VERSION and TFA_BASE_VERSION >= 4.72
SWEP.AdminSpawnable = true
SWEP.UseHands = true
SWEP.Type_Displayed = "Wonder Weapon"
SWEP.Author = "FlamingFox"
SWEP.Slot = 2
SWEP.PrintName = "Wunderwaffe DG-2"
SWEP.DrawCrosshair = true
SWEP.DrawCrosshairIS = false

--[Model]--
SWEP.ViewModel			= "models/weapons/tfa_bo3/wunderwaffe/c_wunderwaffe.mdl"
SWEP.ViewModelFOV = 65
SWEP.WorldModel			= "models/weapons/tfa_bo3/wunderwaffe/w_wunderwaffe.mdl"
SWEP.HoldType = "ar2"
SWEP.CameraAttachmentOffsets = {}
SWEP.CameraAttachmentScale = 1
SWEP.MuzzleAttachment = "1"
SWEP.VMPos = Vector(0, -6, -1.5)
SWEP.VMAng = Vector(0, 0, 0)
SWEP.VMPos_Additive = true

SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
        Pos = {
        Up = -0.5,
        Right = 1,
        Forward = 3.5,
        },
        Ang = {
		Up = 180,
        Right = 190,
        Forward = 0
        },
		Scale = 1
}

--[Gun Related]--
SWEP.Primary.Sound = "TFA_BO3_WAFFE.Shoot"
SWEP.Primary.Ammo = "none"
SWEP.Primary.Automatic = true
SWEP.Primary.RPM = 90
SWEP.Primary.Damage = 115
SWEP.Primary.NumShots = 1
SWEP.Primary.AmmoConsumption = 0
SWEP.Primary.ClipSize = 115
SWEP.Primary.DefaultClip = 115
SWEP.MuzzleFlashEffect = "tfa_bo3_muzzleflash_waffe"
SWEP.DisableChambering = true
SWEP.FiresUnderwater = false

--[Firemode]--
SWEP.Primary.BurstDelay = nil
SWEP.DisableBurstFire = true
SWEP.SelectiveFire = false
SWEP.OnlyBurstFire = false
SWEP.BurstFireCount = nil

--[LowAmmo]--
SWEP.FireSoundAffectedByClipSize = true
SWEP.LowAmmoSoundThreshold = 0.33 --0.33
SWEP.LowAmmoSound = ""
SWEP.LastAmmoSound = "TFA_BO3_WAFFE.ShootLast"

--[Range]--
SWEP.Primary.Range = -1
SWEP.Primary.RangeFalloff = -1
SWEP.Primary.DisplayFalloff = false
SWEP.DisplayFalloff = false

--[Recoil]--
SWEP.ViewModelPunchPitchMultiplier = 0.5 -- Default value is 0.5
SWEP.ViewModelPunchPitchMultiplier_IronSights = 0.09 -- Default value is 0.09

SWEP.ViewModelPunch_MaxVertialOffset				= 3 -- Default value is 3
SWEP.ViewModelPunch_MaxVertialOffset_IronSights		= 1.95 -- Default value is 1.95
SWEP.ViewModelPunch_VertialMultiplier				= 1 -- Default value is 1
SWEP.ViewModelPunch_VertialMultiplier_IronSights	= 0.25 -- Default value is 0.25

SWEP.ViewModelPunchYawMultiplier = 0.6 -- Default value is 0.6
SWEP.ViewModelPunchYawMultiplier_IronSights = 0.25 -- Default value is 0.25

--[Spread Related]--
SWEP.Primary.Spread		  = .04
SWEP.Primary.IronAccuracy = .00
SWEP.IronRecoilMultiplier = 0.6
SWEP.CrouchAccuracyMultiplier = 0.85

SWEP.Primary.KickUp				= 0.6
SWEP.Primary.KickDown			= 0.6
SWEP.Primary.KickHorizontal		= 0.5
SWEP.Primary.StaticRecoilFactor	= 0.4

SWEP.Primary.SpreadMultiplierMax = 3
SWEP.Primary.SpreadIncrement = 3
SWEP.Primary.SpreadRecovery = 4

--[Iron Sights]--
SWEP.IronBobMult 	 = 0.065
SWEP.IronBobMultWalk = 0.065
SWEP.data = {}
SWEP.data.ironsights = 1
SWEP.Secondary.IronFOV = 70
SWEP.IronSightsPos = Vector(-5.13, -4, -0.82)
SWEP.IronSightsAng = Vector(0, 0, 0)
SWEP.IronSightTime = 0.45

--[Shells]--
SWEP.LuaShellEject = false
SWEP.LuaShellEffect = "ShellEject"
SWEP.LuaShellModel = "models/weapons/tfa_bo3/wunderwaffe/tesla_bulb.mdl"
SWEP.LuaShellScale = 1.2
SWEP.LuaShellEjectDelay = 0
SWEP.ShellAttachment = "0"
SWEP.EjectionSmokeEnabled = false

--[Projectile]--
SWEP.Primary.Projectile         = "bo3_ww_wunderwaffe" -- Entity to shoot
SWEP.Primary.ProjectileVelocity = 3500 -- Entity to shoot's velocity
SWEP.Primary.ProjectileModel    = "models/hunter/blocks/cube025x025x025.mdl" -- Entity to shoot's model

--[Misc]--
SWEP.AmmoTypeStrings = {ar2altfire = "Tesla Bulbs"}
SWEP.InspectPos = Vector(3, -2, -1)
SWEP.InspectAng = Vector(20, 10, 15)
SWEP.MoveSpeed = 1
SWEP.IronSightsMoveSpeed  = SWEP.MoveSpeed * 0.8
SWEP.SafetyPos = Vector(1, -2, -0.5)
SWEP.SafetyAng = Vector(-20, 35, -25)
SWEP.SmokeParticle = ""

--[NZombies]--
SWEP.NZWonderWeapon = false
SWEP.NZSpecialCategory = "display"
SWEP.NZSpecialWeaponData = {MaxAmmo = 0, AmmoType = "none"}

function SWEP:NZSpecialHolster(wep)
	local ply = self:GetOwner()
	if IsValid(ply) then
		ply:SetUsingSpecialWeapon(false)
		ply:EquipPreviousWeapon()
		ply:RemovePowerUp("deathmachine")
	end
	return true
end

--[Tables]--
SWEP.StatusLengthOverride = {
	[ACT_VM_RELOAD] = 100 / 30,
}

SWEP.SprintAnimation = {
	["in"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "sprint_in", --Number for act, String/Number for sequence
	},
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "sprint_loop", --Number for act, String/Number for sequence
		["is_idle"] = true
	},
	["out"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "sprint_out", --Number for act, String/Number for sequence
	}
}

SWEP.EventTable = {
[ACT_VM_DRAW] = {
{ ["time"] = 5 / 30, ["type"] = "lua", value = function(self) self:DoTheLights() end, client = true, server = true},
{ ["time"] = 15 / 30, ["type"] = "sound", ["value"] = Sound("TFA_BO3_WAFFE.Meow.Idle") },
},
[ACT_VM_DRAW_DEPLOYED] = {
{ ["time"] = 0, ["type"] = "lua", value = function(self) self:CleanParticles() end, client = true, server = true},
{ ["time"] = 15 / 30, ["type"] = "sound", ["value"] = Sound("TFA_BO3_WAFFE.FlipOn") },
{ ["time"] = 20 / 30, ["type"] = "lua", value = function(self) self:DoTheLights() end, client = true, server = true},
},
}

--[Shit]--
SWEP.AllowViewAttachment = true --Allow the view to sway based on weapon attachment while reloading or drawing, IF THE CLIENT HAS IT ENABLED IN THEIR CONVARS.
SWEP.Sprint_Mode = TFA.Enum.LOCOMOTION_ANI -- ANI = mdl, HYBRID = ani + lua, Lua = lua only
SWEP.Sights_Mode = TFA.Enum.LOCOMOTION_HYBRID -- ANI = mdl, HYBRID = lua but continue idle, Lua = stop mdl animation
SWEP.Idle_Mode = TFA.Enum.IDLE_BOTH --TFA.Enum.IDLE_DISABLED = no idle, TFA.Enum.IDLE_LUA = lua idle, TFA.Enum.IDLE_ANI = mdl idle, TFA.Enum.IDLE_BOTH = TFA.Enum.IDLE_ANI + TFA.Enum.IDLE_LUA
SWEP.Idle_Blend = 0.25 --Start an idle this far early into the end of a transition
SWEP.Idle_Smooth = 0.05 --Start an idle this far early into the end of another animation
SWEP.SprintBobMult = 0

SWEP.VElements = {
	["glass"] = { type = "Model", model = "models/weapons/tfa_bo3/wunderwaffe/c_wunderwaffe_bulbs.mdl", bone = "tag_weapon", rel = "", pos = Vector(0, 0, 0), angle = Angle(0, 0, 0), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bonemerge = true, active = true, translucent = true, bodygroup = {} },
}

--[Effects]--
DEFINE_BASECLASS( SWEP.Base )

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)
	
	self:NetworkVarTFA("Float", "NextWave")
	self:NetworkVarTFA("Float", "NextGlow")
end

function SWEP:ReloadSmokeyNess(num)
	timer.Simple(0, function()
		if IsValid(self) and self:VMIV() then
			if IsFirstTimePredicted() then
				ParticleEffectAttach( "bo3_waffe_vm_smoke", PATTACH_POINT_FOLLOW, self.OwnerViewModel, num)
			end
		end
	end)
end

function SWEP:PostPrimaryAttack()
	if IsFirstTimePredicted() then
		self:EmitGunfireSound("TFA_BO3_WAFFE.Ext")
		ParticleEffectAttach( "bo3_waffe_vm_arcs", PATTACH_POINT_FOLLOW, self.OwnerViewModel, 1)
	end
	self:DoTheLights()
end

function SWEP:DoTheLights()
	timer.Simple(0, function()
		if not IsValid(self) or not IsValid(self.OwnerViewModel) then return end
		if IsFirstTimePredicted() then
			ParticleEffectAttach("bo3_waffe_bulbs", PATTACH_POINT_FOLLOW, self.OwnerViewModel, 2)
			ParticleEffectAttach("bo3_waffe_bulbs", PATTACH_POINT_FOLLOW, self.OwnerViewModel, 3)
			ParticleEffectAttach("bo3_waffe_bulbs", PATTACH_POINT_FOLLOW, self.OwnerViewModel, 4)
			ParticleEffectAttach("bo3_waffe_bulbs_main", PATTACH_POINT_FOLLOW, self.OwnerViewModel, 5)
		end
	end)
end

function SWEP:Think2(...)
	if CLIENT and dlight_cvar:GetBool() and DynamicLight then
		if self:GetNextGlow() > CurTime() then
			self.DLight = self.DLight or DynamicLight(self:EntIndex(), false)
			if self.DLight then
				local attpos = (self:IsFirstPerson() and self.OwnerViewModel or self):GetAttachment(1)

				self.DLight.pos = (attpos and attpos.Pos) and attpos.Pos or self:GetPos()
				self.DLight.r = 200
				self.DLight.g = 250
				self.DLight.b = 220
				self.DLight.decay = 500
				self.DLight.brightness = 1
				self.DLight.size = 128
				self.DLight.dietime = CurTime() + 1
			end
		end
	end

	if not self:GetNextWave() then self:SetNextWave(CurTime() + self:SharedRandom(8, 10)) end
	if TFA.Enum.ReadyStatus[self:GetStatus()] and self:GetNextWave() < CurTime() then
		self:SetNextWave(CurTime() + self:SharedRandom(8, 12))
		self:SetNextGlow(CurTime() + 1)

		if self:VMIV() then
			ParticleEffectAttach( "bo3_waffe_idle", PATTACH_POINT_FOLLOW, self.OwnerViewModel, 1)
		end
		if IsFirstTimePredicted() then self:EmitSoundNet("TFA_BO3_WAFFE.Meow.Calm") end
	end

	return BaseClass.Think2(self, ...)
end

function SWEP:PostSpawnProjectile(ent)
	local ply = self:GetOwner()
	local phys = ent:GetPhysicsObject()
	local vel = self:GetStat("Primary.ProjectileVelocity")

	local spread = (self:GetIronSights() and Vector(0,0,0) or VectorRand(-120,120))

	if ply:IsPlayer() and IsValid(phys) then
		phys:SetVelocity((ply:GetAimVector() * vel) + spread)
	end
end

function SWEP:OnDrop(...)
	local ply = self:GetOwner()
	if SERVER and nzombies and IsValid(ply) then
		ply:SetUsingSpecialWeapon(false)
		ply:EquipPreviousWeapon()
	end
	return BaseClass.OnDrop(self,...)
end

function SWEP:OwnerChanged(...)
	local ply = self:GetOwner()
	if SERVER and nzombies and IsValid(ply) then
		ply:SetUsingSpecialWeapon(false)
		ply:EquipPreviousWeapon()
	end
	return BaseClass.OwnerChanged(self,...)
end
