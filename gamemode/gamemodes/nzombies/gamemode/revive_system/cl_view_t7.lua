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

local cl_drawhud = GetConVar("cl_drawhud")
local nz_bleedouttime = GetConVar("nz_downtime")
local t7_hud_revive_skull = Material("nz_moo/huds/t7/uie_t7_zm_hud_revive_skull.png", "unlitgeneric smooth")
local t7_hud_revive_glow = Material("nz_moo/huds/t7/uie_t7_zm_hud_revive_glow.png", "unlitgeneric smooth")
local t7_hud_revive_arrow = Material("nz_moo/huds/t7/uie_t7_zm_hud_revive_arrow.png", "unlitgeneric smooth")
local t7_hud_revive_ringblur = Material("nz_moo/huds/t7/uie_t7_zm_hud_revive_ringblur.png", "unlitgeneric smooth")

local vector_up_35 = Vector(0,0,35)

local color_white_100 = Color(255, 255, 255, 100)
local color_black_180 = Color(0, 0, 0, 180)
local color_black_100 = Color(0, 0, 0, 100)
local color_red_200 = Color(200, 0, 0, 255)
local color_red_50 = Color(255, 0, 0, 50)
local color_green_50 = Color(0, 255, 0, 50)
local color_revive = Color(140, 160, 255)

local dahudz = {
	["Black Ops 3"] = true,
	["Shadows of Evil"] = true
}

local Circles = {
	[1] = {r = -1, col = Color(0,200,0,100), colb = Color(200,0,0,100), colr = Color(0,50,150,100)},
	[2] = {r = 0, col = Color(0,255,0,200), colb = Color(255,0,0,200), colr = Color(50,150,200,200)},
	[3] = {r = 1, col = Color(0,255,0,255), colb = Color(255,0,0,255), colr = Color(150,150,255,255)},
	[4] = {r = 2, col = Color(0,255,0,200), colb = Color(255,0,0,200), colr = Color(50,150,200,200)},
	[5] = {r = 3, col = Color(0,200,0,100), colb = Color(200,0,0,100), colr = Color(0,50,150,100)},
}

local function DrawReviveCircle( X, Y, target_radius, value, dying, revive )
	local endang = 360 * value
	if endang == 0 then return end

	for i = 1, #Circles do
		local data = Circles[ i ]
		local radius = target_radius + data.r
		local segmentdist = endang / ( math.pi * radius / 3 )

		for a = 0, endang, segmentdist do
			surface.SetDrawColor( revive and data.colr or (dying and data.colb or data.col) )
			surface.DrawLine( X - math.sin( math.rad( a ) ) * radius, Y + math.cos( math.rad( a ) ) * radius, X - math.sin( math.rad( a + segmentdist ) ) * radius, Y + math.cos( math.rad( a + segmentdist ) ) * radius )
		end
	end
end

local function DrawDownedPlayers_t7()
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
		if IsValid(revivor) and revivor == pply then continue end

		local ppos = ply:GetPos()
		local posxy = (ppos + vector_up_35):ToScreen()
		local dir = ((ppos + vector_up_35) - EyeVector()*2):GetNormal():ToScreen()

		local dying = false
		local hasrevive = false

		if posxy.x-35 < 60 or posxy.x-35 > w-130 or posxy.y-50 < 60 or posxy.y-50 > h-110 then
			posxy.x, posxy.y = XYCompassToScreen((ppos + vector_up_35), 64*scale)
		end

		local revivescale = 1 - math.Clamp((CurTime() - data.DownTime) / bleedtime, 0, 1)
		if data.ReviveTime and IsValid(revivor) then
			hasrevive = revivor:HasPerk("revive")
			local revtime = hasrevive and 2 or 4
			revivescale = math.Clamp((CurTime() - data.ReviveTime) / revtime, 0, 1)
		end

		if not IsValid(revivor) and revivescale <= 0.35 then
			dying = true
		end

		surface.SetDrawColor(color_white_100)
		surface.SetMaterial(t7_hud_revive_glow)
		surface.DrawTexturedRect(posxy.x - 40*scale, posxy.y - 40*scale, 80*scale, 80*scale)

		surface.SetDrawColor(color_white)
		surface.SetMaterial(t7_hud_revive_skull)
		surface.DrawTexturedRect(posxy.x - 40*scale, posxy.y - 40*scale, 80*scale, 80*scale)

		surface.SetDrawColor(dying and color_red_50 or color_green_50)
		surface.SetMaterial(t7_hud_revive_ringblur)
		surface.DrawTexturedRect(posxy.x - 40*scale, posxy.y - 40*scale, 80*scale, 80*scale)

		DrawReviveCircle(posxy.x, posxy.y, 32*scale, 1*revivescale, dying, hasrevive)
	end
end

local revnum = 0
local function DrawRevivalProgress_t7()
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
	local scale = (w/1920 + 1)/2

	local data = nzRevive.Players[id]
	if data and data.RevivePlayer == ply then
		revnum = revnum + FrameTime()
		if revnum >= 1 then revnum = 0 end
		local pulsing = 1.5 - ((1 + revnum)*0.25)

		local revivescale = math.Clamp((CurTime() - data.ReviveTime) / revtime, 0, 1)

		surface.SetDrawColor(color_white_100)
		surface.SetMaterial(t7_hud_revive_glow)
		surface.DrawTexturedRect(w/2 - 40*scale, h/2 - 40*scale, 80*scale, 80*scale)

		surface.SetDrawColor(color_white)
		surface.SetMaterial(t7_hud_revive_skull)
		surface.DrawTexturedRect(w/2 - (40*pulsing)*scale, h/2 - (40*pulsing)*scale, (80*pulsing)*scale, (80*pulsing)*scale)

		surface.SetDrawColor(dying and color_red_50 or color_green_50)
		surface.SetMaterial(t7_hud_revive_ringblur)
		surface.DrawTexturedRect(w/2 - 40*scale, h/2 - 40*scale, 80*scale, 80*scale)

		DrawReviveCircle(w/2, h/2, 32*scale, 1*revivescale, false, hasrevive)
	end
end

-- Hooks
hook.Add("HUDPaint", "nzHUDreviveswap_t7_zod", function()
	if dahudz[nzMapping.Settings.hudtype] then
		hook.Add("HUDPaint", "DrawDownedPlayers", DrawDownedPlayers_t7 )
		hook.Add("HUDPaint", "DrawRevivalProgress", DrawRevivalProgress_t7 )
	end
end)
