-- RAGE MOD - ULTIMATE VERSION WITH AIMBOT HIGHLIGHT
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "⚡ RAGE MOD | ULTIMATE",
    LoadingTitle = "RAGE MOD ULTIMATE",
    LoadingSubtitle = "Loading Ultimate Features...",
    Theme = "Dark"
})

-- Основные сервисы
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

-- УЛУЧШЕННАЯ СИСТЕМА СКОРОСТИ С АНТИ-ДЕТЕКТОМ
local AdvancedSpeed = {
    Enabled = false,
    Value = 50,
    Method = "Humanoid",
    BodyVelocity = nil,
    Connection = nil
}

local function EnableBodyVelocitySpeed()
    if AdvancedSpeed.BodyVelocity then return end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    AdvancedSpeed.BodyVelocity = Instance.new("BodyVelocity")
    AdvancedSpeed.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    AdvancedSpeed.BodyVelocity.MaxForce = Vector3.new(10000, 0, 10000)
    AdvancedSpeed.BodyVelocity.P = 1250
    AdvancedSpeed.BodyVelocity.Name = "RageSpeedHelper"
    AdvancedSpeed.BodyVelocity.Parent = humanoidRootPart
    
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
end

local function DisableBodyVelocitySpeed()
    if AdvancedSpeed.Connection then
        AdvancedSpeed.Connection:Disconnect()
        AdvancedSpeed.Connection = nil
    end
    
    if AdvancedSpeed.BodyVelocity then
        AdvancedSpeed.BodyVelocity:Destroy()
        AdvancedSpeed.BodyVelocity = nil
    end
end

-- Все функции выключены по умолчанию
local Settings = {
    Noclip = false,
    Fly = {
        Enabled = false,
        Speed = 50
    },
    Speed = {
        Enabled = false,
        Value = 50,
        Method = "Humanoid"
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
        ShowAimbotStatus = true, -- НОВАЯ ФУНКЦИЯ: показывать статус аимбота
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
        TeamCheck = true,
        VisibleCheck = true,
        Prediction = false,
        PredictionAmount = 0.1,
        MaxDistance = 500,
        WallCheck = true,
        Priority = "Closest"
    }
}

-- Улучшенные уведомления
local function Notify(message)
    Rayfield:Notify({
        Title = "RAGE MOD ULTIMATE",
        Content = message,
        Duration = 2.5
    })
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
        local checkRay = Ray.new(newPosition + Vector3.new(0, 10, 0), Vector3.new(0, -20, 0))
        local hit, hitPosition = workspace:FindPartOnRayWithIgnoreList(checkRay, ignoreList)
        
        if hit then
            humanoidRootPart.CFrame = CFrame.new(hitPosition + Vector3.new(0, 5, 0))
            Notify("Телепортирован на курсор")
        else
            humanoidRootPart.CFrame = CFrame.new(newPosition)
            Notify("Телепортирован на курсор")
        end
    else
        Notify("Не удалось найти точку для телепорта")
    end
end

-- УЛУЧШЕННЫЙ АИМБОТ С МГНОВЕННЫМ НАВЕДЕНИЕМ
local Aimbot = {
    Target = nil,
    Connection = nil,
    FOVCircle = nil,
    LastUpdate = 0
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

local function IsTargetVisible(target)
    if not Settings.Aimbot.VisibleCheck then return true end
    if not Settings.Aimbot.WallCheck then return true end
    
    local character = LocalPlayer.Character
    local targetChar = target.Character
    if not character or not targetChar then return false end
    
    local origin = Camera.CFrame.Position
    local targetPart = targetChar:FindFirstChild(Settings.Aimbot.Part)
    if not targetPart then return false end
    
    local direction = (targetPart.Position - origin).Unit
    local ray = Ray.new(origin, direction * Settings.Aimbot.MaxDistance)
    
    local ignoreList = {character, targetChar}
    local hit, position = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)
    
    return hit == nil or hit:IsDescendantOf(targetChar)
end

local function IsEnemy(target)
    if not Settings.Aimbot.TeamCheck then return true end
    
    local localTeam = LocalPlayer.Team
    local targetTeam = target.Team
    
    return not localTeam or not targetTeam or localTeam ~= targetTeam
end

local function IsInRange(target)
    local character = LocalPlayer.Character
    local targetChar = target.Character
    
    if not character or not targetChar then return false end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
    
    if not humanoidRootPart or not targetRoot then return false end
    
    local distance = (humanoidRootPart.Position - targetRoot.Position).Magnitude
    return distance <= Settings.Aimbot.MaxDistance
end

-- НОВАЯ ФУНКЦИЯ: Проверка может ли аимбот выбрать цель
local function CanAimbotTarget(player)
    if player == LocalPlayer then return false end
    if not player.Character then return false end
    if not IsEnemy(player) then return false end
    if not IsInRange(player) then return false end
    if not IsTargetVisible(player) then return false end
    
    -- Проверка что цель в поле зрения камеры
    local targetPart = player.Character:FindFirstChild(Settings.Aimbot.Part)
    if not targetPart then return false end
    
    local vector, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
    if not onScreen then return false end
    
    -- Проверка FOV
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
        if player == LocalPlayer then continue end
        if not player.Character then continue end
        if not IsEnemy(player) then continue end
        if not IsInRange(player) then continue end
        if not IsTargetVisible(player) then continue end
        
        local character = player.Character
        local targetPart = character:FindFirstChild(Settings.Aimbot.Part)
        if not targetPart then continue end
        
        local vector, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
        if not onScreen then continue end
        
        local score = 0
        local distanceToMouse = (Vector2.new(vector.X, vector.Y) - mousePos).Magnitude
        
        if distanceToMouse <= Settings.Aimbot.FOV then
            score = score + (Settings.Aimbot.FOV - distanceToMouse)
            
            -- Бонус для головы
            if Settings.Aimbot.Part == "Head" then
                score = score + 30
            end
            
            -- Приоритет ближайшей цели
            local character = LocalPlayer.Character
            local targetChar = player.Character
            if character and targetChar then
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart and targetRoot then
                    local distance = (humanoidRootPart.Position - targetRoot.Position).Magnitude
                    score = score + (Settings.Aimbot.MaxDistance - distance) / 5
                end
            end
        else
            continue
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
    
    if Settings.Aimbot.Smoothness <= 1 then
        -- Мгновенное наведение при сглаживании 1
        camera.CFrame = CFrame.lookAt(camera.CFrame.Position, targetPart.Position)
    else
        -- Плавное наведение для остальных значений
        local currentCFrame = camera.CFrame
        local targetCFrame = CFrame.lookAt(currentCFrame.Position, targetPart.Position)
        
        local smoothness = math.max(1, Settings.Aimbot.Smoothness)
        local lerpAlpha = 1 / smoothness
        
        -- Ускоренное наведение для значений от 2 до 5
        if smoothness <= 5 then
            lerpAlpha = lerpAlpha * 3
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
            local newTarget = GetBestTarget()
            
            if newTarget then
                if Aimbot.Target ~= newTarget then
                    Aimbot.Target = newTarget
                end
                
                if Aimbot.Target then
                    SmoothAim(Aimbot.Target)
                end
            else
                Aimbot.Target = nil
            end
        else
            Aimbot.Target = nil
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
end

-- УЛУЧШЕННАЯ СИСТЕМА ESP С ПОДСВЕТКОЙ АИМБОТА
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
    name.Size = 16
    name.Center = true
    name.Outline = true
    name.Text = player.Name
    
    local distance = Drawing.new("Text")
    distance.Visible = false
    distance.Color = Settings.Esp.TextColor
    distance.Size = 14
    distance.Center = true
    distance.Outline = true
    
    -- Полоска здоровья
    local healthBar = Drawing.new("Square")
    healthBar.Visible = false
    healthBar.Color = Color3.fromRGB(0, 255, 0)
    healthBar.Thickness = 1
    healthBar.Filled = true
    
    -- Текст здоровья (цифры)
    local healthText = Drawing.new("Text")
    healthText.Visible = false
    healthText.Color = Color3.fromRGB(255, 255, 255)
    healthText.Size = 14
    healthText.Center = true
    healthText.Outline = true
    
    -- Индикатор статуса аимбота
    local aimbotStatus = Drawing.new("Text")
    aimbotStatus.Visible = false
    aimbotStatus.Color = Color3.fromRGB(255, 255, 0)
    aimbotStatus.Size = 12
    aimbotStatus.Center = true
    aimbotStatus.Outline = true
    aimbotStatus.Text = "🎯"
    
    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Color = Settings.Esp.TracerColor
    tracer.Thickness = 1
    
    Settings.Esp.Boxes[player] = box
    Settings.Esp.Names[player] = name
    Settings.Esp.Distances[player] = distance
    Settings.Esp.HealthBars[player] = healthBar
    Settings.Esp.HealthTexts[player] = healthText
    Settings.Esp.AimbotStatus[player] = aimbotStatus
    Settings.Esp.Tracers[player] = tracer
end

local function RemoveESP(player)
    if Settings.Esp.Boxes[player] then
        Settings.Esp.Boxes[player]:Remove()
        Settings.Esp.Boxes[player] = nil
    end
    if Settings.Esp.Names[player] then
        Settings.Esp.Names[player]:Remove()
        Settings.Esp.Names[player] = nil
    end
    if Settings.Esp.Distances[player] then
        Settings.Esp.Distances[player]:Remove()
        Settings.Esp.Distances[player] = nil
    end
    if Settings.Esp.HealthBars[player] then
        Settings.Esp.HealthBars[player]:Remove()
        Settings.Esp.HealthBars[player] = nil
    end
    if Settings.Esp.HealthTexts[player] then
        Settings.Esp.HealthTexts[player]:Remove()
        Settings.Esp.HealthTexts[player] = nil
    end
    if Settings.Esp.AimbotStatus[player] then
        Settings.Esp.AimbotStatus[player]:Remove()
        Settings.Esp.AimbotStatus[player] = nil
    end
    if Settings.Esp.Tracers[player] then
        Settings.Esp.Tracers[player]:Remove()
        Settings.Esp.Tracers[player] = nil
    end
end

local function UpdateESP()
    if not Settings.Esp.Enabled then return end
    
    local localChar = LocalPlayer.Character
    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
    if not localRoot then return end
    
    for player, box in pairs(Settings.Esp.Boxes) do
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local character = player.Character
            local rootPart = character.HumanoidRootPart
            local humanoid = character:FindFirstChild("Humanoid")
            
            local distance = (localRoot.Position - rootPart.Position).Magnitude
            if distance > Settings.Esp.MaxDistance then
                box.Visible = false
                Settings.Esp.Names[player].Visible = false
                Settings.Esp.Distances[player].Visible = false
                Settings.Esp.HealthBars[player].Visible = false
                Settings.Esp.HealthTexts[player].Visible = false
                Settings.Esp.AimbotStatus[player].Visible = false
                Settings.Esp.Tracers[player].Visible = false
                continue
            end
            
            local position, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen then
                local size = Vector2.new(2000 / position.Z, 4000 / position.Z)
                
                -- Бокс с подсветкой аимбота
                if Settings.Esp.ShowBox then
                    box.Size = size
                    box.Position = Vector2.new(position.X - size.X / 2, position.Y - size.Y / 2)
                    box.Visible = true
                    
                    -- Подсветка синим если аимбот не может выбрать цель
                    if Settings.Aimbot.Enabled and Settings.Esp.ShowAimbotStatus then
                        if CanAimbotTarget(player) then
                            -- Доступная цель - зеленый
                            box.Color = Color3.fromRGB(0, 255, 0)
                        else
                            -- Недоступная цель - синий
                            box.Color = Color3.fromRGB(0, 100, 255)
                        end
                    else
                        -- Обычная логика цвета
                        if Settings.Esp.TeamColor and player.Team then
                            box.Color = player.Team.TeamColor.Color
                        else
                            box.Color = Settings.Esp.BoxColor
                        end
                    end
                else
                    box.Visible = false
                end
                
                -- Имя
                if Settings.Esp.ShowName then
                    Settings.Esp.Names[player].Position = Vector2.new(position.X, position.Y - size.Y / 2 - 20)
                    Settings.Esp.Names[player].Visible = true
                else
                    Settings.Esp.Names[player].Visible = false
                end
                
                -- Дистанция
                if Settings.Esp.ShowDistance then
                    Settings.Esp.Distances[player].Text = math.floor(distance) .. " studs"
                    Settings.Esp.Distances[player].Position = Vector2.new(position.X, position.Y - size.Y / 2 - 40)
                    Settings.Esp.Distances[player].Visible = true
                else
                    Settings.Esp.Distances[player].Visible = false
                end
                
                -- Полоска здоровья
                if Settings.Esp.ShowHealth and humanoid then
                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    local healthBar = Settings.Esp.HealthBars[player]
                    local healthText = Settings.Esp.HealthTexts[player]
                    
                    -- Полоска здоровья (вертикальная слева от бокса)
                    local barWidth = 3
                    local barHeight = size.Y * healthPercent
                    local barX = position.X - size.X / 2 - 8
                    local barY = position.Y + size.Y / 2 - barHeight
                    
                    healthBar.Size = Vector2.new(barWidth, barHeight)
                    healthBar.Position = Vector2.new(barX, barY)
                    healthBar.Visible = true
                    
                    -- Цвет полоски в зависимости от здоровья
                    if healthPercent > 0.7 then
                        healthBar.Color = Color3.fromRGB(0, 255, 0)
                    elseif healthPercent > 0.3 then
                        healthBar.Color = Color3.fromRGB(255, 255, 0)
                    else
                        healthBar.Color = Color3.fromRGB(255, 0, 0)
                    end
                    
                    -- Текст здоровья (цифры рядом с полоской)
                    healthText.Text = tostring(math.floor(humanoid.Health))
                    healthText.Position = Vector2.new(barX - 15, barY + barHeight / 2 - 7)
                    healthText.Visible = true
                    
                else
                    if Settings.Esp.HealthBars[player] then
                        Settings.Esp.HealthBars[player].Visible = false
                    end
                    if Settings.Esp.HealthTexts[player] then
                        Settings.Esp.HealthTexts[player].Visible = false
                    end
                end
                
                -- Индикатор статуса аимбота
                if Settings.Esp.ShowAimbotStatus and Settings.Aimbot.Enabled then
                    local aimbotStatus = Settings.Esp.AimbotStatus[player]
                    aimbotStatus.Position = Vector2.new(position.X, position.Y + size.Y / 2 + 25)
                    
                    if CanAimbotTarget(player) then
                        aimbotStatus.Text = "🎯"
                        aimbotStatus.Color = Color3.fromRGB(0, 255, 0)
                    else
                        aimbotStatus.Text = "🚫"
                        aimbotStatus.Color = Color3.fromRGB(255, 0, 0)
                    end
                    aimbotStatus.Visible = true
                else
                    if Settings.Esp.AimbotStatus[player] then
                        Settings.Esp.AimbotStatus[player].Visible = false
                    end
                end
                
                -- Трейсеры
                if Settings.Esp.ShowTracers then
                    local tracer = Settings.Esp.Tracers[player]
                    tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
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
            if Settings.Esp.Names[player] then Settings.Esp.Names[player].Visible = false end
            if Settings.Esp.Distances[player] then Settings.Esp.Distances[player].Visible = false end
            if Settings.Esp.HealthBars[player] then Settings.Esp.HealthBars[player].Visible = false end
            if Settings.Esp.HealthTexts[player] then Settings.Esp.HealthTexts[player].Visible = false end
            if Settings.Esp.AimbotStatus[player] then Settings.Esp.AimbotStatus[player].Visible = false end
            if Settings.Esp.Tracers[player] then Settings.Esp.Tracers[player].Visible = false end
        end
    end
end

local function EnableESP()
    Settings.Esp.Enabled = true
    
    -- Инициализация таблиц ESP
    Settings.Esp.Boxes = {}
    Settings.Esp.Names = {}
    Settings.Esp.Distances = {}
    Settings.Esp.HealthBars = {}
    Settings.Esp.HealthTexts = {}
    Settings.Esp.AimbotStatus = {}
    Settings.Esp.Tracers = {}
    
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
    
    Settings.Esp.Boxes = {}
    Settings.Esp.Names = {}
    Settings.Esp.Distances = {}
    Settings.Esp.HealthBars = {}
    Settings.Esp.HealthTexts = {}
    Settings.Esp.AimbotStatus = {}
    Settings.Esp.Tracers = {}
end

-- УЛУЧШЕННАЯ СИСТЕМА ПОЛЕТА
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

-- БЫСТРЫЙ НОКЛИП
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

local TpToCursorBtn = MainTab:CreateButton({
    Name = "📌 ТП НА КУРСОР",
    Callback = TpToCursor
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
    Name = "🏃 СКОРОСТЬ БЕГА",
    CurrentValue = false,
    Callback = function(Value)
        Settings.Speed.Enabled = Value
        if not Value then
            pcall(function()
                LocalPlayer.Character.Humanoid.WalkSpeed = 16
            end)
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
            pcall(function()
                if Settings.Speed.Method == "Humanoid" then
                    LocalPlayer.Character.Humanoid.WalkSpeed = Value
                end
            end)
        end
    end
})

local SpeedMethodDropdown = MainTab:CreateDropdown({
    Name = "🏃 МЕТОД СКОРОСТИ",
    Options = {"Humanoid", "BodyVelocity"},
    CurrentOption = Settings.Speed.Method,
    Callback = function(Option)
        Settings.Speed.Method = Option
        if Option == "Humanoid" then
            DisableBodyVelocitySpeed()
            AdvancedSpeed.Enabled = false
        end
        Notify("Метод скорости: " .. Option)
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

local AimbotStatusToggle = VisualsTab:CreateToggle({
    Name = "🎯 ПОКАЗЫВАТЬ СТАТУС АИМБОТА",
    CurrentValue = true,
    Callback = function(Value)
        Settings.Esp.ShowAimbotStatus = Value
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
            Notify("Аимбот включен - Зажмите ПКМ")
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
    CurrentValue = true,
    Callback = function(Value)
        Settings.Aimbot.TeamCheck = Value
    end
})

local VisibleCheckToggle = CombatTab:CreateToggle({
    Name = "👁️ ПРОВЕРКА ВИДИМОСТИ",
    CurrentValue = true,
    Callback = function(Value)
        Settings.Aimbot.VisibleCheck = Value
    end
})

-- ВКЛАДКА ЗАЩИТА
local ProtectionTab = Window:CreateTab("Защита")
local ProtectionSection = ProtectionTab:CreateSection("Функции защиты")

local GodModeToggle = ProtectionTab:CreateToggle({
    Name = "💀 GOD MODE",
    CurrentValue = false,
    Callback = function(Value)
        Settings.GodMode = Value
        if Value then
            pcall(function()
                LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
            end)
            Notify("GOD MODE включен")
        else
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
        
        -- Улучшенная скорость с выбором метода
        if Settings.Speed.Enabled then
            if Settings.Speed.Method == "BodyVelocity" then
                if not AdvancedSpeed.Enabled then
                    AdvancedSpeed.Enabled = true
                    AdvancedSpeed.Value = Settings.Speed.Value
                    EnableBodyVelocitySpeed()
                end
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = 16
                end
            else
                if AdvancedSpeed.Enabled then
                    AdvancedSpeed.Enabled = false
                    DisableBodyVelocitySpeed()
                end
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.WalkSpeed = Settings.Speed.Value
                end
            end
        else
            if AdvancedSpeed.Enabled then
                AdvancedSpeed.Enabled = false
                DisableBodyVelocitySpeed()
            end
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = 16
            end
        end
        
        if Settings.GodMode then
            local humanoid = character:FindFirstChild("Humanoid")
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

Notify("RAGE MOD ULTIMATE загружен! Все функции выключены по умолчанию.")
print("RAGE MOD ULTIMATE: Система активирована с подсветкой аимбота в ESP")
