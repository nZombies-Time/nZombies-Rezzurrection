AddCSLuaFile()

ENT.Base = "nz_zombiebase"
ENT.PrintName = "Brutus"
ENT.Category = "Brainz"
ENT.Author = "Laby"

ENT.Models = { "models/bosses/swampwarden.mdl" }

ENT.AttackRange = 105
ENT.DamageLow = 65
ENT.DamageHigh = 70


ENT.AttackSequences = {
	{seq = "melee1"},
	{seq = "melee2"}
}

ENT.DeathSequences = {
	"death"
}

ENT.AttackSounds = {
	"enemies/bosses/shrek/attack1.wav",
	"enemies/bosses/shrek/attack2.wav",
	"enemies/bosses/shrek/attack3.wav",
	"enemies/bosses/shrek/attack4.wav",
	--"cb/att3.mp3"

}

ENT.PainSounds = {
"physics/flesh/flesh_impact_bullet1.wav",
	"physics/flesh/flesh_impact_bullet2.wav",
	"physics/flesh/flesh_impact_bullet3.wav",
	"physics/flesh/flesh_impact_bullet4.wav",
	"physics/flesh/flesh_impact_bullet5.wav"
}

ENT.AttackHitSounds = {
	"effects/hit/evt_zombie_hit_player_01.ogg",
	"effects/hit/evt_zombie_hit_player_02.ogg",
	"effects/hit/evt_zombie_hit_player_03.ogg",
	"effects/hit/evt_zombie_hit_player_04.ogg",
	"effects/hit/evt_zombie_hit_player_05.ogg",
}

ENT.WalkSounds = {
	"enemies/bosses/cb/step1.ogg",
	"enemies/bosses/cb/step2.ogg",
	"enemies/bosses/cb/step3.ogg",
	"enemies/bosses/cb/step4.ogg",
	"enemies/bosses/cb/step5.ogg"
}

ENT.ActStages = {
	[1] = {
		act = ACT_RUN,
		minspeed = 1,
	},
	[2] = {
		act = ACT_RUN,
		minspeed = 150,
	},
	[3] = {
		act = ACT_SPRINT,
		minspeed = 180
	}
}

-- We overwrite the Init function because we do not change bodygroups randomly!
function ENT:Initialize()

	self:Precache()

	self:SetModel( self.Models[math.random( #self.Models )] )

	self:SetJumping( false )
	self:SetLastLand( CurTime() + 1 ) --prevent jumping after spawn
	self:SetLastTargetCheck( CurTime() )
	self:SetLastTargetChange( CurTime() )

	--sounds
	self:SetNextMoanSound( CurTime() + 1 )

	--stuck prevetion
	self:SetLastPush( CurTime() )
	self:SetLastPostionSave( CurTime() )
	self:SetStuckAt( self:GetPos() )
	self:SetStuckCounter( 0 )

	self:SetAttacking( false )
	self:SetLastAttack( CurTime() )
	self:SetAttackRange( self.AttackRange )
	self:SetTargetCheckRange(1250) -- 0 for no distance restriction (infinite)

	--target ignore
	self:ResetIgnores()

	self:SetHealth( 75 ) --fallback

	self:SetRunSpeed( self.RunSpeed ) --fallback
	self:SetWalkSpeed( self.WalkSpeed ) --fallback

	self:SetCollisionBounds(Vector(-16,-16, 0), Vector(16, 16, 70))
	self:SetActStage(0)
	self:SetSpecialAnimation(false)

	self:StatsInitialize()
	self:SpecialInit()
	
	-- Fallback for buggy tool
	if !self:GetRunSpeed() then self:SetRunSpeed(150) end

	if SERVER then
		self.loco:SetDeathDropHeight( self.DeathDropHeight )
		self.loco:SetDesiredSpeed( self:GetRunSpeed() )
		self.loco:SetAcceleration( self.Acceleration )
		self.loco:SetJumpHeight( self.JumpHeight )
		if GetConVar("nz_zombie_lagcompensated"):GetBool() then
			self:SetLagCompensated(true)
		end
		
		self.HelmetDamage = 0 -- Used to save how much damage the helmet has taken
		self:SetUsingClaw(false)
		
		self.NextAction = 0
		self.NextClawTime = 0
		self.NextFlameTime = 0
	end
	
	self.ZombieAlive = true

end

function ENT:StatsInitialize()
	if SERVER then
		self:SetRunSpeed(180)
		self:SetHealth(10000)
		hasTaunted = false
		helmet = true
	end

	--PrintTable(self:GetSequenceList())
end

function ENT:SpecialInit()

	if CLIENT then
		--make them invisible for a really short duration to blend the emerge sequences
		self:SetNoDraw(true)
		self:TimedEvent( 0.5, function()
			self:SetNoDraw(false)
		end)

		self:SetRenderClipPlaneEnabled( true )
		self:SetRenderClipPlane(self:GetUp(), self:GetUp():Dot(self:GetPos()))

		self:TimedEvent( 2, function()
			self:SetRenderClipPlaneEnabled(false)
		end)

	end
end

function ENT:InitDataTables()
	self:NetworkVar("Entity", 0, "ClawHook")
	self:NetworkVar("Bool", 1, "UsingClaw")
	self:NetworkVar("Bool", 2, "Flamethrowing")
end

function ENT:OnSpawn()
	local seq = "spawn"
	local tr = util.TraceLine({
		start = self:GetPos() + Vector(0,0,500),
		endpos = self:GetPos(),
		filter = self,
		mask = MASK_SOLID_BRUSHONLY,
	})
	if tr.Hit then seq = "spawn" end
	local _, dur = self:LookupSequence(seq)

	-- play emerge animation on spawn
	-- if we have a coroutine else just spawn the zombie without emerging for now.
	if coroutine.running() then
		
		local pos = self:GetPos() + (seq == "spawn" and Vector(0,0,100) or Vector(0,0,450))
		
		ParticleEffect("summon_beam",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
		self:EmitSound("enemies/bosses/nap/spawn.ogg",511)
		self:EmitSound("enemies/bosses/shrek/song.wav",511)
		
		local entParticle = ents.Create("info_particle_system")
		entParticle:SetKeyValue("start_active", "1")
		entParticle:SetKeyValue("effect_name", "napalm_emerge")
		entParticle:SetPos(self:GetPos())
		entParticle:SetAngles(self:GetAngles())
		entParticle:Spawn()
		entParticle:Activate()
		entParticle:Fire("kill","",2)
		self:EmitSound("enemies/bosses/shrek/taunt1.wav",511)
	self:SetInvulnerable(true)
		
		--[[effectData = EffectData()
		effectData:SetStart( pos + Vector(0, 0, 1000) )
		effectData:SetOrigin( pos )
		effectData:SetMagnitude( 0.75 )
		util.Effect("lightning_strike", effectData)]]
		
		self:TimedEvent(dur, function()
			--dust cloud
			self:SetPos(self:GetPos() + Vector(0,0,0))
			self:SetInvulnerable(false)
			local effectData = EffectData()
			effectData:SetStart( self:GetPos() )
			effectData:SetOrigin( self:GetPos() )
			effectData:SetMagnitude(1)
			
		end)
		self:PlaySequenceAndWait(seq)
	end
end

function ENT:OnZombieDeath(dmgInfo)

	self:ReleasePlayer()
	self:StopFlames()
	self:SetRunSpeed(0)
	self.loco:SetVelocity(Vector(0,0,0))
	self:Stop()
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	local seq, dur = self:LookupSequence(self.DeathSequences[math.random(#self.DeathSequences)])
	self:ResetSequence(seq)
	self:SetCycle(0)
self:EmitSound("enemies/bosses/shrek/attack4.wav")
	timer.Simple(dur, function()
		if IsValid(self) then
			self:Remove()
			ParticleEffect("bo3_panzer_explosion",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
		end
	end)

end

function ENT:BodyUpdate()

	self.CalcIdeal = ACT_IDLE

	local velocity = self:GetVelocity()

	local len2d = velocity:Length2D()

	if ( len2d > 200 ) then self.CalcIdeal = ACT_SPRINT elseif ( len2d > 0 ) then self.CalcIdeal = ACT_RUN end

	if self:IsJumping() and self:WaterLevel() <= 0 then
		self.CalcIdeal = ACT_JUMP
	end

	if !self:GetSpecialAnimation() and !self:IsAttacking() then
		if self:GetActivity() != self.CalcIdeal and !self:GetStop() then self:StartActivity(self.CalcIdeal) end

		if self.ActStages[self:GetActStage()] then
			self:BodyMoveXY()
		end
	end

	self:FrameAdvance()

end

function ENT:OnTargetInAttackRange()
    local atkData = {}
    atkData.dmglow = 65
    atkData.dmghigh = 70
    atkData.dmgforce = Vector( 0, 0, 0 )
	atkData.dmgdelay = 0.2
    self:Attack( atkData )
end


function ENT:OnPathTimeOut()
	local target = self:GetTarget()
	if CurTime() < self.NextAction then return end
	
	if math.random(0,5) == 0 and CurTime() > self.NextClawTime then
		-- I SUMMON...DONKEY!
		if self:IsValidTarget(target) then
			local tr = util.TraceLine({
				start = self:GetPos() + Vector(0,50,0),
				endpos = target:GetPos() + Vector(0,0,50),
				filter = self,
			})
			
			
			if IsValid(tr.Entity) and self:IsValidTarget(tr.Entity)  then
				self:SetSpecialAnimation(true)
				self:SetInvulnerable(true)
				self:SetBlockAttack(true)
				self:EmitSound("enemies/bosses/shrek/song.wav")
				self.donkey1 = ents.Create("nz_zombie_special_donkey")
				self.donkey1:SetPos(self:GetPos() + Vector(0,65,0))
				self.donkey1:Spawn()
				self.donkey1:SetHealth(nzRound:GetNumber() * 100)
				self.donkey2 = ents.Create("nz_zombie_special_donkey")
				self.donkey2:SetPos(self:GetPos() + Vector(0,-65,0))
				self.donkey2:Spawn()
				self.donkey2:SetHealth(nzRound:GetNumber() * 100)
				ParticleEffect("summon_beam",self:LocalToWorld(Vector(0,65,0)),Angle(0,0,0),nil)
				ParticleEffect("summon_beam",self:LocalToWorld(Vector(0,-65,0)),Angle(0,0,0),nil)
				self:PlaySequenceAndWait("summondogs")
				self:StartActivity( ACT_RUN )
				
			
			
				self.loco:SetDesiredSpeed(90)
			    self:SetRunSpeed(90)
				self:SetSpecialAnimation(false)
				self:SetInvulnerable(false)
				self:SetBlockAttack(false)
				self.NextAction = CurTime() + math.random(1, 5)
				self.NextClawTime = CurTime() + math.random(10, 13)
		end
		end
	elseif  math.random(0,5) == 3 and CurTime() > self.NextFlameTime and nzElec:IsOn() then
		-- fuck your perks idiot
		self:SetSpecialAnimation(true)
				self:SetInvulnerable(true)
				self:SetBlockAttack(true)
			--local perk = ents.FindByClass("perk_machine")[1]
	--print(nzPerks:Get(perk).name)
	
	for k,v in pairs(ents.FindByClass("perk_machine")) do
			if v:IsOn() then 
			if SERVER then
				self:EmitSound("enemies/bosses/shrek/taunt4.wav")
				v:SetTargetPriority(TARGET_PRIORITY_SPECIAL)
		self.Target = v
		self.Funny = true
		self.loco:SetDesiredSpeed(220)
			    self:SetRunSpeed(220)
		break
			end
		end
		end
	self:PlaySequenceAndWait("enrage")

				self:StartActivity( ACT_RUN )
				
			
			--fuckyoukid = true
			
				self.loco:SetDesiredSpeed(225)
			    self:SetRunSpeed(225)
				self:SetSpecialAnimation(false)
				self:SetInvulnerable(false)
				self:SetBlockAttack(false)
				self.NextAction = CurTime() + math.random(1, 5)
				self.NextClawTime = CurTime() + math.random(10, 13)
			
			self.NextAction = CurTime() + math.random(1, 5)
			self.NextFlameTime = CurTime() + math.random(20, 30)
		end
	end

function ENT:IsValidTarget( ent )
	if not ent then return false end
	return IsValid( ent ) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
end

-- This function is run every time a path times out, once every 1 seconds of pathing

if CLIENT then
	local eyeGlow =  Material( "sprites/redglow1" )
	local white = Color( 255, 255, 255, 255 )
	local lightglow = Material( "sprites/physg_glow1_noz" )
	local lightyellow = Color( 255, 255, 200, 200 )
	local clawglow = Material( "sprites/orangecore1" )
	local clawred = Color( 255, 100, 100, 255 )
end

function ENT:OnRemove()
	if IsValid(self.ClawHook) then self.ClawHook:Remove() end
	if IsValid(self.GrabbedPlayer) then self.GrabbedPlayer:SetMoveType(MOVETYPE_WALK) end
	if IsValid(self.FireEmitter) then self.FireEmitter:Finish() end
end

function ENT:StartFlames(time)
	self:Stop()
	if time then self:TimedEvent(time, function() self:StopFlames() end) end
end

function ENT:StopFlames()
	self:SetStop(false)
end

function ENT:OnInjured(dmg)
	if helmet then
	dmg:ScaleDamage(0.5)
	if self:Health() < 2000 then
	helmet = false
	end
	else
	dmg:ScaleDamage(1)
if  !hasTaunted then
--self:EmitSound("dir/idle_hitpalm1.mp3",511)
self:EmitSound("enemies/bosses/shrek/taunt2.wav",511)
self:SetBodygroup(1,1)
self.loco:SetDesiredSpeed(300)
self:SetRunSpeed(300)
hasTaunted = true
end
end
end

function ENT:OnThink()

if math.random(0,2500) == 1 then
self:EmitSound("enemies/bosses/shrek/taunt"..math.random(1,4)..".wav")
end
	if self:GetFlamethrowing() then
		if !self.NextFireParticle or self.NextFireParticle < CurTime() then
			local bone = self:LookupBone("j_elbow_ri")
			local pos, ang = self:GetBonePosition(bone)
			pos = pos - ang:Forward() * 40 - ang:Up()*10
			if CLIENT then
				if !IsValid(self.FireEmitter) then self.FireEmitter = ParticleEmitter(self:GetPos(), false) end
				
				local p = self.FireEmitter:Add("particles/fire1.vmt", pos)
				if p then
					p:SetColor(math.random(30,60), math.random(40,70), math.random(0,50))
					p:SetStartAlpha(255)
					p:SetEndAlpha(0)
					p:SetVelocity(ang:Forward() * -150 + ang:Up()*math.random(-5,5) + ang:Right()*math.random(-5,5))
					p:SetLifeTime(0.25)

					p:SetDieTime(math.Rand(0.75, 1.5))

					p:SetStartSize(math.random(1, 5))
					p:SetEndSize(math.random(20, 30))
					p:SetRoll(math.random(-180, 180))
					p:SetRollDelta(math.Rand(-0.1, 0.1))
					p:SetAirResistance(50)

					p:SetCollide(false)

					p:SetLighting(false)
				end
			else
				if IsValid(self.GrabbedPlayer) then
					if self.GrabbedPlayer:GetPos():DistToSqr(self:GetPos()) > 10000 then
						self:ReleasePlayer()
						self:StopFlames()
						self.loco:SetDesiredSpeed(self:GetRunSpeed())
						self:SetSpecialAnimation(false)
						self:SetBlockAttack(false)	
						self:SetStop(false)
					else
						local dmg = DamageInfo()
						dmg:SetAttacker(self)
						dmg:SetInflictor(self)
						dmg:SetDamage(2)
						dmg:SetDamageType(DMG_BURN)
						
						self.GrabbedPlayer:TakeDamageInfo(dmg)
						self.GrabbedPlayer:Ignite(1, 0)
					end
				else
					local tr = util.TraceHull({
						start = pos,
						endpos = pos - ang:Forward()*150,
						filter = self,
						--mask = MASK_SHOT,
						mins = Vector( -5, -5, -10 ),
						maxs = Vector( 5, 5, 10 ),
					})
					
					debugoverlay.Line(pos, pos - ang:Forward()*150)
					
					if self:IsValidTarget(tr.Entity) then
						local dmg = DamageInfo()
						dmg:SetAttacker(self)
						dmg:SetInflictor(self)
						dmg:SetDamage(2)
						dmg:SetDamageType(DMG_BURN)
						
						tr.Entity:TakeDamageInfo(dmg)
						tr.Entity:Ignite(2, 0)
					end
				end
			end
			
			self.NextFireParticle = CurTime() + 0.05
		end
	elseif CLIENT and self.FireEmitter then
		self.FireEmitter:Finish()
		self.FireEmitter = nil
	end
	
	if SERVER and IsValid(self.GrabbedPlayer) and !self:IsValidTarget(self.GrabbedPlayer) then
		self:ReleasePlayer()
		self:StopFlames()
	end
end

function ENT:GrabPlayer(ply)
	if CLIENT then return end
	
	
	self:SetUsingClaw(false)
	self:SetStop(false)
	self.loco:SetDesiredSpeed(self:GetRunSpeed())
	
	if self:IsValidTarget(ply) then
		self.GrabbedPlayer = ply
		
		self:TimedEvent(0, function()
			local att = self:GetAttachment(self:LookupAttachment("clawlight"))
			local pos = att.Pos + att.Ang:Forward()*10
			
			ply:SetPos(pos - Vector(0,0,50))
			ply:SetMoveType(MOVETYPE_NONE)
		end)
		
		
		self:SetSequence(self:LookupSequence("nz_grapple_flamethrower"))
		self:SetCycle(0)
		self:StartFlames()
	--[[elseif ply then
		self.loco:SetDesiredSpeed(self:GetRunSpeed())
		self:SetSpecialAnimation(false)
		self:SetBlockAttack(false)
		self:SetStop(false)]]
	else
		
	end
end

function ENT:ReleasePlayer()
	if IsValid(self.GrabbedPlayer) then
		self.GrabbedPlayer:SetMoveType(MOVETYPE_WALK)
	end
	if IsValid(self.ClawHook) then
		self.ClawHook:Release()
	end
	if !self:GetFlamethrowing() then
		self:SetStop(false)
	end
	self:SetUsingClaw(false)
	self:SetStop(false)
	self.loco:SetDesiredSpeed(self:GetRunSpeed())
end


function ENT:OnBarricadeBlocking( barricade )
	if (IsValid(barricade) and barricade:GetClass() == "breakable_entry" ) then
		if barricade:GetNumPlanks() > 0 then
			timer.Simple(0.3, function()

				for i = 1, barricade:GetNumPlanks() do
					barricade:EmitSound("physics/wood/wood_plank_break" .. math.random(1, 4) .. ".wav", 100, math.random(90, 130))
					barricade:RemovePlank()
				end

			end)

			self:SetAngles(Angle(0,(barricade:GetPos()-self:GetPos()):Angle()[2],0))
			
			local seq, dur

			local attacktbl = self.ActStages[1] and self.ActStages[1].attackanims or self.AttackSequences
			local target = type(attacktbl) == "table" and attacktbl[math.random(#attacktbl)] or attacktbl
			
			if type(target) == "table" then
				seq, dur = self:LookupSequenceAct(target.seq)
			elseif target then -- It is a string or ACT
				seq, dur = self:LookupSequenceAct(target)
			else
				seq, dur = self:LookupSequence("swing")
			end
			
			self:SetAttacking(true)
			self:PlaySequenceAndWait(seq, 1)
			self:SetLastAttack(CurTime())
			self:SetAttacking(false)
			self:UpdateSequence()
			if coroutine.running() then
				coroutine.wait(2 - dur)
			end

			-- this will cause zombies to attack the barricade until it's destroyed
			local stillBlocked = self:CheckForBarricade()
			if stillBlocked then
				self:OnBarricadeBlocking(stillBlocked)
				return
			end

			-- Attacking a new barricade resets the counter
			self.BarricadeJumpTries = 0
		elseif barricade:GetTriggerJumps() and self.TriggerBarricadeJump then
			local dist = barricade:GetPos():DistToSqr(self:GetPos())
			if dist <= 3500 + (1000 * self.BarricadeJumpTries) then
				self:TriggerBarricadeJump()
				self.BarricadeJumpTries = 0
			else
				-- If we continuously fail, we need to increase the check range (if it is a bigger prop)
				self.BarricadeJumpTries = self.BarricadeJumpTries + 1
				-- Otherwise they'd get continuously stuck on slightly bigger props :(
			end
		else
			self:SetAttacking(false)
		end
	end
end
