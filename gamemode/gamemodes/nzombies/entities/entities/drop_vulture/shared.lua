AddCSLuaFile()

ENT.Type = "anim"

ENT.PrintName		= "drop_vulture"
ENT.Author			= "Zet0r"
ENT.Contact			= "Don't"
ENT.Purpose			= ""
ENT.Instructions	= ""

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "DropType")

	self:NetworkVar("Bool", 1, "Blinking")

	self:NetworkVar("Float", 0, "BlinkTime")
	self:NetworkVar("Float", 1, "KillTime")
end

local vulturedrops = {
	["points"] =  {
		id = "points",
		model = Model("models/powerups/w_vulture_points.mdl"),
		blink = true,
		effect = function(ply)
			ply:EmitSound("nz_moo/powerups/vulture/vulture_pickup.mp3") 
			ply:EmitSound("nz_moo/powerups/vulture/vulture_money.mp3") 
			ply:GivePoints(math.random(5, 20) * (ply:HasUpgrade("vulture") and 10 or 5))
			return true
		end,
		timer = 30,
		draw = function(self)
			self:DrawModel()
		end,
		initialize = function(self)
			ParticleEffectAttach("nz_powerup_mini", PATTACH_ABSORIGIN_FOLLOW, self, 0)
		end,
	},
	["ammo"] = {
		id = "ammo",
		model = Model("models/powerups/w_vulture_ammo.mdl"),
		blink = true,
		effect = function(ply)
			local wep = ply:GetActiveWeapon()
			if IsValid(wep) then
				local max = wep.Primary.MaxAmmo or nzWeps:CalculateMaxAmmo(wep:GetClass(), wep:HasNZModifier("pap"))
				local give = math.Round(max/math.random(10, 20))
				local ammo = wep:GetPrimaryAmmoType()
				local cur = ply:GetAmmoCount(ammo)

				if (cur + give) > max then give = max - cur end
				if give <= 0 then return end

				ply:GiveAmmo(give, ammo)
				ply:EmitSound("nz_moo/powerups/vulture/vulture_pickup.mp3")
				return true
			end
		end,
		timer = 30,
		draw = function(self)
			self:DrawModel()
		end,
		initialize = function(self)
			ParticleEffectAttach("nz_powerup_mini", PATTACH_ABSORIGIN_FOLLOW, self, 0)
		end,
	},
	["gas"] = {
		id = "gas",
		model = Model("models/dav0r/hoverball.mdl"),
		blink = false,
		effect = function(ply)
			ply:VulturesStink(0.5)
		end,
		timer = 12,
		draw = function(self)
			self:DrawModel()
		end,
		initialize = function(self)
			self:SetNoDraw(true)
			ParticleEffectAttach("nz_perks_vulture_stink", PATTACH_ABSORIGIN_FOLLOW, self, 0)
		end,
	},
}

function ENT:Draw()
	vulturedrops[self:GetDropType()].draw(self)
end

function ENT:Initialize()
	if SERVER then
		self:SetDropType(table.Random(vulturedrops).id)
	end

	self:SetModel(vulturedrops[self:GetDropType()].model)
	self:EmitSound("nz_moo/powerups/vulture/vulture_drop.mp3") 

	self:PhysicsInitSphere(60, "default_silent")
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	self:UseTriggerBounds(true, 1)

	self:SetMaterial("models/weapons/powerups/mtl_x2icon_gold")

	self:SetBlinkTime(CurTime() + vulturedrops[self:GetDropType()].timer - 5)
	self:SetKillTime(CurTime() + vulturedrops[self:GetDropType()].timer)
	self:SetBlinking(false)
	self.NextDraw = CurTime()

	vulturedrops[self:GetDropType()].initialize(self)

	if CLIENT then return end
	local nearest = self:FindNearestPlayer(self:GetPos())
	if IsValid(nearest) then
		self:OOBTest(nearest)
	end
	self:SetTrigger(true)
	self:SetUseType(SIMPLE_USE)
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
		if IsValid(barricade) then
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
	local fuck = false
	for _, ply in pairs(player.GetAll()) do
		if ply:HasUpgrade("vulture") then
			fuck = true
			break
		end
	end

	if IsValid(ent) and ent:IsPlayer() then
		if ent:HasPerk("vulture") or fuck then
			if vulturedrops[self:GetDropType()].effect(ent) then
				self:Remove()
			end
		end
	end
end

function ENT:Touch(ent)
	local fuck = false
	for _, ply in pairs(player.GetAll()) do
		if ply:HasUpgrade("vulture") then
			fuck = true
			break
		end
	end

	if IsValid(ent) and ent:IsPlayer() then
		if self:GetDropType() == "gas" and (ent:HasPerk("vulture") or fuck) then
			vulturedrops[self:GetDropType()].effect(ent)
		end
	end
end

function ENT:Think()
	if not self:GetBlinking() and self:GetBlinkTime() < CurTime() and vulturedrops[self:GetDropType()].blink then
		self:SetBlinking(true)
	end

	if self:GetBlinking() and self.NextDraw < CurTime() then
		local time = self:GetKillTime() - self:GetBlinkTime()
		local final = math.Clamp(self:GetKillTime() - CurTime(), 0.1, 1)
		final = math.Clamp(final / time, 0.1, 1)

		self:SetNoDraw(not self:GetNoDraw())
		self.NextDraw = CurTime() + math.Clamp(1 * final, 0.1, 1)
		if not self:GetNoDraw() then
			ParticleEffectAttach("nz_powerup_mini", PATTACH_ABSORIGIN_FOLLOW, self, 0)
		end
	end

	if SERVER then
		if self:GetKillTime() < CurTime() then
			self:StopParticles()
			self:Remove()
			return false
		end
	end

	self:NextThink(CurTime())
	return true
end

function ENT:OnRemove()
	if IsValid(self) then
		self:StopParticles()
		local att = self:GetAttachment(1)
		ParticleEffect("nz_powerup_mini_poof", att and att.Pos or self:WorldSpaceCenter(), angle_zero)
	end
end
