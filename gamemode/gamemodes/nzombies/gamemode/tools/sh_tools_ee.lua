nzTools:CreateTool("ee", {
	displayname = "Easter Egg Placer",
	desc = "LMB: Easter Egg, RMB: Remove Easter Egg, Use Player Handler to select song",
	condition = function(wep, ply)
		return true
	end,
	PrimaryAttack = function(wep, ply, tr, data)
		nzMapping:EasterEgg(tr.HitPos, Angle(0,0,0), "models/props_lab/huladoll.mdl", ply)
	end,
	SecondaryAttack = function(wep, ply, tr, data)
		if IsValid(tr.Entity) and tr.Entity:GetClass() == "easter_egg" then
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
	displayname = "Easter Egg Placer",
	desc = "LMB: Easter Egg, RMB: Remove Easter Egg, Use Player Handler to select song",
	icon = "icon16/music.png",
	weight = 20,
	condition = function(wep, ply)
		return true
	end,
	interface = function(frame, data)

	end,
	--defaultdata = {}
})
nzTools:CreateTool("usable_ending", {
	displayname = "Ending Placer",
	desc = "LMB: Place Ending Prop, RMB: Remove , When purchased, ends game",
	condition = function(wep, ply)
		return true
	end,
	PrimaryAttack = function(wep, ply, tr, data)
	local ent = tr.Entity
	if !IsValid(ent) then return end
	
		nzMapping:BuyableEnding(ent:GetPos(), ent:GetAngles(), ent:GetModel(),data.price, ply)
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
	displayname = "Ending Placer",
	desc = "LMB: Place Ending Prop, RMB: Remove , When purchased, ends game",
	icon = "icon16/tick.png",
	weight = 20,
	condition = function(wep, ply)
		return true
	end,
	interface = function(frame, data)
		local valz = {}
		valz["Row1"] = data.price
		

		local DProperties = vgui.Create( "DProperties", frame )
		DProperties:SetSize( 480, 450 )
		DProperties:SetPos( 10, 10 )
		
		function DProperties.CompileData()
			data.price = valz["Row1"]

			--PrintTable(data)
			
			return data
		end
		
		function DProperties.UpdateData(data) -- This function will be overwritten if opened via context menu
			nzTools:SendData(data, "ending")
		end

		local Row1 = DProperties:CreateRow( "Buyable Ending", "Price" )
		Row1:Setup( "Integer" )
		Row1:SetValue( valz["Row1"] )
		Row1.DataChanged = function( _, val ) valz["Row1"] = val DProperties.UpdateData(DProperties.CompileData()) end

		return DProperties
	end,
	defaultdata = {
		price = 50000
	
	}
})