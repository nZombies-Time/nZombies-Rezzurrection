AddCSLuaFile()

ENT.Base = "nz_zombiebase"
ENT.PrintName = "Sentinel Bot"
ENT.Category = "Brainz"
ENT.Author = "Laby"

ENT.Models = { "models/nzr/enemies/sentinel/sentinel.mdl" }

ENT.AttackRange = 180
ENT.DamageLow = 20
ENT.DamageHigh = 30


ENT.AttackSequences = {
	{seq = "att2", dmgtimes = {1.3,1.6,1.9}}
}

ENT.DeathSequences = {
	"death"
}
ENT.AttackSounds = {
	"enemies/specials/bot/main_fire_start.wav",
	"enemies/specials/bot/funny/attack1.wav",
	"enemies/specials/bot/funny/attack2.wav",
	"enemies/specials/bot/funny/attack3.wav",
	"enemies/specials/bot/funny/attack4.wav",
	"enemies/specials/bot/funny/attack5.wav",
	"enemies/specials/bot/funny/attack6.wav",
	"enemies/specials/bot/funny/attack7.wav",
	"enemies/specials/bot/funny/attack8.wav",
	"enemies/specials/bot/funny/attack9.wav",
	"enemies/specials/bot/funny/attack10.wav"

}

ENT.PainSounds = {
		"physics/flesh/flesh_impact_bullet1.wav",
	"physics/flesh/flesh_impact_bullet2.wav",
	"physics/flesh/flesh_impact_bullet3.wav",
	"physics/flesh/flesh_impact_bullet4.wav",
	"physics/flesh/flesh_impact_bullet5.wav"

}

ENT.AttackHitSounds = {
	"enemies/specials/bot/break_00.wav"
}

ENT.WalkSounds = {
	"empty.wav",
	"enemies/specials/bot/funny/taunt1.wav",
	"enemies/specials/bot/funny/taunt2.wav",
	"enemies/specials/bot/funny/taunt3.wav",
	"enemies/specials/bot/funny/taunt4.wav",
	"enemies/specials/bot/funny/taunt5.wav",
	"enemies/specials/bot/funny/taunt6.wav",
	"enemies/specials/bot/funny/taunt7.wav",
	"enemies/specials/bot/funny/taunt8.wav",
	"enemies/specials/bot/funny/taunt9.wav",
	"enemies/specials/bot/funny/taunt10.wav",
	"enemies/specials/bot/funny/taunt11.wav",
	"enemies/specials/bot/funny/taunt12.wav"
}

ENT.ActStages = {
	[1] = {
		act = ACT_WALK,
		minspeed = 1,
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

	self:SetCollisionBounds(Vector(-17,-17, 0), Vector(17, 17, 70))

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
		
		self.ouch = 0 -- Used to save how much damage the light has taken
		self:SetUsingClaw(false)
		
		self.NextAction = 0
		self.NextClawTime = 0
		self.NextFlameTime = 0
	end
	
	self.ZombieAlive = true

end

function ENT:StatsInitialize()
	if SERVER then
		self:SetRunSpeed(150)
		self:SetHealth(250)
		self:SetMaxHealth(20000)
		shooting = false
		dying = false
		helmet = true
		counting = false
		hasTaunted = false
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
	local seq = "intro"
	local tr = util.TraceLine({
		start = self:GetPos() + Vector(0,0,500),
		endpos = self:GetPos(),
		filter = self,
		mask = MASK_SOLID_BRUSHONLY,
	})
	if tr.Hit then seq = "intro" end
	local _, dur = self:LookupSequence(seq)

	-- play emerge animation on spawn
	-- if we have a coroutine else just spawn the zombie without emerging for now.
	if coroutine.running() then
		
		local pos = self:GetPos() + (seq == "intro" and Vector(0,0,100) or Vector(0,0,450))
	
		self:SetSpecialAnimation(true)
		--SWAG INCOMING
		ParticleEffectAttach("bo3_panzer_engine",PATTACH_POINT_FOLLOW,self,2)
			ParticleEffectAttach("bo3_panzer_engine",PATTACH_POINT_FOLLOW,self,3)
		self:EmitSound("enemies/specials/bot/funny/spawn" .. math.random(1, 4) .. ".wav")
		self:EmitSound("enemies/specials/bot/incoming/incoming.wav",100)
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
			
			self:StartActivity( ACT_WALK )
			self:EmitSound("enemies/specials/bot/incoming/incoming_land.wav",100)
			self:EmitSound("enemies/specials/bot/incoming/incoming_unwrap.wav",100)
			
				self.loco:SetDesiredSpeed( self:GetRunSpeed() )
				self:SetSpecialAnimation(false)
				self:SetBlockAttack(false)
				PrintTable( self:GetMaterials())
				 
		end)
		self:PlaySequenceAndWait(seq)
	end
	--THERE ARE NO HOES HERE

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
	--FUCK YOU, BITCH
self:EmitSound("enemies/specials/bot/funny/death" .. math.random(1, 11) .. ".wav")
	timer.Simple(dur, function()
		if IsValid(self) then
		
		local target = self:GetTarget()
	-- Claw
		if self:IsValidTarget(target) then
			local tr = util.TraceLine({
				start = self:GetPos() + Vector(0,50,0),
				endpos = target:GetPos() + Vector(0,0,50),
				filter = self,
			})
			ParticleEffect("bo3_panzer_explosion",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
			self.ClawHook = ents.Create("nz_suicideisbadass")
				self.ClawHook:SetPos(self:GetPos() + Vector(0,0,50))
				self.ClawHook:Spawn()
				self.ClawHook:Launch(((tr.Entity:GetPos() + Vector(0,0,50)) - self.ClawHook:GetPos()):GetNormalized())
			--self.fuck = ents.Create("nz_mangler_shot")
				--self.fuck:SetPos(self:GetPos())
				--self.fuck:Spawn()
					self:Remove()
					
		end
	end
end)
end

function ENT:BodyUpdate()

	self.CalcIdeal = ACT_IDLE

	local velocity = self:GetVelocity()

	local len2d = velocity:Length2D()

	--if ( len2d > 100 ) then self.CalcIdeal = ACT_RUN elseif ( len2d > 5 ) then self.CalcIdeal = ACT_RUN end

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
    atkData.dmgforce = Vector( 0, 0, 0 )
    self:Attack( atkData )

end

function ENT:OnPathTimeOut()
	local target = self:GetTarget()
	if CurTime() < self.NextAction then return end
	
	if math.random(0,1) == 1  then
	
	-- Claw
	self:EmitSound("enemies/specials/bot/funny/ranged" .. math.random(1, 7) .. ".wav")
		if self:IsValidTarget(target) then
		
			self:Stop()
			self:SetSpecialAnimation(true)
			self:SetBlockAttack(true)
			self:TimedEvent( 1.5, function()
			self.loco:FaceTowards( self:GetTarget():GetPos() )
				local tr = util.TraceLine({
				start = self:GetPos(),
				endpos = target:GetPos(),
				filter = self,
			})
			local shootPos = self:GetAttachment(5).Pos
		local bullet = {}
		bullet.Num = 5
		bullet.Src = self:GetAttachment(5).Pos
		bullet.Dir = (target:GetPos() - self:GetPos()):GetNormalized()
		bullet.Spread = Vector(0.05,0.05,0.05)
		bullet.Tracer	= 0
		bullet.HullSize	= 21
		bullet.Force = math.random(10)*math.random(4)
		bullet.Damage	= 10
		bullet.AmmoType = "Pistol"
		bullet.Filter = {self}
		bullet.Callback = function(ent, tr, dmg)
			dmg:SetAttacker(self)
			dmg:SetInflictor(self)
			util.ParticleTracerEx("sentinel_laser",
				self:GetAttachment(7).Pos,tr.HitPos,
				false,self:EntIndex(),7
			)
		end
		self:FireBullets(bullet)
		end)
		self.loco:FaceTowards( target:GetPos() )
		self:PlaySequenceAndWait("att1")
				self:StartActivity( ACT_WALK )
				self.loco:SetDesiredSpeed( self:GetRunSpeed() )
				self:SetSpecialAnimation(false)
				self:SetBlockAttack(false)
				self:StopFlames()
			
				self.NextAction = CurTime() + math.random(1, 5)
				self.NextClawTime = CurTime() + math.random(3, 15)
			
			
		end
		
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
	function ENT:Draw()
		self:DrawModel()
	local bone = self:GetAttachment(self:LookupAttachment("center_core"))
	local pos, ang = bone.Pos, bone.Ang
	-- ang:RotateAroundAxis(ang:Up(),90)
	
	local lightglow = Material( "sprites/physg_glow1_noz" )
	local lightyellow = Color( 255, 255, 200, 200 )
	local finalpos = pos + Vector(0,0,3.5)

	cam.Start3D2D(finalpos, ang, 1)
		surface.SetAlphaMultiplier(1)
		surface.SetMaterial(lightglow)
		surface.SetDrawColor(lightyellow)
		surface.DrawTexturedRect(-25,-10,100,20)
	cam.End3D2D()
	
	ang:RotateAroundAxis(ang:Forward(),90)

	cam.Start3D2D(finalpos, ang, 1)
		surface.SetAlphaMultiplier(1)
		surface.SetMaterial(lightglow)
		surface.SetDrawColor(lightyellow)
		surface.DrawTexturedRect(-25,-10,100,20)
	cam.End3D2D()
	end
end

function ENT:OnRemove()
	
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
self:SetSubMaterial( 0,"shit")
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
