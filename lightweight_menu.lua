-- ═════════════════════════════════════════════════════════════════
-- RAYFIELD MENU - SILENT AIM + AUTO SHOOT (ERROR-HANDLED)
-- ═════════════════════════════════════════════════════════════════

local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source.lua"))()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()
local Character = player.Character or player.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- [[ FEATURE STATES ]] --
local Features = {
    SilentAim = false,
    AutoShoot = false,
    FOVCircleVisible = false,
    FOVRadius = 150,
    
    -- Visuals (keep as before)
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

-- [[ CREATE WINDOW ]] --
local Window = Rayfield:CreateWindow({
    Name = "Complete Menu",
    Icon = 0,
    LoadingTitle = "Loading...",
    Theme = "Default",
    ConfigurationSaving = { Enabled = false }
})

local AimbotTab = Window:CreateTab("Aimbot")
local VisualsTab = Window:CreateTab("Visuals")
local ExtraTab = Window:CreateTab("Extra")
local SettingsTab = Window:CreateTab("Settings")

-- ═════════════════════════════════════════════════════════════════
-- AIMBOT TAB
-- ═════════════════════════════════════════════════════════════════
AimbotTab:CreateToggle({
    Name = "Silent Aim (Aim Correction)",
    CurrentValue = false,
    Flag = "SilentAimToggle",
    Callback = function(v) Features.SilentAim = v end,
})

AimbotTab:CreateToggle({
    Name = "Auto Shoot",
    CurrentValue = false,
    Flag = "AutoShootToggle",
    Callback = function(v) Features.AutoShoot = v end,
})

AimbotTab:CreateToggle({
    Name = "FOV Circle",
    CurrentValue = false,
    Flag = "FOVCircleToggle",
    Callback = function(v) Features.FOVCircleVisible = v end,
})

AimbotTab:CreateSlider({
    Name = "FOV Radius",
    Range = {50, 500},
    Increment = 5,
    Suffix = "px",
    CurrentValue = 150,
    Flag = "FOVRadiusSlider",
    Callback = function(v) Features.FOVRadius = v end,
})

-- ═════════════════════════════════════════════════════════════════
-- SILENT AIM IMPLEMENTATION
-- ═════════════════════════════════════════════════════════════════

local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = Color3.fromRGB(255, 0, 0)
FOVCircle.Thickness = 1
FOVCircle.Filled = false
FOVCircle.Transparency = 0.8
FOVCircle.Radius = Features.FOVRadius

-- Update FOV circle every render step
RunService.RenderStepped:Connect(function()
    FOVCircle.Visible = Features.FOVCircleVisible and Features.SilentAim
    FOVCircle.Position = UserInputService:GetMouseLocation()
    FOVCircle.Radius = Features.FOVRadius
end)

-- Get closest player within FOV
local function GetClosestPlayer()
    local closestDist = math.huge
    local closestPart = nil
    local mousePos = UserInputService:GetMouseLocation()

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local head = plr.Character:FindFirstChild("Head")
            local humanoid = plr.Character:FindFirstChild("Humanoid")
            if head and humanoid and humanoid.Health > 0 then
                local screenPos, onScreen = workspace.CurrentCamera:WorldToScreenPoint(head.Position)
                if onScreen then
                    local dist = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                    if dist <= Features.FOVRadius and dist < closestDist then
                        closestDist = dist
                        closestPart = head
                    end
                end
            end
        end
    end
    return closestPart
end

-- Silent aim hook (intercepts mouse.Hit and mouse.Target)
local grm = getrawmetatable(game)
local oldIndex = grm.__index
setreadonly(grm, false)

grm.__index = function(self, key)
    if not checkcaller() and self == mouse and Features.SilentAim then
        if key == "Hit" or key == "Target" then
            local target = GetClosestPlayer()
            if target then
                return CFrame.new(target.Position)
            end
        end
    end
    return oldIndex(self, key)
end
setreadonly(grm, true)

-- Auto shoot (if enabled) – with error handling
local function FireShot()
    if not Features.AutoShoot then return end
    local target = GetClosestPlayer()
    if not target then return end

    -- Try to find the remote; adapt the name if needed.
    local mainEvent = ReplicatedStorage:FindFirstChild("MainEvent")
    if not mainEvent then
        -- Try other common names (you can add more)
        mainEvent = ReplicatedStorage:FindFirstChild("ShootEvent") or 
                    ReplicatedStorage:FindFirstChild("Fire") or
                    ReplicatedStorage:FindFirstChild("RemoteEvent")
        if not mainEvent then
            warn("No shooting remote found. Auto shoot disabled.")
            return
        end
    end

    -- Build the shot data (adjust according to your game)
    local shotData = {
        "Shoot",
        {
            { Instance = target, Normal = Vector3.new(0.99, 0.1, -0.02), Position = target.Position },
            { Instance = target, Normal = Vector3.new(0.99, 0.1, -0.02), Position = target.Position },
            { Instance = target, Normal = Vector3.new(0.99, 0.1, -0.02), Position = target.Position },
            { Instance = target, Normal = Vector3.new(0.99, 0.1, -0.02), Position = target.Position },
            { Instance = target, Normal = Vector3.new(0.99, 0.1, -0.02), Position = target.Position }
        },
        {
            { ThePart = target, TheOffset = CFrame.new() },
            { ThePart = target, TheOffset = CFrame.new() },
            { ThePart = target, TheOffset = CFrame.new() },
            { ThePart = target, TheOffset = CFrame.new() },
            { ThePart = target, TheOffset = CFrame.new() }
        },
        RootPart.Position,
        RootPart.Position,
        workspace:GetServerTimeNow()
    }

    -- Fire with pcall to catch errors
    local success, err = pcall(function()
        mainEvent:FireServer(unpack(shotData))
    end)
    if not success then
        warn("Failed to fire shot: " .. tostring(err))
    end
end

-- Auto shoot loop (throttled to every 2 Heartbeat steps)
local shootCounter = 0
RunService.Heartbeat:Connect(function()
    shootCounter = shootCounter + 1
    if shootCounter % 2 == 0 then
        FireShot()
    end
end)

-- ═════════════════════════════════════════════════════════════════
-- ALL OTHER FEATURES (Fly, Speed, NoClip, TP, etc.) – same as before
-- ═════════════════════════════════════════════════════════════════
-- (I'm omitting them here for brevity, but they are identical to the previous version.
--  They should be placed after this point.)
-- [[ ... paste your ESP, Fly, Speed, NoClip, TP, and character respawn code here ... ]]
-- ═════════════════════════════════════════════════════════════════

print("✓ Silent Aim + Auto Shoot loaded with error handling.")
print("✓ If auto shoot doesn't work, check the remote event name and adjust it.")
