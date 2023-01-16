nzTools:CreateTool("barricade", {
	displayname = "Barricade Creator",
	desc = "LMB: Place Barricade, RMB: Remove Barricade",
	condition = function(wep, ply)
		return true
	end,
	PrimaryAttack = function(wep, ply, tr, data)
		local ent = tr.Entity
		if IsValid(ent) and ent:GetClass() == "breakable_entry" then
			nzMapping:BreakEntry(ent:GetPos(), ent:GetAngles(), data.planks, data.jump, data.prop, ply)
			ent:Remove()
		else
			nzMapping:BreakEntry(tr.HitPos + Vector(0,0,45), Angle(0,(tr.HitPos - ply:GetPos()):Angle()[2],0), data.planks, data.jump,data.prop, ply)
		end
	end,
	SecondaryAttack = function(wep, ply, tr, data)
		if IsValid(tr.Entity) and tr.Entity:GetClass() == "breakable_entry" then
			tr.Entity:Remove()
		end
	end,
	Reload = function(wep, ply, tr, data)
		//Nothing
	end,
	OnEquip = function(wep, ply, data)

	end,
	OnHolster = function(wep, ply, data)

	end
}, {
	displayname = "Barricade Creator",
	desc = "LMB: Place Barricade, RMB: Remove Barricade",
	icon = "icon16/door.png",
	weight = 7,
	condition = function(wep, ply)
		return true
	end,
	interface = function(frame, data)
		local valz = {}
		valz["Row1"] = data.planks
		valz["Row2"] = data.jump
		valz["Row3"] = data.prop
		local DProperties = vgui.Create( "DProperties", frame )
		DProperties:SetSize( 480, 450 )
		DProperties:SetPos( 10, 10 )
		
		function DProperties.CompileData()
			data.planks = valz["Row1"]
			data.jump = valz["Row2"]
			data.prop = valz["Row3"]
			--PrintTable(data)
			
			return data
		end
		
		function DProperties.UpdateData(data) -- This function will be overwritten if opened via context menu
			nzTools:SendData(data, "barricade")
		end

		local Row1 = DProperties:CreateRow( "Barricade", "Has Planks?" )
		Row1:Setup( "Boolean" )
		Row1:SetValue( valz["Row1"] )
		Row1.DataChanged = function( _, val ) valz["Row1"] = val DProperties.UpdateData(DProperties.CompileData()) end
		local Row2 = DProperties:CreateRow( "Barricade", "Jump Animations?" )
		Row2:Setup( "Boolean" )
		Row2:SetValue( valz["Row2"] )
		Row2.DataChanged = function( _, val ) valz["Row2"] = val DProperties.UpdateData(DProperties.CompileData()) end
		local Row3 = DProperties:CreateRow( "Barricade", "Prop" )
		Row3:Setup( "Combo" )
		Row3:AddChoice("None",0)
        Row3:AddChoice("Cinderblocks",1)
        Row3:AddChoice("Metal Barrel",3)
		Row3:AddChoice("Broken Door",4)
		Row3:AddChoice("Sandbag",5)
		Row3:AddChoice("Rocks",6)
		Row3:AddChoice("Wooden Barrel",7)
		Row3:AddChoice("Wooden Crate",8)
		Row3:AddChoice("Barbwire Fence",9)
		Row3.DataChanged = function( _, val ) valz["Row3"] = val DProperties.UpdateData(DProperties.CompileData()) end

		return DProperties
	end,
	defaultdata = {
		planks = 1,
		jump = 0,
		prop = 0,
	}
})