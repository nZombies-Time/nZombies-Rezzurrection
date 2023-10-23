ENT.Type 			= "anim"
ENT.Base 			= "base_anim"
ENT.PrintName		= "Facehugger that is currently fucking you"
ENT.Category		= "None"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false
ENT.Health = 100

ENT.MyModel = "models/specials/facehugger.mdl"
if SERVER then


function ENT:Killme( target, dmginfo )
local host = self:GetParent()
	if  target:IsPlayer()  then
	print("ouch")
		
	end
end



	AddCSLuaFile()




	function ENT:Initialize()

		local model = self.MyModel and self.MyModel or  "models/specials/facehugger.mdl"
		self.Class = self:GetClass()
		--timer.Create( "TIMETODIE2", CurTime()+ 1, 1, DIEIDIOT )
		timer.Simple( 30, function() 
		if self:IsValid() then
		self:DIEIDIOT(self) 
		end
		end  )
		self:SetModel(model)
		self:SetSequence( "Idle_lower" )
		self:PhysicsInit(SOLID_OBB)
		self:SetSolid(SOLID_NONE)
		self:SetTrigger(true)
		--self:SetAngles( Angle( 180,180,180 ))
		self:UseTriggerBounds(true, 0)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
		self:SetSolid(SOLID_VPHYSICS)
		phys = self:GetPhysicsObject()
		if phys and phys:IsValid() then
			phys:Wake()
		end
	end

function ENT:DIEIDIOT(fuck)
	
local host = fuck:GetParent()
	print( "no one likes you" )
	ParticleEffect("ins_blood_dismember_limb",host:GetPos()+Vector (0,0,25),Angle(0,0,0),nil)
		ParticleEffect("ins_blood_impact_headshot",host:GetPos()+Vector (0,0,30),Angle(0,0,0),nil)
		fuck:EmitSound("nz_moo/zombies/gibs/gib_0"..math.random(3)..".mp3",100)
		ParticleEffect("nbnz_gib_explosion",host:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
		fuck.child = ents.Create("nz_zombie_special_chestburster")
				fuck.child:SetPos(host:GetPos()+Vector (-35,0,0))
				fuck.child:Spawn()	
				--fuck.child:SetVelocity( (fuck:GetForward() * 250) )
				host:SetGettingFacefucked(false)
				fuck.child:Retarget()
				--fuck.child:SpawnXeno()
				fuck:Remove();
				host:Kill()
end

function ENT:SetVictim( meat )
 currentBone = "peniscockballspussy"
		correctBoneID = 1
		 bones = meat:GetBoneCount()
		 for i=1,bones do 
	print( meat:GetBoneName( i ) )
	currentBone = meat:GetBoneName( i )
	if currentBone == "ValveBiped.Head1" then
	correctBoneID = i
--	print(i)
--	print("HEAD LOCATED, INITIATING INSEMINATION")
	break
			end 
			end
self:FollowBone( meat, victim:LookupBone("ValveBiped.Bip01_Head1") )

end

	end

if CLIENT then
	
	function ENT:Draw()
		self:DrawModel()
	end

end




