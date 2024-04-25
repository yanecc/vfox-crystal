local http = require("http")
local json = require("json")
local util = require("util")

function getLatestVersion()
    local resp, err = http.get({
        url = "https://crystal-lang.org/feed.xml"
    })
    if err ~= nil then
        error("Failed to request: " .. err)
    end
    if resp.status_code ~= 200 then
        error("Failed to get latest version: " .. err .. "\nstatus_code => " .. resp.status_code)
    end

    local version = resp.body:match("crystal/releases/tag/(%d.%d+.%d)")
    return version
end

function fetchAvailable()
    local result = {}
    if isGithubToken(util.githubToken) then
        result = fetchWithAPI()
    else
        result = fetchFromReleases()
    end

    return result
end

function fetchFromReleases()
    local result = {}
	local resp, err = http.get({
		url = "https://crystal-lang.org/releases/"
	})
	if err ~= nil then
		error("Failed to request: " .. err)
	end
	if resp.status_code ~= 200 then
		error("Failed to get information: " .. err .. "\nstatus_code => " .. resp.status_code)
	end

	local firstLoop = true
    if RUNTIME.osType == "windows" then
        for version in resp.body:gmatch('">(%d.%d+.%d)</a></th>') do
            -- Exclude Crystal v1.5.1
            if version == "1.5.1" then
                goto continue
            end
            if firstLoop then
            	firstLoop = false
                table.insert(result, {
                    version = version,
                    note = "latest"
                })
            else
                table.insert(result, {
                    version = version
                })
            end
            -- Support Crystal version >= 1.3.0
            if not version:isNewerThan("1.3.0") then
                break
            end
            ::continue::
        end
    else
        table.insert(result, {
            version = util.dataVersion,
            note = "nightly build"
        })
        for version in resp.body:gmatch('">(%d.%d+.%d)</a></th>') do
            if firstLoop then
            	firstLoop = false
                table.insert(result, {
                    version = version,
                    note = "latest"
                })
            else
                table.insert(result, {
                    version = version
                })
            end
            -- Support Crystal version >= 0.24.2
            if not version:isNewerThan("0.24.2") then
                break
            end
        end
    end

	return result
end

function fetchWithAPI()
    local result = {}
    local headers = {
        ['Accept'] = "application/vnd.github+json",
        ['Authorization'] = "Bearer " .. util.githubToken,
        ['X-GitHub-Api-Version'] = "2022-11-28"
    }

    local resp, err = http.get({
        -- Authenticate to get higher rate limit
        headers = headers,
        url = "https://api.github.com/repos/crystal-lang/crystal/releases?per_page=60"
    })
    if err ~= nil then
        error("Failed to get information: " .. err)
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
