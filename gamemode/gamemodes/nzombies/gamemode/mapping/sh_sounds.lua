if (SERVER) then
    util.AddNetworkString("nzSounds.PlaySound")
    util.AddNetworkString("nzSounds.RefreshSounds")

    hook.Add("PlayerSpawn", "NZForceSyncSounds", function(ply)
        net.Start("nzSounds.RefreshSounds")
        net.Send(ply)
    end)
end

nzSounds = {}
nzSounds.struct = { -- For use with 'data' when creating config menu options
    "roundstartsnd", "roundendsnd", "specialroundstartsnd", "specialroundendsnd", "dogroundsnd", "gameendsnd", -- main event sounds
    "spawnsnd", "grabsnd", "instakillsnd", "firesalesnd", "deathmachinesnd", "carpentersnd", "nukesnd", "doublepointssnd", "maxammosnd", "zombiebloodsnd", -- power up sounds
    "boxshakesnd", "boxpoofsnd", "boxlaughsnd", "boxbyesnd", "boxjinglesnd", "boxopensnd", "boxclosesnd" -- mystery box sounds
}

nzSounds.Sounds = {}
nzSounds.Sounds.Custom = {}
nzSounds.Sounds.Default = {}
nzSounds.Sounds.Default.RoundStart = "nz/round/round_start.mp3"
nzSounds.Sounds.Default.RoundEnd = "nz/round/round_end.mp3"
nzSounds.Sounds.Default.SpecialRoundStart = "nz/round/special_round_start.wav"
nzSounds.Sounds.Default.SpecialRoundEnd = "nz/round/special_round_end.wav"
nzSounds.Sounds.Default.DogRound = "nz/round/dog_start.wav"
nzSounds.Sounds.Default.GameEnd = "nz/round/game_over_4.mp3"
nzSounds.Sounds.Default.Spawn = "nz/powerups/power_up_spawn.wav"
nzSounds.Sounds.Default.Grab = "nz/powerups/power_up_grab.wav"
nzSounds.Sounds.Default.InstaKill = "nz/powerups/insta_kill.mp3"
nzSounds.Sounds.Default.FireSale = "nz/powerups/fire_sale_announcer.wav"
nzSounds.Sounds.Default.DeathMachine = "nz/powerups/deathmachine.mp3"
nzSounds.Sounds.Default.Carpenter = "nz/powerups/carpenter.wav"
nzSounds.Sounds.Default.Nuke = "nz/powerups/nuke.wav"
nzSounds.Sounds.Default.DoublePoints = "nz/powerups/double_points.mp3"
nzSounds.Sounds.Default.MaxAmmo = "nz/powerups/max_ammo.mp3"
nzSounds.Sounds.Default.ZombieBlood = "nz/powerups/zombie_blood.wav"
nzSounds.Sounds.Default.Shake = "nzr/announcer/mysterybox/box_spinning.wav"
nzSounds.Sounds.Default.Poof = "nz/randombox/poof.wav"
nzSounds.Sounds.Default.Laugh = "nz/randombox/teddy_bear_laugh.wav"
nzSounds.Sounds.Default.Bye = "nz/randombox/Announcer_Teddy_Zombies.wav"
nzSounds.Sounds.Default.Jingle = "nz/randombox/random_box_jingle.wav"
nzSounds.Sounds.Default.Open = "nzr/announcer/mysterybox/box_open.mp3"
nzSounds.Sounds.Default.Close = "nzr/announcer/mysterybox/box_close.mp3"
--nzSounds.MainEvents = {"RoundStart", "RoundEnd", "SpecialRoundStart", "SpecialRoundEnd", "GameEnd", "DogRound"}

function nzSounds:RefreshSounds()
    nzSounds.Sounds.Custom.RoundStart = nzMapping.Settings.roundstartsnd
    nzSounds.Sounds.Custom.RoundEnd = nzMapping.Settings.roundendsnd
    nzSounds.Sounds.Custom.SpecialRoundStart = nzMapping.Settings.specialroundstartsnd
    nzSounds.Sounds.Custom.SpecialRoundEnd = nzMapping.Settings.specialroundendsnd
    nzSounds.Sounds.Custom.DogRound = nzMapping.Settings.dogroundsnd
    nzSounds.Sounds.Custom.GameEnd = nzMapping.Settings.gameendsnd
    nzSounds.Sounds.Custom.Spawn = nzMapping.Settings.spawnsnd
    nzSounds.Sounds.Custom.Grab = nzMapping.Settings.grabsnd
    nzSounds.Sounds.Custom.InstaKill = nzMapping.Settings.instakillsnd
    nzSounds.Sounds.Custom.FireSale = nzMapping.Settings.firesalesnd
    nzSounds.Sounds.Custom.DeathMachine = nzMapping.Settings.deathmachinesnd
    nzSounds.Sounds.Custom.Carpenter = nzMapping.Settings.carpentersnd
    nzSounds.Sounds.Custom.Nuke = nzMapping.Settings.nukesnd
    nzSounds.Sounds.Custom.DoublePoints = nzMapping.Settings.doublepointssnd
    nzSounds.Sounds.Custom.MaxAmmo = nzMapping.Settings.maxammosnd
    nzSounds.Sounds.Custom.ZombieBlood = nzMapping.Settings.zombiebloodsnd
    nzSounds.Sounds.Custom.Shake = nzMapping.Settings.boxshakesnd
    nzSounds.Sounds.Custom.Poof = nzMapping.Settings.boxpoofsnd
    nzSounds.Sounds.Custom.Laugh = nzMapping.Settings.boxlaughsnd
    nzSounds.Sounds.Custom.Bye = nzMapping.Settings.boxbyesnd
    nzSounds.Sounds.Custom.Jingle = nzMapping.Settings.boxjinglesnd
    nzSounds.Sounds.Custom.Open = nzMapping.Settings.boxopensnd
    nzSounds.Sounds.Custom.Close = nzMapping.Settings.boxclosesnd
    if (!table.IsEmpty(nzMapping.Settings) and table.IsEmpty(nzSounds.Sounds.Custom)) then
        nzSounds.Sounds.Custom = table.Copy(nzSounds.Sounds.Default)
    end
    
    if (SERVER) then
        net.Start("nzSounds.RefreshSounds")
        net.Broadcast()
    end
end 
nzSounds:RefreshSounds()

function nzSounds:GetSound(event)
    local snd = !nzSounds.Sounds.Custom[event] and nzSounds.Sounds.Default[event] or nzSounds.Sounds.Custom[event]

    if (istable(snd)) then
        snd = table.Random(snd) -- ^ is a table of sounds, but we can only play 1
    end

    if (SERVER) then
        if (!nzSounds.Sounds.Default[event]) then 
            if (isstring(event)) then
                ServerLog("[nZombies] Tried to play an invalid Sound Event! (" .. event .. ")\n")
            else
                ServerLog("[nZombies] Tried to play an invalid Sound Event!\n")
            end

            snd = nzSounds:GetDefaultSound(event)
        end

        if snd == nil then return nzSounds:GetDefaultSound(event) end
        -- if (!file.Exists("sound/" .. snd, "GAME")) then
        --     ServerLog("[nZombies] Tried to play an invalid sound file (" .. snd .. ") for Event: " .. event .. "\n")
        -- end
    end

    if (CLIENT) then
        -- FALLBACK in case for some reason the client has not gotten their sounds to refresh yet
        if (nzSounds and nzSounds.Sounds and table.IsEmpty(nzSounds.Sounds.Custom)) then    
            if (!table.IsEmpty(nzMapping.Settings)) then -- Stops endless loop from non-submitted configs
                nzSounds:RefreshSounds()
                snd = nzSounds:GetSound(event)
            end
        end

        if (snd == nil or !nzSounds.Sounds.Default[event]) then 
            if (!nzSounds.Sounds.Default[event]) then
                if (isstring(event)) then
                    print("[nZombies] Tried to play an invalid Sound Event! (" .. event .. ")")
                else
                    print("[nZombies] Tried to play an invalid Sound Event!")
                end
            end 

            snd = nzSounds:GetDefaultSound(event)
        end  

        if snd == nil then return end

        if (snd and !file.Exists("sound/" .. snd, "GAME")) then
            print("[nZombies] Tried to play a sound file you don't have! (" .. snd .. ") for Event: " .. event)
            snd = nzSounds:GetDefaultSound(event)
        end
    end

    return snd
end

function nzSounds:GetDefaultSound(event)
    return nzSounds.Sounds.Default[event]
end

function nzSounds:PlayEnt(event, ent, noOverlap) -- Plays on an entity (and must be close to actually hear it)
    local snd = nzSounds:GetSound(event)
    if (snd == nil || !isstring(snd)) then return end

    if (IsValid(ent)) then
        if (noOverlap) then
            ent:StopSound(snd)
        end

        ent:EmitSound(snd)
    end
end

function nzSounds:Play(event, ply) -- Plays everywhere either for 1 or all players
    local snd = nzSounds:GetSound(event)
    if (snd == nil || !isstring(snd)) then return end

    if (SERVER) then
        net.Start("nzSounds.PlaySound")
        net.WriteString(event)
        if !ply then
            net.Broadcast()
        else 
            net.Send(ply)
        end
    end

    if (CLIENT) then
        if (event == "GameEnd") then
            nzSounds:StopAll()
        else
            nzSounds:Stop(event)
        end

        surface.PlaySound(snd)
    end
end

if (CLIENT) then
    function nzSounds:Stop(event) -- Stops all sounds bound to an event
        if (!IsValid(LocalPlayer())) then return end -- The client has not fully loaded yet, LocalPlayer() does not exist.
        
        local notValid = !nzSounds.Sounds.Custom[event] or table.IsEmpty(nzSounds.Sounds.Custom)
        local snds = notValid and nzSounds.Sounds.Default[event] or nzSounds.Sounds.Custom[event]

        if (istable(snds)) then
            for k,v in pairs(snds) do
                v = !file.Exists("sound/" .. v, "GAME") and nzSounds.Sounds.Default[event] or v
                LocalPlayer():StopSound(v)
            end
        else
            LocalPlayer():StopSound(snds)
        end
    end

    function nzSounds:StopAll() -- Stops ALL event sounds
        for k,v in pairs(nzSounds.Sounds.Default) do
            nzSounds:Stop(k)
        end
    end

    net.Receive("nzSounds.PlaySound", function()
        local event = net.ReadString()
        nzSounds:Play(event, nil)
    end)

    net.Receive("nzSounds.RefreshSounds", function()
        nzSounds:RefreshSounds()  
        nzSounds:StopAll()
    end)

    hook.Add("InitPostEntity", "NZSyncCustomSounds", function()
        timer.Simple(2, function()
            nzSounds:RefreshSounds()  
        end)
    end)
end
