AddCSLuaFile()

--debug cvars
CreateConVar( "nz_zombie_debug", "0", { FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_CHEAT } )

--[[
This Base is not really spawnable but it contains a lot of useful functions for it's children
--]]

--Boring
ENT.Base = "base_nextbot"
ENT.PrintName = "Zombie"
ENT.Category = "Brainz"
ENT.Author = "Lolle & Zet0r"
ENT.Spawnable = true
ENT.AdminOnly = true

-- Zombie Stuffz
-- fallbacks
ENT.DeathDropHeight = 700
ENT.StepHeight = 22 --Default is 18 but it makes things easier
ENT.JumpHeight = 70
ENT.AttackRange = 65
ENT.RunSpeed = 200
ENT.WalkSpeed = 100
ENT.Acceleration = 400
ENT.DamageLow = 35
ENT.DamageHigh = 45

ENT.TraversalCheckRange = 40 -- From Moo Base


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

AccessorFunc( ENT, "fTraversalCheckRange", "TraversalCheckRange", FORCE_NUMBER) -- From Moo Base

--sounds
AccessorFunc( ENT, "fNextMoanSound", "NextMoanSound", FORCE_NUMBER)

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

AccessorFunc( ENT, "iActStage", "ActStage", FORCE_NUMBER)

ENT.ActStages = {}

function ENT:SetupDataTables()
	-- If you want decapitation in you zombie and overwrote ENT:SetupDataTables() make sure to add self:NetworkVar("Bool", 0, "Decapitated") again.
	self:NetworkVar("Bool", 0, "Decapitated")
	if self.InitDataTables then self:InitDataTables() end
end

function ENT:Precache()

	--[[ From Moo Base(THIS IS HERE BECAUSE OTHER ENEMIES USING THIS BASE OVERRIDE THEIR INITIALIZE FUNC) ]]--
	self.Climbing = false
	self.NextClimb = 0
	self:SetTraversalCheckRange( self.TraversalCheckRange )
	--[[ From Moo Base(THIS IS HERE BECAUSE OTHER ENEMIES USING THIS BASE OVERRIDE THEIR INITIALIZE FUNC) ]]--

	for _,v in pairs(self.Models) do
		util.PrecacheModel( v )
	end

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
--Init
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
	self:SetTargetUnreachable(true)
	self:SetWandering(false)
	self:SetAttacking( false )
	self:SetLastAttack( CurTime() )
	self:SetAttackRange( self.AttackRange )

	if nzMapping.Settings.range then
		self:SetTargetCheckRange(nzMapping.Settings.range)
	else
		self:SetTargetCheckRange(2000)
	end	-- 0 for no distance restriction (infinite)

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

	if SERVER then
		self.loco:SetDeathDropHeight( self.DeathDropHeight )
		self.loco:SetDesiredSpeed( self:GetRunSpeed() )
		self.loco:SetAcceleration( self.Acceleration )
		self.loco:SetJumpHeight( self.JumpHeight )
		if GetConVar("nz_zombie_lagcompensated"):GetBool() then
			self:SetLagCompensated(true)
		end
		self.BarricadeJumpTries = 0
	end

	for i,v in ipairs(self:GetBodyGroups()) do
		self:SetBodygroup( i-1, math.random(0, self:GetBodygroupCount(i-1) - 1))
	end
	self:SetSkin( math.random(self:SkinCount()) - 1 )
	self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
	self.ZombieAlive = true

end

--init for class related attributes hooks etc...
function ENT:SpecialInit()
	--print("PLEASE Override the base class!")
end

function ENT:StatsInit()
	--print("PLEASE Override the base class!")
end

function ENT:Think()
	if SERVER then --think is shared since last update but all the stuff in here should be serverside
	 if (self:IsAllowedToMove()) then
            self.loco:SetVelocity(self:GetForward() * self:GetRunSpeed())
        end
		if !self:IsJumping() and !self:GetSpecialAnimation() and (self:GetSolidMask() == MASK_NPCSOLID_BRUSHONLY or self:GetSolidMask() == MASK_SOLID_BRUSHONLY) then
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

		if self.loco:IsUsingLadder() then
			--self:SetSolidMask(MASK_NPCSOLID_BRUSHONLY)
		end

		--this is a very costly operation so we only do it every second
		if self:GetLastTargetCheck() + 1 < CurTime() then
			self:SetTarget(self:GetPriorityTarget())
		end

		-- We don't want to say we're stuck if it's because we're attacking or timed out and !self:GetTimedOut() 
		if !self:GetAttacking() and self:GetLastPostionSave() + 4 < CurTime() then
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
	--nzRound:SpawnBoss(self.NZBossType)
	--self:Remove()
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

		--sounds
		self:SoundThink()

		if self:ZombieWaterLevel() == 3 then
			self:RespawnZombie()
		end

		self:DebugThink()

	end
	self:OnThink()
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

function ENT:SoundThink()
	if CurTime() > self:GetNextMoanSound() and !self:GetStop() then
		local soundtbl = self.ActStages[self:GetActStage()] and self.ActStages[self:GetActStage()].sounds or self.WalkSounds
		if soundtbl then
			local soundName = soundtbl[math.random(#soundtbl)]
			self:EmitSound( soundName, 80 )
			local nextSound = SoundDuration( soundName ) + math.random(0,4) + CurTime()
			self:SetNextMoanSound( nextSound )
		end
	end
end

function ENT:RunBehaviour()

	self:SpawnZombie()

	while (true) do
		if !self:GetStop() then
			self:SetTimedOut(false)
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
						self:TimeOut(1)
					end
				elseif pathResult == "timeout" then --asume pathing timedout, maybe we are stuck maybe we are blocked by barricades
					local barricade, dir = self:CheckForBarricade()
					if barricade then
						self:OnBarricadeBlocking( barricade, dir )
					else
					self:SetTargetUnreachable(true)
						self:OnPathTimeOut()
					end
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

function ENT:Stop()
	self:SetStop(true)
	self:SetTarget(nil)
end

--[[ From Moo Base ]]--
if SERVER then
	function ENT:TraversalCheck()
		if !self:GetSpecialAnimation() and !self:GetAttacking() and !self.Climbing and CurTime() > self.NextClimb then

			local anim = false
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
					anim = true
					finalpos = tr6.HitPos
				end
				elseif IsValid(tr5.Entity) then
					anim = true
					finalpos = tr5.HitPos
				elseif IsValid(tr4.Entity) then
					anim = true
					finalpos = tr4.HitPos
				elseif IsValid(tr3.Entity) then
					anim = true
					finalpos = tr3.HitPos
				elseif IsValid(tr2.Entity) then
					anim = true
					finalpos = tr2.HitPos
				elseif IsValid(tr1.Entity) then
					anim = true
					finalpos = tr1.HitPos
				elseif IsValid(tr0.Entity) then
					anim = true
					finalpos = tr0.HitPos
				end
			end
			if anim ~= false then
				if IsValid(self) then
					self:TimeOut(0.35)
					self.Climbing = true
					self:SetSpecialAnimation(true)
					self:SetPos(finalpos)
					local effectData = EffectData()
					effectData:SetOrigin( self:GetPos() + Vector(0, 0, 50)  )
					effectData:SetMagnitude( 1 )
					effectData:SetEntity(nil)
					util.Effect("panzer_spawn_tp", effectData) -- Express Portal to their destination.
					self:TimeOut(0.25)
					self:SetSpecialAnimation(false)
					self.Climbing = false
				end
			end
			self.NextClimb = CurTime() + 0.25
		end
	end
end
--[[ From Moo Base ]]--

--Draw correct eyes
local eyeglow =  Material( "nz/zlight" )
local defaultColor = Color(0, 255, 255, 255)

function ENT:Draw()
	local eyeColor = !IsColor(nzMapping.Settings.zombieeyecolor) and defaultColor or nzMapping.Settings.zombieeyecolor
	self:DrawModel()
	if self.RedEyes then
		--local eyes = self:GetAttachment(self:LookupAttachment("eyes")).Pos
		--local leftEye = eyes + self:GetRight() * -1.5 + self:GetForward() * 0.5
		--local rightEye = eyes + self:GetRight() * 1.5 + self:GetForward() * 0.5

		local lefteye = self:GetAttachment(self:LookupAttachment("lefteye"))
		local righteye = self:GetAttachment(self:LookupAttachment("righteye"))
		
		if !lefteye then lefteye = self:GetAttachment(self:LookupAttachment("left_eye")) end
		if !righteye then righteye = self:GetAttachment(self:LookupAttachment("right_eye")) end
		
		local righteyepos
		local lefteyepos
		
		if lefteye and righteye then
			lefteyepos = lefteye.Pos + self:GetForward() * 1.0
			righteyepos = righteye.Pos+ self:GetForward() * 1.0
		else
			local eyes = self:GetAttachment(self:LookupAttachment("eyes"))
			if eyes then
				lefteyepos = eyes.Pos + self:GetRight() * -1.5 + self:GetForward() * 1.0
				righteyepos = eyes.Pos + self:GetRight() * 1.5 + self:GetForward() * 1.0
			end
		end
		
		if lefteyepos and righteyepos then
			cam.Start3D(EyePos(),EyeAngles())
				render.SetMaterial(eyeglow)
				render.DrawSprite( lefteyepos, 4, 4, eyeColor)
				render.DrawSprite( righteyepos, 4, 4, eyeColor)
			cam.End3D()
		end
	end
	if GetConVar( "nz_zombie_debug" ):GetBool() then
		render.DrawWireframeBox(self:GetPos(), Angle(0,0,0), self:OBBMins(), self:OBBMaxs(), Color(255,0,0), true)
		render.DrawWireframeSphere(self:GetPos(), self:GetAttackRange(), 10, 10, Color(255,165,0), true)
	end
end

--[[
	Events
	You can easily override them.
	Todo: Add Hooks
--]]

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
	if !self:GetBlockAttack() then
		self:Attack()
	else
		self:TimeOut(2)
	end
end

function ENT:OnBarricadeBlocking( barricade, dir )
	if (IsValid(barricade) and barricade:GetClass() == "breakable_entry" ) then
		if barricade:GetNumPlanks() > 0 then

			--[[ Stuff from Moo's Base so old base enemies can still interact with barricades ]]--
			local planktopull = barricade:BeginPlankPull(self)
			local planknumber -- fucking piece of shit
			if planktopull then
				planknumber = planktopull:GetFlags()
			end

			if !IsValid(barricade.ZombieUsing) then
				barricade:HasZombie(self)
			end
					
			timer.Simple(0.3, function()
				if IsValid(planktopull) then
					barricade:RemovePlank(planktopull)
				end
			end)
			--[[ Stuff from Moo's Base so old base enemies can still interact with barricades ]]--

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

function ENT:TimeOut(time)
	self:SetTimedOut(true)
	if coroutine.running() then
		coroutine.wait(time)
	end
end

function ENT:OnPathTimeOut()

end

function ENT:OnNoTarget()
	-- Game over! Walk around randomly
	if nzRound:InState( ROUND_GO ) then
	self:SetWandering(true)
		self:StartActivity(ACT_WALK)
		self.loco:SetDesiredSpeed(40)
		self:MoveToPos(self:GetPos() + Vector(math.random(-512, 512), math.random(-512, 512), 0), {
			repath = 3,
			maxage = 5
		})
	else
		self:TimeOut(0.5)
		-- Start off by checking for a new target
		local newtarget = self:GetPriorityTarget()
		if self:IsValidTarget(newtarget) then
			self:SetTarget(newtarget)
		else
			-- If not visible to players respawn immediately
			if !self:IsInSight() then
				if self.NZBossType then
	nzRound:SpawnBoss(self.NZBossType)
	self:Remove()
	else
	self:RespawnZombie()
	end
			else
				self:UpdateSequence() -- Updates the sequence to be idle animation
				self:StartActivity(self.CalcIdeal) -- Starts the newly updated sequence
				self:TimeOut(3) -- Time out even longer if seen
			end
		end
	end
end

function ENT:OnContactWithTarget()

end

function ENT:OnLandOnGroundZombie()

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
	self:EmitSound( soundName, 90 )
end

function ENT:OnZombieDeath()
	self:BecomeRagdoll(dmgInfo)
end

function ENT:Alive()
	return self.ZombieAlive
end

function ENT:OnKilled(dmgInfo)
	if dmgInfo and self:Alive() then -- Only call once!
		self:OnZombieDeath(dmgInfo)
	end

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

	self.ZombieAlive = false

	hook.Call("OnZombieKilled", GAMEMODE, self, dmgInfo)

end

function ENT:OnRemove()

end

function ENT:OnStuck()
	--
	--self.loco:Approach( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 2000, 1000 )
	--print("Now I'm stuck", self)
end

--Target and pathfidning
function ENT:GetPriorityTarget()

	self:SetLastTargetCheck( CurTime() )

	--if you really would want something that atracts the zombies from everywhere you would need something like this
	local allEnts = ents.GetAll()
	--[[for _, ent in pairs(allEnts) do
		if ent:GetTargetPriority() == TARGET_PRIORITY_ALWAYS and self:IsValidTarget(ent) then
			return ent
		end
	end]]

	-- Disabled the above for for now since it just might be better to use that same loop for everything

	local bestTarget = nil
	local highestPriority = TARGET_PRIORITY_NONE
	local maxdistsqr = self:GetTargetCheckRange()^2
	local targetDist = maxdistsqr + 10

	--local possibleTargets = ents.FindInSphere( self:GetPos(), self:GetTargetCheckRange())

	for _, target in pairs(allEnts) do
		if self:IsValidTarget(target) and !self:IsIgnoredTarget(target) then

			if target:GetTargetPriority() == TARGET_PRIORITY_ALWAYS then return target end

			local dist = self:GetRangeSquaredTo( target:GetPos() )
			if maxdistsqr <= 0 or dist <= maxdistsqr then -- 0 distance is no distance restrictions
				local priority = target:GetTargetPriority()
				if target:GetTargetPriority() > highestPriority then
					highestPriority = priority
					bestTarget = target
					targetDist = dist
				elseif target:GetTargetPriority() == highestPriority then
					if targetDist > dist then
						highestPriority = priority
						bestTarget = target
						targetDist = dist
					end
				end
				--print(highestPriority, bestTarget, targetDist, maxdistsqr)
			end
		end
	end

	return bestTarget
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
		--Timeout the pathing so it will rerun the entire behaviour (break barricades etc)
		if ( path:GetAge() > options.maxage ) then
			local segment = path:FirstSegment()
			self.BarricadeCheckDir = segment and segment.forward or Vector(0,0,0)
			return "timeout"
		end
		
			local distToTarget = self:GetPos():Distance(self.Target:GetPos())
				if path:GetAge() > math.Clamp(distToTarget / 1000,3,10) then -- This is pulled from Ba2 for distance based repathing.
					return "timeout"
				end
				if path:IsValid() then
					if path:GetAge() > 1 and (distToTarget < 750) then -- We're closing in, let's start repathing sooner!
					self.BarricadeCheckDir = segment and segment.forward or Vector(0,0,0)
						return "timeout"
					elseif path:GetAge() > 0.35 and (distToTarget < 250) or path:GetAge() > 0.075 and (distToTarget < 250) and self.loco:GetVelocity():Length2D() >= 150 then -- We're nearing attack range! Don't stop now! self.loco:GetVelocity():Length2D() >= 110
						self.BarricadeCheckDir = segment and segment.forward or Vector(0,0,0)
						return "timeout"
					end
				end
				
		path:Update( self )	-- This function moves the bot along the path
		if options.draw or GetConVar( "nz_zombie_debug" ):GetBool() then
			path:Draw()
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
			--[[local nav = navmesh.GetNearestNavArea( self:GetPos() )
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
			end ]]--
		end
		--print(self.loco:GetGroundMotionVector(), self:GetForward())
		local goal = path:GetCurrentGoal()

		--height triggered jumping
		if path:IsValid() and math.abs(self:GetPos().z - path:GetClosestPosition(self:EyePos() + self.loco:GetGroundMotionVector() * scanDist).z) > 22 and (goal and goal.type != 1) then
			self:Jump()
		end
		--[[if path:IsValid() and goal.type == 4 then
			--self.loco:SetVelocity( Vector( 0, 0, 1000 ) )
			self:SetPos( path:GetClosestPosition( goal.ladder:GetTopForwardArea():GetCenter() ) )
			self:SetClimbing( true )
			coroutine.wait( 0.5 )
			self:SetSolidMask( MASK_NPCSOLID_BRUSHONLY )
			return "timeout"
			if self.loco:IsUsingLadder() then
				self.loco:SetVelocity( self.loco:GetVelocity() + Vector( 0, 0, 50 ) )
			end
		end --]]

		-- If we're stuck, then call the HandleStuck function and abandon
		if ( self.loco:IsStuck() ) then
			self:HandleStuck()
			return "stuck"
		end
		if self:IsMovingIntoObject() then
            self:ApplyRandomPush(400)
        end

        self:TraversalCheck() -- From Moo Base

		coroutine.yield()

	end

	return "ok"

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

function ENT:ChaseTargetPath( options )

	options = options or {}

	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 200 )
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
		local soundtbl = actstage and actstage.attacksounds or self.AttackSounds
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
	

	--self:EmitSound("npc/zombie_poison/pz_throw2.wav", 50, math.random(75, 125))

	self:SetAttacking( true )

	--self:TimedEvent(0.1, function()
	--local soundtbl2 =  self.AttackSounds
	--print(self.AttackSounds)
		--local attacksound = soundtbl[math.random(#soundtbl)] 
		--local attacksound = table.Random( soundtbl )
		--self:EmitSound( attacksound )
	--end)
	
	self:TimedEvent(0.0, function()
		self:EmitSound( data.attacksound )
	end)

	if self:GetTarget():IsPlayer() then
		for k,v in pairs(data.attackseq.dmgtimes) do
			self:TimedEvent( v, function()
				if !self:GetStop() and self:IsValidTarget( self:GetTarget() ) and self:TargetInRange( self:GetAttackRange() + 10 ) then
					local dmgAmount = math.random( data.dmglow, data.dmghigh )
					local dmgInfo = DamageInfo()
						dmgInfo:SetAttacker( self )
						dmgInfo:SetDamage( dmgAmount )
						dmgInfo:SetDamageType( data.dmgtype )
						dmgInfo:SetDamageForce( data.dmgforce )
					self:GetTarget():TakeDamageInfo(dmgInfo)
					if !IsValid(self:GetTarget()) then return end
					self:GetTarget():EmitSound( data.hitsound, 50, math.random( 80, 160 ) )
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
	ex:SetKeyValue( "iMagnitude", tostring( dmg ) )
	ex:SetOwner(self)
	ex:Spawn()
	ex:Fire("Explode",0,0)
	ex:EmitSound( "weapons/explode" .. math.random( 3, 5 ) .. ".wav" )
	ex:Fire("Kill",0,0)

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

--broken
function ENT:InFieldOfView( pos )

	local fov = math.rad( math.cos( 110 ) )
	local v = ( Vector( pos.x, pos.y, 0 ) - Vector( self:GetPos().x, self:GetPos().y, 0 ) ):GetNormalized()

	if self:GetAimVector():Dot( v ) > fov then
		local tr = util.TraceLine( {
			start = self:GetShootPos(),
			endpos = pos + Vector( 0, 0, 64),
			filter = self
		} )

		if !tr.Hit then return true end

	end

	return true

end

function ENT:BodyUpdate()

	self.CalcIdeal = ACT_IDLE

	local velocity = self:GetVelocity()

	local len2d = velocity:Length2D()

	local range = 10

	local curstage = self.ActStages[self:GetActStage()]
	local nextstage = self.ActStages[self:GetActStage() + 1]

	if self:GetActStage() <= 0 then -- We are currently idling, no range to start walking
		if nextstage and len2d >= nextstage.minspeed then -- We DO NOT apply the range here, he needs to walk at 5 speed!
			self:SetActStage( self:GetActStage() + 1 )
		end
		-- If there is no minspeed for the next stage, someone did something wrong and we just idle :/
	--elseif (curstage and len2d <= curstage.minspeed - range) then
		--self:SetActStage( self:GetActStage() - 1 )
	elseif (nextstage and len2d >= nextstage.minspeed + range) then
		self:SetActStage( self:GetActStage() + 1 )
	elseif !self.ActStages[self:GetActStage() - 1] and len2d < curstage.minspeed - 4 then -- Much smaller range to go back to idling
		self:SetActStage(0)
	end
	
	curstage = self.ActStages[self:GetActStage()]

	if curstage and curstage.act then
		local act = curstage.act
		if type(act) == "table" then -- A table of sequences
			local new = act[math.random(#act)]
			self.CalcIdeal = new
		elseif act then
			self.CalcIdeal = act
		end
	end

	if self:IsJumping() and self:WaterLevel() <= 0 then
		self.CalcIdeal = ACT_JUMP
	end

	if !self:GetSpecialAnimation() and !self:IsAttacking() then
		if self:GetActivity() != self.CalcIdeal and !self:GetStop() then self:StartActivitySeq(self.CalcIdeal) end

		if self.ActStages[self:GetActStage()] and !self.FrozenTime then
			self:BodyMoveXY()
		end
	end

	if self.FrozenTime then 
		if self.FrozenTime < CurTime() then
			self.FrozenTime = nil
			self:SetStop(false)
		end
		self:BodyMoveXY()
		--self:FrameAdvance()
	else
		self:FrameAdvance()
	end

end

function ENT:UpdateSequence()
	self:SetActStage(0)
	self:BodyUpdate()
	local actstage = self.ActStages[self:GetActStage()]
	local act = actstage and actstage.act
	if type(act) == "table" then -- A table of sequences
		local new = act[math.random(#act)]
		self:StartActivitySeq(new)
	elseif act then
		self:StartActivitySeq(act)
	else
		self:StartActivitySeq(self.CalcIdeal)
	end
end

function ENT:TriggerBarricadeJump( barricade, dir )
	if !self:GetSpecialAnimation() and (!self.NextBarricade or CurTime() > self.NextBarricade) then
		self:SetSpecialAnimation(true)
		--self:SetPassedBarricade(true)
		self:SetBlockAttack(true)
		
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
		
		self:SetSolidMask(MASK_SOLID_BRUSHONLY)
		self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)
		--self.loco:SetAcceleration( 5000 )
		self.loco:SetDesiredSpeed(speed)
		self:SetVelocity(self:GetForward() * speed)
		self:SetSequence(id)
		self:SetCycle(0)
		self:SetPlaybackRate(1)
		--self:BodyMoveXY()
		--PrintTable(self:GetSequenceInfo(id))
		self:TimedEvent(dur, function()
			self.NextBarricade = CurTime() + 2
			self:SetSpecialAnimation(false)
			self:SetBlockAttack(false)
			self.loco:SetAcceleration( self.Acceleration )
			self.loco:SetDesiredSpeed(self:GetRunSpeed())
			self:UpdateSequence()
		end)
		
		local pos = barricade:GetPos() - dir * 60
		
		--debugoverlay.Cross(pos, 5, 5)
		-- This forces us to move straight through the barricade
		-- in the opposite direction of where we hit the trace from
		self:MoveToPos(pos, {
			lookahead = 60,
			tolerance = 1,
			draw = false,
			maxage = 3,
			repath = 3,
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
        ["mask"] = MASK_NPCSOLID
    })

    -- debugoverlay.Box(startpos, mins, maxs, 0, Color(255,0,0) )
    -- debugoverlay.Box(endpos, mins, maxs, 0, Color(255,0,0, 50))

    local ent = tr.Entity
    if IsValid(ent) and (ent:IsPlayer() or ent:IsScripted()) then return false end --ent:GetClass() == "breakable_entry") then return false end

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
	if self.Target != target then
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
	if  not self:GetClass() == "nz_zombie_boss_brutus" then
	return IsValid( ent ) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
	else
	return IsValid( ent ) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE
	end
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
