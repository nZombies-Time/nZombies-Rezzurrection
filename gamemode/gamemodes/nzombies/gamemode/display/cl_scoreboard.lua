local columns = {
	{Text = "Ping", Get = function(ply) return ply:Ping() end, Order = 0},
	--{Text = "Headshots", Get = function(ply) return ply:Headshots() end, Order = 10},
	{Text = "Revives", Get = function(ply) return ply:GetTotalRevives() end, Order = 20},
	{Text = "Downs", Get = function(ply) return ply:GetTotalDowns() end, Order = 30},
	{Text = "Kills", Get = function(ply) return ply:GetTotalKills() end, Order = 40},
	{Text = "Score", Get = function(ply) return ply:GetPoints() end, Width = 200, Order = 50},
}

local lineheight = 25
local statwidth = 100

local color_base = Color(0,0,0,240)
local color_alt = Color(0,30,40,240)

local font = "nz.grenade"
local textcol = Color(255,255,255)
local textcol_highlight = Color(255,255,50)

local zmhud_icon_voiceon = Material("nz_moo/icons/voice_on.png", "unlitgeneric smooth")
local zmhud_icon_voicedim = Material("nz_moo/icons/voice_on_dim.png", "unlitgeneric smooth")
local zmhud_icon_voiceoff = Material("nz_moo/icons/voice_off.png", "unlitgeneric smooth")

local matblur = Material("pp/blurscreen")
local function barpaint(self,w,h)
	surface.SetMaterial(matblur)
	surface.SetDrawColor(self.m_bgColor)

	local x,y = self:LocalToScreen(0,0)
	for i = 0.33,1,0.33 do
		matblur:SetFloat("$blur", 5*i)
		matblur:Recompute()
		if render then render.UpdateScreenEffectTexture() end
		surface.DrawTexturedRect(-x,-y,ScrW(),ScrH())
	end

	self:DrawFilledRect()
end

local PLAYERLINE = {
	Init = function(self)
		self.Labels = {}
		self.Values = {}
		for k,v in pairs(columns) do
			local p = self:Add("DPanel")
			p:Dock(RIGHT)
			p:SetZPos(v.Order or 0)
			p:SetWide(v.Width or statwidth)
			p:SetBackgroundColor(k%2 == 0 and color_base or color_alt)
			--p:SetBackgroundColor(color_base)
			p.Paint = barpaint

			local lbl = p:Add("DLabel")
			lbl:SetWide(statwidth)
			lbl:SetFont(font)
			lbl:Dock(FILL)
			lbl:SetContentAlignment(5)

			self.Labels[k] = lbl
		end

		local main = self:Add("DPanel")
		main:Dock(FILL)
		main:SetBackgroundColor(color_base)
		main.Paint = barpaint

		self.PlayerAvatar = main:Add( "AvatarImage", self.AvatarButton )
		self.PlayerAvatar:Dock(LEFT)
		self.PlayerAvatar:DockMargin(5,5,5,5)
		self.PlayerAvatar:SetWide(lineheight - 10)

		self.Name = main:Add("DLabel")
		self.Name:SetFont(font)
		self.Name:Dock(FILL)

		local profilebut = self:Add("DButton")
		profilebut:Dock(FILL)
		profilebut:SetText("")
		profilebut.Paint = function() end
		profilebut.DoClick = function()
			self.Player:ShowProfile()
		end

		local mutebut = profilebut:Add("DButton")
		mutebut:Dock(LEFT)
		mutebut:SetMaterial(nil)
		mutebut:SetSize(32, 32)
		mutebut:SetText("")
		mutebut.Paint = function() end
		mutebut.DoClick = function()
			mutebut:SetMaterial(not self.Player:IsMuted() and zmhud_icon_voiceoff or nil)
			self.Player:SetMuted(not self.Player:IsMuted())
		end
	end,
	Setup = function(self, ply)
		self.Player = ply
		self.PlayerAvatar:SetPlayer(ply)

		local col = ply == LocalPlayer() and textcol_highlight or textcol
		for k,v in pairs(self.Labels) do
			v:SetTextColor(col)
		end
		self.Name:SetTextColor(col)

		self:Think()
	end,
	Think = function(self)
		if not IsValid(self.Player)then
			self:SetZPos(99999)
			self:Remove()
		return end

		for k,v in pairs(self.Labels) do
			if self.Values[k] == nil or self.Values[k] ~= columns[k].Get(self.Player) then
				self.Values[k] = columns[k].Get(self.Player)
				v:SetText(self.Values[k])
			end
		end

		if self.PName == nil or self.PName ~= self.Player:Nick() then
			self.PName = self.Player:Nick()
			self.Name:SetText(self.PName)
		end
	end,
}
PLAYERLINE = vgui.RegisterTable(PLAYERLINE, "Panel")

local SCOREBOARD = {
	Init = function(self)
		local server = self:Add("DLabel")
		server:Dock(TOP)
		server:SetText(GetHostName())
		server:SetFont("nz.small.classic")
		server:SetTextColor(Color(255,0,0))
		server:SetContentAlignment(5)
		server:SizeToContentsY()
		server:DockMargin(0,0,0,5)

		local header = self:Add("DPanel")
		header:Dock(TOP)
		header:SetHeight(lineheight)
		header:DockMargin(0,0,0,2)
		for k,v in pairs(columns) do
			local lbl = header:Add("DLabel")
			lbl:SetText(v.Text)
			lbl:SetWide(v.Width or statwidth)
			lbl:Dock(RIGHT)
			lbl:SetFont(font)
			lbl:SetContentAlignment(5)
			lbl:SetZPos(v.Order or 0)
		end
		header:SetBackgroundColor(color_base)
		header.Paint = barpaint

		self.ConfigName = header:Add("DLabel")
		self.ConfigName:Dock(FILL)
		self.ConfigName:DockMargin(5,5,5,5)
		self.ConfigName:SetFont(font)
		self.ConfigName:SetText(game.GetMap())

		self.Lines = self:Add("DScrollPanel")
		self.Lines:Dock(FILL)
		end,
	PerformLayout = function(self)
		self:SetSize(ScrW()/2, ScrH() - 200)
		self:SetPos(ScrW()/4, 100)
	end,
	Think = function(self)
		for k,v in pairs(player.GetAll()) do
			if not IsValid(v.ScoreboardLine)then
				v.ScoreboardLine = vgui.CreateFromTable(PLAYERLINE, self.Lines)
				v.ScoreboardLine:Dock(TOP)
				v.ScoreboardLine:SetTall(lineheight)
				v.ScoreboardLine:Setup(v)
				self.Lines:AddItem(v.ScoreboardLine)
			end
		end

		if IsValid(self.GameOverPanel) and nzu.Round:GetState() ~= ROUND_GAMEOVER then
			self.GameOverPanel:Remove()
			self:Hide()
		end
	end,
}
SCOREBOARD = vgui.RegisterTable(SCOREBOARD, "EditablePanel")

local scoreboard
local function show()
	if not IsValid(scoreboard) then
		scoreboard = vgui.CreateFromTable(SCOREBOARD)
	end

	scoreboard:Show()
	scoreboard:MakePopup()
	scoreboard:SetKeyboardInputEnabled(false)
end

function GM:ScoreboardShow()
	show()
end

function GM:ScoreboardHide()
	if IsValid(scoreboard) then
		if not scoreboard.GameOverShown or nzu.Round:GetState() ~= ROUND_GAMEOVER then
			scoreboard:Hide()
		end
	end
end

--[[-------------------------------------------------------------------------
Game over sequence panel
---------------------------------------------------------------------------]]

-- Global so extensions can replace it
local gameoverpanelfunc = function()
	local p = vgui.Create("Panel")
	local txt = p:Add("DLabel")
	txt:SetFont("nz.small.default")
	txt:SetTextColor(Color(150,0,0))
	txt:SetText("GAME OVER")
	txt:SetContentAlignment(5)
	txt:Dock(FILL)
	txt:DockMargin(0,0,0,-50)

	local r = p:Add("DLabel")
	r:SetFont("nz.small.default")
	r:SetText(nzu.Round:GetRound() == 1 and "You survived 1 round." or "You survived "..(nzu.Round:GetRound() or 0).." rounds.")
	r:SetTextColor(Color(150,0,0))
	r:SetContentAlignment(5)
	r:Dock(BOTTOM)
	r:SizeToContentsY()
	r:DockMargin(0,0,0,50)

	p:SetTall(250)
	p:SetWide(1000)

	return p
end

local gameoverpanel
hook.Add("nzu_GameOverSequence", "nzu_Scoreboard_ShowOnGameOver", function(time)
	if not LocalPlayer()then
		local gp = gameoverpanel
		if not gp then
			local hud = nzu.HUD
			if hud and hud.GameOverPanel then
				gp = hud:GameOverPanel()
			else
				gp = gameoverpanelfunc()
			end
		end

		show()

		gp:SetParent(scoreboard)
		gp:Dock(TOP)
		gp:SetZPos(-1000)

		scoreboard.GameOverPanel = gp
		gameoverpanel = nil
	end
end)

hook.Add("nzu_GameOver", "nzu_Scoreboard_ShowGameOverText", function(time)
	if not LocalPlayer()then
		if IsValid(gameoverpanel) then gameoverpanel:Remove() end

		local hud = nzu.HUD
		if hud and hud.GameOverPanel then -- Ask the HUD object to define a Game Over panel
			gameoverpanel = hud:GameOverPanel()
		else
			gameoverpanel = gameoverpanelfunc()
		end

		gameoverpanel:ParentToHUD()
		gameoverpanel:SetPos(ScrW()/2 - gameoverpanel:GetWide()/2, ScrH()/2 - gameoverpanel:GetTall()/2)
		gameoverpanel:SetVisible(true)
	end
end)

hook.Add("nzu_PlayerUnspawned", "nzu_Scoreboard_RemoveGameOverText", function(ply)
	if ply == LocalPlayer() and IsValid(gameoverpanel) then gameoverpanel:Remove() end
end)