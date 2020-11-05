if engine.ActiveGamemode() == "nzombies" then
hook.Add("InitPostEntity", "setup_semtex", function()
	nzSpecialWeapons:AddGrenade( "nz_semtex", 4, false, 0.65, false, 0.4 )
end)
end

sound.Add(
{
    name = "Weapon_M67.Pin",
    channel = CHAN_WEAPON,
    volume = 1.0,
    soundlevel = 80,
    sound = "nz/m67/pin.wav"
})

sound.Add(
{
    name = "Weapon_M67.Throw",
    channel = CHAN_WEAPON,
    volume = 0.75,
    soundlevel = 80,
    sound = "nz/m67/gren_throw.wav"
})

sound.Add(
{
    name = "Weapon_Semtex.Pin",
    channel = CHAN_WEAPON,
    volume = 1.0,
    soundlevel = 80,
    sound = "nz/m67/semtex_pin_pull.mp3"
})

sound.Add(
{
    name = "Weapon_Semtex.Charge",
    channel = CHAN_WEAPON,
    volume = 1.0,
    soundlevel = 80,
    sound = "nz/m67/semtex_charge.mp3"
})