-- RAGE MOD - ULTIMATE VERSION WITH FIXED AIMBOT
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

-- УЛУЧШЕННАЯ СИСТЕМА СКОРОСТИ С АВТОМАТИЧЕСКИМ АНТИ-ДЕТЕКТОМ
local AdvancedSpeed = {
    Enabled = false,
    Value = 50,
    CurrentMethod = "Auto",
    BodyVelocity = nil,
    Connection = nil,
    OriginalWalkSpeed = 16,
    LastMethodCheck = 0,
    MethodCheckInterval = 5,
    SafeMethods = {}
}

local function DetectSafeMethods()
    AdvancedSpeed.SafeMethods = {
        Humanoid = true,
        BodyVelocity = true,
        Tween = true
    }
    
    local antiCheatDetected = false
    for _, service in pairs(game:GetChildren()) do
        if string.find(service.Name:lower(), "anti") or string.find(service.Name:lower(), "cheat") then
            antiCheatDetected = true
            break
        end
    end
    
    if antiCheatDetected then
        AdvancedSpeed.SafeMethods.BodyVelocity = false
        AdvancedSpeed.SafeMethods.Tween = false
    end
    
    return AdvancedSpeed.SafeMethods
end

local function GetBestSpeedMethod()
    local methods = DetectSafeMethods()
    
    if methods.BodyVelocity then
        return "BodyVelocity"
    elseif methods.Tween then
        return "Tween"
    else
        return "Humanoid"
    end
end

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
        AdvancedSpeed.BodyVelocity.MaxForce = Vector3.new(
            math.random(9000, 11000), 
            0, 
            math.random(9000, 11000)
        )
        AdvancedSpeed.BodyVelocity.P = math.random(1200, 1300)
        
        local randomNames = {"VelocityHelper", "MoveAssist", "PlayerHelper", "GameComponent"}
        AdvancedSpeed.BodyVelocity.Name = randomNames[math.random(1, #randomNames)]
        
        AdvancedSpeed.BodyVelocity.Parent = humanoidRootPart
        
        if humanoidRootPart:FindFirstChildOfClass("NetworkOwner") then
            AdvancedSpeed.BodyVelocity.Parent = humanoidRootPart:FindFirstChildOfClass("NetworkOwner")
        end
    end)

    if not success then
        AdvancedSpeed.SafeMethods.BodyVelocity = false
        return false
    end

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
            
            local randomFactor = Vector3.new(
                moveDirection.X * math.random(95, 105) / 100,
                0,
                moveDirection.Z * math.random(95, 105) / 100
            )
            
            AdvancedSpeed.BodyVelocity.Velocity = randomFactor
        else
            AdvancedSpeed.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)
    
    return true
end

local function EnableTweenSpeed()
    local character = LocalPlayer.Character
    if not character then return false end

    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false end

    AdvancedSpeed.Connection = RunService.Heartbeat:Connect(function()
        if not AdvancedSpeed.Enabled then return end
        
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
            
            local targetPosition = humanoidRootPart.Position + moveDirection * 0.1
            local tweenInfo = TweenInfo.new(
                0.1,
                Enum.EasingStyle.Linear,
                Enum.EasingDirection.Out,
                0,
                false,
                0
            )
            
            local tween = TweenService:Create(humanoidRootPart, tweenInfo, {Position = targetPosition})
            tween:Play()
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
            
            local randomSpeed = AdvancedSpeed.Value * math.random(98, 102) / 100
            humanoid.WalkSpeed = randomSpeed
            
            if math.random(1, 100) == 1 then
                humanoid.WalkSpeed = AdvancedSpeed.OriginalWalkSpeed
                wait(0.05)
                humanoid.WalkSpeed = randomSpeed
            end
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
    
    local bestMethod = GetBestSpeedMethod()
    AdvancedSpeed.CurrentMethod = bestMethod
    
    local success = false
    
    if bestMethod == "BodyVelocity" then
        success = EnableBodyVelocitySpeed()
        if not success then
            bestMethod = GetBestSpeedMethod()
            if bestMethod == "Tween" then
                success = EnableTweenSpeed()
            else
                success = EnableHumanoidSpeed()
            end
        end
    elseif bestMethod == "Tween" then
        success = EnableTweenSpeed()
        if not success then
            success = EnableHumanoidSpeed()
        end
    else
        success = EnableHumanoidSpeed()
    end
    
    if success then
        AdvancedSpeed.CurrentMethod = bestMethod
        Notify("Скорость включена (" .. bestMethod .. " метод)")
    else
        Notify("Ошибка включения скорости")
    end
    
    return success
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
        TeamCheck = true,
        VisibleCheck = true,
        Prediction = false,
        PredictionAmount = 0.1,
        MaxDistance = 500,
        WallCheck = true,
        Priority = "Closest"
    }
}

-- Уведомления
local function Notify(message)
    Rayfield:Notify({
        Title = "RAGE MOD ULTIMATE",
        Content = message,
        Duration = 2.5
    })
end

-- Телепорт на курсор
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

local function IsValidTarget(target)
    if target == LocalPlayer then return false end
    if not target.Character then return false end
    
    local humanoid = target.Character:FindFirstChild("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    
    local targetPart = target.Character:FindFirstChild(Settings.Aimbot.Part)
    if not targetPart then return false end
    
    if not IsEnemy(target) then return false end
    if not IsInRange(target) then return false end
    if not IsTargetVisible(target) then return false end
    
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
        
        local humanoid = targetChar:FindFirstChild("Humanoid")
        if humanoid then
            local healthPercent = humanoid.Health / humanoid.MaxHealth
            if healthPercent < 0.3 then
                score = score + 40
            elseif healthPercent < 0.6 then
                score = score + 20
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

-- ESP система (остается без изменений)
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
                
                if Settings.Esp.ShowBox then
                    box.Size = size
                    box.Position = Vector2.new(position.X - size.X / 2, position.Y - size.Y / 2)
                    box.Visible = true
                    
                    if player == Aimbot.Target and Settings.Aimbot.Enabled then
                        box.Color = Color3.fromRGB(255, 0, 0)
                    elseif Settings.Aimbot.Enabled and Settings.Esp.ShowAimbotStatus then
                        if IsValidTarget(player) then
                            box.Color = Color3.fromRGB(0, 255, 0)
                        else
                            box.Color = Color3.fromRGB(0, 100, 255)
                        end
                    else
                        if Settings.Esp.TeamColor and player.Team then
                            box.Color = player.Team.TeamColor.Color
                        else
                            box.Color = Settings.Esp.BoxColor
                        end
                    end
                else
                    box.Visible = false
                end
                
                if Settings.Esp.ShowName then
                    local name = Settings.Esp.Names[player]
                    name.Position = Vector2.new(position.X, position.Y - size.Y / 2 - 20)
                    name.Visible = true
                else
                    Settings.Esp.Names[player].Visible = false
                end
                
                if Settings.Esp.ShowDistance then
                    local distanceText = Settings.Esp.Distances[player]
                    distanceText.Text = math.floor(distance) .. " studs"
                    distanceText.Position = Vector2.new(position.X, position.Y - size.Y / 2 - 40)
                    distanceText.Visible = true
                else
                    Settings.Esp.Distances[player].Visible = false
                end
                
                if Settings.Esp.ShowHealth and humanoid then
                    local healthPercent = humanoid.Health / humanoid.MaxHealth
                    local healthBar = Settings.Esp.HealthBars[player]
                    local healthText = Settings.Esp.HealthTexts[player]
                    
                    local barWidth = 3
                    local barHeight = size.Y * healthPercent
                    local barX = position.X - size.X / 2 - 8
                    local barY = position.Y + size.Y / 2 - barHeight
                    
                    healthBar.Size = Vector2.new(barWidth, barHeight)
                    healthBar.Position = Vector2.new(barX, barY)
                    healthBar.Visible = true
                    
                    if healthPercent > 0.7 then
                        healthBar.Color = Color3.fromRGB(0, 255, 0)
                    elseif healthPercent > 0.3 then
                        healthBar.Color = Color3.fromRGB(255, 255, 0)
                    else
                        healthBar.Color = Color3.fromRGB(255, 0, 0)
                    end
                    
                    healthText.Text = tostring(math.floor(humanoid.Health))
                    healthText.Position = Vector2.new(barX - 15, barY + barHeight / 2 - 7)
                    healthText.Visible = true
                else
                    Settings.Esp.HealthBars[player].Visible = false
                    Settings.Esp.HealthTexts[player].Visible = false
                end
                
                if Settings.Esp.ShowAimbotStatus and Settings.Aimbot.Enabled then
                    local aimbotStatus = Settings.Esp.AimbotStatus[player]
                    aimbotStatus.Position = Vector2.new(position.X, position.Y + size.Y / 2 + 25)
                    
                    if player == Aimbot.Target then
                        aimbotStatus.Text = "🔒"
                        aimbotStatus.Color = Color3.fromRGB(255, 0, 0)
                    elseif IsValidTarget(player) then
                        aimbotStatus.Text = "🎯"
                        aimbotStatus.Color = Color3.fromRGB(0, 255, 0)
                    else
                        aimbotStatus.Text = "🚫"
                        aimbotStatus.Color = Color3.fromRGB(255, 0, 0)
                    end
                    aimbotStatus.Visible = true
                else
                    Settings.Esp.AimbotStatus[player].Visible = false
                end
                
                if Settings.Esp.ShowTracers then
                    local tracer = Settings.Esp.Tracers[player]
                    tracer.From = screenCenter
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

-- Система полета
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

-- Ноклип
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

-- Интерфейс
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
                Notify("Скорость включена (" .. AdvancedSpeed.CurrentMethod .. ")")
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

-- Вкладка ESP
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

-- Вкладка Аимбот (ИСПРАВЛЕННАЯ)
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

-- Вкладка Защита
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

-- Основные циклы
RunService.Heartbeat:Connect(function()
    pcall(function()
        local character = LocalPlayer.Character
        if not character then return end
        
        local currentTime = tick()
        if currentTime - AdvancedSpeed.LastMethodCheck > AdvancedSpeed.MethodCheckInterval then
            AdvancedSpeed.LastMethodCheck = currentTime
            
            if Settings.Speed.Enabled then
                local bestMethod = GetBestSpeedMethod()
                if bestMethod ~= AdvancedSpeed.CurrentMethod then
                    AdvancedSpeed.CurrentMethod = bestMethod
                    EnableAdvancedSpeed()
                end
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

-- Запоминаем стандартную скорость
pcall(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        AdvancedSpeed.OriginalWalkSpeed = LocalPlayer.Character.Humanoid.WalkSpeed
    end
end)

DetectSafeMethods()

Notify("RAGE MOD ULTIMATE с исправленным аимботом загружен!")
print("RAGE MOD ULTIMATE: Аимбот фиксируется на цели только при зажатой ПКМ")