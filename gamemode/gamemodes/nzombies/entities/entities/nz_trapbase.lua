-- Use this class as base when creating traps

AddCSLuaFile( )

ENT.Type = "anim"
ENT.Base = "nz_activatable"

ENT.PrintName = "nz_trapbase"

ENT.Trap = true

DEFINE_BASECLASS("nz_activatable")

function ENT:SetupDataTables()
	BaseClass.SetupDataTables( self )

	self:SetRemoteActivated(true)

	self.bIsLinked = nil

	self:NetworkVarNotify("NZName", function()
		self.bIsLinked = nil
	end)
end

function ENT:IsLinked()
	if (self.bIsLinked != nil) then 
		return self.bIsLinked 
	end
	
	local linked = false
	
	if (#self:GetNZName() <= 0) then return false end
	for _,class in pairs(nzLogic:GetAll()) do
		for _,logic_ent in pairs(ents.FindByClass(class)) do
			if logic_ent.GetLinkedEnts then
				if (logic_ent:GetLinkedNZName1() == self:GetNZName() or logic_ent:GetLinkedNZName2() == self:GetNZName() or logic_ent:GetLinkedNZName3() == self:GetNZName()) then
					linked = true
					break
				end
			end
		end
	end

	self.bIsLinked = linked
	return linked
end

-- IMPLEMENT ME
function ENT:OnActivation() end

function ENT:OnDeactivation() end

function ENT:OnReady() end