
-- Copyright (c) 2018-2020 TFA Base Devs

-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

include("shared.lua")

local zmhud_icon_chuggaghost = Material("vgui/hud/minimap_icon_chugabud.png", "unlitgeneric smooth")
local name_drawdist = GetConVar("nz_hud_player_name_distance")

function ENT:Draw()
	self:DrawModel()

	local text = self.PrintName
	local pos = self:WorldSpaceCenter() + self:GetUp()*42

	local ply = LocalPlayer()
	local ang = ply:EyeAngles()
	ang = Angle(ang.x, ang.y, 0)
	ang:RotateAroundAxis(ang:Up(), -90)
	ang:RotateAroundAxis(ang:Forward(), 90)

	local range = name_drawdist:GetInt()
	local dist = ply:EyePos():Distance(pos)
	local fade = range*0.6

	local ratio = 1 - math.Clamp((dist - range + fade) / fade, 0, 1)

	cam.Start3D2D(pos, ang, 0.24)
		surface.SetMaterial(zmhud_icon_chuggaghost)
		surface.SetDrawColor(ColorAlpha(color_white, 255*ratio))
		surface.DrawTexturedRect(-16, -16, 32, 32)
	cam.End3D2D()
end

function ENT:GetNZTargetText()
	local ply = self:GetOwner()
	return ply:Nick().."'s - Chugga Bud"
end

function ENT:IsTranslucent()
	return true
end