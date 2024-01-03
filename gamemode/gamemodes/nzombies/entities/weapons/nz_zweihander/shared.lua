SWEP.Base = "tfa_melee_base"
SWEP.Category = "nZombies Buyable Knives"
SWEP.PrintName = "Zweihander"
SWEP.Author		= "Kamikaze" --Author Tooltip
SWEP.ViewModel	= "models/weapons/tfa_kf2/c_zweihander.mdl"
SWEP.WorldModel	= "models/weapons/tfa_kf2/w_zweihander.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 80
SWEP.UseHands = true
SWEP.HoldType = "melee2"
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
	['name'] = "TFA_KF2_ZWEIHANDER.Swing1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/melee/zwei/swing_hard_1.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "TFA_KF2_ZWEIHANDER.Swing2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/melee/zwei/swing_hard_2.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "TFA_KF2_ZWEIHANDER.Swing3",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/melee/zwei/swing_hard_3.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "TFA_KF2_ZWEIHANDER.Swing4",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/melee/zwei/swing_hard_4.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "TFA_KF2_ZWEIHANDER.HitFlesh2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/melee/zwei/hitflesh_2.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "TFA_KF2_ZWEIHANDER.HitFlesh3",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/melee/zwei/hitflesh_3.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "TFA_KF2_ZWEIHANDER.HitFlesh1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/melee/zwei/hitflesh_1.ogg" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "TFA_KF2_ZWEIHANDER.HitWorld",
	['channel'] = CHAN_STATIC,
	['sound'] = { "nz/knife/hit_object.wav" },
	['pitch'] = {100,100}
})


function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_RECOIL1)
	self.HolsterTime = CurTime() + 2.5
	timer.Simple(1, function()
		if IsValid(self) then
			self:EmitSound("weapons/melee/zwei/unsheath_fast_"..math.random(1,2)..".ogg")
		end
	end)
end
SWEP.Primary.Attacks = {
	{
		["act"] = ACT_VM_HITLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 20 * 10, -- Trace distance
		["dir"] = Vector(120, 0, 0), -- Trace arc cast
		["dmg"] = 450, --Damage
		["dmgtype"] = bit.bor(DMG_SLASH), --bit.bor(DMG_SLASH,DMG_ALWAYSGIB),DMG_CRUSH, etc.
		["delay"] = 0.45, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "TFA_KF2_ZWEIHANDER.Swing1", -- Sound ID
		["snd_delay"] = 0.26,
		["viewpunch"] = Angle(1, -5, 0), --viewpunch angle
		["end"] = 0.8, --time before next attack
		["hull"] = 16, --Hullsize
		["direction"] = "R", --Swing dir,
		["hitflesh"] = "TFA_KF2_ZWEIHANDER.HitFlesh3",
		["hitworld"] = "TFA_KF2_ZWEIHANDER.HitWorld"
	},
	{
		["act"] = ACT_VM_HITRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 20 * 10,  -- Trace distance
		["dir"] = Vector(-120, 0, 0), -- Trace arc cast
		["dmg"] = 450, --Damage
		["dmgtype"] = bit.bor(DMG_SLASH),  --bit.bor(DMG_SLASH,DMG_ALWAYSGIB),DMG_CRUSH, etc.
		["delay"] = 0.45, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "TFA_KF2_ZWEIHANDER.Swing2", -- Sound ID
		["snd_delay"] = 0.26,
		["viewpunch"] = Angle(1, 5, 0), --viewpunch angle
		["end"] = 0.8, --time before next attack
		["hull"] = 16, --Hullsize
		["direction"] = "L", --Swing dir,
		["hitflesh"] = "TFA_KF2_ZWEIHANDER.HitFlesh2",
		["hitworld"] = "TFA_KF2_ZWEIHANDER.HitWorld"
	},
	{
		["act"] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 20 * 10,  -- Trace distance
		["dir"] = Vector(0, 20, -70), -- Trace arc cast
		["dmg"] = 450, --Damage
		["dmgtype"] = bit.bor(DMG_SLASH),  --bit.bor(DMG_SLASH,DMG_ALWAYSGIB),DMG_CRUSH, etc.
		["delay"] = 0.45, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "TFA_KF2_ZWEIHANDER.Swing3", -- Sound ID
		["snd_delay"] = 0.26,
		["viewpunch"] = Angle(5, 0, 0), --viewpunch angle
		["end"] = 0.8, --time before next attack
		["hull"] = 16, --Hullsize
		["direction"] = "F", --Swing dir,
		["hitflesh"] = "TFA_KF2_ZWEIHANDER.HitFlesh1",
		["hitworld"] = "TFA_KF2_ZWEIHANDER.HitWorld"
	},
	{
		["act"] = ACT_VM_PULLBACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 20 * 10,  -- Trace distance
		["dir"] = Vector(0, 20, 70), -- Trace arc cast
		["dmg"] = 450, --Damage
		["dmgtype"] = bit.bor(DMG_SLASH),  --bit.bor(DMG_SLASH,DMG_ALWAYSGIB),DMG_CRUSH, etc.
		["delay"] = 0.45, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "TFA_KF2_ZWEIHANDER.Swing4", -- Sound ID
		["snd_delay"] = 0.26,
		["viewpunch"] = Angle(-5, 0, 0), --viewpunch angle
		["end"] = 0.8, --time before next attack
		["hull"] = 16, --Hullsize
		["direction"] = "B", --Swing dir,
		["hitflesh"] = "TFA_KF2_ZWEIHANDER.HitFlesh1",
		["hitworld"] = "TFA_KF2_ZWEIHANDER.HitWorld"
	}--[[,
	{
		["act"] = ACT_VM_HITCENTER, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 16 * 5.5, -- Trace distance
		["dir"] = Vector(0, 30, 10), -- Trace arc cast
		["dmg"] = 120, --Damage
		["dmgtype"] = bit.bor(DMG_SLASH,DMG_ALWAYSGIB), --bit.bor(DMG_SLASH,DMG_ALWAYSGIB),DMG_CRUSH, etc.
		["delay"] = 0.2, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "TFA_KF2_ZWEIHANDER.Swing", -- Sound ID
		["snd_delay"] = 0.1,
		["viewpunch"] = Angle(-5, 0, 2), --viewpunch angle
		["end"] = 0.8, --time before next attack
		["hull"] = 16, --Hullsize
		["direction"] = "FB", --Swing dir,
		["hitflesh"] = "TFA_KF2_ZWEIHANDER.HitFlesh",
		["hitworld"] = "TFA_KF2_ZWEIHANDER.HitWorld"
	}]]--
}

SWEP.Secondary.Attacks = {
	{
		["act"] = ACT_VM_MISSRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 20 * 10,  -- Trace distance
		["dir"] = Vector(-120, 0, 0), -- Trace arc cast
		["dmg"] = 450, --Damage
		["dmgtype"] = bit.bor(DMG_SLASH),  --bit.bor(DMG_SLASH,DMG_ALWAYSGIB),DMG_CRUSH, etc.
		["delay"] = 0.45, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "TFA_KF2_ZWEIHANDER.Swing2", -- Sound ID
		["snd_delay"] = 0.26,
		["viewpunch"] = Angle(1, 5, 0), --viewpunch angle
		["end"] = 0.8, --time before next attack
		["hull"] = 16, --Hullsize
		["direction"] = "L", --Swing dir,
		["hitflesh"] = "TFA_KF2_ZWEIHANDER.HitFlesh2",
		["hitworld"] = "TFA_KF2_ZWEIHANDER.HitWorld"
	}
}
if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_mastercombatknife")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
