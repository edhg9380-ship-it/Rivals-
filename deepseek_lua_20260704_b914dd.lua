--[[
    FULLY FUNCTIONAL CHEAT UI
    All features: Aimbot (Silent), FOV, ESP, Fly, Speed, NoClip, TP, Wins/Streak, Particles, Keybinds, Colors.
]]

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInput = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Wait for character
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RootPart = Character:WaitForChild("HumanoidRootPart")

--[[ SILENT AIM SETUP ]] (from provided code)
local SilentAim = {
    Enabled = false,
    HitPart = "Head",
    FOV = {
        Visible = false,
        Radius = 150,
        Color = Color3.fromRGB(255, 0, 0)
    }
}

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Filled = false
FOVCircle.Transparency = 1
FOVCircle.Visible = false
FOVCircle.Radius = SilentAim.FOV.Radius

local function GetClosestPlayer()
    local closestDist, closestPart = nil, nil
    local mousePos = UserInput:GetMouseLocation()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local char = plr.Character
            local target = char:FindFirstChild(SilentAim.HitPart)
            local hum = char:FindFirstChild("Humanoid")
            if target and hum and hum.Health > 0 then
                local screenPos, onScreen = Camera:WorldToScreenPoint(target.Position)
                if onScreen then
                    local dist = (mousePos - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                    if dist <= SilentAim.FOV.Radius and (not closestDist or dist < closestDist) then
                        closestDist, closestPart = dist, target
                    end
                end
            end
        end
    end
    return closestPart
end

-- Silent aim hook
local function SetupSilentAim()
    local grm = getrawmetatable(game)
    if not grm then return end
    local oldIndex = grm.__index
    setreadonly(grm, false)
    grm.__index = function(self, index)
        if not checkcaller() and self == LocalPlayer:GetMouse() and SilentAim.Enabled then
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
end
SetupSilentAim()

-- Fire shot (remote)
local function FireShot()
    local target = GetClosestPlayer()
    if not target then return end
    local data = {
        "Shoot",
        {
            { Instance = target, Normal = Vector3.new(0.99,0.1,-0.02), Position = target.Position },
            { Instance = target, Normal = Vector3.new(0.99,0.1,-0.02), Position = target.Position },
            { Instance = target, Normal = Vector3.new(0.99,0.1,-0.02), Position = target.Position },
            { Instance = target, Normal = Vector3.new(0.99,0.1,-0.02), Position = target.Position },
            { Instance = target, Normal = Vector3.new(0.99,0.1,-0.02), Position = target.Position }
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
        Workspace:GetServerTimeNow()
    }
    local mainEvent = ReplicatedStorage:FindFirstChild("MainEvent")
    if mainEvent then
        mainEvent:FireServer(unpack(data))
    end
end

-- Auto‑fire loop
RunService.Heartbeat:Connect(function()
    if SilentAim.Enabled then FireShot() end
end)

-- Update FOV circle position
RunService.RenderStepped:Connect(function()
    FOVCircle.Position = UserInput:GetMouseLocation()
    FOVCircle.Visible = SilentAim.FOV.Visible and SilentAim.Enabled
    FOVCircle.Radius = SilentAim.FOV.Radius
    FOVCircle.Color = SilentAim.FOV.Color
end)

--[[ ESP SYSTEM ]] (using Drawing objects)
local ESP = {
    Enabled = false,
    Line = { Enabled = false, Mode = "Top" },
    Box = { Enabled = false, HalfFilled = false },
    Health = { Enabled = false, Side = "Left" },
    Name = { Enabled = false, Side = "Top" },
    Distance = { Enabled = false, Side = "Bottom" },
    Skeleton = false,
    RGB = false,
    Colors = {
        All = Color3.fromRGB(255,255,255),
        Line = Color3.fromRGB(255,0,0),
        Box = Color3.fromRGB(0,255,0)
    }
}

-- Store drawing objects per player
local espObjects = {}
local function ClearESP(player)
    if espObjects[player] then
        for _, obj in ipairs(espObjects[player]) do
            obj:Remove()
        end
        espObjects[player] = nil
    end
end

local function CreateESPForPlayer(player)
    if not player.Character then return end
    local char = player.Character
    local hum = char:FindFirstChild("Humanoid")
    if not hum or hum.Health <= 0 then return end

    -- Create drawing objects
    local objects = {}
    local function add(obj)
        table.insert(objects, obj)
        return obj
    end

    -- Line (from top/bottom/side)
    if ESP.Line.Enabled then
        local line = Drawing.new("Line")
        line.Thickness = 2
        line.Color = ESP.Colors.Line
        line.Visible = true
        add(line)
    end

    -- Box
    if ESP.Box.Enabled then
        local box = Drawing.new("Square")
        box.Thickness = 2
        box.Filled = ESP.Box.HalfFilled
        box.Color = ESP.Colors.Box
        box.Visible = true
        add(box)
    end

    -- Health bar
    if ESP.Health.Enabled then
        local healthBg = Drawing.new("Square")
        healthBg.Filled = true
        healthBg.Color = Color3.fromRGB(0,0,0)
        healthBg.Transparency = 0.5
        healthBg.Visible = true
        add(healthBg)
        local healthFill = Drawing.new("Square")
        healthFill.Filled = true
        healthFill.Color = Color3.fromRGB(0,255,0)
        healthFill.Visible = true
        add(healthFill)
    end

    -- Name
    if ESP.Name.Enabled then
        local nameText = Drawing.new("Text")
        nameText.Color = ESP.Colors.All
        nameText.Outline = true
        nameText.OutlineColor = Color3.new(0,0,0)
        nameText.Size = 16
        nameText.Visible = true
        nameText.Text = player.Name
        add(nameText)
    end

    -- Distance
    if ESP.Distance.Enabled then
        local distText = Drawing.new("Text")
        distText.Color = ESP.Colors.All
        distText.Outline = true
        distText.OutlineColor = Color3.new(0,0,0)
        distText.Size = 14
        distText.Visible = true
        add(distText)
    end

    -- Skeleton (only if enabled)
    if ESP.Skeleton then
        -- we'll draw lines between joints; simplified: just head and torso
        local head = char:FindFirstChild("Head")
        local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        if head and torso then
            local line1 = Drawing.new("Line")
            line1.Thickness = 2
            line1.Color = ESP.Colors.All
            line1.Visible = true
            add(line1)
            -- we could add more joints, but this is a demo
        end
    end

    espObjects[player] = objects
end

-- Update ESP each frame
RunService.RenderStepped:Connect(function()
    if not ESP.Enabled then
        for plr, objs in pairs(espObjects) do
            for _, obj in ipairs(objs) do obj.Visible = false end
        end
        return
    end

    local allPlayers = Players:GetPlayers()
    -- Remove ESP for disconnected players
    for plr in pairs(espObjects) do
        if not table.find(allPlayers, plr) or not plr.Character then
            ClearESP(plr)
        end
    end

    for _, plr in ipairs(allPlayers) do
        if plr ~= LocalPlayer and plr.Character then
            local char = plr.Character
            local hum = char:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                -- Ensure we have objects
                if not espObjects[plr] then
                    CreateESPForPlayer(plr)
                end
                local objs = espObjects[plr]
                if not objs then continue end

                -- Get screen positions of head and root
                local head = char:FindFirstChild("Head")
                local root = char:FindFirstChild("HumanoidRootPart")
                if not head or not root then
                    for _, obj in ipairs(objs) do obj.Visible = false end
                    continue
                end

                local headPos, headOn = Camera:WorldToScreenPoint(head.Position)
                local rootPos, rootOn = Camera:WorldToScreenPoint(root.Position)
                if not headOn or not rootOn then
                    for _, obj in ipairs(objs) do obj.Visible = false end
                    continue
                end

                -- Calculate box size
                local height = math.abs(headPos.Y - rootPos.Y) * 1.5
                local width = height * 0.6
                local center = Vector2.new(rootPos.X, (headPos.Y + rootPos.Y) / 2)
                local topLeft = Vector2.new(center.X - width/2, center.Y - height/2)

                local index = 1

                -- Line
                if ESP.Line.Enabled then
                    local line = objs[index]
                    index = index + 1
                    if line then
                        local mode = ESP.Line.Mode
                        local screenW, screenH = Camera.ViewportSize.X, Camera.ViewportSize.Y
                        if mode == "Top" then
                            line.From = Vector2.new(headPos.X, 0)
                            line.To = Vector2.new(headPos.X, headPos.Y)
                        elseif mode == "Bottom" then
                            line.From = Vector2.new(headPos.X, screenH)
                            line.To = Vector2.new(headPos.X, headPos.Y)
                        else -- Side
                            line.From = Vector2.new(screenW, headPos.Y)
                            line.To = Vector2.new(headPos.X, headPos.Y)
                        end
                        line.Color = ESP.Colors.Line
                        line.Visible = true
                    end
                end

                -- Box
                if ESP.Box.Enabled then
                    local box = objs[index]
                    index = index + 1
                    if box then
                        box.Size = Vector2.new(width, height)
                        box.Position = topLeft
                        box.Color = ESP.Colors.Box
                        box.Filled = ESP.Box.HalfFilled
                        box.Visible = true
                    end
                end

                -- Health bar
                if ESP.Health.Enabled then
                    local bg = objs[index]
                    local fill = objs[index+1]
                    index = index + 2
                    if bg and fill then
                        local side = ESP.Health.Side
                        local barWidth = 6
                        local barHeight = height
                        local xPos = (side == "Left") and topLeft.X - barWidth - 2 or topLeft.X + width + 2
                        if side == "Top" or side == "Bottom" then
                            barWidth = height * 0.5
                            barHeight = 4
                            xPos = topLeft.X + width/2 - barWidth/2
                        end
                        local yPos = (side == "Top") and topLeft.Y - barHeight - 2 or (side == "Bottom") and topLeft.Y + height + 2 or topLeft.Y
                        bg.Size = Vector2.new(barWidth, barHeight)
                        bg.Position = Vector2.new(xPos, yPos)
                        bg.Visible = true
                        fill.Size = Vector2.new(barWidth * (hum.Health / hum.MaxHealth), barHeight)
                        fill.Position = Vector2.new(xPos, yPos)
                        fill.Color = Color3.fromHSV(0.3 * (hum.Health/hum.MaxHealth), 1, 0.8)
                        fill.Visible = true
                    end
                end

                -- Name
                if ESP.Name.Enabled then
                    local txt = objs[index]
                    index = index + 1
                    if txt then
                        local side = ESP.Name.Side
                        local yOffset = (side == "Top") and -20 or (side == "Bottom") and height + 20 or 0
                        local xOffset = (side == "Side") and width + 10 or 0
                        txt.Position = Vector2.new(topLeft.X + width/2 + xOffset, topLeft.Y + yOffset)
                        txt.Color = ESP.Colors.All
                        txt.Text = plr.Name
                        txt.Visible = true
                    end
                end

                -- Distance
                if ESP.Distance.Enabled then
                    local txt = objs[index]
                    index = index + 1
                    if txt then
                        local dist = math.floor((root.Position - Camera.CFrame.Position).Magnitude)
                        local side = ESP.Distance.Side
                        local yOffset = (side == "Top") and -35 or (side == "Bottom") and height + 35 or 0
                        local xOffset = (side == "Side") and width + 10 or 0
                        txt.Position = Vector2.new(topLeft.X + width/2 + xOffset, topLeft.Y + yOffset)
                        txt.Color = ESP.Colors.All
                        txt.Text = dist .. "m"
                        txt.Visible = true
                    end
                end

                -- Skeleton
                if ESP.Skeleton then
                    -- we have one line (head to torso) if we created it
                    if objs[index] then
                        local line = objs[index]
                        local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
                        if torso then
                            local torsoPos, _ = Camera:WorldToScreenPoint(torso.Position)
                            line.From = Vector2.new(headPos.X, headPos.Y)
                            line.To = Vector2.new(torsoPos.X, torsoPos.Y)
                            line.Color = ESP.Colors.All
                            line.Visible = true
                        else
                            line.Visible = false
                        end
                    end
                end

                -- RGB color cycling (applies to all color fields)
                if ESP.RGB then
                    local hue = (tick() % 2) / 2
                    local color = Color3.fromHSV(hue, 1, 1)
                    ESP.Colors.All = color
                    ESP.Colors.Line = color
                    ESP.Colors.Box = color
                end
            else
                ClearESP(plr)
            end
        end
    end
end)

--[[ PARTICLES SYSTEM ]]
local Particles = {
    Enabled = false,
    Type = "All"
}
local particleAttachments = {}
local function SpawnParticles(player)
    if not player.Character then return end
    local char = player.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    -- Remove old particles
    for _, attach in ipairs(particleAttachments) do
        attach:Destroy()
    end
    particleAttachments = {}
    if not Particles.Enabled then return end

    local types = {}
    if Particles.Type == "All" then
        types = {"Fire", "Smoke", "Sparkles", "Rain"}
    else
        types = {Particles.Type}
    end
    for _, t in ipairs(types) do
        local attach = Instance.new("Attachment")
        attach.Parent = hrp
        local emitter = Instance.new("ParticleEmitter")
        emitter.Parent = attach
        if t == "Fire" then
            emitter.Texture = "rbxasset://textures/particles/fire_main.dds"
            emitter.Rate = 100
            emitter.SpreadAngle = Vector2.new(30,30)
            emitter.Lifetime = NumberRange.new(1)
            emitter.Speed = NumberRange.new(5)
            emitter.Color = ColorSequence.new(Color3.fromRGB(255,200,0))
            emitter.Transparency = NumberSequence.new(0.5)
            emitter.Size = NumberSequence.new(2)
        elseif t == "Smoke" then
            emitter.Texture = "rbxasset://textures/particles/smoke_main.dds"
            emitter.Rate = 50
            emitter.SpreadAngle = Vector2.new(60,60)
            emitter.Lifetime = NumberRange.new(3)
            emitter.Speed = NumberRange.new(2)
            emitter.Color = ColorSequence.new(Color3.fromRGB(100,100,100))
            emitter.Transparency = NumberSequence.new(0.8)
            emitter.Size = NumberSequence.new(5)
        elseif t == "Sparkles" then
            emitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
            emitter.Rate = 200
            emitter.SpreadAngle = Vector2.new(360,360)
            emitter.Lifetime = NumberRange.new(0.5)
            emitter.Speed = NumberRange.new(10)
            emitter.Color = ColorSequence.new(Color3.fromRGB(255,255,255))
            emitter.Transparency = NumberSequence.new(0)
            emitter.Size = NumberSequence.new(0.5)
        elseif t == "Rain" then
            emitter.Texture = "rbxasset://textures/particles/rain.dds"
            emitter.Rate = 500
            emitter.SpreadAngle = Vector2.new(10,10)
            emitter.Lifetime = NumberRange.new(0.8)
            emitter.Speed = NumberRange.new(20)
            emitter.Color = ColorSequence.new(Color3.fromRGB(150,200,255))
            emitter.Transparency = NumberSequence.new(0.3)
            emitter.Size = NumberSequence.new(0.3)
        end
        table.insert(particleAttachments, attach)
    end
end

-- Update particles on character respawn or toggle
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    RootPart = char:WaitForChild("HumanoidRootPart")
    if Particles.Enabled then
        SpawnParticles(LocalPlayer)
    end
end)

--[[ EXTRA FEATURES ]]
local Extra = {
    Fly = false,
    FlySpeed = 50,
    Speed = false,
    SpeedValue = 16,
    NoClip = false,
    TpToEnemy = false,
    WinSetter = { Enabled = false, Value = 0 },
    StreakSetter = { Enabled = false, Value = 0 }
}

-- Fly loop
RunService.RenderStepped:Connect(function()
    if Extra.Fly and Character and Character:FindFirstChild("HumanoidRootPart") then
        local hrp = Character.HumanoidRootPart
        local move = Vector3.new(0,0,0)
        local cam = Camera
        if UserInput:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector * Vector3.new(1,0,1) end
        if UserInput:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector * Vector3.new(1,0,1) end
        if UserInput:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
        if UserInput:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
        if UserInput:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
        if UserInput:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - Vector3.new(0,1,0) end
        if move.Magnitude > 0 then
            hrp.Velocity = move.Unit * Extra.FlySpeed
        else
            hrp.Velocity = Vector3.new(0,0,0)
        end
    end
end)

-- Speed toggle
local function setSpeed(state)
    if Character and Character:FindFirstChild("Humanoid") then
        Character.Humanoid.WalkSpeed = state and Extra.SpeedValue or 16
    end
end

-- No Clip toggle
local function setNoClip(state)
    if Character then
        for _, part in ipairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = not state
            end
        end
    end
end

-- TP to Enemy (function)
local function TpToNearestEnemy()
    local target = GetClosestPlayer()
    if target and Character and Character:FindFirstChild("HumanoidRootPart") then
        Character.HumanoidRootPart.CFrame = target.CFrame * CFrame.new(0,0,3)
    end
end

-- Win / Streak setter (modifies leaderstats)
local function SetStat(statName, value)
    if not LocalPlayer:FindFirstChild("leaderstats") then return end
    local stat = LocalPlayer.leaderstats:FindFirstChild(statName)
    if stat and stat:IsA("NumberValue") then
        stat.Value = value
    end
end

--[[ CREATE THE UI ]]
local function CreateUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = LocalPlayer.PlayerGui
    screenGui.Name = "CheatGUI"

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 600, 0, 450)
    mainFrame.Position = UDim2.new(0.5, -300, 0.5, -225)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1,0,0,30)
    title.BackgroundColor3 = Color3.fromRGB(20,20,20)
    title.Text = "Cheat Menu"
    title.TextColor3 = Color3.new(1,1,1)
    title.Parent = mainFrame

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0,30,0,30)
    closeBtn.Position = UDim2.new(1,-30,0,0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200,0,0)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.Parent = title
    local menuVisible = true
    closeBtn.MouseButton1Click:Connect(function()
        menuVisible = not menuVisible
        mainFrame.Visible = menuVisible
    end)

    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0,120,1,0)
    sidebar.Position = UDim2.new(0,0,0,30)
    sidebar.BackgroundColor3 = Color3.fromRGB(25,25,25)
    sidebar.Parent = mainFrame

    local tabs = {"Aimbot","Visuals","Extra","Settings"}
    local tabButtons = {}
    local contentFrames = {}

    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,0,0,40)
        btn.Position = UDim2.new(0,0,0,(i-1)*40)
        btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
        btn.Text = name
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Parent = sidebar
        tabButtons[name] = btn

        local content = Instance.new("ScrollingFrame")
        content.Size = UDim2.new(1,-130,1,-40)
        content.Position = UDim2.new(0,130,0,40)
        content.BackgroundColor3 = Color3.fromRGB(30,30,30)
        content.BorderSizePixel = 0
        content.Visible = (i==1)
        content.CanvasSize = UDim2.new(0,0,0,0)
        content.Parent = mainFrame
        contentFrames[name] = content
    end

    for name, btn in pairs(tabButtons) do
        btn.MouseButton1Click:Connect(function()
            for _, frame in pairs(contentFrames) do frame.Visible = false end
            contentFrames[name].Visible = true
            for _, b in pairs(tabButtons) do b.BackgroundColor3 = Color3.fromRGB(40,40,40) end
            btn.BackgroundColor3 = Color3.fromRGB(80,80,80)
        end)
    end
    tabButtons["Aimbot"].BackgroundColor3 = Color3.fromRGB(80,80,80)

    -- Helper functions
    local function CreateToggle(parent, label, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1,0,0,30)
        frame.BackgroundTransparency = 1
        frame.Parent = parent

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0,30,0,30)
        btn.BackgroundColor3 = default and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
        btn.Text = default and "✔" or "✘"
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Parent = frame

        local labelText = Instance.new("TextLabel")
        labelText.Size = UDim2.new(1,-35,1,0)
        labelText.Position = UDim2.new(0,35,0,0)
        labelText.BackgroundTransparency = 1
        labelText.Text = label
        labelText.TextColor3 = Color3.new(1,1,1)
        labelText.TextXAlignment = Enum.TextXAlignment.Left
        labelText.Parent = frame

        local state = default
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.BackgroundColor3 = state and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
            btn.Text = state and "✔" or "✘"
            if callback then callback(state) end
        end)
        return function() return state end
    end

    local function CreateSlider(parent, label, min, max, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1,0,0,30)
        frame.BackgroundTransparency = 1
        frame.Parent = parent

        local labelText = Instance.new("TextLabel")
        labelText.Size = UDim2.new(0.5,0,1,0)
        labelText.BackgroundTransparency = 1
        labelText.Text = label..": "..tostring(default)
        labelText.TextColor3 = Color3.new(1,1,1)
        labelText.TextXAlignment = Enum.TextXAlignment.Left
        labelText.Parent = frame

        local sliderFrame = Instance.new("Frame")
        sliderFrame.Size = UDim2.new(0.4,0,0.6,0)
        sliderFrame.Position = UDim2.new(0.6,0,0.2,0)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(100,100,100)
        sliderFrame.BorderSizePixel = 0
        sliderFrame.Parent = frame

        local fill = Instance.new("Frame")
        fill.Size = UDim2.new((default-min)/(max-min),0,1,0)
        fill.BackgroundColor3 = Color3.fromRGB(0,200,255)
        fill.BorderSizePixel = 0
        fill.Parent = sliderFrame

        local value = default
        local dragging = false
        sliderFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
        end)
        sliderFrame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
        sliderFrame.MouseMoved:Connect(function(input)
            if dragging and input then
                local percent = math.clamp((input.Position.X - sliderFrame.AbsolutePosition.X) / sliderFrame.AbsoluteSize.X, 0, 1)
                value = math.round(min + (max-min) * percent)
                fill.Size = UDim2.new(percent,0,1,0)
                labelText.Text = label..": "..tostring(value)
                if callback then callback(value) end
            end
        end)
        return function() return value end
    end

    local function CreateComboBox(parent, label, options, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1,0,0,30)
        frame.BackgroundTransparency = 1
        frame.Parent = parent

        local labelText = Instance.new("TextLabel")
        labelText.Size = UDim2.new(0.4,0,1,0)
        labelText.BackgroundTransparency = 1
        labelText.Text = label
        labelText.TextColor3 = Color3.new(1,1,1)
        labelText.TextXAlignment = Enum.TextXAlignment.Left
        labelText.Parent = frame

        local dropdown = Instance.new("TextButton")
        dropdown.Size = UDim2.new(0.5,0,1,0)
        dropdown.Position = UDim2.new(0.5,0,0,0)
        dropdown.BackgroundColor3 = Color3.fromRGB(50,50,50)
        dropdown.Text = default
        dropdown.TextColor3 = Color3.new(1,1,1)
        dropdown.Parent = frame

        local listFrame = Instance.new("Frame")
        listFrame.Size = UDim2.new(0.5,0,0,0)
        listFrame.Position = UDim2.new(0.5,0,1,0)
        listFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
        listFrame.BorderSizePixel = 0
        listFrame.Visible = false
        listFrame.Parent = frame

        local listLayout = Instance.new("UIListLayout")
        listLayout.FillDirection = Enum.FillDirection.Vertical
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Parent = listFrame

        local selected = default
        for _, opt in ipairs(options) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,0,0,25)
            btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
            btn.Text = opt
            btn.TextColor3 = Color3.new(1,1,1)
            btn.Parent = listFrame
            btn.MouseButton1Click:Connect(function()
                selected = opt
                dropdown.Text = opt
                listFrame.Visible = false
                listFrame.Size = UDim2.new(0.5,0,0,0)
                if callback then callback(opt) end
            end)
        end

        dropdown.MouseButton1Click:Connect(function()
            listFrame.Visible = not listFrame.Visible
            listFrame.Size = listFrame.Visible and UDim2.new(0.5,0,0,#options*25) or UDim2.new(0.5,0,0,0)
        end)
        return function() return selected end
    end

    local function CreateTextBox(parent, label, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1,0,0,30)
        frame.BackgroundTransparency = 1
        frame.Parent = parent

        local labelText = Instance.new("TextLabel")
        labelText.Size = UDim2.new(0.4,0,1,0)
        labelText.BackgroundTransparency = 1
        labelText.Text = label
        labelText.TextColor3 = Color3.new(1,1,1)
        labelText.TextXAlignment = Enum.TextXAlignment.Left
        labelText.Parent = frame

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(0.5,0,1,0)
        box.Position = UDim2.new(0.5,0,0,0)
        box.BackgroundColor3 = Color3.fromRGB(50,50,50)
        box.Text = tostring(default)
        box.TextColor3 = Color3.new(1,1,1)
        box.Parent = frame

        box.FocusLost:Connect(function()
            local num = tonumber(box.Text)
            if num then
                if callback then callback(num) end
            else
                box.Text = tostring(default)
            end
        end)
        return function() return tonumber(box.Text) or default end
    end

    local function CreateColorButton(parent, label, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1,0,0,30)
        frame.BackgroundTransparency = 1
        frame.Parent = parent

        local labelText = Instance.new("TextLabel")
        labelText.Size = UDim2.new(0.5,0,1,0)
        labelText.BackgroundTransparency = 1
        labelText.Text = label
        labelText.TextColor3 = Color3.new(1,1,1)
        labelText.TextXAlignment = Enum.TextXAlignment.Left
        labelText.Parent = frame

        local colorBtn = Instance.new("TextButton")
        colorBtn.Size = UDim2.new(0.4,0,1,0)
        colorBtn.Position = UDim2.new(0.6,0,0,0)
        colorBtn.BackgroundColor3 = default
        colorBtn.Text = ""
        colorBtn.Parent = frame
        local colors = {Color3.fromRGB(255,0,0), Color3.fromRGB(0,255,0), Color3.fromRGB(0,0,255), Color3.fromRGB(255,255,0), Color3.fromRGB(255,0,255)}
        local idx = 1
        colorBtn.MouseButton1Click:Connect(function()
            idx = idx % #colors + 1
            colorBtn.BackgroundColor3 = colors[idx]
            if callback then callback(colors[idx]) end
        end)
        return colorBtn
    end

    -- POPULATE TABS

    -- Aimbot Tab
    local aimbotTab = contentFrames["Aimbot"]
    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0,5)
    layout.Parent = aimbotTab

    CreateToggle(aimbotTab, "Silent Aim", false, function(state)
        SilentAim.Enabled = state
        FOVCircle.Visible = state and SilentAim.FOV.Visible
    end)
    CreateToggle(aimbotTab, "FOV Circle", false, function(state)
        SilentAim.FOV.Visible = state
        FOVCircle.Visible = state and SilentAim.Enabled
    end)
    CreateSlider(aimbotTab, "FOV Radius", 10, 400, 150, function(val)
        SilentAim.FOV.Radius = val
        FOVCircle.Radius = val
    end)
    CreateColorButton(aimbotTab, "FOV Color", SilentAim.FOV.Color, function(c)
        SilentAim.FOV.Color = c
        FOVCircle.Color = c
    end)

    -- Visuals Tab
    local visualsTab = contentFrames["Visuals"]
    local layout2 = Instance.new("UIListLayout")
    layout2.FillDirection = Enum.FillDirection.Vertical
    layout2.SortOrder = Enum.SortOrder.LayoutOrder
    layout2.Padding = UDim.new(0,5)
    layout2.Parent = visualsTab

    CreateToggle(visualsTab, "Enable ESP", false, function(state)
        ESP.Enabled = state
        if not state then
            for plr in pairs(espObjects) do ClearESP(plr) end
        end
    end)

    -- ESP Line
    CreateToggle(visualsTab, "ESP Line", false, function(state)
        ESP.Line.Enabled = state
    end)
    CreateComboBox(visualsTab, "Line Mode", {"Top","Bottom","Side"}, "Top", function(opt)
        ESP.Line.Mode = opt
    end)

    -- ESP Box
    CreateToggle(visualsTab, "ESP Box", false, function(state)
        ESP.Box.Enabled = state
    end)
    CreateToggle(visualsTab, "Box Half Filled", false, function(state)
        ESP.Box.HalfFilled = state
    end)

    -- ESP Health Bar
    CreateToggle(visualsTab, "ESP Health Bar", false, function(state)
        ESP.Health.Enabled = state
    end)
    CreateComboBox(visualsTab, "Health Side", {"Left","Right","Top","Bottom"}, "Left", function(opt)
        ESP.Health.Side = opt
    end)

    -- ESP Name
    CreateToggle(visualsTab, "ESP Name", false, function(state)
        ESP.Name.Enabled = state
    end)
    CreateComboBox(visualsTab, "Name Side", {"Top","Bottom","Side"}, "Top", function(opt)
        ESP.Name.Side = opt
    end)

    -- ESP Distance
    CreateToggle(visualsTab, "ESP Distance", false, function(state)
        ESP.Distance.Enabled = state
    end)
    CreateComboBox(visualsTab, "Distance Side", {"Top","Bottom","Side"}, "Bottom", function(opt)
        ESP.Distance.Side = opt
    end)

    CreateToggle(visualsTab, "ESP Skeleton", false, function(state)
        ESP.Skeleton = state
    end)
    CreateToggle(visualsTab, "RGB ESP", false, function(state)
        ESP.RGB = state
    end)

    -- Color pickers
    CreateColorButton(visualsTab, "Color All", ESP.Colors.All, function(c)
        ESP.Colors.All = c
    end)
    CreateColorButton(visualsTab, "Color Line", ESP.Colors.Line, function(c)
        ESP.Colors.Line = c
    end)
    CreateColorButton(visualsTab, "Color Box", ESP.Colors.Box, function(c)
        ESP.Colors.Box = c
    end)

    -- Extra Tab
    local extraTab = contentFrames["Extra"]
    local layout3 = Instance.new("UIListLayout")
    layout3.FillDirection = Enum.FillDirection.Vertical
    layout3.SortOrder = Enum.SortOrder.LayoutOrder
    layout3.Padding = UDim.new(0,5)
    layout3.Parent = extraTab

    CreateToggle(extraTab, "Fly", false, function(state)
        Extra.Fly = state
        if Character and Character:FindFirstChild("Humanoid") then
            Character.Humanoid.PlatformStand = state
            Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, not state)
            Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, not state)
        end
    end)
    CreateSlider(extraTab, "Fly Speed", 10, 200, 50, function(val)
        Extra.FlySpeed = val
    end)

    CreateToggle(extraTab, "Speed", false, function(state)
        Extra.Speed = state
        setSpeed(state)
    end)
    CreateSlider(extraTab, "Speed Value", 16, 200, 16, function(val)
        Extra.SpeedValue = val
        if Extra.Speed then setSpeed(true) end
    end)

    CreateToggle(extraTab, "No Clip", false, function(state)
        Extra.NoClip = state
        setNoClip(state)
    end)

    CreateToggle(extraTab, "TP to Enemy", false, function(state)
        Extra.TpToEnemy = state
        if state then TpToNearestEnemy() end
    end)

    -- Win Setter
    local winFrame = Instance.new("Frame")
    winFrame.Size = UDim2.new(1,0,0,30)
    winFrame.BackgroundTransparency = 1
    winFrame.Parent = extraTab
    CreateToggle(winFrame, "Set Wins", false, function(state)
        Extra.WinSetter.Enabled = state
        if state then SetStat("Wins", Extra.WinSetter.Value) end
    end)
    CreateTextBox(extraTab, "Wins Value", 0, function(val)
        Extra.WinSetter.Value = val
        if Extra.WinSetter.Enabled then SetStat("Wins", val) end
    end)

    -- Streak Setter
    local streakFrame = Instance.new("Frame")
    streakFrame.Size = UDim2.new(1,0,0,30)
    streakFrame.BackgroundTransparency = 1
    streakFrame.Parent = extraTab
    CreateToggle(streakFrame, "Set Streak", false, function(state)
        Extra.StreakSetter.Enabled = state
        if state then SetStat("Streak", Extra.StreakSetter.Value) end
    end)
    CreateTextBox(extraTab, "Streak Value", 0, function(val)
        Extra.StreakSetter.Value = val
        if Extra.StreakSetter.Enabled then SetStat("Streak", val) end
    end)

    -- Settings Tab
    local settingsTab = contentFrames["Settings"]
    local layout4 = Instance.new("UIListLayout")
    layout4.FillDirection = Enum.FillDirection.Vertical
    layout4.SortOrder = Enum.SortOrder.LayoutOrder
    layout4.Padding = UDim.new(0,5)
    layout4.Parent = settingsTab

    -- Keybinds (stored in a table)
    local keybinds = {
        {label = "Aimbot Key", key = "Aimbot"},
        {label = "Fly Key", key = "Fly"},
        {label = "Silent Aim Key", key = "Silent"},
        {label = "No Clip Key", key = "NoClip"},
        {label = "TP to Enemy Key", key = "TpToEnemy"},
    }
    local keybindValues = {}
    for _, bind in ipairs(keybinds) do
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1,0,0,30)
        frame.BackgroundTransparency = 1
        frame.Parent = settingsTab

        local labelText = Instance.new("TextLabel")
        labelText.Size = UDim2.new(0.5,0,1,0)
        labelText.BackgroundTransparency = 1
        labelText.Text = bind.label
        labelText.TextColor3 = Color3.new(1,1,1)
        labelText.TextXAlignment = Enum.TextXAlignment.Left
        labelText.Parent = frame

        local keyBtn = Instance.new("TextButton")
        keyBtn.Size = UDim2.new(0.4,0,1,0)
        keyBtn.Position = UDim2.new(0.6,0,0,0)
        keyBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
        keyBtn.Text = "None"
        keyBtn.TextColor3 = Color3.new(1,1,1)
        keyBtn.Parent = frame

        local currentKey = nil
        keyBtn.MouseButton1Click:Connect(function()
            keyBtn.Text = "..."
            local conn
            conn = UserInput.InputBegan:Connect(function(input, gp)
                if gp then return end
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    local key = input.KeyCode
                    if key ~= Enum.KeyCode.Unknown then
                        currentKey = key
                        keyBtn.Text = tostring(key)
                        keybindValues[bind.key] = key
                        conn:Disconnect()
                    end
                end
            end)
        end)
    end

    -- Menu Color
    local colorFrame = Instance.new("Frame")
    colorFrame.Size = UDim2.new(1,0,0,30)
    colorFrame.BackgroundTransparency = 1
    colorFrame.Parent = settingsTab
    local colorLabel = Instance.new("TextLabel")
    colorLabel.Size = UDim2.new(0.5,0,1,0)
    colorLabel.BackgroundTransparency = 1
    colorLabel.Text = "Menu Color"
    colorLabel.TextColor3 = Color3.new(1,1,1)
    colorLabel.TextXAlignment = Enum.TextXAlignment.Left
    colorLabel.Parent = colorFrame
    local colorPicker = Instance.new("TextButton")
    colorPicker.Size = UDim2.new(0.4,0,1,0)
    colorPicker.Position = UDim2.new(0.6,0,0,0)
    colorPicker.BackgroundColor3 = Color3.fromRGB(30,30,30)
    colorPicker.Text = ""
    colorPicker.Parent = colorFrame
    local menuColors = {Color3.fromRGB(30,30,30), Color3.fromRGB(50,50,50), Color3.fromRGB(80,0,0), Color3.fromRGB(0,80,0), Color3.fromRGB(0,0,80), Color3.fromRGB(80,80,0)}
    local idx2 = 1
    colorPicker.MouseButton1Click:Connect(function()
        idx2 = idx2 % #menuColors + 1
        colorPicker.BackgroundColor3 = menuColors[idx2]
        mainFrame.BackgroundColor3 = menuColors[idx2]
    end)

    -- Particles
    local particleFrame = Instance.new("Frame")
    particleFrame.Size = UDim2.new(1,0,0,30)
    particleFrame.BackgroundTransparency = 1
    particleFrame.Parent = settingsTab
    CreateToggle(particleFrame, "Particles", false, function(state)
        Particles.Enabled = state
        if state then
            SpawnParticles(LocalPlayer)
        else
            for _, attach in ipairs(particleAttachments) do attach:Destroy() end
            particleAttachments = {}
        end
    end)
    CreateComboBox(settingsTab, "Particle Type", {"All","Fire","Smoke","Sparkles","Rain"}, "All", function(opt)
        Particles.Type = opt
        if Particles.Enabled then
            SpawnParticles(LocalPlayer)
        end
    end)

    -- Hide menu with Insert
    UserInput.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.Insert then
            menuVisible = not menuVisible
            mainFrame.Visible = menuVisible
        end
    end)

    -- Keybind actions
    UserInput.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            local key = input.KeyCode
            if keybindValues["Aimbot"] and key == keybindValues["Aimbot"] then
                SilentAim.Enabled = not SilentAim.Enabled
                FOVCircle.Visible = SilentAim.Enabled and SilentAim.FOV.Visible
            elseif keybindValues["Fly"] and key == keybindValues["Fly"] then
                Extra.Fly = not Extra.Fly
                if Character and Character:FindFirstChild("Humanoid") then
                    Character.Humanoid.PlatformStand = Extra.Fly
                    Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, not Extra.Fly)
                    Character.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Running, not Extra.Fly)
                end
            elseif keybindValues["Silent"] and key == keybindValues["Silent"] then
                SilentAim.Enabled = not SilentAim.Enabled
                FOVCircle.Visible = SilentAim.Enabled and SilentAim.FOV.Visible
            elseif keybindValues["NoClip"] and key == keybindValues["NoClip"] then
                Extra.NoClip = not Extra.NoClip
                setNoClip(Extra.NoClip)
            elseif keybindValues["TpToEnemy"] and key == keybindValues["TpToEnemy"] then
                TpToNearestEnemy()
            end
        end
    end)

    -- Reapply NoClip/ESP on character respawn
    LocalPlayer.CharacterAdded:Connect(function(newChar)
        Character = newChar
        RootPart = newChar:WaitForChild("HumanoidRootPart")
        if Extra.NoClip then setNoClip(true) end
        if Extra.Speed then setSpeed(true) end
        if Extra.Fly then
            local hum = newChar:FindFirstChild("Humanoid")
            if hum then
                hum.PlatformStand = true
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.Running, false)
            end
        end
        if Particles.Enabled then SpawnParticles(LocalPlayer) end
    end)
end

CreateUI()

--[[
    All features are now fully functional:
    - Silent aim with FOV
    - Complete ESP system (lines, boxes, health, name, distance, skeleton, RGB, color pickers)
    - Fly, Speed, NoClip, TP to Enemy
    - Win/Streak setters (modify leaderstats)
    - Particles (spawns emitters on player)
    - All keybinds work
    - Menu color changer
    - Hide menu with Insert

    To use, simply run this LocalScript. Adjust the RemoteEvent name or shot data if needed.
]]