---------------------------------------------------------------------------------------------------------
-- Svn's Holy Hand Grenade of Antioch
---------------------------------------------------------------------------------------------------------
--Three shall be the number of the counting and the number of 
--the counting shall be three. Four shalt thou not count, neither shalt thou count two, 
--excepting that thou then proceedeth to three. Five is right out. Once the number three, 
--being the number of the counting, be reached, then lobbest thou the Holy Hand Grenade in 
--the direction of thine foe, who, being naughty in my sight, shall snuff it.
---------------------------------------------------------------------------------------------------------
SWEP.Category					= "Svn's Weapons"
SWEP.Author						= "Svn, Creators of Bob's Gun Base"
SWEP.Contact					= ""
SWEP.Purpose					= ""
SWEP.Instructions				= "Once the number three, being the number of the counting, be reached, then lobbest thou the Holy Hand Grenade in the direction of thine foe, who, being naughty in my sight, shall snuff it."
---------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------------
-- SWEP Variables 
-- Note: Because this is a grenade some of these are redundant)
---------------------------------------------------------------------------------------------------------
SWEP.Gun = ("svn_holyhandgrenadeworms")
SWEP.PrintName					= "Holy Hand Grenade Alt"		
SWEP.Weight						= 2
SWEP.AutoSwitchTo				= true
SWEP.AutoSwitchFrom				= true
SWEP.Base						= "holy_grenade_base"
SWEP.Spawnable					= true
SWEP.BounceWeaponIcon 			= true
SWEP.AdminSpawnable				= true
SWEP.FiresUnderwater 			= true
SWEP.Primary.Sound				= Sound("")
SWEP.Primary.RPM				= 30
SWEP.Primary.ClipSize			= 1
SWEP.Primary.DefaultClip		= 1
SWEP.Primary.KickUp				= 0
SWEP.Primary.KickDown			= 0
SWEP.Primary.KickHorizontal		= 0
SWEP.Primary.Automatic			= false
SWEP.Primary.Ammo				= "Grenade"
SWEP.Primary.Round 				= ("active_holy_nade_alt")
SWEP.Secondary.IronFOV			= 0
SWEP.Primary.NumShots			= 0
SWEP.Primary.Damage				= 0
SWEP.Primary.Spread				= 0
SWEP.Primary.IronAccuracy 		= 0
/*if gmod.GetGamemode("terrortown") then
	SWEP.Base = "weapon_tttbase"
	SWEP.Kind = WEAPON_NADE
	SWEP.CanBuy = { ROLE_TRAITOR }
	SWEP.AutoSpawnable = false
	SWEP.AmmoEnt = "Grenade"
	SWEP.InLoadoutFor = nil
	SWEP.AllowDrop = true
	SWEP.IsSilent = false
	SWEP.NoSights = false
	SWEP.EquipMenuData = {
   		type = "Weapon",
   		desc = "Holy Hand Grenade."
	};
	SWEP.Icon = "vgui/ttt/svn/hhg.png"
end*/
---------------------------------------------------------------------------------------------------------
-- SWEP Viewmodels
---------------------------------------------------------------------------------------------------------
SWEP.HoldType 					= "grenade"
SWEP.ViewModelFOV 				= 52.86432160804
SWEP.ViewModelFlip 				= false
SWEP.UseHands 					= true
SWEP.ViewModel 					= "models/weapons/c_grenade.mdl"
SWEP.WorldModel 				= "models/weapons/w_grenade.mdl"
SWEP.ShowViewModel 				= true
SWEP.ShowWorldModel 			= false
SWEP.ViewModelBoneMods = {
	["ValveBiped.Pin"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["ValveBiped.Grenade_body"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}
SWEP.VElements = {
	["models/freeman/holyhandgrenade.mdl"] = { type = "Model", model = "models/freeman/holyhandgrenade.mdl", bone = "ValveBiped.Grenade_body", rel = "", pos = Vector(0.518, 0.518, -2.951), angle = Angle(164.804, 176.494, -5.844), size = Vector(0.82, 0.82, 0.82), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
SWEP.WElements = {
	["models/freeman/holyhandgrenade.mdl"] = { type = "Model", model = "models/freeman/holyhandgrenade.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1.557, -1.558), angle = Angle(-1.17, -92.338, -171.818), size = Vector(0.755, 0.755, 0.755), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
---------------------------------------------------------------------------------------------------------
-- M9k Stuff. (Optional)
-- Note: Nothing really to change here.
---------------------------------------------------------------------------------------------------------
/*if GetConVar("M9KUniqueSlots") != nil then
	if not (GetConVar("M9KUniqueSlots"):GetBool()) then 
		SWEP.SlotPos = 2
	end
end*/
if CLIENT then
end
