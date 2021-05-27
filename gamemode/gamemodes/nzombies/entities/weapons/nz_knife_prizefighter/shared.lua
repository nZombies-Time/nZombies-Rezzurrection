SWEP.Base = "tfa_melee_base"
SWEP.Category = "nZombies Buyable Knives"
SWEP.PrintName = "Prizefighter"
SWEP.Author		= "Laby" --Author Tooltip
SWEP.ViewModel = "models/weapons/bo3_melees/boxing/c_boxing_NZ.mdl"
SWEP.WorldModel = "models/weapons/bo3_melees/boxing/w_boxing.mdl"
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
SWEP.NZPreventBox		= true	-- If true, this gun won't be placed in random boxes GENERATED. Users can still place it in manually.


SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
        Pos = {
        Up = -0.2,
        Right = 2,
        Forward = 3,
        },
        Ang = {
		Up = -90,
        Right = 180,
        Forward = -15
        },
		Scale = 1
}

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW_DEPLOYED)
	self.HolsterTime = CurTime() + (45/30)
			self:EmitSound("Weapon_BO3_BOXING.Draw")
	
end

SWEP.Primary.Attacks = {
	{
		["act"] = ACT_VM_MISSRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 16*5, -- Trace distance
		["src"] = Vector(0, 0, 0), -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dir"] = Vector(3, 35, 0), -- Trace direction/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dmg"] = 200, --Damage
		["dmgtype"] = bit.bor(DMG_CLUB), 
		["delay"] = 8 / 30, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "Weapon_BO3_BOXING.Swing", -- Sound ID
		["hitflesh"] = "Weapon_BO3_BOXING.Hit_Flesh",
		["hitworld"] = "Weapon_BO3_FISTS.Hit",
		["viewpunch"] = Angle(0, 0, 0), --viewpunch angle
		["end"] = 1.15, --time before next attack
		["hull"] = 10, --Hullsize
	},
	{
		["act"] = ACT_VM_MISSLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 16*5, -- Trace distance
		["src"] = Vector(0, 0, 0), -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dir"] = Vector(-3, 35, 0), -- Trace direction/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dmg"] = 200, --Damage
		["dmgtype"] = bit.bor(DMG_CLUB), 
		["delay"] = 8 / 30, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "Weapon_BO3_BOXING.Swing", -- Sound ID
		["hitflesh"] = "Weapon_BO3_BOXING.Hit_Flesh",
		["hitworld"] = "Weapon_BO3_FISTS.Hit",
		["viewpunch"] = Angle(0, 0, 0), --viewpunch angle
		["end"] = 1, --time before next attack
		["hull"] = 10, --Hullsize
	},
	{
		["act"] = ACT_VM_HITLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 16*5, -- Trace distance
		["src"] = Vector(0, 0, 0), -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dir"] = Vector(-35, 5, 25), -- Trace direction/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dmg"] = 300, --Damage
		["dmgtype"] = bit.bor(DMG_CLUB), 
		["delay"] = 11 / 30, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "Weapon_BO3_BOXING.Swing", -- Sound ID
		["hitflesh"] = "Weapon_BO3_BOXING.Hit_Flesh",
		["hitworld"] = "Weapon_BO3_FISTS.Hit",
		["viewpunch"] = Angle(0, 0, 0), --viewpunch angle
		["end"] = 1.35, --time before next attack
		["hull"] = 10, --Hullsize
	},
	{
		["act"] = ACT_VM_HITRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 16*5, -- Trace distance
		["src"] = Vector(0, 0, 0), -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dir"] = Vector(35, 5, 25), -- Trace direction/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dmg"] = 300, --Damage
		["dmgtype"] = bit.bor(DMG_CLUB), 
		["delay"] = 11 / 30, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "Weapon_BO3_BOXING.Swing", -- Sound ID
		["hitflesh"] = "Weapon_BO3_BOXING.Hit_Flesh",
		["hitworld"] = "Weapon_BO3_FISTS.Hit",
		["viewpunch"] = Angle(0, 0, 0), --viewpunch angle
		["end"] = 1.35, --time before next attack
		["hull"] = 10, --Hullsize
	}
	
}

SWEP.SequenceRateOverride = {
	[ACT_VM_MISSLEFT] = 45 / 30,
	[ACT_VM_MISSRIGHT] = 45 / 30,
	[ACT_VM_HITRIGHT] = 45 / 30,
	[ACT_VM_HITLEFT] = 45 / 30
}


if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_mastercombatknife")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
