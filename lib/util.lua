local strings = require("vfox.strings")

function getDate()
    local current_date = os.date("*t")
    local formatted_date = string.format("%04d%02d%02d", current_date.year, current_date.month, current_date.day)
    return formatted_date
end

function compareVersion(currentVersion, targetVersion)
    local currentVersionArray = strings.split(currentVersion, ".")
    local compareVersionArray = strings.split(targetVersion, ".")

    for i, v in ipairs(currentVersionArray) do
        if tonumber(v) > tonumber(compareVersionArray[i]) then
            return 1
        elseif tonumber(v) < tonumber(compareVersionArray[i]) then
            return -1
        end
    end
    return 0
end

function generateURL(version, osType, archType)
    local file
    local githubURL = os.getenv("GITHUB_URL") or "https://github.com/"
    local baseURL = githubURL:gsub("/$", "") .. "/crystal-lang/crystal/releases/download/%s/crystal-%s-"

    if osType == "darwin" then
        -- new filename since 1.2.0
        if compareVersion(version, "1.2.0") >= 0 then
            file = baseURL .. "1-darwin-universal.tar.gz"
        elseif archType == "amd64" then
            file = baseURL .. "1-darwin-x86_64.tar.gz"
        else
            error("Crystal does not provide darwin-" .. archType .. " v" .. version .. " release")
        end
    elseif osType == "linux" and archType == "amd64" then
        file = baseURL .. "1-linux-x86_64.tar.gz"
    elseif osType == "windows" and archType == "amd64" then
        file = baseURL .. "windows-x86_64-msvc-unsupported.zip"
    else
        error("Crystal does not provide " .. osType .. "-" .. archType .. " release")
    end
    file = file:format(version, version)

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
    end

    return false
end

return {
    -- Authenticate to get higher rate limit   ↓ Add your GitHub Token here
    githubToken = os.getenv("GITHUB_TOKEN") or "",
    dataVersion = getDate(),
}
