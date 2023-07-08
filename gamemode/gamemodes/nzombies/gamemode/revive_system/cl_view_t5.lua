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
local t5_hud_revive = Material("nz_moo/huds/t5/uie_t5hud_waypoint_revive.png", "unlitgeneric smooth")

local bloodpulse = true --if true, going up
local pulse = 0

local vector_up_35 = Vector(0,0,35)

local color_white_100 = Color(255, 255, 255, 100)
local color_black_180 = Color(0, 0, 0, 180)
local color_black_100 = Color(0, 0, 0, 100)
local color_red_200 = Color(200, 0, 0, 255)
local color_red_50 = Color(255, 0, 0, 50)
local color_green_50 = Color(0, 255, 0, 50)
local color_revive = Color(150, 200, 255)

local function DrawDownedPlayers_t5()
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
			surface.SetMaterial(t5_hud_revive)
			surface.DrawTexturedRect(posxy.x - 32*scale, posxy.y - 32*scale, 64*scale, 64*scale)
		end	
	end
end

local function DrawRevivalProgress_t5()
	if not cl_drawhud:GetBool() then return end

	local ply = LocalPlayer()
	local tr = util.QuickTrace(ply:EyePos(), ply:GetAimVector()*100, ply)
	local dply = tr.Entity
	if IsValid(dply) then
		local id = dply:EntIndex()

		local hasrevive = ply:HasPerk("revive")
		local revtime = hasrevive and 2 or 4
		local w, h = ScrW(), ScrH()
		local scale = (w/1920 + 1)/2

		if nzRevive.Players[id] and nzRevive.Players[id].RevivePlayer == ply then
			local revivescale = math.Clamp((CurTime() - nzRevive.Players[id].ReviveTime) / revtime, 0, 1)

			surface.SetDrawColor(color_black_180)
			surface.DrawRect(w/2 - 150*scale, h - 400*scale, 300*scale, 20*scale)

			surface.SetDrawColor(color_white)
			if hasrevive then
				surface.SetDrawColor(color_revive)
			end
			surface.DrawRect(w/2 - 145*scale, h - 395*scale, 290*revivescale*scale, 10*scale)
		end
	end
end

-- Hooks
hook.Add("HUDPaint", "nzHUDreviveswap_t5", function()
	if nzMapping.Settings.hudtype == "Black Ops 1" then
		hook.Add("HUDPaint", "DrawDownedPlayers", DrawDownedPlayers_t5 )
		hook.Add("HUDPaint", "DrawRevivalProgress", DrawRevivalProgress_t5 )
	end
end)
