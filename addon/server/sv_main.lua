local function printRed(text)
    print("^1" .. text .. "^7")
end

local forbiddenPatterns = {
    "fiveguard",
    "fg_",
    "FG",
    "Fg",
}

local function checkResourceNames()
    local resourceName = GetCurrentResourceName()
    for _, pattern in ipairs(forbiddenPatterns) do
        if string.find(resourceName:lower(), pattern:lower()) then
            printRed("[WARNING] The resource '" .. resourceName .. "' contains a forbidden pattern: '" .. pattern .. "'. Please change its name.")
        end
    end
    if Config.ResourceName == "fiveguard" then
        printRed("[CRITICAL] The resource name is 'fiveguard'. Change the resource name and Config.ResourceName immediately!")
    end
    if resourceName ~= "addon" then
        printRed("[IMPORTANT] The ADDON resource must retain the name ADDON to function correctly")
    end
end


-- Wait(30000)
-- checkResourceNames()


-- VERSION CHECKER FOR ADDON !!!!!!!!!

Citizen.CreateThread(function()
    Citizen.Wait(5000)
    checkResourceNames()
    local function ToNumber(str)
        return tonumber(str)
    end
    local resourceName = GetCurrentResourceName()
    local currentVersion = GetResourceMetadata(resourceName, 'version', 0)
    PerformHttpRequest('https://raw.githubusercontent.com/OffSey/OffSey_AssetsVersions/master/'..resourceName..'.txt',function(error, result, headers)
        if not result then 
            return print('^1The version check failed, github is down.^0') 
        end
        local result = json.decode(result:sub(1, -2))
        if ToNumber(result.version:gsub('%.', '')) > ToNumber(currentVersion:gsub('%.', '')) then
            local symbols = '^9'
            for cd = 1, 26+#resourceName do
                symbols = symbols..'='
            end
            symbols = symbols..'^0'
            print(symbols)
            print('^3['..resourceName..'] - New update available now!^0\nCurrent Version: ^1'..currentVersion..'^0.\nNew Version: ^2'..result.version..'^0.\nNote of changes: ^5'..result.news..'^0.\n\n^5Download it now on the OffSey github^0.')
            print(symbols)
        end
    end, 'GET')
end)