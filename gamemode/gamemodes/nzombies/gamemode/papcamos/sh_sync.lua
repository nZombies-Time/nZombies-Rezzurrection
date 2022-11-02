if SERVER then
	-- Server to client (Server)
	util.AddNetworkString( "nzCamos.Generate" )

	function nzCamos:GenerateCamo( ply, weapon )
		net.Start( "nzCamos.Generate" )
			net.WriteEntity( weapon )
		return ply and net.Send( ply ) or net.Broadcast()
	end

	util.AddNetworkString( "nzCamos.GenerateVElment" )

	function nzCamos:GenerateVElementCamo( ply, weapon, model )
		net.Start( "nzCamos.GenerateVElment" )
			net.WriteEntity( weapon )
			net.WriteString( model )
		return ply and net.Send( ply ) or net.Broadcast()
	end

	util.AddNetworkString( "nzCamos.Randomize" )

	function nzCamos:RandomizeCamo( ply, weapon )
		net.Start( "nzCamos.Randomize" )
			net.WriteEntity( weapon )
		return ply and net.Send( ply ) or net.Broadcast()
	end
end

if CLIENT then
	local function RandomizeCamo( length )
		local wep = net.ReadEntity()
		if not IsValid(wep) then return end

		if wep.IsTFAWeapon or wep.CW20Weapon or wep.IsFAS2Weapon then
			if not wep.nzPaPCamo then
				wep.nzPaPCamo = table.Random(nzCamos:GetCamos(nzMapping.Settings.PAPcamo))
			end
		end
	end

	net.Receive( "nzCamos.Randomize", RandomizeCamo )
	
	local function IsGoodMaterial(name)
		local bannedmatnames = {
			"accessor", "scope", "sight",
			"optic", "reticle", "_lens",
			"stencil", "_glow", "tritium",
			"glass", "light", "decal",
			"sticker", "wood", "sling",
			"strap", "bullet",
		}

		for k, v in pairs(bannedmatnames) do
			if string.find(name, v) then
				return false
			end
		end

		return true
	end

	local function IsGoodMaterialKey(name)
		local bannedkeys = {
			["$emissiveblendenabled"] = true,
		}

		local bannedflagval = {
			[2097152] = true,
			[256] = true,
			[64] = true,
			[4] = true,
		}

		//PrintTable(name:GetKeyValues())

		for k, v in pairs(name:GetKeyValues()) do
			if tostring(k) == "$flags" and bannedflagval[tonumber(v)] then
				return false
			end

			if bannedkeys[tostring(k)] and v == 1 then
				return false
			end

			if tostring(k) == "$detail" then
				return false
			end
		end

		if name:GetShader() == "UnlitGeneric" then
			return false
		end

		return true
	end

	local function GenerateCamo( length )
		local wep = net.ReadEntity()
		if not IsValid(wep) then return end

		if wep.IsTFAWeapon or wep.CW20Weapon or wep.IsFAS2Weapon then
			if not wep.PaPOverrideMat or table.IsEmpty(wep.PaPOverrideMat) then
				wep.PaPOverrideMat = {}

				local model = wep.VM or wep.ViewModel or (wep.GetViewModel and wep:GetViewModel() or wep.ViewModel)
				if model then
					local cmdl = ClientsideModel(model)
					local mats = cmdl:GetMaterials()
					for k, v in pairs(mats) do
						if IsGoodMaterial(v) and IsGoodMaterialKey(Material(v)) then
							wep.PaPOverrideMat[k - 1] = true
						end
					end
					cmdl:Remove()
				end
			end
		end
	end

	net.Receive( "nzCamos.Generate", GenerateCamo )

	local function GenerateVElementCamo( length )
		local wep = net.ReadEntity()
		local element = net.ReadString()
		if not IsValid(wep) then return end

		if wep.IsTFAWeapon and wep.VElements then
			if not wep.VPaPOverrideMat or table.IsEmpty(wep.VPaPOverrideMat) then
				wep.VPaPOverrideMat = {}

				local model = wep.VElements[element].model
				if model then
					local cmdl = ClientsideModel(model)
					local mats = cmdl:GetMaterials()
					for k, v in pairs(mats) do
						if IsGoodMaterial(v) and IsGoodMaterialKey(Material(v)) then
							wep.VPaPOverrideMat[k - 1] = true
						end
					end
					cmdl:Remove()
				end
			end
		end
	end

	net.Receive( "nzCamos.GenerateVElment", GenerateVElementCamo )
end