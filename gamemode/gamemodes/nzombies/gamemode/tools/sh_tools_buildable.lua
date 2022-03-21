nzTools:CreateTool("buildable", {
	displayname = "Buildable Placer",
	desc = "LMB: Apply buildable data, RMB: Remove Data, Reload: Delete entire group",
	condition = function(wep, ply)
		return true
	end,
	PrimaryAttack = function(wep, ply, tr, data)
		local tblX = string.Explode( ",", data.flags )
		local ent = tr.Entity
		if !IsValid(ent) then return end
		if ent:IsDoor() or ent:IsBuyableProp() or ent:IsButton() then
			nzDoors:AddBuildable( ent:GetModel(), ent:GetAngles(), ent:GetPos(), tblX[3], tblX[4], tblX[5], tblX[6], tblX[2], tblX[1])
			ent:SetNoDraw(true)
			--ent:SetCollisionGroup( 10 )
		else
			ply:ChatPrint("That is not a valid buildable prop")
		end
	end,
	SecondaryAttack = function(wep, ply, tr, data)
		local ent = tr.Entity
		if !IsValid(ent) then return end
		if ent:IsDoor() or ent:IsBuyableProp() or ent:IsButton() then
		local tblX = string.Explode( ",", data.flags )
			nzDoors:DeleteBuildable(tblX[3])
		end
	end,
	Reload = function(wep, ply, tr, data)
		local ent = tr.Entity
		if !IsValid(ent) then return end
		if ent:IsDoor() or ent:IsBuyableProp() or ent:IsButton() then
			--nzDoors:DisplayDoorLinks(ent)
		end
	end,
	OnEquip = function(wep, ply, data)

	end,
	OnHolster = function(wep, ply, data)

	end
}, {
	displayname = "Buildable Placer",
	desc = "LMB: Apply buildable data, RMB: Remove Data, Reload: Delete entire group",
	icon = "icon16/wrench.png",
	weight = 3,
	condition = function(wep, ply)
		return nzTools.Advanced
	end,
	interface = function(frame, data, context)
		local valz = {}
		valz["Row1"] = data.shared
		valz["Row2"] = data.partid
		valz["Row3"] = data.group
		valz["Row4"] = data.drop
		valz["Row5"] = data.pickuptext
		valz["Row6"] = data.icon

		local DProperties = vgui.Create( "DProperties", frame )
		DProperties:SetSize( 480, 450 )
		DProperties:SetPos( 10, 10 )
		
		function DProperties.CompileData()
			local function compileString(group, drop, partid, pickuptext, icon)
				local str = group
				str = str..","..drop
				str = str..","..partid
				str = str..","..pickuptext
				str = str..","..icon
				return str
			end
			id = valz["Row2"]
			local flagString = compileString(valz["Row3"], valz["Row4"], id, valz["Row5"], valz["Row6"], valz["Row1"])
			print(flagString)

			return {flags = flagString}
		end
		
		function DProperties.UpdateData(data)
			nzTools:SendData( data, "buildable", { -- Hardcoded save function, not just the data
				shared = valz["Row1"],
				partid = valz["Row2"],
				group = valz["Row3"],
				drop = valz["Row4"],
				pickuptext = valz["Row5"],
				icon = valz["Row6"],
			})
		end
		
		-- We call it immediately as it would otherwise auto-send our table to the server, not the compiled string
		-- Although only if not opened via context menu! Context menu should NOT sync tools, causing tool mismatches!
		if !context then DProperties.UpdateData(DProperties.CompileData()) end

		local Row1 = DProperties:CreateRow( "Buildable Settings", "Share between all players?" )
		Row1:Setup( "Boolean" )
		Row1:SetValue( valz["Row1"] )
		Row1.DataChanged = function( _, val ) valz["Row1"] = val DProperties.UpdateData(DProperties.CompileData()) end
		local Row2 = DProperties:CreateRow( "Buildable Settings", "ID" )
		Row2:Setup( "Integer" )
		Row2:SetValue( valz["Row2"] )
		Row2.DataChanged = function( _, val ) valz["Row2"] = val DProperties.UpdateData(DProperties.CompileData()) end
		local Row3 = DProperties:CreateRow( "Buildable Settings", "Group" )
		Row3:Setup( "Integer" )
		Row3:SetValue( valz["Row3"] )
		Row3.DataChanged = function( _, val ) valz["Row3"] = val DProperties.UpdateData(DProperties.CompileData()) end
		local Row4 = DProperties:CreateRow( "Buildable Settings", "Drop on Death?" )
		Row4:Setup( "Boolean" )
		Row4:SetValue( valz["Row4"] )
		Row4.DataChanged = function( _, val ) valz["Row4"] = val DProperties.UpdateData(DProperties.CompileData()) end

		if nzTools.Advanced then
			local Row5 = DProperties:CreateRow( "Advanced Buildable Settings", "Custom Pickup Text" )
			Row5:Setup( "String" )
			Row5:SetValue( valz["Row5"] )
			Row5.DataChanged = function( _, val ) valz["Row5"] = val DProperties.UpdateData(DProperties.CompileData()) end
			local Row6 = DProperties:CreateRow( "Advanced Buildable Settings", "File Path for custom HUD icon" )
			Row6:Setup( "String" )
			Row6:SetValue( valz["Row6"] )
			Row6.DataChanged = function( _, val ) valz["Row6"] = val DProperties.UpdateData(DProperties.CompileData()) end
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
		flags = "shared=1,partid=1,group=1,drop=0,pickuptext=Press E to pick up,icon=Default",
		shared = 1,
		partid = 1,
		group = 1,
		drop = 0,
		pickuptext = "Press E to pick up",
		icon = "Default",
	}
})

