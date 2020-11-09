AddCSLuaFile()
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.Spawnable = false

function ENT:Draw()
self.Entity:DrawModel()
end

function ENT:Initialize()
if SERVER then
self.Entity:SetModel( "models/nmrih/weapons/exp_molotov/w_exp_molotov.mdl" )
self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
self.Entity:SetSolid( SOLID_VPHYSICS )
self.Entity:PhysicsInit( SOLID_VPHYSICS )
self.Entity:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR )
self.Entity:DrawShadow( false )
self.Entity:EmitSound( "Weapon_NMRiH_Molotov.Rag_Loop" )
self.Explode = 0
self.ExplodeTimer = CurTime()
self.BurnTimer = CurTime()
self.Sound = 0
self.SoundTimer = CurTime()
end
end

function ENT:Think()
if self.Explode == 1 then
if self.ExplodeTimer <= CurTime() and self.BurnTimer > CurTime() then
util.BlastDamage( self, self.Owner, self:GetPos(), 192, 300 )
self.ExplodeTimer = CurTime() + 0.5
end
if SERVER and self.BurnTimer <= CurTime() then
self.Explosion:Fire( "kill", "", 0 )
self.Entity:Remove()
end
end
if self.Sound == 1 and self.SoundTimer <= CurTime() then
self.Entity:EmitSound( "Weapon_NMRiH_Molotov.Fire_Loop" )
self.Sound = 0
end
end

function ENT:PhysicsCollide( data )
if SERVER then
self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
self.Entity:SetSolid( SOLID_VPHYSICS )
self.Entity:PhysicsInit( SOLID_VPHYSICS )
self.Entity:SetCollisionGroup( COLLISION_GROUP_PASSABLE_DOOR )
self.Entity:SetRenderMode( RENDERMODE_TRANSALPHA )
self.Entity:SetColor( Color( 255, 255, 255, 0 ) )
local explosion = ents.Create( "info_particle_system" )
explosion:SetKeyValue( "effect_name", "nmrih_molotov_explosion" )
explosion:SetOwner( self.Owner )
explosion:SetPos( self:GetPos() )
explosion:SetAngles( self:GetAngles() )
explosion:Spawn()
explosion:Activate()
explosion:Fire( "start", "", 0 )
self.Explosion = explosion
self.Entity:StopSound( "Weapon_NMRiH_Molotov.Rag_Loop" )
self.Entity:EmitSound( "Weapon_NMRiH_Molotov.Explode" )
end
self.Explode = 1
self.ExplodeTimer = CurTime() + 0.5
self.BurnTimer = CurTime() + 14
self.Sound = 1
self.SoundTimer = CurTime() + 1.9
util.BlastDamage( self, self.Owner, self:GetPos(), 192, 210 )
end