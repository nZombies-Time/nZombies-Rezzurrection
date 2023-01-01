-- -- Part 2 of the Anti-Cheat, made for finding spots that were
-- -- previously thought to have been impossible to detect!
-- ActiveACGhosts = !ActiveACGhosts and {} or ActiveACGhosts -- These fellas well let us know is someone's cheating
-- local PLAYER = FindMetaTable("Player")

-- NZ_AntiCheat_Aggressive = GetConVar("nz_anticheat_aggressive"):GetInt()

-- -- We have this function for performance reasons, wouldn't want these hooks existing when aggressive mode is off
-- local function AddHooks() 
--     if (NZ_AntiCheat_Aggressive < 1) then return end
    
--     hook.Add("PlayerSpawn", "NZAddACEnemy", function(ply)
--         if (!nzMapping.Settings.ac and nzMapping.Settings.ac != nil or NZ_AntiCheat_Aggressive < 1) then return end
--         if (!IsValid(ActiveACGhosts[ply])) then
--             NZNewGhost(ply)
--         end
--     end)

--     local function RemoveGhost(ent)
--         if (!IsValid(ent) || !ent:IsPlayer()) then return end
--         if (!nzMapping.Settings.ac and nzMapping.Settings.ac != nil or NZ_AntiCheat_Aggressive < 1) then return end
--         if (IsValid(ActiveACGhosts[ent])) then
--             ActiveACGhosts[ent]:Remove()
--         end
--     end

--     timer.Destroy("AutoGhostAttach")
--     timer.Create("AutoGhostAttach", 1, 0, function()
--         local amount = 0
--         for k,v in pairs(ActiveACGhosts) do
--             if IsValid(v) then amount = amount + 1 end
--         end

--         if (amount != #player.GetAllPlayingAndAlive()) then
--             for k,v in pairs(ActiveACGhosts) do
--                 if (v:IsValid()) then v:Remove() end
--             end

--             ActiveACGhosts = {}
--             for k,v in pairs(player.GetAllPlayingAndAlive()) do
--                 NZNewGhost(v)
--             end
--         end

--         for k,v in pairs(ActiveACGhosts) do 
--             if IsValid(v) then
--                 v:AttachToClosestZombie()
--             end
--         end
--     end)
    
--     hook.Add("PlayerDeath", "PlyDead", function(ply) 
--         RemoveGhost(ply)
--     end)

--     hook.Add("EntityRemoved", "PlyGone", function(ent)
--         if (!IsValid(ent) || !ent:IsPlayer()) then return end
--         RemoveGhost(ent)
--     end)
-- end
-- AddHooks()

-- if (!cvars.GetConVarCallbacks("nz_anticheat_aggressive") or #cvars.GetConVarCallbacks("nz_anticheat_aggressive") == 0) then
--     cvars.AddChangeCallback("nz_anticheat_aggressive", function()
--         NZ_AntiCheat_Aggressive = GetConVar("nz_anticheat_aggressive"):GetInt()

--         if (NZ_AntiCheat_Aggressive < 1) then 
--             for k,v in pairs(ents.FindByClass("nz_zombie_anticheat")) do
--                 v:Remove()
--             end

--             for k,v in pairs(player.GetAll()) do
--                 v.undetectedSpot = nil -- Just in case they were detected when this convar was disabled
--             end

--             table.Empty(ActiveACGhosts)     
--             hook.Remove("PlayerSpawn", "NZAddACEnemy")
--             hook.Remove("PlayerDeath", "NZRemoveACEnemy")
--             timer.Destroy("AutoGhostAttach")
--         else
--             AddHooks()

--             for k,v in pairs(player.GetAll()) do
--                 NZNewGhost(v)
--             end
--         end
--     end)
-- end

-- function NZNewGhost(ply)
--     if (!IsValid(ActiveACGhosts[ply])) then
--         local acZombie = ents.Create("nz_zombie_anticheat")
--         if IsValid(acZombie) then
--             acZombie:Spawn()
--             acZombie:SetTarget(ply)
--             ActiveACGhosts[ply] = acZombie
--         end
--     end
-- end

-- -- We can use the capabilities of our new Ghost Zombie entity
-- -- to see if a player can really be hurt by zombies or not
-- function PLAYER:CheckIfUnreachable() 
--     if (!nzMapping.Settings.ac and nzMapping.Settings.ac != nil or NZ_AntiCheat_Aggressive < 1) then return end
--     if (!IsValid(ActiveACGhosts[self])) then return end

--     -- Get target's closest zombie_walker:
--     local closestZombie = self:GetClosestZombieTarget()
--     if (closestZombie == nil) then return end -- Round's probably not in progress

--     ActiveACGhosts[self]:AttachTo(closestZombie)
--     ActiveACGhosts[self]:SetTarget(self)
-- end

--  -- Our ghost can't get to the player, even when it's at the closest zombie position possible!
-- function PLAYER:OnTargetOutOfReach()
--     if (!nzMapping.Settings.ac and nzMapping.Settings.ac != nil or NZ_AntiCheat_Aggressive < 1) then return end
--     if (!self:NZPlayerUnreachable()) then
--         self.undetectedSpot = self:GetPos()
--         print("Zombie thinks you're cheating!")
        
--         local function DetectionLoop() -- Keep detecting for as long as they are in this spot
--             timer.Simple(0.2, function()
--                 if (isvector(self.undetectedSpot) and self:NearUndetectedSpot()) then
--                     self:OnCheating() 
--                     DetectionLoop()
--                 end
--             end)
--         end
--         DetectionLoop()
--     end
-- end

-- hook.Add("EntityTakeDamage", "PreventACGhostDeath", function(target, dmg) -- Prevent our Anti-Cheat ghosts from ever taking damage
--     if (target:GetClass() == "nz_zombie_anticheat") then return true end
-- end)
