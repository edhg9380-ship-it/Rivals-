-- ================================================
--   Anti-Cheat Test Menu | Rayfield + Drawing API
--   Keybind: RightShift = Show / Hide
-- ================================================

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Camera           = workspace.CurrentCamera
local LocalPlayer      = Players.LocalPlayer
local LocalCharacter   = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- ══════════════════════════════════════
--  STATE
-- ══════════════════════════════════════
local State = {
    -- Aimbot
    Aimbot        = false,
    AimAssist     = false,
    AutoShoot     = false,
    FOVCircle     = false,
    FOVSize       = 200,

    -- ESP
    ESPEnabled    = false,
    ESPBox        = false,
    ESPName       = false,
    ESPNamePos    = "Top",
    ESPHealthBar  = false,
    ESPHealthPos  = "Left",
    ESPDistance   = false,
    ESPDistPos    = "Bottom",
    ESPSkeleton   = false,
    ESPLine       = false,
    ESPLinePos    = "Bottom",

    -- Player
    Fly           = false,
    FlySpeed      = 50,
    Velocity      = false,
    VelocitySpeed = 50,
    TPNearest     = false,
    AutoHeal      = false,
}

-- ══════════════════════════════════════
--  FLIGHT SYSTEM
-- ══════════════════════════════════════
local Flying = false
local FlyConnection = nil
local FlyVelocity = Instance.new("BodyVelocity")
local FlyGyro = Instance.new("BodyGyro")

-- ══════════════════════════════════════
--  RAYFIELD SETUP
-- ══════════════════════════════════════
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "⚙  AC Test Menu",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Initializing",
    ConfigurationSaving = {
        Enabled = false,
    },
    KeySystem = false,
})

-- ══════════════════════════════════════
--  AIMBOT TAB
-- ══════════════════════════════════════
local AimbotTab = Window:CreateTab("🎯 Aimbot", 4483362458)

local AimbotSection = AimbotTab:CreateSection("Aimbot")

AimbotTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "Aimbot",
    Callback = function(Value)
        State.Aimbot = Value
    end,
})

AimbotTab:CreateToggle({
    Name = "Aim Assist (Instant Lock)",
    CurrentValue = false,
    Flag = "AimAssist",
    Callback = function(Value)
        State.AimAssist = Value
    end,
})

AimbotTab:CreateToggle({
    Name = "Auto Shoot",
    CurrentValue = false,
    Flag = "AutoShoot",
    Callback = function(Value)
        State.AutoShoot = Value
    end,
})

local FOVSection = AimbotTab:CreateSection("Field of View")

AimbotTab:CreateToggle({
    Name = "FOV Circle",
    CurrentValue = false,
    Flag = "FOVCircle",
    Callback = function(Value)
        State.FOVCircle = Value
    end,
})

AimbotTab:CreateSlider({
    Name = "FOV Size",
    Min = 50,
    Max = 1000,
    Increment = 10,
    Suffix = "px",
    CurrentValue = 200,
    Flag = "FOVSize",
    Callback = function(Value)
        State.FOVSize = Value
    end,
})

-- ══════════════════════════════════════
--  VISUALS TAB
-- ══════════════════════════════════════
local VisualsTab = Window:CreateTab("👁 Visuals", 4483362458)

local ESPSection = VisualsTab:CreateSection("ESP")

VisualsTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Flag = "ESPEnabled",
    Callback = function(Value)
        State.ESPEnabled = Value
    end,
})

VisualsTab:CreateToggle({
    Name = "ESP Box",
    CurrentValue = false,
    Flag = "ESPBox",
    Callback = function(Value)
        State.ESPBox = Value
    end,
})

VisualsTab:CreateToggle({
    Name = "ESP Skeleton",
    CurrentValue = false,
    Flag = "ESPSkeleton",
    Callback = function(Value)
        State.ESPSkeleton = Value
    end,
})

local ESPLineSection = VisualsTab:CreateSection("ESP Line")

VisualsTab:CreateToggle({
    Name = "ESP Line",
    CurrentValue = false,
    Flag = "ESPLine",
    Callback = function(Value)
        State.ESPLine = Value
    end,
})

VisualsTab:CreateDropdown({
    Name = "Line Origin",
    Options = {"Top", "Side", "Bottom"},
    CurrentOption = {"Bottom"},
    Flag = "ESPLinePos",
    Callback = function(Option)
        State.ESPLinePos = Option[1]
    end,
})

local ESPNameSection = VisualsTab:CreateSection("ESP Name")

VisualsTab:CreateToggle({
    Name = "ESP Name",
    CurrentValue = false,
    Flag = "ESPName",
    Callback = function(Value)
        State.ESPName = Value
    end,
})

VisualsTab:CreateDropdown({
    Name = "Name Position",
    Options = {"Top", "Bottom"},
    CurrentOption = {"Top"},
    Flag = "ESPNamePos",
    Callback = function(Option)
        State.ESPNamePos = Option[1]
    end,
})

local HealthSection = VisualsTab:CreateSection("Health Bar")

VisualsTab:CreateToggle({
    Name = "ESP Health Bar",
    CurrentValue = false,
    Flag = "ESPHealthBar",
    Callback = function(Value)
        State.ESPHealthBar = Value
    end,
})

VisualsTab:CreateDropdown({
    Name = "Health Bar Side",
    Options = {"Top", "Left", "Right"},
    CurrentOption = {"Left"},
    Flag = "ESPHealthPos",
    Callback = function(Option)
        State.ESPHealthPos = Option[1]
    end,
})

local DistSection = VisualsTab:CreateSection("Distance")

VisualsTab:CreateToggle({
    Name = "ESP Distance",
    CurrentValue = false,
    Flag = "ESPDistance",
    Callback = function(Value)
        State.ESPDistance = Value
    end,
})

VisualsTab:CreateDropdown({
    Name = "Distance Position",
    Options = {"Top", "Bottom"},
    CurrentOption = {"Bottom"},
    Flag = "ESPDistPos",
    Callback = function(Option)
        State.ESPDistPos = Option[1]
    end,
})

-- ══════════════════════════════════════
--  PLAYER TAB
-- ══════════════════════════════════════
local PlayerTab = Window:CreateTab("🧍 Player", 4483362458)

local MovementSection = PlayerTab:CreateSection("Movement")

PlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(Value)
        State.Fly = Value
    end,
})

PlayerTab:CreateSlider({
    Name = "Fly Speed",
    Min = 1,
    Max = 200,
    Increment = 5,
    Suffix = "u/s",
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(Value)
        State.FlySpeed = Value
    end,
})

PlayerTab:CreateToggle({
    Name = "Velocity",
    CurrentValue = false,
    Flag = "Velocity",
    Callback = function(Value)
        State.Velocity = Value
    end,
})

PlayerTab:CreateSlider({
    Name = "Velocity Speed",
    Min = 1,
    Max = 200,
    Increment = 5,
    Suffix = "u/s",
    CurrentValue = 50,
    Flag = "VelocitySpeed",
    Callback = function(Value)
        State.VelocitySpeed = Value
    end,
})

local MiscSection = PlayerTab:CreateSection("Misc")

PlayerTab:CreateToggle({
    Name = "TP to Nearest Player",
    CurrentValue = false,
    Flag = "TPNearest",
    Callback = function(Value)
        State.TPNearest = Value
    end,
})

PlayerTab:CreateToggle({
    Name = "Auto Heal",
    CurrentValue = false,
    Flag = "AutoHeal",
    Callback = function(Value)
        State.AutoHeal = Value
    end,
})

-- ══════════════════════════════════════
--  DRAWING API - ESP
-- ══════════════════════════════════════
local ESPDrawings = {}

local function clearESP()
    for _, drawing in ipairs(ESPDrawings) do
        if drawing and drawing.Visible then
            drawing:Remove()
        end
    end
    ESPDrawings = {}
end

local function drawESP()
    clearESP()
    
    if not State.ESPEnabled then return end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer or not player.Character then continue end
        
        local character = player.Character
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        
        if not humanoid or not humanoidRootPart or humanoid.Health <= 0 then continue end
        
        -- ESP Box
        if State.ESPBox then
            local box = Drawing.new("Square")
            box.Visible = true
            box.Filled = false
            box.Color = Color3.fromRGB(108, 84, 230)
            box.Thickness = 2
            box.Transparency = 0.8
            
            local pos, onScreen = Camera:WorldToScreenPoint(humanoidRootPart.Position)
            if onScreen then
                box.Position = Vector2.new(pos.X - 50, pos.Y - 50)
                box.Size = Vector2.new(100, 100)
                table.insert(ESPDrawings, box)
            end
        end
        
        -- ESP Line
        if State.ESPLine then
            local line = Drawing.new("Line")
            line.Visible = true
            line.Color = Color3.fromRGB(108, 84, 230)
            line.Thickness = 2
            line.Transparency = 0.8
            
            local pos, onScreen = Camera:WorldToScreenPoint(humanoidRootPart.Position)
            if onScreen then
                local screenSize = Vector2.new(1920, 1080) -- Adjust based on screen
                local lineOriginY = State.ESPLinePos == "Top" and 0 or (State.ESPLinePos == "Bottom" and screenSize.Y or screenSize.Y / 2)
                
                line.From = Vector2.new(pos.X, lineOriginY)
                line.To = Vector2.new(pos.X, pos.Y)
                table.insert(ESPDrawings, line)
            end
        end
        
        -- ESP Name
        if State.ESPName then
            local nameText = Drawing.new("Text")
            nameText.Visible = true
            nameText.Color = Color3.fromRGB(215, 215, 245)
            nameText.Size = 13
            nameText.Font = 2
            nameText.Text = player.Name
            
            local pos, onScreen = Camera:WorldToScreenPoint(humanoidRootPart.Position)
            if onScreen then
                local offset = State.ESPNamePos == "Top" and -20 or 20
                nameText.Position = Vector2.new(pos.X, pos.Y + offset)
                table.insert(ESPDrawings, nameText)
            end
        end
        
        -- ESP Distance
        if State.ESPDistance then
            local distText = Drawing.new("Text")
            distText.Visible = true
            distText.Color = Color3.fromRGB(130, 130, 170)
            distText.Size = 11
            distText.Font = 2
            local distance = (humanoidRootPart.Position - LocalCharacter:FindFirstChild("HumanoidRootPart").Position).Magnitude
            distText.Text = string.format("%.1f stud", distance)
            
            local pos, onScreen = Camera:WorldToScreenPoint(humanoidRootPart.Position)
            if onScreen then
                local offset = State.ESPDistPos == "Top" and -35 or 35
                distText.Position = Vector2.new(pos.X, pos.Y + offset)
                table.insert(ESPDrawings, distText)
            end
        end
        
        -- ESP Health Bar
        if State.ESPHealthBar then
            local healthBar = Drawing.new("Square")
            healthBar.Visible = true
            healthBar.Filled = true
            healthBar.Color = Color3.fromRGB(255, 50, 50)
            healthBar.Thickness = 1
            healthBar.Transparency = 0.5
            
            local pos, onScreen = Camera:WorldToScreenPoint(humanoidRootPart.Position)
            if onScreen then
                local barWidth = 3
                local barHeight = 60
                local healthPercent = humanoid.Health / humanoid.MaxHealth
                
                if State.ESPHealthPos == "Left" then
                    healthBar.Position = Vector2.new(pos.X - 60, pos.Y - barHeight / 2)
                elseif State.ESPHealthPos == "Right" then
                    healthBar.Position = Vector2.new(pos.X + 50, pos.Y - barHeight / 2)
                else
                    healthBar.Position = Vector2.new(pos.X - barWidth / 2, pos.Y - 70)
                end
                
                healthBar.Size = Vector2.new(barWidth, barHeight * healthPercent)
                table.insert(ESPDrawings, healthBar)
            end
        end
    end
end

-- ══════════════════════════════════════
--  DRAWING API - FOV CIRCLE
-- ══════════════════════════════════════
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(108, 84, 230)
FOVCircle.Thickness = 2
FOVCircle.Transparency = 0.5

local function updateFOVCircle()
    local screenSize = UserInputService:GetMouseLocation()
    FOVCircle.Position = screenSize
    FOVCircle.Radius = State.FOVSize
    FOVCircle.Visible = State.FOVCircle
end

-- ══════════════════════════════════════
--  KEYBIND: SHOW / HIDE
-- ══════════════════════════════════════
UserInputService.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.KeyCode == Enum.KeyCode.RightShift then
        Window:Toggle()
    end
end)

-- ══════════════════════════════════════
--  AIMBOT SYSTEM
-- ══════════════════════════════════════
local function getClosestPlayerInFOV()
    local closest = nil
    local closestDistance = State.FOVSize
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer or not player.Character then continue end
        
        local head = player.Character:FindFirstChild("Head")
        if not head then continue end
        
        local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then continue end
        
        local screenPos, onScreen = Camera:WorldToScreenPoint(head.Position)
        if not onScreen then continue end
        
        local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
        if distance < closestDistance then
            closestDistance = distance
            closest = player
        end
    end
    
    return closest
end

local lastShootTime = 0
local function autoShoot()
    if not State.AutoShoot then return end
    
    local currentTime = tick()
    if currentTime - lastShootTime < 0.1 then return end -- 100ms cooldown
    lastShootTime = currentTime
    
    -- Try to find and fire weapon
    local tool = LocalCharacter:FindFirstChildOfClass("Tool")
    if tool then
        local fireFunc = tool:FindFirstChild("Fire") or tool:FindFirstChildOfClass("RemoteEvent")
        if fireFunc then
            fireFunc:FireServer()
        end
    end
    
    -- Alternative: simulate mouse click
    UserInputService:SendMouseButtonEvent(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y, 0, true)
    UserInputService:SendMouseButtonEvent(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y, 0, false)
end

-- ══════════════════════════════════════
--  FLY SYSTEM
-- ══════════════════════════════════════
local function startFly()
    if Flying then return end
    Flying = true
    
    local char = LocalCharacter
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
    if not hrp or not hum then return end
    
    -- Setup velocity and gyro
    FlyVelocity.Parent = hrp
    FlyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    
    FlyGyro.Parent = hrp
    FlyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    FlyGyro.CFrame = hrp.CFrame
    
    -- Movement loop
    FlyConnection = RunService.RenderStepped:Connect(function()
        if not Flying or not LocalCharacter then return end
        
        local hrp = LocalCharacter:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local moveDirection = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + (Camera.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - (Camera.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end
        
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit
        end
        
        FlyVelocity.Velocity = moveDirection * State.FlySpeed
        FlyGyro.CFrame = Camera.CFrame
    end)
end

local function stopFly()
    if not Flying then return end
    Flying = false
    
    if FlyConnection then
        FlyConnection:Disconnect()
    end
    
    FlyVelocity.Parent = nil
    FlyGyro.Parent = nil
end

-- ══════════════════════════════════════
--  VELOCITY SYSTEM
-- ══════════════════════════════════════
local velocityBV = nil
local velocityConnection = nil

local function startVelocity()
    local char = LocalCharacter
    local hrp = char:FindFirstChild("HumanoidRootPart")
    
    if not hrp or velocityBV then return end
    
    velocityBV = Instance.new("BodyVelocity")
    velocityBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    velocityBV.Parent = hrp
    
    velocityConnection = RunService.RenderStepped:Connect(function()
        if not State.Velocity or not LocalCharacter then return end
        
        local hrp = LocalCharacter:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local moveDirection = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + (Camera.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - (Camera.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + Camera.CFrame.RightVector
        end
        
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit
        end
        
        velocityBV.Velocity = moveDirection * State.VelocitySpeed
    end)
end

local function stopVelocity()
    if velocityConnection then
        velocityConnection:Disconnect()
        velocityConnection = nil
    end
    
    if velocityBV then
        velocityBV.Parent = nil
        velocityBV = nil
    end
end

-- ══════════════════════════════════════
--  MAIN LOOP
-- ══════════════════════════════════════
RunService.RenderStepped:Connect(function()
    -- Update FOV Circle
    updateFOVCircle()
    
    -- Update ESP
    if State.ESPEnabled then
        drawESP()
    else
        clearESP()
    end
    
    -- Aimbot
    if State.Aimbot or State.AimAssist then
        local target = getClosestPlayerInFOV()
        if target and target.Character then
            local head = target.Character:FindFirstChild("Head")
            if head then
                if State.Aimbot then
                    -- Lock camera to head
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
                end
                
                -- Auto shoot if enabled
                if State.AutoShoot then
                    autoShoot()
                end
            end
        end
    end
    
    -- Fly
    if State.Fly and not Flying then
        startFly()
    elseif not State.Fly and Flying then
        stopFly()
    end
    
    -- Velocity
    if State.Velocity and not velocityConnection then
        startVelocity()
    elseif not State.Velocity and velocityConnection then
        stopVelocity()
    end
    
    -- Auto Heal
    if State.AutoHeal then
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.Health = hum.MaxHealth
            end
        end
    end
    
    -- TP to Nearest
    if State.TPNearest then
        local nearestPlayer = nil
        local nearestDistance = math.huge
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer or not player.Character then continue end
            
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local localHrp = LocalCharacter:FindFirstChild("HumanoidRootPart")
            if not hrp or not localHrp then continue end
            
            local distance = (hrp.Position - localHrp.Position).Magnitude
            if distance < nearestDistance then
                nearestDistance = distance
                nearestPlayer = player
            end
        end
        
        if nearestPlayer and nearestPlayer.Character then
            local targetHrp = nearestPlayer.Character:FindFirstChild("HumanoidRootPart")
            local localHrp = LocalCharacter:FindFirstChild("HumanoidRootPart")
            if targetHrp and localHrp then
                localHrp.CFrame = targetHrp.CFrame + Vector3.new(5, 0, 0)
            end
            State.TPNearest = false
        end
    end
end)

print("[AC Test Menu] Ready │ RightShift = show/hide")

-- Cleanup on disconnect
LocalPlayer.CharacterAdded:Connect(function(newChar)
    LocalCharacter = newChar
    if Flying then
        stopFly()
    end
    if State.Velocity then
        stopVelocity()
    end
end)

-- Cleanup on script destroy
game:GetService("CoreGui").ScreenGui:GetPropertyChangedSignal("Visible"):Connect(function()
    if not game:GetService("CoreGui").ScreenGui.Visible then
        clearESP()
        FOVCircle.Visible = false
        stopFly()
        stopVelocity()
    end
end)

-- Final cleanup function
local function cleanup()
    if Flying then stopFly() end
    if State.Velocity then stopVelocity() end
    clearESP()
    FOVCircle:Remove()
    for _, drawing in ipairs(ESPDrawings) do
        if drawing then pcall(function() drawing:Remove() end) end
    end
end

-- Handle script reload
script.Parent:WaitForChild("Parent"):GetPropertyChangedSignal("Parent"):Connect(function()
    cleanup()
end)
