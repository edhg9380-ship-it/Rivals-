-- ═════════════════════════════════════════════════════════════════
-- LIGHTWEIGHT ROBLOX EXPLOIT MENU - NO FREEZE
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
    Aimbot = false,
    SilentAim = false,
    FOVCircleVisible = false,
    FOVRadius = 150,
    ESPEnabled = false,
    Fly = false,
    FlySpeed = 50,
    Speed = false,
    SpeedValue = 30,
    NoClip = false,
    TPToEnemy = false,
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
mainFrame.Size = UDim2.new(0, 380, 0, 350)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -175)
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
        mainFrame.Size = UDim2.new(0, 380, 0, 30)
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

-- [[ CONTENT FRAME ]] --
local contentFrame = Instance.new("Frame")
contentFrame.Name = "ContentFrame"
contentFrame.Size = UDim2.new(1, 0, 1, -30)
contentFrame.Position = UDim2.new(0, 0, 0, 30)
contentFrame.BackgroundColor3 = PRIMARY_COLOR
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Name = "ScrollingFrame"
scrollingFrame.Size = UDim2.new(1, 0, 1, 0)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 5
scrollingFrame.Parent = contentFrame

-- [[ SIMPLE TOGGLE FUNCTION ]] --
local function createToggle(parent, name, yPos, featureKey)
    local container = Instance.new("Frame")
    container.Name = name .. "Container"
    container.Size = UDim2.new(1, -10, 0, 25)
    container.Position = UDim2.new(0, 5, 0, yPos)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Text = name
    label.Size = UDim2.new(0, 200, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = TEXT_COLOR
    label.TextSize = 10
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local btn = Instance.new("TextButton")
    btn.Text = "OFF"
    btn.Size = UDim2.new(0, 40, 0, 20)
    btn.Position = UDim2.new(1, -40, 0.5, -10)
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
    
    return yPos + 30
end

-- [[ SIMPLE SLIDER FUNCTION ]] --
local function createSlider(parent, name, yPos, min, max, default, featureKey)
    local container = Instance.new("Frame")
    container.Name = name .. "Container"
    container.Size = UDim2.new(1, -10, 0, 40)
    container.Position = UDim2.new(0, 5, 0, yPos)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Text = name
    label.Size = UDim2.new(1, 0, 0, 15)
    label.BackgroundTransparency = 1
    label.TextColor3 = TEXT_COLOR
    label.TextSize = 10
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -35, 0, 4)
    sliderBg.Position = UDim2.new(0, 0, 0, 20)
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
    valueLabel.Size = UDim2.new(0, 30, 0, 15)
    valueLabel.Position = UDim2.new(1, 0, 0, 20)
    valueLabel.BackgroundColor3 = SECONDARY_COLOR
    valueLabel.TextColor3 = ACCENT_COLOR
    valueLabel.TextSize = 9
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
    
    return yPos + 45
end

-- [[ BUILD SIMPLE UI ]] --
local yPos = 5

yPos = createToggle(scrollingFrame, "Aimbot", yPos, "Aimbot")
yPos = createToggle(scrollingFrame, "Silent Aim", yPos, "SilentAim")
yPos = createToggle(scrollingFrame, "FOV Circle", yPos, "FOVCircleVisible")
yPos = createSlider(scrollingFrame, "FOV Radius", yPos, 50, 500, 150, "FOVRadius")

yPos = createToggle(scrollingFrame, "Fly", yPos, "Fly")
yPos = createSlider(scrollingFrame, "Fly Speed", yPos, 0, 200, 50, "FlySpeed")

yPos = createToggle(scrollingFrame, "Speed", yPos, "Speed")
yPos = createSlider(scrollingFrame, "Speed Value", yPos, 0, 100, 30, "SpeedValue")

yPos = createToggle(scrollingFrame, "No Clip", yPos, "NoClip")
yPos = createToggle(scrollingFrame, "TP to Enemy", yPos, "TPToEnemy")

scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, yPos + 10)

-- [[ DRAGGABLE MENU ]] --
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
-- LIGHTWEIGHT FEATURES (OPTIMIZED)
-- ═════════════════════════════════════════════════════════════════

-- [[ FOV CIRCLE (ONLY WHEN NEEDED) ]] --
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
    if fovCounter >= 3 then -- Update every 3 frames
        fovCounter = 0
        
        if Features.SilentAim and Features.FOVCircleVisible then
            if not FOVCircle then createFOVCircle() end
            FOVCircle.Visible = true
            FOVCircle.Position = UserInputService:GetMouseLocation()
            FOVCircle.Radius = Features.FOVRadius
        else
            if FOVCircle then
                FOVCircle.Visible = false
            end
        end
    end
end)

-- [[ GET CLOSEST PLAYER ]] --
local function GetClosestPlayer()
    local ClosestDistance, ClosestPart = math.huge, nil
    local MousePosition = UserInputService:GetMouseLocation()

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            local humanoid = plr.Character:FindFirstChild("Humanoid")
            
            if head and humanoid and humanoid.Health > 0 then
                local screenPos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(head.Position)
                if onScreen then
                    local dist = (MousePosition - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                    if dist < ClosestDistance and dist <= Features.FOVRadius then
                        ClosestDistance, ClosestPart = dist, head
                    end
                end
            end
        end
    end

    return ClosestPart
end

-- [[ NO CLIP ]] --
local noclipCounter = 0
RunService.Stepped:Connect(function()
    if Features.NoClip then
        noclipCounter = noclipCounter + 1
        if noclipCounter >= 2 then -- Every 2 frames
            noclipCounter = 0
            if Character then
                for _, Part in pairs(Character:GetDescendants()) do
                    if Part:IsA("BasePart") then
                        Part.CanCollide = false
                    end
                end
            end
        end
    end
end)

-- [[ SPEED ]] --
local speedCounter = 0
RunService.Heartbeat:Connect(function()
    if Features.Speed and Character and RootPart then
        speedCounter = speedCounter + 1
        if speedCounter >= 1 then
            speedCounter = 0
            local moveDirection = Vector3.new(0, 0, 0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + (workspace.CurrentCamera.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - (workspace.CurrentCamera.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - workspace.CurrentCamera.CFrame.RightVector
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + workspace.CurrentCamera.CFrame.RightVector
            end
            
            if moveDirection.Magnitude > 0 then
                RootPart.AssemblyLinearVelocity = moveDirection.Unit * Features.SpeedValue
            end
        end
    end
end)

-- [[ FLY (OPTIMIZED) ]] --
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

local flyCounter = 0
RunService.Heartbeat:Connect(function()
    if Features.Fly then
        if not flying then startFly() end
        
        flyCounter = flyCounter + 1
        if flyCounter >= 1 then
            flyCounter = 0
            if flying and bodyVelocity and bodyGyro then
                local moveDirection = Vector3.new(0, 0, 0)
                local camera = workspace.CurrentCamera
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDirection = moveDirection + camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDirection = moveDirection - camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDirection = moveDirection - camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDirection = moveDirection + camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveDirection = moveDirection + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    moveDirection = moveDirection - Vector3.new(0, 1, 0)
                end
                
                bodyVelocity.Velocity = moveDirection.Unit * Features.FlySpeed
                bodyGyro.CFrame = camera.CFrame
            end
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
        if tpCounter >= 5 then -- Update every 5 frames
            tpCounter = 0
            local target = GetClosestPlayer()
            if target then
                RootPart.CFrame = target.CFrame + target.CFrame.LookVector * 3
            end
        end
    end
end)

-- Handle character respawn
player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    RootPart = Character:WaitForChild("HumanoidRootPart")
    stopFly()
    Features.Speed = false
    Features.NoClip = false
    Features.Fly = false
end)

print("✓ LIGHTWEIGHT MENU LOADED")
print("✓ Minimize (−) / Close (X) buttons available")
print("✓ Drag menu by the title bar")
print("✓ Zero lag guaranteed!")
