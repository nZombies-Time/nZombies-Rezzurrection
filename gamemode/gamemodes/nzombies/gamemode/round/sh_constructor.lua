-- Setup round module
nzRound = nzRound or AddNZModule("Round")

if SERVER then

    function InitZombieTypes()

        nzConfig.RoundData = {}
		local comedyday = os.date("%d-%m") == "01-04"
		if comedyday then
		
		 nzConfig.RoundData[1] = {
            normalTypes = {
                ["nz_zombie_walker_anchovy"] = {
                    chance = 100,
                },
            },
        }
        nzConfig.RoundData[2] = {
            normalTypes = {
                ["nz_zombie_walker_anchovy"] = {
                    chance = 100,
                },
            },
        }
        nzConfig.RoundData[13] = {
            normalTypes = {
                ["nz_zombie_walker_anchovy"] = {
                    chance = 100,
                },
            },
        }
        nzConfig.RoundData[14] = {
            normalTypes = {
                ["nz_zombie_walker_anchovy"] = {
                    chance = 100,
                },
            },
        }
        nzConfig.RoundData[23] = {
            normalTypes = {
                ["nz_zombie_walker_anchovy"] = {
                    chance = 100,
                },
            },
        }

		else
		
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
		end
       -- PrintTable(nzConfig.RoundData)
    end

    hook.Add("PostGamemodeLoaded", "nInitializeZombieTypes", function() InitZombieTypes() end)
end
