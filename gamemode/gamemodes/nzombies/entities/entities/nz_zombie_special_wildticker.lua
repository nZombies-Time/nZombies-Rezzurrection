AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Wild Ticker"
ENT.Category = "Brainz"
ENT.Author = "Laby"
--Tick Tock it's kaboom o clock
if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true
ENT.IsMooSpecial = true
ENT.AttackDamage = 10
ENT.AttackRange = 110
ENT.DamageRange = 5

ENT.Models = {
	{Model = "models/specials/wild_ticker.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"Jump_On_Grenade_Short"}

local AttackSequences = {
	{seq = "Low_Attack"}
}


ENT.BarricadeTearSequences = "Barricade_Tear"
	

ENT.IdleSequence = "Idle"

ENT.DeathSequences = {
	"reference"
}

local JumpSequences = {
	{seq = "Jump_On_Grenade_Short"},
}



ENT.AttackSounds = {
	"enemies/specials/ticker/explodevox10.ogg",
	"enemies/specials/ticker/explodevox11.ogg",
	"enemies/specials/ticker/explodevox12.ogg"
	
}
local walksounds = {
	Sound("enemies/specials/ticker/ambi1.ogg"),
	Sound("enemies/specials/ticker/ambi2.ogg"),
	Sound("enemies/specials/ticker/ambi3.ogg"),
	Sound("enemies/specials/ticker/ambi4.ogg"),
	Sound("enemies/specials/ticker/ambi5.ogg"),
	Sound("enemies/specials/ticker/ambi6.ogg"),
	Sound("enemies/specials/ticker/ambi7.ogg"),
	Sound("enemies/specials/ticker/ambi8.ogg"),
	Sound("enemies/specials/ticker/ambi9.ogg"),
	Sound("enemies/specials/ticker/ambi10.ogg"),
	Sound("enemies/specials/ticker/ambi11.ogg"),
	Sound("enemies/specials/ticker/ambi12.ogg"),
	Sound("enemies/specials/ticker/ambi13.ogg"),
	Sound("enemies/specials/ticker/ambi14.ogg"),
	Sound("enemies/specials/ticker/ambi15.ogg"),
	Sound("enemies/specials/ticker/ambi16.ogg"),
	Sound("enemies/specials/ticker/ambi17.ogg"),
	Sound("enemies/specials/ticker/ambi18.ogg"),
	Sound("enemies/specials/ticker/ambi19.ogg"),
	Sound("enemies/specials/ticker/ambi20.ogg"),
	Sound("enemies/specials/ticker/explodevox10.ogg"),
	Sound("enemies/specials/ticker/explodevox11.ogg"),
	Sound("enemies/specials/ticker/explodevox12.ogg"),

}


ENT.DeathSounds = {
	"enemies/specials/ticker/explodevox10.ogg",
	"enemies/specials/ticker/explodevox11.ogg",
	"enemies/specials/ticker/explodevox12.ogg"
	
	
}

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"Walk_All",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
}

function ENT:StatsInitialize()
	if SERVER then
		self:SetRunSpeed( 200 )
		self.loco:SetDesiredSpeed( 200 )
		self.criminal = false
	end
	self:SetCollisionBounds(Vector(-13,-13, 0), Vector(13, 13, 45))
end

function ENT:OnSpawn()

	local nav = navmesh.GetNavArea(self:GetPos(), 50)
	--self:EmitSound("nz_moo/zombies/vox/_quad/spawn/spawn_0"..math.random(3)..".mp3", 511, math.random(95, 105), 1, 2)

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
		--print("what the fuck garry")
		--self:EmitSound("BUM.ogg",511)

		self:SetSpecialAnimation(true)
		self:SetIsBusy(true)
		local seq = self:SelectSpawnSequence()

		if seq then
			self:PlaySequenceAndMove(seq, {gravity = true})
			self:SetSpecialAnimation(false)
			self:SetIsBusy(false)
			self:CollideWhenPossible()
		end
	
end

function ENT:HandleAnimEvent(a,b,c,d,e)

	if e == "tkr_jump" then
	self:PlaySound(self.AttackSounds[math.random(#self.AttackSounds)], 90, math.random(85, 105), 1, 2)
	end
	if e == "tkr_step" then
	self:EmitSound("enemies/specials/ticker/step"..math.random(1,4)..".ogg", 65, math.random(95,105))
	end
	if e == "tkr_rob" then
	
	if IsValid(self) and self:GetTarget():GetPos():Distance( self:GetPos()) < 125 then
	guygettingrobbed = self:GetTarget()
	guygettingrobbed:Freeze(true)
	self:FleeTarget(999)
	local wep = guygettingrobbed:GetActiveWeapon():GetClass()
	self:EmitSound("BUM.ogg",511)
	if math.random(1,100) == 21 then
	self:EmitSound("BUM.ogg",511)
	end
	guygettingrobbed:StripWeapon(wep)
	guygettingrobbed:Give("tfa_bo3_wepsteal")
	guygettingrobbed:SelectWeapon("tfa_bo3_wepsteal")
	self.criminal = true
		timer.Simple(1.4, function()
	guygettingrobbed:Freeze(false)
		end)
	print("give me your wallet")
	end
	end
end

function ENT:PerformDeath(dmgInfo)
	self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
	if IsValid(self) then
	if self.criminal then
	local class
	if dmgInfo:GetAttacker():IsPlayer() then
		 class = nzRandomBox.DecideWep(dmgInfo:GetAttacker())
	else
		 class = nzRandomBox.DecideWep(self:GetTarget())
	end
    local wep = ents.Create("nz_powerup_drop_weapon")
    wep:SetGun(class)
    wep:SetPos(self:GetPos() + Vector(0,0,48))
    wep:Spawn()
	end
		ParticleEffect("baby_dead",self:GetPos(),self:GetAngles(),self)
		self:Remove()
	end
end

function ENT:OnTargetInAttackRange()
		if !self:GetBlockAttack() then
		self:PlaySound(self.AttackSounds[math.random(#self.AttackSounds)], 90, math.random(85, 105), 1, 2)
			self:Attack()
		else
			self:TimeOut(2)
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
