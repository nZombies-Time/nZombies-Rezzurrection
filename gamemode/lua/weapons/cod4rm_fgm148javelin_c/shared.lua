SWEP.Base				= "tfa_gun_base"
SWEP.Category				= "TFA CoD MWR" --The category.  Please, just choose something generic or something I've already done if you plan on only doing like one swep..
SWEP.Manufacturer = "Raytheon Missile Systems & Lockheed Martin" --Gun Manufactrer (e.g. Hoeckler and Koch )
SWEP.Author				= "Krazy" --Author Tooltip
SWEP.Contact				= "http://steamcommunity.com/profiles/76561198161775645" --Contact Info Tooltip
SWEP.Purpose				= "Guided anti-tank launcher capable of locking onto moving ground targets and aerial targets. Two attack modes available. Use flashlight for night vision." --Purpose Tooltip
SWEP.Instructions				= "" --Instructions Tooltip
SWEP.Spawnable				= true --Can you, as a normal user, spawn this?
SWEP.AdminSpawnable			= true --Can an adminstrator spawn this?  Does not tie into your admin mod necessarily, unless its coded to allow for GMod's default ranks somewhere in its code.  Evolve and ULX should work, but try to use weapon restriction rather than these.
SWEP.DrawCrosshair			= true		-- Draw the crosshair?
SWEP.DrawCrosshairIS = false --Draw the crosshair in ironsights?
SWEP.PrintName				= "FGM-148 Javelin"		-- Weapon name (Shown on HUD)
SWEP.Slot				= 4				-- Slot in the weapon selection menu.  Subtract 1, as this starts at 0.
SWEP.SlotPos				= 73			-- Position in the slot
SWEP.AutoSwitchTo			= true		-- Auto switch to if we pick it up
SWEP.AutoSwitchFrom			= true		-- Auto switch from if you pick up a better weapon
SWEP.Weight				= 30			-- This controls how "good" the weapon is for autopickup.
SWEP.Type = "Guided Anti-Tank Launcher"

--[[WEAPON HANDLING]]--
SWEP.Primary.Sound = nil -- This is the sound of the weapon, when you shoot.
SWEP.Primary.PenetrationMultiplier = 1 --Change the amount of something this gun can penetrate through
SWEP.Primary.Damage = 500-- Damage, in standard damage points.
SWEP.Primary.DamageTypeHandled = true --true will handle damagetype in base
SWEP.Primary.DamageType = nil --See DMG enum.  This might be DMG_SHOCK, DMG_BURN, DMG_BULLET, etc.  Leave nil to autodetect.  DMG_AIRBOAT opens doors.
SWEP.Primary.Force = nil --Force value, leave nil to autocalc
SWEP.Primary.Knockback = 1 --Autodetected if nil; this is the velocity kickback
SWEP.Primary.HullSize = 0 --Big bullets, increase this value.  They increase the hull size of the hitscan bullet.
SWEP.Primary.NumShots = 1 --The number of shots the weapon fires.  SWEP.Shotgun is NOT required for this to be >1.
SWEP.Primary.Automatic = false -- Automatic/Semi Auto
SWEP.Primary.RPM = 120 -- This is in Rounds Per Minute / RPM
SWEP.Primary.RPM_Displayed = 15 -- This is in Rounds Per Minute / RPM
SWEP.Primary.RPM_Semi = nil -- RPM for semi-automatic or burst fire.  This is in Rounds Per Minute / RPM
SWEP.Primary.RPM_Burst = nil -- RPM for burst fire, overrides semi.  This is in Rounds Per Minute / RPM
SWEP.Primary.BurstDelay = nil -- Delay between bursts, leave nil to autocalculate
SWEP.FiresUnderwater = false
SWEP.AllowViewAttachment = true
--Miscelaneous Sounds
SWEP.IronInSound = "" --Sound to play when ironsighting in?  nil for default
SWEP.IronOutSound = "" --Sound to play when ironsighting out?  nil for default
--Silencing
SWEP.CanBeSilenced = false --Can we silence?  Requires animations.
SWEP.Silenced = false --Silenced by default?
-- Selective Fire Stuff
SWEP.SelectiveFire = false --Allow selecting your firemode?
SWEP.DisableBurstFire = false --Only auto/single?
SWEP.OnlyBurstFire = false --No auto, only burst/single?
SWEP.DefaultFireMode = "" --Default to auto or whatev
SWEP.FireModeName = "Single Shot Launcher" --Change to a text value to override it
--Ammo Related
SWEP.Primary.ClipSize = 1 -- This is the size of a clip
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize * 2 -- This is the number of bullets the gun gives you, counting a clip as defined directly above.
SWEP.Primary.Ammo = "cod4rm_javelin_ammo" -- What kind of ammo.  Options, besides custom, include pistol, 357, smg1, ar2, buckshot, slam, SniperPenetratedRound, and AirboatGun.
SWEP.Primary.AmmoConsumption = 0 --Ammo consumed per shot
--Pistol, buckshot, and slam like to ricochet. Use AirboatGun for a light metal peircing shotgun pellets
SWEP.DisableChambering = true --Disable round-in-the-chamber
--Recoil Related
SWEP.Primary.KickUp = 0.5 -- This is the maximum upwards recoil (rise)
SWEP.Primary.KickDown = 0.4 -- This is the maximum downwards recoil (skeet)
SWEP.Primary.KickHorizontal = 0.3 -- This is the maximum sideways recoil (no real term)
SWEP.Primary.StaticRecoilFactor = 0.3 --Amount of recoil to directly apply to EyeAngles.  Enter what fraction or percentage (in decimal form) you want.  This is also affected by a convar that defaults to 0.5.
--Firing Cone Related
SWEP.Primary.Spread = .02 --This is hip-fire acuracy.  Less is more (1 is horribly awful, .0001 is close to perfect)
SWEP.Primary.IronAccuracy = .04 -- Ironsight accuracy, should be the same for shotguns
--Unless you can do this manually, autodetect it.  If you decide to manually do these, uncomment this block and remove this line.
SWEP.Primary.SpreadMultiplierMax = 5--How far the spread can expand when you shoot. Example val: 2.5
SWEP.Primary.SpreadIncrement = 1.5 --What percentage of the modifier is added on, per shot.  Example val: 1/3.5
SWEP.Primary.SpreadRecovery = 8--How much the spread recovers, per second. Example val: 3
--Range Related
SWEP.Primary.Range = 8856 -- The distance the bullet can travel in source units.  Set to -1 to autodetect based on damage/rpm.
SWEP.Primary.RangeFalloff = 1 -- The percentage of the range the bullet damage starts to fall off at.  Set to 0.8, for example, to start falling off after 80% of the range.
--Penetration Related
SWEP.MaxPenetrationCounter = 2 --The maximum number of ricochets.  To prevent stack overflows.
--Misc
SWEP.IronRecoilMultiplier = 0.5 --Multiply recoil by this factor when we're in ironsights.  This is proportional, not inversely.
SWEP.CrouchAccuracyMultiplier = 0.5 --Less is more.  Accuracy * 0.5 = Twice as accurate, Accuracy * 0.1 = Ten times as accurate
--Movespeed
SWEP.MoveSpeed = 0.8 --Multiply the player's movespeed by this.
SWEP.IronSightsMoveSpeed = SWEP.MoveSpeed * 0.8 --Multiply the player's movespeed by this when sighting.
--[[PROJECTILES]]--
--[[VIEWMODEL]]--
SWEP.UseHands = true --Use gmod c_arms system.
SWEP.ViewModel			= "models/krazy/cod4rm/javelin_c.mdl" --Viewmodel path
SWEP.ViewModelFOV			= 50		-- This controls how big the viewmodel looks.  Less is more.
SWEP.ViewModelFlip			= false		-- Set this to true for CSS models, or false for everything else (with a righthanded viewmodel.
SWEP.VMPos = Vector(0,0,0)
SWEP.VMAng = Vector(0, 0, 0)
SWEP.VMPos_Additive = false --Set to false for an easier time using VMPos. If true, VMPos will act as a constant delta ON TOP OF ironsights, run, whateverelse
SWEP.CenteredPos = nil --The viewmodel positional offset, used for centering.  Leave nil to autodetect using ironsights.
SWEP.CenteredAng = nil --The viewmodel angular offset, used for centering.  Leave nil to autodetect using ironsights.
SWEP.Bodygroups_V = nil --{
	--[0] = 1,
	--[1] = 4,
	--[2] = etc.
--}
--[[WORLDMODEL]]--
SWEP.WorldModel			= "models/krazy/cod4rm/javelin_w.mdl" -- Weapon world model path
SWEP.Bodygroups_W = nil --{
--[0] = 1,
--[1] = 4,
--[2] = etc.
--}
SWEP.HoldType = "rpg" -- This is how others view you carrying the weapon. Options include:
-- normal melee melee2 fist knife smg ar2 pistol rpg physgun grenade shotgun crossbow slam passive
-- You're mostly going to use ar2, smg, shotgun or pistol. rpg and crossbow make for good sniper rifles
SWEP.Offset = {
	Pos = {
		Up = -1.5,
		Right = 1,
		Forward = 0
	},
	Ang = {
		Up = -1,
		Right = -2,
		Forward = 178
	},
	Scale = 1
} --Procedural world model animation, defaulted for CS:S purposes.
SWEP.ThirdPersonReloadDisable = false --Disable third person reload?  True disables.
--[[SCOPES]]--
SWEP.IronSightsSensitivity = 1 --Useful for a RT scope.  Change this to 0.25 for 25% sensitivity.  This is if normal FOV compenstaion isn't your thing for whatever reason, so don't change it for normal scopes.
SWEP.BoltAction = false --Unscope/sight after you shoot?
SWEP.Scoped = false --Draw a scope overlay?
SWEP.ScopeOverlayThreshold = 0.875 --Percentage you have to be sighted in to see the scope.
SWEP.BoltTimerOffset = 0.25 --How long you stay sighted in after shooting, with a bolt action.
SWEP.ScopeScale = 0.5 --Scale of the scope overlay
SWEP.ReticleScale = 0.7 --Scale of the reticle overlay
--GDCW Overlay Options.  Only choose one.
SWEP.Secondary.UseACOG = false --Overlay option
SWEP.Secondary.UseMilDot = false --Overlay option
SWEP.Secondary.UseSVD = false --Overlay option
SWEP.Secondary.UseParabolic = false --Overlay option
SWEP.Secondary.UseElcan = false --Overlay option
SWEP.Secondary.UseGreenDuplex = false --Overlay option
if surface then
	SWEP.Secondary.ScopeTable = nil --[[
		{
			scopetex = surface.GetTextureID("scope/gdcw_closedsight"),
			reticletex = surface.GetTextureID("scope/gdcw_acogchevron"),
			dottex = surface.GetTextureID("scope/gdcw_acogcross")
		}
	]]--
end
--[[SHOTGUN CODE]]--
SWEP.Shotgun = false --Enable shotgun style reloading.
SWEP.ShellTime = .35 -- For shotguns, how long it takes to insert a shell.
--[[SPRINTING]]--
SWEP.RunSightsPos = Vector(0, 0, -0.633)
SWEP.RunSightsAng = Vector(-8.99, 0, -5.029)

--[[IRONSIGHTS]]--
SWEP.data = {}
SWEP.data.ironsights = 1 --Enable Ironsights
SWEP.Secondary.IronFOV = 80 -- How much you 'zoom' in. Less is more!  Don't have this be <= 0.  A good value for ironsights is like 70.
SWEP.IronSightTime = 1
--[[INSPECTION]]--
SWEP.InspectPos = Vector(13.6, -4.62, -6.567)
SWEP.InspectAng = Vector(30.968, 26.319, 21.719)
--[[VIEWMODEL ANIMATION HANDLING]]--
SWEP.AllowViewAttachment = true --Allow the view to sway based on weapon attachment while reloading or drawing, IF THE CLIENT HAS IT ENABLED IN THEIR CONVARS.
--[[VIEWMODEL BLOWBACK]]--
SWEP.BlowbackEnabled = false --Enable Blowback?
SWEP.BlowbackVector = Vector(0,-3,0) --Vector to move bone <or root> relative to bone <or view> orientation.
SWEP.BlowbackCurrentRoot = 0 --Amount of blowback currently, for root
SWEP.BlowbackCurrent = 0 --Amount of blowback currently, for bones
SWEP.BlowbackBoneMods = nil --Viewmodel bone mods via SWEP Creation Kit
SWEP.Blowback_Only_Iron = true --Only do blowback on ironsights
SWEP.Blowback_PistolMode = false --Do we recover from blowback when empty?
SWEP.Blowback_Shell_Enabled = true --Shoot shells through blowback animations
SWEP.Blowback_Shell_Effect = "ShellEject"--Which shell effect to use
--[[VIEWMODEL PROCEDURAL ANIMATION]]--
SWEP.DoProceduralReload = false--Animate first person reload using lua?
SWEP.ProceduralReloadTime = 1 --Procedural reload time?
--[[HOLDTYPES]]--
SWEP.IronSightHoldTypeOverride = "" --This variable overrides the ironsights holdtype, choosing it instead of something from the above tables.  Change it to "" to disable.
SWEP.SprintHoldTypeOverride = "" --This variable overrides the sprint holdtype, choosing it instead of something from the above tables.  Change it to "" to disable.
--[[ANIMATION]]--

SWEP.StatusLengthOverride = {
	[ACT_VM_RELOAD] = 5
} --Changes the status delay of a given animation; only used on reloads.  Otherwise, use SequenceLengthOverride or one of the others
SWEP.SequenceLengthOverride = {1
} --Changes both the status delay and the nextprimaryfire of a given animation
SWEP.SequenceRateOverride = {1} --Like above but changes animation length to a target
SWEP.SequenceRateOverrideScaled = {
	[ACT_VM_PRIMARYATTACK] = 1.5,
	[ACT_VM_PRIMARYATTACK_1] = 1.5
} --Like above but scales animation length rather than being absolute

SWEP.ProceduralHoslterEnabled = nil
SWEP.ProceduralHolsterTime = 0.3
SWEP.ProceduralHolsterPos = Vector(3, 0, -5)
SWEP.ProceduralHolsterAng = Vector(-40, -30, 10)

SWEP.Sights_Mode = TFA.Enum.LOCOMOTION_HYBRID -- ANI = mdl, HYBRID = lua but continue idle, Lua = stop mdl animation
SWEP.Sprint_Mode = TFA.Enum.LOCOMOTION_ANI -- ANI = mdl, HYBRID = ani + lua, Lua = lua only
SWEP.Idle_Mode = TFA.Enum.IDLE_BOTH --TFA.Enum.IDLE_DISABLED = no idle, TFA.Enum.IDLE_LUA = lua idle, TFA.Enum.IDLE_ANI = mdl idle, TFA.Enum.IDLE_BOTH = TFA.Enum.IDLE_ANI + TFA.Enum.IDLE_LUA
SWEP.Idle_Blend = 0.25 --Start an idle this far early into the end of a transition
SWEP.Idle_Smooth = 0.05 --Start an idle this far early into the end of another animation
--MDL Animations Below
SWEP.IronAnimation = {
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value"] = "base_idle",
		["value_empty"] = "empty_idle"
	},
	["shoot"] = {
		["type"] = TFA.Enum.ANIMATION_ACT, --Sequence or act
		["value"] = ACT_VM_PRIMARYATTACK, --Number for act, String/Number for sequence
	} --What do you think
}

SWEP.SprintAnimation = {
	["loop"] = {
		["type"] = TFA.Enum.ANIMATION_SEQ, --Sequence or act
		["value_empty"] = "sprint_empty",
		["value"] = "sprint",
		["is_idle"] = true
	}
}
--[[EFFECTS]]--
--Attachments
SWEP.MuzzleAttachment			= "1" 		-- Should be "1" for CSS models or "muzzle" for hl2 models
SWEP.ShellAttachment			= "2" 		-- Should be "2" for CSS models or "shell" for hl2 models
SWEP.MuzzleFlashEnabled = false --Enable muzzle flash
SWEP.MuzzleAttachmentRaw = nil --This will override whatever string you gave.  This is the raw attachment number.  This is overridden or created when a gun makes a muzzle event.
SWEP.AutoDetectMuzzleAttachment = false --For multi-barrel weapons, detect the proper attachment?
SWEP.MuzzleFlashEffect = nil --Change to a string of your muzzle flash effect.  Copy/paste one of the existing from the base.
SWEP.SmokeParticle = nil --Smoke particle (ID within the PCF), defaults to something else based on holdtype; "" to disable
--Shell eject override
SWEP.LuaShellEject = false --Enable shell ejection through lua?
SWEP.LuaShellEjectDelay = 0 --The delay to actually eject things
SWEP.LuaShellEffect = "ShellEject" --The effect used for shell ejection; Defaults to that used for blowback
--Tracer Stuff
SWEP.TracerName 		= nil 	--Change to a string of your tracer name.  Can be custom. There is a nice example at https://github.com/garrynewman/garrysmod/blob/master/garrysmod/gamemodes/base/entities/effects/tooltracer.lua
SWEP.TracerCount 		= 0 	--0 disables, otherwise, 1 in X chance
--Impact Effects
SWEP.ImpactEffect = nil--Impact Effect
SWEP.ImpactDecal = nil--Impact Decal
--[[EVENT TABLE]]--
SWEP.EventTable = {} --Event Table, used for custom events when an action is played.  This can even do stuff like playing a pump animation after shooting.
--example:
--SWEP.EventTable = {
--	[ACT_VM_RELOAD] = {
--		{ ["time"] = 0.1, ["type"] = "lua", ["value"] = function( wep, viewmodel ) end, ["client"] = true, ["server"] = true},
--		{ ["time"] = 0.1, ["type"] = "sound", ["value"] = Sound("x") }
--	}
--}
--[[RENDER TARGET]]--
SWEP.RTMaterialOverride = nil -- Take the material you want out of print(LocalPlayer():GetViewModel():GetMaterials()), subtract 1 from its index, and set it to this.
SWEP.RTOpaque = false -- Do you want your render target to be opaque?
SWEP.RTCode = nil--function(self) return end --This is the function to draw onto your rendertarget
--[[AKIMBO]]--
SWEP.Akimbo = false --Akimbo gun?  Alternates between primary and secondary attacks.
SWEP.AnimCycle = 0 -- Start on the right
--[[ATTACHMENTS]]--
SWEP.VElements = nil --Export from SWEP Creation Kit.  For each item that can/will be toggled, set active=false in its individual table
SWEP.WElements = nil --Export from SWEP Creation Kit.  For each item that can/will be toggled, set active=false in its individual table
SWEP.Attachments = nil
SWEP.AttachmentDependencies = {}--{["si_acog"] = {"bg_rail"}}
SWEP.AttachmentExclusions = {}--{ ["si_iron"] = {"bg_heatshield"} }
--[[MISC INFO FOR MODELERS]]--
--[[

Used Animations (for modelers):

ACT_VM_DRAW - Draw
ACT_VM_DRAW_EMPTY - Draw empty
ACT_VM_DRAW_SILENCED - Draw silenced, overrides empty

ACT_VM_IDLE - Idle
ACT_VM_IDLE_SILENCED - Idle empty, overwritten by silenced
ACT_VM_IDLE_SILENCED - Idle silenced

ACT_VM_PRIMARYATTACK - Shoot
ACT_VM_PRIMARYATTACK_EMPTY - Shoot last chambered bullet
ACT_VM_PRIMARYATTACK_SILENCED - Shoot silenced, overrides empty
ACT_VM_PRIMARYATTACK_1 - Shoot ironsights, overriden by everything besides normal shooting
ACT_VM_DRYFIRE - Dryfire

ACT_VM_RELOAD - Reload / Tactical Reload / Insert Shotgun Shell
ACT_SHOTGUN_RELOAD_START - Start shotgun reload, unless ACT_VM_RELOAD_EMPTY is there.
ACT_SHOTGUN_RELOAD_FINISH - End shotgun reload.
ACT_VM_RELOAD_EMPTY - Empty mag reload, chambers the new round.  Works for shotguns too, where applicable.
ACT_VM_RELOAD_SILENCED - Silenced reload, overwrites all


ACT_VM_HOLSTER - Holster
ACT_VM_HOLSTER_SILENCED - Holster empty, overwritten by silenced
ACT_VM_HOLSTER_SILENCED - Holster silenced

]]--
DEFINE_BASECLASS( SWEP.Base )


SWEP.Attachments = {
}

SWEP.VElements = {
}

SWEP.MuzzleAttachmentSilenced = 3
SWEP.LaserSightModAttachment = 1

sound.Add( {
	name = "javlockedonrm",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = { 100, 100 },
	sound = "rm_javelin/locked.wav"
} )
sound.Add(soundData)

sound.Add( {
	name = "javlocking",
	channel = CHAN_STATIC,
	volume = 1.0,
	level = 80,
	pitch = { 100 },
	sound = "rm_javelin/lock.wav"
} )
sound.Add(soundData)


hook.Add("Initialize","createjavelinconvar",function()
	if ConVarExists( "javelin_targets" ) == false then
		CreateConVar("javelin_targets", 0) 
	end
end)

SWEP.LockedEnt = nil
SWEP.BeepDelay = CurTime()
SWEP.CheckPosDelay = CurTime()
SWEP.HitPos = nil
SWEP.LOCKD = 0
SWEP.Locking = false
SWEP.JavHUD = false
SWEP.DirectAttack = false
SWEP.TopAttack = false
function SWEP:ShootBullet()
if SERVER then
	if IsValid(self.LockedEnt) then
		local TargetPos=self.LockedEnt:GetPos()
		if SERVER then
			--sound.Play("Homing_Launcher/approaching_warning.wav",TargetPos)
			self:TakePrimaryAmmo(1)
			self:FireMissal()
		end
		self.Owner:StopSound( "javlockedonrm" )
		self.Owner:StopSound( "javlocking" )
		self.Owner:EmitSound("rm_javelin/motor_fire.wav")
		self.Locking = false
		self.LockedEnt = nil
		tempent = nil
		--timer.Simple( 1, function() self:Reload() end )
	else
		self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
		if self.Weapon:Clip1() == 1 then
			self.Owner:PrintMessage(HUD_PRINTCENTER, "Lock-On Required")
		end
	end
end

end

function SWEP:FireMissal()
	if self:GetStat("DirectAttack") then
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		local SelfPos=self.Owner:GetShootPos()+self:GetUp()*-4+self:GetForward()*80+self:GetRight()*31.5
		local TargPos=self.LockedEnt
		local Dist=(self:GetPos()-self.LockedEnt:GetPos()):Length()
		local Vec=(SelfPos)
		local Dir=Vec:GetNormalized()
		Dir=(Dir+Vector(0,0,.5)):GetNormalized()
		local Spred=self.ShotSpread
		--fire round
		local Miss=ents.Create("ent_cod4rm_javelinmissile_dir")
		Miss.HLOwner = self.Owner
		Miss.ParentLauncher=self.Owner
		Miss:SetNetworkedEntity("Owenur",self.Entity)
		Miss:SetPos(SelfPos-self:GetRight()*30)
		local Ang=Dir:Angle()
		local eye=self.Owner:EyeAngles()
		local PosAng=self:GetAttachment(1)
		local phys = Miss:GetPhysicsObject()
		local angl = self:EyeAngles()
		Ang:RotateAroundAxis(Ang:Up(),90)
		Miss:SetAngles(Angle(0,angl.y+90,angl.x-10.8))
		Miss.InitialAng=(Angle(0,angl.y+90,angl.x-10.8))
		Miss.Target=self.LockedEnt -- go get em tiger
		Miss:Spawn()
		Miss:Activate()
		constraint.NoCollide(self.Entity,Miss)
		timer.Simple( 0, function() self:resetstat() end)
		--Miss:GetPhysicsObject():SetVelocity(self:GetPhysicsObject():GetVelocity()+Dir*400)
		self.FiredAtCurrentTarget=true
		self.RoundInChamber=false
		self.NextNoMovementCheckTime=CurTime()+5
		self:SetDTBool(2,self.RoundInChamber)
		self.RoundsOnBelt=0
		local Scayul=2
		local effectd=EffectData()
		effectd:SetScale(1)
		util.Effect("eff_jack_turretmuzzlelight",effectd,true,true)
		local effectd=EffectData()
		effectd:SetScale(1)
		util.Effect("eff_jack_turretmuzzlelight",effectd,true,true)
	else
		self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
		local SelfPos=self.Owner:GetShootPos()+self:GetUp()*-4+self:GetForward()*80+self:GetRight()*31.5
		local TargPos=self.LockedEnt
		local Dist=(self:GetPos()-self.LockedEnt:GetPos()):Length()
		local Vec=(SelfPos)
		local Dir=Vec:GetNormalized()
		Dir=(Dir+Vector(0,0,.5)):GetNormalized()
		local Spred=self.ShotSpread
		--fire round
		local Miss=ents.Create("ent_cod4rm_javelinmissile")
		Miss.HLOwner = self.Owner
		Miss.ParentLauncher=self.Owner
		Miss:SetNetworkedEntity("Owenur",self.Entity)
		Miss:SetPos(SelfPos-self:GetRight()*30)
		local Ang=Dir:Angle()
		local eye=self.Owner:EyeAngles()
		local PosAng=self:GetAttachment(1)
		local phys = Miss:GetPhysicsObject()
		local angl = self:EyeAngles()
		Ang:RotateAroundAxis(Ang:Up(),90)
		Miss:SetAngles(Angle(0,angl.y+90,angl.x-10.8))
		Miss.InitialAng=(Angle(0,angl.y+90,-75))
		Miss.Target=self.LockedEnt -- go get em tiger
		Miss:Spawn()
		Miss:Activate()
		constraint.NoCollide(self.Entity,Miss)
		timer.Simple( 0, function() self:resetstat() end)
		--Miss:GetPhysicsObject():SetVelocity(self:GetPhysicsObject():GetVelocity()+Dir*400)
		self.FiredAtCurrentTarget=true
		self.RoundInChamber=false
		self.NextNoMovementCheckTime=CurTime()+5
		self:SetDTBool(2,self.RoundInChamber)
		self.RoundsOnBelt=0
		local Scayul=2
		local effectd=EffectData()
		effectd:SetScale(1)
		util.Effect("eff_jack_turretmuzzlelight",effectd,true,true)
		local effectd=EffectData()
		effectd:SetScale(1)
		util.Effect("eff_jack_turretmuzzlelight",effectd,true,true)
	end
end
	
function SWEP:OnRemove()
	if self.Dispose == false then
		self.Locking = false
	end
end
SWEP.IronIn = false	
SWEP.Night = nil
function SWEP:Think2()
	BaseClass.Think2(self)
	if self:GetIronSightsRaw() == true and self.IronIn == false and !self.Owner:KeyDown(IN_SPEED) then
		self.IronIn = true
		timer.Simple(0.05,function() self.Weapon:SendWeaponAnim(ACT_VM_PULLBACK_HIGH)  end)
		timer.Simple(0.75,function() if self:GetIronSightsRaw() == true and !self.Owner:KeyDown(IN_SPEED) then self.Owner:SetFOV( 30, 0.05 ) self.JavHUD = true self.Owner:DrawViewModel( false ) end  end)
		--self.Weapon:SetHomingLauncherHud(true)
		--print (self.LockedEnt)
	end
	if self.IronIn == true and self:GetIronSightsRaw() == false then
		--self.Weapon:SetHomingLauncherHud(false)
		self.IronIn = false
		self.Weapon:SendWeaponAnim(ACT_VM_PULLBACK_LOW)
		self.Owner:SetFOV( 0, 0.05 )
		self.LockedEnt = nil
		self.HitPos = nil
		self.LOCKD = 0
		self.Locking = false
		self.JavHUD = false
		self.Owner:DrawViewModel( true )
	end
	if self.Owner:KeyDown(IN_SPEED) and self.JavHUD == true then
		self.IronIn = false
		self.Weapon:SendWeaponAnim(ACT_VM_PULLBACK_LOW)
		self.Owner:SetFOV( 0, 0.05 )
		self.LockedEnt = nil
		self.HitPos = nil
		self.LOCKD = 0
		self.Locking = false
		self.JavHUD = false
		self.Owner:DrawViewModel( true )
	end
	if self.JavHUD == true and self.Weapon:Clip1() == 1 then
		self:StingerTargeting()
	end
	if self.Owner:KeyDown(IN_SPEED) then 
		self.LockedEnt = nil
		self.HitPos = nil
		self.LOCKD = 0
		self.Locking = false
	end
	if not self.Owner:Alive() then
		self:EndSound("javlockrm")
	end
	if !IsValid(self.LockedEnt) and self.LOCKD >=4 then
		self.LOCKD = 0
	end
	--print (self.DirectAttack)
	--self.JavHUD = true
end
function SWEP:StingerTargeting()	
	local Tar = {}
	Tar.start = self.Owner:GetShootPos()
	Tar.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 10^8 )
	Tar.filter = self.Owner
	Tar.mins = Vector( 1,1,1 ) 
	Tar.maxs = Vector( 1,1,1 ) 
	Tar.mask = MASK_SHOT_HULL
	local tr = util.TraceHull(Tar)
	local SelfPos=self:GetPos()
	local Pos=SelfPos
	if IsValid(tr.Entity) and self.Weapon:Clip1() >= 1 and !self.Owner:KeyDown(IN_SPEED) then
		if !tr.Entity:IsPlayer() and tr.Entity:IsValid()  then
			if self.LOCKD < 3 and self.BeepDelay <= CurTime() then
				tempent = tr.Entity
				valident = tr.Entity
				if self.BeepDelay <= CurTime() and IsFirstTimePredicted() then
					self.Owner:EmitSound("javlocking")	
				end
				self.BeepDelay = CurTime() + 0.6
				self.LOCKD = self.LOCKD + 1
				print (self.LOCKD)
				--if CLIENT or SERVER and game.SinglePlayer() and self.LOCKD <= 1 then
			end
			if self.LOCKD == 3 and self.BeepDelay <= CurTime() then
				if self.LOCKD != 3 and self.Locking == false then
					self.Locking = true
				end
				if self.BeepDelay <= CurTime() and IsFirstTimePredicted() then
					self.Owner:EmitSound("javlockedonrm")
				end
				tempent = tr.Entity
				valident = tr.Entity
				self.BeepDelay = CurTime() + 0.6			
				self.LOCKD = self.LOCKD + 1
				print (self.LOCKD)
				--if CLIENT or SERVER and game.SinglePlayer() and self.LOCKD <= 1 then
			end
			if self.LOCKD == 4 then
				self.BeepDelay = CurTime() + 0.6
				self.LOCKD = self.LOCKD + 1	
				self.LockedEnt = tr.Entity
				self.Locking = false
				local TargetPos=self.LockedEnt:GetPos()
				--sound.Play("Homing_Launcher/lock_warning.wav",TargetPos)
			end
		end
	else
		self.Locking = false
	end
end

function SWEP:resetstat()
	self.LockedEnt = nil
	tempent = nil
	temppos = nil
	self.LOCKD = 0
	self.Locking = false
end

SWEP.Attachments = {
	[9] = { offset = { 0, 0 }, atts = { "javelin_dir" }, order = 1 }
}







function SWEP:DrawHUD()
-- Inspection Derma
self:DoInspectionDerma()
-- 3D2D Ammo
self:DrawHUDAmmo() --so it's swappable easily
local SS = (ScrH()/900)
local JAV_OVERLAY = surface.GetTextureID("models/javelin/overlay")
local JAV_CLU = surface.GetTextureID("models/javelin/clu")
local JAV_DAY = surface.GetTextureID("models/javelin/day")
local JAV_NIGHT = surface.GetTextureID("models/javelin/night")
local JAV_DIR = surface.GetTextureID("models/javelin/dir")
local JAV_LOCK = surface.GetTextureID("models/javelin/lock")
local JAV_LOCK_A = 0
local JAV_NOMSL = surface.GetTextureID("models/javelin/nomsl")
local JAV_MSL = surface.GetTextureID("models/javelin/msl")
local JAV_TOP = surface.GetTextureID("models/javelin/top")
local JAV_TARGET = surface.GetTextureID("models/javelin/target")
local JAV_TARGET_UP = surface.GetTextureID("models/javelin/target_up")
local JAV_TARGET_RIGHT = surface.GetTextureID("models/javelin/target_right")
local JAV_TARGET_DOWN = surface.GetTextureID("models/javelin/target_down")
local JAV_TARGET_LEFT = surface.GetTextureID("models/javelin/target_left")
local JAV_NOISE = surface.GetTextureID("models/javelin/noise")
local mat_color = Material( "pp/colour" )

local ownr = LocalPlayer()
local SS = (ScrH()/15000)
if ownr:FlashlightIsOn() then
	self.Night = true
else
	self.Night = false
end
    if self.JavHUD == true and !self.Owner:KeyDown(IN_SPEED) then
        local Tar = {}
        Tar.start = self.Owner:GetShootPos()
        Tar.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 100^10 )
        Tar.filter = self.Owner
        Tar.mins = Vector( -15,-15,-15 )
        Tar.maxs = Vector( 15,15,15 )
        Tar.mask = MASK_SHOT_HULL
        local tr = util.TraceHull( Tar )
		if self.Night == true then
			mat_color:SetTexture( "$fbtexture", render.GetScreenEffectTexture() )
			mat_color:SetFloat( "$pp_colour_addr", -255 )
			mat_color:SetFloat( "$pp_colour_addg", 0 )
			mat_color:SetFloat( "$pp_colour_addb", -255 )
			mat_color:SetFloat( "$pp_colour_mulr", 0 )
			mat_color:SetFloat( "$pp_colour_mulg", 0 )
			mat_color:SetFloat( "$pp_colour_mulb", 0 )
			mat_color:SetFloat( "$pp_colour_brightness", 0.001 )
			mat_color:SetFloat( "$pp_colour_contrast", 4 )
			mat_color:SetFloat( "$pp_colour_colour", 1 )

			render.SetMaterial( mat_color )
			render.DrawScreenQuad()
			
			surface.SetTexture( JAV_NOISE )
			surface.SetDrawColor( 0, 255, 0, 255 )
			surface.DrawTexturedRect( 0+math.Rand(-128,128), 0+math.Rand(-128,128), ScrW(), ScrH() )
		end
		
		--Aiming Lines
		if self.LOCKD == 0 or self.Weapon:Clip1() == 0 then
			local W2 = ScrW()/2
			local H2 = ScrH()/2
			local Wdiff = ScrW()/60
			local Hdiff = ScrH()/21.6
			surface.SetDrawColor( Color( 0, 255,127, 155 ) )
			surface.DrawLine( W2-Wdiff, ScrH()/2.45, W2+Wdiff, ScrH()/2.45 ) --Top Line
			surface.DrawLine( W2-Wdiff, ScrH()/1.6875, W2+Wdiff, ScrH()/1.6875 ) -- Bottom Line
			surface.DrawLine( ScrW()/2.57, H2+Hdiff, ScrW()/2.57, H2-Hdiff ) -- Left Line
			surface.DrawLine( ScrW()/1.62, H2+Hdiff, ScrW()/1.62, H2-Hdiff ) -- Right Line
		end
		
		if self.LOCKD == 0 and self.Weapon:Clip1() == 1 and GetConVar("javelin_targets"):GetInt() == 1 then
			local Findall = ents.GetAll()
			for k, v in pairs(Findall) do
				if v:IsVehicle() or v.LFS then
					if !(v == LocalPlayer()) then
						local tarpos = v:GetPos() + Vector(0,0,v:OBBMaxs().z * .5)
						local post = tarpos:ToScreen()
						surface.SetDrawColor( 255, 255, 255, 255 )
						surface.SetTexture(JAV_TARGET)
						surface.DrawTexturedRect(post.x - 1000*SS / 2,post.y - 900*SS / 2,1000*SS,900*SS)
							--Left Arrow
							if post.x < (ScrW()/5.3) and post.y > (ScrH()/4) and post.y < (ScrH()/1.34) then 
								surface.SetDrawColor( 255, 255, 255, 255 )
								surface.SetTexture(JAV_TARGET_LEFT)
								surface.DrawTexturedRect(ScrW()/4.8,post.y - 900*SS / 2,1000*SS,900*SS)
							end
							
							--Right Arrow
							if post.x > (ScrW()/1.23) and post.y > (ScrH()/4) and post.y < (ScrH()/1.34) then 
								surface.SetDrawColor( 255, 255, 255, 255 )
								surface.SetTexture(JAV_TARGET_RIGHT)
								surface.DrawTexturedRect(ScrW()/1.31,post.y - 900*SS / 2,1000*SS,900*SS)
							end
							
							--Downward Arrow
							if post.y > (ScrH()/1.2) and post.x > (ScrW()/4) and post.x < (ScrW()/1.34) then
								surface.SetDrawColor( 255, 255, 255, 255 )
								surface.SetTexture(JAV_TARGET_DOWN)
								surface.DrawTexturedRect(post.x - 1000*SS / 2,ScrH()/1.4,1000*SS,900*SS)
							end
							//left
							if post.y > (ScrH()/1.2) and post.x <= (ScrW()/4) then
								surface.SetDrawColor( 255, 255, 255, 255 )
								surface.SetTexture(JAV_TARGET_DOWN)
								surface.DrawTexturedRect(ScrW()/4.2,ScrH()/1.4,1000*SS,900*SS)
							end
							//right
							if post.y > (ScrH()/1.2) and post.x >= (ScrW()/1.34) then
								surface.SetDrawColor( 255, 255, 255, 255 )
								surface.SetTexture(JAV_TARGET_DOWN)
								surface.DrawTexturedRect(ScrW()/1.365,ScrH()/1.4,1000*SS,900*SS)
							end
							--Upward Arrow
							if post.y < (ScrH()/5) and post.x > (ScrW()/4) and post.x < (ScrW()/1.34) then
								surface.SetDrawColor( 255, 255, 255, 255 )
								surface.SetTexture(JAV_TARGET_UP)
								surface.DrawTexturedRect(post.x - 1000*SS / 2,ScrH()/4.4,1000*SS,900*SS)
							end
							//left
							if post.y < (ScrH()/5) and post.x <= (ScrW()/4) then
								surface.SetDrawColor( 255, 255, 255, 255 )
								surface.SetTexture(JAV_TARGET_UP)
								surface.DrawTexturedRect(ScrW()/4.2,ScrH()/4.4,1000*SS,900*SS)
							end
							//right
							if post.y < (ScrH()/5) and post.x >= (ScrW()/1.34) then
								surface.SetDrawColor( 255, 255, 255, 255 )
								surface.SetTexture(JAV_TARGET_UP)
								surface.DrawTexturedRect(ScrW()/1.365,ScrH()/4.4,1000*SS,900*SS)
							end
					end
				end
			end
		end
		
		if self.LOCKD > 0 and self.LOCKD <= 5 and self.Weapon:Clip1() == 1 and GetConVar("javelin_targets"):GetInt() == 1 then
			local Findall = ents.GetAll()
			for k, v in pairs(Findall) do
				if v:IsVehicle() or v.LFS then
					if !(v == LocalPlayer()) and !(v == self.LockedEnt) then
						local tarpos = v:GetPos() + Vector(0,0,v:OBBMaxs().z * .5)
						local post = tarpos:ToScreen()
						surface.SetDrawColor( 255, 255, 255, 255 )
						surface.SetTexture(JAV_TARGET)
						surface.DrawTexturedRect(post.x - 1000*SS / 2,post.y - 900*SS / 2,1000*SS,900*SS)
						--Left Arrow
							if post.x < (ScrW()/5.3) and post.y > (ScrH()/4) and post.y < (ScrH()/1.34) then 
								surface.SetDrawColor( 255, 255, 255, 255 )
								surface.SetTexture(JAV_TARGET_LEFT)
								surface.DrawTexturedRect(ScrW()/4.8,post.y - 900*SS / 2,1000*SS,900*SS)
							end
							
							--Right Arrow
							if post.x > (ScrW()/1.23) and post.y > (ScrH()/4) and post.y < (ScrH()/1.34) then 
								surface.SetDrawColor( 255, 255, 255, 255 )
								surface.SetTexture(JAV_TARGET_RIGHT)
								surface.DrawTexturedRect(ScrW()/1.31,post.y - 900*SS / 2,1000*SS,900*SS)
							end
							
							--Downward Arrow
							if post.y > (ScrH()/1.2) and post.x > (ScrW()/4) and post.x < (ScrW()/1.34) then
								surface.SetDrawColor( 255, 255, 255, 255 )
								surface.SetTexture(JAV_TARGET_DOWN)
								surface.DrawTexturedRect(post.x - 1000*SS / 2,ScrH()/1.4,1000*SS,900*SS)
							end
							//left
							if post.y > (ScrH()/1.2) and post.x <= (ScrW()/4) then
								surface.SetDrawColor( 255, 255, 255, 255 )
								surface.SetTexture(JAV_TARGET_DOWN)
								surface.DrawTexturedRect(ScrW()/4.2,ScrH()/1.4,1000*SS,900*SS)
							end
							//right
							if post.y > (ScrH()/1.2) and post.x >= (ScrW()/1.34) then
								surface.SetDrawColor( 255, 255, 255, 255 )
								surface.SetTexture(JAV_TARGET_DOWN)
								surface.DrawTexturedRect(ScrW()/1.365,ScrH()/1.4,1000*SS,900*SS)
							end
							--Upward Arrow
							if post.y < (ScrH()/5) and post.x > (ScrW()/4) and post.x < (ScrW()/1.34) then
								surface.SetDrawColor( 255, 255, 255, 255 )
								surface.SetTexture(JAV_TARGET_UP)
								surface.DrawTexturedRect(post.x - 1000*SS / 2,ScrH()/4.4,1000*SS,900*SS)
							end
							//left
							if post.y < (ScrH()/5) and post.x <= (ScrW()/4) then
								surface.SetDrawColor( 255, 255, 255, 255 )
								surface.SetTexture(JAV_TARGET_UP)
								surface.DrawTexturedRect(ScrW()/4.2,ScrH()/4.4,1000*SS,900*SS)
							end
							//right
							if post.y < (ScrH()/5) and post.x >= (ScrW()/1.34) then
								surface.SetDrawColor( 255, 255, 255, 255 )
								surface.SetTexture(JAV_TARGET_UP)
								surface.DrawTexturedRect(ScrW()/1.365,ScrH()/4.4,1000*SS,900*SS)
							end
					end
				end
			end
		end
		
		if self.LOCKD >= 4 and self.Weapon:Clip1() == 1 and GetConVar("javelin_targets"):GetInt() == 1 then
			local Findall = ents.GetAll()
			for k, v in pairs(Findall) do
				if v:IsVehicle() then
					if !(v == LocalPlayer()) and !(v == self.LockedEnt) then
						local tarpos = v:GetPos() + Vector(0,0,v:OBBMaxs().z * .5)
						local post = tarpos:ToScreen()
						surface.SetDrawColor( 255, 255, 255, 255 )
						surface.SetTexture(JAV_TARGET)
						surface.DrawTexturedRect(post.x - 1000*SS / 2,post.y - 900*SS / 2,1000*SS,900*SS)
						--Left Arrow
							if post.x < (ScrW()/5.3) and post.y > (ScrH()/4) and post.y < (ScrH()/1.34) then 
								surface.SetDrawColor( 255, 255, 255, 255 )
								surface.SetTexture(JAV_TARGET_LEFT)
								surface.DrawTexturedRect(ScrW()/4.8,post.y - 900*SS / 2,1000*SS,900*SS)
							end
							
							--Right Arrow
							if post.x > (ScrW()/1.23) and post.y > (ScrH()/4) and post.y < (ScrH()/1.34) then 
								surface.SetDrawColor( 255, 255, 255, 255 )
								surface.SetTexture(JAV_TARGET_RIGHT)
								surface.DrawTexturedRect(ScrW()/1.31,post.y - 900*SS / 2,1000*SS,900*SS)
							end
							
							--Downward Arrow
							if post.y > (ScrH()/1.2) and post.x > (ScrW()/4) and post.x < (ScrW()/1.34) then
								surface.SetDrawColor( 255, 255, 255, 255 )
								surface.SetTexture(JAV_TARGET_DOWN)
								surface.DrawTexturedRect(post.x - 1000*SS / 2,ScrH()/1.4,1000*SS,900*SS)
							end
							//left
							if post.y > (ScrH()/1.2) and post.x <= (ScrW()/4) then
								surface.SetDrawColor( 255, 255, 255, 255 )
								surface.SetTexture(JAV_TARGET_DOWN)
								surface.DrawTexturedRect(ScrW()/4.2,ScrH()/1.4,1000*SS,900*SS)
							end
							//right
							if post.y > (ScrH()/1.2) and post.x >= (ScrW()/1.34) then
								surface.SetDrawColor( 255, 255, 255, 255 )
								surface.SetTexture(JAV_TARGET_DOWN)
								surface.DrawTexturedRect(ScrW()/1.365,ScrH()/1.4,1000*SS,900*SS)
							end
							--Upward Arrow
							if post.y < (ScrH()/5) and post.x > (ScrW()/4) and post.x < (ScrW()/1.34) then
								surface.SetDrawColor( 255, 255, 255, 255 )
								surface.SetTexture(JAV_TARGET_UP)
								surface.DrawTexturedRect(post.x - 1000*SS / 2,ScrH()/4.4,1000*SS,900*SS)
							end
							//left
							if post.y < (ScrH()/5) and post.x <= (ScrW()/4) then
								surface.SetDrawColor( 255, 255, 255, 255 )
								surface.SetTexture(JAV_TARGET_UP)
								surface.DrawTexturedRect(ScrW()/4.2,ScrH()/4.4,1000*SS,900*SS)
							end
							//right
							if post.y < (ScrH()/5) and post.x >= (ScrW()/1.34) then
								surface.SetDrawColor( 255, 255, 255, 255 )
								surface.SetTexture(JAV_TARGET_UP)
								surface.DrawTexturedRect(ScrW()/1.365,ScrH()/4.4,1000*SS,900*SS)
							end
					end
				end
			end
		end
		
		--Target Lines
		if self.LOCKD > 3 and self.Weapon:Clip1() == 1 and IsValid(self.LockedEnt) then
			local pos = ( self.LockedEnt:GetPos() + Vector(0,0,16 ) ):ToScreen()
			surface.SetDrawColor( Color( 255, 255,255, 255 ) )
			surface.DrawLine( 0, pos.y, ScrW(), pos.y ) 
			surface.DrawLine( pos.x, 0, pos.x, ScrH() ) 
			
			local pos = ( self.LockedEnt:GetPos() + Vector(0,0,16 ) ):ToScreen()
			local tly = ScrH()/250
			local tly2 = ScrH()/200
			local tlx = ScrW()/153.6
			local tlx2 = ScrW()/307.2
			surface.SetDrawColor( Color( 255, 255,255, 255 ) )
			-- Top left
			surface.DrawLine( pos.x-tlx, (pos.y-tly2)-tly, pos.x-tlx2, (pos.y-tly2)-tly ) -- horizontal line
			surface.DrawLine( pos.x-tlx, (pos.y-tly2)-tly, pos.x-tlx, (pos.y-tly2)+tly ) -- vertical line	
			-- Bottom right
			surface.DrawLine( pos.x+tlx, (pos.y+tly2)+tly, pos.x+tlx2, (pos.y+tly2)+tly ) -- horizontal line
			surface.DrawLine( pos.x+tlx, (pos.y+tly2)+tly, pos.x+tlx, (pos.y+tly2)-tly ) -- vertical line
			-- Bottom left
			surface.DrawLine( pos.x-tlx, (pos.y+tly2)+tly, pos.x-tlx2, (pos.y+tly2)+tly ) -- horizontal line
			surface.DrawLine( pos.x-tlx, (pos.y+tly2)+tly, pos.x-tlx, (pos.y+tly2)-tly ) -- vertical line
			-- Top Right
			surface.DrawLine( pos.x+tlx, (pos.y-tly2)-tly, pos.x+tlx2, (pos.y-tly2)-tly ) -- horizontal line
			surface.DrawLine( pos.x+tlx, (pos.y-tly2)-tly, pos.x+tlx, (pos.y-tly2)+tly ) -- vertical line
			-- Box
			surface.DrawLine( ScrW()/2.57, ScrH()/2.45, ScrW()/1.62, ScrH()/2.45 ) --Top Line
			surface.DrawLine( ScrW()/2.57, ScrH()/1.6875, ScrW()/1.62, ScrH()/1.6875 ) -- Bottom Line
			surface.DrawLine( ScrW()/2.57, ScrH()/1.6875, ScrW()/2.57, ScrH()/2.45 ) -- Left Line
			surface.DrawLine( ScrW()/1.62, ScrH()/1.6875, ScrW()/1.62, ScrH()/2.45 ) -- Right Line
        end
		
		//local tly = ScrH()/120
		//local tly2 = ScrH()/36
		//local tlx = ScrW()/51.20
		//local tlx2 = ScrW()/102.4
		
		-- Locking Lines
		if self.LOCKD >=1 and self.LOCKD <= 3 and self.Weapon:Clip1() == 1 then
			local pos = ( tr.Entity:GetPos() + Vector(0,0,16 ) ):ToScreen()
			local tly = ScrH()/240
			local tly2 = ScrH()/72
			local tlx = ScrW()/100
			local tlx2 = ScrW()/150
			surface.SetDrawColor( Color( 255, 255,255, 255 * math.sin(CurTime() * 50) ) )
			-- Top left
			surface.DrawLine( pos.x-tlx, (pos.y-tly2)-tly, pos.x-tlx2, (pos.y-tly2)-tly ) -- horizontal line
			surface.DrawLine( pos.x-tlx, (pos.y-tly2)-tly, pos.x-tlx, (pos.y-tly2)+tly ) -- vertical line	
			-- Bottom right
			surface.DrawLine( pos.x+tlx, (pos.y+tly2)+tly, pos.x+tlx2, (pos.y+tly2)+tly ) -- horizontal line
			surface.DrawLine( pos.x+tlx, (pos.y+tly2)+tly, pos.x+tlx, (pos.y+tly2)-tly ) -- vertical line
			-- Bottom left
			surface.DrawLine( pos.x-tlx, (pos.y+tly2)+tly, pos.x-tlx2, (pos.y+tly2)+tly ) -- horizontal line
			surface.DrawLine( pos.x-tlx, (pos.y+tly2)+tly, pos.x-tlx, (pos.y+tly2)-tly ) -- vertical line
			-- Top Right
			surface.DrawLine( pos.x+tlx, (pos.y-tly2)-tly, pos.x+tlx2, (pos.y-tly2)-tly ) -- horizontal line
			surface.DrawLine( pos.x+tlx, (pos.y-tly2)-tly, pos.x+tlx, (pos.y-tly2)+tly ) -- vertical line	
			--Box
			surface.DrawLine( ScrW()/2.57, ScrH()/2.45, ScrW()/1.62, ScrH()/2.45 ) --Top Line
			surface.DrawLine( ScrW()/2.57, ScrH()/1.6875, ScrW()/1.62, ScrH()/1.6875 ) -- Bottom Line
			surface.DrawLine( ScrW()/2.57, ScrH()/1.6875, ScrW()/2.57, ScrH()/2.45 ) -- Left Line
			surface.DrawLine( ScrW()/1.62, ScrH()/1.6875, ScrW()/1.62, ScrH()/2.45 ) -- Right Line
			
        end

        --surface.SetDrawColor( 255, 255, 255, 255 )
        --surface.SetTexture(JAV_BOX)
        --surface.DrawTexturedRect( 680*SS, 400*SS, 250*SS,120*SS )

        surface.SetDrawColor( 0, 255,0, 255 )
        surface.SetTexture(JAV_NOISE)
        surface.DrawTexturedRect( 0, 0, ScrW(),ScrH() )

        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.SetTexture(JAV_OVERLAY)
        surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
        
        if self.LOCKD >= 1 and self.LOCKD < 4 then
            surface.SetDrawColor( 255, 255, 255, 255 )
            surface.SetTexture(JAV_CLU)
            surface.DrawTexturedRect( 0, 0, ScrW(),ScrH() )
        end
		local ownr = LocalPlayer()
        if ownr:FlashlightIsOn() then
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetTexture(JAV_NIGHT)
			surface.DrawTexturedRect( 0, 0, ScrW(),ScrH() )
		else
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.SetTexture(JAV_DAY)
			surface.DrawTexturedRect( 0, 0, ScrW(),ScrH() )
        end

        if self.LOCKD >= 1 and self.LOCKD < 4 and self.Weapon:Clip1() >= 0 then
            JAV_LOCK_A = 255 * math.sin(CurTime() * 20)
        elseif self.LOCKD >= 4 then
            JAV_LOCK_A = 255
        else
            JAV_LOCK_A = 0
        end
		
		if self.Weapon:Clip1() >= 1 then
			surface.SetDrawColor( 255, 255, 255, JAV_LOCK_A )
			surface.SetTexture(JAV_LOCK)
			surface.DrawTexturedRect( 0, 0, ScrW(),ScrH() )
		end

        if self.Weapon:Clip1() <= 0 then
            surface.SetDrawColor( 255, 255, 255, 255 )
            surface.SetTexture(JAV_NOMSL)
            surface.DrawTexturedRect( 0, 0, ScrW(),ScrH() )
        else
            surface.SetDrawColor( 255, 255, 255, 255 )
            surface.SetTexture(JAV_MSL)
            surface.DrawTexturedRect( 0, 0, ScrW(),ScrH() )
        end

        if self.LOCKD > 3 and self.Weapon:Clip1() == 1 and IsValid(self.LockedEnt) then
			if self:GetStat("DirectAttack") then 
				surface.SetDrawColor( 255, 255, 255, 255 )
                surface.SetTexture(JAV_DIR)
				surface.DrawTexturedRect( 0, 0, ScrW(),ScrH() )
			else
				surface.SetDrawColor( 255, 255, 255, 255 )
                surface.SetTexture(JAV_TOP)
                surface.DrawTexturedRect( 0, 0, ScrW(),ScrH() )
			end
		end

        --surface.SetDrawColor( 255, 255, 255, 255 )
        --surface.SetTexture(JAV_BOX)
        --surface.DrawTexturedRect( 680*SS, 400*SS, 250*SS,120*SS )
	else
		self.Owner:DrawViewModel( true )
		self.JavHUD = false
    end


    
end