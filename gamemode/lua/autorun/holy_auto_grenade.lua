sound.Add({
	name =			"Holy.Explode",
	channel =		CHAN_AUTO,
	volume =		1,
	sound =			"weapons/svn/holyhandgrenade/holyexplode.wav"
})
sound.Add({
	name =			"Holy.Explode_Alt",
	channel =		CHAN_AUTO,
	volume =		1,
	sound =			"weapons/svn/holyhandgrenade/holyexplodeworms.wav"
})
---------------------------------------------------------------------------------------------------------
-- For M9K
---------------------------------------------------------------------------------------------------------
function PocketM9KWeapons(ply, wep)
	if not IsValid(wep) then return end
	class = wep:GetClass()
	m9knopocket = false
	
	for k, 	v in pairs(m9knpw) do
		if 	v == class then
			m9knopocket = true
			break
		end
	end
	if m9knopocket then
		return false
	end	
end
hook.Add("canPocket", "PocketM9KWeapons", PocketM9KWeapons )
