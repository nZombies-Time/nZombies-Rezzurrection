-- Setup round module
nzRound = nzRound or AddNZModule("Round")

if SERVER then

	nzConfig.RoundData = {}
	nzConfig.RoundData[1] = {
		normalTypes = {
			[nzRound:GetZombieType(nzMapping.Settings.zombietype)] = {
				chance = 100,
			},
		},
	}
	nzConfig.RoundData[2] = {
		normalTypes = {
			[nzRound:GetZombieType(nzMapping.Settings.zombietype)] = {
				chance = 100,
			},
		},
	}
	nzConfig.RoundData[13] = {
		normalTypes = {
			[nzRound:GetZombieType(nzMapping.Settings.zombietype)] = {
				chance = 100,
			},
		},
	}
	nzConfig.RoundData[14] = {
		normalTypes = {
			[nzRound:GetZombieType(nzMapping.Settings.zombietype)] = {
				chance = 100,
			},
		},
	}
	nzConfig.RoundData[23] = {
		normalTypes = {
			[nzRound:GetZombieType(nzMapping.Settings.zombietype)] = {
				chance = 100,
			},
		},
	}

	-- Player Class
	nzConfig.BaseStartingWeapons = {"fas2_glock20"} -- "fas2_p226", "fas2_ots33", "fas2_glock20" "weapon_pistol"
	-- nzConfig.CustomConfigStartingWeps = true -- If this is set to false, the gamemode will avoid using custom weapons in configs

end
