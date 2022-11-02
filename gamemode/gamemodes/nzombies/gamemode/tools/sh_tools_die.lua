nzTools:CreateTool("die", {
	displayname = "Misery Acceleration Device",
	desc = "LMB: Place, RMB: Remove",
	condition = function(wep, ply)
		return true
	end,
	
	PrimaryAttack = function(wep, ply, tr, data)
		nzMapping:StinkyLever(tr.HitPos, Angle(0,0,0), ply)
	end,
	SecondaryAttack = function(wep, ply, tr, data)
		if IsValid(tr.Entity) and tr.Entity:GetClass() == "stinky_lever" then
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
	displayname = "Misery Acceleration Device",
	desc = "LMB: Place, RMB: Remove ",
	icon = "icon16/cut.png",
	weight = 20,
	condition = function(wep, ply)
		return true
	end,
	interface = function(frame, data)

	end,
	--defaultdata = {}
})