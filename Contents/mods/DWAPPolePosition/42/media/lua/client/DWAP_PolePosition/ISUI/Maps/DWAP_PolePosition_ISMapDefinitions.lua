print("DWAP Boarding School StashDesc.lua loaded")
LootMaps.Init.DWAP_PPStashMap1 = function(mapUI)
    print("Initializing DWAP_PPStashMap1")
    local mapAPI = mapUI.javaObject:getAPIv1()
    MapUtils.initDirectoryMapData(mapUI, 'media/maps/Muldraugh, KY')
    MapUtils.initDefaultStyleV1(mapUI)
    mapAPI:setBoundsInSquares(12608, 6360, 12839, 6543)
end
