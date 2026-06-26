if not game:IsLoaded() then
    game.Loaded:Wait()
end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- Double execution check
do
    local g = (getgenv and getgenv()) or _G or {}
    if g.MahmutHubLoaded then
        print("Mahmut Hub | already running")
        return
    end
    g.MahmutHubLoaded = true
end

-- ========== RCONSOLE LOADING BAR (FALLBACK) ==========
local function createConsoleLoader()
    -- Check if rconsole available
    local hasConsole = rconsoleprint and rconsoleclear and rconsolehide
    
    if not hasConsole then
        -- Ultimate fallback: do nothing
        return {
            update = function(self, p, msg, gName) end,
            fadeOut = function(self, delayTime) end,
            destroy = function(self) end
        }
    end
    
    -- Clear console first
    rconsoleclear()
    rconsolehide()
    
    local function drawBar(percent, status, gameName)
        rconsoleclear()
        
        local barWidth = 30
        local filled = math.floor(barWidth * percent / 100)
        local empty = barWidth - filled
        local bar = string.rep("=", filled) .. string.rep(" ", empty)
        
        local lines = {
            "",
            "  __  __       _   _           _   _       _     _       ",
            " |  \\/  | __ _| | | |__   __ _| | | |_   _| |__ | | ___  ",
            " | |\\/| |/ _` | | | '_ \\ / _` | | | | | | | '_ \\| |/ _ \\ ",
            " | |  | | (_| | | | | | | (_| | |_| | |_| | |_) | |  __/ ",
            " |_|  |_|\\__,_|_| |_| |_|\\__,_|\\___/ \\__,_|_.__/|_|\\___| ",
            "",
            "  Mahmut Hub Loader v2.0",
            "  " .. (gameName and "Game: " .. gameName or "Checking game..."),
            "",
            "  [" .. bar .. "] " .. string.format("%3d", percent) .. "%",
            "  Status: " .. status,
            "",
            "  " .. string.rep(".", (percent % 4) + 1),
            ""
        }
        
        for _, line in ipairs(lines) do
            rconsoleprint(line .. "\n")
        end
    end
    
    return {
        update = function(self, p, msg, gName)
            drawBar(p, msg, gName)
        end,
        
        fadeOut = function(self, delayTime)
            delayTime = delayTime or 1
            task.wait(delayTime)
            rconsoleclear()
            rconsoleprint("\n  Mahmut Hub | Loaded successfully!\n")
            task.wait(0.5)
        end,
        
        destroy = function(self)
            -- rconsole tidak perlu destroy
        end
    }
end

-- ========== LOAD UI FROM EXTERNAL (WITH FALLBACK) ==========
local function createLoader()
    local ok, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/uis/loader.lua"))()
    end)
    
    -- Jika UI gagal load, pakai rconsole loader
    if not ok or type(result) ~= "table" then
        print("Mahmut Hub | UI failed to load, switching to console mode...")
        return createConsoleLoader()
    end
    
    -- Verify required methods
    local required = {"update", "fadeOut", "destroy"}
    for _, method in ipairs(required) do
        if type(result[method]) ~= "function" then
            print("Mahmut Hub | UI missing method: " .. method .. ", switching to console mode...")
            return createConsoleLoader()
        end
    end
    
    return result
end

-- ========== MAIN LOADER ==========
local loader = createLoader()

local supportedGames = {
    [9186719164] = { name = "Sailor Piece", url = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/SailorPiece/production/main.lua" },
    [1281592938] = { name = "Entrenched WW1", url = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/EntrenchedWW1/production/main.lua" },
    [7633926880] = { name = "BloxStrike", url = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/BloxStrike/production/main.lua" },
    [10004244222] = { name = "Kick a Lucky Block", url = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/KickALuckyBlock/production/main.lua" },
    [9967681734] = { name = "Tebak Lagu", url = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/TebakLagu/production/main.lua" },
    [6931042565] = { name = "VBL", url = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/VBL/production/main.lua" },
    [4658598196] = { name = "AOT:Revolution", url = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/AOTR/production/main.lua" }
}

-- Step 1: Fetch universe
loader:update(10, "Connecting to Roblox API...")
local success, universeData = pcall(function()
    return game:HttpGet("https://apis.roblox.com/universes/v1/places/" .. game.PlaceId .. "/universe")
end)
if not success then loader:destroy() error("Failed to fetch universe data") end

-- Step 2: Parse
loader:update(25, "Parsing game data...")
local UniverseID = HttpService:JSONDecode(universeData).universeId

-- Step 3: Check support
loader:update(40, "Verifying game support...")
local gameInfo = supportedGames[UniverseID]
if not gameInfo then 
    loader:update(100, "Unsupported game!")
    task.wait(1)
    loader:destroy() 
    error(("Unsupported game (UniverseID: %d)"):format(UniverseID)) 
end

loader:update(50, "Game verified", gameInfo.name)

-- Step 4: Download
loader:update(60, "Downloading script...")
local ok, scriptSource = pcall(function()
    return game:HttpGet(gameInfo.url)
end)
if not ok or not scriptSource or scriptSource == "" then 
    loader:destroy() 
    error("Failed to download game script") 
end

-- Step 5: Execute
loader:update(80, "Executing script...")
local ok2, err = pcall(function()
    local func = loadstring(scriptSource)
    if not func then error("loadstring returned nil") end
    getgenv().MahmutHubGame = gameInfo.name
    getgenv().MahmutHubLoader = loader
    func()
end)

if not ok2 then 
    loader:destroy() 
    error("Failed to execute: " .. tostring(err)) 
end

-- Done
loader:update(100, "Ready!", gameInfo.name)
loader:fadeOut(2)