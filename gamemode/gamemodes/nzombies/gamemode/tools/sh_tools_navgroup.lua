
--[[

Moo Mark 2/19/23: 
So it turns out this tool existed in older versions of nZ... Why it was removed? Cause it wasn't getting used... 
Like what the fuck thats such a stupid fucking reason to remove it, but apparently according to Zet that was the case... 
So I'm re-adding it because it turns out this is pretty much a pseudo zoning system so 
you can imagine my anger upon finding out about this tool's removal.

]]

if SERVER then
	util.AddNetworkString("nz_NavMeshGrouping")
	util.AddNetworkString("nz_NavMeshGroupRequest")

	net.Receive("nz_NavMeshGroupRequest", function(len, ply)
		if !IsValid(ply) or !ply:IsSuperAdmin() then return end

		local delete = net.ReadBool()
		local data = net.ReadTable()

		//Reselect all areas from the seed provided
		local areas = FloodSelectNavAreas(navmesh.GetNavAreaByID(data.areaid))

		if delete then
			for k,v in pairs(areas) do
				//Remove nav area from group - add true to delete the group ID as well
				nzNav.Functions.RemoveNavGroupArea(v, true)
			end
		else
			for k,v in pairs(areas) do
				//Set their ID in the table
				nzNav.Functions.AddNavGroupIDToArea(v, data.id)
			end
		end
	end)
else
	net.Receive("nz_NavMeshGrouping", function()

		local data = net.ReadTable()

		local frame = vgui.Create("DFrame")
		frame:SetPos( 100, 100 )
		frame:SetSize( 300, 450 )
		frame:SetTitle( "Nav Mesh Grouping" )
		frame:SetVisible( true )
		frame:SetDraggable( false )
		frame:ShowCloseButton( true )
		frame:MakePopup()
		frame:Center()

		local numareas = vgui.Create( "DLabel", frame )
		numareas:SetPos( 10, 30 )
		numareas:SetSize( frame:GetWide() - 10, 10)
		numareas:SetText( data.num.." areas selected" )

		local map = vgui.Create("DPanel", frame)
		map:SetPos( 25, 50 )
		map:SetSize( 250, 250 )
		map:SetVisible( true )
		map.Paint = function(self, w, h)
			local posx, posy = frame:GetPos()
			cam.Start2D()
				render.RenderView({
					origin = LocalPlayer():GetPos()+Vector(0,0,7000),
					angles = Angle(90,0,0),
					aspectratio = 1,
					x = posx + 12,
					y = posy + 100,
					w = 275,
					h = 275,
					dopostprocess = false,
					drawhud = false,
					drawviewmodel = false,
					viewmodelfov = 0,
					fov = 90,
					ortho = false,
					znear = 0,
					zfar = 10000,
				})
			cam.End2D()
		end

		local DProperties = vgui.Create( "DProperties", frame )
		DProperties:SetSize( 280, 180 )
		DProperties:SetPos( 10, 50 )

		local Row1 = DProperties:CreateRow( "Nav Group", "ID" )
		Row1:Setup( "Integer" )
		Row1:SetValue( data.id )
		Row1.DataChanged = function( _, val ) data.id = val end

		local Submit = vgui.Create( "DButton", frame )
		Submit:SetText( "Submit" )
		Submit:SetPos( 10, 410 )
		Submit:SetSize( 280, 30 )
		Submit.DoClick = function()
			net.Start("nz_NavMeshGroupRequest")
				net.WriteBool(false)
				net.WriteTable(data)
			net.SendToServer()
			frame:Close()
		end

		local Delete = vgui.Create( "DButton", frame )
		Delete:SetText( "Delete Group" )
		Delete:SetPos( 10, 380 )
		Delete:SetSize( 280, 20 )
		Delete.DoClick = function()
			net.Start("nz_NavMeshGroupRequest")
				net.WriteBool(true)
				net.WriteTable(data)
			net.SendToServer()
			frame:Close()
		end
	end)
end

nzTools:CreateTool("navgroup", {
	displayname = "Nav Zoning Tool",
	desc = "LMB: Create/Edit Nav Zones",
	condition = function(wep, ply)
		return true
	end,
	PrimaryAttack = function(wep, ply, tr, data)
		local nav = navmesh.GetNearestNavArea(tr.HitPos)
		local areas = FloodSelectNavAreas(nav)

		net.Start("nz_NavMeshGrouping")
			net.WriteTable({num = #areas, areaid = nav:GetID(), id = nzNav.NavGroups[nav:GetID()] or ""})
		net.Send(ply)
	end,

	SecondaryAttack = function(wep, ply, tr, data)
	end,

	Reload = function(wep, ply, tr, data)
	end,

	OnEquip = function(wep, ply, data)
		if wep.Owner:IsListenServerHost() then
			RunConsoleCommand("nav_edit", 1)
		end
	end,
	OnHolster = function(wep, ply, data)
		if SERVER and wep.Owner:IsListenServerHost() then
			RunConsoleCommand("nav_edit", 0)
		end
		return true
	end

}, {
	displayname = "Nav Zoning Tool",
	desc = "LMB: Create/Edit Nav Zones",
	icon = "icon16/chart_organisation.png",
	weight = 45,
	condition = function(wep, ply)
		//Client needs advanced editing on to see the tool
		return true
	end,
	interface = function(frame, data)
		local panel = vgui.Create("DPanel", frame)
		panel:SetSize(frame:GetSize())

		local textw = vgui.Create("DLabel", panel)
		textw:SetText("You need to be in a listen/local server to be")
		textw:SetFont("Trebuchet18")
		textw:SetTextColor( Color(150, 50, 50) )
		textw:SizeToContents()
		textw:SetPos(0, 20)
		textw:CenterHorizontal()

		local textw2 = vgui.Create("DLabel", panel)
		textw2:SetText("able to see the Navmeshes!")
		textw2:SetFont("Trebuchet18")
		textw2:SetTextColor( Color(150, 50, 50) )
		textw2:SizeToContents()
		textw2:SetPos(0, 30)
		textw2:CenterHorizontal()

		local textw3 = vgui.Create("DLabel", panel)
		textw3:SetText("The ID must be represented via a letter or word such as 'start'")
		textw3:SetFont("Trebuchet18")
		textw3:SetTextColor( Color(50, 50, 50) )
		textw3:SizeToContents()
		textw3:SetPos(0, 40)
		textw3:CenterHorizontal()

		local text = vgui.Create("DLabel", panel)
		text:SetText("Click on the ground to open")
		text:SetFont("Trebuchet18")
		text:SetTextColor( Color(50, 50, 50) )
		text:SizeToContents()
		text:SetPos(0, 80)
		text:CenterHorizontal()

		local text2 = vgui.Create("DLabel", panel)
		text2:SetText("the Nav Zoning Interface of that area.")
		text2:SetFont("Trebuchet18")
		text2:SetTextColor( Color(50, 50, 50) )
		text2:SizeToContents()
		text2:SetPos(0, 90)
		text2:CenterHorizontal()

		local text3 = vgui.Create("DLabel", panel)
		text3:SetText("Zombies can't spawn in areas players are not in.")
		text3:SetFont("Trebuchet18")
		text3:SetTextColor( Color(50, 50, 50) )
		text3:SizeToContents()
		text3:SetPos(0, 110)
		text3:CenterHorizontal()

		local text4 = vgui.Create("DLabel", panel)
		text4:SetText("Use this to segment maps and have more control")
		text4:SetFont("Trebuchet18")
		text4:SetTextColor( Color(50, 50, 50) )
		text4:SizeToContents()
		text4:SetPos(0, 120)
		text4:CenterHorizontal()

		local text5 = vgui.Create("DLabel", panel)
		text5:SetText("over where zombies spawn around the player.")
		text5:SetFont("Trebuchet18")
		text5:SetTextColor( Color(50, 50, 50) )
		text5:SizeToContents()
		text5:SetPos(0, 170)
		text5:CenterHorizontal()

		local text6 = vgui.Create("DLabel", panel)
		text6:SetText("Make sure you isolate areas by disconnecting them from the rest")
		text6:SetFont("Trebuchet18")
		text6:SetTextColor( Color(50, 50, 50) )
		text6:SizeToContents()
		text6:SetPos(0, 180)
		text6:CenterHorizontal()

		local text7 = vgui.Create("DLabel", panel)
		text7:SetText("of the mesh before making zones.")
		text7:SetFont("Trebuchet18")
		text7:SetTextColor( Color(50, 50, 50) )
		text7:SizeToContents()
		text7:SetPos(0, 200)
		text7:CenterHorizontal()

		return panel
	end,
	//defaultdata = {}
})