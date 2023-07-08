AddCSLuaFile( )

ENT.Type = "anim"

ENT.PrintName		= "pap_weapon_trigger"
ENT.Author			= "Zet0r"
ENT.Contact			= "Don't"
ENT.Purpose			= ""
ENT.Instructions	= ""

function ENT:SetupDataTables()
	self:NetworkVar("String", 0, "WepClass")
	self:NetworkVar("Entity", 0, "PaPOwner")
end

function ENT:Initialize()
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_OBB)
	self:SetModel("models/hunter/blocks/cube05x1x025.mdl")
	self:DrawShadow(false)

	if SERVER then
		self:SetUseType( SIMPLE_USE )
	end
end

function ENT:Use(ply, caller)
	if ply == self:GetPaPOwner() then
		nzPowerUps.HasPaped = true

		local class = self:GetWepClass()
		local wep

		if self.RerollingAtts then
			wep = ply:GiveNoAmmo(class)
		else
			wep = ply:Give(class)
		end

		timer.Simple(0, function()
			if not IsValid(ply) or not IsValid(wep) then return end

			wep:ApplyNZModifier("pap")
			if self.RerollingAtts then
				wep:ApplyNZModifier("repap")
			end

			if wep.IsTFAWeapon then
				wep:SetClip1(wep.Primary_TFA.ClipSize)
			else
				wep:SetClip1(wep.Primary.ClipSize)
			end

			if IsValid(self.wep) then
				self.wep.machine:SetBeingUsed(false)
				self.wep:Remove()
			end

			if not wep.NZSpecialCategory and ply:HasPerk("staminup") then
				wep:ApplyNZModifier("staminup")
			end
			if not wep.NZSpecialCategory and ply:HasPerk("deadshot") then
				wep:ApplyNZModifier("deadshot")
			end
			if not wep.NZSpecialCategory and ply:HasPerk("dtap2") then
				wep:ApplyNZModifier("dtap2")
			end
			if not wep.NZSpecialCategory and ply:HasPerk("dtap") then
				wep:ApplyNZModifier("dtap")
			end
			if not wep.NZSpecialCategory and ply:HasPerk("vigor") then
				wep:ApplyNZModifier("vigor")
			end

			self:Remove()
		end)
	else
		if IsValid(self:GetPaPOwner()) then
			ply:PrintMessage( HUD_PRINTTALK, "This is " .. self:GetPaPOwner():Nick() .. "'s gun. You cannot take it." )
		end
	end
end

if CLIENT then
	function ENT:Draw()
		return
	end
end
