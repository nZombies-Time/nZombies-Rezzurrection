SWEP.Base = "tfa_melee_base"
SWEP.Category = "nZombies Buyable Knives"
SWEP.PrintName = "Sickle"
SWEP.Author		= "Laby" --Author Tooltip
SWEP.ViewModel = "models/weapons/bo3_melees/sickle/c_sickle_nz.mdl"
SWEP.WorldModel = "models/weapons/bo3_melees/sickle/w_sickle.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 70
SWEP.UseHands = true
SWEP.HoldType = "knife"
SWEP.DrawCrosshair = true

SWEP.Primary.Directional = false

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.DisableIdleAnimations = true

SWEP.Secondary.CanBash = false
SWEP.Secondary.MaxCombo = 0
SWEP.Primary.MaxCombo = 0

SWEP.VMPos = Vector(0,0,0) --The viewmodel positional offset, constantly.  Subtract this from any other modifications to viewmodel position.

-- nZombies Stuff
SWEP.NZPreventBox		= true	-- If true, this gun won't be placed in random boxes GENERATED. Users can still place it in manually.
SWEP.NZTotalBlackList	= true	-- if true, this gun can't be placed in the box, even manually, and can't be bought off a wall, even if placed manually. Only code can give this gun.


SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
        Pos = {
        Up = 0,
        Right = 1.2,
        Forward = 3,
        },
        Ang = {
		Up = -90,
        Right = 0,
        Forward = 90
        },
		Scale = 1
}

SWEP.EventTable = {
	["draw_first"] = {
		{time = 1 / 30, type = "sound", value = "Weapon_BO3_ZMBOWIE.Start"},
		{time = 20 / 30, type = "sound", value = "Weapon_BO3_ZMBOWIE.Toss"},
		{time = 28 / 30, type = "sound", value = "Weapon_BO3_ZMBOWIE.Catch"},
	}
}
function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW_DEPLOYED)
	self.HolsterTime = CurTime() + (45/30)
	
end
SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_MISSCENTER, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 18*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["src"] = Vector(0, 0, 0), -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dir"] = Vector(40, 0, -2), -- Trace direction/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 250, --This isn't overpowered enough, I swear!!
		["dmgtype"] = bit.bor(DMG_SLASH),  --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 15 / 30, --Delay
		['snd_delay'] = 14 / 30,
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "Weapon_BO3_ZMBOWIE.Swing", -- Sound ID
		["viewpunch"] = Angle(0, 0, 0), --viewpunch angle
		["end"] = 1.3, --time before next attack
		["hull"] = 1, --Hullsize
		['hitflesh'] = "Weapon_BO3_ZMBOWIE.Hit_Flesh",
		['hitworld'] ="Weapon_BO3_KNIFE.Hit"
	},
	{
		['act'] = ACT_VM_HITCENTER, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 18*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["src"] = Vector(0, 0, 0), -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dir"] = Vector(0, 35, 0), -- Trace direction/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 250, --This isn't overpowered enough, I swear!!
		["dmgtype"] = bit.bor(DMG_SLASH),  --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 7 / 30, --Delay
		['snd_delay'] = 6 / 30,
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "Weapon_BO3_ZMBOWIE.Swing", -- Sound ID
		["viewpunch"] = Angle(0, 0, 0), --viewpunch angle
		["end"] = 1, --time before next attack
		["hull"] = 1, --Hullsize
		['hitflesh'] = "Weapon_BO3_ZMBOWIE.Hit_Flesh",
		['hitworld'] ="Weapon_BO3_KNIFE.Hit"
	}
}

SWEP.ImpactDecal = "ManhackCut"

SWEP.SequenceRateOverride = {
	[ACT_VM_DRAW_DEPLOYED] = 22 / 30,
	[ACT_VM_MISSCENTER] = 45 / 30
}

if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_mastercombatknife")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
