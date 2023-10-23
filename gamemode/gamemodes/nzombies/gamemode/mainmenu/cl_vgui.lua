surface.CreateFont( "pier_large", {
	font = "PierSans-Regular",
	size = 48,
	antialias = true,
} )

surface.CreateFont( "pier_medium", {
	font = "PierSans-Regular",
	size = 24,
	antialias = true,
} )

surface.CreateFont( "pier_small", {
	font = "PierSans-Regular",
	size = 16,
	antialias = true,
} )

local MenuFrame = {}

AccessorFunc( MenuFrame, "fLastSpawnSwitch", "LastSpawnSwitch", FORCE_NUMBER )

function MenuFrame:Init()
	self:SetSize(ScrW(), ScrH())
	self:SetPos( 0, 0 )
	gui.EnableScreenClicker( true )

	self.ToolBar = vgui.Create( "NZMainMenuToolBar", self )
	self.Content = vgui.Create( "NZMainMenuContent", self )
	self.PlayerList = vgui.Create( "NZMainMenuPlayerList", self )

	self.CameraPos = LocalPlayer():GetPos() + Vector( 30, 30, 30 )
	self:SetLastSpawnSwitch( CurTime() )

end

function GetFontType(id)
	if id == "Classic NZ" then
	return "classic"
	end
	if id == "Old Treyarch" then
	return "waw"
	end
	if id == "BO2/3" then
	return "blackops2"
	end
	if id == "BO4" then
	return "blackops4"
	end
	if id == "Black Ops 1" then
	return "bo1"
	end
		if id == "Comic Sans" then
	return "xd"
	end
		if id == "Warprint" then
	return "grit"
	end
		if id == "Road Rage" then
	return "rage"
	end
		if id == "Black Rose" then
	return "rose"
	end
		if id == "Reborn" then
	return "reborn"
	end
		if id == "Rio Grande" then
	return "rio"
	end
		if id == "Bad Signal" then
	return "signal"
	end
		if id == "Infection" then
	return "infected"
	end
		if id == "Brutal World" then
	return "brutal"
	end
		if id == "Generic Scifi" then
	return "ugly"
	end
		if id == "Tech" then
	return "tech"
	end
		if id == "Krabby" then
	return "krabs"
	end
		if id == "Default NZR" then
	return "default"
	end
	if id == nil then
	return "default"
	end
end

function MenuFrame:Think()
	local ply = LocalPlayer()
	if ply:Alive() then return end
	if self:GetLastSpawnSwitch() + 15 < CurTime() then
		local sPoints = ents.FindByClass( "player_spawns" )
		if sPoints then
			local sPoint = sPoints[ math.random( #sPoints ) ]
			if IsValid( sPoint ) then
				ply:SetPos( sPoint:GetPos() )
				self.CameraPos = LocalPlayer():GetPos() + Vector( 20, 20, 40 )
				self:SetLastSpawnSwitch( CurTime() )
			end
		end
	end
	local vec1 = self.CameraPos
	local vec2 = ply:GetPos() + Vector( 0, 0, 20 )
	local ang = ( vec2 - vec1 ):Angle()
	ang:RotateAroundAxis( Vector( 0, 0, 1), math.sin( CurTime()/20 ) * 360 )
	ply:SetEyeAngles( ang )
end

function MenuFrame:Paint()
	--Derma_DrawBackgroundBlur( self, self.startTime )
	return
end

--It's not actually a frame but whatever
vgui.Register( "NZMainMenuFrame", MenuFrame, "DPanel")


local MenuToolBar = {}

function MenuToolBar:Init()
	self:SetSize( ScrW(), 80 )
	self:SetPos( 0, 0 )

	self.Logo = vgui.Create( "DLabel", self )
	self.Logo:SetPos( 14, 14 )
	self.Logo:SetFont("nz.main."..GetFontType(nzMapping.Settings.mainfont))
	self.Logo:SetColor( Color( 255, 255, 255 ) )
	self.Logo:SetText( "nZombies" )
	self.Logo:SizeToContents()

	self.Entries = {}

	local ready = self:AddEntry( "READY", "large", "nz_chatcommand", "/ready" )
	function ready:Think()
		if nzRound:InProgress() then
			if LocalPlayer():Alive()  then
				self:SetText( "DROPOUT" )
				self:SetConsoleCommand( "nz_chatcommand", "/dropout" )
			else
				self:SetText( "DROPIN" )
				self:SetConsoleCommand( "nz_chatcommand", "/dropin" )
			end
		else
			if LocalPlayer():IsReady() then
				self:SetText( "UNREADY" )
			else
				self:SetText( "READY" )
			end
			self.DoClick = function()
                if LocalPlayer():IsReady() then
                    RunConsoleCommand( "nz_chatcommand", "/unready" )
                else
                    if nzRound:InState( ROUND_CREATE ) then
                        RunConsoleCommand( "nz_chatcommand", "/create" )
                    end
                    RunConsoleCommand( "nz_chatcommand", "/ready" )
                    RunConsoleCommand( "nz_settings" )
                end
            end
		end
	end

	local spectate = self:AddEntry( "SPECTATE", "medium", "nz_chatcommand", "/spectate" )
	
	local creative = self:AddEntry( "CREATIVE MODE", "medium", "nz_chatcommand", "/create" )
	function creative:Think()
		if LocalPlayer():IsInCreative() then
			self:SetText("SURVIVAL MODE")
		else
			self:SetText("CREATIVE MODE")
		end
	end

	self:AddEntry( "WORKSHOP PAGE", "medium", function() gui.OpenURL( "http://steamcommunity.com/sharedfiles/filedetails/?id=675138912" ) end )
	
	self:AddEntry( "Press F1 to toggle this menu", "small", function() RunConsoleCommand("nz_settings") end )
	
	--Settings Button / Close button
	if LocalPlayer():IsSuperAdmin() then
		self.SettingsButton = vgui.Create( "DImageButton", self )
		self.SettingsButton:SetImage( "icon_settings.png" )
		self.SettingsButton:SetPos( ScrW() - 60, 20 )
		self.SettingsButton:SetSize( 40, 40 )
		self.SettingsButton:SetContentAlignment( 5 )
		function self.SettingsButton:Paint( w, h )

		end

		AccessorFunc( self.SettingsButton, "bSettingsMenuOpen", "SettingsMenuOpen", FORCE_BOOL )

		function self.SettingsButton:DoClick()
			if !self:GetSettingsMenuOpen() then
				self.SettingsMenu = vgui.Create( "NZMainMenuSettingsPanel", self:GetParent():GetParent() ) --Parent to mainframe
				self:SetSettingsMenuOpen( true )
				self:SetColor( Color( 85, 85, 85, 255 ) )
			else
				self.SettingsMenu:Remove()
				self:SetSettingsMenuOpen( false )
				self:SetColor( Color( 255, 255, 255, 255 ) )
			end
		end

	else
		--Show close icon if user not superadmin
		self.CloseButton = vgui.Create( "DImageButton", self )
		self.CloseButton:SetImage( "icon_close.png" )
		self.CloseButton:SetPos( ScrW() - 60, 20 )
		self.CloseButton:SetSize( 40, 40 )
		self.CloseButton:SetContentAlignment( 5 )
		self.CloseButton:SetConsoleCommand( "nz_settings" )
		function self.CloseButton:Paint( w, h )

		end
	end

end

local col = Color( 130, 45, 45, 255 ) 
function MenuToolBar:Paint( w, h )
	draw.RoundedBox( 0, 0, 0, w, h, col )
	--draw.RoundedBox( 0, 0, h-5, w, 5, Color( 255, 255, 255, 255 ) )
end

--[[function MenuToolBar:Think()
	local nextPos = 320
	local temp = self.Entries
	for i = #self.Entries, 1, -1  do
		self.Entries[i]:SizeToContentsX()
		for j = #self.Entries, i, -1 do
			if i == j then break end
			nextPos = nextPos + self.Entries[j]:GetWide() + 30
		end
		self.Entries[i]:SetPos( nextPos, 20 )
		nextPos = 320
	end
end]]

function MenuToolBar:AddEntry( lbl, fontSize, cmd, args )
	local entry = vgui.Create( "NZMainMenuToolBarEntry", self )
	if fontSize == "large" then
		entry:SetFont( "pier_large" )
	elseif fontSize == "medium" then
		entry:SetFont( "pier_medium" )
	else
		entry:SetFont( "pier_small" )
	end
	local nextPos = 300
	for _, v in pairs( self.Entries ) do
		nextPos = nextPos + v:GetWide() + 30
	end
	entry:SetPos( nextPos, 0 )
	entry:SetTall( self:GetTall() )
	if isfunction( cmd ) then
		entry.DoClick = cmd
	elseif isstring( cmd ) then
		entry:SetConsoleCommand( cmd, args )
	end
	entry:SetText( lbl )
	entry:SetContentAlignment( 5 )
	--entry:SizeToContentsX()

	table.insert( self.Entries, 1, entry )

	return self.Entries[ 1 ]
end

vgui.Register( "NZMainMenuToolBar", MenuToolBar, "DPanel")


local MenuToolBarEntry = {}

function MenuToolBarEntry:Init()
	self:SetSize( 260, 60 )
	self:SetFont( "pier_large" )
	self:SetContentAlignment( 5 )
	self:SetTextColor( Color( 255, 255, 255 ) )
end

function MenuToolBarEntry:Paint()

end

vgui.Register( "NZMainMenuToolBarEntry", MenuToolBarEntry, "DButton")


local MenuSettingsPanel = {}

local white = Color(255,255,255,255)
local green = Color(230,255,230,255)

local function MenuSettingsListInit(self)
	self:SetWide( 256 )
	local btnMode = self:AddButton( "< Toggle Creative Mode ...", "nz_chatcommand", "/create" )
	function btnMode:Think()
		if self:IsHovered() or IsValid(self.ExtendedList) and (self.ExtendedList:IsHovered() or self.ExtendedList:IsChildHovered()) then
			if !IsValid(self.ExtendedList) then
				self.ExtendedList = vgui.Create("DScrollPanel", self:GetParent():GetParent():GetParent():GetParent())
				function self.ExtendedList:Paint( w, h )
					draw.RoundedBox( 0, 0, 0, w, h, white )
				end
				
				self.ExtendedList:SetPos( ScrW() - 512, 80 )
				self.ExtendedList:SetSize( 256, math.Clamp(#player.GetAll() * 42, 0, 1024) )
				self.ExtendedList.PlayerList = vgui.Create("NZMainMenuSettingsList", self.ExtendedList)
				self.ExtendedList.PlayerList:SetWide( 256 )
				
				for k,v in pairs(player.GetAll()) do
					local plybtn = self.ExtendedList.PlayerList:AddButton( v:Nick(), "nz_chatcommand", "/create "..v:Nick())
					function plybtn:Paint( w, h )
						draw.RoundedBox( 0, 0, 1, w, h-1, v:IsInCreative() and green or white )
					end
				end
			end
		else
			if IsValid(self.ExtendedList) then
				self.ExtendedList:Remove()
			end
		end
	end
	
	self:AddButton( "Load Map config", "nz_chatcommand", "/load" )
	self:AddButton( "Save Map config", "nz_chatcommand", "/save" )
	self:AddButton( "Player Model Editor", function() nzPlayers:PlayerModelEditor() end)
	self:AddButton( "Generate Navmesh", "nz_chatcommand", "/generate" )
	self:AddButton( "Cheats (Beta)", "nz_chatcommand", "/cheats" )
end

function MenuSettingsPanel:Init()
	self:SetPos( ScrW() - 256, 80 )
	self:SetSize( 256, 256)
	self.List = vgui.Create( "NZMainMenuSettingsList", self )
	MenuSettingsListInit(self.List)
end

function MenuSettingsPanel:Paint( w, h )
	draw.RoundedBox( 0, 0, 0, w, h, white )
end

vgui.Register( "NZMainMenuSettingsPanel", MenuSettingsPanel, "DScrollPanel" )

local MenuSettingsList = {}

function MenuSettingsList:AddButton( lbl, cmd, args )
	local button = vgui.Create( "DButton", self )
	if isfunction( cmd ) then
		button.DoClick = cmd
	elseif isstring( cmd ) then
		button:SetConsoleCommand( cmd, args )
	end
	button:SetText( lbl )
	button:SetFont( "pier_small" )
	button:SetTall( 42 )

	function button:Paint( w, h )

	end

	if !self.ButtonContent then self.ButtonContent = {} end
	local btn = self:Add( button )
	table.insert(self.ButtonContent, btn)
	return btn
end

function MenuSettingsList:Paint( w, h )
	for k,v in ipairs(self.ButtonContent) do
		local nextbtn = self.ButtonContent[k + 1]
		if IsValid(nextbtn) then
			local x, y = nextbtn:GetPos()
			local mid = y - 0
			surface.SetDrawColor(230, 230, 230)
			surface.DrawLine(20, mid, self:GetWide() - 20, mid)
		end
	end
end

vgui.Register( "NZMainMenuSettingsList", MenuSettingsList, "DListLayout" )


local MenuContent = {}

function MenuContent:Init()
	self.Layouts = {}
	self.ActiveLayout = "main"
	self:SetSize(ScrW(), ScrH() - 80 )
	self:SetPos( 0, 80 )

	--Main Page of the menu
	local mainLayout = vgui.Create( "NZMainMenuContentLayout" )

	self:AddLayout( "main", mainLayout )

	--Set Active page to main on Init
	self:SetActiveLayout( "main" )

end

function MenuContent:SetActiveLayout( name )
	self:GetActiveLayout():SetVisible( false )
	self.ActiveLayout = name
	self:GetActiveLayout():SetVisible( true )
end

function MenuContent:GetActiveLayout()
	return self.Layouts[ self.ActiveLayout ]
end

function MenuContent:Paint()
	return
end

function MenuContent:AddLayout( name, layout )
	layout:SetParent( self )
	self.Layouts[name] = layout
end

vgui.Register( "NZMainMenuContent", MenuContent, "DPanel")


local MenuContentLayout = {}

function MenuContentLayout:Init()
	self.Panels = {}
	self:SetSize( 768, 512 )
	self:SetPos( ScrW() / 2 - 384, ScrH() / 2 - 320 )
	self:SetVisible( false )
end

function MenuContentLayout:GetPanels()
	return self.Panels
end

function MenuContentLayout:Paint()
	return
end

function MenuContentLayout:AddPanel( pnl, startGridX, startGridY, gridSizeX, gridSizeY )
	local gridSize = 128
	pnl:SetParent( self )
	pnl:SetPos( gridSize * ( startGridX - 1 ), gridSize * (startGridY - 1) )
	pnl:SetSize( gridSize * gridSizeX, gridSize * gridSizeY )
	table.insert( self.Panels, pnl )
end

vgui.Register( "NZMainMenuContentLayout", MenuContentLayout, "DPanel")

local PlayerList = {}

function PlayerList:Init()
	self:SetPos(100, 200)
	self:SetSize(500, 800)
end

local bloodline_points = Material("bloodline_score.png", "unlitgeneric smooth")
function PlayerList:Paint(w, h)
	local c = 0
	local n = #player.GetAllReady()
	for _,ply in pairs( player.GetAll() ) do
		if IsValid(ply) then
			local text = ""
			surface.SetMaterial(bloodline_points)
			surface.SetDrawColor(200,0,0)
			surface.DrawTexturedRect(0, h / 2 - n * 17.5 + 35 * c, 300, 40)
			if ply:IsReady() then text = "Ready" else
				if nzRound:InState(ROUND_CREATE) and ply:Alive() then
					text = "In Creative"
				else
					text = "Not ready"
				end
			end
			draw.SimpleText(ply:Nick() .. " - " .. text, ("nz.small."..GetFontType(nzMapping.Settings.smallfont)), 25, h / 2 - n * 17.5 + 35 * c + 15, Color(255,255,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			c = c + 1
		end
	end
	return
end

vgui.Register( "NZMainMenuPlayerList", PlayerList, "DPanel")


local function showSettings(ply, cmd, args)
	if ( !IsValid( g_Settings ) ) then
		g_Settings = vgui.Create("NZMainMenuFrame")
		g_Settings:SetVisible(false) -- use the visible bool as toggle indicator TODO: this is bullshit since we are removing the menu anyways
	end

	if ( IsValid( g_Settings ) ) then
		if g_Settings:IsVisible() then
			g_Settings:Hide()
			gui.EnableScreenClicker( false )
			g_Settings:SetVisible(false)
			g_Settings:Remove()
		else
			g_Settings:Show()
			gui.EnableScreenClicker( true )
			g_Settings:SetVisible(true)
			
			if IsValid(nzInterfaces.ConfigVoter) then nzInterfaces.ConfigVoter:Show() end -- Reopen config voter as well if a vote is going on
		end
	end
end
concommand.Add("nz_settings", showSettings)

hook.Add("InitPostEntity", "AutoOpenMenu", function()
	LocalPlayer():ConCommand("nz_settings")
end)
