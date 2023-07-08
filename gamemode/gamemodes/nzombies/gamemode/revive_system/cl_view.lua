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
local mat_revive = Material("materials/Revive.png", "unlitgeneric smooth")
local blood_overlay = Material("materials/overlay_urdyinglol.png", "unlitgeneric smooth")

local bloodpulse = true --if true, going up
local pulse = 0

local vector_up_35 = Vector(0,0,35)

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
	if nzRevive.Players[LocalPlayer():EntIndex()] then
		local fadeadd = ((1/nz_bleedouttime:GetFloat()) * FrameTime()) * -1
		tab[ "$pp_colour_colour" ] = math.Approach(tab[ "$pp_colour_colour" ], 0, fadeadd)
		tab[ "$pp_colour_addr" ] = math.Approach(tab[ "$pp_colour_addr" ], 0.5, fadeadd *-0.5)
		tab[ "$pp_colour_mulr" ] = math.Approach(tab[ "$pp_colour_mulr" ], 1, -fadeadd)
		tab[ "$pp_colour_mulg" ] = math.Approach(tab[ "$pp_colour_mulg" ], 0, fadeadd)
		tab[ "$pp_colour_mulb" ] = math.Approach(tab[ "$pp_colour_mulb" ], 0, fadeadd)
		DrawColorModify(tab)
	end
end

local function DrawDownedPlayers()
	if not cl_drawhud:GetBool() then return end

	local w, h = ScrW(), ScrH()
	local scale = (w/1920 + 1)/2
	local bleedtime = nz_bleedouttime:GetFloat()
	local pply = LocalPlayer()

	for k, v in pairs(nzRevive.Players) do
		local ply = Entity(k)
		if IsValid(ply) then
			local id = ply:EntIndex()
			if ply == pply then continue end
			if not nzRevive.Players[id].DownTime then continue end
			local revivor = nzRevive.Players[id].RevivePlayer

			local ppos = ply:GetPos()
			local posxy = (ppos + vector_up_35):ToScreen()
			local dir = ((ppos + vector_up_35) - EyeVector()*2):GetNormal():ToScreen()

			if posxy.x - 35 < 60 or posxy.x - 35 > w-130 or posxy.y - 50 < 60 or posxy.y - 50 > h-110 then
				posxy.x, posxy.y = XYCompassToScreen((ppos + vector_up_35), 60)
			end

			local revivescale = 1 - math.Clamp((CurTime() - nzRevive.Players[id].DownTime) / bleedtime, 0, 1)

			surface.SetDrawColor(255, 180*revivescale, 0)
			if nzRevive.Players[id].ReviveTime then
				surface.SetDrawColor(color_white)
			end
			if IsValid(revivor) and revivor:HasPerk('revive') then
				surface.SetDrawColor(color_revive)
			end
			surface.SetMaterial(mat_revive)
			surface.DrawTexturedRect(posxy.x - 35, posxy.y - 50, 70, 50)
		end	
	end
end

local function DrawRevivalProgress()
	if not cl_drawhud:GetBool() then return end

	local ply = LocalPlayer()
	local tr = util.QuickTrace(ply:EyePos(), ply:GetAimVector()*100, ply)
	local dply = tr.Entity
	if IsValid(dply) then
		local id = dply:EntIndex()

		local hasrevive = ply:HasPerk("revive")
		local revtime = hasrevive and 2 or 4
		local w, h = ScrW(), ScrH()
		local pscale = 1
		if nz_betterscaling:GetBool() then
			pscale = (w/1920 + 1)/2
		end

		if nzRevive.Players[id] and nzRevive.Players[id].RevivePlayer == ply then
			surface.SetDrawColor(color_black_180)
			surface.DrawRect(w/2 - 150, h - 400*pscale, 300, 20)

			surface.SetDrawColor(color_white)
			if hasrevive then
				surface.SetDrawColor(color_revive)
			end
			surface.DrawRect(w/2 - 145, h - 395*pscale, 290 * (CurTime()-nzRevive.Players[id].ReviveTime)/revtime, 10)
		end
	end
end

local function DrawDownedNotify()
	if not cl_drawhud:GetBool() then return end

	local ply = LocalPlayer()
	if !ply:GetNotDowned() then
		local w, h = ScrW(), ScrH()
		local pscale = 1
		if nz_betterscaling:GetBool() then
			pscale = (w/1920 + 1)/2
		end

		local text = "YOU NEED HELP!"
		local font = ("nz.main."..GetFontType(nzMapping.Settings.mainfont))
		local rply = nzRevive.Players[ply:EntIndex()].RevivePlayer

		if IsValid(rply) and rply:IsPlayer() then
			text = rply:Nick().." is reviving you!"
		end

		draw.SimpleText(text, font, w/2, h*0.9*pscale, color_red_200, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end

local function DrawDownedHeadsUp()
	if not cl_drawhud:GetBool() then return end

	local font = ("nz.small."..GetFontType(nzMapping.Settings.smallfont))
	local h = 40
	local offset = 60
	local max = 2
	local c = 0
	local scw, sch = ScrW(), ScrH()
	local pscale = 1
	if nz_betterscaling:GetBool() then
		pscale = (scw/1920 + 1)/2
	end

	for k, v in pairs(nzRevive.Notify) do
		if type(k) == "Player" and IsValid(k) then
			local fade = math.Clamp(CurTime() - v.time - 5, 0, 1)
			local status = v.text or "needs to be revived!"
			local alpha = 255 - (255*fade)

			draw.SimpleText(k:Nick().." "..status, font, scw/2, sch - (h*pscale)- offset * c, ColorAlpha(color_white, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			if fade >= 1 then nzRevive.Notify[k] = nil end
			c = c + 1
		else
			local fade = math.Clamp(CurTime() - v.time, 0, 1)
			local status = v.text
			local alpha = 255 - (255*fade)

			draw.SimpleText(status, font, scw/2, sch - (h*pscale) - offset * c, ColorAlpha(color_white, alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			if fade >= 1 then nzRevive.Notify[k] = nil end
			c = c + 1
		end
	end
end

local function DrawDamagedOverlay()
	local ply = LocalPlayer()
	if nz_bloodoverlay:GetBool() and ply:Alive() then
		local w, h = ScrW(), ScrH()

		local health = ply:Health()
		local maxhealth = ply:GetMaxHealth()
		local fade = (math.Clamp(health/maxhealth, 0.3, 0.7)-0.3)/0.4
		local fade2 = 1 - math.Clamp(health/maxhealth, 0, 0.7)/0.7
		local alpha = 255-fade*255

		surface.SetMaterial(blood_overlay)
		surface.SetDrawColor(ColorAlpha(color_white, alpha))
		surface.DrawTexturedRect(-10, -10, w+20, h+20)

		if fade2 > 0 then
			local ft = FrameTime()
			if bloodpulse then
				pulse = math.Approach(pulse, 255, math.Clamp(pulse, 1, 50)*ft*100)
				if pulse >= 255 then bloodpulse = false end
			else
				if pulse <= 0 then bloodpulse = true end
				pulse = math.Approach(pulse, 0, -255*ft)
			end
			surface.SetDrawColor(255,255,255,pulse*fade2)
			surface.DrawTexturedRect( -10, -10, w+20, h+20)
		end
	end
end

local function DrawTombstoneNotify()
	if not cl_drawhud:GetBool() then return end
	local font = ("nz.small."..GetFontType(nzMapping.Settings.smallfont))

	if LocalPlayer():GetDownedWithTombstone() then
		local w, h = ScrW(), ScrH()
		local pscale = 1
		if nz_betterscaling:GetBool() then
			pscale = (w/1920 + 1)/2
		end
		local text = "Press & Hold "..string.upper(input.LookupBinding("+USE")).." to feed the zombies"

		draw.SimpleTextOutlined(text, font, w/2, h - 540*pscale, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black)
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

local function DrawWhosWhoProgress()
	if not cl_drawhud:GetBool() then return end
	local ply = LocalPlayer()

	if ply:HasUpgrade("whoswho") and ply:GetNW2Float("nz.ChuggaTeleDelay",0) < CurTime() then
		local w, h = ScrW(), ScrH()
		local scale = (w/1920 + 1) / 2
		local usetime = 3
		local pscale = 1
		if nz_betterscaling:GetBool() then
			pscale = scale
		end

		local fuck = true
		if not ply:IsOnGround() then
			fuck = false
		end
		if (ply:GetNW2Float("nz.LastHit", 0) + 5) > CurTime() then
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
hook.Add("RenderScreenspaceEffects", "DrawColorModulation", DrawColorModulation)
hook.Add("HUDPaint", "DrawDamageOverlay", DrawDamagedOverlay)
hook.Add("HUDPaint", "DrawDownedNotify", DrawDownedNotify )
hook.Add("HUDPaint", "DrawDownedPlayersNotify", DrawDownedHeadsUp )
hook.Add("HUDPaint", "DrawTombstoneNotify", DrawTombstoneNotify )
hook.Add("HUDPaint", "DrawTombstoneProgress", DrawTombstoneProgress )
hook.Add("HUDPaint", "DrawWhosWhoProgress", DrawWhosWhoProgress )

hook.Add("HUDPaint", "nzHUDreviveswap", function()
	if not reworkedHUDs[nzMapping.Settings.hudtype] then
		hook.Add("HUDPaint", "DrawDownedPlayers", DrawDownedPlayers )
		hook.Add("HUDPaint", "DrawRevivalProgress", DrawRevivalProgress )
	end
end)