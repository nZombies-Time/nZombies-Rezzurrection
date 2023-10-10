AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Lambent Wretch"
ENT.Category = "Brainz"
ENT.Author = "Laby"
--GOD DAMN GLOWIE MONKEY DOGS
if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true
ENT.IsMooSpecial = true
ENT.DamageRange = 80
ENT.AttackDamage = 35
ENT.AttackRange = 75

ENT.Models = {
	{Model = "models/specials/locust_wretch.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"scream"}

local AttackSequences = {
	{seq = "swipe", dmgtimes = {0.3}},
	{seq = "Jump_Swipe", dmgtimes = {0.8},{1.0},{1.2}}
}
local JumpSequences = {
	{seq = "Mantle_Over"}
}

local JumpSequences2 = {
	{seq = "Emerge"}
}
ENT.BarricadeTearSequences = {
	--Leave this empty if you don't intend on having a specials enemy use tear anims.
}

ENT.IdleSequence = "Idle_A", "Idle_B", "Idle_C"

ENT.WeaveSequences = {
	"Evade_Bwd_End",
	"Evade_Lft_End",
	"Evade_Rt_End",
}

ENT.DeathSequences = {
	"Death_Back_A","Death_Back_B", "Death_Right"
}

ENT.ElectrocutionSequences = {
	"Chainsaw_Death"
}

ENT.AttackSounds = {
	"enemies/specials/wretch/atk1.ogg",
	"enemies/specials/wretch/atk2.ogg",
	"enemies/specials/wretch/atk3.ogg",
	"enemies/specials/wretch/atk4.ogg",
	"enemies/specials/wretch/atk5.ogg"
	
}


local runsounds = {
	Sound("enemies/specials/wretch/ambi1.ogg"),
	Sound("enemies/specials/wretch/ambi2.ogg"),
	Sound("enemies/specials/wretch/ambi3.ogg"),
	Sound("enemies/specials/wretch/ambi4.ogg"),
	Sound("enemies/specials/wretch/ambi5.ogg"),
	Sound("enemies/specials/wretch/ambi6.ogg"),
	Sound("enemies/specials/wretch/ambi7.ogg"),
	Sound("enemies/specials/wretch/ambi8.ogg"),
	Sound("enemies/specials/wretch/ambi9.ogg"),
	Sound("enemies/specials/wretch/ambi10.ogg"),
	Sound("enemies/specials/wretch/ambi11.ogg"),
	Sound("enemies/specials/wretch/ambi12.ogg"),
	Sound("enemies/specials/wretch/ambi13.ogg")
}

ENT.DeathSounds = {
	"enemies/specials/wretch/death1.ogg",
	"enemies/specials/wretch/death2.ogg",
	"enemies/specials/wretch/death3.ogg",
	"enemies/specials/wretch/death4.ogg",
	"enemies/specials/wretch/death5.ogg",
	"enemies/specials/wretch/death6.ogg",
	"enemies/specials/wretch/death7.ogg"
	
	
}

ENT.AppearSounds = {
	"enemies/specials/wretch/ambi3.ogg",
	"enemies/specials/wretch/ambi4.ogg",
	"enemies/specials/wretch/ambi7.ogg",
	"enemies/specials/wretch/ambi8.ogg",
	"enemies/specials/wretch/ambi9.ogg",
}

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"Run_A",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {runsounds},
		},
	}}
}

function ENT:StatsInitialize()
	if SERVER then
		self:SetRunSpeed( 36 )
		self.loco:SetDesiredSpeed( 36 )
		dying = false
	end
	self:SetCollisionBounds(Vector(-13,-13, 0), Vector(13, 13, 45))
end

function ENT:OnSpawn()
	self:SetMaterial("invisible")
	self:SetInvulnerable(true)
	self:SetBlockAttack(true)
	self:SolidMaskDuringEvent(MASK_PLAYERSOLID)

	self:EmitSound("nz/hellhound/spawn/prespawn.wav",511,100)
	ParticleEffect("hound_summon",self:GetPos(),self:GetAngles(),nil)
	--ParticleEffect("fx_hellhound_summon",self:GetPos(),self:GetAngles(),nil)

	self:TimeOut(0.85)
	
	self:EmitSound("nz/hellhound/spawn/strike.wav",511,100)
	ParticleEffectAttach("ins_skybox_lightning",PATTACH_ABSORIGIN_FOLLOW,self,0)
	
	self:SetMaterial("")
	self.NextAction = CurTime()
	self:SetInvulnerable(nil)
	self:SetBlockAttack(false)
	self:CollideWhenPossible()
	self:EmitSound(self.AppearSounds[math.random(#self.AppearSounds)], 511, math.random(85, 105), 1, 2)
	self.LastSideStep = CurTime()
	self.ImDyingWario = false
	nzRound:SetNextSpawnTime(CurTime() + 3) -- This one spawning delays others by 3 seconds
end

function ENT:PerformDeath(dmgInfo)
dying = true
		self.ImDyingWario = true
		if dmgInfo:GetDamageType() == DMG_SHOCK then
			self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
			self:DoDeathAnimation(self.ElectrocutionSequences[math.random(#self.ElectrocutionSequences)])
		else

			self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
			self:DoDeathAnimation(self.DeathSequences[math.random(#self.DeathSequences)])
			timer.Simple(2, function()
			if IsValid(self) then 
			self:EmitSound("enemies/specials/wretch/explode"..math.random(1,3)..".ogg",100)
	ParticleEffect("npc_gearsofwar_loc_lambent_former_explosion",self:GetPos() +self:OBBCenter(),Angle(0,0,0),nil)
	util.ScreenShake(self:GetPos(),100,50,0.50,90)
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

        	for k, v in pairs(ents.FindInSphere(pos, 250)) do
            	if v:IsPlayer() or v:IsNPC() or v:IsNextBot() then
                	if v:GetClass() == self:GetClass() then continue end
                	if v == self then continue end
                	if v:EntIndex() == self:EntIndex() then continue end
                	if v:Health() <= 0 then continue end
                	if !v:Alive() then continue end
                	tr.endpos = v:WorldSpaceCenter()
                	local tr1 =  util.TraceLine(tr)
                	if tr1.HitWorld then continue end

                	local expdamage = DamageInfo()
                	expdamage:SetAttacker(attacker)
                	expdamage:SetInflictor(inflictor)
                	expdamage:SetDamageType(DMG_NERVEGAS)

                	local distfac = pos:Distance(v:WorldSpaceCenter())
                	distfac = 1 - math.Clamp((distfac/200), 0, 1)
                	expdamage:SetDamage(25 * distfac)

                	expdamage:SetDamageForce(v:GetUp()*5000 + (v:GetPos() - self:GetPos()):GetNormalized() * 10000)

                	v:TakeDamageInfo(expdamage)
            	end
        	end
			self:Remove()
			end
			end)
			
		end

end


function ENT:OnPathTimeOut()
	local target = self:GetTarget()
	if CurTime() < self.NextAction then return end
	
	if math.random(0,2) == 1 and CurTime() > self.NextAction then
		if self:IsValidTarget(target) then
			local tr = util.TraceLine({
				start = self:GetPos() + Vector(0,50,0),
				endpos = target:GetPos() + Vector(0,0,50),
				filter = self,
			})
			
			if IsValid(tr.Entity) and self:IsValidTarget(tr.Entity) then
				timer.Simple(0.9, function()
			if IsValid(self) then 
				self:EmitSound("nz_moo/zombies/vox/_sonic/evt_sonic_attack_flux.mp3", 100, math.random(85, 105))
		self:EmitSound("enemies/specials/wretch/ambi"..math.random(8,9)..".ogg",100)
		ParticleEffectAttach("screamer_scream", 4, self, 1)
		for k,v in pairs(ents.FindInSphere(self:GetPos(), 200)) do
			if IsValid(v) and v:IsPlayer() and !self:IsAttackEntBlocked(v) then
				v:NZSonicBlind(1)
			end
		end
		end
		end)
		self:PlaySequenceAndMove("Scream", 1, self.FaceEnemy)
	end
	

				self.NextAction = CurTime() + math.random(4, 8)
				self.NextAction = CurTime() + math.random(5, 10)
			end
		end
		
	end


function ENT:PostTookDamage( dmgInfo )
if self.ImDyingWario then return end
if self:GetSpecialAnimation() then return end
if CurTime() < self.LastSideStep then return end
if dying then return end
if IsValid(self:GetTarget()) and self:GetTarget():IsPlayer() and dmgInfo:GetDamage() < self:Health() and not self.ImDyingWario and CurTime()> self.LastSideStep then
					local seq = self.WeaveSequences[math.random(#self.WeaveSequences)]
						if self:SequenceHasSpace(seq) then
						self:DoSpecialAnimation(seq, true, true)
					end
					self.LastSideStep = CurTime() + 4
				end

end

function ENT:DoDeathAnimation(seq)
	self.BehaveThread = coroutine.create(function()
		self:PlaySequenceAndWait(seq)
	
		
	end)
end


function ENT:HandleAnimEvent(a,b,c,d,e)

	if e == "md_step" then
		self:EmitSound("enemies/specials/wretch/step"..math.random(1,3)..".ogg",80,math.random(95,100))
	end
	if e == "GearsofWar_Wretch.Step" then
		self:EmitSound("enemies/specials/wretch/step"..math.random(1,3)..".ogg",80,math.random(95,100))
	end
	if e == "MYSTERNUM" then
			--self:EmitSound("enemies/specials/wretch/explode"..math.random(1,3)..".ogg")
	--ParticleEffect("npc_gearsofwar_loc_lambent_former_explosion",self:GetPos() +self:OBBCenter(),Angle(0,0,0),nil)
	--util.ScreenShake(self:GetPos(),100,50,0.50,90)
		--self:Explode( math.random( 25, 50 )) -- Doggy goes Kaboom! Since they explode on death theres no need for them to play death anims.
		--self:Remove()
	end
		if e == "weave" then
		self:PlaySound(self.AttackSounds[math.random(#self.AttackSounds)], 90, math.random(85, 105), 1, 2)
			self:SetInvulnerable(true)
	end
		if e == "ohfuck" then
			self:SetInvulnerable(false)
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
					warppos = (barricade:WorldSpaceCenter() + fwd*30)
				else
					warppos = (barricade:WorldSpaceCenter() + fwd*-30)
				end

				local bpos = barricade:ReserveAvailableTearPosition(self) or warppos

				if barricade:GetNumPlanks() > 0 then
					local currentpos

					self:SetIsBusy(true)
					self:ResetMovementSequence()
					self:MoveToPos(warppos, { lookahead = 20, tolerance = 5, draw = false, maxage = 1, repath = 1, })
					self:SetPos(Vector(warppos.x,warppos.y,self:GetPos().z))
					self:SetAngles(Angle(0,(barricade:GetPos()-self:GetPos()):Angle()[2],0))
					self:TimeOut(0.25)
					
					self:SetSpecialAnimation(true)
					self:SetBlockAttack(true)
					self:SetAngles(Angle(0,(barricade:GetPos()-self:GetPos()):Angle()[2],0))
		
					self:PlaySequenceAndMove("Emerge", {gravity = false})
					self:ResetMovementSequence()
					self:SetBlockAttack(false)
					self:SetSpecialAnimation(false)
					self:SetIsBusy(false)
					self:CollideWhenPossible() -- Remove the mask as soon as we can
					self:TimeOut(0.1)
					--self:HESCHEATING(barricade, dir)

				elseif barricade:GetTriggerJumps() and self.TriggerBarricadeJump then
					self:SetIsBusy(true)
					self:ResetMovementSequence()
					self:MoveToPos(warppos, { lookahead = 20, tolerance = 5, draw = false, maxage = 1, repath = 1, })
					self:SetPos(Vector(warppos.x,warppos.y,self:GetPos().z))
					self:SetAngles(Angle(0,(barricade:GetPos()-self:GetPos()):Angle()[2],0))
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
	
		function ENT:HESCHEATING( barricade, dir )
		if !self:GetSpecialAnimation() then

			local useswalkframes = false

			self:SetSpecialAnimation(true)
			self:SetBlockAttack(true)

			local id, dur, speed
			local animtbl = self.JumpSequences2

		
 
 			if self.JumpSequences2 then
				if type(animtbl) == "number" then -- ACT_ is a number, this is set if it's an ACT
					id = self:SelectWeightedSequence(animtbl)
					dur = self:SequenceDuration(id)
					speed = self:GetSequenceGroundSpeed(id)
					if speed < 10 then
						speed = 20
					end
				else
					local targettbl = animtbl and animtbl[math.random(#animtbl)] or self.JumpSequences2
					if targettbl then -- It is a table of sequences
						id, dur = self:LookupSequenceAct(targettbl.seq) -- Whether it's an ACT or a sequence string
						speed = targettbl.speed
						if speed then
							useswalkframes = false
						else
							useswalkframes = true
						end
					else
						id = self:SelectWeightedSequence(ACT_JUMP)
						dur = self:SequenceDuration(id)
						speed = 30
					end
				end
			end

			self:SolidMaskDuringEvent(MASK_NPCSOLID_BRUSHONLY)

			if useswalkframes then

				self:SetAngles(Angle(0,(barricade:GetPos()-self:GetPos()):Angle()[2],0))
		
				self:PlaySequenceAndMove("Emerge", {gravity = false})
				self:ResetMovementSequence()
			else
				if self.JumpSequences2 then
					self.loco:SetDesiredSpeed(speed)
					self:SetVelocity(self:GetForward() * speed)
					self:ResetSequence(id)
					self:SetCycle(0)
					self:SetPlaybackRate(1)
				end

				local pos = barricade:GetPos() - dir * 50
				self:MoveToPos(pos, { -- Zombie will move through the barricade.
					lookahead = 1,
					tolerance = 10,
					draw = false,
					maxage = dur, -- 12/7/22: Using the current mantle anim's duration allows for more consistent mantling and lessens the zombie's chances of getting stuck.
					repath = dur,
				})
				self:SetPos(pos)
				self.loco:SetAcceleration( self.Acceleration )
				self.loco:SetDesiredSpeed(self:GetRunSpeed())
			end
			self:SetBlockAttack(false)
			self:SetSpecialAnimation(false)
			self:SetIsBusy(false)
			self:CollideWhenPossible() -- Remove the mask as soon as we can
			self:TimeOut(0.1)
		end
	end
end