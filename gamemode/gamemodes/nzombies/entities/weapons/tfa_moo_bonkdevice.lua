SWEP.Base = "tfa_melee_base"
SWEP.Category = "nZombies Buyable Knives"
SWEP.Spawnable = false
SWEP.AdminSpawnable = true
SWEP.UseHands = true
SWEP.Type_Displayed = "Melee"
SWEP.Author = "YuRaNnNzZZ & FlamingFox & GhostlyMoo"
SWEP.Slot = 0
SWEP.PrintName = "Bludgeon"
SWEP.DrawCrosshair = false
SWEP.DrawCrosshairIronSights = false
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

--[Model]--

SWEP.ViewModelFOV = 65
SWEP.ViewModel = "models/weapons/tfa_cod/mwr/wpn_h1_melee_mace_vm.mdl"
SWEP.WorldModel = "models/weapons/tfa_cod/mwr/wpn_h1_melee_mace_wm.mdl"
SWEP.HoldType = "melee"
SWEP.CameraAttachmentOffsets = {}
SWEP.CameraAttachmentScale = 1
SWEP.VMPos = Vector(0, 0, 0)
SWEP.VMAng = Vector(0, 0, 0)
SWEP.VMPos_Additive = true

SWEP.Offset = {
	Pos = {
		Up = 1.5,
		Right = 1,
		Forward = 3
	},
	Ang = {
		Up = 0,
		Right = 15,
		Forward = 165
	},
	Scale = 1
}

SWEP.EventTable = {
	["h1_wpn_melee_mace_inspect"] = {
		{time = 13 / 30, type = "sound", value = "yurie_h1.smace_ins_01"},
		{time = 18 / 30, type = "sound", value = "yurie_h1.viewmodel_small"},
		{time = 52 / 30, type = "sound", value = "yurie_h1.viewmodel_small"},
		{time = 83 / 30, type = "sound", value = "yurie_h1.viewmodel_small"},
		{time = 115 / 30, type = "sound", value = "yurie_h1.smace_ins_02"},
		{time = 61 / 30, type = "sound", value = "yurie_h1.viewmodel_medium"},
		{time = 90 / 30, type = "sound", value = "yurie_h1.viewmodel_medium"},
		{time = 125 / 30, type = "sound", value = "yurie_h1.viewmodel_medium"},
	},
	["h1_wpn_melee_mace_pullout"] = {
		{time = 0 / 30, type = "sound", value = "yurie_h1.shovel_pullout"},
		{time = 11 / 30, type = "sound", value = "yurie_h1.viewmodel_small"},
	},
	["h1_wpn_melee_mace_pullout_first"] = {
		{time = 8 / 30, type = "sound", value = "yurie_h1.viewmodel_medium"},
		{time = 27 / 30, type = "sound", value = "yurie_h1.viewmodel_medium"},
		{time = 0 / 30, type = "sound", value = "yurie_h1.smace_pullout_first"},
	},
	["h1_wpn_melee_mace_putaway"] = {
		{time = 0 / 30, type = "sound", value = "yurie_h1.shovel_putaway"},
		{time = 10 / 30, type = "sound", value = "yurie_h1.viewmodel_small"},
	},
	["h1_wpn_melee_mace_stab"] = {
		{time = 0 / 30, type = "sound", value = "yurie_h1.smace_stab"},
		{time = 5 / 30, type = "sound", value = "yurie_h1.viewmodel_large"},
		{time = 8 / 30, type = "sound", value = "yurie_h1.viewmodel_small"},
		{time = 11 / 30, type = "sound", value = "yurie_h1.viewmodel_small"},
		{time = 15 / 30, type = "sound", value = "yurie_h1.viewmodel_small"},
		{time = 19 / 30, type = "sound", value = "yurie_h1.viewmodel_small"},
	},
	["h1_wpn_melee_mace_swipe"] = {
		{time = 0 / 30, type = "sound", value = "yurie_h1.smace_swipe"},
		{time = 4 / 30, type = "sound", value = "yurie_h1.viewmodel_medium"},
	},
}

--[Gun Related]--
SWEP.Primary.DamageType = DMG_SLASH
SWEP.Primary.RPM = 100
SWEP.Primary.MaxCombo = 0
SWEP.Secondary.MaxCombo = 0

--[Stuff]--
SWEP.ImpactDecal = "ManhackCut"
SWEP.InspectPos = Vector(0, 0, 0)
SWEP.InspectAng = Vector(0, 0, 0)
SWEP.Secondary.CanBash = false
SWEP.AltAttack = false
SWEP.AllowSprintAttack = true
SWEP.CanKnifeLunge = true

SWEP.NZPreventBox = true	-- If true, this gun won't be placed in random boxes GENERATED. Users can still place it in manually.
SWEP.NZTotalBlackList = true	

SWEP.Sprint_Mode = TFA.Enum.LOCOMOTION_ANI

--[Traces]--
SWEP.Primary.Attacks = {
	{
		["act"] = ACT_VM_HITLEFT,
		["len"] = 66,
		["src"] = Vector(0, -16, 0),
		["dir"] = Vector(-10, 12, 1),
		["dmg"] = 950,
		["dmgtype"] = DMG_CRUSH,
		["delay"] = 4 / 30,
		["snd"] = "yurie_h1.melee_swipe_gen",
		["snd_delay"] = 0,
		["hitflesh"] = "yurie_h1.hammer_swipe_hit",
		["hitworld"] = "yurie_h1.solid_impact",
		["viewpunch"] = Angle(0, 0, 0),
		["end"] = 1,
		["hull"] = 10,
	}
}
SWEP.Secondary.Attacks = {
	{
		["act"] = ACT_VM_HITRIGHT,
		["len"] = 99,
		["src"] = Vector(0, 0, 0),
		["dir"] = Vector(-1, 24, -2),
		["dmg"] = 950,
		["dmgtype"] = DMG_CLUB,
		["delay"] = 5 / 30,
		["snd"] = "yurie_h1.melee_swipe_gen",
		["snd_delay"] = 0,
		["hitflesh"] = "yurie_h1.hammer_stab_hit",
		["hitworld"] = "yurie_h1.solid_impact",
		["viewpunch"] = Angle(0, 0, 0),
		["end"] = 1.5,
		["hull"] = 10,
	}
}

if surface and surface.GetTextureID then
	SWEP.WepSelectIcon = surface.GetTextureID("vgui/hud/tfa_mwr_mace")
end

if killicon and killicon.Add then
	killicon.Add("tfa_mwr_mace", "vgui/killicons/tfa_mwr_mace", Color(255, 80, 0, 191))
end

if TFA and TFA.AddSound then
	local p1,p2="yurie_h1.smace_","weapons/tfa_cod/mwr/h1_dlc_wpn/melee_smace/h1_wpn_melee_smace_"
	TFA.AddSound(p1.."ins_01", CHAN_STATIC, 1, 75, 100, p2.."ins_01.ogg", ")")
	TFA.AddSound(p1.."ins_02", CHAN_STATIC, 1, 75, 100, p2.."ins_02.ogg", ")")
	TFA.AddSound(p1.."pullout_first", CHAN_STATIC, 1, 75, 100, p2.."pout_1st.ogg", ")")
	TFA.AddSound(p1.."stab", CHAN_STATIC, 1, 75, 100, p2.."stab.ogg", ")")
	TFA.AddSound(p1.."swipe", CHAN_STATIC, 1, 75, 100, p2.."swipe.ogg", ")")
end

if TFA and TFA.AddSound then
	local p1,p2 = "yurie_h1.","weapons/tfa_cod/mwr/h1_dlc_wpn/impacts/"

	TFA.AddSound(p1.."blade_stab_hit", CHAN_STATIC, 1, 75, 100, {p2.."wpn_blade_stab_hit_01.ogg",p2.."wpn_blade_stab_hit_02.ogg",p2.."wpn_blade_stab_hit_03.ogg"}, ")")
	TFA.AddSound(p1.."blade_swipe_hit", CHAN_STATIC, 1, 75, 100, {p2.."wpn_blade_swipe_hit_01.ogg",p2.."wpn_blade_swipe_hit_02.ogg",p2.."wpn_blade_swipe_hit_03.ogg"}, ")")
	TFA.AddSound(p1.."hammer_stab_hit", CHAN_STATIC, 1, 75, 100, {p2.."wpn_hammer_stab_hit_01.ogg",p2.."wpn_hammer_stab_hit_02.ogg"}, ")")
	TFA.AddSound(p1.."hammer_swipe_hit", CHAN_STATIC, 1, 75, 100, {p2.."wpn_hammer_swipe_hit_01.ogg",p2.."wpn_hammer_swipe_hit_02.ogg"}, ")")
	TFA.AddSound(p1.."shovel_swipe_hit", CHAN_STATIC, 1, 75, 100, {p2.."wpn_shovel_swipe_hit_01.ogg",p2.."wpn_shovel_swipe_hit_02.ogg"}, ")")

	p2="weapons/tfa_cod/mwr/h1_dlc_wpn/melee_gen/"
	TFA.AddSound(p1.."solid_impact", CHAN_STATIC, 1, 75, 100, {p2.."h1_melee_solid_impact_01.ogg",p2.."h1_melee_solid_impact_02.ogg",p2.."h1_melee_solid_impact_03.ogg"}, ")")

	p2="weapons/tfa_cod/mwr/h1_dlc_wpn/hatchet/"
	TFA.AddSound(p1.."melee_putaway", CHAN_STATIC, 1, 75, 100, p2.."melee_putaway_01.ogg", ")")

	p2="weapons/tfa_cod/mwr/h1_dlc_wpn/melee_stick/"
	TFA.AddSound(p1.."melee_swipe_gen", CHAN_STATIC, 1, 75, 100, {p2.."melee_swipe_gen_01.ogg",p2.."melee_swipe_gen_02.ogg",p2.."melee_swipe_gen_03.ogg",p2.."melee_swipe_gen_04.ogg"}, ")")

	-- wrong soungs I DONT FUCKING CARE as long as they fit
	p2="weapons/tfa_cod/mwr/foley/gear/"
	TFA.AddSound(p1.."viewmodel_small", CHAN_STATIC, .2, 75, {113,117}, {p2.."foley_land_gear_lt_01.ogg",p2.."foley_land_gear_lt_02.ogg",p2.."foley_land_gear_lt_03.ogg",p2.."foley_land_gear_lt_04.ogg",p2.."foley_land_gear_lt_05.ogg"}, ")")
	TFA.AddSound(p1.."viewmodel_medium", CHAN_STATIC, .3, 75, {98,102}, {p2.."foley_land_gear_med_01.ogg",p2.."foley_land_gear_med_02.ogg",p2.."foley_land_gear_med_03.ogg",p2.."foley_land_gear_med_04.ogg",p2.."foley_land_gear_med_05.ogg"}, ")")
	TFA.AddSound(p1.."viewmodel_large", CHAN_STATIC, .4, 75, {83,87}, {p2.."foley_land_gear_hv_01.ogg",p2.."foley_land_gear_hv_02.ogg",p2.."foley_land_gear_hv_03.ogg",p2.."foley_land_gear_hv_04.ogg",p2.."foley_land_gear_hv_05.ogg"}, ")")
end


--[Coding]--
DEFINE_BASECLASS( SWEP.Base )

local devcon = GetConVar("developer")

function SWEP:SetupDataTables()
	BaseClass.SetupDataTables(self)

	self:NetworkVarTFA("Bool", "Lunging")
	self:NetworkVarTFA("Bool", "Stabbed")
end

function SWEP:AdjustMouseSensitivity()
	if self:GetLunging() then
		return 0.25
	end
	if self:GetStatus() ~= TFA.Enum.STATUS_SHOOTING and self:GetNextPrimaryFire() > CurTime() and self:GetStabbed() then
		return math.Clamp(CurTime()/self:GetNextPrimaryFire(), 0.2, 1)
	end
end

local l_CT = CurTime
local sp = game.SinglePlayer()

function SWEP:PrimaryAttack(...)
	local ply = self:GetOwner()
	local pos = ply:GetShootPos()
	local aim = self:GetAimVector()

	if ply:IsPlayer() then
		ply:LagCompensation(true)
	end

	local tr = util.TraceHull({
		start = pos,
		endpos = pos + (aim * 120),
		filter = ply,
		mins = Vector(-10, -5, 0),
		maxs = Vector(10, 5, 5),
		mask = MASK_SHOT_HULL,
	})

	if ply:IsPlayer() then
		ply:LagCompensation(false)
	end

	local ent = tr.Entity
	if IsValid(ent) and (ent:IsNPC() or ent:IsNextBot() or ent:IsPlayer()) then
		local speed = ply:GetVelocity():Length()
		local dist = ply:GetPos():DistToSqr(ent:GetPos())

		local range = 60
		local maxrange = 120
		local maxspeed = ply:GetRunSpeed()/2

		local diff = maxrange - range
		range = math.Clamp((range + diff) * (speed/maxspeed), range, maxrange)

		if dist <= range^2 and speed > maxspeed then
			//self:SendViewModelAnim(ACT_VM_HITRIGHT)
			self:SetLunging(true)
			self:SetStabbed(true)
			if ent:Health() > 0 then
				ply:SetKnifingTarget(ent)
				if devcon:GetInt() > 0 then
					ply:PrintMessage(2, tostring(ply:GetKnifingTarget()))
				end
			end
			return self:SecondaryAttack()
		end
	end

	return BaseClass.PrimaryAttack(self, ...)
end

function SWEP:Think2()
	local ply = self:GetOwner()
	local status = self:GetStatus()
	local statusend = CurTime() > self:GetStatusEnd()

	if status == TFA.Enum.STATUS_SHOOTING and self:GetLunging() then
		if statusend then
			self:SetLunging(false)
		end
	end

	if self:GetStabbed() and status ~= TFA.Enum.STATUS_SHOOTING and CurTime() > self:GetNextPrimaryFire() then
		self:SetStabbed(false)
	end

	if IsValid(ply) and self:Clip1() <= 0 and self:Ammo1() > 0 and self:GetNextPrimaryFire() <= CurTime() and self.Primary.ClipSize > 0 then
		self:Reload(true)
	end

	return BaseClass.Think2(self)
end

function SWEP:Hoslter(...)
	if self:GetLunging() then
		return false
	end

	return BaseClass.Hoslter(self, ...)
end
