
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

AddCSLuaFile()
ENT.Type = "anim"
ENT.PrintName = "Turned Logic"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Author = "DBot, FlamingFox"
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
local entMeta = FindMetaTable("Entity")

if SERVER then
	entMeta.AATTurned = function(self, duration, attacker)
		if duration == nil then
			duration = 0
		end
		if attacker == nil then
			attacker = self
		end

		if IsValid(self.perk_turned_logic) then
			self.perk_turned_logic:UpdateDuration(duration)
			return self.perk_turned_logic
		end

		self.perk_turned_logic = ents.Create("status_effect_pop_turned")
		self.perk_turned_logic:SetPos(self:EyePos())
		self.perk_turned_logic:SetParent(self)
		self.perk_turned_logic:SetOwner(self)
		self.perk_turned_logic:SetAttacker(attacker)

		self.perk_turned_logic:Spawn()
		self.perk_turned_logic:Activate()

		self.perk_turned_logic:SetOwner(self)
		self.perk_turned_logic:UpdateDuration(duration)
		self:SetNW2Entity("PERK.TurnedLogic", self.perk_turned_logic)
		return self.perk_turned_logic
	end

	hook.Add("OnZombieKilled", "PERK.TurnedLogic", function(self)
		if IsValid(self.perk_turned_logic) then
			return self.perk_turned_logic:Remove()
		end
	end)
end

entMeta.IsAATTurned = function(self)
	return IsValid(self:GetNW2Entity("PERK.TurnedLogic"))
end

ENT.UpdateTransmitState = function(self)
	return TRANSMIT_ALWAYS
end

ENT.SetupDataTables = function(self)
	self:NetworkVar("Entity", 0, "Attacker")
	self:NetworkVar("String", 0, "Name")
end

local function Draw3DText( pos, ang, scale, text, flipView )
	if ( flipView ) then
		-- Flip the angle 180 degrees around the UP axis
		ang:RotateAroundAxis( Vector( 0, 0, 1 ), 180 )
	end

	cam.Start3D2D( pos, ang, scale )
		-- Actually draw the text. Customize this to your liking.
		draw.DrawText( text, "ChatFont", 0, 0, Color( 40, 255, 0, 255 ), TEXT_ALIGN_CENTER )
	cam.End3D2D()
end

ENT.Draw = function(self)
	local text = self:GetName()

	local mins, maxs = self:GetModelBounds()
	local pos = self:WorldSpaceCenter() + self:GetUp()

	local ang = LocalPlayer():EyeAngles()
	ang = Angle(ang.x, ang.y, 0)
	ang:RotateAroundAxis(ang:Up(), -90)
	ang:RotateAroundAxis(ang:Forward(), 90)

	Draw3DText( pos, ang, 0.2, text, false )
	Draw3DText( pos, ang, 0.2, text, true )
end

ENT.Initialize = function(self)
	self:SetMaterial("null")
	self:DrawShadow(false)
	self:SetNotSolid(true)
	self:SetMoveType(MOVETYPE_NONE)
	
	local p = self:GetParent()

	if IsValid(p) then
		if p:IsValidZombie() then
			p:SetInvulnerable(true)
		end

		ParticleEffectAttach("bo3_aat_turned", PATTACH_ABSORIGIN_FOLLOW, p, 0)

		local names = {
			"Odious Individual", "Laby after Taco Bell", "Fucker.lua",
			"Turned", "Shitass", "Miscellaneous Intent", "The Imposter",
			"Zobie", "Creeper, aww man", "Herbin", "Category Five",
			"TheRelaxingEnd", "Zet0r"
		}
		self:SetName(names[math.random(#names)])

		if SERVER then
			p:SetTargetPriority(TARGET_PRIORITY_PLAYER)
		end
	end

	if CLIENT then return end

	if IsValid(p) and p:GetTarget():IsPlayer() then
		p:SetTarget(p)
		p.loco:SetDesiredSpeed(0)
		p.loco:SetAcceleration(0)
	end

	self.statusStart = CurTime()
	self.duration = 0.1
	self.statusEnd = self.statusStart + 0.1
end

ENT.UpdateDuration = function(self, newtime)
	if newtime == nil then
		newtime = 0
	end

	if self.statusEnd - CurTime() > newtime then return end

    self.duration = newtime
    self.statusEnd = CurTime() + newtime
end

ENT.Think = function(self)
	if CLIENT and DynamicLight then
		local dlight = DynamicLight(self:EntIndex(), false)
		if (dlight) then
			dlight.pos = self:GetPos()
			dlight.r = 50
			dlight.g = 255
			dlight.b = 10
			dlight.brightness = 2
			dlight.Decay = 1000
			dlight.Size = 64
			dlight.dietime = CurTime() + 1
		end
	end

	if CLIENT then return false end

	if self.statusEnd < CurTime() then
		self:Remove()
		return false
	end

	self:NextThink(CurTime())
	return true
end

ENT.InflictDamage = function(self, ent)
	local damage = DamageInfo()
	damage:SetDamage(54000)
	damage:SetAttacker(IsValid(self:GetAttacker()) and self:GetAttacker() or self)
	damage:SetInflictor(IsValid(ent) and ent or self)
	damage:SetDamageType(DMG_BLAST_SURFACE)

	for k, v in pairs(ents.FindInSphere(self:GetPos(), 512)) do
		if v:IsValidZombie() then
			damage:SetDamageForce(v:GetUp()*8000 + (v:GetPos() - self:GetPos()):GetNormalized()*10000)
			if SERVER then
				v:TakeDamageInfo(damage)
			end
		end
	end

	util.ScreenShake(self:GetPos(), 10, 255, 1.5, 600)

	ParticleEffect("grenade_explosion_01", self:WorldSpaceCenter(), Angle(0,0,0))

	self:EmitSound("Perk.Tortoise.Exp")
	self:EmitSound("Perk.Tortoise.Exp_Firey")
	self:EmitSound("Perk.Tortoise.Exp_Decay")

	local dmg = DamageInfo()
	dmg:SetDamageType(DMG_DIRECT)
	dmg:SetAttacker(ent)
	dmg:SetInflictor(ent)
	dmg:SetDamage(ent:Health() + 666)
	dmg:SetDamagePosition(ent:EyePos())
	dmg:SetDamageForce(self:GetUp()*-10000)

	if ent:IsNPC() then ent:SetSchedule(SCHED_ALERT_STAND) end
	ent:TakeDamageInfo(dmg)
	ent:Remove()
end

ENT.OnRemove = function(self)
	if IsValid(self:GetParent()) then
		self:GetParent():StopParticles()
		self:InflictDamage(self:GetParent())
	end
end
