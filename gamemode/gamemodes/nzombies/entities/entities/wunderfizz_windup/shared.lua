AddCSLuaFile()

ENT.Type = "anim"
 
ENT.PrintName		= "wunderfizz_windup"
ENT.Author			= "Zet0r"
ENT.Contact			= "youtube.com/Zet0r"
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.VortexLoopSound = Sound("nz_moo/perks/wonderfizz/vortex_loop.wav")

local teddymat = "models/perk_bottle/c_perk_bottle_teddy"

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "Winding" )
end

function ENT:RandomizeSkin()
	local skin
	if nzMapping.Settings.wunderfizzperks then
		skin = nzPerks:Get(table.Random(table.GetKeys(nzMapping.Settings.wunderfizzperklist))).material
	else
		skin = nzPerks:Get(table.Random(table.GetKeys(nzPerks:GetList()))).material
	end

	if skin then
		self:SetSkin(skin)
	end
end

function ENT:Initialize()
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_OBB)
	self:DrawShadow(false)

	self:SetModel("models/nzr/2022/perks/w_perk_bottle.mdl")
	self:RandomizeSkin()

	local machine = self.WMachine
	if SERVER then
		self:SetWinding(true)
		self.SoundPlayer = CreateSound(self, self.VortexLoopSound)
    	if (self.SoundPlayer) then
        	self.SoundPlayer:Play()
    	end

		timer.Simple(5, function()
			self:SetWinding(false)
			timer.Simple(5, function()
				if IsValid(self) and IsValid(self.WMachine) then
					self.WMachine:SetSharing(true)
				end
			end)

			self:EmitSound("nz_moo/perks/wonderfizz/elec/hit/random_perk_imp_0"..math.random(0, 2)..".mp3", 90, math.random(97, 103))

			if (self.SoundPlayer) then
        		self.SoundPlayer:FadeOut(0.8)
    		end
			if self.Perk == "teddy" then
				self:SetSkin(30)
				machine:SetIsTeddy(true)
				machine:GetUser():GivePoints(machine:GetPrice())
				timer.Simple(5, function() 
					if IsValid(self) and IsValid(machine) then
						self:Remove()
						machine:MoveLocation()
					end
				end)
			else
				self:SetSkin(nzPerks:Get(self.Perk).material)
			end
			machine:SetPerkID(self.Perk)
		end)

		timer.Simple(25, function() if IsValid(self) then self:Remove() end end)
	end
end

function ENT:WindUp()
	self:RandomizeSkin()
end

function ENT:TeddyFlyUp()
end

function ENT:Think()
	if SERVER then
		if self:GetWinding() then
			self:WindUp()
		end
	end

	self:NextThink(CurTime() + 0.0666)
	return true
end

function ENT:OnRemove()
	if IsValid(self.WMachine) then
		self.WMachine:SetBeingUsed(false)
		self.WMachine.Bottle = nil
	end
end

function ENT:Draw()
	self:DrawModel()
	if !self.Stopped then
		self:SetRenderAngles(self:GetNetworkAngles())
		self.LightningAura = nil -- Kill the aura effect
		self.Stopped = true
	end
end
