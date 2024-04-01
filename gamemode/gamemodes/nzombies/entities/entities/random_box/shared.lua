AddCSLuaFile()

ENT.Type = "anim"

ENT.PrintName = "random_box"
ENT.Author = "Fox"
ENT.Contact = "dont"
ENT.Purpose = ""
ENT.Instructions = ""

game.AddParticles("particles/mysterybox.pcf")
game.AddParticles("particles/moo_misc_fx.pcf")

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Open")
	self:NetworkVar("Bool", 1, "Activated")

	self:NetworkVar("Float", 0, "ActivateTime")


	self:NetworkVarNotify("Open", self.OnOpenChanged)
end

function ENT:PhysicsCollide(data, phys)
end

function ENT:Initialize()

	self.AutomaticFrameAdvance = true
	self:PhysicsInit(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:SetSolid(SOLID_VPHYSICS)

	self:SetPos(self:GetPos() - self:GetRight()*7.5)
	self:DrawShadow(false)
	self:SetOpen(false)
	self:SetActivated(false)
	self:SetActivateTime(CurTime() + 6)
	self.Moving = false
	self.Price = 950

	self.ShouldRemoveSelf = false

	self:SetTargetPriority(TARGET_PRIORITY_MONSTERINTERACT) -- This inserts the it into the target array.

	self:Activate()

	if SERVER then
		self:SetUseType(SIMPLE_USE)
		self:SetTrigger(true)

		if !nzPowerUps:IsPowerupActive("firesale") then
			nzRandomBox:ResetBoxUses()
		end
	end

	local box = "models/nzr/2022/magicbox/bo2/magic_box.mdl"
	local nzmapsettings = nzMapping.Settings.boxtype
	local result

	local boxmdl = {
		["UGX Coffin"] = function() 
			box = "models/wavy_ports/ugx/ugx_coffin_box.mdl"
			return box
		end,
		["Black Ops 3"] = function() 
			box = "models/moo/_codz_ports_props/t7/_sumpf/p7_zm_shi_magic_box/moo_codz_p7_zm_magic_box.mdl"
			return box
		end,
		["Black Ops 3(Quiet Cosmos)"] = function() 
			box = "models/moo/_codz_ports_props/t7/_sumpf/p7_zm_shi_magic_box/moo_codz_p7_zm_magic_box.mdl"
			return box
		end,
		["Mob of the Dead"] = function() 
			box = "models/moo/_codz_ports_props/t6/alcatraz/p6_anim_zm_al_magic_box/moo_codz_t6_al_magic_box.mdl"
			return box
		end,
		["Verruckt"] = function() 
			box = "models/nzr/2022/magicbox/bo2/magic_box.mdl"
			return box
		end,
		["Nacht Der Untoten"] = function() 
			box = "models/nzr/2022/magicbox/bo2/magic_box.mdl"
			return box
		end,
		["Original"] = function() 
			box = "models/nzr/2022/magicbox/bo2/magic_box.mdl"
			return box
		end,
	}

	if isstring(nzmapsettings) then
		result = boxmdl[nzmapsettings](box)
	end

	if isstring(result) then
		box = result
	end

	self:SetModel(box)

	if (nzMapping.Settings.boxtype == "Black Ops 3") or (nzMapping.Settings.boxtype) == "Black Ops 3(Quiet Cosmos)" then
		self:SetAngles( self:GetAngles() + Angle(0,90,0))
	end

	local seq = self:LookupSequence("arrive")
	self:ResetSequence(seq)
	
	if (nzMapping.Settings.boxtype == "Mob of the Dead") then
		ParticleEffectAttach("hellbox_plat_sidefire",PATTACH_POINT_FOLLOW,self,2)
		ParticleEffectAttach("hellbox_plat_sidefire",PATTACH_POINT_FOLLOW,self,3)
		ParticleEffectAttach("hellbox_plat_sidefire",PATTACH_POINT_FOLLOW,self,4)
	end

	if (nzMapping.Settings.boxtype) == "Black Ops 3(Quiet Cosmos)" then
		self:SetSkin(1)
	end

	if CLIENT then
		self:CreateBeam()
	end
end

function ENT:Use(activator, caller)
	if self:GetOpen() and IsValid(self.BoxWeapon) then
		self.BoxWeapon:Use( activator, caller)
		return
	end

	if self:GetOpen() or (not self:GetActivated()) or self.Moving then return end

	if activator:CanAfford(self:GetPrice()) then
		self:BuyWeapon(activator)

		if !nzPowerUps:IsPowerupActive("firesale") then
			nzRandomBox:IncreaseBoxUses()
		end
	end
end

function ENT:GetPrice()
	if nzPowerUps:IsPowerupActive("firesale") then
		return 10
	else
		return self.Price
	end
end

function ENT:BuyWeapon(ply)
	ply:Buy(self:GetPrice(), self, function()
        local class = nzRandomBox.DecideWep(ply)

        if class != nil then
      		self:Open()
      		self:SpawnWeapon(ply, class)
			return true
        else
            ply:PrintMessage( HUD_PRINTTALK, "No available weapons left!")
			return false
        end
	end)
end

function ENT:Open()
	local sequence = self:LookupSequence("open")
	self:ResetSequence(sequence)
	self:SetOpen(true)

	self:CreateOpenEffect()
	//ParticleEffectAttach("nz_magicbox", PATTACH_POINT_FOLLOW, self, 1)
end

function ENT:Close()
	local sequence = self:LookupSequence("close")
	self:ResetSequence(sequence)
	self:SetOpen(false)
	--self:StopParticles()
	self:RemoveOpenEffect()
end

function ENT:SpawnWeapon(activator, class)
	local wep = ents.Create("random_box_windup")
	local angles = self:GetAngles()
	local pos = self:GetPos() + self:GetUp()*6

	if (nzMapping.Settings.boxtype == "Mob of the Dead") then
		pos = self:GetPos() + self:GetUp()*14
	elseif (nzMapping.Settings.boxtype == "Black Ops 3") or (nzMapping.Settings.boxtype) == "Black Ops 3(Quiet Cosmos)" then
		angles = self:GetAngles() - Angle(0,90,0)
	end
	
	if (nzMapping.Settings.boxtype == "UGX Coffin") then
		pos = self:GetPos() + self:GetUp()*42
	end

	wep:SetAngles(angles)
	wep:SetPos(pos)
	wep:SetWepClass(class)
	wep:SetBuyer(activator)

	wep:Spawn()

	wep.Box = self
	self.BoxWeapon = wep

	if activator:HasPerk("time") then
		self:EmitSound("nz_moo/effects/box_jingle_timeslip.mp3")
	else
		nzSounds:PlayEnt("Jingle", self)
	end
end

function ENT:Think()
	if CLIENT and DynamicLight then
		local dlight = dlight or DynamicLight(self:EntIndex(), false)
		local color = nzMapping.Settings.boxlightcolor
		if self:GetActivated() and dlight and !self:GetOpen() then
			--dlight.pos =  self:GetPos() + self:GetUp()*10
			dlight.pos = (nzMapping.Settings.boxtype == "UGX Coffin" and self:GetPos() + self:GetUp()*50 or self:GetPos() + self:GetUp()*10) 
			dlight.r = color.r
			dlight.g = color.g
			dlight.b = color.b
			dlight.brightness = 1
			dlight.Decay = 1000
			dlight.Size = 256
			dlight.dietime = CurTime() + 1
		end
	end

	if SERVER then
		if not self:GetActivated() and self:GetActivateTime() < CurTime() and !self.Moving then
			self:SetActivated(true)
		end

		if self.MarkedForRemoval and !self:GetOpen() then
			self:Remove()
		end

		if self.ShouldRemoveSelf and !nzPowerUps:IsPowerupActive("firesale") then -- A failsafe that should HOPEFULLY stop the Box from dupping itself if a firesale is picked up while its leaving.
			if !self.BeginMove then
				self.BeginMove = true

				print("Box Moved!")

				self.MoveDelay = CurTime() + 0.25
			else
				if self.MoveDelay and self.MoveDelay < CurTime() then
					self:MoveToNewSpot(self.SpawnPoint)
					self:Remove()
				end
			end
		end

		if IsValid(self.SpawnPoint) and !self.SpawnPointAnim then
			self.SpawnPointAnim = true
			if (nzMapping.Settings.boxtype == "UGX Coffin") then
			ParticleEffect("doom_hellunit_spawn_medium",self:GetPos(),self:GetAngles(),self)
			end
			if self.SpawnPoint:LookupSequence("arrive") > 0 then
				self.SpawnPoint:ResetSequence("arrive")
			end
		end

		if self:GetOpen() ~= self.IsOpen then
			self.IsOpen = self:GetOpen()
			if self.IsOpen then
				self:CreateOpenEffect()
			else
				self:RemoveOpenEffect()
			end
		end
	end

	self:NextThink(CurTime())
	return true
end

function ENT:MoveAway()
	nzPowerUps.BoxMoved = true
	self.Moving = true
	
	if (nzMapping.Settings.boxtype == "UGX Coffin") then
	ParticleEffect("doom_hellunit_spawn_small",self:GetPos(),self:GetAngles(),self)
	end

	local seq, dur = self:LookupSequence("leave")
	self:ResetSequence(seq)
	self:SetActivated(false)

	if self.SpawnPoint:LookupSequence("leave") > 0 then
		self.SpawnPoint:ResetSequence(seq)
	end

	timer.Simple(0.25, function()
		if not IsValid(self) then return end
		nzSounds:Play("Bye")
	end)

	timer.Simple(dur, function()
		if not IsValid(self) then return end

		self.Moving = false
		self.SpawnPoint.Box = nil

		self.ShouldRemoveSelf = true
		
		self:SetOpen(true)
		self:SetNoDraw(true)

		if CLIENT then
			if IsValid(self.Light) then
				self.Light:Remove()
			end
		end
	end)
end

function ENT:MoveToNewSpot(oldspot)
	nzRandomBox.Spawn(oldspot)
end

function ENT:MarkForRemoval()
	self.MarkedForRemoval = true
end

function ENT:OnRemove()

	self:RemoveBeam()

	if CLIENT then
		if IsValid(self.Light) then
			self.Light:Remove()
		end
	else
		self.SpawnPoint:SetBodygroup(1,0)
	end
end



if SERVER then
	function ENT:UpdateTransmitState() return TRANSMIT_ALWAYS end
else

	function ENT:Draw()
		self:DrawModel()

		if self:GetOpen() and ((nzMapping.Settings.boxtype == "Black Ops 3") or (nzMapping.Settings.boxtype == "Mob of the Dead") or (nzMapping.Settings.boxtype == "Black Ops 3(Quiet Cosmos)")) then
			self:DrawBoxOpenFill() -- You can override the effect here
		end
	end


	local m = Material("nzombies-unlimited/particle/light_glow_square")
	local w,h = 92, 26 -- The width and height of the box's light area
	function ENT:DrawBoxOpenFill()
		local x = -h/2
		local y = -w/2
		local h2 = h/2
		local color = nzMapping.Settings.boxlightcolor

		local boxmod = 10
		local angles = self:GetAngles()

		if (nzMapping.Settings.boxtype == "Mob of the Dead") then
			boxmod = 20
			angles = self:GetAngles() + Angle(0,90,0)
		end

		for i = 1,5 do
			cam.Start3D2D(self:GetPos() + self:GetUp() * (boxmod + i), angles, 1)
				surface.SetMaterial(m)
				surface.SetDrawColor(color.r, color.g, color.b, 150)
				--surface.DrawRect(-10,-44,20,88)
				--surface.SetDrawColor(255,255,255)
				surface.DrawTexturedRectUV(x,y, h, h2, 0,0,1,0.5)
				surface.DrawTexturedRectUV(x,y + h2, h, w - h, 0,0.5,1,0.5)
				surface.DrawTexturedRectUV(x,w - w/2 - h2, h, h2, 0,0.5,1,1)
			cam.End3D2D()
		end
	end
end
-- hellbox_plat_sidefire_a
function ENT:OnOpenChanged(_, old, new)
	if new then
		self:CreateOpenEffect()
		--self:OnOpen()
	else
		self:RemoveOpenEffect()
		--self:OnClosed()
	end
end

function ENT:CreateBeam()
	if CLIENT then
		local color = nzMapping.Settings.boxlightcolor
		local p = CreateParticleSystem(self, "mysterybox_beam", PATTACH_ABSORIGIN_FOLLOW)
		p:SetControlPoint(2, Vector(color.r/255, color.g/255, color.b/255)) -- Color
		p:SetControlPoint(0, self:GetPos()) -- Bottom position
		p:SetControlPoint(1, self:GetPos() + Vector(0,0,4000)) -- Top position
		self.Beam = p
	end
end

function ENT:RemoveBeam()
	if CLIENT then
		if IsValid(self.Beam) then
			self.Beam:StopEmission(false, true)
			self.Beam = nil
		end
	end
end

function ENT:CreateOpenEffect()
	if (nzMapping.Settings.boxtype == "Black Ops 3") or (nzMapping.Settings.boxtype) == "Black Ops 3(Quiet Cosmos)" then
		if CLIENT then
			local color = nzMapping.Settings.boxlightcolor
			local p = CreateParticleSystem(self, "mysterybox_roll", PATTACH_ABSORIGIN_FOLLOW)
			p:SetControlPoint(2, Vector(color.r/255, color.g/255, color.b/255)) -- Color
			self.OpenEffect = p
		end
	end
end

function ENT:RemoveOpenEffect()
	if (nzMapping.Settings.boxtype == "Black Ops 3") or (nzMapping.Settings.boxtype) == "Black Ops 3(Quiet Cosmos)" then
		if CLIENT then
			if IsValid(self.OpenEffect) then
				self.OpenEffect:StopEmission(false, true)
				self.OpenEffect = nil
			end
		end
	end
end
