-- ============================================================
-- MAHMUT-HUB | Sailor Piece
-- ============================================================
local Mahmut = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Mahmut:CreateWindow({
    Title      = "Mahmut-Hub | Sailor Piece ([🔥Huge Update⚔️] Sailor Piece)",
    SubTitle   = "by mahmut",
    TabWidth   = 160,
    Size       = UDim2.fromOffset(580, 460),
    Acrylic    = true,
    Theme      = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl,
})

local Tabs = {
    FarmingSettings = Window:AddTab({ Title = "Farming Settings", Icon = "cog"   }),
    Farming         = Window:AddTab({ Title = "Farming",          Icon = "swords" }),
    Dungeon         = Window:AddTab({ Title = "Dungeon",          Icon = "sword"  }),
    Settings        = Window:AddTab({ Title = "Settings",         Icon = "disc"   }),
}

local Options = Mahmut.Options

-- ============================================================
-- SERVICES
-- ============================================================
local Players        = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VIM            = game:GetService("VirtualInputManager")
local VirtualUser    = game:GetService("VirtualUser")
local Workspace      = game:GetService("Workspace")
local LocalPlayer    = Players.LocalPlayer

-- ============================================================
-- HELPERS
-- ============================================================
local function safeWait(parent, ...)
    local current = parent
    local ok, result = pcall(function()
        for _, name in ipairs({...}) do
            current = current:WaitForChild(name)
        end
        return current
    end)
    return ok and result or nil
end

-- ============================================================
-- REMOTES
-- ============================================================
local RequestHit     = safeWait(ReplicatedStorage, "CombatSystem",  "Remotes",       "RequestHit")
local RequestAbility = safeWait(ReplicatedStorage, "AbilitySystem", "Remotes",       "RequestAbility")

local TeleportToPortal             = safeWait(ReplicatedStorage, "Remotes",       "TeleportToPortal")
local RequestAutoSpawnTheWorld     = safeWait(ReplicatedStorage, "RemoteEvents",  "RequestAutoSpawnTheWorld")
local RequestAutoSpawnSpiritWarrior= safeWait(ReplicatedStorage, "RemoteEvents",  "RequestAutoSpawnSpiritWarrior")
local RequestAutoSpawn             = safeWait(ReplicatedStorage, "Remotes",       "RequestAutoSpawn")
local RequestAutoSpawnStrongest    = safeWait(ReplicatedStorage, "Remotes",       "RequestAutoSpawnStrongest")
local RequestAutoSpawnRimuru       = safeWait(ReplicatedStorage, "RemoteEvents",  "RequestAutoSpawnRimuru")
local RequestAutoSpawnAnos         = safeWait(ReplicatedStorage, "Remotes",       "RequestAutoSpawnAnos")
local RequestAutoSpawnTrueAizen    = safeWait(ReplicatedStorage, "RemoteEvents",  "RequestAutoSpawnTrueAizen")
local RequestDungeonPortal         = safeWait(ReplicatedStorage, "Remotes",       "RequestDungeonPortal")
local StartDungeonPortal           = safeWait(ReplicatedStorage, "Remotes",       "StartDungeonPortal")
local DungeonWaveVote              = safeWait(ReplicatedStorage, "Remotes",       "DungeonWaveVote")
local DungeonWaveReplayVote        = safeWait(ReplicatedStorage, "Remotes",       "DungeonWaveReplayVote")
local DungeonWaveSync              = safeWait(ReplicatedStorage, "RemoteEvents",  "DungeonWaveSync")
local SetAutoTowerReset            = safeWait(ReplicatedStorage, "RemoteEvents",  "SetAutoTowerReset")

-- ============================================================
-- CONSTANTS
-- ============================================================
local ISLAND_PORTALS = {
    Starter      = "Starter",      Jungle     = "Jungle",
    Desert       = "Desert",       Snow       = "Snow",
    Sailor       = "Sailor",       Boss       = "Boss",
    Shibuya      = "Shibuya",      HollowIsland = "HollowIsland",
    Shinjuku     = "Shinjuku",     Slime      = "Slime",
    Academy      = "Academy",      Judgement  = "Judgement",
    SoulDominion = "SoulDominion", Ninja      = "Ninja",
    Lawless      = "Lawless",      StarterSea2= "StarterSea2",
    Punch        = "Punch",        Bizarre    = "Bizarre",
    BluePlanet   = "BluePlanet",   Slayer     = "Slayer",
}

local ENEMY_TO_ISLAND = {
    Thief = "Starter", Monkey = "Jungle", DessertBandit = "Desert",
    FrostRogue = "Snow", SoloHunter = "Sailor", JinwooBoss = "Sailor",
    VampireKing = "Sailor", AlucardBoss = "Sailor",
    SaberBoss = "Boss", QinShiBoss = "Boss", IchigoBoss = "Boss",
    GilgameshBoss = "Boss", BlessedMaidenBoss = "Boss", SaberAlterBoss = "Boss",
    MoonSlayerBoss = "Boss", IceQueenBoss = "Boss",
    Sorcerer = "Shibuya", CursedVessel = "Shibuya", YujiBoss = "Shibuya",
    LimitlessSorcerer = "Shibuya", GojoBoss = "Shibuya",
    CursedKing = "Shibuya", SukunaBoss = "Shibuya",
    Hollow = "HollowIsland", Manipulator = "HollowIsland", AizenBoss = "HollowIsland",
    Curse = "Shinjuku", StrongSorcerer = "Shinjuku",
    ["StrongestofTodayBoss_Normal"]   = "Shinjuku", ["StrongestofTodayBoss_Medium"]   = "Shinjuku",
    ["StrongestofTodayBoss_Hard"]     = "Shinjuku", ["StrongestofTodayBoss_Extreme"]  = "Shinjuku",
    ["StrongestinHistoryBoss_Normal"] = "Shinjuku", ["StrongestinHistoryBoss_Medium"] = "Shinjuku",
    ["StrongestinHistoryBoss_Hard"]   = "Shinjuku", ["StrongestinHistoryBoss_Extreme"]= "Shinjuku",
    Slime = "Slime",
    ["RimuruBoss_Normal"] = "Slime",  ["RimuruBoss_Medium"] = "Slime",
    ["RimuruBoss_Hard"]   = "Slime",  ["RimuruBoss_Extreme"]= "Slime",
    AcademyTeacher = "Academy",
    ["AnosBoss_Normal"] = "Academy",  ["AnosBoss_Medium"]  = "Academy",
    ["AnosBoss_Hard"]   = "Academy",  ["AnosBoss_Extreme"] = "Academy",
    Swordsman = "Judgement", Yamato = "Judgement", YamatoBoss = "Judgement",
    Quincy = "SoulDominion",
    ["TrueAizenBoss_Normal"] = "SoulDominion", ["TrueAizenBoss_Medium"]  = "SoulDominion",
    ["TrueAizenBoss_Hard"]   = "SoulDominion", ["TrueAizenBoss_Extreme"] = "SoulDominion",
    Ninja = "Ninja", StrongestShinobi = "Ninja", StrongestShinobiBoss = "Ninja",
    ArenaFighter = "Lawless", Delinquent = "StarterSea2", StrongFighter = "StarterSea2",
    FastNinja = "Punch", CosmicBeing = "Punch", ["CosmicBeingBoss_Normal"] = "Punch",
    StrongBandit = "Bizarre",
    ["TheWorldBoss_Normal"] = "Bizarre", ["TheWorldBoss_Medium"]  = "Bizarre",
    ["TheWorldBoss_Hard"]   = "Bizarre", ["TheWorldBoss_Extreme"] = "Bizarre",
    SpiritFighter = "BluePlanet",
    ["SpiritWarriorBoss_Normal"] = "BluePlanet", ["SpiritWarriorBoss_Medium"]  = "BluePlanet",
    ["SpiritWarriorBoss_Hard"]   = "BluePlanet", ["SpiritWarriorBoss_Extreme"] = "BluePlanet",
    StrongSlayer = "Slayer", SunGod = "Slayer", ["SunGodBoss_Normal"] = "Slayer",
}

-- Open-World Bosses: display name → workspace NPC name
local OWB_NAME_MAP = {
    ["Vampire King"]        = "AlucardBoss",
    ["Solo Hunter"]         = "JinwooBoss",
    ["Limitless Sorcerer"]  = "GojoBoss",
    ["Cursed Vessel"]       = "YujiBoss",
    ["Cursed King"]         = "SukunaBoss",
    ["Manipulator"]         = "AizenBoss",
    ["Yamato"]              = "YamatoBoss",
    ["Strongest Shinobi"]   = "StrongestShinobiBoss",
}

-- World Bosses (Sea 2): display name → workspace NPC name
local WB_NAME_MAP = {
    ["Cosmic Being"] = "CosmicBeingBoss_Normal",
    ["Sun God"]      = "SunGodBoss_Normal",
}

-- Reverse lookups (for exclusion during normal enemy query)
local OWB_REVERSE = {}
for _, v in pairs(OWB_NAME_MAP) do OWB_REVERSE[v] = true end

local WB_REVERSE = {}
for _, v in pairs(WB_NAME_MAP) do WB_REVERSE[v] = true end

local DIFFICULTIES = { "Normal", "Medium", "Hard", "Extreme" }

local SKILL_KEY_MAP = { Z=1, X=2, C=3, V=4, F=5 }
local SKILL_ORDER   = { "Z", "X", "C", "V", "F" }

local STYLE_KEYCODE = {
    Melee = Enum.KeyCode.One,
    Sword = Enum.KeyCode.Two,
    Power = Enum.KeyCode.Three,
}

-- Sea 2 Boss Spawner config
local BOSS_SPAWN_CONFIG_SEA2 = {
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

-- Sea 1 Boss Spawner config
local BOSS_SPAWN_CONFIG_SEA1 = {
    ["Knight"]             = { remote=RequestAutoSpawn,         bossArg="SaberBoss",          npcName="SaberBoss",          hasDifficulty=false, island="Boss"         },
    ["Qin Shi"]            = { remote=RequestAutoSpawn,         bossArg="QinShiBoss",         npcName="QinShiBoss",         hasDifficulty=false, island="Boss"         },
    ["Soul Reaper"]        = { remote=RequestAutoSpawn,         bossArg="IchigoBoss",         npcName="IchigoBoss",         hasDifficulty=false, island="Boss"         },
    ["King of Heroes"]     = { remote=RequestAutoSpawn,         bossArg="GilgameshBoss",      npcName="GilgameshBoss",      hasDifficulty=true,  island="Boss"         },
    ["Blessed Maiden"]     = { remote=RequestAutoSpawn,         bossArg="BlessedMaidenBoss",  npcName="BlessedMaidenBoss",  hasDifficulty=true,  island="Boss"         },
    ["Corrupted Knight"]   = { remote=RequestAutoSpawn,         bossArg="SaberAlterBoss",     npcName="SaberAlterBoss",     hasDifficulty=true,  island="Boss"         },
    ["Moon Slayer"]        = { remote=RequestAutoSpawn,         bossArg="MoonSlayerBoss",     npcName="MoonSlayerBoss",     hasDifficulty=true,  island="Boss"         },
    ["Ice Queen"]          = { remote=RequestAutoSpawn,         bossArg="IceQueenBoss",       npcName="IceQueenBoss",       hasDifficulty=true,  island="Boss"         },
    ["Demon Lord"]         = { remote=RequestAutoSpawnRimuru,   customRemote=true,                                          npcPrefix="RimuruBoss_",         hasDifficulty=true, island="Slime"        },
    ["Demon King"]         = { remote=RequestAutoSpawnAnos,     customRemote=true,  customArgs={"Anos"},                    npcPrefix="AnosBoss_",           hasDifficulty=true, island="Academy"      },
    ["True Manipulator"]   = { remote=RequestAutoSpawnTrueAizen,customRemote=true,                                          npcPrefix="TrueAizenBoss_",      hasDifficulty=true, island="SoulDominion" },
    ["Strongest of Today"] = { remote=RequestAutoSpawnStrongest,customRemote=true,  customArgs={"StrongestToday"},          npcPrefix="StrongestofTodayBoss_",   hasDifficulty=true, island="Shinjuku"  },
    ["Strongest in History"]={ remote=RequestAutoSpawnStrongest,customRemote=true,  customArgs={"StrongestHistory"},        npcPrefix="StrongestinHistoryBoss_", hasDifficulty=true, island="Shinjuku"  },
}

local DUNGEON_NAME_MAP = {
    ["Double Dungeon"] = "DoubleDungeon",
    ["Shadow Dungeon"] = "CidDungeon",
    ["Rune Dungeon"]   = "RuneDungeon",
    ["Boss Rush"]      = "BossRush",
}

local DUNGEON_PLACE_IDS = {
    [123955125827131] = true,
    [75159314259063]  = true,
    [99684056491472]  = true,
    [96767841099256]  = true,
    [138368689293913] = true,
}

local TOWER_PLACE_IDS = {
    [138368689293913] = true,
    [98826438856089]  = true,
}

-- ============================================================
-- GLOBAL STATE
-- ============================================================
local originalGravity     = Workspace.Gravity
local farmingActive       = false
local lastTeleportedIsland= nil
local lastStyle           = nil
local lastSea1Difficulty  = nil
local lastSea2Difficulty  = nil

-- Anchor: remembers last good farm position so we can return to it
local AnchorState = {
    farmCFrame = nil,
    lastCFrame = nil,
}
function AnchorState:save()
    local hrp = self:_hrp()
    if hrp then self.lastCFrame = hrp.CFrame end
end
function AnchorState:setFarm(cf) self.farmCFrame = cf end
function AnchorState:clearFarm()  self.farmCFrame = nil end
function AnchorState:get()        return self.farmCFrame or self.lastCFrame end
function AnchorState:clear()      self.farmCFrame = nil; self.lastCFrame = nil end
function AnchorState:_hrp()
    local c = LocalPlayer.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

-- Which farm modes are on
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

-- Skill rotation state
local SkillState = {
    autoAll  = false,
    bossOnly = false,
    rotIdx   = 1,
}

-- Tracks which spawner remotes are currently active
local SpawnState = {
    _active = {},
}
function SpawnState:set(k, v)     self._active[k] = v end
function SpawnState:get(k)        return self._active[k] end
function SpawnState:clear()       self._active = {} end
function SpawnState:forEach(fn)
    for k, v in pairs(self._active) do fn(k, v) end
end

-- ============================================================
-- GHOST MODE (disable collisions while farming)
-- ============================================================
local GhostMode = (function()
    local saved = {}

    local function set(enabled)
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")

        if enabled then
            saved = {}
            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("BasePart") then
                    saved[obj] = { CanCollide=obj.CanCollide, CanTouch=obj.CanTouch, CanQuery=obj.CanQuery }
                    pcall(function()
                        obj.CanCollide = false
                        obj.CanTouch   = false
                        obj.CanQuery   = false
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
            for part, props in pairs(saved) do
                if part and part.Parent then
                    pcall(function()
                        part.CanCollide = props.CanCollide
                        part.CanTouch   = props.CanTouch
                        part.CanQuery   = props.CanQuery
                    end)
                end
            end
            saved = {}
            pcall(function()
                if hum then
                    hum.PlatformStand = false
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
            end)
        end
    end

    return { enable = function() set(true) end, disable = function() set(false) end }
end)()

-- ============================================================
-- NPC PROVIDER
-- ============================================================
local NPCProvider = {}

function NPCProvider.folder()
    return workspace:FindFirstChild("NPCs")
end

function NPCProvider.isAlive(npc)
    local h = npc:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end

function NPCProvider.isValidCFrame(cf)
    if not cf then return false end
    local p = cf.Position
    return p.Magnitude >= 1
        and p.Y >= -10
        and math.abs(p.X) <= 5000
        and math.abs(p.Z) <= 5000
end

-- "SoloHunter3" → "SoloHunter", "SaberBoss" → nil (no trailing digits)
function NPCProvider.getPrefix(name)
    return tostring(name):match("^(.-)%d+$") or nil
end

-- true if NPC has no numeric suffix (i.e. it's a named boss, not a mob)
function NPCProvider.isBossNPC(npc)
    return NPCProvider.getPrefix(npc.Name) == nil
end

function NPCProvider.getIslandFromEnemy(name)
    if not name then return nil end
    if ENEMY_TO_ISLAND[name] then return ENEMY_TO_ISLAND[name] end
    local prefix = NPCProvider.getPrefix(name)
    return prefix and ENEMY_TO_ISLAND[prefix] or nil
end

local function shuffled(t)
    local copy = {table.unpack(t)}
    for i = #copy, 2, -1 do
        local j = math.random(1, i)
        copy[i], copy[j] = copy[j], copy[i]
    end
    return copy
end

-- Returns normal mobs (excludes named OWBs and WBs), optionally filtered
function NPCProvider.queryNormal(filter)
    local result = {}
    local f = NPCProvider.folder()
    if not f then return result end
    for _, npc in ipairs(f:GetChildren()) do
        if npc:IsA("Model") and NPCProvider.isAlive(npc) then
            local prefix = NPCProvider.getPrefix(npc.Name)
            if prefix and not OWB_REVERSE[npc.Name] and not WB_REVERSE[npc.Name] then
                if not filter or filter(prefix, npc) then
                    table.insert(result, npc)
                end
            end
        end
    end
    return shuffled(result)
end

-- Returns alive OWBs from the given selection map (or "all")
function NPCProvider.queryOWB(selectedMap)
    local result = {}
    local f = NPCProvider.folder()
    if not f then return result end
    for displayName, wsName in pairs(OWB_NAME_MAP) do
        if selectedMap == "all" or selectedMap[displayName] then
            local npc = f:FindFirstChild(wsName)
            if npc and NPCProvider.isAlive(npc) then
                table.insert(result, npc)
            end
        end
    end
    return result
end

-- Returns alive WBs from the given selection map (or "all")
function NPCProvider.queryWB(selectedMap)
    local result = {}
    local f = NPCProvider.folder()
    if not f then return result end
    for displayName, wsName in pairs(WB_NAME_MAP) do
        if selectedMap == "all" or selectedMap[displayName] then
            local npc = f:FindFirstChild(wsName)
            if npc and NPCProvider.isAlive(npc) then
                table.insert(result, npc)
            end
        end
    end
    return result
end

-- Returns sorted list of all normal enemy type prefixes currently spawned
function NPCProvider.getNormalEnemyTypes()
    local seen, types = {}, {}
    local f = NPCProvider.folder()
    if not f then return types end
    for _, npc in ipairs(f:GetChildren()) do
        if npc:IsA("Model") and not OWB_REVERSE[npc.Name] and not WB_REVERSE[npc.Name] then
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
-- COMBAT UTILITIES  (pure helpers, no state)
-- ============================================================
local function getCombatOptions()
    local method = Options["Select Method Farm"] and Options["Select Method Farm"].Value or "Behind"
    local distY  = tonumber(Options["Distance Farm Y"] and Options["Distance Farm Y"].Value) or 5
    return method, distY
end

local function getTargetCFrame(npcCF, method, distY)
    local pos = npcCF.Position
    if method == "Above" then
        return CFrame.lookAt(pos + Vector3.new(0, distY, 0), pos, Vector3.new(0, 0, -1))
    elseif method == "Under" then
        return CFrame.lookAt(pos + Vector3.new(0, -distY, 0), pos, Vector3.new(0, 0, 1))
    else -- Behind
        return CFrame.lookAt(pos + Vector3.new(0, 0, distY), pos, Vector3.new(0, 1, 0))
    end
end

local function isToolEquipped()
    local char = LocalPlayer.Character
    if not char then return false end
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Tool") then return true end
    end
    return false
end

local function teleportCharacter(targetCF, islandName)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if islandName and ISLAND_PORTALS[islandName] and islandName ~= lastTeleportedIsland then
        if TeleportToPortal then
            pcall(function() TeleportToPortal:FireServer(ISLAND_PORTALS[islandName]) end)
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
        pcall(function() hrp.Anchored = true end)
        task.wait(0.05)
        pcall(function() hrp.Anchored = false end)
    end
end

-- ============================================================
-- COMBAT  (style equip + skill use — called by CombatEngine)
-- ============================================================
local Combat = {}

function Combat.equipStyle()
    local styleValue = Options.Style and Options.Style.Value
    if not styleValue then return end

    local char = LocalPlayer.Character
    if not char then return end

    -- already correct
    if styleValue == lastStyle and (styleValue == "Melee" or isToolEquipped()) then return end

    local kc = STYLE_KEYCODE[styleValue]
    if not kc then return end

    -- unequip current tool if any
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Tool") then
            pcall(function() item.Parent = LocalPlayer.Backpack end)
        end
    end
    task.wait(0.1)

    pcall(function()
        VIM:SendKeyEvent(true,  kc, false, game)
        task.wait(0.05)
        VIM:SendKeyEvent(false, kc, false, game)
    end)

    lastStyle = styleValue
    task.wait(0.3)
end

function Combat.useSkill(isBoss)
    if not (SkillState.autoAll or (SkillState.bossOnly and isBoss)) then return end

    local sel = Options.SelectSkills and Options.SelectSkills.Value
    if type(sel) ~= "table" then return end

    local active = {}
    for _, key in ipairs(SKILL_ORDER) do
        if sel[key] then table.insert(active, SKILL_KEY_MAP[key]) end
    end
    if #active == 0 then return end

    if SkillState.rotIdx > #active then SkillState.rotIdx = 1 end
    pcall(function() RequestAbility:FireServer(active[SkillState.rotIdx]) end)
    SkillState.rotIdx = SkillState.rotIdx + 1
    task.wait(0.5)
end

-- ============================================================
-- STYLE WATCHDOG
-- Keeps the correct style equipped while farming.
-- ============================================================
local StyleWatchdog = (function()
    local registeredToolName = nil
    local addConn, removeConn = nil, nil
    local active = false
    local lastReequipTime = 0
    local COOLDOWN = 1

    local function getExpectedStyle()
        return Options.Style and Options.Style.Value or nil
    end

    local function getCurrentTool()
        local char = LocalPlayer.Character
        if not char then return nil end
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") then return item end
        end
        return nil
    end

    local function forceEquip()
        if tick() - lastReequipTime < COOLDOWN then return end
        lastReequipTime = tick()

        local styleValue = getExpectedStyle()
        if not styleValue then return end
        local kc = STYLE_KEYCODE[styleValue]
        if not kc then return end

        local char = LocalPlayer.Character
        if not char then return end

        local tool = getCurrentTool()
        if tool then
            pcall(function() tool.Parent = LocalPlayer.Backpack end)
            task.wait(0.1)
        end

        pcall(function()
            VIM:SendKeyEvent(true,  kc, false, game)
            task.wait(0.05)
            VIM:SendKeyEvent(false, kc, false, game)
        end)
        lastStyle = styleValue
        task.wait(0.3)

        local equipped = getCurrentTool()
        registeredToolName = equipped and equipped.Name or nil
    end

    local function setupListeners()
        local char = LocalPlayer.Character
        if not char then return end

        if addConn    then addConn:Disconnect()    end
        if removeConn then removeConn:Disconnect() end

        addConn = char.ChildAdded:Connect(function(child)
            if not (child:IsA("Tool") and active and farmingActive) then return end
            if tick() - lastReequipTime < COOLDOWN then return end
            if registeredToolName and child.Name ~= registeredToolName then
                task.spawn(function()
                    pcall(function() child.Parent = LocalPlayer.Backpack end)
                    task.wait(0.2)
                    forceEquip()
                end)
            end
        end)

        removeConn = char.ChildRemoved:Connect(function(child)
            if not (child:IsA("Tool") and active and farmingActive) then return end
            if tick() - lastReequipTime < COOLDOWN then return end
            if child.Name == registeredToolName then
                task.spawn(forceEquip)
            end
        end)
    end

    local M = {}

    function M.start()
        if active then return end
        active = true
        setupListeners()
        local styleValue = getExpectedStyle()
        if styleValue == "Melee" then
            local tool = getCurrentTool()
            if tool then pcall(function() tool.Parent = LocalPlayer.Backpack end) end
            registeredToolName = nil
        else
            if not getCurrentTool() then forceEquip() end
        end
    end

    function M.stop()
        active = false
        if addConn    then addConn:Disconnect();    addConn    = nil end
        if removeConn then removeConn:Disconnect(); removeConn = nil end
        registeredToolName = nil
        lastReequipTime    = 0
    end

    function M.onStyleChanged(newStyle)
        if not newStyle or newStyle == "" then return end
        lastStyle          = newStyle
        registeredToolName = nil
        lastReequipTime    = 0
        if farmingActive then forceEquip() end
    end

    return M
end)()

-- ============================================================
-- COMBAT ENGINE  (unified loop used by all farming modes)
--
-- Usage:
--   CombatEngine.start(getNPCsFn)
--     getNPCsFn() → array of { npc=Model, isBoss=bool }
--
--   CombatEngine.stop()
-- ============================================================
local CombatEngine = (function()
    local state = {
        active   = false,
        thread   = nil,
        getNPCs  = nil,
    }

    local function loop()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local hum  = char:WaitForChild("Humanoid", 5)

        Combat.equipStyle()
        if hum then hum.PlatformStand = true end

        while state.active do
            -- re-check style every tick (user may change it mid-farm)
            local sv = Options.Style and Options.Style.Value
            if sv and (sv ~= lastStyle or not isToolEquipped()) then
                lastStyle = nil
                Combat.equipStyle()
            end

            local targets = state.getNPCs and state.getNPCs() or {}
            for _, entry in ipairs(targets) do
                if not state.active then break end
                local npc, isBoss = entry.npc, entry.isBoss

                local humNPC = npc:FindFirstChildOfClass("Humanoid")
                if humNPC and humNPC.Health > 0 then
                    local ok, npcCF = pcall(function() return npc:GetPivot() end)
                    if ok and NPCProvider.isValidCFrame(npcCF) then
                        local method, distY = getCombatOptions()
                        local targetCF = getTargetCFrame(npcCF, method, distY)
                        local c2 = LocalPlayer.Character
                        if c2 then
                            local hrp2 = c2:FindFirstChild("HumanoidRootPart")
                            if hrp2 then
                                pcall(function()
                                    hrp2.AssemblyLinearVelocity  = Vector3.zero
                                    hrp2.AssemblyAngularVelocity = Vector3.zero
                                    hrp2.CFrame = targetCF
                                end)
                            end
                        end
                    end

                    pcall(function() RequestHit:FireServer(npc) end)
                    Combat.useSkill(isBoss)
                end
            end

            task.wait(0.05)
        end

        local c   = LocalPlayer.Character
        local hum2 = c and c:FindFirstChild("Humanoid")
        if hum2 then hum2.PlatformStand = false end
    end

    local M = {}

    -- getNPCsFn : () → {{ npc=Model, isBoss=bool }, ...}
    function M.start(getNPCsFn)
        M.stop()
        state.getNPCs = getNPCsFn
        state.active  = true
        farmingActive = true
        pcall(function() Workspace.Gravity = 0 end)
        state.thread  = task.spawn(loop)
    end

    function M.stop()
        state.active  = false
        farmingActive = false
        if state.thread then
            pcall(task.cancel, state.thread)
            state.thread = nil
        end
        pcall(function() Workspace.Gravity = originalGravity end)
        local c   = LocalPlayer.Character
        local hum = c and c:FindFirstChild("Humanoid")
        if hum then hum.PlatformStand = false end
    end

    function M.isRunning() return state.active end

    return M
end)()

-- ============================================================
-- NPC QUERY FOR DUNGEON / TOWER  (shared between both modes)
-- Returns all alive NPCs in workspace/NPCs as combat targets.
-- ============================================================
local function getArenaLikeNPCs()
    local result = {}
    local f = workspace:FindFirstChild("NPCs")
    if not f then return result end
    for _, npc in ipairs(f:GetChildren()) do
        if npc:IsA("Model") then
            local h = npc:FindFirstChildOfClass("Humanoid")
            if h and h.Health > 0 then
                table.insert(result, {
                    npc    = npc,
                    isBoss = NPCProvider.isBossNPC(npc),
                })
            end
        end
    end
    return result
end

-- ============================================================
-- BOSS SPAWNER – Sea 2
-- ============================================================
local BossSpawnerSea2 = {}

local function fireSea2Remote(bossType, difficulty)
    local cfg = BOSS_SPAWN_CONFIG_SEA2[bossType]
    if not cfg or not cfg.remote then return end
    pcall(function() cfg.remote:FireServer(difficulty) end)
    task.wait(0.5)
end

function BossSpawnerSea2.enable(bossType, difficulty)  fireSea2Remote(bossType, difficulty) end
function BossSpawnerSea2.disable(bossType, difficulty) fireSea2Remote(bossType, difficulty) end

function BossSpawnerSea2.findBoss(bossType, difficulty)
    local cfg = BOSS_SPAWN_CONFIG_SEA2[bossType]
    if not cfg then return nil end
    local f = NPCProvider.folder()
    if not f then return nil end
    local npc = f:FindFirstChild(cfg.bossNameTemplate .. difficulty)
    return (npc and NPCProvider.isAlive(npc)) and npc or nil
end

function BossSpawnerSea2.getSelection()
    if not AutoFarmState.selectedBSea2 then return nil end
    return Options["Select Boss Spawners 2"] and Options["Select Boss Spawners 2"].Value or {}
end

function BossSpawnerSea2.getDifficulty()
    return Options["Select Difficulty Boss Spawners 2"] and Options["Select Difficulty Boss Spawners 2"].Value or nil
end

function BossSpawnerSea2.disableAllActive(difficulty)
    SpawnState:forEach(function(key, isActive)
        if isActive then
            local bt = key:match("^(.+)_[^_]+$")
            if bt and BOSS_SPAWN_CONFIG_SEA2[bt] then
                pcall(function() BossSpawnerSea2.disable(bt, difficulty) end)
                SpawnState:set(key, false)
            end
        end
    end)
end

function BossSpawnerSea2.onBossTypeChanged(newType)
    if not AutoFarmState.selectedBSea2 then return end
    local diff = BossSpawnerSea2.getDifficulty()
    if not diff or not newType then return end

    local newIsland = BOSS_SPAWN_CONFIG_SEA2[newType] and BOSS_SPAWN_CONFIG_SEA2[newType].island

    -- Find the currently active boss type
    local oldType, oldIsland = nil, nil
    SpawnState:forEach(function(key, isActive)
        if isActive and not oldType then
            local bt = key:match("^(.+)_[^_]+$")
            if bt and BOSS_SPAWN_CONFIG_SEA2[bt] then
                oldType   = bt
                oldIsland = BOSS_SPAWN_CONFIG_SEA2[bt].island
            end
        end
    end)

    if oldType and oldIsland == newIsland then
        SpawnState:set(oldType .. "_" .. diff, false)
    else
        BossSpawnerSea2.disableAllActive(diff)
    end
    AnchorState:clearFarm()
end

function BossSpawnerSea2.onDifficultyChanged(newDiff)
    if not AutoFarmState.selectedBSea2 then return end
    if newDiff == lastSea2Difficulty then return end

    if lastSea2Difficulty then
        SpawnState:forEach(function(key, isActive)
            if isActive then
                local bt = key:match("^(.+)_[^_]+$")
                if bt and BOSS_SPAWN_CONFIG_SEA2[bt] then
                    pcall(function() BossSpawnerSea2.disable(bt, lastSea2Difficulty) end)
                end
            end
        end)
        task.wait(0.3)
    end

    if newDiff then
        SpawnState:forEach(function(key, isActive)
            if isActive then
                local bt = key:match("^(.+)_[^_]+$")
                if bt and BOSS_SPAWN_CONFIG_SEA2[bt] then
                    pcall(function() BossSpawnerSea2.enable(bt, newDiff) end)
                end
            end
        end)
    end

    lastSea2Difficulty = newDiff
    AnchorState:clearFarm()
end

-- ============================================================
-- BOSS SPAWNER – Sea 1
-- ============================================================
local BossSpawnerSea1 = {}

local function fireSea1Remote(cfg, difficulty)
    if not cfg or not cfg.remote then return end
    pcall(function()
        if not cfg.hasDifficulty then
            cfg.remote:FireServer(cfg.bossArg)
        elseif cfg.customRemote then
            local args = {}
            if cfg.customArgs then
                for _, a in ipairs(cfg.customArgs) do table.insert(args, a) end
            end
            table.insert(args, difficulty)
            cfg.remote:FireServer(table.unpack(args))
        else
            cfg.remote:FireServer(cfg.bossArg, difficulty)
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
    local cfg = BOSS_SPAWN_CONFIG_SEA1[bossType]
    if not cfg then return nil end
    local f = NPCProvider.folder()
    if not f then return nil end
    local name = cfg.npcName or (cfg.npcPrefix .. (difficulty or ""))
    local npc  = f:FindFirstChild(name)
    return (npc and NPCProvider.isAlive(npc)) and npc or nil
end

function BossSpawnerSea1.findBossAnyDifficulty(bossType)
    for _, diff in ipairs(DIFFICULTIES) do
        local b = BossSpawnerSea1.findBoss(bossType, diff)
        if b then return b end
    end
    return BossSpawnerSea1.findBoss(bossType, nil)
end

function BossSpawnerSea1.getSelection()
    if not AutoFarmState.selectedBSea1 then return nil end
    return Options["Select Boss Spawners"] and Options["Select Boss Spawners"].Value or nil
end

function BossSpawnerSea1.getDifficulty()
    return Options["Select Difficulty Boss Spawners"] and Options["Select Difficulty Boss Spawners"].Value or nil
end

function BossSpawnerSea1.getOtherBossesOnIsland(bossType, island)
    local others = {}
    for bt, cfg in pairs(BOSS_SPAWN_CONFIG_SEA1) do
        if bt ~= bossType and cfg.island == island then
            table.insert(others, bt)
        end
    end
    return others
end

function BossSpawnerSea1.disableAllActive(difficulty)
    SpawnState:forEach(function(bossType, isActive)
        if isActive and BOSS_SPAWN_CONFIG_SEA1[bossType] then
            local cfg = BOSS_SPAWN_CONFIG_SEA1[bossType]
            pcall(function()
                BossSpawnerSea1.disable(bossType, cfg.hasDifficulty and difficulty or nil)
            end)
            SpawnState:set(bossType, false)
        end
    end)
end

function BossSpawnerSea1.onBossTypeChanged(newType)
    if not AutoFarmState.selectedBSea1 then return end
    local diff = BossSpawnerSea1.getDifficulty()
    if not newType then return end

    local newIsland = BOSS_SPAWN_CONFIG_SEA1[newType] and BOSS_SPAWN_CONFIG_SEA1[newType].island
    local oldType, oldIsland = nil, nil
    SpawnState:forEach(function(bt, isActive)
        if isActive and BOSS_SPAWN_CONFIG_SEA1[bt] and not oldType then
            oldType   = bt
            oldIsland = BOSS_SPAWN_CONFIG_SEA1[bt].island
        end
    end)

    if oldType and oldIsland == newIsland then
        SpawnState:set(oldType, false)
    else
        BossSpawnerSea1.disableAllActive(diff)
    end
    AnchorState:clearFarm()
end

function BossSpawnerSea1.onDifficultyChanged(newDiff)
    if not AutoFarmState.selectedBSea1 then return end
    if newDiff == lastSea1Difficulty then return end

    if lastSea1Difficulty then
        SpawnState:forEach(function(bossType, isActive)
            if isActive and BOSS_SPAWN_CONFIG_SEA1[bossType] then
                local cfg = BOSS_SPAWN_CONFIG_SEA1[bossType]
                if cfg.hasDifficulty then
                    pcall(function() BossSpawnerSea1.disable(bossType, lastSea1Difficulty) end)
                end
            end
        end)
        task.wait(0.3)
    end

    if newDiff then
        SpawnState:forEach(function(bossType, isActive)
            if isActive and BOSS_SPAWN_CONFIG_SEA1[bossType] then
                local cfg = BOSS_SPAWN_CONFIG_SEA1[bossType]
                if cfg.hasDifficulty then
                    pcall(function() BossSpawnerSea1.enable(bossType, newDiff) end)
                end
            end
        end)
    end

    lastSea1Difficulty = newDiff
    AnchorState:clearFarm()
end

-- ============================================================
-- OPEN-WORLD FARM LOOP
-- This is the only complex loop; dungeon/tower use CombatEngine
-- directly via getArenaLikeNPCs.
-- ============================================================
local FarmController = (function()
    local ctrl = {
        _thread    = nil,
        _running   = false,
        _interrupt = false,
    }

    function ctrl:interrupt()     self._interrupt = true  end
    function ctrl:clearInterrupt() self._interrupt = false end
    function ctrl:wasInterrupted() return self._interrupt  end
    function ctrl:isRunning()      return self._running    end

    local function anyActive()
        return AutoFarmState.selectedEnemies or AutoFarmState.everyEnemy
            or AutoFarmState.selectedOWB     or AutoFarmState.everyOWB
            or AutoFarmState.selectedWB      or AutoFarmState.everyWB
            or AutoFarmState.selectedBSea2   or AutoFarmState.selectedBSea1
    end

    -- Attempt to attack an NPC with position tracking
    local function attackNPC(npc, isBoss, c)
        local ok, npcCF = pcall(function() return npc:GetPivot() end)
        if not ok or not NPCProvider.isValidCFrame(npcCF) then return end

        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")

        local method, distY = getCombatOptions()
        local island  = NPCProvider.getIslandFromEnemy(npc.Name)
        local targetCF = getTargetCFrame(npcCF, method, distY)

        teleportCharacter(targetCF, island)
        if hum then hum.PlatformStand = true end
        AnchorState:setFarm(npcCF)

        local deadline = tick() + (isBoss and 120 or 45)
        local hitCount = 0

        while NPCProvider.isAlive(npc) and tick() < deadline do
            if c:wasInterrupted() then break end

            local ok2, freshCF = pcall(function() return npc:GetPivot() end)
            if ok2 and NPCProvider.isValidCFrame(freshCF) then
                npcCF = freshCF
                AnchorState:setFarm(freshCF)
            end

            method, distY = getCombatOptions()
            local safeCF = getTargetCFrame(npcCF, method, distY)
            local c2 = LocalPlayer.Character
            if c2 then
                local hrp2 = c2:FindFirstChild("HumanoidRootPart")
                if hrp2 and (hrp2.CFrame.Position - safeCF.Position).Magnitude > 5 then
                    teleportCharacter(safeCF, NPCProvider.getIslandFromEnemy(npc.Name))
                end
            end

            Combat.useSkill(isBoss)
            pcall(function() RequestHit:FireServer(npc) end)

            hitCount = hitCount + 1
            task.wait(hitCount % 15 == 0 and 0.1 or 0.03)
        end

        if hum then hum.PlatformStand = false end
        if not NPCProvider.isAlive(npc) then
            AnchorState:save()
            AnchorState:clearFarm()
        end
    end

    local function stayAtAnchor()
        local anchor = AnchorState:get()
        if not anchor then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local method, distY = getCombatOptions()
        local targetCF = getTargetCFrame(anchor, method, distY)
        if (hrp.CFrame.Position - targetCF.Position).Magnitude > 2 then
            teleportCharacter(targetCF)
        end
    end

    local function farmLoop(c)
        SpawnState:clear()
        AnchorState:clear()
        lastTeleportedIsland = nil

        Combat.equipStyle()
        task.wait(0.5)

        while not c:wasInterrupted() do
            if not anyActive() then break end

            local owbSel   = AutoFarmState.everyOWB and "all"
                          or (AutoFarmState.selectedOWB and Options["Select Open World Bosses"] and Options["Select Open World Bosses"].Value)
                          or nil
            local wbSel    = AutoFarmState.everyWB and "all"
                          or (AutoFarmState.selectedWB and Options["Select World Bosses"] and Options["Select World Bosses"].Value)
                          or nil
            local bsea2Sel = BossSpawnerSea2.getSelection()
            local sea2Diff = BossSpawnerSea2.getDifficulty()
            local bsea1Sel = BossSpawnerSea1.getSelection()
            local sea1Diff = BossSpawnerSea1.getDifficulty()

            -- ------------------------------------------------
            -- Priority 0: Sea 2 Boss Spawners
            -- ------------------------------------------------
            if bsea2Sel and sea2Diff then
                local sel = type(bsea2Sel) == "string" and { [bsea2Sel]=true } or bsea2Sel

                for bossType in pairs(BOSS_SPAWN_CONFIG_SEA2) do
                    local key      = bossType .. "_" .. sea2Diff
                    local isActive = SpawnState:get(key)
                    local isSelected = sel[bossType]

                    if isSelected and not isActive then
                        -- clear any existing spawn first
                        for _, diff in ipairs(DIFFICULTIES) do
                            if c:wasInterrupted() then break end
                            local existing = BossSpawnerSea2.findBoss(bossType, diff)
                            if existing then attackNPC(existing, true, c) end
                        end
                        BossSpawnerSea2.enable(bossType, sea2Diff)
                        SpawnState:set(key, true)
                    elseif not isSelected and isActive then
                        BossSpawnerSea2.disable(bossType, sea2Diff)
                        SpawnState:set(key, false)
                    end
                end

                for bossType in pairs(BOSS_SPAWN_CONFIG_SEA2) do
                    if c:wasInterrupted() or not AutoFarmState.selectedBSea2 then break end
                    if sel[bossType] then
                        local boss = BossSpawnerSea2.findBoss(bossType, sea2Diff)
                        if boss then attackNPC(boss, true, c) end
                    end
                end
            else
                if sea2Diff then BossSpawnerSea2.disableAllActive(sea2Diff) end
            end

            -- ------------------------------------------------
            -- Priority 0.5: Sea 1 Boss Spawners
            -- ------------------------------------------------
            if bsea1Sel then
                local sel = type(bsea1Sel) == "string" and { [bsea1Sel]=true } or bsea1Sel

                for bossType, cfg in pairs(BOSS_SPAWN_CONFIG_SEA1) do
                    if c:wasInterrupted() then break end
                    local isActive   = SpawnState:get(bossType)
                    local isSelected = sel[bossType]

                    if isSelected and not isActive then
                        -- clear existing
                        local existing = BossSpawnerSea1.findBossAnyDifficulty(bossType)
                        if existing then attackNPC(existing, true, c) end

                        for _, otherBT in ipairs(BossSpawnerSea1.getOtherBossesOnIsland(bossType, cfg.island)) do
                            if c:wasInterrupted() then break end
                            local other = BossSpawnerSea1.findBossAnyDifficulty(otherBT)
                            if other then attackNPC(other, true, c) end
                        end

                        if cfg.hasDifficulty and sea1Diff then
                            BossSpawnerSea1.enable(bossType, sea1Diff)
                        else
                            BossSpawnerSea1.enable(bossType, nil)
                        end
                        SpawnState:set(bossType, true)

                    elseif not isSelected and isActive then
                        BossSpawnerSea1.disable(bossType, cfg.hasDifficulty and sea1Diff or nil)
                        SpawnState:set(bossType, false)
                    end
                end

                for bossType, cfg in pairs(BOSS_SPAWN_CONFIG_SEA1) do
                    if c:wasInterrupted() or not AutoFarmState.selectedBSea1 then break end
                    if sel[bossType] then
                        local boss = (cfg.hasDifficulty and sea1Diff)
                            and BossSpawnerSea1.findBoss(bossType, sea1Diff)
                            or  BossSpawnerSea1.findBoss(bossType, nil)
                        if boss then attackNPC(boss, true, c) end
                    end
                end
            else
                BossSpawnerSea1.disableAllActive(sea1Diff)
            end

            -- ------------------------------------------------
            -- Priority 1: World Bosses
            -- ------------------------------------------------
            if wbSel then
                local wbs = NPCProvider.queryWB(wbSel)
                for _, npc in ipairs(wbs) do
                    if c:wasInterrupted() or not anyActive() then break end
                    if NPCProvider.isAlive(npc) then attackNPC(npc, true, c) end
                end
                if #wbs == 0 then stayAtAnchor() end
            end

            -- ------------------------------------------------
            -- Priority 2: Open World Bosses
            -- ------------------------------------------------
            if owbSel then
                local owbs = NPCProvider.queryOWB(owbSel)
                for _, npc in ipairs(owbs) do
                    if c:wasInterrupted() or not anyActive() then break end
                    if NPCProvider.isAlive(npc) then attackNPC(npc, true, c) end
                end
                if #owbs == 0 then stayAtAnchor() end
            end

            -- ------------------------------------------------
            -- Priority 3: Normal Enemies
            -- ------------------------------------------------
            if (AutoFarmState.selectedEnemies or AutoFarmState.everyEnemy) and not c:wasInterrupted() then
                local selectedTypes = {}

                if AutoFarmState.selectedEnemies then
                    local sel = Options["Select Enemies"] and Options["Select Enemies"].Value or {}
                    for prefix, enabled in pairs(sel) do
                        if enabled then table.insert(selectedTypes, prefix) end
                    end
                    table.sort(selectedTypes)
                else
                    selectedTypes = NPCProvider.getNormalEnemyTypes()
                end

                if #selectedTypes == 0 then
                    stayAtAnchor()
                    task.wait(1)
                else
                    for _, prefix in ipairs(selectedTypes) do
                        if c:wasInterrupted() then break end
                        if not (AutoFarmState.selectedEnemies or AutoFarmState.everyEnemy) then break end

                        -- yield to higher-priority targets if they appear
                        if owbSel and #NPCProvider.queryOWB(owbSel) > 0 then break end
                        if wbSel  and #NPCProvider.queryWB(wbSel)  > 0 then break end

                        local npcs = NPCProvider.queryNormal(function(p) return p == prefix end)
                        if #npcs > 0 then
                            local ok0, cf0 = pcall(function() return npcs[1]:GetPivot() end)
                            if ok0 and NPCProvider.isValidCFrame(cf0) then
                                AnchorState:setFarm(cf0)
                            end
                            for _, npc in ipairs(npcs) do
                                if c:wasInterrupted() then break end
                                if not (AutoFarmState.selectedEnemies or AutoFarmState.everyEnemy) then break end
                                if NPCProvider.isAlive(npc) then attackNPC(npc, false, c) end
                            end
                        end
                    end
                    stayAtAnchor()
                end
            elseif not wbSel and not owbSel then
                stayAtAnchor()
                task.wait(1)
            end

            task.wait(0.05)
        end
    end

    function ctrl:start()
        self:stop()
        self._running   = true
        self._interrupt = false
        farmingActive   = true
        GhostMode.enable()
        pcall(function() Workspace.Gravity = 0 end)
        StyleWatchdog.start()

        self._thread = task.spawn(function()
            local ok, err = pcall(farmLoop, self)
            if not ok then warn("[FarmController] error:", err) end

            self._running   = false
            self._thread    = nil
            farmingActive   = false
            GhostMode.disable()
            pcall(function() Workspace.Gravity = originalGravity end)
            StyleWatchdog.stop()
        end)
    end

    function ctrl:stop()
        self._interrupt = true
        farmingActive   = false
        GhostMode.disable()
        StyleWatchdog.stop()
        pcall(function() Workspace.Gravity = originalGravity end)
        if self._thread then
            pcall(task.cancel, self._thread)
            self._thread = nil
        end
        self._running = false

        -- disable all active spawners
        local s2d = BossSpawnerSea2.getDifficulty()
        local s1d = BossSpawnerSea1.getDifficulty()
        BossSpawnerSea2.disableAllActive(s2d)
        BossSpawnerSea1.disableAllActive(s1d)
        SpawnState:clear()
        AnchorState:clear()
        lastTeleportedIsland = nil

        -- clean up character state
        local c = LocalPlayer.Character
        if c then
            local hrp = c:FindFirstChild("HumanoidRootPart")
            local hum = c:FindFirstChild("Humanoid")
            if hum then hum.PlatformStand = false end
            if hrp then
                pcall(function()
                    hrp.AssemblyLinearVelocity  = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end)
            end
        end
    end

    return ctrl
end)()

local function anyFarmActive()
    return AutoFarmState.selectedEnemies or AutoFarmState.everyEnemy
        or AutoFarmState.selectedOWB     or AutoFarmState.everyOWB
        or AutoFarmState.selectedWB      or AutoFarmState.everyWB
        or AutoFarmState.selectedBSea2   or AutoFarmState.selectedBSea1
end

local function refreshFarm()
    if anyFarmActive() then
        FarmController:start()
    else
        FarmController:stop()
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    if anyFarmActive() then FarmController:stop() end
    lastStyle = nil
    AnchorState:clear()
    lastTeleportedIsland = nil
    if anyFarmActive() then
        task.wait(0.2)
        GhostMode.enable()
        StyleWatchdog.start()
    end
end)

-- ============================================================
-- DUNGEON CONTROLLER
-- Uses CombatEngine with getArenaLikeNPCs — no custom loop.
-- ============================================================
local DungeonController = (function()
    local state = {
        active     = false,
        syncConn   = nil,
        dungeon    = nil,
        difficulty = "Easy",
    }

    local function getDungeonArg()
        local v = Options["Select Dungeon"] and Options["Select Dungeon"].Value
        local display = (type(v) == "string" and v ~= "") and v or state.dungeon
        state.dungeon = display
        return display and DUNGEON_NAME_MAP[display] or nil
    end

    local function getDiffArg()
        local v = Options["Select Difficulty Dungeon"] and Options["Select Difficulty Dungeon"].Value
        return (type(v) == "string" and v ~= "") and v or state.difficulty
    end

    local function isToggleOn()
        local t = Options["Auto Farm Dungeon"]
        return t and t.Value == true
    end

    local function setToggle(value)
        local t = Options["Auto Farm Dungeon"]
        if t and t.SetValue then pcall(function() t:SetValue(value) end) end
    end

    local function stopAll()
        state.active = false
        CombatEngine.stop()
        if state.syncConn then
            pcall(function() state.syncConn:Disconnect() end)
            state.syncConn = nil
        end
    end

    local function setupWaveListener(diffArg)
        if state.syncConn then
            pcall(function() state.syncConn:Disconnect() end)
            state.syncConn = nil
        end
        if not DungeonWaveSync then return end

        -- initial vote
        task.spawn(function()
            task.wait(1)
            if state.active and DungeonWaveVote then
                pcall(function() DungeonWaveVote:FireServer(diffArg) end)
            end
        end)

        -- start combat immediately
        StyleWatchdog.start()
        CombatEngine.start(getArenaLikeNPCs)

        state.syncConn = DungeonWaveSync.OnClientEvent:Connect(function(data)
            if not state.active then return end
            if data.phase == "active" then
                if not CombatEngine.isRunning() then
                    CombatEngine.start(getArenaLikeNPCs)
                end
            elseif data.phase == "cleared" then
                task.spawn(function()
                    task.wait(1); if not state.active then return end
                    if DungeonWaveReplayVote then
                        pcall(function() DungeonWaveReplayVote:FireServer("sponsor") end)
                    end
                    task.wait(1); if not state.active then return end
                    if DungeonWaveVote then
                        pcall(function() DungeonWaveVote:FireServer(getDiffArg()) end)
                    end
                end)
            end
        end)
    end

    local M = {}

    function M.isInsideDungeon()
        return DUNGEON_PLACE_IDS[game.PlaceId] == true
    end

    function M.start()
        stopAll()
        state.active = true

        local dungeonArg = getDungeonArg()
        local diffArg    = getDiffArg()

        if not dungeonArg then
            state.active = false
            task.spawn(function()
                task.wait(1)
                if isToggleOn() then M.start() end
            end)
            return
        end

        if M.isInsideDungeon() then
            setupWaveListener(diffArg)
        else
            if not RequestDungeonPortal then
                state.active = false
                setToggle(false)
                return
            end
            pcall(function() RequestDungeonPortal:FireServer(dungeonArg) end)
            task.spawn(function()
                task.wait(3)
                if not state.active then return end
                if StartDungeonPortal then
                    pcall(function() StartDungeonPortal:FireServer() end)
                else
                    state.active = false
                    setToggle(false)
                end
            end)
        end
    end

    function M.stop()
        stopAll()
        StyleWatchdog.stop()
    end

    function M.tryAutoResume()
        task.spawn(function()
            task.wait(1)
            local O = Mahmut.Options
            if O then
                local sd = O["Select Dungeon"]     and O["Select Dungeon"].Value
                local di = O["Select Difficulty Dungeon"] and O["Select Difficulty Dungeon"].Value
                if type(sd) == "string" and sd ~= "" then state.dungeon    = sd end
                if type(di) == "string" and di ~= "" then state.difficulty = di end
            end
            if getDungeonArg() then
                state.active = true
                setToggle(true)
                setupWaveListener(getDiffArg())
            end
        end)
    end

    function M.syncLoadedState()
        task.spawn(function()
            local deadline = tick() + 10
            while tick() < deadline do
                local O = Mahmut.Options
                if O then
                    local dOpt  = O["Select Dungeon"]
                    local diOpt = O["Select Difficulty Dungeon"]
                    local tog   = O["Auto Farm Dungeon"]
                    if dOpt and diOpt and tog then
                        local dv  = dOpt.Value
                        local div = diOpt.Value
                        if type(dv) == "string" and dv ~= "" then state.dungeon    = dv end
                        if type(div) == "string" and div ~= "" then state.difficulty = div end
                        if tog.Value == true then
                            M.stop()
                            task.wait(0.3)
                            M.start()
                        end
                        return
                    end
                end
                task.wait(0.2)
            end
        end)
    end

    function M.onDungeonChanged(v)
        if type(v) == "string" and v ~= "" then
            state.dungeon = v
            if isToggleOn() then M.start() end
        end
    end

    function M.onDifficultyChanged(v)
        if type(v) == "string" and v ~= "" then
            state.difficulty = v
            if isToggleOn() then M.start() end
        end
    end

    return M
end)()

-- ============================================================
-- TOWER DEFENSE CONTROLLER
-- Uses CombatEngine with getArenaLikeNPCs — no custom loop.
-- ============================================================
local TowerDefenseController = (function()
    local state = {
        active     = false,
        syncConn   = nil,
        dungeonArg = "InfiniteTower",
    }

    local function isSea2()
        return game.PlaceId == 130167267952199
    end

    local function stopAll()
        state.active = false
        CombatEngine.stop()
        if state.syncConn then
            pcall(function() state.syncConn:Disconnect() end)
            state.syncConn = nil
        end
    end

    local function setupWaveListener()
        if state.syncConn then
            pcall(function() state.syncConn:Disconnect() end)
            state.syncConn = nil
        end
        if not DungeonWaveSync then return end

        task.spawn(function()
            task.wait(1)
            if state.active and DungeonWaveVote then
                pcall(function() DungeonWaveVote:FireServer("start") end)
            end
        end)

        StyleWatchdog.start()
        CombatEngine.start(getArenaLikeNPCs)

        state.syncConn = DungeonWaveSync.OnClientEvent:Connect(function(data)
            if not state.active then return end
            if data.phase == "active" then
                if not CombatEngine.isRunning() then
                    CombatEngine.start(getArenaLikeNPCs)
                end
            elseif data.phase == "failed" then
                task.spawn(function()
                    task.wait(1); if not state.active then return end
                    if DungeonWaveReplayVote then
                        pcall(function() DungeonWaveReplayVote:FireServer("sponsor") end)
                    end
                    task.wait(1); if not state.active then return end
                    if DungeonWaveVote then
                        pcall(function() DungeonWaveVote:FireServer("start") end)
                    end
                end)
            end
        end)
    end

    local M = {}

    function M.isInsideTower()
        return TOWER_PLACE_IDS[game.PlaceId] == true
    end

    function M.start()
        stopAll()
        state.active = true

        if not M.isInsideTower() then
            state.dungeonArg = isSea2() and "CrystalDefense" or "InfiniteTower"
        end

        if M.isInsideTower() then
            setupWaveListener()
        else
            if not RequestDungeonPortal then
                state.active = false
                return
            end
            pcall(function() RequestDungeonPortal:FireServer(state.dungeonArg) end)
            task.spawn(function()
                task.wait(3)
                if not state.active then return end
                if StartDungeonPortal then
                    pcall(function() StartDungeonPortal:FireServer() end)
                end
                task.wait(2)
                if state.active then setupWaveListener() end
            end)
        end
    end

    function M.stop()
        stopAll()
        StyleWatchdog.stop()
    end

    function M.onFloorChanged(v)
        local n = tonumber(v)
        if n and n > 0 and SetAutoTowerReset then
            pcall(function() SetAutoTowerReset:FireServer(n) end)
        end
    end

    function M.syncLoadedState()
        task.spawn(function()
            local deadline = tick() + 10
            while tick() < deadline do
                local O = Mahmut.Options
                if O then
                    local tog = O["Auto Farm Infinity Tower/Crystal Defense"]
                    if tog ~= nil then
                        if tog.Value == true then
                            M.stop()
                            task.wait(0.3)
                            M.start()
                        end
                        return
                    end
                end
                task.wait(0.2)
            end
        end)
    end

    return M
end)()

-- ============================================================
-- TAB: FARMING SETTINGS
-- ============================================================
do
    local section = Tabs.FarmingSettings:AddSection("Combat Settings")

    section:AddDropdown("Style", {
        Title  = "Combat Style",
        Values = {"Melee", "Sword", "Power"},
        Multi  = false,
        Default= nil,
        Callback = function(v)
            lastStyle = nil
            StyleWatchdog.onStyleChanged(v)
            if farmingActive then Combat.equipStyle() end
        end,
    })

    section:AddDropdown("SelectSkills", {
        Title  = "Select Skills",
        Values = {"Z", "X", "C", "V", "F"},
        Multi  = true,
        Default= {},
        Callback = function()
            SkillState.rotIdx = 1
        end,
    })

    section:AddToggle("Auto Use Skills For All Mobs", {
        Title    = "Auto Use Skills For All Mobs",
        Default  = false,
        Callback = function(v)
            SkillState.autoAll = v
            if v and SkillState.bossOnly then
                SkillState.bossOnly = false
                local t = Options["Use Skill Only Boss"]
                if t then t:SetValue(false) end
            end
            SkillState.rotIdx = 1
        end,
    })

    section:AddToggle("Use Skill Only Boss", {
        Title    = "Use Skill Only Boss",
        Default  = false,
        Callback = function(v)
            SkillState.bossOnly = v
            if v and SkillState.autoAll then
                SkillState.autoAll = false
                local t = Options["Auto Use Skills For All Mobs"]
                if t then t:SetValue(false) end
            end
            SkillState.rotIdx = 1
        end,
    })

    -- Synced slider + text input for Distance Farm Y
    local syncing = false
    local DFYInput

    local DFYSlider = section:AddSlider("Distance Farm Y", {
        Title       = "Distance Farm Y",
        Description = "Jarak dari NPC. Makin jauh = makin susah kena hit balik.",
        Default     = 5,
        Min         = 0,
        Max         = 10,
        Rounding    = 1,
        Callback    = function(val)
            if syncing then return end
            syncing = true
            if DFYInput then DFYInput:SetValue(tostring(val)) end
            syncing = false
        end,
    })

    DFYInput = section:AddInput("DistanceFarmYInput", {
        Title    = "Distance Farm Y Input",
        Default  = nil,
        Placeholder = "0-10",
        Numeric  = true,
        Finished = true,
        Callback = function(val)
            local n = math.clamp(tonumber(val) or 5, 0, 10)
            if syncing then return end
            syncing = true
            DFYSlider:SetValue(n)
            syncing = false
        end,
    })

    section:AddDropdown("Select Method Farm", {
        Title   = "Select Method Farm",
        Values  = {"Behind", "Above", "Under"},
        Multi   = false,
        Default = "Behind",
    })
end

-- ============================================================
-- TAB: FARMING
-- ============================================================
do
    -- Normal Enemies
    local secE = Tabs.Farming:AddSection("Select Enemies To Farm")

    secE:AddDropdown("Select Enemies", {
        Title   = "Select Enemies",
        Values  = NPCProvider.getNormalEnemyTypes(),
        Multi   = true,
        Default = {},
    })

    secE:AddToggle("Auto Farm Selected Enemies", {
        Title    = "Auto Farm Selected Enemies",
        Default  = false,
        Callback = function(v)
            AutoFarmState.selectedEnemies = v
            if v and AutoFarmState.everyEnemy then
                AutoFarmState.everyEnemy = false
                local t = Options["Auto Farm Every Enemies"]
                if t then t:SetValue(false) end
            end
            refreshFarm()
        end,
    })

    secE:AddToggle("Auto Farm Every Enemies", {
        Title    = "Auto Farm Every Enemies",
        Default  = false,
        Callback = function(v)
            AutoFarmState.everyEnemy = v
            if v and AutoFarmState.selectedEnemies then
                AutoFarmState.selectedEnemies = false
                local t = Options["Auto Farm Selected Enemies"]
                if t then t:SetValue(false) end
            end
            refreshFarm()
        end,
    })

    -- Open World Bosses
    local secOWB = Tabs.Farming:AddSection("Select Open World Bosses To Farm")

    secOWB:AddDropdown("Select Open World Bosses", {
        Title   = "Select Open World Bosses",
        Values  = {"Vampire King","Solo Hunter","Limitless Sorcerer","Cursed Vessel",
                   "Cursed King","Manipulator","Yamato","Strongest Shinobi"},
        Multi   = true,
        Default = {},
    })

    secOWB:AddToggle("Auto Farm Selected Open World Bosses", {
        Title    = "Auto Farm Selected Open World Bosses",
        Default  = false,
        Callback = function(v)
            AutoFarmState.selectedOWB = v
            if v and AutoFarmState.everyOWB then
                AutoFarmState.everyOWB = false
                local t = Options["Auto Farm Every Open World Bosses"]
                if t then t:SetValue(false) end
            end
            refreshFarm()
        end,
    })

    secOWB:AddToggle("Auto Farm Every Open World Bosses", {
        Title    = "Auto Farm Every Open World Bosses",
        Default  = false,
        Callback = function(v)
            AutoFarmState.everyOWB = v
            if v and AutoFarmState.selectedOWB then
                AutoFarmState.selectedOWB = false
                local t = Options["Auto Farm Selected Open World Bosses"]
                if t then t:SetValue(false) end
            end
            refreshFarm()
        end,
    })

    -- World Bosses (Sea 2)
    local secWB = Tabs.Farming:AddSection("Select World Bosses To Farm (Sea 2 Only)")

    secWB:AddDropdown("Select World Bosses", {
        Title   = "Select World Bosses",
        Values  = {"Sun God","Cosmic Being"},
        Multi   = true,
        Default = {},
    })

    secWB:AddToggle("Auto Farm Selected World Bosses", {
        Title    = "Auto Farm Selected World Bosses",
        Default  = false,
        Callback = function(v)
            AutoFarmState.selectedWB = v
            if v and AutoFarmState.everyWB then
                AutoFarmState.everyWB = false
                local t = Options["Auto Farm Every World Bosses"]
                if t then t:SetValue(false) end
            end
            refreshFarm()
        end,
    })

    secWB:AddToggle("Auto Farm Every World Bosses", {
        Title    = "Auto Farm Every World Bosses",
        Default  = false,
        Callback = function(v)
            AutoFarmState.everyWB = v
            if v and AutoFarmState.selectedWB then
                AutoFarmState.selectedWB = false
                local t = Options["Auto Farm Selected World Bosses"]
                if t then t:SetValue(false) end
            end
            refreshFarm()
        end,
    })

    -- Boss Spawners Sea 1
    local secBS1 = Tabs.Farming:AddSection("Select Boss Spawners To Farm (Sea 1 Only)")

    secBS1:AddDropdown("Select Boss Spawners", {
        Title   = "Select Boss Spawners",
        Values  = {"Strongest in History","Strongest of Today","Knight","Qin Shi","Soul Reaper",
                   "King of Heroes","Corrupted Knight","Blessed Maiden","Moon Slayer","Ice Queen",
                   "Demon Lord","Demon King","True Manipulator"},
        Multi   = false,
        Default = nil,
        Callback = BossSpawnerSea1.onBossTypeChanged,
    })

    secBS1:AddDropdown("Select Difficulty Boss Spawners", {
        Title   = "Select Difficulty Boss Spawners",
        Values  = {"Normal","Medium","Hard","Extreme"},
        Multi   = false,
        Default = nil,
        Callback = BossSpawnerSea1.onDifficultyChanged,
    })

    secBS1:AddToggle("Auto Farm Selected Boss Spawners", {
        Title    = "Auto Farm Selected Boss Spawners",
        Default  = false,
        Callback = function(v)
            AutoFarmState.selectedBSea1 = v
            if v then
                lastSea1Difficulty = BossSpawnerSea1.getDifficulty()
            else
                BossSpawnerSea1.disableAllActive(BossSpawnerSea1.getDifficulty())
            end
            refreshFarm()
        end,
    })

    -- Boss Spawners Sea 2
    local secBS2 = Tabs.Farming:AddSection("Select Boss Spawners To Farm (Sea 2 Only)")

    secBS2:AddDropdown("Select Boss Spawners 2", {
        Title   = "Select Boss Spawners 2",
        Values  = {"The World","Spirit Warrior"},
        Multi   = false,
        Default = nil,
        Callback = BossSpawnerSea2.onBossTypeChanged,
    })

    secBS2:AddDropdown("Select Difficulty Boss Spawners 2", {
        Title   = "Select Difficulty Boss Spawners 2",
        Values  = {"Normal","Medium","Hard","Extreme"},
        Multi   = false,
        Default = nil,
        Callback = BossSpawnerSea2.onDifficultyChanged,
    })

    secBS2:AddToggle("Auto Farm Selected Boss Spawners 2", {
        Title    = "Auto Farm Selected Boss Spawners 2",
        Default  = false,
        Callback = function(v)
            AutoFarmState.selectedBSea2 = v
            if v then
                lastSea2Difficulty = BossSpawnerSea2.getDifficulty()
            else
                BossSpawnerSea2.disableAllActive(BossSpawnerSea2.getDifficulty())
            end
            refreshFarm()
        end,
    })
end

-- ============================================================
-- TAB: DUNGEON
-- ============================================================
do
    local sec = Tabs.Dungeon:AddSection("Dungeon / Boss Rush")

    sec:AddDropdown("Select Dungeon", {
        Title   = "Select Dungeon",
        Values  = {"Double Dungeon","Shadow Dungeon","Rune Dungeon","Boss Rush"},
        Multi   = false,
        Default = nil,
        Callback = DungeonController.onDungeonChanged,
    })

    sec:AddDropdown("Select Difficulty Dungeon", {
        Title   = "Select Difficulty Dungeon",
        Values  = {"Easy","Medium","Hard","Extreme"},
        Multi   = false,
        Default = nil,
        Callback = DungeonController.onDifficultyChanged,
    })

    sec:AddToggle("Auto Farm Dungeon", {
        Title    = "Auto Farm Dungeon",
        Default  = false,
        Callback = function(v)
            if v then DungeonController.start() else DungeonController.stop() end
        end,
    })

    if DungeonController.isInsideDungeon() then
        DungeonController.tryAutoResume()
    end

    local sec2 = Tabs.Dungeon:AddSection("Infinity Tower / Crystal Defense")

    sec2:AddInput("Select Floor to Restart", {
        Title       = "Select Floor to Restart",
        Default     = nil,
        Placeholder = "e.g. 50",
        Numeric     = true,
        Finished    = true,
        Callback    = TowerDefenseController.onFloorChanged,
    })

    sec2:AddToggle("Auto Farm Infinity Tower/Crystal Defense", {
        Title    = "Auto Farm Infinity Tower/Crystal Defense",
        Default  = false,
        Callback = function(v)
            if v then TowerDefenseController.start() else TowerDefenseController.stop() end
        end,
    })
end

-- ============================================================
-- TAB: SETTINGS
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
    Title    = "Mahmut-Hub | Sailor Piece",
    Content  = "Script loaded successfully!",
    Duration = 8,
})

-- ============================================================
-- CONFIG AUTO-SAVE / AUTO-LOAD
-- ============================================================
local configPath = "Mahmut-Hub/SailorPiece/settings/default.json"
if isfile(configPath) then
    pcall(function() SaveManager:Load("default") end)
else
    pcall(function() SaveManager:Save("default") end)
end
pcall(function() SaveManager:SetAutoloadConfig("default") end)

task.spawn(function()
    while true do
        task.wait(5)
        pcall(function() SaveManager:Save("default") end)
    end
end)

-- Sync dungeon/tower state after config load
DungeonController.syncLoadedState()
TowerDefenseController.syncLoadedState()

-- ============================================================
-- ANTI-AFK
-- ============================================================
task.spawn(function()
    while true do
        task.wait(30)
        if farmingActive then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0, 0))
            end)
            pcall(function()
                ReplicatedStorage.Remotes.AntiAFKHeartbeat:FireServer()
            end)
        end
    end
end)