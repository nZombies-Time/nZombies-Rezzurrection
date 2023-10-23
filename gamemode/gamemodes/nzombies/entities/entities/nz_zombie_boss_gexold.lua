AddCSLuaFile()

ENT.Base = "nz_zombiebase"
ENT.PrintName = "Gecko Griefer"
ENT.Category = "Brainz"
ENT.Author = "Laby"

ENT.Models = { "models/bosses/gecko.mdl" }

ENT.AttackRange = 90
ENT.DamageLow = 1
ENT.DamageHigh = 2

ENT.AttackSequences = {
	{seq = "h2hattackleft"},
	{seq = "h2hattackright"},
	{seq = "h2hattackpower"},
}

ENT.DeathSequences = {
	"idle"
}

ENT.AttackSounds = {
	"barricade/repair_ching.ogg"

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
	"fosounds/vj_forpnpcs/gecko/npc_gecko_claw_atk_vox_02.mp3",
	"fosounds/vj_forpnpcs/gecko/npc_gecko_claw_atk_vox_03.mp3",
	"fosounds/vj_forpnpcs/gecko/npc_gecko_claw_atk_vox_01.mp3",

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
		self.Funny = false
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
		wallet = 0
		specialHit = 0
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
	local seq = "getup"
	local tr = util.TraceLine({
		start = self:GetPos() + Vector(0,0,500),
		endpos = self:GetPos(),
		filter = self,
		mask = MASK_SOLID_BRUSHONLY,
	})
	if tr.Hit then seq = "getup" end
	local _, dur = self:LookupSequence(seq)

	-- play emerge animation on spawn
	-- if we have a coroutine else just spawn the zombie without emerging for now.
	if coroutine.running() then
		
		local pos = self:GetPos() + (seq == "spawn" and Vector(0,0,100) or Vector(0,0,450))
		
		
		self:EmitSound("fosounds/vj_forpnpcs/gecko/npc_gecko_claw_atk_vox_01.mp3",511)
	self:SetInvulnerable(true)
		
		--[[effectData = EffectData()
		effectData:SetStart( pos + Vector(0, 0, 1000) )
		effectData:SetOrigin( pos )
		effectData:SetMagnitude( 0.75 )
		util.Effect("lightning_strike", effectData)]]
				for k,v in pairs(ents.FindByClass("power_box")) do
		
				--self:EmitSound("enemies/bosses/cb/taunt_staff2.ogg")
				v:SetTargetPriority(TARGET_PRIORITY_NONE)
				end
				
		self:TimedEvent(dur, function()
			--dust cloud
			self:SetPos(self:GetPos() + Vector(0,0,0))
			self:SetInvulnerable(false)
			local effectData = EffectData()
			effectData:SetStart( self:GetPos() )
			effectData:SetOrigin( self:GetPos() )
			effectData:SetMagnitude(1)
			
		end)
		wallet = 0
		specialHit = 0
		self:SetTarget(self:GetPriorityTarget())
		self:PlaySequenceAndWait(seq)
	end
end

function ENT:OnZombieDeath(dmgInfo)
	local geckoslayer = dmgInfo:GetAttacker()
	geckoslayer:GivePoints(wallet)
	self:ReleasePlayer()
	self:StopFlames()
	self:SetNoDraw( true )
	self:SetRunSpeed(0)
	self.loco:SetVelocity(Vector(0,0,0))
	self:Stop()
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	local seq, dur = self:LookupSequence(self.DeathSequences[math.random(#self.DeathSequences)])
	self:ResetSequence(seq)
	self:SetCycle(0)
self:EmitSound("fosounds/vj_forpnpcs/gecko/npc_gecko_death_01.mp3")
		if IsValid(self) then
			self:Remove()
			ParticleEffect("bo3_panzer_explosion",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
		end

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

function ENT:GriefRetarget(roll)

 if SERVER then
print(wallet)
	if roll == 3 then
	print("perk")
		--TIME TO GO DRINKING BABY
		local perks = ents.FindByClass("perk_machine")
	local machine = perks[math.random(#perks)]
	if IsValid(machine) and machine:IsOn() and machine:GetPrice() < wallet then 
	self.Target:SetTargetPriority(TARGET_PRIORITY_NONE)
	machine:SetTargetPriority(TARGET_PRIORITY_FUNNY)
				self.Target = machine
				specialHit = 5
				print(specialHit)
				else
				self:GriefRetarget(4)
		end
	end
	if roll == 4 then
		--GECKO NEEDS A NEW GLIZZY
		print("wallgun")
		local gats = ents.FindByClass("wall_buys")
	local gat = gats[math.random(#gats)]
	if IsValid(gat) and tonumber(gat:GetPrice()) < wallet  then 
	self.Target:SetTargetPriority(TARGET_PRIORITY_NONE)
	gat:SetTargetPriority(TARGET_PRIORITY_FUNNY)
				self.Target = gat
				specialHit = 5
				print(specialHit)
		end
	end
		if roll == 1 then
		--wario im gonna eat your box
		print("box")
		local boxes = ents.FindByClass("random_box")
	local box = boxes[math.random(#boxes)]
	if IsValid(box) and 950 < wallet and not box.Moving  then 
	self.Target:SetTargetPriority(TARGET_PRIORITY_NONE)
	box:SetTargetPriority(TARGET_PRIORITY_FUNNY)
				self.Target = box
				specialHit = 1
				print(specialHit)
				else
				self:GriefRetarget(4)
		end
	end
	
		if roll == 2 then
		--wario im gonna eat your box
		print("fizz")
		local fizzs = ents.FindByClass("wunderfizz_machine")
	local fizz = fizzs[math.random(#fizzs)]
	if IsValid(fizz) and fizz:IsOn() and 1500 < wallet  then 
	self.Target:SetTargetPriority(TARGET_PRIORITY_NONE)
	fizz:SetTargetPriority(TARGET_PRIORITY_FUNNY)
				self.Target = fizz
				specialHit = 2
				print(specialHit)
				else
				self:GriefRetarget(4)
		end
	end
		
		if roll == 0 then
		--wario im gonna eat your box
		local switches = ents.FindByClass("power_box")
	local power = switches[math.random(#switches)]
	if IsValid(power) then 
	self.Target:SetTargetPriority(TARGET_PRIORITY_NONE)
	power:SetTargetPriority(TARGET_PRIORITY_FUNNY)
				self.Target = power
				specialHit = 4
				print(specialHit)
		end
	end
		end
end

function ENT:OnTargetInAttackRange()
	
   	 local atkData = {}
    atkData.dmglow = 1
    atkData.dmghigh = 1
	atkData.dmgdelay = 0.2
    self:Attack( atkData )
	local myTarget = self:GetTarget()
	if myTarget:IsPlayer() and  not self.Funny then

	wallet = myTarget:GetPoints()
	print(wallet)
	myTarget:TakePoints(myTarget:GetPoints())
	self.Funny = true
	local trolling1 =  math.random(1, 4)
	self:GriefRetarget(trolling1)
	else
	
	local waste = self:GetTarget()
	waste:SetTargetPriority(TARGET_PRIORITY_NONE)
	
		if specialHit == 1 then
		specialHit = 0
		--box
		wallet = wallet - 950
		waste:MoveAway()
			local trolling2 =  math.random(2, 4)
			waste:SetTargetPriority(TARGET_PRIORITY_NONE)
		self:GriefRetarget(trolling2)
		end
		if specialHit == 2 then
		specialHit = 0
		--fizz
		wallet = wallet - 1500
		waste:MoveLocation()
		local trolling3 =  math.random(3, 4)
		waste:SetTargetPriority(TARGET_PRIORITY_NONE)
		self:GriefRetarget(trolling3)
		end
		if specialHit == 3 then
		specialHit = 0
		--teleporter
		wallet = wallet - waste:GetPrice()
		waste:SetCooldown(true)
		local trolling4 =  math.random(1, 4)
		waste:SetTargetPriority(TARGET_PRIORITY_NONE)
		self:GriefRetarget(trolling4)
		end
		if specialHit == 4 then
		specialHit = 0
		--power_box
		nzElec:Reset(true)
		waste:SetTargetPriority(TARGET_PRIORITY_NONE)
		self:Remove()
		end
		if specialHit == 5 then
		specialHit = 0
		--wallgun or perk
		wallet = wallet -  tonumber(waste:GetPrice())
			local trolling5 =  math.random(1, 2)
			waste:SetTargetPriority(TARGET_PRIORITY_NONE)
		self:GriefRetarget(trolling5)
		end
	
	end

end

function ENT:OnPathTimeOut()

	end

-- This function is run every time a path times out, once every 1 seconds of pathing

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
				self:StartActivity( ACT_RUN )
				self.loco:SetDesiredSpeed( self:GetRunSpeed() )
			end
			return
		end

		coroutine.yield()

	end

end
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


function ENT:OnThink()
if !self:GetSpecialAnimation() and not self:IsAttacking() and self:IsValid() then 
	if !counting and !dying and self:Health() > 0 and self:IsValid() then
	counting = true
		timer.Simple(0.5,function()
		if self:IsValid() then
		self:EmitSound("fosounds/vj_forpnpcs/gecko/fs_gecko_01.mp3")
		counting = false
		end
		end)
	end
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

function ENT:IsValidTarget( ent )
	if not ent then return false end
	return IsValid( ent ) 
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
