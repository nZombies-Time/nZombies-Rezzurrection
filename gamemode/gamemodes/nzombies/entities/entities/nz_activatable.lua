-- Improved by Ethorbit

AddCSLuaFile( )

-- Interface for stuff taht cna be activated by the player DO NOT USE THIS CLASS create subclasses!

ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.Editable = true

ENT.PrintName = "nz_activatable"

ENT.bIsActivatable = true
ENT.bPhysgunNoCollide = true

ENT.NZEntity = true

function ENT:SetupDataTables()
	self:NetworkVar( "String", 0, "NZName", {KeyName = "nz_name", Edit = {title = "Flag", order = -1, type = "Generic"}} )

	self:NetworkVar( "Bool", 1, "Active")
	self:NetworkVar( "Bool", 2, "CooldownActive")
	self:NetworkVar( "Bool", 3, "DisplayName", {KeyName = "nz_trap_displayname", Edit = {title = "Display Name?", order = 1, type = "Boolean"}} )
	self:NetworkVar( "Bool", 4, "ElectricityNeeded", {KeyName = "nz_electricityneeded", Edit = {title = "Electricity Needed?", order = 3, type = "Boolean"}} )
	self:NetworkVar( "Bool", 5, "RemoteActivated", {KeyName = "nz_remoteactivated", Edit = {title = "Remote Activated?", order = 4, type = "Boolean"}} )
	self:NetworkVar( "Bool", 6, "RenderVisibility", {KeyName = "nz_model_visibility", Edit = {title = "Model Visible?", order = 2, type = "Boolean"}} )

	self:NetworkVar( "Float", 0, "Duration", {KeyName = "nz_duration", Edit = {order = 7, type = "Float", min = 0, max = 100000}} )
	self:NetworkVar( "Float", 1, "Cooldown", {KeyName = "nz_cooldown", Edit = {order = 8, type = "Float", min = 0, max = 100000}} )

	self:NetworkVar( "Int", 0, "Cost", {KeyName = "nz_cost", Edit = {order = 9, type = "Int", min = 0, max = 100000}} )
	self:NetworkVar( "Int", 1, "State")

	self:SetDisplayName(false)
	self:SetRenderVisibility(true)
	self:SetActive(false)
	self:SetDuration(40)
	self:SetCooldown(60)
	self:SetCost(1250)
	self:SetCooldownActive(false)
	self:SetElectricityNeeded(true)
	self:SetRemoteActivated(false)

	if SERVER then
		self:SetUseType(SIMPLE_USE)
	end
end

function ENT:IsActive() return self:GetActive() end

function ENT:IsCooldownActive() return self:GetCooldownActive() end

function ENT:IsElectricityNeeded() return self:GetElectricityNeeded() end

function ENT:IsRemoteActivated() return self:GetRemoteActivated() end

function ENT:Activation(activator, duration, cooldown, creativeMode)
	if !creativeMode then
		self:SetDuration(duration)
		self:SetCooldown(cooldown)
	end

	self:SetActive(true)

	if !creativeMode and self:GetDuration() > 0 then
		timer.Create("nz.activatable.timer." .. self:EntIndex(), self:GetDuration(), 1, function() if IsValid(self) then self:Deactivation() end end)
	end
	self:OnActivation(activator, duration, cooldown)
end

function ENT:Deactivation(creativeMode)
	self:SetActive(false)
	self:SetCooldownActive(true)
	local time = !self:GetCooldown() and 0 or self:GetCooldown()
	--if self:GetCooldown() > 0 then
	self:OnCooldown()

	if (!creativeMode) then
		timer.Create("nz.activatable.cooldown.timer." .. self:EntIndex(), time, 1, function() 
			if IsValid(self) then 
				if (self:GetElectricityNeeded()) then
					if (nzElec:IsOn()) then
						self:Ready() 
					end
				else
					self:Ready() 
				end		
			end 
		end)
	end

	--end
	self:OnDeactivation()
end

function ENT:Ready()
	self:SetCooldownActive(false)
	self:OnReady()


end

function ENT:Use(act, caller, type, value )
	if (nzRound and nzRound:InState(ROUND_CREATE) and !self:IsRemoteButton()) then
		if (!self:GetActive()) then
			self:Activation(caller, 9999999, 0, true)
		else
			self:Deactivation(true)
		end
	return end

	if not nzElec:IsOn() and self:IsElectricityNeeded() then return end
	if IsValid(caller) and caller:IsPlayer() and not self:IsRemoteActivated() and not self:IsCooldownActive() and not self:IsActive() then
		if caller:CanAfford(self:GetCost()) then
			self:Activation(caller, self:GetDuration(), self:GetCooldown())
			if SERVER then
				caller:TakePoints(self:GetCost())
			end
		end
	end
end

function ENT:PowerOff()
	self:Deactivation(true)
	self:SetCooldownActive(false)
	self:OnPoweredOff()
end

-- IMPLEMENT ME
function ENT:OnActivation() end

function ENT:OnDeactivation() end

function ENT:OnReady() end

function ENT:OnPoweredOff() end

function ENT:OnCooldown() end

function ENT:IsRemoteButton()
	return self:GetRemoteActivated() and (self:GetClass() == "nz_button" or self:GetClass() == "nz_button_and")
end

function ENT:GetNZTargetText()
	if (nzRound and nzRound:InState(ROUND_CREATE) and !self:IsRemoteButton()) then
		if (!self:GetActive()) then
			return "Toggle Preview On"
		else
			return "Toggle Preview Off"
		end
	end
	
	-- Warn users if this trap cannot be turned on (Remote activated and no button attached)
	if (self.Trap) then
		if (self:GetRemoteActivated() and self.IsLinked != nil and !self:IsLinked()) then 
			return "There is no way to activate this." 
		end
	end

	if !self:GetRenderVisibility() then return "" end
	if self:IsActive() then return "Already activated" end
	if not self:IsElectricityNeeded() and nzElec:IsOn() and self:IsRemoteActivated() then
		return false
	end

	if self:IsElectricityNeeded() and not nzElec:IsOn() then
		return "No Power."
	else
		if (self.Trap) then
			if (self.IsLinked and self:IsLinked()) then return false end
		end
		if self:IsCooldownActive() then return "On cooldown" end
		if self:IsRemoteActivated() then return false end
		if !LocalPlayer():GetNotDowned() then return "" end
		if self:GetCost() > 0 then
			return (!self:GetDisplayName() or #self:GetNZName() == 0) and "Press E to activate trap for " .. self:GetCost() .. " points." or "Press E to activate " .. self:GetNZName() .. " for " .. self:GetCost() .. " points."
		else
			return (!self:GetDisplayName() or #self:GetNZName() == 0) and "Press E to activate trap." or "Press E to activate " .. self:GetNZName() .. "."
		end
	end
end

-- util
function ENT:GetEntsByNZName(name)
	local result = {}
	if not name or name == "" then return result end
	for _, ent in pairs(ents.GetAll()) do
		if ent:IsActivatable() then
			if ent:GetNZName() == name then
				table.insert(result, ent)
			end
		end
	end
	return result
end

--Default stuff
if CLIENT then
	function ENT:Draw()
		if (self:GetRenderVisibility() or (!self:GetRenderVisibility() and ConVarExists("nz_creative_preview") and !GetConVar("nz_creative_preview"):GetBool() and nzRound:InState( ROUND_CREATE ))) then
			self:DrawModel()
		end
	end
end