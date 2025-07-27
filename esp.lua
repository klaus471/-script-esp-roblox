-- Klaus Hub ESP (Visual KRNL) - by Klaus

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local espAtivo = false
local destaque = {}

-- Tela
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KlausHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Painel com draggability manual
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 220, 0, 120)
frame.Position = UDim2.new(0, 50, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0.1
frame.Parent = ScreenGui

local uicorner = Instance.new("UICorner", frame)
uicorner.CornerRadius = UDim.new(0, 12)

-- Arrastar manual via UserInputService
local UIS = game:GetService("UserInputService")
local dragging = false
local dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
        if dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                        startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end
end)

-- Título
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Klaus Hub | ESP"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- Botão ESP
local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0.9, 0, 0, 50)
button.Position = UDim2.new(0.05, 0, 0.5, 0)
button.Text = "Ativar ESP"
button.TextColor3 = Color3.fromRGB(255,255,255)
button.BackgroundColor3 = Color3.fromRGB(45,45,45)
button.Font = Enum.Font.Gotham
button.TextSize = 16
local bc = Instance.new("UICorner", button)
bc.CornerRadius = UDim.new(0, 8)

-- Lógica ESP (idéia original mantida)
local function criarESP(p)
    if p == LocalPlayer or not p.Character or not p.Character:FindFirstChild("Head") then return end
    if destaque[p] then return end
    local hl = Instance.new("Highlight")
    hl.Name = "ESP_Highlight"
    hl.Adornee = p.Character
    hl.FillTransparency = 0.8
    hl.OutlineTransparency = 0.1
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    if p.Team == LocalPlayer.Team then
        hl.FillColor = Color3.fromRGB(0,150,255)
        hl.OutlineColor = Color3.fromRGB(0,100,200)
    else
        hl.FillColor = Color3.fromRGB(255,0,0)
        hl.OutlineColor = Color3.fromRGB(150,0,0)
    end
    hl.Parent = p.Character
    destaque[p] = hl
end

local function removerESP()
    for p,hl in pairs(destaque) do
        hl:Destroy()
    end
    destaque = {}
end

local function toggleESP()
    espAtivo = not espAtivo
    button.Text = espAtivo and "Desativar ESP" or "Ativar ESP"
    if espAtivo then
        for _,p in ipairs(Players:GetPlayers()) do criarESP(p) end
    else
        removerESP()
    end
end

button.MouseButton1Click:Connect(toggleESP)

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        wait(1)
        if espAtivo then criarESP(p) end
    end)
end)

Players.PlayerRemoving:Connect(function(p)
    if destaque[p] then destaque[p]:Destroy(); destaque[p]=nil end
end)
