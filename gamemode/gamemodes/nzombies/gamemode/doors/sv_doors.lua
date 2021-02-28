function nzDoors:DoorToEntIndex(num)
	local ent = ents.GetMapCreatedEntity(num)

	return IsValid(ent) and ent:EntIndex() or nil
end

function nzDoors:DoorIndexToEnt(num)
	if !num then return nil end
	return ents.GetMapCreatedEntity(num) or NULL
end

function nzDoors:ParseFlagString( flagsStr )

	if (isstring(flagsStr)) then
		local tbl = {}
		
		flagsStr = string.lower(flagsStr)
		
		-- Translate the flags string into a table
		local ex = string.Explode( ",", flagsStr )
		
		for k,v in pairs(ex) do
			local ex2 = string.Explode( "=", v )
			tbl[ex2[1]] = ex2[2]
			-- If buyable is not set on a door, we default to on
			if !tbl["buyable"] and k == #ex then
				tbl["buyable"] = "1"
			end
		end
		
		--PrintTable(tbl)
		return tbl
	end
	
end

function nzDoors:CreateLink( ent, flagsStr )
	-- First remove all links
	--self:RemoveLink( ent )
	if ent:IsDoor() or ent:IsButton() then
		self:CreateMapDoorLink( ent:DoorIndex(), flagsStr )
	elseif ent:IsBuyableProp() or ent:IsScriptBuyable() then
		self:CreatePropDoorLink( ent, flagsStr )
	end
end

function nzDoors:RemoveLink( ent, nohook )
	if ent:IsDoor() or ent:IsButton() then
		self:RemoveMapDoorLink( ent:DoorIndex() )
	elseif ent:IsBuyableProp() then
		self:RemovePropDoorLink( ent )
	end
	if !nohook then
		hook.Call("OnDoorUnlocked", self, ent)
	end
end

nzDoors.buildable1=nil
nzDoors.buildable2=nil
nzDoors.buildable3=nil
nzDoors.buildable4=nil
nzDoors.buildable5=nil
nzDoors.buildable6=nil
nzDoors.buildable7=nil
nzDoors.buildable8=nil
nzDoors.buildable9=nil
nzDoors.buildable10=nil
nzDoors.buildable11=nil
nzDoors.buildable12=nil
nzDoors.buildable13=nil
nzDoors.buildable14=nil
nzDoors.buildable15=nil
function nzDoors:AddBuildable( model,angle, pos, id, text, icon, shared, drop, group)

if id == "1" or id == 1 then
			nzDoors.buildable1 = nzItemCarry:CreateCategory("1")
			nzDoors.buildable1:SetText(text)
			nzDoors.buildable1:SetHasText("You already have this")
			if !icon =="Default" then
			nzDoors.buildable1:SetIcon( icon)
			end
			nzDoors.buildable1:SetShared(shared)
			nzDoors.buildable1:SetDropOnDowned(drop)
			if drop == true then
			nzDoors.buildable1:SetDropFunction( function(self, ply)
				local scriptobj = ents.Create("nz_script_prop")
				scriptobj:SetModel(model)
				scriptobj:SetPos(ply:GetPos())
				scriptobj:SetAngles(Angle(0,0,0))
				scriptobj:PhysicsInit( SOLID_VPHYSICS )
				scriptobj:SetMoveType( MOVETYPE_NONE )
				scriptobj:SetSolid( SOLID_VPHYSICS )
				scriptobj:SetUseType( SIMPLE_USE )
				scriptobj:Spawn()
				self:RegisterEntity( scriptobj )
			end)
			end
			nzDoors.buildable1:SetResetFunction( function(self)
			if not hasSpawned1 then
				local scriptobj = ents.Create("nz_script_prop")
				scriptobj:SetModel(model)
				scriptobj:SetPos(pos)
				scriptobj:SetAngles(angle)
				
				scriptobj:SetMoveType( MOVETYPE_NONE )
				scriptobj:SetSolid( SOLID_VPHYSICS )
				scriptobj:SetUseType( SIMPLE_USE )
				
				scriptobj:Spawn()
				self:RegisterEntity( scriptobj )
				print("registered successfully")
				hasSpawned1 = true
				end
				end)
				
			nzDoors.buildable1:SetPickupFunction( function(self, ply, ent)
				hasSpawned1 = false
				ply:GiveCarryItem("1")
				ent:Remove()
					end)
				
				nzDoors.buildable1:Update()
	return 
end


if id == "2" or id == 2 then
			nzDoors.buildable2 = nzItemCarry:CreateCategory("2")
			nzDoors.buildable2:SetText(text)
			nzDoors.buildable2:SetHasText("You already have this")
			if !icon =="Default" then
			nzDoors.buildable2:SetIcon( icon)
			end
			nzDoors.buildable2:SetShared(shared)
			nzDoors.buildable2:SetDropOnDowned(drop)
			if drop == true then
			nzDoors.buildable2:SetDropFunction( function(self, ply)
				local scriptobj = ents.Create("nz_script_prop")
				scriptobj:SetModel(model)
				scriptobj:SetPos(ply:GetPos())
				scriptobj:SetAngles(Angle(0,0,0))
				scriptobj:Spawn()
				self:RegisterEntity( scriptobj )
			end)
			end
			nzDoors.buildable2:SetResetFunction( function(self)
			if not hasSpawned2 then
				local scriptobj = ents.Create("nz_script_prop")
				scriptobj:SetModel(model)
				scriptobj:SetPos(pos)
				scriptobj:SetAngles(angle)
				
				scriptobj:Spawn()
				self:RegisterEntity( scriptobj )
				hasSpawned2 = true
				end
				end)
				
			nzDoors.buildable2:SetPickupFunction( function(self, ply, ent)
				hasSpawned2 = false
				ply:GiveCarryItem("2")
				ent:Remove()
					end)
				
				nzDoors.buildable2:Update()
	return 
end


if id == "3" or id == 3 then
			nzDoors.buildable3 = nzItemCarry:CreateCategory("3")
			nzDoors.buildable3:SetText(text)
			nzDoors.buildable3:SetHasText("You already have this")
			if !icon =="Default" then
			nzDoors.buildable3:SetIcon( icon)
			end
			nzDoors.buildable3:SetShared(shared)
			nzDoors.buildable3:SetDropOnDowned(drop)
			if drop == true then
			nzDoors.buildable3:SetDropFunction( function(self, ply)
				local scriptobj = ents.Create("nz_script_prop")
				scriptobj:SetModel(model)
				scriptobj:SetPos(ply:GetPos())
				scriptobj:SetAngles(Angle(0,0,0))
				scriptobj:Spawn()
				self:RegisterEntity( scriptobj )
			end)
			end
			nzDoors.buildable3:SetResetFunction( function(self)
			if not hasSpawned3 then
				local scriptobj = ents.Create("nz_script_prop")
				scriptobj:SetModel(model)
				scriptobj:SetPos(pos)
				scriptobj:SetAngles(angle)
				
				scriptobj:Spawn()
				self:RegisterEntity( scriptobj )
				hasSpawned3 = true
				end
				end)
				
			nzDoors.buildable3:SetPickupFunction( function(self, ply, ent)
				hasSpawned3 = false
				ply:GiveCarryItem("3")
				print(PrintTable(ply:GetCarryItems()))
				ent:Remove()
					end)
				
				nzDoors.buildable3:Update()
	return 
end


if id == "4" or id == 4 then
			nzDoors.buildable4 = nzItemCarry:CreateCategory("4")
			nzDoors.buildable4:SetText(text)
			nzDoors.buildable4:SetHasText("You already have this")
			if !icon =="Default" then
			nzDoors.buildable4:SetIcon( icon)
			end
			nzDoors.buildable4:SetShared(shared)
			nzDoors.buildable4:SetDropOnDowned(drop)
			if drop == true then
			nzDoors.buildable4:SetDropFunction( function(self, ply)
				local scriptobj = ents.Create("nz_script_prop")
				scriptobj:SetModel(model)
				scriptobj:SetPos(ply:GetPos())
				scriptobj:SetAngles(Angle(0,0,0))
				scriptobj:Spawn()
				self:RegisterEntity( scriptobj )
			end)
			end
			nzDoors.buildable4:SetResetFunction( function(self)
			if not hasSpawned4 then
				local scriptobj = ents.Create("nz_script_prop")
				scriptobj:SetModel(model)
				scriptobj:SetPos(pos)
				scriptobj:SetAngles(angle)
				
				scriptobj:Spawn()
				self:RegisterEntity( scriptobj )
				hasSpawned4 = true
				end
				end)
				
			nzDoors.buildable4:SetPickupFunction( function(self, ply, ent)
				hasSpawned4 = false
				ply:GiveCarryItem("4")
				ent:Remove()
					end)
				
				nzDoors.buildable4:Update()
	return 
end


if id == "5" or id == 5 then
			nzDoors.buildable5 = nzItemCarry:CreateCategory("5")
			nzDoors.buildable5:SetText(text)
			nzDoors.buildable5:SetHasText("You already have this")
			if !icon =="Default" then
			nzDoors.buildable5:SetIcon( icon)
			end
			nzDoors.buildable5:SetShared(shared)
			nzDoors.buildable5:SetDropOnDowned(drop)
			if drop == true then
			nzDoors.buildable5:SetDropFunction( function(self, ply)
				local scriptobj = ents.Create("nz_script_prop")
				scriptobj:SetModel(model)
				scriptobj:SetPos(ply:GetPos())
				scriptobj:SetAngles(Angle(0,0,0))
				scriptobj:Spawn()
				self:RegisterEntity( scriptobj )
			end)
			end
			nzDoors.buildable5:SetResetFunction( function(self)
			if not hasSpawned5 then
				local scriptobj = ents.Create("nz_script_prop")
				scriptobj:SetModel(model)
				scriptobj:SetPos(pos)
				scriptobj:SetAngles(angle)
				
				scriptobj:Spawn()
				self:RegisterEntity( scriptobj )
				hasSpawned5 = true
				end
				end)
				
			nzDoors.buildable5:SetPickupFunction( function(self, ply, ent)
				hasSpawned5 = false
				ply:GiveCarryItem("5")
				ent:Remove()
					end)
				
				nzDoors.buildable5:Update()
	return 
end


if id == "6" or id == 6 then
			nzDoors.buildable6 = nzItemCarry:CreateCategory("6")
			nzDoors.buildable6:SetText(text)
			nzDoors.buildable6:SetHasText("You already have this")
			if !icon =="Default" then
			nzDoors.buildable6:SetIcon( icon)
			end
			nzDoors.buildable6:SetShared(shared)
			nzDoors.buildable6:SetDropOnDowned(drop)
			if drop == true then
			nzDoors.buildable6:SetDropFunction( function(self, ply)
				local scriptobj = ents.Create("nz_script_prop")
				scriptobj:SetModel(model)
				scriptobj:SetPos(ply:GetPos())
				scriptobj:SetAngles(Angle(0,0,0))
				scriptobj:Spawn()
				self:RegisterEntity( scriptobj )
			end)
			end
			nzDoors.buildable6:SetResetFunction( function(self)
			if not hasSpawned6 then
				local scriptobj = ents.Create("nz_script_prop")
				scriptobj:SetModel(model)
				scriptobj:SetPos(pos)
				scriptobj:SetAngles(angle)
				
				scriptobj:Spawn()
				self:RegisterEntity( scriptobj )
				hasSpawned6 = true
				end
				end)
				
			nzDoors.buildable6:SetPickupFunction( function(self, ply, ent)
				hasSpawned6 = false
				ply:GiveCarryItem("6")
				ent:Remove()
					end)
				
				nzDoors.buildable6:Update()
	return 
end


if id == "7" or id == 7 then
			nzDoors.buildable7 = nzItemCarry:CreateCategory("7")
			nzDoors.buildable7:SetText(text)
			nzDoors.buildable7:SetHasText("You already have this")
			if !icon =="Default" then
			nzDoors.buildable7:SetIcon( icon)
			end
			nzDoors.buildable7:SetShared(shared)
			nzDoors.buildable7:SetDropOnDowned(drop)
			if drop == true then
			nzDoors.buildable7:SetDropFunction( function(self, ply)
				local scriptobj = ents.Create("nz_script_prop")
				scriptobj:SetModel(model)
				scriptobj:SetPos(ply:GetPos())
				scriptobj:SetAngles(Angle(0,0,0))
				scriptobj:Spawn()
				self:RegisterEntity( scriptobj )
			end)
			end
			nzDoors.buildable7:SetResetFunction( function(self)
			if not hasSpawned7 then
				local scriptobj = ents.Create("nz_script_prop")
				scriptobj:SetModel(model)
				scriptobj:SetPos(pos)
				scriptobj:SetAngles(angle)
				
				scriptobj:Spawn()
				self:RegisterEntity( scriptobj )
				hasSpawned7 = true
				end
				end)
				
			nzDoors.buildable7:SetPickupFunction( function(self, ply, ent)
				hasSpawned7 = false
				ply:GiveCarryItem("7")
				ent:Remove()
					end)
				
				nzDoors.buildable7:Update()
	return 
end


if id == "8" or id == 8 then
			nzDoors.buildable8 = nzItemCarry:CreateCategory("8")
			nzDoors.buildable8:SetText(text)
			nzDoors.buildable8:SetHasText("You already have this")
			if !icon =="Default" then
			nzDoors.buildable8:SetIcon( icon)
			end
			nzDoors.buildable8:SetShared(shared)
			nzDoors.buildable8:SetDropOnDowned(drop)
			if drop == true then
			nzDoors.buildable8:SetDropFunction( function(self, ply)
				local scriptobj = ents.Create("nz_script_prop")
				scriptobj:SetModel(model)
				scriptobj:SetPos(ply:GetPos())
				scriptobj:SetAngles(Angle(0,0,0))
				scriptobj:Spawn()
				self:RegisterEntity( scriptobj )
			end)
			end
			nzDoors.buildable8:SetResetFunction( function(self)
			if not hasSpawned8 then
				local scriptobj = ents.Create("nz_script_prop")
				scriptobj:SetModel(model)
				scriptobj:SetPos(pos)
				scriptobj:SetAngles(angle)
				
				scriptobj:Spawn()
				self:RegisterEntity( scriptobj )
				hasSpawned8 = true
				end
				end)
				
			nzDoors.buildable8:SetPickupFunction( function(self, ply, ent)
				hasSpawned8 = false
				ply:GiveCarryItem("8")
				ent:Remove()
					end)
				
				nzDoors.buildable8:Update()
	return 
end


if id == "9" or id == 9 then
			nzDoors.buildable9 = nzItemCarry:CreateCategory("9")
			nzDoors.buildable9:SetText(text)
			nzDoors.buildable9:SetHasText("You already have this")
			if !icon =="Default" then
			nzDoors.buildable9:SetIcon( icon)
			end
			nzDoors.buildable9:SetShared(shared)
			nzDoors.buildable9:SetDropOnDowned(drop)
			if drop == true then
			nzDoors.buildable9:SetDropFunction( function(self, ply)
				local scriptobj = ents.Create("nz_script_prop")
				scriptobj:SetModel(model)
				scriptobj:SetPos(ply:GetPos())
				scriptobj:SetAngles(Angle(0,0,0))
				scriptobj:Spawn()
				self:RegisterEntity( scriptobj )
			end)
			end
			nzDoors.buildable9:SetResetFunction( function(self)
			if not hasSpawned9 then
				local scriptobj = ents.Create("nz_script_prop")
				scriptobj:SetModel(model)
				scriptobj:SetPos(pos)
				scriptobj:SetAngles(angle)
				
				scriptobj:Spawn()
				self:RegisterEntity( scriptobj )
				hasSpawned9 = true
				end
				end)
				
			nzDoors.buildable9:SetPickupFunction( function(self, ply, ent)
				hasSpawned9 = false
				ply:GiveCarryItem("9")
				ent:Remove()
					end)
				
				nzDoors.buildable9:Update()
	return 
end


if id == "10" or id == 10 then
			nzDoors.buildable10 = nzItemCarry:CreateCategory("10")
			nzDoors.buildable10:SetText(text)
			nzDoors.buildable10:SetHasText("You already have this")
			if !icon =="Default" then
			nzDoors.buildable10:SetIcon( icon)
			end
			nzDoors.buildable10:SetShared(shared)
			nzDoors.buildable10:SetDropOnDowned(drop)
			if drop == true then
			nzDoors.buildable10:SetDropFunction( function(self, ply)
				local scriptobj = ents.Create("nz_script_prop")
				scriptobj:SetModel(model)
				scriptobj:SetPos(ply:GetPos())
				scriptobj:SetAngles(Angle(0,0,0))
				scriptobj:Spawn()
				self:RegisterEntity( scriptobj )
			end)
			end
			nzDoors.buildable10:SetResetFunction( function(self)
			if not hasSpawned10 then
				local scriptobj = ents.Create("nz_script_prop")
				scriptobj:SetModel(model)
				scriptobj:SetPos(pos)
				scriptobj:SetAngles(angle)
				
				scriptobj:Spawn()
				self:RegisterEntity( scriptobj )
				hasSpawned10 = true
				end
				end)
				
			nzDoors.buildable10:SetPickupFunction( function(self, ply, ent)
				hasSpawned10 = false
				ply:GiveCarryItem("10")
				ent:Remove()
					end)
				
				nzDoors.buildable10:Update()
	return 
end


if id == "11" or id == 11 then
			nzDoors.buildable11= nzItemCarry:CreateCategory("11")
			nzDoors.buildable11:SetText(text)
			nzDoors.buildable11:SetHasText("You already have this")
			if !icon =="Default" then
			nzDoors.buildable11:SetIcon( icon)
			end
			nzDoors.buildable11:SetShared(shared)
			nzDoors.buildable11:SetDropOnDowned(drop)
			if drop == true then
			nzDoors.buildable11:SetDropFunction( function(self, ply)
				local scriptobj = ents.Create("nz_script_prop")
				scriptobj:SetModel(model)
				scriptobj:SetPos(ply:GetPos())
				scriptobj:SetAngles(Angle(0,0,0))
				scriptobj:Spawn()
				self:RegisterEntity( scriptobj )
			end)
			end
			nzDoors.buildable11:SetResetFunction( function(self)
			if not hasSpawned11 then
				local scriptobj = ents.Create("nz_script_prop")
				scriptobj:SetModel(model)
				scriptobj:SetPos(pos)
				scriptobj:SetAngles(angle)
				
				scriptobj:Spawn()
				self:RegisterEntity( scriptobj )
				hasSpawned11 = true
				end
				end)
				
			nzDoors.buildable11:SetPickupFunction( function(self, ply, ent)
				hasSpawned11 = false
				ply:GiveCarryItem("11")
				ent:Remove()
					end)
				
				nzDoors.buildable11:Update()
	return 
end


if id == "12" or id == 12 then
			nzDoors.buildable12 = nzItemCarry:CreateCategory("12")
			nzDoors.buildable12:SetText(text)
			nzDoors.buildable12:SetHasText("You already have this")
			if !icon =="Default" then
			nzDoors.buildable12:SetIcon( icon)
			end
			nzDoors.buildable12:SetShared(shared)
			nzDoors.buildable12:SetDropOnDowned(drop)
			if drop == true then
			nzDoors.buildable12:SetDropFunction( function(self, ply)
				local scriptobj = ents.Create("nz_script_prop")
				scriptobj:SetModel(model)
				scriptobj:SetPos(ply:GetPos())
				scriptobj:SetAngles(Angle(0,0,0))
				scriptobj:Spawn()
				self:RegisterEntity( scriptobj )
			end)
			end
			nzDoors.buildable12:SetResetFunction( function(self)
			if not hasSpawned12 then
				local scriptobj = ents.Create("nz_script_prop")
				scriptobj:SetModel(model)
				scriptobj:SetPos(pos)
				scriptobj:SetAngles(angle)
				
				scriptobj:Spawn()
				self:RegisterEntity( scriptobj )
				hasSpawned12 = true
				end
				end)
				
			nzDoors.buildable12:SetPickupFunction( function(self, ply, ent)
				hasSpawned12 = false
				ply:GiveCarryItem("12")
				ent:Remove()
					end)
				
				nzDoors.buildable12:Update()
	return 
end


if id == "13" or id == 13 then
			nzDoors.buildable13 = nzItemCarry:CreateCategory("13")
			nzDoors.buildable13:SetText(text)
			nzDoors.buildable13:SetHasText("You already have this")
			if !icon =="Default" then
			nzDoors.buildable13:SetIcon( icon)
			end
			nzDoors.buildable13:SetShared(shared)
			nzDoors.buildable13:SetDropOnDowned(drop)
			if drop == true then
			nzDoors.buildable13:SetDropFunction( function(self, ply)
				local scriptobj = ents.Create("nz_script_prop")
				scriptobj:SetModel(model)
				scriptobj:SetPos(ply:GetPos())
				scriptobj:SetAngles(Angle(0,0,0))
				scriptobj:Spawn()
				self:RegisterEntity( scriptobj )
			end)
			end
			nzDoors.buildable13:SetResetFunction( function(self)
			if not hasSpawned13 then
				local scriptobj = ents.Create("nz_script_prop")
				scriptobj:SetModel(model)
				scriptobj:SetPos(pos)
				scriptobj:SetAngles(angle)
				
				scriptobj:Spawn()
				self:RegisterEntity( scriptobj )
				hasSpawned13 = true
				end
				end)
				
			nzDoors.buildable13:SetPickupFunction( function(self, ply, ent)
				hasSpawned13 = false
				ply:GiveCarryItem("13")
				ent:Remove()
					end)
				
				nzDoors.buildable13:Update()
	return 
end


if id == "14" or id == 14 then
			nzDoors.buildable14 = nzItemCarry:CreateCategory("14")
			nzDoors.buildable14:SetText(text)
			nzDoors.buildable14:SetHasText("You already have this")
			if !icon =="Default" then
			nzDoors.buildable14:SetIcon( icon)
			end
			nzDoors.buildable14:SetShared(shared)
			nzDoors.buildable14:SetDropOnDowned(drop)
			if drop == true then
			nzDoors.buildable14:SetDropFunction( function(self, ply)
				local scriptobj = ents.Create("nz_script_prop")
				scriptobj:SetModel(model)
				scriptobj:SetPos(ply:GetPos())
				scriptobj:SetAngles(Angle(0,0,0))
				scriptobj:Spawn()
				self:RegisterEntity( scriptobj )
			end)
			end
			nzDoors.buildable14:SetResetFunction( function(self)
			if not hasSpawned14 then
				local scriptobj = ents.Create("nz_script_prop")
				scriptobj:SetModel(model)
				scriptobj:SetPos(pos)
				scriptobj:SetAngles(angle)
				
				scriptobj:Spawn()
				self:RegisterEntity( scriptobj )
				hasSpawned14 = true
				end
				end)
				
			nzDoors.buildable14:SetPickupFunction( function(self, ply, ent)
				hasSpawned14 = false
				ply:GiveCarryItem("14")
				ent:Remove()
					end)
				
				nzDoors.buildable14:Update()
	return 
end


if id == "15" or id == 15 then
			nzDoors.buildable15 = nzItemCarry:CreateCategory("15")
			nzDoors.buildable15:SetText(text)
			nzDoors.buildable15:SetHasText("You already have this")
			if !icon =="Default" then
			nzDoors.buildable15:SetIcon( icon)
			end
			nzDoors.buildable15:SetShared(shared)
			nzDoors.buildable15:SetDropOnDowned(drop)
			if drop == true then
			nzDoors.buildable15:SetDropFunction( function(self, ply)
				local scriptobj = ents.Create("nz_script_prop")
				scriptobj:SetModel(model)
				scriptobj:SetPos(ply:GetPos())
				scriptobj:SetAngles(Angle(0,0,0))
				scriptobj:Spawn()
				self:RegisterEntity( scriptobj )
			end)
			end
			nzDoors.buildable15:SetResetFunction( function(self)
			if not hasSpawned15 then
				local scriptobj = ents.Create("nz_script_prop")
				scriptobj:SetModel(model)
				scriptobj:SetPos(pos)
				scriptobj:SetAngles(angle)
				
				scriptobj:Spawn()
				self:RegisterEntity( scriptobj )
				hasSpawned15 = true
				end
				end)
				
			nzDoors.buildable15:SetPickupFunction( function(self, ply, ent)
				hasSpawned15 = false
				ply:GiveCarryItem("15")
				ent:Remove()
					end)
				
				nzDoors.buildable15:Update()
	return 
end
end


function nzDoors:DeleteBuildable(id)
print(id)
if id == "1" or id == 1 then
removedTable = nzDoors.buildable1:GetEntities()
table.Empty(removedTable)
end

if id == "2" or id == 2 then
removedTable = nzDoors.buildable2:GetEntities()
table.Empty(removedTable)
end
if id == "3" or id == 3 then
removedTable = nzDoors.buildable3:GetEntities()
table.Empty(removedTable)
end
if id == "4" or id == 4 then
removedTable = nzDoors.buildable4:GetEntities()
table.Empty(removedTable)
end
if id == "5" or id == 5 then
removedTable = nzDoors.buildable5:GetEntities()
table.Empty(removedTable)
end
if id == "6" or id == 6 then
removedTable = nzDoors.buildable6:GetEntities()
table.Empty(removedTable)
end
if id == "7" or id == 7 then
removedTable = nzDoors.buildable7:GetEntities()
table.Empty(removedTable)
end
if id == "8" or id == 8 then
removedTable = nzDoors.buildable8:GetEntities()
table.Empty(removedTable)
end
if id == "9" or id == 9 then
removedTable = nzDoors.buildable9:GetEntities()
table.Empty(removedTable)
end
if id == "10" or id == 10 then
removedTable = nzDoors.buildable10:GetEntities()
table.Empty(removedTable)
end
if id == "11" or id == 11 then
removedTable = nzDoors.buildable11:GetEntities()
table.Empty(removedTable)
end
if id == "12" or id == 12 then
removedTable = nzDoors.buildable12:GetEntities()
table.Empty(removedTable)
end
if id == "13" or id == 13 then
removedTable = nzDoors.buildable13:GetEntities()
table.Empty(removedTable)
end
if id == "14" or id == 14 then
removedTable = nzDoors.buildable14:GetEntities()
table.Empty(removedTable)
end
if id == "15" or id == 15 then
removedTable = nzDoors.buildable15:GetEntities()
table.Empty(removedTable)
end

end

function nzDoors:CreateMapDoorLink( doorID, flagsStr )

	local door = self:DoorIndexToEnt(doorID)
	if !flagsStr then ErrorNoHalt("Door "..doorID.." doesn't have a flagsStr saved!") return end
	local flagsTbl = self:ParseFlagString( flagsStr )
	
	if IsValid(door) and (door:IsDoor() or door:IsButton()) then
		-- Assign the flags to the door and the table
		door:SetDoorData(flagsTbl)
		door:SetLocked(true)
		--self.MapDoors[doorID] = flagsTbl
		
		hook.Call("OnMapDoorLinkCreated", self, door, flagsTbl, doorID)
	else
		print("Error: " .. doorID .. " is not a door.")
	end
	
end

function nzDoors:RemoveMapDoorLink( doorID )

	local door = self:DoorIndexToEnt(doorID)
	if door:GetDoorData() then
		if IsValid(door) and (door:IsDoor() or door:IsButton()) then	
			self.MapDoors[doorID] = nil
			
			hook.Call("OnMapDoorLinkRemoved", self, door, doorID)
		else
			print("Error: " .. doorID .. " is not a door. ")
		end
	end
	
end

function nzDoors:CreatePropDoorLink( ent, flagsStr )

	local flagsTbl = self:ParseFlagString( flagsStr )
	
	if IsValid(ent) and ent:IsBuyableProp() then
		ent:SetDoorData(flagsTbl)
		ent:SetLocked(true)
		--self.PropDoors[ent:EntIndex()] = flagsTbl
		
		hook.Call("OnPropDoorLinkCreated", self, ent, flagsTbl)
	else
		--print("Error: " .. doorID .. " is not a door. ")
	end
	
end

function nzDoors:RemovePropDoorLink( ent )
	
	if IsValid(ent) and ent:IsBuyableProp() then
		-- Total clear of the table
		self.PropDoors[ent:EntIndex()] = nil
		
		hook.Call("OnPropDoorLinkRemoved", self, ent)
	else
		--print("Error: " .. doorID .. " is not a door. ")
	end
end

function nzDoors:DisplayDoorLinks( ent )
	if ent.link == nil then self.DisplayLinks[ent] = nil return end
	
	if self.DisplayLinks[ent] == nil then
		self.DisplayLinks[ent] = ent.link
	else
		self.DisplayLinks[ent] = nil
	end
	self:SendSync()
end


hook.Add( "OnRoundInit", "buildableInit", function()
		if nzDoors.buildable1 then
		nzDoors.buildable1:Reset()
		end
		if nzDoors.buildable2 then
		nzDoors.buildable2:Reset()
		end
		if nzDoors.buildable3 then
		nzDoors.buildable3:Reset()
		end
		if nzDoors.buildable4 then
		nzDoors.buildable4:Reset()
		end
		if nzDoors.buildable5 then
		nzDoors.buildable5:Reset()
		end
		if nzDoors.buildable6 then
		nzDoors.buildable6:Reset()
		end
		if nzDoors.buildable7 then
		nzDoors.buildable7:Reset()
		end
		if nzDoors.buildable8 then
		nzDoors.buildable8:Reset()
		end
		if nzDoors.buildable9 then
		nzDoors.buildable9:Reset()
		end
		if nzDoors.buildable10 then
		nzDoors.buildable10:Reset()
		end
		if nzDoors.buildable11 then
		nzDoors.buildable11:Reset()
		end
		if nzDoors.buildable12 then
		nzDoors.buildable12:Reset()
		end
		if nzDoors.buildable13 then
		nzDoors.buildable13:Reset()
		end
		if nzDoors.buildable14 then
		nzDoors.buildable14:Reset()
		end
		if nzDoors.buildable15 then
		nzDoors.buildable15:Reset()
		end
	end)