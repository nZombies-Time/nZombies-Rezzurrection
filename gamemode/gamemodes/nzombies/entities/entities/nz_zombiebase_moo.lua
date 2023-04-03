AddCSLuaFile()

CreateConVar( "nz_zombie_debug", "0", { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_CHEAT } )

ENT.Base = "base_nextbot"
ENT.Type = "nextbot"
ENT.Category = "Brainz"
ENT.Author = "Lolle, Zet0r, GhostlyMoo, Ethorbit, FlamingFox"
ENT.Spawnable = true

ENT.DeathDropHeight = 99999999999 -- Moo Mark. This doesn't actually mean it'll kill them... It just limits the height zombies can drop from.
ENT.StepHeight = 24
ENT.JumpHeight = 90
ENT.AttackRange = 115
ENT.CrawlAttackRange = 70
ENT.DamageRange = 75
ENT.RunSpeed = 200
ENT.WalkSpeed = 150
ENT.Acceleration = 500

ENT.TraversalCheckRange = 40

local eyetrails = GetConVar("nz_zombie_eye_trails") -- I've considered for those who don't have this... Your welcome.
local comedyday = os.date("%d-%m") == "01-04"

--[[-------------------------------------------------------------------------
Localization/optimization
---------------------------------------------------------------------------]]
local CurTime = CurTime
local type = type
local Path = Path

local coroutine = coroutine
local ents = ents
local math = math
local hook = hook

ENT.bIsZombie = true
ENT.bSelfHandlePath = true -- PathFollower will not auto-check for barricades or navlocks


--The Accessors will be partially shared, but should only be used serverside
AccessorFunc( ENT, "fWalkSpeed", "WalkSpeed", FORCE_NUMBER)
AccessorFunc( ENT, "fRunSpeed", "RunSpeed", FORCE_NUMBER)
AccessorFunc( ENT, "fAttackRange", "AttackRange", FORCE_NUMBER)
AccessorFunc( ENT, "fLastLand", "LastLand", FORCE_NUMBER)
AccessorFunc( ENT, "fLastTargetCheck", "LastTargetCheck", FORCE_NUMBER)
AccessorFunc( ENT, "fLastAtack", "LastAttack", FORCE_NUMBER)
AccessorFunc( ENT, "fLastHurt", "LastHurt", FORCE_NUMBER)
AccessorFunc( ENT, "fLastTargetChange", "LastTargetChange", FORCE_NUMBER)
AccessorFunc( ENT, "fTargetCheckRange", "TargetCheckRange", FORCE_NUMBER)

AccessorFunc( ENT, "fTraversalCheckRange", "TraversalCheckRange", FORCE_NUMBER)


--Stuck prevention
AccessorFunc( ENT, "fLastPostionSave", "LastPostionSave", FORCE_NUMBER)
AccessorFunc( ENT, "fLastPush", "LastPush", FORCE_NUMBER)
AccessorFunc( ENT, "iStuckCounter", "StuckCounter", FORCE_NUMBER)
AccessorFunc( ENT, "vStuckAt", "StuckAt")
AccessorFunc( ENT, "bTimedOut", "TimedOut")
AccessorFunc( ENT, "bTargetUnreachable", "TargetUnreachable", FORCE_BOOL)

-- fleeing (by Ethorbit)
AccessorFunc( ENT, "bFleeing", "Fleeing", FORCE_BOOL)
AccessorFunc( ENT, "fLastFlee", "LastFlee", FORCE_NUMBER)

-- spawner accessor
AccessorFunc(ENT, "hSpawner", "Spawner")

AccessorFunc( ENT, "bJumping", "Jumping", FORCE_BOOL)
AccessorFunc( ENT, "bAttacking", "Attacking", FORCE_BOOL)
AccessorFunc( ENT, "bStandingAttack", "StandingAttack", FORCE_BOOL)
AccessorFunc( ENT, "bClimbing", "Climbing", FORCE_BOOL)
AccessorFunc( ENT, "bWandering", "Wandering", FORCE_BOOL)
AccessorFunc( ENT, "bStop", "Stop", FORCE_BOOL)
AccessorFunc( ENT, "bSpecialAnim", "SpecialAnimation", FORCE_BOOL)
AccessorFunc( ENT, "bBlockAttack", "BlockAttack", FORCE_BOOL)
AccessorFunc( ENT, "bCrawler", "Crawler", FORCE_BOOL)
AccessorFunc( ENT, "bTeleporting", "Teleporting", FORCE_BOOL)
AccessorFunc( ENT, "bShouldDie", "SpecialShouldDie", FORCE_BOOL)
AccessorFunc( ENT, "bIsBusy", "IsBusy", FORCE_BOOL)

AccessorFunc( ENT, "m_bTargetLocked", "TargetLocked", FORCE_BOOL) -- Stops the Zombie from retargetting and keeps this target while it is valid and targetable
AccessorFunc( ENT, "iActStage", "ActStage", FORCE_NUMBER)

ENT.ActStages = {}

if CLIENT then
	ENT.RedEyes = true
end

function ENT:SetupDataTables()
	self:NetworkVar("Bool", 0, "Decapitated")
	self:NetworkVar("Bool", 1, "Alive")
	self:NetworkVar("Bool", 2, "MooSpecial")
	self:NetworkVar("Bool", 3, "WaterBuff")

	if self.InitDataTables then self:InitDataTables() end
end

function ENT:Precache()
	if self.AttackSounds then
		for _,v in pairs(self.AttackSounds) do
			util.PrecacheSound( v )
		end
	end

	if self.AttackHitSounds then
		for _,v in pairs(self.AttackHitSounds) do
			util.PrecacheSound( v )
		end
	end

	if self.PainSounds then
		for _,v in pairs(self.PainSounds) do
			util.PrecacheSound( v )
		end
	end

	if self.DeathSounds then
		for _,v in pairs(self.DeathSounds) do
			util.PrecacheSound( v )
		end
	end

	if self.WalkSounds then
		for _,v in pairs(self.WalkSounds) do
			util.PrecacheSound( v )
		end
	end

	if self.RunSounds then
		for _,v in pairs(self.RunSounds) do
			util.PrecacheSound( v )
		end
	end
end

if SERVER then
	function ENT:UpdateModel()
		local models = self.Models
		local choice = models[math.random(#models)]
		util.PrecacheModel( choice.Model )
		self:SetModel(choice.Model)
		if choice.Skin then self:SetSkin(choice.Skin) end
		--[[if choice.Bodygroups then
			for k,v in pairs(choice.Bodygroups) do
				self:SetBodygroup(k,v)
			end
		end]]
		for i,v in ipairs(self:GetBodyGroups()) do
			self:SetBodygroup( i-1, math.random(0, self:GetBodygroupCount(i-1) - 1))
		end
	end
	--Init
	function ENT:Initialize()

		self:Precache()
		self:UpdateModel()

		self:SetLastHurt(0)
		self:SetJumping( false )
		self:SetLastLand( CurTime() + 1 ) --prevent jumping after spawn
		self:SetLastTargetCheck( CurTime() )
		self:SetLastTargetChange( CurTime() )

		--stuck prevetion
		self:SetLastPush( CurTime() )
		self:SetLastPostionSave( CurTime() )
		self:SetStuckAt( self:GetPos() )
		self:SetStuckCounter( 0 )
		self:SetTargetUnreachable(false)
		self:SetWandering(false)
		self:SetAttacking( false )
		self:SetStandingAttack( false )

		self.ShouldWalk = false
		self.ShouldCrawl = false
		
		self.Climbing = false
		self.NextClimb = 0
		self.AttackRangeUpdate = 0

		self:SetWaterBuff( false )

		--[[Gib Related Shit]]--
		self:SetCrawler( false )
		self.LArmOff = nil
		self.RArmOff = nil
		self.LlegOff = nil
		self.RlegOff = nil
		--[[Gib Related Shit]]--

		self:SetLastAttack( CurTime() )
		self:SetAttackRange( self.AttackRange )
		self:SetTraversalCheckRange( self.TraversalCheckRange )

		if  nzMapping.Settings.range then
			self:SetTargetCheckRange(nzMapping.Settings.range)
			if nzMapping.Settings.range <= 0 then
				self:SetTargetCheckRange(60000) -- A map can't go bigger than 60,000.
			end
		else
			self:SetTargetCheckRange(2000)
		end	-- 0 for no distance restriction (infinite)

		self:ResetIgnores()

		self:SetHealth( 75 )
		self:SetRunSpeed( self.RunSpeed )
		self:SetWalkSpeed( self.WalkSpeed )

		self:SetCollisionBounds(Vector(-12,-12, 0), Vector(12, 12, 70))

		self:SetActStage(0)
		self:SetSpecialAnimation(false)
		self:SetSpecialShouldDie(false) -- Used for anims where the zombie reacts to something and they should die after the anim finishes. 
		self:SetIsBusy(false) -- Used for shit like the barricades

		self.SSpeedNotSet = false
		self.StartSpeed = 0

		self.SameSquare = true

		self:SetNextRetarget(0)
		self:SetFleeing(false)
		self:SetLastFlee(0)

		self.HasSTaunted = nil -- Zombies should only ever Super Taunt once.

		self:StatsInitialize()
		self:SpecialInit()
		self:CreateTrigger()

		if SERVER then
			self.loco:SetDeathDropHeight( self.DeathDropHeight )
			self.loco:SetDesiredSpeed( self:GetRunSpeed() )
			self.loco:SetAcceleration( self.Acceleration )
			self.loco:SetJumpHeight( self.JumpHeight )
			self.DesiredSpeed = self:GetRunSpeed()
			self:SpeedChanged()
			if GetConVar("nz_zombie_lagcompensated"):GetBool() then
				self:SetLagCompensated(true)
			end
			self.BarricadeJumpTries = 0

			self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
			self:SetAlive(true)


			--[[ EYE TRAILS ]]--

			-- These look cool but will bring your game to it's knees if you got a pc of the wooden variety.
			local defaultColor = Color(255, 75, 0, 255)
			local eyeColor = !IsColor(nzMapping.Settings.zombieeyecolor) and defaultColor or nzMapping.Settings.zombieeyecolor
			local latt = self:LookupAttachment("lefteye")
			local ratt = self:LookupAttachment("righteye")

			local rand = math.Rand(0.1,0.2)
			if latt and ratt then
				if eyetrails ~= nil and eyetrails:GetInt() == 1 and !self.IsMooSpecial then
					if math.random(2) == 1 then
						self.spritetrail = util.SpriteTrail(self, latt, eyeColor, true, 5, 0, rand, 0.1, "effects/laser_citadel1.vmt")
						self.spritetrail2 = util.SpriteTrail(self, ratt, eyeColor, true, 5, 0, rand, 0.1, "effects/laser_citadel1.vmt")
					end
				end
			end
			--[[ EYE TRAILS ]]--
		end
	end

	function ENT:SpecialInit() end
	function ENT:StatsInit() end

	function ENT:SpeedChanged()
		if self.SpeedBasedSequences then
			self:UpdateMovementSequences()
		end
		timer.Simple(engine.TickInterval(), function() -- This is SUPER scuffed and odious but it allows for Zombies to use their movement anim's tag_origin move speed instead of the one given to them by code.
			if not self:Alive() then return end 
			self:UpdateMovementSpeed() -- Moo Mark. 2/1/23: The code here has been turned into a separate function.
		end)
	end

	function ENT:UpdateMovementSpeed()
		local seq = self:ResetMovementSequence()
		local speed = self:GetSequenceGroundSpeed( self:GetSequence() )
		self:SetRunSpeed( speed )
		self.loco:SetDesiredSpeed( self:GetRunSpeed() )
		self.DesiredSpeed = self:GetRunSpeed()
		if !self.SSpeedNotSet then
			self.SSpeedNotSet = true
			self.StartSpeed = self:GetRunSpeed() -- This is so we have a way of saving the zombie's original speed.
		end
	end
end

function ENT:CreateTrigger() -- By Ethorbit, Zombies now have triggers that cover their collision bounds so we can do really cool things like force projectiles to collide!
	if CLIENT then return end

	self:RemoveTrigger()

	self.CollisionTrigger = ents.Create("nz_trigger")
	self.CollisionTrigger:SetPos(self:GetPos())
	self.CollisionTrigger:SetAngles(self:GetAngles())
	self.CollisionTrigger:SetParent(self, 0)

	-- No idea if this positioning will work for all entities, I know it works with Zombie, Nova Crawler, Panzer and Dogs.
	local max = self:OBBMaxs() + (self.ExtraTriggerBounds or Vector(0,0,0))
	self.CollisionTrigger:SetLocalPos(Vector(-max[1] / 2, -max[2] / 2, 0))
	self.CollisionTrigger:SetMaxBound(max)

	self.CollisionTrigger:Spawn()

	self.ForcedCollisions = {}
	self.CollisionTrigger:ListenToTriggerEvent(function(event, ent)
		if event != "Touch" then return end
		if ent:IsPlayer() then return end

		if !self.ForcedCollisions[ent] or CurTime() > self.ForcedCollisions[ent] then
			local phys_obj = ent:GetPhysicsObject()

			-- Simulate PhysicsCollide if it's defined (So projectiles actually hit us)
			if ent.PhysicsCollide then
				self.ForcedCollisions[ent] = CurTime() - 0.1

				if !IsValid(phys_obj) then
					phys_obj = ent
				end

				local ent_speed = ent:GetVelocity():Length2D()
				local ents_dir = (ent:GetPos() - self:GetPos()):GetNormalized()

				ent:PhysicsCollide({ -- Simulate PhysicsCollide (This is what most projectiles rely on)
					["HitPos"] = ent:GetPos(),
					["HitEntity"] = self,
					["OurOldVelocity"] = ent:GetVelocity(),
					["TheirOldVelocity"] = self:GetVelocity(),
					["Speed"] = ent_speed, -- Is this right?
					["HitSpeed"] = ent_speed, -- Is this right?
					["DeltaTime"] = CurTime(), -- Is this right??
					["HitNormal"] = ents_dir
				}, phys_obj)
			end
		end
	end)

	return self.CollisionTrigger
end

function ENT:RemoveTrigger()
	if CLIENT then return end
	if IsValid(self:GetTrigger()) then
		self:GetTrigger():Remove()
	end
end

function ENT:GetTrigger()
	if CLIENT then return end
	return self.CollisionTrigger
end

if SERVER then
	-- Select a spawn sequence and sound to play. This is called after everything is initialized
	function ENT:SelectSpawnSequence()
		local s
		if self.SpawnSounds then s = self.SpawnSounds[math.random(#self.SpawnSounds)] end
		return type(self.SpawnSequence) == "table" and self.SpawnSequence[math.random(#self.SpawnSequence)] or self.SpawnSequence, s
	end

	-- Collide When Possible
	local collidedelay = 0.25
	local bloat = Vector(5,5,0)

	function ENT:Think()
		if (self:IsAllowedToMove() and !self:GetCrawler() and self.loco:GetVelocity():Length2D() >= 145 and self.SameSquare and !self:GetIsBusy() or self:IsAllowedToMove() and self:GetAttacking() ) then -- Moo Mark
        	self.loco:SetVelocity(self:GetForward() * self:GetRunSpeed())
        end
		if self.DoCollideWhenPossible then
			if not self.NextCollideCheck or self.NextCollideCheck < CurTime() then
				local mins,maxs = self:GetCollisionBounds()
				local tr = util.TraceHull({
					start = self:GetPos(),
					endpos = self:GetPos(),
					filter = self,
					mask = MASK_NPCSOLID,
					mins = mins - bloat,
					maxs = maxs + bloat,
					ignoreworld = true
				})

				local b = tr.Entity
				if !IsValid(b) then 
					self:SetSolidMask(MASK_NPCSOLID)
					self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
					self.DoCollideWhenPossible = nil
					self.NextCollideCheck = nil
				else
					self.NextCollideCheck = CurTime() + collidedelay
				end
			end
		end

		-- We don't want to say we're stuck if it's because we're attacking or timed out and !self:GetTimedOut() 
		if !self:GetIsBusy() and !self:GetSpecialAnimation() and !self:GetAttacking() and self:GetLastPostionSave() + 4 < CurTime() then
			if self:GetPos():DistToSqr( self:GetStuckAt() ) < 10 then
				self:SetStuckCounter( self:GetStuckCounter() + 1)
				--print(self:GetStuckCounter())
			else
				self:SetStuckCounter( 0 )
			end

			if self:GetStuckCounter() > 1 then
				local tr = util.TraceHull({
					start = self:GetPos(),
					endpos = self:GetPos(),
					maxs = self:OBBMaxs(),
					mins = self:OBBMins(),
					filter = self
				})
				if !tr.HitNonWorld then
					self:ApplyRandomPush(750) -- Made this comically high so it actually PUSHES them and doesn't just breathe on them.
				end
				if self:GetStuckCounter() > 3 then
					if self.NZBossType then
						local spawnpoints = {}
						for k,v in pairs(ents.FindByClass("nz_spawn_zombie_special")) do -- Find and add all valid spawnpoints that are opened and not blocked
							if (v.link == nil or nzDoors:IsLinkOpened( v.link )) and v:IsSuitable() then
								table.insert(spawnpoints, v)
							end
						end
						local selected = spawnpoints[math.random(#spawnpoints)] -- Pick a random one
						self:SetPos(selected:GetPos())
					else
						self:RespawnZombie()
					end
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

function ENT:DebugThink()
	if GetConVar( "nz_zombie_debug" ):GetBool() then
		local spacing = Vector(0,0,64)
		local target = self:GetTarget()
		if target then
			debugoverlay.Text( self:GetPos() + spacing, tostring(target), FrameTime() * 2 )
		else
			debugoverlay.Text( self:GetPos() + spacing, "NO_TARGET", FrameTime() * 2 )
		end
		spacing = spacing + Vector(0,0,8)
		local attacking = self:IsAttacking()
		if attacking then
			debugoverlay.Text( self:GetPos() + spacing, "IN_ATTACK", FrameTime() * 2 )
		elseif self:IsTimedOut() then
			debugoverlay.Text( self:GetPos() + spacing, "TIMED_OUT", FrameTime() * 2 )
		elseif target then
			debugoverlay.Text( self:GetPos() + spacing, "MOVING_TO_TARGET", FrameTime() * 2 )
		else
			debugoverlay.Text( self:GetPos() + spacing, "ERROR", FrameTime() * 2 )
		end
		spacing = spacing + Vector(0,0,8)
		debugoverlay.Text( self:GetPos() + spacing, "HitPoints: " .. tostring(self:Health()), FrameTime() * 2 )
		spacing = spacing + Vector(0,0,8)
		debugoverlay.Text( self:GetPos() + spacing, "Speed: " .. tostring(self:GetRunSpeed()), FrameTime() * 2 )
		spacing = spacing + Vector(0,0,8)
		debugoverlay.Text( self:GetPos() + spacing, tostring(self), FrameTime() * 2 )
	end
end

------- Fields -------
ENT.SoundDelayMin = 2
ENT.SoundDelayMax = 5
ENT.BehindSoundDistance = 0 -- The distance to a target where we will play "behind sounds" instead (0 = disable). This requires ENT.BehindSounds to be set

function ENT:PlaySound(s, lvl, pitch, vol, chan, delay) --Moo Mark This part is a port of the nZu zombie base sound functions.
	local delay = delay or math.Rand(self.SoundDelayMin, self.SoundDelayMax)
	if s then
		local dur = SoundDuration(s)
		self:EmitSound(s, lvl, pitch, vol, chan)
		delay = delay + dur
	end
	self.NextSound = CurTime() + delay
end

function ENT:Sound()
	if self.BehindSoundDistance > 0 -- We have enabled behind sounds
		and IsValid(self.Target)
		and self.Target:IsPlayer() -- We have a target and it's a player within distance
		and self:GetRangeTo(self.Target) <= self.BehindSoundDistance
		and (self.Target:GetPos() - self:GetPos()):GetNormalized():Dot(self.Target:GetAimVector()) >= 0 then -- If the direction towards the player is same 180 degree as the player's aim (away from the zombie)
			self:PlaySound(self.BehindSounds[math.random(#self.BehindSounds)], 100, math.random(80, 110), 1, 2) -- Play the behind sound, and a bit louder!
	

	--[[ A big "if then" thingy for playing other sounds. ]]--
	elseif self.BO4IsShocked and self:BO4IsShocked() or self.BO4IsScorped and self:BO4IsScorped() or self.BO4IsSpinning and self:BO4IsSpinning() then
		self:PlaySound(self.ElecSounds[math.random(#self.ElecSounds)],94, math.random(80, 110), 1, 2) -- Zappy Zappy Mother Trucker
	elseif IsValid(self.Target) and self.Target:GetClass() == "nz_bo3_tac_monkeybomb" and !self.IsMooSpecial then
		self:PlaySound(self.MonkeySounds[math.random(#self.MonkeySounds)], 100, math.random(80, 110), 1, 2)
	elseif self:GetCrawler() then
		self:PlaySound(self.CrawlerSounds[math.random(#self.CrawlerSounds)],95, math.random(80, 110), 1, 2)
	elseif self.PassiveSounds then
		self:PlaySound(self.PassiveSounds[math.random(#self.PassiveSounds)],95, math.random(80, 110), 1, 2)
	else


		-- We still delay by max sound delay even if there was no sound to play
		self.NextSound = CurTime() + self.SoundDelayMax
	end
end

if SERVER then
	-- Called at the end of the RunBehaviour. For special things that happen to the zobies
	function ENT:AI() end

	function ENT:GetFleeDestination(target) -- Get the place where we are fleeing to, added by: Ethorbit
		return self:GetPos() + (self:GetPos() - target:GetPos()):GetNormalized() * (self.FleeDistance or 300)
	end

	function ENT:RunBehaviour()

		self:Retarget()
		self:SpawnZombie()

		while (true) do
			if self.EventMask and not self.DoCollideWhenPossible then
				self:SetSolidMask(MASK_NPCSOLID)
			end
			if !self:GetStop() and self:GetFleeing() then -- Admittedly this was rushed, I took no time to understand how this can be achieved with nextbot pathing so I just made a short navmesh algorithm for fleeing. Sorry. Created by Ethorbit.
				self:SetTimedOut(false)

				local target = self:GetTarget()
				if IsValid(target) then
					self:SetLastFlee(CurTime())
					self:ResetMovementSequence() -- They'll comically slide away if this isn't here.
					self:MoveToPos(self:GetFleeDestination(target), {lookahead = 0, maxage = 3})
					self:SetLastFlee(CurTime())
				end
			end
			if !self:GetFleeing() and !self:GetStop() and CurTime() > self:GetLastFlee() + 2 then
				self:SetTimedOut(false)
				local ct = CurTime()
				if ct >= self.NextRetarget then
					local oldtarget = self.Target
					self:Retarget() --The overall process of looking for targets is handled much like how it is in nZu. While it may not save much fps in solo... Turns out this can vastly help the performance of multiplayer games.
				end
				if not self:HasTarget() and not self:IsValidTarget(self:GetTarget()) then
					self:OnNoTarget()
				else
					self:UpdateAttackRange()
					local path = self:ChaseTarget()
					if path == "failed" then
						self:SetTargetUnreachable(true)
					end
					if path == "ok" then
						if self:TargetInAttackRange() then
							self:OnTargetInAttackRange()
						else
							self:TimeOut(0.1)
						end
					elseif path == "timeout" then
						self:OnPathTimeOut()
					else
						self:TimeOut(0.5)
					end
				end
			else
				self:TimeOut(1)
			end
			if not self.NextSound or self.NextSound < CurTime() and not self:GetAttacking() and self:Alive() and not self:GetDecapitated() then
				self:Sound() -- Moo Mark 12/7/22: Moved this out of the THINK function since I thought it was a little stupid.
			end
			self:AdditionalZombieStuff()
			self:AI()
		end
	end

	function ENT:TraversalCheck()
		-- ORIGINALLY TAKEN FROM THE VJBASE L4D COMMON INFECTED SNPCS!!!
		-- Moo Mark 3/18/23: Now includes a failsafe for enemies who lack climb anims.
		if !self:GetSpecialAnimation() and !self:GetAttacking() and !self.Climbing and CurTime() > self.NextClimb then

			local seq
			local target
			local anim = false
			local hasanim = false

			local finalpos = self:GetPos()
			local tr6 = util.TraceLine({start = self:GetPos() + self:GetUp()*200, endpos = self:GetPos() + self:GetUp()*200 + self:GetForward()*self.TraversalCheckRange, filter = function(ent) if (ent:GetClass() == "jumptrav_block") then return true end end}) -- 200
			local tr5 = util.TraceLine({start = self:GetPos() + self:GetUp()*160, endpos = self:GetPos() + self:GetUp()*160 + self:GetForward()*self.TraversalCheckRange, filter = function(ent) if (ent:GetClass() == "jumptrav_block") then return true end end}) -- 160
			local tr4 = util.TraceLine({start = self:GetPos() + self:GetUp()*120, endpos = self:GetPos() + self:GetUp()*120 + self:GetForward()*self.TraversalCheckRange, filter = function(ent) if (ent:GetClass() == "jumptrav_block") then return true end end}) -- 120
			local tr3 = util.TraceLine({start = self:GetPos() + self:GetUp()*96, endpos = self:GetPos() + self:GetUp()*96 + self:GetForward()*self.TraversalCheckRange, filter = function(ent) if (ent:GetClass() == "jumptrav_block") then return true end end}) -- 96
			local tr2 = util.TraceLine({start = self:GetPos() + self:GetUp()*72, endpos = self:GetPos() + self:GetUp()*72 + self:GetForward()*self.TraversalCheckRange, filter = function(ent) if (ent:GetClass() == "jumptrav_block") then return true end end}) -- 72
			local tr1 = util.TraceLine({start = self:GetPos() + self:GetUp()*48, endpos = self:GetPos() + self:GetUp()*48 + self:GetForward()*self.TraversalCheckRange, filter = function(ent) if (ent:GetClass() == "jumptrav_block") then return true end end}) -- 48
			local tr0 = util.TraceLine({start = self:GetPos() + self:GetUp()*36, endpos = self:GetPos() + self:GetUp()*36 + self:GetForward()*40, filter = function(ent) if (ent:GetClass() == "jumptrav_block") then return true end end}) -- 36
			local tru = util.TraceLine({start = self:GetPos(), endpos = self:GetPos() + self:GetUp()*200, filter = self and function(ent) if ent:IsValidZombie() then return false end end})
			
			debugoverlay.Line(self:GetPos() + self:GetUp()*200, self:GetPos() + self:GetUp()*200 + self:GetForward()*self.TraversalCheckRange, 1, Color( 255, 100, 100 ), false)
			debugoverlay.Line(self:GetPos() + self:GetUp()*160, self:GetPos() + self:GetUp()*160 + self:GetForward()*self.TraversalCheckRange, 1, Color( 255, 0, 255 ), false)
			debugoverlay.Line(self:GetPos() + self:GetUp()*120, self:GetPos() + self:GetUp()*120 + self:GetForward()*self.TraversalCheckRange, 1, Color( 255, 255, 0 ), false)
			debugoverlay.Line(self:GetPos() + self:GetUp()*96, self:GetPos() + self:GetUp()*96 + self:GetForward()*self.TraversalCheckRange, 1, Color( 255, 0, 0 ), false)
			debugoverlay.Line(self:GetPos() + self:GetUp()*72, self:GetPos() + self:GetUp()*72 + self:GetForward()*self.TraversalCheckRange, 1, Color( 0, 255, 0 ), false)
			debugoverlay.Line(self:GetPos() + self:GetUp()*48, self:GetPos() + self:GetUp()*48 + self:GetForward()*self.TraversalCheckRange, 1, Color( 0, 0, 255 ), false)
			debugoverlay.Line(self:GetPos() + self:GetUp()*36, self:GetPos() + self:GetUp()*36 + self:GetForward()*self.TraversalCheckRange, 1, Color( 255, 10, 50 ), false)

			if !IsValid(tru.Entity) then
				if IsValid(tr6.Entity) then
				local tr6b = util.TraceLine({start = self:GetPos() + self:GetUp()*260, endpos = self:GetPos() + self:GetUp()*260 + self:GetForward()*self.TraversalCheckRange, filter = function(ent) if (ent:GetClass() == "jumptrav_block") then return true end end})
				if !IsValid(tr6b.Entity) then
					if self.Climb200 then
						target = type(self.Climb200) == "table" and self.Climb200[math.random(#self.Climb200)] or self.Climb200
						seq = self:LookupSequence(target)
						hasanim = true
					end
					anim = seq or true
					finalpos = tr6.HitPos
				end
				elseif IsValid(tr5.Entity) then
					if self.Climb160 then
						target = type(self.Climb160) == "table" and self.Climb160[math.random(#self.Climb160)] or self.Climb160
						seq = self:LookupSequence(target)
						hasanim = true
					end
					anim = seq or true
					finalpos = tr5.HitPos
				elseif IsValid(tr4.Entity) then
					if self.Climb120 then
						target = type(self.Climb120) == "table" and self.Climb120[math.random(#self.Climb120)] or self.Climb120
						seq = self:LookupSequence(target)
						hasanim = true
					end
					anim = seq or true
					finalpos = tr4.HitPos
				elseif IsValid(tr3.Entity) then
					if self.Climb96 then
						target = type(self.Climb96) == "table" and self.Climb96[math.random(#self.Climb96)] or self.Climb96
						seq = self:LookupSequence(target)
						hasanim = true
					end
					anim = seq or true
					finalpos = tr3.HitPos
				elseif IsValid(tr2.Entity) then
					if self.Climb72 then
						target = type(self.Climb72) == "table" and self.Climb72[math.random(#self.Climb72)] or self.Climb72
						seq = self:LookupSequence(target)
						hasanim = true
					end
					anim = seq or true
					finalpos = tr2.HitPos
				elseif IsValid(tr1.Entity) then
					if self.Climb48 then
						target = type(self.Climb48) == "table" and self.Climb48[math.random(#self.Climb48)] or self.Climb48
						seq = self:LookupSequence(target)
						hasanim = true
					end
					anim = seq or true
					finalpos = tr1.HitPos
				elseif IsValid(tr0.Entity) then
					if self.Climb36 then
						target = type(self.Climb36) == "table" and self.Climb36[math.random(#self.Climb36)] or self.Climb36
						seq = self:LookupSequence(target)
						hasanim = true
					end
					anim = seq or true
					finalpos = tr0.HitPos
				end
			end
			if anim ~= false then
				if IsValid(self) then
					self:SolidMaskDuringEvent(MASK_NPCSOLID_BRUSHONLY)
					self:TimeOut(0.35)
					self.Climbing = true
					self:SetSpecialAnimation(true)
					self:SetPos(finalpos)
					if hasanim ~= false then
						self:PlaySequenceAndWait(anim)
					else -- For enemies that don't have a traversal for a given height or doesn't have traversal anims period.
						local effectData = EffectData()
						effectData:SetOrigin( self:GetPos() + Vector(0, 0, 50)  )
						effectData:SetMagnitude( 1 )
						effectData:SetEntity(nil)
						util.Effect("panzer_spawn_tp", effectData) -- Express Portal to their destination.
						self:TimeOut(0.25)
					end
					self:SetSpecialAnimation(false)
					self:CollideWhenPossible()
					self.Climbing = false
				end
			end
			self.NextClimb = CurTime() + 0.25
		end
	end

	function ENT:AdditionalZombieStuff()
		if not self:GetSpecialAnimation() and not self.IsMooSpecial then
			if self:GetCrawler() then
				-- Crawler based stuff goes here later.
				if self.BO3IsCooking and self:BO3IsCooking() then
					--print("Uh oh Mario, I'm about to fucking inflate lol.")
					self:SetSpecialShouldDie(true)
					self:DoSpecialAnimation(self.CrawlMicrowaveSequences[math.random(#self.CrawlMicrowaveSequences)])
				end
				if self.BO4IsFrozen and self:BO4IsFrozen() then
					--print("Uh oh Mario, I'm frozen lol.")
					self:SetSpecialShouldDie(true)
					self:DoSpecialAnimation(self.CrawlFreezeDeathSequences[math.random(#self.CrawlFreezeDeathSequences)])
				end
			else
				if self.ThundergunAnim then
					self.ThundergunAnim = false
					self:SetTarget(nil)

					--print("Uh oh Luigi, I'm about to commit insurance fraud lol.")
					self:DoSpecialAnimation(self.SlipGunSequences[math.random(#self.SlipGunSequences)])
				end
				if self.BO3IsSlipping and self:BO3IsSlipping() then
					--print("Uh oh Luigi, I've been played for a fool lol.")
					self:DoSpecialAnimation(self.SlipGunSequences[math.random(#self.SlipGunSequences)])
				end
				if self.BO3IsPulledIn and self:BO3IsPulledIn() then
					--print("Uh oh Mario, I'm getting pulled to my doom lol.")
					self:SetSpecialShouldDie(true)
					self:DoSpecialAnimation(self.IdGunSequences[math.random(#self.IdGunSequences)])
				end
				if self.BO3IsSkullStund and self:BO3IsSkullStund() then
					--print("Uh oh Mario, I'm ASCENDING lol.")
					self:DoSpecialAnimation(self.DeathRaySequences[math.random(#self.DeathRaySequences)])
				end
				if self.BO3IsMystified and self:BO3IsMystified() then
					--print("Uh oh Mario, I'm mentally deficient lol.")
					self:DoSpecialAnimation(self.UnawareSequences[math.random(#self.UnawareSequences)])
				end
				if self.BO3IsCooking and self:BO3IsCooking() then
					--print("Uh oh Mario, I'm about to fucking inflate lol.")
					self:SetSpecialShouldDie(true)
					self:DoSpecialAnimation(self.MicrowaveSequences[math.random(#self.MicrowaveSequences)])
				end
				if self.BO4IsFrozen and self:BO4IsFrozen() then
					--print("Uh oh Mario, I'm frozen lol.")
					self:SetSpecialShouldDie(true)
					self:DoSpecialAnimation(self.FreezeSequences[math.random(#self.FreezeSequences)])
				end
				if self.BO4IsToxic and self:BO4IsToxic() then
					self:FleeTarget(3)
				end
			end
		end
		if self.HasSTaunted == nil and math.random(35) == 1 and self:GetRunSpeed() <= 35 and !self:GetCrawler() and !self.IsMooSpecial then
			self.HasSTaunted = true
			self:DoSpecialAnimation(self.SuperTauntSequences[math.random(#self.SuperTauntSequences)])
			self:SetRunSpeed(36)
			self:SpeedChanged()
		end
		if self:GetRunSpeed() < 145 and nzRound:InProgress() and nzRound:GetNumber() >= 4 and !nzRound:IsSpecial() and nzRound:GetZombiesKilled() >= nzRound:GetZombiesMax() - 3 then
			self.LastZombieMomento = true
			--print("last few")
		end
		if self.LastZombieMomento and !self:GetSpecialAnimation() and !self.IsMooSpecial then
			--print("Uh oh Mario, I'm about to beat your fucking ass lol.")
			self.LastZombieMomento = false
			self:SetRunSpeed(100)
			self:SpeedChanged()
		end
	end

	function ENT:DissolveEffect() -- Places a disintegration effect on us, created by: Ethorbit
		local effect = EffectData()
		effect:SetScale(1)
		effect:SetMagnitude(1)
		effect:SetScale(3)
		effect:SetRadius(1)
		effect:SetStart(self:GetPos())
		effect:SetOrigin(self:GetPos())
		effect:SetEntity(self)
		effect:SetMagnitude(100)
		util.Effect("TeslaHitboxes", effect)

		self:EmitSound("ambient/energy/spark" .. math.random(1, 6) .. ".wav")
	end
end

function ENT:OnTakeDamage(dmginfo) -- Added by Ethorbit for implementation of the ^^^
	if SERVER then
		if (dmginfo:GetDamageType() == DMG_DISSOLVE and dmginfo:GetDamage() >= self:Health() and self:Health() > 0) then
			self:DissolveEffect()
		end

		if dmginfo:GetDamage() == 75 and dmginfo:IsDamageType(DMG_MISSILEDEFENSE) and not self:GetSpecialAnimation() then
			self.ThundergunAnim = true
		end

		self:SetLastHurt(CurTime())
	end
end

if SERVER then
	function ENT:Stop()
		self:SetStop(true)
		self:SetTarget(nil)
	end

	function ENT:SpawnZombie()
		--BAIL if no navmesh is near
		local nav = navmesh.GetNearestNavArea( self:GetPos() )
		if !self:IsInWorld() or !IsValid(nav) or nav:GetClosestPointOnArea( self:GetPos() ):DistToSqr( self:GetPos() ) >= 10000 then
			ErrorNoHalt("Zombie ["..self:GetClass().."]["..self:EntIndex().."] spawned too far away from a navmesh! (at: " .. tostring(self:GetPos()) .. ")")
			self:RespawnZombie()
		end

		self:OnSpawn()
	end

	function ENT:OnSpawn() end


	-- Moo Mark 3/27/23: The two functions below this comment are functions to stop zombies from attacking you through the world and entities(minus other zombies and players).
	function ENT:UpdateAttackRange()
		if CurTime() > self.AttackRangeUpdate and IsValid(self.Target) then
			if self:IsAttackBlocked() then
				self:SetAttackRange(1) -- For as long as the trace is hitting something, the attack range will be 1.
			else
				if self:GetCrawler() then
					self:SetAttackRange(self.CrawlAttackRange)
				else
					self:SetAttackRange(self.AttackRange) -- Revert the range back to normal if theres nothing blocking the trace.
				end
			end
			--print("Attack Range changed, new range is "..self:GetAttackRange()..".")
			self.AttackRangeUpdate = CurTime() + 1
		end
	end

	function ENT:IsAttackBlocked()
		if IsValid(self.Target) then
			local tr = util.TraceLine({
				start = self:GetPos(),
				endpos = self.Target:GetPos(),
				filter = self,
				mask = MASK_PLAYERSOLID,
				collisiongroup = COLLISION_GROUP_WORLD, -- This is what allows zombies to ignore each other.
				ignoreworld = false
			})

			-- Runs a trace from the zombie to the player to make sure theres nothing in between them.

			local ent = tr.Entity

			if IsValid(ent) and ent:IsPlayer() then return false end

			return tr.Hit
		end
	end

	function ENT:OnTargetInAttackRange()
		if !self:GetBlockAttack() then
			self:Attack()
		else
			self:TimeOut(2)
		end
	end
			
	function ENT:SelectTauntSequence() -- Supported Zombies now have the chance to play a taunt animation as they're destroying a barricade!
		local s
		return type(self.TauntSequences) == "table" and self.TauntSequences[math.random(#self.TauntSequences)] or self.TauntSequences, s
	end

	function ENT:OnBarricadeBlocking( barricade, dir )
		if not self:GetSpecialAnimation() then
			if (IsValid(barricade) and barricade:GetClass() == "breakable_entry" ) then
				
				if barricade:GetNumPlanks() > 0 then
					local warppos = barricade:GetPos() + dir * 55
					local currentpos
					local currentb = barricade
					if !self:GetIsBusy() then -- When the zombie initially comes in contact with the barricade.
						self:MoveToPos(warppos, { lookahead = 20, tolerance = 20, draw = false, maxage = 1, repath = 1, })

						self:TimeOut(0.5) -- An intentional and W@W authentic stall.
						self:SolidMaskDuringEvent(MASK_NPCSOLID_BRUSHONLY)
					end
					
					self:SetIsBusy(true)
					currentpos = self:GetPos()
					if currentpos ~= warppos then
						self:SetPos(Vector(warppos.x,warppos.y,currentpos.z))
					end
					self:SetAngles(Angle(0,(barricade:GetPos()-self:GetPos()):Angle()[2],0))

					if IsValid(barricade.ZombieUsing) then -- Moo Mark 3/15/23: Trying out something where only one zombie can actively attack a barricade at a time.
						self:TimeOut(1)
						if barricade then
							self:OnBarricadeBlocking(barricade, dir)
							return
						end
					else
						local seq, dur

						local attacktbl = self.AttackSequences
						if self:GetCrawler() then
							attacktbl = self.CrawlAttackSequences
						end

						local target = type(attacktbl) == "table" and attacktbl[math.random(#attacktbl)] or attacktbl
						local teartbl = self.BarricadeTearSequences[math.random(#self.BarricadeTearSequences)]
						local teartarget = type(teartbl) == "table" and teartbl[math.random(#teartbl)] or teartbl
					
						if not self.IsMooSpecial and not self:GetCrawler() then -- Don't let special zombies use the tear anims.
							if type(teartarget) == "table" then
								seq, dur = self:LookupSequenceAct(teartarget.seq)
							elseif teartarget then -- It is a string or ACT
								seq, dur = self:LookupSequenceAct(teartarget)
							else
								seq, dur = self:LookupSequence("swing")
							end
						else
							if type(target) == "table" then
								seq, dur = self:LookupSequenceAct(target.seq)
							elseif target then -- It is a string or ACT
								seq, dur = self:LookupSequenceAct(target)
							else
								seq, dur = self:LookupSequence("swing")
							end
						end

						local planktopull = barricade:BeginPlankPull(self)
						local planknumber -- fucking piece of shit
						if planktopull then
							planknumber = planktopull:GetFlags()
						end

						if !IsValid(barricade.ZombieUsing) then
							barricade:HasZombie(self) -- Blocks any other zombie from attacking the barricade.
						end

						if self.AttackSounds then self:PlaySound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2) end
						if !self.IsMooSpecial then
							if planknumber ~= nil then
								if !self:GetCrawler() then
									self:PlaySequenceAndWait("nz_boardtear_aligned_m_"..planknumber.."_grab")
									if IsValid(self) and self:Alive() then
										if IsValid(planktopull) then
											barricade:RemovePlank(planktopull)
										end
									end
									self:PlaySequenceAndWait("nz_boardtear_aligned_m_"..planknumber.."_pull")
								else
									self:PlaySequenceAndWait("nz_crawl_boardtear_aligned_m_"..planknumber.."_grab")
									if IsValid(self) and self:Alive() then
										if IsValid(planktopull) then
											barricade:RemovePlank(planktopull)
										end
									end
									self:PlaySequenceAndWait("nz_crawl_boardtear_aligned_m_"..planknumber.."_pull")
								end
							end
						else
							timer.Simple(dur/2, function() -- Moo Mark. This is very sinful but my dumbass can't think of anything else rn.
								if IsValid(self) and self:Alive() and IsValid(planktopull) then -- This is just so the plank being pulled looks nicer and will look like the zombie is actually pulling that bitch.
									barricade:RemovePlank(planktopull)
								end
							end)

							self:PlaySequenceAndWait(seq)
						end

						self:SetLastAttack(CurTime())
						if math.random(100) <= 25 and !self:GetCrawler() and !self.IsMooSpecial then -- The higher the number, the more likely a zombie will taunt.
							self:SetStuckCounter( 0 ) --This is just to make sure a zombie won't despawn at a barricade.
							local seq,s = self:SelectTauntSequence()
							if seq then
								self:PlaySequenceAndWait(seq)
							end
						end

						if barricade then
							self:OnBarricadeBlocking(barricade, dir)
							return
						end
					end
				elseif barricade:GetTriggerJumps() and self.TriggerBarricadeJump then
					self:TimeOut(0.25)
					self:TriggerBarricadeJump(barricade, dir)
				else
					self:SolidMaskDuringEvent(MASK_NPCSOLID_BRUSHONLY)
					local pos = barricade:GetPos() - dir * 50 -- Moo Mark
						self:MoveToPos(pos, { -- Zombie will move through the barricade.
						lookahead = 20,
						tolerance = 20,
						draw = false,
						maxage = 3,
						repath = 3,
					})
					self:CollideWhenPossible()
					self:SetIsBusy(false)
				end
			end
		end
	end
end


function ENT:TimeOut(time)
	self:SetTimedOut(true)
	--if not self:HasTarget() and not self:GetSpecialAnimation() then -- Only play Idle anim if the Zombie doesn't have a target. Moo Mark
	if not self:GetSpecialAnimation() then 
		self:PerformIdle()
	end
	if coroutine.running() then
		coroutine.wait(time)
	end
end

function ENT:OnPathTimeOut() end

function ENT:OnNoTarget()
	self:TimeOut(0.1) -- Instead of being brain dead for a second, just search for a new target sooner.
	local newtarget = self:GetPriorityTarget()
	if self:IsValidTarget(newtarget) then
		self:SetTarget(newtarget)
	else
		if not self:IsInSight() and nzRound:InProgress() and not nzRound:InState( ROUND_GO ) then
			if self.NZBossType then
				nzRound:SpawnBoss(self.NZBossType)
				self:Remove()
			else
				self:RespawnZombie()
			end
		else
			self:TimeOut(0.1)
		end
	end
end

function ENT:OnThink()
	if not IsValid(self) then return end
	if SERVER and self:Alive() and self:GetDecapitated() then // Decapitation bleedout
		if not self.nextbleedtick then
			self.nextbleedtick = CurTime() + 0.25
			self.bleedtickcount = 0
		end

		if self.nextbleedtick and self.nextbleedtick < CurTime() then
			ParticleEffectAttach("ins_blood_impact_headshot", 4, self, 10)

			self.nextbleedtick = CurTime() + math.Rand(0.15, 0.4)
			self.bleedtickcount = self.bleedtickcount + 1
		end

		if self.bleedtickcount and self.bleedtickcount > 10 then
			print("Goodbye Luigi.")
			self:TakeDamage(self:Health() + 666, self, self)
			if nzRound:InProgress() then
                nzRound:SetZombiesKilled( nzRound:GetZombiesKilled() + 1 )
            end
		end
	end
end

--Default NEXTBOT Events
function ENT:OnLandOnGround()
	if self:Alive() then
		self:EmitSound("physics/flesh/flesh_impact_hard" .. math.random(1, 6) .. ".wav")
		self:SetJumping( false )
		self:SetLastLand(CurTime())
		if !self:GetAttacking() and !self:GetSpecialAnimation() and self:Alive() then
			self:ResetMovementSequence()
		end
		self:OnLandOnGroundZombie()
	end
end

function ENT:OnLeaveGround( ent )
	self:SetJumping( true )
end

function ENT:OnLandOnGroundZombie() end

function ENT:OnNavAreaChanged(old, new)
	if bit.band(new:GetAttributes(), NAV_MESH_JUMP) != 0 then
		if old:ComputeGroundHeightChange( new ) < 0 then
			return
		end
		self:Jump()
	end
end

function ENT:OnContact( ent )
	if nzConfig.ValidEnemies[ent:GetClass()] and nzConfig.ValidEnemies[self:GetClass()] then
		self.loco:Approach( self:GetPos() + Vector( math.Rand( -72, 72 ), math.Rand( -72, 72 ), 0 ) * 2000,1000)
	end

	if ( ent:GetClass() == "prop_physics_multiplayer" or ent:GetClass() == "prop_physics" ) then
		--self.loco:Approach( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 2000,1000)
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			local force = -physenv.GetGravity().z * phys:GetMass() / 12 * ent:GetFriction()
			local dir = ent:GetPos() - self:GetPos()
			dir:Normalize()
			phys:ApplyForceCenter( dir * force )
		end
	end

	if ent:GetClass() == "invis_wall" then
		self.loco:Approach( self:GetPos() + Vector( math.Rand( -70, 70 ), math.Rand( -70, 70 ), 0 ) * 2000,1000)
	end

	if self:IsTarget( ent ) then
		self:OnContactWithTarget()
	end
end

function ENT:OnContactWithTarget() end

function ENT:Alive() return self:GetAlive() end

if SERVER then
	ENT.DeathRagdollForce = 9500
	ENT.CrawlerForce = 7500
	ENT.GibForce = 200
	ENT.HasGibbed = false

	function ENT:RagdollForceTest(force)
		if force == nil then return nil end
		return self.DeathRagdollForce^2 <= force:LengthSqr()
	end

	function ENT:CrawlerForceTest(force)
		if force == nil then return nil end
		return self.CrawlerForce^2 <= force:LengthSqr()
	end

	function ENT:GibForceTest(force)
		if force == nil then return nil end
		return self.GibForce^2 <= force:LengthSqr()
	end

	function ENT:OnInjured(dmginfo)
		self:EmitSound( "nz_moo/zombies/gibs/prj_impact/prj_bullet_flesh_0"..math.random(4)..".mp3", 97, math.random(95, 100))

		local hitgroup = util.QuickTrace(dmginfo:GetDamagePosition(), dmginfo:GetDamagePosition()).HitGroup
		local hitforce = dmginfo:GetDamageForce()

		local head = self:LookupBone("ValveBiped.Bip01_Head1")
		if !head then head = self:LookupBone("j_head") end

		local lleg = self:LookupBone("j_knee_le")
		local rleg = self:LookupBone("j_knee_ri")
		local larm = self:LookupBone("j_elbow_le")
		local rarm = self:LookupBone("j_elbow_ri")

		local randleggib = math.random(4) -- Have a chance of randomly removing either the left, right or both legs. jib.

		if !self:GetCrawler() then

			--[[ CRAWLER CREATION FROM DAMAGE ]]--
			if self:CrawlerForceTest(hitforce) and !self.IsMooSpecial and !self.HasGibbed and bit.band(dmginfo:GetDamageType(), bit.bor(DMG_SLASH, DMG_CLUB, DMG_CRUSH)) == 0 and not dmginfo:IsBulletDamage() then	
				timer.Simple(0, function() -- Need to delay it till next tick otherwise it doesn't work.
					if not IsValid(self) then return end
					if not self:Alive() then return end

					if self:Health() <= 100 and self:Health() > 0 then
						if (lleg and !self.LlegOff) and (hitgroup == HITGROUP_LEFTLEG or randleggib == 1 or randleggib == 3) then
							self.LlegOff = true
							self:DeflateBones({
								"j_knee_le",
								"j_knee_bulge_le",
								"j_ankle_le",
								"j_ball_le",
							})

							ParticleEffectAttach("ins_blood_dismember_limb", 4, self, 7)
						end

						if (rleg and !self.RlegOff) and (hitgroup == HITGROUP_RIGHTLEG or randleggib == 2 or randleggib == 3) then
							self.RlegOff = true
	    					self:DeflateBones({
								"j_knee_ri",
								"j_knee_bulge_ri",
								"j_ankle_ri",
								"j_ball_ri",
							})

							ParticleEffectAttach("ins_blood_dismember_limb", 4, self, 8)
						end

						self:EmitSound("nz_moo/zombies/gibs/bodyfall/fall_0"..math.random(2)..".mp3",100)
						self.ShouldCrawl = true
						self:BecomeCrawler() -- Is it's own separate function for ease of doing other things.
					end
				end)
			end

			--[[ GIBBING SYSTEM ]]--
			if self:GibForceTest(hitforce) then
				if (head and hitgroup == HITGROUP_HEAD) and !self.IsMooSpecial and !self.MarkedForDeath and randleggib == 4 and (self:Health() <= self.GibForce) then
					self:GibHead()
				end

				if (larm and hitgroup == HITGROUP_LEFTARM) and !self.IsMooSpecial then
					self:GibArmL()
				end

				if (rarm and hitgroup == HITGROUP_RIGHTARM) and !self.IsMooSpecial then
					self:GibArmR()
				end
			end
		end
	end

	function ENT:GibArmR()
		if not IsValid(self) then return end
		if self.HasGibbed then return end
		self.HasGibbed = true

		self:DeflateBones({
			"j_elbow_ri",
			"j_wrist_ri",
			"j_wristtwist_ri",
			"j_thumb_ri_1",
			"j_thumb_ri_2",
			"j_thumb_ri_3",
			"j_index_ri_1",
			"j_index_ri_2",
			"j_index_ri_3",
			"j_mid_ri_1",
			"j_mid_ri_2",
			"j_mid_ri_3",
			"j_ring_ri_1",
			"j_ring_ri_2",
			"j_ring_ri_3",
			"j_pinky_ri_1",
			"j_pinky_ri_2",
			"j_pinky_ri_3",
		})

		self:EmitSound("nz_moo/zombies/gibs/gib_0"..math.random(3)..".mp3",100)
		if not self.MarkedForDeath then
			ParticleEffectAttach("ins_blood_dismember_limb", 4, self, 6)
		end
	end

	function ENT:GibArmL()
		if not IsValid(self) then return end
		if self.HasGibbed then return end
		self.HasGibbed = true

		self:DeflateBones({
			"j_elbow_le",
			"j_wrist_le",
			"j_wristtwist_le",
			"j_thumb_le_1",
			"j_thumb_le_2",
			"j_thumb_le_3",
			"j_index_le_1",
			"j_index_le_2",
			"j_index_le_3",
			"j_mid_le_1",
			"j_mid_le_2",
			"j_mid_le_3",
			"j_ring_le_1",
			"j_ring_le_2",
			"j_ring_le_3",
			"j_pinky_le_1",
			"j_pinky_le_2",
			"j_pinky_le_3",
		})

		self:EmitSound("nz_moo/zombies/gibs/gib_0"..math.random(3)..".mp3",100)
		if not self.MarkedForDeath then
			ParticleEffectAttach("ins_blood_dismember_limb", 4, self, 5)
		end
	end

	function ENT:GibRandom()
		if not IsValid(self) then return end
		if self.HasGibbed then return end
		if math.random(2) == 1 then
			self:GibArmL()
		else
			self:GibArmR()
		end
	end

	function ENT:GibHead()
		if self:GetDecapitated() then return end
		self:SetDecapitated(true)

		if IsValid(self.spritetrail) and IsValid(self.spritetrail2) then
			SafeRemoveEntity(self.spritetrail)
			SafeRemoveEntity(self.spritetrail2)
		end

		local headbone = self:LookupBone("ValveBiped.Bip01_Head1")
		if !headbone then headbone = self:LookupBone("j_head") end
		if headbone then
			self:ManipulateBoneScale(headbone, Vector(0.00001,0.00001,0.00001))
		end

		self:EmitSound("nz_moo/zombies/gibs/head/head_explosion_0"..math.random(4)..".mp3",100, math.random(95,105))
		self:EmitSound("nz_moo/zombies/gibs/death_nohead/death_nohead_0"..math.random(2)..".mp3",85, math.random(95,105))
		ParticleEffectAttach("ins_blood_impact_headshot", 4, self, 10)
	end

	function ENT:OnKilled(dmginfo)
		if dmginfo and self:Alive() then -- Only call once!
			if IsValid(self.spritetrail) and IsValid(self.spritetrail2) then
				SafeRemoveEntity(self.spritetrail)
				SafeRemoveEntity(self.spritetrail2)
			end

			if !self.IsMooSpecial then
				if dmginfo:IsDamageType(DMG_SHOCK) and math.random(10) == 1 then //Random head-pop
					self:GibHead()
					self:EmitSound("TFA_BO3_WAFFE.Pop")
				end

				local hitgroup = util.QuickTrace(dmginfo:GetDamagePosition(), dmginfo:GetDamagePosition()).HitGroup
				if (hitgroup == HITGROUP_HEAD or nzPowerUps:IsPowerupActive("insta")) then
					self:GibHead()
				end
			end

			self:SetAlive(false)
			self.ZombieAlive = false

			hook.Call("OnZombieKilled", GAMEMODE, self, dmginfo)

			self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
			self:PerformDeath(dmginfo)
		end
	end

	function ENT:PerformDeath(dmginfo)
		if dmginfo:GetDamageType() == DMG_MISSILEDEFENSE or dmginfo:GetDamageType() == DMG_ENERGYBEAM then
			self:BecomeRagdoll(dmginfo) -- Only Thundergun and Wavegun Ragdolls constantly.
		end

		if self.DeathRagdollForce == 0 or dmginfo:GetDamageType() == DMG_REMOVENORAGDOLL or self:GetSpecialAnimation() then
			self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
			self:DoDeathAnimation(self.RagdollDeathSequences[math.random(#self.RagdollDeathSequences)])
		else
			if self:GetCrawler() then
				if self:RagdollForceTest(dmginfo:GetDamageForce()) then
					self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
					self:DoDeathAnimation(self.RagdollDeathSequences[math.random(#self.RagdollDeathSequences)])
				elseif dmginfo:GetDamageType() == DMG_SHOCK then
					self:PlaySound(self.ElecSounds[math.random(#self.ElecSounds)], 90, math.random(85, 105), 1, 2)
					self:DoDeathAnimation(self.CrawlTeslaDeathSequences[math.random(#self.CrawlTeslaDeathSequences)])
				else
					self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
					self:DoDeathAnimation(self.CrawlDeathSequences[math.random(#self.CrawlDeathSequences)])
				end
			else
				if self:RagdollForceTest(dmginfo:GetDamageForce()) then
					self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
					self:DoDeathAnimation(self.BlastDeathSequences[math.random(#self.BlastDeathSequences)])
				elseif dmginfo:GetDamageType() == DMG_SHOCK then
					self:PlaySound(self.ElecSounds[math.random(#self.ElecSounds)], 90, math.random(85, 105), 1, 2)
					self:DoDeathAnimation(self.ElectrocutionSequences[math.random(#self.ElectrocutionSequences)])
				elseif dmginfo:GetDamageType() == DMG_SLASH then
					self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
					self:DoDeathAnimation(self.MeleeDeathSequences[math.random(#self.MeleeDeathSequences)])
				else
					self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
					self:DoDeathAnimation(self.DeathSequences[math.random(#self.DeathSequences)])
				end
			end
		end
	end

	function ENT:DoDeathAnimation(seq)
		self.BehaveThread = coroutine.create(function()
			self:SetSpecialAnimation(true)
			self:PlaySequenceAndWait(seq)
			self:BecomeRagdoll(DamageInfo()) -- Only Ragdoll after death anims.
		end)
	end

	function ENT:DoSpecialAnimation(seq)
		--[[local pos = self:GetPos()
		local sequence = self:LookupSequence(seq)
		local funny, vec, angles = self:GetSequenceMovement(sequence, 0, 1)
		if funny then
			if isvector(vec) then
				--vec = Vector(vec.x, vec.y, vec.z)
			end
			print(vec)
			vec:Rotate(self:GetAngles() + angles)
			self:SetAngles(self:LocalToWorldAngles(angles))
			self:SetPos(pos + vec)
		end]]
		self:SetSpecialAnimation(true)
		self:SolidMaskDuringEvent(MASK_NPCSOLID_BRUSHONLY)
		self:PlaySequenceAndWait(seq)
		if not self:GetSpecialShouldDie() and IsValid(self) and self:Alive() then -- COMMON NZ VALID W
			self:CollideWhenPossible()
			self:SetSpecialAnimation(false) -- Stops them from going back to idle.
		end
	end

	function ENT:BecomeCrawler() -- For turning into Crawlers.
		self:SetCrawler(true) -- CRIPPLE THEIR SORRY ASSES!!!
		self:SetCollisionBounds(Vector(-13,-13, 0), Vector(13, 13, 24))
		if self:GetCrawler() then
			self:SpeedChanged()
		end
	end

	function ENT:BecomeNormal() -- For turning back to normal, i.e they get their legs back.
		self:SetCrawler(false) -- Uncripple them, they may just be doing something funny.
		self:SetCollisionBounds(Vector(-13,-13, 0), Vector(13, 13, 70))
		if !self:GetCrawler() then
			self:SetRunSpeed(self.StartSpeed)
			self:SpeedChanged()
		end
	end

	function ENT:DeflateBones(tbl,ent)
		if !IsValid(self) then return end

		for i,b in pairs(tbl) do
			if self:LookupBone(b) then
				self:ManipulateBoneScale(self:LookupBone(b),Vector(0.00001,0.00001,0.00001))
			end
		end
	end
end

function ENT:OnRemove() end
function ENT:OnStuck() end

if SERVER then
	function ENT:Retarget() -- Causes a retarget
		if self:GetTargetLocked() and self:IsValidTarget(self.Target) then return end

		local target, dist = self:GetPriorityTarget()
		self.Target = target
		self:SetNextRetarget(self:CalculateNextRetarget(target, dist))
	end

	-- Lets your determine what target to go for next upon retargeting
	function ENT:GetPriorityTarget() -- We're using a modified version of the nZu targetting code... This mainly improves performance in multiplayer games.
		self:SetLastTargetCheck( CurTime() )

		local target = nil
		local highestPriority = TARGET_PRIORITY_NONE
		local mindist = self:GetTargetCheckRange()
		local target
		for k,v in pairs(ents.GetAll()) do
			if v:GetTargetPriority() == TARGET_PRIORITY_ALWAYS and not self.IsMooSpecial then return v end
			local d = self:GetRangeTo(v)
			if v:GetTargetPriority() == TARGET_PRIORITY_SPECIAL and not self.IsMooSpecial or d < mindist and self:IsValidTarget(v) then
				target = v
				mindist = d
				--print(target, mindist)
				if IsValid(self.Target) and v:GetTargetPriority() == TARGET_PRIORITY_SPECIAL and not self.IsMooSpecial then
					self:SetBlockAttack(true)
				elseif self:GetBlockAttack() then
					self:SetBlockAttack(false)
				end
			end
		end

		return target, mindist
	end

	function ENT:FleeTarget(time) -- Added by Ethorbit, instead of pathing TO a player, it paths AWAY from them
		local target = self:GetTarget()
		if !IsValid(target) then return end

		local tr = util.TraceLine({
			start = self:GetPos() + Vector(0,0,50),
			endpos = self:GetFleeDestination(target) + Vector(0,0,50),
			filter = self,
			collisiongroup = COLLISION_GROUP_DEBRIS
		})

		if tr.Hit then return end

		self:SetFleeing(true)

		timer.Create(self:GetClass() .. "FleeingTarget" .. self:EntIndex(), time, 1, function()
			if IsValid(self) and self:GetFleeing() then
				self:SetFleeing(false)
			end
		end)
	end

	function ENT:StopFleeing() -- Cancel the fleeing, created by: Ethorbit
		--self:SetLastFlee(CurTime())
		self:SetFleeing(false)
	end

	function ENT:ChaseTarget( options )

		options = options or {}

		local path = self:ChaseTargetPath( self:GetTarget() )
		local distToTarget = self:GetPos():DistToSqr(self:GetTargetPosition())
		local nav = navmesh.GetNavArea(self:GetPos(), self:GetAttackRange())

		if ( !IsValid(path) ) then return "failed" end
		while ( path:IsValid() and self:HasTarget() and not self:TargetInAttackRange() ) do

			path:Update( self )
			self:SetTargetUnreachable(false)

			-- Timeout the pathing so it will rerun the entire behaviour
			if path:GetAge() > math.Clamp(distToTarget / 1000^2,3,10) then -- This is pulled from Ba2 for distance based repathing.
				return "timeout"
			end
			if path:IsValid() then
				if path:GetAge() > 1 and (distToTarget < 750^2) then -- We're closing in, let's start repathing sooner!
					return "timeout"
				elseif path:GetAge() > 0.2 and (distToTarget < 200^2) then -- We're nearing attack range! Don't stop now!
					return "timeout"
				end
			end

			local scanDist
			--this will probaly need adjustments to fit the zombies speed
			if self:GetVelocity():Length2D() > 150 then scanDist = 30 else scanDist = 20 end
			local goal = path:GetCurrentGoal()

			if path:IsValid() and math.abs(self:GetPos().z - path:GetClosestPosition(self:EyePos() + self.loco:GetGroundMotionVector() * scanDist).z) > 52 and (goal and goal.type != 1) then
				self:Jump()
			end

			if !self.IsMooSpecial and !self.ShouldCrawl then
				if IsValid(nav) and nav:HasAttributes(NAV_MESH_CROUCH) then
					if !self:GetCrawler() then
						self:BecomeCrawler()
					end
				elseif IsValid(nav) and !nav:HasAttributes(NAV_MESH_CROUCH) then
					if self:GetCrawler() then
						self:BecomeNormal()
					end
				end
			end

			if self:HasTarget() and !self:GetAttacking() and self:IsAllowedToMove() and self:IsOnGround() then
				self:ResetMovementSequence() -- This is the main point that starts the movement anim. Moo Mark
			end
			
			-- If we're stuck, then call the HandleStuck function and abandon
			if ( self.loco:IsStuck() ) then
				self:HandleStuck()
				return "stuck"
			end

			if self:IsMovingIntoObject() then 
            	self:ApplyRandomPush(100)
        	end

			self:TraversalCheck() -- Moo Mark 3/13/23: This magical little function here allows the zobies to check for a special entity that allows them to climb shit.

			coroutine.yield()
		end
		return "ok"
	end

	function ENT:ChaseTargetPath( options )

	options = options or {}

	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( 10 )
	path:SetGoalTolerance( 30 )

	--[[local targetPos = options.target:GetPos()
	--set the goal to the closet navmesh
	local goal = navmesh.GetNearestNavArea(targetPos, false, 100)
	goal = goal and goal:GetClosestPointOnArea(targetPos) or targetPos--]]

	-- Custom path computer, the same as default but not pathing through locked nav areas.
	path:Compute( self, self:GetTarget():GetPos(),  function( area, fromArea, ladder, elevator, length )
		if ( !IsValid( fromArea ) ) then
			-- First area in path, no cost
			return 0
		else
			if ( !self.loco:IsAreaTraversable( area ) ) then
				-- Our locomotor says we can't move here
				return -1
			end
			-- Prevent movement through either locked navareas or areas with closed doors
			if (nzNav.Locks[area:GetID()]) then
				if nzNav.Locks[area:GetID()].link then
					if !nzDoors:IsLinkOpened( nzNav.Locks[area:GetID()].link ) then
						return -1
					end
				elseif nzNav.Locks[area:GetID()].locked then
				return -1 end
			end
			-- Compute distance traveled along path so far
			local dist = 0
			--[[if ( IsValid( ladder ) ) then
				dist = ladder:GetLength()
			elseif ( length > 0 ) then
				--optimization to avoid recomputing length
				dist = length
			else
				dist = ( area:GetCenter() - fromArea:GetCenter() ):GetLength()
			end]]--
			local cost = dist + fromArea:GetCostSoFar()
			--check height change
			local deltaZ = fromArea:ComputeAdjacentConnectionHeightChange( area )
			if ( deltaZ >= self.loco:GetStepHeight() ) then
				-- use player default max jump height even thouh teh zombie will jump a bit higher
				if ( deltaZ >= 64 ) then
					--Include ladders in pathing:
					--currently disableddue to the lack of a loco:Climb function
					--[[if IsValid( ladder ) then
						if ladder:GetTopForwardArea():GetID() == area:GetID() then
							return cost
						end
					end --]]
					--too high to reach
					return -1
				end
				--jumping is slower than flat ground
				local jumpPenalty = 1.1
				cost = cost + jumpPenalty * dist
			elseif ( deltaZ < -self.loco:GetDeathDropHeight() ) then
				--too far to drop
				return -1
			end
			return cost
		end
	end)

	-- this will replace nav groups
	-- we do this after pathing to know when this happens
	local lastSeg = path:LastSegment()

	-- a little more complicated that i thought but it should do the trick
	if lastSeg then
	if (!IsValid(self:GetTargetNavArea())) then return end
		if self:GetTargetNavArea() and lastSeg.area:GetID() != self:GetTargetNavArea():GetID() then
			if !nzNav.Locks[self:GetTargetNavArea():GetID()] or nzNav.Locks[self:GetTargetNavArea():GetID()].locked then
				self:IgnoreTarget(self:GetTarget())
				-- trigger a retarget
				self:SetLastTargetCheck(CurTime() - 1)
				self:TimeOut(0.5)
				return nil
			end
		else
			self:ResetIgnores()
			return path
		end
	end

	return path

end
end

function ENT:IsAllowedToMove()
    if self:GetTargetUnreachable() then
        return false
    end

    if self:GetTimedOut() or self:GetClimbing() or self:GetJumping() or self:IsGettingPushed() then
        return false
    end
	if self:GetSpecialAnimation() then
		return false
	end	
	if self:GetSpecialShouldDie() then
		return false
	end	
	if self:GetIsBusy() then
		return false
	end	
    if self:GetWandering() then
        return false
    end

    if self:GetCrawler() then
    	--print("cripple")
        return true
    end

    if self:GetTeleporting() then
    	--print("ZOOOM!")
        return true
    end

    if self.FrozenTime and CurTime() < self.FrozenTime then
        return false
    end

    if !self:IsOnGround() then
        return false
    end

    return true
end

function ENT:TargetInAttackRange()
	return self:TargetInRange( self:GetAttackRange() )
end

function ENT:TargetInRange( range )
	local target = self:GetTarget()
	if !IsValid(target) then return false end
	return self:GetRangeTo( target:GetPos() ) < range
end

local function PointOnSegmentNearestToPoint(a, b, p)
    local ab = b - a
    local ap = p - a

    local t = ap:Dot(ab) / (ab.x^2 + ab.y^2 + ab.z^2)
        t = math.Clamp(t, 0, 1)
    return a + t*ab
end

function ENT:CheckForBarricade()
	--we try a line trace first since its more efficient
	local dataL = {}
	dataL.start = self:GetPos() + Vector( 0, 0, self:OBBCenter().z )
	dataL.endpos = self:GetPos() + Vector( 0, 0, self:OBBCenter().z ) + self.BarricadeCheckDir * 7
	dataL.filter = function( ent ) if ( ent:GetClass() == "breakable_entry" ) then return true end end
	dataL.ignoreworld = true
	local trL = util.TraceLine( dataL )

	debugoverlay.Line(self:GetPos() + Vector( 0, 0, self:OBBCenter().z ), self:GetPos() + Vector( 0, 0, self:OBBCenter().z ) + self.BarricadeCheckDir * 7)
	debugoverlay.Cross(self:GetPos() + Vector( 0, 0, self:OBBCenter().z ), 1)

	if IsValid( trL.Entity ) and trL.Entity:GetClass() == "breakable_entry" then
		return trL.Entity, trL.HitNormal
	end

	-- Perform a hull trace if line didnt hit just to make sure
	local dataH = {}
	dataH.start = self:GetPos()
	dataH.endpos = self:GetPos() + self.BarricadeCheckDir * 7
	dataH.filter = function( ent ) if ( ent:GetClass() == "breakable_entry" ) then return true end end
	dataH.mins = self:OBBMins() * 0.65
	dataH.maxs = self:OBBMaxs() * 0.65
	dataH.ignoreworld = true
	local trH = util.TraceHull(dataH )

	if IsValid( trH.Entity ) and trH.Entity:GetClass() == "breakable_entry" then
		return trH.Entity, trH.HitNormal
	end

	return nil

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

		if self:GetTarget():GetVelocity():LengthSqr() < 15 and self:TargetInRange( self.DamageRange ) and not self:GetCrawler() then
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
				self:EmitSound( "npc/vort/claw_swing1.wav", 90, math.random(95, 105))
				if !self:GetStop() and self:IsValidTarget( self:GetTarget() ) and self:TargetInRange( self:GetAttackRange() + 10 ) then
					local dmgInfo = DamageInfo()
					dmgInfo:SetAttacker( self )
					if self:WaterBuff() then
						dmgInfo:SetDamage( 90 )
					else
						dmgInfo:SetDamage( 45 )
					end
					dmgInfo:SetDamageType( DMG_SLASH )
					dmgInfo:SetDamageForce( (self:GetTarget():GetPos() - self:GetPos()) * 7 + Vector( 0, 0, 16 ) )
					if self:TargetInRange( self.DamageRange ) then 
						if !IsValid(self:GetTarget()) then return end
						self:GetTarget():TakeDamageInfo(dmgInfo)
						if comedyday or math.random(1,500) == 1 then
							if self.GoofyahAttackSounds then self:GetTarget():EmitSound(self.GoofyahAttackSounds[math.random(#self.GoofyahAttackSounds)], SNDLVL_TALKING, math.random(95,105)) end
						else
							self:GetTarget():EmitSound( "nz_moo/zombies/plr_impact/_zhd/evt_zombie_hit_player_0"..math.random(0,5)..".mp3", SNDLVL_TALKING, math.random(95,105))
						end

						if self:GetTarget():IsPlayer() then
							self:GetTarget():ViewPunch( VectorRand():Angle() * 0.01 )
						end
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

ENT.GoofyahAttackSounds = {
	Sound("nz_moo/zombies/plr_impact/_goofy/punch_boxing_bodyhit03.wav"),
	Sound("nz_moo/zombies/plr_impact/_goofy/punch_boxing_facehit1.wav"),
	Sound("nz_moo/zombies/plr_impact/_goofy/punch_boxing_facehit2.wav"),
	Sound("nz_moo/zombies/plr_impact/_goofy/punch_boxing_facehit3.wav"),
	Sound("nz_moo/zombies/plr_impact/_goofy/punch_boxing_facehit4.wav"),
}

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
				if !self:GetCrawler() then
					self.loco:SetDesiredSpeed( self:GetRunSpeed() )
				end
			end
			return
		end
		if self:IsValidTarget( self:GetTarget() ) then
			if not self:IsStandingAttack() and not self:GetCrawler() then
				if self.loco:GetVelocity():Length2D() >= 140 and !self.IsMooSpecial then
					self.loco:SetDesiredSpeed( self:GetRunSpeed() + 40 ) -- This just to mimic lung some attack anims have
				else
					self.loco:SetDesiredSpeed( self:GetRunSpeed() )
				end
				self.loco:Approach( self:GetTarget():GetPos(), 10 )
				self.loco:FaceTowards( self:GetTarget():GetPos() )
			end
		end

		coroutine.yield()

	end

end

--we do our own jump since the loco one is a bit weird.
function ENT:Jump()
	local nav = navmesh.GetNavArea(self:GetPos(), math.huge)
	if (!IsValid(nav) or IsValid(nav) and nav:HasAttributes(NAV_MESH_NO_JUMP)) then return end
	if CurTime() < self:GetLastLand() + 0.5 then return end
	if !self:IsOnGround() then return end
	--self.loco:SetDesiredSpeed( 450 )
	--self.loco:SetAcceleration( 1000 )
	self:SetJumping( true )
	self.loco:Jump()
	--Boost them
	--self:TimedEvent( 0.5, function() self.loco:SetVelocity( self:GetForward() * 5 ) end)
end

function ENT:Flames( state )
	if state then
		self.FlamesEnt = ents.Create("env_fire")
		if IsValid( self.FlamesEnt ) then
			
			self.FlamesEnt:SetParent(self)
			self.FlamesEnt:SetOwner(self)
			self.FlamesEnt:SetPos(self:GetPos())
			--no glow + delete when out + start on + last forever
			self.FlamesEnt:SetKeyValue("spawnflags", tostring(128 + 32 + 4 + 2 + 1))
			self.FlamesEnt:SetKeyValue("firesize", (1 * math.Rand(0.7, 1.1)))
			self.FlamesEnt:SetKeyValue("fireattack", 0)
			self.FlamesEnt:SetKeyValue("health", 0)
			self.FlamesEnt:SetKeyValue("damagescale", "-10") -- only neg. value prevents dmg

			self.FlamesEnt:Spawn()
			self.FlamesEnt:Activate()
		end
	elseif IsValid( self.FlamesEnt )  then
		self.FlamesEnt:Remove()
		self.FlamesEnt = nil
	end
end

function ENT:Explode(dmg, suicide)
    suicide = suicide or true
    dmg = dmg or 50

    if SERVER then
        local pos = self:WorldSpaceCenter()
        local targ = self:GetTarget()

        local attacker = self
        local inflictor = self

        if IsValid(targ) and targ.GetActiveWeapon then
            attacker = targ
            if IsValid(targ:GetActiveWeapon()) then
                inflictor = targ:GetActiveWeapon()
            end
        end

        local tr = {
            start = pos,
            filter = self,
            mask = MASK_NPCSOLID_BRUSHONLY
        }

        for k, v in pairs(ents.FindInSphere(pos, 200)) do
            if v:IsPlayer() or v:IsNPC() or v:IsNextBot() then
                if v:GetClass() == self:GetClass() then continue end
                if v == self then continue end
                if v:Health() <= 0 then continue end
                tr.endpos = v:WorldSpaceCenter()
                local tr1 = util.TraceLine(tr)
                if tr1.HitWorld then continue end

                local expdamage = DamageInfo()
                expdamage:SetAttacker(attacker)
                expdamage:SetInflictor(inflictor)
                expdamage:SetDamageType(DMG_BLAST)

                local distfac = pos:Distance(v:WorldSpaceCenter())
                distfac = 1 - math.Clamp((distfac/200), 0, 1)
                expdamage:SetDamage(dmg * distfac)

                expdamage:SetDamageForce(v:GetUp()*5000 + (v:GetPos() - self:GetPos()):GetNormalized() * 10000)

                v:TakeDamageInfo(expdamage)
            end
        end

        local effectdata = EffectData()
        effectdata:SetOrigin(self:GetPos())

        util.Effect("HelicopterMegaBomb", effectdata)
        util.Effect("Explosion", effectdata)

        util.ScreenShake(self:GetPos(), 20, 255, 1.5, 400)
    end

    if suicide then self:TakeDamage(self:Health() + 666, self, self) end
end

function ENT:Kill(dmginfo, noprogress, noragdoll)
	dmginfo = dmginfo or DamageInfo()

	--[[if noragdoll then
		self:Fire("Kill",0,0)
	else
		if dmginfo:GetDamageType() ~= DMG_MISSILEDEFENSE or dmginfo:GetDamageType() ~= DMG_ENERGYBEAM then
			--ParticleEffect("bo3_annihilator_blood", self:WorldSpaceCenter(), Angle(0,0,0), nil)
			self:Remove(dmginfo)
		else
			self:BecomeRagdoll(dmginfo)
		end
	end]]

	if !noprogress then
		nzEnemies:OnEnemyKilled(self, dmginfo:GetAttacker(), dmginfo, 0)
	end

	self:OnKilled(dmginfo)
end

function ENT:RespawnZombie()
	if SERVER then
		if nzRound:InProgress() and self:GetSpawner() then -- Only do this if theres a round in progress.
			self:GetSpawner():IncrementZombiesToSpawn()
			self:GetSpawner():DecrementZombiesToSpawn()
		end

		-- Fake kill the stuck Zombie. Moo 1/31/23
		print("Uh oh Mario, I've suffered a fatal heart attack lol.")
		self:FakeKillZombie()
	end
end

function ENT:FakeKillZombie()
	self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
	self:SetAlive(false)
	self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
	
	if self.DeathSequences then
		if self:GetCrawler() then
			self:DoDeathAnimation(self.CrawlDeathSequences[math.random(#self.CrawlDeathSequences)])
		else
			self:DoDeathAnimation(self.DeathSequences[math.random(#self.DeathSequences)])
		end
	else
		self:Remove()
	end
end

function ENT:Freeze(time)
	--self:TimeOut(time)
	self:SetStop(true)
	self.FrozenTime = CurTime() + time
end

function ENT:IsInSight()
	for _, ply in pairs( player.GetAll() ) do
		--can player see us or the teleport location
		if ply:Alive() and ply:IsLineOfSightClear( self ) then
			if ply:GetAimVector():Dot((self:GetPos() - ply:GetPos()):GetNormalized()) > 0 then
				return true
			end
		end
	end
end

function ENT:BodyUpdate() -- Moo Mark. Remember all that shit with Act Stages? Yeah fuck that, its all gone now... I got rid of all the reasons to keep it finally.

	if not self:GetSpecialAnimation() and not self:IsAttacking() and not self:IsJumping() and not self:IsTimedOut() then
		if not self.FrozenTime then
			self:BodyMoveXY()
		end
	end

	if self:GetSpecialAnimation() or self:IsAttacking() then
		self:SetStuckCounter(0)
	end

	if self.FrozenTime then 
		if self.FrozenTime < CurTime() then
			self.FrozenTime = nil
			self:SetStop(false)
		end
		self:BodyMoveXY()
	else
		self:FrameAdvance()
	end

end

function ENT:UpdateSequence()
	self:BodyUpdate()
	self:ResetMovementSequence()
end

function ENT:TriggerBarricadeJump( barricade, dir )
	if not self:GetSpecialAnimation() then

		local warppos = barricade:GetPos() + dir * 10

		self:SetSpecialAnimation(true)
		self:SetBlockAttack(true)

		local id, dur, speed
		local animtbl = self.JumpSequences

		if self:GetCrawler() then
			animtbl = self.CrawlJumpSequences
		end
 
		if type(animtbl) == "number" then -- ACT_ is a number, this is set if it's an ACT
			id = self:SelectWeightedSequence(animtbl)
			dur = self:SequenceDuration(id)
			speed = self:GetSequenceGroundSpeed(id)
			if speed < 10 then
				speed = 20
			end
		else
			local targettbl = animtbl and animtbl[math.random(#animtbl)] or self.JumpSequences
			if targettbl then -- It is a table of sequences
				id, dur = self:LookupSequenceAct(targettbl.seq) -- Whether it's an ACT or a sequence string
				speed = targettbl.speed
			else
				id = self:SelectWeightedSequence(ACT_JUMP)
				dur = self:SequenceDuration(id)
				speed = 30
			end
		end

		self:ResetMovementSequence()
		self:SolidMaskDuringEvent(MASK_NPCSOLID_BRUSHONLY)
		self:MoveToPos(warppos, { lookahead = 20, tolerance = 20, draw = false, maxage = 1, repath = 1, })
		
		self.loco:SetDesiredSpeed(speed)
		self:SetVelocity(self:GetForward() * speed)
		self:ResetSequence(id)
		self:SetCycle(0)
		self:SetPlaybackRate(1)

		self:SetPos(warppos)
		local pos = barricade:GetPos() - dir * 50 -- Moo Mark
		self:MoveToPos(pos, { -- Zombie will move through the barricade.
			lookahead = 1,
			tolerance = 10,
			draw = false,
			maxage = dur, -- 12/7/22: Using the current mantle anim's duration allows for more consistent mantling and lessens the zombie's chances of getting stuck.
			repath = dur,
		})
		
		self:SetPos(pos)
		self:SetBlockAttack(false)
		self.loco:SetAcceleration( self.Acceleration )
		self.loco:SetDesiredSpeed(self:GetRunSpeed())
		self:SetSpecialAnimation(false)
		self:SetIsBusy(false)
		self:CollideWhenPossible() -- Remove the mask as soon as we can
	end
end

function ENT:GetAimVector()
	return self:GetForward()
end

function ENT:GetShootPos()
	return self:EyePos()
end

function ENT:LookupSequenceAct(id)
	if type(id) == "number" then
		local id = self:SelectWeightedSequence(id)
		local dur = self:SequenceDuration(id)
		return id, dur
	else
		return self:LookupSequence(id)
	end
end

--Helper function
function ENT:TimedEvent(time, callback)
	timer.Simple(time, function()
		if (IsValid(self) and self:Health() > 0) then
			callback()
		end
	end)
end

if SERVER then
	function ENT:Push(vec)
    	if CurTime() < self:GetLastPush() + 0.2 or !self:IsOnGround() then return end

    	self.GettingPushed = true
    	self.loco:SetVelocity( vec )

    	self:TimedEvent(0.5, function()
        	self.GettingPushed = false
    	end)

    	self:SetLastPush( CurTime() )
	end

	function ENT:ApplyRandomPush( power )
    	power = power or 100
    
    	local vec = self.loco:GetVelocity() + VectorRand() * power
    	vec.z = math.random( 100 )
    	self:Push(vec)
	end

	function ENT:IsGettingPushed() -- this is a new method
    	return self.GettingPushed
	end

	function ENT:GetCenterBounds()
    	local mins = self:OBBMins()
    	local maxs = self:OBBMaxs()
    	mins[3] = mins[3] / 2
    	maxs[3] = maxs[3] / 2

    	return {["mins"] = mins, ["maxs"] = maxs}
	end

	function ENT:TraceSelf(start, endpos, dont_adjust, line_trace) -- Creates a hull trace the size of ourself, handy if you'd want to know if we'd get stuck from a position offset
    	local bounds = self:GetCenterBounds()

    	if !dont_adjust then
        	start = start and start + self:OBBCenter() / 1.01 or self:GetPos() + self:OBBCenter() / 2
    	end

    	debugoverlay.Box(start, bounds.mins, bounds.maxs, 0, Color(255,0,0,55))

    	if endpos then
        	if !dont_adjust then
            	endpos = endpos + self:OBBCenter() / 1.01
        	end

        	debugoverlay.Box(endpos, bounds.mins, bounds.maxs, 0, Color(255,0,0,55))
    	end

    	local tbl = {
        	start = start,
        	endpos = endpos or start,
        	filter = self,
        	mins = bounds.mins,
        	maxs = bounds.maxs,
        	collisiongroup = self:GetCollisionGroup(),
        	mask = MASK_NPCSOLID
    	}

    	return !line_trace and util.TraceHull(tbl) or util.TraceLine(tbl)
	end

	function ENT:IsMovingIntoObject() -- Added by Ethorbit as this can be helpful to know
    
    	local bounds = self:GetCenterBounds()
    	local stuck_tr = self:TraceSelf()
    	local startpos = self:GetPos() + self:OBBCenter() / 2
    	local endpos = startpos + self:GetForward() * 10
    	local tr = stuck_tr.Hit and stuck_tr or util.TraceHull({
        	["start"] = startpos,
        	["endpos"] = endpos,
        	["filter"] = self,
        	["mins"] = bounds.mins,
        	["maxs"] = bounds.maxs,
        	["collisiongroup"] = self:GetCollisionGroup(),
        	["mask"] = MASK_SOLID
    	})

    	local ent = tr.Entity
		if tr.Hit then -- Moo Mark 1/8/23: Got rid of the second trace since I thought that it could be more taxing to have two traces for every tick the zombie is moving into something.
			for k,v in pairs(ents.FindAlongRay(self:EyePos() + (self:GetForward() * 10), self:GetForward(), bounds.mins, bounds.maxs)) do
				if IsValid(v) and v:GetClass() == "breakable_entry" then
					local CurrentDirection = self:GetForward() * 10
					self.BarricadeCheckDir = CurrentDirection or Vector(0,0,0)
					local barricade, dir = self:CheckForBarricade()
					if barricade then
						self:OnBarricadeBlocking( barricade, dir )
					end
				end
				if IsValid(v) and v:GetClass() == "func_breakable" then
					v:TakeDamage(v:Health(),self,self) -- Just fucking kill it
				end
			end
		end
    	if IsValid(ent) and (ent:IsPlayer() or ent:IsScripted() or ent:IsValidZombie()) then return false end

    	return tr.Hit
	end

	function ENT:ZombieWaterLevel()
		local pos1 = self:GetPos()
		local halfSize = self:OBBCenter()
		local pos2 = pos1 + halfSize
		local pos3 = pos2 + halfSize
		if bit.band( util.PointContents( pos3 ), CONTENTS_WATER ) == CONTENTS_WATER or bit.band( util.PointContents( pos3 ), CONTENTS_SLIME ) == CONTENTS_SLIME then
			return 3
		elseif bit.band( util.PointContents( pos2 ), CONTENTS_WATER ) == CONTENTS_WATER or bit.band( util.PointContents( pos2 ), CONTENTS_SLIME ) == CONTENTS_SLIME then
			return 2
		elseif bit.band( util.PointContents( pos1 ), CONTENTS_WATER ) == CONTENTS_WATER or bit.band( util.PointContents( pos1 ), CONTENTS_SLIME ) == CONTENTS_SLIME then
			return 1
		end

		return 0
	end

	function ENT:SolidMaskDuringEvent(mask)  -- Changes the zombie's mask until the end of the event. If nil is passed, it immediately removes the mask
		if mask then
			self:SetSolidMask(mask)
			self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
			self.EventMask = true
		else
			self:SetSolidMask(MASK_NPCSOLID)
			self.EventMask = nil
		end
	end
end

function ENT:CollideWhenPossible() 
	if self:Alive() then 
		self.DoCollideWhenPossible = true -- Make the zombie solid again as soon as there is space
	end
end

	ENT.IdleSequence = "nz_idle_ad"

	ENT.CrawlIdleSequence = "nz_idle_crawl"

	-- Called when the zombie wants to idle. Play an animation here
	function ENT:PerformIdle()
		if self:GetCrawler() and !self.IsMooSpecial then
			self:ResetSequence(self.CrawlIdleSequence)
		elseif (self.BO4IsShocked and self:BO4IsShocked() or self.BO4IsScorped and self:BO4IsScorped() or self.BO4IsSpinning and self:BO4IsSpinning() or self:GetNW2Bool("OnAcid")) and self:GetCrawler() and !self.IsMooSpecial then
			self:ResetSequence(self.CrawlSparkySequences[math.random(#self.CrawlSparkySequences)])
		elseif (self.BO4IsShocked and self:BO4IsShocked() or self.BO4IsScorped and self:BO4IsScorped() or self.BO4IsSpinning and self:BO4IsSpinning() or self:GetNW2Bool("OnAcid")) and !self:GetCrawler() and !self.IsMooSpecial then
			self:ResetSequence(self.SparkySequences[math.random(#self.SparkySequences)])
		else
			self:ResetSequence(self.IdleSequence)
		end
	end

-- Returns to normal movement sequence. Call this in events where you want to MoveToPos after an animation
function ENT:ResetMovementSequence()
	if self:GetCrawler() then
		self:ResetSequence(self.CrawlMovementSequence)
	elseif IsValid(self.Target) and self.Target:GetClass() == "nz_bo3_tac_gersch" and !self.IsMooSpecial then
		self:ResetSequence(self.BlackholeMovementSequence)
	--[[elseif self:ZombieWaterLevel() >= 2 and !self.IsMooSpecial then
		self:ResetSequence(self.LowgMovementSequence)]]
	else
		self:ResetSequence(self.MovementSequence)
	end
end

-- 
function ENT:UpdateMovementSequences()
	if self.SequenceTables then
			local t
		if self.SpeedBasedSequences then
			for k,v in pairs(self.SequenceTables) do
				if v.Threshold and v.Threshold > self:GetRunSpeed() then break end
				t = v
			end
		else
			t = self.SequenceTables[math.random(#self.SequenceTables)]
		end

		if t then
			local seqs = t.Sequences[1] and t.Sequences[math.random(#t.Sequences)] or t.Sequences -- If Sequences is a numerical table, pick a random one (supports random selection)
			for k,v in pairs(seqs) do
				self[k] = v[math.random(#v)] -- Pick a random entry
			end
		end
	end
end

ENT.RagdollDeathSequences = {
	"ragdoll"
}
ENT.MeleeDeathSequences = {
	"nz_death_falltoknees_1",
	"nz_death_falltoknees_2",
	"nz_death_nerve",
	"nz_death_neckgrab"
}
ENT.BlastDeathSequences = {
	"nz_death_blast_1",
	"nz_death_blast_2"
}

ENT.BlastDeathLeftSequences = {
	"nz_death_blast_from_right", -- Love you Fox <3 ~Moo
}
ENT.BlastDeathRightSequences = {
	"nz_death_blast_from_left",
}
ENT.BlastDeathBackSequences = {
	"nz_death_blast_from_back",
}

ENT.SuperTauntSequences = {
	"nz_supertaunt_v1",
	--"nz_supertaunt_v2",
}
ENT.SlipGunSequences = {
	"nz_slipslide_collapse",
}
ENT.MicrowaveSequences = {
	"nz_dth_microwave_1",
	"nz_dth_microwave_2",
	"nz_dth_microwave_3",
}
ENT.FreezeSequences = {
	"nz_dth_freeze_1",
	"nz_dth_freeze_2",
	"nz_dth_freeze_3",
}
ENT.DeathRaySequences = {
	"nz_dth_deathray_2",
	"nz_dth_deathray_3",
	"nz_dth_deathray_4",
}
ENT.IdGunSequences = {
	"nz_idgunhole",
}
ENT.AcidStunSequences = {
	"nz_acid_stun_1",
	"nz_acid_stun_2",
	"nz_acid_stun_3",
}
ENT.SparkySequences = {
	"nz_sparky_a",
	"nz_sparky_b",
	"nz_sparky_c",
	"nz_sparky_d",
	"nz_sparky_e",
}
ENT.UnawareSequences = {
	"nz_unaware_idle",
	"nz_unaware_idle_2",
}
ENT.CrawlDeathSequences = {
	"nz_crawl_death_v1",
	"nz_crawl_death_v2",
}
ENT.CrawlTeslaDeathSequences = {
	"nz_crawl_tesla_death_v1",
	"nz_crawl_tesla_death_v2",
}
ENT.CrawlFreezeDeathSequences = {
	"nz_crawl_freeze_death_v1",
	"nz_crawl_freeze_death_v2",
}
ENT.CrawlMicrowaveSequences = {
	"nz_crawl_dth_microwave_1",
	"nz_crawl_dth_microwave_2",
	"nz_crawl_dth_microwave_3",
}
ENT.CrawlSparkySequences = {
	"nz_crawl_sparky_a",
	"nz_crawl_sparky_b",
	"nz_crawl_sparky_c",
	"nz_crawl_sparky_d",
	"nz_crawl_sparky_e",
}
ENT.SideStepSequences = {
	"nz_dodge_sidestep_left_a",
	"nz_dodge_sidestep_left_b",
	"nz_dodge_sidestep_right_a",
	"nz_dodge_sidestep_right_b",
	"nz_dodge_roll_a",
	"nz_dodge_roll_b",
	"nz_dodge_roll_c",
}
ENT.CrawlerSounds = {
	Sound("nz_moo/zombies/vox/_classic/crawl/crawl_00.mp3"),
	Sound("nz_moo/zombies/vox/_classic/crawl/crawl_01.mp3"),
	Sound("nz_moo/zombies/vox/_classic/crawl/crawl_02.mp3"),
	Sound("nz_moo/zombies/vox/_classic/crawl/crawl_03.mp3"),
	Sound("nz_moo/zombies/vox/_classic/crawl/crawl_04.mp3"),
	Sound("nz_moo/zombies/vox/_classic/crawl/crawl_05.mp3"),
}

ENT.MonkeySounds = {
	Sound("nz_moo/zombies/vox/monkey/groan_00.mp3"),
	Sound("nz_moo/zombies/vox/monkey/groan_01.mp3"),
	Sound("nz_moo/zombies/vox/monkey/groan_02.mp3"),
	Sound("nz_moo/zombies/vox/monkey/groan_03.mp3"),
	Sound("nz_moo/zombies/vox/monkey/groan_04.mp3"),
	Sound("nz_moo/zombies/vox/monkey/groan_05.mp3"),
	Sound("nz_moo/zombies/vox/monkey/groan_06.mp3"),
	Sound("nz_moo/zombies/vox/monkey/groan_07.mp3"),
}

if SERVER then
--Targets
function ENT:HasTarget()
	return self:IsValidTarget( self:GetTarget() )
end

function ENT:GetTarget()
	return self.Target
end

function ENT:GetTargetNavArea()
	return self:HasTarget() and navmesh.GetNearestNavArea( self:GetTarget():GetPos(), false, 100)
end

function ENT:SetTarget( target )
	self.Target = target
	if self.Target ~= target then
		self:SetLastTargetChange(CurTime())
	end
end

function ENT:IsTarget( ent )
	return self.Target == ent
end

function ENT:RemoveTarget()
	self:SetTarget( nil )
end

function ENT:IsValidTarget( ent )
	if not ent then return false end
	return IsValid( ent ) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY -- This is really funny.
end

function ENT:GetIgnoredTargets()
	return self.tIgnoreList
end

function ENT:IgnoreTarget( target )
	table.insert(self.tIgnoreList, target)
end

function ENT:IsIgnoredTarget( ent )
	table.HasValue(self.tIgnoreList, ent)
end

function ENT:ResetIgnores()
	self.tIgnoreList = {}
end

-- Lets you determine how long until the next retarget
-- This is called after a retarget. You can use the distance, it is known to be the smallest distance to all players
function ENT:CalculateNextRetarget(target, dist)
	return math.Clamp(dist/200, 3, 15) -- 1 second for every 100 units to the closet player
end

function ENT:GetTargetPosition() return self.LockedTargetPosition or self:SelectTargetPosition() end -- Get the current goal location. Supports locked goal locations

function ENT:SetNextRetarget(time) self.NextRetarget = CurTime() + time end -- Sets the next time the Zombie will repath to its target --Moo Mark Target

-- Here you can do things such as determine your own locations that might not be right on the target
function ENT:SelectTargetPosition()
	return self.Target:GetPos()
end


local function GetClearPaths(ent, pos, tiles)
	local clearPaths = {}
	local filter = player.GetAll()
	for _, tile in pairs( tiles ) do
		local tr = util.TraceLine({
			start = pos,
			endpos = tile,
			filter = filter,
			mask = MASK_PLAYERSOLID
		})
		
		if not tr.Hit and util.IsInWorld(tile) then
			table.insert( clearPaths, tile )
		end
	end
	
	return clearPaths
end

local function GetSurroundingTiles(ent, pos)
	local tiles = {}
	local x, y, z
	local minBound, maxBound = ent:OBBMins(), ent:OBBMaxs()
	local checkRange = math.max(12, maxBound.x, maxBound.y)
	
	for z = -1, 1, 1 do
		for y = -1, 1, 1 do
			for x = -1, 1, 1 do
				local testTile = Vector(x,y,z)
				testTile:Mul( checkRange )
				local tilePos = pos + testTile
				table.insert( tiles, tilePos )
			end
		end
	end
	
	return tiles
end

local function CollisionBoxClear(ent, pos, minBound, maxBound)
	local filter = {ent}
	local tr = util.TraceEntity({
		start = pos,
		endpos = pos,
		filter = filter,
		mask = MASK_PLAYERSOLID
	}, ent)

	return !tr.StartSolid || !tr.AllSolid
end

function ENT:FindSpotBehindPlayer(pos, count, range, stepd, stepu)
	local targ = self:GetTarget()
	pos = pos or targ:GetPos()
	range = range or 100
	stepd = stepd or 25
	stepu = stepu or 25
	count = count or 6

	if navmesh.IsLoaded() then
		local tab = navmesh.Find(pos, range, stepd, stepu)
		local postab = {}

		for i=1, count do
			for _, nav in RandomPairs(tab) do
				if IsValid(nav) and not nav:IsUnderwater() then
					local testpos = nav:GetRandomPoint()
					local norm = (testpos - pos):GetNormal()

					if targ:GetAimVector():Dot(norm) < 0 then
						table.insert(postab, testpos)
						break
					end
				end
			end
		end

		if not table.IsEmpty(postab) then
			table.sort(postab, function(a, b) return a:DistToSqr(pos) < b:DistToSqr(pos) end)
			pos = postab[1]
		end
	end

	local minBound, maxBound = self:OBBMins(), self:OBBMaxs()
	if not CollisionBoxClear( self, pos, minBound, maxBound ) then
		local surroundingTiles = GetSurroundingTiles( self, pos )
		local clearPaths = GetClearPaths( self, pos, surroundingTiles )	
		for _, tile in pairs( clearPaths ) do
			if CollisionBoxClear( self, tile, minBound, maxBound ) then
				pos = tile
				break
			end
		end
	end

	return pos
end

function ENT:FindNearestSpawner(pos)
    local nearbyents = {}
    for k, v in pairs(ents.FindByClass("nz_spawn_zombie_normal")) do
        if v.GetSpawner and v:GetSpawner() then
            if v:IsSuitable() then
                table.insert(nearbyents, v)
            end
        end
    end

    table.sort(nearbyents, function(a, b) return a:GetPos():DistToSqr(pos) < b:GetPos():DistToSqr(pos) end)
    return nearbyents[1]
end

function ENT:FindNearestSpecialSpawner(pos)
    local nearbyents = {}
    for k, v in pairs(ents.FindByClass("nz_spawn_zombie_special")) do
        if v.GetSpawner and v:GetSpawner() then
            if v:IsSuitable() then
                table.insert(nearbyents, v)
            end
        end
    end

    table.sort(nearbyents, function(a, b) return a:GetPos():DistToSqr(pos) < b:GetPos():DistToSqr(pos) end)
    return nearbyents[1]
end

end

--AccessorFuncs
function ENT:IsJumping()
	return self:GetJumping()
end

function ENT:IsClimbing()
	return self:GetClimbing()
end

function ENT:IsAttacking()
	return self:GetAttacking()
end

function ENT:IsStandingAttack()
	return self:GetStandingAttack()
end

function ENT:IsTimedOut()
	return self:GetTimedOut()
end

function ENT:SetInvulnerable(bool)
	self.Invulnerable = bool
end

function ENT:IsInvulnerable()
	return self.Invulnerable
end

function ENT:EyePos()
	return self:WorldSpaceCenter() + (self:OBBCenter()*0.7)
end

function ENT:WaterBuff() return self:GetWaterBuff() end

if CLIENT then
	local eyeglow =  Material("nz_moo/sprites/moo_glow1")
	local defaultColor = Color(255, 75, 0, 255)

	function ENT:Draw() //Runs every frame
		self:DrawModel()
		if self.RedEyes and self:Alive() and !self:GetDecapitated() and !self:GetMooSpecial() and !self.IsMooSpecial then
			self:DrawEyeGlow() 
		end

		if self:WaterBuff() and self:Alive() then
			local elight = DynamicLight( self:EntIndex(), true )
			if ( elight ) then
				local bone = self:LookupBone("j_spineupper")
				local pos = self:GetBonePosition(bone)
				pos = pos 
				elight.pos = pos
				elight.r = 0
				elight.g = 50
				elight.b = 255
				elight.brightness = 10
				elight.Decay = 1000
				elight.Size = 40
				elight.DieTime = CurTime() + 1
				elight.style = 0
				elight.noworld = true
			end
		end

		if GetConVar( "nz_zombie_debug" ):GetBool() then
			render.DrawWireframeBox(self:GetPos(), Angle(0,0,0), self:OBBMins(), self:OBBMaxs(), Color(255,0,0), true)
		end
	end

	function ENT:DrawEyeGlow()
		local eyeColor = !IsColor(nzMapping.Settings.zombieeyecolor) and defaultColor or nzMapping.Settings.zombieeyecolor
		local latt = self:LookupAttachment("lefteye")
		local ratt = self:LookupAttachment("righteye")

		if latt == nil then return end
		if ratt == nil then return end

		local leye = self:GetAttachment(latt)
		local reye = self:GetAttachment(ratt)

		if leye == nil then return end
		if reye == nil then return end

		local righteyepos = leye.Pos + leye.Ang:Forward()*0.5
		local lefteyepos = reye.Pos + reye.Ang:Forward()*0.5

		if lefteyepos and righteyepos then
			render.SetMaterial(eyeglow)
			render.DrawSprite(lefteyepos, 4, 4, eyeColor)
			render.DrawSprite(righteyepos, 4, 4, eyeColor)
		end
	end
end


-- God I love Roxanne, she's such a bad bitch tho!!! Chica is cool too
-- NEWS FLASH!!! Roxanne and Chica are bad bitches!!! I'm adding Loona to that list.
-- If you're checking for something new then I don't got anything this time.
-- If you're also some random person looking through this then pay these comments no mind... If you do... Fuck you.

-- I'm perfectly fine and not mentally ill in anyway, shape, or form... Don't listen to the lies above... They aren't true in the slightest... Or are they?
-- Fuck it, I'm mentally ill and my favorite characters are anthro furry women.

-- The ELECTRIC SLIDE