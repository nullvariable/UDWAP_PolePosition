local DWAPUtils = require "DWAPUtils"
Events.OnLoadRadioScripts.Add(function()
    local config = {
        minimumVersion = 17,
        file = "DWAP_PolePosition",
        overrides = {
            makePrimary = SandboxVars.DWAP_PolePosition.MakePrimary,
            includeLoot = SandboxVars.DWAP_PolePosition.IncludeLoot,
        },
    }
    DWAPUtils.dprint("Loading DWAP_PolePosition config")
    DWAPUtils.addExternalConfig(config)
end)
