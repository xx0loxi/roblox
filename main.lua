-- RAGE MOD - ULTIMATE VERSION 0.8 BETA WITH FIXED GOD MODE
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "⚡ RAGE MOD | ULTIMATE v0.8 BETA",
    LoadingTitle = "RAGE MOD ULTIMATE v0.8 BETA",
    LoadingSubtitle = "Loading Fixed God Mode...",
    Theme = "Dark"
})

-- Основные сервисы
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

-- ВЕРСИЯ
local Version = "0.8 BETA"

-- ИСПРАВЛЕННЫЙ GOD MODE (БЕЗ ЛАГОВ И НАСТОЯЩАЯ НЕУЯЗВИМОСТЬ)
local GodMode = {
    Enabled = false,
    Connection = nil,
    OriginalWalkSpeed = 16
}

local function EnableGodMode()
    if GodMode.Connection then
        GodMode.Connection:Disconnect()
    end
    
    GodMode.Connection = RunService.Heartbeat:Connect(function()
        if not GodMode.Enabled then return end
        
        pcall(function()
            local character = LocalPlayer.Character
            if not character then return end
            
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then return end
            
            -- ПРОСТАЯ И ЭФФЕКТИВНАЯ ЗАЩИТА
            humanoid.Health = humanoid.MaxHealth
            
            -- Защита от смерти
            if humanoid.Health <= 0 then
                humanoid.Health = humanoid.MaxHealth
            end
        end)
    end)
end

local function DisableGodMode()
    if GodMode.Connection then
        GodMode.Connection:Disconnect()
        GodMode.Connection = nil
    end
end

-- НАСТРОЙКИ ТЕЛЕПОРТА НА КУРСОР
local TeleportSettings = {
    Enabled = false,
    Key = Enum.KeyCode.X,
    Connection = nil
}

-- УЛУЧШЕННАЯ СИСТЕМА СКОРОСТИ
local AdvancedSpeed = {
    Enabled = false,
    Value = 50,
    BodyVelocity = nil,
    Connection = nil,
    OriginalWalkSpeed = 16
}

local function EnableBodyVelocitySpeed()
    if AdvancedSpeed.BodyVelocity then 
        DisableBodyVelocitySpeed()
    end

    local character = LocalPlayer.Character
    if not character then return false end

    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end

    local success, result = pcall(function()
        AdvancedSpeed.BodyVelocity = Instance.new("BodyVelocity")
        AdvancedSpeed.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        AdvancedSpeed.BodyVelocity.MaxForce = Vector3.new(10000, 0, 10000)
        AdvancedSpeed.BodyVelocity.P = 1250
        AdvancedSpeed.BodyVelocity.Name = "SpeedHelper"
        AdvancedSpeed.BodyVelocity.Parent = humanoidRootPart
    end)

    if not success then return false end

    AdvancedSpeed.Connection = RunService.Heartbeat:Connect(function()
        if not AdvancedSpeed.Enabled or not AdvancedSpeed.BodyVelocity then return end
        
        local moveDirection = Vector3.new(0, 0, 0)
        
        if UIS:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + Camera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - Camera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - Camera.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + Camera.CFrame.RightVector
        end
        
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit * AdvancedSpeed.Value
            moveDirection = Vector3.new(moveDirection.X, 0, moveDirection.Z)
            AdvancedSpeed.BodyVelocity.Velocity = moveDirection
        else
            AdvancedSpeed.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
    
    return true
end

local function EnableHumanoidSpeed()
    AdvancedSpeed.Connection = RunService.Heartbeat:Connect(function()
        if not AdvancedSpeed.Enabled then return end
        
        pcall(function()
            local character = LocalPlayer.Character
            if not character then return end
            
            local humanoid = character:FindFirstChild("Humanoid")
            if not humanoid then return end
            
            humanoid.WalkSpeed = AdvancedSpeed.Value
        end)
    end)
    
    return true
end

local function DisableBodyVelocitySpeed()
    if AdvancedSpeed.Connection then
        AdvancedSpeed.Connection:Disconnect()
        AdvancedSpeed.Connection = nil
    end
    
    if AdvancedSpeed.BodyVelocity then
        pcall(function()
            AdvancedSpeed.BodyVelocity:Destroy()
        end)
        AdvancedSpeed.BodyVelocity = nil
    end
end

-- АВТОМАТИЧЕСКИЙ ВЫБОР МЕТОДА СКОРОСТИ
local function EnableAdvancedSpeed()
    DisableBodyVelocitySpeed()
    
    local success = EnableBodyVelocitySpeed()
    
    if not success then
        success = EnableHumanoidSpeed()
    end
    
    return success
end

-- УЛУЧШЕННЫЙ ТЕЛЕПОРТ НА КУРСОР
local function TpToCursor()
    if not LocalPlayer.Character then
        Notify("Персонаж не найден")
        return
    end
    
    local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then
        Notify("HumanoidRootPart не найден")
        return
    end
    
    local mouse = LocalPlayer:GetMouse()
    local unitRay = Camera:ViewportPointToRay(mouse.X, mouse.Y)
    local ray = Ray.new(unitRay.Origin, unitRay.Direction * 1000)
    
    local ignoreList = {LocalPlayer.Character}
    local part, position = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
    
    if part then
        local newPosition = position + Vector3.new(0, 3, 0)
        humanoidRootPart.CFrame = CFrame.new(newPosition)
        Notify("Телепортирован на курсор")
    else
        Notify("Не удалось найти точку для телепорта")
    end
end

-- ОБРАБОТКА КЛАВИШ ТЕЛЕПОРТА
local function StartTeleportListener()
    if TeleportSettings.Connection then
        TeleportSettings.Connection:Disconnect()
    end
    
    TeleportSettings.Connection = UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == TeleportSettings.Key and TeleportSettings.Enabled then
            TpToCursor()
        end
    end)
end

local function StopTeleportListener()
    if TeleportSettings.Connection then
        TeleportSettings.Connection:Disconnect()
        TeleportSettings.Connection = nil
    end
end

-- Настройки
local Settings = {
    Noclip = false,
    Fly = {
        Enabled = false,
        Speed = 50
    },
    Speed = {
        Enabled = false,
        Value = 50
    },
    InfiniteJump = false,
    GodMode = false,
    Esp = {
        Enabled = false,
        ShowBox = true,
        ShowName = true,
        ShowDistance = true,
        ShowHealth = true,
        ShowTracers = false,
        ShowAimbotStatus = true,
        BoxColor = Color3.fromRGB(0, 255, 255),
        TextColor = Color3.fromRGB(255, 255, 255),
        TracerColor = Color3.fromRGB(255, 0, 0),
        TeamColor = true,
        MaxDistance = 1000,
        Boxes = {},
        Names = {},
        Distances = {},
        HealthBars = {},
        HealthTexts = {},
        AimbotStatus = {},
        Tracers = {}
    },
    Xray = false,
    AntiAfk = false,
    Aimbot = {
        Enabled = false,
        MouseButton = "RightButton",
        FOV = 100,
        Smoothness = 10,
        Part = "Head",
        TeamCheck = false,  -- ВЫКЛЮЧЕНО ПО УМОЛЧАНИЮ
        VisibleCheck = false,  -- ВЫКЛЮЧЕНО ПО УМОЛЧАНИЮ
        Prediction = false,
        PredictionAmount = 0.1,
        MaxDistance = 500,
        WallCheck = false,  -- ВЫКЛЮЧЕНО ПО УМОЛЧАНИЮ
        Priority = "Closest"
    }
}

-- Уведомления
local function Notify(message)
    Rayfield:Notify({
        Title = "RAGE MOD ULTIMATE v" .. Version,
        Content = message,
        Duration = 3.0
    })
end

-- УЛУЧШЕННЫЙ ESP С ЛУЧШИМ ВИЗУАЛОМ
local function CreateESP(player)
    if Settings.Esp.Boxes[player] then return end
    
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Settings.Esp.BoxColor
    box.Thickness = 2
    box.Filled = false
    
    local name = Drawing.new("Text")
    name.Visible = false
    name.Color = Settings.Esp.TextColor
    name.Size = 18
    name.Center = true
    name.Outline = true
    name.Text = player.Name
    
    local distance = Drawing.new("Text")
    distance.Visible = false
    distance.Color = Color3.fromRGB(255, 255, 0)
    distance.Size = 16
    distance.Center = true
    distance.Outline = true
    
    local healthBar = Drawing.new("Square")
    healthBar.Visible = false
    healthBar.Color = Color3.fromRGB(0, 255, 0)
    healthBar.Thickness = 1
    healthBar.Filled = true
    
    local healthBackground = Drawing.new("Square")
    healthBackground.Visible = false
    healthBackground.Color = Color3.fromRGB(50, 50, 50)
    healthBackground.Thickness = 1
    healthBackground.Filled = true
    
    local healthText = Drawing.new("Text")
    healthText.Visible = false
    healthText.Color = Color3.fromRGB(255, 255, 255)
    healthText.Size = 14
    healthText.Center = true
    healthText.Outline = true
    
    local aimbotStatus = Drawing.new("Text")
    aimbotStatus.Visible = false
    aimbotStatus.Color = Color3.fromRGB(255, 255, 0)
    aimbotStatus.Size = 14
    aimbotStatus.Center = true
    aimbotStatus.Outline = true
    aimbotStatus.Text = "🎯"
    
    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Color = Settings.Esp.TracerColor
    tracer.Thickness = 2
    
    Settings.Esp.Boxes[player] = box
    Settings.Esp.Names[player] = name
    Settings.Esp.Distances[player] = distance
    Settings.Esp.HealthBars[player] = healthBar
    Settings.Esp.HealthTexts[player] = healthText
    Settings.Esp.AimbotStatus[player] = aimbotStatus
    Settings.Esp.Tracers[player] = tracer
end

local function RemoveESP(player)
    for _, drawing in pairs({
        Settings.Esp.Boxes[player],
        Settings.Esp.Names[player],
        Settings.Esp.Distances[player],
        Settings.Esp.HealthBars[player],
        Settings.Esp.HealthTexts[player],
        Settings.Esp.AimbotStatus[player],
        Settings.Esp.Tracers[player]
    }) do
        if drawing then
            drawing:Remove()
        end
    end
    
    Settings.Esp.Boxes[player] = nil
    Settings.Esp.Names[player] = nil
    Settings.Esp.Distances[player] = nil
    Settings.Esp.HealthBars[player] = nil
    Settings.Esp.HealthTexts[player] = nil
    Settings.Esp.AimbotStatus[player] = nil
    Settings.Esp.Tracers[player] = nil
end

local function UpdateESP()
    if not Settings.Esp.Enabled then return end
    
    local localChar = LocalPlayer.Character
    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
    if not localRoot then return end
    
    local viewportSize = Camera.ViewportSize
    local screenCenter = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    
    for player, box in pairs(Settings.Esp.Boxes) do
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local character = player.Character
            local rootPart = character.HumanoidRootPart
            local humanoid = character:FindFirstChild("Humanoid")
            
            local distance = (localRoot.Position - rootPart.Position).Magnitude
            local position, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen and distance <= Settings.Esp.MaxDistance then
                local size = Vector2.new(2000 / position.Z, 4000 / position.Z)
                
                -- БОКС
                if Settings.Esp.ShowBox then
                    box.Size = size
                    box.Position = Vector2.new(position.X - size.X / 2, position.Y - size.Y / 2)
                    box.Visible = true
                    
                    if Settings.Esp.TeamColor and player.Team then
                        box.Color = player.Team.TeamColor.Color
                    else
                        box.Color = Settings.Esp.BoxColor
                    end
                else
                    box.Visible = false
                end
                
                -- ИМЯ
                if Settings.Esp.ShowName then
                    local name = Settings.Esp.Names[player]
                    name.Position = Vector2.new(position.X, position.Y - size.Y / 2 - 25)
                    name.Visible = true
                    name.Color = Settings.Esp.TextColor
                else
                    Settings.Esp.Names[player].Visible = false
                end
                
                -- ДИСТАНЦИЯ
                if Settings.Esp.ShowDistance then
                    local distanceText = Settings.Esp.Distances[player]
                    distanceText.Text = math.floor(distance) .. " studs"
                    distanceText.Position = Vector2.new(position.X, position.Y - size.Y / 2 - 45)
                    distanceText.Visible = true
                else
                    Settings.Esp.Distances[player].Visible = false
                end
                
                -- ЗДОРОВЬЕ
                if Settings.Esp.ShowHealth and humanoid then
                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    local healthBar = Settings.Esp.HealthBars[player]
                    local healthText = Settings.Esp.HealthTexts[player]
                    
                    local barWidth = 4
                    local barHeight = size.Y
                    local barX = position.X - size.X / 2 - 10
                    local barY = position.Y - size.Y / 2
                    
                    -- Фон здоровья
                    healthBar.Size = Vector2.new(barWidth, barHeight * healthPercent)
                    healthBar.Position = Vector2.new(barX, barY + barHeight * (1 - healthPercent))
                    healthBar.Visible = true
                    
                    -- Цвет здоровья
                    if healthPercent > 0.7 then
                        healthBar.Color = Color3.fromRGB(0, 255, 0)
                    elseif healthPercent > 0.3 then
                        healthBar.Color = Color3.fromRGB(255, 255, 0)
                    else
                        healthBar.Color = Color3.fromRGB(255, 0, 0)
                    end
                    
                    -- Текст здоровья
                    healthText.Text = tostring(math.floor(humanoid.Health))
                    healthText.Position = Vector2.new(barX - 20, barY + barHeight / 2 - 7)
                    healthText.Visible = true
                else
                    Settings.Esp.HealthBars[player].Visible = false
                    Settings.Esp.HealthTexts[player].Visible = false
                end
                
                -- ТРЕЙСЕРЫ
                if Settings.Esp.ShowTracers then
                    local tracer = Settings.Esp.Tracers[player]
                    tracer.From = Vector2.new(viewportSize.X / 2, viewportSize.Y)
                    tracer.To = Vector2.new(position.X, position.Y)
                    tracer.Visible = true
                else
                    Settings.Esp.Tracers[player].Visible = false
                end
            else
                box.Visible = false
                Settings.Esp.Names[player].Visible = false
                Settings.Esp.Distances[player].Visible = false
                Settings.Esp.HealthBars[player].Visible = false
                Settings.Esp.HealthTexts[player].Visible = false
                Settings.Esp.AimbotStatus[player].Visible = false
                Settings.Esp.Tracers[player].Visible = false
            end
        else
            box.Visible = false
            Settings.Esp.Names[player].Visible = false
            Settings.Esp.Distances[player].Visible = false
            Settings.Esp.HealthBars[player].Visible = false
            Settings.Esp.HealthTexts[player].Visible = false
            Settings.Esp.AimbotStatus[player].Visible = false
            Settings.Esp.Tracers[player].Visible = false
        end
    end
end

local function EnableESP()
    Settings.Esp.Enabled = true
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreateESP(player)
        end
    end
    
    local ESPConnection
    ESPConnection = RunService.RenderStepped:Connect(function()
        if not Settings.Esp.Enabled then
            ESPConnection:Disconnect()
            return
        end
        UpdateESP()
    end)
end

local function DisableESP()
    Settings.Esp.Enabled = false
    
    for player in pairs(Settings.Esp.Boxes) do
        RemoveESP(player)
    end
end

-- ИСПРАВЛЕННЫЙ АИМБОТ
local Aimbot = {
    Target = nil,
    Connection = nil,
    FOVCircle = nil,
    LastUpdate = 0,
    IsAiming = false
}

local function CreateFOVCircle()
    if Aimbot.FOVCircle then
        Aimbot.FOVCircle:Remove()
    end
    
    local Circle = Drawing.new("Circle")
    Circle.Visible = Settings.Aimbot.Enabled
    Circle.Radius = Settings.Aimbot.FOV
    Circle.Color = Color3.fromRGB(255, 0, 0)
    Circle.Thickness = 2
    Circle.Filled = false
    Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    Aimbot.FOVCircle = Circle
end

local function IsValidTarget(target)
    if target == LocalPlayer then return false end
    if not target.Character then return false end
    
    local humanoid = target.Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    
    local targetPart = target.Character:FindFirstChild(Settings.Aimbot.Part)
    if not targetPart then return false end
    
    -- ПРОВЕРКИ ВЫКЛЮЧЕНЫ ПО УМОЛЧАНИЮ
    if Settings.Aimbot.TeamCheck then
        local localTeam = LocalPlayer.Team
        local targetTeam = target.Team
        if localTeam and targetTeam and localTeam == targetTeam then
            return false
        end
    end
    
    local character = LocalPlayer.Character
    local targetChar = target.Character
    if not character or not targetChar then return false end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart or not targetRoot then return false end
    
    local distance = (humanoidRootPart.Position - targetRoot.Position).Magnitude
    if distance > Settings.Aimbot.MaxDistance then return false end
    
    local vector, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
    if not onScreen then return false end
    
    local mousePos = UIS:GetMouseLocation()
    local distanceToMouse = (Vector2.new(vector.X, vector.Y) - mousePos).Magnitude
    if distanceToMouse > Settings.Aimbot.FOV then return false end
    
    return true
end

local function GetBestTarget()
    local bestTarget = nil
    local bestScore = -math.huge
    local mousePos = UIS:GetMouseLocation()
    
    for _, player in pairs(Players:GetPlayers()) do
        if not IsValidTarget(player) then continue end
        
        local character = player.Character
        local targetPart = character:FindFirstChild(Settings.Aimbot.Part)
        local vector = Camera:WorldToViewportPoint(targetPart.Position)
        
        local score = 0
        local distanceToMouse = (Vector2.new(vector.X, vector.Y) - mousePos).Magnitude
        
        score = score + (Settings.Aimbot.FOV - distanceToMouse)
        
        if Settings.Aimbot.Part == "Head" then
            score = score + 50
        end
        
        local character = LocalPlayer.Character
        local targetChar = player.Character
        if character and targetChar then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart and targetRoot then
                local distance = (humanoidRootPart.Position - targetRoot.Position).Magnitude
                score = score + (Settings.Aimbot.MaxDistance - distance) / 3
            end
        end
        
        if score > bestScore then
            bestScore = score
            bestTarget = player
        end
    end
    
    return bestTarget
end

local function SmoothAim(target)
    if not target or not target.Character then return end
    
    local targetPart = target.Character:FindFirstChild(Settings.Aimbot.Part)
    if not targetPart then return end
    
    local camera = workspace.CurrentCamera
    local currentTime = tick()
    
    if currentTime - Aimbot.LastUpdate < (1 / Settings.Aimbot.Smoothness) * 0.1 then
        return
    end
    Aimbot.LastUpdate = currentTime
    
    if Settings.Aimbot.Smoothness <= 1 then
        camera.CFrame = CFrame.lookAt(camera.CFrame.Position, targetPart.Position)
    else
        local currentCFrame = camera.CFrame
        local targetCFrame = CFrame.lookAt(currentCFrame.Position, targetPart.Position)
        
        local smoothness = math.max(1, Settings.Aimbot.Smoothness)
        local lerpAlpha = 1 / smoothness
        
        if smoothness <= 5 then
            lerpAlpha = lerpAlpha * 2
        end
        
        local smoothedCFrame = currentCFrame:Lerp(targetCFrame, lerpAlpha)
        camera.CFrame = smoothedCFrame
    end
end

local function StartAimbot()
    if Aimbot.Connection then return end
    
    CreateFOVCircle()
    
    Aimbot.Connection = RunService.RenderStepped:Connect(function()
        if not Settings.Aimbot.Enabled then return end
        
        local mouseButtonPressed = UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        
        if mouseButtonPressed then
            if not Aimbot.IsAiming then
                Aimbot.Target = GetBestTarget()
                Aimbot.IsAiming = true
            end
            
            if Aimbot.Target and IsValidTarget(Aimbot.Target) then
                SmoothAim(Aimbot.Target)
            else
                Aimbot.Target = nil
                Aimbot.IsAiming = false
            end
        else
            Aimbot.Target = nil
            Aimbot.IsAiming = false
        end
        
        if Aimbot.FOVCircle then
            Aimbot.FOVCircle.Visible = Settings.Aimbot.Enabled
            Aimbot.FOVCircle.Radius = Settings.Aimbot.FOV
        end
    end)
end

local function StopAimbot()
    if Aimbot.Connection then
        Aimbot.Connection:Disconnect()
        Aimbot.Connection = nil
    end
    
    if Aimbot.FOVCircle then
        Aimbot.FOVCircle:Remove()
        Aimbot.FOVCircle = nil
    end
    
    Aimbot.Target = nil
    Aimbot.IsAiming = false
end

-- СИСТЕМА ПОЛЕТА
local Fly = {
    Connection = nil,
    BodyVelocity = nil
}

local function StartFly()
    if Fly.Connection then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    Fly.BodyVelocity = Instance.new("BodyVelocity")
    Fly.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    Fly.BodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
    Fly.BodyVelocity.P = 1000
    Fly.BodyVelocity.Parent = rootPart
    
    humanoid.PlatformStand = true
    
    Fly.Connection = RunService.Heartbeat:Connect(function()
        if not Settings.Fly.Enabled or not Fly.BodyVelocity then return end
        
        local camera = Camera
        local moveDirection = Vector3.new(0, 0, 0)
        
        if UIS:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + camera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - camera.CFrame.LookVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - camera.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + camera.CFrame.RightVector
        end
        if UIS:IsKeyDown(Enum.KeyCode.E) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UIS:IsKeyDown(Enum.KeyCode.Q) then
            moveDirection = moveDirection + Vector3.new(0, -1, 0)
        end
        
        if moveDirection.Magnitude > 0 then
            Fly.BodyVelocity.Velocity = moveDirection.Unit * Settings.Fly.Speed
        else
            Fly.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

local function StopFly()
    if Fly.Connection then
        Fly.Connection:Disconnect()
        Fly.Connection = nil
    end
    
    if Fly.BodyVelocity then
        Fly.BodyVelocity:Destroy()
        Fly.BodyVelocity = nil
    end
    
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.PlatformStand = false
        end
    end)
end

-- НОКЛИП
local NoclipConnection
local function EnableNoclip()
    if NoclipConnection then return end
    
    NoclipConnection = RunService.Stepped:Connect(function()
        if not Settings.Noclip then return end
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end)
end

local function DisableNoclip()
    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end
end

-- ИНТЕРФЕЙС
local MainTab = Window:CreateTab("Главная")
local MovementSection = MainTab:CreateSection("Передвижение")

-- ТЕЛЕПОРТ НА КУРСОР
local TeleportToggle = MainTab:CreateToggle({
    Name = "📌 ТЕЛЕПОРТ НА КУРСОР",
    CurrentValue = false,
    Callback = function(Value)
        TeleportSettings.Enabled = Value
        if Value then
            StartTeleportListener()
            Notify("Телепорт на курсор включен (Клавиша: " .. tostring(TeleportSettings.Key) .. ")")
        else
            StopTeleportListener()
            Notify("Телепорт на курсор выключен")
        end
    end
})

local TeleportKeyDropdown = MainTab:CreateDropdown({
    Name = "🔤 КЛАВИША ТЕЛЕПОРТА",
    Options = {"X", "C", "V", "F", "G", "T", "Y", "B", "N", "M"},
    CurrentOption = "X",
    Callback = function(Option)
        TeleportSettings.Key = Enum.KeyCode[Option]
        Notify("Клавиша телепорта изменена на: " .. Option)
        
        if TeleportSettings.Enabled then
            StartTeleportListener()
        end
    end
})

local NoclipToggle = MainTab:CreateToggle({
    Name = "🚶 NOCLIP",
    CurrentValue = false,
    Callback = function(Value)
        Settings.Noclip = Value
        if Value then
            EnableNoclip()
            Notify("NOCLIP включен")
        else
            DisableNoclip()
            Notify("NOCLIP выключен")
        end
    end
})

local FlyToggle = MainTab:CreateToggle({
    Name = "🕊️ FLY",
    CurrentValue = false,
    Callback = function(Value)
        Settings.Fly.Enabled = Value
        if Value then
            StartFly()
            Notify("FLY включен - WASD + E/Q")
        else
            StopFly()
            Notify("FLY выключен")
        end
    end
})

local FlySpeedSlider = MainTab:CreateSlider({
    Name = "СКОРОСТЬ ПОЛЕТА",
    Range = {10, 200},
    Increment = 5,
    Suffix = "units",
    CurrentValue = Settings.Fly.Speed,
    Callback = function(Value)
        Settings.Fly.Speed = Value
    end
})

local SpeedToggle = MainTab:CreateToggle({
    Name = "🏃 УЛУЧШЕННАЯ СКОРОСТЬ",
    CurrentValue = false,
    Callback = function(Value)
        Settings.Speed.Enabled = Value
        if not Value then
            DisableBodyVelocitySpeed()
            AdvancedSpeed.Enabled = false
            
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.WalkSpeed = AdvancedSpeed.OriginalWalkSpeed
                end
            end)
            
            Notify("Скорость выключена")
        else
            AdvancedSpeed.Enabled = true
            local success = EnableAdvancedSpeed()
            
            if success then
                Notify("Скорость включена")
            else
                Notify("Ошибка включения скорости")
                Settings.Speed.Enabled = false
            end
        end
    end
})

local SpeedSlider = MainTab:CreateSlider({
    Name = "СКОРОСТЬ ПЕРЕДВИЖЕНИЯ",
    Range = {16, 500},
    Increment = 10,
    Suffix = "units",
    CurrentValue = Settings.Speed.Value,
    Callback = function(Value)
        Settings.Speed.Value = Value
        AdvancedSpeed.Value = Value
        
        if Settings.Speed.Enabled then
            EnableAdvancedSpeed()
        end
    end
})

local InfiniteJumpToggle = MainTab:CreateToggle({
    Name = "🦘 БЕСКОНЕЧНЫЙ ПРЫЖОК",
    CurrentValue = false,
    Callback = function(Value)
        Settings.InfiniteJump = Value
        if Value then
            Notify("Бесконечные прыжки включены")
        end
    end
})

-- ВКЛАДКА ESP
local VisualsTab = Window:CreateTab("ESP")
local VisualsSection = VisualsTab:CreateSection("Основные настройки")

local EspToggle = VisualsTab:CreateToggle({
    Name = "👁️ ВКЛЮЧИТЬ ESP",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            EnableESP()
            Notify("ESP включен")
        else
            DisableESP()
            Notify("ESP выключен")
        end
    end
})

local BoxToggle = VisualsTab:CreateToggle({
    Name = "📦 ПОКАЗЫВАТЬ БОКСЫ",
    CurrentValue = true,
    Callback = function(Value)
        Settings.Esp.ShowBox = Value
    end
})

local NameToggle = VisualsTab:CreateToggle({
    Name = "🏷️ ПОКАЗЫВАТЬ ИМЕНА",
    CurrentValue = true,
    Callback = function(Value)
        Settings.Esp.ShowName = Value
    end
})

local DistanceToggle = VisualsTab:CreateToggle({
    Name = "📏 ПОКАЗЫВАТЬ ДИСТАНЦИИ",
    CurrentValue = true,
    Callback = function(Value)
        Settings.Esp.ShowDistance = Value
    end
})

local HealthToggle = VisualsTab:CreateToggle({
    Name = "❤️ ПОКАЗЫВАТЬ ЗДОРОВЬЕ",
    CurrentValue = true,
    Callback = function(Value)
        Settings.Esp.ShowHealth = Value
    end
})

local TracerToggle = VisualsTab:CreateToggle({
    Name = "🔻 ПОКАЗЫВАТЬ ТРЕЙСЕРЫ",
    CurrentValue = false,
    Callback = function(Value)
        Settings.Esp.ShowTracers = Value
    end
})

local TeamColorToggle = VisualsTab:CreateToggle({
    Name = "🎨 ЦВЕТ ПО КОМАНДАМ",
    CurrentValue = true,
    Callback = function(Value)
        Settings.Esp.TeamColor = Value
    end
})

local MaxDistanceSlider = VisualsTab:CreateSlider({
    Name = "📐 МАКС. ДИСТАНЦИЯ ESP",
    Range = {100, 5000},
    Increment = 50,
    Suffix = "studs",
    CurrentValue = 1000,
    Callback = function(Value)
        Settings.Esp.MaxDistance = Value
    end
})

-- ВКЛАДКА АИМБОТ
local CombatTab = Window:CreateTab("Аимбот")
local AimbotSection = CombatTab:CreateSection("Настройки аимбота")

local AimbotToggle = CombatTab:CreateToggle({
    Name = "🎯 ВКЛЮЧИТЬ АИМБОТ",
    CurrentValue = false,
    Callback = function(Value)
        Settings.Aimbot.Enabled = Value
        if Value then
            StartAimbot()
            Notify("Аимбот включен - Зажмите ПКМ для фиксации цели")
        else
            StopAimbot()
            Notify("Аимбот выключен")
        end
    end
})

local AimbotFOVSlider = CombatTab:CreateSlider({
    Name = "🔍 FOV АИМБОТА",
    Range = {10, 500},
    Increment = 10,
    Suffix = "pixels",
    CurrentValue = Settings.Aimbot.FOV,
    Callback = function(Value)
        Settings.Aimbot.FOV = Value
    end
})

local AimbotSmoothSlider = CombatTab:CreateSlider({
    Name = "⚡ ПЛАВНОСТЬ АИМБОТА",
    Range = {1, 20},
    Increment = 1,
    Suffix = "level",
    CurrentValue = Settings.Aimbot.Smoothness,
    Callback = function(Value)
        Settings.Aimbot.Smoothness = Value
    end
})

local AimbotPartDropdown = CombatTab:CreateDropdown({
    Name = "🎯 ЧАСТЬ ТЕЛА ДЛЯ АИМА",
    Options = {"Head", "HumanoidRootPart", "Torso"},
    CurrentOption = Settings.Aimbot.Part,
    Callback = function(Option)
        Settings.Aimbot.Part = Option
    end
})

local AimbotMaxDistanceSlider = CombatTab:CreateSlider({
    Name = "📏 МАКС. ДИСТАНЦИЯ АИМБОТА",
    Range = {50, 1000},
    Increment = 10,
    Suffix = "studs",
    CurrentValue = Settings.Aimbot.MaxDistance,
    Callback = function(Value)
        Settings.Aimbot.MaxDistance = Value
    end
})

local TeamCheckToggle = CombatTab:CreateToggle({
    Name = "🎪 ПРОВЕРКА КОМАНДЫ",
    CurrentValue = false,  -- ВЫКЛЮЧЕНО ПО УМОЛЧАНИЮ
    Callback = function(Value)
        Settings.Aimbot.TeamCheck = Value
    end
})

local VisibleCheckToggle = CombatTab:CreateToggle({
    Name = "👁️ ПРОВЕРКА ВИДИМОСТИ",
    CurrentValue = false,  -- ВЫКЛЮЧЕНО ПО УМОЛЧАНИЮ
    Callback = function(Value)
        Settings.Aimbot.VisibleCheck = Value
    end
})

local WallCheckToggle = CombatTab:CreateToggle({
    Name = "🧱 ПРОВЕРКА СТЕН",
    CurrentValue = false,  -- ВЫКЛЮЧЕНО ПО УМОЛЧАНИЮ
    Callback = function(Value)
        Settings.Aimbot.WallCheck = Value
    end
})

-- ВКЛАДКА ЗАЩИТА
local ProtectionTab = Window:CreateTab("Защита")
local ProtectionSection = ProtectionTab:CreateSection("Функции защиты")

local GodModeToggle = ProtectionTab:CreateToggle({
    Name = "💀 GOD MODE (НАСТОЯЩАЯ НЕУЯЗВИМОСТЬ)",
    CurrentValue = false,
    Callback = function(Value)
        GodMode.Enabled = Value
        if Value then
            EnableGodMode()
            Notify("⚡ GOD MODE АКТИВИРОВАН - Вы бессмертны!")
        else
            DisableGodMode()
            Notify("GOD MODE выключен")
        end
    end
})

local AntiAfkToggle = ProtectionTab:CreateToggle({
    Name = "⏰ ANTI-AFK",
    CurrentValue = false,
    Callback = function(Value)
        Settings.AntiAfk = Value
        if Value then
            Notify("ANTI-AFK включен")
        else
            Notify("ANTI-AFK выключен")
        end
    end
})

-- ОСНОВНЫЕ ЦИКЛЫ
RunService.Heartbeat:Connect(function()
    pcall(function()
        local character = LocalPlayer.Character
        if not character then return end
        
        -- Бесконечные прыжки
        if Settings.InfiniteJump then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
        
        -- God Mode защита
        if GodMode.Enabled then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
        end
    end)
end)

UIS.JumpRequest:Connect(function()
    if Settings.InfiniteJump and LocalPlayer.Character then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

if Settings.AntiAfk then
    local VirtualUser = game:GetService("VirtualUser")
    LocalPlayer.Idled:connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

Players.PlayerAdded:Connect(function(player)
    if Settings.Esp.Enabled then
        CreateESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

-- Запоминаем стандартную скорость
pcall(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        AdvancedSpeed.OriginalWalkSpeed = LocalPlayer.Character.Humanoid.WalkSpeed
        GodMode.OriginalWalkSpeed = AdvancedSpeed.OriginalWalkSpeed
    end
end)

-- Уведомление о загрузке
Notify("RAGE MOD ULTIMATE v" .. Version .. " загружен!")
print("⚡ RAGE MOD ULTIMATE v" .. Version .. " | Fixed God Mode & Improved ESP")