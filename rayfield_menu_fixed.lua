-- ═════════════════════════════════════════════════════════════════
-- COMPLETE ROBLOX EXPLOIT MENU - RAYFIELD UI (FIXED)
-- ═════════════════════════════════════════════════════════════════

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Exploit Menu",
    LoadingTitle = "Loading...",
    LoadingSubtitle = "Exploit Menu",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ExploitConfig",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
    },
    KeySystem = false,
})

-- [[ SERVICES & VARS ]] --
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local Character = player.Character or player.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- [[ FEATURE STATES ]] --
local Features = {
    -- Aimbot
    Aimbot = false,
    SilentAim = false,
    FOVCircle = false,
    FOVRadius = 150,
    
    -- Visuals
    ESP = false,
    ESPBox = false,
    ESPLine = false,
    ESPName = false,
    ESPDistance = false,
    ESPHealth = false,
    
    -- Extra
    Fly = false,
    FlySpeed = 50,
    Speed = false,
    SpeedValue = 30,
    NoClip = false,
    TPToEnemy = false,
}

-- ═════════════════════════════════════════════════════════════════
-- AIMBOT TAB
-- ═════════════════════════════════════════════════════════════════
local AimbotTab = Window:CreateTab("Aimbot", 4483362458)

local AimbotToggle = AimbotTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "AimbotToggle",
    Callback = function(Value)
        Features.Aimbot = Value
    end,
})

local SilentAimToggle = AimbotTab:CreateToggle({
    Name = "Silent Aim",
    CurrentValue = false,
    Flag = "SilentAimToggle",
    Callback = function(Value)
        Features.SilentAim = Value
    end,
})

local FOVCircleToggle = AimbotTab:CreateToggle({
    Name = "FOV Circle",
    CurrentValue = false,
    Flag = "FOVCircleToggle",
    Callback = function(Value)
        Features.FOVCircle = Value
    end,
})

local FOVRadiusSlider = AimbotTab:CreateSlider({
    Name = "FOV Radius",
    Min = 50,
    Max = 500,
    Default = 150,
    Color = Color3.fromRGB(255, 0, 0),
    Flag = "FOVRadiusSlider",
    Callback = function(Value)
        Features.FOVRadius = Value
    end,
})

-- ═════════════════════════════════════════════════════════════════
-- VISUALS TAB
-- ═════════════════════════════════════════════════════════════════
local VisualsTab = Window:CreateTab("Visuals", 6023426232)

local ESPToggle = VisualsTab:CreateToggle({
    Name = "Enable ESP",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(Value)
        Features.ESP = Value
    end,
})

local ESPBoxToggle = VisualsTab:CreateToggle({
    Name = "ESP Box",
    CurrentValue = false,
    Flag = "ESPBoxToggle",
    Callback = function(Value)
        Features.ESPBox = Value
    end,
})

local ESPLineToggle = VisualsTab:CreateToggle({
    Name = "ESP Line",
    CurrentValue = false,
    Flag = "ESPLineToggle",
    Callback = function(Value)
        Features.ESPLine = Value
    end,
})

local ESPNameToggle = VisualsTab:CreateToggle({
    Name = "ESP Name",
    CurrentValue = false,
    Flag = "ESPNameToggle",
    Callback = function(Value)
        Features.ESPName = Value
    end,
})

local ESPDistanceToggle = VisualsTab:CreateToggle({
    Name = "ESP Distance",
    CurrentValue = false,
    Flag = "ESPDistanceToggle",
    Callback = function(Value)
        Features.ESPDistance = Value
    end,
})

local ESPHealthToggle = VisualsTab:CreateToggle({
    Name = "ESP Health",
    CurrentValue = false,
    Flag = "ESPHealthToggle",
    Callback = function(Value)
        Features.ESPHealth = Value
    end,
})

-- ═════════════════════════════════════════════════════════════════
-- EXTRA TAB
-- ═════════════════════════════════════════════════════════════════
local ExtraTab = Window:CreateTab("Extra", 7072456143)

local FlyToggle = ExtraTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        Features.Fly = Value
    end,
})

local FlySpeedSlider = ExtraTab:CreateSlider({
    Name = "Fly Speed",
    Min = 0,
    Max = 200,
    Default = 50,
    Color = Color3.fromRGB(0, 150, 255),
    Flag = "FlySpeedSlider",
    Callback = function(Value)
        Features.FlySpeed = Value
    end,
})

local SpeedToggle = ExtraTab:CreateToggle({
    Name = "Speed",
    CurrentValue = false,
    Flag = "SpeedToggle",
    Callback = function(Value)
        Features.Speed = Value
    end,
})

local SpeedValueSlider = ExtraTab:CreateSlider({
    Name = "Speed Value",
    Min = 0,
    Max = 100,
    Default = 30,
    Color = Color3.fromRGB(0, 150, 255),
    Flag = "SpeedValueSlider",
    Callback = function(Value)
        Features.SpeedValue = Value
    end,
})

local NoClipToggle = ExtraTab:CreateToggle({
    Name = "No Clip",
    CurrentValue = false,
    Flag = "NoClipToggle",
    Callback = function(Value)
        Features.NoClip = Value
    end,
})

local TPToggle = ExtraTab:CreateToggle({
    Name = "TP to Enemy",
    CurrentValue = false,
    Flag = "TPToggle",
    Callback = function(Value)
        Features.TPToEnemy = Value
    end,
})

-- ═════════════════════════════════════════════════════════════════
-- SETTINGS TAB
-- ═════════════════════════════════════════════════════════════════
local SettingsTab = Window:CreateTab("Settings", 4385362449)

SettingsTab:CreateSection("Keybinds")
SettingsTab:CreateLabel("Aimbot: F")
SettingsTab:CreateLabel("Fly: G")
SettingsTab:CreateLabel("Speed: H")
SettingsTab:CreateLabel("Silent Aim: J")
SettingsTab:CreateLabel("No Clip: K")
SettingsTab:CreateLabel("TP to Enemy: L")

-- ═════════════════════════════════════════════════════════════════
-- DRAWING API - FOV CIRCLE
-- ═════════════════════════════════════════════════════════════════
local FOVCircleDrawing = Drawing.new("Circle")
FOVCircleDrawing.Visible = false
FOVCircleDrawing.Radius = 150
FOVCircleDrawing.Color = Color3.fromRGB(255, 0, 0)
FOVCircleDrawing.Thickness = 2
FOVCircleDrawing.Filled = false
FOVCircleDrawing.Transparency = 0.8

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

-- ═════════════════════════════════════════════════════════════════
-- DRAWING API - ESP
-- ═════════════════════════════════════════════════════════════════
local ESPStorage = {}

local function CreateESPForPlayer(plr)
    if ESPStorage[plr.UserId] then return end
    
    ESPStorage[plr.UserId] = {
        BoxOutline = Drawing.new("Square"),
        BoxFill = Drawing.new("Square"),
        NameText = Drawing.new("Text"),
        DistanceText = Drawing.new("Text"),
        HealthBar = Drawing.new("Square"),
        HealthFill = Drawing.new("Square"),
        LineToPlayer = Drawing.new("Line"),
    }
    
    local esp = ESPStorage[plr.UserId]
    
    -- Box
    esp.BoxOutline.Visible = false
    esp.BoxOutline.Color = Color3.fromRGB(255, 0, 0)
    esp.BoxOutline.Thickness = 1
    esp.BoxOutline.Filled = false
    
    -- Name
    esp.NameText.Visible = false
    esp.NameText.Color = Color3.fromRGB(255, 0, 0)
    esp.NameText.Size = 13
    esp.NameText.Center = true
    esp.NameText.Outline = true
    esp.NameText.OutlineColor = Color3.fromRGB(0, 0, 0)
    esp.NameText.Text = plr.Name
    
    -- Distance
    esp.DistanceText.Visible = false
    esp.DistanceText.Color = Color3.fromRGB(0, 255, 0)
    esp.DistanceText.Size = 11
    esp.DistanceText.Center = true
    esp.DistanceText.Outline = true
    esp.DistanceText.OutlineColor = Color3.fromRGB(0, 0, 0)
    
    -- Health Bar
    esp.HealthBar.Visible = false
    esp.HealthBar.Color = Color3.fromRGB(255, 0, 0)
    esp.HealthBar.Thickness = 1
    
    esp.HealthFill.Visible = false
    esp.HealthFill.Color = Color3.fromRGB(0, 255, 0)
    
    -- Line
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
                local rootPos = camera:WorldToScreenPoint(rootPart.Position)
                
                if onScreen and Features.ESP then
                    local distance = (player.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                    
                    -- Box
                    if Features.ESPBox then
                        esp.BoxOutline.Visible = true
                        esp.BoxOutline.Position = Vector2.new(headPos.X - 20, headPos.Y - 30)
                        esp.BoxOutline.Size = Vector2.new(40, 60)
                    else
                        esp.BoxOutline.Visible = false
                    end
                    
                    -- Name
                    if Features.ESPName then
                        esp.NameText.Visible = true
                        esp.NameText.Position = Vector2.new(headPos.X, headPos.Y - 40)
                    else
                        esp.NameText.Visible = false
                    end
                    
                    -- Distance
                    if Features.ESPDistance then
                        esp.DistanceText.Visible = true
                        esp.DistanceText.Position = Vector2.new(headPos.X, headPos.Y + 50)
                        esp.DistanceText.Text = math.floor(distance) .. " studs"
                    else
                        esp.DistanceText.Visible = false
                    end
                    
                    -- Health Bar
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
                    
                    -- Line
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

local espCounter = 0
RunService.RenderStepped:Connect(function()
    espCounter = espCounter + 1
    if espCounter >= 1 then
        espCounter = 0
        UpdateESP()
    end
end)

-- Clean up ESP when player leaves
Players.PlayerRemoving:Connect(function(plr)
    if ESPStorage[plr.UserId] then
        for _, drawing in pairs(ESPStorage[plr.UserId]) do
            drawing:Remove()
        end
        ESPStorage[plr.UserId] = nil
    end
end)

-- ═════════════════════════════════════════════════════════════════
-- GET CLOSEST PLAYER
-- ═════════════════════════════════════════════════════════════════
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

-- ═════════════════════════════════════════════════════════════════
-- SILENT AIM HOOK
-- ═════════════════════════════════════════════════════════════════
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

-- ═════════════════════════════════════════════════════════════════
-- NO CLIP
-- ═════════════════════════════════════════════════════════════════
local noclipCounter = 0
RunService.Stepped:Connect(function()
    if Features.NoClip then
        noclipCounter = noclipCounter + 1
        if noclipCounter >= 2 then
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

-- ═════════════════════════════════════════════════════════════════
-- SPEED
-- ═════════════════════════════════════════════════════════════════
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

-- ═════════════════════════════════════════════════════════════════
-- FLY
-- ═════════════════════════════════════════════════════════════════
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

-- ═════════════════════════════════════════════════════════════════
-- TP TO ENEMY
-- ═════════════════════════════════════════════════════════════════
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

-- ═════════════════════════════════════════════════════════════════
-- CHARACTER RESPAWN
-- ═════════════════════════════════════════════════════════════════
player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    RootPart = Character:WaitForChild("HumanoidRootPart")
    stopFly()
    Features.Speed = false
    Features.NoClip = false
    Features.Fly = false
end)

print("✓ RAYFIELD EXPLOIT MENU LOADED!")
print("✓ All 4 tabs active: Aimbot, Visuals, Extra, Settings")
print("✓ FOV Circle with Drawing API")
print("✓ Full ESP with Drawing API")
