util.AddNetworkString("AntiCheatWarning")

local PLAYER = FindMetaTable("Player")
local excludedClasses = { -- These are entities players can "cheat" on (They can cheat on parented props regardless)
    "func_tracktrain",
    "func_tanktrain",
    "func_trackchange",
    "func_movelinear",
    "func_brush",
    "func_door"
} 

function PLAYER:ACSavePoint() -- Save the last position they were not cheating at for Anti-Cheat teleports
    if (NZ_AntiCheat_Enabled < 1) then return end
    if (NZ_AntiCheat_Save_Spots == 0) then return end -- Only allow save positions if ConVar allows it
    
    if (self.allowsavespot == nil) then 
        self.allowsavespot = true 
    end

    if (self.allowsavespot and self.saveDelay == nil or CurTime() > self.saveDelay and self.allowsavespot) then
        self.saveDelay = CurTime() + (NZ_AntiCheat_Delay + 0.5) -- Optimization, don't need to save positions every tick

        local navarea = navmesh.GetNavArea(self:GetPos(), 75)   
        if (!navarea || !IsValid(navarea)) then return end
        if (navarea:GetSizeX() >= 113 && navarea:GetSizeY() >= 113) then -- Player is on a big nav mesh
            if (#navmesh.Find(self:GetPos(), 250, 1, 1) >= 6) then -- Plenty of meshes near them
                self.noncheatspot = self:GetPos()
                self.oldangles = self:EyeAngles()
            end
        end
    end
end

function PLAYER:WarnToMove() -- Give the player a chance to move before being teleported to spawn
    if (NZ_AntiCheat_Enabled < 1) then return end
    if self.allowtp then -- They had their chance to get back in the map
        self:NZMoveCheater() 
    return end 

    if self.warning then return end -- They still have time to move
    self.warning = true
    
    net.Start("AntiCheatWarning")
    net.Send(self)

    local warnedPos = self:GetPos() -- Where they were when they were warned
    
    local secs = 5
    if (GetConVar("nz_anticheat_tp_time")) then secs = GetConVar("nz_anticheat_tp_time"):GetInt() end
    timer.Simple(secs, function()
        if !IsValid(self) || !self:Alive() || !self:GetNotDowned() then return end
        if self:NZPlayerUnreachable() then -- They are still cheating, teleport them
            self:NZMoveCheater() -- We've given them a chance to move
        end

        self.allowtp = true
        self.warning = false

        timer.Simple(15, function() -- Give the Anti-Cheat enough time to detect them again
            if !IsValid(self) then return end
            self.allowtp = false
            self.allowsavespot = true
        end)
    end)

    print("[NZ Anti-Cheat] Warning " .. self:Nick() .. " to move..")
end

function PLAYER:CanBeCheater()
    if self:InVehicle() then return false end -- Very unlikely but you are in the plane on MOTD
    if self:GetNWBool("in_afterlife") then return false end -- Doesn't matter with Afterlife, they can't stay forever
    if self:Health() < 100 or !self:GetNotDowned() then return false end -- If they are hurt or down then it doesn't matter if they are cheating
    if self:GetMoveType() != MOVETYPE_WALK or !self:IsOnGround() then return false end -- Only tp them if they are on the floor and can walk
    return true
end

function PLAYER:NZPlayerUnreachable()
    if !self:CanBeCheater() then return false end

    local startPos = self:GetPos() - Vector(0, 0, 0)
    local endPos = self:GetPos() - Vector(0, 0, 16384)
    local Maxs = Vector(self:OBBMaxs().X / self:GetModelScale(), self:OBBMaxs().Y / self:GetModelScale(), self:OBBMaxs().Z / self:GetModelScale()) 
    local Mins = Vector(self:OBBMins().X / self:GetModelScale(), self:OBBMins().Y / self:GetModelScale(), self:OBBMins().Z / self:GetModelScale())
    
    local tr = util.TraceHull({
        start = startPos,
        endpos = endPos,
        maxs = Maxs,
        mins = Mins,
        collisiongroup = COLLISION_GROUP_PLAYER,
        filter = function(ent) return !ent:IsPlayer() end
    })
   
    if tr.Hit and !table.HasValue(excludedClasses, tr.Entity:GetClass()) then -- If it hit something that can't move
        if !IsValid(tr.Entity:GetParent()) then -- Parented entities typically have the ability to move, don't tp people on them
            local hitPos = tr.HitPos
            local navnear = navmesh.GetNearestNavArea(self:GetPos(), false, 75, false, true)
            if !IsValid(navnear) then return true end -- No nav mesh close enough
        end
    end

    self:ACSavePoint() -- They are not cheating, try to save their location as an Anti-Cheat teleport point
    return false
end

function PLAYER:NZNotifyCheat(msg) -- Sends a message to victims of the NZ Anti-Cheat
    if !self.NZACNotified and !self.warning then
        self.NZACNotified = true

        self:ChatPrint(msg)
        timer.Simple(5, function() self.NZACNotified = false end)
    end
end

function PLAYER:NZMoveCheater() -- Teleports them out of the cheat spot
    if (NZ_AntiCheat_Enabled < 1) then return end
    hook.Call("NZAntiCheatMovedPlayer", nil, self)

    if !self.Teleporting then
        self.Teleporting = true

        local navmeshDist = nil
        local navPos = nil
        
        timer.Simple(0.1, function()
            if (self.noncheatspot != nil and self.lastTPspot == nil or self.noncheatspot != nil and self.lastTPspot != nil and self.noncheatspot:Distance(self.lastTPspot) > 150) then -- Make sure they aren't being teleported where they last teleported at     
                self:SetPos(self.noncheatspot) -- Tp to their last non-cheat spot
                self.lastTPspot = self.noncheatspot

                if (self.oldangles != nil) then self:SetEyeAngles(self.oldangles) end
            else -- No last spot saved one of these teleports:
                if !IsValid(self) then return end

                if (#player.GetAllPlayingAndAlive() > 1) then -- To the other player
                    for k,v in pairs(player.GetAllPlayingAndAlive()) do
                        if v != self then 
                            self:SetPos(v:GetPos())
                        end
                    end
                else
                    -- To spawn:
                    local class = "player_spawns"
                    if (#ents.FindByClass("player_spawns") == 0) then class = "info_player_start" end
                    
                    local destent = ents.FindByClass(class)[1]
                    if (IsValid(destent)) then
                        self:SetPos(destent:GetPos())
                    else
                        return -- Don't give them Zombie's Blood if they can't be teleported
                    end              
                end

                nzPowerUps:SpawnPowerUp(self:GetPos(), "zombieblood") -- They are going to be tp'd far away, don't let them die by a crowd
            end

            self.allowsavespot = true
        end)

        ServerLog("[NZ Anti-Cheat] " .. self:Nick() .. " was caught cheating!\n")
        PrintMessage(HUD_PRINTTALK, "[NZ] " .. self:Nick() .. " was teleported by the Anti-Cheat.")
        timer.Simple(5, function() self.Teleporting = false end)
    end
end

hook.Add("PlayerTick", "NZAntiCheat", function(ply) -- Scan for players who are cheating
    if (NZ_AntiCheat_Enabled < 1) then return end
    
    if (waittime == nil or CurTime() > waittime) then 
        if (NZ_AntiCheat_Delay != nil) then 
            if NZ_AntiCheat_Delay <= 5.0 then
                waittime = CurTime() + NZ_AntiCheat_Delay
            else
                waittime = CurTime() + 5.0
            end
        else
            waittime = CurTime()
        end

        if ply:NZPlayerUnreachable() then 
            ply.allowsavespot = false -- Prevents possibly adding a save point outside the map for cheaters (just until the warning time resets)
            ply:WarnToMove() 
        end
    end
end)