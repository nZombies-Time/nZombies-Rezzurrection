AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Astronaut(Assdonut) or THE CYCLOPS"
ENT.Category = "Brainz"
ENT.Author = "Laby and GhostlyMoo"

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = false
ENT.IsMooSpecial = true

ENT.AttackRange = 72

ENT.TraversalCheckRange = 40

ENT.Models = {
	{Model = "models/moo/_codz_ports/t7/moon/moo_codz_t7_moon_assdonut.mdl", Skin = 0, Bodygroups = {0,0}},
}

ENT.BarricadeTearSequences = {
	"nz_legacy_door_tear_high",
	"nz_legacy_door_tear_low",
	"nz_legacy_door_tear_left",
	"nz_legacy_door_tear_right",
}

local AttackSequences = {
	{seq = "nz_astro_headbutt"},
}

local JumpSequences = {
	{seq = "nz_barricade_trav_walk_1", speed = 25, time = 3},
	{seq = "nz_barricade_trav_walk_2", speed = 25, time = 3},
	{seq = "nz_barricade_trav_walk_3", speed = 15, time = 2.5},
	{seq = "nz_barricade_trav_walk_4", speed = 15, time = 2.5},
}

local walksounds = {
	Sound("nz_moo/zombies/vox/_astro/amb_vox/amb_00.mp3"),
	Sound("nz_moo/zombies/vox/_astro/amb_vox/amb_01.mp3"),
	Sound("nz_moo/zombies/vox/_astro/amb_vox/amb_02.mp3"),
	Sound("nz_moo/zombies/vox/_astro/amb_vox/amb_03.mp3"),
}

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			MovementSequence = {
				"nz_astro_walk_v1",
				"nz_astro_walk_v2",
			},
			BlackholeMovementSequence = {
				"nz_blackhole_1",
				"nz_blackhole_2",
				"nz_blackhole_3",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 70, Sequences = {
		{
			MovementSequence = {
				"nz_supersprint_lowg"
			},
			BlackholeMovementSequence = {
				"nz_blackhole_1",
				"nz_blackhole_2",
				"nz_blackhole_3",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}}
}

ENT.DeathSounds = {
	"nz_moo/zombies/vox/mute_00.wav"
}

ENT.BehindSoundDistance = 0 -- When the zombie is within 200 units of a player, play these sounds instead
ENT.BehindSounds = {
	Sound("nz_moo/zombies/vox/mute_00.wav"),
}

function ENT:StatsInitialize()
	if SERVER then
		local data = nzRound:GetBossData(self.NZBossType)
		local count = #player.GetAllPlaying()

		if nzRound:InState( ROUND_CREATE ) then
			self:SetHealth(500)
			self:SetMaxHealth(500)
		else
			self:SetHealth(nzRound:GetNumber() * data.scale + (data.health * count))
			self:SetMaxHealth(nzRound:GetNumber() * data.scale + (data.health * count))
		end
		self:SetRunSpeed(35)

		grabbing = false
		gobyebye = false
		trexarms = 0
		malding = false
	end
end

function ENT:SpecialInit()
	if CLIENT then
	end
end

function ENT:OnSpawn()
	self:EmitSound("nz_moo/zombies/vox/_astro/spawn_flux.mp3", 511, math.random(95, 105))
	self:EmitSound("nz_moo/zombies/vox/_astro/breath.wav", 75, math.random(95, 105), 1, 3)
	ParticleEffect("bo3_astronaut_pulse",self:LocalToWorld(Vector(0,0,50)),Angle(0,0,0),nil)
end

function ENT:PerformDeath(dmgInfo)
	self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
	self:StopSound("nz_moo/zombies/vox/_astro/breath.wav")
	self:Explode(0)
	self:Remove(dmgInfo)
end

function ENT:OnRemove()
	self:StopSound("nz_moo/zombies/vox/_astro/breath.wav")
end

function ENT:IsValidTarget( ent )
	if !ent then return false end
	return IsValid( ent ) and ent:GetTargetPriority() != TARGET_PRIORITY_NONE and ent:GetTargetPriority() != TARGET_PRIORITY_SPECIAL
	-- Won't go for special targets (Monkeys), but still MAX, ALWAYS and so on
end

function ENT:OnThink()
	if self:TargetInAttackRange() then
		if SERVER then
		end
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
							--print("Give me your assets.")
							local livecripplereaction = ents.Create("astro_slow")
							livecripplereaction:SetPos(self:GetPos())
							livecripplereaction:SetAngles(Angle(0,0,0))
							livecripplereaction:Spawn()

							self:OnTargetInAttackRange()
							if self:TargetInAttackRange() then
								gobyebye = true
								if gobyebye then
									gobyebye = false
									--print("You go to brazil now.")
									if malding then
										for k,v in pairs(ents.FindInSphere(self:GetPos(),100)) do
											if v:IsValidZombie() and v.IsMooSpecial or v.NZBossType then continue end
											self:EmitSound("weapons/tfa_bo3/gersch/gersh_teleport.wav",511, 70)
											local d = DamageInfo()
											d:SetDamage( v:Health() - 50 )
											d:SetAttacker( self )
											d:SetDamageType( DMG_VEHICLE ) 
											v:TakeDamageInfo( d )
										end
									else
										for k,v in pairs(ents.FindInSphere(self:GetPos(),self:GetAttackRange())) do
											if v:IsValidZombie() and v.IsMooSpecial or v.NZBossType then continue end
											self:EmitSound("weapons/tfa_bo3/gersch/gersh_teleport.wav",511)
											local d = DamageInfo()
											d:SetDamage( v:Health() - 35 )
											d:SetAttacker( self )
											d:SetDamageType( DMG_VEHICLE ) 
											v:TakeDamageInfo( d )
										end
									end
									if self:GetTarget():IsPlayer() then
										self:GetTarget():ViewPunch( VectorRand():Angle() * 0.1 )
									end
									if malding then
										--print("He's no longer malding.")
										self:SetRunSpeed(35)
										self:SpeedChanged()
										malding = false
										trexarms = 0
									end
								end
							else
								self:PlaySequenceAndWait("nz_astro_headbutt_release")
								trexarms = trexarms + 1
								--print(trexarms)
								if trexarms >= 3 and not malding then -- If you somehow manage to make him mald unintentionally... You're bad at video games.
									print("Look what you've done Yoshi... You've angered the Scuba Diver.")
									--print("F L I N T L O C K W O O D ! ! !")
									self:SetRunSpeed(70)
									self:SpeedChanged()
									malding = true
								end
							end
						else
							self:TimeOut(0.1)
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
			if not self.NextSound or self.NextSound < CurTime() and not self:GetAttacking() and self:Alive() then
				self:Sound() -- Moo Mark 12/7/22: Moved this out of the THINK function since I thought it was a little stupid.
			end
		end
	end
end

function ENT:Explode(dmg, suicide)
    for k, v in pairs(ents.FindInSphere(self:GetPos(), 250)) do
        if not v:IsWorld() and v:IsSolid() then
            v:SetVelocity(((v:GetPos() - self:GetPos()):GetNormalized()*175) + v:GetUp()*225)
            
            if v:IsValidZombie() then
                local damage = DamageInfo()
                damage:SetAttacker(self)
                damage:SetDamageType(DMG_MISSILEDEFENSE)
                damage:SetDamage(v:Health() + 666)
                damage:SetDamageForce(v:GetUp()*22000 + (v:GetPos() - self:GetPos()):GetNormalized() * 10000)
                damage:SetDamagePosition(v:EyePos())
                v:TakeDamageInfo(damage)
            end

            if v:IsPlayer() then
            	v:SetGroundEntity(nil)
                v:ViewPunch(Angle(-25,math.random(-10, 10),0))
            end
        end
    end
	ParticleEffect("bo3_astronaut_pulse",self:LocalToWorld(Vector(0,0,50)),Angle(0,0,0),nil)
	self:EmitSound("nz_moo/zombies/vox/_astro/death/astro_pop.mp3", 511, math.random(95, 105))
	self:EmitSound("nz_moo/zombies/vox/_astro/death/astro_flux.mp3", 511, math.random(95, 105))
    if suicide then self:TakeDamage(self:Health() + 666, self, self) end
end

function ENT:OnBarricadeBlocking( barricade, dir )
		if not self:GetSpecialAnimation() then
			if (IsValid(barricade) and barricade:GetClass() == "breakable_entry" ) then
				
				if barricade:GetNumPlanks() > 0 then
					local warppos = barricade:GetPos() + dir * 50
					local currentpos
					local currentb = barricade
					if !self:GetIsBusy() then -- When the zombie initially comes in contact with the barricade.
						self:MoveToPos(warppos, { lookahead = 20, tolerance = 20, draw = false, maxage = 3, repath = 3, })

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
						--local no, fuckoff = self:CheckForBarricade()
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
						if self.IsMooSpecial then
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

						-- this will cause zombies to attack the barricade until it's destroyed
						--local fuckyou, asshole = self:CheckForBarricade()
						if barricade then
							self:OnBarricadeBlocking(barricade, dir)
							return
						end
					end
				elseif barricade:GetTriggerJumps() and self.TriggerBarricadeJump then
					self:TimeOut(0.5)
					self:TriggerBarricadeJump(barricade, dir)
				else
					self:SolidMaskDuringEvent(MASK_NPCSOLID_BRUSHONLY)
					self:CollideWhenPossible()
					self:SetIsBusy(false)
				end
			end
		end
	end

-- A standard attack you can use it or create something fancy yourself
function ENT:Attack( data )

	self:SetLastAttack(CurTime())

	data = data or {}
	
	data.attackseq = data.attackseq
	if !data.attackseq then
		
		local attacktbl = self.AttackSequences
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
			if malding then
				self.loco:SetDesiredSpeed( 85 ) -- YOU SHALL PAY WITH YOUR PERKS
				self.loco:Approach( self:GetTarget():GetPos(), 10 )
				self.loco:FaceTowards( self:GetTarget():GetPos() )
			else
				self.loco:SetDesiredSpeed( 25 )
				self.loco:Approach( self:GetTarget():GetPos(), 10 )
				self.loco:FaceTowards( self:GetTarget():GetPos() )
			end
		end
		coroutine.yield()
	end
end