ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Panzer Claw"
ENT.Author = "Zet0r"

ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
	AddCSLuaFile()
	util.AddNetworkString("nz_panzer_grab")
end

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "Panzer")
end

function ENT:Initialize()
	if SERVER then
		self:SetModel("models/nz_zombie/panzer_claw.mdl") -- Change later
		self:PhysicsInit(SOLID_OBB)
		self:SetSolid(SOLID_NONE)
		self:SetTrigger(true)
		self:UseTriggerBounds(true, 0)
		self:SetMoveType(MOVETYPE_FLY)
		ParticleEffectAttach("doom_imp_fireball_cheap",PATTACH_ABSORIGIN_FOLLOW,self,0)
		--self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
		--self:SetSolid(SOLID_VPHYSICS)
		phys = self:GetPhysicsObject()

		if phys and phys:IsValid() then
			phys:Wake()
		end
	end
end

function ENT:Launch(dir)
	self:SetLocalVelocity(dir * 1000)
	self:SetAngles((dir*-1):Angle())
	self:SetSequence(self:LookupSequence("anim_close"))
	
	self.AutoReturnTime = CurTime() + 0.75
	self.AutoBreak = CurTime() + 3
end

function ENT:Grab(ply, pos) -- Pos is used for clients who may not have the Panzer valid yet
	if !IsValid(ply) then return end
	
	self.HasGrabbed = true

	local panzer = self:GetPanzer()
	local speed = 1050
	local pos = pos or IsValid(panzer) and panzer:GetAttachment(panzer:LookupAttachment("tag_claw")).Pos
	
	self.GrabbedPlayer = ply
	local breaktime = CurTime() + 3
	local index = self:EntIndex()
	
	panzer:ComedyGrab()

	hook.Add("SetupMove", "PanzerGrab"..index, function(pl, mv, cmd)
		if !IsValid(ply) or IsValid(ply) and !ply:GetNotDowned() then self:Release() end
		
		if pl == ply then
			local dir = (pos - (pl:GetPos() + Vector(0,0,50))):GetNormalized()
			mv:SetVelocity(dir * speed)
			
			if !IsValid(panzer) or !IsValid(Entity(index)) then
				hook.Remove("SetupMove", "PanzerGrab"..index)
			else
				local dist = (pl:GetPos() + Vector(0,0,50)):Distance(pos)
				if dist < 50 then
					speed = 200
				end
				if dist < 25 then
					self:Reattach()
				end
			end

			if mv:GetVelocity():Length() > 100 then -- Keep a speed over 100
				breaktime = CurTime() + 3 -- Then we keep delaying when to "break" the hook
			elseif CurTime() > breaktime then -- But if you haven't been over 100 speed for the time
				self:Release() -- Break the hook!				
			end
			
			if SERVER then
				self:SetPos(pl:GetPos() + Vector(0,0,50))
			end
		end
	end)
	
	if SERVER then
		self:SetLocalVelocity(Vector(0,0,0))
		net.Start("nz_panzer_grab")
			net.WriteBool(true)
			net.WriteEntity(self)
			net.WriteVector(pos)
		net.Send(ply)
		
		self:SetSequence(self:LookupSequence("anim_open"))
	end
	
end

function ENT:Release()
	if IsValid(self.GrabbedPlayer) then
		local panzer = self:GetPanzer()
		panzer:FinishGrab()
		hook.Remove("SetupMove", "PanzerGrab"..self:EntIndex())
		
		if SERVER then
			net.Start("nz_panzer_grab")
				net.WriteBool(false)
				net.WriteEntity(self)
			net.Send(self.GrabbedPlayer)
			
			self:SetSequence(self:LookupSequence("anim_open"))
			self:Return()
		end
	else
		if SERVER then
			net.Start("nz_panzer_grab")
				net.WriteBool(false)
				net.WriteEntity(self)
			net.Broadcast()
		end
	end
	self.GrabbedPlayer = nil
end

if CLIENT then
	net.Receive("nz_panzer_grab", function()
		local grab = net.ReadBool()
		local ent = net.ReadEntity()
		local pos
		if grab then pos = net.ReadVector() end
		
		if IsValid(ent) then
			if grab then
				ent:Grab(LocalPlayer(), pos)
			else
				if IsValid(ent) then ent:Release() end
			end
		end
	end)
end

function ENT:Return() -- Emptyhanded return - Grab is with player
	--print("return")
	self:EmitSound("nz_moo/zombies/vox/_mechz/claw/retract.mp3", 100, math.random(85, 105))
	self.HasGrabbed = true
	self.Retract = true

	local panzer = self:GetPanzer()
	if !IsValid(panzer) then self:Remove() return end

	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetNotSolid(true)
	self:SetCollisionBounds(Vector(0,0,0), Vector(0,0,0))
end

function ENT:Reattach(removed)
	if SERVER then
		if !removed then self:Remove() end
	end
	
	local panzer = self:GetPanzer()
	if !IsValid(panzer) then return end
	
	panzer:FinishGrab()
end

function ENT:StartTouch(ent)
	local panzer = self:GetPanzer()
	if IsValid(panzer) and !self.HasGrabbed  then
		if ent:IsPlayer() and panzer:IsValidTarget(ent) then
			--self:EmitSound("death.wav")
			self:EmitSound("nz_moo/zombies/vox/_mechz/claw/grab.mp3", 100, math.random(85, 105))
			self:Grab(ent)
		else
			if ent:GetClass() == "nz_zombie_boss_panzer" or ent.IsMooZombie then return end
			self:Return()
		end
	else
		if SERVER then
			self:Remove()
		end
	end
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
end


function ENT:Think()
	if SERVER then
		if self.HasGrabbed then
			local panzer = self:GetPanzer()
			if !IsValid(panzer) then self:Remove() return end
			
			if !IsValid(self.GrabbedPlayer) and self:GetPos():DistToSqr(panzer:GetAttachment(panzer:LookupAttachment("tag_claw")).Pos) <= 10000 then
				self:Reattach()
			end
			
			if IsValid(panzer) and self.GrabbedPlayer and !panzer:IsValidTarget(self.GrabbedPlayer) then
				self:Release()
			end
			
			if CurTime() > self.AutoBreak then
				self:Release()
			end
		elseif CurTime() > self.AutoReturnTime then 
			self:Return()
		end
		if self.Retract then
			local panzer = self:GetPanzer()
			local att = panzer:GetAttachment(18)
			if att then
				self:SetPos(LerpVector( 0.1, self:GetPos(), att.Pos ))
			end
		end
	end
	self:NextThink(CurTime())
	return true
end

function ENT:OnRemove()
	if SERVER then
		local panzer = self:GetPanzer()
		panzer:FinishGrab()
	end
	self:Release()
	self:Reattach(true)
end