AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.Type = "nextbot"
ENT.Category = "Brainz"
ENT.Author = "Laby"
ENT.Spawnable = true

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true

ENT.Models = {
	{Model = "models/zombies/slasher_c2.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model = "models/zombies/slasher_cm2.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model = "models/zombies/slasher_c3.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model = "models/zombies/slasher_f6.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model = "models/zombies/slasher_g8.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model =  "models/zombies/slasher_h9.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model =  "models/zombies/slasher_m11.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model = "models/zombies/slasher_s14.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model = "models/zombies/slasher_a1.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model = "models/zombies/slasher_l10.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model = "models/zombies/slasher_n13.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model = "models/zombies/slasher_s15.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model = "models/zombies/slasher_fm7.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model =  "models/zombies/slasher_f7.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model =  "models/zombies/slasher_e5.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model = "models/zombies/slasher_d4.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model = "models/zombies/slasher_n12.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model = "models/zombies/slasher_t17.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model = "models/zombies/slasher_t16.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model = "models/zombies/slasher_z18.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model = "models/zombies/slasher_fm7.mdl", Skin = 0, Bodygroups = {0,0}}
}


local spawnslow = {"weak"}
local spawnsuperfast = {"default_pose"}

ENT.DeathSequences = {
	"flinch",
}

ENT.IdleSequence = "idle"


local AttackSequences = {
	{seq = "attack", dmgtimes = {0.5}},
	{seq = "attack2", dmgtimes = {0.5}},
	{seq = "attack3", dmgtimes = {0.5}}
}

local JumpSequences = {
	{seq = "attack4"}
}


local walksounds = {
	Sound("enemies/zombies/slasher/slashertwister_088.ogg"),
	Sound("enemies/zombies/slasher/twitcher_security_077.ogg"),
	Sound("enemies/zombies/slasher/twitcher_security_097.ogg"),
	Sound("enemies/zombies/slasher/twitcher_security_098.ogg"),
	Sound("enemies/zombies/slasher/twitcher_security_099.ogg"),
	Sound("enemies/zombies/slasher/twitcher_security_100.ogg"),
	Sound("enemies/zombies/slasher/twitcher_security_101.ogg"),
	Sound("enemies/zombies/slasher/armor/slasher_armor_056.ogg"),
	Sound("enemies/zombies/slasher/armor/slasher_armor_084.ogg"),
	Sound("enemies/zombies/slasher/slasher_gov_worker_056.ogg"),
	Sound("enemies/zombies/slasher/slasher_gov_worker_057.ogg"),
	Sound("enemies/zombies/slasher/slasher_male_civilian_058.ogg"),
	Sound("enemies/zombies/slasher/slasher_male_civilian_056.ogg")

}


local runsounds = {
	Sound("enemies/zombies/slasher/slashertwister_088.ogg"),
	Sound("enemies/zombies/slasher/twitcher_security_074.ogg"),
	Sound("enemies/zombies/slasher/twitcher_security_075.ogg"),
	Sound("enemies/zombies/slasher/twitcher_security_076.ogg"),
	Sound("enemies/zombies/slasher/twitcher_security_077.ogg"),
	Sound("enemies/zombies/slasher/twitcher_security_100.ogg"),
	Sound("enemies/zombies/slasher/twitcher_security_101.ogg"),
	Sound("enemies/zombies/slasher/armor/slasher_armor_054.ogg"),
	Sound("enemies/zombies/slasher/armor/slasher_armor_055.ogg"),
	Sound("enemies/zombies/slasher/armor/slasher_armor_057.ogg"),
	Sound("enemies/zombies/slasher/armor/slasher_armor_084.ogg"),
	Sound("enemies/zombies/slasher/slasher_gov_worker_054.ogg"),
	Sound("enemies/zombies/slasher/slasher_gov_worker_055.ogg"),
	Sound("enemies/zombies/slasher/slasher_gov_worker_056.ogg"),
	Sound("enemies/zombies/slasher/slasher_male_civilian_054.ogg"),
	Sound("enemies/zombies/slasher/slasher_male_civilian_055.ogg"),
	Sound("enemies/zombies/slasher/slasher_male_civilian_056.ogg")

}



-- This is a very large and messy looking table... But it gets the job done. Except it isnt because these little fuckers don't have many animations :(
ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawnslow},
			MovementSequence = {
				"walk","walk2", "walk3"
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},

			PassiveSounds = {walksounds},
		},
		
	}},
	{Threshold = 120, Sequences = {
		{
			SpawnSequence = {spawnsuperfast},
			MovementSequence = {
				"walk3",
				"run",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},

			PassiveSounds = {runsounds},
		},
		
	}}
}


ENT.DeathSounds = {
	"enemies/zombies/slasher/twitcher_security_078.ogg",
	"enemies/zombies/slasher/twitcher_security_079.ogg",
	"enemies/zombies/slasher/twitcher_security_080.ogg",
	"enemies/zombies/slasher/twitcher_security_081.ogg",
	"enemies/zombies/slasher/slashertwister_096.ogg",
	"enemies/zombies/slasher/slashertwister_097.ogg",
	"enemies/zombies/slasher/armor/slasher_armor_057.ogg",
	"enemies/zombies/slasher/armor/slasher_armor_058.ogg",
	"enemies/zombies/slasher/armor/slasher_armor_059.ogg",
	"enemies/zombies/slasher/armor/slasher_armor_085.ogg",
	"enemies/zombies/slasher/armor/slasher_armor_086.ogg",
	"enemies/zombies/slasher/armor/slasher_armor_087.ogg",
	"enemies/zombies/slasher/slasher_gov_worker_057.ogg",
	"enemies/zombies/slasher/slasher_gov_worker_058.ogg",
	"enemies/zombies/slasher/slasher_gov_worker_059.ogg",
	"enemies/zombies/slasher/slasher_male_civilian_057.ogg",
	"enemies/zombies/slasher/slasher_male_civilian_058.ogg",
	"enemies/zombies/slasher/slasher_male_civilian_059.ogg"
}

ENT.NukeDeathSounds = {
	"nz_moo/zombies/vox/nuke_death/soul_00.mp3",
	"nz_moo/zombies/vox/nuke_death/soul_01.mp3",
	"nz_moo/zombies/vox/nuke_death/soul_02.mp3",
	"nz_moo/zombies/vox/nuke_death/soul_03.mp3",
	"nz_moo/zombies/vox/nuke_death/soul_04.mp3",
	"nz_moo/zombies/vox/nuke_death/soul_05.mp3",
	"nz_moo/zombies/vox/nuke_death/soul_06.mp3",
	"nz_moo/zombies/vox/nuke_death/soul_07.mp3",
	"nz_moo/zombies/vox/nuke_death/soul_08.mp3",
	"nz_moo/zombies/vox/nuke_death/soul_09.mp3",
	"nz_moo/zombies/vox/nuke_death/soul_10.mp3"
}

ENT.AttackSounds = {
	"enemies/zombies/slasher/twitcher_security_097.ogg",
	"enemies/zombies/slasher/twitcher_security_098.ogg",
	"enemies/zombies/slasher/twitcher_security_099.ogg",
	"enemies/zombies/slasher/twitcher_security_100.ogg",
	"enemies/zombies/slasher/twitcher_security_101.ogg",
	"enemies/zombies/slasher/twitcher_security_087.ogg",
	"enemies/zombies/slasher/twitcher_security_089.ogg",
	"enemies/zombies/slasher/twitcher_security_090.ogg",
	"enemies/zombies/slasher/twitcher_security_091.ogg",
	"enemies/zombies/slasher/twitcher_security_092.ogg",
	"enemies/zombies/slasher/twitcher_security_095.ogg",
	"enemies/zombies/slasher/twitcher_security_096.ogg",
	"enemies/zombies/slasher/armor/slasher_armor_082.ogg",
	"enemies/zombies/slasher/armor/slasher_armor_083.ogg",
	"enemies/zombies/slasher/armor/slasher_armor_084.ogg",
	"enemies/zombies/slasher/slashertwister_091.ogg",
	"enemies/zombies/slasher/slashertwister_092.ogg",
	"enemies/zombies/slasher/slasher_gov_worker_054.ogg",
	"enemies/zombies/slasher/slasher_gov_worker_055.ogg",
	"enemies/zombies/slasher/slasher_male_civilian_054.ogg",
	"enemies/zombies/slasher/slasher_male_civilian_055.ogg",
}


ENT.BehindSoundDistance = 200 -- When the zombie is within 200 units of a player, play these sounds instead
ENT.BehindSounds = {
	Sound("enemies/zombies/slasher/slashertwister_088.ogg"),
	Sound("enemies/zombies/slasher/twitcher_security_099.ogg"),
	Sound("enemies/zombies/slasher/slasher_male_civilian_058.ogg"),
}

function ENT:StatsInitialize()
	if SERVER then
		if nzRound:GetNumber() == -1 then
			self:SetRunSpeed( math.random(25, 220) )
			self:SetHealth( math.random(100, 1500) )
		else
			local speeds = nzRound:GetZombieCoDSpeeds()
			if speeds then
				self:SetRunSpeed( nzMisc.WeightedRandom(speeds) + math.random(0,35) )
			else
				self:SetRunSpeed( 100 )
			end
			self:SetHealth( nzRound:GetZombieHealth() or 75 )
		end
	end
end

function ENT:SpecialInit()
	if CLIENT then
	end
end

function ENT:HandleAnimEvent(a,b,c,d,e) -- Moo Mark 4/14/23: You don't know how sad I am that I didn't know about this sooner.
	if e == "death" then
	ParticleEffect("npc_gearsofwar_loc_lambent_former_explosion",self:GetPos() +self:OBBCenter(),Angle(0,0,0),nil)
	self:Remove()
	
	end
	if e == "lemon_step" then
		self:EmitSound("enemies/zombies/former/step"..math.random(1,9)..".ogg", 65, math.random(95,105))
	end
end

function ENT:OnSpawn()
	local nav = navmesh.GetNavArea(self:GetPos(), 50)
	if IsValid(nav) and nav:HasAttributes(NAV_MESH_NO_JUMP) then
		self:SolidMaskDuringEvent(MASK_PLAYERSOLID)
		self:CollideWhenPossible()
	else
		local SpawnMatSound = {
			[MAT_DIRT] = "nz_moo/zombies/spawn/dirt/pfx_zm_spawn_dirt_0"..math.random(0,1)..".mp3",
			[MAT_SNOW] = "nz_moo/zombies/spawn/snow/pfx_zm_spawn_snow_0"..math.random(0,1)..".mp3",
			[MAT_SLOSH] = "nz_moo/zombies/spawn/mud/pfx_zm_spawn_mud_00.mp3",
			[0] = "nz_moo/zombies/spawn/default/pfx_zm_spawn_default_00.mp3",
		}
		SpawnMatSound[MAT_GRASS] = SpawnMatSound[MAT_DIRT]
		SpawnMatSound[MAT_SAND] = SpawnMatSound[MAT_DIRT]

		local norm = (self:GetPos()):GetNormalized()
		local tr = util.QuickTrace(self:GetPos(), norm*10, self)

		self:SolidMaskDuringEvent(MASK_PLAYERSOLID)

		--ParticleEffect("bo3_zombie_spawn",self:GetPos()+Vector(0,0,1),self:GetAngles(),self)
		--self:EmitSound("nz/zombies/spawn/zm_spawn_dirt"..math.random(1,2)..".wav",80,math.random(95,105))
	
		self:SetSpecialAnimation(true)
		self:SetIsBusy(true)
		local seq = self:SelectSpawnSequence()


		local navtypes = {
			[NAV_MESH_OBSTACLE_TOP] = true,
			[NAV_MESH_DONT_HIDE] = true,
		}



			if tr.Hit then
				local finalsound = SpawnMatSound[tr.MatType] or SpawnMatSound[0]
				self:EmitSound(finalsound)
			end
			ParticleEffect("bo3_zombie_spawn",self:GetPos()+Vector(0,0,1),self:GetAngles(),self)
			self:EmitSound("nz/zombies/spawn/zm_spawn_dirt"..math.random(1,2)..".wav",80,math.random(95,105))
		
		if seq then
			if IsValid(nav) and (nav:HasAttributes(NAV_MESH_OBSTACLE_TOP) or nav:HasAttributes(NAV_MESH_DONT_HIDE)) then
				self:PlaySequenceAndMove(seq, {gravity = false})
			else
				self:PlaySequenceAndMove(seq, {gravity = true})
			end
			self:SetSpecialAnimation(false)
			self:SetIsBusy(false)
			self:CollideWhenPossible()
		end
	end
end


function ENT:PerformDeath(dmginfo)
	local damagetype = dmginfo:GetDamageType()
	if damagetype == DMG_REMOVENORAGDOLL then
		self:Remove(dmginfo)
	end
	if self.DeathSounds then
	self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
	self:EmitSound("enemies/zombies/former/explode"..math.random(1,3)..".ogg")
	ParticleEffect("npc_gearsofwar_loc_lambent_former_explosion",self:GetPos() +self:OBBCenter(),Angle(0,0,0),nil)
	self:Remove(dmgInfo)
	end
	
	
end

ENT.PainSounds = {
	"nz_moo/zombies/vox/_zhd/pain/pain_00.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_01.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_02.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_03.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_04.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_05.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_06.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_07.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_08.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_09.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_10.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_11.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_12.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_13.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_14.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_15.mp3",
	"nz_moo/zombies/vox/_zhd/pain/pain_16.mp3",
}

if SERVER then
	function ENT:ResetMovementSequence()
			self:ResetSequence(self.MovementSequence)
			self.CurrentSeq = self.MovementSequence
		
		if self.UpdateSeq ~= self.CurrentSeq then -- Moo Mark 4/19/23: Finally got a system where the speed actively updates when the movement sequence set is changed.
			--print("update")
			self.UpdateSeq = self.CurrentSeq
			--self.loco:SetDesiredSpeed(  math.random( 90, 350 ) )
		end
	end
	
	-- This function is full of stench
	function ENT:OnBarricadeBlocking( barricade, dir )
		if not self:GetSpecialAnimation() then
			if (IsValid(barricade) and barricade:GetClass() == "breakable_entry" ) then

				local warppos

				--[[ This allows the zombie to know which side of the barricade is which when climbing over it ]]--
				local normal = (self:GetPos() - barricade:GetPos()):GetNormalized()
				local fwd = barricade:GetForward()
				local dot = fwd:Dot(normal)
				if 0 < dot then
					warppos = (barricade:WorldSpaceCenter() + fwd*32)
				else
					warppos = (barricade:WorldSpaceCenter() + fwd*-32)
				end

				local bpos = barricade:ReserveAvailableTearPosition(self) or warppos

				if barricade:GetNumPlanks() > 0 then
					local currentpos

					-- If for some reason the position is nil... Just idle until further notice.
					if !bpos then
						self:TimeOut(2)
						return
					end

					if !self:GetIsBusy() and bpos then -- When the zombie initially comes in contact with the barricade.
						self:SetIsBusy(true)
						self:MoveToPos(bpos, { lookahead = 20, tolerance = 20, draw = false, maxage = 1, repath = 1, })

						self:TimeOut(0.5) -- An intentional and W@W authentic stall.
						self:SolidMaskDuringEvent(MASK_NPCSOLID_BRUSHONLY)
					end

					currentpos = self:GetPos()
					if bpos and currentpos ~= bpos then
						self:SetPos(Vector(bpos.x,bpos.y,currentpos.z))
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
						elseif self.StandAttackSequences and !self:GetCrawler() then
							attacktbl = self.StandAttackSequences
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
								seq, dur = self:LookupSequence("attack")
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
						if self.IsMooSpecial and self.MooSpecialZombie or !self.IsMooSpecial then
							if planknumber ~= nil then
								if !self:GetCrawler() then
									self:PlaySequenceAndWait("attack")
									if IsValid(self) and self:Alive() then
										if IsValid(planktopull) then
											barricade:RemovePlank(planktopull)
										end
									end
									self:PlaySequenceAndWait("attack")
								else
									self:PlaySequenceAndWait("attack")
									if IsValid(self) and self:Alive() then
										if IsValid(planktopull) then
											barricade:RemovePlank(planktopull)
										end
									end
									self:PlaySequenceAndWait("attack")
								end
							end
						else
							timer.Simple(dur/2, function() -- Moo Mark. This is very sinful but my dumbass can't think of anything else rn.
								if IsValid(self) and self:Alive() and IsValid(planktopull) then -- This is just so the plank being pulled looks nicer and will look like the zombie is actually pulling that bitch.
									barricade:RemovePlank(planktopull)
								end
							end)

							self:PlaySequenceAndWait("attack")
						end

						if barricade then
							self:OnBarricadeBlocking(barricade, dir)
							return
						end
					end
				elseif barricade:GetTriggerJumps() and self.TriggerBarricadeJump then
					self:SetIsBusy(true)
					self:ResetMovementSequence()
					self:MoveToPos(warppos, { lookahead = 20, tolerance = 5, draw = false, maxage = 1, repath = 1, })
					self:SetPos(Vector(warppos.x,warppos.y,self:GetPos().z))
					self:SetAngles(Angle(0,(barricade:GetPos()-self:GetPos()):Angle()[2],0))
					self:TimeOut(0.5)

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
