-- ESP Script com Painel Minimalista (By Klaus)
-- Funciona em celular e PC. Aliado = azul, inimigo = vermelho.

local espAtivo = false

-- Interface
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ESP_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 140, 0, 60)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 0
mainFrame.BackgroundTransparency = 0.2
mainFrame.Parent = ScreenGui
mainFrame.Active = true
mainFrame.Draggable = true

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -20, 0, 40)
button.Position = UDim2.new(0, 10, 0, 10)
button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.GothamBold
button.TextSize = 14
button.Text = "ESP [OFF]"
button.Parent = mainFrame

local highlights = {}

-- Função para criar ESP
local function criarESP(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Head") then
        local hl = Instance.new("Highlight")
        hl.Name = "ESP_Highlight"
        hl.Adornee = player.Character
        hl.FillTransparency = 0.8
        hl.OutlineTransparency = 0.1
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = player.Character

        local isAlly = player.Team == game.Players.LocalPlayer.Team
        if isAlly then
            hl.FillColor = Color3.fromRGB(0, 150, 255) -- Azul
            hl.OutlineColor = Color3.fromRGB(0, 100, 200)
        else
            hl.FillColor = Color3.fromRGB(255, 0, 0) -- Vermelho
            hl.OutlineColor = Color3.fromRGB(150, 0, 0)
        end

        highlights[player] = hl
    end
end

-- Função para remover ESP
local function removerESP(player)
    if highlights[player] then
        highlights[player]:Destroy()
        highlights[player] = nil
    end
end

-- Ativar/Desativar
local function toggleESP()
    espAtivo = not espAtivo
    button.Text = espAtivo and "ESP [ON]" or "ESP [OFF]"

    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            if espAtivo then
                criarESP(player)
            else
                removerESP(player)
            end
        end
    end
end

-- Clique no botão ativa/desativa
button.MouseButton1Click:Connect(toggleESP)

-- Atualizar ESP se players entrarem/sair
game.Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if espAtivo then
            wait(1)
            criarESP(player)
        end
    end)
end)

game.Players.PlayerRemoving:Connect(function(player)
    removerESP(player)
end)

-- Inicial
for _, player in pairs(game.Players:GetPlayers()) do
    if player ~= game.Players.LocalPlayer and player.Character then
        player.CharacterAdded:Connect(function()
            if espAtivo then
                wait(1)
                criarESP(player)
            end
        end)
    end
end
