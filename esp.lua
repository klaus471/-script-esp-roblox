-- Klaus Hub ESP + Aimbot (Visual KRNL) - by Klaus

local Players = game:GetService("Players") local LocalPlayer = Players.LocalPlayer local UIS = game:GetService("UserInputService") local RunService = game:GetService("RunService") local Camera = workspace.CurrentCamera

-- ESP Variables local espAtivo = false local destaque = {}

-- Aimbot Variables local aimbotAtivo = false local Smoothness = 0.12 local FOV = 100

-- GUI Principal local ScreenGui = Instance.new("ScreenGui") ScreenGui.Name = "KlausHub" ScreenGui.ResetOnSpawn = false ScreenGui.Parent = game:GetService("CoreGui")

-- Painel local frame = Instance.new("Frame") frame.Name = "MainFrame" frame.Size = UDim2.new(0, 220, 0, 180) -- aumentei altura para dois botões frame.Position = UDim2.new(0, 50, 0, 100) frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25) frame.BorderSizePixel = 0 frame.BackgroundTransparency = 0.1 frame.Parent = ScreenGui Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Ícone minimizado local icon = Instance.new("ImageButton") icon.Name = "IconButton" icon.Size = UDim2.new(0, 50, 0, 50) icon.Position = UDim2.new(0, 10, 0, 100) icon.BackgroundColor3 = Color3.fromRGB(25, 25, 25) icon.BackgroundTransparency = 0.1 icon.Visible = false icon.Parent = ScreenGui icon.Image = "rbxassetid://7072720543" Instance.new("UICorner", icon).CornerRadius = UDim.new(0, 12)

-- Arrastar Painel / Ícone local function makeDraggable(gui) local dragging, dragStart, startPos gui.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = input.Position startPos = gui.Position end end) gui.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end) gui.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then local delta = input.Position - dragStart gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end) end makeDraggable(frame) makeDraggable(icon)

-- Título local title = Instance.new("TextLabel", frame) title.Size = UDim2.new(1, 0, 0, 30) title.Position = UDim2.new(0, 0, 0, 0) title.Text = "Klaus Hub | ESP & Aimbot" title.TextColor3 = Color3.fromRGB(255, 255, 255) title.BackgroundTransparency = 1 title.Font = Enum.Font.GothamBold title.TextSize = 18

-- Botão ESP local buttonESP = Instance.new("TextButton", frame) buttonESP.Size = UDim2.new(0.9, 0, 0, 50) buttonESP.Position = UDim2.new(0.05, 0, 0.25, 0) buttonESP.Text = "Ativar ESP" buttonESP.TextColor3 = Color3.fromRGB(255, 255, 255) buttonESP.BackgroundColor3 = Color3.fromRGB(45, 45, 45) buttonESP.Font = Enum.Font.Gotham buttonESP.TextSize = 16 Instance.new("UICorner", buttonESP).CornerRadius = UDim.new(0, 8)

-- Botão Aimbot local buttonAim = Instance.new("TextButton", frame) buttonAim.Size = UDim2.new(0.9, 0, 0, 50) buttonAim.Position = UDim2.new(0.05, 0, 0.6, 0) buttonAim.Text = "Ativar Aimbot" buttonAim.TextColor3 = Color3.fromRGB(255, 255, 255) buttonAim.BackgroundColor3 = Color3.fromRGB(45, 45, 45) buttonAim.Font = Enum.Font.Gotham buttonAim.TextSize = 16 Instance.new("UICorner", buttonAim).CornerRadius = UDim.new(0, 8)

-- Botão minimizar local btnMinimize = Instance.new("TextButton", frame) btnMinimize.Size = UDim2.new(0, 30, 0, 25) btnMinimize.Position = UDim2.new(1, -35, 0, 5) btnMinimize.Text = "—" btnMinimize.TextColor3 = Color3.fromRGB(255, 255, 255) btnMinimize.BackgroundColor3 = Color3.fromRGB(60, 60, 60) btnMinimize.Font = Enum.Font.GothamBold btnMinimize.TextSize = 20 Instance.new("UICorner", btnMinimize).CornerRadius = UDim.new(0, 8) btnMinimize.MouseButton1Click:Connect(function() frame.Visible = false icon.Visible = true end) icon.MouseButton1Click:Connect(function() frame.Visible = true icon.Visible = false end)

-- ESP Functions local function criarESP(p) if p == LocalPlayer or not p.Character or not p.Character:FindFirstChild("Head") then return end if destaque[p] and destaque[p]:IsDescendantOf(p.Character) then return end local hl = Instance.new("Highlight") hl.Name = "ESP_Highlight" hl.Adornee = p.Character hl.FillTransparency = 0.8 hl.OutlineTransparency = 0.1 hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop if p.Team == LocalPlayer.Team then hl.FillColor = Color3.fromRGB(0, 150, 255) hl.OutlineColor = Color3.fromRGB(0, 100, 200) else hl.FillColor = Color3.fromRGB(255, 0, 0) hl.OutlineColor = Color3.fromRGB(150, 0, 0) end hl.Parent = p.Character destaque[p] = hl end

local function toggleESP() espAtivo = not espAtivo buttonESP.Text = espAtivo and "Desativar ESP" or "Ativar ESP" if espAtivo then for _, p in ipairs(Players:GetPlayers()) do criarESP(p) p.CharacterAdded:Connect(function() task.wait(1) if espAtivo then criarESP(p) end end) end else for _, hl in pairs(destaque) do hl:Destroy() end destaque = {} end end buttonESP.MouseButton1Click:Connect(toggleESP) Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function() task.wait(1) if espAtivo then criarESP(p) end end) end) Players.PlayerRemoving:Connect(function(p) if destaque[p] then destaque[p]:Destroy() destaque[p]=nil end end)

-- Aimbot Functions local hasMouseMove = typeof(mousemoveabs)=="function" local hasDrawing = typeof(Drawing)=="table" and typeof(Drawing.new)=="function"

-- Create FOV circle local fovCircle if hasDrawing then fovCircle = Drawing.new("Circle") fovCircle.Radius = FOV fovCircle.Thickness = 1 fovCircle.Color = Color3.fromRGB(255,255,0) fovCircle.Filled = false fovCircle.Visible = false end

local function getClosestEnemy() local closest, shortest = nil, FOV local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2) for _, pl in pairs(Players:GetPlayers()) do if pl~=LocalPlayer and pl.Team~=LocalPlayer.Team and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then local pos,on = Camera:WorldToViewportPoint(pl.Character.HumanoidRootPart.Position) if on then local dist=(Vector2.new(pos.X,pos.Y)-center).Magnitude if dist<shortest then shortest,closest=dist,pl.Character.HumanoidRootPart end end end end return closest end

local aimConn local function toggleAimbot() aimbotAtivo = not aimbotAtivo buttonAim.Text = aimbotAtivo and "Desativar Aimbot" or "Ativar Aimbot" if fovCircle then fovCircle.Visible=aimbotAtivo end if aimConn then aimConn:Disconnect() end if aimbotAtivo then aimConn = RunService.RenderStepped:Connect(function() if fovCircle then fovCircle.Position=Vector2.new(Camera.ViewportSize.X/2,Camera.ViewportSize.Y/2) end local target = getClosestEnemy() if target and hasMouseMove then local pos=Camera:WorldToViewportPoint(target.Position) mousemoveabs( (Camera.ViewportSize.X/2)+(pos.X-(Camera.ViewportSize.X/2))*Smoothness, (Camera.ViewportSize.Y/2)+(pos.Y-(Camera.ViewportSize.Y/2))*Smoothness ) end end) end end buttonAim.MouseButton1Click:Connect(toggleAimbot)

