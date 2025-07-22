local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui", PlayerGui)
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 370)
MainFrame.Position = UDim2.new(0, 100, 0, 100)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MainFrame.BorderSizePixel = 2
MainFrame.Active = true
MainFrame.Draggable = true

local ToggleButton = Instance.new("TextButton", MainFrame)
ToggleButton.Size = UDim2.new(1, 0, 0, 30)
ToggleButton.Position = UDim2.new(0, 0, 0, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.Text = "Y44I GUI☻"
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 18

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, 0, 1, -30)
ContentFrame.Position = UDim2.new(0, 0, 0, 30)
ContentFrame.BackgroundTransparency = 1

local function createButton(text, pos, size, parent)
	local b = Instance.new("TextButton")
	b.Size = size
	b.Position = pos
	b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Font = Enum.Font.SourceSansBold
	b.TextSize = 18
	b.Text = text
	b.Parent = parent
	return b
end

local function createBox(pos, size, parent)
	local tb = Instance.new("TextBox")
	tb.Size = size
	tb.Position = pos
	tb.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	tb.TextColor3 = Color3.new(1, 1, 1)
	tb.Font = Enum.Font.SourceSansBold
	tb.TextSize = 18
	tb.PlaceholderText = "nhập @username"
	tb.Parent = parent
	return tb
end

-- WALK SPEED
local SpeedEnabled = true
local WalkSpeed = 25
local SpeedLabel = createButton("walk speed 🟢", UDim2.new(0,10,0,10), UDim2.new(0,150,0,30), ContentFrame)
local SpeedMinus = createButton("-", UDim2.new(0,170,0,10), UDim2.new(0,30,0,30), ContentFrame)
local SpeedNum = Instance.new("TextLabel", ContentFrame)
SpeedNum.Size = UDim2.new(0,60,0,30)
SpeedNum.Position = UDim2.new(0,205,0,10)
SpeedNum.BackgroundTransparency = 1
SpeedNum.TextColor3 = Color3.new(1,1,1)
SpeedNum.Font = Enum.Font.SourceSansBold
SpeedNum.TextSize = 18
SpeedNum.Text = tostring(WalkSpeed)
local SpeedPlus = createButton("+", UDim2.new(0,270,0,10), UDim2.new(0,30,0,30), ContentFrame)

SpeedLabel.MouseButton1Click:Connect(function()
	SpeedEnabled = not SpeedEnabled
	SpeedLabel.Text = "walk speed " .. (SpeedEnabled and "🟢" or "🔴")
end)
SpeedMinus.MouseButton1Click:Connect(function()
	WalkSpeed = math.max(0, WalkSpeed - 25)
	SpeedNum.Text = tostring(WalkSpeed)
end)
SpeedPlus.MouseButton1Click:Connect(function()
	WalkSpeed = WalkSpeed + 25
	SpeedNum.Text = tostring(WalkSpeed)
end)

RunService.RenderStepped:Connect(function()
	pcall(function()
		LocalPlayer.Character.Humanoid.WalkSpeed = SpeedEnabled and WalkSpeed or 16
	end)
end)

-- FLY
local FlyEnabled = true
local FlySpeed = 25
local FlyLabel = createButton("fly 🟢", UDim2.new(0,10,0,50), UDim2.new(0,150,0,30), ContentFrame)
local FlyMinus = createButton("-", UDim2.new(0,170,0,50), UDim2.new(0,30,0,30), ContentFrame)
local FlyNum = Instance.new("TextLabel", ContentFrame)
FlyNum.Size = UDim2.new(0,60,0,30)
FlyNum.Position = UDim2.new(0,205,0,50)
FlyNum.BackgroundTransparency = 1
FlyNum.TextColor3 = Color3.new(1,1,1)
FlyNum.Font = Enum.Font.SourceSansBold
FlyNum.TextSize = 18
FlyNum.Text = tostring(FlySpeed)
local FlyPlus = createButton("+", UDim2.new(0,270,0,50), UDim2.new(0,30,0,30), ContentFrame)

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

-- Fly movement setup
local flying = false
local vel, bg = nil, nil
local function startFly()
	if flying then return end
	flying = true

	local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local root = character:WaitForChild("HumanoidRootPart")

	vel = Instance.new("BodyVelocity", root)
	vel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
	vel.Velocity = Vector3.zero

	bg = Instance.new("BodyGyro", root)
	bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
	bg.CFrame = root.CFrame

	RunService.RenderStepped:Connect(function()
		if flying and FlyEnabled then
			local cam = workspace.CurrentCamera
			local moveVec = Vector3.new()
			if UIS:IsKeyDown(Enum.KeyCode.W) then moveVec += cam.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.S) then moveVec -= cam.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.A) then moveVec -= cam.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.D) then moveVec += cam.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.Space) then moveVec += cam.CFrame.UpVector end
			if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveVec -= cam.CFrame.UpVector end
			vel.Velocity = moveVec.Unit * FlySpeed
			bg.CFrame = cam.CFrame
		elseif vel then
			vel.Velocity = Vector3.zero
		end
	end)
end

local function stopFly()
	flying = false
	if vel then vel:Destroy() vel = nil end
	if bg then bg:Destroy() bg = nil end
end

FlyLabel.MouseButton2Click:Connect(function()
	if flying then stopFly() else startFly() end
end)

-- Follow Player Label
local FollowLabel = createButton("bay theo player 🔴", UDim2.new(0,10,0,90), UDim2.new(0,170,0,30), ContentFrame)
local Following = false
FollowLabel.MouseButton1Click:Connect(function()
	Following = not Following
	FollowLabel.Text = "bay theo player " .. (Following and "🟢" or "🔴")
end)

-- Dropdown + Textbox
local PlayerBox = createBox(UDim2.new(0,190,0,90), UDim2.new(0,170,0,30), ContentFrame)

RunService.RenderStepped:Connect(function()
	if Following and PlayerBox.Text ~= "" then
		local target = Players:FindFirstChild(PlayerBox.Text)
		if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if myRoot then
				myRoot.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
			end
		end
	end
end)

-- Toggle GUI collapse
local collapsed = false
ToggleButton.MouseButton1Click:Connect(function()
	collapsed = not collapsed
	if collapsed then
		MainFrame.Size = UDim2.new(0, 400, 0, 30)
	else
		MainFrame.Size = UDim2.new(0, 400, 0, 370)
	end
end)
