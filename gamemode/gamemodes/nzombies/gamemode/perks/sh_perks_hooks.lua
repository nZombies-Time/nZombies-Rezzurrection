-- Tortoise upgrade and Explosion
hook.Add("OnEntityCreated", "nz.Perk.Tortoise_Upgrade", function(ent)
	timer.Simple(engine.TickInterval(), function() //1 tick delay to get owner info
		if not IsValid(ent) then return end
		local ply = ent:GetOwner()
		if not IsValid(ply) or not ply:IsPlayer() then return end

		if ply:HasPerk("tortoise") and IsValid(ply:GetShield()) and ent == ply:GetShield() then
			ent:CallOnRemove("nz.Perk.Tortoise_Exp", function(ent)
				local damage = DamageInfo()
				damage:SetDamage(54000)
				damage:SetAttacker(IsValid(ply) and ply or ent)
				damage:SetInflictor(IsValid(ply:GetShield().Weapon) and ply:GetShield().Weapon or ent)
				damage:SetDamageType(DMG_BLAST_SURFACE)

				for k, v in pairs(ents.FindInSphere(ply:GetPos(), 512)) do
					if v:IsValidZombie() then
						damage:SetDamageForce(v:GetUp()*8000 + (v:GetPos() - ent:GetPos()):GetNormalized()*10000)
						if SERVER then
							v:TakeDamageInfo(damage)
						end
					end
				end

				util.ScreenShake(ply:GetPos(), 10, 255, 1.5, 600)

				ParticleEffect("grenade_explosion_01", ply:WorldSpaceCenter(), Angle(0,0,0))

				ply:EmitSound("Perk.Tortoise.Exp")
				ply:EmitSound("Perk.Tortoise.Exp_Firey")
				ply:EmitSound("Perk.Tortoise.Exp_Decay")
			end)

			if ply:HasUpgrade("tortoise") then
				ent:SetHealth(ent:GetMaxHealth()*2)
				ent:SetMaxHealth(ent:GetMaxHealth()*2)
			end
		end
	end)
end)

if SERVER then
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
            local range = 400
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