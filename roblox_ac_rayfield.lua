-- ================================================
--   Anti-Cheat Test Menu | Rayfield + Drawing API
--   Keybind: RightShift = Show / Hide
-- ================================================

print("[AC Menu] Starting initialization...")

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local Camera           = workspace.CurrentCamera
local LocalPlayer      = Players.LocalPlayer
local LocalCharacter   = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

print("[AC Menu] Services loaded, initializing state...")

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
--  LOAD RAYFIELD
-- ══════════════════════════════════════
print("[AC Menu] Loading Rayfield UI library...")

local Rayfield
local success = pcall(function()
    Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success or not Rayfield then
    print("[AC Menu] ERROR: Failed to load Rayfield. Trying alternative...")
    success = pcall(function()
        Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
    end)
    
    if not success or not Rayfield then
        print("[AC Menu] ERROR: Could not load any UI library!")
        return
    end
end

print("[AC Menu] Rayfield loaded successfully!")

-- ══════════════════════════════════════
--  CREATE WINDOW
-- ══════════════════════════════════════
print("[AC Menu] Creating main window...")

local Window = Rayfield:CreateWindow({
    Name = "⚙ AC Test Menu",
    LoadingTitle = "AC Menu Loading",
    LoadingSubtitle = "Please wait...",
    ConfigurationSaving = {
        Enabled = false,
    },
    KeySystem = false,
})

print("[AC Menu] Window created!")

-- ══════════════════════════════════════
--  TEAM CHECK
-- ══════════════════════════════════════
local function isSameTeam(player)
    local playerTeam = player.Team
    local localTeam = LocalPlayer.Team
    
    if playerTeam == nil or localTeam == nil then
        return false
    end
    
    return playerTeam == localTeam
end

print("[AC Menu] Team check function created")

-- ══════════════════════════════════════
--  AIMBOT TAB
-- ══════════════════════════════════════
print("[AC Menu] Creating Aimbot tab...")

local AimbotTab = Window:CreateTab("🎯 Aimbot", 4483362458)

AimbotTab:CreateSection("Aimbot Settings")

AimbotTab:CreateToggle({
    Name = "Aimbot (Lock to Head)",
    CurrentValue = false,
    Flag = "Aimbot",
    Callback = function(Value)
        State.Aimbot = Value
        print("[Aimbot] Toggled:", Value)
    end,
})

AimbotTab:CreateToggle({
    Name = "Auto Shoot",
    CurrentValue = false,
    Flag = "AutoShoot",
    Callback = function(Value)
        State.AutoShoot = Value
        print("[AutoShoot] Toggled:", Value)
    end,
})

AimbotTab:CreateSection("FOV Settings")

AimbotTab:CreateToggle({
    Name = "Show FOV Circle",
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

print("[AC Menu] Aimbot tab created")

-- ══════════════════════════════════════
--  VISUALS TAB
-- ══════════════════════════════════════
print("[AC Menu] Creating Visuals tab...")

local VisualsTab = Window:CreateTab("👁 Visuals", 4483362458)

VisualsTab:CreateSection("ESP Settings")

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
    Name = "ESP Line",
    CurrentValue = false,
    Flag = "ESPLine",
    Callback = function(Value)
        State.ESPLine = Value
    end,
})

VisualsTab:CreateDropdown({
    Name = "Line Origin",
    Options = {"Top", "Center", "Bottom"},
    CurrentOption = {"Bottom"},
    Flag = "ESPLinePos",
    Callback = function(Option)
        State.ESPLinePos = Option[1]
    end,
})

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

VisualsTab:CreateSection("Health & Distance")

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

VisualsTab:CreateToggle({
    Name = "ESP Distance",
    CurrentValue = false,
    Flag = "ESPDistance",
    Callback = function(Value)
        State.ESPDistance = Value
    end,
})

print("[AC Menu] Visuals tab created")

-- ══════════════════════════════════════
--  PLAYER TAB
-- ══════════════════════════════════════
print("[AC Menu] Creating Player tab...")

local PlayerTab = Window:CreateTab("🧍 Player", 4483362458)

PlayerTab:CreateSection("Movement")

PlayerTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(Value)
        State.Fly = Value
        print("[Fly] Toggled:", Value)
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
        print("[Velocity] Toggled:", Value)
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

PlayerTab:CreateSection("Utilities")

PlayerTab:CreateToggle({
    Name = "TP to Nearest Enemy",
    CurrentValue = false,
    Flag = "TPNearest",
    Callback = function(Value)
        State.TPNearest = Value
        print("[TP Nearest] Toggled:", Value)
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

print("[AC Menu] Player tab created")

-- ══════════════════════════════════════
--  DRAWING - FOV CIRCLE
-- ══════════════════════════════════════
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(108, 84, 230)
FOVCircle.Thickness = 2
FOVCircle.Transparency = 0.5

local function updateFOVCircle()
    local mousePos = UserInputService:GetMouseLocation()
    FOVCircle.Position = mousePos
    FOVCircle.Radius = State.FOVSize
    FOVCircle.Visible = State.FOVCircle
end

-- ══════════════════════════════════════
--  ESP DRAWING
-- ══════════════════════════════════════
local ESPDrawings = {}

local function clearESP()
    for _, drawing in ipairs(ESPDrawings) do
        if drawing then
            pcall(function() drawing:Remove() end)
        end
    end
    ESPDrawings = {}
end

local function drawESP()
    clearESP()
    if not State.ESPEnabled then return end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer or not player.Character then continue end
        if isSameTeam(player) then continue end
        
        local character = player.Character
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local hrp = character:FindFirstChild("HumanoidRootPart")
        
        if not humanoid or not hrp or humanoid.Health <= 0 then continue end
        
        local screenPos, onScreen = Camera:WorldToScreenPoint(hrp.Position)
        if not onScreen then continue end
        
        -- ESP Box
        if State.ESPBox then
            local box = Drawing.new("Square")
            box.Visible = true
            box.Filled = false
            box.Color = Color3.fromRGB(108, 84, 230)
            box.Thickness = 2
            box.Position = Vector2.new(screenPos.X - 50, screenPos.Y - 50)
            box.Size = Vector2.new(100, 100)
            table.insert(ESPDrawings, box)
        end
        
        -- ESP Line
        if State.ESPLine then
            local line = Drawing.new("Line")
            line.Visible = true
            line.Color = Color3.fromRGB(108, 84, 230)
            line.Thickness = 2
            
            local lineOriginY = 0
            if State.ESPLinePos == "Bottom" then lineOriginY = 1080 end
            if State.ESPLinePos == "Center" then lineOriginY = 540 end
            
            line.From = Vector2.new(screenPos.X, lineOriginY)
            line.To = Vector2.new(screenPos.X, screenPos.Y)
            table.insert(ESPDrawings, line)
        end
        
        -- ESP Name
        if State.ESPName then
            local nameText = Drawing.new("Text")
            nameText.Visible = true
            nameText.Color = Color3.fromRGB(215, 215, 245)
            nameText.Size = 13
            nameText.Font = 2
            nameText.Text = player.Name
            
            local offset = State.ESPNamePos == "Top" and -25 or 25
            nameText.Position = Vector2.new(screenPos.X - 30, screenPos.Y + offset)
            table.insert(ESPDrawings, nameText)
        end
        
        -- ESP Distance
        if State.ESPDistance then
            local localHrp = LocalCharacter:FindFirstChild("HumanoidRootPart")
            if localHrp then
                local distance = (hrp.Position - localHrp.Position).Magnitude
                local distText = Drawing.new("Text")
                distText.Visible = true
                distText.Color = Color3.fromRGB(130, 130, 170)
                distText.Size = 11
                distText.Font = 2
                distText.Text = string.format("%.1f stud", distance)
                
                local offset = State.ESPDistPos == "Top" and -40 or 40
                distText.Position = Vector2.new(screenPos.X - 30, screenPos.Y + offset)
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
            
            local barWidth = 3
            local barHeight = 60
            local healthPercent = humanoid.Health / humanoid.MaxHealth
            
            if State.ESPHealthPos == "Left" then
                healthBar.Position = Vector2.new(screenPos.X - 60, screenPos.Y - barHeight / 2)
            elseif State.ESPHealthPos == "Right" then
                healthBar.Position = Vector2.new(screenPos.X + 50, screenPos.Y - barHeight / 2)
            else
                healthBar.Position = Vector2.new(screenPos.X - barWidth / 2, screenPos.Y - 70)
            end
            
            healthBar.Size = Vector2.new(barWidth, barHeight * healthPercent)
            table.insert(ESPDrawings, healthBar)
        end
    end
end

print("[AC Menu] ESP functions created")

-- ══════════════════════════════════════
--  AIMBOT SYSTEM
-- ══════════════════════════════════════
local function getClosestPlayerInFOV()
    local closest = nil
    local closestDistance = State.FOVSize
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer or not player.Character then continue end
        if isSameTeam(player) then continue end
        
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
    if currentTime - lastShootTime < 0.1 then return end
    lastShootTime = currentTime
    
    local tool = LocalCharacter:FindFirstChildOfClass("Tool")
    if tool and tool:FindFirstChild("Handle") then
        local fireEvent = tool:FindFirstChild("Fire")
        if fireEvent then
            pcall(function() fireEvent:FireServer() end)
        end
    end
end

print("[AC Menu] Aimbot functions created")

-- ══════════════════════════════════════
--  FLY SYSTEM
-- ══════════════════════════════════════
local function startFly()
    if Flying then return end
    Flying = true
    
    local hrp = LocalCharacter:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    FlyVelocity.Parent = hrp
    FlyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    
    FlyGyro.Parent = hrp
    FlyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    FlyGyro.CFrame = hrp.CFrame
    
    FlyConnection = RunService.RenderStepped:Connect(function()
        if not Flying or not LocalCharacter then return end
        
        local hrp = LocalCharacter:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local moveDir = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + (Camera.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - (Camera.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDir = moveDir + Vector3.new(0, -1, 0)
        end
        
        if moveDir.Magnitude > 0 then moveDir = moveDir.Unit end
        
        FlyVelocity.Velocity = moveDir * State.FlySpeed
        FlyGyro.CFrame = Camera.CFrame
    end)
    
    print("[Fly] Started!")
end

local function stopFly()
    if not Flying then return end
    Flying = false
    
    if FlyConnection then
        FlyConnection:Disconnect()
    end
    
    FlyVelocity.Parent = nil
    FlyGyro.Parent = nil
    
    print("[Fly] Stopped!")
end

-- ══════════════════════════════════════
--  VELOCITY SYSTEM
-- ══════════════════════════════════════
local velocityBV = nil
local velocityConnection = nil

local function startVelocity()
    local hrp = LocalCharacter:FindFirstChild("HumanoidRootPart")
    if not hrp or velocityBV then return end
    
    velocityBV = Instance.new("BodyVelocity")
    velocityBV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    velocityBV.Parent = hrp
    
    velocityConnection = RunService.RenderStepped:Connect(function()
        if not State.Velocity or not LocalCharacter then return end
        
        local hrp = LocalCharacter:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local moveDir = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + (Camera.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - (Camera.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + Camera.CFrame.RightVector
        end
        
        if moveDir.Magnitude > 0 then moveDir = moveDir.Unit end
        
        velocityBV.Velocity = moveDir * State.VelocitySpeed
    end)
    
    print("[Velocity] Started!")
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
    
    print("[Velocity] Stopped!")
end

print("[AC Menu] Movement systems created")

-- ══════════════════════════════════════
--  MAIN LOOP
-- ══════════════════════════════════════
print("[AC Menu] Creating main loop...")

RunService.RenderStepped:Connect(function()
    -- FOV Circle
    updateFOVCircle()
    
    -- ESP
    if State.ESPEnabled then
        drawESP()
    else
        clearESP()
    end
    
    -- Aimbot
    if State.Aimbot or State.AimAssist or State.AutoShoot then
        local target = getClosestPlayerInFOV()
        if target and target.Character then
            local head = target.Character:FindFirstChild("Head")
            if head then
                if State.Aimbot then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, head.Position)
                end
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
        local hum = LocalCharacter:FindFirstChildOfClass("Humanoid")
        if hum then hum.Health = hum.MaxHealth end
    end
    
    -- TP Nearest
    if State.TPNearest then
        local nearest = nil
        local nearestDist = math.huge
        local localHrp = LocalCharacter:FindFirstChild("HumanoidRootPart")
        
        if localHrp then
            for _, player in ipairs(Players:GetPlayers()) do
                if player == LocalPlayer or not player.Character then continue end
                if isSameTeam(player) then continue end
                
                local targetHrp = player.Character:FindFirstChild("HumanoidRootPart")
                if not targetHrp then continue end
                
                local dist = (targetHrp.Position - localHrp.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearest = player
                end
            end
            
            if nearest and nearest.Character then
                local targetHrp = nearest.Character:FindFirstChild("HumanoidRootPart")
                if targetHrp then
                    localHrp.CFrame = targetHrp.CFrame + Vector3.new(5, 0, 0)
                    print("[TP] Teleported to:", nearest.Name)
                end
            end
        end
        
        State.TPNearest = false
    end
end)

-- ══════════════════════════════════════
--  KEYBIND
-- ══════════════════════════════════════
UserInputService.InputBegan:Connect(function(inp, gpe)
    if gpe then return end
    if inp.KeyCode == Enum.KeyCode.RightShift then
        Window:Toggle()
        print("[AC Menu] Window toggled")
    end
end)

-- ══════════════════════════════════════
--  CLEANUP
-- ══════════════════════════════════════
LocalPlayer.CharacterAdded:Connect(function(newChar)
    LocalCharacter = newChar
    stopFly()
    stopVelocity()
    clearESP()
    print("[AC Menu] Character respawned")
end)

print("[AC Menu] ✅ Initialization complete! Press RightShift to toggle menu")
print("[AC Menu] Enjoy! Team check enabled - you won't target teammates")
