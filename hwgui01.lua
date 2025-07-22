local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

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

local function createLabel(text, pos, size, parent)
	local l = Instance.new("TextLabel")
	l.Size = size
	l.Position = pos
	l.BackgroundTransparency = 1
	l.TextColor3 = Color3.new(1, 1, 1)
	l.Font = Enum.Font.SourceSansBold
	l.TextSize = 18
	l.Text = text
	l.Parent = parent
	return l
end

local WalkSpeed = 25
local SpeedEnabled = true
local SpeedLabel = createButton("speed 🟢", UDim2.new(0,10,0,10), UDim2.new(0,120,0,30), ContentFrame)
local SpeedMinus = createButton("-", UDim2.new(0,135,0,10), UDim2.new(0,30,0,30), ContentFrame)
local SpeedNum = createLabel(tostring(WalkSpeed), UDim2.new(0,170,0,10), UDim2.new(0,50,0,30), ContentFrame)
local SpeedPlus = createButton("+", UDim2.new(0,225,0,10), UDim2.new(0,30,0,30), ContentFrame)

SpeedLabel.MouseButton1Click:Connect(function()
	SpeedEnabled = not SpeedEnabled
	SpeedLabel.Text = "speed " .. (SpeedEnabled and "🟢" or "🔴")
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
	if SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.WalkSpeed = WalkSpeed
	end
end)
local FlySpeed = 25
local FlyEnabled = false
local FlyActive = false
local MoveDir = Vector3.zero

local FlyLabel = createButton("fly 🟢", UDim2.new(0,10,0,50), UDim2.new(0,120,0,30), ContentFrame)
local FlyMinus = createButton("-", UDim2.new(0,135,0,50), UDim2.new(0,30,0,30), ContentFrame)
local FlyNum = createLabel(tostring(FlySpeed), UDim2.new(0,170,0,50), UDim2.new(0,50,0,30), ContentFrame)
local FlyPlus = createButton("+", UDim2.new(0,225,0,50), UDim2.new(0,30,0,30), ContentFrame)

FlyLabel.MouseButton1Click:Connect(function()
	FlyEnabled = not FlyEnabled
	FlyLabel.Text = "fly " .. (FlyEnabled and "🟢" or "🔴")
	if not FlyEnabled then
		local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if root and root:FindFirstChild("BodyVelocity") then
			root.BodyVelocity:Destroy()
		end
	end
end)

FlyMinus.MouseButton1Click:Connect(function()
	FlySpeed = math.max(0, FlySpeed - 25)
	FlyNum.Text = tostring(FlySpeed)
end)

FlyPlus.MouseButton1Click:Connect(function()
	FlySpeed = FlySpeed + 25
	FlyNum.Text = tostring(FlySpeed)
end)

local Keys = {
	[Enum.KeyCode.W] = false,
	[Enum.KeyCode.A] = false,
	[Enum.KeyCode.S] = false,
	[Enum.KeyCode.D] = false,
	[Enum.KeyCode.Space] = false,
	[Enum.KeyCode.LeftShift] = false,
}

UserInputService.InputBegan:Connect(function(input, gpe)
	if Keys[input.KeyCode] ~= nil then
		Keys[input.KeyCode] = true
	end
end)

UserInputService.InputEnded:Connect(function(input, gpe)
	if Keys[input.KeyCode] ~= nil then
		Keys[input.KeyCode] = false
	end
end)

RunService.RenderStepped:Connect(function()
	if not FlyEnabled then return end

	local char = LocalPlayer.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end

	local root = char.HumanoidRootPart
	local cam = workspace.CurrentCamera
	local dir = Vector3.zero

	if Keys[Enum.KeyCode.W] then dir += cam.CFrame.LookVector end
	if Keys[Enum.KeyCode.S] then dir -= cam.CFrame.LookVector end
	if Keys[Enum.KeyCode.A] then dir -= cam.CFrame.RightVector end
	if Keys[Enum.KeyCode.D] then dir += cam.CFrame.RightVector end
	if Keys[Enum.KeyCode.Space] then dir += cam.CFrame.UpVector end
	if Keys[Enum.KeyCode.LeftShift] then dir -= cam.CFrame.UpVector end

	if not root:FindFirstChild("BodyVelocity") then
		local bv = Instance.new("BodyVelocity")
		bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		bv.Velocity = Vector3.zero
		bv.P = 1000
		bv.Name = "BodyVelocity"
		bv.Parent = root
	end

	local bv = root:FindFirstChild("BodyVelocity")
	if bv then
		if dir.Magnitude > 0 then
			bv.Velocity = dir.Unit * FlySpeed
		else
			bv.Velocity = Vector3.zero
		end
	end
end)
