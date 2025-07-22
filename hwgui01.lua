-- Full GUI + Fly + Speed Script (Không comment)

local Players = game:GetService("Players") local UserInputService = game:GetService("UserInputService") local RunService = game:GetService("RunService") local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui")) ScreenGui.Name = "Y44I_GUI" ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui) Frame.Size = UDim2.new(0, 400, 0, 180) Frame.Position = UDim2.new(0, 100, 0, 100) Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) Frame.BorderColor3 = Color3.fromRGB(255, 255, 255) Frame.Draggable = true Frame.Active = true Frame.Name = "MainFrame"

local Title = Instance.new("TextButton", Frame) Title.Size = UDim2.new(1, 0, 0, 30) Title.Position = UDim2.new(0, 0, 0, 0) Title.Text = "Y44I GU1 ☻" Title.TextColor3 = Color3.new(1, 1, 1) Title.BackgroundColor3 = Color3.fromRGB(50, 50, 50) Title.BorderSizePixel = 0

local Collapsed = false Title.MouseButton1Click:Connect(function() Collapsed = not Collapsed Frame.Size = Collapsed and UDim2.new(0, 400, 0, 30) or UDim2.new(0, 400, 0, 180) end)

local function createButton(text, pos, size, parent) local b = Instance.new("TextButton", parent) b.Size = size b.Position = pos b.Text = text b.BackgroundColor3 = Color3.fromRGB(60, 60, 60) b.BorderColor3 = Color3.fromRGB(255, 255, 255) b.TextColor3 = Color3.new(1, 1, 1) b.TextScaled = true return b end

local function createLabel(text, pos, size, parent) local l = Instance.new("TextLabel", parent) l.Size = size l.Position = pos l.Text = text l.BackgroundColor3 = Color3.fromRGB(60, 60, 60) l.BorderColor3 = Color3.fromRGB(255, 255, 255) l.TextColor3 = Color3.new(1, 1, 1) l.TextScaled = true return l end

local Speed = 25 local SpeedEnabled = true local FlySpeed = 25 local FlyEnabled = false

local SpeedLabel = createButton("speed 🟢", UDim2.new(0,10,0,35), UDim2.new(0,120,0,30), Frame) local SpeedMinus = createButton("-", UDim2.new(0,135,0,35), UDim2.new(0,30,0,30), Frame) local SpeedNum = createLabel(tostring(Speed), UDim2.new(0,170,0,35), UDim2.new(0,50,0,30), Frame) local SpeedPlus = createButton("+", UDim2.new(0,225,0,35), UDim2.new(0,30,0,30), Frame)

local FlyLabel = createButton("fly 🟢", UDim2.new(0,10,0,70), UDim2.new(0,120,0,30), Frame) local FlyMinus = createButton("-", UDim2.new(0,135,0,70), UDim2.new(0,30,0,30), Frame) local FlyNum = createLabel(tostring(FlySpeed), UDim2.new(0,170,0,70), UDim2.new(0,50,0,30), Frame) local FlyPlus = createButton("+", UDim2.new(0,225,0,70), UDim2.new(0,30,0,30), Frame)

-- ADDITIONAL CONTROLS (chọn player & fly theo) local FollowToggle = createButton("bay theo player 🟢", UDim2.new(0,10,0,105), UDim2.new(0,150,0,30), Frame) local Dropdown = createLabel("chọn↓", UDim2.new(0,165,0,105), UDim2.new(0,100,0,30), Frame) local NameBox = Instance.new("TextBox", Frame) NameBox.Size = UDim2.new(0,100,0,30) NameBox.Position = UDim2.new(0,270,0,105) NameBox.Text = "nhập tên" NameBox.BackgroundColor3 = Color3.fromRGB(60, 60, 60) NameBox.BorderColor3 = Color3.fromRGB(255, 255, 255) NameBox.TextColor3 = Color3.new(1, 1, 1) NameBox.TextScaled = true

SpeedLabel.MouseButton1Click:Connect(function() SpeedEnabled = not SpeedEnabled SpeedLabel.Text = "speed " .. (SpeedEnabled and "🟢" or "🔴") end) SpeedMinus.MouseButton1Click:Connect(function() Speed = math.max(0, Speed - 25) SpeedNum.Text = tostring(Speed) end) SpeedPlus.MouseButton1Click:Connect(function() Speed = Speed + 25 SpeedNum.Text = tostring(Speed) end)

FlyLabel.MouseButton1Click:Connect(function() FlyEnabled = not FlyEnabled FlyLabel.Text = "fly " .. (FlyEnabled and "🟢" or "🔴") if not FlyEnabled then local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") if root and root:FindFirstChild("BodyVelocity") then root.BodyVelocity:Destroy() end end end) FlyMinus.MouseButton1Click:Connect(function() FlySpeed = math.max(0, FlySpeed - 25) FlyNum.Text = tostring(FlySpeed) end) FlyPlus.MouseButton1Click:Connect(function() FlySpeed = FlySpeed + 25 FlyNum.Text = tostring(FlySpeed) end)

local Keys = { [Enum.KeyCode.W] = false, [Enum.KeyCode.A] = false, [Enum.KeyCode.S] = false, [Enum.KeyCode.D] = false, [Enum.KeyCode.Space] = false, [Enum.KeyCode.LeftShift] = false, } UserInputService.InputBegan:Connect(function(input, gpe) if Keys[input.KeyCode] ~= nil then Keys[input.KeyCode] = true end end) UserInputService.InputEnded:Connect(function(input, gpe) if Keys[input.KeyCode] ~= nil then Keys[input.KeyCode] = false end end)

RunService.RenderStepped:Connect(function() if SpeedEnabled then local char = LocalPlayer.Character if char and char:FindFirstChild("Humanoid") then char.Humanoid.WalkSpeed = Speed end end if FlyEnabled then local char = LocalPlayer.Character if char and char:FindFirstChild("HumanoidRootPart") then local root = char.HumanoidRootPart local cam = workspace.CurrentCamera local dir = Vector3.zero if Keys[Enum.KeyCode.W] then dir += cam.CFrame.LookVector end if Keys[Enum.KeyCode.S] then dir -= cam.CFrame.LookVector end if Keys[Enum.KeyCode.A] then dir -= cam.CFrame.RightVector end if Keys[Enum.KeyCode.D] then dir += cam.CFrame.RightVector end if Keys[Enum.KeyCode.Space] then dir += cam.CFrame.UpVector end if Keys[Enum.KeyCode.LeftShift] then dir -= cam.CFrame.UpVector end if not root:FindFirstChild("BodyVelocity") then local bv = Instance.new("BodyVelocity") bv.MaxForce = Vector3.new(1e5, 1e5, 1e5) bv.Velocity = Vector3.zero bv.P = 1000 bv.Name = "BodyVelocity" bv.Parent = root end local bv = root:FindFirstChild("BodyVelocity") bv.Velocity = dir.Magnitude > 0 and dir.Unit * FlySpeed or Vector3.zero end end end)

-- Fly toggle and control
local FlyEnabled = false
local FlySpeed = 25
local FlyLabel = createButton("fly 🟢", UDim2.new(0,10,0,60), UDim2.new(0,150,0,30), ContentFrame)
local FlyMinus = createButton("-", UDim2.new(0,170,0,60), UDim2.new(0,30,0,30), ContentFrame)
local FlyNum = Instance.new("TextLabel", ContentFrame)
FlyNum.Size = UDim2.new(0,60,0,30)
FlyNum.Position = UDim2.new(0,205,0,60)
FlyNum.BackgroundTransparency = 1
FlyNum.TextColor3 = Color3.new(1,1,1)
FlyNum.Font = Enum.Font.SourceSansBold
FlyNum.TextSize = 18
FlyNum.Text = tostring(FlySpeed)
local FlyPlus = createButton("+", UDim2.new(0,270,0,60), UDim2.new(0,30,0,30), ContentFrame)

FlyLabel.MouseButton1Click:Connect(function()
	FlyEnabled = not FlyEnabled
	FlyLabel.Text = "fly " .. (FlyEnabled and "🟢" or "🔴")
end)
FlyMinus.MouseButton1Click:Connect(function()
	FlySpeed = math.max(0, FlySpeed - 25)
	FlyNum.Text = tostring(FlySpeed)
end)
FlyPlus.MouseButton1Click:Connect(function()
	FlySpeed = FlySpeed + 25
	FlyNum.Text = tostring(FlySpeed)
end)

-- Fly Movement
local UIS = game:GetService("UserInputService")
local flying = false
local direction = Vector3.new()

UIS.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.W then direction = direction + Vector3.new(0, 0, -1) end
		if input.KeyCode == Enum.KeyCode.S then direction = direction + Vector3.new(0, 0, 1) end
		if input.KeyCode == Enum.KeyCode.A then direction = direction + Vector3.new(-1, 0, 0) end
		if input.KeyCode == Enum.KeyCode.D then direction = direction + Vector3.new(1, 0, 0) end
		if input.KeyCode == Enum.KeyCode.Space then direction = direction + Vector3.new(0, 1, 0) end
		if input.KeyCode == Enum.KeyCode.LeftShift then direction = direction + Vector3.new(0, -1, 0) end
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.W then direction = direction - Vector3.new(0, 0, -1) end
		if input.KeyCode == Enum.KeyCode.S then direction = direction - Vector3.new(0, 0, 1) end
		if input.KeyCode == Enum.KeyCode.A then direction = direction - Vector3.new(-1, 0, 0) end
		if input.KeyCode == Enum.KeyCode.D then direction = direction - Vector3.new(1, 0, 0) end
		if input.KeyCode == Enum.KeyCode.Space then direction = direction - Vector3.new(0, 1, 0) end
		if input.KeyCode == Enum.KeyCode.LeftShift then direction = direction - Vector3.new(0, -1, 0) end
	end
end)

RunService.RenderStepped:Connect(function()
	pcall(function()
		if FlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local cam = workspace.CurrentCamera
			local moveDir = cam.CFrame:VectorToWorldSpace(direction)
			LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Velocity = moveDir * FlySpeed
		end
	end)
end)
