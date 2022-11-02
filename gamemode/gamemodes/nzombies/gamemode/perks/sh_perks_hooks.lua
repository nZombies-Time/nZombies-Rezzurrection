-- Tortoise upgrade
hook.Add("OnEntityCreated", "nz.Perk.Tortoise_Upgrade", function(ent)
	timer.Simple(0, function() //1 tick delay to get owner info
		if not IsValid(ent) then return end
		local ply = ent:GetOwner()
		if not IsValid(ply) then return end

		if IsValid(ply.Shield) and ent == ply.Shield then
			if ply:HasUpgrade("tortoise") then
				ent:SetHealth(ent:GetMaxHealth()*2)
				ent:SetMaxHealth(ent:GetMaxHealth()*2)
			end
		end
	end)
end)


if SERVER then
	-- Basic shield functionality
	hook.Add("PlayerShouldTakeDamage", "nzShieldBlock", function(ply, ent)
		if ent:IsValidZombie() and IsValid(ply.Shield) then
			local dot = (ent:GetPos() - ply:GetPos()):Dot(ply:GetAimVector())
			local wep = ply:GetActiveWeapon()
			local shield = IsValid(wep) and wep == ply.Shield.Weapon
			if ply:HasPerk("tortoise") and shield then
				ply.Shield:TakeDamage(30, ent, ent)
				return false
			elseif (dot < 0 and !shield) or (dot >= 0 and shield) then
				ply.Shield:TakeDamage(30, ent, ent)
				return false
			end
		end
	end)

	-- Explode when shield breaks
	hook.Add("EntityTakeDamage", "nz.Perk.Tortoise_Explode", function(ent, dmginfo)
		local ply = ent:GetOwner()
		if not IsValid(ply) or not ply:IsPlayer() then return end
		if ply:HasPerk("tortoise") and IsValid(ply.Shield) and ent == ply.Shield then
			if dmginfo:GetDamage() >= ent:Health() or ent:Health() == 0 then

				local round = nzRound:GetNumber() > 0 and nzRound:GetNumber() or 1
				local health = nzCurves.GenerateHealthCurve(round)

				local damage = DamageInfo()
				damage:SetDamage(health or 54000)
				damage:SetInflictor(IsValid(ply.Shield.Weapon) and ply.Shield.Weapon or ent)
				damage:SetAttacker(IsValid(ply) and ply or ent)
				damage:SetDamageType(DMG_BLAST_SURFACE)

				for k, v in pairs(ents.FindInSphere(ply:GetPos(), 300)) do
					if IsValid(v) and v:IsValidZombie() then
						damage:SetDamageForce(v:GetUp()*8000 + (v:GetPos() - ent:GetPos()):GetNormalized()*10000)
						v:TakeDamageInfo(damage)
					end
				end

				util.ScreenShake(ply:GetPos(), 15000, 255, 1.5, 600)
				
				ParticleEffect("grenade_explosion_01", ply:GetPos() + ply:OBBCenter(), Angle(0,0,0))
				
				ply:EmitSound("Perk.Tortoise.Exp")
				ply:EmitSound("Perk.Tortoise.Exp_Firey")
				ply:EmitSound("Perk.Tortoise.Exp_Decay")
			end
		end
	end)

	-- Scale headshot and boss damage
	hook.Add("EntityTakeDamage", "nz.Perk.Death_Damage", function(ent, dmginfo)
		if not IsValid(ent) or not ent:IsValidZombie() then return end
		local ply = dmginfo:GetAttacker()
		if not IsValid(ply) or not ply:IsPlayer() then return end

		if ply:HasPerk("death") then
			local hitgroup = util.QuickTrace(dmginfo:GetDamagePosition(), dmginfo:GetDamagePosition()).HitGroup

			if hitgroup == HITGROUP_HEAD then
				dmginfo:SetDamage(dmginfo:GetDamage() * 1.25)
			end

			if ply:HasUpgrade("death") then
				if ent.NZBossType then
					dmginfo:ScaleDamage((10 - nzRound:GetBossData(ent.NZBossType).dmgmul*10) + 1)
				end
			end
		end
	end)
end

if CLIENT then
	//no matter what i do, in nzr you can only see one zombie at a time

	-- Wall hacks
	/*hook.Add("PreDrawOpaqueRenderables", "nzDeathHalos", function(vm, ply, wep)
		local ply = LocalPlayer()
		if not IsValid(ply) then return end

		local pos = ply:GetShootPos()
		local angle = math.cos(math.rad(60))
		local range = 350
		local aim = ply:GetAimVector()
		
		local tr = {
			start = pos,
			filter = ply,
			mask = MASK_BLOCKLOS
		}

		local cone = ents.FindInCone(pos, aim, range, angle)
		local tab = {}

		for _, ent in pairs(cone) do
			if (ent:IsNPC() or ent:IsNextBot()) and ent:Health() > 0 then
				tr.endpos = ent:WorldSpaceCenter()
				local trace = util.TraceLine(tr)
				if trace.Hit then
					table.insert(tab, ent)
				end
			end
		end

		if ply:HasPerk("death") then
			cam.Start3D(pos)
			cam.IgnoreZ(true)

			for _, ent in pairs(tab) do
				if IsValid(ent) and ent:IsValidZombie() then
					if not ent:IsEffectActive(EF_NODRAW) then
						local mat = Material("vgui/overlay/death_flow.vmt")
						local vec = Vector(1,1,1)

						local dist = ply:GetPos():DistToSqr(ent:GetPos())
						dist = 1 - math.Clamp(dist/350^2, 0, 1)

						render.SuppressEngineLighting(true)
						render.MaterialOverride(mat)
						render.SetBlend(1 * dist)

						vec:Mul(dist)

						mat:SetVector("$emissiveblendtint", vec)
						ent:DrawModel()
					end
				end
			end

			render.SetBlend(1)
			render.MaterialOverride(nil)
			render.SuppressEngineLighting(false)

			cam.IgnoreZ(false)

			cam.End3D()
		end
	end)*/

    -- Screen indicators
    hook.Add("HUDPaint", "nz.Perk.Death_Hud", function()
        local ply = LocalPlayer()
        if not IsValid(ply) then return end

        if ply:HasPerk("death") then
            local pos = ply:GetPos()
            local range = 350
            local ang = 0.65

            local dents = {}

            local cone = ents.FindInSphere(pos, range)

            for _, ent in pairs(cone) do
                if ent:IsValidZombie() and ent:Health() > 0 then
                    local dir = ply:EyeAngles():Forward()
                    local facing = (ply:GetPos() - ent:GetPos()):GetNormalized()
                    if (facing:Dot(dir) + 1) / 2 > ang then
                        table.insert(dents, ent)
                    end
                end
            end

            local screen = ScreenScale(16)

            for _, ent in ipairs(dents) do
                local dist = math.Clamp(ply:GetPos():Distance(ent:GetPos()) / 200, 0, 1)
                local dir = (ent:GetPos() - ply:GetShootPos()):Angle()
                dir = dir - EyeAngles()
                local angle = dir.y + 90

                local x = (math.cos(math.rad(angle)) * ScreenScale(128)) + ScrW() / 2
                local y = (math.sin(math.rad(angle)) * -ScreenScale(128)) + ScrH() / 2

                surface.SetMaterial(Material("vgui/hud/grenadepointer.png", "smooth unlitgeneric"))
                surface.SetDrawColor(255,255*dist,255*dist,225)
                surface.DrawTexturedRectRotated(x, y, screen, screen, angle - 90)
            end
        end
    end)
end