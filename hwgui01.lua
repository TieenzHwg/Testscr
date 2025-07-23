local Players = game:GetService("Players") local LocalPlayer = Players.LocalPlayer local mouse = LocalPlayer:GetMouse()

local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui")) ScreenGui.Name = "Y44IGUI"

local mainFrame = Instance.new("Frame", ScreenGui) mainFrame.Size = UDim2.new(0, 400, 0, 370) mainFrame.Position = UDim2.new(0, 200, 0, 200) mainFrame.BackgroundColor3 = Color3.new(0, 0, 0) mainFrame.BorderColor3 = Color3.new(1, 0, 0) mainFrame.Active = true mainFrame.Draggable = true

local collapsed = false

local function createButton(text, size, pos, parent) local btn = Instance.new("TextButton", parent) btn.Size = size btn.Position = pos btn.BackgroundColor3 = Color3.new(0, 0, 0) btn.TextColor3 = Color3.new(1, 1, 1) btn.Text = text btn.BorderColor3 = Color3.new(1, 0, 0) btn.Font = Enum.Font.SourceSans btn.TextSize = 18 return btn end

local toggleSpeed = true local speed = 25

local speedButton = createButton("speed🟢", UDim2.new(0, 90, 0, 30), UDim2.new(0, 5, 0, 5), mainFrame) local speedMinus = createButton("-", UDim2.new(0, 30, 0, 30), UDim2.new(0, 100, 0, 5), mainFrame) local speedValue = createButton("25", UDim2.new(0, 40, 0, 30), UDim2.new(0, 135, 0, 5), mainFrame) speedValue.AutoButtonColor = false local speedPlus = createButton("+", UDim2.new(0, 30, 0, 30), UDim2.new(0, 180, 0, 5), mainFrame)

local toggleSize = true local scale = 1

local sizeButton = createButton("size🟢", UDim2.new(0, 90, 0, 30), UDim2.new(0, 5, 0, 40), mainFrame) local sizeMinus = createButton("-", UDim2.new(0, 30, 0, 30), UDim2.new(0, 100, 0, 40), mainFrame) local sizeValue = createButton("1", UDim2.new(0, 40, 0, 30), UDim2.new(0, 135, 0, 40), mainFrame) sizeValue.AutoButtonColor = false local sizePlus = createButton("+", UDim2.new(0, 30, 0, 30), UDim2.new(0, 180, 0, 40), mainFrame)

local followToggle = true local followButton = createButton("follow player🟢", UDim2.new(0, 150, 0, 30), UDim2.new(0, 5, 0, 75), mainFrame)

local dropdown = Instance.new("ScrollingFrame", mainFrame) dropdown.Position = UDim2.new(0, 5, 0, 110) dropdown.Size = UDim2.new(0, 190, 0, 200) dropdown.CanvasSize = UDim2.new(0, 0, 0, 0) dropdown.ScrollBarThickness = 6 dropdown.BackgroundColor3 = Color3.new(0, 0, 0) dropdown.BorderColor3 = Color3.new(1, 0, 0)

local input = Instance.new("TextBox", mainFrame) input.Size = UDim2.new(0, 190, 0, 30) input.Position = UDim2.new(0, 5, 0, 320) input.Text = "@username" input.BackgroundColor3 = Color3.new(0, 0, 0) input.TextColor3 = Color3.new(1, 1, 1) input.BorderColor3 = Color3.new(1, 0, 0) input.Font = Enum.Font.SourceSans input.TextSize = 18

local collapseBtn = createButton("Y44I GU1 ☻", UDim2.new(0, 190, 0, 30), UDim2.new(0, 205, 0, 5), mainFrame)

collapseBtn.MouseButton1Click:Connect(function() collapsed = not collapsed for _, v in ipairs(mainFrame:GetChildren()) do if v:IsA("GuiObject") and v ~= collapseBtn then v.Visible = not collapsed end end mainFrame.Size = collapsed and UDim2.new(0, 400, 0, 30) or UDim2.new(0, 400, 0, 370) end)

speedMinus.MouseButton1Click:Connect(function() speed = math.max(0, speed - 5) speedValue.Text = tostring(speed) end)\n speedPlus.MouseButton1Click:Connect(function() speed = speed + 5 speedValue.Text = tostring(speed) end)

speedButton.MouseButton1Click:Connect(function() toggleSpeed = not toggleSpeed speedButton.Text = toggleSpeed and "speed🟢" or "speed🔴" if toggleSpeed then LocalPlayer.Character.Humanoid.WalkSpeed = speed else LocalPlayer.Character.Humanoid.WalkSpeed = 16 end end)

sizeMinus.MouseButton1Click:Connect(function() scale = math.max(0.5, scale - 0.2) sizeValue.Text = string.format("%.1f", scale) LocalPlayer.Character.Humanoid.BodyDepthScale.Value = scale LocalPlayer.Character.Humanoid.BodyWidthScale.Value = scale LocalPlayer.Character.Humanoid.BodyHeightScale.Value = scale end)

sizePlus.MouseButton1Click:Connect(function() scale = scale + 0.2 sizeValue.Text = string.format("%.1f", scale) LocalPlayer.Character.Humanoid.BodyDepthScale.Value = scale LocalPlayer.Character.Humanoid.BodyWidthScale.Value = scale LocalPlayer.Character.Humanoid.BodyHeightScale.Value = scale end)

sizeButton.MouseButton1Click:Connect(function() toggleSize = not toggleSize sizeButton.Text = toggleSize and "size🟢" or "size🔴" end)

followButton.MouseButton1Click:Connect(function() followToggle = not followToggle followButton.Text = followToggle and "follow player🟢" or "follow player🔴" end)

game:GetService("RunService").Heartbeat:Connect(function() if followToggle then local target = Players:FindFirstChild(input.Text:sub(2)) if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if hrp then hrp.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3) end end end end)

dropdown.CanvasSize = UDim2.new(0, 0, 0, #Players:GetPlayers()*25) for _, p in ipairs(Players:GetPlayers()) do local btn = createButton("@"..p.Name.." ||", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, (#dropdown:GetChildren()-1)*25), dropdown) btn.MouseButton1Click:Connect(function() input.Text = "@"..p.Name end) end

Players.PlayerAdded:Connect(function(p) local btn = createButton("@"..p.Name.." ||", UDim2.new(1, 0, 0, 25), UDim2.new(0, 0, 0, (#dropdown:GetChildren()-1)*25), dropdown) btn.MouseButton1Click:Connect(function() input.Text = "@"..p.Name end) end)

