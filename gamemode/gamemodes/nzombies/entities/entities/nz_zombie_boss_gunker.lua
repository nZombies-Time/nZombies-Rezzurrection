AddCSLuaFile()

ENT.Base = "nz_zombiebase_moo"
ENT.PrintName = "BOOMER!"
ENT.Category = "Brainz"
ENT.Author = "Laby and GhostlyMoo"

--KILL HOMINID

if CLIENT then return end -- Client doesn't really need anything beyond the basics

ENT.SpeedBasedSequences = true
ENT.IsMooZombie = true
ENT.RedEyes = true
ENT.IsMooSpecial = true

ENT.AttackDamage = 75
ENT.AttackRange = 600
ENT.DamageRange = 590
ENT.TraversalCheckRange = 80

ENT.Models = {
	{Model = "models/bosses/loc_gunker.mdl", Skin = 0, Bodygroups = {0,0}},
}

local spawn = {"Emerge"}

ENT.DeathSequences = {
"Gunker_Death"
}


local AttackSequences = {
	{seq = "Gunker_Attack_Rtarm_StabFwd"},
	{seq = "Gunker_Attack_Rtarm_StabCoverFwd"},
}

ENT.BarricadeTearSequences = {
	--Leave this empty if you don't intend on having a special enemy use tear anims.
}

local walksounds = {
	Sound("enemies/bosses/gunker/ambi1.ogg"),
	Sound("enemies/bosses/gunker/ambi2.ogg"),
	Sound("enemies/bosses/gunker/ambi3.ogg"),
	Sound("enemies/bosses/gunker/ambi4.ogg"),
	Sound("enemies/bosses/gunker/ambi5.ogg"),
	Sound("enemies/bosses/gunker/ambi6.ogg"),
	Sound("enemies/bosses/gunker/ambi7.ogg"),
	Sound("enemies/bosses/gunker/ambi8.ogg"),
	Sound("enemies/bosses/gunker/ambi9.ogg"),
	Sound("enemies/bosses/gunker/ambi10.ogg"),
	Sound("enemies/bosses/gunker/ambi11.ogg"),
	Sound("enemies/bosses/gunker/ambi12.ogg"),
	Sound("enemies/bosses/gunker/ambi13.ogg"),
	Sound("enemies/bosses/gunker/ambi14.ogg"),
	Sound("enemies/bosses/gunker/ambi15.ogg")
}

ENT.AttackSounds = {
	"enemies/bosses/gunker/atk1.ogg",
	"enemies/bosses/gunker/atk2.ogg",
	"enemies/bosses/gunker/atk3.ogg",
	"enemies/bosses/gunker/atk4.ogg",
	"enemies/bosses/gunker/atk5.ogg",
}

ENT.PainSounds = {
	"nz/zombies/death/nz_flesh_impact_1.wav",
	"nz/zombies/death/nz_flesh_impact_2.wav",
	"nz/zombies/death/nz_flesh_impact_3.wav",
	"nz/zombies/death/nz_flesh_impact_4.wav"
}

ENT.DeathSounds = {
	"enemies/bosses/gunker/death_vox.ogg"
}

ENT.IdleSequence = "Gunker_Standing_Idle"

ENT.SequenceTables = {
	{Threshold = 0, Sequences = {
		{
			SpawnSequence = {spawn},
			MovementSequence = {
				"Gunker_Walk_Fwd",
			},
			AttackSequences = {AttackSequences},
			JumpSequences = {JumpSequences},
			PassiveSounds = {walksounds},
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
		
		self.NextAction = 0
		self:SetMooSpecial(true)
		self:SetRunSpeed( 20 )
		self.loco:SetDesiredSpeed( 20 )
		self:SetCollisionBounds(Vector(-32,-32, 0), Vector(32, 32, 130))
	end
end

function ENT:OnSpawn()

	self:SolidMaskDuringEvent(MASK_SOLID_BRUSHONLY)
	self:EmitSound("enemies/bosses/gunker/spawn"..math.random(1,3)..".ogg",511)
	
	ParticleEffect("bo3_zombie_spawn",self:GetPos()+Vector(0,0,1),Angle(0,0,0),nil)
	ParticleEffect("bo3_panzer_landing",self:LocalToWorld(Vector(20,20,0)),Angle(0,0,0),nil)
	self:SetInvulnerable(true)
	self:EmitSound("enemies/bosses/thrasher/dst_rock_quake_0"..math.random(1,5)..".ogg",511)
	ParticleEffectAttach("hcea_flood_runner_death",PATTACH_ABSORIGIN_FOLLOW,self,0)
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
		if IsValid(self) then
			self:DoDeathAnimation()
		end

end

function ENT:DoDeathAnimation(seq)
	self.BehaveThread = coroutine.create(function()
	self:PlaySound(self.DeathSounds[math.random(#self.DeathSounds)], 90, math.random(85, 105), 1, 2)
		self:EmitSound("enemies/bosses/gunker/imgonnabust.ogg",80,100)
		self:PlaySequenceAndWait("Gunker_Death")
	end)
end

function ENT:OnPathTimeOut()
	--local PhaseShoot = math.random(2) -- A chance to either Shoot a Plasma Ball or Teleport.
	local target = self:GetTarget()
	if CurTime() < self.NextAction then return end
	if !self:IsAttackBlocked() then
			-- Ranged Attack/Plasma Ball or Gas Ball
			if target:IsPlayer() then
				self:EmitSound("enemies/bosses/gunker/gunk"..math.random(1,5)..".ogg",80,math.random(95,100))
				self:PlaySequenceAndMove("Gunker_Attack_Ltarm_ShortFwd", 1, self.FaceEnemy)
				self.NextAction = CurTime() + math.random(10, 20)
			end
	end
end


function ENT:OnTargetInAttackRange()
		if !self:GetBlockAttack()  then
		  self:Attack()
		  
		else
			self:TimeOut(2)
		end
		end

function ENT:Bust()
    	local dmg = 250

    	if SERVER then
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

        	for k, v in pairs(ents.FindInSphere(pos, 500)) do
            	if v:IsPlayer() or v:IsNPC() or v:IsNextBot() then
                	if v:GetClass() == self:GetClass() then continue end
                	if v == self then continue end
                	if v:EntIndex() == self:EntIndex() then continue end
                	if v:Health() <= 0 then continue end

                	tr.endpos = v:WorldSpaceCenter()
                	local tr1 = util.TraceLine(tr)
                	if tr1.HitWorld then continue end

                	local expdamage = DamageInfo()
                	expdamage:SetAttacker(attacker)
                	expdamage:SetInflictor(inflictor)
                	expdamage:SetDamageType(DMG_BLAST)

                	local distfac = pos:Distance(v:WorldSpaceCenter())
                	distfac = 1 - math.Clamp((distfac/200), 0, 1)
                	expdamage:SetDamage(dmg * distfac)

					
                	v:TakeDamageInfo(expdamage)
            	end
        	end
			self:Remove()

        	util.ScreenShake(self:GetPos(), 20, 255, 1.5, 400)
    	end

    	-- Hate.
    	--if self:Alive() then self:TakeDamage(self:Health() + 666, self, self) end
		
	end
	
function ENT:HandleAnimEvent(a,b,c,d,e)
	if e == "melee" then
		self:EmitSound("enemies/bosses/gunker/arm"..math.random(1,3)..".ogg",80,math.random(95,100))
		if !self:IsAttackBlocked() then
		self:DoAttackDamage()
		else
		self:UpdateAttackRange()
		--self:SetBlockAttack(true)
		--		timer.Simple(5, function()
		--if IsValid(self) then
		--self:SetBlockAttack(false)
		--end
	--end)
		end
	end
	if e == "gunk_step" then
		self:EmitSound("enemies/bosses/gunker/step"..math.random(1,3)..".ogg",80,math.random(95,100))
		util.ScreenShake(self:GetPos(),100000,500000,0.2,1000)
	end
	if e == "bakudan_gunk" then
	self:PlaySound("enemies/bosses/gunker/death"..math.random(1,4)..".ogg", 90, math.random(85, 105), 1, 2)
	self:PlaySound("enemies/bosses/gunker/death_gore"..math.random(1,2)..".ogg", 90, math.random(85, 105), 1, 2)
	util.ScreenShake(self:GetPos(),100,200,1,1000)
					ParticleEffect("npc_gearsofwar_loc_gunker_explosion",self:GetPos() +self:OBBCenter(),Angle(0,0,0),nil)
					print("i came")
		self:Bust()
	end
	if e == "lordhavemercy" then
	local target = self:GetTarget()
	local tr = util.TraceLine({
			start = self:GetPos() + Vector(0,50,0),
			endpos = self:GetTarget():GetPos() + Vector(0,0,50),
			filter = self,
		})
	self:EmitSound("enemies/bosses/gunker/throw.ogg", 95, math.random(95,105))
		local clawpos = self:GetBonePosition(self:LookupBone( "L_Hand_Claw_Main_2" ))
		--obj_gearsofwar_boomshot_projectile
				self.ClawHook = ents.Create("nz_gunkshot")
				self.ClawHook:SetPos(clawpos)
				self.ClawHook:Spawn()
				self.ClawHook:Launch(((tr.Entity:GetPos() + Vector(0,0,50)) - self.ClawHook:GetPos()):GetNormalized())
				self:SetAngles((target:GetPos() - self:GetPos()):Angle())
	end 

end





-- A standard attack you can use it or create something fancy yourself

function ENT:IsValidTarget( ent )
	if not ent then return false end
	return IsValid( ent ) and ent:GetTargetPriority() ~= TARGET_PRIORITY_NONE and ent:GetTargetPriority() ~= TARGET_PRIORITY_MONSTERINTERACT and ent:GetTargetPriority() ~= TARGET_PRIORITY_SPECIAL and ent:GetTargetPriority() ~= TARGET_PRIORITY_FUNNY
end