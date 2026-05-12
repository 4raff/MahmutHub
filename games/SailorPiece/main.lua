-- ============================================================
-- MAHMUT-HUB | Sailor Piece
-- ============================================================
local Mahmut = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

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
    FarmingSettings = Window:AddTab({
        Title = "Farming Settings",
        Icon = "cog"
    }),
    Farming = Window:AddTab({
        Title = "Farming",
        Icon = "swords"
    }),
    Dungeon = Window:AddTab({
        Title = "Dungeon",
        Icon = "sword"
    }),
    Settings = Window:AddTab({
        Title = "Settings",
        Icon = "disc"
    })
}

local Options = Mahmut.Options

-- ============================================================
-- SERVICES
-- ============================================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VIM = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- ============================================================
-- REMOTES
-- ============================================================
local function safeWait(parent, ...)
    local current = parent
    local names = {...}
    local success, result = pcall(function()
        for _, name in ipairs(names) do
            current = current:WaitForChild(name)
        end
        return current
    end)
    return success and result or nil
end

local RequestHit = safeWait(ReplicatedStorage, "CombatSystem", "Remotes", "RequestHit")
local RequestAbility = safeWait(ReplicatedStorage, "AbilitySystem", "Remotes", "RequestAbility")

-- Teleport Remotes
local TeleportToIslandSpot = safeWait(ReplicatedStorage, "Remotes", "TeleportToIslandSpot")
local TeleportToPortal = safeWait(ReplicatedStorage, "Remotes", "TeleportToPortal")

-- Auto Spawn Remotes (Sea 2)
local RequestAutoSpawnTheWorld = safeWait(ReplicatedStorage, "RemoteEvents", "RequestAutoSpawnTheWorld")
local RequestAutoSpawnSpiritWarrior = safeWait(ReplicatedStorage, "RemoteEvents", "RequestAutoSpawnSpiritWarrior")

-- Auto Spawn Remotes (Sea 1)
local RequestAutoSpawn = safeWait(ReplicatedStorage, "Remotes", "RequestAutoSpawn")
local RequestAutoSpawnStrongest = safeWait(ReplicatedStorage, "Remotes", "RequestAutoSpawnStrongest")
local RequestAutoSpawnRimuru = safeWait(ReplicatedStorage, "RemoteEvents", "RequestAutoSpawnRimuru")
local RequestAutoSpawnAnos = safeWait(ReplicatedStorage, "Remotes", "RequestAutoSpawnAnos")
local RequestAutoSpawnTrueAizen = safeWait(ReplicatedStorage, "RemoteEvents", "RequestAutoSpawnTrueAizen")

-- Dungeon Remotes
local RequestDungeonPortal = safeWait(ReplicatedStorage, "Remotes", "RequestDungeonPortal")
local StartDungeonPortal = safeWait(ReplicatedStorage, "Remotes", "StartDungeonPortal")
local DungeonWaveVote = safeWait(ReplicatedStorage, "Remotes", "DungeonWaveVote")
local DungeonWaveReplayVote = safeWait(ReplicatedStorage, "Remotes", "DungeonWaveReplayVote")
local DungeonWaveSync = safeWait(ReplicatedStorage, "RemoteEvents", "DungeonWaveSync")
local SetAutoTowerReset = safeWait(ReplicatedStorage, "RemoteEvents", "SetAutoTowerReset")

-- ============================================================
-- CONSTANTS
-- ============================================================
local ISLAND_PORTALS = {
    Starter = "Starter",
    Jungle = "Jungle",
    Desert = "Desert",
    Snow = "Snow",
    Sailor = "Sailor",
    Boss = "Boss",
    Shibuya = "Shibuya",
    HollowIsland = "HollowIsland",
    Shinjuku = "Shinjuku",
    Slime = "Slime",
    Academy = "Academy",
    Judgement = "Judgement",
    SoulDominion = "SoulDominion",
    Ninja = "Ninja",
    Lawless = "Lawless",
    StarterSea2 = "StarterSea2",
    Punch = "Punch",
    Bizarre = "Bizarre",
    BluePlanet = "BluePlanet",
    Slayer = "Slayer"
}

local ENEMY_TO_ISLAND = {
    Thief = "Starter",
    Monkey = "Jungle",
    DessertBandit = "Desert",
    FrostRogue = "Snow",
    SoloHunter = "Sailor",
    JinwooBoss = "Sailor",
    VampireKing = "Sailor",
    AlucardBoss = "Sailor",
    SaberBoss = "Boss",
    QinShiBoss = "Boss",
    IchigoBoss = "Boss",
    GilgameshBoss = "Boss",
    BlessedMaidenBoss = "Boss",
    SaberAlterBoss = "Boss",
    MoonSlayerBoss = "Boss",
    IceQueenBoss = "Boss",
    Sorcerer = "Shibuya",
    CursedVessel = "Shibuya",
    YujiBoss = "Shibuya",
    LimitlessSorcerer = "Shibuya",
    GojoBoss = "Shibuya",
    CursedKing = "Shibuya",
    SukunaBoss = "Shibuya",
    Hollow = "HollowIsland",
    Manipulator = "HollowIsland",
    AizenBoss = "HollowIsland",
    Curse = "Shinjuku",
    StrongSorcerer = "Shinjuku",
    ["StrongestofTodayBoss_Normal"] = "Shinjuku",
    ["StrongestofTodayBoss_Medium"] = "Shinjuku",
    ["StrongestofTodayBoss_Hard"] = "Shinjuku",
    ["StrongestofTodayBoss_Extreme"] = "Shinjuku",
    ["StrongestinHistoryBoss_Normal"] = "Shinjuku",
    ["StrongestinHistoryBoss_Medium"] = "Shinjuku",
    ["StrongestinHistoryBoss_Hard"] = "Shinjuku",
    ["StrongestinHistoryBoss_Extreme"] = "Shinjuku",
    Slime = "Slime",
    ["RimuruBoss_Normal"] = "Slime",
    ["RimuruBoss_Medium"] = "Slime",
    ["RimuruBoss_Hard"] = "Slime",
    ["RimuruBoss_Extreme"] = "Slime",
    AcademyTeacher = "Academy",
    ["AnosBoss_Normal"] = "Academy",
    ["AnosBoss_Medium"] = "Academy",
    ["AnosBoss_Hard"] = "Academy",
    ["AnosBoss_Extreme"] = "Academy",
    Swordsman = "Judgement",
    Yamato = "Judgement",
    YamatoBoss = "Judgement",
    Quincy = "SoulDominion",
    ["TrueAizenBoss_Normal"] = "SoulDominion",
    ["TrueAizenBoss_Medium"] = "SoulDominion",
    ["TrueAizenBoss_Hard"] = "SoulDominion",
    ["TrueAizenBoss_Extreme"] = "SoulDominion",
    Ninja = "Ninja",
    StrongestShinobi = "Ninja",
    StrongestShinobiBoss = "Ninja",
    ArenaFighter = "Lawless",
    Delinquent = "StarterSea2",
    StrongFighter = "StarterSea2",
    FastNinja = "Punch",
    CosmicBeing = "Punch",
    ["CosmicBeingBoss_Normal"] = "Punch",
    StrongBandit = "Bizarre",
    ["TheWorldBoss_Normal"] = "Bizarre",
    ["TheWorldBoss_Medium"] = "Bizarre",
    ["TheWorldBoss_Hard"] = "Bizarre",
    ["TheWorldBoss_Extreme"] = "Bizarre",
    SpiritFighter = "BluePlanet",
    ["SpiritWarriorBoss_Normal"] = "BluePlanet",
    ["SpiritWarriorBoss_Medium"] = "BluePlanet",
    ["SpiritWarriorBoss_Hard"] = "BluePlanet",
    ["SpiritWarriorBoss_Extreme"] = "BluePlanet",
    StrongSlayer = "Slayer",
    SunGod = "Slayer",
    ["SunGodBoss_Normal"] = "Slayer"
}

local OWB_NAME_MAP = {
    ["Vampire King"] = "AlucardBoss",
    ["Solo Hunter"] = "JinwooBoss",
    ["Limitless Sorcerer"] = "GojoBoss",
    ["Cursed Vessel"] = "YujiBoss",
    ["Cursed King"] = "SukunaBoss",
    ["Manipulator"] = "AizenBoss",
    ["Yamato"] = "YamatoBoss",
    ["Strongest Shinobi"] = "StrongestShinobiBoss"
}

local OWB_NAME_MAP_REVERSE = {}
for _, wsName in pairs(OWB_NAME_MAP) do
    OWB_NAME_MAP_REVERSE[wsName] = true
end

local WB_NAME_MAP = {
    ["Cosmic Being"] = "CosmicBeingBoss_Normal",
    ["Sun God"] = "SunGodBoss_Normal"
}

local WB_NAME_MAP_REVERSE = {}
for _, wsName in pairs(WB_NAME_MAP) do
    WB_NAME_MAP_REVERSE[wsName] = true
end

-- Sea 2 Boss Spawner config
local BOSS_SPAWN_CONFIG_SEA2 = {
    ["The World"] = {
        remote = RequestAutoSpawnTheWorld,
        island = "Bizarre",
        bossNameTemplate = "TheWorldBoss_"
    },
    ["Spirit Warrior"] = {
        remote = RequestAutoSpawnSpiritWarrior,
        island = "BluePlanet",
        bossNameTemplate = "SpiritWarriorBoss_"
    }
}

-- Sea 1 Boss Spawner config
local BOSS_SPAWN_CONFIG_SEA1 = {
    ["Knight"] = {
        remote = RequestAutoSpawn,
        bossArg = "SaberBoss",
        npcName = "SaberBoss",
        hasDifficulty = false,
        island = "Boss"
    },
    ["Qin Shi"] = {
        remote = RequestAutoSpawn,
        bossArg = "QinShiBoss",
        npcName = "QinShiBoss",
        hasDifficulty = false,
        island = "Boss"
    },
    ["Soul Reaper"] = {
        remote = RequestAutoSpawn,
        bossArg = "IchigoBoss",
        npcName = "IchigoBoss",
        hasDifficulty = false,
        island = "Boss"
    },
    ["King of Heroes"] = {
        remote = RequestAutoSpawn,
        bossArg = "GilgameshBoss",
        npcName = "GilgameshBoss",
        hasDifficulty = true,
        island = "Boss"
    },
    ["Blessed Maiden"] = {
        remote = RequestAutoSpawn,
        bossArg = "BlessedMaidenBoss",
        npcName = "BlessedMaidenBoss",
        hasDifficulty = true,
        island = "Boss"
    },
    ["Corrupted Knight"] = {
        remote = RequestAutoSpawn,
        bossArg = "SaberAlterBoss",
        npcName = "SaberAlterBoss",
        hasDifficulty = true,
        island = "Boss"
    },
    ["Moon Slayer"] = {
        remote = RequestAutoSpawn,
        bossArg = "MoonSlayerBoss",
        npcName = "MoonSlayerBoss",
        hasDifficulty = true,
        island = "Boss"
    },
    ["Ice Queen"] = {
        remote = RequestAutoSpawn,
        bossArg = "IceQueenBoss",
        npcName = "IceQueenBoss",
        hasDifficulty = true,
        island = "Boss"
    },
    ["Demon Lord"] = {
        remote = RequestAutoSpawnRimuru,
        customRemote = true,
        npcPrefix = "RimuruBoss_",
        hasDifficulty = true,
        island = "Slime"
    },
    ["Demon King"] = {
        remote = RequestAutoSpawnAnos,
        customRemote = true,
        customArgs = {"Anos"},
        npcPrefix = "AnosBoss_",
        hasDifficulty = true,
        island = "Academy"
    },
    ["True Manipulator"] = {
        remote = RequestAutoSpawnTrueAizen,
        customRemote = true,
        npcPrefix = "TrueAizenBoss_",
        hasDifficulty = true,
        island = "SoulDominion"
    },
    ["Strongest of Today"] = {
        remote = RequestAutoSpawnStrongest,
        customRemote = true,
        customArgs = {"StrongestToday"},
        npcPrefix = "StrongestofTodayBoss_",
        hasDifficulty = true,
        island = "Shinjuku"
    },
    ["Strongest in History"] = {
        remote = RequestAutoSpawnStrongest,
        customRemote = true,
        customArgs = {"StrongestHistory"},
        npcPrefix = "StrongestinHistoryBoss_",
        hasDifficulty = true,
        island = "Shinjuku"
    }
}

local SKILL_KEY_MAP = {
    Z = 1,
    X = 2,
    C = 3,
    V = 4,
    F = 5
}
local SKILL_ORDER = {"Z", "X", "C", "V", "F"}
local STYLE_KEYCODE = {
    Melee = Enum.KeyCode.One,
    Sword = Enum.KeyCode.Two,
    Power = Enum.KeyCode.Three
}
local DIFFICULTIES = {"Normal", "Medium", "Hard", "Extreme"}

-- ============================================================
-- GLOBAL STATE
-- ============================================================
local originalGravity = Workspace.Gravity
local farmingActive = false
local lastTeleportedIsland = nil

-- Anchor positions
local AnchorState = {
    farmCFrame = nil,
    lastCFrame = nil,

    save = function(self)
        local char = LocalPlayer.Character
        if not char then
            return
        end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            self.lastCFrame = hrp.CFrame
        end
    end,

    setFarm = function(self, cf)
        self.farmCFrame = cf
    end,

    clearFarm = function(self)
        self.farmCFrame = nil
    end,

    get = function(self)
        return self.farmCFrame or self.lastCFrame
    end,

    clear = function(self)
        self.farmCFrame = nil
        self.lastCFrame = nil
    end
}

-- Farming toggles
local AutoFarmState = {
    selectedEnemies = false,
    everyEnemy = false,
    selectedOWB = false,
    everyOWB = false,
    selectedWB = false,
    everyWB = false,
    selectedBSea2 = false,
    selectedBSea1 = false
}

-- Skill state
local SkillState = {
    autoAll = false,
    bossOnly = false,
    rotIdx = 1
}

-- Active spawns tracking
local SpawnState = {
    _active = {},

    set = function(self, key, val)
        self._active[key] = val
    end,

    get = function(self, key)
        return self._active[key]
    end,

    clear = function(self)
        self._active = {}
    end,

    forEach = function(self, fn)
        for k, v in pairs(self._active) do
            fn(k, v)
        end
    end
}

local lastSea1Difficulty = nil
local lastSea2Difficulty = nil
local lastStyle = nil

local farmGhostState = {
    parts = {}
}

local function setFarmCollisionGhost(enabled)
    local char = LocalPlayer.Character
    if not char then
        return
    end

    local hum = char:FindFirstChildOfClass("Humanoid")

    if enabled then
        farmGhostState.parts = {}
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("BasePart") then
                farmGhostState.parts[obj] = {
                    CanCollide = obj.CanCollide,
                    CanTouch = obj.CanTouch,
                    CanQuery = obj.CanQuery
                }
                pcall(function()
                    obj.CanCollide = false
                    obj.CanTouch = false
                    obj.CanQuery = false
                end)
            end
        end
        pcall(function()
            if hum then
                hum.PlatformStand = true
                hum:ChangeState(Enum.HumanoidStateType.Physics)
            end
        end)
    else
        for part, props in pairs(farmGhostState.parts) do
            if part and part.Parent and props then
                pcall(function()
                    part.CanCollide = props.CanCollide
                    part.CanTouch = props.CanTouch
                    part.CanQuery = props.CanQuery
                end)
            end
        end
        farmGhostState.parts = {}
        pcall(function()
            if hum then
                hum.PlatformStand = false
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end)
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
    if not cf then
        return false
    end
    local pos = cf.Position
    if pos.Magnitude < 1 then
        return false
    end
    if pos.Y < -10 then
        return false
    end
    if math.abs(pos.X) > 5000 or math.abs(pos.Z) > 5000 then
        return false
    end
    return true
end

function NPCProvider.getPrefix(name)
    return tostring(name):match("^(.-)%d+$") or nil
end

function NPCProvider.getIslandFromEnemy(enemyName)
    if not enemyName then
        return nil
    end
    if ENEMY_TO_ISLAND[enemyName] then
        return ENEMY_TO_ISLAND[enemyName]
    end
    local prefix = tostring(enemyName):match("^(.-)%d+$")
    if prefix and ENEMY_TO_ISLAND[prefix] then
        return ENEMY_TO_ISLAND[prefix]
    end
    return nil
end

function NPCProvider.shuffle(t)
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
    if not folder then
        return result
    end
    for _, npc in ipairs(folder:GetChildren()) do
        if npc:IsA("Model") and NPCProvider.isAlive(npc) then
            local prefix = NPCProvider.getPrefix(npc.Name)
            if prefix and not OWB_NAME_MAP_REVERSE[npc.Name] and not WB_NAME_MAP_REVERSE[npc.Name] then
                if filter == nil or filter(prefix, npc) then
                    table.insert(result, npc)
                end
            end
        end
    end
    return NPCProvider.shuffle(result)
end

function NPCProvider.queryOWB(selectedMap)
    local result = {}
    local folder = NPCProvider.getFolder()
    if not folder then
        return result
    end
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
    if not folder then
        return result
    end
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

function NPCProvider.getNormalEnemyTypes()
    local seen, types = {}, {}
    local folder = NPCProvider.getFolder()
    if not folder then
        return types
    end
    for _, npc in ipairs(folder:GetChildren()) do
        if npc:IsA("Model") and not OWB_NAME_MAP_REVERSE[npc.Name] and not WB_NAME_MAP_REVERSE[npc.Name] then
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

-- ============================================================
-- COMBAT STYLE WATCHDOG
-- ============================================================
local StyleWatchdog = {}

do
    local registeredToolName = nil  -- Nama tool yang di-register saat equip
    local toolChangeConn = nil
    local toolRemoveConn = nil
    local active = false
    local lastReequipTime = 0  -- Debounce: cegah re-equip spam
    local reequipCooldown = 1  -- 1 detik cooldown antar re-equip

    local function getCurrentEquippedTool()
        local char = LocalPlayer.Character
        if not char then
            return nil
        end
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") then
                return item
            end
        end
        return nil
    end

    local function getExpectedStyle()
        local O = Mahmut.Options
        return O and O["Style"] and O["Style"].Value or nil
    end

    local function forceEquipStyle()
        -- Check cooldown sebelum re-equip
        if tick() - lastReequipTime < reequipCooldown then
            return
        end
        lastReequipTime = tick()

        local styleValue = getExpectedStyle()
        if not styleValue then
            return
        end

        local kc = STYLE_KEYCODE[styleValue]
        if not kc then
            return
        end

        local char = LocalPlayer.Character
        if not char then
            return
        end

        -- Unequip tool yang ada dulu (jika ada)
        local tool = getCurrentEquippedTool()
        if tool then
            pcall(function()
                tool.Parent = LocalPlayer.Backpack
            end)
            task.wait(0.1)
        end

        -- Equip style yang benar
        pcall(function()
            VIM:SendKeyEvent(true, kc, false, game)
            task.wait(0.05)
            VIM:SendKeyEvent(false, kc, false, game)
        end)

        lastStyle = styleValue
        task.wait(0.3)

        -- Register nama tool yang baru di-equip (jika ada)
        local equippedTool = getCurrentEquippedTool()
        if equippedTool then
            registeredToolName = equippedTool.Name
            print("[StyleWatchdog] Registered tool:", registeredToolName, "for style:", styleValue)
        else
            registeredToolName = nil
        end
    end

    local function setupToolListener()
        local char = LocalPlayer.Character
        if not char then
            return
        end

        -- Disconnect listener lama
        if toolChangeConn then
            toolChangeConn:Disconnect()
        end
        if toolRemoveConn then
            toolRemoveConn:Disconnect()
        end

        -- Listen ke tool yang di-equip (ChildAdded)
        toolChangeConn = char.ChildAdded:Connect(function(child)
            if child:IsA("Tool") and active and farmingActive then
                -- Skip jika masih dalam cooldown (prevent spam)
                if tick() - lastReequipTime < reequipCooldown then
                    return
                end

                if registeredToolName and child.Name ~= registeredToolName then
                    print("[StyleWatchdog] Wrong tool equipped:", child.Name, "expected:", registeredToolName)
                    task.spawn(function()
                        pcall(function()
                            child.Parent = LocalPlayer.Backpack
                        end)
                        task.wait(0.2)
                        forceEquipStyle()
                    end)
                end
            end
        end)

        -- Listen ke tool yang di-unequip (ChildRemoved)
        toolRemoveConn = char.ChildRemoved:Connect(function(child)
            if child:IsA("Tool") and active and farmingActive then
                -- Skip jika masih dalam cooldown
                if tick() - lastReequipTime < reequipCooldown then
                    return
                end

                if child.Name == registeredToolName then
                    print("[StyleWatchdog] Registered tool unequipped:", child.Name, "re-equipping")
                    task.spawn(forceEquipStyle)
                end
            end
        end)
    end

    function StyleWatchdog.start()
        if active then
            return
        end
        active = true
        print("[StyleWatchdog] started")

        local char = LocalPlayer.Character
        if char then
            setupToolListener()
            -- Cek dan equip style saat start
            local styleValue = getExpectedStyle()
            if styleValue and styleValue ~= "Melee" then
                local tool = getCurrentEquippedTool()
                if not tool or tool.Name ~= registeredToolName then
                    forceEquipStyle()
                end
            elseif styleValue == "Melee" then
                local tool = getCurrentEquippedTool()
                if tool then
                    pcall(function()
                        tool.Parent = LocalPlayer.Backpack
                    end)
                end
                registeredToolName = nil
            end
        end
    end

    function StyleWatchdog.stop()
        active = false
        if toolChangeConn then
            toolChangeConn:Disconnect()
            toolChangeConn = nil
        end
        if toolRemoveConn then
            toolRemoveConn:Disconnect()
            toolRemoveConn = nil
        end
        registeredToolName = nil
        lastReequipTime = 0  -- Reset cooldown saat stop
    end

    function StyleWatchdog.onStyleChanged(newStyle)
        if not newStyle or newStyle == "" then
            return
        end
        lastStyle = newStyle
        registeredToolName = nil  -- Reset registered tool
        lastReequipTime = 0  -- Reset cooldown saat user ubah manual
        if farmingActive then
            forceEquipStyle()
        end
    end
end

-- ============================================================
-- COMBAT
-- ============================================================
local Combat = {}

local function getTargetCFrame(npcCF, method, distY)
    method = method or "Behind"
    distY = distY or 5
    local pos = npcCF.Position
    if method == "Above" then
        return CFrame.lookAt(pos + Vector3.new(0, distY, 0), pos, Vector3.new(0, 0, -1))
    elseif method == "Under" then
        return CFrame.lookAt(pos + Vector3.new(0, -distY, 0), pos, Vector3.new(0, 0, 1))
    else
        return CFrame.lookAt(pos + Vector3.new(0, 0, distY), pos, Vector3.new(0, 1, 0))
    end
end

local function teleportCharacter(targetCF, islandName)
    local char = LocalPlayer.Character
    if not char then
        return
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return
    end

    if islandName and ISLAND_PORTALS[islandName] and islandName ~= lastTeleportedIsland then
        if TeleportToPortal then
            pcall(function()
                TeleportToPortal:FireServer(ISLAND_PORTALS[islandName])
            end)
            lastTeleportedIsland = islandName
        end
        task.wait(0.5)
    end

    if (hrp.Position - targetCF.Position).Magnitude > 1 then
        pcall(function()
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)
        hrp.CFrame = targetCF
        pcall(function()
            hrp.Anchored = true
        end)
        task.wait(0.05)
        pcall(function()
            hrp.Anchored = false
        end)
    end
end

local function isToolEquipped()
    local char = LocalPlayer.Character
    if not char then
        return false
    end
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Tool") then
            return true
        end
    end
    return false
end

local function getCombatOptions()
    return Options["Select Method Farm"] and Options["Select Method Farm"].Value or "Behind",
        tonumber(Options["Distance Farm Y"] and Options["Distance Farm Y"].Value) or 5
end

function Combat.equipStyle()
    local styleValue = Mahmut.Options and Mahmut.Options["Style"] and Mahmut.Options["Style"].Value
    if not styleValue then
        return
    end

    local char = LocalPlayer.Character
    if not char then
        return
    end

    local hasToolEquipped = isToolEquipped()

    -- Jika style sama dan tool sudah equipped, skip
    if styleValue == lastStyle and hasToolEquipped then
        return
    end
    -- Jika style sama dan melee (tidak butuh tool), skip
    if styleValue == lastStyle and styleValue == "Melee" then
        return
    end

    local kc = STYLE_KEYCODE[styleValue]
    if not kc then
        return
    end

    if hasToolEquipped then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") then
                pcall(function()
                    item.Parent = LocalPlayer.Backpack
                end)
            end
        end
        task.wait(0.1)
    end

    pcall(function()
        VIM:SendKeyEvent(true, kc, false, game)
        task.wait(0.05)
        VIM:SendKeyEvent(false, kc, false, game)
    end)

    lastStyle = styleValue
    task.wait(0.3)
end

function Combat.useSkill(isBoss)
    if SkillState.bossOnly and not isBoss then
        return
    end
    if not SkillState.autoAll and not SkillState.bossOnly then
        return
    end

    local sel = Options.SelectSkills and Options.SelectSkills.Value
    if type(sel) ~= "table" then
        return
    end

    local active = {}
    for _, key in ipairs(SKILL_ORDER) do
        if sel[key] then
            table.insert(active, SKILL_KEY_MAP[key])
        end
    end
    if #active == 0 then
        return
    end

    if SkillState.rotIdx > #active then
        SkillState.rotIdx = 1
    end
    pcall(function()
        RequestAbility:FireServer(active[SkillState.rotIdx])
    end)
    SkillState.rotIdx = SkillState.rotIdx + 1
    task.wait(0.5)
end

function Combat.teleportToNPC(npc)
    local ok, npcCF = pcall(function()
        return npc:GetPivot()
    end)
    if not ok or not NPCProvider.isValidCFrame(npcCF) then
        return false
    end
    local method, distY = getCombatOptions()
    local targetCF = getTargetCFrame(npcCF, method, distY)
    local island = NPCProvider.getIslandFromEnemy(npc.Name)
    teleportCharacter(targetCF, island)
    return true
end

function Combat.stayAtAnchor()
    local anchor = AnchorState:get()
    if not anchor then
        return
    end

    local char = LocalPlayer.Character
    if not char then
        return
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return
    end

    local method, distY = getCombatOptions()
    local targetCF = getTargetCFrame(anchor, method, distY)

    if (hrp.CFrame.Position - targetCF.Position).Magnitude > 2 then
        teleportCharacter(targetCF)
    end
end

function Combat.attackLoop(npc, isBoss, ctrl)
    local ok, npcCF = pcall(function()
        return npc:GetPivot()
    end)
    if not ok or not NPCProvider.isValidCFrame(npcCF) then
        return "invalid"
    end

    local char = LocalPlayer.Character
    if not char then
        return "no_char"
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        return "no_hrp"
    end
    local hum = char:FindFirstChild("Humanoid")

    local method, distY = getCombatOptions()
    local island = NPCProvider.getIslandFromEnemy(npc.Name)

    teleportCharacter(getTargetCFrame(npcCF, method, distY), island)
    if hum then
        hum.PlatformStand = true
    end

    AnchorState:setFarm(npcCF)
    Combat.equipStyle()
    Combat.teleportToNPC(npc)

    local hitCount = 0
    local deadline = tick() + (isBoss and 120 or 45)

    while NPCProvider.isAlive(npc) and tick() < deadline do
        if ctrl:wasInterrupted() then
            if hum then
                hum.PlatformStand = false
            end
            return "interrupted"
        end

        -- Refresh NPC position
        local okF, freshCF = pcall(function()
            return npc:GetPivot()
        end)
        if okF and NPCProvider.isValidCFrame(freshCF) then
            npcCF = freshCF
            AnchorState:setFarm(freshCF)
        end

        -- Re-read options in case they changed
        method, distY = getCombatOptions()
        local safeCF = getTargetCFrame(npcCF, method, distY)

        local char2 = LocalPlayer.Character
        if char2 then
            local hrp2 = char2:FindFirstChild("HumanoidRootPart")
            if hrp2 and (hrp2.CFrame.Position - safeCF.Position).Magnitude > 5 then
                teleportCharacter(safeCF, NPCProvider.getIslandFromEnemy(npc.Name))
            end
        end

        Combat.useSkill(isBoss)
        pcall(function()
            RequestHit:FireServer(npc)
        end)

        hitCount = hitCount + 1
        if hitCount % 15 == 0 then
            task.wait(0.1)
        else
            task.wait(0.03)
        end
    end

    if hum then
        hum.PlatformStand = false
    end
    return NPCProvider.isAlive(npc) and "timeout" or "killed"
end

-- ============================================================
-- FARM CONTROLLER
-- ============================================================
local FarmController = {}
FarmController.__index = FarmController

function FarmController.new()
    return setmetatable({
        _thread = nil,
        _running = false,
        _interrupt = false
    }, FarmController)
end

function FarmController:isRunning()
    return self._running
end
function FarmController:interrupt()
    self._interrupt = true
end
function FarmController:clearInterrupt()
    self._interrupt = false
end
function FarmController:wasInterrupted()
    return self._interrupt
end

function FarmController:start(loopFn)
    self:stop()
    self._running = true
    self._interrupt = false
    farmingActive = true
    setFarmCollisionGhost(true)
    pcall(function()
        Workspace.Gravity = 0
    end)
    self._thread = task.spawn(function()
        local ok, err = pcall(loopFn, self)
        if not ok then
            warn("[FarmController] Loop error:", err)
        end
        self._running = false
        self._thread = nil
        farmingActive = false
        setFarmCollisionGhost(false)
        pcall(function()
            Workspace.Gravity = originalGravity
        end)
    end)
end

function FarmController:stop()
    self._interrupt = true
    farmingActive = false
    setFarmCollisionGhost(false)
    pcall(function()
        Workspace.Gravity = originalGravity
    end)
    if self._thread then
        pcall(task.cancel, self._thread)
        self._thread = nil
    end
    self._running = false
end

local farmCtrl = FarmController.new()

-- ============================================================
-- BOSS SPAWNER (Sea 2)
-- ============================================================
local BossSpawnerSea2 = {}

function BossSpawnerSea2.fireRemote(bossType, difficulty)
    local config = BOSS_SPAWN_CONFIG_SEA2[bossType]
    if not config or not config.remote then
        return false
    end
    pcall(function()
        config.remote:FireServer(difficulty)
    end)
    task.wait(0.5)
    return true
end

function BossSpawnerSea2.enable(bossType, difficulty)
    return BossSpawnerSea2.fireRemote(bossType, difficulty)
end

function BossSpawnerSea2.disable(bossType, difficulty)
    return BossSpawnerSea2.fireRemote(bossType, difficulty)
end

function BossSpawnerSea2.findBoss(bossType, difficulty)
    local config = BOSS_SPAWN_CONFIG_SEA2[bossType]
    if not config then
        return nil
    end
    local folder = NPCProvider.getFolder()
    if not folder then
        return nil
    end
    local boss = folder:FindFirstChild(config.bossNameTemplate .. difficulty)
    return (boss and NPCProvider.isAlive(boss)) and boss or nil
end

function BossSpawnerSea2.getSelection()
    if AutoFarmState.selectedBSea2 then
        return Options["Select Boss Spawners 2"] and Options["Select Boss Spawners 2"].Value or {}
    end
    return nil
end

function BossSpawnerSea2.getDifficulty()
    return Options["Select Difficulty Boss Spawners 2"] and Options["Select Difficulty Boss Spawners 2"].Value or nil
end

function BossSpawnerSea2.disableAllActive(difficulty)
    SpawnState:forEach(function(key, isActive)
        if isActive then
            local bt = key:match("^(.+)_[^_]+$")
            if bt and BOSS_SPAWN_CONFIG_SEA2[bt] then
                pcall(function()
                    BossSpawnerSea2.disable(bt, difficulty)
                end)
                SpawnState:set(key, false)
            end
        end
    end)
end

function BossSpawnerSea2.onBossTypeChanged(newBossType)
    if not AutoFarmState.selectedBSea2 then
        return
    end
    local difficulty = BossSpawnerSea2.getDifficulty()
    if not difficulty or not newBossType then
        return
    end

    local newIsland = BOSS_SPAWN_CONFIG_SEA2[newBossType] and BOSS_SPAWN_CONFIG_SEA2[newBossType].island

    -- Find currently active boss
    local oldBossType, oldIsland = nil, nil
    SpawnState:forEach(function(key, isActive)
        if isActive and not oldBossType then
            local bt = key:match("^(.+)_[^_]+$")
            if bt and BOSS_SPAWN_CONFIG_SEA2[bt] then
                oldBossType = bt
                oldIsland = BOSS_SPAWN_CONFIG_SEA2[bt].island
            end
        end
    end)

    if oldBossType and oldIsland == newIsland then
        SpawnState:set(oldBossType .. "_" .. difficulty, false)
    else
        BossSpawnerSea2.disableAllActive(difficulty)
    end
    AnchorState:clearFarm()
end

function BossSpawnerSea2.onDifficultyChanged(newDifficulty)
    if not AutoFarmState.selectedBSea2 then
        return
    end
    if newDifficulty == lastSea2Difficulty then
        return
    end

    if lastSea2Difficulty then
        SpawnState:forEach(function(key, isActive)
            if isActive then
                local bt = key:match("^(.+)_[^_]+$")
                if bt and BOSS_SPAWN_CONFIG_SEA2[bt] then
                    pcall(function()
                        BossSpawnerSea2.disable(bt, lastSea2Difficulty)
                    end)
                end
            end
        end)
        task.wait(0.3)
    end

    if newDifficulty then
        SpawnState:forEach(function(key, isActive)
            if isActive then
                local bt = key:match("^(.+)_[^_]+$")
                if bt and BOSS_SPAWN_CONFIG_SEA2[bt] then
                    pcall(function()
                        BossSpawnerSea2.enable(bt, newDifficulty)
                    end)
                end
            end
        end)
    end

    lastSea2Difficulty = newDifficulty
    AnchorState:clearFarm()
end

-- ============================================================
-- BOSS SPAWNER (Sea 1)
-- ============================================================
local BossSpawnerSea1 = {}

local function fireSea1Remote(config, difficulty)
    if not config or not config.remote then
        return
    end
    pcall(function()
        if not config.hasDifficulty then
            config.remote:FireServer(config.bossArg)
        elseif config.customRemote then
            local args = {}
            if config.customArgs then
                for _, arg in ipairs(config.customArgs) do
                    table.insert(args, arg)
                end
            end
            table.insert(args, difficulty)
            config.remote:FireServer(table.unpack(args))
        else
            config.remote:FireServer(config.bossArg, difficulty)
        end
    end)
    task.wait(0.5)
end

function BossSpawnerSea1.enable(bossType, difficulty)
    fireSea1Remote(BOSS_SPAWN_CONFIG_SEA1[bossType], difficulty)
end

function BossSpawnerSea1.disable(bossType, difficulty)
    fireSea1Remote(BOSS_SPAWN_CONFIG_SEA1[bossType], difficulty)
end

function BossSpawnerSea1.findBoss(bossType, difficulty)
    local config = BOSS_SPAWN_CONFIG_SEA1[bossType]
    if not config then
        return nil
    end
    local folder = NPCProvider.getFolder()
    if not folder then
        return nil
    end
    local name = config.npcName or (config.npcPrefix .. (difficulty or ""))
    local boss = folder:FindFirstChild(name)
    return (boss and NPCProvider.isAlive(boss)) and boss or nil
end

function BossSpawnerSea1.findBossAnyDifficulty(bossType)
    for _, diff in ipairs(DIFFICULTIES) do
        local boss = BossSpawnerSea1.findBoss(bossType, diff)
        if boss then
            return boss
        end
    end
    return BossSpawnerSea1.findBoss(bossType, nil)
end

function BossSpawnerSea1.getSelection()
    if AutoFarmState.selectedBSea1 then
        return Options["Select Boss Spawners"] and Options["Select Boss Spawners"].Value or nil
    end
    return nil
end

function BossSpawnerSea1.getDifficulty()
    return Options["Select Difficulty Boss Spawners"] and Options["Select Difficulty Boss Spawners"].Value or nil
end

function BossSpawnerSea1.getOtherBossesOnIsland(bossType, island)
    local others = {}
    for bt, config in pairs(BOSS_SPAWN_CONFIG_SEA1) do
        if bt ~= bossType and config.island == island then
            table.insert(others, bt)
        end
    end
    return others
end

function BossSpawnerSea1.disableAllActive(difficulty)
    SpawnState:forEach(function(bossType, isActive)
        if isActive and BOSS_SPAWN_CONFIG_SEA1[bossType] then
            if BOSS_SPAWN_CONFIG_SEA1[bossType].hasDifficulty and difficulty then
                pcall(function()
                    BossSpawnerSea1.disable(bossType, difficulty)
                end)
            else
                pcall(function()
                    BossSpawnerSea1.disable(bossType, nil)
                end)
            end
            SpawnState:set(bossType, false)
        end
    end)
end

function BossSpawnerSea1.onBossTypeChanged(newBossType)
    if not AutoFarmState.selectedBSea1 then
        return
    end
    local difficulty = BossSpawnerSea1.getDifficulty()
    if not newBossType then
        return
    end

    local newIsland = BOSS_SPAWN_CONFIG_SEA1[newBossType] and BOSS_SPAWN_CONFIG_SEA1[newBossType].island

    local oldBossType, oldIsland = nil, nil
    SpawnState:forEach(function(bt, isActive)
        if isActive and BOSS_SPAWN_CONFIG_SEA1[bt] and not oldBossType then
            oldBossType = bt
            oldIsland = BOSS_SPAWN_CONFIG_SEA1[bt].island
        end
    end)

    if oldBossType and oldIsland == newIsland then
        SpawnState:set(oldBossType, false)
    else
        BossSpawnerSea1.disableAllActive(difficulty)
    end
    AnchorState:clearFarm()
end

function BossSpawnerSea1.onDifficultyChanged(newDifficulty)
    if not AutoFarmState.selectedBSea1 then
        return
    end
    if newDifficulty == lastSea1Difficulty then
        return
    end

    if lastSea1Difficulty then
        SpawnState:forEach(function(bossType, isActive)
            if isActive and BOSS_SPAWN_CONFIG_SEA1[bossType] then
                if BOSS_SPAWN_CONFIG_SEA1[bossType].hasDifficulty then
                    pcall(function()
                        BossSpawnerSea1.disable(bossType, lastSea1Difficulty)
                    end)
                end
            end
        end)
        task.wait(0.3)
    end

    if newDifficulty then
        SpawnState:forEach(function(bossType, isActive)
            if isActive and BOSS_SPAWN_CONFIG_SEA1[bossType] then
                if BOSS_SPAWN_CONFIG_SEA1[bossType].hasDifficulty then
                    pcall(function()
                        BossSpawnerSea1.enable(bossType, newDifficulty)
                    end)
                end
            end
        end)
    end

    lastSea1Difficulty = newDifficulty
    AnchorState:clearFarm()
end

-- ============================================================
-- FARM STATE HELPERS
-- ============================================================
local function anyFarmActive()
    return AutoFarmState.selectedEnemies or AutoFarmState.everyEnemy or AutoFarmState.selectedOWB or
               AutoFarmState.everyOWB or AutoFarmState.selectedWB or AutoFarmState.everyWB or
               AutoFarmState.selectedBSea2 or AutoFarmState.selectedBSea1
end

local function getOWBSelection()
    if AutoFarmState.everyOWB then
        return "all"
    end
    if AutoFarmState.selectedOWB then
        return Options["Select Open World Bosses"] and Options["Select Open World Bosses"].Value or {}
    end
    return nil
end

local function getWBSelection()
    if AutoFarmState.everyWB then
        return "all"
    end
    if AutoFarmState.selectedWB then
        return Options["Select World Bosses"] and Options["Select World Bosses"].Value or {}
    end
    return nil
end

-- ============================================================
-- MAIN FARM LOOP
-- ============================================================
local function farmLoop(ctrl)
    SpawnState:clear()
    AnchorState:clear()
    lastTeleportedIsland = nil

    local styleValue = Options.Style and Options.Style.Value
    if styleValue then
        if isToolEquipped() then
            lastStyle = styleValue
        else
            Combat.equipStyle()
        end
    end

    task.wait(0.5)

    local owbWasActive = false
    local wbWasActive = false
    local bsea2WasActive = false
    local bsea1WasActive = false

    local function attackAndTrack(npc, isBoss, wasActiveFlag, setActive)
        Combat.attackLoop(npc, isBoss, ctrl)
        if not NPCProvider.isAlive(npc) then
            AnchorState:save()
            AnchorState:clearFarm()
        end
    end

    while not ctrl:wasInterrupted() do
        if not anyFarmActive() then
            break
        end

        local owbSel = getOWBSelection()
        local wbSel = getWBSelection()
        local bsea2Sel = BossSpawnerSea2.getSelection()
        local sea2Diff = BossSpawnerSea2.getDifficulty()
        local bsea1Sel = BossSpawnerSea1.getSelection()
        local sea1Diff = BossSpawnerSea1.getDifficulty()

        local owbFound = false
        local wbFound = false
        local bsea2Found = false
        local bsea1Found = false

        -- ================================================
        -- Priority 0: Sea 2 Boss Spawners
        -- ================================================
        if bsea2Sel and sea2Diff then
            local selectedBosses = type(bsea2Sel) == "string" and {
                [bsea2Sel] = true
            } or bsea2Sel

            -- Enable/disable spawns as needed
            for bossType in pairs(BOSS_SPAWN_CONFIG_SEA2) do
                local key = bossType .. "_" .. sea2Diff
                local isActive = SpawnState:get(key)
                local isSelected = selectedBosses[bossType]

                if isSelected and not isActive then
                    -- Attack any existing boss before enabling
                    for _, diff in ipairs(DIFFICULTIES) do
                        if ctrl:wasInterrupted() then
                            break
                        end
                        local existing = BossSpawnerSea2.findBoss(bossType, diff)
                        if existing then
                            attackAndTrack(existing, true, bsea2WasActive, nil)
                        end
                    end
                    BossSpawnerSea2.enable(bossType, sea2Diff)
                    SpawnState:set(key, true)
                elseif not isSelected and isActive then
                    BossSpawnerSea2.disable(bossType, sea2Diff)
                    SpawnState:set(key, false)
                end
            end

            -- Attack active spawned bosses
            for bossType in pairs(BOSS_SPAWN_CONFIG_SEA2) do
                if ctrl:wasInterrupted() then
                    break
                end
                if not AutoFarmState.selectedBSea2 then
                    break
                end
                if selectedBosses[bossType] then
                    local boss = BossSpawnerSea2.findBoss(bossType, sea2Diff)
                    if boss then
                        bsea2Found = true
                        if not bsea2WasActive then
                            AnchorState:clear()
                            bsea2WasActive = true
                        end
                        attackAndTrack(boss, true, bsea2WasActive, nil)
                    end
                end
            end

            if not bsea2Found and bsea2WasActive then
                bsea2WasActive = false
                AnchorState:save()
                AnchorState:clearFarm()
            end
        else
            bsea2WasActive = false
            if sea2Diff then
                BossSpawnerSea2.disableAllActive(sea2Diff)
            end
        end

        -- ================================================
        -- Priority 0.5: Sea 1 Boss Spawners
        -- ================================================
        if bsea1Sel then
            local selectedBosses = type(bsea1Sel) == "string" and {
                [bsea1Sel] = true
            } or bsea1Sel

            for bossType in pairs(BOSS_SPAWN_CONFIG_SEA1) do
                local isActive = SpawnState:get(bossType)
                local isSelected = selectedBosses[bossType]
                local config = BOSS_SPAWN_CONFIG_SEA1[bossType]

                if isSelected and not isActive then
                    -- Attack any existing boss before enabling
                    local existing = BossSpawnerSea1.findBossAnyDifficulty(bossType)
                    if existing then
                        attackAndTrack(existing, true, bsea1WasActive, nil)
                    end

                    -- Also attack other bosses on same island
                    if not ctrl:wasInterrupted() then
                        for _, otherBT in ipairs(BossSpawnerSea1.getOtherBossesOnIsland(bossType, config.island)) do
                            if ctrl:wasInterrupted() then
                                break
                            end
                            local other = BossSpawnerSea1.findBossAnyDifficulty(otherBT)
                            if other then
                                attackAndTrack(other, true, bsea1WasActive, nil)
                            end
                        end
                    end

                    -- Enable spawn
                    if config.hasDifficulty and sea1Diff then
                        BossSpawnerSea1.enable(bossType, sea1Diff)
                    else
                        BossSpawnerSea1.enable(bossType, nil)
                    end
                    SpawnState:set(bossType, true)

                elseif not isSelected and isActive then
                    if config.hasDifficulty and sea1Diff then
                        BossSpawnerSea1.disable(bossType, sea1Diff)
                    else
                        BossSpawnerSea1.disable(bossType, nil)
                    end
                    SpawnState:set(bossType, false)
                end
            end

            -- Attack active spawned bosses
            for bossType in pairs(BOSS_SPAWN_CONFIG_SEA1) do
                if ctrl:wasInterrupted() then
                    break
                end
                if not AutoFarmState.selectedBSea1 then
                    break
                end
                if selectedBosses[bossType] then
                    local config = BOSS_SPAWN_CONFIG_SEA1[bossType]
                    local boss = (config.hasDifficulty and sea1Diff) and BossSpawnerSea1.findBoss(bossType, sea1Diff) or
                                     BossSpawnerSea1.findBoss(bossType, nil)
                    if boss then
                        bsea1Found = true
                        if not bsea1WasActive then
                            AnchorState:clear()
                            bsea1WasActive = true
                        end
                        attackAndTrack(boss, true, bsea1WasActive, nil)
                    end
                end
            end

            if not bsea1Found and bsea1WasActive then
                bsea1WasActive = false
                AnchorState:save()
                AnchorState:clearFarm()
            end
        else
            bsea1WasActive = false
            BossSpawnerSea1.disableAllActive(sea1Diff)
        end

        -- ================================================
        -- Priority 1: World Bosses
        -- ================================================
        if wbSel then
            local wbs = NPCProvider.queryWB(wbSel)
            if #wbs > 0 then
                wbFound = true
                if not wbWasActive then
                    AnchorState:clear()
                    wbWasActive = true
                end
                for _, npc in ipairs(wbs) do
                    if ctrl:wasInterrupted() then
                        break
                    end
                    if not anyFarmActive() then
                        break
                    end
                    if NPCProvider.isAlive(npc) then
                        attackAndTrack(npc, true, wbWasActive, nil)
                    end
                end
            else
                if wbWasActive then
                    wbWasActive = false
                    AnchorState:save()
                    AnchorState:clearFarm()
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
                    AnchorState:clear()
                    owbWasActive = true
                end
                for _, npc in ipairs(owbs) do
                    if ctrl:wasInterrupted() then
                        break
                    end
                    if not anyFarmActive() then
                        break
                    end
                    if NPCProvider.isAlive(npc) then
                        attackAndTrack(npc, true, owbWasActive, nil)
                    end
                end
            else
                if owbWasActive then
                    owbWasActive = false
                    AnchorState:save()
                    AnchorState:clearFarm()
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
                    if enabled then
                        table.insert(selectedTypes, prefix)
                    end
                end
                table.sort(selectedTypes)
            else
                selectedTypes = NPCProvider.getNormalEnemyTypes()
            end

            if #selectedTypes == 0 then
                Combat.stayAtAnchor()
                task.wait(1)
            else
                for _, prefix in ipairs(selectedTypes) do
                    if ctrl:wasInterrupted() then
                        break
                    end
                    if not (AutoFarmState.selectedEnemies or AutoFarmState.everyEnemy) then
                        break
                    end
                    if owbSel and #NPCProvider.queryOWB(owbSel) > 0 then
                        break
                    end
                    if wbSel and #NPCProvider.queryWB(wbSel) > 0 then
                        break
                    end

                    local npcsOfType = NPCProvider.queryNormal(function(p)
                        return p == prefix
                    end)
                    if #npcsOfType > 0 then
                        local ok0, cf0 = pcall(function()
                            return npcsOfType[1]:GetPivot()
                        end)
                        if ok0 and NPCProvider.isValidCFrame(cf0) then
                            AnchorState:setFarm(cf0)
                        end
                        for _, npc in ipairs(npcsOfType) do
                            if ctrl:wasInterrupted() then
                                break
                            end
                            if not (AutoFarmState.selectedEnemies or AutoFarmState.everyEnemy) then
                                break
                            end
                            if NPCProvider.isAlive(npc) then
                                attackAndTrack(npc, false, false, nil)
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
-- START / STOP FARM (Global)
-- ============================================================
local function startFarm()
    StyleWatchdog.start()
    farmCtrl:start(farmLoop)
end

local function stopFarm()
    StyleWatchdog.stop()
    farmCtrl:stop()
    AnchorState:clear()
    lastTeleportedIsland = nil

    local sea2Diff = BossSpawnerSea2.getDifficulty()
    BossSpawnerSea2.disableAllActive(sea2Diff)

    local sea1Diff = BossSpawnerSea1.getDifficulty()
    BossSpawnerSea1.disableAllActive(sea1Diff)

    SpawnState:clear()

    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if hum then
            hum.PlatformStand = false
        end
        if hrp then
            pcall(function()
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
            end)
        end
    end

    pcall(function()
        Workspace.Gravity = originalGravity
    end)
end

local function refreshFarm()
    if anyFarmActive() then
        startFarm()
    else
        stopFarm()
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    if anyFarmActive() then
        stopFarm()
    end
    lastStyle = nil
    AnchorState:clear()
    lastTeleportedIsland = nil
    if anyFarmActive() then
        task.wait(0.2)
        setFarmCollisionGhost(true)
        StyleWatchdog.start()
    end
end)

-- ============================================================
-- DUNGEON FARMING CONTROLLER
-- ============================================================

local DungeonController = {}

do

    local DUNGEON_NAME_MAP = {
        ["Double Dungeon"] = "DoubleDungeon",
        ["Shadow Dungeon"] = "CidDungeon",
        ["Rune Dungeon"] = "RuneDungeon",
        ["Boss Rush"] = "BossRush"
    }

    local DIFFICULTY_MAP = {
        Easy = "Easy",
        Medium = "Medium",
        Hard = "Hard",
        Extreme = "Extreme"
    }

    local state = {
        active = false,
        combatThread = nil,
        syncConn = nil,
        dungeon = nil,
        difficulty = "Easy"
    }

    local function isDungeonToggleEnabled()
        local O = Mahmut.Options
        if not O then
            return false
        end
        local toggle = O["Auto Farm Dungeon"]
        return toggle ~= nil and toggle.Value == true
    end

    local function setDungeonToggle(value)
        if value == nil then
            value = true
        end
        local O = Mahmut.Options
        if not O then
            return
        end
        local toggle = O["Auto Farm Dungeon"]
        if toggle and toggle.SetValue then
            pcall(function()
                toggle:SetValue(value)
            end)
        end
    end

    local function getDungeonArg()
        local O = Mahmut.Options
        local v = O and O["Select Dungeon"] and O["Select Dungeon"].Value
        local display
        if type(v) == "string" and v ~= "" then
            display = v
            state.dungeon = v
        else
            display = state.dungeon
        end
        return display and DUNGEON_NAME_MAP[display] or nil, display
    end

    local function getDifficultyArg()
        local O = Mahmut.Options
        local v = O and O["Select Difficulty Dungeon"] and O["Select Difficulty Dungeon"].Value
        local display = (type(v) == "string" and v ~= "") and v or state.difficulty
        return display and DIFFICULTY_MAP[display] or "Easy"
    end

    local function combatLoop()
        Combat.equipStyle()
        while state.active do
            local folder = workspace:FindFirstChild("NPCs")
            if folder then
                for _, npc in ipairs(folder:GetChildren()) do
                    if not state.active then
                        break
                    end
                    if npc:IsA("Model") then
                        local hum = npc:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            local ok, npcCF = pcall(function()
                                return npc:GetPivot()
                            end)
                            if ok and NPCProvider.isValidCFrame(npcCF) then
                                local method, distY = getCombatOptions()
                                local targetCF = getTargetCFrame(npcCF, method, distY)
                                local char = LocalPlayer.Character
                                if char then
                                    local hrp = char:FindFirstChild("HumanoidRootPart")
                                    if hrp then
                                        pcall(function()
                                            hrp.AssemblyLinearVelocity = Vector3.zero
                                            hrp.AssemblyAngularVelocity = Vector3.zero
                                            hrp.CFrame = targetCF
                                        end)
                                    end
                                end
                            end
                            pcall(function()
                                RequestHit:FireServer(npc)
                            end)
                            Combat.useSkill(true)
                        end
                    end
                end
            end
            task.wait(0.05)
        end
    end

    local function stopCombat()
        state.active = false
        if state.combatThread then
            pcall(task.cancel, state.combatThread)
            state.combatThread = nil
        end
        pcall(function()
            Workspace.Gravity = originalGravity
        end)
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.PlatformStand = false
            end
        end
    end

    local function startCombat()
        stopCombat()
        state.active = true
        pcall(function()
            Workspace.Gravity = 0
        end)
        state.combatThread = task.spawn(combatLoop)
    end

    local function setupListener(difficultyArg)
        if state.syncConn then
            pcall(function()
                state.syncConn:Disconnect()
            end)
            state.syncConn = nil
        end

        if not DungeonWaveSync then
            return
        end

        task.spawn(function()
            task.wait(1)
            if DungeonWaveVote and state.active then
                pcall(function()
                    DungeonWaveVote:FireServer(difficultyArg)
                end)
            end
        end)

        startCombat()

        state.syncConn = DungeonWaveSync.OnClientEvent:Connect(function(data)
            if not state.active then
                return
            end
            local phase = data.phase

            if phase == "active" then
                if not state.combatThread or coroutine.status(state.combatThread) == "dead" then
                    startCombat()
                end
            elseif phase == "cleared" then
                task.spawn(function()
                    task.wait(1)
                    if not state.active then
                        return
                    end
                    if DungeonWaveReplayVote then
                        pcall(function()
                            DungeonWaveReplayVote:FireServer("sponsor")
                        end)
                    end
                    task.wait(1)
                    if not state.active then
                        return
                    end
                    if DungeonWaveVote then
                        pcall(function()
                            DungeonWaveVote:FireServer(getDifficultyArg())
                        end)
                    end
                end)
            end
        end)
    end

    function DungeonController.isInsideDungeon()
        local ids = {
            [123955125827131] = true,
            [75159314259063] = true,
            [99684056491472] = true,
            [96767841099256] = true,
            [138368689293913] = true
        }
        return ids[game.PlaceId] == true
    end

    function DungeonController.start()
        local O = Mahmut.Options
        if O then
            local currentDungeon = O["Select Dungeon"] and O["Select Dungeon"].Value
            local currentDiff = O["Select Difficulty Dungeon"] and O["Select Difficulty Dungeon"].Value
            if type(currentDungeon) == "string" and currentDungeon ~= "" then
                state.dungeon = currentDungeon
            end
            if type(currentDiff) == "string" and currentDiff ~= "" then
                state.difficulty = currentDiff
            end
        end
        state.active = true

        local dungeonArg, _ = getDungeonArg()
        local diffArg = getDifficultyArg()

        if not dungeonArg then
            state.active = false
            task.spawn(function()
                task.wait(1)
                if isDungeonToggleEnabled() then
                    DungeonController.refresh()
                end
            end)
            return
        end

        if DungeonController.isInsideDungeon() then
            setupListener(diffArg)
        else
            if not RequestDungeonPortal then
                state.active = false
                setDungeonToggle(false)
                return
            end
            pcall(function()
                RequestDungeonPortal:FireServer(dungeonArg)
            end)
            task.spawn(function()
                task.wait(3)
                if not state.active then
                    return
                end
                if StartDungeonPortal then
                    pcall(function()
                        StartDungeonPortal:FireServer()
                    end)
                else
                    state.active = false
                    setDungeonToggle(false)
                end
            end)
        end
    end

    function DungeonController.refresh()
        if isDungeonToggleEnabled() then
            DungeonController.start()
        else
            DungeonController.stop()
        end
    end

    function DungeonController.syncLoadedState()
        task.spawn(function()
            local timeout = tick() + 10

            while tick() < timeout do
                local O = Mahmut.Options
                if O then
                    local dungeonOpt = O["Select Dungeon"]
                    local diffOpt = O["Select Difficulty Dungeon"]
                    local toggleObj = O["Auto Farm Dungeon"]

                    local dungeonVal = dungeonOpt and dungeonOpt.Value
                    local diffVal = diffOpt and diffOpt.Value
                    local toggleVal = toggleObj and toggleObj.Value
                    local dungeonReady = type(dungeonVal) == "string" and dungeonVal ~= ""
                    local diffReady = type(diffVal) == "string" and diffVal ~= ""
                    local toggleReady = toggleObj ~= nil

                    if dungeonReady and diffReady and toggleReady then
                        state.dungeon = dungeonVal
                        state.difficulty = diffVal

                        if toggleVal == true then
                            DungeonController.stop()
                            task.wait(0.3)
                            DungeonController.start()
                        end
                        return
                    end
                end

                task.wait(0.2)
            end

            warn("[DungeonController] syncLoadedState timeout")
        end)
    end

    function DungeonController.stop()
        stopCombat()
        if state.syncConn then
            pcall(function()
                state.syncConn:Disconnect()
            end)
        end
        state.syncConn = nil
    end

    function DungeonController.onDungeonChanged(v)
        if type(v) == "string" and v ~= "" then
            state.dungeon = v
            local O = Mahmut.Options
            local toggle = O and O["Auto Farm Dungeon"]
            if toggle and toggle.Value == true then
                DungeonController.refresh()
            end
        end
    end

    function DungeonController.onDifficultyChanged(v)
        if type(v) == "string" and v ~= "" then
            state.difficulty = v
            DungeonController.refresh()
        end
    end

    function DungeonController.tryAutoResume()
        task.spawn(function()
            task.wait(1)
            local O = Mahmut.Options
            if O then
                local savedDungeon = O["Select Dungeon"] and O["Select Dungeon"].Value
                local savedDiff = O["Select Difficulty Dungeon"] and O["Select Difficulty Dungeon"].Value
                if type(savedDungeon) == "string" and savedDungeon ~= "" then
                    state.dungeon = savedDungeon
                end
                if type(savedDiff) == "string" and savedDiff ~= "" then
                    state.difficulty = savedDiff
                end
            end

            local dungeonArg = getDungeonArg()
            if dungeonArg then
                state.active = true
                setDungeonToggle(true)
                setupListener(getDifficultyArg())
            end
        end)
    end
end

-- ============================================================
-- INFINITY TOWER / CRYSTAL DEFENSE CONTROLLER
-- ============================================================

local InfinityTowerController = {}

do
    local state = {
        active = false,
        combatThread = nil,
        syncConn = nil,
        dungeonArg = "InfiniteTower" -- default
    }

    local function checkSea()
        local sea2PlaceId = 130167267952199
        if game.PlaceId == sea2PlaceId then
            return "CrystalDefense"
        else
            return "InfiniteTower"
        end
    end

    local function combatLoop()
        Combat.equipStyle()
        while state.active do
            local folder = workspace:FindFirstChild("NPCs")
            if folder then
                for _, npc in ipairs(folder:GetChildren()) do
                    if not state.active then
                        break
                    end
                    if npc:IsA("Model") then
                        local hum = npc:FindFirstChildOfClass("Humanoid")
                        if hum and hum.Health > 0 then
                            local ok, npcCF = pcall(function()
                                return npc:GetPivot()
                            end)
                            if ok and NPCProvider.isValidCFrame(npcCF) then
                                local method, distY = getCombatOptions()
                                local targetCF = getTargetCFrame(npcCF, method, distY)
                                local char = LocalPlayer.Character
                                if char then
                                    local hrp = char:FindFirstChild("HumanoidRootPart")
                                    if hrp then
                                        pcall(function()
                                            hrp.AssemblyLinearVelocity = Vector3.zero
                                            hrp.AssemblyAngularVelocity = Vector3.zero
                                            hrp.CFrame = targetCF
                                        end)
                                    end
                                end
                            end
                            pcall(function()
                                RequestHit:FireServer(npc)
                            end)
                            Combat.useSkill(true)
                        end
                    end
                end
            end
            task.wait(0.05)
        end
    end

    local function stopCombat()
        state.active = false
        if state.combatThread then
            pcall(task.cancel, state.combatThread)
            state.combatThread = nil
        end
        pcall(function()
            Workspace.Gravity = originalGravity
        end)
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.PlatformStand = false
            end
        end
    end

    local function startCombat()
        stopCombat()
        state.active = true
        pcall(function()
            Workspace.Gravity = 0
        end)
        state.combatThread = task.spawn(combatLoop)
    end

    local function setupListener()
        if state.syncConn then
            pcall(function()
                state.syncConn:Disconnect()
            end)
            state.syncConn = nil
        end

        if not DungeonWaveSync then
            warn("[Tower] DungeonWaveSync nil!")
            return
        end
        task.spawn(function()
            task.wait(1)
            if DungeonWaveVote and state.active then
                pcall(function()
                    DungeonWaveVote:FireServer("start")
                end)
            end
        end)

        startCombat()

        state.syncConn = DungeonWaveSync.OnClientEvent:Connect(function(data)

            if not state.active then
                return
            end
            local phase = data.phase
            if phase == "active" then
                if not state.combatThread or coroutine.status(state.combatThread) == "dead" then
                    startCombat()
                end
            elseif phase == "failed" then
                task.spawn(function()
                    task.wait(1)
                    if not state.active then
                        return
                    end
                    if DungeonWaveReplayVote then
                        pcall(function()
                            DungeonWaveReplayVote:FireServer("sponsor")
                        end)
                    end
                    task.wait(1)
                    if not state.active then
                        return
                    end
                    if DungeonWaveVote then
                        pcall(function()
                            DungeonWaveVote:FireServer("start")
                        end)
                    end
                end)
            end
        end)

    end

    function InfinityTowerController.isInsideTower()
        local ids = {
            [138368689293913] = true,
            [98826438856089] = true
        }
        return ids[game.PlaceId] == true
    end

    function InfinityTowerController.start()
        -- Simpan dungeonArg ke state SEBELUM teleport
        -- karena setelah teleport game.PlaceId berubah
        if not InfinityTowerController.isInsideTower() then
            state.dungeonArg = checkSea()
        end

        state.active = true

        if InfinityTowerController.isInsideTower() then
            setupListener()
        else
            if not RequestDungeonPortal then
                warn("[Tower] RequestDungeonPortal nil, abort")
                state.active = false
                return
            end
            pcall(function()
                RequestDungeonPortal:FireServer(state.dungeonArg)
            end)
            task.spawn(function()
                task.wait(3)
                if not state.active then
                    return
                end
                if StartDungeonPortal then
                    pcall(function()
                        StartDungeonPortal:FireServer()
                    end)
                end
                task.wait(2)
                if state.active then
                    setupListener()
                end
            end)
        end
    end

    function InfinityTowerController.stop()
        stopCombat()
        if state.syncConn then
            pcall(function()
                state.syncConn:Disconnect()
            end)
        end
        state.syncConn = nil
    end

    -- Dipanggil hanya dari input callback, eksekusi sekali
    function InfinityTowerController.onFloorChanged(v)
        local n = tonumber(v)
        if n and n > 0 then
            if SetAutoTowerReset then
                pcall(function()
                    SetAutoTowerReset:FireServer(n)
                end)
            else
                warn("[Tower] SetAutoTowerReset remote not found")
            end
        end
    end

    function InfinityTowerController.syncLoadedState()
        task.spawn(function()
            local timeout = tick() + 10
            while tick() < timeout do
                local O = Mahmut.Options
                if O then
                    -- key harus sama persis dengan AddToggle
                    local toggleObj = O["Auto Farm Infinity Tower/Crystal Defense"]
                    if toggleObj ~= nil then
                        if toggleObj.Value == true then
                            InfinityTowerController.stop()
                            task.wait(0.3)
                            InfinityTowerController.start()
                        end
                        return
                    end
                end
                task.wait(0.2)
            end
            warn("[InfinityTowerController] syncLoadedState timeout")
        end)
    end
end

-- ============================================================
-- TAB: FARMING SETTINGS
-- ============================================================
do
    local section = Tabs.FarmingSettings:AddSection("Combat Settings")

    section:AddDropdown("Style", {
        Title = "Combat Style",
        Values = {"Melee", "Sword", "Power"},
        Multi = false,
        Default = nil,
        Callback = function(v)
            lastStyle = nil  -- reset dulu biar forceEquip jalan
            StyleWatchdog.onStyleChanged(v)
            -- update langsung kalau farming aktif
            if farmingActive then
                Combat.equipStyle()
            end
        end
    })

    section:AddDropdown("SelectSkills", {
        Title = "Select Skills",
        Values = {"Z", "X", "C", "V", "F"},
        Multi = true,
        Default = {},
        Callback = function(v)
            -- v = table {Z=true, X=false, ...}
            -- reset rotation index setiap kali selection berubah
            SkillState.rotIdx = 1
        end
    })

    section:AddToggle("Auto Use Skills For All Mobs", {
        Title = "Auto Use Skills For All Mobs",
        Default = false,
        Callback = function(v)
            SkillState.autoAll = v
            if v and SkillState.bossOnly then
                -- matikan bossOnly kalau autoAll dinyalakan
                SkillState.bossOnly = false
                local t = Mahmut.Options["Use Skill Only Boss"]
                if t then t:SetValue(false) end
            end
            SkillState.rotIdx = 1
        end
    })

    section:AddToggle("Use Skill Only Boss", {
        Title = "Use Skill Only Boss",
        Default = false,
        Callback = function(v)
            SkillState.bossOnly = v
            if v and SkillState.autoAll then
                -- matikan autoAll kalau bossOnly dinyalakan
                SkillState.autoAll = false
                local t = Mahmut.Options["Auto Use Skills For All Mobs"]
                if t then t:SetValue(false) end
            end
            SkillState.rotIdx = 1
        end
    })

    local syncing = false
    local DFYInput

    local DFYSlider = section:AddSlider("Distance Farm Y", {
        Title = "Distance Farm Y",
        Description = "Distance dari NPC. Jauh = NPC sulit hit kita.",
        Default = 5,
        Min = 0,
        Max = 10,
        Rounding = 1,
        Callback = function(val)
            if syncing then return end
            syncing = true
            if DFYInput then
                DFYInput:SetValue(tostring(val))
            end
            syncing = false
        end
    })

    DFYInput = section:AddInput("DistanceFarmYInput", {
        Title = "Distance Farm Y Input",
        Default = nil,
        Placeholder = "0-10",
        Numeric = true,
        Finished = true,
        Callback = function(val)
            local n = math.clamp(tonumber(val) or 5, 0, 10)
            if syncing then return end
            syncing = true
            DFYSlider:SetValue(n)
            syncing = false
        end
    })

    section:AddDropdown("Select Method Farm", {
        Title = "Select Method Farm",
        Values = {"Behind", "Above", "Under"},
        Multi = false,
        Default = "Behind",
        Callback = function(v)
            -- tidak perlu restart farm, getCombatOptions() baca real-time
            -- tapi bisa log untuk debug
            -- print("[FarmSettings] Method changed:", v)
        end
    })
end

-- ============================================================
-- TAB: FARMING
-- ============================================================
do
    -- Normal Enemies
    local sectionEnemies = Tabs.Farming:AddSection("Select Enemies To Farm")

    sectionEnemies:AddDropdown("Select Enemies", {
        Title = "Select Enemies",
        Values = NPCProvider.getNormalEnemyTypes(),
        Multi = true,
        Default = {}
    })

    sectionEnemies:AddToggle("Auto Farm Selected Enemies", {
        Title = "Auto Farm Selected Enemies",
        Default = false,
        Callback = function(v)
            AutoFarmState.selectedEnemies = v
            if v and AutoFarmState.everyEnemy then
                AutoFarmState.everyEnemy = false
                local t = Mahmut.Options["Auto Farm Every Enemies"]
                if t then
                    t:SetValue(false)
                end
            end
            refreshFarm()
        end

    })

    sectionEnemies:AddToggle("Auto Farm Every Enemies", {
        Title = "Auto Farm Every Enemies",
        Default = false,
        Callback = function(v)
            AutoFarmState.everyEnemy = v
            if v and AutoFarmState.selectedEnemies then
                AutoFarmState.selectedEnemies = false
                local t = Mahmut.Options["Auto Farm Selected Enemies"]
                if t then
                    t:SetValue(false)
                end
            end
            refreshFarm()
        end

    })

    -- Open World Bosses
    local sectionOWB = Tabs.Farming:AddSection("Select Open World Bosses To Farm")

    sectionOWB:AddDropdown("Select Open World Bosses", {
        Title = "Select Open World Bosses",
        Values = {"Vampire King", "Solo Hunter", "Limitless Sorcerer", "Cursed Vessel", "Cursed King", "Manipulator",
                  "Yamato", "Strongest Shinobi"},
        Multi = true,
        Default = {}
    })

    sectionOWB:AddToggle("Auto Farm Selected Open World Bosses", {
        Title = "Auto Farm Selected Open World Bosses",
        Default = false,
        Callback = function(v)
            AutoFarmState.selectedOWB = v
            if v and AutoFarmState.everyOWB then
                AutoFarmState.everyOWB = false
                local t = Mahmut.Options["Auto Farm Every Open World Bosses"]
                if t then
                    t:SetValue(false)
                end
            end
            refreshFarm()
        end

    })

    sectionOWB:AddToggle("Auto Farm Every Open World Bosses", {
        Title = "Auto Farm Every Open World Bosses",
        Default = false,
        Callback = function(v)
            AutoFarmState.everyOWB = v
            if v and AutoFarmState.selectedOWB then
                AutoFarmState.selectedOWB = false
                local t = Mahmut.Options["Auto Farm Selected Open World Bosses"]
                if t then
                    t:SetValue(false)
                end
            end
            refreshFarm()
        end

    })

    -- World Bosses (Sea 2)
    local sectionWB = Tabs.Farming:AddSection("Select World Bosses To Farm (Sea 2 Only)")

    sectionWB:AddDropdown("Select World Bosses", {
        Title = "Select World Bosses",
        Values = {"Sun God", "Cosmic Being"},
        Multi = true,
        Default = {}
    })

    sectionWB:AddToggle("Auto Farm Selected World Bosses", {
        Title = "Auto Farm Selected World Bosses",
        Default = false,
        Callback = function(v)
            AutoFarmState.selectedWB = v
            if v and AutoFarmState.everyWB then
                AutoFarmState.everyWB = false
                local t = Mahmut.Options["Auto Farm Every World Bosses"]
                if t then
                    t:SetValue(false)
                end
            end
            refreshFarm()
        end

    })

    sectionWB:AddToggle("Auto Farm Every World Bosses", {
        Title = "Auto Farm Every World Bosses",
        Default = false,
        Callback = function(v)
            AutoFarmState.everyWB = v
            if v and AutoFarmState.selectedWB then
                AutoFarmState.selectedWB = false
                local t = Mahmut.Options["Auto Farm Selected World Bosses"]
                if t then
                    t:SetValue(false)
                end
            end
            refreshFarm()
        end

    })

    -- Boss Spawners Sea 1
    local sectionBS1 = Tabs.Farming:AddSection("Select Boss Spawners To Farm (Sea 1 Only)")

    sectionBS1:AddDropdown("Select Boss Spawners", {
        Title = "Select Boss Spawners",
        Values = {"Strongest in History", "Strongest of Today", "Knight", "Qin Shi", "Soul Reaper", "King of Heroes",
                  "Corrupted Knight", "Blessed Maiden", "Moon Slayer", "Ice Queen", "Demon Lord", "Demon King",
                  "True Manipulator"},
        Multi = false,
        Default = nil,
        Callback = function(v)
            BossSpawnerSea1.onBossTypeChanged(v)
        end
    })

    sectionBS1:AddDropdown("Select Difficulty Boss Spawners", {
        Title = "Select Difficulty Boss Spawners",
        Values = {"Normal", "Medium", "Hard", "Extreme"},
        Multi = false,
        Default = nil,
        Callback = function(v)
            BossSpawnerSea1.onDifficultyChanged(v)
        end
    })

    sectionBS1:AddToggle("Auto Farm Selected Boss Spawners", {
        Title = "Auto Farm Selected Boss Spawners",
        Default = false,
        Callback = function(v)
            AutoFarmState.selectedBSea1 = v
            if v then
                lastSea1Difficulty = BossSpawnerSea1.getDifficulty()
            else
                BossSpawnerSea1.disableAllActive(BossSpawnerSea1.getDifficulty())
            end
            refreshFarm()
        end
    })

    -- Boss Spawners Sea 2
    local sectionBS2 = Tabs.Farming:AddSection("Select Boss Spawners To Farm (Sea 2 Only)")

    sectionBS2:AddDropdown("Select Boss Spawners 2", {
        Title = "Select Boss Spawners 2",
        Values = {"The World", "Spirit Warrior"},
        Multi = false,
        Default = nil,
        Callback = function(v)
            BossSpawnerSea2.onBossTypeChanged(v)
        end
    })

    sectionBS2:AddDropdown("Select Difficulty Boss Spawners 2", {
        Title = "Select Difficulty Boss Spawners 2",
        Values = {"Normal", "Medium", "Hard", "Extreme"},
        Multi = false,
        Default = nil,
        Callback = function(v)
            BossSpawnerSea2.onDifficultyChanged(v)
        end
    })

    sectionBS2:AddToggle("Auto Farm Selected Boss Spawners 2", {
        Title = "Auto Farm Selected Boss Spawners 2",
        Default = false,
        Callback = function(v)
            AutoFarmState.selectedBSea2 = v
            if v then
                lastSea2Difficulty = BossSpawnerSea2.getDifficulty()
            else
                BossSpawnerSea2.disableAllActive(BossSpawnerSea2.getDifficulty())
            end
            refreshFarm()
        end
    })
end

-- ============================================================
-- TAB: DUNGEON
-- ============================================================
do
    local section = Tabs.Dungeon:AddSection("Dungeon/Boss Rush")

    section:AddDropdown("Select Dungeon", {
        Title = "Select Dungeon",
        Values = {"Double Dungeon", "Shadow Dungeon", "Rune Dungeon", "Boss Rush"},
        Multi = false,
        Default = nil,
        Callback = DungeonController.onDungeonChanged
    })

    section:AddDropdown("Select Difficulty Dungeon", {
        Title = "Select Difficulty Dungeon",
        Values = {"Easy", "Medium", "Hard", "Extreme"},
        Multi = false,
        Default = nil,
        Callback = DungeonController.onDifficultyChanged
    })

    section:AddToggle("Auto Farm Dungeon", {
        Title = "Auto Farm Dungeon",
        Default = false,
        Callback = function(v)
            if v then
                DungeonController.start()
            else
                DungeonController.stop()
            end
        end
    })

    if DungeonController.isInsideDungeon() then
        DungeonController.tryAutoResume()
    end

    local section2 = Tabs.Dungeon:AddSection("Infinity Tower/Crystal Defense")

    section2:AddInput("Select Floor to Restart", {
        Title = "Select Floor to Restart",
        Default = nil,
        Placeholder = "e.g. 50",
        Numeric = true,
        Finished = true,
        Callback = InfinityTowerController.onFloorChanged
    })

    section2:AddToggle("Auto Farm Infinity Tower/Crystal Defense", {
        Title = "Auto Farm Infinity Tower/Crystal Defense",
        Default = false,
        Callback = function(v)
            if v then
                InfinityTowerController.start()
            else
                InfinityTowerController.stop()
            end
        end
    })

end

-- ============================================================
-- TAB: SETTINGS + SAVE MANAGER
-- ============================================================

SaveManager:SetLibrary(Mahmut)
InterfaceManager:SetLibrary(Mahmut)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("Mahmut-Hub")
SaveManager:SetFolder("Mahmut-Hub/SailorPiece")

pcall(function()
    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
end)
pcall(function()
    SaveManager:BuildConfigSection(Tabs.Settings)
end)

Window:SelectTab(1)

Mahmut:Notify({
    Title = "Mahmut-Hub | Sailor Piece",
    Content = "Script loaded successfully!",
    Duration = 8
})

-- Auto load/save config
local configPath = "Mahmut-Hub/SailorPiece/settings/default.json"
if isfile(configPath) then
    pcall(function()
        SaveManager:Load("default")
    end)
else
    pcall(function()
        SaveManager:Save("default")
    end)
end
pcall(function()
    SaveManager:SetAutoloadConfig("default")
end)

task.spawn(function()
    while true do
        task.wait(5)
        pcall(function()
            SaveManager:Save("default")
        end)
    end
end)

-- Anti-AFK heartbeat
task.spawn(function()
    while true do
        task.wait(30)
        if farmingActive then
            pcall(function()
                ReplicatedStorage.Remotes.AntiAFKHeartbeat:FireServer()
            end)
        end
    end
end)
