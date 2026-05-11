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
    Settings        = Window:AddTab({ Title = "Settings",         Icon = "settings" }),
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
    if TeleportToPortal then
        print("[DEBUG] ✅ TeleportToPortal remote LOADED successfully")
    else
        print("[DEBUG] ❌ TeleportToPortal remote FAILED to load")
    end
end)
if not TeleportToPortal then
    print("[DEBUG] ⚠️ WARNING: TeleportToPortal remote is NIL!")
end

-- Island portal mapping
local ISLAND_PORTALS = {
    ["Starter"] = "Starter",
    ["Jungle"] = "Jungle",
    ["Desert"] = "Desert",
    ["Snow"] = "Snow",
    ["Sailor"] = "Sailor",
    ["Boss"] = "Boss",
    ["Shibuya"] = "Shibuya",
    ["HollowIsland"] = "HollowIsland",
    ["Shinjuku"] = "Shinjuku",
    ["Slime"] = "Slime",
    ["Academy"] = "Academy",
    ["Judgement"] = "Judgement",
    ["SoulDominion"] = "SoulDominion",
    ["Ninja"] = "Ninja",
    ["Lawless"] = "Lawless",
    ["StarterSea2"] = "StarterSea2",
    ["Punch"] = "Punch",
    ["Bizarre"] = "Bizarre",
    ["BluePlanet"] = "BluePlanet",
    ["Slayer"] = "Slayer",
}

-- NPC/Enemy to Island mapping
local ENEMY_TO_ISLAND = {
    -- Sea 1 - Starter
    ["Thief"] = "Starter",
    
    -- Sea 1 - Jungle
    ["Monkey"] = "Jungle",
    
    -- Sea 1 - Desert
    ["DessertBandit"] = "Desert",
    
    -- Sea 1 - Snow
    ["FrostRogue"] = "Snow",
    
    -- Sailor (OWB: SoloHunter/JinwooBoss, VampireKing/AlucardBoss)
    ["SoloHunter"] = "Sailor",
    ["JinwooBoss"] = "Sailor",
    ["VampireKing"] = "Sailor",
    ["AlucardBoss"] = "Sailor",
    
    -- Shibuya (Enemy: Sorcerer1-6, OWB: CursedVessel/YujiBoss, LimitlessSorcerer/GojoBoss, CursedKing/SukunaBoss)
    ["Sorcerer"] = "Shibuya",
    ["CursedVessel"] = "Shibuya",
    ["YujiBoss"] = "Shibuya",
    ["LimitlessSorcerer"] = "Shibuya",
    ["GojoBoss"] = "Shibuya",
    ["CursedKing"] = "Shibuya",
    ["SukunaBoss"] = "Shibuya",
    
    -- HollowIsland (Enemy: Hollow1-6, OWB: Manipulator/AizenBoss)
    ["Hollow"] = "HollowIsland",
    ["Manipulator"] = "HollowIsland",
    ["AizenBoss"] = "HollowIsland",
    
    -- Shinjuku (Enemy: Curse1-6, StrongSorcerer1-6)
    ["Curse"] = "Shinjuku",
    ["StrongSorcerer"] = "Shinjuku",
    
    -- Slime (Enemy: Slime1-6)
    ["Slime"] = "Slime",
    
    -- Academy (Enemy: AcademyTeacher1-6)
    ["AcademyTeacher"] = "Academy",
    
    -- Judgement (Enemy: Swordsman1-6, OWB: Yamato/YamatoBoss)
    ["Swordsman"] = "Judgement",
    ["Yamato"] = "Judgement",
    ["YamatoBoss"] = "Judgement",
    
    -- SoulDominion (Enemy: Quincy1-6)
    ["Quincy"] = "SoulDominion",
    
    -- Ninja (Enemy: Ninja1-6, OWB: StrongestShinobi/StrongestShinobiBoss)
    ["Ninja"] = "Ninja",
    ["StrongestShinobi"] = "Ninja",
    ["StrongestShinobiBoss"] = "Ninja",
    
    -- Lawless (Enemy: ArenaFighter1-6)
    ["ArenaFighter"] = "Lawless",
    
    -- StarterSea2 (Enemy: Delinquent, StrongFighter)
    ["Delinquent"] = "StarterSea2",
    ["StrongFighter"] = "StarterSea2",
    
    -- Punch (Enemy: FastNinja, WB: CosmicBeing/CosmicBeingBoss_Normal)
    ["FastNinja"] = "Punch",
    ["CosmicBeing"] = "Punch",
    ["CosmicBeingBoss_Normal"] = "Punch",
    
    -- Bizarre (Enemy: StrongBandit)
    ["StrongBandit"] = "Bizarre",
    
    -- BluePlanet (Enemy: SpiritFighter)
    ["SpiritFighter"] = "BluePlanet",
    
    -- Slayer (Enemy: StrongSlayer, WB: SunGod/SunGodBoss_Normal)
    ["StrongSlayer"] = "Slayer",
    ["SunGod"] = "Slayer",
    ["SunGodBoss_Normal"] = "Slayer",
}

-- Get island from enemy/NPC name
local function getIslandFromEnemy(enemyName)
    if not enemyName then 
        print("[DEBUG] getIslandFromEnemy: enemyName is NIL")
        return nil 
    end
    
    -- Try exact match first
    if ENEMY_TO_ISLAND[enemyName] then
        local island = ENEMY_TO_ISLAND[enemyName]
        print("[DEBUG] getIslandFromEnemy: " .. enemyName .. " → " .. island .. " (exact match)")
        return island
    end
    
    -- Try prefix match (e.g., "Thief1" → "Thief")
    -- Inline getPrefix logic to avoid dependency issues
    local prefix = tostring(enemyName):match("^(.-)%d+$")
    if prefix and ENEMY_TO_ISLAND[prefix] then
        local island = ENEMY_TO_ISLAND[prefix]
        print("[DEBUG] getIslandFromEnemy: " .. enemyName .. " → " .. island .. " (prefix: " .. prefix .. ")")
        return island
    end
    
    print("[DEBUG] ❌ getIslandFromEnemy: " .. enemyName .. " NOT FOUND in mapping")
    return nil
end

-- ============================================================
-- STATE
-- ============================================================
local originalGravity  = Workspace.Gravity
local farmingActive    = false
local farmAnchorCFrame = nil
local lastAnchorCFrame = nil
local lastTeleportedIsland = nil  -- Track last portal teleport untuk avoid spam

-- ============================================================
-- DEBUG TRACKING
-- ============================================================
local lastTeleportPos = nil
local lastServerPos = nil
local positionResetCount = 0

local function trackPositionChanges()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local currentPos = hrp.Position
    
    if lastTeleportPos then
        local diffFromTarget = (currentPos - lastTeleportPos).Magnitude
        if diffFromTarget > 5 and lastServerPos then
            local diffFromLast = (currentPos - lastServerPos).Magnitude
            if diffFromLast > 1 then
                positionResetCount = positionResetCount + 1
                print("[DEBUG] 🚫 Server RESET posisi! | Reset #" .. positionResetCount .. " | Diff: " .. math.floor(diffFromTarget) .. " studs")
                print("[DEBUG] 📍 Target: " .. tostring(lastTeleportPos))
                print("[DEBUG] 📍 Posisi sekarang: " .. tostring(currentPos))
            end
        end
    end
    
    lastServerPos = currentPos
end

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
    print("[FARM] ▶️ Auto Farm MULAI")
    pcall(function() Workspace.Gravity = 0 end)
    self._thread = task.spawn(function()
        local ok, err = pcall(loopFn, self)
        if not ok then warn("[FarmController] Loop error:", err) end
        self._running = false
        self._thread  = nil
        farmingActive = false
        print("[FARM] ⏹️ Auto Farm BERHENTI")
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
}

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

-- Helper: Check apakah karakter sudah hold tool (untuk optimize equip di awal farm)
local function isToolEquipped()
    local char = LocalPlayer.Character
    if not char then return false end
    
    local toolCount = 0
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Tool") then
            toolCount = toolCount + 1
        end
    end
    
    local result = toolCount > 0
    print("[DEBUG] isToolEquipped: " .. tostring(result) .. " (found: " .. toolCount .. " tools)")
    return result
end

-- ============================================================
-- COMBAT
-- ============================================================
local Combat = {}

local function getTargetCFrame(npcCF, method, distY)
    method = method or "Behind"
    distY  = distY  or 5

    local npcPos = npcCF.Position
    local targetPos
    
    if method == "Above" then
        -- Karakter di atas NPC, rotasi 90° forward = memandang ke bawah
        targetPos = npcPos + Vector3.new(0, distY, 0)
        -- CFrame.lookAt(eye, focus, up) - karakter lookAt NPC dengan up ke belakang
        return CFrame.lookAt(targetPos, npcPos, Vector3.new(0, 0, -1))
    elseif method == "Under" then
        -- Karakter di bawah NPC, rotasi -90° forward = memandang ke atas
        targetPos = npcPos + Vector3.new(0, -distY, 0)
        -- CFrame.lookAt dengan up ke depan
        return CFrame.lookAt(targetPos, npcPos, Vector3.new(0, 0, 1))
    else
        -- Behind: Karakter di belakang NPC, memandang ke depan (normal)
        targetPos = npcPos + Vector3.new(0, 0, distY)
        -- CFrame.lookAt dengan up ke atas
        return CFrame.lookAt(targetPos, npcPos, Vector3.new(0, 1, 0))
    end
end

-- Teleport system: Portal (legit remote) → Instant mob teleport (short distance)
local function teleportCharacter(targetCF, islandName)
    local char = LocalPlayer.Character
    if not char then 
        print("[TELEPORT] ❌ No character found")
        return 
    end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then 
        print("[TELEPORT] ❌ No HRP found")
        return 
    end

    local targetPos = targetCF.Position
    
    print("[TELEPORT] 📍 Called with islandName=" .. tostring(islandName) .. ", lastTeleportedIsland=" .. tostring(lastTeleportedIsland) .. ", TeleportToPortal=" .. tostring(TeleportToPortal ~= nil))
    
    -- Step 1: Teleport to portal ONLY if island is different from last teleported island
    if islandName and ISLAND_PORTALS[islandName] then
        if islandName ~= lastTeleportedIsland then
            if TeleportToPortal then
                print("[TELEPORT] 🌐 Portal: Firing TeleportToPortal(\"" .. islandName .. "\") [DIFFERENT ISLAND]")
                local ok, err = pcall(function()
                    TeleportToPortal:FireServer(ISLAND_PORTALS[islandName])
                end)
                if not ok then
                    print("[TELEPORT] ❌ Error firing TeleportToPortal: " .. tostring(err))
                else
                    print("[TELEPORT] ✅ TeleportToPortal fired successfully")
                    lastTeleportedIsland = islandName  -- Update last teleported island
                end
            else
                print("[TELEPORT] ❌ TeleportToPortal is NIL, skipping portal teleport")
            end
            task.wait(0.5)  -- Wait portal teleport complete
        else
            print("[TELEPORT] ⏭️ SKIP: Already on " .. islandName .. ", no portal teleport needed")
        end
    else
        print("[TELEPORT] ⚠️ No island or island not in map. islandName=" .. tostring(islandName))
    end
    
    -- Step 2: Instant CFrame teleport to mob (short distance from portal = safe) - INCLUDE ROTATION!
    local distance = (hrp.Position - targetPos).Magnitude
    if distance > 1 then
        print("[TELEPORT] 🎯 Mob: Instant teleport with rotation | Distance: " .. math.floor(distance) .. " studs")
        
        -- Kill velocity & anchor HRP sebelum rotate
        pcall(function()
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)
        
        -- Apply CFrame dengan rotation
        hrp.CFrame = targetCF
        
        -- Set Anchored untuk prevent fling physics
        pcall(function()
            hrp.Anchored = true
        end)
        
        task.wait(0.05)
        
        -- Unanchor setelah teleport selesai
        pcall(function()
            hrp.Anchored = false
        end)
    end
end


-- Fire RequestHit sekali saja dengan NPC sebagai argument
local function fireRequestHit(npc)
    pcall(function() RequestHit:FireServer(npc) end)
end

function Combat.equipStyle()
    local styleValue = Options.Style and Options.Style.Value
    if not styleValue then 
        print("[EQUIP] ❌ No style selected")
        return 
    end

    local char = LocalPlayer.Character
    if not char then 
        print("[EQUIP] ❌ No character")
        return 
    end

    -- PENTING: Always equip jika lastStyle berbeda (jangan compare dengan nil atau cache)
    -- Skip hanya jika EXACTLY sama dan sudah ada tool
    local hasToolEquipped = isToolEquipped()
    
    if styleValue == lastStyle and hasToolEquipped then
        print("[EQUIP] ⏭️ Already equipped: " .. styleValue .. " (verified)", ", skipping")
        return
    end

    print("[EQUIP] 🎯 Switching to: " .. styleValue .. " | lastStyle: " .. tostring(lastStyle) .. " | hasToolEquipped: " .. tostring(hasToolEquipped))
    
    local kc = STYLE_KEYCODE[styleValue]
    if not kc then 
        print("[EQUIP] ❌ Invalid style keycode for: " .. styleValue)
        return 
    end
    
    -- Unequip tool lama dulu sebelum equip yang baru
    if hasToolEquipped then
        print("[EQUIP] 🔄 Unequipping old tool first")
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") then
                pcall(function() item.Parent = game:GetService("Players").LocalPlayer.Backpack end)
            end
        end
        task.wait(0.1)
    end
    
    -- Equip dengan keycode
    print("[EQUIP] 📤 Sending keycode: " .. tostring(kc))
    local ok, err = pcall(function()
        VIM:SendKeyEvent(true,  kc, false, game)
        task.wait(0.05)
        VIM:SendKeyEvent(false, kc, false, game)
    end)
    
    if not ok then
        print("[EQUIP] ❌ Error sending keycode: " .. tostring(err))
        return
    end
    
    lastStyle = styleValue
    print("[EQUIP] ✅ Successfully equipped: " .. styleValue)
    task.wait(0.3)
end

function Combat.teleportTo(npc)
    print("[COMBAT.TELEPORTTO] 🎯 Called for NPC: " .. npc.Name)
    local ok, npcCF = pcall(function() return npc:GetPivot() end)
    if not ok or not NPCProvider.isValidCFrame(npcCF) then 
        print("[COMBAT.TELEPORTTO] ❌ Invalid NPC CFrame")
        return false 
    end

    local method   = Options["Select Method Farm"] and Options["Select Method Farm"].Value or "Behind"
    local distY    = tonumber(Options["Distance Farm Y"] and Options["Distance Farm Y"].Value) or 5
    local targetCF = getTargetCFrame(npcCF, method, distY)
    
    -- Auto-detect island from enemy name
    local island = getIslandFromEnemy(npc.Name)
    print("[COMBAT.TELEPORTTO] 🏝️ Detected island: " .. tostring(island))
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
    print("[COMBAT.ATTACKLOOP] 🎬 Called for NPC: " .. npc.Name .. " (isBoss: " .. tostring(isBoss) .. ")")
    local hitCount = 0
    local deadline = tick() + (isBoss and 120 or 45)

    local ok, npcCF = pcall(function() return npc:GetPivot() end)
    if not ok or not NPCProvider.isValidCFrame(npcCF) then 
        print("[COMBAT.ATTACKLOOP] ❌ Invalid NPC CFrame")
        return "invalid" 
    end

    local char = LocalPlayer.Character
    if not char then 
        print("[COMBAT.ATTACKLOOP] ❌ No character")
        return "no_char" 
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then 
        print("[COMBAT.ATTACKLOOP] ❌ No HRP")
        return "no_hrp" 
    end
    local hum = char:FindFirstChild("Humanoid")

    local method = Options["Select Method Farm"] and Options["Select Method Farm"].Value or "Behind"
    local distY  = tonumber(Options["Distance Farm Y"] and Options["Distance Farm Y"].Value) or 5
    local safeCF = getTargetCFrame(npcCF, method, distY)
    local island = getIslandFromEnemy(npc.Name)

    print("[COMBAT.ATTACKLOOP] 🚀 First teleport to safeCF with island=" .. tostring(island))
    teleportCharacter(safeCF, island)

    if hum then hum.PlatformStand = true end

    farmAnchorCFrame = npcCF
    Combat.equipStyle()
    print("[COMBAT.ATTACKLOOP] 🎯 Calling Combat.teleportTo")
    Combat.teleportTo(npc)

    while NPCProvider.isAlive(npc) and tick() < deadline do
        if ctrl:wasInterrupted() then
            if hum then hum.PlatformStand = false end
            return "interrupted"
        end

        -- Update posisi NPC terbaru
        local okF, freshCF = pcall(function() return npc:GetPivot() end)
        if okF and NPCProvider.isValidCFrame(freshCF) then
            npcCF = freshCF
            -- Anchor selalu ikut NPC, baik boss maupun normal
            farmAnchorCFrame = freshCF
        end

        -- Update method & distY dari setting terbaru
        method = Options["Select Method Farm"] and Options["Select Method Farm"].Value or "Behind"
        distY  = tonumber(Options["Distance Farm Y"] and Options["Distance Farm Y"].Value) or 5
        safeCF = getTargetCFrame(npcCF, method, distY)

        local char2 = LocalPlayer.Character
        if char2 then
            local hrp2 = char2:FindFirstChild("HumanoidRootPart")
            if hrp2 and (hrp2.CFrame.Position - safeCF.Position).Magnitude > 5 then
                local island = getIslandFromEnemy(npc.Name)
                teleportCharacter(safeCF, island)
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

-- Helper: simpan posisi karakter saat ini ke lastAnchorCFrame
local function saveCurrentPosition()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        lastAnchorCFrame = hrp.CFrame
    end
end

-- ============================================================
-- MAIN FARM LOOP
-- ============================================================
local function farmLoop(ctrl)
    print("[FARM] 🔄 farmLoop STARTED")
    
    -- Cek apakah sudah pegang tool saat farm dimulai
    local styleValue = Options.Style and Options.Style.Value
    print("[FARM] 🎯 Selected style: " .. tostring(styleValue))
    
    if styleValue then
        if isToolEquipped() then
            print("[FARM] ✅ Already holding tool, verifying it's the right style...")
            lastStyle = styleValue  -- Mark sebagai sudah equipped
        else
            print("[FARM] 🛠️ No tool equipped, equipping now...")
            Combat.equipStyle()  -- Force equip
        end
    else
        print("[FARM] ⚠️ No style selected in Options!")
    end
    
    task.wait(0.5)

    farmAnchorCFrame = nil
    lastAnchorCFrame = nil
    lastTeleportedIsland = nil  -- Reset portal tracking untuk session baru

    local owbWasActive = false
    local wbWasActive  = false

    while not ctrl:wasInterrupted() do
        if not anyFarmActive() then 
            print("[FARM] ⚠️ Farm not active, breaking loop")
            break 
        end

        local owbSel   = getOWBSelection()
        local wbSel    = getWBSelection()
        local owbFound = false
        local wbFound  = false

        -- ------------------------------------------------
        -- Priority 1: World Bosses
        -- ------------------------------------------------
        if wbSel then
            local wbs = NPCProvider.queryWB(wbSel)
            if #wbs > 0 then
                wbFound = true
                if not wbWasActive then
                    farmAnchorCFrame = nil
                    lastAnchorCFrame = nil
                    wbWasActive = true
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

        -- ------------------------------------------------
        -- Priority 2: Open World Bosses
        -- ------------------------------------------------
        if owbSel then
            local owbs = NPCProvider.queryOWB(owbSel)
            if #owbs > 0 then
                owbFound = true
                if not owbWasActive then
                    farmAnchorCFrame = nil
                    lastAnchorCFrame = nil
                    owbWasActive = true
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

        -- ------------------------------------------------
        -- Priority 3: Normal Enemies
        -- ------------------------------------------------
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

                    -- Cek kalau ada OWB/WB yang spawn, prioritaskan (OUTER CHECK ONLY)
                    if owbSel and #NPCProvider.queryOWB(owbSel) > 0 then break end
                    if wbSel  and #NPCProvider.queryWB(wbSel)  > 0 then break end

                    local npcsOfType = NPCProvider.queryNormal(function(p) return p == prefix end)

                    if #npcsOfType > 0 then
                        -- Set anchor ke NPC pertama dari tipe ini
                        local okA, npcCF0 = pcall(function() return npcsOfType[1]:GetPivot() end)
                        if okA and NPCProvider.isValidCFrame(npcCF0) then
                            farmAnchorCFrame = npcCF0
                        end

                        print("[FARM] 🎯 Starting farm for enemy type: " .. prefix .. " (" .. #npcsOfType .. " enemies)")
                        
                        for _, npc in ipairs(npcsOfType) do
                            if ctrl:wasInterrupted() then break end
                            if not (AutoFarmState.selectedEnemies or AutoFarmState.everyEnemy) then break end
                            -- REMOVED: OWB/WB check here - let enemy type finish first

                            if NPCProvider.isAlive(npc) then
                                print("[FARM] 🔫 Attacking: " .. npc.Name)
                                Combat.attackLoop(npc, false, ctrl)
                                -- Sama seperti boss: simpan posisi saat enemy mati
                                if not NPCProvider.isAlive(npc) then
                                    saveCurrentPosition()
                                    farmAnchorCFrame = nil
                                end
                            end
                        end
                        
                        print("[FARM] ✅ Finished farm for enemy type: " .. prefix)
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
    farmAnchorCFrame = nil
    lastAnchorCFrame = nil
    lastTeleportedIsland = nil  -- Reset portal tracking

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
    lastStyle        = nil
    farmAnchorCFrame = nil
    lastAnchorCFrame = nil
    lastTeleportedIsland = nil  -- Reset saat respawn
end)

-- ============================================================
-- FARMING SETTINGS TAB
-- ============================================================
do
    local CombatSection = Tabs.FarmingSettings:AddSection("Combat Settings")

    CombatSection:AddDropdown("Style", {
        Title = "Combat Style", Values = {"Melee","Sword","Power"},
        Multi = false, Default = nil,
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
        Title = "Distance Farm Y",
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
        Title = "Select Open World Bosses",
        Values = {"Vampire King","Solo Hunter","Limitless Sorcerer","Cursed Vessel","Cursed King","Manipulator","Yamato","Strongest Shinobi"},
        Multi = true, Default = {},
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

    local FarmingWB = Tabs.Farming:AddSection("Select World Bosses To Farm")

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
        Title = "Select Boss Spawners",
        Values = {"Excalibur","Qin Shi","Soul Reapper","King Of Heroes","Corrupted Knight","Blessed Maiden","Moon Slayer","Ice Queen","The World","Strongest of Today","Strongest of History","Demon Lord","Demon King","True Manipulator","Atomic"},
        Multi = true, Default = {},
    })

    FarmingBS:AddToggle("Auto Farm Selected Boss Spawners", {
        Title = "Auto Farm Selected Boss Spawners", Default = false,
        Callback = function(v) print("Auto Farm Selected BS:", v) end
    })

    local FarmingBS2 = Tabs.Farming:AddSection("Select Boss Spawners To Farm (Sea 2 Only)")

    FarmingBS2:AddDropdown("Select Boss Spawners 2", {
        Title = "Select Boss Spawners 2",
        Values = {"The World","Spirit King"},
        Multi = true, Default = {},
    })

    FarmingBS2:AddToggle("Auto Farm Selected Boss Spawners 2", {
        Title = "Auto Farm Selected Boss Spawners 2", Default = false,
        Callback = function(v) print("Auto Farm Selected BS2:", v) end
    })
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
    Title = "Mahmut-Hub | Sailor Piece",
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