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

return {
    -- Authenticate to get higher rate limit
    githubToken = "",
    dataVersion = getDate()
}