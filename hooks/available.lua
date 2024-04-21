local http = require("http")
local json = require("json")
local util = require("util")

--- Return all available versions provided by this plugin
--- @param ctx table Empty table used as context, for future extension
--- @return table Descriptions of available versions and accompanying tool descriptions
function PLUGIN:Available(ctx)
    local result = {}
    local headers = {}
    if isGithubToken(util.githubToken) then
        headers = {
            ['Accept'] = "application/vnd.github+json",
            ['Authorization'] = "Bearer " .. util.githubToken,
            ['X-GitHub-Api-Version'] = "2022-11-28"
        }
    end

    local resp, err = http.get({
        -- Authenticate to get higher rate limit
        headers = headers,
        url = "https://api.github.com/repos/crystal-lang/crystal/releases?per_page=60"
    })
    if err ~= nil then
        error("Failed to get information: " .. err)
    end
    if resp.status_code == 403 then
        if RUNTIME.osType == "windows" then
            error("\nNote!!!\n================\nAPI rate limit exceeded. Modify the "
                  .. RUNTIME.pluginDirPath
                  .. "\\lib\\util.lua file to set your personal GitHub token for a higher rate limit before formal use.")
        else
            error("\nNote!!!\n================\nAPI rate limit exceeded. Modify the "
                  .. RUNTIME.pluginDirPath
                  .. "/lib/util.lua file to set your personal GitHub token for a higher rate limit before formal use.")
        end
    end
    if resp.status_code ~= 200 then
        error("Failed to get information: " .. err .. "\nstatus_code => " .. resp.status_code)
    end
    local respInfo = json.decode(resp.body)

    if RUNTIME.osType == "windows" then
        for i, release in ipairs(respInfo) do
            -- Exclude Crystal v1.5.1
            if release.id == 76589229 then
                goto continue
            end
            if i == 1 then
                table.insert(result, {
                    version = release.tag_name,
                    note = "latest"
                })
            else
                table.insert(result, {
                    version = release.tag_name
                })
            end
            -- Support Crystal version >= 1.3.0
            if release.id <= 56533184 then
                break
            end
            ::continue::
        end
    else
        table.insert(result, {
            version = util.dataVersion,
            note = "nightly build"
        })
        for i, release in ipairs(respInfo) do
            if i == 1 then
                table.insert(result, {
                    version = release.tag_name,
                    note = "latest"
                })
            else
                table.insert(result, {
                    version = release.tag_name
                })
            end
            -- Support Crystal version >= 0.24.2
            if release.id <= 10022620 then
                break
            end
        end
    end

    return result
end