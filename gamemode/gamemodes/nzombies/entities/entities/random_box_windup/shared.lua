AddCSLuaFile( )

ENT.Type = "anim"

ENT.PrintName		= "random_box_windup"
ENT.Author			= "Alig96"
ENT.Contact			= "Don't"
ENT.Purpose			= ""
ENT.Instructions	= ""

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Winding")
	self:NetworkVar("Float", 0, "ThinkRate")
	self:NetworkVar("String", 0, "WepClass")
	self:NetworkVar("Entity", 0, "Buyer")

	self:NetworkVar("Bool", 1, "IsTeddy")
	self:NetworkVar("Bool", 2, "Sharing")
end

function ENT:Initialize()
	local speed = self:GetBuyer():HasUpgrade("speed")

	self:SetMoveType(MOVETYPE_NOCLIP)
	self:SetLocalVelocity(self:GetAngles():Up() * (speed and 17 or 5))
	self:SetSolid(SOLID_OBB)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:DrawShadow(false)

	self:SetWinding(true)
	self:SetIsTeddy(false)
	self:SetSharing(false)
	self:SetThinkRate(speed and .05 or .1)
	self.c = 0
	self.s = -20
	self.t = 0

	self:SetModel("models/weapons/w_rif_ak47.mdl")

	if SERVER then
		if nzMapping.Settings.rboxweps then
			self.ScrollWepList = table.GetKeys(nzMapping.Settings.rboxweps)
		end

		timer.Simple(speed and 1.5 or 5, function()
			self:SetWinding(false)
			if self:GetWepClass() == "nz_box_teddy" then
				self:SetModel("models/hoff/props/teddy_bear/teddy_bear.mdl")
				--self:SetModel("models/moo/nzprops/mystery_bunny.mdl")
				self:SetAngles( self.Box:GetAngles() + Angle(-90,90,0) )
				self:SetLocalVelocity(self.Box:GetAngles():Up()*30)
				nzSounds:Play("Laugh")
				self:SetIsTeddy(true)
				if IsValid(self:GetBuyer()) then self:GetBuyer():GivePoints(950) end -- Refund please
			else
				local wep = weapons.Get(self:GetWepClass())
				self:SetModel(wep.WM or wep.WorldModel)
				self:SetLocalVelocity(Vector(0,0,0)) -- Stop
			end
		end)

		timer.Simple(15, function()
			if not IsValid(self) then return end
			self:SetLocalVelocity(self:GetAngles():Up()*-2)
			if not self:GetSharing() and #player.GetAllPlaying() > 1 then
				ParticleEffectAttach("nz_magicbox_sharing", PATTACH_ABSORIGIN_FOLLOW, self, 1)
				self:SetSharing(true)
			end
		end)

		timer.Simple(25, function()
			if not IsValid(self) then return end
			self.Box:Close()
			self:Remove()
		end)
	else
		local wep = weapons.Get(self:GetWepClass())
		if !wep then
			timer.Simple(1, function()
				if IsValid(self) then
					wep = weapons.Get(self:GetWepClass())
					if wep and wep.DrawWorldModel then self.WorldModelFunc = wep.DrawWorldModel end
				end
			end)
		elseif wep.DrawWorldModel then 
			self.WorldModelFunc = wep.DrawWorldModel
		end
	end
end

function ENT:Use( activator, caller )
	if !self:GetWinding() and self:GetWepClass() != "nz_box_teddy" then
		if self:GetSharing() then
			local class = self:GetWepClass()
			activator:Give(class)
			nzWeps:GiveMaxAmmoWep(activator, class)
			self.Box:Close()
			self:SetSharing(false)
			self:Remove()
		else
			if activator == self:GetBuyer() then	
				local class = self:GetWepClass()
				activator:Give(class)
				nzWeps:GiveMaxAmmoWep(activator, class)
				self.Box:Close()
				self:SetSharing(false)
				self:Remove()
			else
				activator:PrintMessage( HUD_PRINTTALK, "This is " .. self:GetBuyer():Nick() .. "'s gun. You cannot take it." )
			end
		end
	end
end
		
function ENT:WindUp( )
	local gun
	if self.ScrollWepList then
		gun = weapons.Get(self.ScrollWepList[math.random(#self.ScrollWepList)])
	else
		gun = table.Random(weapons.GetList())
	end

	if gun and gun.WorldModel != nil then
		self:SetModel(gun.WM or gun.WorldModel)
	end
end

function ENT:TeddyFlyUp()
	self.t = self.t + 1
	if self.t > 25 then
		self.Box:Close()
		self.Box:MoveAway()
		self:Remove()
		self.t = 25
	end
end

function ENT:WindDown()
end

function ENT:Think()
	if CLIENT and DynamicLight then
		local dlight = dlight or DynamicLight(self:EntIndex(), false)
		if dlight then
			dlight.pos = self:GetPos()
			dlight.r = self:GetSharing() and 80 or 255
			dlight.g = 255
			dlight.b = self:GetSharing() and 40 or 160
			dlight.brightness = 1
			dlight.Decay = 1000
			dlight.Size = 256
			dlight.dietime = CurTime() + 1
		end
	end

	if SERVER then
		if self:GetIsTeddy() then
			self:TeddyFlyUp()
		elseif self:GetWinding() then
			self:WindUp()
		else
			self:WindDown()
		end
	end

	self:NextThink(CurTime() + self:GetThinkRate())
	return true
end

function ENT:OnTakeDamage(dmginfo)
	local ply = dmginfo:GetAttacker()
	if not IsValid(ply) or not ply:IsPlayer() or self:GetWinding() or self:GetSharing() then return end

	if ply == self:GetBuyer() and bit.band(dmginfo:GetDamageType(), bit.bor(DMG_SLASH, DMG_CLUB, DMG_CRUSH)) ~= 0 then
		ParticleEffectAttach("nz_magicbox_sharing", PATTACH_ABSORIGIN_FOLLOW, self, 1)
		self:SetSharing(true)
	end
end

if CLIENT then
	function ENT:Draw()
		-- If we've stopped winding
		if !self:GetWinding() then
			-- We can use the stored world model draw function from the original weapon, but if it doesn't exist or causes errors, then just draw model
			if !self.WorldModelFunc or !pcall(self.WorldModelFunc, self) then self:DrawModel() end
		else
			self:DrawModel()
		end
	end
end
