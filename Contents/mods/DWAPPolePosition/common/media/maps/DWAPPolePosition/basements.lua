local basements = {
}

local basement_access = {
    ba_dwap_poleposition = { width=30, height=30, stairx=0, stairy=0, stairDir="N" },
    ba_dwap_poleposition_solar = { width=30, height=30, stairx=0, stairy=0, stairDir="N" },
}

local doSolar = getActivatedMods():contains("\\ISA") and SandboxVars.DWAP.EnableGenSystemSolar
local fullConfig = table.newarray()
fullConfig[1] = {
    locations = {
        {x=12653, y = 6397, z=-1, stairDir="N", choices={"dummy"}, access="ba_dwap_poleposition", },
    },
}
if doSolar then
    fullConfig[1].locations[1].access="ba_dwap_poleposition_solar"
end


local locations = {}

for i = 1, #fullConfig do
    for j = 1, #fullConfig[i].locations do
        table.insert(locations, fullConfig[i].locations[j])
    end
end

local api = Basements.getAPIv1()
api:addAccessDefinitions('Muldraugh, KY', basement_access)
api:addBasementDefinitions('Muldraugh, KY', basements)
api:addSpawnLocations('Muldraugh, KY', locations)


if getActivatedMods():contains("\\Taylorsville") then
    print("DWAP Taylorsville support loading")
    api:addAccessDefinitions('Taylorsville', basement_access)
    api:addBasementDefinitions('Taylorsville', basements)
    api:addSpawnLocations('Taylorsville', locations)
end

print("DWAP Pole Position basements.lua loaded")
