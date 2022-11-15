local PLAYER = FindMetaTable("Player")

if PLAYER then
	function PLAYER:GetShield()
		return self:GetNW2Entity("nZ.ShieldEnt")
	end

	function PLAYER:SetShield(ent)
		return self:SetNW2Entity("nZ.ShieldEnt", ent)
	end
end

hook.Add("InitPostEntity", "nzShieldRegister", function()
	nzSpecialWeapons:RegisterSpecialWeaponCategory("shield", KEY_N)
end)

hook.Add("OnPlayerPickupPowerUp", "nzShieldRefill", function( _, id, ent )
	if id == "carpenter" then
		for i, ply in ipairs(player.GetAll()) do
			if IsValid(ply:GetShield()) then
				ply:GetShield():SetHealth(ply:GetShield():GetMaxHealth())
				if IsValid(ply:GetShield().Weapon) then
					ply:GetShield().Weapon:SetDamage(0)
				end
			end
		end
	end
end)

if SERVER then
	-- Basic shield functionality
	hook.Add("PlayerShouldTakeDamage", "nzShieldBlock", function(ply, ent)
		if ent:IsValidZombie() and IsValid(ply:GetShield()) and IsValid(ply:GetShield().Weapon) then
			local dot = (ent:GetPos() - ply:GetPos()):Dot(ply:GetAimVector())
			local wep = ply:GetActiveWeapon()

			local shield = IsValid(wep) and wep == ply:GetShield().Weapon

			if ply:HasPerk("tortoise") and shield then
				ply:GetShield():TakeDamage(30, ent, ent)
				return false
			end

			if (dot < 0 and not shield) or (dot >= 0 and shield) then
				ply:GetShield():TakeDamage(30, ent, ent)
				return false
			end
		end
	end)
end
