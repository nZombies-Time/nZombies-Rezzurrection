AddCSLuaFile()

ENT.Type = "anim"
ENT.PrintName = "drop_powerups"
ENT.Spawnable = false

ENT.Author = "Moo, Fox, Jen"
ENT.Contact = "dont"

game.AddParticles("particles/moo_powerup_fx.pcf")

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
	self:DrawShadow(false)

	timer.Simple(0, function()
		if not IsValid(self) then return end
		ParticleEffectAttach(nzPowerUps:Get(self:GetPowerUp()).global and "nz_powerup_global_intro" or "nz_powerup_local_intro", 1, self, 0)
	end)

	self:EmitSound("nz_moo/powerups/powerup_intro_start.mp3")
	self:EmitSound("nz_moo/powerups/powerup_intro_lp.wav",100, 100, 1, 2)
	self:EmitSound("nz_moo/powerups/powerup_lp_zhd.wav",75, 100, 1, 3)

	self:SetMaterial("null")

	local distfac = 0.1
	local nearest = self:FindNearestPlayer(self:GetPos())
	if IsValid(nearest) then
		local dist = self:GetPos():DistToSqr(nearest:GetPos())
		distfac = 1 - math.Clamp(dist / 40000, 0, 1) //200^2
	end

	self:SetActivateTime(CurTime() + (3 * distfac))
	self:SetBlinkTime(CurTime() + 25)
	self:SetKillTime(CurTime() + 30)

	self:SetActivated(false)
	self:SetBlinking(false)

	if CLIENT then return end
	self:SetTrigger(true)
	self:SetUseType(SIMPLE_USE)
	if IsValid(nearest) then
		self:OOBTest(nearest)
	end
end

function ENT:OOBTest(ply)
	if CLIENT then return end
	if not IsValid(ply) then return end

	local size = Vector(2, 2, 2)
	local entpos = ply:WorldSpaceCenter()
	local pos = self:WorldSpaceCenter()

	local tr = util.TraceLine({
		start = pos,
		endpos = entpos,
		filter = {self, ply},
		mask = MASK_SOLID_BRUSHONLY
	})

	//Check 1, trace to player, if interrupted by world, teleport infront of a barricade closest to player
	if tr.HitWorld then
		local barricade = self:FindNearestBarricade(entpos)
		if barricade and IsValid(barricade) then
			//print('Powerup1, Trace to player blocked by world')
			local normal = (ply:GetPos() - barricade:GetPos()):GetNormalized()
			local fwd = barricade:GetForward()
			local dot = fwd:Dot(normal)
			if 0 < dot then
				self:SetPos(barricade:WorldSpaceCenter() + fwd*50)
			else
				self:SetPos(barricade:WorldSpaceCenter() + fwd*-50)
			end
			return
		end
	end

	//Check 2, raycast to player, if interrupted by a barricade, teleport infront of that barricade
	for k, v in pairs(ents.FindAlongRay(pos, entpos, -size, size)) do
		if v:GetClass() == "breakable_entry" then
			//print('Powerup2, Barricade blocking raycast to player')
			local normal = (ply:GetPos() - v:GetPos()):GetNormalized()
			local fwd = v:GetForward()
			local dot = fwd:Dot(normal)

			if 0 < dot then
				self:SetPos(v:WorldSpaceCenter() + fwd*50)
			else
				self:SetPos(v:WorldSpaceCenter() + fwd*-50)
			end
			return
		end
	end

	//Check 3, if theres a barricade next to us at all, place on side with player
	for k, v in pairs(ents.FindInSphere(pos, 60)) do
		if v:GetClass() == "breakable_entry" then
			//print('Powerup3, Barricade too close')
			local ply2 = self:FindNearestPlayer(v:GetPos())
			local normal = (self:GetPos() - v:GetPos()):GetNormalized()
			local normal2 = (ply2:GetPos() - v:GetPos()):GetNormalized()
			local fwd = v:GetForward()
			local dot = fwd:Dot(normal)
			local dot2 = fwd:Dot(normal2)

			if 0 < dot2 and dot > 0 then
				self:SetPos(v:WorldSpaceCenter() + fwd*50)
			elseif 0 > dot2 and dot < 0 then
				self:SetPos(v:WorldSpaceCenter() + fwd*-50)
			end
			return
		end
	end
end

function ENT:FindNearestPlayer(pos)
	if not pos then
		pos = self:GetPos()
	end

	local nearbyents = {}
	for k, v in pairs(player.GetAll()) do
		if v:Alive() then
			table.insert(nearbyents, v)
		end
	end

	if table.IsEmpty(nearbyents) then return end
	if #nearbyents > 1 then
		table.sort(nearbyents, function(a, b) return a:GetPos():DistToSqr(self:GetPos()) < b:GetPos():DistToSqr(pos) end)
	end
	return nearbyents[1]
end

function ENT:FindNearestBarricade(pos)
	if not pos then
		pos = self:GetPos()
	end

	local nearbyents = {}
	for k, v in pairs(ents.FindInSphere(pos, 2048)) do
		if v:GetClass() == "breakable_entry" then
			table.insert(nearbyents, v)
		end
	end

	if table.IsEmpty(nearbyents) then return end
	if #nearbyents > 1 then
		table.sort(nearbyents, function(a, b) return a:GetPos():DistToSqr(self:GetPos()) < b:GetPos():DistToSqr(pos) end)
	end
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

		if not self:GetNoDraw() then
			local global = nzPowerUps:Get(self:GetPowerUp()).global
			ParticleEffectAttach(global and "nz_powerup_global" or "nz_powerup_local", 1, self, 0)
		end
	end

	if not self:GetActivated() and self:GetActivateTime() < CurTime() then
		self:StopParticles()
		self:DrawShadow(true)

		local global = nzPowerUps:Get(self:GetPowerUp()).global
		local att = self:GetAttachment(1)
		ParticleEffect(global and "nz_powerup_global_poof" or "nz_powerup_local_poof", att and att.Pos or self:WorldSpaceCenter(), angle_zero)
		ParticleEffectAttach(global and "nz_powerup_global" or "nz_powerup_local", 1, self, 0)

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
			for k, v in pairs(ents.FindInSphere(self:GetPos(), pdata.pusharea or 12)) do --powerups are too close to each other!
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
		self:StopParticles()

		local global = nzPowerUps:Get(self:GetPowerUp()).global
		local att = self:GetAttachment(1)
		ParticleEffect(global and "nz_powerup_global_poof" or "nz_powerup_local_poof", att and att.Pos or self:WorldSpaceCenter(), angle_zero)

		self:StopSound("nz_moo/powerups/powerup_intro_lp.wav")
		self:StopSound("nz_moo/powerups/powerup_lp_zhd.wav")
	end
end
