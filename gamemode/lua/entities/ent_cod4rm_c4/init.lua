
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )

function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	
	local ent = ents.Create( "ent_cod4rm_c4" )
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	ent:GetOwner(self.C4Owner)

	return ent
	
end

function ENT:Initialize()
	
	self.Entity:SetModel( "models/krazy/cod4rm/misc/c4.mdl" )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:DrawShadow(false)
--	self.Entity:SetModelScale( 0.5, 0 )
	 
	local phys = self.Entity:GetPhysicsObject()
	
		  if (phys:IsValid()) then
			phys:Wake()
		  end
		self.Hit = false
		
	self:SetDTFloat( 0, math.Rand( 0.5, 1.3 ) )
	self:SetDTFloat( 1, math.Rand( 0.3, 1.2 ) )
	
end

function ENT:SetupDataTables()

	self:DTVar( "Float", 0, "RotationSeed1" )
	self:DTVar( "Float", 1, "RotationSeed2" )

end

function ENT:Explode()

	local c4pos = self.Entity:GetPos()
	self.Entity:EmitSound( "ambient/explosions/explode_4.wav" )
	self.Entity:SetOwner(self.C4Owner)
	
		local detonate = ents.Create( "env_explosion" )
		detonate:SetOwner(self.C4Owner)
		detonate:SetPos( self.Entity:GetPos() )
		detonate:SetKeyValue( "iMagnitude", "0" )
		detonate:Spawn()
		detonate:Activate()
		detonate:Fire( "Explode", "", 0 )
		util.BlastDamage(self.Entity,self.C4Owner,c4pos,300,1000)
	
	local shake = ents.Create( "env_shake" )
		shake:SetOwner( self.Owner )
		shake:SetPos( self.Entity:GetPos() )
		shake:SetKeyValue( "amplitude", "2000" )
		shake:SetKeyValue( "radius", "400" )
		shake:SetKeyValue( "duration", "2.5" )
		shake:SetKeyValue( "frequency", "255" )
		shake:SetKeyValue( "spawnflags", "4" )
		shake:Spawn()
		shake:Activate()
		shake:Fire( "StartShake", "", 0 )

	self.Entity:Remove()	
		for k,v in pairs(ents.FindInSphere(c4pos,100)) do
		if v:GetClass() == "ent_cod4rm_c4" then
			if !v:GetOwner():IsValid() then
				timer.Simple(0.1,function()
					if (type(v.Explode) == "function") then
						v:Explode()
					end
				end)
			end	
		end
	end
end

	function ENT:PhysicsCollide(data,phys)	
	self:EmitSound("rm_c4/plant.wav")
		if self:IsValid() && !self.Hit then
			self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
			self.Hit = true
		end	
		
		if data.HitEntity:IsWorld() == false and data.HitEntity:GetClass() ~= "ent_stickybomb" and data.HitEntity:IsNPC() == false and data.HitEntity:IsPlayer() == false and  data.HitEntity:IsValid() then
		self:SetSolid(SOLID_NONE)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetParent(data.HitEntity)
		self.Stuck = true
		self.Hit = true
		end
		
		if data.HitEntity:IsWorld() then
				self:SetMoveType(MOVETYPE_NONE)
		end
		
		local angs = self:GetAngles()
	--	self:SetAngles(Angle(0,0,0))
		local ang = data.HitNormal:Angle()
		local angl = data.HitNormal:Angle() + (Angle(270,180,90))
        ang.p = ang.p + 90		
		self:SetPos(data.HitPos + ((data.HitNormal / 5)* 5.2))
		local pos = self.C4Owner:GetPos() - self:GetPos()
		local normalized = pos:Angle()
		if (ang.p == 180 and ang.y == 0 and ang.r == 0) or (ang.p == 360 and ang.y == 0 and ang.r == 0) then
			self:SetAngles(Angle(0,normalized.y+270,270))
		else
			self:SetAngles(angl)
		end
		timer.Simple(.001,function() 
		local get = self:GetPos()
		-- print(math.Round(get.x,-2))
		-- local rounded = math.Round(get.x,-2)
		-- self:SetPos(Vector(rounded,get.y,get.z))
		
		local getx = get.x
		local gety = get.y
		local getz = get.z
		
		local roundx = math.Round(get.x,-2)
		local roundy = math.Round(get.y)
		local roundz = math.Round(get.z)
		
		 -- if roundy > roundx and roundy > roundz then
		-- self:SetPos(Vector(getx,roundy,getz))
		 -- elseif roundx > roundy and roundx > roundz then
		 -- self:SetPos(Vector(roundx,gety,getz))
		-- elseif self:GetAngles() == Angle(360,0,0) then
		-- self:SetPos(oldpos + Vector(0,0,8))
		-- elseif self:GetAngles() == Angle(90,90,0) then
		-- self:SetPos(oldpos + Vector(0,15,0))
		-- elseif self:GetAngles() == Angle(90,270,0) then
		-- self:SetPos(oldpos + Vector(0,-18,0))
		-- elseif self:GetAngles() == Angle(90,180,0) then
		-- self:SetPos(oldpos + Vector(-15,0,0))
--		 end
--		print(self:GetAngles())
		
		
		end)
	end

	function ENT:Touch(ent)
		if IsValid(ent) && !self.Stuck then
		if ent == self.C4Owner then return false end
			if ent:IsNPC() || (ent:IsPlayer() && ent != self:GetOwner()) || ent:IsVehicle() then
				self:SetSolid(SOLID_NONE)
				self:SetMoveType(MOVETYPE_NONE)
				self:SetParent(ent)
				self.Stuck = true
				self.Hit = true
			end
		end
	end

function ENT:Use( activator, caller )
-- if activator == self.C4Owner then
-- self.Hit = false
-- self.Stuck = false
-- self:Remove()
-- if activator:HasWeapon("cod-c4") == false then activator:Give("cod-c4") end
-- activator:GiveAmmo(1,"slam")
-- end
end

function ENT:Think()
	if self.BeepA then
		self:EmitSound("beep")
	end
end


