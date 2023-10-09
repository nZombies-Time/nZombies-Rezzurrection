AddCSLuaFile()

ENT.Base = "nz_zombiebase"
ENT.PrintName = "Fuel Junkie"
ENT.Category = "Brainz"
ENT.Author = "Zet0r"

ENT.Models = { "models/bosses/takieater.mdl" }

ENT.AttackRange = 130
ENT.DamageLow = 40
ENT.DamageHigh = 60

ENT.RedEyes = true

ENT.AttackSequences = {
	{seq = "shriek3", dmgtimes = {0.9}}
}

ENT.DeathSequences = {
	"suicide3"
}

ENT.AttackSounds = {
	"nz/zombies/attack/attack_00.wav",
	"nz/zombies/attack/attack_01.wav",
	"nz/zombies/attack/attack_02.wav",
	"nz/zombies/attack/attack_03.wav",
	"nz/zombies/attack/attack_04.wav",
	"nz/zombies/attack/attack_05.wav",
	"nz/zombies/attack/attack_06.wav",
	"nz/zombies/attack/attack_07.wav",
	"nz/zombies/attack/attack_08.wav",
	"nz/zombies/attack/attack_14.wav",
	"nz/zombies/attack/attack_15.wav",
	"nz/zombies/attack/attack_16.wav",
	"nz/zombies/attack/attack_17.wav",
	"nz/zombies/attack/attack_18.wav",
	"nz/zombies/attack/attack_19.wav",
	"nz/zombies/attack/attack_21.wav",
	"nz/zombies/attack/attack_22.wav",
	"enemies/zombies/zombie/attack/attack_n_1.ogg",
	"enemies/zombies/zombie/attack/attack_n_2.ogg",
	"enemies/zombies/zombie/attack/attack_n_3.ogg",
	"enemies/zombies/zombie/attack/attack_n_4.ogg",
	"enemies/zombies/zombie/attack/attack_n_5.ogg",
	"enemies/zombies/zombie/attack/attack_n_6.ogg",
}

ENT.PainSounds = {
	"physics/flesh/flesh_impact_bullet1.wav",
	"physics/flesh/flesh_impact_bullet2.wav",
	"physics/flesh/flesh_impact_bullet3.wav",
	"physics/flesh/flesh_impact_bullet4.wav",
	"physics/flesh/flesh_impact_bullet5.wav"
}

ENT.WalkSounds = {
	"enemies/bosses/shrieker/amb1.ogg",
	"enemies/bosses/shrieker/amb2.ogg",
	"enemies/bosses/shrieker/amb3.ogg"
}

ENT.ActStages = {
	[1] = {
		act = ACT_WALK,
		minspeed = 5,
	},
	[2] = {
		act = ACT_WALK,
		minspeed = 50,
	},
	[3] = {
		act = ACT_RUN,
		minspeed = 60,
	},
	[4] = {
		act = ACT_RUN,
		minspeed = 300,
	},
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
	self:SetTargetCheckRange(0) -- 0 for no distance restriction (infinite)

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
		self:SetRunSpeed(200)
		self:SetHealth(1000)
		self:SetMaxHealth(1000)
		shooting = false
		dying = false
		helmet = true
		counting = false
	end
	self:SetCollisionBounds(Vector(-15,-15, 0), Vector(15, 15, 100))

	--PrintTable(self:GetSequenceList())
end

function ENT:SpecialInit()

	if CLIENT then
		--make them invisible for a really short duration to blend the emerge sequences
		self:SetNoDraw(true)
		self:TimedEvent( 0.15, function()
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
	local seq = "land"
	local tr = util.TraceLine({
		start = self:GetPos() + Vector(0,0,500),
		endpos = self:GetPos(),
		filter = self,
		mask = MASK_SOLID_BRUSHONLY,
	})
	if tr.Hit then seq = "land" end
	local _, dur = self:LookupSequence(seq)

	-- play emerge animation on spawn
	-- if we have a coroutine else just spawn the zombie without emerging for now.
	if coroutine.running() then
		self:SetSpecialAnimation(true)
		local pos = self:GetPos() + (seq == "flinch_head_2" and Vector(0,0,100) or Vector(0,0,450))
		counting = true
		self:EmitSound("enemies/bosses/nap/spawn.ogg",511)
		local entParticle = ents.Create("info_particle_system")
		entParticle:SetKeyValue("start_active", "1")
		entParticle:SetKeyValue("effect_name", "napalm_emerge")
		entParticle:SetPos(self:GetPos())
		entParticle:SetAngles(self:GetAngles())
		entParticle:Spawn()
		entParticle:Activate()
		entParticle:Fire("kill","",1)
		ParticleEffectAttach("firestaff_victim_burning",PATTACH_ABSORIGIN_FOLLOW,self,0)
		self:TimedEvent(dur, function()
		counting = false
		self:SetSpecialAnimation(false)
		end)
		
		self:PlaySequenceAndWait(seq)
		
	end
end

function ENT:OnZombieDeath(dmgInfo)
	dying = true
	self:ReleasePlayer()
	self:StopFlames()
	self:SetRunSpeed(0)
	self.loco:SetVelocity(Vector(0,0,0))
	self:Stop()
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	local seq, dur = self:LookupSequence(self.DeathSequences[math.random(#self.DeathSequences)])
	self:ResetSequence(seq)
	self:SetCycle(0)

self:EmitSound("bo1_overhaul/son/amb1.mp3")

	timer.Simple(dur, function()
		if IsValid(self) then
			
			util.ScreenShake(self:GetPos(),12,400,3,1000)
			self:EmitSound("enemies/bosses/nap/explode.ogg",511)
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
			--util.Effect("Explosion", effectData)
			self:Remove()
		end
	end)

end

function ENT:BodyUpdate()

	self.CalcIdeal = ACT_IDLE

	local velocity = self:GetVelocity()

	local len2d = velocity:Length2D()

	if ( len2d > 60 ) then self.CalcIdeal = ACT_RUN elseif ( len2d > 5 ) then self.CalcIdeal = ACT_WALK end

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
	self.NextFlameTime = CurTime() + 1
    local atkData = {}
    atkData.dmglow = 30
    atkData.dmghigh = 50
    atkData.dmgforce = Vector( 0, 0, 0 )
	atkData.dmgdelay = 1
    self:Attack( atkData )
end

function ENT:IsValidTarget( ent )
	if not ent then return false end
	return IsValid( ent ) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
end

-- This function is run every time a path times out, once every 1 seconds of pathing
function ENT:OnPathTimeOut()
	local target = self:GetTarget()
	if CurTime() < self.NextAction then return end
	
	if math.random(0,5) == 6 and CurTime() > self.NextClawTime then
		-- Claw
		
	elseif CurTime() > self.NextFlameTime then
		-- Flamethrower
		if self:IsValidTarget(target) and self:GetPos():DistToSqr(target:GetPos()) <= 75000 then	
			self:Stop()
			--self:PlaySequenceAndWait("att_ft")
			self.loco:SetDesiredSpeed(0)
			local ang = (target:GetPos() - self:GetPos()):Angle()
			self:SetAngles(Angle(ang[1], ang[2] + 10, ang[3]))
			
			self:StartFlames()
			local seq =  "shriek1"
			local id, dur = self:LookupSequence(seq)
			self:ResetSequence(id)
			self:SetCycle(0)
			self:SetPlaybackRate(1)
			self:SetVelocity(Vector(0,0,0))
			
			self:TimedEvent(dur-0.3, function()
				self.loco:SetDesiredSpeed(100)
				self:SetSpecialAnimation(false)
				self:SetBlockAttack(false)
				self:StopFlames()
			end)
			
			self.NextAction = CurTime() + math.random(1, 5)
			self.NextFlameTime = CurTime() + math.random(10, 20)
		end
	end
end

if CLIENT then
	local eyeGlow =  Material( "sprites/redglow1" )
	local white = Color( 255, 255, 255, 255 )
	local lightglow = Material( "sprites/physg_glow1_noz" )
	local lightyellow = Color( 255, 255, 200, 200 )
	local clawglow = Material( "sprites/orangecore1" )
	local clawred = Color( 255, 100, 100, 255 )
	function ENT:Draw()
		self:DrawModel()
		

		
		--if self.RedEyes then
			--local eyes = self:GetAttachment(self:LookupAttachment("eyes")).Pos
			--local leftEye = eyes + self:GetRight() * -1.5 + self:GetForward() * 0.5
			--local rightEye = eyes + self:GetRight() * 1.5 + self:GetForward() * 0.5

			--local leftEye = self:GetAttachment(self:LookupAttachment("lefteye")).Pos
			--local rightEye = self:GetAttachment(self:LookupAttachment("righteye")).Pos
			--cam.Start3D()
				--render.SetMaterial( eyeGlow )
				--render.DrawSprite( leftEye, 4, 4, white)
				--render.DrawSprite( rightEye, 4, 4, white)
			--cam.End3D()
		--end
		if GetConVar( "nz_zombie_debug" ):GetBool() then
			render.DrawWireframeBox(self:GetPos(), Angle(0,0,0), self:OBBMins(), self:OBBMaxs(), Color(255,0,0), true)
			render.DrawWireframeSphere(self:GetPos(), self:GetAttackRange(), 10, 10, Color(255,165,0), true)
		end
		
		--debugoverlay.Cross(finalpos, 5)
		--debugoverlay.Line(finalpos, finalpos + ang:Forward()*10, 1, Color(0,255,0))
		--debugoverlay.Line(finalpos, finalpos + ang:Right()*5, 1, Color(0,255,0))
	
	end
end


function ENT:OnRemove()
	if IsValid(self.ClawHook) then self.ClawHook:Remove() end
	if IsValid(self.GrabbedPlayer) then self.GrabbedPlayer:SetMoveType(MOVETYPE_WALK) end
	if IsValid(self.FireEmitter) then self.FireEmitter:Finish() end
end

function ENT:StartFlames(time)
	self:Stop()
	--self:EmitSound("codz_megapack/zmb/ai/mechz2/v2/flame/start.wav")
	
	timer.Simple(0.7, function()
	self:EmitSound("enemies/bosses/nap/spawn.ogg")
	self:EmitSound("enemies/bosses/shrieker/scream.ogg")
	self:SetFlamethrowing(true)
	end)
end

function ENT:StopFlames()
self:StopParticles()
ParticleEffectAttach("firestaff_victim_burning",PATTACH_ABSORIGIN_FOLLOW,self,0)
	self:SetFlamethrowing(false)
	self:SetStop(false)
end

function ENT:OnThink()
if self:IsAttacking() then
self:SetSpecialAnimation(true)
self.loco:SetDesiredSpeed(0)
self:SetVelocity(Vector(0,0,0))
timer.Simple(2.5, function()self:SetSpecialAnimation(false)end)
end
if !self:IsAttacking() then
if !counting and !dying and !shooting and self:Health() > 0 and !self:GetFlamethrowing() and !self:GetSpecialAnimation() then
counting = true
timer.Simple(0.32,function()
self:EmitSound("enemies/bosses/nap/step"..math.random(1,3)..".ogg")
counting = false
end)
end
end

	if self:GetFlamethrowing() then
		if !self.NextFireParticle or self.NextFireParticle < CurTime() then
			local bone = self:LookupBone("tag_origin")
			local pos, ang = self:GetBonePosition(bone)
			pos = pos + Vector( 20 ,20, 50 )
			if CLIENT then
				if !IsValid(self.FireEmitter) then self.FireEmitter = ParticleEmitter(self:GetPos(), false) end
				
				ParticleEffectAttach("bo3_panzer_flame",PATTACH_POINT_FOLLOW,self,1)
				--ParticleEffect("bo3_panzer_flame", pos, ang, self )
			else
					local tr = util.TraceHull({
						start = pos,
						endpos = pos + ang:Forward()*300,
						filter = self,
						--mask = MASK_SHOT,
						mins = Vector( -5, -5, -10 ),
						maxs = Vector( 5, 5, 10 ),
					})
					
					debugoverlay.Line(pos, pos + ang:Forward()*300)
					
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
			
			self.NextFireParticle = CurTime() + 0.05
		end
	elseif CLIENT and self.FireEmitter then
		self.FireEmitter:Finish()
		self.FireEmitter = nil
	end
	
end

function ENT:GrabPlayer(ply)
	if CLIENT then return end
	
	self:SetBodygroup(2,0)
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
				seq, dur = self:LookupSequence("att1")
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
