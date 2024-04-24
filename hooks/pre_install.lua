local util = require("util")

--- @param ctx table
--- @field ctx.version string User-input version
--- @return table Version information
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