AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "drop_tombstone"
ENT.Spawnable = false

ENT.Author = "Moo, Fox, Jen"
ENT.Contact = "dont"

ENT.OwnerData = {}
ENT.NextDraw = 0

ENT.Delay = 180
ENT.BlinkDelay = 30

ENT.pmpath = Material("nz_moo/icons/statmon_warning_scripterrors.png", "unlitgeneric smooth")
ENT.nickcage = Material("models/nzr/2023/powerups/tombstone/ugxm_nicky_cage_c.png", "unlitgeneric smooth")

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Activated")
	self:NetworkVar("Bool", 1, "Blinking")
	self:NetworkVar("Bool", 2, "Funny")

	self:NetworkVar("Float", 1, "BlinkTime")
	self:NetworkVar("Float", 2, "KillTime")
end

local color_black_180 = Color(0, 0, 0, 180)
local zmhud_icon_missing = Material("nz_moo/icons/statmon_warning_scripterrors.png", "unlitgeneric smooth")

local function Draw3DText( pos, ang, scale, flipView, icon, name )
	if ( flipView ) then
		ang:RotateAroundAxis( vector_up, 180 )
	end
	if not icon or icon:IsError() then
		icon = zmhud_icon_missing
	end

	cam.Start3D2D(pos, ang, scale)
		surface.SetMaterial(icon)
		surface.SetDrawColor(color_white)
		surface.DrawTexturedRect(-16, -16, 48,48)

		draw.SimpleTextOutlined(name, "nz.points."..GetFontType(nzMapping.Settings.smallfont), 8, 42, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black_180)
	cam.End3D2D()
end

function ENT:Draw()
	local perkply = self:GetOwner()
	self.pmpath = Material("spawnicons/"..string.gsub(perkply:GetModel(),".mdl",".png"), "unlitgeneric smooth")

	local pos = self:GetPos() + self:GetUp()*42
	local ang = LocalPlayer():EyeAngles()

	ang = Angle(ang.x, ang.y, 0)
	ang:RotateAroundAxis(ang:Up(), -90)
	ang:RotateAroundAxis(ang:Forward(), 90)

	Draw3DText( pos, ang, 0.2, false, self:GetFunny() and self.nickcage or self.pmpath, perkply:Nick())
	Draw3DText( pos, ang, 0.2, true, self:GetFunny() and self.nickcage or self.pmpath, perkply:Nick())

	self:DrawModel()
end

function ENT:Initialize()
	self:SetModel("models/nzr/2023/powerups/ch_tombstone1.mdl")

	self:PhysicsInitSphere(60, "default_silent")
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	self:UseTriggerBounds(true, 30)

	-- Move up from ground
	local tr = util.TraceLine({
		start = self:GetPos(),
		endpos = self:GetPos() - Vector(0,0,24),
		filter = self,
		mask = MASK_SOLID_BRUSHONLY,
	})

	if tr.Hit then
		self:SetPos(tr.HitPos + Vector(0,0,24))
	end

	ParticleEffectAttach("nz_powerup_purple", PATTACH_POINT_FOLLOW, self, 1)

	self:SetActivated(false)
	self:SetBlinking(false)

	if self:GetFunny() then
		self:SetMaterial("models/nzr/2023/powerups/tombstone/nick_cage_tombstone")
	else
		self:SetMaterial("models/weapons/powerups/mtl_x2icon_gold")
	end

	self:EmitSound("nz_moo/powerups/powerup_spawn_zhd_"..math.random(1,3)..".mp3", 75)
	self:EmitSound("nz_moo/powerups/powerup_lp_zhd.wav", 75, 100, 0.5, 3)

	if CLIENT then return end
	self:SetTrigger(true)
	self:SetUseType(SIMPLE_USE)
end

function ENT:StartTouch(ply)
	if CLIENT then return end
	if IsValid(ply) and ply:IsPlayer() and ply == self:GetOwner() and ply:GetNotDowned() then
		ply:StripWeapons()

		for _, gun in pairs(self.OwnerData.weps) do
			local wep = ply:Give(gun.class)
			timer.Simple(0, function()
				if not (IsValid(ply) and IsValid(wep)) then return end

				if gun.pap then
					wep:ApplyNZModifier("pap")
				end
				if ply:HasPerk("staminup") then
					wep:ApplyNZModifier("staminup")
				end
				if ply:HasPerk("deadshot") then
					wep:ApplyNZModifier("deadshot")
				end
				if ply:HasPerk("dtap2") then
					wep:ApplyNZModifier("dtap2")
				end
				if ply:HasPerk("dtap") then
					wep:ApplyNZModifier("dtap")
				end
				if ply:HasPerk("vigor") then
					wep:ApplyNZModifier("vigor")
				end
			end)
		end

		for _, perk in pairs(self.OwnerData.perks) do
			if perk == "tombstone" then continue end
			ply:GivePerk(perk)
		end

		for _, mod in pairs(self.OwnerData.upgrades) do
			if mod == "tombstone" then continue end
			ply:GiveUpgrade(mod)
		end

		ply:GiveMaxAmmo()

		self:Remove()
	end
end

function ENT:Think()
	if CLIENT then
		if !self:GetRenderAngles() then self:SetRenderAngles(self:GetAngles()) end
		self:SetRenderAngles(self:GetRenderAngles() + Angle(0,50,0)*math.sin(CurTime()/10)*FrameTime())

		if !self:GetRenderOrigin() then self:SetRenderOrigin(self:GetPos()) end
		self:SetRenderOrigin(self:GetRenderOrigin() + Vector(0,0,4)*math.sin(CurTime()*2)*FrameTime())
		return
	end

	local ply = self:GetOwner()
	if not IsValid(ply) then
		self:Remove()
		return false
	end

	if not self:GetActivated() then
		if ply:Alive() and ply:GetNotDowned() and (ply:IsPlayer() or ply:IsInCreative()) then
			self:SetBlinkTime(CurTime() + (self.Delay - self.BlinkDelay))
			self:SetKillTime(CurTime() + self.Delay)
			self:SetActivated(true)

			ply:ChatPrint('Tombstone activated, you have '..self.Delay..' seconds to grab your shit')
		end
	elseif self:GetActivated() then
		if (not ply:GetNotDowned() or not ply:Alive()) and (self:GetKillTime() - CurTime()) >= self.BlinkDelay then
			if not self.Fuckerdown then
				ply:ChatPrint('Tombstone: Player downed or killed, pausing timer')
				self.DownedAt = CurTime()
				self.Fuckerdown = self:GetKillTime() - CurTime()
			end
			self:SetKillTime(CurTime() + self.Fuckerdown)
			self:SetBlinkTime(CurTime() + (self.Fuckerdown - self.BlinkDelay))
		elseif self.Fuckerdown then
			ply:ChatPrint('Tombstone: Paused at '..math.Round(self.Fuckerdown, 2)..' second left, for '..math.Round(CurTime() - self.DownedAt, 2)..' seconds')

			self.DownedAt = nil
			self.Fuckerdown = nil
		end

		if self:GetKillTime() > 0 and self:GetKillTime() < CurTime() then
			self:Remove()
			return false
		end
	end

	if self:GetActivated() and self:GetBlinking() and self.NextDraw < CurTime() then
		local time = self:GetKillTime() - self:GetBlinkTime()
		local final = math.Clamp(self:GetKillTime() - CurTime(), 0.1, 1)
		final = math.Clamp(final / time, 0.1, 1)

		self:SetNoDraw(not self:GetNoDraw())
		self.NextDraw = CurTime() + math.Clamp(1 * final, 0.1, 1)

		if not self:GetNoDraw() then
			ParticleEffectAttach("nz_powerup_purple", PATTACH_POINT_FOLLOW, self, 1)
		end
	end

	if self:GetActivated() and not self:GetBlinking() and self:GetBlinkTime() < CurTime() then
		self:SetBlinking(true)
	end

	self:NextThink(CurTime())
	return true
end

function ENT:OnRemove()
	self:StopSound("nz_moo/powerups/powerup_intro_lp.wav")
	self:StopSound("nz_moo/powerups/powerup_lp_zhd.wav")
end