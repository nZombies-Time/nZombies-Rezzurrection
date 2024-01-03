SWEP.Base = "tfa_melee_base"
SWEP.Category = "nZombies Buyable Knives"
SWEP.PrintName = "Nunchaku"
SWEP.Author		= "Laby" --Author Tooltip
SWEP.ViewModel = "models/weapons/bo3_melees/nunchucks/c_nunchucks_nz.mdl"
SWEP.WorldModel = "models/weapons/bo3_melees/nunchucks/w_nunchucks.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 70
SWEP.UseHands = true
SWEP.HoldType = "fist"
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


SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
        Pos = {
        Up = -2,
        Right = 1.35,
        Forward = 3.5,
        },
        Ang = {
		Up = 0,
        Right = 0,
        Forward = -90
        },
		Scale = 1
}

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW_DEPLOYED)
	self.HolsterTime = CurTime() + (45/30)
	
end

SWEP.Primary.Attacks = {
	{
		["act"] = ACT_VM_MISSCENTER, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 20*5, -- Trace distance
		["src"] = Vector(0, 0, 0), -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dir"] = Vector(-40, 10, -5), -- Trace direction/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dmg"] = 250, --Damage
		["dmgtype"] = bit.bor(DMG_CLUB),  --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 10 / 30, --Delay
		['snd_delay'] = 11 / 30,
		["spr"] = true, --Allow attack while sprinting?
		['snd'] = "weapons/bo3_melees/nunchucks/melee_nunchucks_whoosh_00.wav" , -- Sound ID
		['hitflesh'] = "Weapon_BO3_NUNCHUCKS.Hit_Flesh",
		['hitworld'] ="Weapon_BO3_NUNCHUCKS.Hit",
		["viewpunch"] = Angle(0, 0, 0), --viewpunch angle
		["end"] = 1.25, --time before next attack
		["hull"] = 1, --Hullsize
	}
}

SWEP.EventTable = {
	["draw_first"] = {
		{time = 1 / 30, type = "sound", value = "Weapon_BO3_NUNCHUCKS.Draw"}
	}
}


if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_mastercombatknife")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
