-- Main Tables
nzNav = nzNav or AddNZModule("Nav")
nzNav.Functions = {}
nzNav.NavGroups = {}
nzNav.NavGroupIDs = {}
nzNav.Data = nzNav.Data or {}
nzNav.Locks = nzNav.Locks or {}

-- I'm actually gonna kill 2016 Zet for removing such a good feature just because it wasn't being used. ~Moo

function IsNavApplicable(ent)
	-- All classes that can be linked with navigation
	if !IsValid(ent) then return false end
	if (ent:IsDoor() or ent:IsBuyableProp() or ent:IsButton()) and ent:GetDoorData().link then
		return true
	else
		return false
	end
end

function nzNav.FlushAllNavModifications()
	nzNav.Locks = {}
	nzNav.Data = {}
end

//Reset navmesh attributes so they don't accidentally save
function GM:ShutDown()
	for k,v in pairs(nzNav.Data) do
		navmesh.GetNavAreaByID(k):SetAttributes(v.prev)
	end
end

local NavFloodSelectedSet = {}
local NavFloodAlreadySelected = {}

function FloodSelectNavAreas(area)
	//Clear tables to be ready for a new selection
	NavFloodSelectedSet = {}
	NavFloodAlreadySelected = {}

	//Start off on the current area
	AddFloodSelectedToSet(area)

	return NavFloodSelectedSet
end

function AddFloodSelectedToSet(area)
	//Prevent locked or door-linked navmeshes from being selected
	if nzNav.Data[area:GetID()] then return end

	//Add it to the table and make sure it doesn't get reached again
	NavFloodAlreadySelected[area:GetID()] = true
	table.insert(NavFloodSelectedSet, area)

	//Loop through adjacent areas and do the same thing
	for k,v in pairs(area:GetAdjacentAreas()) do
		if !NavFloodAlreadySelected[v:GetID()] and v:IsConnected(area) then
			AddFloodSelectedToSet(v)
		end
	end
end

function nzNav.Functions.AddNavGroupIDToArea(area, id)
	local id = string.lower(id)

	//Set the areas ID to the given one
	nzNav.NavGroups[area:GetID()] = id

	//Create the entire group in the index table if it isn't already there
	if !nzNav.NavGroupIDs[id] then
		nzNav.NavGroupIDs[id] = {[id] = true}
	end
end

function nzNav.Functions.RemoveNavGroupArea(area, deletegroup)
	//Remove the entire group from the index table
	if deletegroup and nzNav.NavGroupIDs[nzNav.NavGroups[area:GetID()]] then
		nzNav.NavGroupIDs[nzNav.NavGroups[area:GetID()]] = nil
	end

	//Remove the group data behind the area itself
	nzNav.NavGroups[area:GetID()] = nil
end

function nzNav.Functions.MergeNavGroups(id1, id2)
	if !id1 or !nzNav.NavGroupIDs[id1] then Error("MergeNavGroups called with invalid id1!") return end
	if !id2 or !nzNav.NavGroupIDs[id2] then Error("MergeNavGroups called with invalid id2!") return end

	local tbl = {}
	for k,v in pairs(nzNav.NavGroupIDs[id1]) do
		tbl[k] = true
	end
	for k,v in pairs(nzNav.NavGroupIDs[id2]) do
		tbl[k] = true
	end
	tbl[id1] = true
	tbl[id2] = true

	for k,v in pairs(tbl) do
		nzNav.NavGroupIDs[k] = tbl
	end
end

function nzNav.Functions.GetNavGroup(area)
	if type(area) != "CNavArea" then area = navmesh.GetNearestNavArea(area:GetPos()) end
	return nzNav.NavGroupIDs[nzNav.NavGroups[area:GetID()]]
end

function nzNav.Functions.GetNavGroupID(area)
	if type(area) != "CNavArea" then area = navmesh.GetNearestNavArea(area:GetPos()) end
	return nzNav.NavGroups[area:GetID()]
end

function nzNav.Functions.IsInSameNavGroup(ent1, ent2)
    if not (IsValid(ent1) or IsValid(ent2)) then return true end

    local cunt = navmesh.GetNearestNavArea(ent1:GetPos())
    if not IsValid(cunt) then return true end

    local fuckwad = navmesh.GetNearestNavArea(ent2:GetPos())
    if not IsValid(fuckwad) then return true end

    local area1 = nzNav.NavGroups[cunt:GetID()]
    if not area1 then return true end

    local area2 = nzNav.NavGroups[fuckwad:GetID()]
    if not area2 then return true end

    if not table.HasValue(nzNav.NavGroups, area1) then print("PARKED IN AN ILLEGAL ZONE, YOU WILL BE TOE'D AND FINED 1$") return true end
    if not table.HasValue(nzNav.NavGroups, area2) then print("PARKED IN AN ILLEGAL ZONE, YOU WILL BE TOE'D AND FINED 2$") return true end

    return nzNav.NavGroupIDs[area1][area2] or false
end

function nzNav.Functions.IsPosInSameNavGroup(pos1, pos2)
	local area1 = nzNav.NavGroups[navmesh.GetNearestNavArea(pos1):GetID()]
	if !area1 then return true end

	local area2 = nzNav.NavGroups[navmesh.GetNearestNavArea(pos2):GetID()]
	if !area2 then return true end

	return nzNav.NavGroupIDs[area1][area2] or false
end

function nzNav.ResetNavGroupMerges()
	local tbl = table.GetKeys(nzNav.NavGroupIDs)
	nzNav.NavGroupIDs = {}
	for k,v in pairs(tbl) do
		nzNav.NavGroupIDs[v] = {[v] = true}
	end
end

function nzNav.GenerateCleanGroupIDList()
	//Something to use in case everything messes up - loops through all saved navmeshes and adds them to the index list
	nzNav.NavGroupIDs = {}
	for k,v in pairs(nzNav.NavGroups) do
		nzNav.NavGroupIDs[v] = {[v] = true}
	end
end

function nzNav.Functions.CreateAutoMergeLink(door, id)
	if !door:IsDoor() and !door:IsBuyableProp() and !door:IsButton() then return end
	if door.linkedmeshes then
		if !table.HasValue(door.linkedmeshes, id) then
			table.insert(door.linkedmeshes, id)
		end
	else
		door.linkedmeshes = {}
		table.insert(door.linkedmeshes, id)
	end
end

function nzNav.Functions.UnlinkAutoMergeLink(door)
	if !door:IsDoor() and !door:IsBuyableProp() and !door:IsButton() then return end
	if door.linkedmeshes then
		door.linkedmeshes = nil
	end
end

function nzNav.Functions.AutoGenerateAutoMergeLinks()
	for k,v in pairs(nzNav.Data) do
		if v.link then
			for k2,v2 in pairs(ents.GetAll()) do
				if v2:IsDoor() or v2:IsBuyableProp() or v2:IsButton() then
					if v2.link == v.link then
						nzNav.Functions.CreateAutoMergeLink(v2, k)
						print("Linked navmesh "..k.." to door", v2)
					end
				end
			end
		end
	end
end

function nzNav.Functions.OnNavMeshUnlocked(areaids)
	local tbl = {}

	for k,v in pairs(areaids) do
		local area = navmesh.GetNavAreaByID(v)
		for k2,v2 in pairs(area:GetAdjacentAreas()) do
			local group = nzNav.NavGroups[v2:GetID()]
			if group then
				tbl[group] = true
			end
		end
	end

	local prev_group = nil
	for k,v in pairs(tbl) do
		if prev_group then
			nzNav.Functions.MergeNavGroups(k, prev_group)
		end
		prev_group = k
	end
end
