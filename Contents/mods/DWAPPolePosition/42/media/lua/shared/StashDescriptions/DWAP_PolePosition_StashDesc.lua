require "StashDescriptions/StashUtil";
local configs = {
    [1] = {
        name = "Pole Position Map",
        stamps = {
            {"Asterisk", nil, 12672, 6398, 0, 0, 0},
        },
        buildingX = 12672,
        buildingY = 6398,
    },
}

for i = 1, #configs do
    local config = configs[i]
    local DWAPStashMap = StashUtil.newStash("DWAP_PPStashMap" .. i, "Map", "Base.RosewoodMap", "Stash_AnnotedMap");
    for j = 1, #config.stamps do
        local stamp = config.stamps[j]
        if config.buildingX and config.buildingY then
            DWAPStashMap.buildingX = config.buildingX
            DWAPStashMap.buildingY = config.buildingY
        end
        DWAPStashMap:addStamp(stamp[1], stamp[2], stamp[3], stamp[4], stamp[5], stamp[6], stamp[7])
    end
    DWAPStashMap.customName = config.name
end
