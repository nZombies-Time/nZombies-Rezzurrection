AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "Brutus"
ENT.Category = "Brainz"
ENT.Author = "GhostlyMoo"

function ENT:InitDataTables()
	self:NetworkVar("Bool", 5, "Helmet")
end

function ENT:Draw()
	self:DrawModel()

	if self.RedEyes and self:Alive() and !self:GetDecapitated() and !self:GetMooSpecial() and !self.IsMooSpecial then
		self:DrawEyeGlow() 
		self:Lamp()
	end

	if GetConVar( "nz_zombie_debug" ):GetBool() then
		render.DrawWireframeBox(self:GetPos(), Angle(0,0,0), self:OBBMins(), self:OBBMaxs(), Color(255,0,0), true)
	end
end

function ENT:DrawEyeGlow()
	local eyeglow =  Material("nz_moo/sprites/moo_glow1")
	local eyeColor = Color(255,0,0)
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

function ENT:Lamp()

	local lightglow = Material( "sprites/physg_glow1_noz" )
	local lightyellow = Color( 255, 255, 200, 200 )
	local bone = self:LookupAttachment("spotlight_fx_tag")
	local spotlight = self:GetAttachment(bone)
	local pos, ang = spotlight.Pos, spotlight.Ang	
	local lightglow = Material( "sprites/physg_glow1_noz" )
	local lightyellow = Color( 255, 255, 200, 200 )
	local finalpos = pos

	cam.Start3D2D(finalpos, ang, 1)
		surface.SetAlphaMultiplier(1)
		surface.SetMaterial(lightglow)
		surface.SetDrawColor(lightyellow)
		surface.DrawTexturedRect(-25,-10,100,20)
	cam.End3D2D()
	
	ang:RotateAroundAxis(ang:Forward(),90)

	cam.Start3D2D(finalpos, ang, 1)
		surface.SetAlphaMultiplier(1)
		surface.SetMaterial(lightglow)
		surface.SetDrawColor(lightyellow)
		surface.DrawTexturedRect(-25,-10,100,20)
	cam.End3D2D()
end

if CLIENT then return end

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true
ENT.IsMooSpecial = true

ENT.AttackRange = 95
ENT.DamageRange = 95
ENT.AttackDamage = 85

ENT.TraversalCheckRange = 80

ENT.Models = {
	{Model = "models/moo/_codz_ports/t8/escape/moo_codz_t8_mob_warden.mdl", Skin = 0, Bodygroups = {0,0}},
}

ENT.DeathSequences = {
	"nz_brutus_death",
	"nz_brutus_death_a"
}

local JumpSequences = {
	{seq = "nz_brutus_mantle"},
}

local NormalAttackSequences = {
	{seq = "nz_brutus_attack_1"},
	{seq = "nz_brutus_attack_2"},
	{seq = "nz_brutus_attack_3"},
	{seq = "nz_brutus_attack_swingleft"},
}

local GroundSlamSequences = {
	{seq = "nz_brutus_ground_slam"},
}

local LockPerkSequences = {
	{seq = "nz_brutus_lock_perkmachine"},
}

local LockBoxSequences = {
	{seq = "nz_brutus_lock_magicbox"},
}

local BreakBarricadeSequences = {
	{seq = "nz_brutus_boardsmash_a"},
	{seq = "nz_brutus_boardsmash_b"},
	{seq = "nz_brutus_boardsmash_c"},
}

local ClimbUp36 = {
	"nz_brutus_climbup36"
}
local ClimbUp48 = {
	"nz_brutus_climbup48"
}
local ClimbUp72 = {
	"nz_brutus_climbup72"
}
local ClimbUp96 = {
	"nz_brutus_climbup96"
}
local ClimbUp128 = {
	"nz_brutus_climbup128"
}
local ClimbUp160 = {
	"nz_brutus_climbup160"
}

local walksounds = {
	Sound("nz_moo/zombies/vox/_cellbreaker/amb/vox_amb_00.mp3"),
	Sound("nz_moo/zombies/vox/_cellbreaker/amb/vox_amb_01.mp3"),
	Sound("nz_moo/zombies/vox/_cellbreaker/amb/vox_amb_02.mp3"),
	Sound("nz_moo/zombies/vox/_cellbreaker/amb/vox_amb_03.mp3"),
	Sound("nz_moo/zombies/vox/_cellbreaker/amb/vox_amb_04.mp3"),
}

ENT.AttackSounds = {
	"nz_moo/zombies/vox/_cellbreaker/attack/vox_attack_00.mp3",
	"nz_moo/zombies/vox/_cellbreaker/attack/vox_attack_01.mp3",
	"nz_moo/zombies/vox/_cellbreaker/attack/vox_attack_02.mp3",
	"nz_moo/zombies/vox/_cellbreaker/attack/vox_attack_03.mp3",
	"nz_moo/zombies/vox/_cellbreaker/attack/vox_attack_04.mp3",
}

ENT.DeathSounds = {
	"nz_moo/zombies/vox/_cellbreaker/death/vox_death_00.mp3",
	"nz_moo/zombies/vox/_cellbreaker/death/vox_death_01.mp3",
	"nz_moo/zombies/vox/_cellbreaker/death/vox_death_02.mp3",
	"nz_moo/zombies/vox/_cellbreaker/death/vox_death_03.mp3",
	"nz_moo/zombies/vox/_cellbreaker/death/vox_death_04.mp3",
	"nz_moo/zombies/vox/_cellbreaker/death/vox_death_05.mp3",
}

ENT.AppearSounds = {
	"nz_moo/zombies/vox/_cellbreaker/spawn/vox_laugh_00.mp3",
	"nz_moo/zombies/vox/_cellbreaker/spawn/vox_laugh_01.mp3",
	"nz_moo/zombies/vox/_cellbreaker/spawn/vox_laugh_02.mp3",
	"nz_moo/zombies/vox/_cellbreaker/spawn/vox_laugh_03.mp3",
	"nz_moo/zombies/vox/_cellbreaker/spawn/vox_laugh_04.mp3",
	"nz_moo/zombies/vox/_cellbreaker/spawn/vox_laugh_05.mp3",
	"nz_moo/zombies/vox/_cellbreaker/spawn/vox_laugh_06.mp3",
}

ENT.SlamSounds = {
	"nz_moo/zombies/vox/_cellbreaker/slam/vox_slam_yell_00.mp3",
	"nz_moo/zombies/vox/_cellbreaker/slam/vox_slam_yell_01.mp3",
	"nz_moo/zombies/vox/_cellbreaker/slam/vox_slam_yell_02.mp3",
	"nz_moo/zombies/vox/_cellbreaker/slam/vox_slam_yell_03.mp3",
	"nz_moo/zombies/vox/_cellbreaker/slam/vox_slam_yell_04.mp3",
	"nz_moo/zombies/vox/_cellbreaker/slam/vox_slam_yell_05.mp3",
}

ENT.YellSounds = {
	"nz_moo/zombies/vox/_cellbreaker/yell/vox_helmet_yell_00.mp3",
	"nz_moo/zombies/vox/_cellbreaker/yell/vox_helmet_yell_01.mp3",
	"nz_moo/zombies/vox/_cellbreaker/yell/vox_helmet_yell_02.mp3",
	"nz_moo/zombies/vox/_cellbreaker/yell/vox_helmet_yell_03.mp3",
}

ENT.IdleSequence = "nz_brutus_idle"

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"nz_brutus_walk",
			},
			AttackSequences = {NormalAttackSequences},
			LockPerkSequences = {LockPerkSequences},
			LockBoxSequences = {LockBoxSequences},
			BreakBarricadeSequences = {BreakBarricadeSequences},
			NormalAttackSequences = {NormalAttackSequences},
			StandAttackSequences = {GroundSlamSequences},
			JumpSequences = {JumpSequences},
			Climb36 = {ClimbUp36},
			Climb48 = {ClimbUp48},
			Climb72 = {ClimbUp72},
			Climb96 = {ClimbUp96},
			Climb120 = {ClimbUp128},
			Climb160 = {ClimbUp160},
		},
	}},
	{Threshold = 36, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"nz_brutus_run",
			},
			AttackSequences = {NormalAttackSequences},
			LockPerkSequences = {LockPerkSequences},
			LockBoxSequences = {LockBoxSequences},
			BreakBarricadeSequences = {BreakBarricadeSequences},
			NormalAttackSequences = {NormalAttackSequences},
			StandAttackSequences = {GroundSlamSequences},
			JumpSequences = {JumpSequences},
			Climb36 = {ClimbUp36},
			Climb48 = {ClimbUp48},
			Climb72 = {ClimbUp72},
			Climb96 = {ClimbUp96},
			Climb120 = {ClimbUp128},
			Climb160 = {ClimbUp160},
		},
	}},
	{Threshold = 71, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"nz_brutus_sprint",
			},
			AttackSequences = {NormalAttackSequences},
			LockPerkSequences = {LockPerkSequences},
			LockBoxSequences = {LockBoxSequences},
			BreakBarricadeSequences = {BreakBarricadeSequences},
			NormalAttackSequences = {NormalAttackSequences},
			StandAttackSequences = {GroundSlamSequences},
			JumpSequences = {JumpSequences},
			Climb36 = {ClimbUp36},
			Climb48 = {ClimbUp48},
			Climb72 = {ClimbUp72},
			Climb96 = {ClimbUp96},
			Climb120 = {ClimbUp128},
			Climb160 = {ClimbUp160},
		},
	}}
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

		self.HelmetDamage = 0
		self:SetHelmet(true)

		self.Angered = false

		self.GeneralDestruction = false
		self.PerkDestruction = false
		self.BoxDestruction = false
		self.BarricadeDestruction = false
		self.EntDestruction = false

		self.NextAI = 0
		self.DestructionCoolDown = CurTime() + 10

		self:SetRunSpeed( 36 )
		self:SetBodygroup(2,0)
		self:SetBodygroup(3,0)
	end
end

function ENT:OnSpawn()
	self:SetCollisionBounds(Vector(-14,-14, 0), Vector(14, 14, 72))
	self:SetSurroundingBounds(Vector(-30, -30, 0), Vector(30, 30, 80))

	self:SetNoDraw(true)
	self:SetInvulnerable(true)
	self:SetBlockAttack(true)
	self:SolidMaskDuringEvent(MASK_PLAYERSOLID)

	--self:EmitSound("nz_moo/zombies/vox/_cellbreaker/spawn_2d.mp3",511)

	self:TimeOut(3.75)
	
	self:SetNoDraw(false)
	self:EmitSound("nz_moo/zombies/vox/_cellbreaker/spawn_lightning.mp3",100,math.random(95,105))
	ParticleEffectAttach("ins_skybox_lightning",PATTACH_ABSORIGIN_FOLLOW,self,0)
	ParticleEffect("dusty_explosion_rockets",self:GetPos(),self:GetAngles(),nil)
	util.ScreenShake(self:GetPos(),10000,5000,2,999000)
	
	self:SetInvulnerable(nil)
	self:SetBlockAttack(false)
	self:CollideWhenPossible()
	self:EmitSound(self.AppearSounds[math.random(#self.AppearSounds)], 511)
end

function ENT:PerformDeath(dmgInfo)
	self:SetBodygroup(3,1)
	self:EmitSound("nz_moo/zombies/vox/_cellbreaker/death_lightning.mp3", 511, math.random(95,105))
	ParticleEffectAttach("driese_tp_arrival_ambient",PATTACH_ABSORIGIN,self,0)
	if self:GetSpecialAnimation() then
		self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
		self:BecomeRagdoll(dmgInfo)
	else
		self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
		self:DoDeathAnimation(self.DeathSequences[math.random(#self.DeathSequences)])
	end
end

function ENT:AI()
	if !self:Alive() then return end
	if CurTime() > self.NextAI then
		if !self.GeneralDestruction then
			local roll = math.random(4)
			if roll == 1 then
				for k,v in nzLevel.GetVultureArray() do //cheeky innit?
					if not IsValid(v) then continue end
					if v:GetClass() ~= "perk_machine" then continue end

					local d = self:GetRangeTo(v)
					self.GeneralDestruction = true
					if d < 350 then
						if v:IsOn() and !v:GetBrutusLocked() then
							self.PerkDestruction = true
						else
							self.GeneralDestruction = false
						end
					else
						self.GeneralDestruction = false
					end
				end
			elseif roll == 2 then
				for k,v in nzLevel.GetVultureArray() do
					if not IsValid(v) then continue end
					if v:GetClass() ~= "random_box" then continue end

					local d = self:GetRangeTo(v)
					self.GeneralDestruction = true
					if d < 350 then
						if v:GetActivated() and !v:GetOpen() and !v.Moving then
							self.BoxDestruction = true
						else
							self.GeneralDestruction = false
						end
					else
						self.GeneralDestruction = false
					end
				end
			elseif roll == 3 then
				for k,v in nzLevel.GetBrutusEntityArray() do //ents with a specific bool
					if not IsValid(v) or v:GetNoDraw() then continue end

					if v.BrutusDestructable then
						local d = self:GetRangeTo(v)
						self.GeneralDestruction = true
						if d < 350 then
							if !v:GetBrutusLocked() then
								self.EntDestruction = true
							else
								self.GeneralDestruction = false
							end
						else
							self.GeneralDestruction = false
						end
					end
				end
			end
		end
		self.NextAI = CurTime() + 0.5
	end
end

function ENT:OnInjured( dmgInfo )

	local hitgroup = util.QuickTrace(dmgInfo:GetDamagePosition(), dmgInfo:GetDamagePosition()).HitGroup
	local hitpos = dmgInfo:GetDamagePosition()
	local head = self:LookupBone("j_head")
	
	if self:GetHelmet() then
		if head and hitgroup == HITGROUP_HEAD then
			self.HelmetDamage = self.HelmetDamage + dmgInfo:GetDamage()
			if self.HelmetDamage > (self:GetMaxHealth() * 0.1) then
				self:LoseHelmet()
			end
		end
		dmgInfo:ScaleDamage(0.15)
	else
		if head and hitgroup ~= HITGROUP_HEAD then
			-- No damage scaling on headshot, we keep it at 1x
		else
			dmgInfo:ScaleDamage(0.2) 
		end
	end
end

function ENT:LoseHelmet()
	self:SetHelmet(false)
	self:SetBodygroup(2,1)
	self:EmitSound("nz_moo/zombies/vox/_cellbreaker/helmet_ping.mp3",511, 100)
	self:EmitSound("nz_moo/zombies/vox/_cellbreaker/helmet_flux.mp3",100, 100)
	self:EmitSound(self.YellSounds[math.random(#self.YellSounds)], 100, math.random(85, 105), 1, 2)

	util.ScreenShake(self:GetPos(), 10, 255, 1, 150)
	self:EmitSound("nz_moo/zombies/vox/_cellbreaker/smoke_grenade/smoke_primendrop_0"..math.random(0,1)..".mp3")
	self:EmitSound("nz_moo/zombies/vox/_cellbreaker/smoke_grenade/smoke.mp3")
	ParticleEffectAttach("ins_m203_smokegrenade",PATTACH_POINT,self,1)

	self:SetRunSpeed(72)
	self:SpeedChanged()
end

function ENT:PostTookDamage(dmginfo) end

function ENT:OnRemove() end

function ENT:IsValidTarget( ent )
	if not ent then return false end
	if self.EntDestruction then return IsValid(ent) and ent.BrutusDestructable and !ent:GetBrutusLocked() end
	if self.PerkDestruction then return IsValid(ent) and ent:GetClass() == "perk_machine" and !ent:GetBrutusLocked() end
	if self.BoxDestruction then return IsValid(ent) and ent:GetClass() == "random_box" end
	return IsValid(ent) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
end

function ENT:HasHelmet() return self:GetHelmet() end

function ENT:HandleAnimEvent(a,b,c,d,e) -- Moo Mark 4/14/23: You don't know how sad I am that I didn't know about this sooner.
	if e == "melee" then
		self:EmitSound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2)
		self:DoAttackDamage()
	end
	if e == "death_ragdoll" then
		self:BecomeRagdoll(DamageInfo())
	end
	if e == "start_traverse" then
		--print("starttraverse")
		self.TraversalAnim = true
	end
	if e == "finish_traverse" then
		--print("finishtraverse")
		self.TraversalAnim = false
	end

	if e == "melee_whoosh" then
		self:EmitSound("nz_moo/zombies/vox/_cellbreaker/attack/swing/swing_0"..math.random(0,4)..".mp3",80)
	end
	if e == "ground_slam" then
		local target = self:GetTarget()
		self:EmitSound(self.SlamSounds[math.random(#self.SlamSounds)], 100, math.random(85, 105), 1, 2)
		self:EmitSound("nz_moo/zombies/vox/_cellbreaker/slam/initial_zap_0"..math.random(0,3)..".mp3",100)
		self:EmitSound("nz_moo/zombies/vox/_cellbreaker/slam/rubble_0"..math.random(0,3)..".mp3",100,math.random(95,105))
		ParticleEffect("driese_tp_arrival_phase2",self:LocalToWorld(Vector(60,-30,0)),Angle(0,0,0),nil)
		ParticleEffect("driese_tp_arrival_ambient",self:LocalToWorld(Vector(60,-30,0)),Angle(0,0,0),nil)
		util.ScreenShake(self:GetPos(),10000,5000,1,1000)
		self:DoAttackDamage()

		if target:IsPlayer() and self:TargetInRange(115) then
			target:NZSonicBlind(3)
		end

		for k,v in nzLevel.GetZombieArray() do
			if IsValid(v) and !v:GetSpecialAnimation() and v.IsMooZombie and !v.Non3arcZombie and !v.IsMooSpecial and v ~= self then
				if self:GetRangeTo( v:GetPos() ) < 10^2 then	
					if v.IsMooZombie and !v.IsMooSpecial and !v:GetSpecialAnimation() then
						if v.PainSequences then
							v:DoSpecialAnimation(v.PainSequences[math.random(#v.PainSequences)], true, true)
						end
					end
				end
			end
		end
	end
	--[[if e == "board_smash" then
		local barricade = self:GetTarget()
		if IsValid(barricade) then
			barricade:FullBreak()
			self.BarricadeDestruction = false
			self.GeneralDestruction = false
			self:EmitSound("nz_moo/zombies/vox/_cellbreaker/destruction/barricade_smash_0"..math.random(0,4)..".mp3",100)
			self.DestructionCoolDown = CurTime() + 10
		end
	end]]
	if e == "lock_perk" then
		local perk = self:GetTarget()
		if IsValid(perk) then
			perk:OnBrutusLocked()
			self.EntDestruction = false
			self.PerkDestruction = false
			self.GeneralDestruction = false
			self:EmitSound("nz_moo/zombies/vox/_cellbreaker/lock.mp3",100)
			--self.DestructionCoolDown = CurTime() + 10
		end
	end
	if e == "lock_box" then
		local box = self:GetTarget()
		if IsValid(box) then
			box:MoveAway()
			self.BoxDestruction = false
			self.GeneralDestruction = false
			self:EmitSound("nz_moo/zombies/vox/_cellbreaker/lock.mp3",100)
			--self.DestructionCoolDown = CurTime() + 10
		end
	end
	if e == "lstep" then
		self:EmitSound("nz_moo/zombies/vox/_cellbreaker/fly/step/step_0"..math.random(0,5)..".mp3",80,math.random(95,100))
		self:EmitSound("nz_moo/zombies/vox/_cellbreaker/fly/keys/rattle_0"..math.random(0,4)..".mp3",80,math.random(95,100))
		util.ScreenShake(self:GetPos(),100000,500000,0.2,1000)
		ParticleEffectAttach("brutus_burning_footstep",PATTACH_POINT,self,11)
	end
	if e == "rstep" then
		self:EmitSound("nz_moo/zombies/vox/_cellbreaker/fly/step/step_0"..math.random(0,5)..".mp3",80,math.random(95,100))
		self:EmitSound("nz_moo/zombies/vox/_cellbreaker/fly/keys/rattle_0"..math.random(0,4)..".mp3",80,math.random(95,100))
		util.ScreenShake(self:GetPos(),100000,500000,0.2,1000)
		ParticleEffectAttach("brutus_burning_footstep",PATTACH_POINT,self,12)
	end
end

function ENT:Attack( data )
	self:SetLastAttack(CurTime())

	local useswalkframes = false

	data = data or {}
			
	data.attackseq = data.attackseq
	if !data.attackseq then

		local attacktbl = self.AttackSequences

		self:SetStandingAttack(false)

		if self.PerkDestruction then
			attacktbl = self.LockPerkSequences
		elseif self.BoxDestruction then
			attacktbl = self.LockBoxSequences
		elseif self.BarricadeDestruction then
			attacktbl = self.BreakBarricadeSequences
		elseif self.EntDestruction then
			attacktbl = self.LockPerkSequences
		end

		if self:GetTarget():GetVelocity():LengthSqr() < 175 and self.Target:IsPlayer() and !self.IsTurned then
			if self.StandAttackSequences then
				attacktbl = self.StandAttackSequences
			end
			self:SetStandingAttack(true)
		end

		local target = type(attacktbl) == "table" and attacktbl[math.random(#attacktbl)] or attacktbl

		if type(target) == "table" then
			local id, dur = self:LookupSequenceAct(target.seq)
			if target.dmgtimes then
				data.attackseq = {seq = id, dmgtimes = target.dmgtimes }
				useswalkframes = false
			else
				data.attackseq = {seq = id} -- Assume that if the selected sequence isn't using dmgtimes, its probably using notetracks.
				useswalkframes = true
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
		if data.attackseq.dmgtimes then
			for k,v in pairs(data.attackseq.dmgtimes) do
				self:TimedEvent( v, function()
					if self.AttackSounds then self:PlaySound(self.AttackSounds[math.random(#self.AttackSounds)], 100, math.random(85, 105), 1, 2) end
					self:EmitSound("nz_moo/zombies/fly/attack/whoosh/zmb_attack_med_0"..math.random(0,2)..".mp3", 75)
					self:DoAttackDamage()
				end)
			end
		end
	end

	self:TimedEvent(data.attackdur, function()
		self:SetAttacking(false)
		self:SetLastAttack(CurTime())
	end)

	if useswalkframes then
		self:PlaySequenceAndMove(data.attackseq.seq, 1, self.FaceEnemy)
	else
		self:PlayAttackAndWait(data.attackseq.seq, 1)
	end
end
