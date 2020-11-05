local stg = "stinger/"
local stgrm = "rm_stinger/"
local javrm = "rm_javelin/"
local rpgrm = "rm_rpg7/"
local c4rm = "rm_c4/"
local cmrm = "rm_claymore/"

TFA.AddWeaponSound("Stinger.open", stg .. "deploy.wav")
TFA.AddWeaponSound("StingerRM.Open", stgrm .. "deploy.wav")
TFA.AddWeaponSound("StingerRM.Draw", stgrm .. "draw.wav")
TFA.AddWeaponSound("StingerRM.Dispose", stgrm .. "toss.wav")
TFA.AddWeaponSound("StingerRM.Holster", stgrm .. "holster.wav")
TFA.AddWeaponSound("JavelinRM.Open", javrm .. "open.wav")
TFA.AddWeaponSound("JavelinRM.Deploy", javrm .. "deploy.wav")
TFA.AddWeaponSound("JavelinRM.Rest", javrm .. "rest.wav")
TFA.AddWeaponSound("JavelinRM.Reload", javrm .. "reload.wav")
TFA.AddWeaponSound("JavelinRM.Draw", javrm .. "draw.wav")
TFA.AddWeaponSound("JavelinRM.Holster", javrm .. "holster.wav")
TFA.AddWeaponSound("RPGRM.Draw", rpgrm .. "draw.wav")
TFA.AddWeaponSound("RPGRM.Holster", rpgrm .. "holster.wav")
TFA.AddWeaponSound("RPGRM.Insert1", rpgrm .. "first_insert.wav")
TFA.AddWeaponSound("RPGRM.Insert2", rpgrm .. "second_insert.wav")
TFA.AddWeaponSound("RPGRM.IronIn", rpgrm .. "iron_in.wav")
TFA.AddWeaponSound("RPGRM.IronOut", rpgrm .. "iron_out.wav")
TFA.AddWeaponSound("C4RM.Draw", c4rm .. "draw.wav")
TFA.AddWeaponSound("C4RM.Holster", c4rm .. "holster.wav")
TFA.AddWeaponSound("C4RM.Click", c4rm .. "click.wav")
TFA.AddWeaponSound("C4RM.throw", c4rm .. "toss.wav")
TFA.AddWeaponSound("ClaymoreRM.Draw", cmrm .. "claymore_deploy.wav")
TFA.AddWeaponSound("ClaymoreRM.Ready", cmrm .. "ready.wav")

TFA.AddFireSound("RPGRM.1", rpgrm .. "fire.wav")

TFA.AddAmmo( "cod4rm_javelin_ammo", "FGM-148 High Explosive Anti-Tank Missiles" )
TFA.AddAmmo( "cod4rm_stinger_ammo", "FIM-92 High Explosive Anti-Air Missiles " )
TFA.AddAmmo( "cod4rm_rpg_ammo", "Rocket-Propelled Grenade Warheads" )
TFA.AddAmmo( "cod4rm_c4", "C4 Plastic Explosives" )
TFA.AddAmmo( "cod4rm_claymore", "M18A1 Claymores" )