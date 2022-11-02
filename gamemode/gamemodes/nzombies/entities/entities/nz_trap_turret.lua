-- Fixed and recoded by Ethorbit

AddCSLuaFile( )

-- Register teh trap
nzTraps:Register("nz_trap_turret")

ENT.Author = "Ethorbit"
ENT.PrintName = "Turret"
ENT.SpawnIcon = "models/nzr/2022/traps/autoturret.mdl"
ENT.Description = "Auto Turret that shoots enemies around it."

ENT.Type = "anim"
ENT.Base = "nz_trapbase"

ENT.NZEntity = true

DEFINE_BASECLASS("nz_trapbase")

function ENT:SetupDataTables()
	BaseClass.SetupDataTables(self)
	
	self:NetworkVar( "Int", 2, "AttackRange", {KeyName = "nz_turret_attack_range", Edit = {order = 10, type = "Int", min = 0, max = 100000}} )
	self:NetworkVar( "Int", 3, "HitsToKill", {KeyName = "nz_turret_damage", Edit = {title="Hits to Kill", order = 11, type = "Int", min = 1, max = 1000}} )
	self:NetworkVar("Float", 9, "BulletSpread", {KeyName = "nz_turret_spread", Edit = {title="Min Turret Delay", order = 12, type = "Float", min = 0.0, max = 1000.0}} )
	self:NetworkVar("Float", 10, "TurretDelayMin", {KeyName = "nz_turret_min_delay", Edit = {title="Min Turret Delay", order = 13, type = "Float", min = 0.0, max = 1000.0}})
	self:NetworkVar("Float", 11, "TurretDelayMax", {KeyName = "nz_turret_max_delay", Edit = {title="Max Turret Delay", order = 14, type = "Float", min = 0.0, max = 1000.0}})
	self:NetworkVar("Float", 12, "LastTargetLock")
	self:NetworkVar("Float", 13, "NextShoot")
	self:NetworkVar( "Bool", 7, "TargetVisible")

	self:SetAttackRange(1200)
	self:SetHitsToKill(1)
	self:SetBulletSpread(0.1)
	self:SetTurretDelayMin(0.1)
	self:SetTurretDelayMax(0.1)	
end

function ENT:Initialize()
	self:SetModel( "models/nzr/2022/traps/autoturret.mdl" )
	self:SetModelScale(1.5)
	self.fLastTargetCheck = CurTime()
	self.fNextFire = CurTime()
	self:TurnOffGun()
end


function ENT:TurnOffGun()
	if CLIENT then
		self:ResetSequence(0)
		self:ManipulateBoneAngles(3, Angle(-45,0,0))	
		self.GunOff = true
	end
end	

function ENT:IsGunOff()
	return self.GunOff
end

function ENT:ResetGun()
	self:ManipulateBoneAngles(3, Angle(0,0,0))	
	self.GunOff = false
end

function ENT:OnActivation()
	self:SetTargetVisible(false)
	self:SetLastTargetLock(0)
end

function ENT:OnDeactivation()
	self:TurnOffGun()
end

function ENT:OnPoweredOff() 
	self:TurnOffGun()
end

function ENT:OnReady() 
	self:TurnOffGun()
end

function ENT:OnRemove() end

function ENT:StartScanning() -- It's scanning/waiting for an enemy
	self.bIsScanning = true

	if CLIENT then	
		self:ResetGun()	
	end
end

function ENT:StopScanning()
	self.bIsScanning = false
end

function ENT:IsScanning()
	return self.bIsScanning
end

function ENT:GetGunPos()
	return self:GetBonePosition(3)
end

function ENT:GetTargetPos()
	if (!IsValid(self:GetTarget())) then return Vector(0,0,0) end

	local targettorsopos = self:GetTarget():GetBonePosition(2, 0) 
	return targettorsopos and targettorsopos or self:GetTarget():WorldSpaceCenter()
end

function ENT:GetGunAngle()
	return (self:GetTargetPos() - self:GetGunPos()):Angle()
end

function ENT:GetDamage()
	if (self:GetHitsToKill() > 1 and nzRound and isfunction(nzRound.GetNumber)) then
		local round = nzRound:GetNumber() > 0 and nzRound:GetNumber() or 1
		local health = nzCurves.GenerateHealthCurve(round)

		if (isnumber(health)) then
			return health / self:GetHitsToKill()
		end
	end

	return IsValid(self:GetTarget()) and self:GetTarget():Health() * 2 or 500
end

function ENT:Think()
	if not self:GetActive() then 
		self:TurnOffGun()

		if (self:IsScanning()) then
			self:StopScanning()
			self:ResetSequence(0)
		end
	return end

	if self.fLastTargetCheck + 0.5 < CurTime() and not self:HasValidTarget() then
		self:SetTarget(self:GetPriorityTarget())
	end

	if !self:HasValidTarget() then 
		if (CurTime() - self:GetLastTargetLock() > 1) then
			if !self:IsScanning() then
				self:StartScanning()
			end

			self:ResetSequence(1)
		end
		
		if SERVER and self:GetTargetVisible() then
			self:SetTargetVisible(false)
		end
	return end

	self:SetLastTargetLock(CurTime())
	self:ResetSequence(0)

	if (self:IsScanning()) then
		self:StopScanning()
	end

	if CLIENT then
		-- Machinegun rotation
		self:ManipulateBoneAngles(3, self:WorldToLocalAngles(self:GetGunAngle()))

		if self.fNextFire < CurTime()  then
			-- Bullet tracer (because the FireBullets tracer is actually dogshit and appears at the entity's position even when the bone position is passed..)
			if (!self.NextTracerEffect or (self.NextTracerEffect and CurTime() > self.NextTracerEffect)) then
				self.NextTracerEffect = CurTime() + 0.15

				local effectData = EffectData()
				effectData:SetEntity(self)
				effectData:SetOrigin(self:GetTargetPos())
				effectData:SetStart((self:GetGunPos()) + Vector(0,0,10))
				effectData:SetAngles(self:GetGunAngle())
				effectData:SetScale(5000)
				util.Effect("AR2Tracer", effectData, false)

				-- Muzzleflash
				local effectData = EffectData()
				effectData:SetEntity(self)
				effectData:SetOrigin((self:GetGunPos() + Vector(0,0,8)) + self:GetGunAngle():Forward() * 40)
				effectData:SetScale(0.3)
				util.Effect("MuzzleEffect", effectData)
			end
		end
	end

	if SERVER then
		if self.fNextFire < CurTime() then
			-- Kill the target
			local bullet = {
				Attacker = self,
				Damage = self:GetDamage(),
				Force = 3,
				Src = self:GetGunPos(),
				Dir = self:GetGunAngle():Forward(),
				Distance = self:GetAttackRange() * 2,
				Spread = Vector(self:GetBulletSpread(), self:GetBulletSpread(),0),
				Tracer = 99999
			}

			self:EmitSound("npc/sniper/sniper1.wav")
			self:FireBullets(bullet)

			self.fNextFire = CurTime() + math.Rand(self:GetTurretDelayMin(), self:GetTurretDelayMax())
		end
	end
end

function ENT:SetTarget( target )
	self.eTarget = target
end

function ENT:GetTarget()
	return self.eTarget
end

function ENT:HasValidTarget()
	return IsValid(self:GetTarget()) and self:GetTarget():IsValidZombie() and self:GetPos():Distance(self.eTarget:GetPos()) < self:GetAttackRange() and self.eTarget:Health() > 0 and self:GetEnemyVisible(self.eTarget)
end

function ENT:GetEnemyVisible(ent)
	if SERVER then
		local livedLongEnough = ent.GetLastSpawnTime == nil and true or (CurTime() - ent:GetLastSpawnTime() > 2)
		--local emerging = string.find( ent:GetSequenceName(ent:GetSequence()), "nz_emerge")
		local vis = ent:VisibleVec(self:GetGunPos()) and livedLongEnough
		self:SetTargetVisible(vis)
		return vis
	end
	
	if CLIENT then
		-- local tr = util.TraceLine({
		-- 	start = self:GetGunPos(),
		-- 	endpos = self:GetTargetPos(),
		-- 	filter = self,
		-- 	mask = MASK_VISIBLE_AND_NPCS 
		-- })
		
		return self:GetTargetVisible()
	end
end

--Targetfinding
function ENT:GetPriorityTarget()
	self.fLastTargetCheck = CurTime()

	local possibleTargets = ents.FindInSphere(self:GetPos(), self:GetAttackRange())

	local zombies = {}

	for _, ent in pairs(possibleTargets) do
		if ent:IsValidZombie() and self:GetEnemyVisible(ent) and ent:Health() > 0 then
			table.insert(zombies, ent)
		end
	end

	return zombies[math.floor(util.SharedRandom("TurretTarg" .. self:EntIndex(), 1, #zombies))]
end

local onColor = Color(255,0,0)
local colorMat = Material("nz/zlight")

function ENT:Draw()
	BaseClass.Draw(self)

	if (self:GetActive()) then 
		render.SetMaterial(colorMat)
		local upAmount = self:GetUp() * 23
		local backPos = self:GetPos() + upAmount - self:GetForward() * 10
		render.DrawSprite(backPos, 70, 70, onColor)
		local forwardPos = self:GetPos() + upAmount + self:GetForward() * 25
		render.DrawSprite(forwardPos, 90, 90, onColor)
		local leftPos = self:GetPos() + upAmount + (self:GetRight() * 18) + self:GetForward() * 9
		render.DrawSprite(leftPos, 70, 70, onColor)
		local rightPos = self:GetPos() + upAmount - (self:GetRight() * 18) + self:GetForward() * 9
		render.DrawSprite(rightPos, 70, 70, onColor)
	end
end