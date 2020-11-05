AddCSLuaFile()

function EFFECT:Init(data)
	self.Start 	= data:GetOrigin()
	self.Scale 	= data:GetScale()
	self.DirVec = data:GetNormal()

	self.Emitter = ParticleEmitter(self.Start)
	
	local smoke = self.Emitter:Add( "particle/smokesprites_000"..math.random(1,9), self.Start )	
	if smoke then
		smoke:SetVelocity( self.DirVec * math.random(90,300) )
		smoke:SetDieTime( math.Rand(1, 1.2) )
		smoke:SetStartAlpha( 150 )
		smoke:SetEndAlpha( 0 )
		smoke:SetStartSize( math.random(6, 8) )
		smoke:SetEndSize( math.random(8, 10) )
		smoke:SetRoll( math.Rand(150, 360) )
		smoke:SetRollDelta( math.Rand(-1, 1) )
		smoke:SetAirResistance( 50 )
		smoke:SetColor( 100, 100, 100 )
	end
	
	local light = self.Emitter:Add( "effects/muzzleflash"..math.random(1,4), self.Start )
	if light then
		light:SetAirResistance( 200 )
		light:SetDieTime( 0.2 )
		light:SetStartAlpha( 255 )
		light:SetEndAlpha( 100 )
		light:SetStartSize( self.Scale * 20 )
		light:SetEndSize( 0 )
		light:SetRoll( math.Rand(180,480) )
		light:SetRollDelta( math.Rand(-1,1) )
		light:SetColor(255, 255, 255)	
	end
		
	self.Emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
	
end