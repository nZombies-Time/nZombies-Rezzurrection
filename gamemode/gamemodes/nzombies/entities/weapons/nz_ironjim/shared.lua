SWEP.Base = "tfa_melee_base"
SWEP.Category = "nZombies"
SWEP.PrintName = "The Classic"
SWEP.Author		= "Kamikaze" --Author Tooltip
SWEP.ViewModel = "models/weapons/bo3/c_bo3_crowbar.mdl"
SWEP.WorldModel = "models/weapons/bo3/w_bo3_crowbar.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 80
SWEP.UseHands = true
SWEP.HoldType = "melee"
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
	['name'] = "Ironjim.Attack",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/nzr/jim/swing_1_01.wav", "weapons/nzr/jim/swing_1_02.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Ironjim.Meat",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/nzr/jim/crowbar_impact_human_00.wav", "weapons/jim/zwei/crowbar_impact_human_01.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "Ironjim.World",
	['channel'] = CHAN_STATIC,
	['sound'] = { "nz/knife/hit_object.wav" },
	['pitch'] = {100,100}
})


function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_FIDGET)
	self.HolsterTime = CurTime() + 1.8
	self:EmitSound("weapons/nzr/jim/crowbar_first_raise.wav")
end

SWEP.Primary.Attacks = {
	{
		["act"] = ACT_VM_HITCENTER, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 13 * 10, -- Trace distance
		["dir"] = Vector(0, 20, -70), -- Trace arc cast
		["dmg"] = 250, --Damage
		["dmgtype"] = bit.bor(DMG_CRUSH), --bit.bor(DMG_SLASH,DMG_ALWAYSGIB),DMG_CRUSH, etc.
		["delay"] = 0.45, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "Ironjim.Attack", -- Sound ID
		["snd_delay"] = 0.26,
		["viewpunch"] = Angle(1, -5, 0), --viewpunch angle
		["end"] = 0.8, --time before next attack
		["hull"] = 16, --Hullsize
		["direction"] = "F", --Swing dir,
		["hitflesh"] =  "Ironjim.Meat",
		["hitworld"] = "Ironjim.World"
	}
}

SWEP.Secondary.Attacks = {
		{
		["act"] = ACT_VM_HITCENTER, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 13 * 10, -- Trace distance
		["dir"] = Vector(0, 20, -70), -- Trace arc cast
		["dmg"] = 250, --Damage
		["dmgtype"] = bit.bor(DMG_CRUSH), --bit.bor(DMG_SLASH,DMG_ALWAYSGIB),DMG_CRUSH, etc.
		["delay"] = 0.45, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "Ironjim.Attack", -- Sound ID
		["snd_delay"] = 0.26,
		["viewpunch"] = Angle(1, -5, 0), --viewpunch angle
		["end"] = 0.8, --time before next attack
		["hull"] = 16, --Hullsize
		["direction"] = "F", --Swing dir,
		["hitflesh"] =  "Ironjim.Meat",
		["hitworld"] = "Ironjim.World"
	}
}
if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_mastercombatknife")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
