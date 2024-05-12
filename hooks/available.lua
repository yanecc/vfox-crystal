require("client")

function PLUGIN:Available(ctx)
    local option = ctx.args[1]
    local noCache = false
    if option == "--no-cache" then
        noCache = true
    end
    return fetchAvailable(noCache)
end