local playerColors = {
	Color(239,154,154),
	Color(244,143,177),
	Color(159,168,218),
	Color(129,212,250),
	Color(128,203,196),
	Color(165,214,167),
	Color(230,238,156),
	Color(255,241,118),
	Color(255,224,130),
	Color(255,171,145),
	Color(161,136,127),
	Color(224,224,224),
	Color(144,164,174),
	nil
}

function player:GetHUDPointsType(id)
	if id == "Black Ops 3" then
	 return "bo3_score1.png"
	end
		if id == "Buried" then
	return "buried_score1.png"
	end
	if id == "Division 9" then
	 return "d9s.png"
	end
	if id == "Shadows of Evil" then
		return "bo3_score2.png"
	end
	if id == "Black Ops 1" then
	 return "bo1s.png"
	end
		if id == "Mob of the Dead" then
	return "bloodline_score2.png"
	end
	if id == "Fade" then
	return "fades.png"
	end
		if id == "Origins (Black Ops 2)" then
	return "bloodline_score2.png"
	end
		if id == "Tranzit (Black Ops 2)" then
	return "bloodline_score3.png"
	end
		if id == "nZombies Classic(HD)" then
	return "hd_score1.png"
	end
	if id == "Covenant" then
	return "covenant_score1.png"
	end
	if id == "UNSC" then
	return "unsc_score1.png"
	end
	if id == "Dead Space" then
	return "bloodline_score2.png"
	end
	if id == "Devil May Cry - Dante" then
	return "dante_score1.png"
	end
	if id == "Devil May Cry - Nero" then
	return "nero_score1.png"
	end
	if id == "Devil May Cry - V" then
	return "V_score1.png"
	end
	if id == "Devil May Cry - Vergil" then
	return "vergil_score1.png"
	end
	if id == "Gears of War" then
	return "gears_score1.png"
	end
	if id == "Killing Floor 2" then
	return "hd_score4.png"
	end
	if id == "Resident Evil" then
	return "RE_score1.png"
	end
	if id == "Simple (Black)" then
	return "simple_score1.png"
	end
	if id == "Simple (Outline)" then
	return "simple_score1.png"
	end
	if id == nil then
	return "bloodline_score2.png"
	end
end

local blooddecals = {
	Material("bloodline_score1.png", "unlitgeneric smooth"),
	Material("bloodline_score2.png", "unlitgeneric smooth"),
	Material("bloodline_score3.png", "unlitgeneric smooth"),
	Material("bloodline_score4.png", "unlitgeneric smooth"),
	nil
}

--shuffle the colors on map start
local rand = math.random
local n = #playerColors

while n > 2 do

	local k = rand(n) -- 1 <= k <= n

	playerColors[n], playerColors[k] = playerColors[k], playerColors[n]
	n = n - 1
end

n = #blooddecals

while n > 2 do

	local k = rand(n) -- 1 <= k <= n

	blooddecals[n], blooddecals[k] = blooddecals[k], blooddecals[n]
	n = n - 1
end

function player.GetColorByIndex(index)
	return playerColors[((index - 1) % #playerColors) + 1]
end

function player.GetBloodByIndex(index)
	return Material(player:GetHUDPointsType(nzMapping.Settings.hudtype), "unlitgeneric smooth")
end
