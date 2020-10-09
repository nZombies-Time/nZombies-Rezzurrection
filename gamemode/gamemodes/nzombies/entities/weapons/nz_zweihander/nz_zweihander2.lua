if SERVER then
	AddCSLuaFile("nz_zweihander2.lua")
	SWEP.Weight			= 5
	SWEP.AutoSwitchTo	= false
	SWEP.AutoSwitchFrom	= true
end

if CLIENT then

	SWEP.PrintName     	    = "Zweihander"	
	SWEP.Slot				= 1
	SWEP.SlotPos			= 1
	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= true
	
	SWEP.Category			= "nZombies"

end


SWEP.Author			= "Laby"
SWEP.Contact		= "you make joke"
SWEP.Purpose		= "Stab Stab Stab!"
SWEP.Instructions	= "Let the gamemode give you it"

SWEP.Spawnable			= false
SWEP.AdminSpawnable		= false

SWEP.HoldType = "melee2"

SWEP.ViewModel	= "models/weapons/tfa_kf2/c_zweihander.mdl"
SWEP.WorldModel	= "models/weapons/tfa_kf2/w_zweihander.mdl"
SWEP.UseHands = true
SWEP.vModel = true

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"
SWEP.Primary.DamageType		= DMG_CLUB
SWEP.Primary.Force			= 0

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.NextReload				= 1

SWEP.Primary.Damage 		= 350
SWEP.Range					= 215


function SWEP:Initialize()

	self:SetHoldType( self.HoldType )

end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_RECOIL1)
	self.HolsterTime = CurTime() + 2.5
	timer.Simple(1, function()
		if IsValid(self) then
			self:EmitSound("weapons/nzr/zwei/unsheath_fast_"..math.random(1,2)..".wav")
		end
	end)
end

sound.Add({
	['name'] = "Mastercombat.Wall",
	['channel'] = CHAN_STATIC,
	['sound'] = { "nz/knife/hit_object.wav" },
	['pitch'] = {100,100}
})
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
		['act'] = ACT_VM_HITLEFT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 30*10, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dir"] = Vector(120, 0, 0), -- Trace arc cast
		['dmg'] = 80, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.45, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "Mastercombat.Slash", -- Sound ID
		["snd_delay"] = 0.26,
		["viewpunch"] = Angle(1, -5, 0), --viewpunch angle
		['end'] = 0.6, --time before next attack
		['hull'] = 60, --Hullsize
		['direction'] = "W", --Swing dir,
		['hitflesh'] = "Mastercombat.Hit",
		['hitworld'] = "Mastercombat.Wall"
	},
	{
		['act'] = ACT_VM_HITRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 30*10, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dir"] = Vector(-120, 0, 0), -- Trace arc cast
		['dmg'] = 80, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.45, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "Mastercombat.Slash", -- Sound ID
		["snd_delay"] = 0.26,
		["viewpunch"] = Angle(1, 5, 0), --viewpunch angle
		['end'] = 0.6, --time before next attack
		['hull'] = 60, --Hullsize
		['direction'] = "W", --Swing dir,
		['hitflesh'] = "Mastercombat.Hit",
		['hitworld'] = "Mastercombat.Wall"
	},
	{
		['act'] = ACT_VM_PRIMARYATTACK, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 30*10, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		["dir"] = Vector(0, 20, -70), -- Trace arc cast
		['dmg'] = 80, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
		['delay'] = 0.45, --Delay
		['spr'] = true, --Allow attack while sprinting?
		['snd'] = "Mastercombat.Slash", -- Sound ID
		["snd_delay"] = 0.26,
		["viewpunch"] = Angle(5, 0, 0), --viewpunch angle
		['end'] = 0.6, --time before next attack
		['hull'] = 60, --Hullsize
		['direction'] = "W", --Swing dir,
		['hitflesh'] = "Mastercombat.Hit",
		['hitworld'] = "Mastercombat.Wall"
	},
}

SWEP.Secondary.Attacks = {
	{
		['act'] = ACT_VM_MISSRIGHT, -- Animation; ACT_VM_THINGY, ideally something unique per-sequence
		['len'] = 15*5, -- Trace source; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dir'] = Vector(0,0,-40), -- Trace dir/length; X ( +right, -left ), Y ( +forward, -back ), Z ( +up, -down )
		['dmg'] = 80, --This isn't overpowered enough, I swear!!
		['dmgtype'] = DMG_SLASH, --DMG_SLASH,DMG_CRUSH, etc.
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

function SWEP:DrawAnim()
	
end

function SWEP:PostDrawViewModel()

end

function SWEP:DrawWorldModel()

end

function SWEP:OnRemove()
	
end

function SWEP:Think()
	
end

--function SWEP:GetViewModelPosition( pos, ang )
 
 	--local newpos = LocalPlayer():EyePos()
	--local newang = LocalPlayer():EyeAngles()
	--local up = newang:Up()
	
	--newpos = newpos + LocalPlayer():GetAimVector()*6 - up*65
	
	--return newpos, newang
 
--end