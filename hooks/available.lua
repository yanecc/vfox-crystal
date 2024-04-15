local http = require("http")
local json = require("json")

--- Return all available versions provided by this plugin
--- @param ctx table Empty table used as context, for future extension
--- @return table Descriptions of available versions and accompanying tool descriptions
function PLUGIN:Available(ctx)
    local result = {}
    local resp, err = http.get({
        -- -- Authenticate to get higher rate limit
        -- headers = {
        --   ['Accept'] = "application/vnd.github+json",
        --   ['Authorization'] = "Bearer <Your_personal_github_token>",
        --   ['X-GitHub-Api-Version'] = "2022-11-28"
        -- },
        url = "https://api.github.com/repos/crystal-lang/crystal/releases?per_page=40"
    })
    if err ~= nil then
        error("Failed to get information: " .. err)
    end
    if resp.status_code == 403 then
        error("\nNote!!!\n================\nAPI rate limit exceeded. Modify the ~/.version-fox/plugin/crystal/hooks/available.lua file to set your personal GitHub token for a higher rate limit before formal use.")
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
        -- Support Crystal version >= 1.2.0
        if release.id <= 51307977 then
            break
        end
    end

    return result
end