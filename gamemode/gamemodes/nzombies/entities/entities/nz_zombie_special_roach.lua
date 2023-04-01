AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.Type = "nextbot"
ENT.Category = "Brainz"
ENT.Author = "Lolle/Moo"
ENT.Spawnable = true

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Decapitated")
	self:NetworkVar("Bool", 1, "Alive")
	self:NetworkVar("Bool", 2, "MooSpecial")
	self:NetworkVar("Bool", 3, "WaterBuff")
end

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = false
ENT.IsMooSpecial = true

ENT.TraversalCheckRange = 40

ENT.Models = {
	{Model = "models/specials/radroach.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model = "models/specials/radroach.mdl", Skin = 1, Bodygroups = {0,0}},
	{Model = "models/specials/radroach.mdl", Skin = 2, Bodygroups = {0,0}},
	--{Model = "models/moo/_codz_ports/t8/ofc_quadcrawler/moo_codz_t8_nova_bomber.mdl", Skin = 0, Bodygroups = {0,0}},
}

ENT.DeathSequences = {
	"h2hunequip"
}

ENT.BarricadeTearSequences = {
	--Leave this empty if you don't intend on having a special enemy use tear anims.
}

local AttackSequences = {
	{seq = "h2hattackleft_jump", dmgtimes = {0.3}},
	{seq = "h2hattackright_jump", dmgtimes = {0.3}},
}

local JumpSequences = {
	{seq = "h2hattackright_jump", speed = 15, time = 2.5},
}

local walksounds = {
	
}


ENT.ActStages = {
	[1] = {
		act = ACT_WALK,
		minspeed = 0,
		attackanims = AttackSequences,
		barricadejumps = JumpSequences,
	},
	[2] = {
		act = ACT_RUN,
		minspeed = 75,
		attackanims = AttackSequences,
		barricadejumps = JumpSequences,
	},
	[3] = {
		act = ACT_SPRINT,
		minspeed = 145,
		attackanims = AttackSequences,
		barricadejumps = JumpSequences,
	},
}

ENT.IdleSequence = "mtidle"

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			MovementSequence = {
				"mtforward",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 225, Sequences = {
		{
			MovementSequence = {
				"mtfastforward",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
}

ENT.AttackHitSounds = {
	"nz/zombies/attack/player_hit_0.wav",
	"nz/zombies/attack/player_hit_1.wav",
	"nz/zombies/attack/player_hit_2.wav",
	"nz/zombies/attack/player_hit_3.wav",
	"nz/zombies/attack/player_hit_4.wav",
	"nz/zombies/attack/player_hit_5.wav"
}

ENT.PainSounds = {
	"nz/zombies/death/nz_flesh_impact_1.wav",
	"nz/zombies/death/nz_flesh_impact_2.wav",
	"nz/zombies/death/nz_flesh_impact_3.wav",
	"nz/zombies/death/nz_flesh_impact_4.wav"
}

ENT.DeathSounds = {
	"enemies/specials/roach/npc_roach_death_01.mp3",
	"enemies/specials/roach/npc_roach_death_02.mp3",
}

ENT.AttackSounds = {
	"enemies/specials/roach/npc_roach_attack_01.mp3",
	"enemies/specials/roach/npc_roach_attack_02.mp3",
	"enemies/specials/roach/npc_roach_attack_03.mp3"

}

ENT.BehindSoundDistance = 200 -- When the zombie is within 200 units of a player, play these sounds instead
ENT.BehindSounds = {
	Sound("enemies/specials/roach/npc_roach_attack_01.mp3"),
	Sound("enemies/specials/roach/npc_roach_attack_03.mp3"),
}

function ENT:StatsInitialize()
	if SERVER then
		self:SetMooSpecial(true)
		if nzRound:GetNumber() == -1 then
			self:SetRunSpeed( math.random(20, 105) )
			self:SetHealth( math.random(100, 1500) )
		else
			local speeds = nzRound:GetZombieSpeeds()
			if speeds then
				self:SetRunSpeed(  math.min( 333 , nzMisc.WeightedRandom(speeds)) )
			else
				self:SetRunSpeed( 100 )
			end
			self:SetHealth( nzRound:GetZombieHealth()/2 or 75 )
		end
	end
end

function ENT:SpecialInit()
	if CLIENT then
	end
end

function ENT:OnSpawn()
	if self:GetRunSpeed() > 300 then -- rOACH FAST
		timer.Simple(engine.TickInterval(), function()
			print("WE GOT A RUNNER")
			self:SetRunSpeed(300)
			self.loco:SetDesiredSpeed( self:GetRunSpeed() )
		end)
	end
	timer.Simple(engine.TickInterval(), function()
		if IsValid(self) then
			self:EmitSound("enemies/specials/roach/npc_roach_attack_0"..math.random(3)..".mp3", 100, math.random(95, 105), 1, 2)
			ParticleEffect("bo3_zombie_spawn",self:LocalToWorld(Vector(0,-0,0)),Angle(0,0,0),nil)
			if IsValid(self) then ParticleEffectAttach("novagas_trail", 4, self, 2) end
		end
	end)
end


--[[ CUSTOM/MODIFIED THINGS FROM BASE HERE ]]--

function ENT:PerformDeath(dmgInfo)
	if dmgInfo:GetDamageType() == DMG_REMOVENORAGDOLL then self:Remove(dmgInfo) end
	if self.DeathRagdollForce == 0 or self.DeathRagdollForce <= dmgInfo:GetDamageForce():Length() and dmgInfo:GetDamageType() ~= DMG_REMOVENORAGDOLL or self:GetSpecialAnimation() then
		self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
		self:Remove(dmgInfo)
	else
		self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
		self:DoDeathAnimation(self.DeathSequences[math.random(#self.DeathSequences)])
	end
end


function ENT:DoDeathAnimation(seq) -- Modified death function to have a chance of spawning a gas cloud on death.
	local GasDeathChance = math.random(3)
	self.BehaveThread = coroutine.create(function()
		self:SetNoDraw(true )
		ParticleEffect("baby_dead2",self:LocalToWorld(Vector(0,0,-11)),Angle(0,0,0),nil)
		self:EmitSound("fosounds/vj_forpnpcs/gecko/npc_gecko_death_01.mp3")
		if GasDeathChance == 3 then
			print("FOUL ROACH DETECTED")
				local vaporizer = ents.Create("point_hurt")
		   		local gfx = ents.Create("pfx2_03")
				ParticleEffectAttach("bo3_sliquifier_puddle_2", PATTACH_ABSORIGIN_FOLLOW, gfx, 0)
        		gfx:SetPos(self:GetPos() + (Vector(0,0,5)))
        		gfx:SetAngles(Angle(0,0,0))
				gfx:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        		gfx:Spawn()
				if !vaporizer:IsValid() then return end
				vaporizer:SetKeyValue("Damage", 18)
				vaporizer:SetKeyValue("DamageRadius", 115)
				vaporizer:SetKeyValue("DamageDelay",0.5)
				vaporizer:SetKeyValue("DamageType",DMG_NERVEGAS)
				vaporizer:SetPos(self:GetPos())
				vaporizer:SetOwner(self)
				vaporizer:Spawn()
				vaporizer:Fire("TurnOn","",0)
				vaporizer:Fire("kill","",7)
				timer.Simple(7, function()
					gfx:Remove()
				end)
			--local fuckercloud = ents.Create("nova_gas_cloud")
			--fuckercloud:SetPos(self:GetPos())
			--fuckercloud:SetAngles(Angle(0,0,0))
			--fuckercloud:Spawn()
		end
		
		self:Remove(DamageInfo())
	end)
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
				self:StartActivity( ACT_WALK )
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
