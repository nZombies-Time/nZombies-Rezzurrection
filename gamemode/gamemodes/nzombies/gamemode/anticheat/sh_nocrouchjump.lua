hook.Add("PlayerSpawn", "ACSaveViewOffsets", function(ply) 
    -- We need to remember these for getting rid of any unusual jittering
    ply.acviewoffset = ply:GetViewOffset()
    ply.accviewoffset = ply:GetViewOffsetDucked()
end)

local nextPrint = 0
local function Notify() 
    if (CLIENT and nextPrint == nil or CLIENT and CurTime() > nextPrint) then
        nextPrint = CurTime() + 30
        print("[NZ] Crouch Jumping has been disabled for this map.")
    end
end

hook.Add("StartCommand", "ACNoCrouchJump", function(ply, ucmd)
    if (nzMapping.Settings.ac and nzMapping.Settings.acpreventcjump and !ply:IsInCreative()) then
        local isDucking = bit.band(ucmd:GetButtons(), IN_DUCK) == IN_DUCK
        local isJumping = bit.band(ucmd:GetButtons(), IN_JUMP) == IN_JUMP
        
        -- Disallow crouching in the air
        if (!ply:OnGround() and isDucking) then 
            ucmd:RemoveKey(IN_DUCK)

            if (CLIENT) then
                Notify()
            end
        end

        -- Disallow crouch jump
        if (isDucking and isJumping) then
            if (CLIENT) then
                Notify()
            end

            ucmd:RemoveKey(IN_JUMP)
            if (!ply.accviewoffset) then return end
            if (SERVER) then
                ply:SetViewOffsetDucked(ply.accviewoffset)
            end
        elseif (SERVER) then
            ply:SetViewOffsetDucked(ply.accviewoffset)
        end
    end
end)