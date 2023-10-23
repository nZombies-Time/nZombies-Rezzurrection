-------------------------
-- Localize
local pairs, IsValid, LocalPlayer, CurTime, Color, ScreenScale =
	pairs, IsValid, LocalPlayer, CurTime, Color, ScreenScale

local math, surface, table, input, string, draw, killicon, file =
	math, surface, table, input, string, draw, killicon, file

local file_exists, input_getkeyname, input_isbuttondown, input_lookupbinding, table_insert, table_remove, table_isempty, table_count, table_copy =
	file.Exists, input.GetKeyName, input.IsButtonDown, input.LookupBinding, table.insert, table.remove, table.IsEmpty, table.Count, table.Copy

local string_len, string_sub, string_gsub, string_upper, string_rep, string_match, string_split =
	string.len, string.sub, string.gsub, string.upper, string.rep, string.match, string.Split

local TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, TEXT_ALIGN_BOTTOM =
	TEXT_ALIGN_CENTER, TEXT_ALIGN_LEFT, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, TEXT_ALIGN_BOTTOM

local voiceloopback = GetConVar("voice_loopback")
local cl_drawhud = GetConVar("cl_drawhud")
local nz_clientpoints = GetConVar("nz_point_notification_clientside")
local nz_perkmax = GetConVar("nz_difficulty_perks_max")

local nz_showhealth = GetConVar("nz_hud_show_health")
local nz_showhealthmp = GetConVar("nz_hud_show_health_mp")
local nz_showstamina = GetConVar("nz_hud_show_stamina")

local nz_showmmostats = GetConVar("nz_hud_show_perkstats")
local nz_showcompass = GetConVar("nz_hud_show_compass")
local nz_shownames = GetConVar("nz_hud_show_names")
local nz_showgun = GetConVar("nz_hud_show_wepicon")
local nz_showperkframe = GetConVar("nz_hud_show_perk_frames")

local nz_indicators = GetConVar("nz_hud_player_indicators")
local nz_indicatorangle = GetConVar("nz_hud_player_indicator_angle")
local nz_healthplayercolor = GetConVar("nz_hud_health_playercolor")
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
local color_red_20 = Color(255, 0, 0, 20)

local color_grey = Color(200, 200, 200, 255)
local color_used = Color(250, 200, 120, 255)
local color_gold = Color(255, 255, 100, 255)
local color_green = Color(100, 255, 10, 255)
local color_armor = Color(135, 200, 255)
local color_electric = Color(140, 255, 255, 255)

local color_t7 = Color(255, 255, 220, 255)
local color_t7_outline = Color(255, 150, 10, 40)
local color_t7zod = Color(255, 250, 100, 255)

local color_blood = Color(60, 0, 0, 255)
local color_blood_score = Color(120, 0, 0, 255)

local color_points1 = Color(255, 200, 0, 255)
local color_points2 = Color(100, 255, 70, 255)
local color_points4 = Color(255, 0, 0, 255)

roundcounters = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "i", "ii", "iii", "iiii", "iiiii"}
roundassets = {["burnt"] = {}, ["heat"] = {}, ["normal"] = {}}

for k, v in pairs(roundcounters) do
	for a, b in pairs(roundassets) do
		roundassets[a][tonumber(v) or v] = Material("round/_bo4/" .. a .. "/" .. v .. ".png", "unlitgeneric")
	end
end

roundassets["sparks"] = {}

for i = 0, 19 do
	roundassets["sparks"][i] = Material("round/sparks/" .. i .. ".png", "unlitgeneric")
end

/*local spark_center = {x = 33, y = -84}
local spark_size = {x = 168, y = 252}

local function DrawSpark(x, y, size)
end*/

local oldnum = 0
local usingtally = true

local tallysize = 150
local digitsize = {x = 84, y = 120}

local strokes = {
	[0] = {
		[1] = {
			{42, 10},
			{17, 28},
			{11, 65},
			{24, 96},
			{44, 108}
		},
		[2] = {
			{42, 10},
			{66, 29},
			{69, 64},
			{62, 93},
			{44, 108}
		}
	},
	[1] = {
		[1] = {
			{36, 9},
			{38, 51},
			{49, 107}
		}
	},
	[2] = {
		[1] = {
			{14, 45},
			{26, 24},
			{45, 11},
			{55, 27},
			{44, 57},
			{32, 100},
			{56, 89},
			{73, 70}
		}
	},
	[3] = {
		[1] = {
			{14, 36},
			{29, 17},
			{48, 10},
			{63, 22},
			{55, 44},
			{33, 62},
			{59, 67},
			{67, 84},
			{54, 99},
			{32, 106}
		}
	},
	[4] = {
		[1] = {
			{58, 18},
			{53, 49},
			{52, 113}
		},
		[2] = {
			{40, 8},
			{22, 63},
			{67, 40}
		}
	},
	[5] = {
		[1] = {
			{61, 7},
			{28, 18},
			{26, 55},
			{58, 41},
			{61, 76},
			{58, 102},
			{45, 112},
			{30, 102}
		}
	},
	[6] = {
		[1] = {
			{53, 9},
			{31, 35},
			{23, 65},
			{25, 97},
			{36, 109},
			{53, 92},
			{61, 51},
			{42, 61},
			{31, 74}
		}
	},
	[7] = {
		[1] = {
			{15, 37},
			{42, 24},
			{64, 8},
			{58, 56},
			{48, 111}
		}
	},
	[8] = {
		[1] = {
			{43, 7},
			{24, 29},
			{25, 55},
			{44, 58},
			{62, 70},
			{57, 95},
			{40, 114}
		},
		[2] = {
			{43, 7},
			{56, 23},
			{53, 45},
			{44, 58},
			{33, 77},
			{26, 102},
			{40, 114}
		}
	},
	[9] = {
		[1] = {
			{50, 44},
			{28, 63},
			{11, 56},
			{19, 34},
			{35, 18},
			{57, 18},
			{69, 18},
			{54, 62},
			{38, 114}
		}
	},
	["i"] = {
		[1] = {
			{35, 44},
			{59, 210}
		}
	},
	["ii"] = {
		[1] = {
			{83, 56},
			{104, 212}
		}
	},
	["iii"] = {
		[1] = {
			{138, 62},
			{148, 205}
		}
	},
	["iiii"] = {
		[1] = {
			{188, 62},
			{189, 195}
		}
	},
	["iiiii"] = {
		[1] = {
			{24, 61},
			{210, 201}
		}
	},
	["e"] = {
		[1] = {
			{62, 26},
			{43, 18},
			{22, 25},
			{17, 52},
			{34, 62},
			{48, 60},
			{28, 78},
			{30, 96},
			{49, 99},
			{64, 89}
		}
	},
	["slash"] = {
		[1] = {
			{69, 25},
			{19, 90}
		}
	}
}

local tallycoordmult = tallysize/256
local rounddata = {}
local sparkdata = {}
local roundbusy = false
local prev_round_special = false
local spacing = 70

//--------------------------------------------------/GhostlyMoo and Fox's Shadows of Evil HUD\------------------------------------------------\\

//t7 hud
local t7_hud_dpad_base = Material("nz_moo/huds/t7_zod/uie_t7_zm_hud_ammo_dpadelement_new.png", "unlitgeneric smooth")
local t7_hud_dpad_bulb_flmnt = Material("nz_moo/huds/t7_zod/uie_t7_zm_hud_ammo_bulbflmnt.png", "unlitgeneric smooth")
local t7_hud_dpad_bulb = Material("nz_moo/huds/t7_zod/uie_t7_zm_hud_ammo_bulbsmedge.png", "unlitgeneric smooth")
local t7_hud_dpad_bulb_fill = Material("nz_moo/huds/t7_zod/uie_t7_zm_hud_ammo_bulbsmfill.png", "unlitgeneric smooth")

local t7_hud_dpad_bulb_lrg = Material("nz_moo/huds/t7_zod/uie_t7_zm_hud_ammo_bulblrgedge.png", "unlitgeneric smooth")
local t7_hud_dpad_bulb_lrg_fill = Material("nz_moo/huds/t7_zod/uie_t7_zm_hud_ammo_bulblrgfill.png", "unlitgeneric smooth")

local t7_hud_dpad_flash_up = Material("nz_moo/huds/t7_zod/uie_t7_zm_hud_ammo_newshield.png", "unlitgeneric smooth")
local t7_hud_dpad_flash_down = Material("nz_moo/huds/t7_zod/uie_t7_zm_hud_ammo_newbubblegum.png", "unlitgeneric smooth")
local t7_hud_dpad_flash_right = Material("nz_moo/huds/t7_zod/uie_t7_zm_hud_ammo_newmine.png", "unlitgeneric smooth")

local t7_hud_ammo_glowfilm = Material("nz_moo/huds/t7_zod/uie_t7_zm_hud_ammo_glowfilm.png", "unlitgeneric smooth")
local t7_hud_ammo_grid = Material("nz_moo/huds/t7_zod/uie_t7_zm_hud_ammo_grid.png", "unlitgeneric smooth")
local t7_hud_ammo_elm_clip = Material("nz_moo/huds/t7_zod/uie_t7_zm_hud_ammo_elmclipamo.png", "unlitgeneric smooth")
local t7_hud_ammo_elm_ammo = Material("nz_moo/huds/t7_zod/uie_t7_zm_hud_ammo_elmttlamo.png", "unlitgeneric smooth")
local t7_hud_ammo_elm_circl = Material("nz_moo/huds/t7_zod/uie_t7_zm_hud_ammo_elminvcrc.png", "unlitgeneric smooth")

local t7_hud_ammo_glow = Material("nz_moo/huds/t7_zod/uie_t7_zm_derriese_hud_ammo_number_glow_empty.png", "unlitgeneric smooth")
local t7_hud_ammo_glow_empty = Material("nz_moo/huds/t7/uie_t7_zm_derriese_hud_ammo_number_glow_empty.png", "unlitgeneric smooth")
local t7_hud_ammo_sword = Material("nz_moo/huds/t7_zod/uie_t7_zm_hud_ammo_swordback.png", "unlitgeneric smooth")
local t7_hud_ammo_panelglow = Material("nz_moo/huds/t7/uie_t7_zm_hud_panel_ammo.png", "unlitgeneric smooth")

local t7_hud_ammo = {
	[0] = Material("nz_moo/huds/t7_zod/uie_t7_zm_hud_ammo_number0.png", "unlitgeneric smooth"),
	[1] = Material("nz_moo/huds/t7_zod/uie_t7_zm_hud_ammo_number1.png", "unlitgeneric smooth"),
	[2] = Material("nz_moo/huds/t7_zod/uie_t7_zm_hud_ammo_number2.png", "unlitgeneric smooth"),
	[3] = Material("nz_moo/huds/t7_zod/uie_t7_zm_hud_ammo_number3.png", "unlitgeneric smooth"),
	[4] = Material("nz_moo/huds/t7_zod/uie_t7_zm_hud_ammo_number4.png", "unlitgeneric smooth"),
	[5] = Material("nz_moo/huds/t7_zod/uie_t7_zm_hud_ammo_number5.png", "unlitgeneric smooth"),
	[6] = Material("nz_moo/huds/t7/uie_t7_zm_derriese_hud_ammo_noglow_number6.png", "unlitgeneric smooth"),
	[7] = Material("nz_moo/huds/t7/uie_t7_zm_derriese_hud_ammo_noglow_number7.png", "unlitgeneric smooth"),
	[8] = Material("nz_moo/huds/t7/uie_t7_zm_derriese_hud_ammo_noglow_number8.png", "unlitgeneric smooth"),
	[9] = Material("nz_moo/huds/t7/uie_t7_zm_derriese_hud_ammo_noglow_number9.png", "unlitgeneric smooth"),
}

local t7_hud_score = Material("nz_moo/huds/bo3/uie_score_feed_glow.png", "unlitgeneric smooth")
local t7_hud_player_vignette = Material("nz_moo/huds/t7/vignette.png", "unlitgeneric smooth")
local t7_hud_player_glow = Material("nz_moo/huds/t7/uie_t7_zm_hud_panel_rnd.png", "unlitgeneric smooth")

//t7 powerup
local t7_powerup_minigun = Material("nz_moo/icons/t7_zod/t7_hud_zm_powerup_deathmachine.png", "unlitgeneric")
local t7_powerup_blood = Material("nz_moo/icons/t7/specialty_giant_blood_zombies.png", "unlitgeneric")
local t7_powerup_2x = Material("nz_moo/icons/t7_zod/specialty_2x_zombies.png", "unlitgeneric")
local t7_powerup_killjoy = Material("nz_moo/icons/t7_zod/specialty_instakill_zombies.png", "unlitgeneric")
local t7_powerup_firesale = Material("nz_moo/icons/t7_zod/specialty_firesale_zombies.png", "unlitgeneric")
local t7_powerup_bonfiresale = Material("nz_moo/icons/t7/powerup_bon_fire.png", "unlitgeneric")

//t7 inventory
local t7_icon_shield_fill = Material("nz_moo/huds/t7_zod/uie_t7_zm_hud_ammo_dpadicnshld_new.png", "unlitgeneric smooth")
local t7_icon_shield = Material("nz_moo/huds/t7_zod/uie_t7_zm_hud_ammo_dpadicnshld_new_inactive.png", "unlitgeneric smooth")
local t7_icon_special_swirl = Material("nz_moo/huds/t7/uie_t7_core_hud_ammowidget_abilityswirl.png", "unlitgeneric smooth")
local t7_icon_special = Material("nz_moo/huds/t7_zod/uie_t7_zm_derriese_hud_ammo_icon_gun.png", "unlitgeneric smooth")
local t7_icon_grenade = Material("nz_moo/huds/t7/uie_t7_zm_hud_inv_icnlthl.png", "unlitgeneric smooth")
local t7_icon_sticky = Material("nz_moo/huds/t7/uie_t7_zm_hud_inv_widowswine.png", "unlitgeneric smooth")
local t7_icon_trap_fill = Material("nz_moo/huds/t7_zod/uie_t7_zm_hud_ammo_dpadicnmine_new.png", "unlitgeneric smooth")
local t7_icon_trap = Material("nz_moo/huds/t7_zod/uie_t7_zm_hud_ammo_dpadicnmine_new_inactive.png", "unlitgeneric smooth")
local t7_icon_underbarrel = Material("nz_moo/huds/t5/uie_t5hud_icon_grenade_launcher.png", "unlitgeneric smooth")

//universal
local zmhud_vulture_glow = Material("nz_moo/huds/t6/specialty_vulture_zombies_glow.png", "unlitgeneric smooth")
local zmhud_dpad_compass = Material("nz_moo/huds/t7/compass_mp_hud.png", "unlitgeneric smooth noclamp")
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

local function StatesHud_t7_zod()
	if not cl_drawhud:GetBool() then return end
	if not (nzRound:InState(ROUND_WAITING) or nzRound:InState(ROUND_CREATE) or nzRound:InState(ROUND_GO)) then return end

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

local function DrawRotatedText( text, x, y, font, color, ang)
	render.PushFilterMag( TEXFILTER.ANISOTROPIC )
	render.PushFilterMin( TEXFILTER.ANISOTROPIC )

	local m = Matrix()
	m:Translate( Vector( x, y, 0 ) )
	m:Rotate( Angle( 0, ang, 0 ) )

	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )

	m:Translate( -Vector( w / 2, h / 2, 0 ) )

	cam.PushModelMatrix( m )
		draw.DrawText( text, font, 0, 0, color )
	cam.PopModelMatrix()

	render.PopFilterMag()
	render.PopFilterMin()
end

net.Receive("nz_points_notification_bo3_zod", function()
	local amount = net.ReadInt(20)
	local ply = net.ReadEntity()
	PointsNotification(ply, amount)
end)

//Equipment
local fade_down = 0
local fade_down_acc = 0
local fade_right = 0
local fade_right_acc = 0
local fade_special = 0
local fade_special_acc = 0
local fade_ammo = 0
local fade_ammo_acc = 0

local Circles = {
	[1] = {r = -2, col = Color(255,250,200,100), colb = Color(10,150,200,100), cole = Color(120,80,0,100)},
	[2] = {r = -1, col = Color(255,120,50,200), colb = Color(10,150,200,100), cole = Color(200,0,0,100)},
	[3] = {r = 0, col = Color(255,100,0,255), colb = Color(100,255,255,200), cole = Color(255,100,0,200)},
	[4] = {r = 1, col = Color(255,200,0,255), colb = Color(200,255,255,255), cole = Color(255,200,0,200)},
	[5] = {r = 2, col = Color(255,100,0,255), colb = Color(100,255,255,200), cole = Color(255,100,0,200)},
	[6] = {r = 3, col = Color(255,120,50,200), colb = Color(10,150,200,100), cole = Color(200,0,0,100)},
	[7] = {r = 4, col = Color(255,250,200,100), colb = Color(10,150,200,100), cole = Color(120,80,0,100)},
}

local function DrawSpecialistCircle( X, Y, target_radius, value, active, empty )
	local endang = 360 * value
	if endang == 0 then return end

	for i = 1, #Circles do
		local data = Circles[ i ]
		local radius = target_radius + data.r
		local segmentdist = endang / ( math.pi * radius / 3 )

		for a = 0, endang, segmentdist do
			surface.SetDrawColor( empty and data.cole or data.col )
			surface.DrawLine( X - math.sin( math.rad( a ) ) * radius * 0.85, Y + math.cos( math.rad( a ) ) * radius, X - math.sin( math.rad( a + segmentdist ) ) * radius * 0.85, Y + math.cos( math.rad( a + segmentdist ) ) * radius )
		end
	end
end

local function InventoryHUD_t7_zod()
	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	if ply:IsNZMenuOpen() then return end
	if IsValid(ply:GetObserverTarget()) then
		ply = ply:GetObserverTarget()
	end

	local ammofont = ("nz.ammo.blackops2")
	local ammo2font = ("nz.ammo2.blackops2")

	local w, h = ScrW(), ScrH()
	local scale = ((w/1920) + 1) / 2
	local plyweptab = ply:GetWeapons()

	// Special Weapon Categories
	for _, wep in pairs(plyweptab) do
		// Traps
		if wep.IsTFAWeapon and wep.NZSpecialCategory == "trap" then
			if wep.NZPickedUpTime and (wep.NZPickedUpTime + 5 > CurTime() or fade_right > 0) then
				fade_right_acc = fade_right_acc + FrameTime()*2
				fade_right = math.abs(math.sin(fade_right_acc))
				if wep.NZPickedUpTime + 5 < CurTime() and fade_right < 0.1 then
					fade_right = 0
					fade_right_acc = 0
				end

				surface.SetMaterial(t7_hud_dpad_flash_right)
				surface.SetDrawColor(ColorAlpha(color_white, 255*fade_right))
				surface.DrawTexturedRect(w - 156*scale, h - 258*scale, 144*scale, 214*scale)
			end

			surface.SetMaterial(t7_icon_trap)
			surface.SetDrawColor(color_white)
			surface.DrawTexturedRect(w - 112*scale, h - 178*scale, 55*scale, 55*scale)

			surface.SetMaterial(t7_icon_trap_fill)
			surface.SetDrawColor(color_white)
			surface.DrawTexturedRect(w - 112*scale, h - 178*scale, 55*scale, 55*scale)
		end

		// Specialists
		if wep.IsTFAWeapon and wep.NZSpecialCategory == "specialist" then
			local icon = t7_icon_special
			local custom = false
			if IsValid(wep) and wep.NZHudIcon_t7zod then
				icon = wep.NZHudIcon_t7zod
				custom = true
			end
			if not icon or icon:IsError() then
				icon = zmhud_icon_missing
			end

			surface.SetMaterial(icon)
			surface.SetDrawColor(color_white)
			surface.DrawTexturedRect(w - 190*scale, h - 208*scale, 108*scale, 108*scale)

			local specialhp = wep:Clip1()
			local specialmax = wep.Primary_TFA.ClipSize
			local specialscale = math.Clamp(specialhp / specialmax, 0, 1)
			local active = ply:GetActiveWeapon() == wep

			DrawSpecialistCircle(w - 137*scale, h - 156*scale, 34*scale, 1*specialscale, active, not active and specialhp < specialmax)

			if wep.NZPickedUpTime and (wep.NZPickedUpTime + 5 > CurTime() or fade_special > 0) then
				fade_special_acc = fade_special_acc + FrameTime()*2
				fade_special = math.abs(math.sin(fade_special_acc))
				if wep.NZPickedUpTime + 5 < CurTime() and fade_special < 0.1 then
					fade_special = 0
					fade_special_acc = 0
				end

				if wep.NZPickedUpTime + 1 > CurTime() then
					local fucker = 1 - math.Clamp(((wep.NZPickedUpTime + 1) - CurTime()) / 1, 0, 1)
					local dafade = 1
					if fucker < 0.5 then
						dafade = 1 - math.Clamp(((wep.NZPickedUpTime + 0.5) - CurTime()) / 0.5, 0, 1)
					else
						dafade = math.Clamp(((wep.NZPickedUpTime + 1) - CurTime()) / 1, 0, 1)
					end

					cwimage("rf/round/sparks/" .. (math.ceil(CurTime()*30) % 20) .. ".png", w - 105*scale, h - 235*scale, 168*scale, 252*scale, ColorAlpha(color_t7, 200*dafade))

					surface.SetMaterial(t7_icon_special_swirl)
					surface.SetDrawColor(ColorAlpha(color_t7, 255*dafade))
					surface.DrawTexturedRectRotated(w - 135*scale, h - 155*scale, 140*fucker*scale, 140*fucker*scale, (fade_special_acc*900)%360)
				end

				if wep.NZPickedUpTime + 0.6 > CurTime() then
					surface.SetMaterial(t7_icon_special_swirl)
					surface.SetDrawColor(color_white)
					surface.DrawTexturedRectRotated(w - 135*scale, h - 155*scale, 90*scale, 90*scale, (fade_special_acc*900)%360)
				end
			end
		end

		// Shield Slot Occupier
		if wep.IsTFAWeapon and wep.NZSpecialCategory == "shield" and wep.NZHudIcon and not wep.ShieldEnabled then
			if wep.NZPickedUpTime and (wep.NZPickedUpTime + 5 > CurTime() or fade_down > 0) then
				fade_down_acc = fade_down_acc + FrameTime()*2
				fade_down = math.abs(math.sin(fade_down_acc))
				if wep.NZPickedUpTime + 5 < CurTime() and fade_down < 0.1 then
					fade_down = 0
					fade_down_acc = 0
				end

				surface.SetMaterial(t7_hud_dpad_flash_down)
				surface.SetDrawColor(ColorAlpha(color_white, 255*fade_down))
				surface.DrawTexturedRect(w - 231*scale, h - 168*scale, 188*scale, 142*scale)
			end

			local icon = t7_icon_shield
			if IsValid(wep) and wep.NZHudIcon then
				icon = wep.NZHudIcon
			end
			if not icon or icon:IsError() then
				icon = zmhud_icon_missing
			end

			surface.SetMaterial(icon)
			surface.SetDrawColor(ColorAlpha(color_t7_outline, 120))
			surface.DrawTexturedRect(w - 159*scale, h - 115*scale, 42*scale, 42*scale)

			surface.SetMaterial(icon)
			surface.SetDrawColor(color_t7)
			surface.DrawTexturedRect(w - 156*scale, h - 112*scale, 36*scale, 36*scale)
		end
	end

	// Shield
	if ply.GetShield and IsValid(ply:GetShield()) then
		local shield = ply:GetShield()
		local wep = shield:GetWeapon()

		if wep.NZPickedUpTime and (wep.NZPickedUpTime + 5 > CurTime() or fade_down > 0) then
			fade_down_acc = fade_down_acc + FrameTime()*2
			fade_down = math.abs(math.sin(fade_down_acc))
			if wep.NZPickedUpTime + 5 < CurTime() and fade_down < 0.1 then
				fade_down = 0
				fade_down_acc = 0
			end

			surface.SetMaterial(t7_hud_dpad_flash_down)
			surface.SetDrawColor(ColorAlpha(color_white, 255*fade_down))
			surface.DrawTexturedRect(w - 231*scale, h - 167*scale, 188*scale, 144*scale)
		end

		local shieldhp = shield:Health()
		local shieldmax = shield:GetMaxHealth()
		local shieldscale = math.Clamp(shieldhp / shieldmax, 0, 1)

		if wep.Secondary and wep.Secondary.ClipSize > 0 then
			local clip2 = wep:Clip2()
			local clip2rate = wep.Secondary.AmmoConsumption
			local clip2i = math.floor(clip2/clip2rate)

			surface.SetMaterial(t7_hud_ammo[clip2i])
			surface.SetDrawColor(color_white)
			surface.DrawTexturedRect(w - 166*scale, h - 100*scale, 60*scale, 60*scale)
		end

		surface.SetMaterial(t7_icon_shield)
		surface.SetDrawColor(color_white)
		surface.DrawTexturedRect(w - 167*scale, h - 128*scale, 62*scale, 62*scale)

		surface.SetMaterial(t7_icon_shield_fill)
		surface.SetDrawColor(color_white)
		surface.DrawTexturedRectUV(w - 166*scale, h - 127*scale, 60*scale, (60*shieldscale)*scale, 0, 0, 1, (1*shieldscale))
	end
end

local function ScoreHud_t7_zod()
	if not cl_drawhud:GetBool() then return end
	if not (nzRound:InProgress() or nzRound:InState(ROUND_CREATE)) then return end

	local fontsmall = "nz.ammo.bo3.wepname"
	local fontmain = "nz.small.blackops2"
	local fontnade = "nz.grenade"

	local w, h = ScrW(), ScrH()
	local scale = (w/1920 + 1) / 2
	local offset = 0
	local pscale = scale
	local wr = w/1920

	local ply = LocalPlayer()
	if IsValid(ply:GetObserverTarget()) then
		ply = ply:GetObserverTarget()
	end

	local plyindex = ply:EntIndex()
	local plytab = player.GetAll()

	local color = player.GetColorByIndex(plyindex)
	if nz_useplayercolor:GetBool() then
		local pcol = ply:GetPlayerColor()
		color = Color(255*pcol.x, 255*pcol.y, 255*pcol.z, 255)
	end

	//name
	if nz_shownames:GetBool() then
		local nick = ply:Nick()
		if #nick > 20 then
			nick = string.sub(nick, 1, 20) //limit name to 20 chars
		end

		if ply:IsSpeaking() then
			local icon = zmhud_icon_voicedim
			if ply:VoiceVolume() > 0 then
				icon = zmhud_icon_voiceon
			end
			if not voiceloopback:GetBool() then
				icon = zmhud_icon_voiceon
			end

			surface.SetFont(fontsmall)
			local tw, th = surface.GetTextSize(nick)

			surface.SetMaterial(icon)
			surface.SetDrawColor(color_white)
			surface.DrawTexturedRect(wr + 45*scale + tw, h - (275*scale) - offset - 16, 32, 32)
		end

		draw.SimpleTextOutlined(nick, fontsmall, wr + 45*scale, h - (275*scale) - offset, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, color_black_50)
	end

	//points
	surface.SetDrawColor(ColorAlpha(color, 20))
	surface.SetMaterial(t7_hud_score)
	surface.DrawTexturedRect(wr + 40*scale, h - (270*scale) - offset, 215*scale, 60*scale)

	draw.SimpleTextOutlined(ply:GetPoints(), fontmain, wr + (115*scale), h - (240*scale) - offset, color, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, ColorAlpha(color, 10))
	ply.PointsSpawnPosition = {x = wr + 220*scale, y = h - 240 * scale - offset}

	//icon
	local pmpath = Material("spawnicons/"..string_gsub(ply:GetModel(),".mdl",".png"), "unlitgeneric smooth")
	if not pmpath or pmpath:IsError() then
		pmpath = zmhud_icon_missing
	end

	surface.SetDrawColor(color_t7_outline)
	surface.SetMaterial(t7_hud_player_glow)
	surface.DrawTexturedRect(wr + 46*scale, h - 260 * scale - offset, 64*scale, 64*scale)

	surface.SetDrawColor(color_white)
	surface.SetMaterial(pmpath)
	surface.DrawTexturedRect(wr + 46*scale, h - 260 * scale - offset, 64*scale, 64*scale)

	surface.SetDrawColor(color_white)
	surface.SetMaterial(t7_hud_player_vignette)
	surface.DrawTexturedRect(wr + 44*scale, h - (262*scale) - offset, 68*scale, 68*scale)

	surface.SetDrawColor(color_black_100)
	surface.DrawOutlinedRect(wr + 44*scale, h - (262*scale) - offset, 68*scale, 68*scale, 2*scale)

	//shovel
	if ply.GetShovel and IsValid(ply:GetShovel()) then
		local pshovel = ply:GetShovel()

		surface.SetMaterial(pshovel:IsGolden() and pshovel.NZHudIcon2 or pshovel.NZHudIcon)
		surface.SetDrawColor(color_white)
		surface.DrawTexturedRect(wr + 5*scale, h - 235*scale - offset, 42*scale, 42*scale)
	end

	for k, v in pairs(plytab) do
		local index = v:EntIndex()
		if index == plyindex then continue end

		local pcolor = player.GetColorByIndex(index)
		if nz_useplayercolor:GetBool() then
			local pvcol = v:GetPlayerColor()
			pcolor = Color(255*pvcol.x, 255*pvcol.y, 255*pvcol.z, 255)
		end

		offset = offset + 50
		if nz_showhealthmp:GetBool() then
			offset = offset + 5 //health bar offset buffer
		end
		if nz_shownames:GetBool() then
			offset = offset + 25 //nickname offset buffer
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

				surface.SetFont(fontsmall)
				local tw, th = surface.GetTextSize(nick)

				surface.SetMaterial(icon)
				surface.SetDrawColor(color_white)
				surface.DrawTexturedRect(wr + 69*scale + tw, h - (275*scale) - offset - 16, 32, 32)
			end

			draw.SimpleTextOutlined(nick, fontsmall, wr + 69*scale, h - (275*scale) - offset, pcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, color_black_50)
		end

		//points
		surface.SetDrawColor(ColorAlpha(pcolor, 20))
		surface.SetMaterial(t7_hud_score)
		surface.DrawTexturedRect(wr + 80*scale, h - (275*scale) - offset, 140*scale*0.8, 60*scale*0.8)

		draw.SimpleTextOutlined(v:GetPoints(), fontsmall, wr + (118*scale), h - (248*scale) - offset, pcolor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER, 2, ColorAlpha(pcolor, 10))
		v.PointsSpawnPosition = {x = wr + 190*scale, y = h - 253 * scale - offset}

		//icon
		local pmpath = Material("spawnicons/"..string_gsub(v:GetModel(),".mdl",".png"), "unlitgeneric smooth")
		if not pmpath or pmpath:IsError() then
			pmpath = zmhud_icon_missing
		end

		surface.SetDrawColor(color_t7_outline)
		surface.SetMaterial(t7_hud_player_glow)
		surface.DrawTexturedRect(wr + 70*scale, h - (260*scale) - offset, 40*scale, 40*scale)

		surface.SetDrawColor(color_white)
		surface.SetMaterial(pmpath)
		surface.DrawTexturedRect(wr + 70*scale, h - (260*scale) - offset, 40*scale, 40*scale)

		surface.SetDrawColor(color_white)
		surface.SetMaterial(t7_hud_player_vignette)
		surface.DrawTexturedRect(wr + 68*scale, h - (262*scale) - offset, 44*scale, 44*scale)

		surface.SetDrawColor(color_black_100)
		surface.DrawOutlinedRect(wr + 68*scale, h - (262*scale) - offset, 44*scale, 44*scale, 2*scale)

		//shovel
		if v.GetShovel and IsValid(v:GetShovel()) then
			local pshovel = v:GetShovel()

			surface.SetMaterial(pshovel:IsGolden() and pshovel.NZHudIcon2 or pshovel.NZHudIcon)
			surface.SetDrawColor(color_white)
			surface.DrawTexturedRect(wr + 40*scale, h - 245*scale - offset, 32*scale, 32*scale)
		end

		//indicator
		if nz_indicators:GetBool() and v:GetNotDowned() then
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

		//health
		if nz_showhealthmp:GetBool() then
			local phealth = v:Health()
			local pmaxhealth = v:GetMaxHealth()
			local phealthscale = math.Clamp(phealth / pmaxhealth, 0, 1)
			local phealthcolor = Color(255, 300*phealthscale, 300*phealthscale, 255)

			surface.SetDrawColor(phealthcolor)
			surface.DrawRect(wr + (70*scale), h - 215*scale - offset, 132*phealthscale, 4)
		end
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
				draw.SimpleText("+"..v.amount, fontnade, v.ply.PointsSpawnPosition.x + 35*fade, v.ply.PointsSpawnPosition.y + v.diry*fade, points2, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
			if v.amount < 100 then --If you're earning less than 100 points, the notif will be gold!
				draw.SimpleText("+"..v.amount, fontnade, v.ply.PointsSpawnPosition.x + 35*fade, v.ply.PointsSpawnPosition.y + v.diry*fade, points1, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
		else -- If you're doing something that subtracts points, the notif will be red!
			draw.SimpleText(v.amount, fontnade, v.ply.PointsSpawnPosition.x + 35*fade, v.ply.PointsSpawnPosition.y + v.diry*fade, points4, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end

		if fade >= 1 then
			table_remove(PointsNotifications, k)
		end
	end
end

local dotpos = 0
local p1pos = 0
local p2pos = 0
local p3pos = 0

local hudsword = {
	["tfa_bo3_keepersword"] = Material("nz_moo/huds/t7_zod/uie_t7_zm_hud_ammo_sword.png", "unlitgeneric smooth"),
	["tfa_bo3_zodsword"] = Material("nz_moo/huds/t7_zod/uie_t7_zm_hud_ammo_swordelectric.png", "unlitgeneric smooth"),
}

local lerpcol_white = Color(255, 255, 220, 255)
local lerpcol_red = Color(200, 0, 0, 255)
local emptyclipdie = false
local emptycliptime = 0

local emptyclip2die = false
local emptyclip2time = 0

local function GunHud_t7_zod()
	if not cl_drawhud:GetBool() then return end

	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	if ply:IsNZMenuOpen() then return end
	if IsValid(ply:GetObserverTarget()) then
		ply = ply:GetObserverTarget()
	end

	local ct = math.Round(CurTime())
	local w, h = ScrW(), ScrH()
	local scale = ((w/1920) + 1) / 2
	local wep = ply:GetActiveWeapon()

	local dafont = "nz.ammo.bo3zod.big"
	local ammofont = ("nz.ammo.bo3zod.main")
	local ammo2font = ("nz.ammo2.blackops2")
	local smallfont = ("nz.ammo.bo3.wepname")
	local fontColor = !IsColor(nzMapping.Settings.textcolor) and color_red_200 or nzMapping.Settings.textcolor

	local akimbo = wep.Secondary and (not wep.CanBeSilenced or (wep.CanBeSilenced and not wep:GetSilenced() and wep.Clip3)) and wep.Secondary.ClipSize > 0
	local bulbwidth = (akimbo and 465 or 395)
	local bulbheight = (akimbo and 242 or 238)
	local bulbscalew = (akimbo and 300 or 240)
	local bulbscaleh = (akimbo and 144 or 132)

	surface.SetMaterial(akimbo and t7_hud_dpad_bulb_lrg_fill or t7_hud_dpad_bulb_fill)
	surface.SetDrawColor(color_white_50)
	surface.DrawTexturedRect(w - bulbwidth*scale, h - bulbheight*scale, bulbscalew*scale, bulbscaleh*scale)

	surface.SetMaterial(akimbo and t7_hud_dpad_bulb_lrg or t7_hud_dpad_bulb)
	surface.SetDrawColor(color_white)
	surface.DrawTexturedRect(w - bulbwidth*scale, h - bulbheight*scale, bulbscalew*scale, bulbscaleh*scale)

	surface.SetMaterial(t7_hud_dpad_bulb_flmnt)
	surface.SetDrawColor(color_white)
	surface.DrawTexturedRect(w - 385*scale, h - 235*scale, 240*scale, 132*scale)

	//ammo backings
	surface.SetMaterial(t7_hud_ammo_elm_clip)
	surface.SetDrawColor(color_white_100)
	surface.DrawTexturedRect(w - 375*scale, h - 225*scale, 108*scale, 108*scale)

	surface.SetMaterial(t7_hud_ammo_elm_ammo)
	surface.SetDrawColor(color_white_100)
	surface.DrawTexturedRect(w - 275*scale, h - 180*scale, 60*scale, 48*scale)

	//base
	surface.SetMaterial(t7_hud_dpad_base)
	surface.SetDrawColor(color_white)
	surface.DrawTexturedRect(w - 220*scale, h - 260*scale, 128*scale*1.6, 128*scale*1.6)

	//compass
	if nz_showcompass:GetBool() and (nzRound:InProgress() or nzRound:InState(ROUND_CREATE)) then
		local angle = -ply:EyeAngles().y/360

		local hight = 195
		if nz_showhealth:GetBool() then
			hight = hight - 10
			if ply:Armor() > 0 then
				hight = hight - 10
			end
		end

		surface.SetMaterial(zmhud_dpad_compass)
		surface.SetDrawColor(color_white)
		surface.DrawTexturedRectUV(45*scale, h - hight*scale, 256*scale*0.6, 64*scale*0.6, 0 + angle , 0, 0.5 + angle , 1)
	end

	//weapon
	if IsValid(wep) then
		local class = wep:GetClass()
		if wep.NZWonderWeapon or wep.NZSpecialCategory == "specialgrenade" then
			fontColor = Color(0, 255, 255, 255)
		end
		if wep.NZSpecialCategory == "specialist" then
			fontColor = Color(180, 0, 0, 255)
		end

		if class == "nz_multi_tool" then
			draw.SimpleTextOutlined(nzTools.ToolData[wep.ToolMode].displayname or wep.ToolMode, smallfont, w - 230*scale, h - 80*scale, fontColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 2, color_black_50)
			draw.SimpleTextOutlined(nzTools.ToolData[wep.ToolMode].desc or "", ammofont, w - 235*scale, h - 195*scale, color_t7, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP, 4, ColorAlpha(color_t7_outline, 10))
		elseif illegalspecials[wep.NZSpecialCategory] then
			local name = wep:GetPrintName()
			draw.SimpleTextOutlined(name, smallfont, w - 230*scale, h - 80*scale, fontColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 2, color_black_50)
		elseif not illegalspecials[wep.NZSpecialCategory] and not hudsword[class] then
			if wep.Primary then
				local clip = wep.Primary.ClipSize
				local resclip = wep.Primary.DefaultClip
				local clip1 = wep:Clip1()

				local flashing_sin = math.abs(math.sin(CurTime()*4))
				local ammoType = wep:GetPrimaryAmmoType()
				local ammoTotal = ply:GetAmmoCount(ammoType)
				local outlineCol = color_t7_outline
				local reserveoutCol = color_t7_outline
				local ammoCol = Color(255, 255, 220, 255)
				local reserveCol = color_t7
				local lowclip = false
				local lowammo = false

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

				if emptyclipdie and clip1 > 0 then
					emptycliptime = CurTime() + 1
					emptyclipdie = false
				end

				if clip and (clip > 1 or clip1 == 0) and clip1 <= math.ceil(clip/4) then
					lowclip = true

					if clip1 > 0 then
						ammoCol.r = Lerp(flashing_sin, lerpcol_red.r, lerpcol_white.r)
						ammoCol.g = Lerp(flashing_sin, lerpcol_red.g, lerpcol_white.g)
						ammoCol.b = Lerp(flashing_sin, lerpcol_red.b, lerpcol_white.b)
						ammoCol.a = Lerp(flashing_sin, lerpcol_red.a, lerpcol_white.a)
					else
						emptyclipdie = true
						ammoCol = color_red_200
					end

					outlineCol = color_red_20
				end
				if resclip and resclip > 0 and ammoTotal <= math.ceil(resclip/4) then
					lowammo = true
					reserveCol = color_red_255
					reserveoutCol = color_red_20
				end

				local ammolen = string_len(ammoTotal)
				local cliplen = string_len(clip1)

				flashing_sin = math.max(flashing_sin, 0.2)
				if clip and clip > 0 then
					surface.SetMaterial(lowclip and t7_hud_ammo_glow_empty or t7_hud_ammo_glow)
					surface.SetDrawColor(lowclip and (ColorAlpha(color_white, 200*flashing_sin)) or color_white)
					surface.DrawTexturedRect(w - 390*scale, h - 240*scale, 140*scale, 140*scale)

					if ammoType == -1 then
						local xlipoffset = 0
						if cliplen >= 3 then xlipoffset = 10 end
						draw.SimpleTextOutlined(clip1, dafont, w - (295 - xlipoffset)*scale, h - 132*scale, ammoCol, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 4, outlineCol)
					else
						draw.SimpleTextOutlined(clip1, dafont, w - 295*scale, h - 132*scale, ammoCol, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 4, outlineCol)
						if resclip and resclip > 0 then
							surface.SetMaterial(t7_hud_ammo_glow)
							surface.SetDrawColor(color_white)
							surface.DrawTexturedRect(w - 310*scale, h - 220*scale, 120*scale, 120*scale)

							draw.SimpleTextOutlined(ammoTotal, ammofont, w - 220*scale, h - 122*scale, color_t7, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 4, color_t7_outline)
						end
					end
				else
					//weapons that dont have a clip1 and use the ammo pool
					if resclip and resclip > 0 then
						surface.SetMaterial(lowammo and t7_hud_ammo_glow_empty or t7_hud_ammo_glow)
						surface.SetDrawColor(lowammo and (ColorAlpha(color_white, 200*flashing_sin)) or color_white)
						surface.DrawTexturedRect(w - 390*scale, h - 240*scale, 140*scale, 140*scale)

						local ammooffset = 0
						if ammolen >= 3 then ammooffset = 10 end
						draw.SimpleTextOutlined(ammoTotal, dafont, w - (295 - ammooffset)*scale, h - 132*scale, reserveCol, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 4, reserveoutCol)
					end
				end
			end

			if wep.Secondary and (not wep.CanBeSilenced or (wep.CanBeSilenced and not wep:GetSilenced() and wep.Clip3)) then
				local clip2 = wep.Secondary.ClipSize
				local resclip2 = wep.Secondary.DefaultClip

				local flashing_sin = math.abs(math.sin(CurTime()*4))
				local ammoType2 = wep:GetSecondaryAmmoType()
				local ammoTotal2 = ply:GetAmmoCount(ammoType2)
				local outlineCol = color_t7_outline
				local reserveoutCol = color_t7_outline
				local ammoCol = Color(255, 255, 220, 255)
				local reserveCol = color_t7
				local lowclip = false
				local lowammo = false

				if emptyclip2die and wep:Clip2() > 0 then
					emptyclip2time = CurTime() + 1
					emptyclip2die = false
				end

				flashing_sin = math.max(flashing_sin, 0.2)
				if clip2 and clip2 > 0 and wep:Clip2() <= math.ceil(clip2/4) then
					lowclip = true

					if wep:Clip2() > 0 then
						ammoCol.r = Lerp(flashing_sin, lerpcol_red.r, lerpcol_white.r)
						ammoCol.g = Lerp(flashing_sin, lerpcol_red.g, lerpcol_white.g)
						ammoCol.b = Lerp(flashing_sin, lerpcol_red.b, lerpcol_white.b)
						ammoCol.a = Lerp(flashing_sin, lerpcol_red.a, lerpcol_white.a)
					else
						emptyclip2die = true
						ammoCol = color_red_200
					end

					outlineCol = color_red_20
				end
				if resclip2 and resclip2 > 0 and ammoTotal2 <= math.ceil(resclip2/4) then
					lowammo = true
					reserveCol = color_red_255
					reserveoutCol = color_red_20
				end

				if clip2 and clip2 > 0 then
					surface.SetMaterial(t7_hud_ammo_elm_clip)
					surface.SetDrawColor(color_white_100)
					surface.DrawTexturedRect(w - 460*scale, h - 231*scale, 108*scale, 108*scale)

					surface.SetMaterial(lowclip and t7_hud_ammo_glow_empty or t7_hud_ammo_glow)
					surface.SetDrawColor(lowclip and (ColorAlpha(color_white, 200*flashing_sin)) or color_white)
					surface.DrawTexturedRect(w - 480*scale, h - 246*scale, 140*scale, 140*scale)

					draw.SimpleTextOutlined(wep:Clip2(), dafont, w - 380*scale, h - 138*scale, ammoCol, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 4, outlineCol)
				else
					if ammoTotal2 and ammoTotal2 > 0 then
						surface.SetMaterial(t7_hud_ammo_elm_clip)
						surface.SetDrawColor(color_white_100)
						surface.DrawTexturedRect(w - 460*scale, h - 231*scale, 108*scale, 108*scale)

						surface.SetMaterial(lowammo and t7_hud_ammo_glow_empty or t7_hud_ammo_glow)
						surface.SetDrawColor(lowammo and (ColorAlpha(color_white, 200*flashing_sin)) or color_white)
						surface.DrawTexturedRect(w - 480*scale, h - 246*scale, 140*scale, 140*scale)

						draw.SimpleTextOutlined(ammoTotal2, dafont, w - 380*scale, h - 138*scale, reserveCol, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 4, reserveoutCol)
					end
				end
			end

			if emptycliptime > CurTime() then
				local alphascale = 1 - math.Clamp((emptycliptime - CurTime()) / 1, 0, 1)
				if alphascale > 0.5 then
					alphascale = math.Clamp((emptycliptime - CurTime()) / 1, 0, 1)
				end

				surface.SetMaterial(t7_hud_ammo_panelglow)
				surface.SetDrawColor(ColorAlpha(color_t7zod, 150*alphascale))
				surface.DrawTexturedRect(w - 335*scale - (52*scale), h - 185*scale - (52*scale), 104*scale, 104*scale)
			end
			if emptyclip2time > CurTime() then
				local alphascale = 1 - math.Clamp((emptyclip2time - CurTime()) / 1, 0, 1)
				if alphascale > 0.5 then
					alphascale = math.Clamp((emptyclip2time - CurTime()) / 1, 0, 1)
				end

				surface.SetMaterial(t7_hud_ammo_panelglow)
				surface.SetDrawColor(ColorAlpha(color_t7zod, 150*alphascale))
				surface.DrawTexturedRect(w - 420*scale - (52*scale), h - 190*scale - (52*scale), 104*scale, 104*scale)
			end

			//silencer/underbarrel/altattack hud
			if wep.CanBeSilenced then
				local icon = t7_icon_underbarrel
				if wep.NZHudIcon_t7 or wep.NZHudIcon then
					icon = wep.NZHudIcon
				end
				if not icon or icon:IsError() then
					icon = zmhud_icon_missing
				end

				surface.SetMaterial(icon)
				surface.SetDrawColor(color_t7)
				surface.DrawTexturedRect(w - 215*scale, h - 195*scale, 60*scale, 60*scale)

				local ammoTotal2 = ply:GetAmmoCount(wep:GetSecondaryAmmoType()) + (wep.Clip3 and wep:Clip3() or wep:Clip2())
				if ammoTotal2 > 0 then
					draw.SimpleTextOutlined(ammoTotal2, ("nz.ammo2.blackops2"), w - 180*scale, h - 130*scale, color_t7, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 2, color_t7_outline)
				end
			end

			local name = wep:GetPrintName()
			draw.SimpleTextOutlined(name, smallfont, w - 230*scale, h - 80*scale, fontColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 2, color_black_50)

			if nz_showgun:GetBool() and killicon.Exists(class) then
				surface.SetFont(smallfont)
				local tw, th = surface.GetTextSize(name)

				killicon.Draw(w - 230*scale - (64*scale) - tw, h - 80*scale - (32*scale), class, 255)
			end
		elseif hudsword[class] then
			local electric = class == "tfa_bo3_zodsword"
			surface.SetMaterial(t7_hud_ammo_glow)
			surface.SetDrawColor(color_white_150)
			surface.DrawTexturedRectRotated(w - 300*scale, h - 170*scale, 228*scale, 84*scale, -4)

			surface.SetMaterial(t7_hud_ammo_sword)
			surface.SetDrawColor(ColorAlpha(electric and color_electric or color_t7_outline, 120))
			surface.DrawTexturedRectRotated(w - 300*scale, h - 170*scale, 228*scale*0.8, 84*scale*0.8, -4)

			surface.SetDrawColor(ColorAlpha(electric and color_electric or color_t7_outline, 120))
			surface.SetMaterial(hudsword[class])
			surface.DrawTexturedRectRotated(w - 300*scale, h - 170*scale, 202*scale*0.8, 58*scale*0.8, -4)

			surface.SetDrawColor(color_white)
			surface.SetMaterial(hudsword[class])
			surface.DrawTexturedRectRotated(w - 300*scale, h - 170*scale, 192*scale*0.8, 48*scale*0.8, -4)

			local name = wep:GetPrintName()
			draw.SimpleTextOutlined(name, smallfont, w - 230*scale, h - 80*scale, fontColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 2, color_black_50)
		end

		if ply:HasPerk("mulekick") and not illegalspecials[wep.NZSpecialCategory] then
			surface.SetDrawColor(color_white_50)
			if IsValid(wep) and wep:GetNWInt("SwitchSlot") == 3 then
				surface.SetDrawColor(color_white)
			end
			surface.SetMaterial(zmhud_icon_mule)
			surface.DrawTexturedRect(w - 220*scale, h - 280*scale, 35*scale, 35*scale)
		end
	end

	//grenade hud
	local num = ply:GetAmmoCount(GetNZAmmoID("grenade") or -1)
	local numspecial = ply:GetAmmoCount(GetNZAmmoID("specialgrenade") or -1)
	local scale = (w/1920 + 1) / 2

	if numspecial > 0 then
		surface.SetMaterial(t7_hud_ammo_glow)
		surface.SetDrawColor(color_white_200)
		surface.DrawTexturedRect(w - 315*scale, h - 240*scale, 84*scale, 84*scale)

		local icon = t7_icon_grenade
		local plyweptab = ply:GetWeapons()

		for _, wep in pairs(plyweptab) do
			if wep.NZSpecialCategory == "specialgrenade" and wep.NZHudIcon then
				icon = wep.NZHudIcon
				if wep:GetClass() == "tfa_bo3_lilarnie" then
					icon = wep.NZHudIcon_t7
				end
				break
			end
		end
		if not icon or icon:IsError() then
			icon = zmhud_icon_missing
		end

		surface.SetMaterial(icon)
		for i = numspecial, 1, -1 do
			surface.SetDrawColor(ColorAlpha(color_t7_outline, 100/i*1.5))
			surface.DrawTexturedRect(w - 300*scale + (i*9*scale) - 4, h - 220*scale - (i*2*scale) - 4, 44*scale, 44*scale)

			surface.SetDrawColor(ColorAlpha(color_t7, 255/i))
			surface.DrawTexturedRect(w - 300*scale + (i*9*scale), h - 220*scale - (i*2*scale), 36*scale, 36*scale)
		end
	end

	if num > 0 then
		surface.SetMaterial(t7_hud_ammo_glow)
		surface.SetDrawColor(color_white_200)
		surface.DrawTexturedRect(w - 280*scale, h - 240*scale, 84*scale, 84*scale)

		surface.SetDrawColor(color_t7_outline)
		surface.SetMaterial(t7_icon_grenade)
		if ply:HasPerk("widowswine") then
			surface.SetMaterial(t7_icon_sticky)
		end
		if ply:HasWeapon("nz_holy") and not ply:HasPerk("widowswine") then
			surface.SetMaterial(zmhud_icon_holygrenade) -- Replaces Lethals!!!
		end
		for i = num, 1, -1 do
			surface.SetDrawColor(ColorAlpha(color_t7_outline, 100/i*1.5))
			surface.DrawTexturedRect(w - 265*scale + (i*9*scale) - 4, h - 220*scale - (i*2*scale) - 4, 44*scale, 44*scale)

			surface.SetDrawColor(ColorAlpha(color_t7, 250/i))
			surface.DrawTexturedRect(w - 265*scale + (i*9*scale), h - 220*scale - (i*2*scale), 36*scale, 36*scale)
		end
	end

	surface.SetMaterial(t7_hud_ammo_elm_circl)
	surface.SetDrawColor(color_white_100)
	surface.DrawTexturedRect(w - 265*scale, h - 225*scale, 50*scale, 50*scale)

	surface.SetMaterial(t7_hud_ammo_elm_circl)
	surface.SetDrawColor(color_white_100)
	surface.DrawTexturedRect(w - 295*scale, h - 225*scale, 50*scale, 50*scale)

	local glowfilm = surface.GetTextureID("nz_moo/huds/t7_zod/uie_t7_zm_hud_ammo_glowfilm")
	surface.SetTexture(glowfilm)
	surface.SetDrawColor(color_white)
	surface.DrawTexturedRect(w - 550*scale, h - 390*scale, 560*scale, 380*scale)
end

local function PerksMMOHud_t7_zod()
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
	if ply:HasPerk("mulekick") then
		traycount = traycount + 1
	end

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
		surface.DrawTexturedRect(w - 220*scale - (40*traycount*scale), h - 280*scale, 35*scale, 35*scale)

		if ply:HasUpgrade(v) and mmohud.border and ply:GetNW2Float(tostring(mmohud.upgrade), 0) < curtime then
			surface.SetDrawColor(color_gold)
			surface.SetMaterial(zmhud_icon_frame)
			surface.DrawTexturedRect(w - 220*scale - (40*traycount*scale), h - 280*scale, 35*scale, 35*scale)
		end

		if mmohud.style == "toggle" then
		elseif mmohud.style == "count" then
			draw.SimpleTextOutlined(ply:GetNW2Int(tostring(mmohud.count), 0), ChatFont, w - 185*scale - (40*traycount*scale), h - 240*scale, fontColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, color_black)
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
				draw.SimpleTextOutlined(perkpercent.."%", ChatFont, w - 185*scale - (40*traycount*scale), h - 240*scale, fontColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, color_black)
			end
		elseif mmohud.style == "chance" then
			draw.SimpleTextOutlined(ply:GetNW2Int(tostring(mmohud.count), 0).."/"..mmohud.max, ChatFont, w - 185*scale - (40*traycount*scale), h - 240*scale, fontColor, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM, 1, color_black)
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

local function DeathHud_t7_zod()
	if not cl_drawhud:GetBool() then return end
	local ply = LocalPlayer()
	if not IsValid(ply) then return end

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

				surface.SetMaterial(ent.NZThrowIcon or t7_icon_grenade)
				surface.SetDrawColor(ColorAlpha(color_t7_outline, 300*dist))
				surface.DrawTexturedRect(data.x - screen*0.5 - 4, data.y - screen*0.5 - 4, screen + 8, screen + 8)

				surface.SetMaterial(ent.NZThrowIcon or t7_icon_grenade)
				surface.SetDrawColor(ColorAlpha(color_t7zod, 300*dist))
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

		surface.SetMaterial(ent.NZThrowIcon or t7_icon_grenade)
		surface.SetDrawColor(ColorAlpha(color_t7_outline, 400*dist))
		surface.DrawTexturedRect(x - (screen*0.5) - 4, y - (screen*0.5) - 4, screen + 8, screen + 8)

		surface.SetMaterial(ent.NZThrowIcon or t7_icon_grenade)
		surface.SetDrawColor(ColorAlpha(color_t7zod, 400*dist))
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
local downdelay = 0

local function PowerUpsHud_t7_zod()
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
			draw.SimpleTextOutlined(math.Round(timeleft), font, width, sch - 170*scale, color_t7, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_t7_outline)
		end
		powerupsActive = powerupsActive + 1
	end

	for k,v in pairs(nzPowerUps.ActivePowerUps) do	
		if nzPowerUps:IsPowerupActive(k) then
			if k == "dp" then
				AddPowerup(t7_powerup_2x, v)
				ReturnPosition("Returning" .. "dp", math.Round(v - ctime))	
			end

			if k == "insta" then
				AddPowerup(t7_powerup_killjoy, v)
				ReturnPosition("Returning" .. "insta", math.Round(v - ctime))	
			end

			if k == "firesale" then
				AddPowerup(t7_powerup_firesale, v)
				ReturnPosition("Returning" .. "firesale", math.Round(v - ctime))	
			end

			if k == "bonfiresale" then
				AddPowerup(t7_powerup_bonfiresale, v)
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
				AddPowerup(t7_powerup_blood, v)
				ReturnPosition("Returning" .. "zombieblood", math.Round(v - ctime))	
			end

			if k == "deathmachine" then
				AddPowerup(t7_powerup_minigun, v)
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

local perkcount = 0
local perkflashtime = 0
local function PerksHud_t7_zod()
	if not cl_drawhud:GetBool() then return end
	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	if IsValid(ply:GetObserverTarget()) then
		ply = ply:GetObserverTarget()
	end

	local pscale = (ScrW()/1920 + 1)/2

	local perks = ply:GetPerks()
	local w = ScrW()/1920 + 200
	local h = ScrH()
	local size = 50

	local num = 0
	local row = 0
	local num_b = 0
	local row_b = 0

	if nz_showperkframe:GetBool() then
		if nzRound:InProgress() or (#perks > 0) then
			surface.SetMaterial(zmhud_icon_frame)
			surface.SetDrawColor(color_white_100)
			for i=1, nz_perkmax:GetInt() do
				if not ply:HasUpgrade(perks[i]) then
					surface.DrawTexturedRect(w + num_b*(size + 6)*pscale, h - 100*pscale - 64*row_b, 54*pscale, 54*pscale)
				end

				num_b = num_b + 1
				if num_b%8 == 0 then
					row_b = row_b + 1
					num_b = 0
				end
			end
		end
	end

	if perkcount < #perks and perkflashtime < CurTime() then
		perkflashtime = CurTime() + 1
		perkcount = math.Approach(perkcount, #perks, 1)
	end

	if (!ply:GetNotDowned() or !ply:Alive()) and perkcount ~= 0 then
		perkcount = 0
		perkflashtime = 0
	end

	if perkflashtime > CurTime() then
		local alpha = 1 - math.Clamp((perkflashtime - CurTime()) / 1, 0, 1)
		if alpha > 0.5 then
			alpha = math.Clamp((perkflashtime - CurTime()) / 1, 0, 1)
		end
		local flashrow = perkcount > 8 and math.floor(perkcount/8) or 0
		local flashcount = perkcount > 8 and perkcount%8 or perkcount

		cwimage("rf/round/sparks/" .. (math.ceil(CurTime()*30) % 20) .. ".png", (w + 46*pscale) + ((flashcount-1)*(size + 6))*pscale, h - 154*pscale - 64*flashrow, 168*pscale, 252*pscale, ColorAlpha(color_white, 255*alpha))

		surface.SetMaterial(t7_hud_score)
		surface.SetDrawColor(ColorAlpha(color_t7_outline, 255*alpha))
		surface.DrawTexturedRect((w - 40*pscale) + ((flashcount-1)*(size + 6))*pscale, h - 148*pscale - 64*flashrow, 128*pscale, 128*pscale)
	end

	for _, perk in pairs(perks) do
		local icon = GetPerkIconMaterial(perk)
		if not icon or icon:IsError() then
			icon = zmhud_icon_missing
		end

		local alpha = 1
		if perks[perkcount] == perk and perkflashtime > CurTime() then
			alpha = 1 - math.Clamp((perkflashtime - CurTime()) / 1, 0, 1)
		end

		surface.SetMaterial(icon)
		surface.SetDrawColor(alpha < 1 and ColorAlpha(color_white, 800*alpha) or color_white)
		surface.DrawTexturedRect(w + num*(size + 6)*pscale, h - 100*pscale - 64*row, 54*pscale, 54*pscale)

		if ply:HasUpgrade(perk) then
			surface.SetDrawColor(color_gold)
			surface.SetMaterial(zmhud_icon_frame)
			surface.DrawTexturedRect(w + num*(size + 6)*pscale, h - 100*pscale - 64*row, 54*pscale, 54*pscale)
		end

		if perk == "vulture" and ply:HasVultureStink() then
			surface.SetMaterial(zmhud_vulture_glow)
			surface.SetDrawColor(color_white)
			surface.DrawTexturedRect((w + num*(size + 6)*pscale) - 24*pscale, (h - 100*pscale - 64*row) - 24*pscale, 102*pscale, 102*pscale)
			
			local stink = surface.GetTextureID("nz_moo/huds/t6/zm_hud_stink_ani_green")
			surface.SetTexture(stink)
			surface.SetDrawColor(color_white)
			surface.DrawTexturedRect((w + num*(size + 6)*pscale), (h - 100*pscale - 64*row) - 62*pscale, 64*pscale, 64*pscale)
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

local function VultureVision_t7_zod()
	local ply = LocalPlayer()
	if IsValid(ply:GetObserverTarget()) then ply = ply:GetObserverTarget() end
	if not ply:HasPerk("vulture") then return end
	local scale = (ScrW()/1920 + 1)/2
	local icon = vulture_textures["wunderfizz_machine"] //? if unknown

	for k, v in nzLevel.GetVultureArray() do
		if not IsValid(v) then continue end

		local data = v:WorldSpaceCenter():ToScreen()
		if not data.visible then continue end

		if ply:GetPos():DistToSqr(v:GetPos()) > 562500 then continue end //750^2

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

--[[ JEN WALTER'S ROUND COUNTER ]]--

local function AddStroke(number, entry, tally)
	local str = tally and string_rep("i", math.Clamp(tonumber(number), 1, 5)) or (isstring(number) and number or tonumber(number))
	table_insert(rounddata, entry, {
		image = str,
		state = CurTime() + 4,
		istally = tally,
		fade = false
	})
	table_insert(sparkdata, entry, {
		move = table_copy(strokes[str]),
		state = CurTime() + 1,
		istally = tally,
		offset = !tally and ((entry-1)*spacing) or 0
	})
end

local wiping = false

local function WipeRound()
	if !wiping then
		roundbusy = true
		wiping = true
		for k, v in pairs(rounddata) do
			v.state = CurTime() + 2
			v.fade = true
		end
		timer.Simple(1, function()
			table_insert(sparkdata, 999, {
				move = {[1] = {{12, 90}, {12 + (usingtally and tallysize or (spacing*table_count(rounddata))), 90}}},
				state = CurTime() + 1,
				overridesize = 2,
				istally = false,
				offset = 0
			})
		end)
		timer.Simple(1.99, function()
			rounddata = {}
			sparkdata = {}
			wiping = false
			roundbusy = false
		end)
	end
end

local function AddStrokeBulk(number)
	if !table_isempty(rounddata) then
		WipeRound()
	else
		usingtally = false
		number = tostring(number)
		for i = 1, string_len(tostring(number)) do
			local str = string_sub(number, i, i)
			if i == 1 then
				AddStroke(tonumber(str), i)
			else
				timer.Simple((i-1)/3, function() AddStroke(tonumber(str), i) end)
			end
		end
	end
end

local function RoundHud_t7_zod()
	if !nzRound then return end
	if not cl_drawhud:GetBool() then return end

	local w, h = ScrW(), ScrH()
	local pscale = (w/1920 + 1)/2

	if (!roundbusy or table_isempty(rounddata)) and !(nzRound:InState(ROUND_WAITING) or nzRound:InState(ROUND_PREP) or nzRound:InState(ROUND_CREATE)) then
		local R = nzRound and nzRound:GetNumber() or 0
		if R != oldnum then
			roundbusy = true
			if R < 6 then
				if !usingtally or table_count(rounddata) > R then
					WipeRound()
					usingtally = true
				else
					for i = 1, 5 do
						if R >= i and not rounddata[i] then
							AddStroke(i, i, true)
						end
					end
				end
			else
				AddStrokeBulk(R)
			end
		end
	elseif !table_isempty(rounddata) and (nzRound:InState(ROUND_WAITING) or nzRound:InState(ROUND_CREATE)) then
		WipeRound()
	end

	for k, v in pairs(rounddata) do
		local timer = v.state - CurTime()
		local T = v.istally
		local offset = ((k-1)*spacing)
		local hi = T and 160 or 160
		if nz_showcompass:GetBool() then
			hi = hi - 10
			if nz_showhealth:GetBool() then
				hi = hi - 10
			end
		end

		if timer > 3 then
			surface.SetMaterial(roundassets["burnt"][v.image])
			surface.SetDrawColor(color_white)
			surface.DrawTexturedRectUV(10 + (T and 0 or offset), h - hi*pscale, T and tallysize or digitsize.x, (T and tallysize or digitsize.y) * (4-timer), 0, 0, 1, 4-timer)
		elseif timer > 2 then
			surface.SetMaterial(roundassets["burnt"][v.image])
			surface.SetDrawColor(color_white)
			surface.DrawTexturedRect(10 + (T and 0 or offset), h - hi*pscale, T and tallysize or digitsize.x, T and tallysize or digitsize.y)
			surface.SetMaterial(roundassets["heat"][v.image])
			surface.SetDrawColor(Color(255,255,99,255*(3-timer)))
			surface.DrawTexturedRect(10 + (T and 0 or offset), h - hi*pscale, T and tallysize or digitsize.x, T and tallysize or digitsize.y)
		elseif timer > 1 and !v.fade then
			surface.SetMaterial(roundassets["normal"][v.image])
			surface.SetDrawColor(Color(255,255,255,255*(2-timer)))
			surface.DrawTexturedRect(10 + (T and 0 or offset), h - hi*pscale, T and tallysize or digitsize.x, T and tallysize or digitsize.y)
			surface.SetMaterial(roundassets["burnt"][v.image])
			surface.SetDrawColor(Color(255,255,255,1024*(timer-1)))
			surface.DrawTexturedRect(10 + (T and 0 or offset), h - hi*pscale, T and tallysize or digitsize.x, T and tallysize or digitsize.y)
			surface.SetMaterial(roundassets["heat"][v.image])
			surface.SetDrawColor(Color(255,80 + (175*(timer-1)),99*(timer-1)))
			surface.DrawTexturedRect(10 + (T and 0 or offset), h - hi*pscale, T and tallysize or digitsize.x, T and tallysize or digitsize.y)
		elseif timer > 0 and !v.fade then
			surface.SetMaterial(roundassets["normal"][v.image])
			surface.SetDrawColor(color_white)
			surface.DrawTexturedRect(10 + (T and 0 or offset), h - hi*pscale, T and tallysize or digitsize.x, T and tallysize or digitsize.y)
			surface.SetMaterial(roundassets["heat"][v.image])
			surface.SetDrawColor(Color(255,80,0,255*timer))
			surface.DrawTexturedRect(10 + (T and 0 or offset), h - hi*pscale, T and tallysize or digitsize.x, T and tallysize or digitsize.y)
		elseif v.fade then
			local fade_colora = ColorAlpha(color_white, 255*timer)
			local fade_colorb = ColorAlpha(color_white, 255*(1-timer))

			if timer > 1 then
				surface.SetMaterial(roundassets["normal"][v.image])
				surface.SetDrawColor(fade_colora)
				surface.DrawTexturedRect(10 + (T and 0 or offset), h - hi*pscale, T and tallysize or digitsize.x, T and tallysize or digitsize.y)
				surface.SetMaterial(roundassets["burnt"][v.image])
				surface.SetDrawColor(fade_colorb)
				surface.DrawTexturedRect(10 + (T and 0 or offset), h - hi*pscale, T and tallysize or digitsize.x, T and tallysize or digitsize.y)
			else
				surface.SetMaterial(roundassets["burnt"][v.image])
				surface.SetDrawColor(fade_colora)
				surface.DrawTexturedRectUV(10 + (T and 0 or offset), h - hi*pscale, T and tallysize or digitsize.x, T and tallysize or digitsize.y, 0, 0, 1, 1 - math.sin(math.pi*(0.5 + timer/2)))
				--surface.DrawTexturedRect(10 + (T and 0 or offset), h - hi*pscale, T and tallysize or digitsize.x, T and tallysize or digitsize.y)
			end
		else
			surface.SetMaterial(roundassets["normal"][v.image])
			surface.SetDrawColor(color_white)
			surface.DrawTexturedRect(10 + (T and 0 or offset), h - hi*pscale, T and tallysize or digitsize.x, T and tallysize or digitsize.y)
			if nzRound:InState(ROUND_PREP) then
				local prep_color = ColorAlpha(color_white, 127.5 + (127.5*math.sin(CurTime()*8)))

				surface.SetMaterial(roundassets["heat"][v.image])
				surface.SetDrawColor(prep_color)
				surface.DrawTexturedRect(10 + (T and 0 or offset), h - hi*pscale, T and tallysize or digitsize.x, T and tallysize or digitsize.y)
			end
		end
	end

	local busysparks = false
	if !table_isempty(sparkdata) then
		for k, v in pairs(sparkdata) do
			if CurTime() < v.state then
				busysparks = true
				local T = v.istally
				local timer = 1 - (v.state - CurTime())
				local spark_color = ColorAlpha(color_white, 512*(1-timer))
				for a, b in pairs(v.move) do
					local movement = (table_count(b) * timer) + 0.6
					local mod1 = math.floor(movement)
					local mod2 = math.ceil(movement)
					local mod3 = mod1 == mod2 and 1 or (movement % 1)
					local X = 10 + (T and 0 or v.offset)
					local Y = v.offsetheight or (T and 175 or 160)
					local SIZE = v.overridesize or 1
					if b[mod1] and b[mod2] then
						local x1 = b[mod1][1] * (T and tallycoordmult or 1)
						local y1 = b[mod1][2] * (T and tallycoordmult or 1)
						local x2 = b[mod2][1] * (T and tallycoordmult or 1)
						local y2 = b[mod2][2] * (T and tallycoordmult or 1)
						cwimage("rf/round/sparks/" .. (math.ceil(CurTime()*30) % 20) .. ".png", X + (x1*(1-mod3)) + (x2*mod3) + (33*SIZE), h - Y*pscale + (y1*(1-mod3)) + (y2*mod3) - (84*SIZE), 168 * SIZE, 252 * SIZE, spark_color)
					elseif b[mod1] then
						cwimage("rf/round/sparks/" .. (math.ceil(CurTime()*30) % 20) .. ".png", X + (b[mod1][1] * (T and tallycoordmult or 1)) + (33*SIZE), h - Y*pscale + (b[mod1][2] * (T and tallycoordmult or 1)) - (84*SIZE), 168 * SIZE, 252 * SIZE, spark_color)
					end
				end
			end
		end
	end

	if !busysparks then sparkdata = {} end
end

local prevroundspecial = false

local function StartChangeRound_t7_zod()
	local SND = "RoundEnd"
	if prev_round_special then
		SND = "SpecialRoundEnd"
	end
	nzSounds:Play(SND)
end

local function EndChangeRound_t7_zod()
	local SND = "RoundStart"
	roundbusy = false
	prev_round_special = false
	if nzRound:IsSpecial() then
		SND = "SpecialRoundStart"
		prev_round_special = true
	end
	if nzRound:GetNumber() == 1 then
		SND = "FirstRoundStart" -- Music for the first round.
	end
	nzSounds:Play(SND)
end

local function ResetRound_t7_zod()
end

--[[ JEN WALTER'S ROUND COUNTER ]]--

local function PlayerHealthHUD_t7_zod()
	if not cl_drawhud:GetBool() then return end
	if not nz_showhealth:GetBool() then return end

	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	if IsValid(ply:GetObserverTarget()) then ply = ply:GetObserverTarget() end
	if not (nzRound:InProgress() or nzRound:InState(ROUND_CREATE)) then return end

	local w, h = ScrW(), ScrH()
	local scale = (w/1920 + 1) / 2

	local health = ply:Health()
	local maxhealth = ply:GetMaxHealth()

	local healthscale = math.Clamp(health / maxhealth, 0, 1)
	local healthcolor = Color(255, 300*healthscale, 300*healthscale, 255)

	surface.SetDrawColor(healthcolor)
	surface.DrawRect(w/1920 + (45*scale), h - 190*scale, 152*healthscale*scale, 5*scale)

	local armor = ply:Armor()
	if armor > 0 then //there is no 'max armor' value, the hardcoded limit is 255, certain armor chargers max out at 200, and the max thru armor pickups is 100
		local maxarmor = (armor <= 100) and 100 or (armor <= 200) and 200 or 255
		local armorscale = math.Clamp(armor / maxarmor, 0, 1)

		surface.SetDrawColor(color_armor)
		surface.DrawRect(w/1920 + (45*scale), h - 180*scale, 152*armorscale*scale, 5*scale)
	end
end

local function PlayerStaminaHUD_t7_zod()
	if not cl_drawhud:GetBool() then return end
	if not nz_showstamina:GetBool() then return end

	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	if not ply.GetStamina then return end
	if IsValid(ply:GetObserverTarget()) then ply = ply:GetObserverTarget() end
	if not (nzRound:InProgress() or nzRound:InState(ROUND_CREATE)) then return end

	local w, h = ScrW(), ScrH()
	local scale = (w/1920 + 1) / 2

	local stamina = ply:GetStamina()
	local maxstamina = ply:GetMaxStamina()
	local fade = maxstamina*0.12 //lower the number, faster the fade in

	local staminascale = math.Clamp(stamina / maxstamina, 0, 1)
	local stamalpha = 1 - math.Clamp((stamina - maxstamina + fade) / fade, 0, 1)
	local staminacolor = ColorAlpha(color_white, 255*stamalpha)

	if stamina < maxstamina then
		surface.SetDrawColor(staminacolor)
		surface.DrawRect(w/1920 + (115*scale), h - 201*scale, 100*staminascale*scale, 5*scale)
	end
end

-- Hooks
hook.Add("HUDPaint", "nzHUDswapping_t7_zod", function()
	if nzMapping.Settings.hudtype == "Shadows of Evil" then
		hook.Add("HUDPaint", "roundHUD", StatesHud_t7_zod )
		hook.Add("HUDPaint", "PlayerHealthBarHUD", PlayerHealthHUD_t7_zod )
		hook.Add("HUDPaint", "PlayerStaminaBarHUD", PlayerStaminaHUD_t7_zod )
		hook.Add("HUDPaint", "1WepInventoryHUD", InventoryHUD_t7_zod )
		hook.Add("HUDPaint", "scoreHUD", ScoreHud_t7_zod )
		hook.Add("HUDPaint", "powerupHUD", PowerUpsHud_t7_zod )
		hook.Add("HUDPaint", "perksmmoinfoHUD", PerksMMOHud_t7_zod )
		hook.Add("HUDPaint", "perksHUD", PerksHud_t7_zod )
		hook.Add("HUDPaint", "vultureVision", VultureVision_t7_zod )
		hook.Add("HUDPaint", "roundnumHUD", RoundHud_t7_zod )
		hook.Add("HUDPaint", "gunHUD", GunHud_t7_zod )
		hook.Add("HUDPaint", "deathiconsHUD", DeathHud_t7_zod )

		hook.Add("OnRoundPreparation", "BeginRoundHUDChange", StartChangeRound_t7_zod )
		hook.Add("OnRoundStart", "EndRoundHUDChange", EndChangeRound_t7_zod )
		hook.Add("OnRoundEnd", "GameEndHUDChange", ResetRound_t7_zod )
	end
end)

//--------------------------------------------------/GhostlyMoo and Fox's Shadoes of Evil HUD\------------------------------------------------\\
