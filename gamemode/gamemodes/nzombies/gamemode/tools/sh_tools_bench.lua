nzTools:CreateTool("bench", {
	displayname = "Workbench Placer",
	desc = "LMB: Place Workbench with Given Parameters, RMB: Remove Workbench",
	condition = function(wep, ply)
		return true
	end,

	PrimaryAttack = function(wep, ply, tr, data)
		nzMapping:Bench(tr.HitPos, Angle(0,(ply:GetPos() - tr.HitPos):Angle()[2],0), data.class,data.gettext, data.model, data.giveent,data.isperk,data.code,data.position,data.entposition,data.id1,data.mat1a,data.mat1b,data.mat1c,data.id2,data.mat2a,data.mat2b,data.mat2c,data.id3,data.mat3a,data.mat3b,data.mat3c,data.angl, data.name, ply)
	end,

	SecondaryAttack = function(wep, ply, tr, data)
		if IsValid(tr.Entity) and tr.Entity:GetClass() == "buildable_table" then
			tr.Entity:Remove()
		end
	end,
	Reload = function(wep, ply, tr, data)
	data.entposition = tr.HitPos
	print("stored")
	end,
	OnEquip = function(wep, ply, data)

	end,
	OnHolster = function(wep, ply, data)

	end
}, {

	displayname = "Workbench Placer",
	desc = "LMB: Place Workbench with Given Parameters, RMB: Remove Workbench",
	icon = "icon16/bricks.png",
	weight = 5,
	condition = function(wep, ply)
		return nzTools.Advanced
	end,
	interface = function(frame, data)
		local valz = {}
		valz["Row1"] = data.name
		valz["Row2"] = data.class
		valz["Row3"] = data.gettext
		valz["Row4"] = data.id1
		valz["Row5"] = data.mat1a
		valz["Row6"] = data.id2
		valz["Row7"] = data.mat2a
		valz["Row8"] = data.id3
		valz["Row9"] = data.mat3a
		valz["Row10"] = data.angl
		valz["Row11"] = data.position
		valz["Row12"] = data.model
		valz["Row13"] = data.mat1b
		valz["Row14"] = data.mat1c
		valz["Row15"] = data.mat2b
		valz["Row16"] = data.mat2c
		valz["Row17"] = data.mat3b
		valz["Row18"] = data.mat3c
		valz["Row19"] = data.giveent
		valz["Row20"] = data.isperk
		valz["Row21"] = data.code
		valz["Row22"] = data.entposition
		local DProperties = vgui.Create( "DProperties", frame )
		DProperties:SetSize( 400, 450 )
		DProperties:SetPos( 10, 10 )
		
		function DProperties.CompileData()
			
				data.name = valz["Row1"]
				data.class = valz["Row2"]
				data.gettext = valz["Row3"] 
				data.id1 = valz["Row4"] 
				data.mat1a = valz["Row5"]
				data.id2 = valz["Row6"]
				data.mat2a = valz["Row7"]
				data.id3 = valz["Row8"]
				data.mat3a = valz["Row9"]
				data.angl = valz["Row10"]
				data.position = valz["Row11"]
				data.model = valz["Row12"]
				data.mat1b = valz["Row13"]
				data.mat1c = valz["Row14"]
				data.mat2b = valz["Row15"]
				data.mat2c = valz["Row16"]
				data.mat3b = valz["Row17"]
				data.mat3c = valz["Row18"]
				data.giveent = valz["Row19"]
				data.isperk = valz["Row20"]
				data.code = valz["Row21"]
				data.entposition = valz["Row22"]
			return data
		end
		
		function DProperties.UpdateData(data)
			nzTools:SendData(data, "bench")
		end
		
		local Row1 = DProperties:CreateRow( "Bench Settings", "Buildable Name" )
		Row1:Setup( "String" )
		Row1:SetValue( valz["Row1"] )
		Row1.DataChanged = function( _, val ) valz["Row1"] = val DProperties.UpdateData(DProperties.CompileData()) end
		
		local Row2 = DProperties:CreateRow( "Bench Settings", "Weapon Given" )
		Row2:Setup( "Combo" )
		for k,v in pairs(weapons.GetList()) do
			if !v.NZTotalBlacklist then
				if v.Category and v.Category != "" then
					Row2:AddChoice(v.PrintName and v.PrintName != "" and v.Category.. " - "..v.PrintName or v.ClassName, v.ClassName, false)
				else
					Row2:AddChoice(v.PrintName and v.PrintName != "" and v.PrintName or v.ClassName, v.ClassName, false)
				end
			end
		end
		Row2.DataChanged = function( _, val ) valz["Row2"] = val DProperties.UpdateData(DProperties.CompileData()) end

		local Row3 = DProperties:CreateRow( "Bench Settings", "Interact Text" )
		Row3:Setup( "String" )
		Row3:SetValue( valz["Row3"] )
		Row3.DataChanged = function( _, val ) valz["Row3"] = val DProperties.UpdateData(DProperties.CompileData()) end
		
		local Row4 = DProperties:CreateRow( "Bench Settings", "ID 1" )
		Row4:Setup( "String" )
		Row4:SetValue( valz["Row4"] )
		Row4.DataChanged = function( _, val ) valz["Row4"] = val DProperties.UpdateData(DProperties.CompileData()) end
		
		local Row5 = DProperties:CreateRow( "Bench Settings", "Material ID 1" )
		Row5:Setup( "Integer" )
		Row5:SetValue( valz["Row5"] )
		Row5.DataChanged = function( _, val ) valz["Row5"] = val DProperties.UpdateData(DProperties.CompileData()) end
		
		local Row6 = DProperties:CreateRow( "Bench Settings", "ID 2" )
		Row6:Setup( "String" )
		Row6:SetValue( valz["Row6"] )
		Row6.DataChanged = function( _, val ) valz["Row6"] = val DProperties.UpdateData(DProperties.CompileData()) end
		
		local Row7 = DProperties:CreateRow( "Bench Settings", "Material ID 2" )
		Row7:Setup( "Integer" )
		Row7:SetValue( valz["Row7"] )
		Row7.DataChanged = function( _, val ) valz["Row7"] = val DProperties.UpdateData(DProperties.CompileData()) end
		
		local Row8 = DProperties:CreateRow( "Bench Settings", "ID 3" )
		Row8:Setup( "String" )
		Row8:SetValue( valz["Row8"] )
		Row8.DataChanged = function( _, val ) valz["Row8"] = val DProperties.UpdateData(DProperties.CompileData()) end
		
		local Row9 = DProperties:CreateRow( "Bench Settings", "Material ID 3" )
		Row9:Setup( "Integer" )
		Row9:SetValue( valz["Row9"] )
		Row9.DataChanged = function( _, val ) valz["Row9"] = val DProperties.UpdateData(DProperties.CompileData()) end
		
		local Row10 = DProperties:CreateRow( "Bench Settings", "Item Angle" )
		Row10:Setup( "String" )
		Row10:SetValue( valz["Row10"] )
		Row10.DataChanged = function( _, val ) valz["Row10"] = val DProperties.UpdateData(DProperties.CompileData()) end
		
		local Row11 = DProperties:CreateRow( "Bench Settings", "Item Position" )
		Row11:Setup( "String" )
		Row11:SetValue( valz["Row11"] )
		Row11.DataChanged = function( _, val ) valz["Row11"] = val DProperties.UpdateData(DProperties.CompileData()) end
		

		if nzTools.Advanced then
			local Row12 = DProperties:CreateRow( "Bench Settings", "Alternate model path" )
			Row12:Setup( "String" )
			Row12:SetValue( valz["Row12"] )
			Row12.DataChanged = function( _, val ) valz["Row12"] = val DProperties.UpdateData(DProperties.CompileData()) end
			local Row13 = DProperties:CreateRow( "Advanced Bench Settings", "Material 2 (Part 1)" )
			Row13:Setup( "Integer" )
			Row13:SetValue( valz["Row13"] )
			Row13.DataChanged = function( _, val ) valz["Row13"] = val DProperties.UpdateData(DProperties.CompileData()) end
			local Row14 = DProperties:CreateRow( "Advanced Bench Settings", "Material 3 (Part 1)" )
			Row14:Setup( "Integer" )
			Row14:SetValue( valz["Row14"] )
			Row14.DataChanged = function( _, val ) valz["Row14"] = val DProperties.UpdateData(DProperties.CompileData()) end
			local Row15 = DProperties:CreateRow( "Advanced Bench Settings", "Material 2 (Part 2)" )
			Row15:Setup( "Integer" )
			Row15:SetValue( valz["Row15"] )
			Row15.DataChanged = function( _, val ) valz["Row15"] = val DProperties.UpdateData(DProperties.CompileData()) end
			local Row16 = DProperties:CreateRow( "Advanced Bench Settings", "Material 3 (Part 2)" )
			Row16:Setup( "Integer" )
			Row16:SetValue( valz["Row16"] )
			Row16.DataChanged = function( _, val ) valz["Row16"] = val DProperties.UpdateData(DProperties.CompileData()) end
			local Row17 = DProperties:CreateRow( "Advanced Bench Settings", "Material 2 (Part 3)" )
			Row17:Setup( "Integer" )
			Row17:SetValue( valz["Row17"] )
			Row17.DataChanged = function( _, val ) valz["Row17"] = val DProperties.UpdateData(DProperties.CompileData()) end
			local Row18 = DProperties:CreateRow( "Advanced Bench Settings", "Material 3 (Part 3)" )
			Row18:Setup( "Integer" )
			Row18:SetValue( valz["Row18"] )
			Row18.DataChanged = function( _, val ) valz["Row18"] = val DProperties.UpdateData(DProperties.CompileData()) end
			local Row19 = DProperties:CreateRow( "Bench Settings", "Use Special Entity?" )
			Row19:Setup( "Boolean" )
			Row19:SetValue( valz["Row19"] )
			Row19.DataChanged = function( _, val ) valz["Row19"] = val DProperties.UpdateData(DProperties.CompileData()) end
			local Row20 = DProperties:CreateRow( "Bench Settings", "Places Perk/Pack-A-Punch" )
			Row20:Setup( "Boolean" )
			Row20:SetValue( valz["Row20"] )
			Row20.DataChanged = function( _, val ) valz["Row20"] = val DProperties.UpdateData(DProperties.CompileData()) end
			local Row21 = DProperties:CreateRow( "Bench Settings", "Special Entity Code" )
			Row21:Setup( "String" )
			Row21:SetValue( valz["Row21"] )
			Row21.DataChanged = function( _, val ) valz["Row21"] = val DProperties.UpdateData(DProperties.CompileData()) end
			local Row22 = DProperties:CreateRow( "Bench Settings", "Map Entity Position" )
			Row22:Setup( "Vector" )
			Row22:SetValue( valz["Row22"] )
			Row22.DataChanged = function( _, val ) valz["Row22"] = val DProperties.UpdateData(DProperties.CompileData()) end
		else
			local text = vgui.Create("DLabel", DProperties)
			text:SetText("Enable Advanced Mode for more options.")
			text:SetFont("Trebuchet18")
			text:SetTextColor( Color(50, 50, 50) )
			text:SizeToContents()
			text:Center()
		end
		

		return DProperties
		
	end,
	defaultdata = {
		name = "Buildable 1",
		class = "weapon_class",
		gettext = "Press E to pickup",
		id1 = "1",
		mat1a = 0,
		id2 = "2",
		mat2a = 0,
		id3 = "3",
		mat3a = 0,
		angl = ("0,180,90"),
		position =  ("0,0,60"),
		model = "Defaults to weapon model",
		mat1b = 0,
		mat1c = 0,
		mat2b = 0,
		mat2c = 0,
		mat3b = 0,
		mat3c = 0,
		giveent = false,
		isperk = false,
		code = "None",
		entposition =  Vector(0, 0, 0)
	}
})