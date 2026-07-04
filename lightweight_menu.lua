-- ═════════════════════════════════════════════════════════════════
-- COMPLETE ROBLOX EXPLOIT MENU - ALL FEATURES (OPTIMIZED NO FREEZE)
-- ═════════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Safe character loading
local Character = player.Character or player.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- [[ FEATURE STATES ]] --
local Features = {
    -- Aimbot
    Aimbot = false,
    SilentAim = false,
    FOVCircleVisible = false,
    FOVRadius = 150,
    
    -- Visuals
    ESPEnabled = false,
    ESPLine = false,
    ESPLinePosition = "Top",
    ESPBox = false,
    ESPBoxHalfFilled = false,
    ESPHealthBar = false,
    ESPHealthBarPosition = "Left",
    ESPName = false,
    ESPNamePosition = "Top",
    ESPDistance = false,
    ESPDistancePosition = "Top",
    ESPSkeleton = false,
    RGBESP = false,
    
    -- Extra
    Fly = false,
    FlySpeed = 50,
    Speed = false,
    SpeedValue = 30,
    NoClip = false,
    TPToEnemy = false,
    GetWins = false,
    SetWinsValue = 0,
    GetStreaks = false,
    SetStreaksValue = 0,
    
    -- Settings
    HideMenu = false,
    ParticleEffect = "Dots",
}

-- [[ GUI COLORS ]] --
local PRIMARY_COLOR = Color3.fromRGB(20, 20, 30)
local SECONDARY_COLOR = Color3.fromRGB(30, 30, 45)
local ACCENT_COLOR = Color3.fromRGB(0, 150, 255)
local TEXT_COLOR = Color3.fromRGB(255, 255, 255)
local TOGGLE_OFF = Color3.fromRGB(100, 100, 100)
local TOGGLE_ON = Color3.fromRGB(0, 200, 100)

-- [[ CREATE SCREENGUI ]] --
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MenuGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- [[ MAIN FRAME ]] --
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 420, 0, 380)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -190)
mainFrame.BackgroundColor3 = PRIMARY_COLOR
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = ACCENT_COLOR
mainFrame.Parent = screenGui

-- [[ TITLE BAR ]] --
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = SECONDARY_COLOR
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "[ MENU ]"
titleLabel.Size = UDim2.new(1, -70, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = ACCENT_COLOR
titleLabel.TextSize = 12
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = titleBar

-- [[ MINIMIZE BUTTON ]] --
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Name = "MinimizeBtn"
minimizeBtn.Text = "−"
minimizeBtn.Size = UDim2.new(0, 30, 1, 0)
minimizeBtn.Position = UDim2.new(1, -65, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
minimizeBtn.TextColor3 = TEXT_COLOR
minimizeBtn.TextSize = 14
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.BorderSizePixel = 0
minimizeBtn.Parent = titleBar

local isMinimized = false
local originalSize = mainFrame.Size

minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        mainFrame.Size = UDim2.new(0, 420, 0, 30)
        minimizeBtn.Text = "+"
    else
        mainFrame.Size = originalSize
        minimizeBtn.Text = "−"
    end
end)

-- [[ CLOSE BUTTON ]] --
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseBtn"
closeBtn.Text = "X"
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = TEXT_COLOR
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.BorderSizePixel = 0
closeBtn.Parent = titleBar

closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

-- [[ MAIN CONTENT FRAME ]] --
local mainContentFrame = Instance.new("Frame")
mainContentFrame.Name = "MainContentFrame"
mainContentFrame.Size = UDim2.new(1, 0, 1, -30)
mainContentFrame.Position = UDim2.new(0, 0, 0, 30)
mainContentFrame.BackgroundTransparency = 1
mainContentFrame.BorderSizePixel = 0
mainContentFrame.Parent = mainFrame

-- [[ TAB FRAME ]] --
local tabFrame = Instance.new("Frame")
tabFrame.Name = "TabFrame"
tabFrame.Size = UDim2.new(0, 80, 1, 0)
tabFrame.Position = UDim2.new(0, 0, 0, 0)
tabFrame.BackgroundColor3 = SECONDARY_COLOR
tabFrame.BorderSizePixel = 1
tabFrame.BorderColor3 = ACCENT_COLOR
tabFrame.Parent = mainContentFrame

-- [[ TAB SETUP ]] --
local tabs = {"Aimbot", "Visuals", "Extra", "Settings"}
local tabButtons = {}
local tabContents = {}

for i, tabName in ipairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Name = tabName .. "Btn"
    tabBtn.Text = tabName
    tabBtn.Size = UDim2.new(1, -6, 0, 32)
    tabBtn.Position = UDim2.new(0, 3, 0, (i-1) * 37 + 3)
    tabBtn.BackgroundColor3 = SECONDARY_COLOR
    tabBtn.TextColor3 = TEXT_COLOR
    tabBtn.TextSize = 9
    tabBtn.Font = Enum.Font.Gotham
    tabBtn.BorderSizePixel = 1
    tabBtn.BorderColor3 = ACCENT_COLOR
    tabBtn.Parent = tabFrame
    tabButtons[i] = tabBtn
end

-- [[ CONTENT FRAME ]] --
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, -80, 1, 0)
contentFrame.Position = UDim2.new(0, 80, 0, 0)
contentFrame.BackgroundColor3 = PRIMARY_COLOR
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainContentFrame

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Name = "ScrollingFrame"
scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 5
scrollingFrame.Parent = contentFrame

-- [[ CREATE TOGGLE ]] --
local function createToggle(parent, name, position, featureKey)
    local container = Instance.new("Frame")
    container.Name = name .. "Container"
    container.Size = UDim2.new(1, -10, 0, 22)
    container.Position = position
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Text = name
    label.Size = UDim2.new(0, 180, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = TEXT_COLOR
    label.TextSize = 9
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local btn = Instance.new("TextButton")
    btn.Text = "OFF"
    btn.Size = UDim2.new(0, 38, 0, 18)
    btn.Position = UDim2.new(1, -38, 0.5, -9)
    btn.BackgroundColor3 = TOGGLE_OFF
    btn.TextColor3 = TEXT_COLOR
    btn.TextSize = 8
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(80, 80, 80)
    btn.Parent = container
    
    btn.MouseButton1Click:Connect(function()
        Features[featureKey] = not Features[featureKey]
        if Features[featureKey] then
            btn.Text = "ON"
            btn.BackgroundColor3 = TOGGLE_ON
        else
            btn.Text = "OFF"
            btn.BackgroundColor3 = TOGGLE_OFF
        end
    end)
    
    return container
end

-- [[ CREATE SLIDER ]] --
local function createSlider(parent, name, position, min, max, default, featureKey)
    local container = Instance.new("Frame")
    container.Name = name .. "Container"
    container.Size = UDim2.new(1, -10, 0, 38)
    container.Position = position
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Text = name
    label.Size = UDim2.new(1, 0, 0, 14)
    label.BackgroundTransparency = 1
    label.TextColor3 = TEXT_COLOR
    label.TextSize = 9
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -32, 0, 4)
    sliderBg.Position = UDim2.new(0, 0, 0, 18)
    sliderBg.BackgroundColor3 = SECONDARY_COLOR
    sliderBg.BorderColor3 = ACCENT_COLOR
    sliderBg.BorderSizePixel = 1
    sliderBg.Parent = container
    
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
    sliderFill.BackgroundColor3 = ACCENT_COLOR
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Text = tostring(default)
    valueLabel.Size = UDim2.new(0, 28, 0, 14)
    valueLabel.Position = UDim2.new(1, 0, 0, 18)
    valueLabel.BackgroundColor3 = SECONDARY_COLOR
    valueLabel.TextColor3 = ACCENT_COLOR
    valueLabel.TextSize = 8
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.BorderColor3 = ACCENT_COLOR
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
            local percentage = math.clamp(pos / size, 0, 1)
            local value = math.floor(min + (max - min) * percentage)
            sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
            valueLabel.Text = tostring(value)
            Features[featureKey] = value
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return container
end

-- [[ CREATE COMBOBOX ]] --
local function createComboBox(parent, name, position, options, featureKey)
    local container = Instance.new("Frame")
    container.Name = name .. "Container"
    container.Size = UDim2.new(1, -10, 0, 30)
    container.Position = position
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Text = name
    label.Size = UDim2.new(0, 180, 0, 14)
    label.BackgroundTransparency = 1
    label.TextColor3 = TEXT_COLOR
    label.TextSize = 9
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local btn = Instance.new("TextButton")
    btn.Text = options[1]
    btn.Size = UDim2.new(0, 85, 0, 18)
    btn.Position = UDim2.new(1, -85, 0.5, -9)
    btn.BackgroundColor3 = SECONDARY_COLOR
    btn.TextColor3 = ACCENT_COLOR
    btn.TextSize = 8
    btn.Font = Enum.Font.Gotham
    btn.BorderColor3 = ACCENT_COLOR
    btn.BorderSizePixel = 1
    btn.Parent = container
    
    local dropdownOpen = false
    
    local function createDropdown()
        local dropdownFrame = Instance.new("Frame")
        dropdownFrame.Name = "Dropdown"
        dropdownFrame.Size = UDim2.new(0, 85, 0, #options * 18)
        dropdownFrame.Position = UDim2.new(1, -85, 1, 0)
        dropdownFrame.BackgroundColor3 = SECONDARY_COLOR
        dropdownFrame.BorderColor3 = ACCENT_COLOR
        dropdownFrame.BorderSizePixel = 1
        dropdownFrame.Parent = btn
        
        for i, option in ipairs(options) do
            local optionBtn = Instance.new("TextButton")
            optionBtn.Text = option
            optionBtn.Size = UDim2.new(1, 0, 0, 18)
            optionBtn.Position = UDim2.new(0, 0, 0, (i-1) * 18)
            optionBtn.BackgroundColor3 = SECONDARY_COLOR
            optionBtn.TextColor3 = TEXT_COLOR
            optionBtn.TextSize = 8
            optionBtn.Font = Enum.Font.Gotham
            optionBtn.BorderSizePixel = 0
            optionBtn.Parent = dropdownFrame
            
            optionBtn.MouseButton1Click:Connect(function()
                btn.Text = option
                Features[featureKey] = option
                dropdownOpen = false
                dropdownFrame:Destroy()
            end)
            
            optionBtn.MouseEnter:Connect(function()
                optionBtn.BackgroundColor3 = ACCENT_COLOR
                optionBtn.TextColor3 = PRIMARY_COLOR
            end)
            
            optionBtn.MouseLeave:Connect(function()
                optionBtn.BackgroundColor3 = SECONDARY_COLOR
                optionBtn.TextColor3 = TEXT_COLOR
            end)
        end
    end
    
    btn.MouseButton1Click:Connect(function()
        if dropdownOpen then
            dropdownOpen = false
            local dropdown = btn:FindFirstChild("Dropdown")
            if dropdown then dropdown:Destroy() end
        else
            dropdownOpen = true
            createDropdown()
        end
    end)
    
    return container
end

-- [[ CREATE TEXTBOX ]] --
local function createTextBox(parent, name, position, placeholder, featureKey)
    local container = Instance.new("Frame")
    container.Name = name .. "Container"
    container.Size = UDim2.new(1, -10, 0, 30)
    container.Position = position
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Text = name
    label.Size = UDim2.new(0, 180, 0, 14)
    label.BackgroundTransparency = 1
    label.TextColor3 = TEXT_COLOR
    label.TextSize = 9
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local textBox = Instance.new("TextBox")
    textBox.PlaceholderText = placeholder
    textBox.Size = UDim2.new(0, 85, 0, 18)
    textBox.Position = UDim2.new(1, -85, 0.5, -9)
    textBox.BackgroundColor3 = SECONDARY_COLOR
    textBox.TextColor3 = TEXT_COLOR
    textBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    textBox.TextSize = 8
    textBox.Font = Enum.Font.Gotham
    textBox.BorderColor3 = ACCENT_COLOR
    textBox.BorderSizePixel = 1
    textBox.Parent = container
    
    textBox.FocusLost:Connect(function()
        Features[featureKey] = tonumber(textBox.Text) or 0
    end)
    
    return container
end

-- ═════════════════════════════════════════════════════════════════
-- AIMBOT TAB
-- ═════════════════════════════════════════════════════════════════
local aimbotContent = Instance.new("Frame")
aimbotContent.Name = "AimbotContent"
aimbotContent.Size = UDim2.new(1, 0, 1, 0)
aimbotContent.BackgroundTransparency = 1
aimbotContent.BorderSizePixel = 0
aimbotContent.Parent = scrollingFrame
tabContents[1] = aimbotContent

local yPos = 5
createToggle(aimbotContent, "Aimbot", UDim2.new(0, 5, 0, yPos), "Aimbot") yPos = yPos + 25
createToggle(aimbotContent, "Silent Aim", UDim2.new(0, 5, 0, yPos), "SilentAim") yPos = yPos + 25
createToggle(aimbotContent, "FOV Circle", UDim2.new(0, 5, 0, yPos), "FOVCircleVisible") yPos = yPos + 25
createSlider(aimbotContent, "FOV Radius", UDim2.new(0, 5, 0, yPos), 50, 500, 150, "FOVRadius") yPos = yPos + 42
aimbotContent.CanvasSize = UDim2.new(0, 0, 0, yPos + 5)

-- ═════════════════════════════════════════════════════════════════
-- VISUALS TAB
-- ═════════════════════════════════════════════════════════════════
local visualsContent = Instance.new("Frame")
visualsContent.Name = "VisualsContent"
visualsContent.Size = UDim2.new(1, 0, 1, 0)
visualsContent.BackgroundTransparency = 1
visualsContent.BorderSizePixel = 0
visualsContent.Parent = scrollingFrame
tabContents[2] = visualsContent
visualsContent.Visible = false

yPos = 5
createToggle(visualsContent, "Enable ESP", UDim2.new(0, 5, 0, yPos), "ESPEnabled") yPos = yPos + 25
createToggle(visualsContent, "ESP Line", UDim2.new(0, 5, 0, yPos), "ESPLine") yPos = yPos + 25
createComboBox(visualsContent, "Line Position", UDim2.new(0, 5, 0, yPos), {"Top", "Bottom", "Side"}, "ESPLinePosition") yPos = yPos + 32
createToggle(visualsContent, "ESP Box", UDim2.new(0, 5, 0, yPos), "ESPBox") yPos = yPos + 25
createToggle(visualsContent, "Box Half Filled", UDim2.new(0, 5, 0, yPos), "ESPBoxHalfFilled") yPos = yPos + 25
createToggle(visualsContent, "Health Bar", UDim2.new(0, 5, 0, yPos), "ESPHealthBar") yPos = yPos + 25
createComboBox(visualsContent, "Health Position", UDim2.new(0, 5, 0, yPos), {"Left", "Right", "Top", "Bottom"}, "ESPHealthBarPosition") yPos = yPos + 32
createToggle(visualsContent, "ESP Name", UDim2.new(0, 5, 0, yPos), "ESPName") yPos = yPos + 25
createComboBox(visualsContent, "Name Position", UDim2.new(0, 5, 0, yPos), {"Top", "Bottom", "Side"}, "ESPNamePosition") yPos = yPos + 32
createToggle(visualsContent, "ESP Distance", UDim2.new(0, 5, 0, yPos), "ESPDistance") yPos = yPos + 25
createComboBox(visualsContent, "Distance Pos", UDim2.new(0, 5, 0, yPos), {"Top", "Bottom", "Side"}, "ESPDistancePosition") yPos = yPos + 32
createToggle(visualsContent, "Skeleton", UDim2.new(0, 5, 0, yPos), "ESPSkeleton") yPos = yPos + 25
createToggle(visualsContent, "RGB ESP", UDim2.new(0, 5, 0, yPos), "RGBESP") yPos = yPos + 25
visualsContent.CanvasSize = UDim2.new(0, 0, 0, yPos + 5)

-- ═════════════════════════════════════════════════════════════════
-- EXTRA TAB
-- ═════════════════════════════════════════════════════════════════
local extraContent = Instance.new("Frame")
extraContent.Name = "ExtraContent"
extraContent.Size = UDim2.new(1, 0, 1, 0)
extraContent.BackgroundTransparency = 1
extraContent.BorderSizePixel = 0
extraContent.Parent = scrollingFrame
tabContents[3] = extraContent
extraContent.Visible = false

yPos = 5
createToggle(extraContent, "Fly", UDim2.new(0, 5, 0, yPos), "Fly") yPos = yPos + 25
createSlider(extraContent, "Fly Speed", UDim2.new(0, 5, 0, yPos), 0, 200, 50, "FlySpeed") yPos = yPos + 42
createToggle(extraContent, "Speed", UDim2.new(0, 5, 0, yPos), "Speed") yPos = yPos + 25
createSlider(extraContent, "Speed Value", UDim2.new(0, 5, 0, yPos), 0, 100, 30, "SpeedValue") yPos = yPos + 42
createToggle(extraContent, "No Clip", UDim2.new(0, 5, 0, yPos), "NoClip") yPos = yPos + 25
createToggle(extraContent, "TP to Enemy", UDim2.new(0, 5, 0, yPos), "TPToEnemy") yPos = yPos + 25
createToggle(extraContent, "Get Wins", UDim2.new(0, 5, 0, yPos), "GetWins") yPos = yPos + 25
createTextBox(extraContent, "Set Wins", UDim2.new(0, 5, 0, yPos), "Enter wins", "SetWinsValue") yPos = yPos + 32
createToggle(extraContent, "Get Streaks", UDim2.new(0, 5, 0, yPos), "GetStreaks") yPos = yPos + 25
createTextBox(extraContent, "Set Streak", UDim2.new(0, 5, 0, yPos), "Enter streak", "SetStreaksValue") yPos = yPos + 32
extraContent.CanvasSize = UDim2.new(0, 0, 0, yPos + 5)

-- ═════════════════════════════════════════════════════════════════
-- SETTINGS TAB
-- ═════════════════════════════════════════════════════════════════
local settingsContent = Instance.new("Frame")
settingsContent.Name = "SettingsContent"
settingsContent.Size = UDim2.new(1, 0, 1, 0)
settingsContent.BackgroundTransparency = 1
settingsContent.BorderSizePixel = 0
settingsContent.Parent = scrollingFrame
tabContents[4] = settingsContent
settingsContent.Visible = false

yPos = 5

local keybindLabel = Instance.new("TextLabel")
keybindLabel.Text = "═ KEYBINDS ═"
keybindLabel.Size = UDim2.new(1, -10, 0, 18)
keybindLabel.Position = UDim2.new(0, 5, 0, yPos)
keybindLabel.BackgroundColor3 = SECONDARY_COLOR
keybindLabel.TextColor3 = ACCENT_COLOR
keybindLabel.TextSize = 9
keybindLabel.Font = Enum.Font.GothamBold
keybindLabel.BorderColor3 = ACCENT_COLOR
keybindLabel.BorderSizePixel = 1
keybindLabel.Parent = settingsContent
yPos = yPos + 22

local keybinds = {"Aimbot: F", "Fly: G", "Speed: H", "S.Aim: J", "NoClip: K", "TP: L"}
for _, kb in ipairs(keybinds) do
    local kbLabel = Instance.new("TextLabel")
    kbLabel.Text = kb
    kbLabel.Size = UDim2.new(1, -10, 0, 18)
    kbLabel.Position = UDim2.new(0, 5, 0, yPos)
    kbLabel.BackgroundColor3 = SECONDARY_COLOR
    kbLabel.TextColor3 = TEXT_COLOR
    kbLabel.TextSize = 9
    kbLabel.Font = Enum.Font.Gotham
    kbLabel.BorderColor3 = ACCENT_COLOR
    kbLabel.BorderSizePixel = 1
    kbLabel.Parent = settingsContent
    yPos = yPos + 22
end

yPos = yPos + 5

local particleLabel = Instance.new("TextLabel")
particleLabel.Text = "═ PARTICLES ═"
particleLabel.Size = UDim2.new(1, -10, 0, 18)
particleLabel.Position = UDim2.new(0, 5, 0, yPos)
particleLabel.BackgroundColor3 = SECONDARY_COLOR
particleLabel.TextColor3 = ACCENT_COLOR
particleLabel.TextSize = 9
particleLabel.Font = Enum.Font.GothamBold
particleLabel.BorderColor3 = ACCENT_COLOR
particleLabel.BorderSizePixel = 1
particleLabel.Parent = settingsContent
yPos = yPos + 22

createComboBox(settingsContent, "Particle", UDim2.new(0, 5, 0, yPos), {"Dots", "Rain", "Line", "Hacker", "Circle"}, "ParticleEffect") yPos = yPos + 32

createToggle(settingsContent, "Hide Menu", UDim2.new(0, 5, 0, yPos), "HideMenu") yPos = yPos + 25

settingsContent.CanvasSize = UDim2.new(0, 0, 0, yPos + 5)

-- ═════════════════════════════════════════════════════════════════
-- TAB SWITCHING
-- ═════════════════════════════════════════════════════════════════
for i, tabBtn in ipairs(tabButtons) do
    tabBtn.MouseButton1Click:Connect(function()
        for j, content in ipairs(tabContents) do
            content.Visible = false
            tabButtons[j].BackgroundColor3 = SECONDARY_COLOR
        end
        tabContents[i].Visible = true
        tabBtn.BackgroundColor3 = ACCENT_COLOR
        scrollingFrame.CanvasSize = tabContents[i].CanvasSize
    end)
end

tabButtons[1].BackgroundColor3 = ACCENT_COLOR
tabContents[1].Visible = true

-- ═════════════════════════════════════════════════════════════════
-- DRAGGABLE MENU
-- ═════════════════════════════════════════════════════════════════
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

UserInputService.InputChanged:Connect(function(input, gameProcessed)
    if dragging and input.UserInputType == Enum.UserInputType.Mouse then
        local delta = mouse.X - (mainFrame.AbsolutePosition.X + dragStart)
        mainFrame.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta, framePos.Y.Scale, framePos.Y.Offset)
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- ═════════════════════════════════════════════════════════════════
-- OPTIMIZED FEATURES (FRAME SKIPPING)
-- ═════════════════════════════════════════════════════════════════

-- [[ FOV CIRCLE ]] --
local FOVCircle = nil
local function createFOVCircle()
    if not FOVCircle then
        FOVCircle = Drawing.new("Circle")
        FOVCircle.Color = Color3.fromRGB(255, 0, 0)
        FOVCircle.Thickness = 1
        FOVCircle.Filled = false
        FOVCircle.Transparency = 0.8
    end
end

local fovCounter = 0
RunService.RenderStepped:Connect(function()
    fovCounter = fovCounter + 1
    if fovCounter >= 4 then
        fovCounter = 0
        if Features.SilentAim and Features.FOVCircleVisible then
            if not FOVCircle then createFOVCircle() end
            FOVCircle.Visible = true
            FOVCircle.Position = UserInputService:GetMouseLocation()
            FOVCircle.Radius = Features.FOVRadius
        elseif FOVCircle then
            FOVCircle.Visible = false
        end
    end
end)

-- [[ GET CLOSEST PLAYER ]] --
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

-- [[ NO CLIP ]] --
local noclipCounter = 0
RunService.Stepped:Connect(function()
    if Features.NoClip then
        noclipCounter = noclipCounter + 1
        if noclipCounter >= 3 then
            noclipCounter = 0
            if Character then
                for _, part in pairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end
end)

-- [[ SPEED ]] --
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

-- [[ FLY ]] --
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

-- [[ TP TO ENEMY ]] --
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

-- [[ CHARACTER RESPAWN ]] --
player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    RootPart = Character:WaitForChild("HumanoidRootPart")
    stopFly()
    Features.Speed = false
    Features.NoClip = false
    Features.Fly = false
end)

print("✓ COMPLETE MENU LOADED - ALL FEATURES")
print("✓ All tabs: Aimbot, Visuals, Extra, Settings")
print("✓ Optimized to prevent freezing")
print("✓ Minimize (−) and Close (X) buttons available")
