function nzMapping:Radio(pos, ang, sound,ply)
	local ent = ents.Create("nz_radio")
	ent:SetPos(pos)
	ent:SetAngles(ang)
	print(sound)
	
		if sound then
			ent:SetRadio(tostring(sound))
		end
	

	ent:Spawn()

	local phys = ent:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end

	if ply then
		undo.Create("Radio")
			undo.SetPlayer(ply)
			undo.AddEntity(ent)
		undo.Finish("Effect (" .. tostring( sound ) .. ")")
	end

	return ent
end