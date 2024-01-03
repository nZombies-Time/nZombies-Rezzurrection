ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Jolting Jack Shot"
ENT.Author = "GhostlyMoo"

ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
	AddCSLuaFile()
end

ENT.PulseSounds = {
	Sound("nz_moo/zombies/vox/_raz/mangler/pop/pulse_00.mp3"),
	Sound("nz_moo/zombies/vox/_raz/mangler/pop/pulse_01.mp3"),
	Sound("nz_moo/zombies/vox/_raz/mangler/pop/pulse_02.mp3"),
	Sound("nz_moo/zombies/vox/_raz/mangler/pop/pulse_03.mp3"),
}

ENT.ImpSounds = {
	Sound("nz_moo/zombies/vox/_raz/mangler/imp/imp_00.mp3"),
	Sound("nz_moo/zombies/vox/_raz/mangler/imp/imp_01.mp3"),
	Sound("nz_moo/zombies/vox/_raz/mangler/imp/imp_02.mp3"),
	Sound("nz_moo/zombies/vox/_raz/mangler/imp/imp_03.mp3"),
}

function ENT:Initialize()
	if SERVER then
		self:SetModel("models/dav0r/hoverball.mdl")
		self:SetNoDraw(true)
		ParticleEffectAttach("bo3_mangler_pulse",PATTACH_ABSORIGIN_FOLLOW,self,0)
		
		self:PhysicsInit(SOLID_OBB)
		self:SetSolid(SOLID_NONE)
		self:SetTrigger(true)
		self:UseTriggerBounds(true, 0)
		self:SetMoveType(MOVETYPE_FLY)

		phys = self:GetPhysicsObject()

		self.NextPulse = 0

		if phys and phys:IsValid() then
			phys:Wake()
		end
	end
end

function ENT:Launch(dir)
	self:SetLocalVelocity(dir * 950)
	self:SetAngles((dir*-1):Angle())
end

function ENT:StartTouch(ent)
	if !ent:IsWorld() and (!ent:IsPlayer() or ent.IsMooZombie) then return end

    local dmg = 90

    if SERVER then
        local pos = self:WorldSpaceCenter()

        local tr = {
            start = pos,
            filter = self,
            mask = MASK_NPCSOLID_BRUSHONLY
        }

        for k, v in pairs(ents.FindInSphere(pos, 50)) do
            local expdamage = DamageInfo()
            expdamage:SetDamageType(DMG_SHOCK)

            local distfac = pos:Distance(v:WorldSpaceCenter())
            distfac = 1 - math.Clamp((distfac/50), 0, 1)

            expdamage:SetAttacker(self)
            expdamage:SetDamage(dmg * distfac)
            expdamage:SetDamageForce(v:GetUp()*5000 + (v:GetPos() - self:GetPos()):GetNormalized() * 10000)

            if v:IsPlayer() then
                v:TakeDamageInfo(expdamage)
				v:NZSonicBlind(1)
            end
        end

        local effectdata = EffectData()
        effectdata:SetOrigin(self:GetPos())

        --util.Effect("Explosion", effectdata)
        util.ScreenShake(self:GetPos(), 20, 255, 0.5, 100)

		self:EmitSound(self.ImpSounds[math.random(#self.ImpSounds)], 577, math.random(95,105))
		ParticleEffectAttach("bo3_mangler_blast",PATTACH_ABSORIGIN,self,0)
		ParticleEffect("bo3_mangler_blast",self:GetPos()+Vector(0,0,1),self:GetAngles(),self)

		self:Remove()
	end
end


function ENT:Think()

	if SERVER then
		if CurTime() > self.NextPulse then
			self:EmitSound(self.PulseSounds[math.random(#self.PulseSounds)], 75, math.random(95,105))
			ParticleEffectAttach("bo3_mangler_blast_wave",PATTACH_ABSORIGIN_FOLLOW,self,0)

			self.NextPulse = CurTime() + 0.25
		end
	end

	self:NextThink(CurTime())
	return true
end

function ENT:OnRemove()
end
