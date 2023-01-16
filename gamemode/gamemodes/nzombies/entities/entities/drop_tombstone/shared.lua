AddCSLuaFile()

ENT.Type = "anim"
 
ENT.PrintName		= "drop_tombstone"
ENT.Author			= "Zet0r"
ENT.Contact			= "Don't"
ENT.Purpose			= ""
ENT.Instructions	= ""

ENT.LoopSound = Sound("nz_moo/powerups/powerup_lp_zhd.mp3")

function ENT:SetupDataTables()

	self:NetworkVar( "Entity", 0, "PerkOwner" )
	
end

function ENT:Initialize()
	if SERVER then
	self:SetModel("models/props_c17/gravestone003a.mdl")
	
	self:PhysicsInitSphere(60, "default_silent")
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_NONE)

		self:SetTrigger(true)
		self:SetUseType(SIMPLE_USE)

		self:UseTriggerBounds(true, 30)

		-- Move up from ground
		local tr = util.TraceLine({
			start = self:GetPos(),
			endpos = self:GetPos() - Vector(0,0,40),
			filter = self,
			mask = MASK_SOLID_BRUSHONLY,
		})
		if tr.Hit then
			self:SetPos(tr.HitPos + Vector(0,0,40))
		end
	else
		self.NextParticle = CurTime()
		self.ParticleEmitter = ParticleEmitter(self:GetPos())
		self.ParticleEmitter:SetNoDraw(true) -- We draw them manually
	end
		self:SetMaterial("models/weapons/powerups/mtl_x2icon_gold")
		self.SoundPlayer = CreateSound(self, self.LoopSound)
    	if (self.SoundPlayer) then
        	self.SoundPlayer:Play()
    	end
end

if SERVER then
	function ENT:StartTouch(hitEnt)
		--print("Collided")
		if (IsValid(hitEnt) and hitEnt:IsPlayer() and hitEnt == self:GetPerkOwner()) then
			--PrintTable(self.OwnerData)
			
			-- Weapons are completely replaced
			hitEnt:StripWeapons()
			for k,v in pairs(self.OwnerData.weps) do
				local wep = hitEnt:Give(v.class)
				if v.pap then
					wep:ApplyNZModifier("pap")
				end
			end
			for k,v in pairs(self.OwnerData.perks) do
				if v != "tombstone" then
					hitEnt:GivePerk(v)
				end
			end
			hitEnt:GiveMaxAmmo()
			
			--timer.Destroy(self:EntIndex().."_deathtimer")
			self:Remove()
		end
	end
	
	function ENT:Think()
		if !self.RemoveTime then
			local ply = self:GetPerkOwner()
			if IsValid(ply) then
				if ply:Alive() and ply:GetNotDowned() and (ply:IsPlaying() or ply:IsInCreative()) then
					self.RemoveTime = CurTime() + 90
				end
			else
				-- Man, the player must've disconnected or crashed :/
				self:Remove()
			end
		elseif self.RemoveTime and CurTime() > self.RemoveTime then
			self:Remove()
		end
	end
	function ENT:OnRemove()
		if (self.SoundPlayer) then
    		self.SoundPlayer:Stop()
   		end
   	end
end

if CLIENT then
	local mats = {
		"nzombies-unlimited/particle/powerup_glow_09",
		--"particle/particle_glow_05",
		--"nzombies-unlimited/particle/powerup_wave_5",
		"particle/particle_glow_03"
	}
	local mat = Material(mats[1])
	function ENT:Draw()
		if not self.NextParticle or self.NextParticle < CurTime() then
			local r,g,b = 100,255,50
			for k,v in pairs(mats) do
				local p = self.ParticleEmitter:Add(v, self:GetPos())
				p:SetDieTime(0.5)
				p:SetStartAlpha(255)
				p:SetEndAlpha(0)
				p:SetStartSize(15)
				p:SetEndSize(35)
				p:SetRoll(math.random()*2)
				p:SetColor(r,g,b)
				p:SetLighting(false)
			end
			self.NextParticle = CurTime() + 0.2
		end

		self.ParticleEmitter:Draw()
		self:DrawModel()
	end
	ENT.DrawTranslucent = ENT.Draw

	function ENT:OnRemove()
		if IsValid(self.ParticleEmitter) then self.ParticleEmitter:Finish() end
	end

	local rotang = Angle(2,50,2)
	function ENT:Think()
		if !self:GetRenderAngles() then self:SetRenderAngles(self:GetAngles()) end
		self:SetRenderAngles(self:GetRenderAngles()+(Angle(0,50,0)*FrameTime()))
	end
end