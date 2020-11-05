function EFFECT:Init( data )

local Pos 		= data:GetOrigin()
local Scale 		= data:GetScale()	
local Radius 		= data:GetRadius()
local DirVec 		= Vector(0,0,0)
local Particles 	= data:GetMagnitude()
local Angle 		= DirVec:Angle()
self.Particles 		= data:GetMagnitude()
self.Scale 		= data:GetScale()	
self.Origin 		= Pos	
self.emitter 		= ParticleEmitter( Pos )


		for i=1,5 do 
			local Flash = self.emitter:Add( "effects/muzzleflash"..math.random(1,4), Pos )
			if (Flash) then
				Flash:SetDieTime( 0.05 )
				Flash:SetStartAlpha( 255 )
				Flash:SetEndAlpha( 0 )
				Flash:SetStartSize( 300 )
				Flash:SetEndSize( 0 )
				Flash:SetColor(255,255,255)	
			end
		end


		for i=1,30 do
			local Dust = self.emitter:Add( "particle/smokesprites_000"..math.random(1,9), Pos )
			if (Dust) then
				Dust:SetDieTime( 1.2 )
				Dust:SetStartAlpha( 25 )
				Dust:SetEndAlpha( 0 )
				Dust:SetStartSize( 125 )
				Dust:SetEndSize( 100 ) 
                                Dust:SetAirResistance( 200 )			
				Dust:SetColor( 60,60,60 )
			end
		end

end

function EFFECT:Render()
end
