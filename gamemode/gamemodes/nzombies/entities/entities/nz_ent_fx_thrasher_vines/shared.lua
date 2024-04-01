AddCSLuaFile( )

ENT.Type = "anim"
 
ENT.PrintName		= "Thrasher Vines"
ENT.Author			= "GhostlyMoo"
ENT.Contact			= "Don't"
ENT.Purpose			= ""
ENT.Instructions	= ""

function ENT:Initialize()
	self:SetModel("models/moo/_codz_ports_props/t7/_island/p7_fxanim_zm_island_thrasher_teleport_mod/p7_fxanim_zm_island_thrasher_teleport_mod.mdl")
	self.AutomaticFrameAdvance = true
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_NONE )

	self.TeleportIn 	= false
	self.TeleportOut 	= false
	self.RemoveTime 	= nil
end

function ENT:GetPos() return self:GetPos() end
function ENT:GetAngles() return self:GetAngles() end

function ENT:VinesIn()
	local seq, dur = self:LookupSequence("teleport_in")
	self:ResetSequence(seq)

	self.RemoveTime = CurTime() + dur
	self.TeleportIn = true
end

function ENT:VinesOut()
	local seq, dur = self:LookupSequence("teleport_out")
	self:ResetSequence(seq)

	self.RemoveTime = CurTime() + dur
	self.TeleportOut = true
end

function ENT:Think()
	if (self.TeleportIn or self.TeleportOut) and CurTime() > self.RemoveTime then
		self:Remove()
	end

	self:NextThink( CurTime() )
	return true
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end