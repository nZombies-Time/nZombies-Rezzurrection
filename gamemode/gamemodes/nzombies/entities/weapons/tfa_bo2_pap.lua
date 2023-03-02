local nzombies = engine.ActiveGamemode() == "nzombies"

SWEP.Base = "tfa_gun_base"
SWEP.Category = "TFA Zombies Buildables"
SWEP.Spawnable = TFA_BASE_VERSION and TFA_BASE_VERSION >= 4.74
SWEP.AdminSpawnable = true
SWEP.UseHands = false
SWEP.Type_Displayed = "Machine"
SWEP.Purpose = "M1 to place, what the fuck."
SWEP.Author = "FlamingFox"
SWEP.Slot = 0
SWEP.PrintName = "A fucking Pack a' Punch machine"
SWEP.DrawCrosshair = false
SWEP.DrawCrosshairIS = false
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = true

--[Model]--
SWEP.ViewModel			= "models/nzr/2022/machines/pap/vending_pap.mdl"
SWEP.ViewModelFOV = 65
SWEP.WorldModel			= "models/nzr/2022/machines/pap/vending_pap.mdl"
SWEP.HoldType = "slam"
SWEP.SprintHoldTypeOverride = "slam"
SWEP.CameraAttachmentOffsets = {}
SWEP.CameraAttachmentScale = 2
SWEP.VMPos = Vector(0, 0, 0)
SWEP.VMAng = Vector(0, 0, 0)
SWEP.VMPos_Additive = true

SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
	Pos = {
	Up = 0,
	Right = 0,
	Forward = 0,
	},
	Ang = {
	Up = -180,
	Right = -180,
	Forward = 0
	},
	Scale = 0.9
}

--[Gun Related]--
SWEP.Primary.Sound = ""
SWEP.Primary.Ammo = "none"
SWEP.Primary.RPM = 100
SWEP.Primary.Damage = 115
SWEP.Primary.ClipSize = 100
SWEP.Primary.DefaultClip = 100
SWEP.Primary.AmmoConsumption = 0
SWEP.DisableChambering = true
SWEP.FiresUnderwater = false
SWEP.Delay = 0.1

--[Firemode]--
SWEP.Primary.BurstDelay = nil
SWEP.DisableBurstFire = true
SWEP.SelectiveFire = false
SWEP.OnlyBurstFire = false
SWEP.BurstFireCount = nil

--[LowAmmo]--
SWEP.FireSoundAffectedByClipSize = false
SWEP.LowAmmoSoundThreshold = 0.33 --0.33
SWEP.LowAmmoSound = nil
SWEP.LastAmmoSound = nil

--[Range]--
SWEP.Primary.Range = -1
SWEP.Primary.RangeFalloff = -1
SWEP.Primary.DisplayFalloff = false
SWEP.DisplayFalloff = false

--[Spread Related]--
SWEP.Primary.Spread		  = .00
SWEP.Primary.IronAccuracy = .00
SWEP.IronRecoilMultiplier = 0.8

SWEP.Primary.KickUp				= 0.0
SWEP.Primary.KickDown 			= 0.0
SWEP.Primary.KickHorizontal		= 0.0
SWEP.Primary.StaticRecoilFactor = 0.0

SWEP.Primary.SpreadMultiplierMax = 5
SWEP.Primary.SpreadIncrement = 0
SWEP.Primary.SpreadRecovery = 5

--[Iron Sights]--
SWEP.data = {}
SWEP.data.ironsights = 0

--[Shells]--
SWEP.LuaShellEject = false
SWEP.LuaShellScale = 0
SWEP.EjectionSmokeEnabled = false

--[Projectile]--
SWEP.Primary.Projectile         = "perk_machine"
SWEP.Primary.ProjectileVelocity = 0
SWEP.Primary.ProjectileModel    = "models/nzr/2022/machines/pap/vending_pap.mdl"

--[Stuff]--
SWEP.InspectPos = Vector(0, 0, -1)
SWEP.InspectAng = Vector(0, 0, 15)
SWEP.AllowSprintAttack = true
SWEP.RunSightsPos = Vector(0, 0, 0)
SWEP.RunSightsAng = Vector(0, 0, 0)
SWEP.DoMuzzleFlash = false
SWEP.SmokeParticle = ""

--[NZombies]--
SWEP.NZWonderWeapon = false
SWEP.NZSpecialCategory = "shield"
SWEP.NZSpecialWeaponData = {MaxAmmo = 0, AmmoType = "none"}
SWEP.NZHudIcon = Material("vgui/icon/zom_hud_icon_buildable_item_papbody.png", "unlitgeneric smooth")

SWEP.SpeedColaFactor = 1
SWEP.SpeedColaActivities = {
	[ACT_VM_RELOAD] = true,
	[ACT_VM_RELOAD_EMPTY] = true,
	[ACT_VM_RELOAD_SILENCED] = true,
}

function SWEP:NZSpecialHolster(wep)
	return true
end

--[Tables]--
SWEP.SequenceRateOverride = {
}

SWEP.EventTable = {
[ACT_VM_DRAW] = {
{ ["time"] = 5 / 30, ["type"] = "sound", ["value"] = Sound("TFA_BO2_SHIELD.Recover") },
},
[ACT_VM_HOLSTER] = {
{ ["time"] = 0, ["type"] = "sound", ["value"] = Sound("TFA_BO2_SHIELD.Recover") },
},
}

--[Shit]--
SWEP.AllowViewAttachment = true --Allow the view to sway based on weapon attachment while reloading or drawing, IF THE CLIENT HAS IT ENABLED IN THEIR CONVARS.
SWEP.Sprint_Mode = TFA.Enum.LOCOMOTION_LUA -- ANI = mdl, HYBRID = ani + lua, Lua = lua only
SWEP.Sights_Mode = TFA.Enum.LOCOMOTION_LUA -- ANI = mdl, HYBRID = lua but continue idle, Lua = stop mdl animation
SWEP.Idle_Mode = TFA.Enum.IDLE_BOTH --TFA.Enum.IDLE_DISABLED = no idle, TFA.Enum.IDLE_LUA = lua idle, TFA.Enum.IDLE_ANI = mdl idle, TFA.Enum.IDLE_BOTH = TFA.Enum.IDLE_ANI + TFA.Enum.IDLE_LUA
SWEP.Idle_Blend = 0.25 --Start an idle this far early into the end of a transition
SWEP.Idle_Smooth = 0.05 --Start an idle this far early into the end of another animation
SWEP.SprintBobMult = 0

SWEP.ReachDistance = 64

DEFINE_BASECLASS(SWEP.Base)

function SWEP:CalcViewModelView(vm, oldeyepos, oldeyeang, eyepos, eyeang)
	return self:SetupPlaceable(true)[1], self:SetupPlaceable(true)[2]
end

function SWEP:PreSpawnProjectile(ent)
	ent:SetPerkID("pap")

	ent:PhysicsInit(SOLID_NONE)
	ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
	ent:SetSolid(SOLID_VPHYSICS)

	ent:SetPos(self:SetupPlaceable()[1] + Vector(0,0,1))
	ent:SetAngles(self:SetupPlaceable()[2])
end

function SWEP:PostSpawnProjectile(ent)
	ent:EmitSound("TFA_BO2_SHIELD.Plant")

	ent:PhysicsInit(SOLID_NONE)
	ent:SetCollisionGroup(COLLISION_GROUP_WORLD)
	ent:SetSolid(SOLID_VPHYSICS)
	ent:Update()

	if nzElec:IsOn() then
		ent:TurnOn()
	end

	ent.OnUsed = function(self, ply)
		if CLIENT then return end
		if not IsValid(ply) then return end
		if self:GetActive() then return end
		if self:GetBeingUsed() then return end
		if ply:HasWeapon("tfa_bo2_pap") then return end

		ply:Give("tfa_bo2_pap")
		util.ScreenShake(self:GetPos(), 10, 255, 0.5, 150)
		self:EmitSound("TFA_BO2_SHIELD.Pickup")
		self:Remove()
	end
end

function SWEP:PostPrimaryAttack()
	local ply = self:GetOwner()

	if SERVER then
		if nzombies then
			ply:SetUsingSpecialWeapon(false)
			ply:EquipPreviousWeapon()
		end
		timer.Simple(0, function()
			if not IsValid(ply) or not IsValid(self) then return end
			ply:StripWeapon(self:GetClass())
		end)
	end
end

function SWEP:SetupPlaceable(vm)	
	local ply = self:GetOwner()
	if not IsValid(ply) then return end

	local pos = ply:GetShootPos()
	local aim = ply:GetAimVector():Angle()
	local ang = Angle(0, aim.yaw, aim.roll)

	local start = ply:GetShootPos() + (ang:Forward() * self.ReachDistance)
	local tr = util.QuickTrace(start, Vector(0,0,-128), {ply, self})

	if tr.HitWorld then
		return {tr.HitPos, ang - Angle(0,180,0), false}
	end

	return {ply:GetPos(), ang - Angle(0,180,0), false}
end

if CLIENT then
	local WorldModel = ClientsideModel(SWEP.WorldModel)
	WorldModel:SetSkin(1)
	WorldModel:SetNoDraw(true)

	function SWEP:DrawWorldModel()
		local ply = self:GetOwner()

		if IsValid(ply) then
			local aim = ply:GetAimVector():Angle()
			local ang = Angle(0, aim.yaw, aim.roll)

			WorldModel:SetPos(ply:GetPos() + (ang:Forward() * self.ReachDistance))
			WorldModel:SetAngles(ang - Angle(0,180,0))
            WorldModel:SetupBones()
		else
			WorldModel:SetPos(self:GetPos())
			WorldModel:SetAngles(self:GetAngles())
		end

		WorldModel:DrawModel()
	end
end