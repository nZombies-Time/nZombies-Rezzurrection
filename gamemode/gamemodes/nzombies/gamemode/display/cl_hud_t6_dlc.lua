-------------------------
-- Localize
local pairs, IsValid, LocalPlayer, CurTime, Color, ScreenScale =
	pairs, IsValid, LocalPlayer, CurTime, Color, ScreenScale

local math, surface, table, input, string, draw, killicon, file =
	math, surface, table, input, string, draw, killicon, file

local file_exists, input_getkeyname, input_isbuttondown, input_lookupbinding, table_insert, table_remove =
	file.Exists, input.GetKeyName, input.IsButtonDown, input.LookupBinding, table.insert, table.remove

local string_len, string_split, string_gsub, string_upper, string_rep, string_match =
	string.len, string.Split, string.gsub, string.upper, string.rep, string.match

local TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, TEXT_ALIGN_BOTTOM =
	TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, TEXT_ALIGN_BOTTOM

local voiceloopback = GetConVar("voice_loopback")
local cl_drawhud = GetConVar("cl_drawhud")
local nz_clientpoints = GetConVar("nz_point_notification_clientside")
local nz_perkmax = GetConVar("nz_difficulty_perks_max")

local nz_showmmostats = GetConVar("nz_hud_show_perkstats")
local nz_showcompass = GetConVar("nz_hud_show_compass")
local nz_shownames = GetConVar("nz_hud_show_names")
local nz_showgun = GetConVar("nz_hud_show_wepicon")
local nz_showperkframe = GetConVar("nz_hud_show_perk_frames")

local nz_indicators = GetConVar("nz_hud_player_indicators")
local nz_indicatorangle = GetConVar("nz_hud_player_indicator_angle")
local nz_useplayercolor = GetConVar("nz_hud_use_playercolor")

local color_white_50 = Color(255, 255, 255, 50)
local color_white_100 = Color(255, 255, 255, 100)
local color_white_150 = Color(255, 255, 255, 150)
local color_white_200 = Color(255, 255, 255, 200)
local color_black_180 = Color(0, 0, 0, 180)
local color_black_100 = Color(0, 0, 0, 100)
local color_black_50 = Color(0, 0, 0, 50)
local color_red_200 = Color(200, 0, 0, 255)
local color_red_255 = Color(255, 0, 0, 255)

local color_grey = Color(200, 200, 200, 255)
local color_used = Color(250, 200, 120, 255)
local color_gold = Color(255, 255, 100, 255)
local color_green = Color(100, 255, 10, 255)
local color_armor = Color(135, 200, 255)

local color_blood = Color(100, 0, 0, 255)
local color_blood_score = Color(120, 0, 0, 255)

local color_points1 = Color(255, 200, 0, 255)
local color_points2 = Color(100, 255, 70, 255)
local color_points4 = Color(255, 0, 0, 255)

local t6_dlcHUDs = {
	["Buried"] = true,
	["Mob of the Dead"] = true,
	["Origins (Black Ops 2)"] = true,
}

//--------------------------------------------------/GhostlyMoo and Fox's BO2 DLC HUD\------------------------------------------------\\

//t6 hud
local t6_hud_score = Material("nz_moo/huds/t6/scorebar_zom_5.png", "unlitgeneric smooth")

local t6_hud_dpad_dlc = {
	["Mob of the Dead"] = Material("nz_moo/huds/t6/hud_hell_dpad.png", "unlitgeneric smooth"),
	["Buried"] = Material("nz_moo/huds/t6/hud_buried_dpad.png", "unlitgeneric smooth"),
	["Origins (Black Ops 2)"] = Material("nz_moo/huds/t6/hud_tomb_dpad.png", "unlitgeneric smooth"),
}
local t6_hud_dpad_bar_dlc = {
	["Mob of the Dead"] = Material("nz_moo/huds/t6/hud_hell_dpad_bar.png", "unlitgeneric smooth"),
	["Buried"] = Material("nz_moo/huds/t6/hud_buried_dpad_bar.png", "unlitgeneric smooth"),
	["Origins (Black Ops 2)"] = Material("nz_moo/huds/t6/hud_tomb_dpad_bar.png", "unlitgeneric smooth"),
}
local t6_hud_num_line = {
	["Mob of the Dead"] = Material("nz_moo/huds/t6/hud_hell_zom_num_line.png", "unlitgeneric smooth"),
	["Buried"] = Material("nz_moo/huds/t6/hud_buried_zom_num_line.png", "unlitgeneric smooth"),
	["Origins (Black Ops 2)"] = Material("nz_moo/huds/t6/hud_tomb_zom_num_line.png", "unlitgeneric smooth"),
}
local t6_hud_num_slash = {
	["Mob of the Dead"] = Material("nz_moo/huds/t6/hud_hell_zom_num_slash.png", "unlitgeneric smooth"),
	["Buried"] = Material("nz_moo/huds/t6/hud_buried_zom_num_slash.png", "unlitgeneric smooth"),
	["Origins (Black Ops 2)"] = Material("nz_moo/huds/t6/hud_tomb_zom_num_slash.png", "unlitgeneric smooth"),
}

local t6_hud_hell_numbers = {
	Material("nz_moo/huds/t6/hud_hell_zom_num_0.png", "unlitgeneric smooth"),
	Material("nz_moo/huds/t6/hud_hell_zom_num_1.png", "unlitgeneric smooth"),
	Material("nz_moo/huds/t6/hud_hell_zom_num_2.png", "unlitgeneric smooth"),
	Material("nz_moo/huds/t6/hud_hell_zom_num_3.png", "unlitgeneric smooth"),
	Material("nz_moo/huds/t6/hud_hell_zom_num_4.png", "unlitgeneric smooth"),
	Material("nz_moo/huds/t6/hud_hell_zom_num_5.png", "unlitgeneric smooth"),
	Material("nz_moo/huds/t6/hud_hell_zom_num_6.png", "unlitgeneric smooth"),
	Material("nz_moo/huds/t6/hud_hell_zom_num_7.png", "unlitgeneric smooth"),
	Material("nz_moo/huds/t6/hud_hell_zom_num_8.png", "unlitgeneric smooth"),
	Material("nz_moo/huds/t6/hud_hell_zom_num_9.png", "unlitgeneric smooth"),
}

local t6_hud_buried_numbers = {
	Material("nz_moo/huds/t6/hud_buried_zom_num_0.png", "unlitgeneric smooth"),
	Material("nz_moo/huds/t6/hud_buried_zom_num_1.png", "unlitgeneric smooth"),
	Material("nz_moo/huds/t6/hud_buried_zom_num_2.png", "unlitgeneric smooth"),
	Material("nz_moo/huds/t6/hud_buried_zom_num_3.png", "unlitgeneric smooth"),
	Material("nz_moo/huds/t6/hud_buried_zom_num_4.png", "unlitgeneric smooth"),
	Material("nz_moo/huds/t6/hud_buried_zom_num_5.png", "unlitgeneric smooth"),
	Material("nz_moo/huds/t6/hud_buried_zom_num_6.png", "unlitgeneric smooth"),
	Material("nz_moo/huds/t6/hud_buried_zom_num_7.png", "unlitgeneric smooth"),
	Material("nz_moo/huds/t6/hud_buried_zom_num_8.png", "unlitgeneric smooth"),
	Material("nz_moo/huds/t6/hud_buried_zom_num_9.png", "unlitgeneric smooth"),
}

local t6_hud_tomb_numbers = {
	Material("nz_moo/huds/t6/hud_tomb_zom_num_0.png", "unlitgeneric smooth"),
	Material("nz_moo/huds/t6/hud_tomb_zom_num_1.png", "unlitgeneric smooth"),
	Material("nz_moo/huds/t6/hud_tomb_zom_num_2.png", "unlitgeneric smooth"),
	Material("nz_moo/huds/t6/hud_tomb_zom_num_3.png", "unlitgeneric smooth"),
	Material("nz_moo/huds/t6/hud_tomb_zom_num_4.png", "unlitgeneric smooth"),
	Material("nz_moo/huds/t6/hud_tomb_zom_num_5.png", "unlitgeneric smooth"),
	Material("nz_moo/huds/t6/hud_tomb_zom_num_6.png", "unlitgeneric smooth"),
	Material("nz_moo/huds/t6/hud_tomb_zom_num_7.png", "unlitgeneric smooth"),
	Material("nz_moo/huds/t6/hud_tomb_zom_num_8.png", "unlitgeneric smooth"),
	Material("nz_moo/huds/t6/hud_tomb_zom_num_9.png", "unlitgeneric smooth"),
}

//t6 powerup
local t6_powerup_minigun = Material("nz_moo/icons/bo2/charred_powerup_deathmachine.png", "unlitgeneric")
local t6_powerup_blood = Material("nz_moo/icons/bo2/charred_powerup_blood_alt_alt.png", "unlitgeneric")
local t6_powerup_2x = Material("nz_moo/icons/bo2/charred_powerup_2x.png", "unlitgeneric")
local t6_powerup_killjoy = Material("nz_moo/icons/bo2/charred_powerup_instakill.png", "unlitgeneric")
local t6_powerup_firesale = Material("nz_moo/icons/bo2/charred_powerup_sale.png", "unlitgeneric")
local t6_powerup_bonfiresale = Material("nz_moo/icons/bo2/charred_powerup_bonfire.png", "unlitgeneric")

//t6 inventory
local t6_icon_shield = Material("nz_moo/icons/zm_riotshield_icon.png", "unlitgeneric smooth")
local t6_icon_special = Material("nz_moo/huds/t6/hud_minigun.png", "unlitgeneric smooth")
local t6_icon_grenade = Material("nz_moo/hud_grenade_bo2.png", "unlitgeneric smooth")
local t6_icon_semtex = Material("nz_moo/huds/t5/hud_sticky_grenade.png", "unlitgeneric smooth")
local t6_icon_trap = Material("nz_moo/icons/zm_turbine_icon.png", "unlitgeneric smooth")
local t6_icon_gl = Material("nz_moo/huds/t6/hud_gl_select_big.png", "unlitgeneric smooth")
local t6_icon_shovel = Material("nz_moo/huds/t6/zom_hud_craftable_tank_shovel.png", "unlitgeneric smooth")
local t6_icon_shovel_gold = Material("nz_moo/huds/t6/zom_hud_shovel_gold.png", "unlitgeneric smooth")

//universal
local zmhud_vulture_glow = Material("nz_moo/huds/t6/specialty_vulture_zombies_glow.png", "unlitgeneric smooth")
local zmhud_dpad_compass = Material("nz_moo/huds/t6/compass_white.png", "unlitgeneric smooth noclamp")
local zmhud_icon_holygrenade = Material("nz_moo/hud_holygrenade.png", "unlitgeneric smooth")
local zmhud_icon_frame = Material("nz_moo/icons/perk_frame.png", "unlitgeneric smooth")
local zmhud_icon_missing = Material("nz_moo/icons/statmon_warning_scripterrors.png", "unlitgeneric smooth")
local zmhud_icon_player = Material("nz_moo/icons/offscreenobjectivepointer.png", "unlitgeneric smooth")
local zmhud_icon_death = Material("vgui/hud/grenadepointer.png", "unlitgeneric smooth")
local zmhud_icon_mule = Material("perk_icons/waw/mule.png", "unlitgeneric smooth")
local zmhud_icon_talk = Material("nz_moo/icons/talkballoon.png", "unlitgeneric smooth")
local zmhud_icon_voiceon = Material("nz_moo/icons/voice_on.png", "unlitgeneric smooth")
local zmhud_icon_voicedim = Material("nz_moo/icons/voice_on_dim.png", "unlitgeneric smooth")
local zmhud_icon_voiceoff = Material("nz_moo/icons/voice_off.png", "unlitgeneric smooth")
local zmhud_icon_offscreen = Material("nz_moo/icons/offscreen_arrow.png", "unlitgeneric smooth")

local illegalspecials = {
	["specialgrenade"] = true,
	["grenade"] = true,
	["knife"] = true,
	["display"] = true,
}

local function StatesHud_t6_dlc()
	if cl_drawhud:GetBool() then
		local text = ""
		local font = ("nz.main.blackops2")
		local w, h = ScrW(), ScrH()
		local pscale = (w/1920 + 1) / 2

		if nzRound:InState(ROUND_WAITING) then
			text = "Waiting for players. Type /ready to ready up."
			font = ("nz.small.blackops2")
		elseif nzRound:InState(ROUND_CREATE) then
			text = "Creative Mode"
		elseif nzRound:InState(ROUND_GO) then
			text = "Game Over"
		end

		local fontColor = !IsColor(nzMapping.Settings.textcolor) and color_red_200 or nzMapping.Settings.textcolor
		draw.SimpleTextOutlined(text, font, w/2, 60*pscale, fontColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black_100)
	end
end

local function GetButtonDown(key)
	if not key then key = 0 end
	return (input_isbuttondown(key))
end

local PointsNotifications = {}
local function PointsNotification(ply, amount)
	if not IsValid(ply) then return end
	local data = {ply = ply, amount = amount, diry = math.random(-25, 25), time = CurTime()}
	table_insert(PointsNotifications, data)
end

net.Receive("nz_points_notification_bo2_dlc", function()
	local amount = net.ReadInt(20)
	local ply = net.ReadEntity()
	PointsNotification(ply, amount)
end)

//Equipment
local function InventoryHUD_t6_dlc()
	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	if ply:IsNZMenuOpen() then return end
	if IsValid(ply:GetObserverTarget()) then
		ply = ply:GetObserverTarget()
	end

	local ammofont =  ("nz.ammo.blackops2")
	local ammo2font =  ("nz.ammo2.blackops2")

	local w, h = ScrW(), ScrH()
	local scale = ((w/1920) + 1) / 2
	local plyweptab = ply:GetWeapons()

	// Special Weapon Categories
	for _, wep in pairs(plyweptab) do
		// Traps
		if wep.IsTFAWeapon and wep.NZSpecialCategory == "trap" then
			local icon = t6_icon_trap
			if wep.NZHudIcon then
				icon = wep.NZHudIcon
			end
			if not icon or icon:IsError() then
				icon = zmhud_icon_missing
			end

			surface.SetMaterial(icon)
			surface.SetDrawColor(color_white)
			surface.DrawTexturedRect((w - 45*scale) - (24*scale), (h - 115*scale) - (24*scale), 48*scale, 48*scale)
		end

		// Specialists
		if wep.IsTFAWeapon and wep.NZSpecialCategory == "specialist" then
			local icon = t6_icon_special
			if wep.NZHudIcon then
				icon = wep.NZHudIcon
			end
			if not icon or icon:IsError() then
				icon = zmhud_icon_missing
			end

			surface.SetMaterial(icon)
			surface.SetDrawColor(color_white)
			surface.DrawTexturedRect((w - 92*scale) - (24*scale), (h - 60*scale) - (24*scale), 48*scale, 48*scale)
		end

		// Shield Slot Occupier
		if wep.IsTFAWeapon and wep.NZSpecialCategory == "shield" and wep.NZHudIcon and not wep.ShieldEnabled then
			local icon = t6_icon_shield
			if wep.NZHudIcon then
				icon = wep.NZHudIcon
			end
			if not icon or icon:IsError() then
				icon = zmhud_icon_missing
			end

			surface.SetMaterial(icon)
			surface.SetDrawColor(color_white)
			surface.DrawTexturedRect((w - 92*scale) - (24*scale), (h - 165*scale) - (24*scale), 48*scale, 48*scale)
		end
	end

	// Shield
	if ply.GetShield and IsValid(ply:GetShield()) then
		local shield = ply:GetShield()
		local wep = shield:GetWeapon()

		local icon = t6_icon_shield
		if IsValid(wep) and wep.NZHudIcon then
			icon = wep.NZHudIcon
		end
		if not icon or icon:IsError() then
			icon = zmhud_icon_missing
		end

		surface.SetMaterial(icon)
		surface.SetDrawColor(color_white)
		surface.DrawTexturedRect((w - 92*scale) - (24*scale), (h - 165*scale) - (24*scale), 48*scale, 48*scale)
	end
end

local function ScoreHud_t6_dlc()
	if not cl_drawhud:GetBool() then return end
	if not (nzRound:InProgress() or nzRound:InState(ROUND_CREATE)) then return end

	local hudtype = nzMapping.Settings.hudtype
	if not t6_dlcHUDs[hudtype] then return end

	local smallfont = "nz.small.blackops2"
	local fontsmall = "nz.points.blackops2"
	local fontnade = "nz.grenade"

	local w, h = ScrW(), ScrH()
	local scale = (w/1920 + 1) / 2
	local offset = 60

	local ply = LocalPlayer()
	if IsValid(ply:GetObserverTarget()) then
		ply = ply:GetObserverTarget()
	end

	local plyindex = ply:EntIndex()
	local plytab = player.GetAll()
	local istheplayer = false
	local wide = false
	if nz_shownames:GetBool() then
		wide = true
	end

	surface.SetDrawColor(color_white)
	local function DrawPointsNum(points, index, offset, big)
		local num = string_split(points, "")[index]+1
		if hudtype == "Mob of the Dead" then
			surface.SetMaterial(t6_hud_hell_numbers[num])
		elseif hudtype == "Buried" then
			surface.SetMaterial(t6_hud_buried_numbers[num])
		elseif hudtype == "Origins (Black Ops 2)" then
			surface.SetMaterial(t6_hud_tomb_numbers[num])
		end
		surface.DrawTexturedRect(w - ((big and 250 or 240) - index*24)*scale, h - ((big and 235 or 245)*scale) - offset, 32*scale, 64*scale)
	end

	for k, v in pairs(plytab) do
		local index = v:EntIndex()
		if index == plyindex then istheplayer = true end

		local pcolor = player.GetColorByIndex(index)
		if nz_useplayercolor:GetBool() then
			local pvcol = v:GetPlayerColor()
			pcolor = Color(255*pvcol.x, 255*pvcol.y, 255*pvcol.z, 255)
		end

		/*if nz_showhealthmp:GetBool() then
			offset = offset + 5 //health bar offset buffer
		end*/
		if istheplayer then
			offset = offset + 20
		end

		//points
		if istheplayer then
			surface.SetDrawColor(color_blood_score)
			surface.SetMaterial(t6_hud_score)
			surface.DrawTexturedRect(w - 235*scale, h - 230*scale - offset, 210*scale, 50*scale)
		end

		local points = v:GetPoints()
		surface.SetDrawColor(color_white)
		for i=1, string_len(points) do
			DrawPointsNum(points, i, offset, istheplayer)
		end
		v.PointsSpawnPosition = {x = w - 240*scale, y = h - (205*scale) - offset}

		//icon
		local pmpath = Material("spawnicons/"..string_gsub(v:GetModel(),".mdl",".png"), "unlitgeneric smooth")
		if not pmpath or pmpath:IsError() then
			pmpath = zmhud_icon_missing
		end

		surface.SetDrawColor(color_white)
		surface.SetMaterial(pmpath)
		surface.DrawTexturedRect(w - 60*scale, h - (istheplayer and 230 or 235)*scale - offset, (istheplayer and 48 or 40)*scale, (istheplayer and 48 or 40)*scale)

		surface.SetDrawColor(pcolor)
		surface.DrawOutlinedRect(w - 60*scale, h - (istheplayer and 230 or 235)*scale - offset, (istheplayer and 50 or 42)*scale, (istheplayer and 50 or 42)*scale, 2)

		//shovel
		if v.GetShovel and IsValid(v:GetShovel()) then
			local pshovel = v:GetShovel()

			surface.SetMaterial(pshovel:IsGolden() and t6_icon_shovel_gold or t6_icon_shovel)
			surface.SetDrawColor(color_white)
			surface.DrawTexturedRect(w - (90*scale), h - ((istheplayer and 210 or 225)*scale) - offset, 32, 32)
		end

		//indicator
		if nz_indicators:GetBool() and v:GetNotDowned() and not istheplayer then
			local pos = ply:GetPos()
			local epos = v:GetPos()

			local ang = nz_indicatorangle:GetFloat()
			local dir = ply:EyeAngles():Forward()
			local facing = (pos - epos):GetNormalized()

			if (facing:Dot(dir) + 1) / 2 > ang then
				local screen = ScreenScale(8)
				local xscale = ScreenScale(260)
				local yscale = ScreenScale(160)

				local dist = math.Clamp(pos:Distance(epos) / 200, 0, 1)
				local dir = (epos - pos):Angle()
				dir = dir - EyeAngles()
				local angle = dir.y + 90

				local x = (math.cos(math.rad(angle)) * xscale) + w / 2
				local y = (math.sin(math.rad(angle)) * -yscale) + h / 2

				surface.SetMaterial(zmhud_icon_player)
				surface.SetDrawColor(pcolor)
				if v:IsDormant() then
					surface.SetDrawColor(ColorAlpha(pcolor, 40))
				end
				if v:GetNW2Float("nz.LastHit", 0) + 0.35 > CurTime() then
					surface.SetDrawColor(color_used)
				end

				surface.DrawTexturedRectRotated(x, y, screen*2, screen, angle - 90)
			end
		end

		//nickname
		if nz_shownames:GetBool() then
			local nick = v:Nick()
			if #nick > 20 then
				nick = string.sub(nick, 1, 20) //limit name to 20 chars
			end

			if v:IsSpeaking() then
				local icon = zmhud_icon_voicedim
				if v:VoiceVolume() > 0 then
					icon = zmhud_icon_voiceon
				end
				if v:IsMuted() then
					icon = zmhud_icon_voiceoff
				end
				if istheplayer and not voiceloopback:GetBool() then
					icon = zmhud_icon_voiceon
				end

				surface.SetFont(fontsmall)
				local tw, th = surface.GetTextSize(nick)

				surface.SetMaterial(icon)
				surface.SetDrawColor(color_white)
				surface.DrawTexturedRect((w - 215*scale) - 32, h - (245*scale) - offset - 16, 32, 32)
			end

			draw.SimpleTextOutlined(nick, fontsmall, w - 215*scale, h - (245*scale) - offset, pcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 1, color_black)

			offset = offset + 25 //nickname offset buffer
		end

		offset = offset + (50*scale)
		istheplayer = false
	end

	if nz_clientpoints:GetBool() then
		for k, v in pairs(plytab) do
			if v:GetPoints() >= 0 then
				if not v.LastPoints then v.LastPoints = 0 end
				if v:GetPoints() ~= v.LastPoints then
					PointsNotification(v, v:GetPoints() - v.LastPoints)
					v.LastPoints = v:GetPoints()
				end
			end
		end
	end

	for k, v in pairs(PointsNotifications) do
		local fade = math.Clamp((CurTime()-v.time), 0, 1)
		local fadeinvert = 1 - fade
		local points1 = ColorAlpha(color_points1, 255*fadeinvert)
		local points2 = ColorAlpha(color_points2, 255*fadeinvert)
		local points4 = ColorAlpha(color_points4, 255*fadeinvert)

		if not v.ply.PointsSpawnPosition then return end

		if v.amount >= 0 then
			if v.amount >= 100 then --If you're earning 100 points or more, the notif will be green!
				draw.SimpleText("+"..v.amount, fontsmall, v.ply.PointsSpawnPosition.x - 50*fade, v.ply.PointsSpawnPosition.y + v.diry*fade, points2, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			end
			if v.amount < 100 then --If you're earning less than 100 points, the notif will be gold!
				draw.SimpleText("+"..v.amount, fontsmall, v.ply.PointsSpawnPosition.x - 50*fade, v.ply.PointsSpawnPosition.y + v.diry*fade, points1, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
			end
		else --If you're doing something that subtracts points, the notif will be red!
			draw.SimpleText(v.amount, fontsmall, v.ply.PointsSpawnPosition.x - 50*fade, v.ply.PointsSpawnPosition.y + v.diry*fade, points4, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)
		end

		if fade >= 1 then
			table_remove(PointsNotifications, k)
		end
	end
end

local lerpcol_white = Color(255, 255, 255, 255)
local lerpcol_red = Color(200, 0, 0, 255)
local emptyclipdie = false
local emptycliptime = 0

local emptyclip2die = false
local emptyclip2time = 0

local function GunHud_t6_dlc()
	if not cl_drawhud:GetBool() then return end

	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	if ply:IsNZMenuOpen() then return end
	if IsValid(ply:GetObserverTarget()) then
		ply = ply:GetObserverTarget()
	end

	local w, h = ScrW(), ScrH()
	local scale = ((w/1920) + 1) / 2
	local wep = ply:GetActiveWeapon()

	local hudtype = nzMapping.Settings.hudtype
	if not t6_dlcHUDs[hudtype] then return end

	local ammofont = ("nz.ammo.blackops2")
	local ammo2font = ("nz.ammo2.blackops2")
	local smallfont = ("nz.small.blackops2")
	local mainfont = ("nz.main.blackops2")
	local fontsmall = "nz.points.blackops2"
	local fontColor = !IsColor(nzMapping.Settings.textcolor) and color_red_200 or nzMapping.Settings.textcolor

	surface.SetDrawColor(color_white)

	//main hud
	surface.SetMaterial(t6_hud_dpad_bar_dlc[hudtype])
	surface.DrawTexturedRect(w - 480*scale, h - 70*scale, 256*scale*1.5, 16*scale*1.5)

	surface.SetMaterial(t6_hud_dpad_dlc[hudtype])
	surface.DrawTexturedRect(w - 190*scale, h - 210*scale, 128*scale*1.5, 128*scale*1.5)

	//compass hud
	if nz_showcompass:GetBool() then
		local angle = -ply:EyeAngles().y/360 + 0.016

		surface.SetMaterial(zmhud_dpad_compass)
		surface.SetDrawColor(color_white)
		surface.DrawTexturedRectUV(w - 256*scale, h - 242*scale, 256*scale, 64*scale, 0 + angle , 0, 0.5 + angle , 1)
	end

	local function DrawClipNum(clip, index, color)
		if not color then color = color_white end
		surface.SetDrawColor(color)
		local num = string_split(string.reverse(clip), "")[index]+1
		if hudtype == "Mob of the Dead" then
			surface.SetMaterial(t6_hud_hell_numbers[num])
		elseif hudtype == "Buried" then
			surface.SetMaterial(t6_hud_buried_numbers[num])
		elseif hudtype == "Origins (Black Ops 2)" then
			surface.SetMaterial(t6_hud_tomb_numbers[num])
		end
		surface.DrawTexturedRect(w - (270 + index*32)*scale, h - 150*scale, 32*scale*1.4, 64*scale*1.4)
	end

	local function DrawClip2Num(clip2, index, buffer, color)
		if not color then color = color_white end
		surface.SetDrawColor(color)
		local num = string_split(string.reverse(clip2), "")[index]+1
		if hudtype == "Mob of the Dead" then
			surface.SetMaterial(t6_hud_hell_numbers[num])
		elseif hudtype == "Buried" then
			surface.SetMaterial(t6_hud_buried_numbers[num])
		elseif hudtype == "Origins (Black Ops 2)" then
			surface.SetMaterial(t6_hud_tomb_numbers[num])
		end
		surface.DrawTexturedRect(w - ((270 + buffer) + index*32)*scale, h - 150*scale, 32*scale*1.4, 64*scale*1.4)
	end

	local function DrawAmmoNum(ammo, index)
		surface.SetDrawColor(color_white)
		local num = string_split(ammo, "")[index]+1
		if hudtype == "Mob of the Dead" then
			surface.SetMaterial(t6_hud_hell_numbers[num])
		elseif hudtype == "Buried" then
			surface.SetMaterial(t6_hud_buried_numbers[num])
		elseif hudtype == "Origins (Black Ops 2)" then
			surface.SetMaterial(t6_hud_tomb_numbers[num])
		end

		surface.DrawTexturedRect(w - (270 - index*24)*scale, h - 130*scale, 32*scale, 64*scale)
	end

	//weapon hud
	if IsValid(wep) then
		local class = wep:GetClass()
		if wep.NZWonderWeapon then
			fontColor = Color(0, 255, 255, 255)
		end
		if wep.NZSpecialCategory == "specialist" then
			fontColor = Color(180, 0, 0, 255)
		end

		if class == "nz_multi_tool" then
			draw.SimpleTextOutlined(nzTools.ToolData[wep.ToolMode].displayname or wep.ToolMode, ammofont, w - 170*scale, h - 145*scale, fontColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 2, color_black)
			draw.SimpleTextOutlined(nzTools.ToolData[wep.ToolMode].desc or "", smallfont, w - 170*scale, h - 70*scale, fontColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 2, color_black)
		elseif illegalspecials[wep.NZSpecialCategory] then
			local name = wep:GetPrintName()
			draw.SimpleTextOutlined(name, fontsmall, w - 170*scale, h - 145*scale, fontColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 2, color_black_50)
		elseif not illegalspecials[wep.NZSpecialCategory] then
			if wep.Primary then
				local clip = wep.Primary.ClipSize
				local resclip = wep.Primary.DefaultClip
				local clip1 = wep:Clip1()

				local flashing_sin = math.abs(math.sin(CurTime()*4))
				local ammoType = wep:GetPrimaryAmmoType()
				local ammoTotal = ply:GetAmmoCount(ammoType)

				local ammoCol = Color(255, 255, 255, 255)
				local lowclip = false

				if wep.CanBeSilenced and wep:GetSilenced() then
					if wep.Clip3 then
						clip = wep.Tertiary.ClipSize
						resclip = wep.Tertiary.DefaultClip
						clip1 = wep:Clip3()
					else
						clip = wep.Secondary.ClipSize
						resclip = wep.Secondary.DefaultClip
						clip1 = wep:Clip2()
					end
					ammoTotal = ply:GetAmmoCount(wep:GetSecondaryAmmoType())
				end

				if clip and (clip > 1 or clip1 == 0) and clip1 <= math.ceil(clip/4) then
					lowclip = true

					ammoCol.r = Lerp(flashing_sin, lerpcol_red.r, lerpcol_white.r)
					ammoCol.g = Lerp(flashing_sin, lerpcol_red.g, lerpcol_white.g)
					ammoCol.b = Lerp(flashing_sin, lerpcol_red.b, lerpcol_white.b)
				end

				local ammolen = string_len(ammoTotal)
				local cliplen = string_len(clip1)

				if clip and clip > 0 then
					if ammoType == -1 then
						//for weapons that only use clip1 and dont have an ammo pool
						for i=1, cliplen do
							DrawClipNum(clip1, i, ammoCol)
							surface.SetDrawColor(color_white)
							surface.SetMaterial(t6_hud_num_slash[hudtype])
							surface.DrawTexturedRect(w - (265*scale), h - 130*scale, 32*scale, 64*scale)
							for i=1, string_len(resclip) do
								DrawAmmoNum(resclip, i)
							end
						end
					else
						//normal weapons
						for i=1, cliplen do
							DrawClipNum(clip1, i, ammoCol)
						end
						if resclip and resclip > 0 then
							surface.SetDrawColor(color_white)
							surface.SetMaterial(t6_hud_num_slash[hudtype])
							surface.DrawTexturedRect(w - (265*scale), h - 130*scale, 32*scale, 64*scale)
							for i=1, ammolen do
								DrawAmmoNum(ammoTotal, i)
							end
						end
					end
				else
					//weapons that dont have a clip1 and use the ammo pool
					if resclip and resclip > 0 then
						for i=1, ammolen do
							DrawClipNum(ammoTotal, i, color_white)
							surface.SetDrawColor(color_white)
							surface.SetMaterial(t6_hud_num_slash[hudtype])
							surface.DrawTexturedRect(w - (265*scale), h - 130*scale, 32*scale, 64*scale)
							for i=1, string_len(resclip) do
								DrawAmmoNum(resclip, i)
							end
						end
					end
				end
			end

			if wep.Secondary and (not wep.CanBeSilenced or (wep.CanBeSilenced and not wep:GetSilenced() and wep.Clip3)) then
				local clip2size = wep.Secondary.ClipSize
				local resclip2 = wep.Secondary.DefaultClip
				local clip2 = wep:Clip2()

				local flashing_sin = math.abs(math.sin(CurTime()*4))
				local clipsize = wep.Primary.ClipSize
				local ammoTotal = ply:GetAmmoCount(wep:GetPrimaryAmmoType())
				local ammoType2 = wep:GetSecondaryAmmoType()
				local ammoTotal2 = ply:GetAmmoCount(ammoType2)

				local ammoCol = Color(255, 255, 255, 255)
				local lowclip = false

				if clip2size and clip2size > 0 and clip2 <= math.ceil(clip2size/4) then
					lowclip = true

					ammoCol.r = Lerp(flashing_sin, lerpcol_red.r, lerpcol_white.r)
					ammoCol.g = Lerp(flashing_sin, lerpcol_red.g, lerpcol_white.g)
					ammoCol.b = Lerp(flashing_sin, lerpcol_red.b, lerpcol_white.b)
					ammoCol.a = Lerp(flashing_sin, lerpcol_red.a, lerpcol_white.a)
				end

				local diff2 = math.max(string_len(wep:Clip1()), 1.5)*(32*1.4)

				if clip2size and clip2size > 0 then
					//akimbo weapons
					surface.SetDrawColor(color_white)
					surface.SetMaterial(t6_hud_num_line[hudtype])
					surface.DrawTexturedRect(w - (270 + diff2)*scale, h - 145*scale, 32*scale*1.4, 64*scale*1.4)
					for i=1, string_len(clip2) do
						DrawClip2Num(clip2, i, diff2, ammoCol)
					end
				else
					//weapons that have a secondary ammo pool but no clip2
					if ammoTotal2 and ammoTotal2 > 0 then
						surface.SetDrawColor(color_white)
						surface.SetMaterial(t6_hud_num_line[hudtype])
						surface.DrawTexturedRect(w - (270 + diff2)*scale, h - 145*scale, 32*scale*1.4, 64*scale*1.4)
						for i=1, string_len(ammoTotal2) do
							DrawClip2Num(ammoTotal2, i, diff2, ammoCol)
						end
					end
				end
			end

			//silencer/underbarrel/altattack
			if wep.CanBeSilenced then
				local icon = t6_icon_gl
				if wep.NZHudIcon then
					icon = wep.NZHudIcon
				end
				if not icon or icon:IsError() then
					icon = zmhud_icon_missing
				end

				surface.SetMaterial(icon)
				surface.DrawTexturedRect((w - 140*scale) - (24*scale), (h - 115*scale) - (24*scale), 48*scale, 48*scale)

				local ammoTotal2 = ply:GetAmmoCount(wep:GetSecondaryAmmoType()) + (wep.Clip3 and wep:Clip3() or wep:Clip2())
				if ammoTotal2 > 0 then
					draw.SimpleTextOutlined(ammoTotal2, ammofont, w - 135*scale, h - 100*scale, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 2, color_black_50)
				end
			end

			local name = wep:GetPrintName()
			draw.SimpleTextOutlined(name, fontsmall, w - 170*scale, h - 145*scale, fontColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 2, color_black_50)

			if nz_showgun:GetBool() and killicon.Exists(class) then
				surface.SetFont(fontsmall)
				local tw, th = surface.GetTextSize(name)

				killicon.Draw(w - 170*scale - (64*scale) - tw, h - 145*scale - (32*scale), class, 255)
			end

			if ply:HasPerk("mulekick") then
				surface.SetDrawColor(color_white_50)
				if IsValid(wep) and wep:GetNWInt("SwitchSlot") == 3 then
					surface.SetDrawColor(color_white)
				end
				surface.SetMaterial(zmhud_icon_mule)
				surface.DrawTexturedRect(w - 165*scale, h - 200*scale, 35*scale, 35*scale)
			end
		end
	end

	//grenade hud
	local num = ply:GetAmmoCount(GetNZAmmoID("grenade") or -1)
	local numspecial = ply:GetAmmoCount(GetNZAmmoID("specialgrenade") or -1)
	local scale = (w/1920 + 1) / 2

	if num > 0 then
		surface.SetDrawColor(color_white)
		surface.SetMaterial(t6_icon_grenade)
		if ply:HasPerk("widowswine") then
			surface.SetMaterial(t6_icon_semtex)
		end
		if ply:HasWeapon("nz_holy") and not ply:HasPerk("widowswine") then
			surface.SetMaterial(zmhud_icon_holygrenade) -- Replaces Lethals!!!
		end
		for i = num, 1, -1 do
			surface.SetDrawColor(color_white)
			surface.DrawTexturedRect(w - 70*scale - i*(35*scale), h - 35*scale, 32*scale, 32*scale)
		end
	end

	if numspecial > 0 then
		local icon = t6_icon_grenade
		local plyweptab = ply:GetWeapons()

		for _, wep in pairs(plyweptab) do
			if wep.NZSpecialCategory == "specialgrenade" and wep.NZHudIcon then
				icon = wep.NZHudIcon
				break
			end
		end

		if not icon or icon:IsError() then
			icon = zmhud_icon_missing
		end

		surface.SetMaterial(icon)
		for i = numspecial, 1, -1 do
			surface.SetDrawColor(color_white)
			surface.DrawTexturedRect(w - 230*scale - i*(35*scale), h - 35*scale, 32*scale, 32*scale)
		end
	end
end

local function PerksMMOHud_t6_dlc()
	if not cl_drawhud:GetBool() then return end
	if not nz_showmmostats:GetBool() then return end

	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	if ply:IsNZMenuOpen() then return end
	if IsValid(ply:GetObserverTarget()) then
		ply = ply:GetObserverTarget()
	end

	local wep = ply:GetActiveWeapon()
	if IsValid(wep) and (illegalspecials[wep.NZSpecialCategory] or wep:GetClass() == "nz_multi_tool") then return end

	local fontColor = !IsColor(nzMapping.Settings.textcolor) and color_red_200 or nzMapping.Settings.textcolor
	local w, h = ScrW(), ScrH()
	local scale = ((w/1920) + 1) / 2
	local curtime = CurTime()

	local traycount = 0
	for k, v in pairs(ply:GetPerks()) do
		local data = nzPerks:Get(v)
		if not data or not data.mmohud then continue end

		local mmohud = data.mmohud
		if not mmohud.style then continue end
		if mmohud.upgradeonly and not ply:HasUpgrade(v) then continue end

		surface.SetDrawColor(color_white)
		if (mmohud.countdown and ply:GetNW2Int(tostring(mmohud.count), 0) == 0) or (mmohud.delay and ply:GetNW2Float(tostring(mmohud.delay), 0) > curtime) then
			surface.SetDrawColor(color_white_50)
		end

		surface.SetMaterial(data.icon_waw)
		surface.DrawTexturedRect(w - 405*scale - (40*traycount*scale), h - 75*scale, 35*scale, 35*scale)

		if ply:HasUpgrade(v) and mmohud.border and ply:GetNW2Float(tostring(mmohud.upgrade), 0) < curtime then
			surface.SetDrawColor(color_gold)
			surface.SetMaterial(zmhud_icon_frame)
			surface.DrawTexturedRect(w - 405*scale - (40*traycount*scale), h - 75*scale, 35*scale, 35*scale)
		end

		if mmohud.style == "toggle" then
		elseif mmohud.style == "count" then
			draw.SimpleTextOutlined(ply:GetNW2Int(tostring(mmohud.count), 0), ChatFont, w - 370*scale - (40*traycount*scale), h - 35*scale, fontColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, color_black)
		elseif mmohud.style == "%" then
			local perkpercent = 100
			if mmohud.time then
				local perktime = ply:GetNW2Float(tostring(mmohud.delay), 0)
				local time = math.max(perktime - curtime, 0)
				perkpercent = math.Round(100 * (1 - math.Clamp(time / mmohud.max, 0, 1)))
			else
				perkpercent = 100 * (1 - math.Clamp(ply:GetNW2Int(tostring(mmohud.count), 0) / mmohud.max, 0, 1))
			end

			if (not mmohud.hide) or (mmohud.hide and perkpercent < 100) then
				draw.SimpleTextOutlined(perkpercent.."%", ChatFont, w - 370*scale - (40*traycount*scale), h - 35*scale, fontColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, color_black)
			end
		elseif mmohud.style == "chance" then
			draw.SimpleTextOutlined(ply:GetNW2Int(tostring(mmohud.count), 0).."/"..mmohud.max, ChatFont, w - 370*scale - (40*traycount*scale), h - 35*scale, fontColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, color_black)
		end

		traycount = traycount + 1
	end
end

local hud_grenadetypes = {
	["bo1_m67_grenade"] = true,
	["nz_bo3_tac_gersch"] = true,
	["nz_bo3_tac_gstrike"] = true,
	["nz_bo3_tac_lilarnie"] = true,
	["nz_bo4_tac_matryoshka"] = true,
	["nz_bo3_tac_matryoshka"] = true,
	["nz_bo3_tac_matryoshka_mini"] = true,
	["nz_bo3_tac_monkeybomb"] = true,
	["nz_bo3_tac_qed"] = true,
}

local function DeathHud_t6_dlc()
	if not cl_drawhud:GetBool() then return end
	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	if IsValid(ply:GetObserverTarget()) then
		ply = ply:GetObserverTarget()
	end

	local screen = ScreenScale(16)
	local pscale = ScreenScale(128)
	local screen2 = ScreenScale(24)

	local pos = ply:GetPos()
	local range = 160000
	local ang = 0.65
	local zeds = {}
	local nades = {}

	for i, ent in nzLevel.GetHudEntityArray() do
		if not IsValid(ent) then continue end
		if (ent.NZThrowIcon or ent.NZNadeRethrow) and (ent:GetCreationTime() + 0.3 < CurTime()) then
			local epos = ent:WorldSpaceCenter() + vector_up*10
			local data = epos:ToScreen()
			if data.visible then
				if ent.GetActivated and ent:GetActivated() then continue end
				local dist = 1 - math.Clamp(pos:DistToSqr(ent:GetPos()) / 160000, 0, 1)

				surface.SetDrawColor(ColorAlpha(color_white, 300*dist))
				surface.SetMaterial(ent.NZThrowIcon or t6_icon_grenade)
				surface.DrawTexturedRect(data.x - screen*0.5, data.y - screen*0.5, screen, screen)
			else
				if ent.NZNadeRethrow and ply ~= ent:GetOwner() then continue end
				table_insert(nades, ent)
			end
		end
	end

	for _, ent in ipairs(nades) do
		local epos = ent:GetPos()

		local dist = 1 - math.Clamp(pos:DistToSqr(epos) / 160000, 0, 1)
		local dir = (epos - pos):Angle()
		dir = dir - EyeAngles()
		local angle = dir.y + 90

		local x = (math.cos(math.rad(angle)) * pscale) + ScrW() / 2
		local y = (math.sin(math.rad(angle)) * -pscale) + ScrH() / 2

		surface.SetDrawColor(ColorAlpha(color_white, 400*dist))

		surface.SetMaterial(ent.NZThrowIcon or t6_icon_grenade)
		surface.DrawTexturedRect(x - (screen*0.5), y - (screen*0.5), screen, screen)

		if nz_useplayercolor:GetBool() then
			local owner = ent:GetOwner()
			if IsValid(owner) and owner:IsPlayer() then
				local pcol = owner:GetPlayerColor()
				surface.SetDrawColor(Color(255*pcol.x, 255*pcol.y, 255*pcol.z, math.min(400*dist, 200)))
			end
		end

		surface.SetMaterial(zmhud_icon_offscreen)
		surface.DrawTexturedRectRotated(x, y, screen2, screen2, angle - 90)
	end

	if ply:HasPerk("death") then
		for i, ent in nzLevel.GetZombieArray() do
			if not IsValid(ent) then continue end
			if ent:IsValidZombie() and ent:Alive() then
				if pos:DistToSqr(ent:GetPos()) > range then continue end
				local dir = ply:EyeAngles():Forward()
				local facing = (pos - ent:GetPos()):GetNormalized()

				if (facing:Dot(dir) + 1) / 2 > ang then
					table_insert(zeds, ent)
				end
			end
		end

		for i, ent in nzLevel.GetZombieBossArray() do
			if not IsValid(ent) then continue end
			if ent:IsValidZombie() and ent:Alive() then
				local dir = ply:EyeAngles():Forward()
				local facing = (pos - ent:GetPos()):GetNormalized()

				if (facing:Dot(dir) + 1) / 2 > ang then
					table_insert(zeds, ent)
				end
			end
		end

		for _, ent in ipairs(zeds) do
			local epos = ent:GetPos()

			local dist = math.Clamp(pos:DistToSqr(epos) / 40000, 0, 1)
			local dir = (epos - pos):Angle()
			dir = dir - EyeAngles()
			local angle = dir.y + 90

			local x = (math.cos(math.rad(angle)) * pscale) + ScrW() / 2
			local y = (math.sin(math.rad(angle)) * -pscale) + ScrH() / 2

			surface.SetMaterial(zmhud_icon_death)
			surface.SetDrawColor(Color(255,255*dist,255*dist,225))
			surface.DrawTexturedRectRotated(x, y, screen, screen, angle - 90)
		end
	end
end

local decaytime = nil
local totalWidth = 0
local downed = false

local function PowerUpsHud_t6_dlc()
	if not cl_drawhud:GetBool() then return end
	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	local spectating = false
	if IsValid(ply:GetObserverTarget()) then
		ply = ply:GetObserverTarget()
		spectating = true
	end

	local ctime = CurTime()
	local scw, sch = ScrW(), ScrH()

	local fontColor = !IsColor(nzMapping.Settings.textcolor) and color_white or nzMapping.Settings.textcolor
	local font = "nz.points.blackops2"
	local scale = (scw/1920 + 1)/2
	local width = (scw / 2) 
	local powerupsActive = 0
	local c = 0

	local function ReturnPosition(id, seconds, subtractBy) -- When the powerup disappears we need to align everything back again
		if timer.Exists(id) then return end -- We already did this, we need to wait..
		timer.Create(id, seconds, 1, function()
			totalWidth = totalWidth - (70*scale)
		end)
	end

	local function AddPowerup(material, time) -- Display another powerup on the player's screen
		local width = scw / 2 + (70*scale) * powerupsActive - totalWidth / 2

		if width - scw / 2 > totalWidth then 
			prevWidth = totalWidth
			totalWidth = width - scw / 2 
		end

		if not material or material:IsError() then
			material = zmhud_icon_missing
		end

		local timeleft = time - ctime
		local warningthreshold = 10 --at what time does the icon start blinking?
		local frequency1 = 0.25 --how long in seconds it takes for the icon to toggle visibility
		local urgencythreshold = 5 --at what time does the blinking get faster/slower?
		local frequency2 = 0.1 --how long in seconds it takes for the icon to toggle visibility in urgency mode
		if timeleft > warningthreshold or (timeleft > urgencythreshold and timeleft % (frequency1 * 2) > frequency1) or (timeleft <= urgencythreshold and timeleft % (frequency2*2) > frequency2) then
			surface.SetMaterial(material)
			surface.SetDrawColor(color_white)
			surface.DrawTexturedRect(width - 32*scale, sch - 155*scale, 64*scale, 64*scale)
			draw.SimpleTextOutlined(math.Round(timeleft), font, width, sch - 170*scale, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black_50)
		end
		powerupsActive = powerupsActive + 1
	end

	for k,v in pairs(nzPowerUps.ActivePowerUps) do	
		if nzPowerUps:IsPowerupActive(k) then
			if k == "dp" then
				AddPowerup(t6_powerup_2x, v)
				ReturnPosition("Returning" .. "dp", math.Round(v - ctime))	
			end

			if k == "insta" then
				AddPowerup(t6_powerup_killjoy, v)
				ReturnPosition("Returning" .. "insta", math.Round(v - ctime))	
			end

			if k == "firesale" then
				AddPowerup(t6_powerup_firesale, v)
				ReturnPosition("Returning" .. "firesale", math.Round(v - ctime))	
			end

			if k == "bonfiresale" then
				AddPowerup(t6_powerup_bonfiresale, v)
				ReturnPosition("Returning" .. "bonfiresale", math.Round(v - ctime))	
			end

			local powerupData = nzPowerUps:Get(k)
			--draw.SimpleText(powerupData.name .. " - " .. math.Round(v - ctime), font, w, ScrH() * 0.85 + offset * c, Color(255, 255, 255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			c = c + 1
		end
	end

	if not nzPowerUps.ActivePlayerPowerUps[ply] then nzPowerUps.ActivePlayerPowerUps[ply] = {} end
	for k,v in pairs(nzPowerUps.ActivePlayerPowerUps[ply]) do
		if nzPowerUps:IsPlayerPowerupActive(ply, k) then
			if k == "zombieblood" then
				AddPowerup(t6_powerup_blood, v)
				ReturnPosition("Returning" .. "zombieblood", math.Round(v - ctime))	
			end

			if k == "deathmachine" then
				AddPowerup(t6_powerup_minigun, v)
				ReturnPosition("Returning" .. "deathmachine", math.Round(v - ctime))	
			end

			local powerupData = nzPowerUps:Get(k)
			--draw.SimpleText(powerupData.name .. " - " .. math.Round(v - ctime), font, w, ScrH() * 0.85 + offset * c, Color(255, 255, 255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			c = c + 1
		end
	end

	if spectating then return end
	if not ply.ambiences then ply.ambiences = {} end
	if not ply.refstrings then ply.refstrings = {} end
	if not ply.picons then ply.picons = {} end

	for k, v in pairs(nzPowerUps.Data) do
		local active = false

		if v.global then
			active = nzPowerUps:IsPowerupActive(k)
		else
			if nzPowerUps.ActivePlayerPowerUps[ply] then
				active = nzPowerUps:IsPlayerPowerupActive(ply, k)
			end
		end

		if v.loopsound then
			if active then
				if not ply.refstrings[k] then --Haven't cached yet
					ply.refstrings[k] = v.loopsound
					ply.ambiences[k] = CreateSound(ply, v.loopsound)
				elseif ply.refstrings[k] ~= v.loopsound then --Cached but the sound was changed, requires re-cache
					if ply.ambiences[k] then ply.ambiences[k]:Stop() end --stop the existing sound if it's still playing

					ply.refstrings[k] = v.loopsound
					ply.ambiences[k] = CreateSound(ply, v.loopsound)
				end

				if ply.ambiences[k] then
					ply.ambiences[k]:Play()
					if ply.picons[k] then
						local timer = ply.picons[k].time - CurTime()
						ply.ambiences[k]:ChangePitch(100 + (v.nopitchshift and 0 or math.max(0, (10-timer)*5)) + (v.addpitch or 0))
					end
				end
			elseif ply.ambiences[k] then
				if v.stopsound and ply.ambiences[k]:IsPlaying() then
					ply:EmitSound(v.stopsound, 95, 100 + (v.addpitch or 0))
				end

				ply.ambiences[k]:Stop()
			end
		end
	end
end

local function PerksHud_t6_dlc()
	if not cl_drawhud:GetBool() then return end
	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	if IsValid(ply:GetObserverTarget()) then
		ply = ply:GetObserverTarget()
	end

	local scale = (ScrW()/1920 + 1)/2

	local perks = ply:GetPerks()
	local w = ScrW()/1920 + 10
	local h = ScrH()
	local size = 45

	local num = 0
	local row = 0
	local num_b = 0
	local row_b = 0

	//perk borders
	if nz_showperkframe:GetBool() then
		if nzRound:InProgress() or (#perks > 0) then
			surface.SetMaterial(zmhud_icon_frame)
			surface.SetDrawColor(color_white_100)
			for i=1, nz_perkmax:GetInt() do
				if not ply:HasUpgrade(perks[i]) then
					surface.DrawTexturedRect(w + num_b*(size + 15)*scale, h - 210*scale - 64*row_b, 52*scale, 52*scale)
				end

				num_b = num_b + 1
				if num_b%8 == 0 then
					row_b = row_b + 1
					num_b = 0
				end
			end
		end
	end

	//perk icons
	for _, perk in pairs(perks) do
		local icon = GetPerkIconMaterial(perk)
		if not icon or icon:IsError() then
			icon = zmhud_icon_missing
		end

		surface.SetMaterial(icon)
		surface.SetDrawColor(color_white)
		surface.DrawTexturedRect(w + num*(size + 15)*scale, h - 210*scale - 64*row, 52*scale, 52*scale)

		if ply:HasUpgrade(perk) then
			surface.SetDrawColor(color_gold)
			surface.SetMaterial(zmhud_icon_frame)
			surface.DrawTexturedRect(w + num*(size + 15)*scale, h - 210*scale - 64*row, 52*scale, 52*scale)
		end

		if perk == "vulture" and ply:HasVultureStink() then
			surface.SetMaterial(zmhud_vulture_glow)
			surface.SetDrawColor(color_white)
			surface.DrawTexturedRect((w + num*(size + 15)*scale) - 24*scale, (h - 210*scale - 64*row) - 24*scale, 100*scale, 100*scale)
			
			local stink = surface.GetTextureID("nz_moo/huds/t6/zm_hud_stink_ani_green")
			surface.SetTexture(stink)
			surface.SetDrawColor(color_white)
			surface.DrawTexturedRect((w + num*(size + 15)*scale), (h - 210*scale - 64*row) - 62*scale, 64*scale, 64*scale)
		end

		num = num + 1
		if num%8 == 0 then
			row = row + 1
			num = 0
		end
	end
end

local vulture_textures = {
	["nz_ammo_matic"] = Material("nz_moo/icons/vulture/fxt_zmb_question_mark.png", "smooth unlitgeneric"),
	["pap"] = Material("nz_moo/icons/vulture/fxt_zmb_perk_pap.png", "smooth unlitgeneric"),
	["wall_buys"] = Material("nz_moo/icons/vulture/fxt_zmb_perk_rifle.png", "smooth unlitgeneric"),
	["random_box"] = Material("nz_moo/icons/vulture/fxt_zmb_perk_magic_box.png", "smooth unlitgeneric"),
	["wunderfizz_machine"] = Material("nz_moo/icons/vulture/fxt_zmb_question_mark.png", "smooth unlitgeneric"),
}

local function VultureVision_t6_dlc()
	local ply = LocalPlayer()
	if IsValid(ply:GetObserverTarget()) then ply = ply:GetObserverTarget() end
	if not ply:HasPerk("vulture") then return end
	local scale = (ScrW()/1920 + 1)/2
	local icon = vulture_textures["wunderfizz_machine"] //? if unknown

	for k, v in nzLevel.GetVultureArray() do
		if not IsValid(v) then continue end

		local data = v:WorldSpaceCenter():ToScreen()
		if not data.visible then continue end

		if ply:GetPos():DistToSqr(v:GetPos()) > 562500  then continue end //750^2

		local class = v:GetClass()

		if vulture_textures[class] then
			icon = vulture_textures[class]
		elseif class == "perk_machine" then
			local perk = v:GetPerkID()
			if perk == "pap" then
				icon = vulture_textures["pap"]
			else
				icon = GetPerkIconMaterial(perk)
			end
		end

		if not icon or icon:IsError() then
			icon = zmhud_icon_missing
		end

		surface.SetMaterial(icon)
		surface.SetDrawColor(color_white_150)
		surface.DrawTexturedRect(data.x - 21*scale, data.y - 21*scale, 42*scale, 42*scale)
	end
end

//This is a modified Classic nZ Round Counter... If you want a Counter thats styled after the classic era of Zombies, use this one.
local round_white = 0
local round_alpha = 255
local round_num = 0
local infmat = Material("materials/nz_moo/round_tallies/chalk_infinity.png", "smooth")
local tallymats = {
	Material("nz_moo/round_tallies/bo1_tallies/chalkmarks_bo1_1.png", "unlitgeneric smooth"),
	Material("nz_moo/round_tallies/bo1_tallies/chalkmarks_bo1_2.png", "unlitgeneric smooth"),
	Material("nz_moo/round_tallies/bo1_tallies/chalkmarks_bo1_3.png", "unlitgeneric smooth"),
	Material("nz_moo/round_tallies/bo1_tallies/chalkmarks_bo1_4.png", "unlitgeneric smooth"),
	Material("nz_moo/round_tallies/bo1_tallies/chalkmarks_bo1_5.png", "unlitgeneric smooth")
}

local function RoundHud_t6_dlc()
	local text = ""
	local font = ("nz.rounds.blackops2")
	local w, h = ScrW()/1920, ScrH()
	local scale = (ScrW()/1920 + 1)/2

	local round = round_num
	local color = Color(color_blood.r + round_white, round_white, round_white, round_alpha)
	surface.SetDrawColor(color)

	if round == -1 then
		surface.SetMaterial(infmat)
		surface.DrawTexturedRect(w + 10*scale, h - 115*scale, 200*scale, 100*scale)
		return
	end
	if round <= 10 and round > 0 then
		if round <= 5 then -- Instead of using text for the tallies, We're now using the actual tally textures instead.
			surface.SetMaterial(tallymats[round])
			surface.DrawTexturedRect(w*scale, h - 150*scale, 140*scale, 140*scale)
		end
        if round <= 10 and round > 5 then
			surface.SetMaterial(tallymats[5]) -- Always display five.
			surface.DrawTexturedRect(w*scale, h - 150*scale, 140*scale, 140*scale)
			surface.SetMaterial(tallymats[round - 5])
			surface.DrawTexturedRect(w + 150*scale, h - 150*scale, 140*scale, 140*scale)
		end
	else
		text = round
		draw.SimpleText(text, font, w + 15*scale, h + 5*scale, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
    end
end

local roundchangeending = false
local prevroundspecial = false
local function StartChangeRound_t6_dlc()
	local lastround = nzRound:GetNumber()

	if lastround >= 1 then
		if prevroundspecial then
			nzSounds:Play("SpecialRoundEnd")
		else
			nzSounds:Play("RoundEnd")
		end
	elseif lastround == -2 then
		surface.PlaySound("nz/round/round_-1_prepare.mp3")
	else
		round_num = 1
	end

	roundchangeending = false
	round_white = 255
	local round_charger = 0.25
	local alphafading = false
	local haschanged = false
	hook.Add("HUDPaint", "nz_roundnumWhiteFade", function()
		if not alphafading then
			round_white = math.Approach(round_white, round_charger > 0 and 255 or 0, round_charger*350*FrameTime())
			if round_white >= 255 and not roundchangeending then
				alphafading = true
				round_charger = -1
			elseif round_white <= 0 and roundchangeending then
				hook.Remove("HUDPaint", "nz_roundnumWhiteFade")
			end
		else
			round_alpha = math.Approach(round_alpha, round_charger > 0 and 255 or 0, round_charger*350*FrameTime())
			if round_alpha >= 255 then
				if haschanged then
					round_charger = -0.25
					alphafading = false
				else
					round_charger = -1
				end
			elseif round_alpha <= 0 then
				if roundchangeending then
					round_num = nzRound:GetNumber()
					round_charger = 0.5
					if round_num == -1 then
					elseif nzRound:IsSpecial() then
						nzSounds:Play("SpecialRoundStart")
						prevroundspecial = true
					else
						nzSounds:Play("RoundStart")
						prevroundspecial = false
					end
					haschanged = true
				else
					round_charger = 1
				end
			end
		end
	end)
end

local function EndChangeRound_t6_dlc()
	roundchangeending = true
end

local function ResetRound_t6_dlc()
	round_num = 0
end

local function PlayerHealthHUD_t6_dlc()
end
local function PlayerStaminaHUD_t6_dlc()
end

-- Hooks
hook.Add("HUDPaint", "nzHUDswapping_t6_dlc", function()
	if t6_dlcHUDs[nzMapping.Settings.hudtype] then
		hook.Add("HUDPaint", "roundHUD", StatesHud_t6_dlc )
		hook.Add("HUDPaint", "PlayerHealthBarHUD", PlayerHealthHUD_t6_dlc )
		hook.Add("HUDPaint", "PlayerStaminaBarHUD", PlayerStaminaHUD_t6_dlc )
		hook.Add("HUDPaint", "1WepInventoryHUD", InventoryHUD_t6_dlc )
		hook.Add("HUDPaint", "scoreHUD", ScoreHud_t6_dlc )
		hook.Add("HUDPaint", "powerupHUD", PowerUpsHud_t6_dlc )
		hook.Add("HUDPaint", "perksHUD", PerksHud_t6_dlc )
		hook.Add("HUDPaint", "vultureVision", VultureVision_t6_dlc )
		hook.Add("HUDPaint", "roundnumHUD", RoundHud_t6_dlc )
		hook.Add("HUDPaint", "perksmmoinfoHUD", PerksMMOHud_t6_dlc )
		hook.Add("HUDPaint", "gunHUD", GunHud_t6_dlc )
		hook.Add("HUDPaint", "deathiconsHUD", DeathHud_t6_dlc )

		hook.Add("OnRoundPreparation", "BeginRoundHUDChange", StartChangeRound_t6_dlc )
		hook.Add("OnRoundStart", "EndRoundHUDChange", EndChangeRound_t6_dlc )
		hook.Add("OnRoundEnd", "GameEndHUDChange", ResetRound_t6_dlc )
	end
end)

//--------------------------------------------------/GhostlyMoo and Fox's BO2 DLC HUD\------------------------------------------------\\
/*Gregory, do you see the small vent on the floor? 
Have you ever heard of Among Us, Gregory? 
You need to vent. 

I know it will be hard for you to be sus, 
but i know you can do it Gregory.*/