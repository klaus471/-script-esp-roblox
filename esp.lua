--[[
ESP Script (By Klaus)
enzo da o rabo (Mobile e PC)
--]]

local players = game:GetService("Players")
local localPlayer = players.LocalPlayer

-- Criar GUI principal
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "ESP_GUI"

-- Botão de abrir/fechar menu
local toggleMenu = Instance.new("TextButton", ScreenGui)
toggleMenu.Size = UDim2.new(0, 100, 0, 30)
toggleMenu.Position = UDim2.new(0, 10, 0, 10)
toggleMenu.Text = "☰ ESP Menu"
toggleMenu.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleMenu.TextColor3 = Color3.new(1,1,1)
toggleMenu.BorderSizePixel = 0

-- Painel principal
local mainFrame = Instance.new("Frame", ScreenGui)
mainFrame.Size = UDim2.new(0, 200, 0, 100)
mainFrame.Position = UDim2.new(0, 10, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Visible = false
mainFrame.BorderSizePixel = 0

-- Botão de ativar/desativar ESP
local espButton = Instance.new("TextButton", mainFrame)
espButton.Size = UDim2.new(1, -20, 0, 40)
espButton.Position = UDim2.new(0, 10, 0, 10)
espButton.Text = "Ativar ESP"
espButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
espButton.TextColor3 = Color3.new(1,1,1)
espButton.BorderSizePixel = 0

-- Variável de controle
local espAtivo = false
local destaques = {}

-- Função para criar ESP
local function criarESP(player)
    if player == localPlayer then return end
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end

    local highlight = Instance.new("Highlight", player.Character)
    highlight.Name = "ESP_Highlight"
    highlight.FillTransparency = 0.75
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    if player.Team == localPlayer.Team then
        highlight.FillColor = Color3.fromRGB(0, 100, 255) -- azul
        highlight.OutlineColor = Color3.fromRGB(0, 0, 150)
    else
        highlight.FillColor = Color3.fromRGB(255, 0, 0) -- vermelho
        highlight.OutlineColor = Color3.fromRGB(100, 0, 0)
    end

    destaques[player] = highlight
end

-- Função para remover ESP
local function removerESP(player)
    if destaques[player] then
        destaques[player]:Destroy()
        destaques[player] = nil
    end
end

-- Ativar ou desativar ESP
local function toggleESP()
    espAtivo = not espAtivo
    espButton.Text = espAtivo and "Desativar ESP" or "Ativar ESP"

    for _, player in ipairs(players:GetPlayers()) do
        if espAtivo then
            criarESP(player)
        else
            removerESP(player)
        end
    end
end

-- Atualizar ao entrar/renascer
players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        if espAtivo then task.wait(1) criarESP(p) end
    end)
end)

-- Clique dos botões
toggleMenu.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

espButton.MouseButton1Click:Connect(toggleESP)
