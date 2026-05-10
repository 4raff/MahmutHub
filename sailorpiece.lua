local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
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

local Options = Fluent.Options
local Toggles = Fluent.Toggles

-- ============================================================
-- SERVICES
-- ============================================================
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VIM               = game:GetService("VirtualInputManager")
local RunService        = game:GetService("RunService")
local LocalPlayer       = Players.LocalPlayer

-- ============================================================
-- REMOTES
-- ============================================================
local RequestHit = ReplicatedStorage
    :WaitForChild("CombatSystem"):WaitForChild("Remotes"):WaitForChild("RequestHit")

local RequestAbility = ReplicatedStorage
    :WaitForChild("AbilitySystem"):WaitForChild("Remotes"):WaitForChild("RequestAbility")

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

-- ============================================================
-- STATE
-- ============================================================
local AutoFarmState = { selectedEnemies=false, everyEnemy=false }
local SkillState    = { autoAll=false, bossOnly=false }
local farmThread    = nil
local skillRotIdx   = 1
local lastStyle     = nil

-- ============================================================
-- UTILITY
-- ============================================================
local function getPrefix(name)
    local prefix = tostring(name):match("^(.-)%d+$")
    if prefix and prefix ~= "" then return prefix end
    return nil
end

local function getNPCFolder()
    return workspace:FindFirstChild("NPCs")
end

local function isAlive(npc)
    local h = npc:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0
end

-- Ambil posisi NPC via GetPivot (work meski tidak ada BasePart)
local function getNPCPosition(npc)
    local ok, cf = pcall(function() return npc:GetPivot() end)
    if ok and cf then return cf end
    return nil
end

-- ============================================================
-- TELEPORT
-- ============================================================
local function safeTeleport(cf)
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    pcall(function() hrp.CFrame = cf end)
    RunService.Heartbeat:Wait()
end

local function teleportToNPC(npc)
    local npcCF = getNPCPosition(npc)
    if not npcCF then return end

    local methodValue = Options["Select Method Farm"] and Options["Select Method Farm"].Value or 1
    local distY  = tonumber(Options["Distance Farm Y"] and Options["Distance Farm Y"].Value) or 30
    local distZ  = tonumber(Options["Distance Farm Z"] and Options["Distance Farm Z"].Value) or 3

    local method = "Behind"
    if type(methodValue) == "number" then
        method = ({"Behind","Above","Under"})[methodValue] or "Behind"
    elseif type(methodValue) == "string" then
        method = methodValue
    end

    local cf
    if method == "Above" then
        cf = npcCF * CFrame.new(0, distY, 0)
    elseif method == "Under" then
        cf = npcCF * CFrame.new(0, -distY, 0)
    else -- Behind
        cf = npcCF * CFrame.new(0, 0, distZ)
    end

    safeTeleport(cf)
end

-- ============================================================
-- EQUIP COMBAT STYLE
-- ============================================================
local function equipCombatStyle()
    local styleValue = Options.Style and Options.Style.Value
    if not styleValue or styleValue == lastStyle then return end

    local kc = STYLE_KEYCODE[styleValue]
    if not kc then return end

    pcall(function()
        VIM:SendKeyEvent(true,  kc, false, game)
        task.wait(0.05)
        VIM:SendKeyEvent(false, kc, false, game)
    end)

    lastStyle = styleValue
    task.wait(0.3)
end

-- ============================================================
-- SKILL SYSTEM
-- ============================================================
local function useNextSkill(isBoss)
    if SkillState.bossOnly and not isBoss then return end
    if not SkillState.autoAll and not SkillState.bossOnly then return end

    local sel = Options.SelectSkills and Options.SelectSkills.Value
    if type(sel) ~= "table" then return end

    local active = {}
    for _, key in ipairs(SKILL_ORDER) do
        if sel[key] == true then
            table.insert(active, SKILL_KEY_MAP[key])
        end
    end
    if #active == 0 then return end

    if skillRotIdx > #active then skillRotIdx = 1 end
    pcall(function() RequestAbility:FireServer(active[skillRotIdx]) end)
    skillRotIdx = skillRotIdx + 1
    task.wait(0.5)
end

-- ============================================================
-- NPC LIST FUNCTIONS
-- ============================================================
local function getNormalEnemyTypes()
    local seen  = {}
    local types = {}
    local folder = getNPCFolder()
    if not folder then return types end
    for _, npc in ipairs(folder:GetChildren()) do
        if npc:IsA("Model") then
            local prefix = getPrefix(npc.Name)
            if prefix and not seen[prefix] then
                seen[prefix] = true
                table.insert(types, prefix)
            end
        end
    end
    table.sort(types)
    return types
end

local function getAllNormalNPCs()
    local list   = {}
    local folder = getNPCFolder()
    if not folder then return list end
    for _, npc in ipairs(folder:GetChildren()) do
        if npc:IsA("Model") and getPrefix(npc.Name) and isAlive(npc) then
            table.insert(list, npc)
        end
    end
    return list
end

local function getSelectedNPCs(selectedNames)
    local list   = {}
    local folder = getNPCFolder()
    if not folder then return list end
    for _, npc in ipairs(folder:GetChildren()) do
        if npc:IsA("Model") and isAlive(npc) then
            local prefix = getPrefix(npc.Name)
            if prefix and selectedNames[prefix] == true then
                table.insert(list, npc)
            end
        end
    end
    return list
end

local function groupByType(npcList)
    local groups = {}
    local order  = {}
    for _, npc in ipairs(npcList) do
        local prefix = getPrefix(npc.Name)
        if prefix then
            if not groups[prefix] then
                groups[prefix] = {}
                table.insert(order, prefix)
            end
            table.insert(groups[prefix], npc)
        end
    end
    return groups, order
end

-- ============================================================
-- ATTACK SINGLE NPC SAMPAI MATI (max 30 detik)
-- ============================================================
local function attackUntilDead(npc, isBoss)
    local deadline = tick() + 30
    while isAlive(npc) and tick() < deadline do
        if not AutoFarmState.selectedEnemies and not AutoFarmState.everyEnemy then return end

        equipCombatStyle()
        teleportToNPC(npc)
        useNextSkill(isBoss)
        pcall(function() RequestHit:FireServer() end)

        task.wait(0.15)
    end
end

-- ============================================================
-- FARM LOOP UTAMA
-- ============================================================
local function farmLoop()
    while true do
        if not AutoFarmState.selectedEnemies and not AutoFarmState.everyEnemy then break end

        local rawList
        if AutoFarmState.everyEnemy then
            rawList = getAllNormalNPCs()
        else
            local sel = Options["Select Enemies"] and Options["Select Enemies"].Value or {}
            rawList   = getSelectedNPCs(sel)
        end

        if #rawList == 0 then
            task.wait(1)
        else
            local groups, order = groupByType(rawList)
            for _, typeName in ipairs(order) do
                if not AutoFarmState.selectedEnemies and not AutoFarmState.everyEnemy then break end
                for _, npc in ipairs(groups[typeName]) do
                    if not AutoFarmState.selectedEnemies and not AutoFarmState.everyEnemy then break end
                    if isAlive(npc) then
                        attackUntilDead(npc, false)
                    end
                end
                task.wait(0.3)
            end
            task.wait(0.5)
        end
    end
    farmThread = nil
end

local function startFarm()
    if farmThread then return end
    farmThread = task.spawn(farmLoop)
end

local function stopFarm()
    if farmThread then
        task.cancel(farmThread)
        farmThread = nil
    end
end

LocalPlayer.CharacterAdded:Connect(function()
    lastStyle = nil
end)

-- ============================================================
-- FARMING SETTINGS TAB
-- ============================================================
do
    local CombatSection = Tabs.FarmingSettings:AddSection("Combat Settings")

    CombatSection:AddDropdown("Style", {
        Title = "Combat Style", Values = {"Melee","Sword","Power"},
        Multi = false, Default = "",
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
        Title = "Distance Farm Y", Description = "Distance on Y axis.",
        Default = 30, Min = 0, Max = 100, Rounding = 1,
        Callback = function(val)
            if syncing then return end
            syncing = true
            if DFYInput then DFYInput:SetValue(tostring(val)) end
            syncing = false
        end
    })

    DFYInput = CombatSection:AddInput("DistanceFarmYInput", {
        Title = "Distance Farm Y Input", Default = "30",
        Placeholder = "0-100", Numeric = true, Finished = true,
        Callback = function(val)
            local n = math.clamp(tonumber(val) or 30, 0, 100)
            if syncing then return end
            syncing = true
            DFYSlider:SetValue(n)
            syncing = false
        end
    })

    local DFZInput

    local DFZSlider = CombatSection:AddSlider("Distance Farm Z", {
        Title = "Distance Farm Z", Description = "Distance on Z axis (Behind method).",
        Default = 3, Min = 0, Max = 50, Rounding = 1,
        Callback = function(val)
            if syncing then return end
            syncing = true
            if DFZInput then DFZInput:SetValue(tostring(val)) end
            syncing = false
        end
    })

    DFZInput = CombatSection:AddInput("DistanceFarmZInput", {
        Title = "Distance Farm Z Input", Default = "3",
        Placeholder = "0-50", Numeric = true, Finished = true,
        Callback = function(val)
            local n = math.clamp(tonumber(val) or 3, 0, 50)
            if syncing then return end
            syncing = true
            DFZSlider:SetValue(n)
            syncing = false
        end
    })

    CombatSection:AddDropdown("Select Method Farm", {
        Title = "Select Method Farm", Values = {"Behind","Above","Under"},
        Multi = false, Default = 1,
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
        Callback = function(v) print("Selected Enemies:", v) end
    })

    FarmingNPCs:AddToggle("Auto Farm Selected Enemies", {
        Title = "Auto Farm Selected Enemies", Default = false,
        Callback = function(value)
            AutoFarmState.selectedEnemies = value
            if value and AutoFarmState.everyEnemy then
                AutoFarmState.everyEnemy = false
                Toggles["Auto Farm Every Enemies"]:SetValue(false)
            end
            if value then startFarm() else stopFarm() end
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
            if value then startFarm() else stopFarm() end
        end
    })

    -- ── Open World Bosses ──────────────────────────────────────
    local FarmingOWB = Tabs.Farming:AddSection("Select Open World Bosses To Farm")
    FarmingOWB:AddDropdown("Select Open World Bosses", {
        Title = "Select Open World Bosses",
        Values = {"Vampire King","Solo Hunter","Limitless Sorcerer","Cursed Vessel","Cursed King","Manipulator","Yamato","Strongest Shinobi"},
        Multi = true, Default = {},
        Callback = function(v) print("OWB selected:", v) end
    })
    FarmingOWB:AddToggle("Auto Farm Selected Open World Bosses", {
        Title = "Auto Farm Selected Open World Bosses", Default = false,
        Callback = function(v) print("Auto Farm Selected OWB:", v) end
    })
    FarmingOWB:AddToggle("Auto Farm Every Open World Bosses", {
        Title = "Auto Farm Every Open World Bosses", Default = false,
        Callback = function(v) print("Auto Farm Every OWB:", v) end
    })

    -- ── World Bosses ───────────────────────────────────────────
    local FarmingWB = Tabs.Farming:AddSection("Select World Bosses To Farm")
    FarmingWB:AddDropdown("Select World Bosses", {
        Title = "Select World Bosses", Values = {"Sun God","Cosmic Being"},
        Multi = true, Default = {},
        Callback = function(v) print("WB selected:", v) end
    })
    FarmingWB:AddToggle("Auto Farm Selected World Bosses", {
        Title = "Auto Farm Selected World Bosses", Default = false,
        Callback = function(v) print("Auto Farm Selected WB:", v) end
    })
    FarmingWB:AddToggle("Auto Farm Every World Bosses", {
        Title = "Auto Farm Every World Bosses", Default = false,
        Callback = function(v) print("Auto Farm Every WB:", v) end
    })

    -- ── Boss Spawners ──────────────────────────────────────────
    local FarmingBS = Tabs.Farming:AddSection("Select Boss Spawners To Farm")
    FarmingBS:AddDropdown("Select Boss Spawners", {
        Title = "Select Boss Spawners",
        Values = {"Excalibur","Qin Shi","Soul Reapper","King Of Heroes","Corrupted Knight","Blessed Maiden","Moon Slayer","Ice Queen","The World","Strongest of Today","Strongest of History","Demon Lord","Demon King","True Manipulator","Atomic"},
        Multi = true, Default = {},
        Callback = function(v) print("BS selected:", v) end
    })
    FarmingBS:AddToggle("Auto Farm Selected Boss Spawners", {
        Title = "Auto Farm Selected Boss Spawners", Default = false,
        Callback = function(v) print("Auto Farm Selected BS:", v) end
    })
end

-- ============================================================
-- ADDONS & SAVE MANAGER
-- ============================================================
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("Mahmut-Hub")
SaveManager:SetFolder("MahmutHub/SailorPiece")

if Tabs and Tabs.Settings then
    pcall(function() InterfaceManager:BuildInterfaceSection(Tabs.Settings) end)
    pcall(function() SaveManager:BuildConfigSection(Tabs.Settings) end)
end

Window:SelectTab(1)

Fluent:Notify({
    Title = "Mahmut-Hub | Sailor Piece",
    Content = "Script loaded successfully!",
    Duration = 8
})

SaveManager:LoadAutoloadConfig()

task.spawn(function()
    while task.wait(5) do
        pcall(function()
            local cfg = SaveManager.CurrentConfig
            SaveManager:Save(cfg and cfg ~= "" and cfg or "default")
        end)
    end
end)