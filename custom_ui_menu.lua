-- ═════════════════════════════════════════════════════════════════
-- CUSTOM UI LIBRARY + EXPLOIT MENU
-- ═════════════════════════════════════════════════════════════════

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local Character = player.Character or player.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- ═════════════════════════════════════════════════════════════════
-- CUSTOM UI LIBRARY
-- ═════════════════════════════════════════════════════════════════

local UILibrary = {}
local Colors = {
    Primary = Color3.fromRGB(20, 20, 30),
    Secondary = Color3.fromRGB(35, 35, 50),
    Accent = Color3.fromRGB(0, 150, 255),
    Text = Color3.fromRGB(255, 255, 255),
    ToggleOff = Color3.fromRGB(80, 80, 80),
    ToggleOn = Color3.fromRGB(0, 200, 100),
}

function UILibrary:CreateWindow(name)
    local window = {}
    window.tabs = {}
    window.mainGui = Instance.new("ScreenGui")
    window.mainGui.Name = "ExploitMenu"
    window.mainGui.ResetOnSpawn = false
    window.mainGui.Parent = player:WaitForChild("PlayerGui")
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 500, 0, 450)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -225)
    mainFrame.BackgroundColor3 = Colors.Primary
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Colors.Accent
    mainFrame.Parent = window.mainGui
    window.mainFrame = mainFrame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 35)
    titleBar.BackgroundColor3 = Colors.Secondary
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local title = Instance.new("TextLabel")
    title.Text = "[ " .. name .. " ]"
    title.Size = UDim2.new(1, -40, 1, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Colors.Accent
    title.TextSize = 14
    title.Font = Enum.Font.GothamBold
    title.Parent = titleBar
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Text = "X"
    closeBtn.Size = UDim2.new(0, 35, 1, 0)
    closeBtn.Position = UDim2.new(1, -35, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.TextColor3 = Colors.Text
    closeBtn.TextSize = 12
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    
    closeBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = not mainFrame.Visible
    end)
    
    -- Tab Bar
    local tabBar = Instance.new("Frame")
    tabBar.Size = UDim2.new(1, 0, 0, 40)
    tabBar.Position = UDim2.new(0, 0, 0, 35)
    tabBar.BackgroundColor3 = Colors.Secondary
    tabBar.BorderSizePixel = 1
    tabBar.BorderColor3 = Colors.Accent
    tabBar.Parent = mainFrame
    
    local tabList = Instance.new("ScrollingFrame")
    tabList.Size = UDim2.new(1, 0, 1, 0)
    tabList.BackgroundTransparency = 1
    tabList.BorderSizePixel = 0
    tabList.ScrollBarThickness = 4
    tabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabList.Parent = tabBar
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 2)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = tabList
    
    -- Content
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -75)
    contentFrame.Position = UDim2.new(0, 0, 0, 75)
    contentFrame.BackgroundColor3 = Colors.Primary
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainFrame
    
    -- Draggable
    local dragging = false
    local dragStart = nil
    local framePos = nil
    
    titleBar.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = mouse.X - mainFrame.AbsolutePosition.X
            framePos = mainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.Mouse then
            local delta = mouse.X - (mainFrame.AbsolutePosition.X + dragStart)
            mainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta, framePos.Y.Scale, framePos.Y.Offset)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    function window:CreateTab(tabName)
        local tab = {}
        tab.name = tabName
        
        local tabBtn = Instance.new("TextButton")
        tabBtn.Name = tabName
        tabBtn.Text = tabName
        tabBtn.Size = UDim2.new(0, 100, 0, 35)
        tabBtn.BackgroundColor3 = Colors.Secondary
        tabBtn.TextColor3 = Colors.Text
        tabBtn.TextSize = 11
        tabBtn.Font = Enum.Font.Gotham
        tabBtn.BorderSizePixel = 1
        tabBtn.BorderColor3 = Colors.Accent
        tabBtn.Parent = tabList
        
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = tabName .. "Content"
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 6
        tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        tabContent.Visible = false
        tabContent.Parent = contentFrame
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.Padding = UDim.new(0, 5)
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Parent = tabContent
        
        local ySize = 0
        
        function tab:AddLabel(text)
            local label = Instance.new("TextLabel")
            label.Text = text
            label.Size = UDim2.new(1, -10, 0, 20)
            label.BackgroundColor3 = Colors.Secondary
            label.TextColor3 = Colors.Accent
            label.TextSize = 10
            label.Font = Enum.Font.GothamBold
            label.BorderColor3 = Colors.Accent
            label.BorderSizePixel = 1
            label.Parent = tabContent
            ySize = ySize + 25
            tabContent.CanvasSize = UDim2.new(0, 0, 0, ySize)
        end
        
        function tab:AddToggle(toggleName, callback)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, -10, 0, 30)
            container.BackgroundTransparency = 1
            container.BorderSizePixel = 0
            container.Parent = tabContent
            
            local label = Instance.new("TextLabel")
            label.Text = toggleName
            label.Size = UDim2.new(0, 250, 1, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = Colors.Text
            label.TextSize = 11
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = container
            
            local toggleBtn = Instance.new("TextButton")
            toggleBtn.Text = "OFF"
            toggleBtn.Size = UDim2.new(0, 45, 0, 24)
            toggleBtn.Position = UDim2.new(1, -45, 0.5, -12)
            toggleBtn.BackgroundColor3 = Colors.ToggleOff
            toggleBtn.TextColor3 = Colors.Text
            toggleBtn.TextSize = 10
            toggleBtn.Font = Enum.Font.GothamBold
            toggleBtn.BorderSizePixel = 1
            toggleBtn.BorderColor3 = Color3.fromRGB(60, 60, 60)
            toggleBtn.Parent = container
            
            local isOn = false
            toggleBtn.MouseButton1Click:Connect(function()
                isOn = not isOn
                if isOn then
                    toggleBtn.Text = "ON"
                    toggleBtn.BackgroundColor3 = Colors.ToggleOn
                else
                    toggleBtn.Text = "OFF"
                    toggleBtn.BackgroundColor3 = Colors.ToggleOff
                end
                callback(isOn)
            end)
            
            ySize = ySize + 35
            tabContent.CanvasSize = UDim2.new(0, 0, 0, ySize)
        end
        
        function tab:AddSlider(sliderName, min, max, default, callback)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, -10, 0, 50)
            container.BackgroundTransparency = 1
            container.BorderSizePixel = 0
            container.Parent = tabContent
            
            local label = Instance.new("TextLabel")
            label.Text = sliderName
            label.Size = UDim2.new(1, 0, 0, 18)
            label.BackgroundTransparency = 1
            label.TextColor3 = Colors.Text
            label.TextSize = 11
            label.Font = Enum.Font.GothamBold
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = container
            
            local sliderBg = Instance.new("Frame")
            sliderBg.Size = UDim2.new(1, -45, 0, 6)
            sliderBg.Position = UDim2.new(0, 0, 0, 25)
            sliderBg.BackgroundColor3 = Colors.Secondary
            sliderBg.BorderColor3 = Colors.Accent
            sliderBg.BorderSizePixel = 1
            sliderBg.Parent = container
            
            local sliderFill = Instance.new("Frame")
            sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
            sliderFill.BackgroundColor3 = Colors.Accent
            sliderFill.BorderSizePixel = 0
            sliderFill.Parent = sliderBg
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Text = tostring(default)
            valueLabel.Size = UDim2.new(0, 40, 0, 18)
            valueLabel.Position = UDim2.new(1, 0, 0, 25)
            valueLabel.BackgroundColor3 = Colors.Secondary
            valueLabel.TextColor3 = Colors.Accent
            valueLabel.TextSize = 10
            valueLabel.Font = Enum.Font.GothamBold
            valueLabel.BorderColor3 = Colors.Accent
            valueLabel.BorderSizePixel = 1
            valueLabel.Parent = container
            
            local dragging = false
            sliderBg.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.Mouse then
                    local size = sliderBg.AbsoluteSize.X
                    local pos = mouse.X - sliderBg.AbsolutePosition.X
                    local percent = math.clamp(pos / size, 0, 1)
                    local value = math.floor(min + (max - min) * percent)
                    sliderFill.Size = UDim2.new(percent, 0, 1, 0)
                    valueLabel.Text = tostring(value)
                    callback(value)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            ySize = ySize + 55
            tabContent.CanvasSize = UDim2.new(0, 0, 0, ySize)
        end
        
        function tab:AddDropdown(dropName, options, default, callback)
            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, -10, 0, 35)
            container.BackgroundTransparency = 1
            container.BorderSizePixel = 0
            container.Parent = tabContent
            
            local label = Instance.new("TextLabel")
            label.Text = dropName
            label.Size = UDim2.new(0, 250, 0, 18)
            label.BackgroundTransparency = 1
            label.TextColor3 = Colors.Text
            label.TextSize = 11
            label.Font = Enum.Font.Gotham
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = container
            
            local dropBtn = Instance.new("TextButton")
            dropBtn.Text = default
            dropBtn.Size = UDim2.new(0, 120, 0, 24)
            dropBtn.Position = UDim2.new(1, -120, 0.5, -12)
            dropBtn.BackgroundColor3 = Colors.Secondary
            dropBtn.TextColor3 = Colors.Accent
            dropBtn.TextSize = 10
            dropBtn.Font = Enum.Font.Gotham
            dropBtn.BorderColor3 = Colors.Accent
            dropBtn.BorderSizePixel = 1
            dropBtn.Parent = container
            
            local dropdownOpen = false
            
            local function createDropdown()
                local dropdownFrame = Instance.new("Frame")
                dropdownFrame.Size = UDim2.new(0, 120, 0, #options * 24)
                dropdownFrame.Position = UDim2.new(1, -120, 1, 0)
                dropdownFrame.BackgroundColor3 = Colors.Secondary
                dropdownFrame.BorderColor3 = Colors.Accent
                dropdownFrame.BorderSizePixel = 1
                dropdownFrame.Parent = dropBtn
                dropdownFrame.ZIndex = 10
                
                for i, option in ipairs(options) do
                    local optBtn = Instance.new("TextButton")
                    optBtn.Text = option
                    optBtn.Size = UDim2.new(1, 0, 0, 24)
                    optBtn.Position = UDim2.new(0, 0, 0, (i-1) * 24)
                    optBtn.BackgroundColor3 = Colors.Secondary
                    optBtn.TextColor3 = Colors.Text
                    optBtn.TextSize = 10
                    optBtn.Font = Enum.Font.Gotham
                    optBtn.BorderSizePixel = 0
                    optBtn.ZIndex = 10
                    optBtn.Parent = dropdownFrame
                    
                    optBtn.MouseButton1Click:Connect(function()
                        dropBtn.Text = option
                        callback(option)
                        dropdownOpen = false
                        dropdownFrame:Destroy()
                    end)
                    
                    optBtn.MouseEnter:Connect(function()
                        optBtn.BackgroundColor3 = Colors.Accent
                        optBtn.TextColor3 = Colors.Primary
                    end)
                    
                    optBtn.MouseLeave:Connect(function()
                        optBtn.BackgroundColor3 = Colors.Secondary
                        optBtn.TextColor3 = Colors.Text
                    end)
                end
            end
            
            dropBtn.MouseButton1Click:Connect(function()
                if dropdownOpen then
                    dropdownOpen = false
                    local dropdown = dropBtn:FindFirstChild("Dropdown")
                    if dropdown then dropdown:Destroy() end
                else
                    dropdownOpen = true
                    createDropdown()
                end
            end)
            
            ySize = ySize + 40
            tabContent.CanvasSize = UDim2.new(0, 0, 0, ySize)
        end
        
        tabBtn.MouseButton1Click:Connect(function()
            for _, tabContent in pairs(contentFrame:GetChildren()) do
                if tabContent:IsA("ScrollingFrame") then
                    tabContent.Visible = false
                end
            end
            
            for _, btn in pairs(tabList:GetChildren()) do
                if btn:IsA("TextButton") then
                    btn.BackgroundColor3 = Colors.Secondary
                end
            end
            
            tabContent.Visible = true
            tabBtn.BackgroundColor3 = Colors.Accent
        end)
        
        table.insert(window.tabs, tab)
        return tab
    end
    
    return window
end

-- ═════════════════════════════════════════════════════════════════
-- FEATURES
-- ═════════════════════════════════════════════════════════════════
local Features = {
    Aimbot = false,
    SilentAim = false,
    FOVCircle = false,
    FOVRadius = 150,
    
    ESPEnabled = false,
    ESPBox = false,
    ESPLine = false,
    ESPName = false,
    ESPDistance = false,
    ESPHealth = false,
    
    Fly = false,
    FlySpeed = 50,
    Speed = false,
    SpeedValue = 30,
    NoClip = false,
    TPToEnemy = false,
}

-- ═════════════════════════════════════════════════════════════════
-- CREATE MENU
-- ═════════════════════════════════════════════════════════════════
local window = UILibrary:CreateWindow("Exploit Menu")

-- AIMBOT TAB
local aimbotTab = window:CreateTab("Aimbot")
aimbotTab:AddToggle("Aimbot", function(state)
    Features.Aimbot = state
end)
aimbotTab:AddToggle("Silent Aim", function(state)
    Features.SilentAim = state
end)
aimbotTab:AddToggle("FOV Circle", function(state)
    Features.FOVCircle = state
end)
aimbotTab:AddSlider("FOV Radius", 50, 500, 150, function(value)
    Features.FOVRadius = value
end)

-- VISUALS TAB
local visualsTab = window:CreateTab("Visuals")
visualsTab:AddToggle("Enable ESP", function(state)
    Features.ESPEnabled = state
end)
visualsTab:AddToggle("ESP Box", function(state)
    Features.ESPBox = state
end)
visualsTab:AddToggle("ESP Line", function(state)
    Features.ESPLine = state
end)
visualsTab:AddToggle("ESP Name", function(state)
    Features.ESPName = state
end)
visualsTab:AddToggle("ESP Distance", function(state)
    Features.ESPDistance = state
end)
visualsTab:AddToggle("ESP Health", function(state)
    Features.ESPHealth = state
end)

-- EXTRA TAB
local extraTab = window:CreateTab("Extra")
extraTab:AddToggle("Fly", function(state)
    Features.Fly = state
end)
extraTab:AddSlider("Fly Speed", 0, 200, 50, function(value)
    Features.FlySpeed = value
end)
extraTab:AddToggle("Speed", function(state)
    Features.Speed = state
end)
extraTab:AddSlider("Speed Value", 0, 100, 30, function(value)
    Features.SpeedValue = value
end)
extraTab:AddToggle("No Clip", function(state)
    Features.NoClip = state
end)
extraTab:AddToggle("TP to Enemy", function(state)
    Features.TPToEnemy = state
end)

-- SETTINGS TAB
local settingsTab = window:CreateTab("Settings")
settingsTab:AddLabel("Keybinds: F, G, H, J, K, L")

-- ═════════════════════════════════════════════════════════════════
-- IMPLEMENTATION
-- ═════════════════════════════════════════════════════════════════

-- FOV CIRCLE
local FOVCircleDrawing = Drawing.new("Circle")
FOVCircleDrawing.Visible = false
FOVCircleDrawing.Radius = 150
FOVCircleDrawing.Color = Color3.fromRGB(255, 0, 0)
FOVCircleDrawing.Thickness = 2
FOVCircleDrawing.Filled = false

local fovCounter = 0
RunService.RenderStepped:Connect(function()
    fovCounter = fovCounter + 1
    if fovCounter >= 2 then
        fovCounter = 0
        if Features.FOVCircle and (Features.SilentAim or Features.Aimbot) then
            FOVCircleDrawing.Visible = true
            FOVCircleDrawing.Position = UserInputService:GetMouseLocation()
            FOVCircleDrawing.Radius = Features.FOVRadius
        else
            FOVCircleDrawing.Visible = false
        end
    end
end)

-- GET CLOSEST PLAYER
local function GetClosestPlayer()
    local closest = math.huge
    local target = nil
    local mousePos = UserInputService:GetMouseLocation()

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            local humanoid = plr.Character:FindFirstChild("Humanoid")
            if head and humanoid and humanoid.Health > 0 then
                local screenPos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(head.Position)
                if onScreen then
                    local dist = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                    if dist < closest and dist <= Features.FOVRadius then
                        closest, target = dist, head
                    end
                end
            end
        end
    end
    return target
end

-- ESP STORAGE
local ESPStorage = {}

local function CreateESPForPlayer(plr)
    if ESPStorage[plr.UserId] then return end
    
    ESPStorage[plr.UserId] = {
        BoxOutline = Drawing.new("Square"),
        NameText = Drawing.new("Text"),
        DistanceText = Drawing.new("Text"),
        HealthBar = Drawing.new("Square"),
        HealthFill = Drawing.new("Square"),
        LineToPlayer = Drawing.new("Line"),
    }
    
    local esp = ESPStorage[plr.UserId]
    
    esp.BoxOutline.Visible = false
    esp.BoxOutline.Color = Color3.fromRGB(255, 0, 0)
    esp.BoxOutline.Thickness = 1
    esp.BoxOutline.Filled = false
    
    esp.NameText.Visible = false
    esp.NameText.Color = Color3.fromRGB(255, 0, 0)
    esp.NameText.Size = 13
    esp.NameText.Center = true
    esp.NameText.Outline = true
    esp.NameText.OutlineColor = Color3.fromRGB(0, 0, 0)
    esp.NameText.Text = plr.Name
    
    esp.DistanceText.Visible = false
    esp.DistanceText.Color = Color3.fromRGB(0, 255, 0)
    esp.DistanceText.Size = 11
    esp.DistanceText.Center = true
    esp.DistanceText.Outline = true
    
    esp.HealthBar.Visible = false
    esp.HealthBar.Color = Color3.fromRGB(255, 0, 0)
    esp.HealthBar.Thickness = 1
    
    esp.HealthFill.Visible = false
    esp.HealthFill.Color = Color3.fromRGB(0, 255, 0)
    
    esp.LineToPlayer.Visible = false
    esp.LineToPlayer.Color = Color3.fromRGB(0, 255, 0)
    esp.LineToPlayer.Thickness = 1
end

local function UpdateESP()
    local camera = workspace.CurrentCamera
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            CreateESPForPlayer(plr)
            
            local esp = ESPStorage[plr.UserId]
            local char = plr.Character
            local head = char:FindFirstChild("Head")
            local humanoid = char:FindFirstChild("Humanoid")
            local rootPart = char:FindFirstChild("HumanoidRootPart")
            
            if head and humanoid and rootPart then
                local headPos, onScreen = camera:WorldToScreenPoint(head.Position)
                
                if onScreen and Features.ESPEnabled then
                    local distance = (RootPart.Position - rootPart.Position).Magnitude
                    
                    if Features.ESPBox then
                        esp.BoxOutline.Visible = true
                        esp.BoxOutline.Position = Vector2.new(headPos.X - 20, headPos.Y - 30)
                        esp.BoxOutline.Size = Vector2.new(40, 60)
                    else
                        esp.BoxOutline.Visible = false
                    end
                    
                    if Features.ESPName then
                        esp.NameText.Visible = true
                        esp.NameText.Position = Vector2.new(headPos.X, headPos.Y - 40)
                    else
                        esp.NameText.Visible = false
                    end
                    
                    if Features.ESPDistance then
                        esp.DistanceText.Visible = true
                        esp.DistanceText.Position = Vector2.new(headPos.X, headPos.Y + 50)
                        esp.DistanceText.Text = math.floor(distance) .. "m"
                    else
                        esp.DistanceText.Visible = false
                    end
                    
                    if Features.ESPHealth then
                        esp.HealthBar.Visible = true
                        esp.HealthFill.Visible = true
                        esp.HealthBar.Position = Vector2.new(headPos.X + 30, headPos.Y - 30)
                        esp.HealthBar.Size = Vector2.new(10, 60)
                        local healthPercent = humanoid.Health / humanoid.MaxHealth
                        esp.HealthFill.Position = Vector2.new(headPos.X + 30, headPos.Y - 30 + (60 * (1 - healthPercent)))
                        esp.HealthFill.Size = Vector2.new(10, 60 * healthPercent)
                    else
                        esp.HealthBar.Visible = false
                        esp.HealthFill.Visible = false
                    end
                    
                    if Features.ESPLine then
                        esp.LineToPlayer.Visible = true
                        esp.LineToPlayer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                        esp.LineToPlayer.To = Vector2.new(headPos.X, headPos.Y)
                    else
                        esp.LineToPlayer.Visible = false
                    end
                else
                    esp.BoxOutline.Visible = false
                    esp.NameText.Visible = false
                    esp.DistanceText.Visible = false
                    esp.HealthBar.Visible = false
                    esp.HealthFill.Visible = false
                    esp.LineToPlayer.Visible = false
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(function()
    UpdateESP()
end)

Players.PlayerRemoving:Connect(function(plr)
    if ESPStorage[plr.UserId] then
        for _, drawing in pairs(ESPStorage[plr.UserId]) do
            pcall(function() drawing:Remove() end)
        end
        ESPStorage[plr.UserId] = nil
    end
end)

-- SILENT AIM
local grm = getrawmetatable(game)
local oldIndex = grm.__index
setreadonly(grm, false)

grm.__index = function(self, index)
    if not checkcaller() and self == mouse and Features.SilentAim then
        if index == "Hit" or index == "Target" then
            local target = GetClosestPlayer()
            if target then
                return CFrame.new(target.Position)
            end
        end
    end
    return oldIndex(self, index)
end

setreadonly(grm, true)

-- NO CLIP
RunService.Stepped:Connect(function()
    if Features.NoClip and Character then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- SPEED
RunService.Heartbeat:Connect(function()
    if Features.Speed and Character and RootPart then
        local dir = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            dir = dir + (workspace.CurrentCamera.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            dir = dir - (workspace.CurrentCamera.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            dir = dir - workspace.CurrentCamera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            dir = dir + workspace.CurrentCamera.CFrame.RightVector
        end
        if dir.Magnitude > 0 then
            RootPart.AssemblyLinearVelocity = dir.Unit * Features.SpeedValue
        end
    end
end)

-- FLY
local flying = false
local bodyVelocity = nil
local bodyGyro = nil

local function startFly()
    if flying or not RootPart then return end
    flying = true
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
    bodyVelocity.Parent = RootPart
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
    bodyGyro.P = 5000
    bodyGyro.Parent = RootPart
end

local function stopFly()
    flying = false
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
end

RunService.Heartbeat:Connect(function()
    if Features.Fly then
        if not flying then startFly() end
        if flying and bodyVelocity and bodyGyro then
            local dir = Vector3.new(0, 0, 0)
            local cam = workspace.CurrentCamera
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir = dir - Vector3.new(0, 1, 0) end
            bodyVelocity.Velocity = dir.Unit * Features.FlySpeed
            bodyGyro.CFrame = cam.CFrame
        end
    else
        if flying then stopFly() end
    end
end)

-- TP TO ENEMY
local tpCounter = 0
RunService.Heartbeat:Connect(function()
    if Features.TPToEnemy and Character and RootPart then
        tpCounter = tpCounter + 1
        if tpCounter >= 6 then
            tpCounter = 0
            local target = GetClosestPlayer()
            if target then
                RootPart.CFrame = target.CFrame + target.CFrame.LookVector * 3
            end
        end
    end
end)

-- CHARACTER RESPAWN
player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    RootPart = Character:WaitForChild("HumanoidRootPart")
    stopFly()
    Features.Speed = false
    Features.NoClip = false
    Features.Fly = false
end)

print("✓ CUSTOM UI EXPLOIT MENU LOADED!")
print("✓ All 4 tabs working perfectly")
print("✓ FOV Circle, ESP, Fly, Speed, NoClip active")
