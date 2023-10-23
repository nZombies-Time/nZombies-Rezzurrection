AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Brute Necromorph"
ENT.Category = "Brainz"
ENT.Author = "Laby and GhostlyMoo"

--Girly weak ass bitch

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true
ENT.IsMooSpecial = true

ENT.DamageRange = 140
ENT.AttackDamage = 70
ENT.AttackRange = 150

ENT.TraversalCheckRange = 80


ENT.Models = {
	{Model =  "models/bosses/brute_necro_ds1.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"attack3"}

ENT.DeathSequences = {
	"down"
}

ENT.BarricadeTearSequences = {
	--Leave this empty if you don't intend on having a special enemy use tear anims.
}

local AttackSequences = {
	{seq = "attack", dmgtimes = {0.5}},
	{seq = "attack2", dmgtimes = {0.5}}
}

local JumpSequences = {
	--stink
}

local walksounds = {
	Sound("enemies/bosses/brute/brut_vx_idle_01_nr_00.ogg"),
	Sound("enemies/bosses/brute/brut_vx_idle_01_nr_01.ogg"),
	Sound("enemies/bosses/brute/brut_vx_idle_01_nr_02.ogg"),
	Sound("enemies/bosses/brute/brut_vx_idle_01_nr_03.ogg"),
	Sound("enemies/bosses/brute/brut_vx_idle_01_nr_04.ogg"),
	Sound("enemies/bosses/brute/brut_vx_idle_01_nr_05.ogg"),
	Sound("enemies/bosses/brute/brut_vx_idle_01_nr_06.ogg"),
	Sound("enemies/bosses/brute/brut_vx_idle_01_nr_07.ogg"),
	Sound("enemies/bosses/brute/brut_vx_idle_01_nr_08.ogg"),

}

ENT.AttackSounds = {
		"enemies/bosses/brute/brute_attack_01.ogg",
	"enemies/bosses/brute/brute_attack_02.ogg",
	"enemies/bosses/brute/brute_attack_03.ogg",
	"enemies/bosses/brute/brute_attack_04.ogg"
}

ENT.PainSounds = {
	"nz/zombies/death/nz_flesh_impact_1.wav",
	"nz/zombies/death/nz_flesh_impact_2.wav",
	"nz/zombies/death/nz_flesh_impact_3.wav",
	"nz/zombies/death/nz_flesh_impact_4.wav"
}

ENT.DeathSounds = {
	"enemies/bosses/brute/brut_vx_death_01_nr_00.ogg"
}

ENT.IdleSequence = "idle"

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"walk"
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 60, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"run"
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}}
}

function ENT:StatsInitialize()
	if SERVER then
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		if nzRound:InState( ROUND_CREATE ) then
			self:SetHealth(500)
			self:SetMaxHealth(500)
		else
			self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
			self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		end
		
		
		self.NextAction = 0
		self:SetMooSpecial(true)
		self:SetRunSpeed( 55 )
		self.loco:SetDesiredSpeed( 55 )
		self:SetCollisionBounds(Vector(-25,-25, 0), Vector(25, 25, 70))
	end
end

function ENT:OnSpawn()

	self:SolidMaskDuringEvent(MASK_SOLID_BRUSHONLY)
	self:SetNoDraw(false)
		ParticleEffect("bo3_panzer_landing",self:LocalToWorld(Vector(20+(1),20,0)),Angle(0,0,0),nil)
		
		util.ScreenShake(self:GetPos(),5,1000,1.2,2048)
	
		self:EmitSound("enemies/bosses/thrasher/tele_hand_up.ogg",511)
	self:SetSpecialAnimation(true)
	local seq = self:SelectSpawnSequence()
	if seq then
		self:PlaySequenceAndWait(seq)
		self:EmitSound("enemies/bosses/brute/brute_roar_0"..math.random(1,4)..".ogg")
		self:SetSpecialAnimation(false)
		self:SetInvulnerable(false)
		self:CollideWhenPossible()
	end
end

function ENT:PerformDeath(dmgInfo)
	if self:GetSpecialAnimation() then
		self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
		if IsValid(self) then
			ParticleEffect("bo3_margwa_death",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
			self:Remove()
		end
	else
		self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
		self:DoDeathAnimation(self.DeathSequences[math.random(#self.DeathSequences)])
	end
end

function ENT:DoDeathAnimation(seq)
	self.BehaveThread = coroutine.create(function()
		self:PlaySequenceAndWait(seq)
		if IsValid(self) then
			ParticleEffect("bo3_margwa_death",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
			self:Remove()
		end
	end)
end

function ENT:OnPathTimeOut()
	local target = self:GetTarget()
	local actionchance = math.random(3)
	local comedyday = os.date("%d-%m") == "01-04"

	if CurTime() < self.NextAction then return end
	for k,v in pairs(player.GetAll()) do
	
		
	if  actionchance == 1 and CurTime() > self.NextAction then
		-- ME BREAK YOUR ANKLES, THEN ME SMASH YOU PUNY HUMAN
		self:EmitSound("enemies/bosses/brute/brute_roar_0"..math.random(1,4)..".ogg")
				ParticleEffect("bo3_astronaut_pulse",self:LocalToWorld(Vector(0,0,60)),Angle(0,0,0),nil)
				
		for k,v in pairs(ents.FindInSphere(self:GetPos(), 240)) do
			if IsValid(v) and v:IsPlayer() and !self:IsAttackEntBlocked(v) then
			self:SetMaxHealth(self:Health()*1.1)
			self:SetHealth(self:Health() *1.1)
				v:NZSonicBlind(2)
				v:TakeDamage( 25, self,self )
			end
		end
		self:PlaySequenceAndWait("attack3")
		end
	end
	end



function ENT:HandleAnimEvent(a,b,c,d,e)

	if e == "brute_stepl" then
		self:EmitSound("enemies/bosses/brute/brut_fs_walk_heel_01_0"..math.random(0,9)..".ogg",80,math.random(95,100))
		util.ScreenShake(self:GetPos(),100000,500000,0.2,1000)
	end
	if e == "brute_stepr" then
		self:EmitSound("enemies/bosses/brute/brut_fs_walk_heel_01_0"..math.random(0,9)..".ogg",80,math.random(95,100))
		util.ScreenShake(self:GetPos(),100000,500000,0.2,1000)
		
	end
	if e == "brute_stepbig" then
	ParticleEffect("bo3_panzer_landing",self:LocalToWorld(Vector(90,20,20)),Angle(0,0,0),nil)
	ParticleEffect("bo3_zombie_spawn",self:LocalToWorld(Vector(110,0,5)),Angle(0,0,0),nil)
			local vaporizer = ents.Create("point_hurt")
        if !vaporizer:IsValid() then return end
        vaporizer:SetKeyValue("Damage", 30)
        vaporizer:SetKeyValue("DamageRadius", 200)
        vaporizer:SetKeyValue("DamageType",DMG_CRUSH)
        vaporizer:SetPos(self:GetPos())
        vaporizer:SetOwner(self)
        vaporizer:Spawn()
        vaporizer:Fire("TurnOn","",0)
        vaporizer:Fire("kill","",0.2)
		self:EmitSound("enemies/bosses/nemesis/spawn1.ogg",80,100)
		
		util.ScreenShake(self:GetPos(),1000000,500000,0.4,1000)
	end

end


function ENT:IsValidTarget( ent )
	if not ent then return false end
	return IsValid( ent ) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
end