local playerMeta = FindMetaTable("Player")
local wepMeta = FindMetaTable("Weapon")

if SERVER then
	
	-- Now handled in default weapon modifiers
	
	--[[function ReplaceReloadFunction(wep)
		-- Either not a weapon, doesn't have a reload function, or is FAS2
		if wep:NZPerkSpecialTreatment() then return end
		local oldreload = wep.Reload
		if !oldreload then return end
		
		--print("Weapon reload modified")
		
		wep.Reload = function( self, ... )
			if self.ReloadFinish and self.ReloadFinish > CurTime() then return end
			local ply = self.Owner
			if ply:HasPerk("speed") then
				--print("Hasd perk")
				local cur = self:Clip1()
				if cur >= self:GetMaxClip1() then return end
				local give = self:GetMaxClip1() - cur
				if give > ply:GetAmmoCount(self:GetPrimaryAmmoType()) then
					give = ply:GetAmmoCount(self:GetPrimaryAmmoType())
				end
				if give <= 0 then return end
				--print(give)
				
				self:SendWeaponAnim(ACT_VM_RELOAD)
				oldreload(self, ...)
				local rtime = self:SequenceDuration(self:SelectWeightedSequence(ACT_VM_RELOAD))/2
				self:SetPlaybackRate(2)
				ply:GetViewModel():SetPlaybackRate(2)

				local nexttime = CurTime() + rtime

				self:SetNextPrimaryFire(nexttime)
				self:SetNextSecondaryFire(nexttime)
				self.ReloadFinish = nexttime
				
				timer.Simple(rtime, function()
					if IsValid(self) and ply:GetActiveWeapon() == self then
						self:SetPlaybackRate(1)
						ply:GetViewModel():SetPlaybackRate(1)
						self:SendWeaponAnim(ACT_VM_IDLE)
						self:SetClip1(give + cur)
						ply:RemoveAmmo(give, self:GetPrimaryAmmoType())
						self:SetNextPrimaryFire(0)
						self:SetNextSecondaryFire(0)
					end
				end)
			else
				oldreload(self, ...)
			end
		end
	end
	hook.Add("WeaponEquip", "nzModifyWeaponReloads", ReplaceReloadFunction)
	
	function ReplacePrimaryFireCooldown(wep)
		local oldfire = wep.PrimaryAttack
		if !oldfire then return end
		
		--print("Weapon fire modified")
		
		wep.PrimaryAttack = function(...)
			oldfire(wep, ...)
			
			-- FAS2 weapons have built-in DTap functionality
			if wep:IsFAS2() then return end
			-- With double tap, reduce the delay for next primary fire to 2/3
			if wep.Owner:HasPerk("dtap") or wep.Owner:HasPerk("dtap2") then
				local delay = (wep:GetNextPrimaryFire() - CurTime())*0.80
				wep:SetNextPrimaryFire(CurTime() + delay)
			end
		end
	end
	hook.Add("WeaponEquip", "nzModifyWeaponNextFires", ReplacePrimaryFireCooldown)]]
	
	function ReplaceAimDownSight(wep)
		local oldfire = wep.SecondaryAttack
		if !oldfire then return end
		
		--print("Weapon fire modified")
		
		wep.SecondaryAttack = function(...)
			oldfire(wep, ...)
			-- With deadshot, aim at the head of the entity aimed at
			if wep.Owner:HasPerk("deadshot") then
				local tr = wep.Owner:GetEyeTrace()
				local ent = tr.Entity
				if IsValid(ent) and nzConfig.ValidEnemies[ent:GetClass()] then
					local head = ent:LookupBone("ValveBiped.Bip01_Neck1")
					if head then
						local headpos,headang = ent:GetBonePosition(head)
						wep.Owner:SetEyeAngles((headpos - wep.Owner:GetShootPos()):Angle())
					end
				end
			end
		end
	end
	hook.Add("WeaponEquip", "nzModifyAimDownSights", ReplaceAimDownSight)
	
	function GM:GetFallDamage( ply, speed )
		local dmg = speed / 10
		if ply:HasPerk("phd") and dmg >= 25 then
			if ply:Crouching() then
				local zombies = ents.FindInSphere(ply:GetPos(), 300)
				for k,v in pairs(zombies) do
					if nzConfig.ValidEnemies[v:GetClass()] then
						v:TakeDamage(300, ply, ply)
					end
				end
				local pos = ply:GetPos()
				local effectdata = EffectData()
				effectdata:SetOrigin( pos )
				util.Effect( "HelicopterMegaBomb", effectdata )
				ply:EmitSound("phx/explode0"..math.random(0, 6)..".wav")
			end
			return 0
		end
		return ( dmg )
	end
	
	local oldsetwep = playerMeta.SetActiveWeapon
	function playerMeta:SetActiveWeapon(wep)
    if isstring(wep) then
        local wepEnt = weapons.Get(wep)
        if istable(wepEnt) == true then
          wep = ents.Create(wep)
        else
          print(string.format("[nZ] Error : Function SetActiveWeapon get a bad wep classname : %s",wep))
          return
        end
    end

    local oldwep = self:GetActiveWeapon()
    if IsValid(oldwep) and !oldwep:IsSpecial() then
        self.NZPrevWep = oldwep
    end
    oldsetwep(self, wep)
end
	
else
	
	--[[ Manual speedup of the reload function on FAS2 weapons - seemed like the original solution broke along the way
	function ReplaceReloadFunction(wep)
		print(wep, "HUKDAHD1")
		if wep:IsFAS2() then
			print(wep, "HUKDAHD2")
			local oldreload = wep.Reload
			if !oldreload then return end
			print(wep, "HUKDAHD3")
			wep.Reload = function()
				print(wep, "HUKDAHD4")
				oldreload(wep)
				if LocalPlayer():HasPerk("speed") then
					wep.Wep:SetPlaybackRate(2)
				end
			end
			print(wep, "HUKDAHD5")
		end
	end
	hook.Add("HUDWeaponPickedUp", "ModifyFAS2WeaponReloads", ReplaceReloadFunction)]]
	
end

local olddefreload = wepMeta.DefaultReload
function wepMeta:DefaultReload(act)
	if IsValid(self.Owner) and self.Owner:HasPerk("speed") then return end
	olddefreload(self, act)
end

local ghosttraceentities = {
	["wall_block"] = true,
	["invis_wall"] = true,
	["invis_damage_wall"] = true,
	["player"] = true,
}

function GM:EntityFireBullets(ent, data)

	-- Fire the PaP shooting sound if the weapon is PaP'd
	--print(wep, wep:HasNZModifier("pap"))
	if ent:IsPlayer() then
	 local fuckercheck = ent:GetEyeTrace().Entity
	 if IsValid(fuckercheck) and fuckercheck:IsPlayer() and fuckercheck:GetGettingFacefucked() then
	    	for k, v in pairs(ents.FindInSphere(fuckercheck:GetPos(), 75)) do
                	if v:GetClass() == "nz_facehugger" then
					print("GET THIS SHIT OFF ME")
					ParticleEffect("ins_blood_impact_headshot",v:GetPos(),Angle(0,0,0),nil)
					v:EmitSound("nz_moo/zombies/gibs/gib_0"..math.random(3)..".mp3",100)
					v:Remove()
					end
            	
        	end
	 end
		local wep = ent:GetActiveWeapon()
		if IsValid(wep) and wep:HasNZModifier("pap") and !wep.IsMelee and !wep.IsKnife then
			nzSounds:PlayEnt("UpgradedShoot", ent)
		end
	end
	-- Perform a trace that filters out entities from the table above
	--[[local tr = util.TraceLine({
		start = data.Src,
		endpos = data.Src + (data.Dir*data.Distance),
		filter = function(ent2) 
			if ghosttraceentities[ent2:GetClass()] then
				return false
			else
				return true
			end 
		end
	})
	
	--PrintTable(tr)
	
	-- If we hit anything, move the source of the bullets up to that point
	if IsValid(tr.Entity) and tr.Fraction < 1 then
		data.Src = tr.HitPos - data.Dir * 5
		return true
	end]]

	if ent:IsPlayer() and ent:HasPerk("dtap2") then return true end
end

-- Ghost invisible walls so nothing but players or NPCs collide with them
local inviswalls = {
	["invis_damage_wall"] = true,
	["invis_wall"] = true,
	["wall_block"] = true,
}
hook.Add("ShouldCollide", "nz_InvisibleBlockFilter", function(ent1, ent2)
	if inviswalls[ent1:GetClass()] then
		return ent2:IsPlayer() or ent2:IsNPC()
	elseif inviswalls[ent2:GetClass()] then
		return ent1:IsPlayer() or ent1:IsNPC()
	end
end)

-- This is so awkward ._.
-- game.AddAmmoType doesn't take duplicates into account and has a hardcoded limit of 128
-- which means our ammo types won't exist if we pass that limit with the countless duplicates :(
local oldaddammo = game.AddAmmoType
local alreadyexist = alreadyexist or {}
function game.AddAmmoType( tbl ) -- Let's prevent that!
	if tbl.name and !alreadyexist[tbl.name] then -- Only if the ammo doesn't already exist!
		oldaddammo(tbl) -- THEN we can proceed with normal procedure!
		alreadyexist[tbl.name] = true
	end
end
-- This doesn't work for lua scripts run before the gamemode, but should help for weapons adding ammo types on-the-fly!
-- This will also prevent some ammo types from being added - that's fine. Our gamemode doesn't need them.
