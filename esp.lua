-- Klaus Hub ESP (Visual KRNL) - by Klaus

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

local espAtivo = false
local destaque = {}

-- GUI Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KlausHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Painel
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 220, 0, 120)
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

-- Arrastar Painel
local dragging = false
local dragStart, startPos
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)
frame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Arrastar Ícone
local draggingIcon = false
local iconStart, iconPos
icon.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingIcon = true
		iconStart = input.Position
		iconPos = icon.Position
	end
end)
icon.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingIcon = false
	end
end)
icon.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement and draggingIcon then
		local delta = input.Position - iconStart
		icon.Position = UDim2.new(iconPos.X.Scale, iconPos.X.Offset + delta.X,
			iconPos.Y.Scale, iconPos.Y.Offset + delta.Y)
	end
end)

-- Título
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Klaus Hub | ESP"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 18

-- Botão ESP
local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0.9, 0, 0, 50)
button.Position = UDim2.new(0.05, 0, 0.5, 0)
button.Text = "Ativar ESP"
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
button.Font = Enum.Font.Gotham
button.TextSize = 16
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

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
	frame.Visible = false
	icon.Visible = true
end)

icon.MouseButton1Click:Connect(function()
	frame.Visible = true
	icon.Visible = false
end)

-- ESP
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
	button.Text = espAtivo and "Desativar ESP" or "Ativar ESP"

	if espAtivo then
		for _, p in ipairs(Players:GetPlayers()) do
			if p.Character then
				criarESP(p)
			end
			p.CharacterAdded:Connect(function()
				wait(1)
				if espAtivo then
					criarESP(p)
				end
			end)
		end
	else
		for p, hl in pairs(destaque) do
			hl:Destroy()
		end
		destaque = {}
	end
end

button.MouseButton1Click:Connect(toggleESP)

Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function()
		wait(1)
		if espAtivo then
			criarESP(p)
		end
	end)
end)

Players.PlayerRemoving:Connect(function(p)
	if destaque[p] then
		destaque[p]:Destroy()
		destaque[p] = nil
	end
end)

