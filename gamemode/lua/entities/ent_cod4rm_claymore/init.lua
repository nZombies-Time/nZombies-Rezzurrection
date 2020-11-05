local model = "models/krazy/cod4rm/claymore_armed.mdl"
local classname = "cod4rmclaymore" 
local ShouldSetOwner = true
ENT.Exploded = false
ENT.Setup        = false
-------------------------------
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
-------------------------------

--------------------
-- Spawn Function --
--------------------
function ENT:SpawnFunction( ply, tr )

	if ( !tr.Hit ) then return end
	local SpawnPos = tr.HitPos + tr.HitNormal * 25
	local ent = ents.Create( classname )
	ent:GetOwner(self.ClayOwner)
	ent:SetPos( self.ClayOwner )
	ent:Spawn()
	ent:Activate()
	
	return ent
	
end

----------------
-- Initialize --
----------------
function ENT:Initialize()
	
	self.Entity:SetModel( model )
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

	
       //Tripmine exclusive code
        self.Spawned = CurTime()
        local tr = self:Trace()
        if ( tr.Hit and tr.Entity and tr.Entity:IsValid() and !tr.Entity:IsPlayer() ) then
                self.InitEnt = tr.Entity
        end
end
ENT.Triggered = false
function ENT:Think()


local pos = self:GetPos()
local ang = Angle(self:GetAngles().x,self:GetAngles().y,self:GetAngles().z) + Angle(0,-90,0)
local tracedata = {}
tracedata.start = pos
tracedata.endpos = self:GetPos() + self:GetRight() * -100
tracedata.filter = self
local trace = util.TraceLine(tracedata)

local pos1 = self:GetPos()
local ang1 = Angle(self:GetAngles().x,self:GetAngles().y,self:GetAngles().z) + Angle(0,-90,0)
local tracedata1 = {}
tracedata1.start = pos1
tracedata1.endpos = self:GetPos() + self:GetRight() * -50 + self:GetForward() * 20 + Vector(0,0,11)
tracedata1.filter = self
local trace1 = util.TraceLine(tracedata1)

local pos2 = self:GetPos()
local ang2 = Angle(self:GetAngles().x,self:GetAngles().y,self:GetAngles().z) + Angle(0,-90,0)
local tracedata2 = {}
tracedata2.start = pos2
tracedata2.endpos = self:GetPos() + self:GetRight() * -50 + self:GetForward() * -20 + Vector(0,0,11)
tracedata2.filter = self
local trace2 = util.TraceLine(tracedata2)
if trace2.HitNonWorld or trace1.HitNonWorld or trace.HitNonWorld then
   target2 = trace2.Entity 
   target1 = trace1.Entity 
   target = trace.Entity
   if target2:IsValid() or target1:IsValid() or target:IsValid() then
   if target1 ~= self.ClayOwner and target2 ~= self.ClayOwner and target ~= self.ClayOwner and self.Triggered == false then
   self.Triggered = true
   self.Entity:EmitSound( "rm_claymore/trigger.wav" )
   timer.Simple(0.5, function() self:Explode() end)
   
   end
   end
end

   self:NextThink( CurTime() + 0.001 )
    return true


end


function ENT:PhysicsCollide( data, phys )
        if self.Setup || !data.HitEntity:IsWorld() then 
                return
        end
        
        if !data.HitEntity:IsWorld() then
                return
        end

        self:SetMoveType( MOVETYPE_NONE )
        phys:EnableMotion( false )
        phys:Sleep()

        self:SetUpTripMine( data.HitNormal:GetNormal() * -1 )
end

function ENT:Trace()
        local tr = {}
        tr.start = self:GetPos()
        
        if self.InitEnt && self.InitEnt:IsValid() then
                tr.filter = {self, self.InitEnt}
        else
                tr.filter = {self}
        end

        return util.TraceLine( tr )
end

function ENT:SetUpTripMine( forward )
        self.Setup = true

        self:SetAngles( forward:Angle() + Angle( 90, 0, 0 ) )
        self:EmitSound( self.StickSound[math.random(1,#self.StickSound)] )
end

function ENT:UpdateTransmitState()
        return TRANSMIT_ALWAYS
end

function ENT:OnTakeDamage()
        self:Explode()
end


function ENT:Explode()
if self:GetNWString("exploded") == "true" then return end
self:SetNWString("exploded","true")
if !IsValid(self) then return end
if !IsValid(self.ClayOwner) then return end
local own = self:GetPos()
	self.Entity:EmitSound( "ambient/explosions/explode_4.wav" )
	self.Entity:SetOwner(self.ClayOwner)
	
local detonate = ents.Create( "env_explosion" )
		detonate:SetOwner(self.ClayOwner)
		detonate:SetPos( self.Entity:GetPos() )
		detonate:SetKeyValue( "iMagnitude", "0" )
		detonate:Spawn()
		detonate:Activate()
		detonate:Fire( "Explode", "", 0 )
		util.BlastDamage(self.Entity,self.ClayOwner,own,300,750)
	
	local shake = ents.Create( "env_shake" )
		shake:SetOwner( self.ClayOwner )
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
	
end



------------
-- On use --
------------
function ENT:Use( activator, caller )

end

-----------
-- Touch --
-----------
function ENT:Touch(ent)

end

--------------------
-- PhysicsCollide -- 
--------------------
function ENT:PhysicsCollide( data, physobj )
        if not data.HitEntity:IsWorld( ) then return end
        
        physobj:EnableMotion( false )
        physobj:Sleep( )
        
end

function ENT:UpdateTransmitState( )
        return TRANSMIT_ALWAYS
end  