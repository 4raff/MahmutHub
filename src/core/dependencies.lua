local function loadFromUrl(url)
    return loadstring(game:HttpGet(url))()
end

local Dependencies = {
    Fluent = loadFromUrl("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"),
    SaveManager = loadFromUrl("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"),
    InterfaceManager = loadFromUrl("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"),
}

return Dependencies
