ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.PrintName = "Nova Bomber Shot"
ENT.Author = "GhostlyMoo"

ENT.Spawnable = false
ENT.AdminSpawnable = false

if SERVER then
	AddCSLuaFile()
end

function ENT:Initialize()
	if SERVER then
		self:SetModel("models/weapons/w_eq_fraggrenade.mdl") -- Change later
		self:SetNoDraw(true)
		ParticleEffectAttach("spore_trail",PATTACH_ABSORIGIN_FOLLOW,self,0)
		self:PhysicsInit(SOLID_OBB)
		self:SetSolid(SOLID_NONE)
		self:SetTrigger(true)
		self:UseTriggerBounds(true, 0)
		self:SetMoveType(MOVETYPE_FLY)

		phys = self:GetPhysicsObject()

		if phys and phys:IsValid() then
			phys:Wake()
		end
	end
end

function ENT:Launch(dir)
	self:SetLocalVelocity(dir * 1750)
	self:SetAngles((dir*-1):Angle())
end

function ENT:StartTouch(ent)
	if (!ent.IsMooZombie or ent.IsMooSpecial) and !ent:IsWorld() then return end

    if SERVER then
        local pos = self:WorldSpaceCenter()

        local tr = {
            start = pos,
            filter = self,
            mask = MASK_NPCSOLID_BRUSHONLY
        }

        for k, v in pairs(ents.FindInSphere(pos, 150)) do
            local expdamage = DamageInfo()
            expdamage:SetDamageType(DMG_POISON)

            expdamage:SetAttacker(self)
            expdamage:SetDamage(0)
            expdamage:SetDamageForce(v:GetUp()*5000 + (v:GetPos() - self:GetPos()):GetNormalized() * 10000)

            if IsValid(v) and v.IsMooZombie and !v.IsMooSpecial then
            	v:SetRunSpeed(250)
				v.loco:SetDesiredSpeed( v:GetRunSpeed() )
				v:SetHealth( nzRound:GetZombieHealth() * 2 )
				v:SpeedChanged()
				v:SetBomberBuff(true)
			end
        end

		if IsValid(self) then ParticleEffectAttach("hcea_flood_runner_death", 3, self, 2) end
		self:EmitSound("nz_moo/zombies/vox/_quad/gas_cloud/cloud_0"..math.random(0,3)..".mp3")
        util.ScreenShake(self:GetPos(), 20, 255, 0.5, 100)

		self:Remove()
	end
end


function ENT:Think()
end

function ENT:OnRemove()
end
