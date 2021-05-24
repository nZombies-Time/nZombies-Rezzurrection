-- Fixed by Ethorbit

-- Setup round module
nzTraps = nzTraps or AddNZModule("Traps")
nzLogic = nzLogic or AddNZModule("Logic")
nzTrapsAndLogic = nzTrapsAndLogic or {}

nzTraps.Registry = nzTraps.Registry or {}
nzLogic.Registry = nzLogic.Registry or {}

local function register (tbl, classname)
	table.insert(tbl, classname)
end

function nzTraps:Register(classname)
	if !table.HasValue(self.Registry, classname) then
		register(self.Registry, classname)
	end
end

function nzLogic:Register(classname)
	if !table.HasValue(self.Registry, classname) then
		register(self.Registry, classname)
	end
end

function nzTraps:GetAll()
	return table.Copy(self.Registry)
end

function nzLogic:GetAll()
	return table.Copy(self.Registry)
end

function nzTrapsAndLogic:GetAll()
	local tbl = nzTraps:GetAll()
	table.Add(tbl, nzLogic:GetAll())
	return tbl
end

if (SERVER) then
	nzMapping:AddSaveModule("TrapsLogic", {
		savefunc = function()
			local traps_logic = {}
			for k, class in pairs(nzTrapsAndLogic:GetAll()) do
				for _, ent in pairs(ents.FindByClass(class)) do
					table.insert(traps_logic, duplicator.CopyEntTable(ent))
				end
			end
			return traps_logic
		end,
		loadfunc = function(data)
			for _, entTable in pairs(data) do
				local ent = duplicator.CreateEntityFromTable(ply, entTable)

				ent:SetMoveType( MOVETYPE_NONE )
				ent:SetSolid( SOLID_VPHYSICS )
				ent:Activate()
				ent:Spawn()
				ent:PhysicsInit( SOLID_VPHYSICS )
				ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

				if (entTable.DT) then
					entTable.DT.Active = false
					entTable.DT.CooldownActive = false
				end

				local phys = ent:GetPhysicsObject()
				if (IsValid(phys)) then
					phys:EnableMotion(false)
				end

				for k, v in pairs(entTable.DT) do
					if ent["Set" .. k] then
						timer.Simple( 0.1, function() ent["Set" .. k](ent, v) end)
					end
				end
			end
		end,
		cleanents = {"nz_trap_zapper", "nz_trap_turret", "nz_trap_particles", "nz_trap_projectiles", "nz_trap_propeller", "nz_button", "nz_button_and"}, -- TODO: make this automatic! If that fails it's risky and can mess up saving configs...
	})
end