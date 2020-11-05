local path = "weapons/tfa_ww2_rgd33/"
local pref = "TFA_WW2_RGD33"
local hudcolor = Color(255, 255, 255, 255)

TFA.AddWeaponSound(pref .. ".RopePull", path .. "stielhandgranate_ropepull.wav")
TFA.AddWeaponSound(pref .. ".ArmThrow", path .. "no77_throw.wav")
TFA.AddWeaponSound(pref .. ".ArmDraw", path .. "stielhandgranate_armdraw.wav")
TFA.AddWeaponSound(pref .. ".Bounce", path .. "m67_bounce_01.wav")

if killicon and killicon.Add then
    killicon.Add( "tfa_m1917_russian_gas_grenade", "vgui/hud/tfa_m1917_russian_gas_grenade_gas", Color( 255, 255, 255, 255 ) )
end