// infinite warfare down anim
/*hook.Add("CalcMainActivity", "nzDownedAnimation", function(ply, vel)
	if !ply:GetNotDowned() then
		local angle, angle2 = vel:Angle(), ply:GetAngles()
		local ydif = math.abs(math.NormalizeAngle(angle.y - angle2.y))

		local seq1 = ply:LookupSequence("crawl_idle")
		local seq2 = ply:LookupSequence("crawl_back")
		local seq3 = ply:LookupSequence("crawl_forward")

		ply:SetPlaybackRate(0)
		ply:SetCycle(CurTime())

		if vel:Length2D() < 1 then
			return ACT_IDLE, seq1
		elseif ydif < 90 then
			return ACT_IDLE, seq3
		else
			return ACT_IDLE, seq2
		end
	end
end)

local cyclex, cycley = 0.6,0.65
hook.Add("UpdateAnimation", "nzDownedAnimation", function(ply, vel, seqspeed)
	if !ply:GetNotDowned() then
		local movement = 0

		local len = vel:Length2D()
		if len > 1 then
			movement = len / seqspeed
		else
			local cycle = ply:GetCycle()
			if cycle < cyclex or cycle > cycley then
				movement = 5
			end
		end

		ply:SetPlaybackRate(movement)
		return true
	end
end)*/

//nzu swimming down anim
hook.Add("CalcMainActivity", "nzDownedAnimation", function(ply, vel)
	if !ply:GetNotDowned() then
		if vel:Length2D() > 1 then
			ply.CalcIdeal = ACT_HL2MP_SWIM_REVOLVER
		else
			ply.CalcIdeal = ACT_HL2MP_SWIM_PISTOL
		end

		return ply.CalcIdeal, ply.CalcSeqOverride
	end
end)

local cyclex, cycley = 0.6,0.65
local loweredpos = Vector(0,0,-30)
local rotate = Angle(0,0,-30)

hook.Add("UpdateAnimation", "nzDownedAnimation", function(ply, vel, seqspeed)
	if !ply:GetNotDowned() then
		local movement = 0

		local len = vel:Length2D()
		if len > 1 then
			movement = len / seqspeed
		else
			local cycle = ply:GetCycle()
			if cycle < cyclex or cycle > cycley then
				movement = 5
			end
		end

		ply:SetPoseParameter("move_x", -1)
		ply:SetPlaybackRate(movement)

		if not ply.nzu_DownedAnim then
			ply:ManipulateBonePosition(0, loweredpos)
			ply:ManipulateBoneAngles(0, rotate)
			ply.nzu_DownedAnim = true
		end

		return true
	elseif ply.nzu_DownedAnim then
		ply:ManipulateBonePosition(0, Vector(0,0,0))
		ply:ManipulateBoneAngles(0, Angle(0,0,0))
		ply.nzu_DownedAnim = false
	end
end)
