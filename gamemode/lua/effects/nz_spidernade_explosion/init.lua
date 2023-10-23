local blankvec   = Vector(0, 0, 0)

EFFECT.Life      = 0.085
EFFECT.HeatSize  = 0.70
EFFECT.FlashSize = 0.70

function EFFECT:Init(data)
	self.PlayerDat = data:GetEntity()

	self.PlayerDat:EmitSound("TFA_BO3_SPIDERNADE.Explode")
	ParticleEffect("bo3_spider_impact", self.PlayerDat:WorldSpaceCenter(), Angle(0,0,0), self.PlayerDat)
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end