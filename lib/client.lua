local http = require("http")
local json = require("json")
local util = require("util")

-- pre_install.lua
function getDownloadInfo(version)
    local file
    local headers
    local dataVersion = util.dataVersion
    if RUNTIME.archType ~= "amd64" and RUNTIME.osType ~= "darwin" then
        error("Crystal does not provide " .. RUNTIME.osType .. "-" .. RUNTIME.archType .. " release")
    end
    if version == "latest" then
        version = getLatestVersion()
    end
    if version == "dev" or version == "nightly" or version == dataVersion then
        version = dataVersion
        file, headers = generateNightlyURL(RUNTIME.osType, RUNTIME.archType)
    else
        file = generateURL(version, RUNTIME.osType, RUNTIME.archType)
    end

    return file, headers, version
end

function getLatestVersion()
    local version
    if isGithubToken(util.githubToken) then
        version = getLatestVersionWithAPI()
    else
        version = getLatestVersionFromFeed()
    end

    return version
end

function getLatestVersionWithAPI()
    local headers = {
        ["Accept"] = "application/vnd.github+json",
        ["Authorization"] = "Bearer " .. util.githubToken,
        ["X-GitHub-Api-Version"] = "2022-11-28",
    }
    local resp, err = http.get({
        headers = headers,
        url = "https://api.github.com/repos/crystal-lang/crystal/releases/latest",
    })
    if err ~= nil then
        error("Failed to request: " .. err)
    end
    if resp.status_code ~= 200 then
        error("Failed to get latest version: " .. err .. "\nstatus_code => " .. resp.status_code)
    end
    local latest = json.decode(resp.body)
    local version = latest.tag_name

    return version
end

function getLatestVersionFromFeed()
    local resp, err = http.get({
        url = "https://crystal-lang.org/feed.xml",
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

function generateNightlyURL(osType, archType)
    local file
    local headers
    local nightlyUrl = "https://artifacts.crystal-lang.org/dist/crystal-nightly-"

    if osType == "darwin" then
        file = nightlyUrl .. "darwin-universal.tar.gz"
    elseif osType == "linux" then
        file = nightlyUrl .. "linux-x86_64.tar.gz"
    elseif osType == "windows" then
        if isGithubToken(util.githubToken) then
            file, headers = fetchWinNightly()
        else
            error("Please provide a valid GitHub Token to download Windows nightly builds")
        end
    else
        error("Crystal doesn't provide nightly builds for " .. osType .. "-" .. archType)
    end

    return file, headers
end

function fetchWinNightly()
    local file
    local artifactsUrl
    local headers = {
        ["Accept"] = "application/vnd.github+json",
        ["Authorization"] = "Bearer " .. util.githubToken,
        ["X-GitHub-Api-Version"] = "2022-11-28",
    }
    local resp, err = http.get({
        headers = headers,
        url = "https://api.github.com/repos/crystal-lang/crystal/actions/runs",
    })
    if err ~= nil then
        error("Failed to fetch workflow runs: " .. err)
    end
    if resp.status_code ~= 200 then
        error("Failed to fetch workflow runs: " .. err .. "\nstatus_code => " .. resp.status_code)
    end
    local workflow = json.decode(resp.body)
    for _, run in ipairs(workflow.workflow_runs) do
        if run.name == "Windows CI" and run.conclusion == "success" then
            artifactsUrl = run.artifacts_url
            break
        end
    end
    resp, err = http.get({
        headers = headers,
        url = artifactsUrl,
    })
    if err ~= nil then
        error("Failed to fetch artifacts: " .. err)
    end
    if resp.status_code ~= 200 then
        error("Failed to fetch artifacts: " .. err .. "\nstatus_code => " .. resp.status_code)
    end
    local job = json.decode(resp.body)
    file = job.artifacts[1].archive_download_url .. "#/crystal-nightly-windows-x86_64.zip"

    return file, headers
end

-- available.lua
function fetchAvailable()
    local result = {}
    if RUNTIME.archType ~= "amd64" and RUNTIME.osType ~= "darwin" then
        error("Crystal does not provide " .. RUNTIME.osType .. "-" .. RUNTIME.archType .. " release")
    end
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
        url = "https://crystal-lang.org/releases/",
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
                    note = "latest",
                })
            else
                table.insert(result, {
                    version = version,
                })
            end
            -- Support Crystal version >= 1.3.0
            if compareVersion(version, "1.3.0") <= 0 then
                break
            end
            ::continue::
        end
    else
        table.insert(result, {
            version = util.dataVersion,
            note = "nightly build",
        })
        for version in resp.body:gmatch('">(%d.%d+.%d)</a></th>') do
            if firstLoop then
                firstLoop = false
                table.insert(result, {
                    version = version,
                    note = "latest",
                })
            else
                table.insert(result, {
                    version = version,
                })
            end
            -- Support Crystal version >= 0.24.2
            if compareVersion(version, "0.24.2") <= 0 then
                break
            end
        end
    end

    return result
end

function fetchWithAPI()
    local result = {}
    local headers = {
        ["Accept"] = "application/vnd.github+json",
        ["Authorization"] = "Bearer " .. util.githubToken,
        ["X-GitHub-Api-Version"] = "2022-11-28",
    }
    local resp, err = http.get({
        -- Authenticate to get higher rate limit
        headers = headers,
        url = "https://api.github.com/repos/crystal-lang/crystal/releases?per_page=60",
    })
    if err ~= nil then
        error("Failed to get information: " .. err)
    end
    if resp.status_code ~= 200 then
        error("Failed to get information: " .. err .. "\nstatus_code => " .. resp.status_code)
    end
    local releases = json.decode(resp.body)

    table.insert(result, {
        version = util.dataVersion,
        note = "nightly build",
    })
    if RUNTIME.osType == "windows" then
        for i, release in ipairs(releases) do
            -- Exclude Crystal v1.5.1
            if release.id == 76589229 then
                goto continue
            end
            if i == 1 then
                table.insert(result, {
                    version = release.tag_name,
                    note = "latest",
                })
            else
                table.insert(result, {
                    version = release.tag_name,
                })
            end
            -- Support Crystal version >= 1.3.0
            if release.id <= 56533184 then
                break
            end
            ::continue::
        end
    else
        for i, release in ipairs(releases) do
            if i == 1 then
                table.insert(result, {
                    version = release.tag_name,
                    note = "latest",
                })
            else
                table.insert(result, {
                    version = release.tag_name,
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
