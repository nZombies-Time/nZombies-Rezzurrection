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
	self:NetworkVar("Int", 4, "CooldownTime")
	self:NetworkVar("Vector", 0, "DestPos")
	self:NetworkVar("Int", 6, "GifType")
	self:NetworkVar("Bool", 3, "Kino")
	self:NetworkVar("Int", 5, "Kinodelay")
	self:NetworkVar("Bool", 4, "Giftoggle")
	self:NetworkVar("Bool", 5, "Usable")
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
self:SetModel("models/teleporters/der_riese/zombie_teleporter_pad.mdl")
self:SetModelType(1)
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

function ENT:Animation(id)
	local selectedmat
	if id == 1 then
	selectedmat = "codtele"
	end
	if id == 2 then
	selectedmat = "coldwartp"
	end
	if id == 3 then
	selectedmat = "bo3tp"
	end
	if id == 4 then
	selectedmat = "soe"
	end
	if id == 5 then
	selectedmat = "originstp"
	end
	return selectedmat
end


function ENT:Use(activator, caller)
	
	print(self:GetUsable())
	local price = self:GetPrice()
	local damnitbobby = self:GetGifType()
	if self:IsOn() and !self:GetBeingUsed() and price > -1 and damnitbobby < 6 then
		--if self:GetUsable() == true then
		--local price = self:GetPrice()
		local walk = activator:GetWalkSpeed()
		local run = activator:GetRunSpeed()
		if activator:GetPoints() > price and self:GetCooldown()==false  then
		self:SetBeingUsed(true)
		for k,v in pairs(ents.FindByClass("nz_teleporter")) do
		if(v:GetID() == self:GetDestination()) then
		self:SetDestPos(v:GetPos() +  Vector(0, 0, 21))
		end
		end
		timer.Simple(1, function()
		local effectData = EffectData()
			effectData:SetOrigin( self:GetPos()+ Vector(0, 0, 100) )
			effectData:SetMagnitude( 2 )
			effectData:SetEntity(nil)
			util.Effect("lightning_prespawn", effectData)
			end)
			-- If they have enough money
			activator:TakePoints(price)
			
			for k, v in pairs ( ents.FindInSphere( self:GetPos(), 200 ) ) do 
			if v:IsValid() and v:IsPlayer() then
			v:GodEnable()
			v:SetRunSpeed(1)
			v:SetWalkSpeed(1)
			timer.Simple(2.5,function()
			self:SetGiftoggle(true)
			v:EmitSound( "teleport.mp3" )
			end)
			timer.Simple(2.5,function()
			local effectData = EffectData()
			effectData:SetStart( self:GetPos() + Vector(0, 0, 1000) )
			effectData:SetOrigin( self:GetPos() )
			effectData:SetMagnitude( 1 )
			util.Effect("lightning_strike", effectData)
			
					end)
					timer.Simple(5, function()
					self:SetGiftoggle(false)
					v:SetPos(self:GetDestPos() )
					v:SetRunSpeed(run)
					v:SetWalkSpeed(walk)
					v:GodDisable()
					for k,v in pairs(ents.FindByClass("nz_teleporter")) do
								if(v:GetID() == self:GetDestination()) then
									local effectData = EffectData()
									effectData:SetStart( v:GetPos() + Vector(0, 0, 1000) )
									effectData:SetOrigin( v:GetPos() )
									effectData:SetMagnitude( 1 )
									util.Effect("lightning_strike", effectData)
								self:SetCooldown(true)
								v:SetCooldown(true)
								if(self:GetKino() == false) then
								self:SetBeingUsed(false)
								end
								timer.Simple((self:GetCooldownTime()+self:GetKinodelay()),function()
								self:SetCooldown(false)
								v:SetCooldown(false)
								end)
					end
					end
					end)
					if(self:GetKino() == true) then
					timer.Simple(self:GetKinodelay()-1, function()
					local effectData = EffectData()
					effectData:SetOrigin( self:GetPos()+ Vector(0, 0, 100) )
					effectData:SetMagnitude( 2 )
					effectData:SetEntity(nil)
					util.Effect("lightning_prespawn", effectData)
					local effectData = EffectData()
					effectData:SetOrigin( v:GetPos()+ Vector(0, 0, 100) )
					effectData:SetMagnitude( 2 )
					effectData:SetEntity(nil)
					util.Effect("lightning_prespawn", effectData)
					end)
					timer.Simple(self:GetKinodelay(), function()
					self:SetGiftoggle(true)
					v:GodEnable()
					v:SetRunSpeed(1)
					v:SetWalkSpeed(1)
					v:EmitSound( "teleport.mp3" )
					
					end)
					timer.Simple(self:GetKinodelay() + 3,function()
					local effectData = EffectData()
					effectData:SetStart( v:GetPos() + Vector(0, 0, 1000) )
					effectData:SetOrigin( v:GetPos() )
					effectData:SetMagnitude( 1 )
					util.Effect("lightning_strike", effectData)
					v:SetPos(self:GetPos()+  Vector(0, 0, 21) )
					v:SetRunSpeed(run)
					v:SetWalkSpeed(walk)
					self:SetGiftoggle(false)
					v:GodDisable()
					self:SetBeingUsed(false)
					end)
					end
					
			--take points, start revving up, wait 3 seconds, check player distance, if within circle,lock, play gif on screen, setpos to destination id,put teleporter on cooldown for 30 seconds
			else
			--It smells like poor in here
			
			end
		end
			
	
		end
	--end
	end
end

if CLIENT then
			
			
	function ENT:Draw()
		self:DrawModel()
		hook.Add( "DrawOverlay", "TeleporterImage", function()
			if self:IsValid()  then
			if self:GetGiftoggle() == true then
			if LocalPlayer():GetRunSpeed() < 5 then
			local tpgif = self:Animation(self:GetGifType())
			DrawMaterialOverlay(tpgif, 0.03)
			end
			end
			end
			end)
	end
end