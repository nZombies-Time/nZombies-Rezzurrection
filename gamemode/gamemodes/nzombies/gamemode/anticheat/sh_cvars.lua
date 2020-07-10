CreateConVar("nz_anticheat_delay", 0.0, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE}, 
"The time (0.1 would be 100ms) to scan for cheaters.")

CreateConVar("nz_anticheat_warning", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE}, 
"Warns players to move before they are teleported.")

CreateConVar("nz_anticheat_tp_time", 5, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}, 
"Time (in seconds) for a player to be teleported out.")

CreateConVar("nz_anticheat_save_spots", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}, 
"If on, the Anti-Cheat will constantly save player positions as TP spots.")

if (SERVER) then
    CreateConVar("nz_anticheat_enabled", 1, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_ARCHIVE, FCVAR_REPLICATED, FCVAR_NOTIFY}, 
    "Enables/disables the nZombies Anti-Cheat.")

    -- Better for performance when info is needed 24/7:
    NZ_AntiCheat_Enabled = GetConVar("nz_anticheat_enabled"):GetInt()
    NZ_AntiCheat_Delay = GetConVar("nz_anticheat_delay"):GetFloat()
    NZ_AntiCheat_Save_Spots = GetConVar("nz_anticheat_save_spots"):GetInt()

    local function callbackExists(cvarName)
        local val = cvars.GetConVarCallbacks(cvarName)
        return val and #val > 0
    end

    if (!callbackExists("nz_anticheat_enabled")) then
        cvars.AddChangeCallback("nz_anticheat_enabled", function(cvar, oldVal, newVal)
            NZ_AntiCheat_Enabled = GetConVar("nz_anticheat_enabled"):GetInt()

            if (tonumber(newVal) > 0) then 
                print("[NZ] Anti-Cheat Enabled.") 
            else
                print("[NZ] Anti-Cheat Disabled.") 
            end
        end)
    end

    if (!callbackExists("nz_anticheat_delay")) then
        cvars.AddChangeCallback("nz_anticheat_delay", function()
            NZ_AntiCheat_Delay = GetConVar("nz_anticheat_delay"):GetInt()
        end)
    end

    if (!callbackExists("nz_anticheat_save_spots")) then
        cvars.AddChangeCallback("nz_anticheat_save_spots", function(cvar, oldVal, newVal)
            NZ_AntiCheat_Save_Spots = GetConVar("nz_anticheat_save_spots"):GetInt()

            -- If we're not saving player spots, we should delete any currently saved:
            if (tonumber(newVal) <= 0) then
                for k,v in pairs(player.GetAll()) do
                    v.noncheatspot = nil
                    v.oldangles = nil
                end
            end
        end)
    end
end