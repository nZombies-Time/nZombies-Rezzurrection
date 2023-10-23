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

		nzBuilds:NewBuildable("custom_heisenberg_hammer", {
			name = "Heisenberg's Hammer",
			model = "models/weapons/bo3_melees/mace/karlheisenberg_hammer.mdl"
			pos = Vector(0,0,48),
			ang = Angle(0,90,0),
			weapon = "nz_knife_heisenberg",
			parts = {
				[1] = {id = "Metal Pole", mdl = "models/props_c17/signpole001.mdl"},
				[2] = {id = "Gear", mdl = "models/props_phx/gears/spur12.mdl"},
				[3] = {id = "Engineblock", mdl = "models/props_c17/trappropeller_engine.mdl"},
				//there can be as many parts as you want
			},
			remove = false,
		})
	end)
end