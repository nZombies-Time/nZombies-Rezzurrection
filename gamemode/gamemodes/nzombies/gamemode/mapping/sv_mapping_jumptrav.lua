--
function nzMapping:JumpBlockSpawn(pos, ang, model, ply)
	local jumpblock = ents.Create( "jumptrav_block" )
	
	-- Replace with nZombies versions of the same model (if exist) which are grate-based (bullets go through)
	local model2 = string.Replace(model, "/hunter/plates/", "/nzombies_plates/")
	if !util.IsValidModel(model2) then
		model2 = model
	end
	print(model2)
	
	jumpblock:SetModel( model2 )
	jumpblock:SetPos( pos )
	jumpblock:SetAngles( ang )
	jumpblock:Spawn()
	jumpblock:PhysicsInit( SOLID_VPHYSICS )
	print(jumpblock:GetModel())

	local phys = jumpblock:GetPhysicsObject()
	if IsValid(phys) then
		phys:EnableMotion(false)
	end

	if ply then
		undo.Create( "Jump Traversal Block" )
			undo.SetPlayer( ply )
			undo.AddEntity( jumpblock )
		undo.Finish( "Effect (" .. tostring( model ) .. ")" )
	end
	return jumpblock
end
