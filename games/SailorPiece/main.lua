local Mahmut = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Mahmut:CreateWindow({
    Title = "Mahmut-Hub | Sailor Piece ([🔥Huge Update⚔️] Sailor Piece)",
    SubTitle = "by mahmut",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    FarmingSettings = Window:AddTab({ Title = "Farming Settings", Icon = "cog" }),
    Farming         = Window:AddTab({ Title = "Farming",          Icon = "swords" }),
    Dungeon         = Window:AddTab({ Title = "Dungeon",          Icon = "sword" }),
    Settings        = Window:AddTab({ Title = "Settings",         Icon = "disc" }),
}

local Options = Mahmut.Options
local Toggles = Mahmut.Toggles

-- ============================================================
-- SERVICES
-- ============================================================
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VIM               = game:GetService("VirtualInputManager")
local Workspace         = game:GetService("Workspace")
local LocalPlayer       = Players.LocalPlayer

-- ============================================================
-- REMOTES
-- ============================================================
local RequestHit = ReplicatedStorage
    :WaitForChild("CombatSystem"):WaitForChild("Remotes"):WaitForChild("RequestHit")

local RequestAbility = ReplicatedStorage
    :WaitForChild("AbilitySystem"):WaitForChild("Remotes"):WaitForChild("RequestAbility")

local TeleportToIslandSpot = nil
pcall(function()
    TeleportToIslandSpot = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("TeleportToIslandSpot")
end)

local TeleportToPortal = nil
pcall(function()
    TeleportToPortal = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("TeleportToPortal")
end)

-- Auto Spawn Remotes (Sea 2)
local RequestAutoSpawnTheWorld = nil
pcall(function()
    RequestAutoSpawnTheWorld = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestAutoSpawnTheWorld")
end)

local RequestAutoSpawnSpiritWarrior = nil
pcall(function()
    RequestAutoSpawnSpiritWarrior = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestAutoSpawnSpiritWarrior")
end)

-- Auto Spawn Remotes (Sea 1)
local RequestAutoSpawn = nil
pcall(function()
    RequestAutoSpawn = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RequestAutoSpawn")
end)

local RequestAutoSpawnStrongest = nil
pcall(function()
    RequestAutoSpawnStrongest = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RequestAutoSpawnStrongest")
end)

local RequestAutoSpawnRimuru = nil
pcall(function()
    RequestAutoSpawnRimuru = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestAutoSpawnRimuru")
end)

local RequestAutoSpawnAnos = nil
pcall(function()
    RequestAutoSpawnAnos = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RequestAutoSpawnAnos")
end)

local RequestAutoSpawnTrueAizen = nil
pcall(function()
    RequestAutoSpawnTrueAizen = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("RequestAutoSpawnTrueAizen")
end)

-- Dungeon remotes
local RequestDungeonPortal = nil
pcall(function()
    RequestDungeonPortal = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("RequestDungeonPortal")
end)

local StartDungeonPortal = nil
pcall(function()
    StartDungeonPortal = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("StartDungeonPortal")
end)

local DungeonWaveVote = nil
pcall(function()
    DungeonWaveVote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("DungeonWaveVote")
end)

local DungeonWaveReplayVote = nil
pcall(function()
    DungeonWaveReplayVote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("DungeonWaveReplayVote")
end)

local DungeonWaveSync = nil
pcall(function()
    DungeonWaveSync = ReplicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("DungeonWaveSync")
end)

-- Island portal mapping
local ISLAND_PORTALS = {
    ["Starter"]      = "Starter",
    ["Jungle"]       = "Jungle",
    ["Desert"]       = "Desert",
    ["Snow"]         = "Snow",
    ["Sailor"]       = "Sailor",
    ["Boss"]         = "Boss",
    ["Shibuya"]      = "Shibuya",
    ["HollowIsland"] = "HollowIsland",
    ["Shinjuku"]     = "Shinjuku",
    ["Slime"]        = "Slime",
    ["Academy"]      = "Academy",
    ["Judgement"]    = "Judgement",
    ["SoulDominion"] = "SoulDominion",
    ["Ninja"]        = "Ninja",
    ["Lawless"]      = "Lawless",
    ["StarterSea2"]  = "StarterSea2",
    ["Punch"]        = "Punch",
    ["Bizarre"]      = "Bizarre",
    ["BluePlanet"]   = "BluePlanet",
    ["Slayer"]       = "Slayer",
}

-- NPC/Enemy to Island mapping
local ENEMY_TO_ISLAND = {
    ["Thief"]                        = "Starter",
    ["Monkey"]                       = "Jungle",
    ["DessertBandit"]                = "Desert",
    ["FrostRogue"]                   = "Snow",
    ["SoloHunter"]                   = "Sailor",
    ["JinwooBoss"]                   = "Sailor",
    ["VampireKing"]                  = "Sailor",
    ["AlucardBoss"]                  = "Sailor",
    ["SaberBoss"]                    = "Boss",
    ["QinShiBoss"]                   = "Boss",
    ["IchigoBoss"]                   = "Boss",
    ["GilgameshBoss"]                = "Boss",
    ["BlessedMaidenBoss"]            = "Boss",
    ["SaberAlterBoss"]               = "Boss",
    ["MoonSlayerBoss"]               = "Boss",
    ["IceQueenBoss"]                 = "Boss",
    ["Sorcerer"]                     = "Shibuya",
    ["CursedVessel"]                 = "Shibuya",
    ["YujiBoss"]                     = "Shibuya",
    ["LimitlessSorcerer"]            = "Shibuya",
    ["GojoBoss"]                     = "Shibuya",
    ["CursedKing"]                   = "Shibuya",
    ["SukunaBoss"]                   = "Shibuya",
    ["Hollow"]                       = "HollowIsland",
    ["Manipulator"]                  = "HollowIsland",
    ["AizenBoss"]                    = "HollowIsland",
    ["Curse"]                        = "Shinjuku",
    ["StrongSorcerer"]               = "Shinjuku",
    ["StrongestofTodayBoss_Normal"]  = "Shinjuku",
    ["StrongestofTodayBoss_Medium"]  = "Shinjuku",
    ["StrongestofTodayBoss_Hard"]    = "Shinjuku",
    ["StrongestofTodayBoss_Extreme"] = "Shinjuku",
    ["StrongestinHistoryBoss_Normal"]  = "Shinjuku",
    ["StrongestinHistoryBoss_Medium"]  = "Shinjuku",
    ["StrongestinHistoryBoss_Hard"]    = "Shinjuku",
    ["StrongestinHistoryBoss_Extreme"] = "Shinjuku",
    ["Slime"]                        = "Slime",
    ["RimuruBoss_Normal"]            = "Slime",
    ["RimuruBoss_Medium"]            = "Slime",
    ["RimuruBoss_Hard"]              = "Slime",
    ["RimuruBoss_Extreme"]           = "Slime",
    ["AcademyTeacher"]               = "Academy",
    ["AnosBoss_Normal"]              = "Academy",
    ["AnosBoss_Medium"]              = "Academy",
    ["AnosBoss_Hard"]                = "Academy",
    ["AnosBoss_Extreme"]             = "Academy",
    ["Swordsman"]                    = "Judgement",
    ["Yamato"]                       = "Judgement",
    ["YamatoBoss"]                   = "Judgement",
    ["Quincy"]                       = "SoulDominion",
    ["TrueAizenBoss_Normal"]         = "SoulDominion",
    ["TrueAizenBoss_Medium"]         = "SoulDominion",
    ["TrueAizenBoss_Hard"]           = "SoulDominion",
    ["TrueAizenBoss_Extreme"]        = "SoulDominion",
    ["Ninja"]                        = "Ninja",
    ["StrongestShinobi"]             = "Ninja",
    ["StrongestShinobiBoss"]         = "Ninja",
    ["ArenaFighter"]                 = "Lawless",
    ["Delinquent"]                   = "StarterSea2",
    ["StrongFighter"]                = "StarterSea2",
    ["FastNinja"]                    = "Punch",
    ["CosmicBeing"]                  = "Punch",
    ["CosmicBeingBoss_Normal"]       = "Punch",
    ["StrongBandit"]                 = "Bizarre",
    ["TheWorldBoss_Normal"]          = "Bizarre",
    ["TheWorldBoss_Medium"]          = "Bizarre",
    ["TheWorldBoss_Hard"]            = "Bizarre",
    ["TheWorldBoss_Extreme"]         = "Bizarre",
    ["SpiritFighter"]                = "BluePlanet",
    ["SpiritWarriorBoss_Normal"]     = "BluePlanet",
    ["SpiritWarriorBoss_Medium"]     = "BluePlanet",
    ["SpiritWarriorBoss_Hard"]       = "BluePlanet",
    ["SpiritWarriorBoss_Extreme"]    = "BluePlanet",
    ["StrongSlayer"]                 = "Slayer",
    ["SunGod"]                       = "Slayer",
    ["SunGodBoss_Normal"]            = "Slayer",
}

local function getIslandFromEnemy(enemyName)
    if not enemyName then return nil end
    if ENEMY_TO_ISLAND[enemyName] then
        return ENEMY_TO_ISLAND[enemyName]
    end
    local prefix = tostring(enemyName):match("^(.-)%d+$")
    if prefix and ENEMY_TO_ISLAND[prefix] then
        return ENEMY_TO_ISLAND[prefix]
    end
    return nil
end

-- ============================================================
-- STATE
-- ============================================================
local originalGravity      = Workspace.Gravity
local farmingActive        = false
local farmAnchorCFrame     = nil
local lastAnchorCFrame     = nil
local lastTeleportedIsland = nil

-- ============================================================
-- FARM CONTROLLER
-- ============================================================
local FarmController = {}
FarmController.__index = FarmController

function FarmController.new()
    return setmetatable({
        _thread    = nil,
        _running   = false,
        _interrupt = false,
    }, FarmController)
end

function FarmController:isRunning()      return self._running   end
function FarmController:interrupt()      self._interrupt = true end
function FarmController:clearInterrupt() self._interrupt = false end
function FarmController:wasInterrupted() return self._interrupt end

function FarmController:start(loopFn)
    self:stop()
    self._running   = true
    self._interrupt = false
    farmingActive   = true
    pcall(function() Workspace.Gravity = 0 end)
    self._thread = task.spawn(function()
        local ok, err = pcall(loopFn, self)
        if not ok then warn("[FarmController] Loop error:", err) end
        self._running = false
        self._thread  = nil
        farmingActive = false
        pcall(function() Workspace.Gravity = originalGravity end)
    end)
end

function FarmController:stop()
    self._interrupt = true
    farmingActive   = false
    pcall(function() Workspace.Gravity = originalGravity end)
    if self._thread then
        pcall(task.cancel, self._thread)
        self._thread = nil
    end
    self._running = false
end

local farmCtrl = FarmController.new()

-- ============================================================
-- CONSTANTS
-- ============================================================
local SKILL_KEY_MAP = { Z=1, X=2, C=3, V=4, F=5 }
local SKILL_ORDER   = {"Z","X","C","V","F"}
local STYLE_KEYCODE = {
    Melee = Enum.KeyCode.One,
    Sword = Enum.KeyCode.Two,
    Power = Enum.KeyCode.Three,
}

local OWB_NAME_MAP = {
    ["Vampire King"]       = "AlucardBoss",
    ["Solo Hunter"]        = "JinwooBoss",
    ["Limitless Sorcerer"] = "GojoBoss",
    ["Cursed Vessel"]      = "YujiBoss",
    ["Cursed King"]        = "SukunaBoss",
    ["Manipulator"]        = "AizenBoss",
    ["Yamato"]             = "YamatoBoss",
    ["Strongest Shinobi"]  = "StrongestShinobiBoss",
}

local OWB_NAME_MAP_REVERSE = {}
for _, wsName in pairs(OWB_NAME_MAP) do
    OWB_NAME_MAP_REVERSE[wsName] = true
end

local WB_NAME_MAP = {
    ["Cosmic Being"] = "CosmicBeingBoss_Normal",
    ["Sun God"]      = "SunGodBoss_Normal",
}

local WB_NAME_MAP_REVERSE = {}
for _, wsName in pairs(WB_NAME_MAP) do
    WB_NAME_MAP_REVERSE[wsName] = true
end

-- ============================================================
-- AUTO FARM STATE
-- ============================================================
local AutoFarmState = {
    selectedEnemies = false,
    everyEnemy      = false,
    selectedOWB     = false,
    everyOWB        = false,
    selectedWB      = false,
    everyWB         = false,
    selectedBSea2   = false,
    selectedBSea1   = false,
}

local DungeonState = {
    active       = false,
    currentPhase = nil,
}

local ActiveAutoSpawns  = {}
local lastSea1Difficulty = nil
local lastSea2Difficulty = nil

local SkillState  = { autoAll = false, bossOnly = false }
local skillRotIdx = 1
local lastStyle   = nil

-- ============================================================
-- SCHEDULER
-- ============================================================
local Scheduler = {}

function Scheduler.adaptiveWait(hitCount)
    if hitCount % 15 == 0 then
        task.wait(0.1)
    else
        task.wait(0.03)
    end
end

-- ============================================================
-- NPC PROVIDER
-- ============================================================
local NPCProvider = {}

function NPCProvider.getFolder()
    return workspace:FindFirstChild("NPCs")
end

function NPCProvider.isAlive(npc)
    local h = npc:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end

function NPCProvider.isValidCFrame(cf)
    if not cf then return false end
    local pos = cf.Position
    if pos.Magnitude < 1 then return false end
    if pos.Y < -10 then return false end
    if math.abs(pos.X) > 5000 or math.abs(pos.Z) > 5000 then return false end
    return true
end

function NPCProvider.getPrefix(name)
    return tostring(name):match("^(.-)%d+$") or nil
end

local function shuffleTable(t)
    local n = #t
    for i = n, 2, -1 do
        local j = math.random(1, i)
        t[i], t[j] = t[j], t[i]
    end
    return t
end

function NPCProvider.queryNormal(filter)
    local result = {}
    local folder = NPCProvider.getFolder()
    if not folder then return result end

    for _, npc in ipairs(folder:GetChildren()) do
        if npc:IsA("Model") and NPCProvider.isAlive(npc) then
            local prefix = NPCProvider.getPrefix(npc.Name)
            if prefix
                and not OWB_NAME_MAP_REVERSE[npc.Name]
                and not WB_NAME_MAP_REVERSE[npc.Name]
            then
                if filter == nil or filter(prefix, npc) then
                    table.insert(result, npc)
                end
            end
        end
    end
    return shuffleTable(result)
end

function NPCProvider.queryOWB(selectedMap)
    local result = {}
    local folder = NPCProvider.getFolder()
    if not folder then return result end

    for displayName, wsName in pairs(OWB_NAME_MAP) do
        if selectedMap == "all" or selectedMap[displayName] then
            local npc = folder:FindFirstChild(wsName)
            if npc and NPCProvider.isAlive(npc) then
                table.insert(result, npc)
            end
        end
    end
    return result
end

function NPCProvider.queryWB(selectedMap)
    local result = {}
    local folder = NPCProvider.getFolder()
    if not folder then return result end

    for displayName, wsName in pairs(WB_NAME_MAP) do
        if selectedMap == "all" or selectedMap[displayName] then
            local npc = folder:FindFirstChild(wsName)
            if npc and NPCProvider.isAlive(npc) then
                table.insert(result, npc)
            end
        end
    end
    return result
end

local function isToolEquipped()
    local char = LocalPlayer.Character
    if not char then return false end
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Tool") then return true end
    end
    return false
end

-- ============================================================
-- COMBAT
-- ============================================================
local Combat = {}

local function getTargetCFrame(npcCF, method, distY)
    method = method or "Behind"
    distY  = distY  or 5
    local npcPos = npcCF.Position
    if method == "Above" then
        local targetPos = npcPos + Vector3.new(0, distY, 0)
        return CFrame.lookAt(targetPos, npcPos, Vector3.new(0, 0, -1))
    elseif method == "Under" then
        local targetPos = npcPos + Vector3.new(0, -distY, 0)
        return CFrame.lookAt(targetPos, npcPos, Vector3.new(0, 0, 1))
    else
        local targetPos = npcPos + Vector3.new(0, 0, distY)
        return CFrame.lookAt(targetPos, npcPos, Vector3.new(0, 1, 0))
    end
end

local function teleportCharacter(targetCF, islandName)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local targetPos = targetCF.Position

    if islandName and ISLAND_PORTALS[islandName] then
        if islandName ~= lastTeleportedIsland then
            if TeleportToPortal then
                pcall(function()
                    TeleportToPortal:FireServer(ISLAND_PORTALS[islandName])
                end)
                lastTeleportedIsland = islandName
            end
            task.wait(0.5)
        end
    end

    local distance = (hrp.Position - targetPos).Magnitude
    if distance > 1 then
        pcall(function()
            hrp.AssemblyLinearVelocity  = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)
        hrp.CFrame = targetCF
        pcall(function() hrp.Anchored = true end)
        task.wait(0.05)
        pcall(function() hrp.Anchored = false end)
    end
end

local function fireRequestHit(npc)
    pcall(function() RequestHit:FireServer(npc) end)
end

function Combat.equipStyle()
    local styleValue = Options.Style and Options.Style.Value
    if not styleValue then return end

    local char = LocalPlayer.Character
    if not char then return end

    local hasToolEquipped = isToolEquipped()
    if styleValue == lastStyle and hasToolEquipped then return end

    local kc = STYLE_KEYCODE[styleValue]
    if not kc then return end

    if hasToolEquipped then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") then
                pcall(function() item.Parent = game:GetService("Players").LocalPlayer.Backpack end)
            end
        end
        task.wait(0.1)
    end

    pcall(function()
        VIM:SendKeyEvent(true,  kc, false, game)
        task.wait(0.05)
        VIM:SendKeyEvent(false, kc, false, game)
    end)

    lastStyle = styleValue
    task.wait(0.3)
end

function Combat.teleportTo(npc)
    local ok, npcCF = pcall(function() return npc:GetPivot() end)
    if not ok or not NPCProvider.isValidCFrame(npcCF) then return false end

    local method   = Options["Select Method Farm"] and Options["Select Method Farm"].Value or "Behind"
    local distY    = tonumber(Options["Distance Farm Y"] and Options["Distance Farm Y"].Value) or 5
    local targetCF = getTargetCFrame(npcCF, method, distY)
    local island   = getIslandFromEnemy(npc.Name)
    teleportCharacter(targetCF, island)
    return true
end

function Combat.stayAtAnchor()
    local anchorToUse = farmAnchorCFrame or lastAnchorCFrame
    if not anchorToUse then return end

    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local method   = Options["Select Method Farm"] and Options["Select Method Farm"].Value or "Behind"
    local distY    = tonumber(Options["Distance Farm Y"] and Options["Distance Farm Y"].Value) or 5
    local targetCF = getTargetCFrame(anchorToUse, method, distY)
    

    if (hrp.CFrame.Position - targetCF.Position).Magnitude > 2 then
        teleportCharacter(targetCF)
    end
end

function Combat.useSkill(isBoss)
    if SkillState.bossOnly and not isBoss then return end
    if not SkillState.autoAll and not SkillState.bossOnly then return end

    local sel = Options.SelectSkills and Options.SelectSkills.Value
    if type(sel) ~= "table" then return end

    local active = {}
    for _, key in ipairs(SKILL_ORDER) do
        if sel[key] then table.insert(active, SKILL_KEY_MAP[key]) end
    end
    if #active == 0 then return end

    if skillRotIdx > #active then skillRotIdx = 1 end
    pcall(function() RequestAbility:FireServer(active[skillRotIdx]) end)
    skillRotIdx = skillRotIdx + 1
    task.wait(0.5)
end

-- ============================================================
-- ATTACK LOOP
-- ============================================================
function Combat.attackLoop(npc, isBoss, ctrl)
    local hitCount = 0
    local deadline = tick() + (isBoss and 120 or 45)

    local ok, npcCF = pcall(function() return npc:GetPivot() end)
    if not ok or not NPCProvider.isValidCFrame(npcCF) then return "invalid" end

    local char = LocalPlayer.Character
    if not char then return "no_char" end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return "no_hrp" end
    local hum = char:FindFirstChild("Humanoid")

    local method = Options["Select Method Farm"] and Options["Select Method Farm"].Value or "Behind"
    local distY  = tonumber(Options["Distance Farm Y"] and Options["Distance Farm Y"].Value) or 5
    local safeCF = getTargetCFrame(npcCF, method, distY)
    local island = getIslandFromEnemy(npc.Name)

    teleportCharacter(safeCF, island)

    if hum then hum.PlatformStand = true end

    farmAnchorCFrame = npcCF
    Combat.equipStyle()
    Combat.teleportTo(npc)

    while NPCProvider.isAlive(npc) and tick() < deadline do
        if ctrl:wasInterrupted() then
            if hum then hum.PlatformStand = false end
            return "interrupted"
        end

        local okF, freshCF = pcall(function() return npc:GetPivot() end)
        if okF and NPCProvider.isValidCFrame(freshCF) then
            npcCF = freshCF
            farmAnchorCFrame = freshCF
        end

        method = Options["Select Method Farm"] and Options["Select Method Farm"].Value or "Behind"
        distY  = tonumber(Options["Distance Farm Y"] and Options["Distance Farm Y"].Value) or 5
        safeCF = getTargetCFrame(npcCF, method, distY)

        local char2 = LocalPlayer.Character
        if char2 then
            local hrp2 = char2:FindFirstChild("HumanoidRootPart")
            if hrp2 and (hrp2.CFrame.Position - safeCF.Position).Magnitude > 5 then
                local isl = getIslandFromEnemy(npc.Name)
                teleportCharacter(safeCF, isl)
            end
        end

        Combat.useSkill(isBoss)
        fireRequestHit(npc)

        hitCount = hitCount + 1
        Scheduler.adaptiveWait(hitCount)
    end

    if hum then hum.PlatformStand = false end
    return NPCProvider.isAlive(npc) and "timeout" or "killed"
end

-- ============================================================
-- HELPERS
-- ============================================================
local function anyFarmActive()
    return AutoFarmState.selectedEnemies or AutoFarmState.everyEnemy
        or AutoFarmState.selectedOWB     or AutoFarmState.everyOWB
        or AutoFarmState.selectedWB      or AutoFarmState.everyWB
        or AutoFarmState.selectedBSea2   or AutoFarmState.selectedBSea1
end

local function getOWBSelection()
    if AutoFarmState.everyOWB then return "all" end
    if AutoFarmState.selectedOWB then
        return Options["Select Open World Bosses"] and Options["Select Open World Bosses"].Value or {}
    end
    return nil
end

local function getWBSelection()
    if AutoFarmState.everyWB then return "all" end
    if AutoFarmState.selectedWB then
        return Options["Select World Bosses"] and Options["Select World Bosses"].Value or {}
    end
    return nil
end

local function getNormalEnemyTypes()
    local seen  = {}
    local types = {}
    local folder = NPCProvider.getFolder()
    if not folder then return types end

    for _, npc in ipairs(folder:GetChildren()) do
        if npc:IsA("Model")
            and not OWB_NAME_MAP_REVERSE[npc.Name]
            and not WB_NAME_MAP_REVERSE[npc.Name]
        then
            local prefix = NPCProvider.getPrefix(npc.Name)
            if prefix and not seen[prefix] then
                seen[prefix] = true
                table.insert(types, prefix)
            end
        end
    end
    table.sort(types)
    return types
end

local function saveCurrentPosition()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then lastAnchorCFrame = hrp.CFrame end
end

-- ============================================================
-- BOSS SPAWNER (Sea 2)
-- ============================================================
local BossSpawner = {}

local BOSS_SPAWN_CONFIG = {
    ["The World"] = {
        remote           = RequestAutoSpawnTheWorld,
        island           = "Bizarre",
        bossNameTemplate = "TheWorldBoss_",
    },
    ["Spirit Warrior"] = {
        remote           = RequestAutoSpawnSpiritWarrior,
        island           = "BluePlanet",
        bossNameTemplate = "SpiritWarriorBoss_",
    },
}

local BOSS_SPAWN_CONFIG_SEA1 = {
    ["Knight"] = {
        remote        = RequestAutoSpawn,
        bossArg       = "SaberBoss",
        npcName       = "SaberBoss",
        hasDifficulty = false,
        island        = "Boss",
    },
    ["Qin Shi"] = {
        remote        = RequestAutoSpawn,
        bossArg       = "QinShiBoss",
        npcName       = "QinShiBoss",
        hasDifficulty = false,
        island        = "Boss",
    },
    ["Soul Reaper"] = {
        remote        = RequestAutoSpawn,
        bossArg       = "IchigoBoss",
        npcName       = "IchigoBoss",
        hasDifficulty = false,
        island        = "Boss",
    },
    ["King of Heroes"] = {
        remote        = RequestAutoSpawn,
        bossArg       = "GilgameshBoss",
        npcName       = "GilgameshBoss",
        hasDifficulty = true,
        island        = "Boss",
    },
    ["Blessed Maiden"] = {
        remote        = RequestAutoSpawn,
        bossArg       = "BlessedMaidenBoss",
        npcName       = "BlessedMaidenBoss",
        hasDifficulty = true,
        island        = "Boss",
    },
    ["Corrupted Knight"] = {
        remote        = RequestAutoSpawn,
        bossArg       = "SaberAlterBoss",
        npcName       = "SaberAlterBoss",
        hasDifficulty = true,
        island        = "Boss",
    },
    ["Moon Slayer"] = {
        remote        = RequestAutoSpawn,
        bossArg       = "MoonSlayerBoss",
        npcName       = "MoonSlayerBoss",
        hasDifficulty = true,
        island        = "Boss",
    },
    ["Ice Queen"] = {
        remote        = RequestAutoSpawn,
        bossArg       = "IceQueenBoss",
        npcName       = "IceQueenBoss",
        hasDifficulty = true,
        island        = "Boss",
    },
    ["Demon Lord"] = {
        remote        = RequestAutoSpawnRimuru,
        customRemote  = true,
        npcPrefix     = "RimuruBoss_",
        hasDifficulty = true,
        island        = "Slime",
    },
    ["Demon King"] = {
        remote        = RequestAutoSpawnAnos,
        customRemote  = true,
        customArgs    = {"Anos"},
        npcPrefix     = "AnosBoss_",
        hasDifficulty = true,
        island        = "Academy",
    },
    ["True Manipulator"] = {
        remote        = RequestAutoSpawnTrueAizen,
        customRemote  = true,
        npcPrefix     = "TrueAizenBoss_",
        hasDifficulty = true,
        island        = "SoulDominion",
    },
    ["Strongest of Today"] = {
        remote        = RequestAutoSpawnStrongest,
        customRemote  = true,
        customArgs    = {"StrongestToday"},
        npcPrefix     = "StrongestofTodayBoss_",
        hasDifficulty = true,
        island        = "Shinjuku",
    },
    ["Strongest in History"] = {
        remote        = RequestAutoSpawnStrongest,
        customRemote  = true,
        customArgs    = {"StrongestHistory"},
        npcPrefix     = "StrongestinHistoryBoss_",
        hasDifficulty = true,
        island        = "Shinjuku",
    },
}

function BossSpawner.enableAutoSpawn(bossType, difficulty)
    if not bossType or not difficulty then return false end
    local config = BOSS_SPAWN_CONFIG[bossType]
    if not config or not config.remote then return false end
    pcall(function() config.remote:FireServer(difficulty) end)
    task.wait(0.5)
    return true
end

function BossSpawner.disableAutoSpawn(bossType, difficulty)
    if not bossType or not difficulty then return false end
    local config = BOSS_SPAWN_CONFIG[bossType]
    if not config or not config.remote then return false end
    pcall(function() config.remote:FireServer(difficulty) end)
    task.wait(0.5)
    return true
end

function BossSpawner.findSpawnedBoss(bossType, difficulty)
    local config = BOSS_SPAWN_CONFIG[bossType]
    if not config then return nil end
    local bossNamePrefix = config.bossNameTemplate .. difficulty
    local folder = NPCProvider.getFolder()
    if not folder then return nil end
    local boss = folder:FindFirstChild(bossNamePrefix)
    if boss and NPCProvider.isAlive(boss) then return boss end
    return nil
end

function BossSpawner.getSea2BossSelection()
    if AutoFarmState.selectedBSea2 then
        return Options["Select Boss Spawners 2"] and Options["Select Boss Spawners 2"].Value or {}
    end
    return nil
end

function BossSpawner.getDifficulty()
    return Options["Select Difficulty Boss Spawners 2"] and Options["Select Difficulty Boss Spawners 2"].Value or nil
end

-- ============================================================
-- BOSS SPAWNER SEA 1
-- ============================================================
local BossSpawnerSea1 = {}

function BossSpawnerSea1.enableAutoSpawn(bossType, difficulty)
    if not bossType then return false end
    local config = BOSS_SPAWN_CONFIG_SEA1[bossType]
    if not config or not config.remote then return false end
    pcall(function()
        if config.noDifficulty or not config.hasDifficulty then
            config.remote:FireServer(config.bossArg)
        elseif config.customRemote then
            if config.customArgs then
                local args = {}
                for _, arg in ipairs(config.customArgs) do table.insert(args, arg) end
                table.insert(args, difficulty)
                config.remote:FireServer(unpack(args))
            else
                config.remote:FireServer(difficulty)
            end
        else
            config.remote:FireServer(config.bossArg, difficulty)
        end
    end)
    task.wait(0.5)
    return true
end

function BossSpawnerSea1.disableAutoSpawn(bossType, difficulty)
    if not bossType then return false end
    local config = BOSS_SPAWN_CONFIG_SEA1[bossType]
    if not config or not config.remote then return false end
    pcall(function()
        if config.noDifficulty or not config.hasDifficulty then
            config.remote:FireServer(config.bossArg)
        elseif config.customRemote then
            if config.customArgs then
                local args = {}
                for _, arg in ipairs(config.customArgs) do table.insert(args, arg) end
                table.insert(args, difficulty)
                config.remote:FireServer(unpack(args))
            else
                config.remote:FireServer(difficulty)
            end
        else
            config.remote:FireServer(config.bossArg, difficulty)
        end
    end)
    task.wait(0.5)
    return true
end

function BossSpawnerSea1.findSpawnedBoss(bossType, difficulty)
    local config = BOSS_SPAWN_CONFIG_SEA1[bossType]
    if not config then return nil end
    local folder = NPCProvider.getFolder()
    if not folder then return nil end
    local bossName
    if config.npcName then
        bossName = config.npcName
    else
        bossName = config.npcPrefix .. difficulty
    end
    local boss = folder:FindFirstChild(bossName)
    if boss and NPCProvider.isAlive(boss) then return boss end
    return nil
end

function BossSpawnerSea1.getSea1BossSelection()
    if AutoFarmState.selectedBSea1 then
        return Options["Select Boss Spawners"] and Options["Select Boss Spawners"].Value or nil
    end
    return nil
end

function BossSpawnerSea1.getDifficulty()
    return Options["Select Difficulty Boss Spawners"] and Options["Select Difficulty Boss Spawners"].Value or nil
end

local function getOtherBossesOnIsland(selectedBossType, island)
    local otherBosses = {}
    for bossType, config in pairs(BOSS_SPAWN_CONFIG_SEA1) do
        if bossType ~= selectedBossType and config.island == island then
            table.insert(otherBosses, bossType)
        end
    end
    return otherBosses
end

-- ============================================================
-- MAIN FARM LOOP
-- ============================================================
local function farmLoop(ctrl)
    ActiveAutoSpawns = {}

    local styleValue = Options.Style and Options.Style.Value
    if styleValue then
        if isToolEquipped() then
            lastStyle = styleValue
        else
            Combat.equipStyle()
        end
    end

    task.wait(0.5)

    farmAnchorCFrame     = nil
    lastAnchorCFrame     = nil
    lastTeleportedIsland = nil

    local owbWasActive   = false
    local wbWasActive    = false
    local bsea2WasActive = false

    while not ctrl:wasInterrupted() do
        if not anyFarmActive() then break end

        local owbSel     = getOWBSelection()
        local wbSel      = getWBSelection()
        local bsea2Sel   = BossSpawner.getSea2BossSelection()
        local difficulty  = BossSpawner.getDifficulty()
        local owbFound   = false
        local wbFound    = false
        local bsea2Found = false

        -- ================================================
        -- Priority 0: Sea 2 Boss Spawners
        -- ================================================
        if bsea2Sel and difficulty then
            local selectedBosses = {}
            if type(bsea2Sel) == "string" then
                selectedBosses[bsea2Sel] = true
            else
                selectedBosses = bsea2Sel
            end

            for bossType, _ in pairs(BOSS_SPAWN_CONFIG) do
                local key        = bossType .. "_" .. difficulty
                local isActive   = ActiveAutoSpawns[key]
                local isSelected = selectedBosses[bossType]

                if isSelected and not isActive then
                    for _, checkDifficulty in ipairs({"Normal","Medium","Hard","Extreme"}) do
                        if ctrl:wasInterrupted() then break end
                        local existingBoss = BossSpawner.findSpawnedBoss(bossType, checkDifficulty)
                        if existingBoss and NPCProvider.isAlive(existingBoss) then
                            Combat.attackLoop(existingBoss, true, ctrl)
                            if not NPCProvider.isAlive(existingBoss) then
                                saveCurrentPosition()
                                farmAnchorCFrame = nil
                            end
                        end
                    end
                    BossSpawner.enableAutoSpawn(bossType, difficulty)
                    ActiveAutoSpawns[key] = true
                elseif not isSelected and isActive then
                    BossSpawner.disableAutoSpawn(bossType, difficulty)
                    ActiveAutoSpawns[key] = false
                end
            end

            for bossType, _ in pairs(BOSS_SPAWN_CONFIG) do
                if not ctrl:wasInterrupted() and not AutoFarmState.selectedBSea2 then break end
                if selectedBosses[bossType] then
                    local spawnedBoss = BossSpawner.findSpawnedBoss(bossType, difficulty)
                    if spawnedBoss and NPCProvider.isAlive(spawnedBoss) then
                        bsea2Found = true
                        if not bsea2WasActive then
                            farmAnchorCFrame = nil
                            lastAnchorCFrame = nil
                            bsea2WasActive   = true
                        end
                        Combat.attackLoop(spawnedBoss, true, ctrl)
                        if not NPCProvider.isAlive(spawnedBoss) then
                            saveCurrentPosition()
                            farmAnchorCFrame = nil
                        end
                    end
                end
            end

            if not bsea2Found and bsea2WasActive then
                bsea2WasActive = false
                saveCurrentPosition()
                farmAnchorCFrame = nil
            end
        else
            bsea2WasActive = false
            if difficulty then
                for key, isActive in pairs(ActiveAutoSpawns) do
                    if isActive then
                        local bossType = key:match("^(.+)_[^_]+$")
                        if bossType then
                            pcall(function() BossSpawner.disableAutoSpawn(bossType, difficulty) end)
                            ActiveAutoSpawns[key] = false
                        end
                    end
                end
            end
        end

        -- ================================================
        -- Priority 0.5: Sea 1 Boss Spawners
        -- ================================================
        local bsea1Sel        = BossSpawnerSea1.getSea1BossSelection()
        local bsea1Difficulty = BossSpawnerSea1.getDifficulty()
        local bsea1Found      = false
        local bsea1WasActive  = false

        if bsea1Sel then
            local selectedBosses = {}
            if type(bsea1Sel) == "string" then
                selectedBosses[bsea1Sel] = true
            else
                selectedBosses = bsea1Sel
            end

            for bossType, _ in pairs(BOSS_SPAWN_CONFIG_SEA1) do
                local isActive   = ActiveAutoSpawns[bossType]
                local isSelected = selectedBosses[bossType]

                if isSelected and not isActive then
                    if BOSS_SPAWN_CONFIG_SEA1[bossType].hasDifficulty and bsea1Difficulty then
                        for _, checkDifficulty in ipairs({"Normal","Medium","Hard","Extreme"}) do
                            if ctrl:wasInterrupted() then break end
                            local existingBoss = BossSpawnerSea1.findSpawnedBoss(bossType, checkDifficulty)
                            if existingBoss and NPCProvider.isAlive(existingBoss) then
                                Combat.attackLoop(existingBoss, true, ctrl)
                                if not NPCProvider.isAlive(existingBoss) then
                                    saveCurrentPosition()
                                    farmAnchorCFrame = nil
                                end
                            end
                        end
                    else
                        local existingBoss = BossSpawnerSea1.findSpawnedBoss(bossType, nil)
                        if existingBoss and NPCProvider.isAlive(existingBoss) then
                            Combat.attackLoop(existingBoss, true, ctrl)
                            if not NPCProvider.isAlive(existingBoss) then
                                saveCurrentPosition()
                                farmAnchorCFrame = nil
                            end
                        end
                    end

                    local island              = BOSS_SPAWN_CONFIG_SEA1[bossType].island
                    local otherBossesOnIsland = getOtherBossesOnIsland(bossType, island)
                    for _, otherBossType in ipairs(otherBossesOnIsland) do
                        if ctrl:wasInterrupted() then break end
                        local otherConfig = BOSS_SPAWN_CONFIG_SEA1[otherBossType]
                        if otherConfig.hasDifficulty then
                            for _, checkDifficulty in ipairs({"Normal","Medium","Hard","Extreme"}) do
                                if ctrl:wasInterrupted() then break end
                                local otherBoss = BossSpawnerSea1.findSpawnedBoss(otherBossType, checkDifficulty)
                                if otherBoss and NPCProvider.isAlive(otherBoss) then
                                    Combat.attackLoop(otherBoss, true, ctrl)
                                    if not NPCProvider.isAlive(otherBoss) then
                                        saveCurrentPosition()
                                        farmAnchorCFrame = nil
                                    end
                                end
                            end
                        else
                            local otherBoss = BossSpawnerSea1.findSpawnedBoss(otherBossType, nil)
                            if otherBoss and NPCProvider.isAlive(otherBoss) then
                                Combat.attackLoop(otherBoss, true, ctrl)
                                if not NPCProvider.isAlive(otherBoss) then
                                    saveCurrentPosition()
                                    farmAnchorCFrame = nil
                                end
                            end
                        end
                    end

                    if BOSS_SPAWN_CONFIG_SEA1[bossType].hasDifficulty and bsea1Difficulty then
                        BossSpawnerSea1.enableAutoSpawn(bossType, bsea1Difficulty)
                    else
                        BossSpawnerSea1.enableAutoSpawn(bossType, nil)
                    end
                    ActiveAutoSpawns[bossType] = true

                elseif not isSelected and isActive then
                    if BOSS_SPAWN_CONFIG_SEA1[bossType].hasDifficulty and bsea1Difficulty then
                        BossSpawnerSea1.disableAutoSpawn(bossType, bsea1Difficulty)
                    else
                        BossSpawnerSea1.disableAutoSpawn(bossType, nil)
                    end
                    ActiveAutoSpawns[bossType] = false
                end
            end

            for bossType, _ in pairs(BOSS_SPAWN_CONFIG_SEA1) do
                if not ctrl:wasInterrupted() and not AutoFarmState.selectedBSea1 then break end
                if selectedBosses[bossType] then
                    local spawnedBoss = nil
                    if BOSS_SPAWN_CONFIG_SEA1[bossType].hasDifficulty and bsea1Difficulty then
                        spawnedBoss = BossSpawnerSea1.findSpawnedBoss(bossType, bsea1Difficulty)
                    else
                        spawnedBoss = BossSpawnerSea1.findSpawnedBoss(bossType, nil)
                    end
                    if spawnedBoss and NPCProvider.isAlive(spawnedBoss) then
                        bsea1Found = true
                        if not bsea1WasActive then
                            farmAnchorCFrame = nil
                            lastAnchorCFrame = nil
                            bsea1WasActive   = true
                        end
                        Combat.attackLoop(spawnedBoss, true, ctrl)
                        if not NPCProvider.isAlive(spawnedBoss) then
                            saveCurrentPosition()
                            farmAnchorCFrame = nil
                        end
                    end
                end
            end

            if not bsea1Found and bsea1WasActive then
                bsea1WasActive = false
                saveCurrentPosition()
                farmAnchorCFrame = nil
            end
        else
            for bossType, isActive in pairs(ActiveAutoSpawns) do
                if BOSS_SPAWN_CONFIG_SEA1[bossType] and isActive then
                    if BOSS_SPAWN_CONFIG_SEA1[bossType].hasDifficulty and bsea1Difficulty then
                        pcall(function() BossSpawnerSea1.disableAutoSpawn(bossType, bsea1Difficulty) end)
                    else
                        pcall(function() BossSpawnerSea1.disableAutoSpawn(bossType, nil) end)
                    end
                    ActiveAutoSpawns[bossType] = false
                end
            end
        end

        -- ================================================
        -- Priority 1: World Bosses
        -- ================================================
        if wbSel then
            local wbs = NPCProvider.queryWB(wbSel)
            if #wbs > 0 then
                wbFound = true
                if not wbWasActive then
                    farmAnchorCFrame = nil
                    lastAnchorCFrame = nil
                    wbWasActive      = true
                end
                for _, npc in ipairs(wbs) do
                    if ctrl:wasInterrupted() then break end
                    if not anyFarmActive() then break end
                    if NPCProvider.isAlive(npc) then
                        Combat.attackLoop(npc, true, ctrl)
                        if not NPCProvider.isAlive(npc) then
                            saveCurrentPosition()
                            farmAnchorCFrame = nil
                        end
                    end
                end
            else
                if wbWasActive then
                    wbWasActive = false
                    saveCurrentPosition()
                    farmAnchorCFrame = nil
                end
            end
        else
            wbWasActive = false
        end

        -- ================================================
        -- Priority 2: Open World Bosses
        -- ================================================
        if owbSel then
            local owbs = NPCProvider.queryOWB(owbSel)
            if #owbs > 0 then
                owbFound = true
                if not owbWasActive then
                    farmAnchorCFrame = nil
                    lastAnchorCFrame = nil
                    owbWasActive     = true
                end
                for _, npc in ipairs(owbs) do
                    if ctrl:wasInterrupted() then break end
                    if not anyFarmActive() then break end
                    if NPCProvider.isAlive(npc) then
                        Combat.attackLoop(npc, true, ctrl)
                        if not NPCProvider.isAlive(npc) then
                            saveCurrentPosition()
                            farmAnchorCFrame = nil
                        end
                    end
                end
            else
                if owbWasActive then
                    owbWasActive = false
                    saveCurrentPosition()
                    farmAnchorCFrame = nil
                end
            end
        else
            owbWasActive = false
        end

        -- ================================================
        -- Priority 3: Normal Enemies
        -- ================================================
        if (AutoFarmState.selectedEnemies or AutoFarmState.everyEnemy) and not ctrl:wasInterrupted() then
            local selectedTypes = {}
            if AutoFarmState.selectedEnemies then
                local sel = Options["Select Enemies"] and Options["Select Enemies"].Value or {}
                for prefix, enabled in pairs(sel) do
                    if enabled then table.insert(selectedTypes, prefix) end
                end
                table.sort(selectedTypes)
            else
                selectedTypes = getNormalEnemyTypes()
            end

            if #selectedTypes == 0 then
                Combat.stayAtAnchor()
                task.wait(1)
            else
                for _, prefix in ipairs(selectedTypes) do
                    if ctrl:wasInterrupted() then break end
                    if not (AutoFarmState.selectedEnemies or AutoFarmState.everyEnemy) then break end
                    if owbSel and #NPCProvider.queryOWB(owbSel) > 0 then break end
                    if wbSel  and #NPCProvider.queryWB(wbSel)  > 0 then break end

                    local npcsOfType = NPCProvider.queryNormal(function(p) return p == prefix end)

                    if #npcsOfType > 0 then
                        local okA, npcCF0 = pcall(function() return npcsOfType[1]:GetPivot() end)
                        if okA and NPCProvider.isValidCFrame(npcCF0) then
                            farmAnchorCFrame = npcCF0
                        end

                        for _, npc in ipairs(npcsOfType) do
                            if ctrl:wasInterrupted() then break end
                            if not (AutoFarmState.selectedEnemies or AutoFarmState.everyEnemy) then break end
                            if NPCProvider.isAlive(npc) then
                                Combat.attackLoop(npc, false, ctrl)
                                if not NPCProvider.isAlive(npc) then
                                    saveCurrentPosition()
                                    farmAnchorCFrame = nil
                                end
                            end
                        end
                    end
                end
                Combat.stayAtAnchor()
            end
        elseif not wbFound and not owbFound then
            Combat.stayAtAnchor()
            task.wait(1)
        end

        task.wait(0.05)
    end
end

-- ============================================================
-- START / STOP
-- ============================================================
local function startFarm()
    farmCtrl:start(farmLoop)
end

local function stopFarm()
    farmCtrl:stop()
    farmAnchorCFrame     = nil
    lastAnchorCFrame     = nil
    lastTeleportedIsland = nil

    local difficulty = BossSpawner.getDifficulty()
    if difficulty then
        for key, isActive in pairs(ActiveAutoSpawns) do
            if isActive then
                local bossType = key:match("^(.+)_[^_]+$")
                if bossType then
                    pcall(function() BossSpawner.disableAutoSpawn(bossType, difficulty) end)
                end
            end
        end
    end

    local bsea1Difficulty = BossSpawnerSea1.getDifficulty()
    for bossType, isActive in pairs(ActiveAutoSpawns) do
        if isActive and BOSS_SPAWN_CONFIG_SEA1[bossType] then
            if BOSS_SPAWN_CONFIG_SEA1[bossType].hasDifficulty and bsea1Difficulty then
                pcall(function() BossSpawnerSea1.disableAutoSpawn(bossType, bsea1Difficulty) end)
            else
                pcall(function() BossSpawnerSea1.disableAutoSpawn(bossType, nil) end)
            end
        end
    end

    ActiveAutoSpawns = {}

    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.PlatformStand = false end
        if hrp then
            pcall(function()
                hrp.AssemblyLinearVelocity  = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
            end)
        end
    end

    pcall(function() Workspace.Gravity = originalGravity end)
end

LocalPlayer.CharacterAdded:Connect(function()
    if anyFarmActive() then stopFarm() end
    lastStyle            = nil
    farmAnchorCFrame     = nil
    lastAnchorCFrame     = nil
    lastTeleportedIsland = nil
end)

-- ============================================================
-- FARMING SETTINGS TAB
-- ============================================================
do
    local CombatSection = Tabs.FarmingSettings:AddSection("Combat Settings")

    CombatSection:AddDropdown("Style", {
        Title = "Combat Style", Values = {"Melee","Sword","Power"},
        Multi = false, Default = "Melee",
    })

    CombatSection:AddDropdown("SelectSkills", {
        Title = "Select Skills", Values = {"Z","X","C","V","F"},
        Multi = true, Default = {},
    })

    CombatSection:AddToggle("Auto Use Skills For All Mobs", {
        Title = "Auto Use Skills For All Mobs", Default = false,
        Callback = function(v) SkillState.autoAll = v end
    })

    CombatSection:AddToggle("Use Skill Only Boss", {
        Title = "Use Skill Only Boss", Default = false,
        Callback = function(v) SkillState.bossOnly = v end
    })

    local syncing = false
    local DFYInput

    local DFYSlider = CombatSection:AddSlider("Distance Farm Y", {
        Title       = "Distance Farm Y",
        Description = "Distance dari NPC. Jauh = NPC sulit hit kita.",
        Default = 5, Min = 0, Max = 10, Rounding = 1,
        Callback = function(val)
            if syncing then return end
            syncing = true
            if DFYInput then DFYInput:SetValue(tostring(val)) end
            syncing = false
        end
    })

    DFYInput = CombatSection:AddInput("DistanceFarmYInput", {
        Title = "Distance Farm Y Input", Default = nil,
        Placeholder = "0-10", Numeric = true, Finished = true,
        Callback = function(val)
            local n = math.clamp(tonumber(val) or 5, 0, 10)
            if syncing then return end
            syncing = true
            DFYSlider:SetValue(n)
            syncing = false
        end
    })

    CombatSection:AddDropdown("Select Method Farm", {
        Title = "Select Method Farm", Values = {"Behind","Above","Under"},
        Multi = false, Default = "Behind",
    })
end

-- ============================================================
-- FARMING TAB
-- ============================================================
do
    local FarmingNPCs = Tabs.Farming:AddSection("Select Enemies To Farm")

    FarmingNPCs:AddDropdown("Select Enemies", {
        Title = "Select Enemies", Values = getNormalEnemyTypes(),
        Multi = true, Default = {},
    })

    FarmingNPCs:AddToggle("Auto Farm Selected Enemies", {
        Title = "Auto Farm Selected Enemies", Default = false,
        Callback = function(value)
            AutoFarmState.selectedEnemies = value
            if value and AutoFarmState.everyEnemy then
                AutoFarmState.everyEnemy = false
                Toggles["Auto Farm Every Enemies"]:SetValue(false)
            end
            if anyFarmActive() then startFarm() else stopFarm() end
        end
    })

    FarmingNPCs:AddToggle("Auto Farm Every Enemies", {
        Title = "Auto Farm Every Enemies", Default = false,
        Callback = function(value)
            AutoFarmState.everyEnemy = value
            if value and AutoFarmState.selectedEnemies then
                AutoFarmState.selectedEnemies = false
                Toggles["Auto Farm Selected Enemies"]:SetValue(false)
            end
            if anyFarmActive() then startFarm() else stopFarm() end
        end
    })

    local FarmingOWB = Tabs.Farming:AddSection("Select Open World Bosses To Farm")

    FarmingOWB:AddDropdown("Select Open World Bosses", {
        Title  = "Select Open World Bosses",
        Values = {"Vampire King","Solo Hunter","Limitless Sorcerer","Cursed Vessel","Cursed King","Manipulator","Yamato","Strongest Shinobi"},
        Multi  = true, Default = {},
    })

    FarmingOWB:AddToggle("Auto Farm Selected Open World Bosses", {
        Title = "Auto Farm Selected Open World Bosses", Default = false,
        Callback = function(v)
            AutoFarmState.selectedOWB = v
            if v and AutoFarmState.everyOWB then
                AutoFarmState.everyOWB = false
                Toggles["Auto Farm Every Open World Bosses"]:SetValue(false)
            end
            if anyFarmActive() then startFarm() else stopFarm() end
        end
    })

    FarmingOWB:AddToggle("Auto Farm Every Open World Bosses", {
        Title = "Auto Farm Every Open World Bosses", Default = false,
        Callback = function(v)
            AutoFarmState.everyOWB = v
            if v and AutoFarmState.selectedOWB then
                AutoFarmState.selectedOWB = false
                Toggles["Auto Farm Selected Open World Bosses"]:SetValue(false)
            end
            if anyFarmActive() then startFarm() else stopFarm() end
        end
    })

    local FarmingWB = Tabs.Farming:AddSection("Select World Bosses To Farm (Sea 2 Only)")

    FarmingWB:AddDropdown("Select World Bosses", {
        Title = "Select World Bosses", Values = {"Sun God","Cosmic Being"},
        Multi = true, Default = {},
    })

    FarmingWB:AddToggle("Auto Farm Selected World Bosses", {
        Title = "Auto Farm Selected World Bosses", Default = false,
        Callback = function(v)
            AutoFarmState.selectedWB = v
            if v and AutoFarmState.everyWB then
                AutoFarmState.everyWB = false
                Toggles["Auto Farm Every World Bosses"]:SetValue(false)
            end
            if anyFarmActive() then startFarm() else stopFarm() end
        end
    })

    FarmingWB:AddToggle("Auto Farm Every World Bosses", {
        Title = "Auto Farm Every World Bosses", Default = false,
        Callback = function(v)
            AutoFarmState.everyWB = v
            if v and AutoFarmState.selectedWB then
                AutoFarmState.selectedWB = false
                Toggles["Auto Farm Selected World Bosses"]:SetValue(false)
            end
            if anyFarmActive() then startFarm() else stopFarm() end
        end
    })

    local FarmingBS = Tabs.Farming:AddSection("Select Boss Spawners To Farm (Sea 1 Only)")

    FarmingBS:AddDropdown("Select Boss Spawners", {
        Title  = "Select Boss Spawners",
        Values = {"Strongest in History","Strongest of Today","Knight","Qin Shi","Soul Reaper","King of Heroes","Corrupted Knight","Blessed Maiden","Moon Slayer","Ice Queen","Demon Lord","Demon King","True Manipulator"},
        Multi  = false, Default = nil,
        Callback = function(v)
            if AutoFarmState.selectedBSea1 and anyFarmActive() then
                if not v then return end
                local bsea1Difficulty = BossSpawnerSea1.getDifficulty()
                local newBossType     = v
                local newIsland       = BOSS_SPAWN_CONFIG_SEA1[newBossType].island
                local oldBossType     = nil
                local oldIsland       = nil
                for bossType, isActive in pairs(ActiveAutoSpawns) do
                    if isActive and BOSS_SPAWN_CONFIG_SEA1[bossType] then
                        oldBossType = bossType
                        oldIsland   = BOSS_SPAWN_CONFIG_SEA1[bossType].island
                        break
                    end
                end
                if oldBossType and oldIsland == newIsland then
                    ActiveAutoSpawns[oldBossType] = false
                    farmAnchorCFrame = nil
                else
                    for bossType, isActive in pairs(ActiveAutoSpawns) do
                        if isActive and BOSS_SPAWN_CONFIG_SEA1[bossType] then
                            if BOSS_SPAWN_CONFIG_SEA1[bossType].hasDifficulty and bsea1Difficulty then
                                pcall(function() BossSpawnerSea1.disableAutoSpawn(bossType, bsea1Difficulty) end)
                            else
                                pcall(function() BossSpawnerSea1.disableAutoSpawn(bossType, nil) end)
                            end
                            ActiveAutoSpawns[bossType] = false
                        end
                    end
                    farmAnchorCFrame = nil
                end
            end
        end,
    })

    FarmingBS:AddDropdown("Select Difficulty Boss Spawners", {
        Title  = "Select Difficulty Boss Spawners",
        Values = {"Normal","Medium","Hard","Extreme"},
        Multi  = false, Default = nil,
        Callback = function(v)
            if AutoFarmState.selectedBSea1 and anyFarmActive() and BossSpawnerSea1.getSea1BossSelection() then
                local newDifficulty = v
                local oldDifficulty = lastSea1Difficulty
                if oldDifficulty == newDifficulty then return end
                if oldDifficulty then
                    for bossType, isActive in pairs(ActiveAutoSpawns) do
                        if isActive and BOSS_SPAWN_CONFIG_SEA1[bossType] then
                            if BOSS_SPAWN_CONFIG_SEA1[bossType].hasDifficulty then
                                pcall(function() BossSpawnerSea1.disableAutoSpawn(bossType, oldDifficulty) end)
                            end
                        end
                    end
                    task.wait(0.3)
                end
                if newDifficulty then
                    for bossType, isActive in pairs(ActiveAutoSpawns) do
                        if isActive and BOSS_SPAWN_CONFIG_SEA1[bossType] then
                            if BOSS_SPAWN_CONFIG_SEA1[bossType].hasDifficulty then
                                pcall(function() BossSpawnerSea1.enableAutoSpawn(bossType, newDifficulty) end)
                            end
                        end
                    end
                end
                lastSea1Difficulty = newDifficulty
                farmAnchorCFrame   = nil
            end
        end,
    })

    FarmingBS:AddToggle("Auto Farm Selected Boss Spawners", {
        Title = "Auto Farm Selected Boss Spawners", Default = false,
        Callback = function(v)
            AutoFarmState.selectedBSea1 = v
            if v then
                lastSea1Difficulty = BossSpawnerSea1.getDifficulty()
            else
                local bsea1Difficulty = BossSpawnerSea1.getDifficulty()
                for bossType, isActive in pairs(ActiveAutoSpawns) do
                    if isActive and BOSS_SPAWN_CONFIG_SEA1[bossType] then
                        if BOSS_SPAWN_CONFIG_SEA1[bossType].hasDifficulty and bsea1Difficulty then
                            pcall(function() BossSpawnerSea1.disableAutoSpawn(bossType, bsea1Difficulty) end)
                        else
                            pcall(function() BossSpawnerSea1.disableAutoSpawn(bossType, nil) end)
                        end
                        ActiveAutoSpawns[bossType] = false
                    end
                end
            end
            if anyFarmActive() then startFarm() else stopFarm() end
        end
    })

    local FarmingBS2 = Tabs.Farming:AddSection("Select Boss Spawners To Farm (Sea 2 Only)")

    FarmingBS2:AddDropdown("Select Boss Spawners 2", {
        Title  = "Select Boss Spawners 2",
        Values = {"The World","Spirit Warrior"},
        Multi  = false, Default = nil,
        Callback = function(v)
            if AutoFarmState.selectedBSea2 and anyFarmActive() then
                if not v then return end
                local difficulty  = BossSpawner.getDifficulty()
                if not difficulty then return end
                local newBossType = v
                local newIsland   = BOSS_SPAWN_CONFIG[newBossType].island
                local oldBossType = nil
                local oldIsland   = nil
                for key, isActive in pairs(ActiveAutoSpawns) do
                    if isActive then
                        local bt = key:match("^(.+)_[^_]+$")
                        if bt and BOSS_SPAWN_CONFIG[bt] then
                            oldBossType = bt
                            oldIsland   = BOSS_SPAWN_CONFIG[bt].island
                            break
                        end
                    end
                end
                if oldBossType and oldIsland == newIsland then
                    ActiveAutoSpawns[oldBossType .. "_" .. difficulty] = false
                    farmAnchorCFrame = nil
                else
                    for key, isActive in pairs(ActiveAutoSpawns) do
                        if isActive then
                            local bt = key:match("^(.+)_[^_]+$")
                            if bt then
                                pcall(function() BossSpawner.disableAutoSpawn(bt, difficulty) end)
                                ActiveAutoSpawns[key] = false
                            end
                        end
                    end
                    farmAnchorCFrame = nil
                end
            end
        end,
    })

    FarmingBS2:AddDropdown("Select Difficulty Boss Spawners 2", {
        Title  = "Select Difficulty Boss Spawners 2",
        Values = {"Normal","Medium","Hard","Extreme"},
        Multi  = false, Default = nil,
        Callback = function(v)
            if AutoFarmState.selectedBSea2 and anyFarmActive() and BossSpawner.getSea2BossSelection() then
                local newDifficulty = v
                local oldDifficulty = lastSea2Difficulty
                if oldDifficulty == newDifficulty then return end
                if oldDifficulty then
                    for key, isActive in pairs(ActiveAutoSpawns) do
                        if isActive then
                            local bt = key:match("^(.+)_[^_]+$")
                            if bt then
                                pcall(function() BossSpawner.disableAutoSpawn(bt, oldDifficulty) end)
                            end
                        end
                    end
                    task.wait(0.3)
                end
                if newDifficulty then
                    for key, isActive in pairs(ActiveAutoSpawns) do
                        if isActive then
                            local bt = key:match("^(.+)_[^_]+$")
                            if bt then
                                pcall(function() BossSpawner.enableAutoSpawn(bt, newDifficulty) end)
                            end
                        end
                    end
                end
                lastSea2Difficulty = newDifficulty
                farmAnchorCFrame   = nil
            end
        end,
    })

    FarmingBS2:AddToggle("Auto Farm Selected Boss Spawners 2", {
        Title = "Auto Farm Selected Boss Spawners 2", Default = false,
        Callback = function(v)
            AutoFarmState.selectedBSea2 = v
            if v then
                lastSea2Difficulty = BossSpawner.getDifficulty()
            else
                local difficulty = BossSpawner.getDifficulty()
                if difficulty then
                    for key, isActive in pairs(ActiveAutoSpawns) do
                        if isActive then
                            local bt = key:match("^(.+)_[^_]+$")
                            if bt then
                                pcall(function() BossSpawner.disableAutoSpawn(bt, difficulty) end)
                                ActiveAutoSpawns[key] = false
                            end
                        end
                    end
                end
            end
            if anyFarmActive() then startFarm() else stopFarm() end
        end
    })
end

-- ============================================================
-- DUNGEON FARMING TAB
-- ============================================================
do
    local DUNGEON_PLACE_IDS = {
        [123955125827131] = true,
        [75159314259063]  = true,
        [99684056491472]  = true,
        [96767841099256]  = true,
    }

    local DUNGEON_NAME_MAP = {
        ["Double Dungeon"] = "DoubleDungeon",
        ["Shadow Dungeon"] = "CidDungeon",
        ["Rune Dungeon"]   = "RuneDungeon",
        ["Boss Rush"] = "BossRush"
    }

    local DIFFICULTY_MAP = {
        ["Easy"]    = "Easy",
        ["Medium"]  = "Medium",
        ["Hard"]    = "Hard",
        ["Extreme"] = "Extreme",
    }

    local dungeonConfig = {
        dungeon    = nil,
        difficulty = "Easy",
    }

    local dungeonSyncConn     = nil
    local dungeonCombatThread = nil

    local function isInsideDungeon()
        return DUNGEON_PLACE_IDS[game.PlaceId] == true
    end

    local function getDungeonArg()
        local v       = Options["Select Dungeon"] and Options["Select Dungeon"].Value
        local display = (type(v) == "string" and v ~= "") and v or dungeonConfig.dungeon
        return display and DUNGEON_NAME_MAP[display] or nil, display
    end

    local function getDifficultyArg()
        local v       = Options["Select Difficulty Dungeon"] and Options["Select Difficulty Dungeon"].Value
        local display = (type(v) == "string" and v ~= "") and v or dungeonConfig.difficulty
        return display and DIFFICULTY_MAP[display] or "Easy", display
    end

    local function dungeonCombatLoop()
        Combat.equipStyle()
        while DungeonState.active do
            local npcFolder = workspace:FindFirstChild("NPCs")
            if npcFolder then
                for _, npc in ipairs(npcFolder:GetChildren()) do
                    if not DungeonState.active then break end
                    if npc:IsA("Model") then
                        local hum = npc:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            local ok, npcCF = pcall(function() return npc:GetPivot() end)
                            if ok and NPCProvider.isValidCFrame(npcCF) then
                                local method   = Options["Select Method Farm"] and Options["Select Method Farm"].Value or "Behind"
                                local distY    = tonumber(Options["Distance Farm Y"] and Options["Distance Farm Y"].Value) or 5
                                local targetCF = getTargetCFrame(npcCF, method, distY)
                                local char     = LocalPlayer.Character
                                if char then
                                    local hrp = char:FindFirstChild("HumanoidRootPart")
                                    if hrp then
                                        pcall(function()
                                            hrp.AssemblyLinearVelocity  = Vector3.zero
                                            hrp.AssemblyAngularVelocity = Vector3.zero
                                            hrp.CFrame = targetCF
                                        end)
                                    end
                                end
                            end
                            fireRequestHit(npc)
                            Combat.useSkill(true)
                        end
                    end
                end
            end
            task.wait(0.05)
        end
    end

    local function stopDungeonCombat()
        DungeonState.active = false
        if dungeonCombatThread then
            pcall(task.cancel, dungeonCombatThread)
            dungeonCombatThread = nil
        end
        pcall(function() Workspace.Gravity = originalGravity end)
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then hum.PlatformStand = false end
        end
    end

    local function startDungeonCombat()
        stopDungeonCombat()
        DungeonState.active = true
        pcall(function() Workspace.Gravity = 0 end)
        dungeonCombatThread = task.spawn(dungeonCombatLoop)
    end

    local function stopDungeonFarm()
        stopDungeonCombat()
        DungeonState.currentPhase = nil
        if dungeonSyncConn then
            pcall(function() dungeonSyncConn:Disconnect() end)
            dungeonSyncConn = nil
        end
    end

    local function setupDungeonListener(difficultyArg, dungeonArg)
        if dungeonSyncConn then
            pcall(function() dungeonSyncConn:Disconnect() end)
            dungeonSyncConn = nil
        end

        if not DungeonWaveSync then return end

        task.spawn(function()
            task.wait(1)
            if DungeonWaveVote and DungeonState.active then
                pcall(function() DungeonWaveVote:FireServer(difficultyArg) end)
            end
        end)

        startDungeonCombat()

        dungeonSyncConn = DungeonWaveSync.OnClientEvent:Connect(function(data)
            if not DungeonState.active then return end

            local phase = data.phase
            DungeonState.currentPhase = phase

            if phase == "active" then
                if not dungeonCombatThread or coroutine.status(dungeonCombatThread) == "dead" then
                    startDungeonCombat()
                end
            elseif phase == "cleared" then
                task.spawn(function()
                    task.wait(1)
                    if not DungeonState.active then return end
                    if DungeonWaveReplayVote then
                        pcall(function() DungeonWaveReplayVote:FireServer("sponsor") end)
                    end
                    task.wait(1)
                    if not DungeonState.active then return end
                    local currentDiffArg = getDifficultyArg()
                    if DungeonWaveVote then
                        pcall(function() DungeonWaveVote:FireServer(currentDiffArg) end)
                    end
                end)
            end
        end)
    end

    local function startDungeonFarm()
        DungeonState.active = true

        local dungeonArg, dungeonDisplay       = getDungeonArg()
        local difficultyArg, difficultyDisplay = getDifficultyArg()

        if not dungeonArg then
            DungeonState.active = false
            if Toggles["Auto Farm Dungeon"] then Toggles["Auto Farm Dungeon"]:SetValue(false) end
            return
        end

        if isInsideDungeon() then
            setupDungeonListener(difficultyArg, dungeonArg)
        else
            if not RequestDungeonPortal then
                DungeonState.active = false
                if Toggles["Auto Farm Dungeon"] then Toggles["Auto Farm Dungeon"]:SetValue(false) end
                return
            end
            pcall(function() RequestDungeonPortal:FireServer(dungeonArg) end)
            task.spawn(function()
                task.wait(3)
                if not DungeonState.active then return end
                if StartDungeonPortal then
                    pcall(function() StartDungeonPortal:FireServer() end)
                else
                    DungeonState.active = false
                    if Toggles["Auto Farm Dungeon"] then Toggles["Auto Farm Dungeon"]:SetValue(false) end
                end
            end)
        end
    end

    -- UI
    local DungeonSection = Tabs.Dungeon:AddSection("Dungeon Settings")

    DungeonSection:AddDropdown("Select Dungeon", {
        Title   = "Select Dungeon",
        Values  = {"Double Dungeon","Shadow Dungeon","Rune Dungeon", "Boss Rush"},
        Multi   = false,
        Default = nil,
        Callback = function(v)
            if type(v) == "string" and v ~= "" then
                dungeonConfig.dungeon = v
            end
        end,
    })

    DungeonSection:AddDropdown("Select Difficulty Dungeon", {
        Title   = "Select Difficulty Dungeon",
        Values  = {"Easy","Medium","Hard","Extreme"},
        Multi   = false,
        Default = nil,
        Callback = function(v)
            if type(v) == "string" and v ~= "" then
                dungeonConfig.difficulty = v
            end
        end,
    })

    DungeonSection:AddToggle("Auto Farm Dungeon", {
        Title = "Auto Farm Dungeon", Default = false,
        Callback = function(v)
            if v then startDungeonFarm() else stopDungeonFarm() end
        end
    })

    if isInsideDungeon() then
        task.spawn(function()
            task.wait(6)
            local savedDungeon = Options["Select Dungeon"] and Options["Select Dungeon"].Value
            local savedDiff    = Options["Select Difficulty Dungeon"] and Options["Select Difficulty Dungeon"].Value
            if type(savedDungeon) == "string" and savedDungeon ~= "" then
                dungeonConfig.dungeon = savedDungeon
            end
            if type(savedDiff) == "string" and savedDiff ~= "" then
                dungeonConfig.difficulty = savedDiff
            end
            local dungeonArg, _    = getDungeonArg()
            local difficultyArg, _ = getDifficultyArg()
            if dungeonArg then
                DungeonState.active = true
                pcall(function() Toggles["Auto Farm Dungeon"]:SetValue(true) end)
                setupDungeonListener(difficultyArg, dungeonArg)
            end
        end)
    end
end

-- ============================================================
-- ADDONS & SAVE MANAGER
-- ============================================================
SaveManager:SetLibrary(Mahmut)
InterfaceManager:SetLibrary(Mahmut)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("Mahmut-Hub")
SaveManager:SetFolder("Mahmut-Hub/SailorPiece")

pcall(function() InterfaceManager:BuildInterfaceSection(Tabs.Settings) end)
pcall(function() SaveManager:BuildConfigSection(Tabs.Settings) end)

Window:SelectTab(1)

Mahmut:Notify({
    Title   = "Mahmut-Hub | Sailor Piece",
    Content = "Script loaded successfully!",
    Duration = 8
})

local configPath = "Mahmut-Hub/SailorPiece/settings/default.json"

if isfile(configPath) then
    pcall(function() SaveManager:Load("default") end)
else
    pcall(function() SaveManager:Save("default") end)
end

pcall(function() SaveManager:SetAutoloadConfig("default") end)

task.spawn(function()
    task.wait(3)
    while true do
        task.wait(5)
        pcall(function() SaveManager:Save("default") end)
    end
end)

-- Anti-AFK heartbeat
task.spawn(function()
    while true do
        task.wait(30)
        if farmingActive then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.AntiAFKHeartbeat:FireServer()
            end)
        end
    end
end)