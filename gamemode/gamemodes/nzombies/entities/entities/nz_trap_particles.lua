-- New trap made by Ethorbit, using the trap template code 

AddCSLuaFile( )

-- Register trap
nzTraps:Register("nz_trap_particles")
ENT.Author = "Ethorbit"

ENT.Type = "anim"
ENT.Base = "nz_trapbase"

ENT.PrintName = "Particles"
ENT.SpawnIcon = "models/props_c17/pipe_cap005c.mdl"
ENT.Description = "Emits hazardous particles."

ENT.ParticleTargetCooldowns = {}

-- Model Presets
ENT.ModelTranslate = {
	"models/props_c17/pipe_cap005c.mdl",
	"models/props_canal/mattpipe.mdl",
	"models/props_c17/gaspipes001a.mdl",
	"models/props_lab/tpplug.mdl"
}

-- Particle Presets (no hurttype has no special damage FX)
ENT.ParticleEffects = {
	{name = "Fire", mat = "particles/fire1", hurttype = DMG_BURN},
	{name = "Smoke", mat = "particles/smokey"},
	{name = "Steam", mat = "effects/strider_bulge_dudv"},
	{name = "Plasma", mat = "sprites/plasmaember"},
	{name = "Plasma2", mat = "effects/bluelaser1"},
	{name = "Water", mat = "particle/water/waterdrop_001a"},
	{name = "Water2", mat = "effects/splash1"},
	{name = "Blood", mat = "effects/blood_core"},
	{name = "Balls", mat = "effects/slime1"},
	{name = "Bubbles", mat = "sprites/scanner_dots1"},
	{name = "Rings", mat = "particle/particle_ring_blur"}
}

-- Particle sound presets
ENT.ParticleSounds = {
	"ambient/gas/steam2.wav",
	"ambient/fire/fire_med_loop1.wav",
	"ambient/machines/combine_shield_loop3.wav"
}

ENT.NZEntity = true

DEFINE_BASECLASS("nz_trapbase")

-- We use Smokestack for particle generation because it avoids a lot of lua logic, does everything we want,
-- is properly integrated into the HL2 engine and is extremely customizable!
function ENT:CreateParticleEntity() 
	if CLIENT then return end
	
	self.ParticleEntity = ents.Create("env_smokestack")
	if (IsValid(self.ParticleEntity)) then
		self.ParticleEntity:SetParent(self)
	end
end

function ENT:SetupDataTables()
	BaseClass.SetupDataTables(self)

	-- Create our Particle Generator
	if SERVER then 
		self:CreateParticleEntity()
	end

	-- Model Presets
	local modelTbl = {}
	modelTbl["Pipe Cap"] = 1
	modelTbl["Pipe"] = 2
	modelTbl["Gas Pipes"] = 3
	modelTbl["Electric Plug"] = 4

	-- Sound Presets
	local soundTbl = {}
	soundTbl["Gas"] = 1
	soundTbl["Fire"] = 2
	soundTbl["Energy"] = 3

	-- Particle Type Presets
	local particleTbl = {}
	for k,v in pairs(self.ParticleEffects) do
		particleTbl[v.name] = k
	end

	self:NetworkVar( "Int", 1, "ModelID", {KeyName = "nz_model_id", Edit = {title = "Model", order = 10, type = "Combo", text = "Select a model!", values = modelTbl}} )
	self:NetworkVar( "Int", 2, "Effect", {KeyName = "nz_trap_particle_effect", Edit = {title = "Particle Effect", order = 11, type = "Combo", values = particleTbl}} )
	self:NetworkVar( "Int", 3, "ParticleSound", {KeyName = "nz_trap_particle_sound", Edit = {title = "Particle Sound", order = 12, type = "Combo", values = soundTbl}} )

	self:NetworkVar("Float", 9, "ParticleRadius", {KeyName = "nz_trap_particle_radius", Edit = {title="Radius", order = 13, type = "Float", min = 0.0, max = 1000.0}} )
	self:NetworkVar("Float", 11, "ParticleSpeed", {KeyName = "nz_trap_particle_speed", Edit = {title="Particle Speed", order = 14, type = "Float", min = 0.0, max = 1000.0}} )
	self:NetworkVar("Float", 12, "ParticleAmount", {KeyName = "nz_trap_particle_amount", Edit = {title="Particle Amount", order = 15, type = "Float", min = 0.0, max = 1000.0}} )
	self:NetworkVar("Float", 13, "ZombieDeathDelayMin", {KeyName = "nz_particles_zmb_kill_delay_min", Edit = {title = "Min Zombie Death Delay", order = 16, type = "Float", min = 0, max = 100000}} )
	self:NetworkVar("Float", 14, "ZombieDeathDelayMax", {KeyName = "nz_particles_zmb_kill_delay_max", Edit = {title = "Max Zombie Death Delay", order = 17, type = "Float", min = 0, max = 100000}} )
	self:NetworkVar("Float", 15, "PlayerDamageDelay", {KeyName = "nz_trap_particle_player_dmg_delay", Edit = {title="Player Damage Delay", order = 19, type = "Float", min = 0.0, max = 100000.0}} )
	self:NetworkVar("Float", 16, "PlayerDamage", {KeyName = "nz_trap_particle_ply_dmg", Edit = {title="Player Damage", order = 20, type = "Float", min = 0.0, max = 100000.0}} )
	--self:NetworkVar("Float", 17, "NextAttack")

	self:NetworkVar("Vector", 0, "ParticleColor", { KeyName = "nz_trap_particle_color",	Edit = { title = "Particle Color", type = "VectorColor",	order = 18 } } )
	self:NetworkVarNotify("ModelID", self.OnModelChange)

	if SERVER then -- our particle ent can only be manipulated serverside
		self:NetworkVarNotify("Effect", self.OnParticleChange)
		self:NetworkVarNotify("ParticleSound", self.OnParticleSoundChange)
		self:NetworkVarNotify("ParticleRadius", self.OnParticleRadiusChange)
		self:NetworkVarNotify("ParticleColor", self.OnParticleColorChange)
		self:NetworkVarNotify("ParticleSpeed", self.OnParticleSpeedChange)
		self:NetworkVarNotify("ParticleAmount", self.OnParticleAmountChange)
	end

	-- Default values:
	self:SetZombieDeathDelayMin(1.5)
	self:SetZombieDeathDelayMax(1.5)
	self:SetPlayerDamageDelay(0.2)
    self:SetPlayerDamage(20)
	self:SetParticleRadius(50.0)
	self:SetParticleSpeed(100.0)
	self:SetParticleAmount(30.0)
	self:SetParticleColor(Vector(1,1,1))
	self:SetModelID(1)
	self:SetEffect(1)
	self:SetParticleSound(1)
end

function ENT:Initialize()
	if (SERVER) then
		self:SetModel(self.ModelTranslate[self:GetModelID()])
		self:DrawShadow( false )
		self:ResetParticles()
	end	
end

-- Some of the SmokeStack stuff only works the first time the entity is spawned (no realtime support)
-- So let's implement a function to completely redo the entity
function ENT:ResetParticles() 
	if (self.ResettingParticles) then return end
	self.ResettingParticles = true

	if (IsValid(self.ParticleEntity)) then
		self.ParticleEntity:Remove()
	end

	self:CreateParticleEntity()
	if (IsValid(self.ParticleEntity)) then
		self:InitParticles() -- The stuff users can't change

		-- Just call the listeners so we don't repeat logic
		self:OnParticleChange("Effect", self:GetEffect(), self:GetEffect())
		self:OnParticleRadiusChange("ParticleRadius", self:GetParticleRadius(), self:GetParticleRadius())
		self:OnParticleColorChange("ParticleColor", self:GetParticleColor(), self:GetParticleColor())
		self:OnParticleSpeedChange("ParticleSpeed", self:GetParticleSpeed(), self:GetParticleSpeed())
		self:OnParticleAmountChange("ParticleAmount", self:GetParticleAmount(), self:GetParticleAmount())

		-- Now do the stuff that only works when it is first created (or else endless loop lol)
		if (self:IsValidParticle(self:GetEffect())) then
			self.ParticleEntity:SetKeyValue("SmokeMaterial", self.ParticleEffects[self:GetEffect()].mat)
		end

		self.ParticleEntity:SetKeyValue("Rate", self:GetParticleAmount())
	end

	self.ResettingParticles = false

	if (!self:GetActive()) then
		self:TurnOffParticles()
	end
end

function ENT:TurnOnParticles() -- Particles start emitting
	if !IsValid(self.ParticleEntity) then return end

	local partSound = self.ParticleSounds[self:GetParticleSound()]
	if partSound then
		self.SoundPlayer = CreateSound(self, partSound)
	end

	self:PlayParticleSound()
	self.bParticlesEmitting = true

	if (IsValid(self.ParticleEntity)) then
		self.ParticleEntity:Fire("TurnOn")
		print(self.ParticleEntity:SetParent(self))
	end
end

function ENT:TurnOffParticles() -- Particles stop being emitted
	if !IsValid(self.ParticleEntity) then return end
	self:StopParticleSound()
	self.bParticlesEmitting = false

	if (IsValid(self.ParticleEntity)) then
		self.ParticleEntity:Fire("TurnOff")
	end
end

function ENT:PlayParticleSound()
	if (self.SoundPlayer) then
		self.SoundPlayer:PlayEx(70, 100)	
	end
end

function ENT:StopParticleSound(func)
	local fadeTime = 1

	if (self.SoundPlayer) then
		self.SoundPlayer:FadeOut(fadeTime)
	end

	timer.Simple(fadeTime + 0.1, function()
		if (func) then func() end
	end)
end

function ENT:IsEmittingParticles()
	return self.bParticlesEmitting 
end

function ENT:GetParticleHurtType()
	return self.ParticleEffects[self:GetEffect()] and self.ParticleEffects[self:GetEffect()].hurttype or DMG_GENERIC
end

function ENT:OnModelChange(name, old, new)
	if (IsValid(self) and new and self.ModelTranslate[new] and self.ModelTranslate[new]) then
		self:SetModel(self.ModelTranslate[new])
	end
end

function ENT:IsValidParticle(id)
	return IsValid(self) and self.ParticleEffects[id] != nil and self.ParticleEffects[id].mat != nil
end

function ENT:OnParticleChange(name, old, new)
	if !IsValid(self.ParticleEntity) then return end
	if (self:IsValidParticle(new)) then
		self:ResetParticles()
	end
end

function ENT:OnParticleRadiusChange(name, old, new)
	if !IsValid(self.ParticleEntity) then return end
	self.ParticleEntity:SetKeyValue("StartSize", new)
	self.ParticleEntity:SetKeyValue("BaseSpread", 30)
	self.ParticleEntity:SetKeyValue("SpreadSpeed", new)
	self.ParticleEntity:SetKeyValue("JetLength", new + 20)
end

function ENT:OnParticleSpeedChange(name, old, new)
	if !IsValid(self.ParticleEntity) then return end
	self.ParticleEntity:SetKeyValue("Speed", new)
end

function ENT:OnParticleColorChange(name, old, new)
	if !IsValid(self.ParticleEntity) then return end

	-- Colors only affect the particles if they are rounded (but also we multiply because the netvar has a min of 0 and max 1)
	local color = tonumber(math.Round(new[1]) * 255) .. " " .. tonumber(math.Round(new[2]) * 255) .. " " .. tonumber(math.Round(new[3]) * 255)
	self.ParticleEntity:SetKeyValue("rendercolor", color)
	self.ParticleEntity:Fire("Color", color)
end

function ENT:OnParticleAmountChange(name, old, new)
	self:ResetParticles()
end

function ENT:OnParticleSoundChange(name, old, new)
	local isPlaying = false
	if (self.SoundPlayer) then
		isPlaying = self.SoundPlayer:IsPlaying()
	end
	
	self:StopParticleSound(function()
		if IsValid(self) then
			self.SoundPlayer = CreateSound(self, self.ParticleSounds[new])
			if (isPlaying and self.SoundPlayer) then
				self:PlayParticleSound()
			end
		end
	end)
end

function ENT:InitParticles() -- Manipulates our Particle Generator to initialize itself
	if (!IsValid(self.ParticleEntity)) then return end
	self.ParticleEntity:SetPos(self:GetPos())
	self.ParticleEntity:SetKeyValue("InitialState", 1)
	self.ParticleEntity:SetKeyValue("EndSize", 0)
	self.ParticleEntity:Fire("TurnOn")
	self.ParticleEntity:Spawn()
end

function ENT:AddTargetToCooldown(ent)
	if (IsValid(ent) and ent:IsPlayer()) then 
		self.ParticleTargetCooldowns[ent] = CurTime() + self:GetPlayerDamageDelay()
	end
end

function ENT:TargetOnCooldown(ent)
	return self.ParticleTargetCooldowns[ent] and CurTime() < self.ParticleTargetCooldowns[ent]
end

function ENT:TargetIsPlayer(ent)
	return IsValid(ent) and ent:IsPlayer() and (!ent:IsSpectating() or ent:IsInCreative()) and ent:GetNotDowned() and !self:TargetOnCooldown(ent)
end

function ENT:TargetIsZombie(ent)
	return IsValid(ent) and ent:IsValidZombie() and ent:Health() > 0 and !ent.NZBossType
end

function ENT:HurtEntsByRadius(radius)
	for _,ent in pairs(ents.FindInSphere(self:GetPos(), radius)) do
		if !IsValid(ent) then return end
		if (self:TargetIsPlayer(ent)) then
			self:AddTargetToCooldown(ent)
			
			local dmg = DamageInfo()
			dmg:SetAttacker(Entity(0))
			dmg:SetDamage(self:GetPlayerDamage())
			ent:TakeDamageInfo(dmg)
		end
	
		if (self:TargetIsZombie(ent)) then
			if (self:GetParticleHurtType() == DMG_BURN) then
				ent:Ignite(2)
			end

			timer.Simple(math.Rand(self:GetZombieDeathDelayMin(), self:GetZombieDeathDelayMax()), function()
				if (!self:TargetIsZombie(ent)) then return end
	
				local dmg = DamageInfo()
				dmg:SetDamageType(DMG_BURN)
				dmg:SetAttacker(Entity(0))
				dmg:SetInflictor(Entity(0))
				dmg:SetDamage(ent:Health() * 2)
				dmg:SetDamageForce(Vector(0,0,0))
				ent:TakeDamageInfo(dmg)
			end)
		end
	end
end

function ENT:Think()	
	if SERVER then
		if (self:IsEmittingParticles() != self:GetActive()) then
			if (self:GetActive()) then
				self:TurnOnParticles()
			end
	
			if (!self:GetActive()) then
				self:TurnOffParticles()
			end
		end

		if (!IsValid(self.ParticleEntity)) then
			self:CreateParticleEntity()
			self:ResetParticles()
		end

		if (!self:GetActive()) then return end
		self:HurtEntsByRadius(self:GetParticleRadius())
	end
end

if CLIENT then
	function ENT:Draw()
		if self:GetRenderVisibility() then
			BaseClass.Draw(self)
		end

		if ConVarExists("nz_creative_preview") and !GetConVar("nz_creative_preview"):GetBool() and nzRound:InState( ROUND_CREATE ) then		
			BaseClass.Draw(self)
			render.SetColorMaterial()
			render.DrawSphere(self:GetPos(), self:GetParticleRadius(), 50, 50, Color(255, 0, 0, 80))
			
			-- Maybe add a Halo while in Creative to help see through the particles and locate the trap? 
			--IDK, I didn't do it because I banned halos from my server for causing great lag
		end	
	end
end

function ENT:OnRemove()
	if (self.SoundPlayer) then
		self.SoundPlayer:Stop()
	end

	if (IsValid(self.ParticleEntity)) then
		self.ParticleEntity:Remove()
	end
end	