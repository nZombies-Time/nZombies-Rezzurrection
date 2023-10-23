AddCSLuaFile()

--[Info]--
ENT.Type = "anim"
ENT.PrintName = "Planted Shield"
ENT.Author = ""
ENT.Purpose = ""
ENT.Instructions = ""
ENT.DoNotDuplicate = true
ENT.DisableDuplicator = true
ENT.Damage = 0

local nzombies = engine.ActiveGamemode() == "nzombies"
local sp = game.SinglePlayer()

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "HurtType")
	self:NetworkVar("Int", 1, "RewardType")
	self:NetworkVar("Int", 2, "PointAmount")

	self:NetworkVar("String", 0, "DoorFlag")

	self:NetworkVar("Bool", 0, "Upgrade")
	self:NetworkVar("Bool", 1, "Global")
end

function ENT:EmitSoundNet(sound)
	if CLIENT or sp then
		if sp and not IsFirstTimePredicted() then return end

		self:EmitSound(sound)
		return
	end

	local filter = RecipientFilter()
	filter:AddPAS(self:GetPos())
	if IsValid(self:GetOwner()) then
		filter:RemovePlayer(self:GetOwner())
	end

	net.Start("tfaSoundEvent", true)
	net.WriteEntity(self)
	net.WriteString(sound)
	net.Send(filter)
end
