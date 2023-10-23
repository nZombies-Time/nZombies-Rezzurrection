-------------------------
-- Localize
local pairs = pairs
local IsValid = IsValid
local LocalPlayer = LocalPlayer
local CurTime = CurTime
local Color = Color

local math = math
local surface = surface
local table = table
local draw = draw

local table_insert = table.insert

local TEXT_ALIGN_CENTER = TEXT_ALIGN_CENTER
local TEXT_ALIGN_TOP = TEXT_ALIGN_TOP
local TEXT_ALIGN_BOTTOM = TEXT_ALIGN_BOTTOM

CreateClientConVar("nz_bloodoverlay", 1, true, false, "Enable or disable drawing the blood overlay when low health. (0 false, 1 true), Default is 1.", 0, 1)

local cl_drawhud = GetConVar("cl_drawhud")
local nz_bleedouttime = GetConVar("nz_downtime")
local nz_betterscaling = GetConVar("nz_hud_better_scaling")
local nz_bloodoverlay = GetConVar("nz_bloodoverlay")

local zmhud_icon_revive = Material("materials/Revive.png", "unlitgeneric smooth")
local zmhud_blood_overlay = Material("materials/nz_moo/huds/t7/i_blood_damage_c.png", "unlitgeneric smooth")
local zmhud_blood_highlight = Material("materials/nz_moo/huds/t7/i_blood_highlights_c.png", "unlitgeneric smooth")

local vector_up_35 = Vector(0,0,35)

local color_black_100 = Color(0, 0, 0, 100)
local color_black_180 = Color(0, 0, 0, 180)
local color_red_200 = Color(200, 0, 0, 255)
local color_revive = Color(150, 200, 255)

local reworkedHUDs = {
	["Shadows of Evil"] = true,
	["Black Ops 3"] = true,
	["Black Ops 1"] = true,
	["Buried"] = true,
	["Mob of the Dead"] = true,
	["Origins (Black Ops 2)"] = true,
	["Tranzit (Black Ops 2)"] = true
}

local dahudz = {
	["Shadows of Evil"] = true,
	["Black Ops 3"] = true,
}

local SyretteClass = {
	["tfa_bo2_syrette"] = true,
	["tfa_bo3_syrette"] = true,
	["tfa_bo4_syrette"] = true,
}

-- Useful ToScreen replacement for better directional
function XYCompassToScreen(pos, boundary)
	local boundary = boundary or 0
	local eyedir = EyeVector()
	local w = ScrW() - boundary
	local h = ScrH() - boundary
	local dir = (pos - EyePos()):GetNormalized()
	dir = Vector(dir.x, dir.y, 0)
	eyedir = Vector(eyedir.x, eyedir.y, 0)

	eyedir:Rotate(Angle(0,-90,0))
	local newdirx = eyedir:Dot(dir)

	return ScrW()/2 + (newdirx*w/2), math.Clamp(pos:ToScreen().y, boundary, h)
end

local fade = 1
local tab = {
	[ "$pp_colour_addr" ] = 0,
	[ "$pp_colour_addg" ] = 0,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = 0,
	[ "$pp_colour_mulr" ] = 0,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0
}

function nzRevive:ResetColorFade()
	tab = {
		 [ "$pp_colour_addr" ] = 0,
		 [ "$pp_colour_addg" ] = 0,
		 [ "$pp_colour_addb" ] = 0,
		 [ "$pp_colour_brightness" ] = 0,
		 [ "$pp_colour_contrast" ] = 1,
		 [ "$pp_colour_colour" ] = 0,
		 [ "$pp_colour_mulr" ] = 0,
		 [ "$pp_colour_mulg" ] = 0,
		 [ "$pp_colour_mulb" ] = 0
	}
	fade = 1
end

function nzRevive:DownedHeadsUp(ply, text)
	nzRevive.Notify[ply] = {time = CurTime(), text = text}
end

function nzRevive:CustomNotify(text, time)
	if !text or !isstring(text) then return end
	if time then
		table.insert(nzRevive.Notify, {time = CurTime() + time, text = text})
	else
		table.insert(nzRevive.Notify, {time = CurTime() + 5, text = text})
	end
end

function surface.DrawTexturedRectRotatedPoint( x, y, w, h, rot, x0, y0 )
	local c = math.cos( math.rad( rot ) )
	local s = math.sin( math.rad( rot ) )

	local newx = y0 * s - x0 * c
	local newy = y0 * c + x0 * s

	surface.DrawTexturedRectRotated( x + newx, y + newy, w, h, rot )
end

local function DrawColorModulation()
	local ply = LocalPlayer()
	if IsValid(ply:GetObserverTarget()) then ply = ply:GetObserverTarget() end

	if nzRevive.Players[ply:EntIndex()] then
		local fadeadd = ((1/nz_bleedouttime:GetFloat()) * FrameTime()) * -1
		tab[ "$pp_colour_addr" ] = math.Approach(tab[ "$pp_colour_addr" ], 0.28, fadeadd *-0.28)
		tab[ "$pp_colour_mulr" ] = math.Approach(tab[ "$pp_colour_mulr" ], 1, -fadeadd)
		tab[ "$pp_colour_contrast" ] = math.Approach(tab[ "$pp_colour_contrast" ], 0.5, fadeadd *-0.5)
		DrawColorModify(tab)
	end
end

local function DrawDownedPlayers()
	if not cl_drawhud:GetBool() then return end

	local w, h = ScrW(), ScrH()
	local scale = (w/1920 + 1)/2
	local bleedtime = nz_bleedouttime:GetFloat()
	local pply = LocalPlayer()
	if IsValid(pply:GetObserverTarget()) then
		pply = pply:GetObserverTarget()
	end

	for id, data in pairs(nzRevive.Players) do
		local ply = Entity(id)
		if not IsValid(ply) then continue end

		if ply == pply then continue end
		if not data.DownTime then continue end
		local revivor = data.RevivePlayer

		local ppos = ply:GetPos()
		local posxy = (ppos + vector_up_35):ToScreen()

		if posxy.x - 35 < 60 or posxy.x - 35 > w-130 or posxy.y - 50 < 60 or posxy.y - 50 > h-110 then
			posxy.x, posxy.y = XYCompassToScreen((ppos + vector_up_35), 60)
		end

		local downscale = 1 - math.Clamp((CurTime() - data.DownTime) / bleedtime, 0, 1)
		surface.SetDrawColor(255, 180*downscale, 0)
		surface.SetMaterial(zmhud_icon_revive)
		surface.DrawTexturedRect(posxy.x - 32*scale, posxy.y - 32*scale, 64*scale, 48*scale)

		if IsValid(revivor) and data.ReviveTime then
			local hasrevive = revivor:HasPerk("revive")
			local revtime = hasrevive and 2 or 4
			local revivescale = math.Clamp((CurTime() - data.ReviveTime) / revtime, 0, 1)

			surface.SetDrawColor(color_white)
			if hasrevive then
				surface.SetDrawColor(color_revive)
			end
			surface.SetMaterial(zmhud_icon_revive)
			surface.DrawTexturedRectUV(posxy.x - 32*scale, posxy.y - 32*scale, 64*scale, 48*revivescale*scale, 0, 0, 1, 1*revivescale)
		end
	end
end

local function DrawRevivalProgress()
	if not cl_drawhud:GetBool() then return end

	local ply = LocalPlayer()
	if IsValid(ply:GetObserverTarget()) then
		ply = ply:GetObserverTarget()
	end

	local reviving = ply:GetPlayerReviving()
	if not IsValid(reviving) then return end
	local id = reviving:EntIndex()

	local hasrevive = ply:HasPerk("revive")
	local revtime = hasrevive and 2 or 4
	local w, h = ScrW(), ScrH()
	local pscale = 1
	if nz_betterscaling:GetBool() then
		pscale = (w/1920 + 1)/2
	end

	local data = nzRevive.Players[id]
	if data and data.RevivePlayer == ply then
		local revivescale = math.Clamp((CurTime() - data.ReviveTime) / revtime, 0, 1)

		surface.SetDrawColor(color_black_180)
		surface.DrawRect(w/2 - 150, h - 400*pscale, 300, 20)

		surface.SetDrawColor(color_white)
		if hasrevive then
			surface.SetDrawColor(color_revive)
		end
		surface.DrawRect(w/2 - 145, h - 395*pscale, 290*revivescale, 10)
	end
end

local downed = false
local downdelay = 0
local huddowndata = {
	["Classic"] = { -- default/fallback
		loop = "nz_moo/player/t6/laststand_loop.wav",
		revive = "nz_moo/player/t6/plr_revived.wav",
		delay = 0,
		volume = 0.5,
	},
	["Black Ops 3"] = {
		down = "nz_moo/player/t7/player_downed.wav",
		loop = "nz_moo/player/t7/player_downed_loop.wav",
		revive = "nz_moo/player/t7/player_revived.wav",
		delay = 0.5,
		volume = 0.25,
	},
	["Shadows of Evil"] = {
		down = "nz_moo/player/t7/player_downed.wav",
		loop = "nz_moo/player/t7/player_downed_loop.wav",
		revive = "nz_moo/player/t7/player_revived.wav",
		delay = 0.5,
		volume = 0.25,
	},
}

local function DrawDownedNotify()
	if not cl_drawhud:GetBool() then return end
	local hudtype = nzMapping.Settings.hudtype
	local ply = LocalPlayer()
	/*if IsValid(ply:GetObserverTarget()) then
		ply = ply:GetObserverTarget()
	end*/

	local downdata = huddowndata[hudtype]
	if not downdata then
		downdata = huddowndata["Classic"]
	end

	if downdata then
		if not ply.downambience then
			ply.downstring = downdata.loop
			ply.downambience = CreateSound(ply, downdata.loop)
		elseif ply.downstring ~= downdata.loop then
			if ply.downambience:IsPlaying() then ply.downambience:Stop() end

			ply.downstring = downdata.loop
			ply.downambience = CreateSound(ply, downdata.loop)
		end

		if !ply:GetNotDowned() and not downed then
			downed = true
			downdelay = CurTime() + downdata.delay
			if downdata.down then
				surface.PlaySound(downdata.down)
			end
		end
		if (not ply:Alive() or ply:GetNotDowned()) and downed then
			downed = false
		end

		if downed then
			if downdelay < CurTime() then
				ply.downambience:Play()
				ply.downambience:ChangeVolume(downdata.volume,0)
			end
		else
			if downdata.revive and ply.downambience:IsPlaying() then
				ply:EmitSound(downdata.revive)
			end
			ply.downambience:Stop()
		end
	end

	if nzRevive.Players and nzRevive.Players[ply:EntIndex()] then
		local rply = nzRevive.Players[ply:EntIndex()].RevivePlayer
		if !ply:GetNotDowned() and IsValid(rply) and rply:IsPlayer() then
			local font = ("nz.small."..GetFontType(nzMapping.Settings.smallfont))
			local w, h = ScrW(), ScrH()
			local scale = (w/1920 + 1)/2
			local pscale = 1
			if nz_betterscaling:GetBool() then
				pscale = scale
			end
			if scale < 0.96 then
				font = ("nz.points."..GetFontType(nzMapping.Settings.smallfont))
			end

			draw.SimpleTextOutlined(rply:Nick().." is reviving you!", font, w/2, h - 280*pscale, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black_180)
		end
	end
end

local function DrawDownedHeadsUp()
	if not cl_drawhud:GetBool() then return end
	local font = ("nz.small."..GetFontType(nzMapping.Settings.smallfont))

	local w, h = ScrW(), ScrH()
	local scale = (w/1920 + 1)/2
	local count = 0
	local pscale = 1
	if nz_betterscaling:GetBool() then
		pscale = scale
	end
	if scale < 0.96 then
		font = ("nz.points."..GetFontType(nzMapping.Settings.smallfont))
	end

	surface.SetFont(font)
	for k, v in pairs(nzRevive.Notify) do
		if type(k) == "Player" and IsValid(k) then
			local fade = math.Clamp(CurTime() - v.time - 5, 0, 1)
			local status = v.text or "needs to be revived!"
			local alpha = 255 - (255*fade)
			local wt, ht = surface.GetTextSize(status)
			local offset = ht + 5*pscale

			draw.SimpleTextOutlined(k:Nick().." "..status, font, w/2, h - (220*pscale) + (offset*count), ColorAlpha(color_white, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, ColorAlpha(color_black, 180*(1-fade)))

			if fade >= 1 then nzRevive.Notify[k] = nil end
			count = count + 1
		else
			local fade = math.Clamp(CurTime() - v.time, 0, 1)
			local status = v.text or ""
			local alpha = 255 - (255*fade)
			local wt, ht = surface.GetTextSize(status)
			local offset = ht + 5*pscale

			draw.SimpleTextOutlined(status, font, w/2, h - (220*pscale) + (offset*count), ColorAlpha(color_white, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, ColorAlpha(color_black, 180*(1-fade)))

			if fade >= 1 then nzRevive.Notify[k] = nil end
			count = count + 1
		end
	end
end

local function DrawDamageOverlay()
	local ply = LocalPlayer()
	if IsValid(ply:GetObserverTarget()) then
		ply = ply:GetObserverTarget()
	end

	if nz_bloodoverlay:GetBool() and (ply:Alive() or !ply:GetNotDowned()) then
		local health = ply:Health()
		local diff = ply:GetMaxHealth()*0.2
		local maxhealth = ply:GetMaxHealth() - diff

		if health < maxhealth or !ply:GetNotDowned() then
			local w, h = ScrW(), ScrH()
			local fade = 1 - math.Clamp(health/maxhealth, 0, 1)
			if !ply:GetNotDowned() then fade = 1 end
			local alpha = 255*fade

			surface.SetDrawColor(ColorAlpha(color_white, alpha))

			surface.SetMaterial(zmhud_blood_highlight)
			surface.DrawTexturedRect(0, 0, w, h)

			surface.SetMaterial(zmhud_blood_overlay)
			surface.DrawTexturedRect(0, 0, w, h)

			if fade > 0 then
				local pulse = math.abs(math.sin(CurTime()*4))
				surface.SetDrawColor(ColorAlpha(color_white, (255*pulse)*fade))
				surface.SetMaterial(zmhud_blood_overlay)
				surface.DrawTexturedRect(0, 0, w, h)
			end
		end
	end
end

local tombstonetime = nil
local senttombstonerequest = false

local function DrawTombstoneProgress()
	local ply = LocalPlayer()

	if ply:GetDownedWithTombstone() then
		local w, h = ScrW(), ScrH()
		local pscale = 1
		if nz_betterscaling:GetBool() then
			pscale = (w/1920 + 1)/2
		end

		local killtime = 1

		if ply:KeyDown(IN_USE) then
			if !tombstonetime then
				tombstonetime = CurTime()
			end

			local pct = math.Clamp((CurTime()-tombstonetime)/killtime, 0, 1)

			surface.SetDrawColor(color_black_180)
			surface.DrawRect(w/2 - 150, h - 500*pscale, 300, 20)
			surface.SetDrawColor(color_white)
			surface.DrawRect(w/2 - 145, h - 495*pscale, 290 * pct, 10)

			if pct >= 1 and !senttombstonerequest then
				net.Start("nz_TombstoneSuicide")
				net.SendToServer()
				senttombstonerequest = true
			end
		else
			tombstonetime = nil
			senttombstonerequest = false
		end
	end
end

local whoswhotime = nil
local sentwhoswhorequest = false
local attacktime = 0

local function DrawWhosWhoProgress()
	if not cl_drawhud:GetBool() then return end
	local ply = LocalPlayer()
	local curtime = CurTime()

	if ply:HasUpgrade("whoswho") and ply:GetNW2Float("nz.ChuggaTeleDelay",0) < CurTime() then
		local w, h = ScrW(), ScrH()
		local scale = (w/1920 + 1) / 2
		local usetime = 3
		local pscale = 1
		if nz_betterscaling:GetBool() then
			pscale = scale
		end
		local revive = ply:GetPlayerReviving()

		local fuck = true

		if (not ply:IsOnGround())
		or (ply:GetNW2Float("nz.LastHit", 0) + 5) > CurTime()
		or (IsValid(revive) and nzRevive.Players[revive:EntIndex()])
		or (ply:KeyDown(IN_ATTACK)) then
			fuck = false
			attacktime = curtime + 0.5
		end

		if attacktime > curtime then
			fuck = false
		end

		if ply:KeyDown(IN_USE) and ply:KeyDown(IN_RELOAD) and fuck then
			if !whoswhotime then
				whoswhotime = CurTime()
			end

			local pct = math.Clamp((CurTime() - whoswhotime) / usetime, 0, 1)

			surface.SetDrawColor(color_black_180)
			surface.DrawRect(w/2 - 150, h - 500*pscale, 300, 20)
			surface.SetDrawColor(color_white)
			surface.DrawRect(w/2 - 145, h - 495*pscale, 290 * pct, 10)

			if pct >= 1 and !sentwhoswhorequest then
				net.Start("nz_WhosWhoTeleRequest")
				net.SendToServer()
				sentwhoswhorequest = true
			end
		else
			whoswhotime = nil
			sentwhoswhorequest = false
		end
	end
end

-- Hooks
hook.Add("RenderScreenspaceEffects", "DrawColorModulation", DrawColorModulation )
hook.Add("HUDPaint", "DrawDamageOverlay", DrawDamageOverlay )
hook.Add("HUDPaint", "DrawDownedNotify", DrawDownedNotify )
hook.Add("HUDPaint", "DrawDownedPlayersNotify", DrawDownedHeadsUp )
hook.Add("HUDPaint", "DrawTombstoneProgress", DrawTombstoneProgress )
hook.Add("HUDPaint", "DrawWhosWhoProgress", DrawWhosWhoProgress )

hook.Add("TFA_DrawCrosshair", "ReviveBlockCrosshair", function(wep)
	local ply = LocalPlayer()
	if not IsValid(ply) then return end
	if not IsValid(wep) then return end
	if IsValid(ply:GetObserverTarget()) then ply = ply:GetObserverTarget() end

	local reviving = ply:GetPlayerReviving()
	if SyretteClass[wep:GetClass()] and IsValid(reviving) and reviving:IsPlayer() and not reviving:GetNotDowned() then
		return true
	end
end)

hook.Add("HUDPaint", "nzHUDreviveswap", function()
	if not reworkedHUDs[nzMapping.Settings.hudtype] then
		hook.Add("HUDPaint", "DrawDownedPlayers", DrawDownedPlayers )
		hook.Add("HUDPaint", "DrawRevivalProgress", DrawRevivalProgress )
	end
end)