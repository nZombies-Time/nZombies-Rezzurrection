nzTools:CreateTool("ending", {
	displayname = "Buyable Ending Spawner",
	desc = "LMB: Place Buyable Ending, RMB: Remove that shit",
	condition = function(wep, ply)
		return true
	end,

	PrimaryAttack = function(wep, ply, tr, data)
		nzMapping:Ending(tr.HitPos, Angle(0,(tr.HitPos - ply:GetPos()):Angle()[2] - 90,0), tonumber(data.price), ply)
	end,

	SecondaryAttack = function(wep, ply, tr, data)
		if IsValid(tr.Entity) and tr.Entity:GetClass() == "buyable_ending" then
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
	displayname = "Buyable Ending Spawner",
	desc = "LMB: Place Buyable Ending, RMB: Remove that shit",
	icon = "icon16/tick.png",
	weight = 4,
	condition = function(wep, ply)
		return true
	end,
	interface = function(frame, data)
		local valz = {}
		valz["Row1"] = data.price

		local DProperties = vgui.Create( "DProperties", frame )
		DProperties:SetSize( 480, 300 )
		DProperties:SetPos( 10, 10 )
		
		function DProperties.CompileData()
			data.price = valz["Row1"]
			return data
		end
		
		function DProperties.UpdateData(data)
			nzTools:SendData(data, "ending")
		end

		local Row1 = DProperties:CreateRow( "Buyable Ending", "Price" )
		Row1:Setup( "Integer" )
		Row1:SetValue( valz["Row1"] )
		Row1.DataChanged = function( _, val ) valz["Row1"] = val DProperties.UpdateData(DProperties.CompileData()) end

		return DProperties
	end,
	defaultdata = {
		price = 500,
	}
})