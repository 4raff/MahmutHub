-- Mahmut Hub Main Loader
print("Checking game support...")

local UniverseID = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://apis.roblox.com/universes/v1/places/"..game.PlaceId.."/universe")).universeId

local supportedGames = {
    [9186719164] = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/SailorPiece/production/main.lua",
    [1281592938] = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/EntrenchedWW1/production/main.lua",
    [7633926880] = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/BloxStrike/production/main.lua",
    [10004244222] = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/KickALuckyBlock/production/main.lua",
    [9967681734] = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/TebakLagu/production/main.lua",
    [6931042565] = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/VBL/production/main.lua",
    [4658598196] = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/AOTR/production/main.lua",
}

if supportedGames[UniverseID] then
    print("Game supported! Loading script...")

    local success, result = pcall(function()
        return game:HttpGet(supportedGames[UniverseID])
    end)

    if success and result then
        pcall(function()
            loadstring(result)()
        end)
    else
        warn("Failed to fetch script.")
    end
else
    warn("Unsupported game. UniverseID:", UniverseID)
end
