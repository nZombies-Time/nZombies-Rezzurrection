if engine.ActiveGamemode() == "nzombies" then
	hook.Add("PostGamemodeLoaded", "nz.register.myname.buildables", function()
		--[[Example
		nzBuilds:NewBuildable("unique_id", {
			name = "Build Name",
			model = "path/to/model/model.mdl",
			weapon = "weapon_class", //reward weapon class, if applicable
			pos = Vector(0,0,0), //height of model from table
			ang = Angle(0,0,0), //rotation of model from table
			parts = {
				[1] = {id = "Part1 Name", mdl = "path/to/model/model.mdl"},
				[2] = {id = "Part2 Name", mdl = "path/to/model/model.mdl"},
			},
			remove = bool, //remove table after use?
			use = function(self, ply) end, //custom use function, DELETE IF NOT USING
			text = function(self) end, //custom text, DELETE IF NOT USING
		})]]--

		nzBuilds:NewBuildable("heisenhammer", {
			name = "Heisenberg's Hammer",
			model = "models/weapons/bo3_melees/mace/karlheisenberg_hammer.mdl",
			pos = Vector(0,0,60),
			ang = Angle(0,90,90),
			weapon = "nz_knife_heisenberg",
			parts = {
				[1] = {id = "Metal Pole", mdl = "models/props_c17/signpole001.mdl"},
				[2] = {id = "Gear", mdl = "models/props_phx/gears/spur12.mdl"},
				[3] = {id = "Engineblock", mdl = "models/props_c17/trappropeller_engine.mdl"},
				//there can be as many parts as you want
			},
			remove = true,
		})
			nzBuilds:NewBuildable("bomb_door", {
			name = "Bomb Door",
			model = "models/dav0r/tnt/tnttimed.mdl",
			pos = Vector(0,0,70),
			ang = Angle(0,90,180),
			weapon = "",
			parts = {
				[1] = {id = "Explosives", mdl = "models/dav0r/tnt/tnt.mdl"},
				[2] = {id = "Timer", mdl = "models/maxofs2d/button_05.mdl"},
				//there can be as many parts as you want
			},
			remove = true,
			  use = function(self, ply)
			 nzDoors:OpenLinkedDoors("buildable_bomb")
    end,
    text = function(self)
        return "Press "..string.upper(input.LookupBinding("+USE")).." - Open Linked Door"
    end,
		})
		
		nzBuilds:NewBuildable("ritual_door", {
			name = "Ritual Door",
			model = "models/zmb/bo2/alcatraz/zm_al_skull_afterlife.mdl",
			pos = Vector(0,0,40),
			ang = Angle(90,90,0),
			weapon = "",
			parts = {
				[1] = {id = "Skull", mdl = "models/Gibs/HGIBS.mdl"},
				[2] = {id = "Ritual Knife", mdl = "models/nzr/2022/weapons/w_knife.mdl"},
				//there can be as many parts as you want
			},
			remove = true,
			  use = function(self, ply)
			 nzDoors:OpenLinkedDoors("buildable_ritual")
    end,
    text = function(self)
        return "Press "..string.upper(input.LookupBinding("+USE")).." - Open Linked Door"
    end,
		})
		
		nzBuilds:NewBuildable("power", {
			name = "Power Switch",
			model = "models/nzprops/zombies_power_lever.mdl",
			pos = Vector(0,0,0),
			ang = Angle(0,0,0),
			weapon = "",
			parts = {
				[1] = {id = "Power Switch Panel", mdl = "models/zmb/bo2/power/build_power_body.mdl"},
				[2] = {id = "Power Switch Lever", mdl = "models/zmb/bo2/power/build_power_lever.mdl"},
				//there can be as many parts as you want
			},
			remove = true,
			  use = function(self, ply)
			 nzElec:Activate()
    end,
    text = function(self)
        return "Press "..string.upper(input.LookupBinding("+USE")).." - Turn Power On"
    end,
		})
	end)
end