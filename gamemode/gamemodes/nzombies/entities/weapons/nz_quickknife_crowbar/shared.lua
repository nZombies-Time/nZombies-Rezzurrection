SWEP.Base = "tfa_melee_base"
SWEP.Category = "TFA CS:O"
SWEP.PrintName = "Better nZombies Knife"
SWEP.Author		= "Kamikaze" --Author Tooltip
SWEP.ViewModel = "models/weapons/knife/v_knife.mdl"
SWEP.WorldModel = "models/weapons/knife/w_knife.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 80
SWEP.UseHands = true
SWEP.HoldType = "knife"
SWEP.DrawCrosshair = true

SWEP.Primary.Directional = false

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.DisableIdleAnimations = false

SWEP.Secondary.CanBash = false
SWEP.Secondary.MaxCombo = -1
SWEP.Primary.MaxCombo = -1

SWEP.VMPos = Vector(0,0,0) --The viewmodel positional offset, constantly.  Subtract this from any other modifications to viewmodel position.

-- nZombies Stuff
SWEP.NZWonderWeapon		= false	-- Is this a Wonder-Weapon? If true, only one player can have it at a time. Cheats aren't stopped, though.
--SWEP.NZRePaPText		= "your text here"	-- When RePaPing, what should be shown? Example: Press E to your text here for 2000 points.
SWEP.NZPaPName				= "Lady's Kiss"
--SWEP.NZPaPReplacement 	= "tfa_cso_dualinfinityfinal"	-- If Pack-a-Punched, replace this gun with the entity class shown here.
SWEP.NZPreventBox		= true	-- If true, this gun won't be placed in random boxes GENERATED. Users can still place it in manually.
SWEP.NZTotalBlackList	= true	-- if true, this gun can't be placed in the box, even manually, and can't be bought off a wall, even if placed manually. Only code can give this gun.


SWEP.Offset = { --Procedural world model animation, defaulted for CS:S purposes.
		Pos = {
		Up = -8.2,
		Right = 1,
		Forward = 3.5,
		},
		Ang = {
		Up = 60,
		Right = -70,
		Forward = 10
		},
		Scale = 1
}


sound.Add({
	['name'] = "Mastercombat.Hit",
	['channel'] = CHAN_STATIC,
	['sound'] = { "nz/knife/knife_slash.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Mastercombat.Slash",
	['channel'] = CHAN_STATIC,
	['sound'] = { "nz/knife/whoosh.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Mastercombat.Stab",
	['channel'] = CHAN_STATIC,
	['sound'] = { "nz/knife/knife_stab.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Mastercombat.Wall",
	['channel'] = CHAN_STATIC,
	['sound'] = { "nz/knife/hit_object.wav" },
	['pitch'] = {100,100}
})

SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 16*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(-60,0,0), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 80, --This isn't overpowered enough, I swear!!
		["dmgtype"] = bit.bor(DMG_GENERIC),  --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.15, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "Mastercombat.Slash", -- Sound ID
		['snd_delay'] = 0.01,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 0.6, --time before next attack
		['hull'] = 60, --Hullsize
		['direction'] = "W", --Swing dir,
		['hitflesh'] = "Mastercombat.Hit",
		['hitworld'] = "Mastercombat.Wall"
	},
}

SWEP.Secondary.Attacks = {
	{
		['act'] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 15*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(0,0,-40), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 80, --This isn't overpowered enough, I swear!!
		["dmgtype"] = bit.bor(DMG_GENERIC),  --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.18, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "Mastercombat.Slash", -- Sound ID
		['snd_delay'] = 0.01,
		["viewpunch"] = Angle(0,0,0), --viewpunch angle
		['end'] = 1.25, --time before next attack
		['hull'] = 60, --Hullsize
		['direction'] = "S", --Swing dir,
		['hitflesh'] = "Mastercombat.Stab",
		['hitworld'] = "Mastercombat.Wall"
	}
}
if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_mastercombatknife")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
