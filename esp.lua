-- ESP Script do Klaus
-- Créditos: By Klaus (github.com/klaus471)

for i,v in pairs(game:GetService("Players"):GetPlayers()) do
    if v ~= game.Players.LocalPlayer then
        local esp = Instance.new("BillboardGui", v.Character:WaitForChild("Head"))
        esp.Size = UDim2.new(0, 100, 0, 40)
        esp.Adornee = v.Character.Head
        esp.AlwaysOnTop = true

        local name = Instance.new("TextLabel", esp)
        name.Text = v.Name
        name.Size = UDim2.new(1, 0, 1, 0)
        name.TextColor3 = Color3.fromRGB(255, 0, 0)
        name.BackgroundTransparency = 1
    end
end
