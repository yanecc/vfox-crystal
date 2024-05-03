require("client")

function PLUGIN:PreInstall(ctx)
    local file, version = getDownloadInfo(ctx.version)

    return {
        url = file,
        version = version
    }
end