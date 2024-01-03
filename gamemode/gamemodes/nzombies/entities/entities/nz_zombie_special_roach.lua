AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.Type = "nextbot"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo"
ENT.Spawnable = true

--ROACH FROM NEW YORK 
if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = false
ENT.IsMooSpecial = true

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

local SpawnSequences = {"h2hattackright_jump"}

local AttackSequences = {
	{seq = "h2hattackleft_jump", dmgtimes = {0.3}},
	{seq = "h2hattackright_jump", dmgtimes = {0.3}},
}

local JumpSequences = {
	{seq = "h2hattackright_jump"},
}

local walksounds = {

}

ENT.IdleSequence = "mtidle"

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			MovementSequence = {
				"mtforward"
			},
			SpawnSequence = {SpawnSequences},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 189, Sequences = {
		{
			MovementSequence = {
				"mtfastforward",
			},
			SpawnSequence = {SpawnSequences},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}}
}

ENT.AttackHitSounds = {
	"nz/zombies/attack/player_hit_0.wav",
	"nz/zombies/attack/player_hit_1.wav",
	"nz/zombies/attack/player_hit_2.wav",
	"nz/zombies/attack/player_hit_3.wav",
	"nz/zombies/attack/player_hit_4.wav",
	"nz/zombies/attack/player_hit_5.wav"
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
			self:SetRunSpeed( math.random(100, 300) )
			self:SetHealth( math.random(100, 1500) )
		else
			local speeds = nzRound:GetZombieSpeeds()
			if speeds then
				self:SetRunSpeed( nzMisc.WeightedRandom(speeds) )
			else
				self:SetRunSpeed( 300 )
			end
			self:SetHealth( nzRound:GetZombieHealth() or 75 )
		end

		self.Exploded = false

	end
end

function ENT:OnSpawn()
	local spawn
	local types = {
		["nz_spawn_zombie_normal"] = true,
		["nz_spawn_zombie_special"] = true,
		["nz_spawn_zombie_extra1"] = true,
		["nz_spawn_zombie_extra2"] = true,
		["nz_spawn_zombie_extra3"] = true,
		["nz_spawn_zombie_extra4"] = true,
	}
	for k,v in pairs(ents.FindInSphere(self:GetPos(), 10)) do
		if types[v:GetClass()] then
			if !v:GetMasterSpawn() then
				spawn = v
			end
		end
	end
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

	if IsValid(self) then ParticleEffectAttach("novagas_trail", 4, self, 2) end
	self:EmitSound("enemies/specials/roach/npc_roach_attack_0"..math.random(3)..".mp3", 100, math.random(95, 105), 1, 2)

	if IsValid(spawn) and spawn:GetSpawnType() == 1 then
		if IsValid(self) then
			self:EmitSound("nz_moo/effects/teleport_in_00.mp3", 100)
			if IsValid(self) then ParticleEffect("panzer_spawn_tp", self:GetPos() + Vector(0,0,20), Angle(0,0,0), self) end
		end
		self:SolidMaskDuringEvent(MASK_PLAYERSOLID)
		self:CollideWhenPossible()
	else
		self:SolidMaskDuringEvent(MASK_PLAYERSOLID)

		self:SetSpecialAnimation(true)
		self:SetIsBusy(true)
		local seq = self:SelectSpawnSequence()

		if tr.Hit then
			local finalsound = SpawnMatSound[tr.MatType] or SpawnMatSound[0]
			self:EmitSound(finalsound)
		end
		ParticleEffect("bo3_zombie_spawn",self:GetPos()+Vector(0,0,1),self:GetAngles(),self)
		self:EmitSound("nz_moo/zombies/spawn/_generic/dirt/dirt_0"..math.random(0,2)..".mp3",100,math.random(95,105))

		if seq then
			self:PlaySequenceAndMove(seq, {gravity = true})
			self:SetSpecialAnimation(false)
			self:SetIsBusy(false)
			self:CollideWhenPossible()
		end
	end
end


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

function ENT:HandleAnimEvent(a,b,c,d,e) -- Moo Mark 4/14/23: You don't know how sad I am that I didn't know about this sooner.
	if e == "melee" then
		self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2)
		--self:DoAttackDamage()
	end
	if e == "death_ragdoll" then
		self:BecomeRagdoll(DamageInfo())
	end
	if e == "melee_whoosh" then
		self:EmitSound("nz_moo/zombies/fly/attack/whoosh/zmb_attack_med_0"..math.random(0,2)..".mp3", 75, math.random(95,105))
	end
	if e == "roach_crawl" then
		self:EmitSound("nz_moo/zombies/footsteps/crawl/crawl_0"..math.random(0,3)..".mp3", 65, math.random(95,105))
	end
end

if SERVER then
	function ENT:OnTakeDamage(dmginfo)
		if (dmginfo:GetDamageType() == DMG_DISSOLVE and dmginfo:GetDamage() >= self:Health() and self:Health() > 0) then
			self:DissolveEffect()
		end

		self:SetLastHurt(CurTime())
	end
end

function ENT:IsValidTarget( ent )
	if not ent then return false end
	return IsValid( ent ) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
end