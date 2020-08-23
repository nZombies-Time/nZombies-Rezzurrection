CreateConVar("nz_anticheat_delay", 0.0, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, 
"The additional time to a server tick (0.1 would be 100ms) to scan for cheaters.")

-- CreateConVar("nz_anticheat_aggressive", 0, {FCVAR_SERVER_CAN_EXECUTE, FCVAR_REPLICATED, FCVAR_ARCHIVE, FCVAR_NOTIFY}, 
-- "Whether or not the Anti-Cheat should add zombie AI to detection (This can cause false positives!)")