AddCSLuaFile()

--debug cvars
CreateConVar( "nz_zombie_debug", "0", { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_CHEAT } )

--[[
This Base is not really spawnable but it contains a lot of useful functions for it's children
--]]

--Boring
ENT.Base = "base_nextbot"
ENT.Type = "nextbot"
ENT.Category = "Brainz"
ENT.Author = "Lolle & Zet0r"
ENT.Spawnable = true

-- Zombie Stuffz
-- fallbacks
ENT.DeathDropHeight = 700
ENT.StepHeight = 22 --Default is 18 but it makes things easier
ENT.JumpHeight = 70
ENT.AttackRange = 65
ENT.RunSpeed = 200
ENT.WalkSpeed = 100
ENT.Acceleration = 1000
ENT.DamageLow = 35
ENT.DamageHigh = 45
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

-- important for ent:IsZombie()
ENT.bIsZombie = true
ENT.bSelfHandlePath = true -- PathFollower will not auto-check for barricades or navlocks

--The Accessors will be partially shared, but should only be used serverside
AccessorFunc( ENT, "fWalkSpeed", "WalkSpeed", FORCE_NUMBER)
AccessorFunc( ENT, "fRunSpeed", "RunSpeed", FORCE_NUMBER)
AccessorFunc( ENT, "fAttackRange", "AttackRange", FORCE_NUMBER)
AccessorFunc( ENT, "fLastLand", "LastLand", FORCE_NUMBER)
AccessorFunc( ENT, "fLastTargetCheck", "LastTargetCheck", FORCE_NUMBER)
AccessorFunc( ENT, "fLastAtack", "LastAttack", FORCE_NUMBER)
AccessorFunc( ENT, "fLastTargetChange", "LastTargetChange", FORCE_NUMBER)
AccessorFunc( ENT, "fTargetCheckRange", "TargetCheckRange", FORCE_NUMBER)

--Stuck prevention
AccessorFunc( ENT, "fLastPostionSave", "LastPostionSave", FORCE_NUMBER)
AccessorFunc( ENT, "fLastPush", "LastPush", FORCE_NUMBER)
AccessorFunc( ENT, "iStuckCounter", "StuckCounter", FORCE_NUMBER)
AccessorFunc( ENT, "vStuckAt", "StuckAt")
AccessorFunc( ENT, "bTimedOut", "TimedOut")
AccessorFunc( ENT, "bTargetUnreachable", "TargetUnreachable", FORCE_BOOL)


-- spawner accessor
AccessorFunc(ENT, "hSpawner", "Spawner")

AccessorFunc( ENT, "bJumping", "Jumping", FORCE_BOOL)
AccessorFunc( ENT, "bAttacking", "Attacking", FORCE_BOOL)
AccessorFunc( ENT, "bClimbing", "Climbing", FORCE_BOOL)
AccessorFunc( ENT, "bWandering", "Wandering", FORCE_BOOL)
AccessorFunc( ENT, "bStop", "Stop", FORCE_BOOL)
AccessorFunc( ENT, "bSpecialAnim", "SpecialAnimation", FORCE_BOOL)
AccessorFunc( ENT, "bBlockAttack", "BlockAttack", FORCE_BOOL)

AccessorFunc(ENT, "m_bTargetLocked", "TargetLocked", FORCE_BOOL) -- Stops the Zombie from retargetting and keeps this target while it is valid and targetable
AccessorFunc( ENT, "iActStage", "ActStage", FORCE_NUMBER)

ENT.ActStages = {}

if CLIENT then
	ENT.RedEyes = true
end

function ENT:SetupDataTables()
	-- If you want decapitation in you zombie and overwrote ENT:SetupDataTables() make sure to add self:NetworkVar("Bool", 0, "Decapitated") again.
	self:NetworkVar("Bool", 0, "Decapitated")
	self:NetworkVar("Bool", 1, "Alive")
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
		util.PrecacheModel( choice.Model ) -- Model Precache Moment 
														--Moo Mark
		self:SetModel(choice.Model)
		if choice.Skin then self:SetSkin(choice.Skin) end
			for i,v in ipairs(self:GetBodyGroups()) do
			self:SetBodygroup( i-1, math.random(0, self:GetBodygroupCount(i-1) - 1))
		end
	end
	--Init
	function ENT:Initialize()

		self:Precache()
		self:UpdateModel()

		self:SetJumping( false )
		self:SetLastLand( CurTime() + 1 ) --prevent jumping after spawn
		self:SetLastTargetCheck( CurTime() )
		self:SetLastTargetChange( CurTime() )

		--stuck prevetion
		self:SetLastPush( CurTime() )
		self:SetLastPostionSave( CurTime() )
		self:SetStuckAt( self:GetPos() )
		self:SetStuckCounter( 0 )
		self:SetTargetUnreachable(true)
		self:SetWandering(false)
		self:SetAttacking( false )
		self:SetLastAttack( CurTime() )
		self:SetAttackRange( self.AttackRange )
		if  nzMapping.Settings.range then
			self:SetTargetCheckRange(nzMapping.Settings.range)
			if nzMapping.Settings.range <= 0 then
				self:SetTargetCheckRange(math.huge)
			end
		else
			self:SetTargetCheckRange(2000)
		end	-- 0 for no distance restriction (infinite)

		--target ignore
		self:ResetIgnores()

		self:SetHealth( 75 ) --fallback

		self:SetRunSpeed( self.RunSpeed ) --fallback
		self:SetWalkSpeed( self.WalkSpeed ) --fallback

		self:SetCollisionBounds(Vector(-13,-13, 0), Vector(13, 13, 72))

		self:SetActStage(0)
		self:SetSpecialAnimation(false)

		self:SetNextRetarget(0)
		--self:SetNextRepath(0)

		self:StatsInitialize()
		self:SpecialInit()

		if SERVER then
			self.loco:SetDeathDropHeight( self.DeathDropHeight )
			self.loco:SetDesiredSpeed( self:GetRunSpeed() )
			self.loco:SetAcceleration( self.Acceleration )
			self.loco:SetJumpHeight( self.JumpHeight )
			self.DesiredSpeed = self:GetRunSpeed()
			if self.SpeedBasedSequences then
				self:UpdateMovementSequences()
			end
			if GetConVar("nz_zombie_lagcompensated"):GetBool() then
				self:SetLagCompensated(true)
			end
			self.BarricadeJumpTries = 0
			self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
			self:SetAlive(true)
		end
	end

	--init for class related attributes hooks etc...
	function ENT:SpecialInit()
		--print("PLEASE Override the base class!")
	end

	function ENT:StatsInit()
		--print("PLEASE Override the base class!")
	end
end

-- Select a spawn sequence and sound to play. This is called after everything is initialized
function ENT:SelectSpawnSequence()
	local s
	if self.SpawnSounds then s = self.SpawnSounds[math.random(#self.SpawnSounds)] end
	return type(self.SpawnSequence) == "table" and self.SpawnSequence[math.random(#self.SpawnSequence)] or self.SpawnSequence, s
end

-- Collide When Possible
local collidedelay = 0.5
local bloat = Vector(5,5,0)

function ENT:Think()
	if SERVER then --think is shared since last update but all the stuff in here should be serverside
		if ( self:IsAllowedToMove() and self.loco:GetVelocity():Length2D() >= 110 or self:IsAttacking()) and self.loco:GetVelocity():Length2D() >= 10 then --Moo Mark
        	self.loco:SetVelocity(self:GetForward() * self:GetRunSpeed())
        end
		if not self:IsJumping() and not self:GetSpecialAnimation() and (self:GetSolidMask() == MASK_NPCSOLID_BRUSHONLY or self:GetSolidMask() == MASK_SOLID_BRUSHONLY) then
			local occupied = false
			local tr = util.TraceHull( {
				start = self:GetPos(),
				endpos = self:GetPos(),
				filter = self,
				mins = Vector( -20, -20, -0 ),
				maxs = Vector( 20, 20, 70 ),
				mask = MASK_NPCSOLID
			} )
			if !tr.HitNonWorld then
				self:SetSolidMask(MASK_NPCSOLID)
				self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
				--print("No longer no-colliding")
			end
			--[[for _,ent in pairs(ents.FindInBox(self:GetPos() + Vector( -16, -16, 0 ), self:GetPos() + Vector( 16, 16, 70 ))) do
				if ent:GetClass() == "nz_zombie*" and ent != self then occupied = true end
			end
			if !occupied then self:SetSolidMask(MASK_NPCSOLID) end]]
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

				local b = IsValid(tr.Entity)
				if not b then
					self:SetSolidMask(MASK_NPCSOLID)
					self.DoCollideWhenPossible = nil
					self.NextCollideCheck = nil
				else
					self.NextCollideCheck = CurTime() + collidedelay
				end
			end
		end

		if self.loco:IsUsingLadder() then
			self:SetSolidMask(MASK_NPCSOLID_BRUSHONLY)
		end

		--this is a very costly operation so we only do it every second
		--[[if self:GetLastTargetCheck() + 1 < CurTime() then
			self:SetTarget(self:GetPriorityTarget())
		end]]

		-- We don't want to say we're stuck if it's because we're attacking or timed out and !self:GetTimedOut() 
		if not self:GetAttacking() and self:GetLastPostionSave() + 4 < CurTime() then
			if self:GetPos():Distance( self:GetStuckAt() ) < 10 then
				self:SetStuckCounter( self:GetStuckCounter() + 1)
			else
				self:SetStuckCounter( 0 )
			end

			if self:GetStuckCounter() > 2 then

				local tr = util.TraceHull({
					start = self:GetPos(),
					endpos = self:GetPos(),
					maxs = self:OBBMaxs(),
					mins = self:OBBMins(),
					filter = self
				})
				if tr.Hit then
					--if there bounding box is intersecting with something there is now way we can unstuck them just respawn.
					--make a dust cloud to make it look less ugly
					local effectData = EffectData()
					effectData:SetStart( self:GetPos() + Vector(0,0,32) )
					effectData:SetOrigin( self:GetPos() + Vector(0,0,32) )
					effectData:SetMagnitude(1)
					util.Effect("zombie_spawn_dust", effectData)
					self:Remove()
				end

				if self:GetStuckCounter() <= 3 then
					--try to unstuck via random velocity
					self:ApplyRandomPush()
				end

				if self:GetStuckCounter() > 3 and self:GetStuckCounter() <= 5 then
					--try to unstuck via jump
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

				if self:GetStuckCounter() > 5 then
					--Worst case:
					--respawn the zombie after 32 seconds with no postion change
					if self.NZBossType then
						nzRound:SpawnBoss(self.NZBossType)
						self:Remove()
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
	end
	self:OnThink()
		if not self.NextSound or self.NextSound < CurTime() and not self:GetAttacking() and self:Alive() then
			self:Sound() --Moo Mark
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
		debugoverlay.Text( self:GetPos() + spacing, tostring(self), FrameTime() * 2 )
	end
end

------- Fields -------
ENT.SoundDelayMin = 3
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
			self:PlaySound(self.BehindSounds[math.random(#self.BehindSounds)], SNDLVL_140) -- Play the behind sound, and a bit louder!
	elseif self.PassiveSounds then
		self:PlaySound(self.PassiveSounds[math.random(#self.PassiveSounds)],92, math.random(85, 105), 1, 2)
	else
		-- We still delay by max sound delay even if there was no sound to play
		self.NextSound = CurTime() + self.SoundDelayMax
	end
end

if SERVER then
	function ENT:RunBehaviour()

		self:Retarget()
		self:SpawnZombie()

		while (true) do

			if self.EventMask and not self.DoCollideWhenPossible then
				self:SetSolidMask(MASK_NPCSOLID)
			end
			if not self:GetStop() then
				self:SetTimedOut(false)
				local ct = CurTime()
				if ct >= self.NextRetarget then
					local oldtarget = self.Target
					self:Retarget() --The overall process of looking for targets is handled much like how it is in nZu. While it may not save much fps in solo... Turns out this can vastly help the performance of multiplayer games.
				end
				if self:HasTarget() then
					local pathResult = self:ChaseTarget( {
						maxage = 1,
						draw = false,
						tolerance = self:GetSpecialAnimation() and 0 or ((self:GetAttackRange() -30) > 0 ) and self:GetAttackRange() - 20
					} )
					if pathResult == "failed" then
						self:SetTargetUnreachable(true)
					end
					if pathResult == "ok" then
						if self:TargetInAttackRange() then
							self:OnTargetInAttackRange()
						else
							self:TimeOut(0.5)
						end
					elseif pathResult == "timeout" then --asume pathing timedout, maybe we are stuck maybe we are blocked by barricades
						self:SetTargetUnreachable(true)
						self:OnPathTimeOut()
					else
						self:TimeOut(2)
						-- path failed what should we do :/?
					end
				else
					self:OnNoTarget()
				end
			else
				self:TimeOut(2)
			end
		end
	end
end

function ENT:Stop()
	self:SetStop(true)
	self:SetTarget(nil)
end

function ENT:SpawnZombie()
	--BAIL if no navmesh is near
	local nav = navmesh.GetNearestNavArea( self:GetPos() )
	if !self:IsInWorld() or !IsValid(nav) or nav:GetClosestPointOnArea( self:GetPos() ):DistToSqr( self:GetPos() ) >= 10000 then
		ErrorNoHalt("Zombie ["..self:GetClass().."]["..self:EntIndex().."] spawned too far away from a navmesh!")
		self:RespawnZombie()
	end

	self:OnSpawn()
end

function ENT:OnSpawn()

end

function ENT:OnTargetInAttackRange()
	if not self:GetBlockAttack() then
		self:Attack()
	else
		self:TimeOut(2)
	end
end
				
function ENT:SelectTauntSequence() --Supported Zombies now have the chance to play a taunt animation as they're destroying a barricade!
	local s
	return type(self.TauntSequences) == "table" and self.TauntSequences[math.random(#self.TauntSequences)] or self.TauntSequences, s
end

function ENT:OnBarricadeBlocking( barricade, dir )
	if not self:GetSpecialAnimation() then
		if (IsValid(barricade) and barricade:GetClass() == "breakable_entry" ) then
			if barricade:GetNumPlanks() > 0 then
				timer.Simple(0.3, function()
					barricade:EmitSound("physics/wood/wood_plank_break" .. math.random(1, 4) .. ".wav", 100, math.random(90, 130))
					barricade:RemovePlank()
				end)

				self:SetAngles(Angle(0,(barricade:GetPos()-self:GetPos()):Angle()[2],0))
				local seq, dur

				local attacktbl = self.ActStages[1] and self.ActStages[1].attackanims or self.AttackSequences
				local taunttbl = self.TauntSequences
				local target = type(attacktbl) == "table" and attacktbl[math.random(#attacktbl)] or attacktbl
				local taunt = type(taunttbl) == "table" and taunttbl[math.random(#taunttbl)] or taunttbl
			
				if type(target) == "table" then
					seq, dur = self:LookupSequenceAct(target.seq)
				elseif target then -- It is a string or ACT
					seq, dur = self:LookupSequenceAct(target)
				else
					seq, dur = self:LookupSequence("swing")
				end
			
				local tauntchance = math.random(1,100)
				self:SetAttacking(true)
				self:PlaySequenceAndWait(seq, 1)
				self:SetLastAttack(CurTime())
					if self.IsMooZombie then -- Moo Mark
						if tauntchance <= 25 then --The higher the number, the more likely a zombie will taunt.
							self:SetStuckCounter( 0 ) --This is just to make sure a zombie won't despawn at a barricade.
							local seq,s = self:SelectTauntSequence()
							if seq then
								self:PlaySequenceAndWait(seq)
								self:SetAttacking(false)
							end
						else
							self:SetAttacking(false)
							self:UpdateSequence()
						end
					else
						self:SetAttacking(false)
						self:UpdateSequence()
					end
				if coroutine.running() then
					coroutine.wait(2 - dur)
				end

				-- this will cause zombies to attack the barricade until it's destroyed
				local stillBlocked, dir = self:CheckForBarricade()
				if stillBlocked then
					self:OnBarricadeBlocking(stillBlocked, dir)
					return
				end

				-- Attacking a new barricade resets the counter
				self.BarricadeJumpTries = 0
			elseif barricade:GetTriggerJumps() and self.TriggerBarricadeJump then
				local dist = barricade:GetPos():DistToSqr(self:GetPos())
				if dist <= 3500 + (1000 * self.BarricadeJumpTries) then
					self:TriggerBarricadeJump(barricade, dir)
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
end

function ENT:TimeOut(time)
	self:SetTimedOut(true)
	--if not self:HasTarget() and not self:GetSpecialAnimation() then --Only play Idle anim if the Zombie doesn't have a target. Moo Mark
	if not self:GetSpecialAnimation() then 
		self:PerformIdle()
	end
	if coroutine.running() then
		coroutine.wait(time)
	end
end

function ENT:OnPathTimeOut()

end

function ENT:OnNoTarget()
	self:TimeOut(0.5)
	-- Start off by checking for a new target
	local newtarget = self:GetPriorityTarget()
		if self:IsValidTarget(newtarget) then
			self:SetTarget(newtarget)
		else
			if not self:IsInSight() then
				if self.NZBossType then
					nzRound:SpawnBoss(self.NZBossType)
					self:Remove()
				else
					self:RespawnZombie()
				end
			else
			self:TimeOut(3) -- Time out even longer if seen
		end
	end
end

function ENT:OnContactWithTarget()

end

function ENT:OnLandOnGroundZombie()
	self:ResetMovementSequence()
end

function ENT:OnThink()

end

--Default NEXTBOT Events
function ENT:OnLandOnGround()
	self:EmitSound("physics/flesh/flesh_impact_hard" .. math.random(1, 6) .. ".wav")
	self:SetJumping( false )
	if self:HasTarget() then
		self.loco:SetDesiredSpeed(self:GetRunSpeed())
	else
		self.loco:SetDesiredSpeed(self:GetWalkSpeed())
	end
	self.loco:SetAcceleration( self.Acceleration )
	self.loco:SetStepHeight( 22 )
	self:SetLastLand(CurTime())
	self:OnLandOnGroundZombie()
end

function ENT:OnLeaveGround( ent )
	self:SetJumping( true )
end

function ENT:OnNavAreaChanged(old, new)
	if bit.band(new:GetAttributes(), NAV_MESH_JUMP) != 0 then
		--dont make jumps in the wrong direction
		if old:ComputeGroundHeightChange( new ) < 0 then
			return
		end
		self:Jump()
	end
end

function ENT:OnContact( ent )
	if nzConfig.ValidEnemies[ent:GetClass()] and nzConfig.ValidEnemies[self:GetClass()] then
		--this is a poor approach to unstuck them when walking into each other
		self.loco:Approach( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 2000,1000)
		--important if the get stuck on top of each other!
		--if math.abs(self:GetPos().z - ent:GetPos().z) > 30 then self:SetSolidMask( MASK_NPCSOLID_BRUSHONLY ) end
	end
	--buggy prop push away thing comment if you dont want this :)
	if  ( ent:GetClass() == "prop_physics_multiplayer" or ent:GetClass() == "prop_physics" ) then
		--self.loco:Approach( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 2000,1000)
		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			local force = -physenv.GetGravity().z * phys:GetMass() / 12 * ent:GetFriction()
			local dir = ent:GetPos() - self:GetPos()
			dir:Normalize()
			phys:ApplyForceCenter( dir * force )
		end
	end

	if self:IsTarget( ent ) then
		self:OnContactWithTarget()
	end
end

function ENT:OnInjured( dmgInfo )
	local attacker = dmgInfo:GetAttacker()
	if self:IsValidTarget( attacker ) then
		self:SetTarget( attacker )
	end
	local soundName = self.PainSounds[ math.random( #self.PainSounds ) ]
	self:EmitSound( soundName, 97, math.random(95, 100))
end

function ENT:Alive() return self:GetAlive() end

if SERVER then
	ENT.DeathRagdollForce = 9500

	function ENT:OnKilled(dmgInfo)
		if dmgInfo and self:Alive() then -- Only call once!
			self.ZombieAlive = false
			self:SetAlive(false)
			self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
			hook.Call("OnZombieKilled", GAMEMODE, self, dmgInfo)
			self:PerformDeath(dmgInfo) -- DMG_MISSILEDEFENSE for skull based death
			local headbone = self:LookupBone("ValveBiped.Bip01_Head1")
			if !headbone then headbone = self:LookupBone("j_head") end
			if headbone then
				local headPos = self:GetBonePosition(headbone)
				local dmgPos = dmgInfo:GetDamagePosition()
				-- it will not always trigger since the offset can be larger than 12
				-- but I think it's fine not to decapitate every headshotted zombie
				if headPos and dmgPos and headPos:Distance(dmgPos) < 12 then
					self:SetDecapitated(true)
				end
			end
		end
	end

	function ENT:PerformDeath(dmgInfo)
		if self.DeathRagdollForce == 0 or self.DeathRagdollForce <= dmgInfo:GetDamageForce():Length() or self:GetSpecialAnimation() or dmgInfo:GetDamageType() == DMG_ENERGYBEAM then
			self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
			self:BecomeRagdoll(dmgInfo)
		else
			if dmgInfo:GetDamageType() == DMG_SHOCK then
				self:PlaySound(self.ElecSounds[math.random(#self.ElecSounds)], 90, math.random(85, 105), 1, 2)
				self:DoDeathAnimation(self.ElectrocutionSequences[math.random(#self.ElectrocutionSequences)])
			else
				self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
				self:DoDeathAnimation(self.DeathSequences[math.random(#self.DeathSequences)])
			end
		end
	end

	function ENT:DoDeathAnimation(seq)
		self.BehaveThread = coroutine.create(function()
			self:PlaySequenceAndWait(seq)
			self:BecomeRagdoll(DamageInfo())
		end)
	end

	function ENT:DoSpecialAnimation(seq)
		self.BehaveThread = coroutine.create(function()
			self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
			self:PlaySequenceAndWait(seq)
			--self:BecomeRagdoll(DamageInfo())
		end)
	end
end



function ENT:OnRemove()

end

function ENT:OnStuck()
	--
	--self.loco:Approach( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 2000, 1000 )
	--print("Now I'm stuck", self)
end

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
			if v:GetTargetPriority() == TARGET_PRIORITY_ALWAYS then return v end
			local d = self:GetRangeTo(v)
			if v:GetTargetPriority() == TARGET_PRIORITY_SPECIAL or d < mindist and self:IsValidTarget(v) then
				target = v
				mindist = d
				print(target, mindist)
			end
		end

		return target, mindist
	end

	function ENT:ChaseTarget( options )

		options = options or {}

		if !options.target then
			options.target = self:GetTarget()
		end

		local path = self:ChaseTargetPath( options )

		if ( !IsValid(path) ) then return "failed" end
		while ( path:IsValid() and self:HasTarget() and !self:TargetInAttackRange() ) do

			path:Update( self )
			self:SetTargetUnreachable(false)

			-- Timeout the pathing so it will rerun the entire behaviour
			local distToTarget = self:GetPos():Distance(self:GetTargetPosition())
				if path:GetAge() > math.Clamp(distToTarget / 1000,3,10) then -- This is pulled from Ba2 for distance based repathing.
					return "timeout"
				end
				if path:IsValid() then
					if path:GetAge() > 1 and (distToTarget < 1000) then -- We're closing in, let's start repathing sooner!
						return "timeout"
					elseif path:GetAge() > 0.45 and (distToTarget < 250) or path:GetAge() > 0.1 and (distToTarget < 250) and self.loco:GetVelocity():Length2D() >= 150 then -- We're nearing attack range! Don't stop now! self.loco:GetVelocity():Length2D() >= 110
						return "timeout"
					end
				end
			--path:Update( self )	-- This function moves the bot along the path
			if options.draw or GetConVar( "nz_zombie_debug" ):GetBool() then
				path:Draw()
			end

			if self:HasTarget() and !self:GetAttacking() and self:IsAllowedToMove() and self:IsOnGround() then
				self:ResetMovementSequence() -- This is the main point that starts the movement anim. Moo Mark
			end
			--the jumping part simple and buggy
			--local scanDist = (self.loco:GetVelocity():Length()^2)/(2*900) + 15
			local scanDist
			--this will probaly need asjustments to fit the zombies speed
			if self:GetVelocity():Length2D() > 150 then scanDist = 30 else scanDist = 20 end
			--debug section
			if GetConVar( "nz_zombie_debug" ):GetBool() then
				debugoverlay.Line( self:GetPos(),  path:GetClosestPosition(self:EyePos() + self.loco:GetGroundMotionVector() * scanDist), 0.05, Color(0,0,255,0) )
				local losColor  = Color(255,0,0)
				if self:IsLineOfSightClear( self:GetTarget():GetPos() + Vector(0,0,35) ) then
					losColor = Color(0,255,0)
				end
				debugoverlay.Line( self:EyePos(),  self:GetTarget():GetPos() + Vector(0,0,35), 0.03, losColor )
				local nav = navmesh.GetNearestNavArea( self:GetPos() )
				if IsValid(nav) and nav:GetClosestPointOnArea( self:GetPos() ):DistToSqr( self:GetPos() ) < 2500 then
					debugoverlay.Line( nav:GetCorner( 0 ),  nav:GetCorner( 1 ), 0.05, Color(255,0,0), true )
					debugoverlay.Line( nav:GetCorner( 0 ),  nav:GetCorner( 3 ), 0.05, Color(255,0,0), true )
					debugoverlay.Line( nav:GetCorner( 1 ),  nav:GetCorner( 2 ), 0.05, Color(255,0,0), true )
					debugoverlay.Line( nav:GetCorner( 2 ),  nav:GetCorner( 3 ), 0.05, Color(255,0,0), true )
					for _,v in pairs(nav:GetAdjacentAreas()) do
						debugoverlay.Line( v:GetCorner( 0 ),  v:GetCorner( 1 ), 0.05, Color(150,80,0,80), true )
						debugoverlay.Line( v:GetCorner( 0 ),  v:GetCorner( 3 ), 0.05, Color(150,80,0,80), true )
						debugoverlay.Line( v:GetCorner( 1 ),  v:GetCorner( 2 ), 0.05, Color(150,80,0,80), true )
						debugoverlay.Line( v:GetCorner( 2 ),  v:GetCorner( 3 ), 0.05, Color(150,80,0,80), true )
					end
				end
			end
			--print(self.loco:GetGroundMotionVector(), self:GetForward())
			local goal = path:GetCurrentGoal()

			--height triggered jumping
			if path:IsValid() and math.abs(self:GetPos().z - path:GetClosestPosition(self:EyePos() + self.loco:GetGroundMotionVector() * scanDist).z) > 52 and (goal and goal.type != 1) then
				self:Jump()
			end

			-- If we're stuck, then call the HandleStuck function and abandon
			if ( self.loco:IsStuck() ) then
				self:HandleStuck()
				return "stuck"
			end
			if self:IsMovingIntoObject() then -- This function handles barricade checks now. Moo Mark.
            	self:ApplyRandomPush(400)
        	end
			coroutine.yield()
		end
		return "ok"
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

    if self:GetWandering() then
        return false
    end

    if self.FrozenTime and CurTime() < self.FrozenTime then
        return false
    end

    if !self:IsOnGround() then
        return false
    end

    return true
end

if SERVER then
	function ENT:ChaseTargetPath( options )

		options = options or {}

		local path = Path( "Follow" )
		path:SetMinLookAheadDistance( options.lookahead or 1 )
		path:SetGoalTolerance( options.tolerance or 30 )

		--[[local targetPos = options.target:GetPos()
		--set the goal to the closet navmesh
		local goal = navmesh.GetNearestNavArea(targetPos, false, 100)
		goal = goal and goal:GetClosestPointOnArea(targetPos) or targetPos--]]

		-- Custom path computer, the same as default but not pathing through locked nav areas.
		path:Compute( self, options.target:GetPos(),  function( area, fromArea, ladder, elevator, length )
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
				end]]
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
						end]]
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

function ENT:GetLadderTop( ladder )
	return ladder:GetTopForwardArea() or ladder:GetTopBehindArea() or ladder:GetTopRightArea() or ladder:GetTopLeftArea()
end

function ENT:TargetInAttackRange()
	return self:TargetInRange( self:GetAttackRange() )
end

function ENT:TargetInRange( range )
	local target = self:GetTarget()
	if !IsValid(target) then return false end
	return self:GetRangeTo( target:GetPos() ) < range
end

function ENT:CheckForBarricade()
	--we try a line trace first since its more efficient
	local dataL = {}
	dataL.start = self:GetPos() + Vector( 0, 0, self:OBBCenter().z )
	dataL.endpos = self:GetPos() + Vector( 0, 0, self:OBBCenter().z ) + self.BarricadeCheckDir * 48
	dataL.filter = function( ent ) if ( ent:GetClass() == "breakable_entry" ) then return true end end
	dataL.ignoreworld = true
	local trL = util.TraceLine( dataL )

	--debugoverlay.Line(self:GetPos() + Vector( 0, 0, self:OBBCenter().z ), self:GetPos() + Vector( 0, 0, self:OBBCenter().z ) + self.BarricadeCheckDir * 32)
	--debugoverlay.Cross(self:GetPos() + Vector( 0, 0, self:OBBCenter().z ), 1)

	if IsValid( trL.Entity ) and trL.Entity:GetClass() == "breakable_entry" then
		return trL.Entity, trL.HitNormal
	end

	-- Perform a hull trace if line didnt hit just to make sure
	local dataH = {}
	dataH.start = self:GetPos()
	dataH.endpos = self:GetPos() + self.BarricadeCheckDir * 48
	dataH.filter = function( ent ) if ( ent:GetClass() == "breakable_entry" ) then return true end end
	dataH.mins = self:OBBMins() * 0.65
	dataH.maxs = self:OBBMaxs() * 0.65
	local trH = util.TraceHull(dataH )

	if IsValid( trH.Entity ) and trH.Entity:GetClass() == "breakable_entry" then
		return trH.Entity, trH.HitNormal
	end

	return nil

end

-- A standard attack you can use it or create something fancy yourself
function ENT:Attack( data )

	self:SetLastAttack(CurTime())

	--if self:Health() <= 0 then coroutine.yield() return end

	data = data or {}
	
	data.attackseq = data.attackseq
	if !data.attackseq then
		local curstage = self:GetActStage()
		local actstage = self.ActStages[curstage]
		if !actstage and curstage <= 0 then actstage = self.ActStages[1] end
		
		local attacktbl = actstage and actstage.attackanims or self.AttackSequences
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
	
	
	data.attacksound = data.attacksound
	if !data.attacksound then
		local actstage = self.ActStages[self:GetActStage()]
		local soundtbl = actstage and actstage.attacksounds
		data.attacksound = soundtbl and soundtbl[math.random(#soundtbl)] or Sound( "npc/vort/claw_swing1.wav" )
	end
	
	data.hitsound = data.hitsound
	if !data.hitsound then
		local actstage = self.ActStages[self:GetActStage()]
		local soundtbl = actstage and actstage.attackhitsounds or self.AttackHitSounds
		data.hitsound = soundtbl and soundtbl[math.random(#soundtbl)] or Sound( "npc/zombie/zombie_hit.wav" )
	end
	
	data.viewpunch = data.viewpunch or VectorRand():Angle() * 0.05
	data.dmglow = data.dmglow or self.DamageLow or 25
	data.dmghigh = data.dmghigh or self.DamageHigh or 45
	data.dmgtype = data.dmgtype or DMG_CLUB
	data.dmgforce = data.dmgforce or (self:GetTarget():GetPos() - self:GetPos()) * 7 + Vector( 0, 0, 16 )
	data.dmgforce.z = math.Clamp(data.dmgforce.z, 1, 16)
	

	self:SetAttacking( true )

	if self:GetTarget():IsPlayer() then
		for k,v in pairs(data.attackseq.dmgtimes) do
			self:TimedEvent( v, function()
				local soundName = self.AttackSounds[ math.random( #self.AttackSounds ) ] --Moo Mark
				self:EmitSound( soundName, 100, math.random(85, 105), 1, 2) 	-- I moved the attack sounds here so they sync up when the zombie can do damage during an attack.
				self:EmitSound( "npc/vort/claw_swing1.wav", 90, math.random(95, 105))
				if !self:GetStop() and self:IsValidTarget( self:GetTarget() ) and self:TargetInRange( self:GetAttackRange() + 10 ) then
					local dmgAmount = math.random( data.dmglow, data.dmghigh )
					local dmgInfo = DamageInfo()
						dmgInfo:SetAttacker( self )
						dmgInfo:SetDamage( dmgAmount )
						dmgInfo:SetDamageType( data.dmgtype )
						dmgInfo:SetDamageForce( data.dmgforce )
					self:GetTarget():TakeDamageInfo(dmgInfo)
					if !IsValid(self:GetTarget()) then return end
					self:GetTarget():EmitSound( data.hitsound, 100)
					self:GetTarget():ViewPunch( data.viewpunch )
					self:GetTarget():SetVelocity( data.dmgforce )

					local blood = ents.Create("env_blood")
					blood:SetKeyValue("targetname", "carlbloodfx")
					blood:SetKeyValue("parentname", "prop_ragdoll")
					blood:SetKeyValue("spawnflags", 8)
					blood:SetKeyValue("spraydir", math.random(500) .. " " .. math.random(500) .. " " .. math.random(500))
					blood:SetKeyValue("amount", dmgAmount * 5)
					blood:SetCollisionGroup( COLLISION_GROUP_WORLD )
					blood:SetPos( self:GetTarget():GetPos() + self:GetTarget():OBBCenter() + Vector( 0, 0, 10 ) )
					blood:Spawn()
					blood:Fire("EmitBlood")
					SafeRemoveEntityDelayed( blood, 2) -- Just to make sure everything gets cleaned
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
		if self:IsValidTarget( self:GetTarget() ) and self:TargetInRange( self:GetAttackRange() * 2  ) then
			self.loco:SetDesiredSpeed( self:GetRunSpeed() / 3 )
			self.loco:Approach( self:GetTarget():GetPos(), 10 )
			self.loco:FaceTowards( self:GetTarget():GetPos() )
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
	self.loco:SetDesiredSpeed( 450 )
	self.loco:SetAcceleration( 5000 )
	self:SetJumping( true )
	--self:SetSolidMask( MASK_NPCSOLID_BRUSHONLY )
	self.loco:Jump()
	--Boost them
	self:TimedEvent( 0.5, function() self.loco:SetVelocity( self:GetForward() * 5 ) end)
	
	local classname = self:GetClass()
	local bossent = string.find( classname:lower(), "boss" )
	if bossent then
		print("THOT DETECTED")
		local spawnpoint =  "nz_spawn_zombie_special"  or "nz_spawn_zombie_boss" 
		local spawnpoints = {}
		for k,v in pairs(ents.FindByClass(spawnpoint)) do -- Find and add all valid spawnpoints that are opened and not blocked
			if (v.link == nil or nzDoors:IsLinkOpened( v.link )) and v:IsSuitable() then
				table.insert(spawnpoints, v)
			end
		end
		local spawn = spawnpoints[math.random(#spawnpoints)] -- Pick a random one
		if IsValid(spawn) then -- If we this exists, spawn here
			self:SetPos( spawn:GetPos() )	
		end
	else
		timer.Simple(3, function()
			if self:IsValid() then
				if self:Health() > 0 and IsValid(nav) then
				else
					self:RespawnZombie()
				end
			end
		end)
	end
end

function ENT:Flames( state )
	if state then
		self.FlamesEnt = ents.Create("env_fire")
		if IsValid( self.FlamesEnt ) then
			
			self.FlamesEnt:SetParent(self)
			self.FlamesEnt:SetOwner(self)
			self.FlamesEnt:SetPos(self:GetPos() - Vector(0, 0, -50))
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

	local ex = ents.Create("env_explosion")
	if !IsValid(ex) then return end
	ex:SetPos(self:GetPos())
    ex:SetAngles(self:GetAngles())
    ex:Spawn()
    ex:SetKeyValue("imagnitude", "60") -- Deadly enough to nearly kill you... But not crazy enough to crash singleplayer games.
    ex:Fire("explode")

	if suicide then self:TimedEvent( 0, function() self:Kill() end ) end

end

function ENT:Kill(dmginfo, noprogress, noragdoll)
	local dmg = dmginfo or DamageInfo()
	if noragdoll then
		self:Fire("Kill",0,0)
	else
		self:BecomeRagdoll(dmg)
	end
	if !noprogress then
		nzEnemies:OnEnemyKilled(self, dmg:GetAttacker(), dmg, 0)
	end
	self:OnKilled(dmg)
	--self:TakeDamage( 10000, self, self )
end

function ENT:RespawnZombie()
	if SERVER then
		if self:GetSpawner() then
			self:GetSpawner():IncrementZombiesToSpawn()
		end

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

function ENT:TeleportToTarget( silent )

	if !self:HasTarget() then return false end

	--that's probably not smart, just like me. SORRY D:
	local locations = {
		Vector( 256, 0, 0),
		Vector( -256, 0, 0),
		Vector( 0, 256, 0),
		Vector( 0, -256, 0),
		Vector( 256, 256, 0),
		Vector( -256, -256, 0),
		Vector( 512, 0, 0),
		Vector( -512, 0, 0),
		Vector( 0, 512, 0),
		Vector( 0, -512, 0),
		Vector( 512, 512, 0),
		Vector( -512, -512, 0),
		Vector( 1024, 0, 0),
		Vector( -1024, 0, 0),
		Vector( 0, 1024, 0),
		Vector( 0, -1024, 0),
		Vector( 1024, 1024, 0),
		Vector( -1024, -1024, 0)
	}

	--resource friendly shuffle
	local rand = math.random
	local n = #locations

	while n > 2 do

		local k = rand(n) -- 1 <= k <= n

		locations[n], locations[k] = locations[k], locations[n]
		n = n - 1

	end

	for _, v in pairs( locations ) do

		local area = navmesh.GetNearestNavArea( self:GetTarget():GetPos() + v )

		if area then

			local location = area:GetRandomPoint() + Vector( 0, 0, 2 )

			local tr = util.TraceHull( {
				start = location,
				endpos = location,
				maxs = Vector( 16, 16, 40 ), --DOGE is small
				mins = Vector( -16, -16, 0 ),
			} )

			--debugoverlay.Box( location, Vector( -16, -16, 0 ), Vector( 16, 16, 40 ), 5, Color( 255, 0, 0 ) )

			if silent then
				if !tr.Hit then
					local inFOV = false
					for _, ply in pairs( player.GetAllPlayingAndAlive() ) do
						--can player see us or the teleport location
						if ply:Alive() and ply:IsLineOfSightClear( location ) or ply:IsLineOfSightClear( self ) then
							inFOV = true
						end
					end
					if !inFOV then
						self:SetPos( location )
						return true
					end
				end
			else
				self:SetPos( location )
			end
		end
	end

	return false

end

function ENT:BodyUpdate()

	local velocity = self:GetVelocity()
	local len2d = velocity:Length2D()
	local range = 10
	local curstage = self.ActStages[self:GetActStage()]
	local nextstage = self.ActStages[self:GetActStage() + 1]

	if self:GetActStage() <= 0 then
		if nextstage and len2d >= nextstage.minspeed then
			self:SetActStage( self:GetActStage() + 1 )
		end
	elseif (nextstage and len2d >= nextstage.minspeed + range) then
		self:SetActStage( self:GetActStage() + 1 )
	elseif not self.ActStages[self:GetActStage() - 1] and len2d < curstage.minspeed - 4 then -- Much smaller range to go back to idling
		self:SetActStage(0)
	end

	if self:IsJumping() or !self:IsOnGround() then
		self.CalcIdeal = ACT_JUMP
	end

	if not self:GetSpecialAnimation() and not self:IsAttacking() and not self:IsJumping() and not self:IsTimedOut() then
		if self.ActStages[self:GetActStage()] and not self.FrozenTime then
			self:BodyMoveXY()
		end
	end

	if self.FrozenTime then 
		if self.FrozenTime < CurTime() then
			self.FrozenTime = nil
			self:SetStop(false)
		end
		self:BodyMoveXY()
		if self:BO3IsCooking() and not self:GetSpecialAnimation() then
			print("Uh oh Mario, I'm about to fucking inflate lol.")
			self:SetSpecialAnimation(true)
			self:DoSpecialAnimation(self.MicrowaveSequences[math.random(#self.MicrowaveSequences)])
		end
		if self:BO3IsSkullStund() and not self:GetSpecialAnimation() then
			print("Uh oh Mario, I'm about to fucking explode lol.")
			self:SetSpecialAnimation(true)
			self:DoSpecialAnimation(self.DeathRaySequences[math.random(#self.DeathRaySequences)])
		end
	else
		self:FrameAdvance()
	end

end


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

function ENT:UpdateSequence()
	self:BodyUpdate()
	self:ResetMovementSequence()
end

function ENT:TriggerBarricadeJump( barricade, dir )
	if not self:GetSpecialAnimation() and (not self.NextBarricade or CurTime() > self.NextBarricade) then
		self:SetSpecialAnimation(true)
		self:SetBlockAttack(true) --Moo Mark BarricadeJump

		local id, dur, speed
		local actstage = self.ActStages[self:GetActStage()]
		local animtbl = actstage and actstage.barricadejumps or (self.ActStages[1] and self.ActStages[1].barricadejumps)
		
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
				--dur = targettbl.time or dur
			else
				id = self:SelectWeightedSequence(ACT_JUMP)
				dur = self:SequenceDuration(id)
				speed = 30
			end
		end
		

		--self:SetSolidMask(MASK_SOLID_BRUSHONLY)
		self:SolidMaskDuringEvent(MASK_SOLID_BRUSHONLY) -- Nocollide with props and other entities while we attempt to vault (Gets removed after event, or with CollideWhenPossible)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)

		self.loco:SetDesiredSpeed(speed)
		self:SetVelocity(self:GetForward() * speed)
		self:SetSequence(id)
		self:SetCycle(0)
		self:SetPlaybackRate(1)
		--PrintTable(self:GetSequenceInfo(id))
		self:TimedEvent(dur, function()
			self.NextBarricade = CurTime() + 2
			self:SetSpecialAnimation(false)
			self:SetBlockAttack(false)
			self.loco:SetAcceleration( self.Acceleration )
			self.loco:SetDesiredSpeed(self:GetRunSpeed())
			self:ResetMovementSequence()
			self:CollideWhenPossible() -- Remove the mask as soon as we can
		end)
		
		--debugoverlay.Cross(pos, 5, 5)
		-- This forces us to move straight through the barricade
		-- in the opposite direction of where we hit the trace from
		local pos = barricade:GetPos() - dir * 50 --Moo Mark
		self:MoveToPos(pos, { --Zombie will move through the barricade.
			lookahead = 1,
			tolerance = 10,
			draw = false,
			maxage = 3,
			repath = 1,
		})
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

function ENT:StartActivitySeq(act)
	if type(act) == "number" then
		self:StartActivity(act)
	else
		local id, dur = self:LookupSequence(act)
		--self:ResetSequenceInfo()
		--self:ResetSequence(id)
		self:SetSequence(id)
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

    --debugoverlay.Box(start, bounds.mins, bounds.maxs, 0, Color(255,0,0,55))

    if endpos then
        if !dont_adjust then
            endpos = endpos + self:OBBCenter() / 1.01
        end

        --debugoverlay.Box(endpos, bounds.mins, bounds.maxs, 0, Color(255,0,0,55))
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

--[[
					Moo Mark
	So I changed how barricades are checked...
	Since I changed how Repaths are done, they're
		done based on the targets distance.

	The old system didn't work well with this
	change at all. Since it originally hinged
	off of the repath that happened every one second.

	Well I finally got a good work around thats just
	as consistent as the old system. Only now, barricade
	checks are done when the zombie bumps into something.

	It checks if the object the zombie is stuck on is a
	entity. If that checks out, then it checks if its a
	barricade. We good? Cool, then the whole sequence of
	the zombie breaking the barricade plays out as normal.
]]

function ENT:IsMovingIntoObject() -- Added by Ethorbit as this can be helpful to know
    
    local bounds = self:GetCenterBounds() -- Moo Mark, Ethorbit you fucking god this function helped change the barricade check system!
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
        ["mask"] = MASK_NPCSOLID
    })

    local ent = tr.Entity
    	if IsValid(ent) and (ent:IsScripted() and ent:GetClass() == "breakable_entry") then
    		print("!!BarricadeDetected!!")
				self:TimeOut(0.5) -- Timeout, so Barricade can be detected.
				local CurrentDirection = self:GetForward() * 10
				self.BarricadeCheckDir = CurrentDirection or Vector(0,0,0)
				local barricade, dir = self:CheckForBarricade()
				if barricade then
					self:OnBarricadeBlocking( barricade, dir )
				end
    		return true
    	end
    if IsValid(ent) and (ent:IsPlayer() or ent:IsScripted()) then return false end

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
		self.EventMask = true
	else
		self:SetSolidMask(MASK_NPCSOLID)
		self.EventMask = nil
	end
end
end

function ENT:CollideWhenPossible() self.DoCollideWhenPossible = true end -- Make the zombie solid again as soon as there is space

-- Called when the zombie wants to idle. Play an animation here
	function ENT:PerformIdle()
		self:ResetSequence(self.IdleSequence)
	end

-- Returns to normal movement sequence. Call this in events where you want to MoveToPos after an animation
function ENT:ResetMovementSequence()
	if self:ZombieWaterLevel() >= 2 then
		self:ResetSequence(self.LowgMovementSequence) --Holy fucking shit this works?!
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
	return IsValid( ent ) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE
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

function ENT:IsTimedOut()
	return self:GetTimedOut()
end

function ENT:SetInvulnerable(bool)
	self.Invulnerable = bool
end

function ENT:IsInvulnerable()
	return self.Invulnerable
end

if CLIENT then
	local eyeglow =  Material( "nz_moo/sprites/moo_glow1" )
	local defaultColor = Color(255, 75, 0, 255)

	function ENT:Draw() -- This runs every frame...
		self:DrawModel() 
		if self.RedEyes and self:Alive() then -- bo3_zombie_eyeglow_white
			self:DrawEyeGlow() 
		end
	end

	function ENT:DrawEyeGlow()
		--print("Hello Mario")
		local eyeColor = !IsColor(nzMapping.Settings.zombieeyecolor) and defaultColor or nzMapping.Settings.zombieeyecolor
		local latt,ratt = self:LookupAttachment("lefteye"), self:LookupAttachment("righteye")

		if latt < 1 then latt = self:LookupAttachment("left_eye") end
		if ratt < 1 then ratt = self:LookupAttachment("right_eye") end
		
		local righteyepos
		local lefteyepos
		if latt > 0 and ratt > 0 then
			local leye = self:GetAttachment(latt)
			local reye = self:GetAttachment(ratt)
			lefteyepos = leye.Pos + leye.Ang:Forward()*0.5
			righteyepos = reye.Pos + reye.Ang:Forward()*0.5
		else
			local eyes = self:GetAttachment(self:LookupAttachment("eyes"))
			if eyes then
				local right = eyes.Ang:Right()
				local forward = eyes.Ang:Forward()
				lefteyepos = eyes.Pos + right * -1.5 + forward * 0.5
				righteyepos = eyes.Pos + forward * 1.5 + forward * 0.5
			end
		end

		if lefteyepos and righteyepos then
			render.SetMaterial(eyeglow)
			render.DrawSprite(lefteyepos, 4, 4, eyeColor)
			render.DrawSprite(righteyepos, 4, 4, eyeColor)
		end
	end
end
