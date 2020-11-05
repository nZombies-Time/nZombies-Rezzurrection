---------------------------------------------------------------------------------------------------------
-- Active Holy Hand Grenade
-- Note: This is the entity created when it is thrown.
-- Base entity derived from M9k.
---------------------------------------------------------------------------------------------------------

ENT.Type = "anim"
ENT.PrintName				= "Active Holy Hand Grenade"
ENT.Author					= ""
ENT.Contact					= ""
ENT.Purpose					= ""
ENT.Instructions			= ""
ENT.Spawnable				= false
ENT.AdminOnly 				= true
ENT.DoNotDuplicate 			= true
ENT.DisableDuplicator 		= true
if SERVER then
AddCSLuaFile( "shared.lua" )

---------------------------------------------------------------------------------------------------------
-- Initialization
---------------------------------------------------------------------------------------------------------

function ENT:Initialize()
	self.Owner = self.Entity.Owner
	self.Entity:SetModel("models/freeman/holyhandgrenade.mdl")
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:DrawShadow( false )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self.Entity:EmitSound("Holy.Explode")
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
	phys:Wake()
	end
	-- Note: This is the amount of time until it explodes, changing this will offset the audio track.
	self.timeleft = CurTime() + 3
	self:Think()
	self.CanTool = false
end

---------------------------------------------------------------------------------------------------------
-- Tick Tock
---------------------------------------------------------------------------------------------------------

function ENT:Think()
	if not IsValid(self) then return end
	if not IsValid(self.Entity) then return end
	if self.timeleft < CurTime() then
			self:Explosion()
	end
	self.Entity:NextThink( CurTime() )
	return true
end

---------------------------------------------------------------------------------------------------------
-- Time's up!
---------------------------------------------------------------------------------------------------------

function ENT:Explosion()
	if not IsValid(self.Owner) then
		self.Entity:Remove()
		return
	end
	local effectdata = EffectData()
		effectdata:SetOrigin(self.Entity:GetPos())
		effectdata:SetEntity(self.Entity)
		effectdata:SetStart(self.Entity:GetPos())
		effectdata:SetNormal(Vector(0,0,1))
		util.Effect("cball_explode", effectdata)
		util.Effect("Explosion", effectdata)
	local thumper = effectdata
		thumper:SetOrigin(self.Entity:GetPos())
		thumper:SetScale(1000)
		thumper:SetMagnitude(3000)
		util.Effect("ThumperDust", effectdata)
	local sparkeffect = effectdata
		sparkeffect:SetMagnitude(3)
		sparkeffect:SetRadius(8)
		sparkeffect:SetScale(5)
		util.Effect("Sparks", sparkeffect)
	local scorchstart = self.Entity:GetPos() + ((Vector(0,0,1)) * 5)
	local scorchend = self.Entity:GetPos() + ((Vector(0,0,-1)) * 5)
		util.BlastDamage(self.Entity, self.Owner, self.Entity:GetPos(), 400, 800)
		util.ScreenShake(self.Entity:GetPos(), 500, 800, 1.25, 500)
		self.Entity:Remove()
		util.Decal("Scorch", scorchstart, scorchend)
end

function ENT:OtherExplosion()

	if not IsValid(self.Owner) then
		self.Entity:Remove()
		return
	end

	util.BlastDamage(self.Entity, self.Owner, self.Entity:GetPos(), 800, 800)
	util.ScreenShake(self.Entity:GetPos(), 500, 1000, 1.25, 500)

	local scorchstart = self.Entity:GetPos() + ((Vector(0,0,1)) * 5)
	local scorchend = self.Entity:GetPos() + ((Vector(0,0,-1)) * 5)

	pos = self.Entity:GetPos()

	local effectdata = EffectData()
		effectdata:SetOrigin(pos)
		effectdata:SetEntity(self.Entity)
		effectdata:SetStart(pos)
		effectdata:SetNormal(Vector(0,0,1))
	util.Effect("Explosion", effectdata)

	local thumper = effectdata
		thumper:SetOrigin(self.Entity:GetPos())
		thumper:SetScale(500)
		thumper:SetMagnitude(800)
	util.Effect("ThumperDust", thumper)

	local sparkeffect = effectdata
		sparkeffect:SetMagnitude(3)
		sparkeffect:SetRadius(8)
		sparkeffect:SetScale(12)
	util.Effect("Sparks", sparkeffect)

	local fire = EffectData()
		fire:SetOrigin(pos)
		fire:SetEntity(self.Owner)
		fire:SetScale(1)
	util.Effect("holy_grenade_explode", fire)

	for i=1, 30 do

		ouchies = {}
		ouchies.start = pos
		ouchies.endpos = pos + (Vector(math.Rand(-1,1), math.Rand(-1,1), math.Rand(0,1)) * 64000)
		ouchies.filter = self.Entity
		ouchies = util.TraceLine(ouchies)

		if ouchies.Hit then
			local bullet = {}
			bullet.Num 			= 2
			bullet.Src 			= pos
			bullet.Dir 			= ouchies.Normal
			bullet.Spread 		= Vector(.001,.001, 0)
			bullet.Tracer		= 1
			bullet.TracerName 	= ""
			bullet.Force		= 400
			bullet.Damage		= 800
			self.Owner:FireBullets(bullet)
			if ouchies.Entity == self.Owner then
				ouchies.Entity:TakeDamage(800 * math.Rand(.85,1.15), self.Owner, self.Entity)
			end
		end
	end
	self.Entity:Remove()
	util.Decal("Scorch", scorchstart, scorchend)
end

---------------------------------------------------------------------------------------------------------
-- Physics Collide
-- Note: What I like to call the bouncy part.
---------------------------------------------------------------------------------------------------------
function ENT:PhysicsCollide(data,phys)
	if data.Speed > 50 then
		self.Entity:EmitSound(Sound("HEGrenade.Bounce"))
	end
	local impulse = -data.Speed * data.HitNormal * .4 + (data.OurOldVelocity * -.6)
	phys:ApplyForceCenter(impulse)
end

end

if CLIENT then
function ENT:Draw()
	self.Entity:DrawModel()
end
end