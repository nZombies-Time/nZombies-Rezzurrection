SWEP.Base = "tfa_melee_base"
SWEP.Category = "nZombies Buyable Knives"
SWEP.PrintName = "Galvaknuckles"
SWEP.Author		= "Laby" --Author Tooltip
SWEP.ViewModel = "models/weapons/nz_knives/c_tazer.mdl"
SWEP.WorldModel = "models/weapons/tfa_bo2/tazer/w_tazer.mdl"
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
	self:SendWeaponAnim(ACT_VM_DEPLOY)
	self.HolsterTime = CurTime() + 3
	timer.Simple(0.2, function()
		if IsValid(self) then
			self:EmitSound("weapons/tfa_bo2/tazer/taser_zap_purchase.wav")
		end
	end)
			
	
end

SWEP.Primary.Attacks = {
	{
		["act"] = ACT_VM_HITCENTER, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 16*5, -- Trace distance
		["src"] = Vector(0, 0, 0), -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dir"] = Vector(0, 0, 0), -- Trace direction/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dmg"] = 322, --Damage
		["dmgtype"] = bit.bor(DMG_SHOCK), 
		["delay"] = 6 / 30, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "weapons/tfa_bo2/tazer/fly_taser_swing_00.wav","weapons/tfa_bo2/tazer/fly_taser_swing_01.wav","weapons/tfa_bo2/tazer/fly_taser_swing_02.wav", -- Sound ID
		["hitflesh"] = "weapons/tfa_bo2/tazer/fly_taser_imp_00.wav","weapons/tfa_bo2/tazer/fly_taser_imp_01.wav","weapons/tfa_bo2/tazer/fly_taser_imp_02.wav","weapons/tfa_bo2/tazer/fly_taser_imp_03.wav",
		["hitworld"] = "weapons/tfa_bo2/tazer/fly_taser_gen_00.wav","weapons/tfa_bo2/tazer/fly_taser_gen_01.wav", 
		["viewpunch"] = Angle(0, 0, 0), --viewpunch angle
		["end"] = 1.15, --time before next attack
		["hull"] = 10, --Hullsize
	},
	{
		["act"] = ACT_VM_MISSCENTER, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		["len"] = 16*5, -- Trace distance
		["src"] = Vector(0, 0, 0), -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dir"] = Vector(-0, 0, 0), -- Trace direction/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dmg"] = 322, --Damage
		["dmgtype"] = bit.bor(DMG_SHOCK), 
		["delay"] = 4 / 30, --Delay
		["spr"] = true, --Allow attack while sprinting?
		["snd"] = "weapons/tfa_bo2/tazer/fly_taser_swing_00.wav","weapons/tfa_bo2/tazer/fly_taser_swing_01.wav","weapons/tfa_bo2/tazer/fly_taser_swing_02.wav",
		["hitflesh"] = "weapons/tfa_bo2/tazer/fly_taser_imp_00.wav","weapons/tfa_bo2/tazer/fly_taser_imp_01.wav","weapons/tfa_bo2/tazer/fly_taser_imp_02.wav","weapons/tfa_bo2/tazer/fly_taser_imp_03.wav",
		["hitworld"] = "weapons/tfa_bo2/tazer/fly_taser_gen_00.wav","weapons/tfa_bo2/tazer/fly_taser_gen_01.wav", 
		["viewpunch"] = Angle(0, 0, 0), --viewpunch angle
		["end"] = 1, --time before next attack
		["hull"] = 10, --Hullsize
	}
	
}

SWEP.SequenceRateOverride = {
}


if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_mastercombatknife")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
