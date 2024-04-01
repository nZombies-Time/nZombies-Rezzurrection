AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "A narcissistic lightning man"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo"

local meleetypes = {
	[DMG_CLUB] = true,
	[DMG_SLASH] = true,
	[DMG_CRUSH] = true,
	[DMG_GENERIC] = true,
}

if CLIENT then 
	function ENT:Draw()
		self:DrawModel()
		self:PostDraw()
	end
	function ENT:PostDraw()
		self:EffectsAndSounds()
	end
	function ENT:EffectsAndSounds()
		if self:Alive() then
			-- Credit: FlamingFox for Code and fighting the PVS monster -- 
			if !IsValid(self) then return end
			if (!self.Draw_FX or !IsValid(self.Draw_FX)) then
				self.Draw_FX = CreateParticleSystem(self, "avo_glow", PATTACH_POINT_FOLLOW, 2)
			end
		end
	end
	return 
end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = false
ENT.IsMooSpecial = true

ENT.AttackDamage = 75
ENT.AttackRange = 72


ENT.SoundDelayMin = 10
ENT.SoundDelayMax = 20

ENT.TraversalCheckRange = 40

ENT.Models = {
	{Model = "models/moo/_codz_ports/t8/white/moo_codz_t8_avogadro.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"nz_avo_arrive"}

local AttackSequences = {
	{seq = "nz_avo_ranged_melee"},
}

local JumpSequences = {
	{seq = "nz_avo_jump_across_120"},
}

local walksounds = {
	Sound("enemies/bosses/avo/avogadro_taunt_0.ogg"),
	Sound("enemies/bosses/avo/avogadro_taunt_1.ogg"),
	Sound("enemies/bosses/avo/avogadro_taunt_2.ogg"),
	Sound("enemies/bosses/avo/avogadro_taunt_3.ogg"),
	Sound("enemies/bosses/avo/avogadro_taunt_4.ogg"),
	Sound("enemies/bosses/avo/avogadro_taunt_5.ogg"),
	Sound("enemies/bosses/avo/avogadro_taunt_6.ogg"),
	Sound("enemies/bosses/avo/avogadro_taunt_7.ogg"),
	Sound("enemies/bosses/avo/avogadro_taunt_8.ogg"),
	Sound("enemies/bosses/avo/avogadro_taunt_9.ogg"),
	Sound("enemies/bosses/avo/avogadro_taunt_10.ogg"),
	Sound("enemies/bosses/avo/avogadro_taunt_11.ogg"),
	Sound("enemies/bosses/avo/avogadro_taunt_12.ogg"),
}

ENT.IdleSequence = "nz_avo_idle"

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			MovementSequence = {
				"nz_avo_walk",
				"nz_avo_walk_twitch",
			},
			SpawnSequence = {spawn},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 71, Sequences = {
		{
			MovementSequence = {
				"nz_avo_run",
				"nz_avo_run_twitch"
			},
			SpawnSequence = {spawn},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}}
}

ENT.SpawnSounds = {
	"enemies/bosses/avo/avogadro_spawn_0.ogg",
	"enemies/bosses/avo/avogadro_spawn_1.ogg",
	"enemies/bosses/avo/avogadro_spawn_2.ogg",
	"enemies/bosses/avo/avogadro_spawn_3.ogg",
	"enemies/bosses/avo/avogadro_spawn_4.ogg",
}

ENT.PainSounds = {
	"enemies/bosses/avo/avogadro_damaged_0.ogg",
	"enemies/bosses/avo/avogadro_damaged_1.ogg",
	"enemies/bosses/avo/avogadro_damaged_2.ogg",
	"enemies/bosses/avo/avogadro_damaged_3.ogg",
	"enemies/bosses/avo/avogadro_damaged_4.ogg",
	"enemies/bosses/avo/avogadro_damaged_5.ogg",
	"enemies/bosses/avo/avogadro_damaged_6.ogg",
	"enemies/bosses/avo/avogadro_damaged_7.ogg",
	"enemies/bosses/avo/avogadro_damaged_8.ogg",
	"enemies/bosses/avo/avogadro_damaged_9.ogg",
	"enemies/bosses/avo/avogadro_damaged_10.ogg",
	"enemies/bosses/avo/avogadro_damaged_11.ogg",
	"enemies/bosses/avo/avogadro_damaged_12.ogg",
}

ENT.DeathSounds = {
	"enemies/bosses/avo/avogadro_death_0.ogg",
	"enemies/bosses/avo/avogadro_death_1.ogg",
	"enemies/bosses/avo/avogadro_death_2.ogg",
	"enemies/bosses/avo/avogadro_death_3.ogg",
	"enemies/bosses/avo/avogadro_death_4.ogg",
	"enemies/bosses/avo/avogadro_death_5.ogg",
	"enemies/bosses/avo/avogadro_death_6.ogg",
	"enemies/bosses/avo/avogadro_death_7.ogg",
	"enemies/bosses/avo/avogadro_death_8.ogg",
	"enemies/bosses/avo/avogadro_death_9.ogg",
	"enemies/bosses/avo/avogadro_death_10.ogg",
	"enemies/bosses/avo/avogadro_death_11.ogg",
	"enemies/bosses/avo/avogadro_death_12.ogg",
	"enemies/bosses/avo/avogadro_death_13.ogg",
}

ENT.PhaseSequences = {
	"nz_avo_teleport_back_short",
	"nz_avo_teleport_back_med",
	"nz_avo_teleport_back_long",

	"nz_avo_teleport_forward_short",
	"nz_avo_teleport_forward_med",
	"nz_avo_teleport_forward_long",

	"nz_avo_teleport_left_short",
	"nz_avo_teleport_left_med",
	"nz_avo_teleport_left_long",

	"nz_avo_teleport_right_short",
	"nz_avo_teleport_right_med",
	"nz_avo_teleport_right_long",
}

ENT.BehindSoundDistance = 0 -- When the zombie is within 200 units of a player, play these sounds instead

function ENT:StatsInitialize()
	if SERVER then
		local count = #player.GetAllPlaying()

		if nzRound:InState( ROUND_CREATE ) then
			self:SetHealth(1250)
			self:SetMaxHealth(1250)
		else
			self:SetHealth(1250 * count)
			self:SetMaxHealth(1250 * count)
		end

		self.LastShot = CurTime() + 10
		self.LastTeleport = CurTime() + 5
		self.LastStun = CurTime() + 5

		self.ShockWave = CurTime() + 5

		self.ManIsMad = false

		self:SetRunSpeed(36)
	end
end

function ENT:SpecialInit()
	if CLIENT then
	end
end

function ENT:OnSpawn()
	local seq = self:SelectSpawnSequence()
	local _, dur = self:LookupSequence(seq)

	self:SolidMaskDuringEvent(MASK_SOLID_BRUSHONLY)
	self:SetInvulnerable(true)
	self:SetSpecialAnimation(true)

	self:EmitSound("enemies/bosses/avo/move_loop.wav", 65)
	self:EmitSound(self.SpawnSounds[math.random(#self.SpawnSounds)], 100, math.random(95,105), 1, 2)
	self.NextSound = CurTime() + 7

	ParticleEffectAttach("avo_glow",PATTACH_POINT_FOLLOW,self,1)

	if seq then
		self:PlaySequenceAndWait(seq)
		self:SetSpecialAnimation(false)
		self:SetInvulnerable(false)
		self:CollideWhenPossible()
	end
end

function ENT:HandleAnimEvent(a,b,c,d,e) -- Moo Mark 4/14/23: You don't know how sad I am that I didn't know about this sooner.
	if e == "melee" then
		if self.AttackSounds then
			self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2)
		end
		self:DoAttackDamage()
	end
	if e == "death_ragdoll" then
		self:BecomeRagdoll(DamageInfo())
	end
	if e == "start_traverse" then
		--print("starttraverse")
		self.TraversalAnim = true
	end
	if e == "finish_traverse" then
		--print("finishtraverse")
		self.TraversalAnim = false
	end
	if e == "phase_in" then
		self:EmitSound("nz_moo/zombies/vox/_quad/teleport/warp_in.mp3", 100)
		if IsValid(self) then ParticleEffectAttach("hcea_shield_impact", 3, self, 2) end
	end
	if e == "phase_out" then
		self:SetMaterial("")
		self:EmitSound("enemies/bosses/avo/tele.ogg", 100)
		if IsValid(self) then ParticleEffectAttach("hcea_shield_impact", 3, self, 2) end
	end
end

function ENT:OnTakeDamage(dmginfo)
	if !meleetypes[dmginfo:GetDamageType()] or !dmginfo:GetAttacker():HasPerk("sake") then
		dmginfo:ScaleDamage(0)
	else
		if CurTime() > self.LastStun then
			dmginfo:ScaleDamage(2) -- Increase damage done by melee because the nZ knives don't do consistent damage.
			self:AvoPain()
		else
			dmginfo:ScaleDamage(0)
		end
	end
end

function ENT:AvoPain()
	self:EmitSound("enemies/bosses/avo/pain"..math.random(2)..".ogg", 85)
	self:EmitSound(self.PainSounds[math.random(#self.PainSounds)], 100, math.random(95,105), 1, 2)

	self.NextSound = CurTime() + 7
	self.LastStun = CurTime() + 5

	self:SetInvulnerable(true)
	self:DoSpecialAnimation("nz_avo_pain_long", true, true)
	self:SetInvulnerable(false)
end

function ENT:CustomOnPathTimeOut()
	local chance = math.random(2)
	if !self:IsAttackBlocked() then
		if chance == 1 then
			if CurTime() > self.LastTeleport then
				local seq = self.PhaseSequences[math.random(#self.PhaseSequences)]
				if self:SequenceHasSpace(seq) then
					self:SetMaterial("invisible")
					self:DoSpecialAnimation(seq, true, true)
				end
				self.LastTeleport = CurTime() + 5
			end
		elseif chance == 2 then
			if CurTime() > self.LastShot then

				self:PlaySequenceAndMove("nz_avo_ranged_attack_intro", 1, self.FaceEnemy)

				local larmfx_tag = self:LookupBone("j_wrist_le")
				local tr = util.TraceLine({
					start = self:GetPos() + Vector(0,50,0),
					endpos = self:GetTarget():GetPos() + Vector(0,0,50),
					filter = self,
					ignoreworld = true,
				})
			
				if IsValid(tr.Entity) then
					self:EmitSound("enemies/bosses/avo/att"..math.random(2)..".ogg",100,math.random(95, 105))
					self.ZapShot = ents.Create("nz_avo_shot")
					self.ZapShot:SetPos(self:EyePos() + self:GetForward() * 2)
					self.ZapShot:Spawn()
					self.ZapShot:Launch(((tr.Entity:GetPos() + Vector(0,0,50)) - self.ZapShot:GetPos()):GetNormalized())
				end

				self:PlaySequenceAndMove("nz_avo_ranged_attack_end", 1, self.FaceEnemy)

				self.LastShot = CurTime() + math.random(5,10)
			end
		end
	end
end

function ENT:PerformDeath(dmgInfo)
	self:StopSound("enemies/bosses/avo/move_loop.wav")
	self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
	self:DoDeathAnimation("nz_avo_exit")
end

function ENT:DoDeathAnimation(seq)
	self.BehaveThread = coroutine.create(function()
		self:SetSpecialAnimation(true)
		self:PlaySequenceAndWait(seq)
		self:Remove(DamageInfo())
	end)
end

function ENT:PostAdditionalZombieStuff()

	if self:Health() < self:Health() / 2 then
		if !self.ManIsMad then
			self.ManIsMad = true
			self:SetRunSpeed(100)
			self:SpeedChanged()
		end
	end

	if CurTime() > self.ShockWave then
		local plys = {}
		for k,v in pairs(player.GetAll()) do
			if v:IsPlayer() then
				if self:GetRangeTo(v:GetPos()) < 100 then
					table.insert(plys, v)
					if #plys >= 2 then
						self:Explode(20, false)
						self.ShockWave = CurTime() + 5
						self:DoSpecialAnimation("nz_avo_pain_med")
					end
				end
			end
		end
	end
end

function ENT:Explode(dmg, suicide)
    for k, v in pairs(ents.FindInSphere(self:GetPos(), 250)) do
        if not v:IsWorld() and v:IsSolid() then
            v:SetVelocity(((v:GetPos() - self:GetPos()):GetNormalized()*255) + v:GetUp()*255)
            if v:IsPlayer() then
            	v:SetGroundEntity(nil)
                v:ViewPunch(Angle(-25,math.random(-10, 10),0))
                v:TakeDamage(dmg)
            end
        end
    end
	ParticleEffect("bo3_astronaut_pulse",self:LocalToWorld(Vector(0,0,50)),Angle(0,0,0),nil)
	self:EmitSound("nz_moo/zombies/vox/_astro/death/astro_pop.mp3", 511, math.random(95, 105))
	self:EmitSound("nz_moo/zombies/vox/_astro/death/astro_flux.mp3", 511, math.random(95, 105))
    if suicide then self:TakeDamage(self:Health() + 666, self, self) end
end

function ENT:OnRemove()
	self:StopSound("enemies/bosses/avo/move_loop.wav")
end

function ENT:IsValidTarget( ent )
	if !ent then return false end
	return IsValid(ent) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
	-- Won't go for special targets (Monkeys), but still MAX, ALWAYS and so on
end
