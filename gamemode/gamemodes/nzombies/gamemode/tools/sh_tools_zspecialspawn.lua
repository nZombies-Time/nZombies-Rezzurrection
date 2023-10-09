nzTools:CreateTool("zspecialspawn", {
	displayname = "Special Spawn Creator",
	desc = "LMB: Place Spawnpoint, RMB: Remove Spawnpoint",
	condition = function(wep, ply)
		-- Function to check whether a player can access this tool - always accessible
		return true
	end,
	PrimaryAttack = function(wep, ply, tr, data)
		-- Create a new spawnpoint and set its data to the guns properties
		local ent
		if IsValid(tr.Entity) and tr.Entity:GetClass() == "nz_spawn_zombie_special" then
			ent = tr.Entity -- No need to recreate if we shot an already existing one
		else
			ent = nzMapping:ZedSpecialSpawn(tr.HitPos,(Angle(0,(ply:GetPos() - tr.HitPos):Angle()[2],0)), nil, tobool(data.master), data.spawntype, data.zombietype, data.roundactive,ply)
		end

		ent.flag = data.flag
		if tobool(data.flag) and ent.link != "" then
			ent.link = data.link
		end

		-- For the link displayer
		if data.link then
			ent:SetLink(data.link)
		end
		
		ent.master = data.master
		ent.roundactive = data.roundactive
	end,
	SecondaryAttack = function(wep, ply, tr, data)
		-- Remove entity if it is a zombie spawnpoint
		if IsValid(tr.Entity) and tr.Entity:GetClass() == "nz_spawn_zombie_special" then
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
	displayname = "Special Spawn Creator",
	desc = "LMB: Place Spawnpoint, RMB: Remove Spawnpoint",
	icon = "icon16/user_red.png",
	weight = 2,
	condition = function(wep, ply)
		return true
	end,
	interface = function(frame, data)
		local valz = {}
		valz["Row1"] = data.flag
		valz["Row2"] = data.link
		valz["Row3"] = data.master
		valz["Row4"] = data.spawntype
		valz["Row5"] = data.zombietype
		valz["Row6"] = data.roundactive

		local DProperties = vgui.Create( "DProperties", frame )
		DProperties:SetSize( 480, 450 )
		DProperties:SetPos( 10, 10 )
		
		function DProperties.CompileData()
			local str="nil"
			if valz["Row1"] == 0 then
				str=nil
				data.flag = 0
			else
				str=valz["Row2"]
				data.flag = 1
			end
			data.link = str
			
			data.master = valz["Row3"]
			data.spawntype = valz["Row4"]
			data.zombietype = valz["Row5"]
			data.roundactive = valz["Row6"]

			return data
		end
		
		function DProperties.UpdateData(data)
			nzTools:SendData(data, "zspecialspawn")
		end

		local Row1 = DProperties:CreateRow( "Zombie Spawn", "Enable Flag?" )
		Row1:Setup( "Boolean" )
		Row1:SetValue( valz["Row1"] )
		Row1.DataChanged = function( _, val ) valz["Row1"] = val DProperties.UpdateData(DProperties.CompileData()) end
		local Row2 = DProperties:CreateRow( "Zombie Spawn", "Flag" )
		Row2:Setup( "Integer" )
		Row2:SetValue( valz["Row2"] )
		Row2.DataChanged = function( _, val ) valz["Row2"] = val DProperties.UpdateData(DProperties.CompileData()) end
		local Row3 = DProperties:CreateRow( "Zombie Spawn", "Master Spawner?" )
		Row3:Setup( "Boolean" )
		Row3:SetValue( valz["Row3"] )
		Row3.DataChanged = function( _, val ) valz["Row3"] = val DProperties.UpdateData(DProperties.CompileData()) end

		local Row4 = DProperties:CreateRow( "Zombie Spawn", "Spawn Type" )
		Row4:Setup( "Combo" )
		Row4:AddChoice("Riser",0)
        Row4:AddChoice("No Animation",1)
        Row4:AddChoice("Undercroft",3)
		Row4:AddChoice("Wall Emerge",4)
		Row4:AddChoice("Jump Spawn",5)
		Row4:AddChoice("Barrel Climbout",6)
		Row4:AddChoice("Ceiling Dropdown Low",7)
		Row4:AddChoice("Ceiling Dropdown High",8)
		Row4:AddChoice("Ground Wall(Like Undercroft)",9)
		Row4.DataChanged = function( _, val ) valz["Row4"] = val DProperties.UpdateData(DProperties.CompileData()) end

		local Row5 = DProperties:CreateRow("Zombie Spawn", "Zombie Type")
		Row5:Setup( "Combo" )
		local found = false
		for k,v in pairs(nzConfig.ValidEnemies) do
			if k == valz["Row5"] then
				Row5:AddChoice(k, k, true)
				found = true
			else
				Row5:AddChoice(k, k, false)
			end
		end
		Row5.DataChanged = function( _, val ) valz["Row5"] = val DProperties.UpdateData(DProperties.CompileData()) end

		local Row6 = DProperties:CreateRow( "Zombie Spawn", "Round Activation" )
		Row6:Setup( "Integer" )
		Row6:SetValue( valz["Row6"] )
		Row6.DataChanged = function( _, val ) valz["Row6"] = val DProperties.UpdateData(DProperties.CompileData()) end
		

		local text = vgui.Create("DLabel", DProperties)
		text:SetText("Special Spawnpoints apply to Hellhounds")
		text:SetFont("Trebuchet18")
		text:SetPos(0, 185)
		text:SetTextColor( Color(50, 50, 50) )
		text:SizeToContents()
		text:CenterHorizontal()

		local text2 = vgui.Create("DLabel", DProperties)
		text2:SetText("and for respawning with Who's Who")
		text2:SetFont("Trebuchet18")
		text2:SetPos(0, 195)
		text2:SetTextColor( Color(50, 50, 50) )
		text2:SizeToContents()
		text2:CenterHorizontal()

		return DProperties
	end,
	defaultdata = {
		flag = 0,
		link = 1,
		spawnable = 1,
		respawnable = 1,
		master = 0,
		spawntype = 0,
		zombietype = zombietype or "none",
		roundactive = 0,
	}
})
