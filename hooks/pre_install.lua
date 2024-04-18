local util = require("util")

--- @param ctx table
--- @field ctx.version string User-input version
--- @return table Version information
function PLUGIN:PreInstall(ctx)
    local version = ctx.version
    local file = ""

    if RUNTIME.osType == "darwin" then
        if version == util.dataVersion then
            file = "https://artifacts.crystal-lang.org/dist/crystal-nightly-darwin-universal.tar.gz"
        elseif isNewVersion(version) then
            file = "https://github.com/crystal-lang/crystal/releases/download/%s/crystal-%s-1-darwin-universal.tar.gz"
        elseif RUNTIME.archType == "amd64" then
            file = "https://github.com/crystal-lang/crystal/releases/download/%s/crystal-%s-1-darwin-x86_64.tar.gz"
        else
            error("Crystal does not provide darwin-" .. RUNTIME.archType.. " v" .. version .. " release")
        end
    elseif RUNTIME.osType == "linux" and RUNTIME.archType == "amd64" then
        if version == util.dataVersion then
            file = "https://artifacts.crystal-lang.org/dist/crystal-nightly-linux-x86_64.tar.gz"
        else
            file = "https://github.com/crystal-lang/crystal/releases/download/%s/crystal-%s-1-linux-x86_64.tar.gz"
        end
    elseif RUNTIME.osType == "windows" and RUNTIME.archType == "amd64" then
        file = "https://github.com/crystal-lang/crystal/releases/download/%s/crystal-%s-windows-x86_64-msvc-unsupported.zip"
    else
        error("Crystal does not provide " .. RUNTIME.osType .. "-" .. RUNTIME.archType .. " release")
    end

    if version ~= util.dataVersion then
        file = file:format(version, version)
    end

    return {
        version = version,
        url = file
    }
end