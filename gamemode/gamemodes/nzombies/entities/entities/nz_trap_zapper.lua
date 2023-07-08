-- Fixed and recoded by Ethorbit

AddCSLuaFile( )

-- Register teh trap
nzTraps:Register("nz_trap_zapper")

ENT.Author = "Ethorbit"
ENT.PrintName = "Tesla Coil"
ENT.SpawnIcon = "models/nzprops/zapper_coil.mdl"
ENT.Description = "An Electro-Shock Defense that zaps its victims with high voltage."

ENT.Type = "anim"
ENT.Base = "nz_trapbase"

ENT.MatDebug = Material("cable/cable2")

ENT.ZapLoopingSound = "ambient/energy/electric_loop.wav"
ENT.ZapSounds = {}

ENT.ZapTargetCooldowns = {}

ENT.NZEntity = true

DEFINE_BASECLASS("nz_trapbase")

function ENT:SetupDataTables()
	BaseClass.SetupDataTables( self )

	self:NetworkVar( "Float", 2, "ZapDelayMin", {KeyName = "nz_zap_delay_min", Edit = {title = "Min Zap Delay", order = 20, type = "Float", min = 0, max = 100000}} )
	self:NetworkVar( "Float", 3, "ZapDelayMax", {KeyName = "nz_zap_delay_max", Edit = {title = "Max Zap Delay", order = 21, type = "Float", min = 0, max = 100000}} )
	self:NetworkVar( "Float", 4, "NextZap" )
	self:NetworkVar( "Float", 5, "ZombieDeathDelayMin", {KeyName = "nz_zap_zmb_kill_delay_min", Edit = {title = "Min Zombie Death Delay", order = 22, type = "Float", min = 0, max = 100000}} )
	self:NetworkVar( "Float", 6, "ZombieDeathDelayMax", {KeyName = "nz_zap_zmb_kill_delay_max", Edit = {title = "Max Zombie Death Delay", order = 23, type = "Float", min = 0, max = 100000}} )
	self:NetworkVar( "Float", 7, "PlayerDamageDelay", {KeyName = "nz_zap_player_dmg_delay", Edit = {title = "Player Damage Delay", order = 25, type = "Float", min = 0, max = 100000}} )
	self:NetworkVar( "Int", 8, "PlayerDamage", {KeyName = "nz_zap_player_dmg", Edit = {title = "Player Damage", order = 24, type = "Int", min = 0, max = 100000}} )

	self:SetZapDelayMin(0.0) -- Min usually 0.5 and max 1.0, but then sometimes zombies can get through, so I'm forcing them to 0.0 
	self:SetZapDelayMax(0.0) 
	self:SetZombieDeathDelayMin(0.3) 
	self:SetZombieDeathDelayMax(1.0)
	self:SetPlayerDamage(95)
	self:SetPlayerDamageDelay(0.5)
end

function ENT:Initialize()
	self:SetModelScale(1.2)

	if SERVER then
		self:SetModel("models/nzprops/zapper_coil.mdl")
		self:DrawShadow( false )
	end

	self.ZapSounds = {}
	local function addTheSound(num)
		self.ZapSounds[#self.ZapSounds + 1] = "ambient/energy/zap" .. num .. ".wav"
	end

	for i = 1,3 do addTheSound(i) end
	for i = 5,9 do addTheSound(i) end
end

-- IMPLEMENT ME
function ENT:OnActivation()
	if SERVER then 
		self.SoundPlayer = CreateSound(self, self.ZapLoopingSound)
	end
	
	self.NextElectricEffect = nil
	self.NextZapSound = nil

	if (self:GetZapDelayMin() < 0.5) then
		self:StartElectricSounds()
	end
	
	if SERVER then
		self:SetNextZap(CurTime() + math.Rand(self:GetZapDelayMin(), self:GetZapDelayMax()))
	end
end

function ENT:OnDeactivation()
	self:StopElectricSounds()
end

function ENT:OnRemove()
	self:StopElectricSounds()
end

function ENT:StartElectricSounds()	
	if (self.SoundPlayer) then
		if (self.SoundPlayer:IsPlaying()) then return end
		self.SoundPlayer:Play()
	end
end

function ENT:OnReady() 
	self:StopElectricSounds()
end

function ENT:OnPoweredOff() 
	self:StopElectricSounds()
end

function ENT:StopElectricSounds()
	if (self.SoundPlayer) then
		self.SoundPlayer:Stop()
	end
end

--function ENT:Think()
	-- if SERVER and self:IsActive() and self:GetNextZap() < CurTime() then
	-- 	self:Zap()
	-- end

	-- return false
--end

-- ENTITY:Think can surprisingly be too slow for the line trace shit, yay!! less performance! :D
hook.Add("Tick", "TrapZapperTick", function()
	for _,v in pairs(ents.FindByClass("nz_trap_zapper")) do
		if (v:IsActive() and CurTime() > v:GetNextZap()) then
			v:Zap()
		end
	end
end)

if CLIENT then
	function ENT:Draw()
		BaseClass.Draw(self)

		if ConVarExists("nz_creative_preview") and !GetConVar("nz_creative_preview"):GetBool() and nzRound:InState( ROUND_CREATE ) then		
			local texcoord = math.Rand( 0, 1 )
			render.SetMaterial(self.MatDebug)
			render.DrawBeam(self:GetPos() + self:GetUp() * 10, self:GetPos() + self:GetUp() * 70, 1, texcoord, texcoord + 1, Color( 250, 150, 106 ))
		end
	end
end

function ENT:AddTargetToCooldown(ent)
	if (IsValid(ent) and ent:IsPlayer()) then 
		ent.NextAllowedZapByTraps = CurTime() + 0.3 -- Just prevent the traps from overlapping the damage
		self.ZapTargetCooldowns[ent] = CurTime() + self:GetPlayerDamageDelay()
	end
end

function ENT:TargetOnCooldown(ent)
	return (self.ZapTargetCooldowns[ent] and CurTime() < self.ZapTargetCooldowns[ent]) or (ent.NextAllowedZapByTraps and CurTime() < ent.NextAllowedZapByTraps)
end

function ENT:ZapTrace()
	return util.QuickTrace(self:GetPos() + self:GetUp() * 20, self:GetUp() * 500, self) 
end

function ENT:ZapInRadius() -- Called by ENT:Zap(), so just use that
	local tr = self:ZapTrace()

	for _,v in pairs(ents.FindInBox(self:GetPos() - Vector(5,5,5), tr.HitPos + Vector(5,5,5))) do
		if (IsValid(v)) then
			if (v:IsPlayer()) then
				self:ZapTarget(v)
			end
			
			if (v:IsValidZombie() and !v.NZTrapped) then
				v.NZTrapped = true
				self:ZapTarget(v, math.random(self:GetZombieDeathDelayMin(), self:GetZombieDeathDelayMax()))
			end
		end
	end	
end

function ENT:Zap(ent) -- This is the function that can eat performance because normal line traces are dog shit and too slow, yay Garry yay!!!! :D 
	local tr = self:ZapTrace()
	local ent = tr.Entity
	local randomTime = math.Rand(self:GetZapDelayMin(), self:GetZapDelayMax())
	self:SetNextZap(CurTime() + randomTime)

	if SERVER then
		if (randomTime >= 0.2) then
			timer.Create("ZappingTrap" .. self:EntIndex(), 0.1, math.Clamp(randomTime / 0.15, 0, 999999), function()
				self:ZapInRadius()
			end)
		else
			self:ZapInRadius()
		end

		-- Sounds
		if (self:GetZapDelayMax() > 0.4) then
			self:StartElectricSounds()
			timer.Simple(0.4, function()
				if (IsValid(self)) then
					self:StopElectricSounds()
				end
			end)
		else
			self:StartElectricSounds()
		end

		-- FX
		if (randomTime > 0.5 or (!self.NextElectricEffect or CurTime() > self.NextElectricEffect)) then
			self.NextElectricEffect = CurTime() + 0.5
			-- render effect
			effectData = EffectData()
			-- startpos
			effectData:SetStart(self:GetPos() + self:GetUp() * 10)
			-- end pos
			effectData:SetOrigin(tr.HitPos)
			-- duration
			effectData:SetMagnitude(0.5)

			util.Effect("zapper_lightning", effectData, true, true)
		end
	end
end

function ENT:TargetIsPlayer(ent)
	return IsValid(ent) and ent:IsPlayer() and ent:GetNotDowned() and (!ent:IsSpectating() or ent:IsInCreative()) and !self:TargetOnCooldown(ent) 
end

function ENT:TargetIsZombie(ent)
	return IsValid(ent) and ent:IsValidZombie() and ent:Health() > 0
end

function ENT:ZapTarget(ent, delay)
	if IsValid(ent) then
		if (ent.NZBossType) then return end -- Bosses shouldn't die from traps!

		-- Play a zap sound
		if ((self:TargetIsPlayer(ent) or self:TargetIsZombie(ent)) and (!self.NextZapSound or CurTime() > self.NextZapSound)) then	
			ent:EmitSound(self.ZapSounds[math.random(#self.ZapSounds)])
			self.NextZapSound = CurTime() + 0.5
		end

		local time = !delay and 0 or delay
		timer.Simple(time, function()
			if (self:TargetIsPlayer(ent)) then
				self:AddTargetToCooldown(ent)
				
				local dmg = DamageInfo()
				dmg:SetDamage(self:GetPlayerDamage())
				dmg:SetDamageType(DMG_SHOCK)
				dmg:SetAttacker(Entity(0))
				ent:TakeDamageInfo(dmg)
			end
	
			if (self:TargetIsZombie(ent)) then
				local dmg = DamageInfo()
				dmg:SetAttacker(Entity(0))
				dmg:SetDamageType(DMG_SHOCK)
				dmg:SetDamage(ent:Health() + 666)
				ent:TakeDamageInfo(dmg)
			end
		end)
	end
end