AddCSLuaFile( )

ENT.Type = "anim"

ENT.PrintName		= "buy_gun_area"
ENT.Author			= "Alig96 & Zet0r"
ENT.Contact			= "Don't"
ENT.Purpose			= ""
ENT.Instructions	= ""

function ENT:SetupDataTables()
	self:NetworkVar( "String", 0, "WepClass" )
	self:NetworkVar( "String", 1, "Price" )
	self:NetworkVar( "Bool", 0, "Bought" )
	self:NetworkVar( "Bool", 1, "Flipped" )
	self:NetworkVar( "Bool", 2, "Hacked" )
end

local flipscale = Vector(0.85, 0.01, 0.85) 	-- Decides on which axis it flattens the outline
local oldflipscale = Vector(1.5, 0.01, 1.5) -- Decides on which axis it flattens the outline
local normalscale = Vector(0.01, 0.85, 0.85) 	-- based on the bool self:GetFlipped()

if GetConVar("nz_wallbuy_lod") == nil then
	CreateClientConVar("nz_wallbuy_lod", 4, true, false, "Chalk Outline level of detail.(4 High, 3-2 Medium, 1 Low, 0 No Chalk) Default is 4.", 0, 4)
end
if GetConVar("nz_wallbuy_legacy") == nil then
	CreateClientConVar("nz_wallbuy_legacy", 1, true, false, "Use the oldschool huge chalk wallbuys. Requires reloading the config to apply. (1 Enabled, 0 Disabled) Default is 1.", 0, 1)
end

chalkmaterial = Material("chalk.png", "VertexLitGeneric")

function ENT:Initialize()
	if SERVER then
		self:SetMoveType( MOVETYPE_NONE )
		--self:SetSolid( SOLID_VPHYSICS )
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
		self:SetUseType(SIMPLE_USE)
		self:SetFlipped(true) -- Apparently makes it work with default orientation?
		self:SetSolid( SOLID_OBB )
		self:PhysicsInit( SOLID_OBB )
	else
		self.Flipped = self:GetFlipped()
		local wep = weapons.Get(self:GetWepClass())
		if wep then
			if wep.DrawWorldModel then self.WorldModelFunc = wep.DrawWorldModel end
			
			-- Forced precaching!
			local model = ClientsideModel("models/hoff/props/teddy_bear/teddy_bear.mdl")
			util.PrecacheModel(wep.VM or wep.ViewModel)
			model:SetModel(wep.ViewModel)
			if wep.VM then model:SetModel(wep.VM) end
			model:Remove()
			
			self:RecalculateModelOutlines()
		end
	end
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:DrawShadow(false)
end

function ENT:OnRemove()
	if CLIENT then
		self:RemoveOutline()
	end
end

function ENT:RecalculateModelOutlines()
	chalkmaterial = Material("chalk.png", "VertexLitGeneric")
	self:RemoveOutline()
	local num = GetConVar("nz_wallbuy_lod"):GetInt()
	local ang = self:GetAngles()
	local curang = self:GetAngles() -- Modifies offset if flipped
	local curpos = self:GetPos()
	local wep = weapons.Get(self:GetWepClass())
	if !wep then self:RemoveOutline() return end
	local model = wep.WM or wep.WorldModel

	-- Precache the model whenever it changes, including on spawn
	util.PrecacheModel(wep.WM or wep.WorldModel)

	self.modelclass = self:GetWepClass()

	if !self.Flipped then
		curang:RotateAroundAxis(curang:Up(), 90)
	end

	if num >= 1 then
		self.Chalk1 = ClientsideModel(model)
		local offset = curang:Up()*0.5 + curang:Forward()*-0.5 --Vector(0,-0.5,0.5)
		self.Chalk1:SetPos(curpos + offset)
		self.Chalk1:SetAngles(ang)
		self.Chalk1:SetMaterial("chalk.png")

		local mat = Matrix()
		if GetConVar("nz_wallbuy_legacy"):GetInt() == 0 then
			mat:Scale( self.Flipped and flipscale or normalscale )
		else
			mat:Scale( self.Flipped and oldflipscale or normalscale )
		end

		self.Chalk1:EnableMatrix( "RenderMultiply", mat )
		self.Chalk1:SetNoDraw(true)
		self.Chalk1:SetParent(self)
	end

	if num >= 2 then
		self.Chalk2 = ClientsideModel(model)
		offset = curang:Up()*-0.5 + curang:Forward()*0.5
		self.Chalk2:SetPos(curpos + offset)
		self.Chalk2:SetAngles(ang)
		self.Chalk2:SetMaterial("chalk.png")

		local mat = Matrix()
		if GetConVar("nz_wallbuy_legacy"):GetInt() == 0 then
			mat:Scale( self.Flipped and flipscale or normalscale )
		else
			mat:Scale( self.Flipped and oldflipscale or normalscale )
		end

		self.Chalk2:EnableMatrix( "RenderMultiply", mat )
		self.Chalk2:SetNoDraw(true)
		self.Chalk2:SetParent(self)
	end

	if num >= 3 then
		self.Chalk3 = ClientsideModel(model)
		offset = curang:Up()*0.5 + curang:Forward()*0.5
		self.Chalk3:SetPos(curpos + offset)
		self.Chalk3:SetAngles(ang)
		self.Chalk3:SetMaterial("chalk.png")

		local mat = Matrix()
		if GetConVar("nz_wallbuy_legacy"):GetInt() == 0 then
			mat:Scale( self.Flipped and flipscale or normalscale )
		else
			mat:Scale( self.Flipped and oldflipscale or normalscale )
		end

		self.Chalk3:EnableMatrix( "RenderMultiply", mat )
		self.Chalk3:SetNoDraw(true)
		self.Chalk3:SetParent(self)
	end
		
	if num >= 4 then
		self.Chalk4 = ClientsideModel(model)
		offset = curang:Up()*-0.5 + curang:Forward()*-0.5
		self.Chalk4:SetPos(curpos + offset)
		self.Chalk4:SetAngles(ang)
		self.Chalk4:SetMaterial("chalk.png")

		local mat = Matrix()
		if GetConVar("nz_wallbuy_legacy"):GetInt() == 0 then
			mat:Scale( self.Flipped and flipscale or normalscale )
		else
			mat:Scale( self.Flipped and oldflipscale or normalscale )
		end

		self.Chalk4:EnableMatrix( "RenderMultiply", mat )
		self.Chalk4:SetNoDraw(true)
		self.Chalk4:SetParent(self)
	end
		
	if num >= 1 then
		self.ChalkCenter = ClientsideModel(model)
		self.ChalkCenter:SetPos(curpos)
		self.ChalkCenter:SetAngles(ang)
		self.ChalkCenter:SetMaterial("chalk.png")

		local mat = Matrix()
		if GetConVar("nz_wallbuy_legacy"):GetInt() == 0 then
			mat:Scale( self.Flipped and flipscale or normalscale )
		else
			mat:Scale( self.Flipped and oldflipscale or normalscale )
		end

		self.ChalkCenter:EnableMatrix( "RenderMultiply", mat )
		self.ChalkCenter:SetNoDraw(true)
		self.ChalkCenter:SetParent(self)
	end
end

function ENT:RemoveOutline()
	if IsValid(self.Chalk1) then
		self.Chalk1:Remove()
	end
	if IsValid(self.Chalk2) then
		self.Chalk2:Remove()
	end
	if IsValid(self.Chalk3) then
		self.Chalk3:Remove()
	end
	if IsValid(self.Chalk4) then
		self.Chalk4:Remove()
	end
	if IsValid(self.ChalkCenter) then
		self.ChalkCenter:Remove()
	end
end

if SERVER then
	function ENT:SetWeapon(weapon, price)
		-- Add a special check for FAS weps
		local price = price or self:GetPrice()
		local wep = weapons.Get(weapon)
		self.wop = wep
		local model
		if !wep then
			model = "models/weapons/w_crowbar.mdl"
		else
			model = wep.WM or wep.WorldModel
		end

		self:SetModel(model)

		if GetConVar("nz_wallbuy_legacy"):GetInt() == 0 then
			self:SetModelScale( 0.85, 0 )
		else
			self:SetModelScale( 1.5, 0)
		end
		
		self.WeaponGive = weapon
		self.Price = price
		self:SetWepClass(weapon)
		self:SetPrice(price)
		self.upgrade = ""
		self.upgrade2 = ""
		if wep.NZPaPReplacement then
			self.upgrade = wep.NZPaPReplacement
			local wep2 = weapons.Get(wep.NZPaPReplacement)
			if wep2.NZPaPReplacement then
				self.upgrade2 = wep2.NZPaPReplacement
			end
		end
		self.savegun = 0
	end

	function ENT:ToggleRotate()
		local ang = self:GetAngles()
		self:SetFlipped(!self:GetFlipped())
		ang:RotateAroundAxis(ang:Up(), 90)
		self:SetAngles(ang)
	end

	function ENT:Use( activator, caller )
		local price = self.Price

		local wep
		for k,v in pairs(activator:GetWeapons()) do
			if v:GetClass() == self.WeaponGive then wep = v break end
		end

		if !wep then wep = weapons.Get(self.WeaponGive) end
		if !wep then return end

		local giveboolet = false
		local ammo_type = wep.Primary.Ammo
		local ammo_price = self:GetHacked() and 4500 or math.ceil((price - (price % 10))/2)
		local ammo_price_pap = self:GetHacked() and math.ceil((price - (price % 10))/2) or 4500
		local max_ammo = wep.Primary.MaxAmmo and wep.Primary.MaxAmmo or nzWeps:CalculateMaxAmmo(self.WeaponGive)
		local curr_ammo = activator:GetAmmoCount(ammo_type)
		local give_ammo = max_ammo - curr_ammo

		if self:GetWepClass() == "tfa_bo1_m67" then 
			ammo_type = "nz_grenade"
			ammo_price = activator:HasPerk("widowswine") and 4500 or 250
		end

		if activator:HasWeapon(self.upgrade) then
			giveboolet = true
			self.saveGun = 1
		end

		if activator:HasWeapon(self.upgrade2) then
			giveboolet = true
			self.saveGun = 2
		end

		if !activator:HasWeapon(self.WeaponGive) and !giveboolet then
			if nzRound:InState(ROUND_CREATE) then
				price = 0
			end
			activator:Buy(price, self, function()
				self:SetBought(true)
				activator:EmitSound("nz_moo/effects/rarities/evt_weapon_common.mp3", SNDLVL_TALKING)

				if self.WeaponGive == "tfa_bo1_m67" then
					activator:SetAmmo(4, "nz_grenade")
					activator:TakePoints(ammo_price)
					return false
				else
					local wep = activator:Give(self.WeaponGive)
					if wep:GetSpecialCategory() == "specialgrenade" then
						activator:SetAmmo(3, "nz_specialgrenade")
					end
				end

				return true
			end)
		elseif string.lower(ammo_type) != "none" and ammo_type != -1 then
			if giveboolet then
				if self.saveGun == 1 then
					self.wop = activator:GetWeapon(self.upgrade)
				end
				if self.saveGun == 2 then
					self.wop = activator:GetWeapon(self.upgrade2)
				end
			else
				self.wop = activator:GetWeapon(self.WeaponGive)
			end

			if self.WeaponGive == "tfa_bo1_m67" then
				if not self:GetBought() then
					self:SetBought(true)
					activator:EmitSound("nz_moo/effects/rarities/evt_weapon_common.mp3", SNDLVL_TALKING)
				end

				activator:SetAmmo(4, "nz_grenade")
				activator:TakePoints(ammo_price)
				return true
			else
				if not self:GetBought() then
					self:SetBought(true)
					activator:EmitSound("nz_moo/effects/rarities/evt_weapon_common.mp3", SNDLVL_TALKING)
				end

				local wep = activator:GetWeapon(self.WeaponGive)
				if IsValid(wep) and wep:GetSpecialCategory() == "specialgrenade" then
					activator:SetAmmo(3, "nz_specialgrenade")
				end
			end

			if self.wop:HasNZModifier("pap") then
				activator:Buy(ammo_price_pap, self, function()
					if give_ammo != 0 or self.wop:Clip1() < self.wop.Primary.ClipSize then
						self.wop:GiveMaxAmmo()
						return true
					else
						print("Max Clip!")
						return false
					end
				end)
			else
				activator:Buy(ammo_price, self, function()
					if give_ammo != 0 or self.wop:Clip1() < self.wop.Primary.ClipSize then
						self.wop:GiveMaxAmmo()
						return true
					else
						print("Max Clip!")
						return false
					end
				end)
			end
		end

		giveboolet = false
		return
	end
end


if CLIENT then
	function ENT:Update()
		local wep = weapons.Get(self:GetWepClass())
		if wep then
			if wep.DrawWorldModel then self.WorldModelFunc = wep.DrawWorldModel end
			util.PrecacheModel(wep.WM or wep.WorldModel)
			self:RecalculateModelOutlines()
		end
		self.OutlineGiveUp = 0
	end

	function ENT:Think()
		if self.Flipped != self:GetFlipped() then
			self.Flipped = self:GetFlipped()
			self:RecalculateModelOutlines()
		end
		if self.modelclass != self:GetWepClass() then
			self.modelclass = self:GetWepClass()
			self:Update()
		end
	end

	local glow = Material( "sprites/light_ignorez" )
	local white = Color(0,200,255,0)
	
	function ENT:Draw()
		local ply = LocalPlayer()
		if not IsValid(ply) then return end
		local eyepos = ply:EyePos()
		local eyeang = ply:EyeAngles()

		local num = GetConVar("nz_wallbuy_lod"):GetInt()
		if num < 1 or (self.OutlineGiveUp and self.OutlineGiveUp > 5) then
			-- If we don't have a function or it errors, call default DrawModel
			if !self.WorldModelFunc or !pcall(self.WorldModelFunc, self) then
				self:DrawModel()
			end
		else
			local pos = eyepos + eyeang:Forward()*10
			local ang = eyeang
			ang = Angle(ang.p+90,ang.y,0)

			if halo.RenderedEntity() != self then
				render.ClearStencil()
				render.SetStencilEnable(true)
				render.SetStencilWriteMask(255)
				render.SetStencilTestMask(255)
				render.SetStencilReferenceValue(15)
				render.SetStencilFailOperation(STENCILOPERATION_KEEP)
				render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
				render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
				render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_ALWAYS)
				render.SetBlend(0)

				for i = 1, num do
					-- If it isn't valid (NULL ENTITY), attempt to recreate
					if !IsValid(self["Chalk"..i]) then 
						self:RecalculateModelOutlines()
						-- Log how many tries we did, we'll give up after 5 and just draw the model :(
						self.OutlineGiveUp = self.OutlineGiveUp and self.OutlineGiveUp + 1 or 1
						break 
					end
					self["Chalk"..i]:DrawModel()
				end

				render.SetStencilPassOperation(STENCILOPERATION_ZERO) -- Make it deselect the center model
				if !IsValid(self["ChalkCenter"]) then 
					self:RecalculateModelOutlines()
					self.OutlineGiveUp = self.OutlineGiveUp and self.OutlineGiveUp + 1 or 1
				else
					self.ChalkCenter:DrawModel()
				end

				render.SetBlend(1)
				render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
				cam.Start3D2D(pos,ang,1)
					/*local price = self.Price
					surface.SetDrawColor(0,0,0)
					if price > 7500 then
						surface.SetDrawColor(255,240,165)
					elseif price <= 7500 then
						surface.SetDrawColor(255,201,165)
					elseif price <= 3000 then
						surface.SetDrawColor(226,165,255)
					elseif price <= 1500 then
						surface.SetDrawColor(165,179,255)
					elseif price <= 750 then
						surface.SetDrawColor(192,255,165)
					end*/

					surface.SetDrawColor(color_white)
					surface.DrawRect(-ScrW(),-ScrH(),ScrW()*2,ScrH()*2)
					//surface.SetMaterial(chalkmaterial)
					//surface.DrawTexturedRect(-ScrW(),-ScrH(),ScrW()*2,ScrH()*2)
				cam.End3D2D()
				render.SetStencilEnable(false)
			end

			//alot of this was commented out, so i just decided to nuke the whole thing so theres less cam.start calls

			/*local wsc = self:WorldSpaceCenter()
			local wsp = self:GetPos()

			local spritepos = self:GetFlipped() and Vector(wsp.x, wsc.y, wsc.z) or Vector(wsc.x, wsp.y, wsc.z)
			local spriteang = self:GetFlipped() and self:GetAngles() + Angle(180,10,-90) or self:GetAngles() + Angle(0,90,90)
			cam.Start3D()
				render.SetMaterial( glow )
				render.DrawSprite( spritepos + (pos-spritepos):GetNormalized()*5, 200, 100, white)
			cam.End3D()

			cam.Start3D2D(spritepos, spriteang, 1)
				surface.SetMaterial(glow)
				surface.SetDrawColor(white)
				surface.DrawTexturedRect(-50,-25,100,50)
				surface.DrawTexturedRectUV(-50,-25,50,50,0,0,0.5,1)
			cam.End3D2D()

			debugoverlay.Line(spritepos, spritepos + spriteang:Forward()*15, 1, Color(0,255,0))
			debugoverlay.Line(spritepos, spritepos + spriteang:Right()*5, 1, Color(0,255,0))

			spriteang:RotateAroundAxis(spriteang:Right(),20)

			debugoverlay.Line(spritepos, spritepos + spriteang:Forward()*15, 1, Color(255,0,0))
			debugoverlay.Line(spritepos, spritepos + spriteang:Right()*5, 1, Color(255,0,0))

			cam.Start3D2D(spritepos, spriteang, 1)
				surface.SetMaterial(glow)
				surface.SetDrawColor(white)
				surface.DrawTexturedRect(-50,-25,100,50)
				surface.DrawTexturedRectUV(0,-25,50,50,0.5,0,1,1)
			cam.End3D2D()*/

			if self:GetBought() then
				if !self.WorldModelFunc or !pcall(self.WorldModelFunc, self) then
					self:DrawModel()
				end
			end
		end
	end
end