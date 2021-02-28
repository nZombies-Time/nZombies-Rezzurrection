AddCSLuaFile()

ENT.Type			= "anim"

ENT.PrintName		= "nz_teleporter"
ENT.Author			= "Laby"
ENT.Contact			= "Don't"
ENT.Purpose			= ""
ENT.Instructions	= ""

function ENT:SetupDataTables()
	self:NetworkVar("Int", 1, "Destination")
	self:NetworkVar("Int", 2, "ID")
	self:NetworkVar("Bool", 0, "Active")
	self:NetworkVar("Bool", 1, "BeingUsed")
	self:NetworkVar("Bool", 2, "Cooldown")
	self:NetworkVar("Int", 0, "Price")
	self:NetworkVar("Int", 3, "ModelType")
end

function ENT:Initialize()
	if SERVER then
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_VPHYSICS )
		self:DrawShadow( false )
		self:SetUseType( SIMPLE_USE )
		self:SetBeingUsed(false)
		self:SetCooldown(false)
		
	end
end

function ENT:TurnOn()

	self:SetActive(true)
	self:Update()
end

function ENT:TurnOff()
	self:SetActive(false)
	self:Update()
end


function ENT:Update()

self:SetModel("models/nz_der_riese_waw/zombie_teleporter_pad.mdl")

		--if self:GetModelType() == 1 then
		--if self:IsOn() then
			--self:SetModel(FIVEON)
			--else
			--self:SetModel(FIVEOFF)
			--end
		--else
	--if self:IsOn() then
			--self:SetModel(KINOON)
			--else
			--self:SetModel(KINOOFF)
			--end
		--end	
end

function ENT:IsOn()
	return self:GetActive()
end

function ENT:Use(activator, caller)
	
	
	if self:IsOn() then
		local price = self:GetPrice()
		local walk = activator:GetWalkSpeed()
		local run = activator:GetRunSpeed()
		if activator:GetPoints() > price and self:GetCooldown()==false  then
		timer.Simple(1, function()
		local effectData = EffectData()
			effectData:SetOrigin( self:GetPos()+ Vector(0, 0, 100) )
			effectData:SetMagnitude( 2 )
			effectData:SetEntity(nil)
			util.Effect("lightning_prespawn", effectData)
			end)
			-- If they have enough money
			activator:TakePoints(price)
			--playsound(zap and shit)
			activator:GodEnable()
			activator:SetRunSpeed(1)
			activator:SetWalkSpeed(1)
			self:SetModelType(0)
			timer.Simple(2.5,function()
			local effectData = EffectData()
			effectData:SetStart( self:GetPos() + Vector(0, 0, 1000) )
			effectData:SetOrigin( self:GetPos() )
			effectData:SetMagnitude( 1 )
			util.Effect("lightning_strike", effectData)
				self:SetBeingUsed(true)
				
					end)
					timer.Simple(5, function()
					self:SetModelType(1)
					activator:GodDisable()
					for k,v in pairs(ents.FindByClass("nz_teleporter")) do
								if(v:GetID() == self:GetDestination()) then
								activator:SetPos(v:GetPos() +  Vector(0, 0, 21) )
									activator:SetRunSpeed(run)
									activator:SetWalkSpeed(walk)
									local effectData = EffectData()
									effectData:SetStart( v:GetPos() + Vector(0, 0, 1000) )
									effectData:SetOrigin( v:GetPos() )
									effectData:SetMagnitude( 1 )
									util.Effect("lightning_strike", effectData)
								self:SetCooldown(true)
								v:SetCooldown(true)
								self:SetBeingUsed(false)
								timer.Simple(32,function()
								self:SetCooldown(false)
								v:SetCooldown(false)
								
								end)
					end
					end
					end)
					
			--take points, start revving up, wait 3 seconds, check player distance, if within circle,lock, play gif on screen, setpos to destination id,put teleporter on cooldown for 30 seconds
			else
			--It smells like poor in here
			
			end
			
	
		end
	end

if CLIENT then
	
	
	function ENT:Draw()
	
			if self:IsValid() then
			hook.Add( "DrawOverlay", "TeleporterImage", function()
			local teleportermat = Material( "codtele" )
			if self:IsValid() and self:GetBeingUsed() then
			if self:GetModelType()< 1 then
			--local teleportermat = Material( "teleportHD2.png", "unlitgeneric smooth" )
			--if self:GetModelType()< 1 then
			--surface.SetMaterial(teleportermat)
			--surface.SetDrawColor(255,255,255,255)
			--surface.DrawTexturedRectRotated(ScrW()/2+50, ScrH()/2+50, ScrW()*2, ScrH()*2, CurTime()*720)
			surface.SetMaterial(teleportermat)
			surface.SetDrawColor(255,255,255,255)
			surface.DrawTexturedRect( -10, -10, ScrW()+50, ScrH()+50 )
			surface.PlaySound("teleport.mp3" )
			end
			end
			end)
		end
		self:DrawModel()
	end
end