-- Klaus Hub ESP + Trigger Bot (Visual KRNL) - by Klaus

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = workspace.CurrentCamera

-- ESP Variables
local espAtivo = false
local destaque = {}

-- Trigger Variables
local triggerAtivo = false
local triggerConnection = nil
local TRIGGER_FOV = 100 -- alcance para trigger

-- RemoteEvent de disparo (substitua pelo nome correto)
local shootEvent = ReplicatedStorage:WaitForChild("RemoteEventName")

-- GUI Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KlausHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Painel
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 220, 0, 200) -- altura ajustada
frame.Position = UDim2.new(0, 50, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.1
frame.Parent = ScreenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Ícone minimizado
local icon = Instance.new("ImageButton")
icon.Name = "IconButton"
icon.Size = UDim2.new(0, 50, 0, 50)
icon.Position = UDim2.new(0, 10, 0, 100)
icon.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
icon.BackgroundTransparency = 0.1
icon.Visible = false
icon.Parent = ScreenGui
icon.Image = "rbxassetid://7072720543"
Instance.new("UICorner", icon).CornerRadius = UDim.new(0, 12)

-- Draggable helper
local function makeDraggable(gui)
    local dragging, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
        end
    end)
    gui.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
makeDraggable(frame)
makeDraggable(icon)

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Klaus Hub | ESP & Trigger"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- Botão ESP
local buttonESP = Instance.new("TextButton", frame)
buttonESP.Size = UDim2.new(0.9, 0, 0, 40)
buttonESP.Position = UDim2.new(0.05, 0, 0.25, 0)
buttonESP.Text = "Ativar ESP"
buttonESP.TextColor3 = Color3.fromRGB(255, 255, 255)
buttonESP.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
buttonESP.Font = Enum.Font.Gotham
buttonESP.TextSize = 16
Instance.new("UICorner", buttonESP).CornerRadius = UDim.new(0, 8)

-- Botão Trigger
local buttonTrigger = Instance.new("TextButton", frame)
buttonTrigger.Size = UDim2.new(0.9, 0, 0, 40)
buttonTrigger.Position = UDim2.new(0.05, 0, 0.55, 0)
buttonTrigger.Text = "Ativar Trigger"
buttonTrigger.TextColor3 = Color3.fromRGB(255, 255, 255)
buttonTrigger.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
buttonTrigger.Font = Enum.Font.Gotham
buttonTrigger.TextSize = 16
Instance.new("UICorner", buttonTrigger).CornerRadius = UDim.new(0, 8)

-- Botão minimizar
local btnMinimize = Instance.new("TextButton", frame)
btnMinimize.Size = UDim2.new(0, 30, 0, 25)
btnMinimize.Position = UDim2.new(1, -35, 0, 5)
btnMinimize.Text = "—"
btnMinimize.TextColor3 = Color3.fromRGB(255, 255, 255)
btnMinimize.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
btnMinimize.Font = Enum.Font.GothamBold
btnMinimize.TextSize = 20
Instance.new("UICorner", btnMinimize).CornerRadius = UDim.new(0, 8)
btnMinimize.MouseButton1Click:Connect(function()
    frame.Visible = false icon.Visible = true
end)
icon.MouseButton1Click:Connect(function()
    frame.Visible = true icon.Visible = false
end)

-- ESP Logic
local function criarESP(p)
    if p == LocalPlayer or not p.Character or not p.Character:FindFirstChild("Head") then return end
    if destaque[p] and destaque[p]:IsDescendantOf(p.Character) then return end
    local hl = Instance.new("Highlight")
    hl.Name = "ESP_Highlight"
    hl.Adornee = p.Character
    hl.FillTransparency = 0.8
    hl.OutlineTransparency = 0.1
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    if p.Team == LocalPlayer.Team then
        hl.FillColor = Color3.fromRGB(0, 150, 255)
        hl.OutlineColor = Color3.fromRGB(0, 100, 200)
    else
        hl.FillColor = Color3.fromRGB(255, 0, 0)
        hl.OutlineColor = Color3.fromRGB(150, 0, 0)
    end
    hl.Parent = p.Character
destaque[p] = hl
end

local function toggleESP()
    espAtivo = not espAtivo
    buttonESP.Text = espAtivo and "Desativar ESP" or "Ativar ESP"
    if espAtivo then
        for _, p in ipairs(Players:GetPlayers()) do
            criarESP(p)
            p.CharacterAdded:Connect(function() task.wait(1) if espAtivo then criarESP(p) end end)
        end
    else
        for _, hl in pairs(destaque) do hl:Destroy() end
destaque = {}
    end
end
buttonESP.MouseButton1Click:Connect(toggleESP)

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function() task.wait(1) if espAtivo then criarESP(p) end end)
end)
Players.PlayerRemoving:Connect(function(p) if destaque[p] then destaque[p]:Destroy() destaque[p]=nil end end)

-- Trigger Logic
local function getClosestTarget()
    local closest, shortest = nil, TRIGGER_FOV
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl~=LocalPlayer and pl.Team~=LocalPlayer.Team and pl.Character and pl.Character:FindFirstChild("Head") then
            local pos, onScreen = Camera:WorldToViewportPoint(pl.Character.Head.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                if dist<shortest then shortest,closest=dist,pl.Character.Head end
            end
        end
    end
    return closest
end

local function toggleTrigger()
    triggerAtivo = not triggerAtivo
    buttonTrigger.Text = triggerAtivo and "Desativar Trigger" or "Ativar Trigger"
    if triggerConnection then triggerConnection:Disconnect() end
    if triggerAtivo then
        triggerConnection = RunService.RenderStepped:Connect(function()
            local target = getClosestTarget()
            if target then
                shootEvent:FireServer(target.Position)
            end
        end)
    end
end
buttonTrigger.MouseButton1Click:Connect(toggleTrigger)
