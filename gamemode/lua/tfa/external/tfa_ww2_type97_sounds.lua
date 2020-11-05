local path = "weapons/tfa_ww2_type97/"
local pref = "TFA_WW2_TYPE97"
local hudcolor = Color(255, 255, 255, 255)

TFA.AddWeaponSound(pref .. ".PinPull", path .. "stielhandgranate_ropepull.wav")
TFA.AddWeaponSound(pref .. ".ArmDraw", path .. "stielhandgranate_armdraw.wav")
TFA.AddWeaponSound(pref .. ".ArmThrow", path .. "mk2_throw_01.wav")

if killicon and killicon.Add then
	killicon.Add("tfa_ww2_type97_explosive", "vgui/hud/tfa_ww2_type97", hudcolor)
end