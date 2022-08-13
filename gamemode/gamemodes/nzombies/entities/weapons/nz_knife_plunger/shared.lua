SWEP.Base = "tfa_melee_base"
SWEP.Category = "nZombies Buyable Knives"
SWEP.PrintName = "Plunger"
SWEP.Author		= "Laby" --Author Tooltip
SWEP.ViewModel = "models/weapons/nz_knives/c_plunger.mdl"
SWEP.WorldModel = "models/weapons/tfa_bo3/plunger/w_plunger.mdl"
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


SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_HITRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 20*10, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["src"] = Vector(0, 0, 0), -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dir"] = Vector(0, 35,0), -- Trace direction/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 90, --This isn't overpowered enough, I swear!!
		["dmgtype"] = bit.bor(DMG_CLUB),  --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 10 / 30, --Delay
		['snd_delay'] = 9 / 30,
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "weapons/tfa_bo3/plunger/swing_foley_1_00.wav","weapons/tfa_bo3/plunger/swing_foley_1_01.wav",  -- Sound ID
		["viewpunch"] = Angle(0, 0, 0), --viewpunch angle
		["end"] = 2, --time before next attack
		["hull"] = 1, --Hullsize
		['hitflesh'] = "weapons/tfa_bo3/plunger/plunger_hit_00.wav","weapons/tfa_bo3/plunger/plunger_hit_01.wav","weapons/tfa_bo3/plunger/plunger_hit_02.wav","weapons/tfa_bo3/plunger/plunger_hit_03.wav",
		['hitworld'] ="weapons/tfa_bo3/plunger/plunger_hit_00.wav","weapons/tfa_bo3/plunger/plunger_hit_01.wav","weapons/tfa_bo3/plunger/plunger_hit_02.wav","weapons/tfa_bo3/plunger/plunger_hit_03.wav"
	},
	{
		['act'] = ACT_VM_HITCENTER, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 20*10, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["src"] = Vector(0, 0, 0), -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dir"] = Vector(0, 35, 0), -- Trace direction/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 90, --This isn't overpowered enough, I swear!!
		["dmgtype"] = bit.bor(DMG_CLUB),  --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 7 / 30, --Delay
		['snd_delay'] = 6 / 30,
		['spr'] = true, --Allow attack while sprinting?
		['snd'] ="weapons/tfa_bo3/plunger/swing_foley_1_00.wav","weapons/tfa_bo3/plunger/swing_foley_1_01.wav", -- Sound ID
		["viewpunch"] = Angle(0, 0, 0), --viewpunch angle
		["end"] = 1, --time before next attack
		["hull"] = 1, --Hullsize
		['hitflesh'] = "weapons/tfa_bo3/plunger/plunger_hit_00.wav","weapons/tfa_bo3/plunger/plunger_hit_01.wav","weapons/tfa_bo3/plunger/plunger_hit_02.wav","weapons/tfa_bo3/plunger/plunger_hit_03.wav",
		['hitworld'] ="weapons/tfa_bo3/plunger/plunger_hit_00.wav","weapons/tfa_bo3/plunger/plunger_hit_01.wav","weapons/tfa_bo3/plunger/plunger_hit_02.wav","weapons/tfa_bo3/plunger/plunger_hit_03.wav"
	}
}

SWEP.ImpactDecal = "ManhackCut"

SWEP.SequenceRateOverride = {
	
}


if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_mastercombatknife")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
