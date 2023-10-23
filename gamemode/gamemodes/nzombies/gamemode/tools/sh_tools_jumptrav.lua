
local models = {
	"models/nzombies_plates/plate.mdl",
	"models/nzombies_plates/plate1.mdl",
	"models/nzombies_plates/plate1x1.mdl",
	"models/nzombies_plates/plate1x2.mdl",
	"models/nzombies_plates/plate1x3.mdl",
	"models/nzombies_plates/plate1x4.mdl",
	"models/nzombies_plates/plate1x5.mdl",
	"models/nzombies_plates/plate1x6.mdl",
	"models/nzombies_plates/plate1x7.mdl",
	"models/nzombies_plates/plate1x8.mdl",
	"models/nzombies_plates/plate1x16.mdl",
	"models/nzombies_plates/plate1x24.mdl",
	"models/nzombies_plates/plate1x32.mdl",
	"models/nzombies_plates/plate2.mdl",
	"models/nzombies_plates/plate2x2.mdl",
	"models/nzombies_plates/plate2x3.mdl",
	"models/nzombies_plates/plate2x4.mdl",
	"models/nzombies_plates/plate2x5.mdl",
	"models/nzombies_plates/plate2x6.mdl",
	"models/nzombies_plates/plate2x7.mdl",
	"models/nzombies_plates/plate2x8.mdl",
	"models/nzombies_plates/plate2x16.mdl",
	"models/nzombies_plates/plate2x24.mdl",
	"models/nzombies_plates/plate2x32.mdl",
	"models/nzombies_plates/plate3.mdl",
	"models/nzombies_plates/plate3x3.mdl",
	"models/nzombies_plates/plate3x4.mdl",
	"models/nzombies_plates/plate3x5.mdl",
	"models/nzombies_plates/plate3x6.mdl",
	"models/nzombies_plates/plate3x7.mdl",
	"models/nzombies_plates/plate3x8.mdl",
	"models/nzombies_plates/plate3x16.mdl",
	"models/nzombies_plates/plate3x24.mdl",
	"models/nzombies_plates/plate3x32.mdl",
	"models/nzombies_plates/plate4.mdl",
	"models/nzombies_plates/plate4x4.mdl",
	"models/nzombies_plates/plate4x5.mdl",
	"models/nzombies_plates/plate4x6.mdl",
	"models/nzombies_plates/plate4x7.mdl",
	"models/nzombies_plates/plate4x8.mdl",
	"models/nzombies_plates/plate4x16.mdl",
	"models/nzombies_plates/plate4x24.mdl",
	"models/nzombies_plates/plate4x32.mdl",
	"models/nzombies_plates/plate5.mdl",
	"models/nzombies_plates/plate5x5.mdl",
	"models/nzombies_plates/plate5x6.mdl",
	"models/nzombies_plates/plate5x7.mdl",
	"models/nzombies_plates/plate5x8.mdl",
	"models/nzombies_plates/plate5x16.mdl",
	"models/nzombies_plates/plate5x24.mdl",
	"models/nzombies_plates/plate5x32.mdl",
	"models/nzombies_plates/plate6.mdl",
	"models/nzombies_plates/plate6x6.mdl",
	"models/nzombies_plates/plate6x7.mdl",
	"models/nzombies_plates/plate6x8.mdl",
	"models/nzombies_plates/plate6x16.mdl",
	"models/nzombies_plates/plate6x24.mdl",
	"models/nzombies_plates/plate6x32.mdl",
	"models/nzombies_plates/plate7.mdl",
	"models/nzombies_plates/plate7x7.mdl",
	"models/nzombies_plates/plate7x8.mdl",
	"models/nzombies_plates/plate7x16.mdl",
	"models/nzombies_plates/plate7x24.mdl",
	"models/nzombies_plates/plate7x32.mdl",
	"models/nzombies_plates/plate8.mdl",
	"models/nzombies_plates/plate8x8.mdl",
	"models/nzombies_plates/plate8x16.mdl",
	"models/nzombies_plates/plate8x24.mdl",
	"models/nzombies_plates/plate8x32.mdl",
	"models/nzombies_plates/plate16.mdl",
	"models/nzombies_plates/plate16x16.mdl",
	"models/nzombies_plates/plate16x24.mdl",
	"models/nzombies_plates/plate16x32.mdl",
	"models/nzombies_plates/plate24x24.mdl",
	"models/nzombies_plates/plate24x32.mdl",
	"models/nzombies_plates/plate32x32.mdl",
	
	"models/nzombies_plates/platehole1x1.mdl",
	"models/nzombies_plates/platehole1x2.mdl",
	"models/nzombies_plates/platehole2x2.mdl",
	"models/nzombies_plates/platehole3.mdl",
	"models/nzombies_plates/tri1x1.mdl",
	"models/nzombies_plates/tri2x1.mdl",
	"models/nzombies_plates/tri3x1.mdl",
	
	"models/nzombies_plates/plate1x3x1trap.mdl",
	"models/nzombies_plates/plate1x4x2trap.mdl",
	"models/nzombies_plates/plate1x4x2trap1.mdl",
}

nzTools:CreateTool("jumpblock", {
	displayname = "Jump Traversal Block Spawner",
	desc = "LMB: Create Jump Traversal Block, RMB: Remove Jump Traversal Block, R: Change Model",
	condition = function(wep, ply)
		return true
	end,
	PrimaryAttack = function(wep, ply, tr, data)
		local ent = tr.Entity
		if IsValid(ent) and ent:GetClass() == "jumptrav_block" then
			nzMapping:JumpBlockSpawn(ent:GetPos(),ent:GetAngles(), data.model, nil, ply)
			ent:Remove()
		else
			nzMapping:JumpBlockSpawn(tr.HitPos,Angle(90,(tr.HitPos - ply:GetPos()):Angle()[2] + 90,90), data.model, nil, ply)
		end
	end,
	SecondaryAttack = function(wep, ply, tr, data)
		if IsValid(tr.Entity) and tr.Entity:GetClass() == "jumptrav_block" then
			tr.Entity:Remove()
		end
	end,
	Reload = function(wep, ply, tr, data)
		if IsValid(tr.Entity) and tr.Entity:GetClass() == "jumptrav_block" then
			tr.Entity:SetModel(data.model)
		end
	end,
	OnEquip = function(wep, ply, data)

	end,
	OnHolster = function(wep, ply, data)

	end
}, {
	displayname = "Jump Traversal Block Spawner",
	desc = "LMB: Create Jump Traversal Block, RMB: Remove Jump Traversal Block, R: Change Model",
	icon = "icon16/shading.png",
	weight = 15,
	condition = function(wep, ply)
		return true
	end,
	interface = function(frame, data, context)
		local Scroll = vgui.Create( "DScrollPanel", frame )
		Scroll:SetSize( 480, 450 )
		Scroll:SetPos( 10, 10 )

		function Scroll.CompileData()
			return {model = data.model}
		end

		function Scroll.UpdateData(data)
			nzTools:SendData(data, "jumpblock", data) -- Save the same data here
		end

		local List	= vgui.Create( "DIconLayout", Scroll )
		List:SetSize( 480, 200 )
		List:SetPos( 0, 0 )
		List:SetSpaceY( 5 )
		List:SetSpaceX( 5 )

		local models = models

		for k,v in pairs(models) do
			local Blockmodel = List:Add( "SpawnIcon" )
			Blockmodel:SetSize( 40, 40 )
			Blockmodel:SetModel(v)
			Blockmodel.DoClick = function()
				data.model = v
				Scroll.UpdateData(Scroll.CompileData())
			end
			Blockmodel.Paint = function(self)
				self.OverlayFade = math.Clamp( ( self.OverlayFade or 0 ) - RealFrameTime() * 640 * 2, 0, 255 )

				if data.model == v or self:IsHovered() then
					self.OverlayFade = math.Clamp( self.OverlayFade + RealFrameTime() * 640 * 8, 0, 255 )
				end
			end
		end

		return Scroll
	end,
	defaultdata = {
		model = "models/nzombies_platess/plate2x2.mdl"
	},
})

nzTools:EnableProperties("jumpblock", "Edit Model...", "icon16/brick_edit.png", 9009, true, function( self, ent, ply )
	if ( !IsValid( ent ) or !IsValid(ply) ) then return false end
	if ( ent:GetClass() != "jumptrav_block" ) then return false end
	if !nzRound:InState( ROUND_CREATE ) then return false end
	if ( ent:IsPlayer() ) then return false end
	if ( !ply:IsInCreative() ) then return false end

	return true

end, function(ent)
	return {model = ent:GetModel()}
end)
