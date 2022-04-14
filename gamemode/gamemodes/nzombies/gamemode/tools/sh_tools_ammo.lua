nzTools:CreateTool("ammobox", {
	displayname = "Ammo Box Placer",
	desc = "LMB: Ammo Box, RMB: Remove Ammo Box",
	condition = function(wep, ply)
		return true
	end,
	
	PrimaryAttack = function(wep, ply, tr, data)
		nzMapping:AmmoBox(tr.HitPos, Angle(0,0,0), "models/codww2/other/carepackage.mdl", ply)
	end,
	SecondaryAttack = function(wep, ply, tr, data)
		if IsValid(tr.Entity) and tr.Entity:GetClass() == "ammo_box" then
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
	displayname = "Ammo Box Placer",
	desc = "LMB: Ammo Box, RMB: Remove Ammo Box",
	icon = "icon16/tab.png",
	weight = 20,
	condition = function(wep, ply)
		return true
	end,
	interface = function(frame, data)

	end,
	--defaultdata = {}
})