-- Garry's Mod has NO IsJumping() function
-- so this needs to be done..
local PLAYER = FindMetaTable("Player")
AccessorFunc(PLAYER, "bIsJumping", "IsJumping", FORCE_BOOL)

hook.Add("DoAnimationEvent", "IsJumpingHook", function(ply, event)
    if (event == PLAYERANIMEVENT_JUMP) then
        ply:SetIsJumping(true)
        timer.Simple(0.6, function()
            if !IsValid(ply) then return end
            ply:SetIsJumping(false)
        end)
    end
end)