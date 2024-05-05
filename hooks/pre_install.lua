require("client")

function PLUGIN:PreInstall(ctx)
    local file, headers, version = getDownloadInfo(ctx.version)

    return {
        url = file,
        headers = headers,
        version = version
    }
end