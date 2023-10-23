-- Setup round module
nzRound = nzRound or AddNZModule("Round")

if SERVER then

   

        nzConfig.RoundData = {}
		local comedyday = os.date("%d-%m") == "01-04"

		
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
		
       -- PrintTable(nzConfig.RoundData)

    hook.Add("PostGamemodeLoaded", "nInitializeZombieTypes", function() InitZombieTypes() end)
end
