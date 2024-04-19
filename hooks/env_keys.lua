function PLUGIN:EnvKeys(ctx)
    local mainPath = ctx.path
    if RUNTIME.osType == "windows" then
        return {
            {
                key = "PATH",
                value = mainPath
            }
        }
    elseif RUNTIME.osType == "linux" then
        return {
            {
                key = "PATH",
                value = mainPath .. "/bin"
            }
        }
    else
        return {
            {
                key = "PATH",
                value = mainPath .. "/bin"
            },
            {
                key = "PATH",
                value = mainPath .. "/embedded/bin"
            }
        }
    end
end