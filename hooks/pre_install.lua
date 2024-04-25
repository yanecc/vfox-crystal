require("client")
local util = require("util")

function PLUGIN:PreInstall(ctx)
    local version = ctx.version
    local file

    if version == "latest" then
        version = getLatestVersion()
    end
    if version == "nightly" or version == "dev" then
        version = util.dataVersion
    end

    file = generateUrl(version, RUNTIME.osType, RUNTIME.archType, version == util.dataVersion)

    return {
        version = version,
        url = file
    }
end