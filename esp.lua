--// Klaushub ESP + Aimbot v2 // --// Feito para "Cães da Guerra - Segunda Guerra Mundial" //

-- Serviços essenciais local Players = game:GetService("Players") local RunService = game:GetService("RunService") local Camera = workspace.CurrentCamera local LocalPlayer = Players.LocalPlayer local Mouse = LocalPlayer:GetMouse()

-- Configurações local FOV = 100 local Smoothness = 0.15

-- Variáveis de controle local aimbotAtivo = false local aimbotConnection = nil

-- Desenhar círculo de FOV local fovCircle = Drawing.new("Circle") fovCircle.Radius = FOV fovCircle.Thickness = 1 fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2) fovCircle.Color = Color3.fromRGB(0, 255, 255) fovCircle.Visible = false fovCircle.Filled = false

-- Função para encontrar o inimigo mais próximo no FOV local function GetClosestEnemy() local closest = nil local shortestDistance = FOV

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team then
        local char = player.Character
        if char and char:FindFirstChild("Head") then
            local pos, onScreen = Camera:WorldToViewportPoint(char.Head.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    closest = char.Head
                end
            end
        end
    end
end

return closest

end

-- Toggle do aimbot local function toggleAimbot() aimbotAtivo = not aimbotAtivo buttonAimbot.Text = aimbotAtivo and "Desativar Aimbot" or "Ativar Aimbot" fovCircle.Visible = aimbotAtivo

if aimbotAtivo then
    if aimbotConnection then
        aimbotConnection:Disconnect()
    end

    aimbotConnection = RunService.RenderStepped:Connect(function()
        local target = GetClosestEnemy()
        if target then
            local dir = (target.Position - Camera.CFrame.Position).Unit
            local newCFrame = CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Camera.CFrame.LookVector:Lerp(dir, Smoothness))
            Camera.CFrame = newCFrame
        end

        -- Proteção contra nil
        if Camera and Camera.ViewportSize then
            fovCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        end
    end)
else
    if aimbotConnection then
        aimbotConnection:Disconnect()
    end
    fovCircle.Visible = false
end

end

-- Interface Simples local ScreenGui = Instance.new("ScreenGui", game.CoreGui) local buttonAimbot = Instance.new("TextButton")

buttonAimbot.Size = UDim2.new(0, 140, 0, 30) buttonAimbot.Position = UDim2.new(0, 10, 0, 10) buttonAimbot.BackgroundColor3 = Color3.fromRGB(40, 40, 40) buttonAimbot.TextColor3 = Color3.new(1, 1, 1) buttonAimbot.Text = "Ativar Aimbot" buttonAimbot.Parent = ScreenGui

buttonAimbot.MouseButton1Click:Connect(toggleAimbot)

print("Klaushub ESP + Aimbot carregado!")

