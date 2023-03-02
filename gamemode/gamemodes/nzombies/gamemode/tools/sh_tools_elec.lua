nzTools:CreateTool("elec", {
	displayname = "Electricity Switch Placer",
	desc = "LMB: Place Electricity Switch, RMB: Remove Switch",
	condition = function(wep, ply)
		return true
	end,

	PrimaryAttack = function(wep, ply, tr, data)
		nzMapping:Electric(tr.HitPos + tr.HitNormal*5, tr.HitNormal:Angle(),data.limited,data.aoe, ply)
	end,

	SecondaryAttack = function(wep, ply, tr, data)
		if IsValid(tr.Entity) and tr.Entity:GetClass() == "power_box" then
			tr.Entity:Remove()
		end
	end,
	Reload = function(wep, ply, tr, data)
		-- Nothing
	end,
	OnEquip = function(wep, ply, data)

	end,
	OnHolster = function(wep, ply, data)

	end
}, {
	displayname = "Electricity Switch Placer",
	desc = "LMB: Place Electricity Switch, RMB: Remove Switch",
	icon = "icon16/lightning.png",
	weight = 8,
	condition = function(wep, ply)
		return true
	end,
		interface = function(frame, data)
		local valz = {}
		valz["Row1"] = data.limited
		valz["Row2"] = data.aoe

		local DProperties = vgui.Create( "DProperties", frame )
		DProperties:SetSize( 480, 450 )
		DProperties:SetPos( 10, 10 )
		
		function DProperties.CompileData()
				data.limited = valz["Row1"]
				data.aoe = tostring(valz["Row2"])
			return data
		end
		
		function DProperties.UpdateData(data)
			nzTools:SendData(data, "elec")
		end

		local Row1 = DProperties:CreateRow( "Power Switch", "Limit Area of Effect?" )
		Row1:Setup( "Boolean" )
		Row1:SetValue( valz["Row1"] )
		Row1.DataChanged = function( _, val ) valz["Row1"] = val DProperties.UpdateData(DProperties.CompileData()) end
		local Row2 = DProperties:CreateRow( "Power Switch", "Area of Effect" )
		Row2:Setup( "Integer" )
		Row2:SetValue( valz["Row2"] )
		Row2.DataChanged = function( _, val ) valz["Row2"] = val DProperties.UpdateData(DProperties.CompileData()) end

		local text = vgui.Create("DLabel", DProperties)
		text:SetText("Power Switch, what the fuck do you want me to put here")
		text:SetFont("Trebuchet18")
		text:SetTextColor( Color(50, 50, 50) )
		text:SizeToContents()
		text:Center()

		return DProperties
	end,
	defaultdata = {
		limited = 0,
		aoe = 0,
	}
})