if SERVER then
	//all credits to wgetJane for tf2 style damage indicators
	util.AddNetworkString("nz.dmgindicator")

	local function percent2uint(a, b, c)
		return math.Clamp(math.floor(a / b * c + 0.5), 0, c)
	end

	local worldents = {
		["invis_damage_wall"] = true,
		["nz_trap_projectiles"] = true,
	}

	hook.Add("PostEntityTakeDamage", "nz.DamageIndicators", function(victim, dmginfo, took)
		if not (IsValid(victim) and victim:IsPlayer() and victim:Alive()) then return end
		if not took then return end

		local dmg = dmginfo:GetDamage()
		if dmg <= 0 then return end

		local src, pos

		if dmginfo:IsDamageType(DMG_FALL + DMG_DROWN) then
			pos = victim:GetPos()
		else
			src = dmginfo:GetAttacker()

			if IsValid(src) and not src:IsWorld() and not src:IsPlayer() then
				if worldents[src:GetClass()] then
					pos = victim:WorldSpaceCenter()
				else
					pos = (src:IsNPC() or src:IsNextBot()) and src:EyePos() or src:WorldSpaceCenter()
				end
			end
			if not pos or pos:IsZero() then
				pos = dmginfo:GetDamagePosition()
				if pos:IsZero() then
					pos = victim:EyePos()
				end
			end
		end

		pos:Mul(-1)
		pos:Add(victim:EyePos())

		local len = percent2uint(pos:Length(), 1024, 1023)

		pos:Normalize()

		net.Start("nz.dmgindicator")
			net.WriteUInt(len, 10)
			for i = 1, 3 do
				net.WriteUInt(percent2uint(pos[i] + 1, 2, 1023), 10)
			end
		net.Send(victim)
	end)
end

if CLIENT then
	local zmhud_icon_damage = Material("nz_moo/icons/hit_direction.png", "unlitgeneric smooth")

	local cvarname = "nz_hud_dmg_indicators"
	local enabled = CreateConVar(cvarname, 1, FCVAR_ARCHIVE, "Enable or disable showing damage direction indicators when attacked. (0 false, 1 true), Default is 1.", 0, 1):GetBool()
	cvars.AddChangeCallback(cvarname, function(name, old, new)
		enabled = tonumber(new) == 1
	end)

	local ply = LocalPlayer()
	hook.Add("InitPostEntity", "nzdamageHUD_InitPostEntity", function()
		ply = LocalPlayer()
	end)

	local w2, h2 = ScrW() / 2, ScrH() / 2
	hook.Add("OnScreenSizeChanged", "nzdamageHUD_OnScreenSizeChanged", function()
		w2, h2 = ScrW() / 2, ScrH() / 2
	end)

	local head, tail
	local pool_size, pool = 0
	local RealTime = RealTime

	net.Receive("nz.dmgindicator", function()
		if not enabled then
			return
		end

		local len = net.ReadUInt(10) / 1023 * 1024

		local pos = ply:EyePos()

		for i = 1, 3 do
			pos[i] = pos[i] - (net.ReadUInt(10) / (1023 * 0.5) - 1) * len
		end

		local ind = tail

		local push
		if pool then
			push = pool

			pool = push.nxtpool

			pool_size = pool_size - 1
		else
			push = {0, 0, 0}
		end

		push.start = RealTime()
		push[1], push[2], push[3] = pos.x, pos.y, pos.z

		tail = push

		if ind then
			ind.nxt = tail
		else
			head = tail
		end
	end)

	local SetMaterial, SetDrawColor, DrawTexturedRectRotated =
		surface.SetMaterial, surface.SetDrawColor, surface.DrawTexturedRectRotated
	local min, max, atan2, sin, cos =
		math.min, math.max, math.atan2, math.sin, math.cos

	hook.Add("HUDPaint", "nzdamageHUD", function()
		if not head then return end

		if not (IsValid(ply) and ply:Alive()) then
			local ind = head
			head, tail = nil, nil

			::clear::

			if pool_size < 8 then
				ind.nxtpool = pool

				pool = ind

				pool_size = pool_size + 1
			else
				ind.nxtpool = nil
			end

			local nxt = ind.nxt

			if nxt then
				ind.nxt = nil

				ind = nxt

				goto clear
			end

			return
		end

		local realtime = RealTime()

		local scale = h2 * (2 / 1080)

		local eyepos = EyePos()
		local ex, ey, ez = eyepos[1], eyepos[2], eyepos[3]

		local eyeang = EyeAngles()
		local eyaw = (eyeang[2] - 180) * 0.017453292519943

		SetMaterial(zmhud_icon_damage)

		local ind, prev = head

		::loop::

		local lifetime = realtime - ind.start

		local max_lifetime = 2

		local nxt = ind.nxt

		if lifetime > max_lifetime then
			if pool_size < 8 then
				ind.nxtpool = pool

				pool = ind

				pool_size = pool_size + 1
			else
				ind.nxtpool = nil
			end

			ind.nxt = nil

			prev, ind = ind, prev

			if prev == head then
				head = nxt

				if not nxt then
					tail = nil

					return
				end
			else
				ind.nxt = nxt
			end
		else
			local hold = 1
			local lifeperc = 1 - (lifetime - max_lifetime + hold) / hold

			SetDrawColor(ColorAlpha(color_white, 255*lifeperc))

			local x, y, z = ex - ind[1], ey - ind[2], ez - ind[3]

			local yaw = atan2(y, x) - eyaw

			DrawTexturedRectRotated(w2 - 256 * sin(yaw) * scale, h2 - 256 * cos(yaw) * scale, 256*scale, 256*scale, yaw * 57.295779513082)
		end

		prev, ind = ind, nxt

		if ind then
			goto loop
		end
	end)
end
