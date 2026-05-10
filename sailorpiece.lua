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
local RunService        = game:GetService("RunService")
local Workspace         = game:GetService("Workspace")
local LocalPlayer       = Players.LocalPlayer

-- ============================================================
-- REMOTES
-- ============================================================
local RequestHit = ReplicatedStorage
    :WaitForChild("CombatSystem"):WaitForChild("Remotes"):WaitForChild("RequestHit")

local RequestAbility = ReplicatedStorage
    :WaitForChild("AbilitySystem"):WaitForChild("Remotes"):WaitForChild("RequestAbility")

-- ============================================================
-- EARLY STATE INITIALIZATION
-- ============================================================
local originalGravity    = Workspace.Gravity
local farmingActive      = false
local positioningConnection = nil
local positioningState   = { targetCF = nil, active = false }

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

function FarmController:isRunning()     return self._running   end
function FarmController:interrupt()     self._interrupt = true end
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
    positioningState.active = false
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

-- ============================================================
-- STATE
-- ============================================================
local AutoFarmState = {
    selectedEnemies = false,
    everyEnemy      = false,
    selectedOWB     = false,
    everyOWB        = false,
}
local SkillState  = { autoAll=false, bossOnly=false }
local skillRotIdx = 1
local lastStyle   = nil

local farmAnchorCFrame = nil
local lastYDistance    = nil

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
            if prefix and not OWB_NAME_MAP_REVERSE[npc.Name] then
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

-- ============================================================
-- COMBAT
-- ============================================================
local Combat = {}

-- Hitung posisi "aman" berdasarkan method & distY
local function getTargetCFrame(npcCF, method, distY)
    method = method or "Behind"
    distY  = distY  or 5

    if method == "Above" then
        return npcCF * CFrame.new(0,  distY, 0)
    elseif method == "Under" then
        return npcCF * CFrame.new(0, -distY, 0)
    else
        -- Behind: mundur dari NPC (sumbu Z lokal NPC)
        return npcCF * CFrame.new(0, 0, distY)
    end
end

-- ============================================================
-- [FIX UTAMA] Fire RequestHit dengan berbagai kombinasi parameter
-- Server Sailor Piece kemungkinan butuh NPC sebagai argument
-- ============================================================
local function fireRequestHit(npc, npcCF)
    -- Coba semua kemungkinan signature RequestHit server-side:

    -- 1. Kirim NPC model langsung
    pcall(function() RequestHit:FireServer(npc) end)
    task.wait(0.02)

    -- 2. Kirim NPC + posisi NPC
    pcall(function() RequestHit:FireServer(npc, npcCF.Position) end)
    task.wait(0.02)

    -- 3. Kirim NPC + CFrame
    pcall(function() RequestHit:FireServer(npc, npcCF) end)
    task.wait(0.02)

    -- 4. Tanpa argument (fallback, server pakai posisi player)
    pcall(function() RequestHit:FireServer() end)
end

function Combat.equipStyle()
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

function Combat.teleportTo(npc)
    local ok, npcCF = pcall(function() return npc:GetPivot() end)
    if not ok or not NPCProvider.isValidCFrame(npcCF) then return false end

    local char = LocalPlayer.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end

    local method = Options["Select Method Farm"] and Options["Select Method Farm"].Value or "Behind"
    local distY  = tonumber(Options["Distance Farm Y"] and Options["Distance Farm Y"].Value) or 5
    local targetCF = getTargetCFrame(npcCF, method, distY)

    pcall(function()
        hrp.CFrame = targetCF
        if hrp.AssemblyLinearVelocity then
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
        local hum = hrp.Parent:FindFirstChild("Humanoid")
        if hum then
            hum.PlatformStand = true
            task.wait(0.05)
            hum.PlatformStand = false
        end
    end)

    task.wait(0.1)

    if (hrp.CFrame.Position - targetCF.Position).Magnitude > 10 then
        pcall(function()
            hrp.CFrame = targetCF
            if hrp.AssemblyLinearVelocity then
                hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
        end)
    end

    return hrp.CFrame.Position.Y >= -10
end

function Combat.stayAtAnchor()
    if not farmAnchorCFrame then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local method = Options["Select Method Farm"] and Options["Select Method Farm"].Value or "Behind"
    local distY  = tonumber(Options["Distance Farm Y"] and Options["Distance Farm Y"].Value) or 5
    local targetCF = getTargetCFrame(farmAnchorCFrame, method, distY)

    local dist = (hrp.CFrame.Position - targetCF.Position).Magnitude
    if dist > 2 then
        pcall(function()
            hrp.CFrame = targetCF
            if hrp.AssemblyLinearVelocity then
                hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            end
        end)
    end
end

function Combat.setAnchorFromNPC(npc)
    if farmAnchorCFrame then return end
    local ok, npcCF = pcall(function() return npc:GetPivot() end)
    if ok and NPCProvider.isValidCFrame(npcCF) then
        farmAnchorCFrame = npcCF
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
-- ATTACK LOOP (dengan hitbox snap fix)
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

    -- Disconnect positioning connection sebelumnya
    if positioningConnection then
        positioningConnection:Disconnect()
        positioningConnection = nil
    end
    positioningState.active = false

    -- Baca method & distY
    local method = Options["Select Method Farm"] and Options["Select Method Farm"].Value or "Behind"
    local distY  = tonumber(Options["Distance Farm Y"] and Options["Distance Farm Y"].Value) or 5
    local safeCF = getTargetCFrame(npcCF, method, distY)

    -- Teleport ke posisi aman
    pcall(function()
        hrp.CFrame = safeCF
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end)

    if hum then hum.PlatformStand = true end

    farmAnchorCFrame = npcCF

    Combat.equipStyle()

    while NPCProvider.isAlive(npc) and tick() < deadline do
        if ctrl:wasInterrupted() then
            if hum then hum.PlatformStand = false end
            return "interrupted"
        end

        -- Update posisi NPC terbaru
        local okF, freshCF = pcall(function() return npc:GetPivot() end)
        if okF and NPCProvider.isValidCFrame(freshCF) then
            npcCF = freshCF
            if isBoss then farmAnchorCFrame = freshCF end
        end

        -- Update method & distY kalau berubah dari slider
        method = Options["Select Method Farm"] and Options["Select Method Farm"].Value or "Behind"
        distY  = tonumber(Options["Distance Farm Y"] and Options["Distance Farm Y"].Value) or 5
        safeCF = getTargetCFrame(npcCF, method, distY)

        -- Pastikan karakter di posisi aman
        pcall(function()
            hrp.CFrame = safeCF
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end)

        Combat.useSkill(isBoss)

        -- [FIX] Fire dengan NPC sebagai parameter
        fireRequestHit(npc, npcCF)

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
end

local function getOWBSelection()
    if AutoFarmState.everyOWB then return "all" end
    if AutoFarmState.selectedOWB then
        return Options["Select Open World Bosses"] and Options["Select Open World Bosses"].Value or {}
    end
    return nil
end

local function getNormalEnemyTypes()
    local seen  = {}
    local types = {}
    local folder = NPCProvider.getFolder()
    if not folder then return types end

    for _, npc in ipairs(folder:GetChildren()) do
        if npc:IsA("Model") and not OWB_NAME_MAP_REVERSE[npc.Name] then
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
-- MAIN FARM LOOP
-- ============================================================
local function farmLoop(ctrl)
    task.wait(0.5)

    farmAnchorCFrame = nil
    local owbWasActive = false

    while not ctrl:wasInterrupted() do
        if not anyFarmActive() then break end

        local owbSel  = getOWBSelection()
        local owbFound = false

        -- Priority 1: OWB
        if owbSel then
            local owbs = NPCProvider.queryOWB(owbSel)
            if #owbs > 0 then
                owbFound = true
                if not owbWasActive then
                    farmAnchorCFrame = nil
                    owbWasActive = true
                end
                for _, npc in ipairs(owbs) do
                    if ctrl:wasInterrupted() then break end
                    if not anyFarmActive() then break end
                    if NPCProvider.isAlive(npc) then
                        Combat.attackLoop(npc, true, ctrl)
                    end
                end
            else
                if owbWasActive then
                    owbWasActive = false
                    farmAnchorCFrame = nil
                end
            end
        else
            owbWasActive = false
        end

        -- Priority 2: Normal enemies
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

                    if owbSel then
                        local liveOWBs = NPCProvider.queryOWB(owbSel)
                        if #liveOWBs > 0 then break end
                    end

                    local npcsOfType = NPCProvider.queryNormal(function(p) return p == prefix end)

                    if #npcsOfType > 0 then
                        local okA, npcCF0 = pcall(function() return npcsOfType[1]:GetPivot() end)
                        if okA and NPCProvider.isValidCFrame(npcCF0) then
                            farmAnchorCFrame = npcCF0
                        end

                        for _, npc in ipairs(npcsOfType) do
                            if ctrl:wasInterrupted() then break end
                            if not (AutoFarmState.selectedEnemies or AutoFarmState.everyEnemy) then break end

                            if owbSel then
                                local liveOWBs = NPCProvider.queryOWB(owbSel)
                                if #liveOWBs > 0 then break end
                            end

                            if NPCProvider.isAlive(npc) then
                                Combat.attackLoop(npc, false, ctrl)
                            end
                        end
                    end
                end

                Combat.stayAtAnchor()
            end

        elseif not owbFound then
            Combat.stayAtAnchor()
            task.wait(1)
        end

        task.wait(0.05)
    end
end

local function startFarm()
    farmCtrl:start(farmLoop)
end

local function stopFarm()
    farmCtrl:stop()
    positioningState.active = false
    farmAnchorCFrame = nil
    if positioningConnection then
        positioningConnection:Disconnect()
        positioningConnection = nil
    end

    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChild("Humanoid")
        if hum then hum.PlatformStand = false end
        if hrp and hrp.AssemblyLinearVelocity then
            pcall(function() hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0) end)
        end
    end

    pcall(function() Workspace.Gravity = originalGravity end)
end

LocalPlayer.CharacterAdded:Connect(function()
    if anyFarmActive() then stopFarm() end
    lastStyle = nil
    farmAnchorCFrame = nil
    positioningState.active = false
    lastYDistance = nil
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
        Description = "Distance dari NPC. Jauh = NPC sulit hit kita. Script otomatis snap ke hitbox sebelum attack.",
        Default = 5, Min = 0, Max = 100, Rounding = 1,
        Callback = function(val)
            if syncing then return end
            syncing = true
            if DFYInput then DFYInput:SetValue(tostring(val)) end
            syncing = false
        end
    })

    DFYInput = CombatSection:AddInput("DistanceFarmYInput", {
        Title = "Distance Farm Y Input", Default = nil,
        Placeholder = "0-100", Numeric = true, Finished = true,
        Callback = function(val)
            local n = math.clamp(tonumber(val) or 5, 0, 100)
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
        Callback = function(v) print("OWB selected:", v) end
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
    print("Config ditemukan, loading...")
    pcall(function() SaveManager:Load("default") end)
else
    print("Config belum ada, membuat baru...")
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