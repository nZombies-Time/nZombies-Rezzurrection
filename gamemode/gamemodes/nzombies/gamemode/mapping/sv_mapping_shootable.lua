function nzMapping:SpawnShootable(pos, ang, ply, data)
	local ent = ents.Create("nz_shootable")
	ent:SetPos(pos)
	ent:SetAngles(ang)

	if data then
		if data.model and util.IsValidModel(data.model) then
			ent:SetModel(tostring(data.model))
		end
		if data.hurttype then
			ent:SetHurtType(tonumber(data.hurttype))
		end
		if data.rewardtype then
			ent:SetRewardType(tonumber(data.rewardtype))
		end
		if data.pointamount then
			ent:SetPointAmount(tonumber(data.pointamount))
		end
		if data.door then
			ent:SetDoorFlag(tostring(data.door))
		end
		if data.killall then
			ent.KillAll = tobool(data.killall)
		end
		if data.upgrade then
			ent:SetUpgrade(tobool(data.upgrade))
		end
		if data.global then
			ent:SetGlobal(tobool(data.global))
		end
	end

	ent:Spawn()

	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end

	if ply then
		undo.Create("Shootable")
			undo.SetPlayer(ply)
			undo.AddEntity(ent)
		undo.Finish("Effect (" .. tostring( model ) .. ")")
	end

	return ent
end
