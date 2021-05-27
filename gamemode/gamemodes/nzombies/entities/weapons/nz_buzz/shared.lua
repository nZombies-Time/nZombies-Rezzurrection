SWEP.Base = "tfa_melee_base"
SWEP.Category = "nZombies Buyable Knives"
SWEP.PrintName = "Bushwacker"
SWEP.Author		= "Kamikaze" --Author Tooltip
SWEP.ViewModel	= "models/weapons/c_tdon_buzz.mdl"
SWEP.WorldModel	= "models/weapons/w_bush.mdl"
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
--SWEP.NZPaPReplacement 	= "tfa_cso_dualinfinityfinal"	-- If Pack-a-Punched, replace this gun with the entity class shown here.-- if true, this gun can't be placed in the box, even manually, and can't be bought off a wall, even if placed manually. Only code can give this gun.


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
	['name'] = "Bushwacker.Attack",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/nzr/buzz/chainsaw_strike_00.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "TFA_KF2_ZWEIHANDER.HitFlesh3",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/nzr/zwei/hitflesh_3.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "TFA_KF2_ZWEIHANDER.HitWorld",
	['channel'] = CHAN_STATIC,
	['sound'] = { "nz/knife/hit_object.wav" },
	['pitch'] = {100,100}
})


function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
	self.HolsterTime = CurTime() + 1.5
	self:EmitSound("weapons/nzr/buzz/chainsaw_firstraise.wav")
end
SWEP.Primary.Attacks = {
	{
		["act"] = ACT_VM_HITCENTER, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 11 * 10, -- Trace distance
		["dir"] = Vector(120, 0, 0), -- Trace arc cast
		["dmg"] = 450, --Damage
		["dmgtype"] = bit.bor(DMG_GENERIC),  --bit.bor(DMG_SLASH,DMG_ALWAYSGIB),DMG_CRUSH, etc.
		["delay"] = 0.15, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "Bushwacker.Attack", -- Sound ID
		["snd_delay"] = 0.01,
		["viewpunch"] = Angle(1, -5, 0), --viewpunch angle
		["end"] = 0.8, --time before next attack
		["hull"] = 16, --Hullsize
		["direction"] = "L", --Swing dir,
		["hitflesh"] = "TFA_KF2_ZWEIHANDER.HitFlesh3",
		["hitworld"] = "TFA_KF2_ZWEIHANDER.HitWorld"
	}
}

SWEP.Secondary.Attacks = {
	{
		["act"] = ACT_VM_HITCENTER, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 11 * 10, -- Trace distance
		["dir"] = Vector(120, 0, 0), -- Trace arc cast
		["dmg"] = 450, --Damage
		["dmgtype"] = bit.bor(DMG_GENERIC),  --bit.bor(DMG_SLASH,DMG_ALWAYSGIB),DMG_CRUSH, etc.
		["delay"] = 0.45, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "Bushwacker.Attack", -- Sound ID
		["snd_delay"] = 0.26,
		["viewpunch"] = Angle(1, -5, 0), --viewpunch angle
		["end"] = 0.8, --time before next attack
		["hull"] = 16, --Hullsize
		["direction"] = "L", --Swing dir,
		["hitflesh"] = "TFA_KF2_ZWEIHANDER.HitFlesh3",
		["hitworld"] = "TFA_KF2_ZWEIHANDER.HitWorld"
	}
}
if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_mastercombatknife")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
