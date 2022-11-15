AddCSLuaFile( )

ENT.Type = "anim"

ENT.PrintName		= "random_box"
ENT.Author			= "Alig96"
ENT.Contact			= "Don't"
ENT.Purpose			= ""
ENT.Instructions	= ""
ENT.Rotated = false

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "Open" )
end

function ENT:Initialize()
	if (nzMapping.Settings.boxtype =="Original") then
		self:SetModel("models/hoff/props/mysterybox/box.mdl")
	end
	if (nzMapping.Settings.boxtype =="Origins") then
		self:SetModel( "models/nzr/originsbox/box.mdl" )
	end
	if (nzMapping.Settings.boxtype =="Mob of the Dead") then
		self:SetModel( "models/nzr/2022/box/motd.mdl" )
		--self:SetModelScale( self:GetModelScale() * 0.6, 0 )
	end
	if (nzMapping.Settings.boxtype =="Dead Space") then
		self:SetModel( "models/wolfkannund_maz_ter_/dsr/Kiosk_MysBox.mdl" )
	end
	if (nzMapping.Settings.boxtype =="Resident Evil") then
		self:SetModel( "models/nzr/re/box.mdl" )
	end
	if (nzMapping.Settings.boxtype == nil) then
		self:SetModel("models/hoff/props/mysterybox/box.mdl")
	end
	if (nzMapping.Settings.boxtype == "Call of Duty: WW2") then
		self:SetModel( "models/nzr/2022/box/ww2.mdl" )
	end
	if (nzMapping.Settings.boxtype == "DOOM") then
		self:SetModel( "models/nzr/2022/box/DOOM_on.mdl" )
	end
	if (nzMapping.Settings.boxtype == "Shadows of Evil") then
		self:SetModel( "models/nzr/2022/box/soe.mdl" )
	end
	if (nzMapping.Settings.boxtype == "Chaos") then
		self:SetModel( "models/nzr/2022/box/chaos.mdl" )
	end
	
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_VPHYSICS )

	self:DrawShadow( false )
	self:SetOpen(false)
	self.Moving = false
	self:Activate()

	if SERVER then
		self:SetUseType( SIMPLE_USE )
	end
	
	if CLIENT then
		self.Light = ClientsideModel("models/effects/vol_light128x512.mdl")
		local ang = self:GetAngles()
		self.Light:SetAngles(Angle(0, ang[2], 180))
		self.Light:SetPos(self:GetPos() - Vector(0,0,50))
		local defaultColor = Color(0, 150,200,255)
		local lightColor = !IsColor(nzMapping.Settings.boxlightcolor) and defaultColor or nzMapping.Settings.boxlightcolor
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

function ENT:Use( activator, caller )
	if self:GetOpen() == true or self.Moving then return end
	if (activator:GetPoints() >= 950) then
		nzSounds:PlayEnt("Open", self)
	end
	self:BuyWeapon(activator)
end

function ENT:BuyWeapon(ply)
	ply:Buy(nzPowerUps:IsPowerupActive("firesale") and 10 or 950, self, function()
        local class = nzRandomBox.DecideWep(ply)
        if class != nil then
			local ang = self:GetAngles()
      		self:Open()
      		local wep = self:SpawnWeapon( ply, class )
			wep.Buyer = ply
			return true
        else
            ply:PrintMessage( HUD_PRINTTALK, "No available weapons left!")
			return false
        end
	end)
end

function ENT:Open()
	if (nzMapping.Settings.boxtype =="Mob of the Dead") then
		self.FlamesEnt = ents.Create("env_fire")
		self.FlamesEntL = ents.Create("env_fire")
		self.FlamesEntR = ents.Create("env_fire")
		if IsValid( self.FlamesEnt ) then
			self.FlamesEnt:SetParent(self)
			self.FlamesEnt:SetOwner(self)
			self.FlamesEnt:SetPos(self:GetPos())
			--no glow + delete when out + start on + last forever
			self.FlamesEnt:SetKeyValue("spawnflags", tostring(128 + 32 + 4 + 2 + 1))
			self.FlamesEnt:SetKeyValue("firesize", (1 * math.Rand(0.7, 1.1)))
			self.FlamesEnt:SetKeyValue("fireattack", 0)
			self.FlamesEnt:SetKeyValue("health", 0)
			self.FlamesEnt:SetKeyValue("damagescale", "-10") -- only neg. value prevents dmg

			self.FlamesEnt:Spawn()
			self.FlamesEnt:Activate()
		end
		
		if IsValid( self.FlamesEntR ) then
			self.FlamesEntR:SetParent(self)
			self.FlamesEntR:SetOwner(self)
			self.FlamesEntR:SetPos(self:GetPos() +Vector( 0, 30, 0 ))
			--no glow + delete when out + start on + last forever
			self.FlamesEntR:SetKeyValue("spawnflags", tostring(128 + 32 + 4 + 2 + 1))
			self.FlamesEntR:SetKeyValue("firesize", (1 * math.Rand(0.7, 1.1)))
			self.FlamesEntR:SetKeyValue("fireattack", 0)
			self.FlamesEntR:SetKeyValue("health", 0)
			self.FlamesEntR:SetKeyValue("damagescale", "-10") -- only neg. value prevents dmg

			self.FlamesEntR:Spawn()
			self.FlamesEntR:Activate()
		end

		if IsValid( self.FlamesEntL ) then
			self.FlamesEntL:SetParent(self)
			self.FlamesEntL:SetOwner(self)
			self.FlamesEntL:SetPos(self:GetPos()  +Vector( 0, -30, 0 ))
			--no glow + delete when out + start on + last forever
			self.FlamesEntL:SetKeyValue("spawnflags", tostring(128 + 32 + 4 + 2 + 1))
			self.FlamesEntL:SetKeyValue("firesize", (1 * math.Rand(0.7, 1.1)))
			self.FlamesEntL:SetKeyValue("fireattack", 0)
			self.FlamesEntL:SetKeyValue("health", 0)
			self.FlamesEntL:SetKeyValue("damagescale", "-10") -- only neg. value prevents dmg
			self.FlamesEntL:Spawn()
			self.FlamesEntL:Activate()
		end
	end

	local sequence = self:LookupSequence("Close")
	self:SetPlaybackRate( 0.1 )
	self:SetSequence( sequence )
	self:SetOpen(true)
end

function ENT:Close()

	local sequence = self:LookupSequence("Open")
	self:SetSequence( sequence )
	self:SetOpen(false)
	nzSounds:PlayEnt("Close", self)
end

function ENT:SpawnWeapon(activator, class)
	local wep = ents.Create("random_box_windup")
	local ang = self:GetAngles()
	wep:SetAngles( ang )
	if (nzMapping.Settings.boxtype =="Original") then
		wep:SetPos( self:GetPos() + ang:Up()*17 )
	else
		wep:SetPos( self:GetPos() + ang:Up()*30 )
	end

	wep:SetWepClass(class)
	wep:SetBuyer(activator)

	wep:Spawn()

	wep.Box = self
	if activator:HasPerk("speed") and activator:HasUpgrade("speed") then
		self:EmitSound("nz/randombox/music_box_00_fast.wav")
	else
		nzSounds:PlayEnt("Jingle", self)
	end

	return wep
end

function ENT:Think()
	self:NextThink(CurTime())
	
	if self.MarkedForRemoval and !self:GetOpen() then
		self:Remove()
	end
	
	return true
end

function ENT:MoveAway()

	self.Moving = true
	self:SetSolid(SOLID_NONE)
	local s = 0
	local ang = self:GetAngles()

	-- Shake Effect
	nzSounds:PlayEnt("Shake", self)
	timer.Create( "shake", 0.1, 300, function()
		if s < 23 then
			if s % 2 == 0 then
				if self:IsValid() then
					self:SetAngles(ang + Angle(10, 0, 0))
				end
			else
				if self:IsValid() then
					self:SetAngles(ang + Angle(-10, 0, 0))
				end
			end
		else
			self:SetAngles(ang)
			timer.Destroy("shake")
		end
		s = s + 1
	end)

	timer.Simple(0.1, function()
		if (!IsValid(self)) then return end
		self:EmitSound("nz/effects/gone.wav")
		timer.Simple(0.1, function()
			if (!IsValid(self)) then return end
			nzSounds:Play("Bye")
		end)
	end)

	-- Move Up
	if (nzMapping.Settings.boxtype =="Dead Space") or (nzMapping.Settings.boxtype =="Shadows of Evil")  then
		self.Moving = false
		timer.Destroy("moveAway")
		timer.Destroy("shake")

		self.SpawnPoint.Box = nil
		self:MoveToNewSpot(self.SpawnPoint)
		nzSounds:PlayEnt("Poof", self)
		self:Remove()
	else
		timer.Simple( 1, function()
			timer.Create( "moveAway", 5, 1, function()
				self.Moving = false
				timer.Destroy("moveAway")
				timer.Destroy("shake")

				self.SpawnPoint.Box = nil
				self:MoveToNewSpot(self.SpawnPoint)
				nzSounds:PlayEnt("Poof", self)
				self:Remove()
			end)

			self:SetMoveType(MOVETYPE_FLY)
			self:SetGravity(0.1)
			self:SetNotSolid(true)
			self:SetCollisionBounds(Vector(0,0,0), Vector(0,0,0))
			self:GetPhysicsObject():SetDamping(100, 0)
			self:CollisionRulesChanged()
			self:SetLocalVelocity(ang:Up()*100)
			timer.Simple(1.5, function()
				self:SetLocalVelocity( Vector(0,0,0) )
				self:SetVelocity( Vector(0,0,0) )
				self:SetMoveType(MOVETYPE_FLY)
				self:Open()
				self:SetLocalAngularVelocity( Angle(0, 0, 250) )
				timer.Simple(0.5, function()
					self:SetLocalAngularVelocity( Angle(0, 0, 500) )
					timer.Simple(0.5, function()
						self:SetLocalAngularVelocity( Angle(0, 0, 750) )
						timer.Simple(0.2, function()
							self:SetLocalAngularVelocity( Angle(0, 0, 1000) )
							timer.Simple(0.2, function()
								self:SetLocalAngularVelocity( Angle(0, 0, 2000) )
							end)
						end)
					end)
				end)
			end)
		end)
	end
end

function ENT:MoveToNewSpot(oldspot)
	-- Calls mapping function excluding the current spot
	nzRandomBox.Spawn(oldspot)
end

function ENT:MarkForRemoval()
	self.MarkedForRemoval = true
	--[[if !self:GetOpen() then
		self:Remove()
	else
		hook.Add("Think", "RemoveBox"..self:EntIndex(), function()
			if !IsValid(self) or !self:GetOpen() then
				hook.Remove("Think", "RemoveBox"..self:EntIndex())
				self:Remove()
			end
		end)
	end]]
end


if CLIENT then
	function ENT:Draw()
		self:DrawModel()
	end
	--[[hook.Add( "PostDrawOpaqueRenderables", "random_box_beam", function()
		for k,v in pairs(ents.FindByClass("random_box")) do
			if ( LocalPlayer():GetPos():Distance( v:GetPos() ) ) > 750 then
				local Vector1 = v:GetPos() + Vector( 0, 0, -200 )
				local Vector2 = v:GetPos() + Vector( 0, 0, 5000 )
				render.SetMaterial( Material( "cable/redlaser" ) )
				render.DrawBeam( Vector1, Vector2, 300, 1, 1, Color( 255, 255, 255, 255 ) )
			end
		end
	end )]]
end

function ENT:OnRemove()
	if CLIENT then
		if IsValid(self.Light) then
			self.Light:Remove()
		end
	else
		if IsValid(self.SpawnPoint) then
			--self.SpawnPoint.Box = nil
			if (nzMapping.Settings.boxtype =="Resident Evil" or nzMapping.Settings.boxtype =="Call of Duty: WW2" or nzMapping.Settings.boxtype =="DOOM" or nzMapping.Settings.boxtype =="Chaos" ) then
				self.SpawnPoint:SetModelScale(1, 0 )
			end
			
			self.SpawnPoint:SetBodygroup(1,0)
		end
	end
end
