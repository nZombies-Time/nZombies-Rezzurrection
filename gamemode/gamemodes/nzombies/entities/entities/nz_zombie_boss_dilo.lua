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

ENT.DamageRange = 150
ENT.AttackDamage = 55
ENT.AttackRange = 165

ENT.TraversalCheckRange = 80


ENT.Models = {
	{Model =  "models/bosses/turok_dilophosaurus.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"angryroar"}

ENT.DeathSequences = {
	"death1",
	"death2"
}

ENT.BarricadeTearSequences = {
	--Leave this empty if you don't intend on having a special enemy use tear anims.
}

local AttackSequences = {
	{seq = "bite_stand", dmgtimes = {0.1}},
	{seq = "bite_walk", dmgtimes = {0.1}}
}

local AttackSequencesMAD = {
	{seq = "bite_run", dmgtimes = {0.6}},
	{seq = "headbutt", dmgtimes = {0.7}},
	{seq = "tailsmash", dmgtimes = {0.8}}
}

local JumpSequences = {
	--stink
}

local walksounds = {
	"enemies/bosses/dildophossaurus/breath1.ogg",
	"enemies/bosses/dildophossaurus/breath2.ogg",
	"enemies/bosses/dildophossaurus/breath3.ogg",
	"enemies/bosses/dildophossaurus/breath4.ogg",
	"enemies/bosses/dildophossaurus/breath5.ogg",
	"enemies/bosses/dildophossaurus/breath6.ogg",
	"enemies/bosses/dildophossaurus/hiss1.ogg",
	"enemies/bosses/dildophossaurus/hiss2.ogg",
	"enemies/bosses/dildophossaurus/hiss3.ogg",
	"enemies/bosses/dildophossaurus/react1.ogg",
	"enemies/bosses/dildophossaurus/react2.ogg",
	"enemies/bosses/dildophossaurus/react3.ogg",
	"enemies/bosses/dildophossaurus/react4.ogg",
	"enemies/bosses/dildophossaurus/react5.ogg",
	"enemies/bosses/dildophossaurus/react6.ogg",
	"enemies/bosses/dildophossaurus/react7.ogg",
	"enemies/bosses/dildophossaurus/react8.ogg",
	"enemies/bosses/dildophossaurus/react9.ogg",
	"enemies/bosses/dildophossaurus/react10.ogg",
	"enemies/bosses/dildophossaurus/react11.ogg",
	"enemies/bosses/dildophossaurus/react12.ogg",

}

ENT.AttackSounds = {
	"enemies/bosses/dildophossaurus/attack1.ogg",
	"enemies/bosses/dildophossaurus/attack1.ogg",
	"enemies/bosses/dildophossaurus/headattack1.ogg",
	"enemies/bosses/dildophossaurus/headattack2.ogg",
	"enemies/bosses/dildophossaurus/walkbite1.ogg",
	"enemies/bosses/dildophossaurus/walkbite2.ogg",
	"enemies/bosses/dildophossaurus/roar_short1.ogg",
	"enemies/bosses/dildophossaurus/roar_short2.ogg",
	"enemies/bosses/dildophossaurus/roar_short3.ogg",
	"enemies/bosses/dildophossaurus/roar_short4.ogg",
	"enemies/bosses/dildophossaurus/roar_short5.ogg",
}

ENT.PainSounds = {
	"nz/zombies/death/nz_flesh_impact_1.wav",
	"nz/zombies/death/nz_flesh_impact_2.wav",
	"nz/zombies/death/nz_flesh_impact_3.wav",
	"nz/zombies/death/nz_flesh_impact_4.wav"
}

ENT.DeathSounds = {
	"enemies/bosses/dildophossaurus/pain4.ogg"
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
	{Threshold = 75, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"run"
			},
			AttackSequences = {AttackSequencesMAD},
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
		--counting = true
		enraged = false
		self.NextAction = 0
		self:SetMooSpecial(true)
		self:SetRunSpeed( 80 )
		self.loco:SetDesiredSpeed( 80 )
		self:SetCollisionBounds(Vector(-16,-16, 0), Vector(16, 16, 70))
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
		self:EmitSound("enemies/bosses/dildophossaurus/roar_short5.ogg",511)
			util.ScreenShake(self:GetPos(),20,1000,3,2048)
		self:SetSpecialAnimation(false)
		self:SetInvulnerable(false)
		self:CollideWhenPossible()
		--counting = false
	end
end

function ENT:PerformDeath(dmgInfo)
counting = true
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
--counting = true
	local target = self:GetTarget()
	local actionchance = math.random(7	)
	local comedyday = os.date("%d-%m") == "01-04"

	if CurTime() < self.NextAction then return end
	for k,v in pairs(player.GetAll()) do
	
		
	if  actionchance == 1 and CurTime() > self.NextAction then
		-- Gorilla is not happy\
		if enraged == true then
		enraged = false
		self.loco:SetDesiredSpeed(80)
				self:SetRunSpeed(80)
				self:SpeedChanged() -- Updates current anim to be a sprinting one.
		else
		
				enraged = true -- OOOOOOO PISS EM
				self:EmitSound("enemies/bosses/dildophossaurus/roar_short"..math.random(2,5)..".ogg")
				ParticleEffect("bo3_astronaut_pulse",self:LocalToWorld(Vector(0,0,60)),Angle(0,0,0),nil)	
				self:PlaySequenceAndWait("angryroar")
				self:SetRunSpeed(160)
				self.loco:SetDesiredSpeed(160)
				--counting = false
				self:SpeedChanged() -- Updates current anim to be a sprinting one.
		end
	end
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

-- A standard attack you can use it or create something fancy yourself
function ENT:Attack( data )


	self:SetLastAttack(CurTime())

	data = data or {}
	
	data.attackseq = data.attackseq
	if !data.attackseq then

		local attacktbl = self.AttackSequences

		self:SetStandingAttack(false)

		if self:GetCrawler() then
			attacktbl = self.CrawlAttackSequences
		end

		if self:GetTarget():GetVelocity():LengthSqr() < 5 and not self:GetCrawler() then
			if self.StandAttackSequences then -- Incase they don't have standing attack anims.
				attacktbl = self.StandAttackSequences
			end
			self:SetStandingAttack(true)
		end

		local target = type(attacktbl) == "table" and attacktbl[math.random(#attacktbl)] or attacktbl

		
		if type(target) == "table" then
			local id, dur = self:LookupSequenceAct(target.seq)
			if !target.dmgtimes then
			data.attackseq = {seq = id, dmgtimes =  {0.5} }
			else
			data.attackseq = {seq = id, dmgtimes = target.dmgtimes }
			end
			data.attackdur = dur
		elseif target then -- It is a string or ACT
			local id, dur = self:LookupSequenceAct(attacktbl)
			data.attackseq = {seq = id, dmgtimes = {dur/2}}
			data.attackdur = dur
		else
			local id, dur = self:LookupSequence("swing")
			data.attackseq = {seq = id, dmgtimes = {1}}
			data.attackdur = dur
		end
	end
	
	self:SetAttacking( true )
	if IsValid(self:GetTarget()) and self:GetTarget():Health() and self:GetTarget():Health() > 0 then -- Doesn't matter if its a player... If the zombie is targetting it, they probably wanna attack it.
		for k,v in pairs(data.attackseq.dmgtimes) do
			self:TimedEvent( v, function()
				if self.AttackSounds then self:PlaySound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2) end
				if !self:GetStop() and self:IsValidTarget( self:GetTarget() ) and self:TargetInRange( self:GetAttackRange() + 10 ) then
					local dmgInfo = DamageInfo()
					dmgInfo:SetAttacker( self )
					dmgInfo:SetDamage( 80 )
					dmgInfo:SetDamageType( DMG_SLASH )
					dmgInfo:SetDamageForce( (self:GetTarget():GetPos() - self:GetPos()) * 7 + Vector( 0, 0, 16 ) )
					self:GetTarget():TakeDamageInfo(dmgInfo)
					if !IsValid(self:GetTarget()) then return end
					self:GetTarget():EmitSound( "nz/zombies/attack/player_hit_"..math.random(0,5)..".wav", SNDLVL_TALKING, math.random(95,105))
					
					if self:GetTarget():IsPlayer() then
						self:GetTarget():ViewPunch( VectorRand():Angle() * 0.01 )
					end
				end
			end)
		end
	end

	self:TimedEvent(data.attackdur, function()
		self:SetAttacking(false)
		self:SetLastAttack(CurTime())
	end)

	self:PlayAttackAndWait(data.attackseq.seq, 1)
end

function ENT:IsValidTarget( ent )
	if not ent then return false end
	return IsValid( ent ) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL
end

if SERVER then
	-- Collide When Possible
	local collidedelay = 0.25
	local bloat = Vector(5,5,0)

	function ENT:Think()	
	
		if self.DoCollideWhenPossible then
			if not self.NextCollideCheck or self.NextCollideCheck < CurTime() then
				local mins,maxs = self:GetCollisionBounds()
				local tr = util.TraceHull({
					start = self:GetPos(),
					endpos = self:GetPos(),
					filter = self,
					mask = MASK_SOLID,
					mins = mins - bloat,
					maxs = maxs + bloat,
					ignoreworld = false
				})

				local b = IsValid(tr.Entity)
				if not b then
					self:SetSolidMask(MASK_NPCSOLID)
					self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
					self:SetCollisionBounds(Vector(-20,-20, 0), Vector(20, 20, 85))
					self.DoCollideWhenPossible = nil
					self.NextCollideCheck = nil
				else
					self.NextCollideCheck = CurTime() + collidedelay
				end
			end
		end

		-- We don't want to say we're stuck if it's because we're attacking or timed out and !self:GetTimedOut() 
		if not self:GetSpecialAnimation() and not self:GetAttacking() and self:GetLastPostionSave() + 4 < CurTime() then
			if self:GetPos():DistToSqr( self:GetStuckAt() ) < 10 then
				self:SetStuckCounter( self:GetStuckCounter() + 1)
				--print(self:GetStuckCounter())
			else
				self:SetStuckCounter( 0 )
			end

			if self:GetStuckCounter() >= 1 then
				local tr = util.TraceHull({
					start = self:GetPos(),
					endpos = self:GetPos(),
					maxs = self:OBBMaxs(),
					mins = self:OBBMins(),
					filter = self
				})
				if !tr.HitNonWorld then
					--print("Stuck")
					self:ApplyRandomPush(750)
					self:SolidMaskDuringEvent(MASK_NPCSOLID_BRUSHONLY)
					self:CollideWhenPossible()
				end
				if self:GetStuckCounter() > 5 then
					local spawnpoints = {}
					for k,v in pairs(ents.FindByClass("nz_spawn_zombie_special")) do -- Find and add all valid spawnpoints that are opened and not blocked
						if (v.link == nil or nzDoors:IsLinkOpened( v.link )) and v:IsSuitable() then
							table.insert(spawnpoints, v)
						end
					end
					local selected = spawnpoints[math.random(#spawnpoints)] -- Pick a random one
					self:SetPos(selected:GetPos())
					self:SetStuckCounter( 0 )
				end
			end
			self:SetLastPostionSave( CurTime() )
			self:SetStuckAt( self:GetPos() )
		end
		self:DebugThink()
		self:OnThink()
	end
end