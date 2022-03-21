-- Fixed by Ethorbit

nzTools:CreateTool("traps_logic", {
	displayname = "Traps, Buttons, Logic",
	desc = "LMB: Create Entity, RMB: Remove Entity, R: Duplicate Entity, C: Edit Properties",
	condition = function(wep, ply)
		return true
	end,
	PrimaryAttack = function(wep, ply, tr, data)
		local ent
		if data.clone then
			ent = duplicator.CreateEntityFromTable(ply, data.dupe)
			if !IsValid(ent) then return end
		else
			ent = ents.Create(data.classname)
		end
		ent:SetPos(tr.HitPos)
		
		if (IsValid(ent)) then
			if (ent:GetClass() == "nz_trap_propeller") then
				ent:SetAngles((tr.HitNormal:Angle() + Angle(90,0,0)))
				if (ent:GetAngles()[2] == 0) then
					ent:SetAngles(ent:GetAngles() + Angle(0,(ply:GetPos() - tr.HitPos):Angle()[2], 0))
				end

				ent:SetPos(ent:GetPos() + ent:GetUp() * 17)
			elseif (ent:GetClass() == "nz_trap_particles") then
				ent:SetAngles((tr.HitNormal:Angle()))
			elseif (ent:GetClass() == "nz_button") then
				ent:SetAngles(tr.HitNormal:Angle() + Angle(180,90,180)) 
				ent:SetPos(ent:GetPos() - (ent:GetRight() * 5))
			elseif (ent:GetClass() == "nz_trap_turret") then
				ent:SetAngles(Angle(0,(ply:GetPos() - tr.HitPos):Angle()[2] + 180,0))
			else
				ent:SetAngles(tr.HitNormal:Angle() + Angle(90,0,0)) 
			end
		end
			
		ent:SetMoveType( MOVETYPE_NONE )
		ent:SetSolid( SOLID_VPHYSICS )

		ent:Spawn()
		ent:Activate()
		ent:PhysicsInit( SOLID_VPHYSICS )
		ent:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)

		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:EnableMotion(false)
		end
		
		if IsValid(ply) then
			undo.Create( "Logic/Trap" )
				undo.SetPlayer( ply )
				undo.AddEntity( ent )
			undo.Finish()
		end

		if data.clone then
			for k, v in pairs(data.dupe.DT) do
				if ent["Set" .. k] then
					timer.Simple( 0.1, function() ent["Set" .. k](ent, v) end)
				end
			end
		end
	end,
	SecondaryAttack = function(wep, ply, tr, data)
		if IsValid(tr.Entity) then
			if (nzTraps and nzTraps.Registry and table.HasValue(nzTraps.Registry, tr.Entity:GetClass())) then
				tr.Entity:Remove()
			end
			
			if (nzLogic and nzLogic.Registry and table.HasValue(nzLogic.Registry, tr.Entity:GetClass())) then
				tr.Entity:Remove()
			end
		end
	end,
	Reload = function(wep, ply, tr, data)
		ply:SetNZToolData({dupe = duplicator.CopyEntTable( tr.Entity ), clone = true})
	end,
	OnEquip = function(wep, ply, data)

	end,
	OnHolster = function(wep, ply, data)

	end
}, {
	displayname = "Traps, Buttons, Logic",
	desc = "LMB: Create Entity, RMB: Remove Entity, R: Duplicate Entity, C: Edit Properties",
	icon = "icon16/controller.png",
	weight = 40,
	condition = function(wep, ply)
		-- Client needs advanced editing on to see the tool
		return true
	end,
	interface = function(frame, data, context)

		local cont = vgui.Create("DScrollPanel", frame)
		cont:Dock(FILL)

		function cont.CompileData()
			return data
		end

		function cont.UpdateData(data)
			nzTools:SendData(data, "traps_logic") -- Save the same data here
		end

		local function genSpawnList(tbl, parent)
			for _, classname in pairs(tbl) do
				local info = baseclass.Get(classname)
				local model = info.SpawnIcon
				local name = info.PrintName
				local desc = info.Description
				if model then
					local panel = vgui.Create("DPanel", parent)
					panel:Dock(TOP)
					panel:DockMargin(2, 0, 2, 2)
					panel:DockPadding(2, 2, 2, 2)
					panel:SetHeight(64)

					local entityIcon = vgui.Create( "SpawnIcon", panel )
					entityIcon:Dock(LEFT)
					entityIcon:SetModel(model)
					entityIcon:SetTooltip(name)
					entityIcon:SetWidth(64)
					entityIcon.DoClick = function()
						cont.UpdateData({classname = classname, clone = false})
					end

					local richText = vgui.Create( "RichText" , panel)
					richText:SetFontInternal("DermaDefault")
					richText:InsertColorChange(9, 9, 9, 255)
					richText:AppendText(name .. "\n\n")
					richText:InsertColorChange(40, 40, 40, 255)
					richText:AppendText(desc)
					richText:Dock(FILL)

					panel:InvalidateLayout( true )
					panel:SizeToChildren( false, true )
				end
			end

			return list
		end

		local contWidth, contHeight = cont:GetSize()

		local traps = vgui.Create( "DCollapsibleCategory", cont )
		traps:SetExpanded( 1 )
		traps:SetLabel( "Traps" )
		traps:Dock(TOP)

		local trapsScroll = vgui.Create("DScrollPanel", traps)
		trapsScroll:Dock(TOP)
		trapsScroll:SetHeight(270)
		trapsScroll:SetWidth(contWidth)

		genSpawnList(nzTraps:GetAll(), trapsScroll)


		local logic = vgui.Create( "DCollapsibleCategory", cont )
		logic:SetExpanded( 1 )
		logic:SetLabel( "Logic" )
		logic:Dock(TOP)

		local logicScroll = vgui.Create("DScrollPanel", logic)
		logicScroll:Dock(TOP)
		logicScroll:SetHeight(180)
		logicScroll:SetWidth(contWidth)

		genSpawnList(nzLogic:GetAll(), logicScroll)

		return cont
	end,
	defaultdata = {
		model = "models/hunter/plates/plate2x2.mdl"
	},
})