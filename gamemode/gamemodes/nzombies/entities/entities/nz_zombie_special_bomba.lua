AddCSLuaFile()

ENT.Base = "nz_zombiebase"
ENT.PrintName = "Bomb Zombie"
ENT.Category = "Brainz"
ENT.Author = "Laby"

ENT.Models = { "models/roach/codz_megapack/ww2/bmb.mdl"}

ENT.AttackRange = 70
ENT.DamageLow = 30
ENT.DamageHigh = 40


ENT.AttackSequences = {
	{seq = "att1", dmgtimes = {0.23}},
	{seq = "att2", dmgtimes = {0.83,1.36}}
}

ENT.DeathSequences = {
	"death1",
	"death2",
	"death3"
}

ENT.AttackSounds = {
	"codz_megapack/ww2/bomber/vox/zvox_bmb_growl_lev3_01.wav","codz_megapack/ww2/bomber/vox/zvox_bmb_growl_lev3_02.wav",
		"codz_megapack/ww2/bomber/vox/zvox_bmb_growl_lev3_03.wav","codz_megapack/ww2/bomber/vox/zvox_bmb_growl_lev3_04.wav",
		"codz_megapack/ww2/bomber/vox/zvox_bmb_growl_lev3_05.wav","codz_megapack/ww2/bomber/vox/zvox_bmb_growl_lev4_01.wav",
		"codz_megapack/ww2/bomber/vox/zvox_bmb_growl_lev4_02.wav","codz_megapack/ww2/bomber/vox/zvox_bmb_growl_lev4_03.wav",
		"codz_megapack/ww2/bomber/vox/zvox_bmb_growl_lev4_04.wav","codz_megapack/ww2/bomber/vox/zvox_bmb_growl_lev4_05.wav"
}

ENT.AttackHitSounds = {
	"roach/bo3/_zhd_player_impacts/evt_zombie_hit_player_01.mp3",
	"roach/bo3/_zhd_player_impacts/evt_zombie_hit_player_02.mp3",
	"roach/bo3/_zhd_player_impacts/evt_zombie_hit_player_03.mp3",
	"roach/bo3/_zhd_player_impacts/evt_zombie_hit_player_04.mp3"
}

ENT.PainSounds = {
	"physics/flesh/flesh_impact_bullet1.wav",
	"physics/flesh/flesh_impact_bullet2.wav",
	"physics/flesh/flesh_impact_bullet3.wav",
	"physics/flesh/flesh_impact_bullet4.wav",
	"physics/flesh/flesh_impact_bullet5.wav"
}

ENT.WalkSounds = {
		"codz_megapack/ww2/bomber/vox/zvox_bmb_taunt_01.wav","codz_megapack/ww2/bomber/vox/zvox_bmb_taunt_02.wav",
		"codz_megapack/ww2/bomber/vox/zvox_bmb_taunt_03.wav","codz_megapack/ww2/bomber/vox/zvox_bmb_taunt_04.wav",
		"codz_megapack/ww2/bomber/vox/zvox_bmb_taunt_05.wav","codz_megapack/ww2/bomber/vox/zvox_bmb_taunt_06.wav",
		"codz_megapack/ww2/bomber/vox/zvox_bmb_taunt_07.wav","codz_megapack/ww2/bomber/vox/zvox_bmb_taunt_08.wav",
		"codz_megapack/ww2/bomber/vox/zvox_bmb_taunt_09.wav"
}

ENT.ActStages = {
	[1] = {
		act = ACT_WALK,
		minspeed = 1,
	},
	[2] = {
		act = ACT_WALK_ANGRY,
		minspeed = 1,
	},
	[3] = {
		act = ACT_RUN,
		minspeed = 180,
	},
	[4] = {
		act = ACT_RUN,
		minspeed = 200
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
	self:SetTargetCheckRange(2000) -- 0 for no distance restriction (infinite)

	--target ignore
	self:ResetIgnores()

	self:SetHealth( 75 ) --fallback

	self:SetRunSpeed( self.RunSpeed ) --fallback
	self:SetWalkSpeed( self.WalkSpeed ) --fallback

	self:SetCollisionBounds(Vector(-20,-20, 0), Vector(20, 20, 90))

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
		
		self.HelmetDamage = 0 -- Used to save how much damage the light has taken
		self:SetUsingClaw(false)
		
		self.NextAction = 0
		self.NextClawTime = 0
		self.NextFlameTime = 0
	end
	
	self.ZombieAlive = true

end

function ENT:StatsInitialize()
	if SERVER then
		hasExploded = false
		self:SetRunSpeed(200)
		self:SetHealth(1000)
		self:SetMaxHealth(3000)
		dying = false
		counting = true
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

	local seq = "emerge"
	local tr = util.TraceLine({
		start = self:GetPos() + Vector(0,0,500),
		endpos = self:GetPos(),
		filter = self,
		mask = MASK_SOLID_BRUSHONLY,
	})
    if tr.Hit then 
        seq = "emerge"
    end
    local _, dur = self:LookupSequence(seq)

    self.spawning = true
    timer.Simple(dur, function()
        self:ResetSequence( math.random(5, 7) )
        self.spawning = false
    end)

	-- play emerge animation on spawn
	-- if we have a coroutine else just spawn the zombie without emerging for now.
	if coroutine.running() then
	    local pos = self:GetPos() + (seq == "emerge" and Vector(0,0,100) or Vector(0,0,450))
		ParticleEffect("bo3_zombie_spawn",self:LocalToWorld(Vector(40,-20,0)),Angle(0,0,0),nil)
		local effectData = EffectData()
		effectData:SetStart( pos )
		effectData:SetOrigin( pos )
		effectData:SetMagnitude(1)
		self:EmitSound("codz_megapack/ww2/bomber/vox/zvox_bmb_spawn_01.wav",511)
        self:SetInvulnerable(true)
		
		--[[effectData = EffectData()
		effectData:SetStart( pos + Vector(0, 0, 1000) )
		effectData:SetOrigin( pos )
		effectData:SetMagnitude( 0.75 )
		util.Effect("lightning_strike", effectData)]]
		
		self:TimedEvent(dur, function()
			--dust cloud
			self:SetInvulnerable(false)
			local effectData = EffectData()
			effectData:SetStart( self:GetPos() )
			effectData:SetOrigin( self:GetPos() )
			effectData:SetMagnitude(1)
	
			self.loco:SetDesiredSpeed(200)
			counting = false
		end)
		self:PlaySequenceAndWait(seq)
	end
end

function ENT:OnZombieDeath()
dying = true
	if !hasExploded then
        self:SetNoDraw(true)
        hasExploded = true
        self:EmitSound("bo1_overhaul/nap/explode.mp3",511)
            local ent = ents.Create("env_explosion")
        ent:SetPos(self:GetPos())
        ent:SetAngles(self:GetAngles())
        ent:Spawn()
        ent:SetKeyValue("imagnitude", "200")
        ent:Fire("explode")
            local entParticle = ents.Create("info_particle_system")
            entParticle:SetKeyValue("start_active", "1")
            entParticle:SetKeyValue("effect_name", "napalm_postdeath_napalm")
            entParticle:SetPos(self:GetPos())
            entParticle:SetAngles(self:GetAngles())
            entParticle:Spawn()
            entParticle:Activate()
            entParticle:Fire("kill","",20)
            local vaporizer = ents.Create("point_hurt")
            if !vaporizer:IsValid() then return end
            vaporizer:SetKeyValue("Damage", 22)
            vaporizer:SetKeyValue("DamageRadius", 150)
            vaporizer:SetKeyValue("DamageType",DMG_BURN)
            vaporizer:SetPos(self:GetPos())
            vaporizer:SetOwner(self)
            vaporizer:Spawn()
            vaporizer:Fire("TurnOn","",0)
            vaporizer:Fire("kill","",20)
        self:SetRunSpeed(0)
        self.loco:SetVelocity(Vector(0,0,0))
        self:Stop()
        local seqstr = self.DeathSequences[math.random(#self.DeathSequences)]
        local seq, dur = self:LookupSequence(seqstr)
        -- Delay it slightly; Seems to fix it instantly getting overwritten
        timer.Simple(0, function() 
            if IsValid(self) then
                self:ResetSequence(seq)
                self:SetCycle(0)
                self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
            end 
        end)

        timer.Simple(dur + 1, function()
            if IsValid(self) then
                self:Remove()
            end
        end)
        
        if self.DeathSounds then
            self:EmitSound( self.DeathSounds[ math.random( #self.DeathSounds ) ], 100)
        end
	else
	    self:ResetSequence(seq)
        self:SetCycle(0)
        self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
        self:Remove()
    end
end

function ENT:BodyUpdate()
    
	self.CalcIdeal = ACT_WALK

	local velocity = self:GetVelocity()

	local len2d = velocity:Length2D()

    if ( len2d > 60 ) then 
        self.CalcIdeal = ACT_WALK 
    elseif ( len2d > 5 ) then 
        self.CalcIdeal = ACT_WALK 
    end

	if self:IsJumping() and self:WaterLevel() <= 0 then
		self.CalcIdeal = ACT_JUMP
	end

	if !self:GetSpecialAnimation() and !self:IsAttacking() then
        if self:GetActivity() != self.CalcIdeal and !self:GetStop() then 
            self:ResetSequence(5) 
            self:StartActivity(self.CalcIdeal) 
        end

        local curseq = self:GetSequence()
        if !self.spawning and (curseq != 5 and curseq != 6 and curseq != 7) then
            self:ResetSequence( math.random(5, 7) )
        end

        if self.ActStages[self:GetActStage()] then
			self:BodyMoveXY()
		end
    end
    
	self:FrameAdvance()

end

function ENT:OnTargetInAttackRange()
    local atkData = {}
    atkData.dmglow = 10
    atkData.dmghigh = 20
    atkData.dmgforce = Vector( 0, 0, 0 )
    atkData.dmgdelay = 1.0
    self:Attack( atkData )

    self:OnZombieDeath()
end

function ENT:OnPathTimeOut()
    --self:ResetSequence(5)
end

function ENT:IsValidTarget( ent )
	if !ent then return false end
	return IsValid( ent ) and ent:GetTargetPriority() != TARGET_PRIORITY_NONE and ent:GetTargetPriority() != TARGET_PRIORITY_SPECIAL
	-- Won't go for special targets (Monkeys), but still MAX, ALWAYS and so on
end

-- This function is run every time a path times out, once every 1 seconds of pathing

if CLIENT then
	local eyeGlow =  Material( "sprites/redglow1" )
	local white = Color( 255, 255, 255, 255 )
	local lightglow = Material( "sprites/physg_glow1_noz" )
	local lightyellow = Color( 255, 255, 200, 200 )
	local clawglow = Material( "sprites/orangecore1" )
	local clawred = Color( 255, 100, 100, 255 )
	function ENT:Draw()
		self:DrawModel()
		
		local dlight = DynamicLight( self:EntIndex() )
		if ( dlight ) then
			local bone = self:LookupBone("j_spinelower")
			local pos, ang = self:GetBonePosition(bone)
			pos = pos + ang:Right()*-8 + ang:Forward()*25
			dlight.pos = pos
			dlight.r = 255
			dlight.g = 255
			dlight.b = 255
			dlight.brightness = 10
			dlight.Decay = 1000
			dlight.Size = 16
			dlight.DieTime = CurTime() + 1
			dlight.dir = ang:Right() + ang:Forward()
			dlight.innerangle = 1
			dlight.outerangle = 1
			dlight.style = 0
			dlight.noworld = true
		end

	end
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

function ENT:OnThink()
if !counting and !dying and self:Health() > 0 then
counting = true
timer.Simple(0.8,function()
self:EmitSound("bo1_overhaul/nap/step"..math.random(1,3)..".mp3")
counting = false
end)
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
