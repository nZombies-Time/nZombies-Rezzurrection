function nzMapping:Jukebox(pos, ang, ply)
	local ent = ents.Create("nz_jukebox")
	ent:SetPos(pos)
	ent:SetAngles(ang)
	ent:Spawn()

	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end

	if ply then
		undo.Create("Jukebox")
			undo.SetPlayer(ply)
			undo.AddEntity(ent)
		undo.Finish("Effect (" .. tostring( sound ) .. ")")
	end

	return ent
end
