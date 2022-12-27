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
ENT.Author = "Lolle, Zet0r, GhostlyMoo, Ethorbit, FlamingFox"
ENT.Spawnable = true

-- Zombie Stuffz
-- fallbacks
ENT.DeathDropHeight = 99999999999 -- Set to big number by Ethorbit because a drop height limit is retarded IMO
ENT.StepHeight = 22 --Default is 18 but it makes things easier
ENT.JumpHeight = 70
ENT.AttackRange = 60
ENT.RunSpeed = 200
ENT.WalkSpeed = 150
ENT.Acceleration = 400
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
AccessorFunc( ENT, "fLastHurt", "LastHurt", FORCE_NUMBER)
AccessorFunc( ENT, "fLastTargetChange", "LastTargetChange", FORCE_NUMBER)
AccessorFunc( ENT, "fTargetCheckRange", "TargetCheckRange", FORCE_NUMBER)

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
AccessorFunc( ENT, "bClimbing", "Climbing", FORCE_BOOL)
AccessorFunc( ENT, "bWandering", "Wandering", FORCE_BOOL)
AccessorFunc( ENT, "bStop", "Stop", FORCE_BOOL)
AccessorFunc( ENT, "bSpecialAnim", "SpecialAnimation", FORCE_BOOL)
AccessorFunc( ENT, "bBlockAttack", "BlockAttack", FORCE_BOOL)
AccessorFunc( ENT, "bCrawler", "Crawler", FORCE_BOOL)
AccessorFunc( ENT, "bTeleporting", "Teleporting", FORCE_BOOL)
AccessorFunc( ENT, "bShouldDie", "SpecialShouldDie", FORCE_BOOL)

AccessorFunc(ENT, "m_bTargetLocked", "TargetLocked", FORCE_BOOL) -- Stops the Zombie from retargetting and keeps this target while it is valid and targetable
AccessorFunc( ENT, "iActStage", "ActStage", FORCE_NUMBER)

ENT.ActStages = {}

if CLIENT then
	ENT.RedEyes = true
end

function ENT:SetupDataTables()
	-- If you want decapitation in your zombie and overwrote ENT:SetupDataTables() make sure to add self:NetworkVar("Bool", 0, "Decapitated") again.
	self:NetworkVar("Bool", 0, "Decapitated")
	self:NetworkVar("Bool", 1, "Alive")
	self:NetworkVar("Bool", 2, "MooSpecial")
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
		self:SetTargetUnreachable(true)
		self:SetWandering(false)
		self:SetAttacking( false )

		--[[Gib Related Shit]]--
		self:SetCrawler( false )
		self.LArmOff = nil
		self.RArmOff = nil
		self.LlegOff = nil
		self.RlegOff = nil
		--[[Gib Related Shit]]--

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
		self:SetSpecialShouldDie(false) -- Used for anims where the zombie reacts to something and they should die after the anim finishes. 

		self:SetNextRetarget(0)
		--self:SetNextRepath(0)
		self:SetFleeing(false)
		self:SetLastFlee(0)

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
			self:SetCollisionGroup(COLLISION_GROUP_NPC)
			self:SetAlive(true)

			local defaultColor = Color(255, 75, 0, 255)
			local eyeColor = !IsColor(nzMapping.Settings.zombieeyecolor) and defaultColor or nzMapping.Settings.zombieeyecolor
			local latt = self:LookupAttachment("lefteye")
			local ratt = self:LookupAttachment("righteye")

			local rand = math.Rand(0.1,0.2)

			if !self:GetMooSpecial() and math.random(2) == 1 then
				//self.spritetrail = util.SpriteTrail(self, latt, eyeColor, true, 5, 0, rand, 0.1, "effects/laser_citadel1.vmt")
				//self.spritetrail2 = util.SpriteTrail(self, ratt, eyeColor, true, 5, 0, rand, 0.1, "effects/laser_citadel1.vmt")
			end
		end
	end

	--init for class related attributes hooks etc...
	function ENT:SpecialInit()
		--print("PLEASE Override the base class!")
	end

	function ENT:StatsInit()
		--print("PLEASE Override the base class!")
	end

	function ENT:SpeedChanged()
		if self.SpeedBasedSequences then
			self:UpdateMovementSequences()
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
		if (self:IsAllowedToMove() and !self:GetCrawler() and self.loco:GetVelocity():Length2D() >= 130 and !self:GetAttacking()) then --Moo Mark
        	self.loco:SetVelocity(self:GetForward() * self:GetRunSpeed())
        end
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
					ignoreworld = true
				})

				local b = IsValid(tr.Entity)
				if not b then
					self:SetSolidMask(MASK_NPCSOLID)
					self:SetCollisionGroup(COLLISION_GROUP_NPC)
					self.DoCollideWhenPossible = nil
					self.NextCollideCheck = nil
				else
					self.NextCollideCheck = CurTime() + collidedelay
				end
			end
		end

		-- We don't want to say we're stuck if it's because we're attacking or timed out and !self:GetTimedOut() 
		if not self:GetAttacking() and self:GetLastPostionSave() + 4 < CurTime() then
			if self:GetPos():Distance( self:GetStuckAt() ) < 10 then
				self:SetStuckCounter( self:GetStuckCounter() + 1)
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
				if tr.Hit then
					self:SolidMaskDuringEvent(MASK_SOLID_BRUSHONLY) -- Moo Mark
					self:CollideWhenPossible() -- Lose collision with any entity and regain it as soon as theres space!
				end

				if self:GetStuckCounter() > 3 then
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
			end
			self:SetLastPostionSave( CurTime() )
			self:SetStuckAt( self:GetPos() )
		end

		self:DebugThink()
	end
		if not self.NextSound or self.NextSound < CurTime() and not self:GetAttacking() and self:Alive() then
			self:Sound() --Moo Mark
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
		debugoverlay.Text( self:GetPos() + spacing, "Speed: " .. tostring(self:GetRunSpeed()), FrameTime() * 2 )
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
			self:PlaySound(self.BehindSounds[math.random(#self.BehindSounds)], 100, math.random(85, 105), 1, 2) -- Play the behind sound, and a bit louder!
	elseif IsValid(self.Target) and self.Target:GetClass() == "nz_bo3_tac_monkeybomb" and !self.IsMooSpecial then
		self:PlaySound(self.MonkeySounds[math.random(#self.MonkeySounds)], 100, math.random(85, 105), 1, 2)
	elseif self:GetCrawler() then
		self:PlaySound(self.CrawlerSounds[math.random(#self.CrawlerSounds)],85, math.random(85, 105), 1, 2)
	elseif self.PassiveSounds then
		self:PlaySound(self.PassiveSounds[math.random(#self.PassiveSounds)],92, math.random(85, 105), 1, 2)
	else
		-- We still delay by max sound delay even if there was no sound to play
		self.NextSound = CurTime() + self.SoundDelayMax
	end
end

if SERVER then
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
					local path = self:ChaseTarget()
					if path == "failed" then
						self:SetTargetUnreachable(true)
					end
					if path == "ok" then
						if self:TargetInAttackRange() then
							self:OnTargetInAttackRange()
						else
							self:TimeOut(0.5)
						end
					elseif path == "timeout" then --asume pathing timedout, maybe we are stuck maybe we are blocked by barricades
						self:SetTargetUnreachable(true)
						self:OnPathTimeOut()
					else
						self:TimeOut(2)
					end
				end
			else
				self:TimeOut(2)
			end
			if not self:GetSpecialAnimation() and not self.IsMooSpecial then
				if self:GetCrawler() then
					-- Crawler based stuff goes here later.
				else
					if self.ThundergunAnim then
						self.ThundergunAnim = false
						self:SetTarget(nil)

						print("Uh oh Luigi, I'm about to commit insurance fraud lol.")
						self:DoSpecialAnimation(self.SlipGunSequences[math.random(#self.SlipGunSequences)])
					end
					if self.BO3IsPulledIn and self:BO3IsPulledIn() then
						print("Uh oh Mario, I'm getting pulled to my doom lol.")
						self:SetSpecialShouldDie(true)
						self:DoSpecialAnimation(self.IdGunSequences[math.random(#self.IdGunSequences)])
					end
					if self.BO3IsSkullStund and self:BO3IsSkullStund() then
						print("Uh oh Mario, I'm ASCENDING lol.")
						self:DoSpecialAnimation(self.DeathRaySequences[math.random(#self.DeathRaySequences)])
					end
					if self.BO3IsMystified and self:BO3IsMystified() then
						print("Uh oh Mario, I'm mentally deficient lol.")
						self:DoSpecialAnimation(self.UnawareSequences[math.random(#self.UnawareSequences)])
					end
					if self.BO3IsCooking and self:BO3IsCooking() then
						print("Uh oh Mario, I'm about to fucking inflate lol.")
						self:SetSpecialShouldDie(true)
						self:DoSpecialAnimation(self.MicrowaveSequences[math.random(#self.MicrowaveSequences)])
					end
					if self.BO4IsFrozen and self:BO4IsFrozen() then
						print("Uh oh Mario, I'm frozen lol.")
						self:SetSpecialShouldDie(true)
						self:DoSpecialAnimation(self.FreezeSequences[math.random(#self.FreezeSequences)])
					end
					if self.BO4IsToxic and self:BO4IsToxic() then
						self:FleeTarget(3)
					end
				end
			end
		end
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
					--barricade:EmitSound("physics/wood/wood_plank_break" .. math.random(1, 4) .. ".wav", 100, math.random(90, 130))
					barricade:EmitSound("nz_moo/barricade/snap/board_snap_zhd_0" .. math.random(1, 6) .. ".mp3", 100, math.random(90, 130))
					barricade:RemovePlank()
				end)

				self:SetAngles(Angle(0,(barricade:GetPos()-self:GetPos()):Angle()[2],0))
				local seq, dur

				local attacktbl = self.ActStages[1] and self.ActStages[1].attackanims or self.AttackSequences
				local crawlattacktbl = self.ActStages[6] and self.ActStages[6].attackanims or self.CrawlAttackSequences
				local taunttbl = self.TauntSequences
				local target = type(attacktbl) == "table" and attacktbl[math.random(#attacktbl)] or attacktbl
				local crawltarget = type(crawlattacktbl) == "table" and crawlattacktbl[math.random(#crawlattacktbl)] or crawlattacktbl
				local taunt = type(taunttbl) == "table" and taunttbl[math.random(#taunttbl)] or taunttbl
			
				if self:GetCrawler() then
					if type(crawltarget) == "table" then
						seq, dur = self:LookupSequenceAct(crawltarget.seq)
					elseif crawltarget then -- It is a string or ACT
						seq, dur = self:LookupSequenceAct(crawltarget)
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
			
				local tauntchance = math.random(1,100)
				self:SetAttacking(true)
				self:PlaySequenceAndWait(seq, 1)
				self:SetLastAttack(CurTime())
					if self.IsMooZombie then -- Moo Mark
						if tauntchance <= 25 and !self:GetCrawler() and !self.IsMooSpecial then --The higher the number, the more likely a zombie will taunt.
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
	self:TimeOut(0.1)
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
			self:TimeOut(3)
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
	self.loco:SetDesiredSpeed(self:GetRunSpeed())
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

function ENT:Alive() return self:GetAlive() end

if SERVER then
	ENT.DeathRagdollForce = 9500
	ENT.CrawlerForce = 7500

	function ENT:OnInjured( dmgInfo )
		local soundName = self.PainSounds[ math.random( #self.PainSounds ) ]
		self:EmitSound( soundName, 97, math.random(95, 100))
		if dmgInfo:GetDamageType() == DMG_SLASH then -- Funny squishy knife slash sound
			self:EmitSound("nz/effects/knife/knife_flesh_"..math.random(0,4)..".wav",100,math.random(95, 105))
		end
	end

	function ENT:OnKilled(dmgInfo)
		if dmgInfo and self:Alive() then -- Only call once!
			if IsValid(self.spritetrail) and IsValid(self.spritetrail2) then
				SafeRemoveEntity(self.spritetrail)
				SafeRemoveEntity(self.spritetrail2)
			end
			local headbone = self:LookupBone("ValveBiped.Bip01_Head1")
			if !headbone then headbone = self:LookupBone("j_head") end
			local hitgroup = util.QuickTrace( dmgInfo:GetDamagePosition(), dmgInfo:GetDamagePosition() ).HitGroup

			if hitgroup == HITGROUP_HEAD or nzPowerUps:IsPowerupActive("insta") and !self.IsMooSpecial then
  				self:SetDecapitated(true)
				if headbone then
    				dmgInfo:SetDamagePosition(self:GetBonePosition(headbone))
					self:ManipulateBoneScale(headbone, Vector(0.00001,0.00001,0.00001))
					--self:EmitSound("nz_moo/zombies/gibs/head/head_explosion_0"..math.random(4)..".mp3",100, math.random(95,105))
					--self:EmitSound("nz_moo/zombies/gibs/death_nohead/death_nohead_0"..math.random(2)..".mp3",85, math.random(95,105))
					--if IsValid(self) then ParticleEffectAttach("ins_blood_impact_headshot", 4, self, 10) end
				end
			end

			self:SetAlive(false)
			self.ZombieAlive = false
			hook.Call("OnZombieKilled", GAMEMODE, self, dmgInfo)
			self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
			self:PerformDeath(dmgInfo)
		end
	end

	function ENT:PerformDeath(dmgInfo)
		if dmgInfo:GetDamageType() == DMG_REMOVENORAGDOLL then self:Remove(dmgInfo) end
		if dmgInfo:GetDamageType() == DMG_MISSILEDEFENSE then
			self:BecomeRagdoll(dmgInfo) -- Only Thundergun Ragdolls constantly.
		end
		if self.DeathRagdollForce == 0 or self.DeathRagdollForce <= dmgInfo:GetDamageForce():Length() and dmgInfo:GetDamageType() ~= DMG_REMOVENORAGDOLL or self:GetSpecialAnimation() then
			self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
			ParticleEffectAttach("bo3_annihilator_blood", 4, self, 9)
			self:Remove(dmgInfo) -- Fuck you bitch, BEGONE!!!
		else
			if self:GetCrawler() then
				if dmgInfo:GetDamageType() == DMG_SHOCK then
					self:PlaySound(self.ElecSounds[math.random(#self.ElecSounds)], 90, math.random(85, 105), 1, 2)
					self:DoDeathAnimation(self.CrawlTeslaDeathSequences[math.random(#self.CrawlTeslaDeathSequences)])
				else
					self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
					self:DoDeathAnimation(self.CrawlDeathSequences[math.random(#self.CrawlDeathSequences)])
				end
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
	end

	function ENT:DoDeathAnimation(seq)
		self.BehaveThread = coroutine.create(function()
			self:PlaySequenceAndWait(seq)
			self:BecomeRagdoll(DamageInfo()) -- Only Ragdoll after death anims.
		end)
	end

	function ENT:DoSpecialAnimation(seq)
		self:SetSpecialAnimation(true)
		self:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
		self:PlaySequenceAndWait(seq)
		if not self:GetSpecialShouldDie() and IsValid(self) then -- COMMON NZ VALID W
			self:SetCollisionGroup(COLLISION_GROUP_NPC)
			self:SetSpecialAnimation(false) -- Stops them from going back to idle.
		end
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
					if path:GetAge() > 1 and (distToTarget < 750) then -- We're closing in, let's start repathing sooner!
						return "timeout"
					elseif path:GetAge() > 0.35 and (distToTarget < 250) or path:GetAge() > 0.075 and (distToTarget < 250) and self.loco:GetVelocity():Length2D() >= 150 then -- We're nearing attack range! Don't stop now! self.loco:GetVelocity():Length2D() >= 110
						return "timeout"
					end
				end
			if options.draw or GetConVar( "nz_zombie_debug" ):GetBool() then
				path:Draw()
			end

			if self:HasTarget() and !self:GetAttacking() and self:IsAllowedToMove() and self:IsOnGround() then
				self:ResetMovementSequence() -- This is the main point that starts the movement anim. Moo Mark
			end
			
			local scanDist
			--this will probaly need adjustments to fit the zombies speed
			if self:GetVelocity():Length2D() > 150 then scanDist = 30 else scanDist = 20 end
			--debug section
			if GetConVar( "nz_zombie_debug" ):GetBool() then
				debugoverlay.Line( self:GetPos(), path:GetClosestPosition(self:EyePos() + self.loco:GetGroundMotionVector() * scanDist), 0.05, Color(0,0,255,0) )
				local losColor  = Color(255,0,0)
				if self:IsLineOfSightClear( self:GetTarget():GetPos() + Vector(0,0,35) ) then
					losColor = Color(0,255,0)
				end
			end
			local goal = path:GetCurrentGoal()

			if !goal then
				local jumpHeight = math.abs(self:GetTarget():GetPos()[3] - self:GetPos()[3]) * 2
				if jumpHeight > 100 then -- While we do want them to jump to make exploiting on props harder, we DON'T want them to jump if the player is not high enough away
					local should_
					= true --math.random(3) == 1 -- We mainly want to jump at cheaters, but let's also hit them randomly so they shit their pants
					if jumpHeight > 150 then -- Hitting them from here won't do shit, just jump.
						should_attack = false
					end

					if should_attack then -- The reason we force attack instead of letting them auto attack when close enough during jump, is because they can't jump when a player is likely on top of them
						self:Attack()
						print("I'm gonna beat that ass")
					else
						self:JumpToTargetHeight(jumpHeight)
					end
				end
			end

			--height triggered jumping
			if path:IsValid() and math.abs(self:GetPos().z - path:GetClosestPosition(self:EyePos() + self.loco:GetGroundMotionVector() * scanDist).z) > 52 and (goal and goal.type != 1) then
				self:Jump()
			end

			-- If we're stuck, then call the HandleStuck function and abandon
			if ( self.loco:IsStuck() ) then
				self:HandleStuck()
				return "stuck"
			end
			if self:IsMovingIntoObject() then 
            	self:ApplyRandomPush(100)
        	end
			coroutine.yield()
		end
		return "ok"
	end
end

function ENT:JumpToTargetHeight(height) -- Created by Ethorbit, mainly to help combat cheaters
	local jumpHeight = height or math.abs(self:GetTarget():GetPos()[3] - self:GetPos()[3]) * 1.3

	self.loco:SetJumpHeight(jumpHeight)
	self:Jump()
	self.loco:SetJumpHeight(self.JumpHeight)
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

if SERVER then
	function ENT:ChaseTargetPath( options )

		local path = Path( "Follow" )
		path:SetMinLookAheadDistance( 1 )
		path:SetGoalTolerance( 30 )

		-- Custom path computer, the same as default but not pathing through locked nav areas.
		path:Compute( self, self:GetTarget():GetPos(),  function( area, fromArea, length )
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
				local cost = dist + fromArea:GetCostSoFar()
				--check height change
				local deltaZ = fromArea:ComputeAdjacentConnectionHeightChange( area )
				if ( deltaZ >= self.loco:GetStepHeight() ) then
					-- use player default max jump height even thouh teh zombie will jump a bit higher
					if ( deltaZ >= 64 ) then
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

	data = data or {}
	
	data.attackseq = data.attackseq
	if !data.attackseq then
		local curstage = self:GetActStage()
		local actstage = self.ActStages[curstage]
		if !self:GetCrawler() and !actstage and curstage <= 0 then actstage = self.ActStages[1] end
		--if self:GetCrawler() then self.CrawlAttackSequences end
		
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
	
	self:SetAttacking( true )

	if self:GetTarget():IsPlayer() then
		for k,v in pairs(data.attackseq.dmgtimes) do
			self:TimedEvent( v, function()
				if self.AttackSounds then self:PlaySound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2) end
				self:EmitSound( "npc/vort/claw_swing1.wav", 90, math.random(95, 105))
				if !self:GetStop() and self:IsValidTarget( self:GetTarget() ) and self:TargetInRange( self:GetAttackRange() + 10 ) then
					local dmgInfo = DamageInfo()
					dmgInfo:SetAttacker( self )
					dmgInfo:SetDamage( 45 )
					dmgInfo:SetDamageType( DMG_SLASH )
					dmgInfo:SetDamageForce( (self:GetTarget():GetPos() - self:GetPos()) * 7 + Vector( 0, 0, 16 ) )
					self:GetTarget():TakeDamageInfo(dmgInfo)
					if !IsValid(self:GetTarget()) then return end
					self:GetTarget():EmitSound( "nz_moo/zombies/plr_impact/_zhd/evt_zombie_hit_player_0"..math.random(0,5)..".mp3", SNDLVL_TALKING, math.random(95,105))
					self:GetTarget():ViewPunch( VectorRand():Angle() * 0.01 )
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
				if !self:GetCrawler() then
					self.loco:SetDesiredSpeed( self:GetRunSpeed() )
				end
			end
			return
		end
		if self:IsValidTarget( self:GetTarget() ) then
			if not self:GetCrawler() then
				self.loco:SetDesiredSpeed( self:GetRunSpeed() )
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
	self.loco:SetDesiredSpeed( 450 )
	self.loco:SetAcceleration( 5000 )
	self:SetJumping( true )
	self.loco:Jump()
	--Boost them
	self:TimedEvent( 0.5, function() self.loco:SetVelocity( self:GetForward() * 5 ) end)
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
		ParticleEffectAttach("bo3_annihilator_blood", 4, self, 9)
		self:Remove(dmg)
	end
	if !noprogress then
		nzEnemies:OnEnemyKilled(self, dmg:GetAttacker(), dmg, 0)
	end
	self:OnKilled(dmg)
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

function ENT:BodyUpdate()

	local velocity = self:GetVelocity()
	local len2d = velocity:Length2D()
	local range = 10
	local curstage = self.ActStages[self:GetActStage()]
	local nextstage = self.ActStages[self:GetActStage() + 1]

	if self:GetCrawler() then
		--print("bruh bitch stole my mf chicken strips!")
		self:SetActStage(6)
	else
		if self:GetActStage() <= 0 then
			if nextstage and len2d >= nextstage.minspeed then
				self:SetActStage( self:GetActStage() + 1 )
			end
		elseif (nextstage and len2d >= nextstage.minspeed + range) then
			self:SetActStage( self:GetActStage() + 1 )
		elseif not self.ActStages[self:GetActStage() - 1] and len2d < curstage.minspeed - 4 then -- Much smaller range to go back to idling
			self:SetActStage(0)
		end
	end

	if self:IsJumping() or !self:IsOnGround() then
		if self:GetCrawler() then
			self.CalcIdeal = ACT_HOP
		else
			self.CalcIdeal = ACT_JUMP
		end
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
	else
		self:FrameAdvance()
	end

end

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
	local hull = Vector(26,26,24) -- Moo Mark 10/22/22: Another new barricade check system... This time using traces.
	local trace = util.TraceLine({ -- Moo Mark 11/14/22: This is the main check system thats used on its own.
    	start = self:EyePos(),
    	endpos = self:EyePos() + (self:GetForward() * 36),
    	filter = {self},
    	mask = MASK_NPCSOLID,
	})
	if trace.Hit then
		for k,v in pairs(ents.FindAlongRay(self:EyePos(), self:GetForward(), -hull, hull)) do
			if IsValid(v) and v:IsValidZombie() then continue end -- Stop the Zombies from using the force to break barricades.
			if IsValid(v) and v:GetClass() == "breakable_entry" then
				--print("Leh Big Funny")
				--self:TimeOut(0.5) -- Timeout, so Barricade can be detected.
				local CurrentDirection = self:GetForward() * 10
				self.BarricadeCheckDir = CurrentDirection or Vector(0,0,0)
				local barricade, dir = self:CheckForBarricade()
				if barricade then
					self:OnBarricadeBlocking( barricade, dir )
				end
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
	elseif self:ZombieWaterLevel() >= 2 and !self.IsMooSpecial then
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
	local eyeglow =  Material("nz_moo/sprites/moo_glow1")
	local defaultColor = Color(255, 75, 0, 255)

	function ENT:Draw() //Runs every frame
		self:DrawModel()
		if self.RedEyes and self:Alive() and !self:GetMooSpecial() then
			self:DrawEyeGlow() 
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

		local righteyepos = leye.Pos + leye.Ang:Forward()*0.5
		local lefteyepos = reye.Pos + reye.Ang:Forward()*0.5

		if lefteyepos and righteyepos then
			render.SetMaterial(eyeglow)
			render.DrawSprite(lefteyepos, 4, 4, eyeColor)
			render.DrawSprite(righteyepos, 4, 4, eyeColor)
		end
	end
end


-- God I love Roxanne, she's such a bad bitch tho!!! Chica is cool too :)