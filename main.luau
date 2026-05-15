if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

repeat task.wait() until LocalPlayer

print("Checking game support...")

if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

local gameId = game.GameId

local supportedGames = {
    [9186719164] = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/games/SailorPiece/production/main.luau",
    [1281592938] = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/games/EntrenchedWW1/production/main.luau",
    [7633926880] = "https://raw.githubusercontent.com/4raff/MahmutHub/refs/heads/main/games/BloxStrike/production/main.luau",
}

if supportedGames[gameId] then 
    print("Game supported! Loading script...")

    local success, result = pcall(function()
        return game:HttpGet(supportedGames[gameId])
    end)

    if success and result then
        pcall(function()
            loadstring(result)()
        end)
    else
        warn("Failed to fetch script.")
    end
else
    warn("Unsupported game. GameId:", gameId)
end