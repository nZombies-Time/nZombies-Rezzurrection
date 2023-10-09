AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Ticker"
ENT.Category = "Brainz"
ENT.Author = "Laby"
--Tick Tock it's kaboom o clock
if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true
ENT.IsMooSpecial = true
ENT.AttackDamage = 10
ENT.AttackRange = 175
ENT.DamageRange = 5

ENT.Models = {
	{Model = "models/specials/locust_ticker.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"Jump_On_Grenade_Short"}

local AttackSequences = {
	{seq = "Explode"}
}


ENT.BarricadeTearSequences = "Barricade_Tear"
	

ENT.IdleSequence = "Idle"

ENT.DeathSequences = {
	"reference"
}

local JumpSequences = {
	{seq = "Jump_On_Grenade_Short"},
}



ENT.AttackSounds = {
	"enemies/specials/ticker/explodevox1.ogg",
	"enemies/specials/ticker/explodevox2.ogg",
	"enemies/specials/ticker/explodevox3.ogg",
	"enemies/specials/ticker/explodevox4.ogg",
	"enemies/specials/ticker/explodevox5.ogg",
	"enemies/specials/ticker/explodevox6.ogg",
	"enemies/specials/ticker/explodevox7.ogg",
	"enemies/specials/ticker/explodevox8.ogg",
	"enemies/specials/ticker/explodevox9.ogg",
	"enemies/specials/ticker/explodevox10.ogg",
	"enemies/specials/ticker/explodevox11.ogg",
	"enemies/specials/ticker/explodevox12.ogg"
	
}
local walksounds = {
	Sound("enemies/specials/ticker/ambi1.ogg"),
	Sound("enemies/specials/ticker/ambi2.ogg"),
	Sound("enemies/specials/ticker/ambi3.ogg"),
	Sound("enemies/specials/ticker/ambi4.ogg"),
	Sound("enemies/specials/ticker/ambi5.ogg"),
	Sound("enemies/specials/ticker/ambi6.ogg"),
	Sound("enemies/specials/ticker/ambi7.ogg"),
	Sound("enemies/specials/ticker/ambi8.ogg"),
	Sound("enemies/specials/ticker/ambi9.ogg"),
	Sound("enemies/specials/ticker/ambi10.ogg"),
	Sound("enemies/specials/ticker/ambi11.ogg"),
	Sound("enemies/specials/ticker/ambi12.ogg"),
	Sound("enemies/specials/ticker/ambi13.ogg"),
	Sound("enemies/specials/ticker/ambi14.ogg"),
	Sound("enemies/specials/ticker/ambi15.ogg"),
	Sound("enemies/specials/ticker/ambi16.ogg"),
	Sound("enemies/specials/ticker/ambi17.ogg"),
	Sound("enemies/specials/ticker/ambi18.ogg"),
	Sound("enemies/specials/ticker/ambi19.ogg"),
	Sound("enemies/specials/ticker/ambi20.ogg"),
	Sound("enemies/specials/ticker/explodevox10.ogg"),
	Sound("enemies/specials/ticker/explodevox11.ogg"),
	Sound("enemies/specials/ticker/explodevox12.ogg"),

}


ENT.DeathSounds = {
	"enemies/specials/ticker/boom1.ogg",
	"enemies/specials/ticker/boom2.ogg"
	
	
}

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"Walk_All",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
}

function ENT:StatsInitialize()
	if SERVER then
		self:SetRunSpeed( 200 )
		self.loco:SetDesiredSpeed( 200 )
	end
	self:SetCollisionBounds(Vector(-13,-13, 0), Vector(13, 13, 45))
end

function ENT:OnSpawn()

	local nav = navmesh.GetNavArea(self:GetPos(), 50)
	--self:EmitSound("nz_moo/zombies/vox/_quad/spawn/spawn_0"..math.random(3)..".mp3", 511, math.random(95, 105), 1, 2)

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

		if tr.Hit then
			local finalsound = SpawnMatSound[tr.MatType] or SpawnMatSound[0]
			self:EmitSound(finalsound)
		end

		ParticleEffect("bo3_zombie_spawn",self:GetPos()+Vector(0,0,1),self:GetAngles(),self)
		self:EmitSound("nz_moo/zombies/spawn/_generic/dirt/dirt_0"..math.random(0,2)..".mp3",100,math.random(95,105))

		self:SetSpecialAnimation(true)
		self:SetIsBusy(true)
		local seq = self:SelectSpawnSequence()

		if seq then
			self:PlaySequenceAndMove(seq, {gravity = true})
			self:SetSpecialAnimation(false)
			self:SetIsBusy(false)
			self:CollideWhenPossible()
		end
	
end

function ENT:HandleAnimEvent(a,b,c,d,e)

	if e == "tkr_jump" then
	self:PlaySound(self.AttackSounds[math.random(#self.AttackSounds)], 90, math.random(85, 105), 1, 2)
	end
	if e == "tkr_step" then
	self:EmitSound("enemies/specials/ticker/step"..math.random(1,4)..".ogg", 65, math.random(95,105))
	end
	if e == "tkr_bakudan" then
	if IsValid(self) then
		ParticleEffect("npc_gearsofwar_locust_ticker_explosion",self:GetPos(),self:GetAngles(),self)
		self:Explode( math.random( 50,125 )) -- DAISAN BAKUDAN, BITES ZA DUSTO
		self:Remove()
	end
	end
end

function ENT:PerformDeath(dmgInfo)
	self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
	if IsValid(self) then
		ParticleEffect("npc_gearsofwar_locust_ticker_explosion",self:GetPos(),self:GetAngles(),self)
		self:Explode( math.random( 60 )) -- FOR ALLAH
		self:Remove()
	end
end

function ENT:OnTargetInAttackRange()
		if !self:GetBlockAttack() then
		self:PlaySound(self.AttackSounds[math.random(#self.AttackSounds)], 90, math.random(85, 105), 1, 2)
		--self:SetSpecialAnimation(true)
				--self:SetBlockAttack(true)
			self:Attack()
		else
			self:TimeOut(2)
		end
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
				self:ResetMovementSequence()
				self.loco:SetDesiredSpeed( self:GetRunSpeed() )
			end
			return
		end
		if self:IsValidTarget( self:GetTarget() ) then
			self.loco:FaceTowards( self:GetTarget():GetPos() )
		end

		coroutine.yield()

	end

end

function ENT:IsValidTarget( ent )
	if not ent then return false end
	return IsValid( ent ) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
end

if SERVER then

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
						if self.IsMooSpecial and self.MooSpecialZombie or !self.IsMooSpecial then
							if planknumber ~= nil then
								if !self:GetCrawler() then
									self:PlaySequenceAndWait("Barricade_Tear")
									if IsValid(self) and self:Alive() then
										if IsValid(planktopull) then
											barricade:RemovePlank(planktopull)
										end
									end
									self:PlaySequenceAndWait("Barricade_Tear")
								else
									self:PlaySequenceAndWait("Barricade_Tear")
									if IsValid(self) and self:Alive() then
										if IsValid(planktopull) then
											barricade:RemovePlank(planktopull)
										end
									end
									self:PlaySequenceAndWait("Barricade_Tear")
								end
							end
						else
							timer.Simple(dur/2, function() -- Moo Mark. This is very sinful but my dumbass can't think of anything else rn.
								if IsValid(self) and self:Alive() and IsValid(planktopull) then -- This is just so the plank being pulled looks nicer and will look like the zombie is actually pulling that bitch.
									barricade:RemovePlank(planktopull)
								end
							end)

							self:PlaySequenceAndWait("Barricade_Tear")
						end

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