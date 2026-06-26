repeat task.wait() until game:IsLoaded()
local HttpService = game:GetService("HttpService")
print("Mahmut Hub | Loading...")
print("Mahmut Hub | Checking game support...")
local UniverseID = HttpService:JSONDecode(
    game:HttpGet("https://apis.roblox.com/universes/v1/places/" .. game.PlaceId .. "/universe")
).universeId

local supportedGames = {
    [9186719164]  = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/SailorPiece/production/main.lua",
    [1281592938]  = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/EntrenchedWW1/production/main.lua",
    [7633926880]  = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/BloxStrike/production/main.lua",
    [10004244222] = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/KickALuckyBlock/production/main.lua",
    [9967681734]  = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/TebakLagu/production/main.lua",
    [6931042565]  = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/VBL/production/main.lua",
    [4658598196]  = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/AOTR/production/main.lua",
}

local url = supportedGames[UniverseID]

if not url then
    error(("Unsupported game (UniverseID: %d)"):format(UniverseID))
end

local ok, script = pcall(game.HttpGet, game, url)

if not ok then
    error("Failed to download game script.")
end

local ok2, err = pcall(loadstring(script))

if not ok2 then
    error(err)
end