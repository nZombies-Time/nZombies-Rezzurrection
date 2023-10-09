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
	{Model = "models/zombies/former_male.mdl", Skin = 0, Bodygroups = {0,0}},
	{Model = "models/zombies/former_female.mdl", Skin = 0, Bodygroups = {0,0}}
}

local spawnslow = {"Crawl_Out"}
local spawnsuperfast = {"reference"}

ENT.DeathSequences = {
	"ragdoll",
}

ENT.IdleSequence = "run_unarmed"

ENT.ElectrocutionSequences = {
	"executed_chainsaw"
}

local AttackSequences = {
	{seq = "attack_1"},
	{seq = "attack_2"},
	{seq = "attack_3"},
	{seq = "attack_4"},
	{seq = "attack_5"},
	{seq = "attack_6"}
}

local JumpSequences = {
	{seq = "Mantle_Start"}
}

local walksounds = {
	Sound("enemies/zombies/former/slow1.ogg"),
	Sound("enemies/zombies/former/slow2.ogg"),
	Sound("enemies/zombies/former/slow3.ogg"),
	Sound("enemies/zombies/former/slow4.ogg"),
	Sound("enemies/zombies/former/slow5.ogg"),
	Sound("enemies/zombies/former/slow6.ogg"),
	Sound("enemies/zombies/former/slow7.ogg"),
	Sound("enemies/zombies/former/slow8.ogg"),
	Sound("enemies/zombies/former/slow9.ogg"),
	Sound("enemies/zombies/former/slow10.ogg"),
	Sound("enemies/zombies/former/slow11.ogg"),
	Sound("enemies/zombies/former/slow12.ogg"),
	Sound("enemies/zombies/former/slow13.ogg"),
	Sound("enemies/zombies/former/slow14.ogg"),
	Sound("enemies/zombies/former/slow15.ogg"),
	Sound("enemies/zombies/former/slow16.ogg"),
	Sound("enemies/zombies/former/slow17.ogg"),
	Sound("enemies/zombies/former/slow18.ogg"),
	Sound("enemies/zombies/former/slow19.ogg"),
	Sound("enemies/zombies/former/slow20.ogg"),
	Sound("enemies/zombies/former/slow21.ogg"),
	Sound("enemies/zombies/former/slow22.ogg"),

}

local runsounds = {
	Sound("enemies/zombies/former/ambi1.ogg"),
	Sound("enemies/zombies/former/ambi2.ogg"),
	Sound("enemies/zombies/former/ambi3.ogg"),
	Sound("enemies/zombies/former/ambi4.ogg"),
	Sound("enemies/zombies/former/ambi5.ogg"),
	Sound("enemies/zombies/former/ambi6.ogg"),
	Sound("enemies/zombies/former/ambi7.ogg"),
	Sound("enemies/zombies/former/ambi8.ogg"),
	Sound("enemies/zombies/former/ambi9.ogg"),
	Sound("enemies/zombies/former/ambi10.ogg"),
	Sound("enemies/zombies/former/ambi11.ogg"),
	Sound("enemies/zombies/former/ambi12.ogg"),
	Sound("enemies/zombies/former/ambi13.ogg"),
	Sound("enemies/zombies/former/ambi14.ogg"),
	Sound("enemies/zombies/former/ambi15.ogg"),
	Sound("enemies/zombies/former/ambi16.ogg"),
	Sound("enemies/zombies/former/ambi17.ogg"),
	Sound("enemies/zombies/former/ambi18.ogg"),
	Sound("enemies/zombies/former/ambi19.ogg"),
}



-- This is a very large and messy looking table... But it gets the job done. Except it isnt because these little fuckers don't have many animations :(
ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawnslow},
			MovementSequence = {
				"run_unarmed",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},

			PassiveSounds = {walksounds},
		},
		
	}},
	{Threshold = 200, Sequences = {
		{
			SpawnSequence = {spawnsuperfast},
			MovementSequence = {
				"run_unarmed",
				"run_sprint",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},

			PassiveSounds = {runsounds},
		},
		
	}}
}




ENT.DeathSounds = {
	"enemies/zombies/former/death1.ogg",
	"enemies/zombies/former/death2.ogg",
	"enemies/zombies/former/death3.ogg",
	"enemies/zombies/former/death4.ogg",
	"enemies/zombies/former/death5.ogg",
	"enemies/zombies/former/death6.ogg",
	"enemies/zombies/former/death7.ogg",
	"enemies/zombies/former/death8.ogg",
	"enemies/zombies/former/death9.ogg",
	"enemies/zombies/former/death10.ogg",
	"enemies/zombies/former/death11.ogg",
	"enemies/zombies/former/death12.ogg",
	"enemies/zombies/former/death13.ogg",
	"enemies/zombies/former/death14.ogg",
	"enemies/zombies/former/death15.ogg",
	"enemies/zombies/former/death16.ogg",
	
	
}

ENT.ElecSounds = {
	"enemies/zombies/former/death6.ogg",
	"enemies/zombies/former/death8.ogg",
	"enemies/zombies/former/death11.ogg",
	"enemies/zombies/former/death12.ogg",
	"enemies/zombies/former/spawn1.ogg",
	"enemies/zombies/former/spawn6.ogg",
	"enemies/zombies/former/spawn7.ogg"
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
	"enemies/zombies/former/atk1.ogg",
	"enemies/zombies/former/atk2.ogg",
	"enemies/zombies/former/atk3.ogg",
	"enemies/zombies/former/atk4.ogg",
	"enemies/zombies/former/atk5.ogg",
	"enemies/zombies/former/atk6.ogg",
	"enemies/zombies/former/atk7.ogg",
	"enemies/zombies/former/atk8.ogg",
	"enemies/zombies/former/atk9.ogg",
	"enemies/zombies/former/atk10.ogg",
	"enemies/zombies/former/atk11.ogg",
	"enemies/zombies/former/atk12.ogg",
	"enemies/zombies/former/atk13.ogg",
	"enemies/zombies/former/atk14.ogg",
	"enemies/zombies/former/atk15.ogg",
	"enemies/zombies/former/atk16.ogg",
	"enemies/zombies/former/atk17.ogg",
	"enemies/zombies/former/atk18.ogg",
	"enemies/zombies/former/atk19.ogg",
	"enemies/zombies/former/atk20.ogg",
	"enemies/zombies/former/atk21.ogg",
	"enemies/zombies/former/atk22.ogg",
	"enemies/zombies/former/atk23.ogg",
	"enemies/zombies/former/atk24.ogg",
	
}


ENT.BehindSoundDistance = 200 -- When the zombie is within 200 units of a player, play these sounds instead
ENT.BehindSounds = {
	Sound("enemies/zombies/former/slow3.ogg"),
	Sound("enemies/zombies/former/slow7.ogg"),
	Sound("enemies/zombies/former/slow11.ogg"),
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
	if e == "melee" then
		self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2)
		self:DoAttackDamage()
	end
	if e == "youcantseeme" then
	self:SetNoDraw(true)
	end
	if e == "youcanseeme" then
	self:SetNoDraw(false)
	end
	if e == "death" then
	self:EmitSound("enemies/zombies/former/explode"..math.random(1,3)..".ogg")
	ParticleEffect("npc_gearsofwar_loc_lambent_former_explosion",self:GetPos() +self:OBBCenter(),Angle(0,0,0),nil)
	util.ScreenShake(self:GetPos(),100,50,0.50,90)
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
	util.ScreenShake(self:GetPos(),100,50,0.50,90)
	--self:DoDeathAnimation(self.DeathSequences[math.random(#self.DeathSequences)])
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
								seq, dur = self:LookupSequence("attack_1")
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
									self:PlaySequenceAndWait("attack_1")
									if IsValid(self) and self:Alive() then
										if IsValid(planktopull) then
											barricade:RemovePlank(planktopull)
										end
									end
									self:PlaySequenceAndWait("attack_1")
								else
									self:PlaySequenceAndWait("attack_1")
									if IsValid(self) and self:Alive() then
										if IsValid(planktopull) then
											barricade:RemovePlank(planktopull)
										end
									end
									self:PlaySequenceAndWait("attack_1")
								end
							end
						else
							timer.Simple(dur/2, function() -- Moo Mark. This is very sinful but my dumbass can't think of anything else rn.
								if IsValid(self) and self:Alive() and IsValid(planktopull) then -- This is just so the plank being pulled looks nicer and will look like the zombie is actually pulling that bitch.
									barricade:RemovePlank(planktopull)
								end
							end)

							self:PlaySequenceAndWait("attack_1")
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
