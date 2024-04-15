--- Returns some pre-installed information, such as version number, download address, local files, etc.
--- If checksum is provided, vfox will automatically check it for you.
--- @param ctx table
--- @field ctx.version string User-input version
--- @return table Version information
function PLUGIN:PreInstall(ctx)
    local version = ctx.version
    local file = ""
    if RUNTIME.osType == "darwin" then
        file = "https://github.com/crystal-lang/crystal/releases/download/%s/crystal-%s-1-darwin-universal.tar.gz"
    elseif RUNTIME.osType == "windows" and RUNTIME.archType == "amd64" then
        file = "https://github.com/crystal-lang/crystal/releases/download/%s/crystal-%s-windows-x86_64-msvc-unsupported.zip"
    elseif RUNTIME.osType == "linux" and RUNTIME.archType == "amd64" then
        file = "https://github.com/crystal-lang/crystal/releases/download/%s/crystal-%s-1-linux-x86_64.tar.gz"
    else
        error("Crystal does not support " .. RUNTIME.osType .. "-" .. RUNTIME.archType .. " os")
    end

    return {
        --- Version number
        version = version,
        --- remote URL or local file path [optional]
        url = file:format(version, version)
    }
end