AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Thrasher aka The Cheekeater"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo"

--Girly weak ass bitch

function ENT:InitDataTables()
	self:NetworkVar("Entity", 	5, "CurrentZombie")
	self:NetworkVar("Entity", 	6, "CurrentPlayer")
	self:NetworkVar("Bool", 	7, "IsEnraged")
end

if CLIENT then 
	local eyeglow =  Material("nz/zlight")
	function ENT:Draw() //Runs every frame
		self:DrawModel()
		if self.RedEyes and self:Alive() and !self:GetDecapitated() then
			self:DrawEyeGlow() 
		end
		if GetConVar( "nz_zombie_debug" ):GetBool() then
			render.DrawWireframeBox(self:GetPos(), Angle(0,0,0), self:OBBMins(), self:OBBMaxs(), Color(255,0,0), true)
		end
		
		self:EffectsAndSounds()

		self:HideSelfFromVictim()
		--self:HideVictimFromClients()
	end

	function ENT:EffectsAndSounds()
		if self:Alive() then
			-- Credit: FlamingFox for Code and fighting the PVS monster -- 
			if !IsValid(self) then return end
			if self:GetIsEnraged() and (!self.Draw_FX or !IsValid(self.Draw_FX)) then
				self.Draw_FX = CreateParticleSystem(self, "bo3_thrasher_aura", PATTACH_POINT_FOLLOW, 1)
			end
		end
	end

	function ENT:DrawEyeGlow()
		local eyeColor = Color(255, 100, 0, 255)
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
			render.DrawSprite(lefteyepos, 6, 6, eyeColor)
			render.DrawSprite(righteyepos, 6, 6, eyeColor)
		end
	end

	function ENT:HideSelfFromVictim()
		-- Get the Thrasher's player and the client.

		local currentply = self:GetCurrentPlayer()
		local ply = LocalPlayer()

		-- If they are equal, hide the thrasher from the client(victim)
		if self:Alive() and IsValid(currentply) and IsValid(ply) then
			if currentply:IsPlayer() and currentply == ply then
				self:SetNoDraw(true)
			else
				self:SetNoDraw(false)
			end
		else
			self:SetNoDraw(false)
		end
	end

	--[[function ENT:HideVictimFromClients()
		local currentply = self:GetCurrentPlayer()
		local ply = LocalPlayer()
		if IsValid(self) then
			if IsValid(currentply) and IsValid(ply) then
				if currentply:IsPlayer() and (currentply ~= ply or currentply == ply) then
					currentply:SetNoDraw(true)
				else
					currentply:SetNoDraw(false)
				end
			end
		else
			if IsValid(currentply) then
				currentply:SetNoDraw(false)
			end
		end
	end]]

	return 
end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.IsMooSpecial = true
ENT.RedEyes = true

ENT.AttackRange = 100
ENT.AttackDamage = 90
ENT.HeavyAttackDamage = 150

ENT.TraversalCheckRange = 80

ENT.Models = {
	{Model = "models/moo/_codz_ports/t7/island/moo_codz_t7_island_thrasher.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"nz_thrasher_transform"}

ENT.DeathSequences = {
	"nz_thrasher_death_v1",
	"nz_thrasher_death_v2"
}

ENT.BarricadeTearSequences = {
	--Leave this empty if you don't intend on having a special enemy use tear anims.
}

local AttackSequences = {
	{seq = "nz_thrasher_attack_swing_swipe"},
	{seq = "nz_thrasher_attack_swipe"},
}

local JumpSequences = {
	{seq = "nz_thrasher_mantle_over_36"},
}

local walksounds = {
	Sound("nz_moo/zombies/vox/_thrasher/vox/ambient/ambient_00.mp3"),
	Sound("nz_moo/zombies/vox/_thrasher/vox/ambient/ambient_01.mp3"),
	Sound("nz_moo/zombies/vox/_thrasher/vox/ambient/ambient_02.mp3"),
	Sound("nz_moo/zombies/vox/_thrasher/vox/ambient/ambient_03.mp3"),
	Sound("nz_moo/zombies/vox/_thrasher/vox/ambient/ambient_04.mp3"),
	Sound("nz_moo/zombies/vox/_thrasher/vox/ambient/ambient_05.mp3"),
	Sound("nz_moo/zombies/vox/_thrasher/vox/ambient/ambient_06.mp3"),
	Sound("nz_moo/zombies/vox/_thrasher/vox/ambient/ambient_07.mp3"),
	Sound("nz_moo/zombies/vox/_thrasher/vox/ambient/ambient_08.mp3"),
}

ENT.IdleSequence = "nz_thrasher_idle"

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"nz_thrasher_walk_f_v1",
				"nz_thrasher_walk_f_v2",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}},
	{Threshold = 75, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"nz_thrasher_run_f_v1",
				"nz_thrasher_run_f_v2",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
		},
	}}
}

ENT.ZombieLandSequences = {
	"nz_thrasher_jump_land",
}

ENT.CustomMantleOver48 = {
	"nz_thrasher_mantle_over_48"
}

ENT.CustomMantleOver72 = {
	"nz_thrasher_mantle_over_72"
}

ENT.CustomMantleOver96 = {
	"nz_thrasher_mantle_over_96"
}

ENT.CustomNormalJumpUp128 = {
	"nz_thrasher_jump_up_128"
}

ENT.CustomNormalJumpDown128 = {
	"nz_thrasher_jump_down_128"
}

ENT.AttackSounds = {
	Sound("nz_moo/zombies/vox/_thrasher/vox/attack/attack_00.mp3"),
	Sound("nz_moo/zombies/vox/_thrasher/vox/attack/attack_01.mp3"),
	Sound("nz_moo/zombies/vox/_thrasher/vox/attack/attack_02.mp3"),
	Sound("nz_moo/zombies/vox/_thrasher/vox/attack/attack_03.mp3"),
}

ENT.PainSounds = {
	Sound("nz_moo/zombies/vox/_thrasher/vox/pain/pain_00.mp3"),
	Sound("nz_moo/zombies/vox/_thrasher/vox/pain/pain_01.mp3"),
	Sound("nz_moo/zombies/vox/_thrasher/vox/pain/pain_02.mp3"),
	Sound("nz_moo/zombies/vox/_thrasher/vox/pain/pain_03.mp3"),
}

ENT.DeathSounds = {
	Sound("nz_moo/zombies/vox/_thrasher/vox/death/death_00.mp3"),
	Sound("nz_moo/zombies/vox/_thrasher/vox/death/death_01.mp3"),
	Sound("nz_moo/zombies/vox/_thrasher/vox/death/death_02.mp3"),
	Sound("nz_moo/zombies/vox/_thrasher/vox/death/death_03.mp3"),
}

ENT.SpawnSounds = {
	Sound("nz_moo/zombies/vox/_thrasher/vox/spawn/spawn_00.mp3"),
	Sound("nz_moo/zombies/vox/_thrasher/vox/spawn/spawn_01.mp3"),
	Sound("nz_moo/zombies/vox/_thrasher/vox/spawn/spawn_02.mp3"),
}

ENT.RoarSounds = {
	Sound("nz_moo/zombies/vox/_thrasher/vox/roar/roar_00.mp3"),
	Sound("nz_moo/zombies/vox/_thrasher/vox/roar/roar_01.mp3"),
	Sound("nz_moo/zombies/vox/_thrasher/vox/roar/roar_02.mp3"),
	Sound("nz_moo/zombies/vox/_thrasher/vox/roar/roar_03.mp3"),
}

ENT.BiteSounds = {
	Sound("nz_moo/zombies/vox/_thrasher/bite/bite_00.mp3"),
	Sound("nz_moo/zombies/vox/_thrasher/bite/bite_01.mp3"),
	Sound("nz_moo/zombies/vox/_thrasher/bite/bite_02.mp3"),
	Sound("nz_moo/zombies/vox/_thrasher/bite/bite_03.mp3"),
	Sound("nz_moo/zombies/vox/_thrasher/bite/bite_04.mp3"),
}

ENT.StompSounds = {
	Sound("nz_moo/zombies/vox/_margwa/step/step_00.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/step/step_01.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/step/step_02.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/step/step_03.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/step/step_04.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/step/step_05.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/step/step_06.mp3"),
}

ENT.SporeExplodeSounds = {
	Sound("nz_moo/zombies/vox/_margwa/head_explo/margwa_head_explo_0.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/head_explo/margwa_head_explo_1.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/head_explo/margwa_head_explo_2.mp3"),
	Sound("nz_moo/zombies/vox/_margwa/head_explo/margwa_head_explo_3.mp3"),
}

function ENT:StatsInitialize()
	if SERVER then
		local count = #player.GetAllPlaying()

		if nzRound:InState( ROUND_CREATE ) then
			self:SetHealth(3500)
			self:SetMaxHealth(3500)
		else
			if nzRound:InState( ROUND_PROG ) then
				self:SetHealth(math.Clamp(nzRound:GetNumber() * 900 + (700 * count), 3500, 8700 * count))
				self:SetMaxHealth(math.Clamp(nzRound:GetNumber() * 900 + (700 * count), 3500, 8700 * count))
			else
				self:SetHealth(3500)
				self:SetMaxHealth(3500)	
			end
		end
		
		-- Instead of being random, it will now always be 15 to 30 seconds before a Thrasher becomes enraged.
		self.EnrageTime = CurTime() + math.random(15, 30)
		self.Enraged = false
		self:SetIsEnraged(false)

		self.TeleportCooldown = CurTime() + 1

		self.LegSpore = true
		self.ChestSpore = true
		self.BackSpore = true

		self.LegSporeHp = self:Health() / 10
		self.ChestSporeHp = self:Health() / 10
		self.BackSporeHp = self:Health() / 10

		self:SetCurrentZombie(nil)
		self:SetCurrentPlayer(nil)

		self.Acting = false
		self.ActTime = CurTime() + 1

		self.SporeCount = 0
		self.RegenCooldown = CurTime() + 5

		self.IFrames = CurTime() + 3

		self:SetRunSpeed( 60 )
		self.loco:SetDesiredSpeed( 60 )
	end
end

function ENT:OnSpawn()
	self:SetCollisionBounds(Vector(-14,-14, 0), Vector(14, 14, 72))
	self:SetSurroundingBounds(Vector(-26, -26, 0), Vector(26, 26, 75))
	
	self:SolidMaskDuringEvent(MASK_SOLID_BRUSHONLY)
	self:EmitSound(self.SpawnSounds[math.random(#self.SpawnSounds)],577)

	self:CreateVinesIn()

	self:SetSpecialAnimation(true)
	local seq = self:SelectSpawnSequence()
	if seq then
		self:PlaySequenceAndWait(seq)
		self:SetSpecialAnimation(false)
		self:SetInvulnerable(false)
		self:CollideWhenPossible()
	end
end

function ENT:PerformDeath(dmgInfo)
	if self:GetSpecialAnimation() then
		self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
		if IsValid(self) then
			ParticleEffect("bo3_margwa_death",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
			self:Remove()
		end
	else
		self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
		self:DoDeathAnimation(self.DeathSequences[math.random(#self.DeathSequences)])
	end
end

function ENT:AI()
	-- ENRAGE
	if !self.Enraged and CurTime() > self.EnrageTime then
		self.Enraged = true
		self:SetIsEnraged(true)

		self:EmitSound("enemies/bosses/thrasher/vox/spawn_0"..math.random(1,2)..".ogg",677)
		self:EmitSound("nz_moo/zombies/vox/_thrasher/enrage_imp_00.mp3",577)
		ParticleEffect("bo3_astronaut_pulse",self:LocalToWorld(Vector(0,0,60)),Angle(0,0,0),nil)	
		
		self:DoSpecialAnimation("nz_thrasher_enrage")
		self:SetRunSpeed(150)
		self:SpeedChanged()
	end


	-- ABDUCTION
	for k,v in pairs(player.GetAll()) do
		
		if #player.GetAllPlaying() <= 1 then return end

		if IsValid(v) and !v:GetNotDowned() and !IsValid(self:GetCurrentPlayer()) and !v:NZIsThrasherVictim() and math.random(3) == 1 then
			
			self:SetTarget(v)

			if !self:TargetInRange(450) then return end

			local pos = v:GetPos()

			self:ResetMovementSequence()
			self:MoveToPos(pos, {
				lookahead = 1,
				tolerance = 75,
				draw = false,
				repath = 3,
				maxage = 5,
			})

			self:FaceTowards(v:GetPos())
			self:DoSpecialAnimation("nz_thrasher_eat", 1)
			if IsValid(self) and self:Alive() then
				if !v:GetNotDowned() and !v:NZIsThrasherVictim() then
					--v:Kill()
					v:SetCollisionGroup(COLLISION_GROUP_IN_VEHICLE)
					self:SetCurrentPlayer(v)
					v.ThrasherParent = self
				end
			end
		end
	end


	-- TELEPORT
	if IsValid(self.Target) and !self:TargetInRange(750) and CurTime() > self.TeleportCooldown then
		if !self.Target:IsPlayer() then return end

		local target = self.Target
		local pos = self:FindSpotBehindPlayer(target:GetPos(), 10)

		self:CreateVinesOut()
		self:PlaySequenceAndWait("nz_thrasher_teleport_out")
		self:SetSpecialAnimation(true)


		self:SetPos( pos )
		self:FaceTowards(self.Target)

		self:CreateVinesIn()
		self:PlaySequenceAndWait("nz_thrasher_teleport_in")
		self:SetSpecialAnimation(false)
		self:CollideWhenPossible()

		self.TeleportCooldown = CurTime() + 7
	end

	-- SPORE REGENERATION
	if self.SporeCount ~= 0 and CurTime() > self.RegenCooldown then
		for k,v in nzLevel.GetZombieArray() do
			if IsValid(v) and !v:GetSpecialAnimation() and v.IsMooZombie and !v.Non3arcZombie and !v.IsMooSpecial and v ~= self then
				if self:GetRangeTo( v:GetPos() ) < 85 then
					local seq = "nz_thrasher_eat_z_b"
					if self:SequenceHasSpace(seq) then
						if !IsValid(v) then return end

						self.RegenCooldown = CurTime() + 10

						self:TimeOut(0.25)

						self.Regen = true

						self:SetCurrentZombie(v)

						self:TempBehaveThread(function(self)
							if !IsValid(self:GetCurrentZombie()) then return end
							local zomb = self:GetCurrentZombie()

							self:SetSpecialAnimation(true)
							self:SetIsBusy(true)
							self.TraversalAnim = true
							self.Acting = true
							local pos = self:GetPos() + self:GetRight() * -6 + self:GetForward() * 70

							debugoverlay.Sphere(pos, 50, 5, Color( 255, 255, 255 ), false)

							--zomb:ApproachPosAndWait(pos, 13)
							zomb:SetPos(pos)
							zomb:SetAngles(self:GetAngles())

							self:FaceTowards(zomb:GetPos())

							zomb:DoSpecialAnimation("nz_zombie_eaten_by_thrasher_f", false, false, false)
							self:PlaySequenceAndMove(seq, 1)

							self:RegenSpore()
							self.Regen = false
							self:SetSpecialAnimation(false)
							self:SetIsBusy(false)
							self.TraversalAnim = false
							self.Acting = false
						end)
					end
				end
			end
		end
	end

	-- Knock normal zombies aside
	for k,v in nzLevel.GetZombieArray() do
		if IsValid(v) and !v:GetSpecialAnimation() and v.IsMooZombie and !v.Non3arcZombie and !v.IsMooSpecial and v ~= self then
			if self:GetRangeTo( v:GetPos() ) < 7^2 then	
				if v.IsMooZombie and !v.IsMooSpecial and !v:GetSpecialAnimation() and self:GetRunSpeed() > 36 then
					if v.PainSequences then
						v:DoSpecialAnimation(v.PainSequences[math.random(#v.PainSequences)], true, true)
					end
				end
			end
		end
	end

	-- Wander
	--[[if IsValid(self:GetCurrentPlayer()) then
		self:ResetMovementSequence()
		self:MoveToPos(self:GetPos() + Vector(math.random(-512, 512), math.random(-512, 512), 0), {
			repath = 3,
			maxage = 5
		})
	end]]
end

function ENT:OnThink()
	local victim = self:GetCurrentPlayer()

	if CurTime() > self.ActTime then
		if self.Acting and !IsValid(self:GetCurrentZombie()) then
			self.Acting = false
			self:SetCurrentZombie(nil)
			self:TimeOut(1)
		end
		self.ActTime = CurTime() + 1
	end

	if IsValid(victim) and victim:Alive() then
		victim:NZThrasherVictim(0.5, victim)
		--victim:SetPos(self:EyePos()) -- This is by far the worst thing I've ever done.
		--victim:SetPos(LerpVector( 0.15, victim:GetPos(), self:EyePos() ))
	elseif IsValid(victim) and !victim:Alive() then
		victim:SetParent(nil)
		self:SetCurrentPlayer(nil)
	end
end

function ENT:RegenSpore()
	self.SporeCount = self.SporeCount - 1
	if !self.LegSpore then
		self.LegSpore = true
		self.LegSporeHp = 3500 / 10
		self:ManipulateBoneScale(self:LookupBone("tag_spore_leg"), Vector(1,1,1))
		return
	end
	if !self.ChestSpore then
		self.ChestSpore = true
		self.ChestSporeHp = 3500 / 10
		self:ManipulateBoneScale(self:LookupBone("tag_spore_chest"), Vector(1,1,1))
		return
	end
	if !self.BackSpore then
		self.BackSpore = true
		self.BackSporeHp = 3500 / 10
		self:ManipulateBoneScale(self:LookupBone("tag_spore_back"), Vector(1,1,1))
		return
	end
end

function ENT:OnInjured(dmginfo)
	if !self:Alive() then return end

	local hitpos = dmginfo:GetDamagePosition()
	local hitgroup = util.QuickTrace(dmginfo:GetDamagePosition(), dmginfo:GetDamagePosition()).HitGroup
	local hitforce = dmginfo:GetDamageForce()
	local damage = dmginfo:GetDamage()

	local attacker = dmginfo:GetAttacker()

	local leg = self:LookupBone("tag_spore_leg")
	local legpos = self:GetBonePosition(leg)

	local chest = self:LookupBone("tag_spore_chest")
	local chestpos = self:GetBonePosition(chest)

	local back = self:LookupBone("tag_spore_back")
	local backpos = self:GetBonePosition(back)

	if hitpos:DistToSqr(legpos) < 20^2 and self.LegSpore and CurTime() > self.IFrames then
		if self.LegSporeHp > 0 then
			self.LegSporeHp = self.LegSporeHp - damage
		else
			self.IFrames = CurTime() + 2
			self.EnrageTime = 0
			self.LegSpore = false
			self.SporeCount = self.SporeCount + 1

			self:ManipulateBoneScale(leg, Vector(0.00001,0.00001,0.00001))
			self:EmitSound(self.SporeExplodeSounds[math.random(#self.SporeExplodeSounds)], 511)

    		if IsValid(attacker) then
    			attacker:GivePoints(50)
    		end
    		timer.Simple(engine.TickInterval(), function()
				if self.SporeCount >= 3 then
					self:OnKilled(dmginfo)
				else
					self:TempBehaveThread(function(self)
						self:SetSpecialAnimation(true)
						self:SolidMaskDuringEvent(MASK_PLAYERSOLID, collision)
						self:PlaySequenceAndMove("nz_thrasher_stunned_v2", {gravity = true})
						self:CollideWhenPossible()
						self:SetSpecialAnimation(false) -- Stops them from going back to idle.
					end)
				end
			end)
		end
	end

	if hitpos:DistToSqr(chestpos) < 20^2 and self.ChestSpore and CurTime() > self.IFrames then
		if self.ChestSporeHp > 0 then
			self.ChestSporeHp = self.ChestSporeHp - damage
		else
			self.IFrames = CurTime() + 2
			self.EnrageTime = 0
			self.ChestSpore = false
			self.SporeCount = self.SporeCount + 1

			self:ManipulateBoneScale(chest, Vector(0.00001,0.00001,0.00001))
			ParticleEffect("bo3_thrasher_blood",chestpos, Angle(0,0,0), nil)
			self:EmitSound(self.SporeExplodeSounds[math.random(#self.SporeExplodeSounds)], 511)

    		if IsValid(attacker) then
    			attacker:GivePoints(50)
    		end
    		timer.Simple(engine.TickInterval(), function()
				if self.SporeCount >= 3 then
					self:OnKilled(dmginfo)
				else
					self:TempBehaveThread(function(self)
						self:SetSpecialAnimation(true)
						self:SolidMaskDuringEvent(MASK_PLAYERSOLID, collision)
						self:PlaySequenceAndMove("nz_thrasher_stunned_v1", {gravity = true})
						self:CollideWhenPossible()
						self:SetSpecialAnimation(false) -- Stops them from going back to idle.
					end)
				end
			end)
		end
	end

	if hitpos:DistToSqr(backpos) < 20^2 and self.BackSpore and CurTime() > self.IFrames then
		if self.BackSporeHp > 0 then
			self.BackSporeHp = self.BackSporeHp - damage
		else
			self.IFrames = CurTime() + 2
			self.EnrageTime = 0
			self.BackSpore = false
			self.SporeCount = self.SporeCount + 1

			self:ManipulateBoneScale(back, Vector(0.00001,0.00001,0.00001))
			ParticleEffect("bo3_thrasher_blood",backpos, Angle(0,0,0), nil)
			self:EmitSound(self.SporeExplodeSounds[math.random(#self.SporeExplodeSounds)], 511)

    		if IsValid(attacker) then
    			attacker:GivePoints(50)
    		end
    		timer.Simple(engine.TickInterval(), function()
				if self.SporeCount >= 3 then
					self:OnKilled(dmginfo)
				else
					self:TempBehaveThread(function(self)
						self:SetSpecialAnimation(true)
						self:SolidMaskDuringEvent(MASK_PLAYERSOLID, collision)
						self:PlaySequenceAndMove("nz_thrasher_stunned_v3", {gravity = true})
						self:CollideWhenPossible()
						self:SetSpecialAnimation(false) -- Stops them from going back to idle.
					end)
				end
			end)
		end
	end

	if !self.Enraged and math.random(100) < 25 then -- Have a chance of becoming enraged from just being shot.
		self.EnrageTime = 0
	end

	dmginfo:ScaleDamage(0.25)

end

function ENT:IsValidTarget( ent )
	if not ent then return false end
	return IsValid(ent) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
end

function ENT:CreateVinesIn()
	if !IsValid(self) then return end
	
	local vines = ents.Create("nz_ent_fx_thrasher_vines")
	vines:SetPos(self:GetPos())
	vines:SetAngles(self:GetAngles())

	vines:Spawn()

	vines:VinesIn() 
end

function ENT:CreateVinesOut()

	local vines = ents.Create("nz_ent_fx_thrasher_vines")
	vines:SetPos(self:GetPos())
	vines:SetAngles(self:GetAngles())

	vines:Spawn()
	
	vines:VinesOut()
end

function ENT:HandleAnimEvent(a,b,c,d,e) -- Moo Mark 4/14/23: You don't know how sad I am that I didn't know about this sooner.
	if e == "step_right_small" or e == "step_left_small" then
		self:EmitSound(self.StompSounds[math.random(#self.StompSounds)], 80, math.random(95,105))
		self:EmitSound("nz_moo/zombies/vox/_thrasher/fall_swt/fall_swt_0"..math.random(0,6)..".mp3", 80)
		util.ScreenShake(self:GetPos(),1,1,0.2,450)
	end
	if e == "step_right_large" or e == "step_left_large" then
		self:EmitSound(self.StompSounds[math.random(#self.StompSounds)], 80, math.random(95,105))
		self:EmitSound("nz_moo/zombies/vox/_thrasher/fall_swt/fall_swt_0"..math.random(0,6)..".mp3", 80)
		util.ScreenShake(self:GetPos(),1,1,0.2,450)
	end
	if e == "melee" or e == "melee_heavy" then
		if self:BomberBuff() and self.GasAttack then
			self:EmitSound(self.GasAttack[math.random(#self.GasAttack)], 100, math.random(95, 105), 1, 2)
		else
			if self.AttackSounds then
				self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2)
			end
		end
		if e == "melee_heavy" then
			self.HeavyAttack = true
		end
		self:DoAttackDamage()
	end
	if e == "melee_whoosh" then
		self:EmitSound("nz_moo/zombies/vox/_thrasher/swing/swing_0"..math.random(0,7)..".mp3", 90)
	end
	if e == "thrasher_fall" then
		self:EmitSound("nz_moo/zombies/vox/_thrasher/fall/fall_0"..math.random(0,3)..".mp3", 90)
		self:EmitSound("nz_moo/zombies/vox/_thrasher/fall_swt/fall_swt_0"..math.random(0,6)..".mp3", 90)
	end
	if e == "thrasher_grab" then
		if math.random(100) == 69  or comedyday then
			self:EmitSound("Thrasher_roar_laby.wav",511)
		end
		self:EmitSound("nz_moo/zombies/vox/_thrasher/grab/grab_0"..math.random(0,3)..".mp3", 90)
	end
	if e == "thrasher_pain" then
		self:EmitSound(self.PainSounds[math.random(#self.PainSounds)], 80, math.random(95,105), 1, 2)
	end
	if e == "thrasher_eat" then
		self:EmitSound(self.BiteSounds[math.random(#self.BiteSounds)], 80, math.random(95,105))
		ParticleEffectAttach("bo3_thrasher_blood", 4, self, 8)
	end
	if e == "thrasher_emerge" then
		ParticleEffect("bo3_zombie_spawn",self:GetPos()+Vector(0,0,1),Angle(0,0,0),nil)

		self:EmitSound("nz_moo/zombies/vox/_thrasher/teleport_in/tele_hand_up.mp3", 100, math.random(95,105))
		self:EmitSound("enemies/bosses/thrasher/teleport_in_01.ogg",511)
		self:EmitSound("enemies/bosses/thrasher/dst_rock_quake_0"..math.random(1,5)..".ogg",511)
		for i=1,1 do
			ParticleEffect("bo3_panzer_landing",self:LocalToWorld(Vector(20+(i*2),20,0)),Angle(0,0,0),nil)
		end
	end
	if e == "thrasher_burrow" then
		ParticleEffect("bo3_zombie_spawn",self:GetPos()+Vector(0,0,1),Angle(0,0,0),nil)

		self:EmitSound("nz_moo/zombies/vox/_thrasher/teleport_in/tele_hand_up.mp3", 100, math.random(95,105))
		self:EmitSound("enemies/bosses/thrasher/teleport_in_01.ogg",511)
		self:EmitSound("enemies/bosses/thrasher/dst_rock_quake_0"..math.random(1,5)..".ogg",511)
		for i=1,1 do
			ParticleEffect("bo3_panzer_landing",self:LocalToWorld(Vector(20+(i*2),20,0)),Angle(0,0,0),nil)
		end
	end
	if e == "thrasher_explode" then
		if IsValid(self) then

			ParticleEffect("bo3_margwa_death",self:LocalToWorld(Vector(0,0,0)),Angle(0,0,0),nil)
			self:Remove()
		end
	end
	if e == "start_traverse" then
		--print("starttraverse")
		self.TraversalAnim = true
	end
	if e == "finish_traverse" then
		--print("finishtraverse")
		self.TraversalAnim = false
	end
end

function ENT:OnRemove()
	if IsValid(self:GetCurrentPlayer()) then
		local ply = self:GetCurrentPlayer()
		ply:SetParent(nil)
		ply:SetNoDraw(false)
		ply:SetCollisionGroup(COLLISION_GROUP_PLAYER)
	end
end
