if not game:IsLoaded() then
    game.Loaded:Wait()
end

local HttpService = game:GetService("HttpService")

-- prevent double execution
do
    local g = (getgenv and getgenv()) or _G or {}
    if g.MahmutHubLoaded then
        warn("Mahmut Hub | already running in this client - skipping duplicate execution")
        return
    end
    g.MahmutHubLoaded = true
end

print("Mahmut Hub | Loading...")
print("Mahmut Hub | Checking game support...")

local success, universeData = pcall(function()
    return game:HttpGet("https://apis.roblox.com/universes/v1/places/" .. game.PlaceId .. "/universe")
end)

if not success then
    error("Mahmut Hub | Failed to fetch universe data")
end

local UniverseID = HttpService:JSONDecode(universeData).universeId

local supportedGames = {
    [9186719164] = { name = "Sailor Piece", url = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/SailorPiece/production/main.lua" },
    [1281592938] = { name = "Entrenched WW1", url = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/EntrenchedWW1/production/main.lua" },
    [7633926880] = { name = "BloxStrike", url = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/BloxStrike/production/main.lua" },
    [10004244222] = { name = "Kick a Lucky Block", url = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/KickALuckyBlock/production/main.lua" },
    [9967681734] = { name = "Tebak Lagu", url = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/TebakLagu/production/main.lua" },
    [6931042565] = { name = "VBL", url = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/VBL/production/main.lua" },
    [4658598196] = { name = "AOT:Revolution", url = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/AOTR/production/main.lua" }
}

local gameInfo = supportedGames[UniverseID]
if not gameInfo then
    error(("Mahmut Hub | Unsupported game (UniverseID: %d)"):format(UniverseID))
end

print(("Mahmut Hub | Supported game detected: %s, loading script..."):format(gameInfo.name))

local ok, scriptSource = pcall(function()
    return game:HttpGet(gameInfo.url)
end)

if not ok or not scriptSource or scriptSource == "" then
    error("Mahmut Hub | Failed to download game script.")
end

local ok2, err = pcall(function()
    local func = loadstring(scriptSource)
    if not func then
        error("loadstring returned nil - script may be empty or malformed")
    end
    func()
end)

if not ok2 then
    error("Mahmut Hub | Failed to execute game script: " .. tostring(err))
end

print("Mahmut Hub | Script loaded successfully!")