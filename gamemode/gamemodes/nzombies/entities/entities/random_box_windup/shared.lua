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
	local speed = self:GetBuyer():HasPerk("time")

	self:SetMoveType(MOVETYPE_NOCLIP)
	--self:SetLocalVelocity(self:GetAngles():Up() * (speed and 19 or 6))
	self:SetSolid(SOLID_OBB)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:DrawShadow(false)

	self:SetWinding(true)
	self:SetIsTeddy(false)
	self:SetSharing(false)

	self.WindupTime = speed and 1.5 or 4.5

	self.WindupMovement = Vector(0,0,30)
	self.WindDownMovement = Vector(0,0,-20)

	self.TeddyVelocity = Vector(0,0,50)
	self.TeddyVelocityCoffin = Vector(0,0,-30)
	
	self.WindingTime = CurTime() + self.WindupTime
	
	if !(nzMapping.Settings.boxtype == "UGX Coffin") then
		self:SetLocalVelocity(self.WindupMovement/self.WindupTime)
	end
	
	if (nzMapping.Settings.boxtype == "UGX Coffin") then
		self:SetAngles(Angle(-90,-90,0))
		--self:SetPos(Vector(0,0,0))
	end

	self:SetModel("models/weapons/w_rif_ak47.mdl")

	if SERVER then
		if nzMapping.Settings.rboxweps then
			self.ScrollWepList = table.GetKeys(nzMapping.Settings.rboxweps)
		end
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
		if (nzMapping.Settings.boxtype == "UGX Coffin") then
		self:EmitSound("nz_moo/mysterybox/ugx_coffin/box_boom.mp3", 300, 100, 1)
		end
	end
	
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
	
	-- NO MORE TIMERS!!! USING nZU CODE ONCE MORE!!!

	if SERVER then
		if self:GetIsTeddy() then
			if self.TeddyFlyTime and self.TeddyFlyTime < CurTime() then
				if !(nzMapping.Settings.boxtype == "UGX Coffin") then
				self:SetLocalVelocity(self.TeddyVelocity)
			else
				self:SetLocalVelocity(self.TeddyVelocityCoffin)
			end

				if self.RemoveTime < CurTime() then
					if IsValid(self.Box) then
						self.Box:Close()
						self.Box:MoveAway()
					end
					self:Remove()
				end
			end
		elseif self:GetWinding() then
			if self.WindingTime > CurTime() then
				self:WindUp()
				if !(nzMapping.Settings.boxtype == "UGX Coffin") then
					self:NextThink(CurTime() + 0.2/(self.WindingTime - CurTime()))
					else
					self:NextThink(CurTime() + 0.1*(self.WindingTime - CurTime()))
					end
				return true 
			end
		else
			if self.ReturnTime and self.ReturnTime < CurTime() then
				local timeleft = math.Clamp(self.RemoveTime - CurTime(), 4, self.RemoveTime)
					self:SetLocalVelocity(self.WindDownMovement/timeleft)

				if self.ShareTime < CurTime() and !self:GetSharing() and #player.GetAllPlaying() > 1 then
					ParticleEffectAttach("nz_magicbox_sharing", PATTACH_ABSORIGIN_FOLLOW, self, 1)
					self:SetSharing(true)
				end

				if self.RemoveTime < CurTime() then
					self:Remove()
					if IsValid(self.Box) then
						self.Box:Close()
					end
				end
			end
		end
		if not self.Finalized then
			self.Finalized = true
			self:SetWinding(false)
			self:SetLocalVelocity(Vector(0,0,0)) -- Stop

			if self:GetWepClass() == "nz_box_teddy" then
				local angle = self.Box:GetAngles() + Angle(-90,90,0)
				if (nzMapping.Settings.boxtype == "Black Ops 3") or (nzMapping.Settings.boxtype) == "Black Ops 3(Quiet Cosmos)" then
					self:SetModel("models/moo/_codz_ports_props/t7/_der/p7_zm_teddybear/moo_codz_p7_teddybear.mdl")
					angle = self.Box:GetAngles() + Angle(-90,0,0)
				else
					self:SetModel("models/moo/_codz_ports_props/t6/global/zombie_teddybear/moo_codz_p6_teddybear.mdl")
				end

				self:SetAngles( angle )

				self.TeddyFlyTime = CurTime() + 2
				self.RemoveTime = CurTime() + 5

				nzSounds:Play("Laugh")
				self:SetIsTeddy(true)
				if IsValid(self:GetBuyer()) then self:GetBuyer():GivePoints(950) end -- Refund please
			else
				local wep = weapons.Get(self:GetWepClass())
				self:SetModel(wep.WM or wep.WorldModel)

				self.ReturnTime = CurTime() + 3
				self.RemoveTime = CurTime() + 12
				self.ShareTime = CurTime() + 6
			end
		end
	end
end

function ENT:OnTakeDamage(dmginfo)
	local ply = dmginfo:GetAttacker()
	if not IsValid(ply) or not ply:IsPlayer() or self:GetWinding() or self:GetSharing() then return end

	if ply == self:GetBuyer() and bit.band(dmginfo:GetDamageType(), bit.bor(DMG_SLASH, DMG_CLUB, DMG_CRUSH)) ~= 0 then
		ParticleEffectAttach("nz_magicbox_sharing", PATTACH_ABSORIGIN_FOLLOW, self, 1)
		self:SetSharing(true)
	end
end

function ENT:OnRemove()
	if IsValid(self.Box) then
		local box = self.Box
		if box.BoxWeapon == self then
			box.BoxWeapon = nil
		end
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
