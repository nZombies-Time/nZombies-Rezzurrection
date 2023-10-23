SWEP.Base = "tfa_melee_base"
SWEP.Category = "nZombies Knives"
SWEP.PrintName = "Krauser's Knife"
SWEP.Author		= "Laby" --Author Tooltip
SWEP.ViewModel = "models/weapons/c_knife_krauser.mdl"
SWEP.WorldModel ="models/weapons/krauser_knife.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 51
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

SWEP.VMPos = Vector(0,2,0) --The viewmodel positional offset, constantly.  Subtract this from any other modifications to viewmodel position.

-- nZombies Stuff
SWEP.NZPreventBox		= true	-- If true, this gun won't be placed in random boxes GENERATED. Users can still place it in manually.
SWEP.NZTotalBlackList	= true	-- if true, this gun can't be placed in the box, even manually, and can't be bought off a wall, even if placed manually. Only code can give this gun.


	
	SWEP.Offset = {
	Pos = {
		Up = 2,
		Right = 2,
		Forward = 3
	},
	Ang = {
		Up = -1,
		Right = -2,
		Forward = 0
	},
	Scale = 1
}

SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 22*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["src"] = Vector(0, 0, 0), -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dir"] = Vector(0, 5, 0), -- Trace arc cast
		['dmg'] = 75, --This isn't overpowered enough, I swear!!
		["dmgtype"] = bit.bor(DMG_CRUSH),  --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 4 / 30, --Delay
		['snd_delay'] = 14 / 30,
		['spr'] = true, --Allow attack while sprinting?
		["snd"] = "re4knife.miss", -- Sound ID
		["viewpunch"] = Angle(0, 0, 0), --viewpunch angle
		["end"] = 0.5, --time before next attack
		["hull"] = 1, --Hullsize
		["direction"] = "L", --Swing dir,
		["hitflesh"] = "re4Weapon_Knife.Hit",
		["hitworld"] = "re4Weapon_Knife.Hitwall"
	},
	{
		['act'] = ACT_VM_SECONDARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 18*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["src"] = Vector(0, 0, 0), -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dir"] = Vector(0, 0, 0), -- Trace arc cast
		['dmg'] = 125, --This isn't overpowered enough, I swear!!
		["dmgtype"] = bit.bor(DMG_CRUSH),  --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 8 / 30, --Delay
		['snd_delay'] = 7 / 30, --Delay
		['spr'] = true, --Allow attack while sprinting?
		["snd"] = "re4knife.miss", -- Sound ID
		["viewpunch"] = Angle(0, 0, 0), --viewpunch angle
		["end"] = 0.5, --time before next attack
		["hull"] = 1, --Hullsize
		["hitflesh"] = "re4Weapon_Knife.Hit",
		["hitworld"] = "re4Weapon_Knife.Hitwall"
	}
}

SWEP.ImpactDecal = "ManhackCut"

SWEP.SequenceRateOverride = {
	[ACT_VM_PRIMARYATTACK] = 40 / 30,
	[ACT_VM_HITCENTER] = 40 / 30
}

if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_mastercombatknife")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
