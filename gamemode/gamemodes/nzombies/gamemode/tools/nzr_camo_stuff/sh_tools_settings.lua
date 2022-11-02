nzTools:CreateTool("settings", {
	displayname = "Map Settings",
	desc = "Use the Tool Interface and press Submit to save changes",
	condition = function(wep, ply)
		return true
	end,

	PrimaryAttack = function(wep, ply, tr, data)
	end,
	SecondaryAttack = function(wep, ply, tr, data)
	end,
	Reload = function(wep, ply, tr, data)
	end,
	OnEquip = function(wep, ply, data)
	end,
	OnHolster = function(wep, ply, data)
	end
}, {
	displayname = "Map Settings",
	desc = "Use the Tool Interface and press Submit to save changes",
	icon = "icon16/cog.png",
	weight = 25,
	condition = function(wep, ply)
		return true
	end,
	interface = function(frame, data)
		local data = table.Copy(nzMapping.Settings)
		local valz = {}
		valz["Row1"] = data.startwep or "Select ..."
		valz["Knife"] = data.knife or "Select ..."
		valz["Row2"] = data.startpoints or 500
		valz["Row3"] = data.eeurl or ""
		valz["Row4"] = data.script or false
		valz["Row5"] = data.scriptinfo or ""
		valz["Row6"] = data.gamemodeentities or false
		valz["Row7"] = data.specialroundtype or "Hellhounds"
		valz["Row8"] = data.bosstype or "Panzer"
		valz["Row9"] = data.startingspawns == nil and 35 or data.startingspawns
		valz["Row10"] = data.spawnperround == nil and 0 or data.spawnperround
		valz["Row11"] = data.maxspawns == nil and 35 or data.maxspawns
		valz["Row13"] = data.zombiesperplayer == nil and 0 or data.zombiesperplayer
		valz["Row14"] = data.spawnsperplayer == nil and 0 or data.spawnsperplayer
		valz["Row15"] = data.zombietype or "Kino der Toten"
		valz["Row16"] = data.hudtype or "Origins (Black Ops 2)"
		valz["Row17"] = data.zombieeyecolor == nil and Color(0, 255, 255, 255) or data.zombieeyecolor
		valz["Row18"] = data.perkmachinetype or "Original"
		valz["Row19"] = data.boxtype or "Original"
		valz["Row20"] = data.boxlightcolor == nil and Color(0,150,200,255) or data.boxlightcolor
		valz["Row21"] = data.newwave1 or 20
		valz["Row22"] = data.newtype1 or "Hellhounds"
		valz["Row23"] = data.newratio1 or 0.5
		valz["Row24"] = data.newwave2 or 0
		valz["Row25"] = data.newtype2 or "None"
		valz["Row26"] = data.newratio2 or 0
		valz["Row27"] = data.newwave3 or 0
		valz["Row28"] = data.newtype3 or "None"
		valz["Row29"] = data.newratio3 or 0
		valz["Row30"] = data.newwave4 or 0
		valz["Row31"] = data.newtype4 or "None"
		valz["Row32"] = data.newratio4 or 0
		valz["Row33"] = data.mainfont or "Default NZR"
		valz["Row34"] = data.smallfont or "Default NZR"
		valz["Row35"] = data.mediumfont or "Default NZR"
		valz["Row36"] = data.roundfont or "Classic NZ"
		valz["Row37"] = data.ammofont or "Default NZR"
		valz["Row38"] = data.ammo2font or "Default NZR"
		valz["Row39"] = data.textcolor == nil and Color(0, 255, 255, 255) or data.textcolor
		valz["Row40"] = data.fontthicc or 2
		valz["Row41"] = data.icontype or "Rezzurrection"
		valz["Row42"] = data.perkupgrades or false
		valz["Row43"] = data.PAPtype or "Original"
		valz["Row44"] = data.PAPcamo or "nz_classic"
		valz["Row45"] = data.hp or 100
		valz["Row46"] = data.range or 2000
		valz["Row47"] = data.sharing or false
		valz["Row48"] = data.eemdl or "Hula Doll"
		valz["RBoxWeps"] = data.RBoxWeps or {}
		valz["ACRow1"] = data.ac == nil and false or data.ac
		valz["ACRow2"] = data.acwarn == nil and true or data.acwarn
		valz["ACRow3"] = data.acsavespot == nil and true or tobool(data.acsavespot)
		valz["ACRow4"] = data.actptime == nil and 5 or data.actptime
		valz["ACRow5"] = data.acpreventboost == nil and true or tobool(data.acpreventboost)
		valz["ACRow6"] = data.acpreventcjump == nil and false or tobool(data.acpreventcjump)

		if (ispanel(sndFilePanel)) then sndFilePanel:Remove() end

		-- Cache all Wunderfizz perks for saving/loading allowed Wunderfizz perks:
		local wunderfizzlist = {}
		for k,v in pairs(nzPerks:GetList()) do
			if k != "wunderfizz" and k != "pap" then
				wunderfizzlist[k] = {true, v}
			end
		end

		valz["Wunderfizz"] = data.wunderfizzperklist == nil and wunderfizzlist or data.wunderfizzperklist

		-- More compact and less messy:
		for k,v in pairs(nzSounds.struct) do
			valz["SndRow" .. k] = data[v] or {}
		end


		local sheet = vgui.Create( "DPropertySheet", frame )
		sheet:SetSize( 480, 430 )
		sheet:SetPos( 10, 10 )

		local DProperties = vgui.Create( "DProperties", DProperySheet )
		DProperties:SetSize( 280, 220 )
		DProperties:SetPos( 0, 0 )
		sheet:AddSheet( "Map Properties", DProperties, "icon16/cog.png", false, false, "Set a list of general settings. The Easter Egg Song URL needs to be from Soundcloud.")

		local Row1 = DProperties:CreateRow( "Map Settings", "Starting Weapon" )
		Row1:Setup( "Combo" )
		for k,v in pairs(weapons.GetList()) do
			if !v.NZTotalBlacklist then
				if v.Category and v.Category != "" then
					Row1:AddChoice(v.PrintName and v.PrintName != "" and v.Category.. " - "..v.PrintName or v.ClassName, v.ClassName, false)
				else
					Row1:AddChoice(v.PrintName and v.PrintName != "" and v.PrintName or v.ClassName, v.ClassName, false)
				end
			end
		end
		if data.startwep then
			local wep = weapons.Get(data.startwep)
			if !wep and weapons.Get(nzConfig.BaseStartingWeapons) and #weapons.Get(nzConfig.BaseStartingWeapons) >= 1 then wep = weapons.Get("robotnik_bo1_1911") end
			if wep != nil then  
				if wep.Category and wep.Category != "" then
					Row1:AddChoice(wep.PrintName and wep.PrintName != "" and wep.Category.. " - "..wep.PrintName or wep.ClassName, wep.ClassName, false)
				else
					Row1:AddChoice(wep.PrintName and wep.PrintName != "" and wep.PrintName or wep.ClassName, wep.ClassName, false)
				end
			end
		end

		Row1.DataChanged = function( _, val ) valz["Row1"] = val end
		
			local kniferow = DProperties:CreateRow( "Map Settings", "Knife" )
		kniferow:Setup( "Combo" )
		for k,v in pairs(weapons.GetList()) do
				if v.Category and v.Category == "nZombies Knives" then
					kniferow:AddChoice(v.PrintName and v.PrintName != "" and v.Category.. " - "..v.PrintName or v.ClassName, v.ClassName, false)
				end
		end
		if data.knife then
			local wep = weapons.Get(data.knife)
			if !wep  then wep = weapons.Get("nz_knife_boring") end
			if wep != nil then  
				if wep.Category and wep.Category == "nzombies Knives" then
					kniferow:AddChoice(wep.PrintName and wep.PrintName != "" and wep.Category.. " - "..wep.PrintName or wep.ClassName, wep.ClassName, false)
				end
			end
		end

		kniferow.DataChanged = function( _, val ) valz["Knife"] = val end

		local Row2 = DProperties:CreateRow( "Map Settings", "Starting Points" )
		Row2:Setup( "Integer" )
		Row2:SetValue( valz["Row2"] )
		Row2.DataChanged = function( _, val ) valz["Row2"] = val end
		
			local Row4 = DProperties:CreateRow( "Map Settings", "Includes Map Script?" )
			Row4:Setup( "Boolean" )
			Row4:SetValue( valz["Row4"] )
			Row4.DataChanged = function( _, val ) valz["Row4"] = val end
			Row4:SetTooltip("Loads a .lua file with the same name as the config .txt from /lua/nzmapscripts - for advanced developers.")
		
			local Row5 = DProperties:CreateRow( "Map Settings", "Script Description" )
			Row5:Setup( "Generic" )
			Row5:SetValue( valz["Row5"] )
			Row5.DataChanged = function( _, val ) valz["Row5"] = val end
			Row5:SetTooltip("Sets the description displayed when attempting to load the script.")
			
			local Row6 = DProperties:CreateRow( "Map Settings", "GM Extensions" )
			Row6:Setup("Boolean")
			Row6:SetValue( valz["Row6"] )
			Row6.DataChanged = function( _, val ) valz["Row6"] = val end
			Row6:SetTooltip("Sets whether the gamemode should spawn in map entities from other gamemodes, such as ZS.")

			local Row7 = DProperties:CreateRow("Map Settings", "Special Round")
			Row7:Setup( "Combo" )
			local found = false
			for k,v in pairs(nzRound.SpecialData) do
				if k == valz["Row7"] then
					Row7:AddChoice(k, k, true)
					found = true
				else
					Row7:AddChoice(k, k, false)
				end
			end
			Row7:AddChoice(" None", "None", !found)
			Row7.DataChanged = function( _, val ) valz["Row7"] = val end
			Row7:SetTooltip("Sets what type of special round will appear.")
			
			local Row8 = DProperties:CreateRow( "Map Settings", "Boss" )
			Row8:Setup( "Combo" )
			local found = false
			for k,v in pairs(nzRound.BossData) do
				if k == valz["Row8"] then
					Row8:AddChoice(k, k, true)
					found = true
				else
					Row8:AddChoice(k, k, false)
				end
			end
			Row8:AddChoice(" None", "None", !found)
			Row8.DataChanged = function( _, val ) valz["Row8"] = val end
			Row8:SetTooltip("Sets what type of boss will appear.")
			
			local Row9 = DProperties:CreateRow("Map Settings", "Starting Spawns")
			Row9:Setup( "Integer" )
			Row9:SetValue( valz["Row9"] )
			Row9:SetTooltip("Allowed zombies alive at once, can be increased per round with Spawns Per Round")
			Row9.DataChanged = function( _, val ) valz["Row9"] = val end

			local Row10 = DProperties:CreateRow("Map Settings", "Spawns Per Round")
			Row10:Setup( "Integer" )
			Row10:SetValue( valz["Row10"] )
			Row10:SetTooltip("Amount to increase spawns by each round (Cannot increase past Max Spawns)")
			Row10.DataChanged = function( _, val ) valz["Row10"] = val end

			local Row11 = DProperties:CreateRow("Map Settings", "Max Spawns")
			Row11:Setup( "Integer" )
			Row11:SetValue( valz["Row11"] )
			Row11:SetTooltip("The max allowed zombies alive at any given time, it will NEVER go above this.")
			Row11.DataChanged = function( _, val ) valz["Row11"] = val end

			local Row13 = DProperties:CreateRow("Map Settings", "Zombies Per Player")
			Row13:Setup( "Integer" )
			Row13:SetValue( valz["Row13"] )
			Row13:SetTooltip("Extra zombies to kill per player (Ignores first player)")
			Row13.DataChanged = function( _, val ) valz["Row13"] = val end

			local Row14 = DProperties:CreateRow("Map Settings", "Spawns Per Player")
			Row14:Setup( "Integer" )
			Row14:SetValue( valz["Row14"] )
			Row14:SetTooltip("Extra zombies allowed to spawn per player (Ignores first player and Max Spawns option)")
			Row14.DataChanged = function( _, val ) valz["Row14"] = val end
			
			local Row15 = DProperties:CreateRow("Map Settings", "Zombie Type")
			Row15:Setup( "Combo" )
			local found = false
			for k,v in pairs(nzRound.ZombieSkinData) do
				if k == valz["Row15"] then
					Row15:AddChoice(k, k, true)
					found = true
				else
					Row15:AddChoice(k, k, false)
				end
			end
			Row15.DataChanged = function( _, val ) valz["Row15"] = val end
			Row15:SetTooltip("Sets the zombies that will appear in your map.")
			
			local Row16 = DProperties:CreateRow("Map Settings", "HUD Select")
			Row16:Setup( "Combo" )
			local found = false
			for k,v in pairs(nzRound.HudSelectData) do
				if k == valz["Row16"] then
					Row16:AddChoice(k, k, true)
					found = true
				else
					Row16:AddChoice(k, k, false)
				end
			end
			Row16.DataChanged = function( _, val ) valz["Row16"] = val end
			Row16:SetTooltip("Sets the HUD players will see in your map")
			
			local Row18 = DProperties:CreateRow("Map Settings", "Perk Machine Skins")
			Row18:Setup( "Combo" )
			local found = false
			for k,v in pairs(nzRound.PerkSelectData) do
				if k == valz["Row18"] then
					Row18:AddChoice(k, k, true)
					found = true
				else
					Row18:AddChoice(k, k, false)
				end
			end
			Row18.DataChanged = function( _, val ) valz["Row18"] = val end
			Row18:SetTooltip("Sets the Perk Machines Appearance")
			
			local Row19 = DProperties:CreateRow("Map Settings", "Mystery Box Skin")
			Row19:Setup( "Combo" )
			local found = false
			for k,v in pairs(nzRound.BoxSkinData) do
				if k == valz["Row19"] then
					Row19:AddChoice(k, k, true)
					found = true
				else
					Row19:AddChoice(k, k, false)
				end
			end
			Row19.DataChanged = function( _, val ) valz["Row19"] = val end
			Row19:SetTooltip("Sets the Mystery Box Skin")
			
			local DProperties3 = vgui.Create( "DProperties", enemysheet )
		DProperties3:SetSize( 280, 220 )
		DProperties3:SetPos( 0, 0 )
		sheet:AddSheet( "Extra Enemy Settings", DProperties3, "icon16/user_gray.png", false, false, "Change extra enemy settings")
		
		local Row21 = DProperties3:CreateRow( "Dynamic Enemy System", "Extra Enemy Interval 1" )
		Row21:Setup( "Integer" )
		Row21:SetValue( valz["Row21"] )
		Row21.DataChanged = function( _, val ) valz["Row21"] = val end
		
		local Row22 = DProperties3:CreateRow( "Dynamic Enemy System", "Extra Enemy 1")
			Row22:Setup( "Combo" )
			local found = false
			for k,v in pairs(nzRound.AdditionalZombieData) do
				if k == valz["Row22"] then
					Row22:AddChoice(k, k, true)
					found = true
				else
					Row22:AddChoice(k, k, false)
				end
			end
			Row22:AddChoice(" None", "None", !found)
			Row22.DataChanged = function( _, val ) valz["Row22"] = val end
			Row22:SetTooltip("Sets what type of new enemy will appear on the first new enemy interval")
			
		local Row23 = DProperties3:CreateRow( "Dynamic Enemy System", "Extra Enemy 1 Ratio" )
		Row23:Setup( "Integer" )
		Row23:SetValue( valz["Row23"] )
		Row23.DataChanged = function( _, val ) valz["Row23"] = val end
		
		local Row24 = DProperties3:CreateRow( "Dynamic Enemy System", "Extra Enemy Interval 2" )
		Row24:Setup( "Integer" )
		Row24:SetValue( valz["Row24"] )
		Row24.DataChanged = function( _, val ) valz["Row24"] = val end
		
		local Row25 = DProperties3:CreateRow( "Dynamic Enemy System", "Extra Enemy 2")
			Row25:Setup( "Combo" )
			local found = false
			for k,v in pairs(nzRound.AdditionalZombieData) do
				if k == valz["Row25"] then
					Row25:AddChoice(k, k, true)
					found = true
				else
					Row25:AddChoice(k, k, false)
				end
			end
			Row25:AddChoice(" None", "None", !found)
			Row25.DataChanged = function( _, val ) valz["Row25"] = val end
			Row25:SetTooltip("Sets what type of new enemy will appear on the second new enemy interval")
			
		local Row26 = DProperties3:CreateRow( "Dynamic Enemy System", "Extra Enemy 2 Ratio" )
		Row26:Setup( "Integer" )
		Row26:SetValue( valz["Row26"] )
		Row26.DataChanged = function( _, val ) valz["Row26"] = val end
		
		local Row27 = DProperties3:CreateRow( "Dynamic Enemy System", "Extra Enemy Interval 3" )
		Row27:Setup( "Integer" )
		Row27:SetValue( valz["Row27"] )
		Row27.DataChanged = function( _, val ) valz["Row27"] = val end
		
		local Row28 = DProperties3:CreateRow( "Dynamic Enemy System", "Extra Enemy 3")
			Row28:Setup( "Combo" )
			local found = false
			for k,v in pairs(nzRound.AdditionalZombieData) do
				if k == valz["Row28"] then
					Row28:AddChoice(k, k, true)
					found = true
				else
					Row28:AddChoice(k, k, false)
				end
			end
			Row28:AddChoice(" None", "None", !found)
			Row28.DataChanged = function( _, val ) valz["Row28"] = val end
			Row28:SetTooltip("Sets what type of new enemy will appear on the third new enemy interval")
			
		local Row29 = DProperties3:CreateRow( "Dynamic Enemy System", "Extra Enemy 3 Ratio" )
		Row29:Setup( "Integer" )
		Row29:SetValue( valz["Row29"] )
		Row29.DataChanged = function( _, val ) valz["Row29"] = val end
		
		local Row30 = DProperties3:CreateRow( "Dynamic Enemy System", "Extra Enemy Interval 4" )
		Row30:Setup( "Integer" )
		Row30:SetValue( valz["Row30"] )
		Row30.DataChanged = function( _, val ) valz["Row30"] = val end
		
		local Row31 = DProperties3:CreateRow( "Dynamic Enemy System", "Extra Enemy 4")
			Row31:Setup( "Combo" )
			local found = false
			for k,v in pairs(nzRound.AdditionalZombieData) do
				if k == valz["Row31"] then
					Row31:AddChoice(k, k, true)
					found = true
				else
					Row31:AddChoice(k, k, false)
				end
			end
			Row31:AddChoice(" None", "None", !found)
			Row31.DataChanged = function( _, val ) valz["Row31"] = val end
			Row31:SetTooltip("Sets what type of new enemy will appear on the fourth new enemy interval")
			
			local Row32 = DProperties3:CreateRow( "Dynamic Enemy System", "Extra Enemy 4 Ratio" )
		Row32:Setup( "Integer" )
		Row32:SetValue( valz["Row32"] )
		Row32.DataChanged = function( _, val ) valz["Row32"] = val end
		
		local DProperties2 = vgui.Create( "DProperties", fontsheet )
		DProperties2:SetSize( 280, 220 )
		DProperties2:SetPos( 0, 0 )
		sheet:AddSheet( "Font Settings", DProperties2, "icon16/font.png", false, false, "Change font settings")
		
		local Row33 = DProperties2:CreateRow("Font Settings", "Main Menu Font")
			Row33:Setup( "Combo" )
			local found = false
			for k,v in pairs(nzRound.FontSelection) do
				if k == valz["Row33"] then
					Row33:AddChoice(k, k, true)
					found = true
				else
					Row33:AddChoice(k, k, false)
				end
			end
			Row33.DataChanged = function( _, val ) valz["Row33"] = val end
			Row33:SetTooltip("Changes the font of the main font")
			
		local Row34 = DProperties2:CreateRow("Font Settings", "Gun Name and Pickup Font")
			Row34:Setup( "Combo" )
			local found = false
			for k,v in pairs(nzRound.FontSelection) do
				if k == valz["Row34"] then
					Row34:AddChoice(k, k, true)
					found = true
				else
					Row34:AddChoice(k, k, false)
				end
			end
			Row34.DataChanged = function( _, val ) valz["Row34"] = val end
			Row34:SetTooltip("Changes the font of the name of your gun and interactibles")
		
		local Row35 = DProperties2:CreateRow("Font Settings", "Point Display Font")
			Row35:Setup( "Combo" )
			local found = false
			for k,v in pairs(nzRound.FontSelection) do
				if k == valz["Row35"] then
					Row35:AddChoice(k, k, true)
					found = true
				else
					Row35:AddChoice(k, k, false)
				end
			end
			Row35.DataChanged = function( _, val ) valz["Row35"] = val end
			Row35:SetTooltip("Changes the font of the point displays")
		
		local Row36 = DProperties2:CreateRow("Font Settings", "Round Font")
			Row36:Setup( "Combo" )
			local found = false
			for k,v in pairs(nzRound.FontSelection) do
				if k == valz["Row36"] then
					Row36:AddChoice(k, k, true)
					found = true
				else
					Row36:AddChoice(k, k, false)
				end
			end
			Row36.DataChanged = function( _, val ) valz["Row36"] = val end
			Row36:SetTooltip("Changes the font of the round")
		
		local Row37 = DProperties2:CreateRow("Font Settings", "Ammo Font")
			Row37:Setup( "Combo" )
			local found = false
			for k,v in pairs(nzRound.FontSelection) do
				if k == valz["Row37"] then
					Row37:AddChoice(k, k, true)
					found = true
				else
					Row37:AddChoice(k, k, false)
				end
			end
			Row37.DataChanged = function( _, val ) valz["Row37"] = val end
			Row37:SetTooltip("Changes the font of points gained")
		
		local Row38 = DProperties2:CreateRow("Font Settings", "Ammo 2 Font")
			Row38:Setup( "Combo" )
			local found = false
			for k,v in pairs(nzRound.FontSelection) do
				if k == valz["Row38"] then
					Row38:AddChoice(k, k, true)
					found = true
				else
					Row38:AddChoice(k, k, false)
				end
			end
			Row38.DataChanged = function( _, val ) valz["Row38"] = val end
			Row38:SetTooltip("Changes the font of points gained")
		
		local Row40 = DProperties2:CreateRow( "Font Settings", "Font Thickness" )
		Row40:Setup( "Integer" )
		Row40:SetValue( valz["Row40"] )
		Row40.DataChanged = function( _, val ) valz["Row40"] = val end
			
		local Row41 = DProperties:CreateRow("Map Settings", "Perk Icons")
			Row41:Setup( "Combo" )
			local found = false
			for k,v in pairs(nzRound.IconSelectData) do
				if k == valz["Row41"] then
					Row41:AddChoice(k, k, true)
					found = true
				else
					Row41:AddChoice(k, k, false)
				end
			end
			Row41.DataChanged = function( _, val ) valz["Row41"] = val end
			Row41:SetTooltip("Changes the style of the perk icons")
			
			local Row42 = DProperties:CreateRow( "Map Settings", "Perk Upgrades?" )
			Row42:Setup( "Boolean" )
			Row42:SetValue( valz["Row42"] )
			Row42.DataChanged = function( _, val ) valz["Row42"] = val end
			Row42:SetTooltip("Enable upgradeable perks on this config")
			
			local Row43 = DProperties:CreateRow("Map Settings", "Pack-A-Punch Skins")
			Row43:Setup( "Combo" )
			local found = false
			for k,v in pairs(nzRound.PAPSelectData) do
				if k == valz["Row43"] then
					Row43:AddChoice(k, k, true)
					found = true
				else
					Row43:AddChoice(k, k, false)
				end
			end
			Row43.DataChanged = function( _, val ) valz["Row43"] = val end
			Row43:SetTooltip("Sets the Pack-A-Punch skin")
			
			
			local Row44 = DProperties:CreateRow("Map Settings", "Pack-A-Punch Camo")
			Row44:Setup( "Combo" )
			local found = false
			for k, v in pairs(nzCamos.Data) do
				if k == valz["Row44"] then
					Row44:AddChoice(nzCamos:Get(k).name, k, true)
					found = true
				else
					Row44:AddChoice(nzCamos:Get(k).name, k, false)
				end
			end
			Row44.DataChanged = function( _, val ) valz["Row44"] = val end
			Row44:SetTooltip("Sets the Global Pack-A-Punch Camo")

			local Row45 = DProperties:CreateRow( "Map Settings", "Player Base Health" )
		Row45:Setup( "Integer" )
		Row45:SetValue( valz["Row45"] )
		Row45.DataChanged = function( _, val ) valz["Row45"] = val end
		

		
		local Row46 = DProperties:CreateRow( "Map Settings", "Zombie Search Range" )
		Row46:Setup( "Integer" )
		Row46:SetValue( valz["Row46"] )
		Row46.DataChanged = function( _, val ) valz["Row46"] = val end
		Row46:SetTooltip("Sets zombie search range. 0 is infinite search range and not recommended. Must be positive")
		
		local Row47 = DProperties:CreateRow( "Map Settings", "Mystery Box Sharing?" )
			Row47:Setup( "Boolean" )
			Row47:SetValue( valz["Row47"] )
			Row47.DataChanged = function( _, val ) valz["Row47"] = val end
			Row47:SetTooltip("To be a box communist or not to be a box communist")
		
		local Row48 = DProperties:CreateRow("Map Settings", "Easter egg song Model")
			Row48:Setup( "Combo" )
			local found = false
			for k,v in pairs(nzRound.eemodel) do
				if k == valz["Row48"] then
					Row48:AddChoice(k, k, true)
					found = true
				else
					Row48:AddChoice(k, k, false)
				end
			end
			Row48.DataChanged = function( _, val ) valz["Row48"] = val end
			Row48:SetTooltip("Sets the model for the easteregg song")
		
		
		
		if nzTools.Advanced then
		local Row3 = DProperties:CreateRow( "Map Settings", "Easter Egg Song URL (deprecated)" )
		Row3:Setup( "Generic" )
		Row3:SetValue( valz["Row3"] )
		Row3.DataChanged = function( _, val ) valz["Row3"] = val end
		Row3:SetTooltip("The original way easter egg songs were played. Does not work, do not use.")
		end


		local function UpdateData() -- Will remain a local function here. There is no need for the context menu to intercept
			if !weapons.Get( valz["Row1"] ) then data.startwep = nil else data.startwep = valz["Row1"] end
			if !weapons.Get( valz["Knife"] ) then data.knife = nil else data.knife = valz["Knife"] end
			if !tonumber(valz["Row2"]) then data.startpoints = 500 else data.startpoints = tonumber(valz["Row2"]) end
			if !valz["Row3"] or valz["Row3"] == "" then data.eeurl = nil else data.eeurl = valz["Row3"] end
			if !valz["Row4"] then data.script = nil else data.script = valz["Row4"] end
			if !valz["Row5"] or valz["Row5"] == "" then data.scriptinfo = nil else data.scriptinfo = valz["Row5"] end
			if !valz["Row6"] or valz["Row6"] == "0" then data.gamemodeentities = nil else data.gamemodeentities = tobool(valz["Row6"]) end
			if !valz["Row7"] then data.specialroundtype = "Hellhounds" else data.specialroundtype = valz["Row7"] end
			if !valz["Row8"] then data.bosstype = "Panzer" else data.bosstype = valz["Row8"] end
			if !tonumber(valz["Row9"]) then data.startingspawns = 35 else data.startingspawns = tonumber(valz["Row9"]) end
			if !tonumber(valz["Row10"]) then data.spawnperround = 0 else data.spawnperround = tonumber(valz["Row10"]) end
			if !tonumber(valz["Row11"]) then data.maxspawns = 35 else data.maxspawns = tonumber(valz["Row11"]) end
			if !tonumber(valz["Row13"]) then data.zombiesperplayer = 0 else data.zombiesperplayer = tonumber(valz["Row13"]) end
			if !tonumber(valz["Row14"]) then data.spawnsperplayer = 0 else data.spawnsperplayer = tonumber(valz["Row14"]) end
			if !valz["Row15"] then data.zombietype = "Kino der Toten" else data.zombietype = valz["Row15"] end
			if !valz["Row16"] then data.hudtype = "Origins (Black Ops 2)" else data.hudtype = valz["Row16"] end
			if !istable(valz["Row17"]) then data.zombieeyecolor = Color(0, 255, 255, 255) else data.zombieeyecolor = valz["Row17"] end
			if !valz["Row18"] then data.perkmachinetype = "Original" else data.perkmachinetype = valz["Row18"] end
			if !valz["Row19"] then data.boxtype = "Original" else data.boxtype= valz["Row19"] end
			if !istable(valz["Row20"]) then data.boxlightcolor = Color(0, 150,200,255) else data.boxlightcolor = valz["Row20"] end
			if !tonumber(valz["Row21"]) then data.newwave1 = 20 else data.newwave1 = tonumber(valz["Row21"]) end
			if !valz["Row22"] then data.newtype1 = "Hellhounds" else data.newtype1 = valz["Row22"] end
			if !tonumber(valz["Row23"]) then data.newratio1 = 0.5 else data.newratio1 = tonumber(valz["Row23"]) end
			if !tonumber(valz["Row24"]) then data.newwave2 = 0 else data.newwave2 = tonumber(valz["Row24"]) end
			if !valz["Row25"] then data.newtype2 = "None" else data.newtype2 = valz["Row25"] end
			if !tonumber(valz["Row26"]) then data.newratio2 = 0 else data.newratio2 = tonumber(valz["Row26"]) end
			if !tonumber(valz["Row27"]) then data.newwave3 = 0 else data.newwave3 = tonumber(valz["Row27"]) end
			if !valz["Row28"] then data.newtype3 = "None" else data.newtype3 = valz["Row28"] end
			if !tonumber(valz["Row29"]) then data.newratio3 = 0 else data.newratio3 = tonumber(valz["Row29"]) end
			if !tonumber(valz["Row30"]) then data.newwave4 = 0 else data.newwave4 = tonumber(valz["Row30"]) end
			if !valz["Row31"] then data.newtype4 = "None" else data.newtype4 = valz["Row31"] end
			if !tonumber(valz["Row32"]) then data.newratio4 = 0 else data.newratio4 = tonumber(valz["Row32"]) end
			if !valz["Row33"] then data.mainfont = "Default NZR" else data.mainfont = valz["Row33"] end
			if !valz["Row34"] then data.smallfont = "Default NZR" else data.smallfont = valz["Row34"] end
			if !valz["Row35"] then data.mediumfont = "Default NZR" else data.mediumfont = valz["Row35"] end
			if !valz["Row36"] then data.roundfont = "Classic NZ" else data.roundfont = valz["Row36"] end
			if !valz["Row37"] then data.ammofont = "Default NZR" else data.ammofont = valz["Row37"] end
			if !valz["Row38"] then data.ammo2font = "Default NZR" else data.ammo2font = valz["Row38"] end
			if !istable(valz["Row39"]) then data.textcolor = Color(0, 255, 255, 255) else data.textcolor = valz["Row39"] end
			if !tonumber(valz["Row40"]) then data.fontthicc  = 2 else data.fontthicc  = tonumber(valz["Row40"]) end
			if !valz["Row41"] then data.icontype = "Rezzurrection" else data.icontype = valz["Row41"] end
			if !valz["Row42"] then data.perkupgrades = nil else data.perkupgrades = valz["Row42"] end
			if !valz["Row43"] then data.PAPtype = "Original" else data.PAPtype = valz["Row43"] end
			if !valz["Row44"] then data.PAPcamo = "nz_classic" else data.PAPcamo = valz["Row44"] end
			if !tonumber(valz["Row45"]) then data.hp = 100 else data.hp = tonumber(valz["Row45"]) end
			if !tonumber(valz["Row46"]) then data.range = 0 else data.range = tonumber(valz["Row46"]) end
			if !valz["Row47"] then data.sharing = nil else data.sharing = valz["Row47"] end
			if !valz["Row48"] then data.eemdl = "Hula Doll" else data.eemdl = valz["Row48"] end
			if !valz["RBoxWeps"] or table.Count(valz["RBoxWeps"]) < 1 then data.rboxweps = nil else data.rboxweps = valz["RBoxWeps"] end
			if valz["Wunderfizz"] == nil then data.wunderfizzperklist = wunderfizzlist else data.wunderfizzperklist = valz["Wunderfizz"] end
			if valz["ACRow1"] == nil then data.ac = false else data.ac = tobool(valz["ACRow1"]) end
			if valz["ACRow2"] == nil then data.acwarn = nil else data.acwarn = tobool(valz["ACRow2"]) end
			if valz["ACRow3"] == nil then data.acsavespot = nil else data.acsavespot = tobool(valz["ACRow3"]) end
			if valz["ACRow4"] == nil then data.actptime = 5 else data.actptime = valz["ACRow4"] end
			if valz["ACRow5"] == nil then data.acpreventboost = true else data.acpreventboost = tobool(valz["ACRow5"]) end
			if valz["ACRow6"] == nil then data.acpreventcjump = false else data.acpreventcjump = tobool(valz["ACRow6"]) end


			for k,v in pairs(nzSounds.struct) do
				if (valz["SndRow" .. k] == nil) then
					data[v] = {}
				else
					data[v] = valz["SndRow" .. k]
				end
			end

			PrintTable(data)

			nzMapping:SendMapData( data )
		end

			if (MapSDermaButton != nil) then
			MapSDermaButton:Remove()
		end

		MapSDermaButton = vgui.Create( "DButton", frame )
		MapSDermaButton:SetText( "Submit" )
		--MapSDermaButton:Dock(BOTTOM)
		MapSDermaButton:SetPos( 10, 430 )

		MapSDermaButton:SetSize( 480, 30 )
		MapSDermaButton.DoClick = UpdateData
		
		local function AddEyeStuff()
			local eyePanel = vgui.Create("DPanel", sheet)
			sheet:AddSheet("Eye Color", eyePanel, "icon16/palette.png", false, false, "Set the eye glow color the zombies have.")
			eyePanel:DockPadding(5, 5, 5, 5)
			local colorChoose = vgui.Create("DColorMixer", eyePanel)
			colorChoose:SetColor(valz["Row17"])
			colorChoose:SetPalette(false)
			colorChoose:SetAlphaBar(false)
			colorChoose:Dock(TOP)
			colorChoose:SetSize(150, 220)
			
			local presets = vgui.Create("DComboBox", eyePanel)
			presets:SetSize(335, 20)
			presets:SetPos(5, 225)
			presets:Dock(BOTTOM)
			presets:AddChoice("Richtofen")
			presets:AddChoice("Samantha")
			presets:AddChoice("Avogadro")
			presets:AddChoice("Warden")
			presets.OnSelect = function(self, index, value)
				if (value == "Richtofen") then
					colorChoose:SetColor(Color(0, 255, 255))
				elseif (value == "Samantha") then
					colorChoose:SetColor(Color(255, 145, 0))
				elseif (value == "Avogadro") then
					colorChoose:SetColor(Color(255, 255, 255))
				elseif (value == "Warden") then
					colorChoose:SetColor(Color(255, 0, 0))	
				end

				colorChoose:ValueChanged(nil)
			end

			colorChoose.ValueChanged = function(col)
				valz["Row17"] = colorChoose:GetColor()
			end
		end
		
		local function AddBoxStuff()
			local boxlightPanel = vgui.Create("DPanel", sheet)
			sheet:AddSheet("Box Color", boxlightPanel, "icon16/palette.png", false, false, "Set the color of the Mystery Box light.")
			boxlightPanel:DockPadding(5, 5, 5, 5)
			local colorChoose2 = vgui.Create("DColorMixer", boxlightPanel)
			colorChoose2:SetColor(valz["Row20"])
			colorChoose2:SetPalette(false)
			colorChoose2:SetAlphaBar(false)
			colorChoose2:Dock(TOP)
			colorChoose2:SetSize(150, 150)
			
			local presets = vgui.Create("DComboBox", boxlightPanel)
			presets:SetSize(60, 20)
			presets:Dock(BOTTOM)
			presets:AddChoice("Default")
			presets:AddChoice("Mob of the Dead")
			presets.OnSelect = function(self, index, value)
				if (value == "Default") then
					colorChoose2:SetColor(Color(150,200,255))
				elseif (value == "Mob of the Dead") then
					colorChoose2:SetColor(Color(204, 102, 0))	
				end

				colorChoose2:ValueChanged(nil)
			end

			colorChoose2.ValueChanged = function(col)
				valz["Row20"] = colorChoose2:GetColor()
				print(valz["Row20"])
			end
		end
		
		local function AddFontColor()
			local fontPanel = vgui.Create("DPanel", sheet)
			sheet:AddSheet("Font Color", fontPanel, "icon16/palette.png", false, false, "Set the color of the various fonts.")
			fontPanel:DockPadding(5, 5, 5, 5)
			local fontColorChoice = vgui.Create("DColorMixer", fontPanel)
			fontColorChoice:SetColor(valz["Row39"])
			fontColorChoice:SetPalette(false)
			fontColorChoice:SetAlphaBar(false)
			fontColorChoice:Dock(TOP)
			fontColorChoice:SetSize(150, 150)
			
			local presets = vgui.Create("DComboBox", fontPanel)
			presets:SetSize(60, 20)
			presets:Dock(BOTTOM)
			presets:AddChoice("Default")
			presets.OnSelect = function(self, index, value)
				if (value == "Default") then
					fontColorChoice:SetColor(Color(255,255,255))
				end

				fontColorChoice:ValueChanged(nil)
			end

			fontColorChoice.ValueChanged = function(col)
				valz["Row39"] = fontColorChoice:GetColor()
				print(valz["Row39"])
			end
		end
		
		local acPanel = vgui.Create("DPanel", sheet)
		sheet:AddSheet("Anti-Cheat", acPanel, "icon16/script_gear.png", false, false, "Automatically teleport players from cheating spots.")
		local acProps = vgui.Create("DProperties", acPanel)
		local acheight, acwidth = sheet:GetSize()
		acProps:SetSize(acwidth, acwidth - 50)

		
		local ACRow1 = acProps:CreateRow("Anti-Cheat Settings", "Enabled?")
		ACRow1:Setup("Boolean")
		ACRow1:SetValue(valz["ACRow1"])
		ACRow1.DataChanged = function( _, val ) valz["ACRow1"] = val end
		-- local DermaButton3 = vgui.Create( "DButton", acPanel )
		-- DermaButton3:SetText( "Submit" )
		-- DermaButton3:SetPos( 0, 185 )
		-- DermaButton3:SetSize( 260, 30 )
		-- DermaButton3.DoClick = UpdateData

		
			local ACRow2 = acProps:CreateRow("Anti-Cheat Settings", "Warn players?")
			ACRow2:Setup("Boolean")
			ACRow2:SetValue(valz["ACRow2"])
			ACRow2:SetTooltip("Shows \"Return to map!\" with a countdown on player's screens")
			ACRow2.DataChanged = function(_, val) valz["ACRow2"] = val end

			local ACRow3 = acProps:CreateRow("Anti-Cheat Settings", "Save Last Spots?")
			ACRow3:Setup("Boolean")
			ACRow3:SetValue(valz["ACRow3"])
			ACRow3:SetTooltip("Remembers the last spot a player was at before they were detected. (Uses more performance)")
			ACRow3.DataChanged = function(_, val) valz["ACRow3"] = val end

			local ACRow5 = acProps:CreateRow("Anti-Cheat Settings", "Prevent boosting?")
			ACRow5:Setup("Boolean")
			ACRow5:SetValue(valz["ACRow5"])
			ACRow5:SetTooltip("Cancels out vertical velocity when players boost up faster than jump speed")
			ACRow5.DataChanged = function(_, val) valz["ACRow5"] = val end

			local ACRow6 = acProps:CreateRow("Anti-Cheat Settings", "No Crouch Jump?")
			ACRow6:Setup("Boolean")
			ACRow6:SetValue(valz["ACRow6"])
			ACRow6:SetTooltip("Turns crouch jumps into normal jumps to make climbing on stuff harder")
			ACRow6.DataChanged = function(_, val) valz["ACRow6"] = val end

			local ACRow4 = acProps:CreateRow("Anti-Cheat Settings", "Seconds for TP")
			ACRow4:Setup("Integer")
			ACRow4:SetValue(valz["ACRow4"])
			ACRow4:SetTooltip("Amount of seconds before a cheating player is teleported.")
			ACRow4.DataChanged = function(_, val) valz["ACRow4"] = val end
			
			local weplist = {}
			local numweplist = 0

			local rboxpanel = vgui.Create("DPanel", sheet)
			sheet:AddSheet( "Random Box Weapons", rboxpanel, "icon16/box.png", false, false, "Set which weapons appear in the Random Box.")
			rboxpanel.Paint = function() return end

			local rbweplist = vgui.Create("DScrollPanel", rboxpanel)
			rbweplist:SetPos(0, 0)
			rbweplist:SetSize(365, 350)
			rbweplist:SetPaintBackground(true)
			rbweplist:SetBackgroundColor( Color(200, 200, 200) )

			local function InsertWeaponToList(name, class, weight, tooltip)
				weight = weight or 10
				if IsValid(weplist[class]) then return end
				weplist[class] = vgui.Create("DPanel", rbweplist)
				weplist[class]:SetSize(365, 16)
				weplist[class]:SetPos(0, numweplist*16)
				valz["RBoxWeps"][class] = weight

				local dname = vgui.Create("DLabel", weplist[class])
				dname:SetText(name)
				dname:SetTextColor(Color(50, 50, 50))
				dname:SetPos(5, 0)
				dname:SetSize(250, 16)
				
				local dhover = vgui.Create("DPanel", weplist[class])
				dhover.Paint = function() end
				dhover:SetText("")
				dhover:SetSize(365, 16)
				dhover:SetPos(0,0)
				if tooltip then
					dhover:SetTooltip(tooltip)
				end
				
				local dweight = vgui.Create("DNumberWang", weplist[class])
				dweight:SetPos(295, 1)
				dweight:SetSize(40, 14)
				dweight:SetTooltip("The chance of this weapon appearing in the box")
				dweight:SetMinMax( 1, 100 )
				dweight:SetValue(valz["RBoxWeps"][class])
				function dweight:OnValueChanged(val)
					valz["RBoxWeps"][class] = val
				end
				
				local ddelete = vgui.Create("DImageButton", weplist[class])
				ddelete:SetImage("icon16/delete.png")
				ddelete:SetPos(335, 0)
				ddelete:SetSize(16, 16)
				ddelete.DoClick = function()
					valz["RBoxWeps"][class] = nil
					weplist[class]:Remove()
					weplist[class] = nil
					local num = 0
					for k,v in pairs(weplist) do
						v:SetPos(0, num*16)
						num = num + 1
					end
					numweplist = numweplist - 1
				end

				numweplist = numweplist + 1
			end

			if nzMapping.Settings.rboxweps then
				for k,v in pairs(nzMapping.Settings.rboxweps) do
					local wep = weapons.Get(k)
					if wep then
						if wep.Category and wep.Category != "" then
							InsertWeaponToList(wep.PrintName != "" and wep.PrintName or k, k, v or 10, k.." ["..wep.Category.."]")
						else
							InsertWeaponToList(wep.PrintName != "" and wep.PrintName or k, k, v or 10, k.." [No Category]")
						end
					end
				end
			else
				for k,v in pairs(weapons.GetList()) do
					-- By default, add all weapons that have print names unless they are blacklisted
					if v.PrintName and v.PrintName != "" and !nzConfig.WeaponBlackList[v.ClassName] and v.PrintName != "Scripted Weapon" and !v.NZPreventBox and !v.NZTotalBlacklist then
						if v.Category and v.Category != "" then
							InsertWeaponToList(v.PrintName != "" and v.PrintName or v.ClassName, v.ClassName, 10, v.ClassName.." ["..v.Category.."]")
							break
						else
							InsertWeaponToList(v.PrintName != "" and v.PrintName or v.ClassName, v.ClassName, 10, v.ClassName.." [No Category]")
							break
						end
					end
					-- The rest are still available in the dropdown
				end
			end

			local wepentry = vgui.Create( "DComboBox", rboxpanel )
			wepentry:SetPos( 0, 355 )
			wepentry:SetSize( 146, 20 )
			wepentry:SetValue( "Weapon ..." )
			for k,v in pairs(weapons.GetList()) do
				if !v.NZTotalBlacklist and !v.NZPreventBox then
					if v.Category and v.Category != "" then
						wepentry:AddChoice(v.PrintName and v.PrintName != "" and v.Category.. " - "..v.PrintName or v.ClassName, v.ClassName, false)
					else
						wepentry:AddChoice(v.PrintName and v.PrintName != "" and v.PrintName or v.ClassName, v.ClassName, false)
					end
				end
			end
			wepentry.OnSelect = function( panel, index, value )
			end

			local wepadd = vgui.Create( "DButton", rboxpanel )
			wepadd:SetText( "Add" )
			wepadd:SetPos( 150, 355 )
			wepadd:SetSize( 53, 20 )
			wepadd.DoClick = function()
				local v = weapons.Get(wepentry:GetOptionData(wepentry:GetSelectedID()))
				if v then
					if v.Category and v.Category != "" then
						InsertWeaponToList(v.PrintName != "" and v.PrintName or v.ClassName, v.ClassName, 10, v.ClassName.." ["..v.Category.."]")
					else
						InsertWeaponToList(v.PrintName != "" and v.PrintName or v.ClassName, v.ClassName, 10, v.ClassName.." [No Category]")
					end
				end
				wepentry:SetValue( "Weapon..." )
			end
			
			local wepmore = vgui.Create( "DButton", rboxpanel )
			wepmore:SetText( "More ..." )
			wepmore:SetPos( 207, 355 )
			wepmore:SetSize( 53, 20 )
			wepmore.DoClick = function()
				local morepnl = vgui.Create("DFrame")
				morepnl:SetSize(300, 170)
				morepnl:SetTitle("More weapon options ...")
				morepnl:Center()
				morepnl:SetDraggable(true)
				morepnl:ShowCloseButton(true)
				morepnl:MakePopup()
				
				local morecat = vgui.Create("DComboBox", morepnl)
				morecat:SetSize(150, 20)
				morecat:SetPos(10, 30)
				local cattbl = {}
				for k,v in SortedPairsByMemberValue(weapons.GetList(), "PrintName") do
					if v.Category and v.Category != "" then
						if !cattbl[v.Category] then
							morecat:AddChoice(v.Category, v.Category, false)
							cattbl[v.Category] = true
						end
					end
				end
				morecat:AddChoice(" Category ...", nil, true)
					
				local morecatadd = vgui.Create("DButton", morepnl)
				morecatadd:SetText( "Add all" )
				morecatadd:SetPos( 165, 30 )
				morecatadd:SetSize( 60, 20 )
				morecatadd.DoClick = function()
					local cat = morecat:GetOptionData(morecat:GetSelectedID())
					if cat and cat != "" then
						for k,v in SortedPairsByMemberValue(weapons.GetList(), "PrintName") do
							if  v.Category and v.Category == cat and !nzConfig.WeaponBlackList[v.ClassName] and !v.NZPreventBox and !v.NZTotalBlacklist then
								InsertWeaponToList(v.PrintName != "" and v.PrintName or v.ClassName, v.ClassName, 10, v.ClassName.." ["..v.Category.."]")
							end
						end
					end
				end
				
				local morecatdel = vgui.Create("DButton", morepnl)
				morecatdel:SetText( "Remove all" )
				morecatdel:SetPos( 230, 30 )
				morecatdel:SetSize( 60, 20 )
				morecatdel.DoClick = function()
					local cat = morecat:GetOptionData(morecat:GetSelectedID())
					if cat and cat != "" then
						for k,v in pairs(weplist) do
							local wep = weapons.Get(k)
							if wep then
								if wep.Category and wep.Category == cat then
									valz["RBoxWeps"][k] = nil
									weplist[k]:Remove()
									weplist[k] = nil
									local num = 0
									for k,v in pairs(weplist) do
										v:SetPos(0, num*16)
										num = num + 1
									end
									numweplist = numweplist - 1
								end
							end
						end
					end
				end
				
				local moreprefix = vgui.Create("DComboBox", morepnl)
				moreprefix:SetSize(150, 20)
				moreprefix:SetPos(10, 60)
				local prefixtbl = {}
				for k,v in pairs(weapons.GetList()) do
					local prefix = string.sub(v.ClassName, 0, string.find(v.ClassName, "_"))
					if prefix and !prefixtbl[prefix] then
						moreprefix:AddChoice(prefix, prefix, false)
						prefixtbl[prefix] = true
					end
				end
				moreprefix:AddChoice(" Prefix ...", nil, true)
					
				local moreprefixadd = vgui.Create("DButton", morepnl)
				moreprefixadd:SetText( "Add all" )
				moreprefixadd:SetPos( 165, 60 )
				moreprefixadd:SetSize( 60, 20 )
				moreprefixadd.DoClick = function()
					local prefix = moreprefix:GetOptionData(moreprefix:GetSelectedID())
					if prefix and prefix != "" then
						for k,v in SortedPairsByMemberValue(weapons.GetList(), "PrintName") do
							local wepprefix = string.sub(v.ClassName, 0, string.find(v.ClassName, "_"))
							if wepprefix and wepprefix == prefix and !nzConfig.WeaponBlackList[v.ClassName] and !v.NZPreventBox and !v.NZTotalBlacklist then
								if v.Category and v.Category != "" then
									InsertWeaponToList(v.PrintName != "" and v.PrintName or v.ClassName, v.ClassName, 10, v.ClassName.." ["..v.Category.."]")
								else
									InsertWeaponToList(v.PrintName != "" and v.PrintName or v.ClassName, v.ClassName, 10, v.ClassName.." [No Category]")
								end
							end
						end
					end
				end
				
				local moreprefixdel = vgui.Create("DButton", morepnl)
				moreprefixdel:SetText( "Remove all" )
				moreprefixdel:SetPos( 230, 60 )
				moreprefixdel:SetSize( 60, 20 )
				moreprefixdel.DoClick = function()
					local prefix = moreprefix:GetOptionData(moreprefix:GetSelectedID())
					if prefix and prefix != "" then
						for k,v in pairs(weplist) do
							local wepprefix = string.sub(k, 0, string.find(k, "_"))
							if wepprefix and wepprefix == prefix then
								valz["RBoxWeps"][k] = nil
								weplist[k]:Remove()
								weplist[k] = nil
								local num = 0
								for k,v in pairs(weplist) do
									v:SetPos(0, num*16)
									num = num + 1
								end
								numweplist = numweplist - 1
							end
						end
					end
				end
				
				local removeall = vgui.Create("DButton", morepnl)
				removeall:SetText( "Remove all" )
				removeall:SetPos( 10, 100 )
				removeall:SetSize( 140, 25 )
				removeall.DoClick = function()
					for k,v in pairs(weplist) do
						valz["RBoxWeps"][k] = nil
						weplist[k]:Remove()
						weplist[k] = nil
						numweplist = 0
					end
				end
				
				local addall = vgui.Create("DButton", morepnl)
				addall:SetText( "Add all" )
				addall:SetPos( 150, 100 )
				addall:SetSize( 140, 25 )
				addall.DoClick = function()
					for k,v in pairs(weplist) do
						valz["RBoxWeps"][k] = nil
						weplist[k]:Remove()
						weplist[k] = nil
						numweplist = 0
					end
					for k,v in SortedPairsByMemberValue(weapons.GetList(), "PrintName") do
						-- By default, add all weapons that have print names unless they are blacklisted
						if v.PrintName and v.PrintName != "" and !nzConfig.WeaponBlackList[v.ClassName] and v.PrintName != "Scripted Weapon" and !v.NZPreventBox and !v.NZTotalBlacklist then
							if v.Category and v.Category != "" then
								InsertWeaponToList(v.PrintName != "" and v.PrintName or v.ClassName, v.ClassName, 10, v.ClassName.." ["..v.Category.."]")
							else
								InsertWeaponToList(v.PrintName != "" and v.PrintName or v.ClassName, v.ClassName, 10, v.ClassName.." [No Category]")
							end
						end
						-- The same reset as when no random box list exists on server
					end
				end
				
				local reload = vgui.Create("DButton", morepnl)
				reload:SetText( "Reload from server" )
				reload:SetPos( 10, 130 )
				reload:SetSize( 280, 25 )
				reload.DoClick = function()
					-- Remove all and insert from random box list
					for k,v in pairs(weplist) do
						valz["RBoxWeps"][k] = nil
						weplist[k]:Remove()
						weplist[k] = nil
						numweplist = 0
					end
					if nzMapping.Settings.rboxweps then
						for k,v in pairs(nzMapping.Settings.rboxweps) do
							local wep = weapons.Get(v)
							if wep then
								if wep.Category and wep.Category != "" then
									InsertWeaponToList(wep.PrintName != "" and wep.PrintName or v, v, 10, v.." ["..v.Category.."]")
								else
									InsertWeaponToList(wep.PrintName != "" and wep.PrintName or v, v, 10, v.." [No Category]")
								end
							end
						end
					end
				end
			end
			------------------Sound Chooser----------------------------
			-- So we can create the elements in a loop
			local SndMenuMain = { 
				[1] = {
					["Title"] = "Round Start",
					["ToolTip"] = "",
					["Bind"] = valz["SndRow1"]
				},
				[2] = {
					["Title"] = "Round End",
					["ToolTip"] = "",
					["Bind"] = valz["SndRow2"]
				},
				[3] = {
					["Title"] = "Special Round Start",
					["ToolTip"] = "Eg. Dog Round",
					["Bind"] = valz["SndRow3"]
				},
				[4] = {
					["Title"] = "Special Round End",
					["ToolTip"] = "Eg. Dog Round",
					["Bind"] = valz["SndRow4"]
				},
				[5] = {
					["Title"] = "Dog Round",
					["ToolTip"] = "ONLY for dog rounds!",
					["Bind"] = valz["SndRow5"]
				},
				[6] = {
					["Title"] = "Game Over",
					["ToolTip"] = "",
					["Bind"] = valz["SndRow6"]
				},
				[7] = {
					["Title"] = "Easter Egg Song",
					["ToolTip"] = "Remember to sail the seas safely",
					["Bind"] = valz["SndRow24"]
				},
				[8] = {
					["Title"] = "Pack-A-Punch Sound",
					["ToolTip"] = "",
					["Bind"] = valz["SndRow25"]
				}
			}

			local SndMenuPowerUp = { 
				[1] = {
					["Title"] = "Spawn",
					["ToolTip"] = "Played on the powerup itself when it spawns",
					["Bind"] = valz["SndRow7"]
				},
				[2] = {
					["Title"] = "Grab",
					["ToolTip"] = "When players get the powerup",
					["Bind"] = valz["SndRow8"]
				},
				[3] = {
					["Title"] = "Insta Kill",
					["ToolTip"] = "",
					["Bind"] = valz["SndRow9"]
				},
				[4] = {
					["Title"] = "Fire Sale",
					["ToolTip"] = "",
					["Bind"] = valz["SndRow10"]
				},
				[5] = {
					["Title"] = "Death Machine",
					["ToolTip"] = "",
					["Bind"] = valz["SndRow11"]
				},
				[6] = {
					["Title"] = "Carpenter",
					["ToolTip"] = "",
					["Bind"] = valz["SndRow12"]
				},
				[7] = {
					["Title"] = "Nuke",
					["ToolTip"] = "",
					["Bind"] = valz["SndRow13"]
				},
				[8] = {
					["Title"] = "Double Points",
					["ToolTip"] = "",
					["Bind"] = valz["SndRow14"]
				},
				[9] = {
					["Title"] = "Max Ammo",
					["ToolTip"] = "",
					["Bind"] = valz["SndRow15"]
				},
				[10] = {
					["Title"] = "Zombie Blood",
					["ToolTip"] = "",
					["Bind"] = valz["SndRow16"]
				}
			}

			local SndMenuBox = { 
				[1] = {
					["Title"] = "Shake",
					["ToolTip"] = "When the teddy appears and the box starts hovering",
					["Bind"] = valz["SndRow17"]
				},
				[2] = {
					["Title"] = "Poof",
					["ToolTip"] = "When the box moves to another destination",
					["Bind"] = valz["SndRow18"]
				},
				[3] = {
					["Title"] = "Laugh",
					["ToolTip"] = "When the teddy appears",
					["Bind"] = valz["SndRow19"]
				},
				[4] = {
					["Title"] = "Bye Bye",
					["ToolTip"] = "Plays along with Shake",
					["Bind"] = valz["SndRow20"]
				},
				[5] = {
					["Title"] = "Jingle",
					["ToolTip"] = "When weapons are shuffling",
					["Bind"] = valz["SndRow21"]
				},
				[6] = {
					["Title"] = "Open",
					["ToolTip"] = "",
					["Bind"] = valz["SndRow22"]
				},
				[7] = {
					["Title"] = "Close",
					["ToolTip"] = "",
					["Bind"] = valz["SndRow23"]
				}
			}

			local sndPanel = vgui.Create("DPanel", sheet)
			local sndheight, sndwidth = sheet:GetSize()
			sndPanel:SetSize(sndheight, (sndwidth - 50))
			sheet:AddSheet("Custom Sounds", sndPanel, "icon16/sound_add.png", false, false, "Customize the sounds that play for certain events.")

			AddEyeStuff()
			AddBoxStuff()
			AddFontColor()
			local wrapper = vgui.Create("DPanel", sndPanel)
			wrapper:SetSize(500, 363)
			wrapper:SetPos(0, 0)
			
			-- A modifiable list of all sounds bound to currently selected event:
			local curSndList = vgui.Create("DListView", wrapper)
			curSndList:Dock(RIGHT)
			curSndList:SetSize(330, 200)
			curSndList:SetMultiSelect(false)
			curSndList:SetSortable(false)
		
			local curSndTbl = nil -- All sounds for currently selected Event Item
			local function DeleteNewItem(text, line)
				table.RemoveByValue(curSndTbl, text)
				curSndList:RemoveLine(line)
			end

			local soundsPlayed = {}
			curSndList.OnRowRightClick = function(lineID, line)
				local file = curSndList:GetLine(line):GetColumnText(1)
				local fileSubMenu = DermaMenu()	
				local function StopPlayedSounds()
					for k,v in pairs(soundsPlayed) do
						LocalPlayer():StopSound(v)
					end
				end

				fileSubMenu:AddOption("Play", function()
					StopPlayedSounds()		
					table.insert(soundsPlayed, file)	
					curSound = CreateSound(LocalPlayer(), file)
					curSound:Play()
				end)

				fileSubMenu:AddOption("Stop", function()
					StopPlayedSounds()		
				end)

				fileSubMenu:AddSpacer()
				fileSubMenu:AddSpacer()
				fileSubMenu:AddSpacer()
				fileSubMenu:AddOption("Remove", function()
					DeleteNewItem(file, line)
				end)

				fileSubMenu:Open()
			end

			local newCol = curSndList:AddColumn("Assigned Sounds")
			newCol:SetToolTip("A random sound from the list will play")
			local theList = nil 
			local function NewSelectedItem(list, tbl)
				curSndTbl = tbl
				theList = list
				curSndList:Clear()
				for k,v in pairs(tbl) do
					local newline = curSndList:AddLine(v)
					newline:SetToolTip(v)
				end
			end

			local function AddNewItem(text)
				table.insert(curSndTbl, text)
				local newline = curSndList:AddLine(text)
				newline:SetTooltip(text)
			end
			
			local selectedData = {}
			if (ispanel(sndFilePanel)) then sndFilePanel:Remove() end
			sndFilePanel = nil -- We want to keep this reference so only 1 file menu exists at a time
			sndFileMenu = nil -- Keep this so we don't restructure and reset the file menu EVERY TIME

			local function ChooseSound() -- Menu to make selecting mounted sounds effortless
				local eventItem = theList:GetLine(theList:GetSelectedLine())
				if (!list || !eventItem) then return end

				sndFilePanel = vgui.Create("DFrame", frame)
				sndFilePanel:SetSize(500, 475)
				--sndFilePanel:Dock(FILL)
				sndFilePanel:SetTitle(eventItem:GetColumnText(1) .. " Sound")
				sndFilePanel:SetDeleteOnClose(true)
				sndFilePanel.OnClose = function()
					-- Pretend to close it so users can continue where they left off when adding another sound
					sndFileMenu:SetParent(frame)
					sndFileMenu:Hide()
					
					sndFilePanel = nil
				end

				if (!ispanel(sndFileMenu)) then
					fileMenu = vgui.Create("DFileBrowser", sndFilePanel)
					fileMenu:Dock(FILL)	
					fileMenu:SetPath("GAME")
					fileMenu:SetFileTypes("*.wav *.mp3 *.ogg")
					fileMenu:SetBaseFolder("sound")
					fileMenu:SetOpen(true)
					sndFileMenu = fileMenu
				else
					sndFileMenu:SetParent(sndFilePanel)
					sndFileMenu:Show()
				end

				local soundsPlayed = {}
				function fileMenu:OnRightClick(filePath, selectedPnl)
					lastPath = fileMenu:GetCurrentFolder()

					if (SERVER) then return end
					filePath = string.Replace(filePath, "sound/", "")
					local fileSubMenu = DermaMenu()
					
					local function StopPlayedSounds()
						for k,v in pairs(soundsPlayed) do
							LocalPlayer():StopSound(v)
						end
					end

					fileSubMenu:AddOption("Play", function()
						StopPlayedSounds()		
						table.insert(soundsPlayed, filePath)	
						curSound = CreateSound(LocalPlayer(), filePath)
						curSound:Play()
					end)

					fileSubMenu:AddOption("Stop", function()
						StopPlayedSounds()		
					end)

					fileSubMenu:AddSpacer()
					fileSubMenu:AddSpacer()
					fileSubMenu:AddSpacer()
					fileSubMenu:AddOption("Add", function()
						AddNewItem(filePath)
					end)

					fileSubMenu:Open()
				end
			end

			local catList = vgui.Create("DCategoryList", wrapper)
			catList:Dock(FILL)
			catList:Center()

			local addBtn = vgui.Create("DButton", curSndList)
			addBtn:SetText("Add Sound")
			addBtn:Dock(BOTTOM)
			addBtn.DoClick = function()
				ChooseSound()
			end

			-- Menu categories with Event Lists inside
			local mainCat = catList:Add("Main")
			local powerupCat = catList:Add("Powerups")
			powerupCat:SetExpanded(false)
			local boxCat = catList:Add("Mystery Box")
			boxCat:SetExpanded(false)
			local mainSnds = vgui.Create("DListView", mainCat)
			local powerUpSnds = vgui.Create("DListView", powerupCat)
			local boxSnds = vgui.Create("DListView", boxCat)

			mainSnds:SetSortable(false)
			powerUpSnds:SetSortable(false)
			boxSnds:SetSortable(false)

			local function AddDList(listView)
				listView:Dock(LEFT)
				listView:AddColumn("Event")
			end

			AddDList(mainSnds)
			AddDList(powerUpSnds)
			AddDList(boxSnds)
			mainCat:SetContents(mainSnds)
			powerupCat:SetContents(powerUpSnds)
			boxCat:SetContents(boxSnds)

			local function AddContents(tbl, listView)
				for k,v in ipairs(tbl) do
					local newItem = listView:AddLine(v["Title"])
					if (v["ToolTip"] != "") then newItem:SetTooltip(v["ToolTip"]) end

					listView.OnRowSelected = function(panel, rowIndex, row) -- We need to update the editable list for the item we have selected
						local tblSnds = tbl[rowIndex]["Bind"] -- The table of sounds that is saved along with the config
						NewSelectedItem(listView, tblSnds)
					end

					listView:SetMultiSelect(false)
				end
			end
			AddContents(SndMenuMain, mainSnds)
			AddContents(SndMenuPowerUp, powerUpSnds)
			AddContents(SndMenuBox, boxSnds)
			
			mainSnds:SelectFirstItem() -- Since Main category is always expanded, let's make sure the first item is selected

			local function AddCollapseCB(this) -- New category expanded, collapse all others & deselect their items
				this.OnToggle = function()
					if (this:GetExpanded()) then 
						for k,v in pairs({mainCat, powerupCat, boxCat}) do
							if (v != this) then
								-- These categories are expanded, we cannot have more than 1 expanded so let's collapse these
								if (v:GetExpanded()) then
									v:Toggle()
								end
							else
								-- This category is expanded, let's select the first Event Item
								local listView = v:GetChild(1)
								if (ispanel(listView)) then
									listView:SelectFirstItem()
								end
							end
						end
					end
				end
			end
			AddCollapseCB(mainCat)
			AddCollapseCB(powerupCat)
			AddCollapseCB(boxCat)	
			------------------------------------------------------------------------
			------------------------------------------------------------------------
			local perklist = {}

			local perkpanel = vgui.Create("DPanel", sheet)
			sheet:AddSheet( "Wunderfizz Perks", perkpanel, "icon16/drink.png", false, false, "Set which perks appears in Der Wunderfizz.")
			perkpanel.Paint = function() return end

			local perklistpnl = vgui.Create("DScrollPanel", perkpanel)
			perklistpnl:SetPos(0, 0)
			perklistpnl:SetSize(465, 450)
			perklistpnl:SetPaintBackground(true)
			perklistpnl:SetBackgroundColor( Color(200, 200, 200) )
			
			local perkchecklist = vgui.Create( "DIconLayout", perklistpnl )
			perkchecklist:SetSize( 465, 450 )
			perkchecklist:SetPos( 35, 10 )
			perkchecklist:SetSpaceY( 5 )
			perkchecklist:SetSpaceX( 5 )
			
			--for k,v in pairs(nzPerks:GetList()) do
			--	if k != "wunderfizz" and k != "pap" then
				for k,v in pairs(wunderfizzlist) do
				--if (!valz["Wunderfizz"] || !valz["Wunderfizz"][k]) then return end

				local perkitem = perkchecklist:Add( "DPanel" )
				perkitem:SetSize( 130, 20 )
				
				local check = perkitem:Add("DCheckBox")
				check:SetPos(2,2)

				if (nzMapping.Settings.wunderfizzperklist and istable(nzMapping.Settings.wunderfizzperklist[k]) and isbool(nzMapping.Settings.wunderfizzperklist[k][1])) then
					check:SetValue(nzMapping.Settings.wunderfizzperklist[k][1])
				else
					check:SetValue(true)
				end

				--if has then perklist[k] = true else perklist[k] = nil end
				check.OnChange = function(self, val)
					--if val then perklist[k] = true else perklist[k] = nil end
					valz["Wunderfizz"][k][1] = val
					--nzMapping:SendMapData( {wunderfizzperks = perklist} )
				end
				
				local name = perkitem:Add("DLabel")
				name:SetTextColor(Color(50,50,50))
				name:SetSize(105, 20)
				name:SetPos(20,1)
				name:SetText(v[2])
			end
				--end
			--end
			--local text = vgui.Create("DLabel", DProperties)
			--text:SetText("Enable this mode for broken stuff")
			--text:SetFont("Trebuchet18")
			--text:SetTextColor( Color(50, 50, 50) )
			--text:SizeToContents()
			--text:SetPos(0, 140)
			--text:CenterHorizontal()
		

		return sheet
	end,
	-- defaultdata = {}
})