AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "drop_powerups"
ENT.Spawnable = false

ENT.Author = "Moo, Fox, Jen"
ENT.Contact = "dont"

game.AddParticles("particles/moo_powerup_fx.pcf")

--[[PrecacheParticleSystem("nz_powerup_purple") -- Not added yet
PrecacheParticleSystem("nz_powerup_global")
PrecacheParticleSystem("nz_powerup_local")
PrecacheParticleSystem("nz_powerup_anti")
PrecacheParticleSystem("nz_powerup_mini")]]

ENT.NextDraw = 0

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "PowerUp")

	self:NetworkVar("Bool", 0, "Activated")
	self:NetworkVar("Bool", 1, "Blinking")

	self:NetworkVar("Float", 0, "ActivateTime")
	self:NetworkVar("Float", 1, "BlinkTime")
	self:NetworkVar("Float", 2, "KillTime")
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:Initialize()
	if SERVER then
		SafeRemoveEntityDelayed(self, 30)
	end

	local pdata = nzPowerUps:Get(self:GetPowerUp())
	self:SetModelScale(pdata.scale, 0)
	self:PhysicsInitSphere(60, "default_silent")
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	self:UseTriggerBounds(true, 1)

	if nzPowerUps:Get(self:GetPowerUp()).global then
		timer.Simple(0, function() if IsValid(self) then ParticleEffectAttach("bo3_qed_powerup", 1, self, 0) end end)
	else -- This uses the new Powerup FX that were done not too long ago... But now Non-Global Powerups have a Blue Aura rather than the normal green one.
		timer.Simple(0, function() if IsValid(self) then ParticleEffectAttach("bo3_qed_powerup_local", 1, self, 0) end end)
	end

	self:EmitSound("nz_moo/powerups/powerup_intro_start.mp3")
	self:EmitSound("nz_moo/powerups/powerup_intro_lp.wav",100, 100, 1, 2)
	self:EmitSound("nz_moo/powerups/powerup_lp_zhd.wav",75, 100, 1, 3)

	self:SetMaterial("null")

	local distfac = 0.1
	local nearest = self:FindNearestPlayer(self:GetPos())
	if IsValid(nearest) then
		local dist = math.Clamp(self:GetPos():Distance(nearest:GetPos()), 0, 256)
		distfac = 1 - math.Clamp(dist / 256, 0, 1)
	end

	self:SetActivateTime(CurTime() + (4.5 * distfac))
	self:SetBlinkTime(CurTime() + 25)
	self:SetKillTime(CurTime() + 30)

	self:SetActivated(false)
	self:SetBlinking(false)

	if CLIENT then return end

	if IsValid(nearest) then
		local size = Vector(2, 2, 2)
		local entpos = nearest:WorldSpaceCenter()
		local pos = self:WorldSpaceCenter()

		local tr = util.TraceLine({
			start = pos,
			endpos = entpos,
			filter = {self, nearest},
			mask = MASK_SOLID_BRUSHONLY
		})

		if tr.HitWorld then //Check 1, trace to player, if hits wall, check in sphere for barricads to place infront of
			local barricade = self:FindNearestBarricade(self:GetPos())
			if IsValid(barricade) then
				local normal = (nearest:GetPos() - barricade:GetPos()):GetNormalized()
				local fwd = barricade:GetForward()
				local dot = fwd:Dot(normal)
				if 0 < dot then
					self:SetPos(barricade:WorldSpaceCenter() + fwd*50)
				else
					self:SetPos(barricade:WorldSpaceCenter() + fwd*-50)
				end
			end
		end

		for k, v in pairs(ents.FindAlongRay(pos, entpos, -size, size)) do
			if v:GetClass() == "breakable_entry" then //Check 2, raycast to player, if hit barricade, place infront of
				local normal = (nearest:GetPos() - v:GetPos()):GetNormalized()
				local fwd = v:GetForward()
				local dot = fwd:Dot(normal)

				if 0 < dot then
					self:SetPos(v:WorldSpaceCenter() + fwd*50)
				else
					self:SetPos(v:WorldSpaceCenter() + fwd*-50)
				end
			end
		end
	end

	self:SetTrigger(true)
	self:SetUseType(SIMPLE_USE)
end

function ENT:FindNearestPlayer(pos)
	local nearbyents = {}
	for k, v in pairs(ents.FindInSphere(pos, 2048)) do
		if v:IsPlayer() then
			table.insert(nearbyents, v)
		end
	end

	table.sort(nearbyents, function(a, b) return a:GetPos():DistToSqr(self:GetPos()) < b:GetPos():DistToSqr(pos) end)
	return nearbyents[1]
end

function ENT:FindNearestBarricade(pos)
	local nearbyents = {}
	for k, v in pairs(ents.FindInSphere(pos, 2048)) do
		if v:GetClass() == "breakable_entry" then
			table.insert(nearbyents, v)
		end
	end

	table.sort(nearbyents, function(a, b) return a:GetPos():DistToSqr(self:GetPos()) < b:GetPos():DistToSqr(pos) end)
	return nearbyents[1]
end

function ENT:StartTouch(ent)
	if not IsValid(ent) then return end

	if self:GetActivated() and ent:IsPlayer() then
		nzPowerUps:Activate(self:GetPowerUp(), ent, self)

		local GLOBAL = nzPowerUps:Get(self:GetPowerUp()).global
		ent:EmitSound(nzPowerUps:Get(self:GetPowerUp()).collect or "nz_moo/powerups/powerup_pickup_zhd.mp3")

		self:Remove()
	end
end

local PUSH_STRENGTH = 5

local PUSH = {
	Vector(PUSH_STRENGTH, 0, 0), --horizontal
	Vector(0, PUSH_STRENGTH, 0), --vertical
	Vector(-PUSH_STRENGTH, PUSH_STRENGTH, 0), --diagonal (left)
	Vector(PUSH_STRENGTH, PUSH_STRENGTH, 0) --diagonal (right)
}

function ENT:Think()
	if CLIENT then
		if !self:GetRenderAngles() then self:SetRenderAngles(self:GetAngles()) end
		self:SetRenderAngles(self:GetRenderAngles() + Angle(2,50,5)*math.sin(CurTime()/10)*FrameTime())
	end

	if self:GetBlinking() and self.NextDraw < CurTime() then
		local time = self:GetKillTime() - self:GetBlinkTime()
		local final = math.Clamp(self:GetKillTime() - CurTime(), 0.1, 1)
		final = math.Clamp(final / time, 0.1, 1)

		self:SetNoDraw(not self:GetNoDraw())
		self.NextDraw = CurTime() + math.Clamp(1 * final, 0.1, 1)
	end

	if not self:GetActivated() and self:GetActivateTime() < CurTime() then
		self:SetMaterial("")
		self:EmitSound("nz_moo/powerups/powerup_spawn_zhd_"..math.random(1,3)..".mp3",100)
		self:StopSound("nz_moo/powerups/powerup_intro_lp.wav")
		self:SetActivated(true)
	end

	if not self:GetBlinking() and self:GetBlinkTime() < CurTime() then
		self:SetBlinking(true)
	end

	if SERVER then
		local pdata = nzPowerUps:Get(self:GetPowerUp())
		if not pdata.nopush then
			for k, v in pairs(ents.FindInSphere(self:GetPos(), pdata.pusharea or 10)) do --powerups are too close to each other!
				if v:GetClass() == "drop_powerup" and v ~= self then
					if not nzPowerUps:Get(v:GetPowerUp()).nopush then
						if v:EntIndex() < self:EntIndex() then
							if not self.pushdirection then self.pushdirection = math.random(4) end
							self:SetPos(self:GetPos() + (PUSH[self.pushdirection] / (pdata.pushdelta or 10)))
							v:SetPos(v:GetPos() - (PUSH[self.pushdirection] / (pdata.pushdelta or 10)))
						end
					end
				end
			end
		end
	end

	self:NextThink(CurTime())
	return true
end

function ENT:OnRemove()
	if IsValid(self) then
		self:StopSound("nz_moo/powerups/powerup_intro_lp.wav")
		self:StopSound("nz_moo/powerups/powerup_lp_zhd.wav")
	end
end
