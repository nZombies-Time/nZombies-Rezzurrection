local model = "models/hoff/weapons/seal6_claymore/w_claymore.mdl"
local classname = "nz_seal6-claymore-ent" 
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
	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()
	ent:GetOwner(self.ClayOwner)
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
end

function ENT:Think()

local proxy = ents.FindInSphere( self:GetPos(), 100 )
	for k, v in pairs( proxy ) do 
		if ( IsValid(v) and (v:IsNextBot()) and v != self.Owner ) then
			self.Target = v
			self:Explode()
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
	
	local effectdata = EffectData()
      effectdata:SetOrigin( self:GetPos() )
      util.Effect("nade_explode", effectdata)
      util.BlastDamage( self, self.Owner, self:GetPos(), 200, 300 )
        
	
	local shake = ents.Create( "env_shake" )
		shake:SetOwner( self.ClayOwner )
		shake:SetPos( self.Entity:GetPos() )
		shake:SetKeyValue( "amplitude", "2000" )
		shake:SetKeyValue( "radius", "335" )
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