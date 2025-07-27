-- Klaus Hub ESP - enzo da o rabo| By Klaus (github.com/klaus471)

-- Criar UI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")

-- Config UI
ScreenGui.Name = "KlausHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.75, -100, 0.3, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 120)
MainFrame.BorderSizePixel = 0
MainFrame.BackgroundTransparency = 0.1

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Klaus Hub - ESP"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BorderSizePixel = 0

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleButton.Position = UDim2.new(0.1, 0, 0.5, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0.3, 0)
ToggleButton.Text = "Ativar ESP"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Font = Enum.Font.Gotham
ToggleButton.TextSize = 14
ToggleButton.BorderSizePixel = 0

-- ESP Funcionalidade
local ESP_Ativado = false
local ESP_Objs = {}

function CriarESP(player)
    if player == game.Players.LocalPlayer then return end
    local char = player.Character
    if not char or not char:FindFirstChild("Head") then return end

    local esp = Instance.new("BoxHandleAdornment")
    esp.Size = Vector3.new(3, 6, 1)
    esp.Name = "ESP_Box"
    esp.Adornee = char
    esp.AlwaysOnTop = true
    esp.ZIndex = 5
    esp.Transparency = 0.5
    esp.Color3 = (player.Team == game.Players.LocalPlayer.Team) and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(255, 0, 0)
    esp.Parent = char:FindFirstChild("Head")

    table.insert(ESP_Objs, esp)
end

function AtivarESP()
    for _, p in pairs(game.Players:GetPlayers()) do
        CriarESP(p)
    end

    game.Players.PlayerAdded:Connect(function(p)
        p.CharacterAdded:Connect(function()
            wait(1)
            CriarESP(p)
        end)
    end)
end

function DesativarESP()
    for _, obj in pairs(ESP_Objs) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end
    ESP_Objs = {}
end

-- Botão funcional
ToggleButton.MouseButton1Click:Connect(function()
    ESP_Ativado = not ESP_Ativado
    if ESP_Ativado then
        ToggleButton.Text = "Desativar ESP"
        AtivarESP()
    else
        ToggleButton.Text = "Ativar ESP"
        DesativarESP()
    end
end)

