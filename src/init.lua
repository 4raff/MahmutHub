local Dependencies = require(script.core.dependencies)
local WindowFactory = require(script.core.window)
local MainTab = require(script.tabs.main)
local SettingsTab = require(script.tabs.settings)

local Fluent = Dependencies.Fluent
local SaveManager = Dependencies.SaveManager
local InterfaceManager = Dependencies.InterfaceManager

local Window, Tabs = WindowFactory.create(Fluent)
local Options = Fluent.Options

local context = {
    Fluent = Fluent,
    SaveManager = SaveManager,
    InterfaceManager = InterfaceManager,
    Window = Window,
    Tabs = Tabs,
    Options = Options,
}

MainTab.build(context)
SettingsTab.build(context)

Window:SelectTab(1)

Fluent:Notify({
    Title = "Fluent",
    Content = "The script has been loaded.",
    Duration = 8,
})

SaveManager:LoadAutoloadConfig()
