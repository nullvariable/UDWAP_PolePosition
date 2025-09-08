local DWAPUtils = require "DWAPUtils"
Events.OnLoadRadioScripts.Add(function()
    local config = {
        minimumVersion = 17,
        file = "DWAP_PolePosition/configs/DWAP_PolePosition",
        overrides = {
            makePrimary = SandboxVars.DWAP_PolePosition.MakePrimary,
            key = SandboxVars.DWAP_PolePosition.Key,
            map = SandboxVars.DWAP_PolePosition.Map,
            essentialLoot = SandboxVars.DWAP_PolePosition.EssentialLoot,
            regularLoot = SandboxVars.DWAP_PolePosition.RegularLoot,
        },
    }
    if SandboxVars.DWAP_PolePosition.ExtraLoot then
        config.file = "DWAP_PolePosition/configs/DWAP_PolePosition_extra"
    end
    DWAPUtils.dprint("Loading DWAP_PolePosition config")
    DWAPUtils.addExternalConfig(config)
end)

local CLEAR_RADIUS = 5

function DWAP_PP_beforeTeleport(coords)
    Events.OnZombieCreate.Add(function(zombie)
        local x, y, z = coords.x, coords.y, coords.z
        if zombie then
            local zombieX, zombieY, zombieZ = zombie:getX(), zombie:getY(), zombie:getZ()
            if zombieX >= x - CLEAR_RADIUS and zombieX <= x + CLEAR_RADIUS and
            zombieY >= y - CLEAR_RADIUS and zombieY <= y + CLEAR_RADIUS and
            (zombieZ == z) then
                print("Removing zombie: " .. zombieX .. ", " .. zombieY)
                -- prevent zombie spawns
                zombie:removeFromWorld()
                zombie:removeFromSquare()
            end
        end
    end)
end

function DWAP_PP_afterTeleport(coords)
    for x = coords.x - CLEAR_RADIUS, coords.x + CLEAR_RADIUS do
        for y = coords.y - CLEAR_RADIUS, coords.y + CLEAR_RADIUS do
            local square = getSquare(x, y, z)
            if square then
                local movingObjects = square:getLuaMovingObjectList()
                for i = 1, #movingObjects do
                    local movingObject = movingObjects[i]
                    if instanceof(movingObject, "IsoZombie") then
                        movingObject:removeFromWorld()
                        movingObject:removeFromSquare()
                        print("Removed zombie at: " .. x .. ", " .. y)
                    end
                end
            end
        end
    end
    local result = DWAPUtils.lightsOnCurrentRoom(nil, -120)
    if not result then
        DWAPUtils.DeferMinute(function()
            DWAPUtils.lightsOnCurrentRoom()
        end)
    end
end
local coords = { x = 12672, y = 6398, z = 0 }
Events.OnNewGame.Add(function(player, square)
    local modData = player:getModData()
    if not modData.DWAPPP_Spawn then
        DWAPUtils.dprint("DWAP Pole Position spawn logic running")
        local spawnRegion = MapSpawnSelect.instance.selectedRegion

        if not spawnRegion then
            spawnRegion = MapSpawnSelect.instance:useDefaultSpawnRegion()
        end
        if spawnRegion and spawnRegion.name == "DWAPPolePosition" then
            DWAP_PP_beforeTeleport(coords)
            if isClient() then
                SendCommandToServer("/teleportto " .. coords.x .. "," .. coords.y .. "," .. coords.z);
            else
                getPlayer():teleportTo(coords.x, coords.y, coords.z)
            end
            DWAPUtils.Defer(function()
                DWAP_PP_afterTeleport(coords)
            end)
            modData.DWAPPP_Spawn = true
        end
    end
end)
