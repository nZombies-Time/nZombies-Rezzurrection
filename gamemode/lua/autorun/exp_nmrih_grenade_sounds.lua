sound.Add(
{
name = "WeaponFrag_NMRiH.Draw",
channel = CHAN_BODY,
volume = 0.9,
level = 40,
pitch = { 95, 105 },
sound = { "nmrih/player/weapon_draw_01.wav",
"nmrih/player/weapon_draw_02.wav",
"nmrih/player/weapon_draw_03.wav",
"nmrih/player/weapon_draw_04.wav",
"nmrih/player/weapon_draw_05.wav" }
} )
sound.Add(
{
name = "WeaponFrag_NMRiH.PinPull",
channel = CHAN_WEAPON,
volume = 0.7,
level = 55,
sound = { "nmrih/weapons/firearms/exp_frag/Frag_Pull_Pin1.wav",
"nmrih/weapons/firearms/exp_frag/Frag_Pull_Pin2.wav" }
} )
sound.Add(
{
name = "WeaponFrag_NMRiH.Explode",
channel = CHAN_WEAPON,
volume = 1,
level = 90,
sound = { "nmrih/weapons/firearms/exp_frag/Frag_Explode1.wav",
"nmrih/weapons/firearms/exp_frag/Frag_Explode2.wav",
"nmrih/weapons/firearms/exp_frag/Frag_Explode3.wav" }
} )
sound.Add(
{
name = "WeaponFrag_NMRiH.Explode_Dist",
channel = CHAN_STATIC,
volume = 1,
level = 160,
sound = { "nmrih/weapons/firearms/exp_frag/Frag_Explode1_dist.wav",
"nmrih/weapons/firearms/exp_frag/Frag_Explode2_dist.wav",
"nmrih/weapons/firearms/exp_frag/Frag_Explode3_dist.wav" }
} )
sound.Add(
{
name = "WeaponFrag_NMRiH.Debris",
channel = CHAN_AUTO,
volume = 1,
level = 75,
sound = { "nmrih/weapons/firearms/exp_frag/Frag_Debris1.wav",
"nmrih/weapons/firearms/exp_frag/Frag_Debris2.wav" }
} )