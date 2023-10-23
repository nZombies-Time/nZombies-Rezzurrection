AddCSLuaFile()

ENT.Base = "nz_zombiebase"
ENT.PrintName = "Gecko Griefer"
ENT.Category = "Brainz"
ENT.Author = "Laby"

ENT.Models = { "models/bosses/gecko.mdl" }

ENT.AttackRange = 90
ENT.DamageLow = 1
ENT.DamageHigh = 2
ENT.Purchases = 0

ENT.AttackSequences = {
	{seq = "h2hattackleft"},
	{seq = "h2hattackright"},
	{seq = "h2hattackpower"},
}

ENT.DeathSequences = {
	"idle"
}

ENT.AttackSounds = {
	"nz/effects/buy.wav"
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

		self.Funny = nil
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
		self.TargetsToIgnore = {}
	end
end

function ENT:SpecialInit()
	if CLIENT then
		--make them invisible for a really short duration to blend the emerge sequences
		self:SetNoDraw(true)
		self:TimedEvent(0.5, function()
			self:SetNoDraw(false)
		end)

		self:SetRenderClipPlaneEnabled( true )
		self:SetRenderClipPlane(self:GetUp(), self:GetUp():Dot(self:GetPos()))

		self:TimedEvent(2, function()
			self:SetRenderClipPlaneEnabled(false)
		end)
	end
end

function ENT:InitDataTables()
	//self:NetworkVar("Int", 0, "Wallet")
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
		self:EmitSound("enemies/bosses/gex/gex_".. math.random(6) .. ".wav",511)
		self:SetInvulnerable(true)

		self:TimedEvent(dur, function()
			self:SetPos(self:GetPos() + Vector(0,0,0))
			self:SetInvulnerable(false)
		end)
		self.Funny = nil
		wallet = 0
		specialHit = 0

		self:PlaySequenceAndWait(seq)
	end
end

function ENT:OnZombieDeath(dmgInfo)
	if wallet > 0 and IsValid(self.Funny) then
		self.Funny:GivePoints(wallet)
	end

	self:SetNoDraw(true)
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
		ParticleEffect("nbnz_gib_explosion",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
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
	if CLIENT then return end

	print(wallet)
if wallet < 950 then
roll = 0
end
	if roll == 0 then //fork in the electrical socket
		print("power")

		local switches = ents.FindByClass("power_box")
		local power = nil
		for k, v in RandomPairs(switches) do
			power = v
			break
		end

		if IsValid(power) then 
			self.Target:SetTargetPriority(TARGET_PRIORITY_NONE)
			power:SetTargetPriority(TARGET_PRIORITY_FUNNY)
			self:SetTarget(power)
			self.Target = power
			specialHit = 4
			print(specialHit)
		else
			self:GriefRetarget(4)
		end
	end

	if roll == 1 then --wario im gonna eat your box
		print("box")

		local boxes = ents.FindByClass("random_box")
		local box = nil
		for k, v in RandomPairs(boxes) do
			if self:CanAfford(950) and not v.Moving then
				box = v
				break
			end
		end

		if IsValid(box) then 
			self.Target:SetTargetPriority(TARGET_PRIORITY_NONE)
			box:SetTargetPriority(TARGET_PRIORITY_FUNNY)
			self:SetTarget(box)
			self.Target = box
			specialHit = 1
			print(specialHit)
		else
			self:GriefRetarget(4)
		end
	end

	if roll == 2 then //alcholism
		print("fizz")

		local fizzs = ents.FindByClass("wunderfizz_machine")
		local fizz = nil
		for k, v in RandomPairs(fizzs) do
			if v:IsOn() and self:CanAfford(1500) then
				fizz = v
				break
			end
		end

		if IsValid(fizz) then 
			self.Target:SetTargetPriority(TARGET_PRIORITY_NONE)
			fizz:SetTargetPriority(TARGET_PRIORITY_FUNNY)
			self:SetTarget(fizz)
			self.Target = fizz
			specialHit = 2
			print(specialHit)
		else
			self:GriefRetarget(3)
		end
	end

	if roll == 3 then --TIME TO GO DRINKING BABY
		print("perk")

		local perks = ents.FindByClass("perk_machine")
		local machine = nil
		for k, v in RandomPairs(perks) do
			if v:IsOn() and self:CanAfford(v:GetPrice()) then
				machine = v
				break
			end
		end

		if IsValid(machine) then 
		self:SetTarget(machine)
			self.Target:SetTargetPriority(TARGET_PRIORITY_NONE)
			machine:SetTargetPriority(TARGET_PRIORITY_FUNNY)
			self.Target = machine
			specialHit = 5
			print(specialHit)
		else
			self:GriefRetarget(4)
		end
	end

	if roll == 4 then --GECKO NEEDS A NEW GLIZZY
		print("wallgun")

		local gats = ents.FindByClass("wall_buys")
		local gat = nil
		for k, v in RandomPairs(gats) do
			if self:CanAfford(v:GetPrice()) then
				gat = v
				break
			end
		end

		if IsValid(gat) then 
			self.Target:SetTargetPriority(TARGET_PRIORITY_NONE)
			gat:SetTargetPriority(TARGET_PRIORITY_FUNNY)
			self:SetTarget(gat)
			self.Target = gat
			specialHit = 5
			print(specialHit)
		end
	end
end

function ENT:CanAfford(price)
	if not price then return false end
	return (wallet - tonumber(price)) > 0
end

function ENT:OnTargetInAttackRange()
	local atkData = {}
	atkData.dmglow = 1
	atkData.dmghigh = 1
	atkData.dmgdelay = 0.2
	self:Attack( atkData )

	local target = self:GetTarget()
	if target:IsPlayer() and wallet == 0 then
		wallet = target:GetPoints()
		target:TakePoints(target:GetPoints())
		self:EmitSound("enemies/bosses/gex/gex_".. math.random(6) .. ".wav",511)
		self.Funny = target
		self:GriefRetarget(math.random(4)) //when given only one input, the range for math.random starts at 1 instead of 0

		print(wallet)
	else
		local waste = self:GetTarget()
		--waste:SetTargetPriority(TARGET_PRIORITY_NONE)

		if specialHit == 1 then --box
			specialHit = 0
			wallet = wallet - 950
			waste:MoveAway()
			waste:SetTargetPriority(TARGET_PRIORITY_NONE)

			--local trolling2 = math.random(2,4)
			self:GriefRetarget(math.random(4))

			self.Purchases = self.Purchases + 1
			self.TargetsToIgnore[self.Purchases] = waste
		end

		if specialHit == 2 then --fizz
			specialHit = 0
			wallet = wallet - 1500
			waste:MoveLocation()
			waste:SetTargetPriority(TARGET_PRIORITY_NONE)

			--local trolling3 = math.random(3,4)
			self:GriefRetarget(math.random(4))

			self.Purchases = self.Purchases + 1
			self.TargetsToIgnore[self.Purchases] = waste
		end

		if specialHit == 3 then --teleporter
			specialHit = 0
			wallet = wallet - waste:GetPrice()
			waste:SetCooldown(true)
			waste:SetTargetPriority(TARGET_PRIORITY_NONE)

			--local trolling4 = math.random(1,4)
			self:GriefRetarget(math.random(4))

			self.Purchases = self.Purchases + 1
			self.TargetsToIgnore[self.Purchases] = waste
		end

		if specialHit == 4 then --power_box
			specialHit = 0
			nzElec:Reset(true)
			waste:SetTargetPriority(TARGET_PRIORITY_NONE)
			self.Funny = nil
			self:EmitSound("fosounds/vj_forpnpcs/gecko/npc_gecko_death_01.mp3")
			ParticleEffect("nbnz_gib_explosion",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)

			self:Remove()

			self.Purchases = self.Purchases + 1
			self.TargetsToIgnore[self.Purchases] = waste
		end

		if specialHit == 5 then --wallgun or perk
			specialHit = 0
			wallet = wallet - tonumber(waste:GetPrice())
			waste:SetTargetPriority(TARGET_PRIORITY_NONE)

			--local trolling5 = math.random(1,3)
			self:GriefRetarget(math.random(4))

			self.Purchases = self.Purchases + 1
			self.TargetsToIgnore[self.Purchases] = waste
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

function ENT:IsValidTarget( ent )
	if not ent then return false end
	return IsValid( ent ) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
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

function ENT:OnRemove()
end
