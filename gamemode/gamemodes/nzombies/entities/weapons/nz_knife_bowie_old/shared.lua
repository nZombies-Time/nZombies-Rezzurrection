SWEP.Base = "tfa_melee_base"
SWEP.Category = "nZombies Buyable Knives"
SWEP.PrintName = "Bowie Knife (Crusty)"
SWEP.Author		= "Laby" --Author Tooltip
SWEP.ViewModel	= "models/weapons/c_bowie_knife.mdl"
SWEP.WorldModel	= "models/weapons/w_bowie_knife.mdl"
SWEP.ViewModelFlip = false
SWEP.ViewModelFOV = 70
SWEP.UseHands = true
SWEP.HoldType = "knife"
SWEP.DrawCrosshair = true

SWEP.Primary.Directional = false

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Secondary.CanBash = false
SWEP.Secondary.MaxCombo = 0
SWEP.Primary.MaxCombo = 0

SWEP.VMPos = Vector(0,0,0) --The viewmodel positional offset, constantly.  Subtract this from any other modifications to viewmodel position.

-- nZombies Stuff
SWEP.NZPreventBox	= true -- If true, this gun won't be placed in random boxes GENERATED. Users can still place it in manually.


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


function SWEP:Deploy()
print("you had 40 correct choices and you managed to choose the wrong one, contopolations on your lobotomy")
	self:SendWeaponAnim(ACT_VM_DRAW)
	self.HolsterTime = CurTime() + 2.5
	self:EmitSound("nz/bowie/draw/bowie_start.wav")
	
	timer.Simple(0.7, function()
		if IsValid(self) then
			self:EmitSound("nz/bowie/draw/bowie_turn.wav")
		end
	end)
	timer.Simple(1.4, function()
		if IsValid(self) then
			self:EmitSound("nz/bowie/draw/bowie_toss.wav")
		end
	end)
	
	timer.Simple(1.9, function()
		if IsValid(self) then
			self:EmitSound("nz/bowie/draw/bowie_catch.wav")
		end
	end)
end

SWEP.Primary.Attacks = {
	{
		['act'] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 18*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["src"] = Vector(0, 0, 0), -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dir"] = Vector(40, 0, -2), -- Trace direction/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 250, --This isn't overpowered enough, I swear!!
		["dmgtype"] = bit.bor(DMG_SLASH),  --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 6 / 30, --Delay
		['snd_delay'] = 4 / 30,
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "Weapon_BO3_ZMBOWIE.Swing", -- Sound ID
		["viewpunch"] = Angle(0, 0, 0), --viewpunch angle
		["end"] = 1.3, --time before next attack
		["hull"] = 1, --Hullsize
		['hitflesh'] = "Weapon_BO3_ZMBOWIE.Hit_Flesh",
		['hitworld'] ="Weapon_BO3_KNIFE.Hit"
	},
	{
		['act'] = ACT_VM_HITCENTER, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 18*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["src"] = Vector(0, 0, 0), -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dir"] = Vector(0, 35, 0), -- Trace direction/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 250, --This isn't overpowered enough, I swear!!
		["dmgtype"] = bit.bor(DMG_SLASH),  --DMG_SLASH,DMG_CRUSH, etc.
		["delay"] = 7 / 30, --Delay
		['snd_delay'] = 6 / 30,
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "Weapon_BO3_ZMBOWIE.Swing", -- Sound ID
		["viewpunch"] = Angle(0, 0, 0), --viewpunch angle
		["end"] = 1, --time before next attack
		["hull"] = 1, --Hullsize
		['hitflesh'] = "Weapon_BO3_ZMBOWIE.Hit_Flesh",
		['hitworld'] ="Weapon_BO3_KNIFE.Hit"
	}
}

SWEP.ImpactDecal = "ManhackCut"

function SWEP:GetViewModelPosition( pos, ang )
 
 	local newpos = LocalPlayer():EyePos()
	local newang = LocalPlayer():EyeAngles()
	local up = newang:Up()
	
	newpos = newpos + LocalPlayer():GetAimVector()*6 - up*65
	
	return newpos, newang
 
end

if CLIENT then
	SWEP.WepSelectIconCSO = Material("vgui/killicons/tfa_cso_mastercombatknife")
	SWEP.DrawWeaponSelection = TFA_CSO_DrawWeaponSelection
end
