if killicon and killicon.Add then
    killicon.Add( "tfa_ww1_tnt", "vgui/hud/tfa_ww1_tnt_charge", Color( 255, 255, 255, 255 ) )
end

sound.Add(
{
    name = "Weapon_compositonB.Prime",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = 75,
    sound = "weapons/tnt_charge/tnt_prime.wav"
})
sound.Add(
{
    name = "Weapon_compositonB.Throw",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = 75,
    sound = "weapons/tnt_charge/tnt_throw.wav"
})
sound.Add(
{
    name = "Weapon_compositonB.Explode",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = 75,
    sound = "weapons/tnt_charge/tnt_detonate_01.wav"
})

sound.Add(
{
    name = "Weapon_compositonB.Bounce",
    channel = CHAN_ITEM,
    volume = 1.0,
    soundlevel = 75,
    sound = {	"weapons/tnt_charge/tnt_bounce_01.wav",
				"weapons/tnt_charge/tnt_bounce_02.wav",
				"weapons/tnt_charge/tnt_bounce_03.wav",
			}
})
