-- ========== MODERN BLACK & WHITE CARTOON LOADER ==========
local M = {}
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
M.CreateUILoader = function()
    local player = Players.LocalPlayer
    
    local gui = Instance.new("ScreenGui")
    gui.Name = "MahmutHubLoader"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 9999
    gui.Parent = player:WaitForChild("PlayerGui")
    
    -- BACKGROUND BLUR
    local blurBg = Instance.new("ImageLabel")
    blurBg.Size = UDim2.new(1, 0, 1, 0)
    blurBg.Position = UDim2.new(0, 0, 0, 0)
    blurBg.BackgroundTransparency = 1
    blurBg.Image = "rbxassetid://1316045217"
    blurBg.ImageColor3 = Color3.fromRGB(0, 0, 0)
    blurBg.ImageTransparency = 0.3
    blurBg.ZIndex = 0
    blurBg.Parent = gui
    
    -- Dark overlay
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.5
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 1
    overlay.Parent = gui
    
    -- CONTAINER (centered)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 480, 0, 260)
    container.Position = UDim2.new(0.5, -240, 0.5, -130)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ZIndex = 10
    container.Parent = gui
    
    -- SHADOW (WHITE card behind, offset to BOTTOM-RIGHT)
    local shadow = Instance.new("Frame")
    shadow.Size = UDim2.new(0, 480, 0, 260)
    shadow.Position = UDim2.new(0, 8, 0, 8) -- Offset +8 +8 (bottom right)
    shadow.BackgroundColor3 = Color3.fromRGB(255, 255, 255) -- WHITE
    shadow.BackgroundTransparency = 0
    shadow.BorderSizePixel = 0
    shadow.ZIndex = 10
    shadow.Parent = container
    
    local shadowCorner = Instance.new("UICorner")
    shadowCorner.CornerRadius = UDim.new(0, 20)
    shadowCorner.Parent = shadow
    
    -- MAIN CARD (BLACK card in front, NO offset)
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 480, 0, 260)
    main.Position = UDim2.new(0, 0, 0, 0) -- NO offset, exact position
    main.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- BLACK
    main.BackgroundTransparency = 0
    main.BorderSizePixel = 0
    main.ZIndex = 11
    main.Parent = container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 20)
    corner.Parent = main
    
    -- LOGO: Mahmut Hub icon
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 50, 0, 50)
    icon.Position = UDim2.new(0, 30, 0, 30)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://79791092079055"
    icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    icon.ZIndex = 12
    icon.Parent = main
    
    -- Bounce animation
    task.spawn(function()
        while icon and icon.Parent do
            TweenService:Create(icon, TweenInfo.new(0.4, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), 
                {Position = UDim2.new(0, 30, 0, 22)}):Play()
            task.wait(0.4)
            TweenService:Create(icon, TweenInfo.new(0.4, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), 
                {Position = UDim2.new(0, 30, 0, 30)}):Play()
            task.wait(0.4)
        end
    end)
    
    -- Title "MAHMUT HUB" - WHITE text
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 300, 0, 40)
    title.Position = UDim2.new(0, 100, 0, 30)
    title.BackgroundTransparency = 1
    title.Text = "MAHMUT HUB"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 32
    title.Font = Enum.Font.Cartoon
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 12
    title.Parent = main
    
    -- Subtitle - GRAY text
    local gameName = Instance.new("TextLabel")
    gameName.Size = UDim2.new(0, 300, 0, 20)
    gameName.Position = UDim2.new(0, 100, 0, 70)
    gameName.BackgroundTransparency = 1
    gameName.Text = "Initializing..."
    gameName.TextColor3 = Color3.fromRGB(150, 150, 150)
    gameName.TextSize = 14
    gameName.Font = Enum.Font.Cartoon
    gameName.TextXAlignment = Enum.TextXAlignment.Left
    gameName.Name = "GameName"
    gameName.ZIndex = 12
    gameName.Parent = main
    
    -- White divider line
    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(0, 420, 0, 2)
    divider.Position = UDim2.new(0, 30, 0, 105)
    divider.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    divider.BorderSizePixel = 0
    divider.ZIndex = 12
    divider.Parent = main
    
    -- Progress bar background (DARK GRAY)
    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(0, 420, 0, 14)
    barBg.Position = UDim2.new(0, 30, 0, 125)
    barBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    barBg.BorderSizePixel = 0
    barBg.ZIndex = 12
    barBg.Parent = main
    
    local barBgCorner = Instance.new("UICorner")
    barBgCorner.CornerRadius = UDim.new(0, 7)
    barBgCorner.Parent = barBg
    
    -- Progress fill (WHITE)
    local barFill = Instance.new("Frame")
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    barFill.BorderSizePixel = 0
    barFill.ZIndex = 13
    barFill.Parent = barBg
    
    local barFillCorner = Instance.new("UICorner")
    barFillCorner.CornerRadius = UDim.new(0, 7)
    barFillCorner.Parent = barFill
    
    -- Black stripe on bar
    local stripe = Instance.new("Frame")
    stripe.Size = UDim2.new(0, 30, 0, 3)
    stripe.Position = UDim2.new(0, 0, 0, 5)
    stripe.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    stripe.BorderSizePixel = 0
    stripe.ZIndex = 14
    stripe.Parent = barFill
    
    -- Stripe animation
    task.spawn(function()
        while stripe and stripe.Parent do
            TweenService:Create(stripe, TweenInfo.new(0.8, Enum.EasingStyle.Linear), 
                {Position = UDim2.new(1, -30, 0, 5)}):Play()
            task.wait(0.9)
            if stripe and stripe.Parent then
                stripe.Position = UDim2.new(0, 0, 0, 5)
            end
        end
    end)
    
    -- Percentage text (WHITE)
    local percentText = Instance.new("TextLabel")
    percentText.Size = UDim2.new(0, 100, 0, 35)
    percentText.Position = UDim2.new(0, 30, 0, 155)
    percentText.BackgroundTransparency = 1
    percentText.Text = "0%"
    percentText.TextColor3 = Color3.fromRGB(255, 255, 255)
    percentText.TextSize = 28
    percentText.Font = Enum.Font.Cartoon
    percentText.TextXAlignment = Enum.TextXAlignment.Left
    percentText.Name = "Percent"
    percentText.ZIndex = 12
    percentText.Parent = main
    
    -- Status text (GRAY)
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(0, 300, 0, 20)
    statusText.Position = UDim2.new(0, 140, 0, 162)
    statusText.BackgroundTransparency = 1
    statusText.Text = "Waiting..."
    statusText.TextColor3 = Color3.fromRGB(150, 150, 150)
    statusText.TextSize = 12
    statusText.Font = Enum.Font.Cartoon
    statusText.TextXAlignment = Enum.TextXAlignment.Left
    statusText.Name = "Status"
    statusText.ZIndex = 12
    statusText.Parent = main
    
    -- Loading dots (WHITE)
    for i = 1, 3 do
        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 6, 0, 6)
        dot.Position = UDim2.new(0, 30 + (i-1) * 14, 0, 200)
        dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        dot.BorderSizePixel = 0
        dot.ZIndex = 12
        dot.Parent = main
        
        local dotCorner = Instance.new("UICorner")
        dotCorner.CornerRadius = UDim.new(1, 0)
        dotCorner.Parent = dot
        
        -- Bounce animation
        task.spawn(function()
            while dot and dot.Parent do
                task.wait(0.2 * i)
                TweenService:Create(dot, TweenInfo.new(0.3, Enum.EasingStyle.Bounce), 
                    {Position = UDim2.new(0, 30 + (i-1) * 14, 0, 194)}):Play()
                task.wait(0.3)
                TweenService:Create(dot, TweenInfo.new(0.3, Enum.EasingStyle.Bounce), 
                    {Position = UDim2.new(0, 30 + (i-1) * 14, 0, 200)}):Play()
                task.wait(0.5)
            end
        end)
    end
    
    -- Version text (GRAY)
    local version = Instance.new("TextLabel")
    version.Size = UDim2.new(0, 100, 0, 16)
    version.Position = UDim2.new(1, -130, 1, -30)
    version.BackgroundTransparency = 1
    version.Text = "v2.0"
    version.TextColor3 = Color3.fromRGB(120, 120, 120)
    version.TextSize = 12
    version.Font = Enum.Font.Cartoon
    version.TextXAlignment = Enum.TextXAlignment.Right
    version.ZIndex = 12
    version.Parent = main
    
    -- Scale animation on start
    container.Size = UDim2.new(0, 0, 0, 0)
    container.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    TweenService:Create(container, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
        {Size = UDim2.new(0, 480, 0, 260), Position = UDim2.new(0.5, -240, 0.5, -130)}):Play()
    
    return {
        gui = gui,
        blurBg = blurBg,
        overlay = overlay,
        container = container,
        shadow = shadow,
        main = main,
        barFill = barFill,
        percentText = percentText,
        statusText = statusText,
        gameName = gameName,
        
        update = function(self, p, msg, gName)
            TweenService:Create(self.barFill, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), 
                {Size = UDim2.new(p / 100, 0, 1, 0)}):Play()
            self.percentText.Text = string.format("%d%%", p)
            self.statusText.Text = msg
            if gName then self.gameName.Text = gName end
        end,
        
        fadeOut = function(self, delayTime)
            delayTime = delayTime or 1.5
            task.wait(delayTime)
            
            -- Fade shadow first (WHITE shadow fades)
            TweenService:Create(self.shadow, TweenInfo.new(0.6, Enum.EasingStyle.Quad), 
                {BackgroundTransparency = 1}):Play()
            
            task.wait(0.3)
            
            -- Fade main card content
            for _, child in pairs(self.main:GetDescendants()) do
                if child:IsA("TextLabel") then
                    TweenService:Create(child, TweenInfo.new(0.5), 
                        {TextTransparency = 1}):Play()
                elseif child:IsA("Frame") then
                    TweenService:Create(child, TweenInfo.new(0.5), 
                        {BackgroundTransparency = 1}):Play()
                elseif child:IsA("ImageLabel") then
                    TweenService:Create(child, TweenInfo.new(0.5), 
                        {ImageTransparency = 1}):Play()
                end
            end
            
            -- Fade main BLACK card
            TweenService:Create(self.main, TweenInfo.new(0.6, Enum.EasingStyle.Quad), 
                {BackgroundTransparency = 1}):Play()
            
            -- Fade overlay and blur
            TweenService:Create(self.overlay, TweenInfo.new(0.8), 
                {BackgroundTransparency = 1}):Play()
            TweenService:Create(self.blurBg, TweenInfo.new(0.8), 
                {ImageTransparency = 1}):Play()
            
            task.wait(0.9)
            self.gui:Destroy()
        end,
        
        destroy = function(self)
            self.gui:Destroy()
        end
    }
end

return M.CreateUILoader()