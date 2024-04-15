local http = require("http")
local json = require("json")

--- Return all available versions provided by this plugin
--- @param ctx table Empty table used as context, for future extension
--- @return table Descriptions of available versions and accompanying tool descriptions
function PLUGIN:Available(ctx)
    local result = {}
    local resp, err = http.get({
        url = "https://api.github.com/repos/crystal-lang/crystal/releases"
    })
    if err ~= nil then
        error("Failed to get information: " .. err)
    end
    if resp.status_code ~= 200 then
        error("Failed to get information: status_code =>" .. resp.status_code)
    end
    local respInfo = json.decode(resp.body)

    for i, release in ipairs(respInfo) do
        table.insert(result, {
            name = "crystal",
            version = release.tag_name,
        })
    end

    return result
end