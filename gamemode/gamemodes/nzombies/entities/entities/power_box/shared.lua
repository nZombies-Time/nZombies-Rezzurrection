AddCSLuaFile( )

ENT.Type = "anim"
 
ENT.PrintName		= "Zombies Power"
ENT.Author			= "Zet0r"
ENT.Contact			= ""
ENT.Purpose			= ""
ENT.Instructions	= ""

function ENT:SetupDataTables()

	self:NetworkVar( "Bool", 0, "Switch" )
	self:NetworkVar( "Entity", 0, "PowerHandle")
	self:NetworkVar( "Bool", 1, "Limited" )
	self:NetworkVar( "Int", 0, "AOE" )
	
end

function ENT:Initialize()
	if SERVER then
		self:SetModel( "models/nzprops/zombies_power_lever.mdl" )
		self:SetSolid( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_NONE )
		self:SetUseType( ONOFF_USE )
		self:SetSwitch(false)
		
		self.Handle = ents.Create("nz_prop_effect_attachment")
		self.Handle:SetModel("models/nzprops/zombies_power_lever_handle.mdl")
		self.Handle:SetAngles( self:GetAngles() )
		self.Handle:SetPos(self:GetPos() + self:GetAngles():Up()*46 + self:GetAngles():Forward()*7)
		self.Handle:Spawn()
		self.Handle:SetParent(self)
		self:SetPowerHandle(self.Handle)
		
		self:DeleteOnRemove( self.Handle )
	else
		self.Switched = false
	end
end

function ENT:Use( activator )

if ( !activator:IsPlayer() ) then return end
		
		print(self:GetLimited())
		if self:GetLimited() == true and self:GetAOE() > 0 then
		print("limited")
		net.Start("nz.nzElec.Sound")
			net.WriteBool(true)
		net.Broadcast()
		self:SetSwitch(true)
		self.Switched = 0
		local weball = false
		for k,v in pairs(ents.FindByClass("wunderfizz_machine")) do
		if v:IsOn() then 
		weball = true
		end
		end
	-- Open all doors with no price and electricity requirement
	for k,v in pairs(ents.FindInSphere( self:GetPos(), self:GetAOE() or 1000 )) do
		if v:GetClass() == "wunderfizz_machine" and weball == false then 
		v:TurnOn()
		end
		
		if v:GetClass() == "perk_machine" or v:GetClass() == "nz_teleporter" then 
		v:TurnOn()
		end
		
		if v:IsBuyableEntity() then
			local data = v:GetDoorData()
			if data then
				if tonumber(data.price) == 0 and tobool(data.elec) == true then
					nzDoors:OpenDoor( v )
				end
			end
		end
	end
	
	else
	print("whole map")
	if !IsElec() and nzRound:InProgress() then
		self:SetSwitch(true)
		self.Switched = 0
		nzElec:Activate()
	end

end
end
	
if CLIENT then

	local offang = Angle(0,0,0)
	local onang = Angle(-90,0,0)

	function ENT:Think()
		local handle = self:GetPowerHandle()
		if self:GetSwitch() != self.Switched then
			self.Switching = math.Approach( self.Switching or 0, 1, FrameTime() * 2 )
			local ang = self:GetAngles()
			if self:GetSwitch() then
				handle:SetRenderAngles(LerpAngle(self.Switching, self:LocalToWorldAngles(offang), self:LocalToWorldAngles(onang)))
			else
				handle:SetRenderAngles(LerpAngle(self.Switching, self:LocalToWorldAngles(onang), self:LocalToWorldAngles(offang)))
			end
			
			if self.Switching >= 1 then
				self.Switched = self:GetSwitch()
				self.Switching = nil
			end
		end
	end
	
	function ENT:Draw()
		self:DrawModel()
	end
end