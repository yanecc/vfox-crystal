function getDate()
    local current_date = os.date("*t")
    local formatted_date = string.format("%04d%02d%02d", current_date.year, current_date.month, current_date.day)
    return formatted_date
end

-- Check if version >= 1.2.0
function isNewVersion(version)
    local versionTable = {}
    for i in string.gmatch(version, "%d+") do
        table.insert(versionTable, tonumber(i))
    end
    if versionTable[1] == 1 and versionTable[2] >= 2 then
        return true
    elseif versionTable[1] > 1 then
        return true
    else
        return false
    end
end

function generateUrl(version, osType, archType, isNightly)
    -- Get GitHub proxy
    local githubUrl = os.getenv("GITHUB_URL") or "https://github.com/"
    if os.getenv("GITHUB_URL") then
        githubUrl = os.getenv("GITHUB_URL")
    end
    local baseUrl = githubUrl .. "crystal-lang/crystal/releases/download/%s/crystal-%s-"
    local nightlyUrl = "https://artifacts.crystal-lang.org/dist/crystal-nightly-"
    local file

    if isNightly then
        if osType == "linux" then
            file = nightlyUrl .. "linux-x86_64.tar.gz"
        elseif osType == "darwin" then
            file = nightlyUrl .. "darwin-universal.tar.gz"
        else
            error("Crystal only provides nightly builds for Linux and Darwin")
        end
    else
        if osType == "darwin" then
            if isNewVersion(version) then
                file = baseUrl .. "1-darwin-universal.tar.gz"
            elseif archType == "amd64" then
                file = baseUrl .. "1-darwin-x86_64.tar.gz"
            else
                error("Crystal does not provide darwin-" .. archType .. " v" .. version .. " release")
            end
        elseif osType == "linux" and archType == "amd64" then
            file = baseUrl .. "1-linux-x86_64.tar.gz"
        elseif osType == "windows" and archType == "amd64" then
            file = baseUrl .. "windows-x86_64-msvc-unsupported.zip"
        else
            error("Crystal does not provide " .. osType .. "-" .. archType .. " release")
        end
        file = file:format(version, version)
    end

    return file
end

function isGithubToken(token)
    local character = "[a-zA-Z0-9]"
    -- Personal Access Token (Classic)
    if token:match("^ghp_" .. character:rep(36) .. "$") then
        return true
    -- Personal Access Token (Fine-Grained)
    elseif token:match("^github_pat_" .. character:rep(22) .. "_" .. character:rep(59) .. "$") then
        return true
    else
        return false
    end
end

return {
    -- Authenticate to get higher rate limit
    githubToken = "",
    dataVersion = getDate()
}