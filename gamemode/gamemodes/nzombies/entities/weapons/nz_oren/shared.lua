SWEP.Base = "tfa_melee_base"
SWEP.Category = "nZombies Buyable Knives"
SWEP.PrintName = "O'Ren Ishii Katana"
SWEP.Author		= "Kamikaze" --Author Tooltip
SWEP.ViewModel = "models/weapons/tfa_l4d2/c_oren_katana.mdl"
SWEP.WorldModel = "models/weapons/tfa_l4d2/w_oren_katana.mdl"
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
	['name'] = "TFA_KF2_KATANA.Swing1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/nzr/oren/katana_swing_miss1.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "TFA_KF2_KATANA.Swing2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/nzr/oren/katana_swing_miss2.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "TFA_KF2_KATANA.Swing3",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/nzr/oren/katana_swing_miss3.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "TFA_KF2_KATANA.Swing4",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/nzr/oren/katana_swing_miss4.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "TFA_KF2_KATANA.HitFlesh1",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/nzr/oren/melee_katana_01.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "TFA_KF2_KATANA.HitFlesh2",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/nzr/oren/melee_katana_02.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "TFA_KF2_KATANA.HitFlesh3",
	['channel'] = CHAN_STATIC,
	['sound'] = { "weapons/nzr/oren/melee_katana_03.wav" },
	['pitch'] = {100,100}
})
sound.Add({
	['name'] = "TFA_KF2_KATANA.HitWorld",
	['channel'] = CHAN_STATIC,
	['sound'] = { "nz/knife/hit_object.wav" },
	['pitch'] = {100,100}
})


function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_RECOIL2)
	self.HolsterTime = CurTime() + 3
	self:EmitSound("weapons/nzr/oren/knife_deploy.wav")
	
	timer.Simple(0.9, function()
		if IsValid(self) then
			self:EmitSound("nz/bowie/draw/bowie_turn.wav")
		end
	end)
end

SWEP.Primary.Attacks = {
	{
		["act"] = ACT_VM_HITLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 16 * 10, -- Trace distance
		["dir"] = Vector(75, 0, 0), -- Trace arc cast
		["dmg"] = 300, --Damage
		["dmgtype"] = bit.bor(DMG_GENERIC),  --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.4, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "TFA_KF2_KATANA.Swing1", -- Sound ID
		["snd_delay"] = 0.26,
		["viewpunch"] = Angle(1, -5, 0), --viewpunch angle
		["end"] = 0.8, --time before next attack
		["hull"] = 16, --Hullsize
		["direction"] = "R", --Swing dir,
		["hitflesh"] = "TFA_KF2_KATANA.HitFlesh3",
		["hitworld"] = "TFA_KF2_KATANA.HitWorld",
		["combotime"] = 0.2
	},
	{
		["act"] = ACT_VM_HITRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 16 * 10, -- Trace distance
		["dir"] = Vector(-75, 0, 0), -- Trace arc cast
		["dmg"] = 300, --Damage
		["dmgtype"] = bit.bor(DMG_GENERIC),  --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.4, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "TFA_KF2_KATANA.Swing2", -- Sound ID
		["snd_delay"] = 0.26,
		["viewpunch"] = Angle(1, 5, 0), --viewpunch angle
		["end"] = 0.8, --time before next attack
		["hull"] = 16, --Hullsize
		["direction"] = "L", --Swing dir,
		["hitflesh"] = "TFA_KF2_KATANA.HitFlesh2",
		["hitworld"] = "TFA_KF2_KATANA.HitWorld",
		["combotime"] = 0.2
	},
	{
		["act"] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 16 * 10, -- Trace distance
		["dir"] = Vector(0, 20, -70), -- Trace arc cast
		["dmg"] = 300, --Damage
		["dmgtype"] = bit.bor(DMG_GENERIC),  --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.4, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "TFA_KF2_KATANA.Swing3", -- Sound ID
		["snd_delay"] = 0.26,
		["viewpunch"] = Angle(5, 0, 0), --viewpunch angle
		["end"] = 0.8, --time before next attack
		["hull"] = 16, --Hullsize
		["direction"] = "F", --Swing dir,
		["hitflesh"] = "TFA_KF2_KATANA.HitFlesh1",
		["hitworld"] = "TFA_KF2_KATANA.HitWorld",
		["combotime"] = 0.2
	},
	{
		["act"] = ACT_VM_PULLBACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 16 * 10, -- Trace distance
		["dir"] = Vector(0, 20, 70), -- Trace arc cast
		["dmg"] = 300, --Damage
		["dmgtype"] = bit.bor(DMG_GENERIC),  --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.4, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "TFA_KF2_KATANA.Swing4", -- Sound ID
		["snd_delay"] = 0.26,
		["viewpunch"] = Angle(-5, 0, 0), --viewpunch angle
		["end"] = 0.8, --time before next attack
		["hull"] = 16, --Hullsize
		["direction"] = "B", --Swing dir,
		["hitflesh"] = "TFA_KF2_KATANA.HitFlesh1",
		["hitworld"] = "TFA_KF2_KATANA.HitWorld",
		["combotime"] = 0.2
	}--[[,
	{
		["act"] = ACT_VM_HITCENTER, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 16 * 4.5, -- Trace distance
		["dir"] = Vector(0, 30, 10), -- Trace arc cast
		["dmg"] = 80, --Damage
		["dmgtype"] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 0.2, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "TFA_KF2_KATANA.Swing", -- Sound ID
		["snd_delay"] = 0.1,
		["viewpunch"] = Angle(-5, 0, 2), --viewpunch angle
		["end"] = 0.8, --time before next attack
		["hull"] = 16, --Hullsize
		["direction"] = "FB", --Swing dir,
		["hitflesh"] = "TFA_KF2_KATANA.HitFlesh",
		["hitworld"] = "TFA_KF2_KATANA.HitWorld"
	}]]--
}

SWEP.Secondary.Attacks = {
	{
		["act"] = ACT_VM_MISSRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 16 * 10,  -- Trace distance
		["dir"] = Vector(-120, 0, 0), -- Trace arc cast
		["dmg"] = 450, --Damage
		["dmgtype"] = bit.bor(DMG_GENERIC),  --bit.bor(DMG_SLASH,DMG_ALWAYSGIB),DMG_CRUSH, etc.
		["delay"] = 0.45, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "TFA_KF2_KATANA.Swing1", -- Sound ID
		["snd_delay"] = 0.26,
		["viewpunch"] = Angle(1, 5, 0), --viewpunch angle
		["end"] = 0.8, --time before next attack
		["hull"] = 16, --Hullsize
		["direction"] = "L", --Swing dir,
		["hitflesh"] = "TFA_KF2_KATANA.HitFlesh1",
		["hitworld"] = "TFA_KF2_KATANA.HitWorld",
	}
}
if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_mastercombatknife")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
