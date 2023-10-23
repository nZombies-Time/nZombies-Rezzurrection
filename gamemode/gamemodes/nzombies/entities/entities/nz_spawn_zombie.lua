AddCSLuaFile( )
 
ENT.Type = "anim"
ENT.Base = "base_entity"
 
ENT.PrintName       = "nz_spawn_zombie"
 
AccessorFunc(ENT, "iSpawnWeight", "SpawnWeight", FORCE_NUMBER)
AccessorFunc(ENT, "tZombieData", "ZombieData")
AccessorFunc(ENT, "iZombiesToSpawn", "ZombiesToSpawn", FORCE_NUMBER)
AccessorFunc(ENT, "hSpawner", "Spawner")
AccessorFunc(ENT, "dNextSpawn", "NextSpawn", FORCE_NUMBER)
AccessorFunc(ENT, "dSpawnUpdateRate", "SpawnUpdateRate", FORCE_NUMBER)
 
ENT.NZOnlyVisibleInCreative = true
 
function ENT:DecrementZombiesToSpawn()
    self:SetZombiesToSpawn( self:GetZombiesToSpawn() - 1 )
end
 
function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "Link")
    self:NetworkVar("String", 1, "ZombieType")
	self:NetworkVar("Bool", 0, "Skip")
    self:NetworkVar("Bool", 1, "MasterSpawn")
    self:NetworkVar("Int", 0, "SpawnType")
    self:NetworkVar("Int", 1, "ActiveRound")
end
 
function ENT:Initialize()
    if !NZNukeSpawnDelay then NZNukeSpawnDelay = 0 end
    self:SetModel( "models/player/odessa.mdl" )
    self:SetMoveType( MOVETYPE_NONE )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetCollisionGroup( COLLISION_GROUP_DEBRIS )
    self:SetColor(Color(0, 255, 0))
    self:DrawShadow( false )
    self:SetSpawnWeight(0)
    self:SetZombiesToSpawn(0)
    self:SetNextSpawn(CurTime())
    self:SetSpawnUpdateRate(0)

    if (self:GetSpawnType() == 0 or self:GetSpawnType() == nil) and !self:GetMasterSpawn() then
        self:AutoSpawnType() -- Spawns don't have the data set.
    end

    self.Spawns = {}

    self.CurrentSpawnType = "nil"
    self:UpdateSpawnType()
end

function ENT:UpdateSpawnType()
    local types = {
        [0] = "Riser",
        [1] = "No Animation",
        [3] = "Undercroft",
        [4] = "Wall Emerge",
        [5] = "Jump Spawn",
        [6] = "Barrel Climbout",
        [7] = "Ceiling Dropdown Low",
        [8] = "Ceiling Dropdown High",
        [9] = "Ground Wall",
    }
    self.CurrentSpawnType = types[self:GetSpawnType()]
end

function ENT:AutoSpawnType()
    if SERVER then -- Client gets really made cuz it doesn't know what a "navmesh" is.
        local nav = navmesh.GetNearestNavArea( self:GetPos() )
        if IsValid(nav) then
            if nav:HasAttributes(NAV_MESH_NO_JUMP) then
                self:SetSpawnType(1)
            elseif nav:HasAttributes(NAV_MESH_OBSTACLE_TOP) then
                self:SetSpawnType(3)
            elseif nav:HasAttributes(NAV_MESH_DONT_HIDE) then
                self:SetSpawnType(4)
            else
                self:SetSpawnType(0)
            end
        end
    end
end

function ENT:IsSuitable(ent) --OOOOoooo nZu Code Port!
    -- Optimization: No need to check trace in the same tick as another earlier check
    if self.LastSuccessfulCheck == engine.TickCount() then return true end

    local pos = self:GetPos() + Vector(0,0,1)
    local trace = {
        start = pos,
        endpos = pos,
        filter = ent,
        ignoreworld = true,
        mask = MASK_NPCSOLID,
    }
    local result
    if IsValid(ent) then result = util.TraceEntity(trace, ent) else
        trace.mins = Vector(-20,-20,0)
        trace.maxs = Vector(20,20,10)
        result = util.TraceHull(trace)
    end
    
    local entt = result.Entity

    if not result.Hit then
        self.LastSuccessfulCheck = engine.TickCount()
        return true
    end
    if result.Hit then
        if IsValid(entt) and entt.IsMooZombie or IsValid(entt) and entt:GetClass() == "prop_buys" then
            self.LastSuccessfulCheck = engine.TickCount()
            return true
        else
            return false
        end
    end
end


-- Moo Mark 7/24/23: Moved a bunch of code from "sv_spawner.lua" and put here, also tweaked it a ton too.
-- Basically I'ved reworked the spawn system to be less shitty and not spawn ALL of the zombies at one spawn when there like 20 other spawns to use.
-- This never really happened in solo, but in multiplayer games with around 4+ players... It got really bad to the point where the zombie industry crashed.

-- But now... Its been reworked to be more like actual CoD where you'll place down one main spawner and that spawner will randomly pick any open spawn to use.
-- This should basically get rid of the "dumping all the zombies at one spawn." thing thats been an issue in recent times.
-- Maps should also just flow better from this too.

-- Though it should be noted that this code isn't optimized at all, and should be improved in the future.

function ENT:Think()
    if SERVER then
        if nzRound:InState( ROUND_PROG ) and self:GetZombiesToSpawn() > 0 and self:GetMasterSpawn() then

            if (nzRound:GetZombiesKilled() + nzEnemies:TotalAlive()) + 1 > nzRound:GetZombiesMax() then --[[print("--Possible Overflow--")]] return end

            if self:GetSpawner() and self:GetSpawner():GetNextSpawn() < CurTime() and self:GetNextSpawn() < CurTime() then
                local maxspawns = NZZombiesMaxAllowed != nil and NZZombiesMaxAllowed or 24
                if nzEnemies:TotalAlive() < maxspawns then
                    local class
                    local zombie

                    if self:GetSpawnUpdateRate() < CurTime() then

                        local plys = player.GetAllPlaying()
                        local range = math.Clamp(nzMapping.Settings.range / 2, 1000, 60000) 
                        if range <= 0 then range = 60000 end -- A quote on quote, infinite range.

                        self.Spawns = {}

                        for k,v in nzLevel.GetZombieSpawnArray() do -- You get an array now.
                            if v:GetClass() == self:GetClass() then
                                if !v:GetMasterSpawn() 
                                    and (v.link == nil or nzDoors:IsLinkOpened(v.link)) 
                                    and (nzElec:IsOn() and v:GetActiveRound() == -1 or nzRound:GetNumber() >= v:GetActiveRound() and v:GetActiveRound() ~= -1) then

                                    if nzMapping.Settings.navgroupbased then
                                        for k2, v2 in pairs(plys) do
                                            if IsValid(v2) and v2:IsInWorld() and nzNav.Functions.IsInSameNavGroup(v2, v) then
                                                if v:GetPos():DistToSqr(v2:GetPos()) <= range^2 then
                                                    table.insert(self.Spawns, v)
                                                end
                                            end
                                        end
                                    else
                                        for k2, v2 in pairs(plys) do
                                            if v:GetPos():DistToSqr(v2:GetPos()) <= range^2 then
                                                table.insert(self.Spawns, v)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        self:SetSpawnUpdateRate(CurTime() + 5)
                    end

                    local randomspawn = self.Spawns[math.random(#self.Spawns)]
                    if IsValid(randomspawn) then

                        -- Find what type of spawner it is.
                        local spawntypes = {
                            ["nz_spawn_zombie_normal"] = true,
                            ["nz_spawn_zombie_extra1"] = true,
                            ["nz_spawn_zombie_extra2"] = true,
                            ["nz_spawn_zombie_extra3"] = true,
                            ["nz_spawn_zombie_extra4"] = true,
                        }

                        -- Now we're gonna see if the spawner has a zombie type set.
                        if !nzRound:IsSpecial() and randomspawn:GetZombieType() ~= "none" and spawntypes[randomspawn:GetClass()] then
                            -- Normal and Extra Spawns.
                            class = randomspawn:GetZombieType()
                        elseif nzRound:IsSpecial() and !spawntypes[randomspawn:GetClass()] and randomspawn:GetClass() == "nz_spawn_zombie_special" and randomspawn:GetZombieType() ~= "none" then
                            -- Special Spawns.
                            class = randomspawn:GetZombieType()
                        else
                            -- No zombie type set, default to config mapsetting.
                            class = nzMisc.WeightedRandom(self:GetZombieData(), "chance")
                        end

                        zombie = ents.Create(class)
                        zombie:SetPos(randomspawn:GetPos())
                        zombie:SetAngles(randomspawn:GetAngles())
                        zombie:Spawn()

                        -- make a reference to the spawner object used for "respawning"
                        zombie:SetSpawner(self:GetSpawner())
                        zombie:Activate()

                        -- reduce zombies in queue on self and spawner object
                        self:GetSpawner():DecrementZombiesToSpawn()
                        self:DecrementZombiesToSpawn()
                    end
                    
                    if nzRound:IsSpecial() then
                        local data = nzRound:GetSpecialRoundData()
                        if data and data.spawnfunc then
                            data.spawnfunc(zombie)
                        end
                    end

                    hook.Call("OnZombieSpawned", nzEnemies, zombie, self )

                    -- Global spawner timer only set if a successful spawn happens!
                    self:GetSpawner():SetNextSpawn(CurTime() + self:GetSpawner():GetDelay())
                end
            end
        end
    end
end

if CLIENT then
    local displayfont = "ChatFont"
    local outline = Color(0,0,0,59)
    local drawdistance = 800
    local size = 0.25
    function ENT:Draw()
        if ConVarExists("nz_creative_preview") and !GetConVar("nz_creative_preview"):GetBool() and nzRound:InState( ROUND_CREATE ) then
            self:DrawModel()
            if self:GetPos():DistToSqr(LocalPlayer():WorldSpaceCenter()) < drawdistance^2 then
                local angle = EyeAngles()
                angle:RotateAroundAxis( angle:Up(), -90 )
                angle:RotateAroundAxis( angle:Forward(), 90 )
                cam.Start3D2D(self:GetPos() + Vector(0,0,80), angle, size)
                    draw.SimpleTextOutlined("Link: "..self:GetLink().."", displayfont, 0, 0, self:GetColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, outline)
                cam.End3D2D()
            end
            if self:GetPos():DistToSqr(LocalPlayer():WorldSpaceCenter()) < drawdistance^2 and self.CurrentSpawnType then
                local angle = EyeAngles()
                angle:RotateAroundAxis( angle:Up(), -90 )
                angle:RotateAroundAxis( angle:Forward(), 90 )
                cam.Start3D2D(self:GetPos() + Vector(0,0,85), angle, size)
                    draw.SimpleTextOutlined("Spawn Type: "..self.CurrentSpawnType.."", displayfont, 0, 0, self:GetColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, outline)
                cam.End3D2D()
            end
            if self:GetPos():DistToSqr(LocalPlayer():WorldSpaceCenter()) < drawdistance^2 and self:GetMasterSpawn() then
                local angle = EyeAngles()
                angle:RotateAroundAxis( angle:Up(), -90 )
                angle:RotateAroundAxis( angle:Forward(), 90 )
                cam.Start3D2D(self:GetPos() + Vector(0,0,90), angle, size)
                    draw.SimpleTextOutlined("Master Spawn", displayfont, 0, 0, self:GetColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, outline)
                cam.End3D2D()
            end
            if self:GetPos():DistToSqr(LocalPlayer():WorldSpaceCenter()) < drawdistance^2 and self:GetZombieType() then
                local angle = EyeAngles()
                angle:RotateAroundAxis( angle:Up(), -90 )
                angle:RotateAroundAxis( angle:Forward(), 90 )
                cam.Start3D2D(self:GetPos() + Vector(0,0,95), angle, size)
                    draw.SimpleTextOutlined("Type: "..self:GetZombieType().."", displayfont, 0, 0, self:GetColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, outline)
                cam.End3D2D()
            end
            if self:GetPos():DistToSqr(LocalPlayer():WorldSpaceCenter()) < drawdistance^2 and self:GetActiveRound() then
                local angle = EyeAngles()
                angle:RotateAroundAxis( angle:Up(), -90 )
                angle:RotateAroundAxis( angle:Forward(), 90 )
                cam.Start3D2D(self:GetPos() + Vector(0,0,100), angle, size)
                    draw.SimpleTextOutlined("Round: "..self:GetActiveRound().."", displayfont, 0, 0, self:GetColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 3, outline)
                cam.End3D2D()
            end
        end
    end
end
 