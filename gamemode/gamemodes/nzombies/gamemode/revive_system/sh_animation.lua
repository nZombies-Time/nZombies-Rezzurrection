local function HandlePlayerDowned(ply, vel)
	if !ply:GetNotDowned() then
		ply.CalcIdeal = ACT_HL2MP_SIT_AR2
		
		local len = vel:Length2D()
		if ( len <= 1 ) then
			ply.CalcIdeal = ACT_HL2MP_SIT_AR2
		end
		
		return ply.CalcIdeal, ply.CalcSeqOverride
	end
end
hook.Add("CalcMainActivity", "nzPlayerDownedAnims", HandlePlayerDowned)
