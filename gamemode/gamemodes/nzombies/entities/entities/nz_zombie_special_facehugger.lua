AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Nemacyte"
ENT.Category = "Brainz"
ENT.Author = "Laby"

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true
ENT.IsMooSpecial = true
ENT.AttackDamage = 1
ENT.AttackRange = 5
ENT.DamageRange = 5

ENT.Models = {
	{Model = "models/specials/facehugger.mdl" , Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"burrowout"}

ENT.AttackSequences = {
	{seq = "jump"},
	{seq = "hop"}
}


ENT.BarricadeTearSequences = {
	--Leave this empty if you don't intend on having a special enemy use tear anims.
}

ENT.IdleSequence = "Idle_lower"

ENT.DeathSequences = {
	"burrowin"
}

ENT.AttackSounds = {
	"npc/headcrab/attack1.wav",
	"npc/headcrab/attack2.wav",
	"npc/headcrab/attack3.wav"
}

local walksounds = {
	Sound("enemies/specials/nemacyte/ambi1.ogg"),
	Sound("enemies/specials/nemacyte/ambi2.ogg"),
	Sound("enemies/specials/nemacyte/ambi3.ogg"),
	Sound("enemies/specials/nemacyte/ambi4.ogg"),
	Sound("enemies/specials/nemacyte/ambi5.ogg"),
	Sound("enemies/specials/nemacyte/ambi6.ogg"),
	Sound("enemies/specials/nemacyte/ambi7.ogg")
}


ENT.DeathSounds = {
	"enemies/specials/spider/vox/death_01.ogg"
	
	
}

ENT.AppearSounds = {
	"npc/antlion/digup1.wav"
}

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"leap"
			},
			AttackSequences = {AttackSequences},
			PassiveSounds = {walksounds},
		},
	}},
}

function ENT:StatsInitialize()
	if SERVER then
		self:SetRunSpeed( 200 )
		self.loco:SetDesiredSpeed( 200 )
		self.NextAction = 0
		self.isFucking = false
		self.flying = false
	end
	self:SetCollisionBounds(Vector(-13,-13, 0), Vector(13, 13, 45))
end

function ENT:OnSpawn()

	local nav = navmesh.GetNavArea(self:GetPos(), 50)
	self:EmitSound("nz_moo/zombies/vox/_quad/spawn/spawn_0"..math.random(3)..".mp3", 511, math.random(95, 105), 1, 2)

		local SpawnMatSound = {
			[MAT_DIRT] = "nz_moo/zombies/spawn/dirt/pfx_zm_spawn_dirt_0"..math.random(0,1)..".mp3",
			[MAT_SNOW] = "nz_moo/zombies/spawn/snow/pfx_zm_spawn_snow_0"..math.random(0,1)..".mp3",
			[MAT_SLOSH] = "nz_moo/zombies/spawn/mud/pfx_zm_spawn_mud_00.mp3",
			[0] = "nz_moo/zombies/spawn/default/pfx_zm_spawn_default_00.mp3",
		}
		SpawnMatSound[MAT_GRASS] = SpawnMatSound[MAT_DIRT]
		SpawnMatSound[MAT_SAND] = SpawnMatSound[MAT_DIRT]

		local norm = (self:GetPos()):GetNormalized()
		local tr = util.QuickTrace(self:GetPos(), norm*10, self)

		self:SolidMaskDuringEvent(MASK_PLAYERSOLID)

		if tr.Hit then
			local finalsound = SpawnMatSound[tr.MatType] or SpawnMatSound[0]
			self:EmitSound(finalsound)
		end

		ParticleEffect("bo3_zombie_spawn",self:GetPos()+Vector(0,0,1),self:GetAngles(),self)
		self:EmitSound("nz_moo/zombies/spawn/_generic/dirt/dirt_0"..math.random(0,2)..".mp3",100,math.random(95,105))

		self:SetSpecialAnimation(true)
		self:SetIsBusy(true)
		local seq = self:SelectSpawnSequence()

		if seq then
			self:PlaySequenceAndMove(seq, {gravity = true})
			self:SetSpecialAnimation(false)
			self:SetIsBusy(false)
			self:CollideWhenPossible()
			self:SetBlockAttack(true)
		end
	
end

function ENT:PerformDeath(dmgInfo)
		self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
		if IsValid(self) then
				ParticleEffect("ins_blood_impact_headshot",self:GetPos(),self:GetAngles(),self)
				self:Remove()
		end
	
end



function ENT:OnPathTimeOut()
	local target = self:GetTarget()
	if CurTime() < self.NextAction then return end
	
	if math.random(0,5) == 6 and CurTime() > self.NextAction then
		if self:IsValidTarget(target) then
			local tr = util.TraceLine({
				start = self:GetPos() + Vector(0,50,0),
				endpos = target:GetPos() + Vector(0,0,50),
				filter = self,
			})
			
			if IsValid(tr.Entity) and self:IsValidTarget(tr.Entity) then
				self:Jump()
				self:SetSpecialAnimation(true)
				--self.loco:SetVelocity( (self:GetForward() * 1000) + Vector(0,0,200) )
				self:EmitSound("npc/antlion/digup1.wav")
				local dir = (tr.Entity:GetPos() + Vector(0,0,50)) - self:GetPos():GetNormalized()
				--self:SetPos( self:GetPos() + Vector(0,0,50))
				--timer.Simple(1, function()
				--self:SetSpecialAnimation(false)
				--end)

				self.NextAction = CurTime() + math.random(4, 8)
				self.NextAction = CurTime() + math.random(5, 10)
			end
		end
		
	end
end

function ENT:OnContact( ent )
if SERVER then
	if ent:IsPlayer() and not self.isFucking and not ent:GetGettingFacefucked()  then
	print("GIVE ME YOUR FACE")
	self:SetSpecialAnimation(true)
	self.isFucking = true
	self:SetBlockAttack(true)
		self:SetIsBusy(true)
		
		 victim = self:GetTarget()
		-- print(victim:GetAngles())
		 
		-- bones = target:GetBoneCount()
		 if victim:LookupBone("ValveBiped.Bip01_Head1") then
							local bonepos, boneang = victim:GetBonePosition(victim:LookupBone("ValveBiped.Bip01_Head1"))
							local a = victim:GetAngles()
							print( a.p, a.y, a.r )
							local hc = ents.Create("nz_facehugger")
							hc:FollowBone( victim, victim:LookupBone("ValveBiped.Bip01_Head1") )
							hc:LocalToWorld( bonepos )
							if a.y > 0 then
							hc:SetPos(bonepos+Vector(1,5,1))
							else
							hc:SetPos(bonepos+Vector(1,-5,1))
							end
							hc:SetAngles(boneang+Angle(70,-10,0))
							hc:Spawn()
							print("you are being violated good sir")
							victim:SetGettingFacefucked(true)
						end
					end
		self:Remove()
	end
	end

	
	
function ENT:PlayAttackAndWait( name, speed )

	local len = self:SetSequence( name )
	speed = speed or 1

	self:ResetSequenceInfo()
	self:SetCycle( 0 )
	self:SetPlaybackRate( speed )

	local endtime = CurTime() + len / speed

	while ( true ) do

		if ( endtime < CurTime() ) then
			if !self:GetStop() then
				self:ResetMovementSequence()
				self.loco:SetDesiredSpeed( self:GetRunSpeed() )
			end
			return
		end
		if self:IsValidTarget( self:GetTarget() ) then
			self.loco:FaceTowards( self:GetTarget():GetPos() )
		end

		coroutine.yield()

	end

end

function ENT:IsValidTarget( ent )
	if not ent then return false end
	return IsValid( ent ) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
end

if SERVER then
	function ENT:ResetMovementSequence()
			self:ResetSequence(self.MovementSequence)
			self.CurrentSeq = self.MovementSequence
		
		if self.UpdateSeq ~= self.CurrentSeq then -- Moo Mark 4/19/23: Finally got a system where the speed actively updates when the movement sequence set is changed.
			--print("update")
			self.UpdateSeq = self.CurrentSeq
			self.loco:SetDesiredSpeed( 200)
		end
	end
	
	end