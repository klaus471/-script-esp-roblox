-- CONFIGURAÇÃO local FOV_RADIUS = 100 local SMOOTHNESS = 0.15 local AIM_KEY = Enum.UserInputType.MouseButton2

-- SERVIÇOS local uis = game:GetService("UserInputService") local rs = game:GetService("RunService") local players = game:GetService("Players") local cam = workspace.CurrentCamera local lp = players.LocalPlayer local mouse = lp:GetMouse()

-- SEGURANÇA local hasMouseMove = typeof(mousemoveabs) == "function" local hasDrawing = typeof(Drawing) == "table" and typeof(Drawing.new) == "function"

-- FOV CIRCLE local fovCircle if hasDrawing then fovCircle = Drawing.new("Circle") fovCircle.Color = Color3.fromRGB(0, 255, 0) fovCircle.Thickness = 1 fovCircle.Radius = FOV_RADIUS fovCircle.Filled = false fovCircle.Visible = true end

-- INTERFACE BÁSICA local screenGui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui")) screenGui.Name = "AimbotUI"

local toggleButton = Instance.new("TextButton") toggleButton.Parent = screenGui toggleButton.Size = UDim2.new(0, 100, 0, 30) toggleButton.Position = UDim2.new(0, 10, 0, 10) toggleButton.Text = "Aimbot: ON" toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50) toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255) toggleButton.BorderSizePixel = 0

local aimbotEnabled = true

toggleButton.MouseButton1Click:Connect(function() aimbotEnabled = not aimbotEnabled toggleButton.Text = "Aimbot: " .. (aimbotEnabled and "ON" or "OFF") end)

-- FUNÇÃO PARA PEGAR O INIMIGO MAIS PRÓXIMO local function getClosestTarget() local closest = nil local shortestDistance = FOV_RADIUS

for _, player in ipairs(players:GetPlayers()) do
    if player ~= lp and player.Team ~= lp.Team and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Humanoid") then
        local hrp = player.Character.HumanoidRootPart
        local humanoid = player.Character.Humanoid
        if humanoid.Health > 0 then
            local pos, onScreen = cam:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    closest = hrp
                end
            end
        end
    end
end

return closest

end

-- LOOP PRINCIPAL rs.RenderStepped:Connect(function() if fovCircle then fovCircle.Position = Vector2.new(mouse.X, mouse.Y) fovCircle.Visible = aimbotEnabled end

if aimbotEnabled and uis:IsMouseButtonPressed(AIM_KEY) then
    local target = getClosestTarget()
    if target then
        local pos = cam:WorldToViewportPoint(target.Position)
        if hasMouseMove then
            mousemoveabs(
                mouse.X + (pos.X - mouse.X) * SMOOTHNESS,
                mouse.Y + (pos.Y - mouse.Y) * SMOOTHNESS
            )
        end
    end
end

end)

-- SOM OPCIONAL (corrigido) local Sound = Instance.new("Sound", lp:WaitForChild("PlayerGui")) Sound.SoundId = "rbxassetid://12222216" -- som público Sound.Volume = 1 Sound:Play()

