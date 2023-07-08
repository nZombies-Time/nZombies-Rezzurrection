if SERVER then
	util.AddNetworkString("nzUpdateVultureArray")
	util.AddNetworkString("nzCleanVultureArray")

	function nzPerks:AddVultureEntity(ent, reciever)
		if not IsValid(ent) then return end

		if !table.HasValue(nzPerks.VultureArray, ent) then
			table.insert(nzPerks.VultureArray, ent)
		end

		net.Start("nzUpdateVultureArray")
			net.WriteEntity(ent)
			net.WriteBool(false)
		return reciever and net.Send(reciever) or net.Broadcast()
	end

	function nzPerks:RemoveVultureEntity(ent, reciever)
		if not IsValid(ent) then return end

		if table.HasValue(nzPerks.VultureArray, ent) then
			table.RemoveByValue(nzPerks.VultureArray, ent)
		end

		net.Start("nzUpdateVultureArray")
			net.WriteEntity(ent)
			net.WriteBool(true)
		return reciever and net.Send(reciever) or net.Broadcast()
	end

	function nzPerks:CleanVultureArray()
		nzPerks.VultureArray = {}

		net.Start("nzCleanVultureArray")
		net.Broadcast()
	end

	FullSyncModules["nzPerks"] = function(ply)
		for _, ent in pairs(nzPerks.VultureArray) do
			nzPerks:AddVultureEntity(ent, ply)
		end
	end

	//clean then build incase loading a new config on the same map
	hook.Add("PostConfigLoad", "NZ.BuildVultureArray", function()
		nzPerks:CleanVultureArray()
		timer.Simple(2, function()
			for _, ent in pairs(ents.GetAll()) do
				if nzPerks.VultureClass[ent:GetClass()] then
					nzPerks:AddVultureEntity(ent)
				end
			end
		end)
	end)

	hook.Add("OnEntityCreated", "NZ.VultureArrayFix", function(ent)
		if nzPerks.VultureClass[ent:GetClass()] then
			timer.Simple(1, function()
				if not IsValid(ent) then return end
				nzPerks:AddVultureEntity(ent)
			end)
		end
	end)

	hook.Add("EntityRemoved", "NZ.VultureArrayFix", function(ent)
		if IsValid(ent) and nzPerks.VultureClass[ent:GetClass()] and table.HasValue(nzPerks.VultureArray, ent) then
			nzPerks:RemoveVultureEntity(ent)
		end
	end)
end

if CLIENT then
	local function RecieveVultureArrayUpdate( length )
		local ent = net.ReadEntity()
		local remove = net.ReadBool()
		//if not IsValid(ent) then return end

		if !table.HasValue(nzPerks.VultureArray, ent) then
			table.insert(nzPerks.VultureArray, ent)
		end
		if remove then
			table.RemoveByValue(nzPerks.VultureArray, ent)
		end
	end

	local function RecieveVultureArrayClean( length )
		nzPerks.VultureArray = {}
	end

	net.Receive("nzUpdateVultureArray", RecieveVultureArrayUpdate)
	net.Receive("nzCleanVultureArray", RecieveVultureArrayClean)
end
