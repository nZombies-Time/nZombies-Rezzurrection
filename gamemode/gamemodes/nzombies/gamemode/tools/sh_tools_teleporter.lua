nzTools:CreateTool("teleporter", {
	displayname = "Teleporter Setup",
	desc = "LMB: Place Teleporter, RMB: Remove Teleporter",
	condition = function(wep, ply)
		return true
	end,
	PrimaryAttack = function(wep, ply, tr, data)
		local ent = tr.Entity
		--print(data.gif)
		if IsValid(ent) and ent:GetClass() == "nz_teleporter" then
			nzMapping:Teleporter(ent:GetPos(), ent:GetAngles(), data.destination, data.id,data.price,data.mdl,data.gif,data.cooldown, data.kino,data.kinodelay,data.buyable, ply)
			
			ent:Remove()
		else
			nzMapping:Teleporter(tr.HitPos, Angle(0,(tr.HitPos - ply:GetPos()):Angle()[2],0), data.destination, data.id,data.price,data.mdl,data.gif,data.cooldown, data.kino,data.kinodelay,data.buyable, ply)
		end
	end,
	SecondaryAttack = function(wep, ply, tr, data)
		if IsValid(tr.Entity) and tr.Entity:GetClass() == "nz_teleporter" then
			tr.Entity:Remove()
		end
	end,
	Reload = function(wep, ply, tr, data)
	end,
	OnEquip = function(wep, ply, data)


	end,
	OnHolster = function(wep, ply, data)

	end
}, {
	displayname = "Teleporter Setup",
	desc = "LMB: Place Teleporter, RMB: Remove Teleporter",
	icon = "icon16/connect.png",
	weight = 7,
	condition = function(wep, ply)
		return true
	end,
	interface = function(frame, data)
		local valz = {}
		valz["Row1"] = data.destination
		valz["Row2"] = data.id
		valz["Row3"] = data.price
		valz["Row4"] = data.mdl
		valz["Row5"] = data.gif
		valz["Row6"] = data.cooldown
		valz["Row7"] = data.kino
		valz["Row8"] = data.kinodelay
		valz["Row9"] = data.buyable
		

		local DProperties = vgui.Create( "DProperties", frame )
		DProperties:SetSize( 480, 450 )
		DProperties:SetPos( 10, 10 )
		
		function DProperties.CompileData()
			data.destination = valz["Row1"]
			data.id = valz["Row2"]
			data.price = valz["Row3"]
			data.mdl = valz["Row4"]
			data.gif = valz["Row5"]
			data.cooldown = valz["Row6"]
			data.kino = valz["Row7"]
			data.kinodelay = valz["Row8"]
			data.buyable = valz["Row9"]

			--PrintTable(data)
			
			return data
		end
		
		function DProperties.UpdateData(data) -- This function will be overwritten if opened via context menu
			nzTools:SendData(data, "teleporter")
		end

		local Row1 = DProperties:CreateRow( "Teleporter", "Destination ID" )
		Row1:Setup( "Integer" )
		Row1:SetValue( valz["Row1"] )
		Row1.DataChanged = function( _, val ) valz["Row1"] = val DProperties.UpdateData(DProperties.CompileData()) end
		local Row2 = DProperties:CreateRow( "Teleporter", "Self ID" )
		Row2:Setup( "Integer" )
		Row2:SetValue( valz["Row2"] )
		Row2.DataChanged = function( _, val ) valz["Row2"] = val DProperties.UpdateData(DProperties.CompileData()) end
		local Row3 = DProperties:CreateRow( "Teleporter", "Price" )
		Row3:Setup( "Integer" )
		Row3:SetValue( valz["Row3"] )
		Row3.DataChanged = function( _, val ) valz["Row3"] = val DProperties.UpdateData(DProperties.CompileData()) end
		local Row4 = DProperties:CreateRow( "Teleporter", "Model(Not Implemented yet.)" )
		Row4:Setup( "Integer" )
		Row4:SetValue( valz["Row4"] )
		Row4.DataChanged = function( _, val ) valz["Row4"] = val DProperties.UpdateData(DProperties.CompileData()) end
		--local Row5 = DProperties:CreateRow( "Teleporter", "Teleporting Animation" )
		--Row5:Setup( "String" )
		--Row5:SetValue( valz["Row5"] )
		--Row5.DataChanged = function( _, val ) valz["Row5"] = val DProperties.UpdateData(DProperties.CompileData()) end
		local Row5 = DProperties:CreateRow( "Teleporter", "Animation" )
		Row5:Setup( "Combo" )
		Row5:AddChoice("Der Riese",1)
        Row5:AddChoice("Cold War",2)
        Row5:AddChoice("Black Ops 3",3)
        Row5:AddChoice("Shadows of Evil",4)
		Row5:AddChoice("Origins (Black Ops 3)",5)
		Row5:AddChoice("DISABLE THIS TELEPORTER",6)
		Row5.DataChanged = function( _, val ) valz["Row5"] = val DProperties.UpdateData(DProperties.CompileData()) end
		local Row6 = DProperties:CreateRow( "Teleporter", "Cooldown" )
		Row6:Setup( "Integer" )
		Row6:SetValue( valz["Row6"] )
		Row6.DataChanged = function( _, val ) valz["Row6"] = val DProperties.UpdateData(DProperties.CompileData()) end
		local Row7 = DProperties:CreateRow( "Teleporter", "Kino Type?" )
		Row7:Setup( "Boolean" )
		Row7:SetValue( valz["Row7"] )
		Row7.DataChanged = function( _, val ) valz["Row7"] = val DProperties.UpdateData(DProperties.CompileData()) end
		local Row8 = DProperties:CreateRow( "Teleporter", "Kino Delay" )
		Row8:Setup( "Integer" )
		Row8:SetValue( valz["Row8"] )
		Row8.DataChanged = function( _, val ) valz["Row8"] = val DProperties.UpdateData(DProperties.CompileData()) end
		
		--local Row9 = DProperties:CreateRow( "Teleporter", "Purchaseable?" )
		--Row9:Setup( "Boolean" )
		--Row9:SetValue( valz["Row9"] )
		--Row9.DataChanged = function( _, val ) valz["Row9"] = val DProperties.UpdateData(DProperties.CompileData()) end

		return DProperties
	end,
	defaultdata = {
		destination = 1,
		id = 0,
		price = 1500,
		mdl = 0,
		gif =1,
		cooldown = 30,
		kino = false,
		kinodelay = 0,
		buyable = true
	}
})