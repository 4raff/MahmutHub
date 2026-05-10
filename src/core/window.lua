local WindowFactory = {}

function WindowFactory.create(Fluent)
    local window = Fluent:CreateWindow({
        Title = "MahmutHub " .. Fluent.Version,
        SubTitle = "by Mahmut",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Acrylic = true,
        Theme = "Dark",
        MinimizeKey = Enum.KeyCode.LeftControl,
    })

    local tabs = {
        Main = window:AddTab({ Title = "Main", Icon = "" }),
        Settings = window:AddTab({ Title = "Settings", Icon = "settings" }),
    }

    return window, tabs
end

return WindowFactory
