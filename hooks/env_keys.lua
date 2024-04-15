function PLUGIN:EnvKeys(ctx)
    if RUNTIME.osType == "windows" then
        return {
            {
                key = "PATH",
                value = ctx.path,
            }
        }
    else
        return {
            {
                key = "PATH",
                value = ctx.path .. "/bin"
            }
        }
    end
end