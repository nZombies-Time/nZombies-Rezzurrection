
local zmhud_filter_zombieblood = Material("materials/nz_moo/huds/t7/i_generic_filter_zombie_blood_d.png", "unlitgeneric smooth noclamp")
local zmhud_filter_zombieblood_2 = Material("materials/nz_moo/huds/t7/i_generic_filter_zombie_blood_c.png", "unlitgeneric smooth noclamp")
local blur_mat = Material("pp/bokehblur")

local zbtab = {
	["$pp_colour_addr"] = 0,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 1,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0
}

local function MyDrawBokehDOF(fac)
	render.UpdateScreenEffectTexture()
	render.UpdateFullScreenDepthTexture()
	blur_mat:SetTexture("$BASETEXTURE", render.GetScreenEffectTexture())
	blur_mat:SetTexture("$DEPTHTEXTURE", render.GetResolvedFullFrameDepth())
	blur_mat:SetFloat("$size", fac * 5)
	blur_mat:SetFloat("$focus", 1)
	blur_mat:SetFloat("$focusradius", 60*fac)
	render.SetMaterial(blur_mat)
	render.DrawScreenQuad()
end

local bloodtime = 0
local bloody = false
local function DrawColorModulation()
	local ply = LocalPlayer()
	if IsValid(ply:GetObserverTarget()) then ply = ply:GetObserverTarget() end

	if nzPowerUps:IsPlayerPowerupActive(ply, "zombieblood") then
		zbtab["$pp_colour_mulr"] = 1
		zbtab["$pp_colour_mulg"] = 0
		zbtab["$pp_colour_addr"] = 0.15
		zbtab["$pp_colour_addg"] = 0.1
		DrawColorModify(zbtab)
		if not bloody then
			bloody = true
			bloodtime = CurTime() + 0.6
		end
	elseif bloody then
		bloody = false
		bloodtime = CurTime() + 1.2
	end

	if bloodtime > CurTime() then
		local fac = math.Clamp((bloodtime - CurTime()) / 1, 0, 1)
		MyDrawBokehDOF(fac)
	end
end

local function CalcZombieBloodView(ply, pos, ang, fov, znear, zfar)
	if IsValid(ply:GetObserverTarget()) then ply = ply:GetObserverTarget() end
	if nzPowerUps:IsPlayerPowerupActive(ply, "zombieblood") then
		local fov = fov + 12
		return {origin = pos, angles = ang, fov = fov, znear = znear, zfar = zfar, drawviewer = false }
	end
end

local p1pos = 0
local p2pos = 0
local function DrawZombieBlood()
	local ply = LocalPlayer()
	if IsValid(ply:GetObserverTarget()) then ply = ply:GetObserverTarget() end

	if nzPowerUps:IsPlayerPowerupActive(ply, "zombieblood") then
		local w, h = ScrW(), ScrH()
		local scale = (w/1920 + 1)/2

		p1pos = p1pos + FrameTime()*0.1
		if p1pos > 1 then p1pos = 0 end

		surface.SetDrawColor(color_white)
		surface.SetMaterial(zmhud_filter_zombieblood)
		surface.DrawTexturedRectUV(0, 0, w, h, 0, 0+p1pos, 1, 1+p1pos)

		p2pos = p2pos + FrameTime()*0.4
		if p2pos > 1 then p2pos = 0 end

		surface.SetDrawColor(color_white)
		surface.SetMaterial(zmhud_filter_zombieblood_2)
		surface.DrawTexturedRectUV(0, 0, w, h, 0, 0+p2pos, 1, 1+p2pos)
	end
end

hook.Add("RenderScreenspaceEffects", "DrawZombieBloodMOD", DrawColorModulation )
hook.Add("CalcView", "CalcZombieBloodView", CalcZombieBloodView )
hook.Add("HUDPaint", "DrawZombieBlood", DrawZombieBlood)