
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

--[Info]--
ENT.Type = "anim"
ENT.PrintName = "Firework"
ENT.Spawnable = false

--[Parameters]--
ENT.RPM = 400
ENT.ClipSize = 20
ENT.MuzzleAttach = 1
ENT.Kills = 0
ENT.MaxKills = 24

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Activated")

	self:NetworkVar("Int", 0, "Clip1")
	self:NetworkVar("Int", 1, "RPM")

	self:NetworkVar("Int", 2, "CurrentWeaponProficiency")
	self:NetworkVar("Int", 3, "AmmoCount")

	self:NetworkVar("Vector", 0, "AimVector")
	self:NetworkVar("Vector", 1, "ShootPos")

	self:NetworkVar("Float", 0, "NextPrimaryFire")

	self:NetworkVar("Entity", 0, "ActiveWeapon")
	self:NetworkVar("Entity", 1, "Attacker")
	self:NetworkVar("Entity", 2, "Inflictor")
end

function ENT:Initialize()
	if SERVER then
		SafeRemoveEntityDelayed(self, 40)
	end

	self:SetParent(nil)

	self:SetModel("models/weapons/tfa_bo3/qed/w_kn44.mdl")

	self:SetRPM(self.RPM)
	self:SetClip1(self.ClipSize)
	self:SetCurrentWeaponProficiency(WEAPON_PROFICIENCY_PERFECT)
	self:SetAimVector(self:GetForward())
	self:SetShootPos(self:GetPos())
	self:SetAmmoCount(self.ClipSize)

	local attacker = self:GetAttacker()
	local inflictor = self:GetInflictor()

	if IsValid(inflictor) and inflictor.IsTFAWeapon then
		if SERVER then
			if inflictor:GetClass() == "tfa_bo3_vr11" then return self:Remove() end
		end

		self:SetModel(inflictor.WorldModel)
		self:SetRPM(math.Clamp(inflictor.Primary.RPM, self.RPM, 1200))
		self:SetClip1(math.Clamp(inflictor.Primary.ClipSize, self.ClipSize, 100))
		self:SetAmmoCount(self:GetClip1())
		self:SetShootPos(inflictor.GetMuzzlePos and inflictor:GetMuzzlePos().Pos or inflictor:GetPos())
	end

	ParticleEffectAttach("bo3_aat_fireworks", PATTACH_ABSORIGIN, self, 0)

	self:DrawShadow(true)
	self:SetNoDraw(true)
	self:PhysicsInit(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)

	self.TargetsToIgnore = {}
	self.Ratio = engine.TickInterval()*5
	self.FinalPos = self:GetPos() + Vector(0,0,36)
	self.ActivateTime = CurTime() + 0.5
	self.WhistleDelay = CurTime()
	self.ExplodeDelay = CurTime()

	if CLIENT then return end

	local tickrate = 1 / engine.TickInterval()
	local time = (tickrate / self:GetRPM()) * self:GetClip1()
	SafeRemoveEntityDelayed(self, time + 0.5)

	if IsValid(attacker) and IsValid(inflictor) and inflictor.IsTFAWeapon and not inflictor.NZSpecialCategory then
		local round = nzRound:GetNumber() > 0 and nzRound:GetNumber() or 1
		local health = nzCurves.GenerateHealthCurve(round)

		local weapon = ents.Create(inflictor:GetClass())
		weapon:Spawn()

		weapon.StatCache_Blacklist["PumpAction"] = true
		weapon.StatCache_Blacklist["Primary.Damage"] = true
		weapon.StatCache_Blacklist["Primary.RPM"] = true
		weapon.StatCache_Blacklist["Primary.ClipSize"] = true

		weapon.PumpAction = nil
		weapon.Primary_TFA.Damage = health + 666
		weapon.Primary_TFA.RPM = self:GetRPM()
		weapon.Primary_TFA.ClipSize = self:GetClip1()
		weapon:SetClip1(weapon.Primary_TFA.ClipSize)

		weapon:SetMoveType(MOVETYPE_NONE)
		weapon:SetOwner(self)
		weapon:SetParent(self)
		weapon:AddEffects(EF_BONEMERGE)

		local oldbullet = weapon.CustomBulletCallback
		weapon.CustomBulletCallback = function(ply, trace, dmginfo)
			dmginfo:SetAttacker(attacker)
			dmginfo:SetInflictor(inflictor)
			if oldbullet then
				oldbullet(ply, trace, dmginfo)
			end
		end

		local oldpre = weapon.PreSpawnProjectile
		if oldpre then
			weapon.PreSpawnProjectile = function(self, ent)
				oldpre(self, ent)
				ent:SetOwner(attacker)
				ent.Inflictor = inflictor
			end
		end

		local oldpost = weapon.PostSpawnProjectile
		if oldpost then
			weapon.PostSpawnProjectile = function(self, ent)
				oldpost(self, ent)
				ent:SetOwner(attacker)
				ent.Inflictor = inflictor
			end
		end

		self:SetActiveWeapon(weapon)

		hook.Add("PlayerCanPickupWeapon", "fireworks_gun"..self:EntIndex(), function(ply, wep)
			if not IsValid(ply) or not IsValid(self:GetActiveWeapon()) then return end
			if wep == self:GetActiveWeapon() then return false end
		end)
	end
end

function ENT:Think()
	if SERVER then
		if self:GetPos() ~= self.FinalPos then
			self:SetPos(LerpVector(self.Ratio, self:GetPos(), self.FinalPos))
		end

		if self.WhistleDelay < CurTime() then
			self:EmitSound("NZ.POP.Fireworks.Whistle")
			self.WhistleDelay = CurTime() + math.Rand(0.4,0.8)
		end

		if self.ExplodeDelay < CurTime() then
			self:EmitSound("NZ.POP.Fireworks.Expl")
			self.ExplodeDelay = CurTime() + math.Rand(0.4,0.8)
		end

		local weapon = self:GetActiveWeapon()
		if self:GetActivated() and IsValid(weapon) then
			if weapon:GetNextPrimaryFire() < CurTime() and weapon:CanPrimaryAttack() then
				self:FakePrimaryAttack()
			end
		end

		if self.ActivateTime < CurTime() and not self:GetActivated() then
			self:SetActivated(true)
		end

		if self.Kills >= self.MaxKills then
			self:Remove()
			return false
		end
	end

	self:NextThink(CurTime())
	return true
end

function ENT:FakePrimaryAttack()
	local wep = self:GetActiveWeapon()
	if not IsValid(wep) then return end
	local shootpos = wep.GetMuzzlePos and wep:GetMuzzlePos().Pos or wep:GetPos()

	self:SetShootPos(shootpos)
	self:SetAimVector(self:GetForward())

	for k, v in pairs(ents.FindInSphere(shootpos, 200)) do
		if (v:IsNPC() or v:IsNextBot()) and v:Health() > 0 then
			if self.Kills >= self.MaxKills then break end
			if v.NZBossType then continue end
			if v.Alive and not v:Alive() then continue end
			if table.HasValue(self.TargetsToIgnore, v) then continue end

			self:InflictDamage(v)
			self.TargetsToIgnore[self.Kills] = v
			self.Kills = self.Kills + 1
			break
		end
	end

	//i literally have no idea why this works
	wep:PrimaryAttack()
	if SERVER then
		wep:CallOnClient("PrimaryAttack", "")
	end

	self:SetClip1(self:GetClip1() - wep.Primary_TFA.AmmoConsumption)
	self:SetAngles(Angle(math.random(-90,90),math.random(-90,90),math.random(-90,90)))
end

function ENT:InflictDamage(ent)
	local damage = DamageInfo()
	damage:SetDamageType(DMG_MISSILEDEFENSE)
	damage:SetAttacker(IsValid(self:GetOwner()) and self:GetOwner() or self)
	damage:SetInflictor(IsValid(self.Inflictor) and self.Inflictor or self)
	damage:SetDamageForce(self:GetForward()*50000)
	damage:SetDamagePosition(ent:WorldSpaceCenter())
	damage:SetDamage(ent:Health() + 666)

	if SERVER then
		ent:TakeDamageInfo(damage)
	end
end

function ENT:OnRemove()
	self:StopParticles()
	local wep = self:GetActiveWeapon()
	if SERVER and IsValid(wep) then
		wep:Remove()
		hook.Remove("PlayerCanPickupWeapon", "fireworks_gun"..self:EntIndex())
	end
end
