include("shared.lua")
 
function ENT:Draw()
	self:DrawModel()
	render.SetMaterial( Material( "effects/redflare.vtf"))

	if self.BlinkA then
		render.DrawSprite( self:GetAttachment(1).Pos, 5, 5, Color(255,0,0,0))

		local lights = DynamicLight(self:EntIndex())
		if (lights) then
			lights.Pos = self:GetAttachment(1).Pos
			lights.r = 255
			lights.g = 0
			lights.b = 0
			lights.Brightness = 1.78
			lights.Size = 31.17
			lights.Decay = 100
			lights.DieTime = CurTime() + 0.5
		end
	end
end



function ENT:Initialize()
self.BlinkA = false
timer.Create( self:EntIndex().."Blink", 0.3, 0, function() self.BlinkA = !self.BlinkA end)
timer.Start( self:EntIndex().."Blink" )

self.cldet = false

end




function ENT:OnRemove()
timer.Destroy( self:EntIndex().."Blink" )
end 

