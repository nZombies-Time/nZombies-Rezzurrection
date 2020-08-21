if (SERVER) then
    util.AddNetworkString("nzSounds.PlaySound")
    -- util.AddNetworkString("nzSounds.IsSoundValid")
    -- util.AddNetworkString("nzSounds.SoundExists")

    -- net.Receive("nzSounds.IsSoundValid", function(len, ply)
    --     local sFile = net.ReadString()
    --     net.Start("nzSounds.SoundExists")
    --     net.WriteBool(file.Exists("sound/" .. sFile, "GAME"))
    --     net.Send(ply)
    -- end)
end

nzSounds = {}
nzSounds.Sounds = {}
nzSounds.Sounds.Custom = {}
nzSounds.Sounds.Default = {}
nzSounds.Sounds.Default.RoundStart = "nz/round/round_start.mp3"
nzSounds.Sounds.Default.RoundEnd = "nz/round/round_end.mp3"
nzSounds.Sounds.Default.SpecialRoundStart = "nz/round/special_round_start.wav"
nzSounds.Sounds.Default.SpecialRoundEnd = "nz/round/special_round_end.wav"
nzSounds.Sounds.Default.GameEnd = "nz/round/game_over_4.mp3"
nzSounds.Sounds.Default.Grab = "nz/powerups/power_up_grab.wav"
nzSounds.Sounds.Default.InstaKill = "nz/powerups/insta_kill.mp3"
nzSounds.Sounds.Default.FireSale = "nz/powerups/fire_sale_announcer.wav"
nzSounds.Sounds.Default.DeathMachine = "nz/powerups/deathmachine.mp3"
nzSounds.Sounds.Default.Carpenter = "chron/nz/announcer/powerups/carpenter.wav"
nzSounds.Sounds.Default.Nuke = "chron/nz/announcer/powerups/nuke.wav"
nzSounds.Sounds.Default.DoublePoints = "nz/powerups/double_points.mp3"
nzSounds.Sounds.Default.MaxAmmo = "nz/powerups/max_ammo.mp3"
nzSounds.Sounds.Default.ZombieBlood = "nz/powerups/zombie_blood.wav"
nzSounds.Sounds.Default.Spin = ""
nzSounds.Sounds.Default.Poof = "nz/randombox/poof.wav"
nzSounds.Sounds.Default.Laugh = "nz/randombox/teddy_bear_laugh.wav"
nzSounds.Sounds.Default.Bye = "nz/randombox/Announcer_Teddy_Zombies.wav"
nzSounds.Sounds.Default.Jingle = "nz/randombox/random_box_jingle.wav"
nzSounds.Sounds.Default.Close = "chron/nz/randombox/box_close.mp3"
nzSounds.MainEvents = {"RoundStart", "RoundEnd", "SpecialRoundStart", "SpecialRoundEnd", "GameEnd"}

function nzSounds:RefreshSounds()
    nzSounds.Sounds.Custom.RoundStart = nzMapping.Settings.roundstartsnd
    nzSounds.Sounds.Custom.RoundEnd = nzMapping.Settings.roundendsnd
    nzSounds.Sounds.Custom.SpecialRoundStart = nzMapping.Settings.specialroundstartsnd
    nzSounds.Sounds.Custom.SpecialRoundEnd = nzMapping.Settings.specialroundendsnd
    nzSounds.Sounds.Custom.GameEnd = nzMapping.Settings.gameendsnd
    nzSounds.Sounds.Custom.Grab = nzMapping.Settings.grabsnd
    nzSounds.Sounds.Custom.InstaKill = nzMapping.Settings.instakillsnd
    nzSounds.Sounds.Custom.FireSale = nzMapping.Settings.firesalesnd
    nzSounds.Sounds.Custom.DeathMachine = nzMapping.Settings.deathmachinesnd
    nzSounds.Sounds.Custom.Carpenter = nzMapping.Settings.carpentersnd
    nzSounds.Sounds.Custom.Nuke = nzMapping.Settings.nukesnd
    nzSounds.Sounds.Custom.DoublePoints = nzMapping.Settings.doublepointssnd
    nzSounds.Sounds.Custom.MaxAmmo = nzMapping.Settings.maxammosnd
    nzSounds.Sounds.Custom.ZombieBlood = nzMapping.Settings.zombiebloodsnd
    nzSounds.Sounds.Custom.Spin = nzMapping.Settings.boxspinsnd
    nzSounds.Sounds.Custom.Poof = nzMapping.Settings.boxpoofsnd
    nzSounds.Sounds.Custom.Laugh = nzMapping.Settings.boxlaughsnd
    nzSounds.Sounds.Custom.Bye = nzMapping.Settings.boxbyesnd
    nzSounds.Sounds.Custom.Jingle = nzMapping.Settings.boxjinglesnd
    nzSounds.Sounds.Custom.Close = nzMapping.Settings.boxclosesnd
end 
nzSounds:RefreshSounds()

function nzSounds:GetSound(event)
    local snd = !nzSounds.Sounds.Custom[event] || table.IsEmpty(nzSounds.Sounds.Custom[event]) and nzSounds.Sounds.Default[event] or nzSounds.Sounds.Custom[event]
    
    if (istable(snd)) then
        snd = table.Random(snd) -- ^ is a table of sounds, but we can only play 1
    end

    return snd
end

function nzSounds:GetDefaultSound(event)
    return nzSounds.Sounds.Default[event]
end

function nzSounds:Play(event, ply)
    local snd = nzSounds:GetSound(event)
    
    if (SERVER) then
        if (!nzSounds.Sounds.Default[event]) then 
            if (isstring(event)) then
                ServerLog("[nZombies] Tried to play an invalid Sound Event! (" .. event .. ")\n")
            else
                ServerLog("[nZombies] Tried to play an invalid Sound Event!\n")
            end
        return end

        if (!file.Exists("sound/" .. snd, "GAME")) then
            ServerLog("[nZombies] Tried to play an invalid sound file (" .. snd .. ") for Event: " .. event .. "\n")
        end

        net.Start("nzSounds.PlaySound")
        net.WriteString(event)
        if !ply then
            net.Broadcast()
        else 
            net.Send(ply)
        end
    end

    if (CLIENT) then
        if (!nzSounds.Sounds.Default[event]) then 
            if (isstring(event)) then
                print("[nZombies] Tried to play an invalid Sound Event! (" .. event .. ")")
            else
                print("[nZombies] Tried to play an invalid Sound Event!")
            end
        return end  

        if (istable(snd)) then
            snd = table.Random(snd)
        end

        if (!snd || !file.Exists("sound/" .. snd, "GAME")) then
            print("[nZombies] Tried to play a sound file you don't have! (" .. snd .. ") for Event: " .. event)
            snd = nzSounds:GetDefaultSound(event)
        end
        
        if (string.find(event, "Round") || event == "GameEnd") then -- Stop all main event sounds for this one
            for k,v in pairs(nzSounds.MainEvents) do
                nzSounds:Stop(v)
            end
        else
            nzSounds:Stop(event)
        end

        surface.PlaySound(snd)
    end
end

if (CLIENT) then
    function nzSounds:Stop(event) -- Stops all sounds bound to an event
        local snds = !nzSounds.Sounds.Custom[event] or table.IsEmpty(nzSounds.Sounds.Custom[event]) and nzSounds.Sounds.Default[event] or nzSounds.Sounds.Custom[event]

        if (istable(snds)) then
            for k,v in pairs(snds) do
                v = !file.Exists("sound/" .. v, "GAME") and nzSounds.Sounds.Default[event] or v
                LocalPlayer():StopSound(v)
            end
        else
            LocalPlayer():StopSound(snds)
        end
    end

    net.Receive("nzSounds.PlaySound", function()
        local event = net.ReadString()
        nzSounds:Play(event, nil)
    end)
end