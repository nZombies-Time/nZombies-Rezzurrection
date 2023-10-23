nzTools:CreateTool("jukebox", {
	displayname = "Jukebox Placer",
	desc = "LMB: Place Jukebox, RMB: Remove Jukebox",
	condition = function(wep, ply)
		return true
	end,
	PrimaryAttack = function(wep, ply, tr, data)
		nzMapping:Jukebox(tr.HitPos + tr.HitNormal, Angle(0,(ply:GetPos() - tr.HitPos):Angle()[2],0), ply)
	end,
	SecondaryAttack = function(wep, ply, tr, data)
		if IsValid(tr.Entity) and tr.Entity:GetClass() == "nz_jukebox" then
			tr.Entity:Remove()
		end
	end,
	Reload = function(wep, ply, tr, data)
	end,
	OnEquip = function(wep, ply, data)
	end,
	OnHolster = function(wep, ply, data)
	end
}, {
	displayname = "Jukebox Placer",
	desc = "LMB: Place Jukebox, RMB: Remove Jukebox",
	icon = "icon16/ipod.png",
	weight = 20,
	condition = function(wep, ply)
		return true
	end,
	interface = function(frame, data)
	end,
})

if SERVER then
	nzMapping:AddSaveModule("JukeboxSpawns", {
		savefunc = function()
			local jukebox_spawns = {}
			for k, v in pairs(ents.FindByClass("nz_jukebox")) do
				table.insert(jukebox_spawns, {
					pos = v:GetPos(),
					angle = v:GetAngles()
				})
			end

			return jukebox_spawns
		end,
		loadfunc = function(data)
			for k, v in pairs(data) do
				nzMapping:Jukebox(v.pos, v.angle)
			end
		end,
		cleanents = {"nz_jukebox"}
	})
end