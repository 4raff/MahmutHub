local SettingsTab = {}

function SettingsTab.build(context)
    local SaveManager = context.SaveManager
    local InterfaceManager = context.InterfaceManager
    local Fluent = context.Fluent
    local Tabs = context.Tabs

    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)

    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({})

    InterfaceManager:SetFolder("FluentScriptHub")
    SaveManager:SetFolder("FluentScriptHub/specific-game")

    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)
end

return SettingsTab
