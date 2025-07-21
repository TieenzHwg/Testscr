local Players = game:GetService("Players") local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui", PlayerGui) ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui) MainFrame.Size = UDim2.new(0, 400, 0, 370) MainFrame.Position = UDim2.new(0, 100, 0, 100) MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0) MainFrame.BorderSizePixel = 2 MainFrame.Active = true MainFrame.Draggable = true

local ToggleButton = Instance.new("TextButton", MainFrame) ToggleButton.Size = UDim2.new(1, 0, 0, 30) ToggleButton.Position = UDim2.new(0, 0, 0, 0) ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30) ToggleButton.Text = "Y44I GUI☻" ToggleButton.TextColor3 = Color3.new(1, 1, 1) ToggleButton.Font = Enum.Font.SourceSansBold ToggleButton.TextSize = 18

local ContentFrame = Instance.new("Frame", MainFrame) ContentFrame.Size = UDim2.new(1, 0, 1, -30) ContentFrame.Position = UDim2.new(0, 0, 0, 30) ContentFrame.BackgroundTransparency = 1

local function createButton(text, pos, size, parent) local b = Instance.new("TextButton") b.Size = size b.Position = pos b.BackgroundColor3 = Color3.fromRGB(40, 40, 40) b.TextColor3 = Color3.new(1, 1, 1) b.Font = Enum.Font.SourceSansBold b.TextSize = 18 b.Text = text b.Parent = parent return b end

local function createBox(pos, size, parent) local tb = Instance.new("TextBox") tb.Size = size tb.Position = pos tb.BackgroundColor3 = Color3.fromRGB(40, 40, 40) tb.TextColor3 = Color3.new(1, 1, 1) tb.Font = Enum.Font.SourceSansBold tb.TextSize = 18 tb.PlaceholderText = "nhập @username" tb.Parent = parent return tb end

local SpeedEnabled = true local WalkSpeed = 25 local SpeedLabel = createButton("walk speed 🟢", UDim2.new(0,10,0,10), UDim2.new(0,150,0,30), ContentFrame) local SpeedMinus = createButton("-", UDim2.new(0,170,0,10), UDim2.new(0,30,0,30), ContentFrame) local SpeedNum = Instance.new("TextLabel", ContentFrame) SpeedNum.Size = UDim2.new(0,60,0,30) SpeedNum.Position = UDim2.new(0,205,0,10) SpeedNum.BackgroundTransparency = 1 SpeedNum.TextColor3 = Color3.new(1,1,1) SpeedNum.Font = Enum.Font.SourceSansBold SpeedNum.TextSize = 18 SpeedNum.Text = tostring(WalkSpeed) local SpeedPlus = createButton("+", UDim2.new(0,270,0,10), UDim2.new(0,30,0,30), ContentFrame)

SpeedLabel.MouseButton1Click:Connect(function() SpeedEnabled = not SpeedEnabled SpeedLabel.Text = "walk speed " .. (SpeedEnabled and "🟢" or "🔴") end) SpeedMinus.MouseButton1Click:Connect(function() WalkSpeed = math.max(0, WalkSpeed - 25) SpeedNum.Text = tostring(WalkSpeed) end) SpeedPlus.MouseButton1Click:Connect(function() WalkSpeed = WalkSpeed + 25 SpeedNum.Text = tostring(WalkSpeed) end)

RunService.RenderStepped:Connect(function() pcall(function() LocalPlayer.Character.Humanoid.WalkSpeed = SpeedEnabled and WalkSpeed or 16 end) end)

local FollowEnabled = true local FollowLabel = createButton("bay theo player 🟢", UDim2.new(0,10,0,60), UDim2.new(0,200,0,30), ContentFrame) FollowLabel.MouseButton1Click:Connect(function() FollowEnabled = not FollowEnabled FollowLabel.Text = "bay theo player " .. (FollowEnabled and "🟢" or "🔴") end)

local DropDown = createButton("chọn player ↓", UDim2.new(0,10,0,110), UDim2.new(0,200,0,30), ContentFrame) local TextBox = createBox(UDim2.new(0,220,0,110), UDim2.new(0,170,0,30), ContentFrame) local RefreshButton = createButton("làm mới", UDim2.new(0, 220, 0, 145), UDim2.new(0, 170, 0, 25), ContentFrame)

local DropOpen = false local DropFrame = Instance.new("Frame", ContentFrame) DropFrame.Size = UDim2.new(0,200,0,150) DropFrame.Position = UDim2.new(0,10,0,150) DropFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50) DropFrame.Visible = false DropFrame.Active = true DropFrame.Draggable = true local UIList = Instance.new("UIListLayout", DropFrame)

DropDown.MouseButton1Click:Connect(function() DropOpen = not DropOpen DropFrame.Visible = DropOpen end)

local function refreshPlayers() DropFrame:ClearAllChildren() UIList.Parent = DropFrame for _, plr in ipairs(Players:GetPlayers()) do if plr ~= LocalPlayer then local b = createButton("@"..plr.Name, UDim2.new(), UDim2.new(1,0,0,25), DropFrame) b.MouseButton1Click:Connect(function() TextBox.Text = "@" .. plr.Name DropFrame.Visible = false DropOpen = false end) end end end

refreshPlayers()

Players.PlayerAdded:Connect(refreshPlayers) RefreshButton.MouseButton1Click:Connect(refreshPlayers)

RunService.RenderStepped:Connect(function() if FollowEnabled and TextBox.Text ~= "" then local target = Players:FindFirstChild(TextBox.Text:gsub("@","")) if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,2,0) end end end)

ToggleButton.MouseButton1Click:Connect(function() if ContentFrame.Visible then ContentFrame.Visible = false DropFrame.Visible = false DropOpen = false MainFrame.Size = UDim2.new(0,400,0,30) else ContentFrame.Visible = true MainFrame.Size = UDim2.new(0,400,0,370) end end)

RunService.RenderStepped:Connect(function() for _, plr in pairs(Players:GetPlayers()) do if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then if not plr.Character.Head:FindFirstChild("ESP") then local billboard = Instance.new("BillboardGui", plr.Character.Head) billboard.Name = "ESP" billboard.Size = UDim2.new(0, 100, 0, 20) billboard.StudsOffset = Vector3.new(0, 2, 0) billboard.AlwaysOnTop = true local text = Instance.new("TextLabel", billboard) text.Size = UDim2.new(1, 0, 1, 0) text.Text = plr.Name text.BackgroundTransparency = 1 text.TextColor3 = Color3.new(1,1,1) text.TextSize = 6 end end end end)

