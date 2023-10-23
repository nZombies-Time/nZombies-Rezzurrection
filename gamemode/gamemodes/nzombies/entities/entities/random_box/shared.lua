AddCSLuaFile()

ENT.Type = "anim"

ENT.PrintName = "random_box"
ENT.Author = "Fox"
ENT.Contact = "dont"
ENT.Purpose = ""
ENT.Instructions = ""

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Open")
	self:NetworkVar("Bool", 1, "Activated")

	self:NetworkVar("Float", 0, "ActivateTime")
end

function ENT:PhysicsCollide(data, phys)
end

function ENT:Draw()
	self:DrawModel()
end

function ENT:Initialize()
self:SetTargetPriority(TARGET_PRIORITY_MONSTERINTERACT) -- This inserts the it into the target array.
	self:SetModel("models/nzr/2022/magicbox/bo2/magic_box.mdl")
	if (nzMapping.Settings.boxtype == "Original") then
		self:SetModel("models/nzr/2022/magicbox/bo2/magic_box.mdl")
	elseif (nzMapping.Settings.boxtype == "Origins") then
		self:SetModel("models/nzr/2022/magicbox/bo2/tomb_box.mdl")
	elseif (nzMapping.Settings.boxtype == "Mob of the Dead") then
		self:SetModel( "models/nzr/2022/magicbox/motd.mdl" )
	elseif (nzMapping.Settings.boxtype == "Dead Space") then
		self:SetModel( "models/nzr/2022/magicbox/Deadspace_box.mdl" )
		self:SetModelScale( self:GetModelScale() * 0.7, 0 )
	elseif (nzMapping.Settings.boxtype == "Resident Evil") then
		self:SetModel( "models/nzr/2022/magicbox/re_box.mdl" )
	elseif (nzMapping.Settings.boxtype == "Call of Duty: WW2") then
		self:SetModel( "models/nzr/2022/magicbox/ww2.mdl" )
	elseif (nzMapping.Settings.boxtype == "DOOM") then
		self:SetModel( "models/nzr/2022/magicbox/doom_on.mdl" )
	elseif (nzMapping.Settings.boxtype == "Chaos") then
		self:SetModel( "models/nzr/2022/magicbox/chaos.mdl" )
	elseif (nzMapping.Settings.boxtype == "Shadows of Evil") then
		self:SetModel( "models/nzr/2022/magicbox/soe.mdl" )
	end

	self.AutomaticFrameAdvance = true
	self:PhysicsInit(SOLID_NONE)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetCollisionGroup(COLLISION_GROUP_WORLD)
	self:SetSolid(SOLID_VPHYSICS)

	local sequence = self:LookupSequence("arrive")
	if sequence then
		self:ResetSequence(sequence)
	end

	self:SetPos(self:GetPos() - self:GetRight()*7.5)
	self:DrawShadow(false)
	self:SetOpen(false)
	self:SetActivated(false)
	self:SetActivateTime(CurTime() + 6)
	self.Moving = false
	self.Price = 950

	self:Activate()

	if SERVER then
		self:SetUseType(SIMPLE_USE)
		self:SetTrigger(true)
	end

	if CLIENT then
		local ang = self:GetAngles()
		self.Light = ClientsideModel("models/effects/vol_light128x512.mdl")
		self.Light:SetAngles(Angle(0, ang[2], 180))
		self.Light:SetPos(self:GetPos() - Vector(0,0,50))
		self.Light:SetColor(nzMapping.Settings.boxlightcolor)
		self.Light:DrawShadow(false)
		local min, max = self.Light:GetRenderBounds()
		self.Light:SetRenderBounds(Vector(min.x, min.y, min.z), Vector(max.x, max.y, max.z*10))

		local scale = Vector( 1, 1, 5 )
		local mat = Matrix()
		mat:Scale( scale )
		self.Light:EnableMatrix( "RenderMultiply", mat )

		self.Light:Spawn()
	end
end

function ENT:Use(activator, caller)
	if self:GetOpen() or (not self:GetActivated()) or self.Moving then return end

	if activator:CanAfford(self:GetPrice()) then
		self:BuyWeapon(activator)
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
	//ParticleEffectAttach("nz_magicbox", PATTACH_POINT_FOLLOW, self, 1)
end

function ENT:Close()
	local sequence = self:LookupSequence("close")
	self:ResetSequence(sequence)
	self:SetOpen(false)
	self:StopParticles()
end

function ENT:SpawnWeapon(activator, class)
	local wep = ents.Create("random_box_windup")
	wep:SetAngles(self:GetAngles())
	wep:SetPos(self:GetPos() + self:GetUp()*6)
	wep:SetWepClass(class)
	wep:SetBuyer(activator)

	wep:Spawn()

	wep.Box = self

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
			dlight.pos = self:GetPos() + self:GetUp()*10
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
	end

	self:NextThink(CurTime())
	return true
end

function ENT:MoveAway()
	nzPowerUps.BoxMoved = true
	self.Moving = true

	local sequence = self:LookupSequence("leave")
	self:ResetSequence(sequence)
	self:SetActivated(false)

	timer.Simple(0.25, function()
		if not IsValid(self) then return end
		nzSounds:Play("Bye")
	end)

	timer.Simple(7.5, function()
		if not IsValid(self) then return end

		self.Moving = false
		self.SpawnPoint.Box = nil

		self:MoveToNewSpot(self.SpawnPoint)

		self:Remove()
	end)
end

function ENT:MoveToNewSpot(oldspot)
	nzRandomBox.Spawn(oldspot)
end

function ENT:MarkForRemoval()
	self.MarkedForRemoval = true
end

function ENT:OnRemove()
	if CLIENT then
		if IsValid(self.Light) then
			self.Light:Remove()
		end
	else
		if IsValid(self.SpawnPoint) then
			self.SpawnPoint:SetBodygroup(1,0)
		end
	end
end
