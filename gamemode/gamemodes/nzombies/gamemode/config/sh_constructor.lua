-- Main Tables
nzConfig = nzConfig or AddNZModule("Config")

--  Defaults

if not ConVarExists("nz_randombox_whitelist") then CreateConVar("nz_randombox_whitelist", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}) end
if not ConVarExists("nz_downtime") then CreateConVar("nz_downtime", 45, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}) end
if not ConVarExists("nz_nav_grouptargeting") then CreateConVar("nz_nav_grouptargeting", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}) end
if not ConVarExists("nz_round_special_interval") then CreateConVar("nz_round_special_interval", 6, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}) end
if not ConVarExists("nz_round_prep_time") then CreateConVar("nz_round_prep_time", 10, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}) end
if not ConVarExists("nz_randombox_maplist") then CreateConVar("nz_randombox_maplist", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}) end
if not ConVarExists("nz_round_dropins_allow") then CreateConVar("nz_round_dropins_allow", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}) end
if not ConVarExists("nz_difficulty_zombie_amount_base") then CreateConVar("nz_difficulty_zombie_amount_base", 6, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}) end
if not ConVarExists("nz_difficulty_zombie_amount_scale") then CreateConVar("nz_difficulty_zombie_amount_scale", 0.35, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}) end
if not ConVarExists("nz_difficulty_zombie_health_base") then CreateConVar("nz_difficulty_zombie_health_base", 75, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}) end
if not ConVarExists("nz_difficulty_zombie_health_scale") then CreateConVar("nz_difficulty_zombie_health_scale", 1.1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}) end
 -- Modified in configs now:
--if not ConVarExists("nz_difficulty_max_zombies_alive") then CreateConVar("nz_difficulty_max_zombies_alive", 35, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}) end
if not ConVarExists("nz_difficulty_barricade_planks_max") then CreateConVar("nz_difficulty_barricade_planks_max", 6, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}) end
if not ConVarExists("nz_difficulty_powerup_chance") then CreateConVar("nz_difficulty_powerup_chance", 2, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}) end
if not ConVarExists("nz_difficulty_perks_max") then CreateConVar("nz_difficulty_perks_max", 4, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}) end
if not ConVarExists("nz_point_notification_clientside") then CreateConVar("nz_point_notification_clientside", 0, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED}) end
if not ConVarExists("nz_zombie_lagcompensated") then CreateConVar("nz_zombie_lagcompensated", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}) end
if not ConVarExists("nz_spawnpoint_update_rate") then CreateConVar("nz_spawnpoint_update_rate", 4, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}) end
if not ConVarExists("nz_rtv_time") then CreateConVar("nz_rtv_time", 45, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}) end
if not ConVarExists("nz_rtv_enabled") then CreateConVar("nz_rtv_enabled", 0, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}) end

-- Zombie table - Moved to shared area for client collision prediction (barricades)
nzConfig.ValidEnemies = {
	["nz_zombie_walker"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_walker_five"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
		["nz_zombie_walker_hazmat"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_walker_motd"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_walker_buried"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_walker_moon"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_walker_moon_guard"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_walker_moon_tech"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_walker_eisendrache"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_walker_origins"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	
	["nz_zombie_walker_origins_soldier"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_walker_origins_templar"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_walker_shangrila"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_walker_sumpf"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_walker_ascension"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_walker_cotd"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_walker_nuketown"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_walker_clown"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_walker_greenrun"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_walker_deathtrooper"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
		["nz_zombie_walker_ascension_classic"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
			["nz_zombie_walker_diemachine"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
				["nz_zombie_walker_orange"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
				["nz_zombie_walker_derriese"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
				["nz_zombie_walker_moon_classic"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
				["nz_zombie_walker_kino"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_walker_skeleton"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_walker_gorodkrovi"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_walker_soemale"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_walker_zetsubou"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_walker_anchovy"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_walker_necromorph"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_walker_xeno"] = {
		-- Set to false to disable the spawning of this zombie
		Valid = true,
		-- Allow you to scale damage on a per-hitgroup basis
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			-- Headshots for double damage
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		-- Function runs whenever the zombie is damaged (NOT when killed)
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			-- If player is playing and is not downed, give points
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		-- Function is run whenever the zombie is killed
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_special_burning"] = {
		Valid = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_special_burning_ascension"] = {
		Valid = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_special_burning_buried"] = {
		Valid = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_special_burning_clown"] = {
		Valid = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_special_bomba"] = {
		Valid = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_special_roach"] = {
		Valid = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_special_bot"] = {
		Valid = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			--if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				--if dmginfo:GetDamageType() == DMG_CLUB then
					--attacker:GivePoints(130)
				--elseif hitgroup == HITGROUP_HEAD then
					--attacker:GivePoints(100)
				--else
					attacker:GivePoints(50)
				--end
			end
		end
	},
	["nz_zombie_special_burning_cotd"] = {
		Valid = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_special_burning_eisendrache"] = {
		Valid = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_special_burning_five"] = {
		Valid = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_special_burning_gorodkrovi"] = {
		Valid = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_special_burning_greenrun"] = {
		Valid = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_special_burning_hazmat"] = {
		Valid = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_special_burning_moon"] = {
		Valid = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_special_burning_motd"] = {
		Valid = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_special_burning_nuketown"] = {
		Valid = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_special_burning_origins"] = {
		Valid = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
		["nz_zombie_special_burning_shangrila"] = {
		Valid = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
		["nz_zombie_special_burning_skeleton"] = {
		Valid = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
		["nz_zombie_special_burning_soe"] = {
		Valid = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
		["nz_zombie_special_burning_sumpf"] = {
		Valid = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
		["nz_zombie_special_burning_templar"] = {
		Valid = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
		["nz_zombie_special_burning_zetsubou"] = {
		Valid = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_special_keeper"] = {
		Valid = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_special_nova"] = {
		Valid = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_special_nova_bomber"] = {
		Valid = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_special_nova_electric"] = {
		Valid = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_special_dog"] = {
		Valid = true,
		SpecialSpawn = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_special_raptor"] = {
		Valid = true,
		SpecialSpawn = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_special_facehugger"] = {
		Valid = true,
		SpecialSpawn = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
	["nz_zombie_special_chestburster"] = {
		Valid = true,
		SpecialSpawn = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
		["nz_zombie_special_licker"] = {
		Valid = true,
		SpecialSpawn = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
		["nz_zombie_special_pack"] = {
		Valid = true,
		SpecialSpawn = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
			if hitgroup == HITGROUP_HEAD then dmginfo:ScaleDamage(1) end
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
		["nz_zombie_special_spooder"] = {
		Valid = true,
		SpecialSpawn = true,
		ScaleDMG = function(zombie, hitgroup, dmginfo)
		end,
		OnHit = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				attacker:GivePoints(10)
			end
		end,
		OnKilled = function(zombie, dmginfo, hitgroup)
			local attacker = dmginfo:GetAttacker()
			if attacker:IsPlayer() and attacker:GetNotDowned() then
				if dmginfo:GetDamageType() == DMG_CLUB then
					attacker:GivePoints(130)
				elseif hitgroup == HITGROUP_HEAD then
					attacker:GivePoints(100)
				else
					attacker:GivePoints(50)
				end
			end
		end
	},
}

-- Random Box

nzConfig.WeaponBlackList = {}
function nzConfig.AddWeaponToBlacklist( class, remove )
	nzConfig.WeaponBlackList[class] = remove and nil or true
end

nzConfig.AddWeaponToBlacklist( "weapon_base" )
nzConfig.AddWeaponToBlacklist( "weapon_fists" )
nzConfig.AddWeaponToBlacklist( "weapon_flechettegun" )
nzConfig.AddWeaponToBlacklist( "weapon_medkit" )
nzConfig.AddWeaponToBlacklist( "weapon_dod_sim_base" )
nzConfig.AddWeaponToBlacklist( "weapon_dod_sim_base_shot" )
nzConfig.AddWeaponToBlacklist( "weapon_dod_sim_base_snip" )
nzConfig.AddWeaponToBlacklist( "weapon_sim_admin" )
nzConfig.AddWeaponToBlacklist( "weapon_sim_spade" )
nzConfig.AddWeaponToBlacklist( "fas2_base" )
nzConfig.AddWeaponToBlacklist( "fas2_ammobox" )
nzConfig.AddWeaponToBlacklist( "fas2_ifak" )
nzConfig.AddWeaponToBlacklist( "nz_multi_tool" )
nzConfig.AddWeaponToBlacklist( "nz_grenade" )
nzConfig.AddWeaponToBlacklist( "nz_perk_bottle" )
nzConfig.AddWeaponToBlacklist( "nz_quickknife_crowbar" )
nzConfig.AddWeaponToBlacklist( "nz_knife_butterfly" )
nzConfig.AddWeaponToBlacklist( "nz_knife_boring" )
nzConfig.AddWeaponToBlacklist( "nz_knife_lukewarmconflict" )
nzConfig.AddWeaponToBlacklist( "nz_knife_wrench" )
nzConfig.AddWeaponToBlacklist( "nz_tool_base" )
nzConfig.AddWeaponToBlacklist( "nz_one_inch_punch" ) -- Nope! You gotta give this with special map scripts

nzConfig.AddWeaponToBlacklist( "cw_base" )

nzConfig.WeaponWhiteList = {
	"fas2_", "m9k_", "tfa_",
}


