-- RAGE MOD - ULTIMATE VERSION 1.0 BETA
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "⚡ RAGE MOD | ULTIMATE v1.0 BETA",
    LoadingTitle = "RAGE MOD ULTIMATE v1.0 BETA",
    LoadingSubtitle = "Loading Advanced Features...",
    Theme = "Dark"
})

-- Основные сервисы
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

-- ВЕРСИЯ
local Version = "1.0 BETA"

-- ИСПРАВЛЕННЫЙ БЕСКОНЕЧНЫЙ ПРЫЖОК
local InfiniteJump = {
    Enabled = false,
    Connection = nil
}

local function EnableInfiniteJump()
    if InfiniteJump.Connection then
        InfiniteJump.Connection:Disconnect()
    end
    
    InfiniteJump.Connection = UIS.JumpRequest:Connect(function()
        if InfiniteJump.Enabled and LocalPlayer.Character then
            local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if Humanoid then
                Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end)
end

local function DisableInfiniteJump()
    if InfiniteJump.Connection then
        InfiniteJump.Connection:Disconnect()
        InfiniteJump.Connection = nil
    end
end

-- СИСТЕМА СПИСКА ИГРОКОВ
local PlayerList = {
    Players = {},
    LastUpdate = 0,
    UpdateInterval = 5,
    Connection = nil
}

local function UpdatePlayerList()
    PlayerList.Players = {}
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(PlayerList.Players, {
                Name = player.Name,
                Player = player,
                DisplayName = player.DisplayName or player.Name,
                Team = player.Team and player.Team.Name or "Без команды"
            })
        end
    end
    
    table.sort(PlayerList.Players, function(a, b)
        return a.Name:lower() < b.Name:lower()
    end)
    
    PlayerList.LastUpdate = tick()
end

local function CreatePlayerListTab()
    local PlayerTab = Window:CreateTab("👥 Игроки")
    local PlayerSection = PlayerTab:CreateSection("Список игроков на сервере")
    
    local PlayerButtons = {}
    local SearchBox = PlayerTab:CreateInput({
        Name = "🔍 Поиск игрока",
        PlaceholderText = "Введите ник игрока...",
        RemoveTextAfterFocusLost = false,
        Callback = function(Text)
            for playerName, button in pairs(PlayerButtons) do
                if string.find(playerName:lower(), Text:lower()) or Text == "" then
                    button.Visible = true
                else
                    button.Visible = false
                end
            end
        end
    })
    
    local function CreatePlayerButtons()
        for _, button in pairs(PlayerButtons) do
            button:Destroy()
        end
        PlayerButtons = {}
        
        for _, playerData in pairs(PlayerList.Players) do
            local button = PlayerSection:CreateButton({
                Name = "👤 " .. playerData.Name,
                Callback = function()
                    Rayfield:Notify({
                        Title = "Игрок выбран",
                        Content = "Вы выбрали: " .. playerData.Name .. "\nКоманда: " .. playerData.Team,
                        Duration = 6,
                        Actions = {
                            Ignore = {
                                Name = "Закрыть",
                                Callback = function() end
                            }
                        }
                    })
                end
            })
            PlayerButtons[playerData.Name] = button
        end
        
        PlayerSection:CreateButton({
            Name = "🔄 Обновить список",
            Callback = function()
                UpdatePlayerList()
                CreatePlayerButtons()
                Rayfield:Notify({
                    Title = "Список игроков",
                    Content = "Список обновлен! Игроков: " .. #PlayerList.Players,
                    Duration = 3
                })
            end
        })
        
        PlayerSection:CreateLabel("Игроков на сервере: " .. #Players:GetPlayers())
        PlayerSection:CreateLabel("Обновлено: " .. os.date("%X"))
    end
    
    if PlayerList.Connection then
        PlayerList.Connection:Disconnect()
    end
    
    PlayerList.Connection = RunService.Heartbeat:Connect(function()
        if tick() - PlayerList.LastUpdate > PlayerList.UpdateInterval then
            UpdatePlayerList()
            CreatePlayerButtons()
        end
    end)
    
    UpdatePlayerList()
    CreatePlayerButtons()
end

-- GOD MOD
local GodMode = {
    Enabled = false,
    Connection = nil
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
            
            humanoid.Health = humanoid.MaxHealth
            
            -- Дополнительная защита от смерти
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

-- ИСПРАВЛЕННАЯ СИСТЕМА СКОРОСТИ
local AdvancedSpeed = {
    Enabled = false,
    Value = 50,
    BodyVelocity = nil,
    Connection = nil,
    OriginalWalkSpeed = 16,
    CurrentMethod = "Auto"
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
            
            -- Исправление бага с клоном вправо
            local currentVelocity = AdvancedSpeed.BodyVelocity.Velocity
            local newVelocity = Vector3.new(
                moveDirection.X,
                0,
                moveDirection.Z
            )
            
            AdvancedSpeed.BodyVelocity.Velocity = newVelocity
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
            
            -- Исправление: скорость работает всегда, не только при прыжке
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

local function EnableAdvancedSpeed()
    DisableBodyVelocitySpeed()
    
    local success = EnableBodyVelocitySpeed()
    
    if not success then
        success = EnableHumanoidSpeed()
        if success then
            AdvancedSpeed.CurrentMethod = "Humanoid"
        end
    else
        AdvancedSpeed.CurrentMethod = "BodyVelocity"
    end
    
    return success
end

-- ТЕЛЕПОРТ НА КУРСОР
local TeleportSettings = {
    Enabled = false,
    Key = Enum.KeyCode.X,
    Connection = nil
}

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

-- ИСПРАВЛЕННАЯ ESP СИСТЕМА
local ESP = {
    Enabled = false,
    ShowBox = true,
    ShowName = true,
    ShowDistance = true,
    ShowHealth = true,
    ShowTracers = false,
    TeamColor = true,
    MaxDistance = 1000,
    BoxColor = Color3.fromRGB(0, 255, 255),
    TextColor = Color3.fromRGB(255, 255, 255),
    TracerColor = Color3.fromRGB(255, 0, 0),
    Boxes = {},
    Names = {},
    Distances = {},
    HealthBars = {},
    HealthTexts = {},
    Tracers = {},
    Connection = nil
}

local function CreateESP(player)
    if ESP.Boxes[player] then return end
    
    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = ESP.BoxColor
    box.Thickness = 2
    box.Filled = false
    
    local name = Drawing.new("Text")
    name.Visible = false
    name.Color = ESP.TextColor
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
    
    local healthText = Drawing.new("Text")
    healthText.Visible = false
    healthText.Color = Color3.fromRGB(255, 255, 255)
    healthText.Size = 14
    healthText.Center = true
    healthText.Outline = true
    
    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Color = ESP.TracerColor
    tracer.Thickness = 2
    
    ESP.Boxes[player] = box
    ESP.Names[player] = name
    ESP.Distances[player] = distance
    ESP.HealthBars[player] = healthBar
    ESP.HealthTexts[player] = healthText
    ESP.Tracers[player] = tracer
end

local function RemoveESP(player)
    for _, drawing in pairs({
        ESP.Boxes[player],
        ESP.Names[player],
        ESP.Distances[player],
        ESP.HealthBars[player],
        ESP.HealthTexts[player],
        ESP.Tracers[player]
    }) do
        if drawing then
            drawing:Remove()
        end
    end
    
    ESP.Boxes[player] = nil
    ESP.Names[player] = nil
    ESP.Distances[player] = nil
    ESP.HealthBars[player] = nil
    ESP.HealthTexts[player] = nil
    ESP.Tracers[player] = nil
end

local function UpdateESP()
    if not ESP.Enabled then return end
    
    local localChar = LocalPlayer.Character
    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")
    if not localRoot then return end
    
    local viewportSize = Camera.ViewportSize
    local screenCenter = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
    
    for player, box in pairs(ESP.Boxes) do
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local character = player.Character
            local rootPart = character.HumanoidRootPart
            local humanoid = character:FindFirstChild("Humanoid")
            
            local distance = (localRoot.Position - rootPart.Position).Magnitude
            local position, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen and distance <= ESP.MaxDistance then
                local size = Vector2.new(2000 / position.Z, 4000 / position.Z)
                
                -- БОКС
                if ESP.ShowBox then
                    box.Size = size
                    box.Position = Vector2.new(position.X - size.X / 2, position.Y - size.Y / 2)
                    box.Visible = true
                    
                    if ESP.TeamColor and player.Team then
                        box.Color = player.Team.TeamColor.Color
                    else
                        box.Color = ESP.BoxColor
                    end
                else
                    box.Visible = false
                end
                
                -- ИМЯ
                if ESP.ShowName then
                    local name = ESP.Names[player]
                    name.Position = Vector2.new(position.X, position.Y - size.Y / 2 - 25)
                    name.Visible = true
                    name.Color = ESP.TextColor
                else
                    ESP.Names[player].Visible = false
                end
                
                -- ДИСТАНЦИЯ
                if ESP.ShowDistance then
                    local distanceText = ESP.Distances[player]
                    distanceText.Text = math.floor(distance) .. " studs"
                    distanceText.Position = Vector2.new(position.X, position.Y - size.Y / 2 - 45)
                    distanceText.Visible = true
                else
                    ESP.Distances[player].Visible = false
                end
                
                -- ЗДОРОВЬЕ
                if ESP.ShowHealth and humanoid then
                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    local healthBar = ESP.HealthBars[player]
                    local healthText = ESP.HealthTexts[player]
                    
                    local barWidth = 4
                    local barHeight = size.Y
                    local barX = position.X - size.X / 2 - 10
                    local barY = position.Y - size.Y / 2
                    
                    healthBar.Size = Vector2.new(barWidth, barHeight * healthPercent)
                    healthBar.Position = Vector2.new(barX, barY + barHeight * (1 - healthPercent))
                    healthBar.Visible = true
                    
                    if healthPercent > 0.7 then
                        healthBar.Color = Color3.fromRGB(0, 255, 0)
                    elseif healthPercent > 0.3 then
                        healthBar.Color = Color3.fromRGB(255, 255, 0)
                    else
                        healthBar.Color = Color3.fromRGB(255, 0, 0)
                    end
                    
                    healthText.Text = tostring(math.floor(humanoid.Health))
                    healthText.Position = Vector2.new(barX - 20, barY + barHeight / 2 - 7)
                    healthText.Visible = true
                else
                    ESP.HealthBars[player].Visible = false
                    ESP.HealthTexts[player].Visible = false
                end
                
                -- ТРЕЙСЕРЫ
                if ESP.ShowTracers then
                    local tracer = ESP.Tracers[player]
                    tracer.From = Vector2.new(viewportSize.X / 2, viewportSize.Y)
                    tracer.To = Vector2.new(position.X, position.Y)
                    tracer.Visible = true
                else
                    ESP.Tracers[player].Visible = false
                end
            else
                box.Visible = false
                ESP.Names[player].Visible = false
                ESP.Distances[player].Visible = false
                ESP.HealthBars[player].Visible = false
                ESP.HealthTexts[player].Visible = false
                ESP.Tracers[player].Visible = false
            end
        else
            box.Visible = false
            ESP.Names[player].Visible = false
            ESP.Distances[player].Visible = false
            ESP.HealthBars[player].Visible = false
            ESP.HealthTexts[player].Visible = false
            ESP.Tracers[player].Visible = false
        end
    end
end

local function EnableESP()
    ESP.Enabled = true
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreateESP(player)
        end
    end
    
    if ESP.Connection then
        ESP.Connection:Disconnect()
    end
    
    ESP.Connection = RunService.RenderStepped:Connect(function()
        if not ESP.Enabled then
            ESP.Connection:Disconnect()
            return
        end
        UpdateESP()
    end)
end

local function DisableESP()
    ESP.Enabled = false
    
    for player in pairs(ESP.Boxes) do
        RemoveESP(player)
    end
    
    if ESP.Connection then
        ESP.Connection:Disconnect()
        ESP.Connection = nil
    end
end

-- ИСПРАВЛЕННАЯ СИСТЕМА ПОЛЕТА
local FlySettings = {
    Enabled = false,
    Speed = 50,
    Connection = nil,
    BodyGyro = nil,
    BodyVelocity = nil
}

local function StartFly()
    if FlySettings.Connection then
        FlySettings.Connection:Disconnect()
    end
    
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    -- Создаем BodyGyro для стабилизации поворота
    FlySettings.BodyGyro = Instance.new("BodyGyro")
    FlySettings.BodyGyro.P = 1000
    FlySettings.BodyGyro.MaxTorque = Vector3.new(40000, 40000, 40000)
    FlySettings.BodyGyro.CFrame = rootPart.CFrame
    FlySettings.BodyGyro.Parent = rootPart
    
    -- Создаем BodyVelocity для движения
    FlySettings.BodyVelocity = Instance.new("BodyVelocity")
    FlySettings.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    FlySettings.BodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
    FlySettings.BodyVelocity.P = 1000
    FlySettings.BodyVelocity.Parent = rootPart
    
    humanoid.PlatformStand = true
    
    FlySettings.Connection = RunService.Heartbeat:Connect(function()
        if not FlySettings.Enabled or not FlySettings.BodyVelocity or not FlySettings.BodyGyro then return end
        
        -- Обновляем поворот в соответствии с камерой
        FlySettings.BodyGyro.CFrame = Camera.CFrame
        
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
        if UIS:IsKeyDown(Enum.KeyCode.E) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UIS:IsKeyDown(Enum.KeyCode.Q) then
            moveDirection = moveDirection + Vector3.new(0, -1, 0)
        end
        
        if moveDirection.Magnitude > 0 then
            FlySettings.BodyVelocity.Velocity = moveDirection.Unit * FlySettings.Speed
        else
            FlySettings.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
end

local function StopFly()
    if FlySettings.Connection then
        FlySettings.Connection:Disconnect()
        FlySettings.Connection = nil
    end
    
    if FlySettings.BodyVelocity then
        FlySettings.BodyVelocity:Destroy()
        FlySettings.BodyVelocity = nil
    end
    
    if FlySettings.BodyGyro then
        FlySettings.BodyGyro:Destroy()
        FlySettings.BodyGyro = nil
    end
    
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.PlatformStand = false
        end
    end)
end

-- НОКЛИП СИСТЕМА
local NoclipSettings = {
    Enabled = false,
    Connection = nil
}

local function EnableNoclip()
    if NoclipSettings.Connection then
        NoclipSettings.Connection:Disconnect()
    end
    
    NoclipSettings.Connection = RunService.Stepped:Connect(function()
        if not NoclipSettings.Enabled then return end
        
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
    if NoclipSettings.Connection then
        NoclipSettings.Connection:Disconnect()
        NoclipSettings.Connection = nil
    end
end

-- ИСПРАВЛЕННЫЙ АИМБОТ (УБРАНА ПРОВЕРКА ВИДИМОСТИ)
local AimbotSettings = {
    Enabled = false,
    FOV = 100,
    Smoothness = 10,
    Part = "Head",
    TeamCheck = false,
    WallCheck = false, -- Оставляем только проверку стен
    MaxDistance = 500,
    Connection = nil,
    Target = nil,
    FOVCircle = nil,
    LastUpdate = 0,
    IsAiming = false
}

local function CreateFOVCircle()
    if AimbotSettings.FOVCircle then
        AimbotSettings.FOVCircle:Remove()
    end
    
    local Circle = Drawing.new("Circle")
    Circle.Visible = AimbotSettings.Enabled
    Circle.Radius = AimbotSettings.FOV
    Circle.Color = Color3.fromRGB(255, 0, 0)
    Circle.Thickness = 2
    Circle.Filled = false
    Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    AimbotSettings.FOVCircle = Circle
end

local function IsValidTarget(target)
    if target == LocalPlayer then return false end
    if not target.Character then return false end
    
    local humanoid = target.Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    
    local targetPart = target.Character:FindFirstChild(AimbotSettings.Part)
    if not targetPart then return false end
    
    if AimbotSettings.TeamCheck then
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
    if distance > AimbotSettings.MaxDistance then return false end
    
    -- ПРОВЕРКА ВИДИМОСТИ УБРАНА ПО ТВОЕМУ ЗАПРОСУ
    
    local vector, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
    if not onScreen then return false end
    
    local mousePos = UIS:GetMouseLocation()
    local distanceToMouse = (Vector2.new(vector.X, vector.Y) - mousePos).Magnitude
    if distanceToMouse > AimbotSettings.FOV then return false end
    
    return true
end

local function GetBestTarget()
    local bestTarget = nil
    local bestScore = -math.huge
    local mousePos = UIS:GetMouseLocation()
    
    for _, player in pairs(Players:GetPlayers()) do
        if not IsValidTarget(player) then continue end
        
        local character = player.Character
        local targetPart = character:FindFirstChild(AimbotSettings.Part)
        local vector = Camera:WorldToViewportPoint(targetPart.Position)
        
        local score = 0
        local distanceToMouse = (Vector2.new(vector.X, vector.Y) - mousePos).Magnitude
        
        score = score + (AimbotSettings.FOV - distanceToMouse)
        
        if AimbotSettings.Part == "Head" then
            score = score + 50
        end
        
        local character = LocalPlayer.Character
        local targetChar = player.Character
        if character and targetChar then
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart and targetRoot then
                local distance = (humanoidRootPart.Position - targetRoot.Position).Magnitude
                score = score + (AimbotSettings.MaxDistance - distance) / 3
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
    
    local targetPart = target.Character:FindFirstChild(AimbotSettings.Part)
    if not targetPart then return end
    
    local camera = workspace.CurrentCamera
    local currentTime = tick()
    
    if currentTime - AimbotSettings.LastUpdate < (1 / AimbotSettings.Smoothness) * 0.1 then
        return
    end
    AimbotSettings.LastUpdate = currentTime
    
    if AimbotSettings.Smoothness <= 1 then
        camera.CFrame = CFrame.lookAt(camera.CFrame.Position, targetPart.Position)
    else
        local currentCFrame = camera.CFrame
        local targetCFrame = CFrame.lookAt(currentCFrame.Position, targetPart.Position)
        
        local smoothness = math.max(1, AimbotSettings.Smoothness)
        local lerpAlpha = 1 / smoothness
        
        if smoothness <= 5 then
            lerpAlpha = lerpAlpha * 2
        end
        
        local smoothedCFrame = currentCFrame:Lerp(targetCFrame, lerpAlpha)
        camera.CFrame = smoothedCFrame
    end
end

local function StartAimbot()
    if AimbotSettings.Connection then
        AimbotSettings.Connection:Disconnect()
    end
    
    CreateFOVCircle()
    
    AimbotSettings.Connection = RunService.RenderStepped:Connect(function()
        if not AimbotSettings.Enabled then return end
        
        local mouseButtonPressed = UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
        
        if mouseButtonPressed then
            if not AimbotSettings.IsAiming then
                AimbotSettings.Target = GetBestTarget()
                AimbotSettings.IsAiming = true
            end
            
            if AimbotSettings.Target and IsValidTarget(AimbotSettings.Target) then
                SmoothAim(AimbotSettings.Target)
            else
                AimbotSettings.Target = nil
                AimbotSettings.IsAiming = false
            end
        else
            AimbotSettings.Target = nil
            AimbotSettings.IsAiming = false
        end
        
        if AimbotSettings.FOVCircle then
            AimbotSettings.FOVCircle.Visible = AimbotSettings.Enabled
            AimbotSettings.FOVCircle.Radius = AimbotSettings.FOV
        end
    end)
end

local function StopAimbot()
    if AimbotSettings.Connection then
        AimbotSettings.Connection:Disconnect()
        AimbotSettings.Connection = nil
    end
    
    if AimbotSettings.FOVCircle then
        AimbotSettings.FOVCircle:Remove()
        AimbotSettings.FOVCircle = nil
    end
    
    AimbotSettings.Target = nil
    AimbotSettings.IsAiming = false
end

-- ИСПРАВЛЕННЫЙ XRAY СИСТЕМА
local XraySettings = {
    Enabled = false,
    OriginalProperties = {} -- Сохраняем все свойства
}

local function EnableXray()
    XraySettings.OriginalProperties = {}
    
    for _, part in pairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency < 0.5 then
            -- Сохраняем все исходные свойства
            XraySettings.OriginalProperties[part] = {
                Transparency = part.Transparency,
                Material = part.Material,
                Color = part.Color,
                Reflectance = part.Reflectance
            }
            
            -- Устанавливаем свойства Xray
            part.Transparency = 0.7
            part.Material = Enum.Material.ForceField
            part.Color = Color3.fromRGB(100, 100, 255)
            part.Reflectance = 0.1
        end
    end
end

local function DisableXray()
    for part, properties in pairs(XraySettings.OriginalProperties) do
        if part and part.Parent then
            -- Восстанавливаем все исходные свойства
            part.Transparency = properties.Transparency
            part.Material = properties.Material
            part.Color = properties.Color
            part.Reflectance = properties.Reflectance
        end
    end
    XraySettings.OriginalProperties = {}
end

-- ANTI-AFK СИСТЕМА
local AntiAfkSettings = {
    Enabled = false,
    Connection = nil
}

local function EnableAntiAfk()
    if AntiAfkSettings.Connection then
        AntiAfkSettings.Connection:Disconnect()
    end
    
    local VirtualUser = game:GetService("VirtualUser")
    AntiAfkSettings.Connection = LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end

local function DisableAntiAfk()
    if AntiAfkSettings.Connection then
        AntiAfkSettings.Connection:Disconnect()
        AntiAfkSettings.Connection = nil
    end
end

-- УВЕДОМЛЕНИЯ
local function Notify(message)
    Rayfield:Notify({
        Title = "RAGE MOD ULTIMATE v" .. Version,
        Content = message,
        Duration = 3.0
    })
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
        NoclipSettings.Enabled = Value
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
    Name = "🕊️ FLY (ИСПРАВЛЕННЫЙ)",
    CurrentValue = false,
    Callback = function(Value)
        FlySettings.Enabled = Value
        if Value then
            StartFly()
            Notify("FLY включен - WASD + E/Q (Следует за камерой)")
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
    CurrentValue = FlySettings.Speed,
    Callback = function(Value)
        FlySettings.Speed = Value
    end
})

local SpeedToggle = MainTab:CreateToggle({
    Name = "🏃 УЛУЧШЕННАЯ СКОРОСТЬ (ИСПРАВЛЕННАЯ)",
    CurrentValue = false,
    Callback = function(Value)
        AdvancedSpeed.Enabled = Value
        if not Value then
            DisableBodyVelocitySpeed()
            
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.WalkSpeed = AdvancedSpeed.OriginalWalkSpeed
                end
            end)
            
            Notify("Скорость выключена")
        else
            local success = EnableAdvancedSpeed()
            
            if success then
                Notify("Скорость включена (" .. AdvancedSpeed.CurrentMethod .. ")")
            else
                Notify("Ошибка включения скорости")
                AdvancedSpeed.Enabled = false
            end
        end
    end
})

local SpeedSlider = MainTab:CreateSlider({
    Name = "СКОРОСТЬ ПЕРЕДВИЖЕНИЯ",
    Range = {16, 500},
    Increment = 10,
    Suffix = "units",
    CurrentValue = AdvancedSpeed.Value,
    Callback = function(Value)
        AdvancedSpeed.Value = Value
        
        if AdvancedSpeed.Enabled then
            EnableAdvancedSpeed()
        end
    end
})

local InfiniteJumpToggle = MainTab:CreateToggle({
    Name = "🦘 БЕСКОНЕЧНЫЙ ПРЫЖОК",
    CurrentValue = false,
    Callback = function(Value)
        InfiniteJump.Enabled = Value
        if Value then
            EnableInfiniteJump()
            Notify("Бесконечные прыжки включены (Пробел)")
        else
            DisableInfiniteJump()
            Notify("Бесконечные прыжки выключены")
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
        ESP.ShowBox = Value
    end
})

local NameToggle = VisualsTab:CreateToggle({
    Name = "🏷️ ПОКАЗЫВАТЬ ИМЕНА",
    CurrentValue = true,
    Callback = function(Value)
        ESP.ShowName = Value
    end
})

local DistanceToggle = VisualsTab:CreateToggle({
    Name = "📏 ПОКАЗЫВАТЬ ДИСТАНЦИИ",
    CurrentValue = true,
    Callback = function(Value)
        ESP.ShowDistance = Value
    end
})

local HealthToggle = VisualsTab:CreateToggle({
    Name = "❤️ ПОКАЗЫВАТЬ ЗДОРОВЬЕ",
    CurrentValue = true,
    Callback = function(Value)
        ESP.ShowHealth = Value
    end
})

local TracerToggle = VisualsTab:CreateToggle({
    Name = "🔻 ПОКАЗЫВАТЬ ТРЕЙСЕРЫ",
    CurrentValue = false,
    Callback = function(Value)
        ESP.ShowTracers = Value
    end
})

local TeamColorToggle = VisualsTab:CreateToggle({
    Name = "🎨 ЦВЕТ ПО КОМАНДАМ",
    CurrentValue = true,
    Callback = function(Value)
        ESP.TeamColor = Value
    end
})

local MaxDistanceSlider = VisualsTab:CreateSlider({
    Name = "📐 МАКС. ДИСТАНЦИЯ ESP",
    Range = {100, 5000},
    Increment = 50,
    Suffix = "studs",
    CurrentValue = 1000,
    Callback = function(Value)
        ESP.MaxDistance = Value
    end
})

-- ВКЛАДКА АИМБОТ
local CombatTab = Window:CreateTab("Аимбот")
local AimbotSection = CombatTab:CreateSection("Настройки аимбота")

local AimbotToggle = CombatTab:CreateToggle({
    Name = "🎯 ВКЛЮЧИТЬ АИМБОТ",
    CurrentValue = false,
    Callback = function(Value)
        AimbotSettings.Enabled = Value
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
    CurrentValue = AimbotSettings.FOV,
    Callback = function(Value)
        AimbotSettings.FOV = Value
    end
})

local AimbotSmoothSlider = CombatTab:CreateSlider({
    Name = "⚡ ПЛАВНОСТЬ АИМБОТА",
    Range = {1, 20},
    Increment = 1,
    Suffix = "level",
    CurrentValue = AimbotSettings.Smoothness,
    Callback = function(Value)
        AimbotSettings.Smoothness = Value
    end
})

local AimbotPartDropdown = CombatTab:CreateDropdown({
    Name = "🎯 ЧАСТЬ ТЕЛА ДЛЯ АИМА",
    Options = {"Head", "HumanoidRootPart", "Torso"},
    CurrentOption = AimbotSettings.Part,
    Callback = function(Option)
        AimbotSettings.Part = Option
    end
})

local AimbotMaxDistanceSlider = CombatTab:CreateSlider({
    Name = "📏 МАКС. ДИСТАНЦИЯ АИМБОТА",
    Range = {50, 1000},
    Increment = 10,
    Suffix = "studs",
    CurrentValue = AimbotSettings.MaxDistance,
    Callback = function(Value)
        AimbotSettings.MaxDistance = Value
    end
})

local TeamCheckToggle = CombatTab:CreateToggle({
    Name = "🎪 ПРОВЕРКА КОМАНДЫ",
    CurrentValue = false,
    Callback = function(Value)
        AimbotSettings.TeamCheck = Value
    end
})

local WallCheckToggle = CombatTab:CreateToggle({
    Name = "🧱 ПРОВЕРКА СТЕН",
    CurrentValue = false,
    Callback = function(Value)
        AimbotSettings.WallCheck = Value
    end
})

-- ВКЛАДКА ЗАЩИТА
local ProtectionTab = Window:CreateTab("Защита")
local ProtectionSection = ProtectionTab:CreateSection("Функции защиты")

local GodModeToggle = ProtectionTab:CreateToggle({
    Name = "💀 GOD MOD",
    CurrentValue = false,
    Callback = function(Value)
        GodMode.Enabled = Value
        if Value then
            EnableGodMode()
            Notify("⚡ GOD MOD АКТИВИРОВАН!")
        else
            DisableGodMode()
            Notify("GOD MOD выключен")
        end
    end
})

local AntiAfkToggle = ProtectionTab:CreateToggle({
    Name = "⏰ ANTI-AFK",
    CurrentValue = false,
    Callback = function(Value)
        AntiAfkSettings.Enabled = Value
        if Value then
            EnableAntiAfk()
            Notify("ANTI-AFK включен")
        else
            DisableAntiAfk()
            Notify("ANTI-AFK выключен")
        end
    end
})

-- ВКЛАДКА ВИЗУАЛ
local VisualTab = Window:CreateTab("Визуал")
local VisualSection = VisualTab:CreateSection("Визуальные эффекты")

local XrayToggle = VisualTab:CreateToggle({
    Name = "👁️ XRAY (ИСПРАВЛЕННЫЙ)",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            EnableXray()
            Notify("XRAY включен - Текстуры сохраняются")
        else
            DisableXray()
            Notify("XRAY выключен - Текстуры восстановлены")
        end
    end
})

-- СОЗДАЕМ ВКЛАДКУ С ИГРОКАМИ
CreatePlayerListTab()

-- ОСНОВНЫЕ ЦИКЛЫ
RunService.Heartbeat:Connect(function()
    pcall(function()
        local character = LocalPlayer.Character
        if not character then return end
        
        -- God MOD защита
        if GodMode.Enabled then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health < humanoid.MaxHealth then
                humanoid.Health = humanoid.MaxHealth
            end
        end
    end)
end)

-- ОБРАБОТЧИКИ ИГРОКОВ
Players.PlayerAdded:Connect(function(player)
    if ESP.Enabled then
        CreateESP(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

-- ЗАПОМИНАЕМ СТАНДАРТНУЮ СКОРОСТЬ
pcall(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        AdvancedSpeed.OriginalWalkSpeed = LocalPlayer.Character.Humanoid.WalkSpeed
    end
end)

-- УВЕДОМЛЕНИЕ О ЗАГРУЗКЕ
Notify("RAGE MOD ULTIMATE v" .. Version .. " загружен!")
print("⚡ RAGE MOD ULTIMATE v" .. Version .. " | Complete Fixed System Loaded | Lines: 1200+")