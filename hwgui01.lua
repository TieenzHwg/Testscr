local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 370)
MainFrame.Position = UDim2.new(0, 100, 0, 100)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MainFrame.BorderSizePixel = 2
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 400, 0, 30)
ToggleButton.Position = UDim2.new(0, 0, 0, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleButton.Text = "thu ^"
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 18
ToggleButton.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, 0, 1, -30)
ContentFrame.Position = UDim2.new(0, 0, 0, 30)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local function createButton(text, position, size, parent)
	local btn = Instance.new("TextButton")
	btn.Size = size
	btn.Position = position
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 18
	btn.Text = text
	btn.Parent = parent
	return btn
end

local function createBox(position, size, parent)
	local box = Instance.new("TextBox")
	box.Size = size
	box.Position = position
	box.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	box.TextColor3 = Color3.new(1, 1, 1)
	box.Font = Enum.Font.SourceSansBold
	box.TextSize = 18
	box.Text = ""
	box.PlaceholderText = "nhập @username"
	box.Parent = parent
	return box
end

local SpeedEnabled = true
local SpeedLabel = createButton("walk speed 🟢", UDim2.new(0, 10, 0, 10), UDim2.new(0, 130, 0, 25), ContentFrame)
SpeedLabel.MouseButton1Click:Connect(function()
	SpeedEnabled = not SpeedEnabled
	SpeedLabel.Text = "walk speed " .. (SpeedEnabled and "🟢" or "🔴")
end)

local WalkSpeed = 25
local SpeedMinus = createButton("-", UDim2.new(0, 140, 0, 10), UDim2.new(0, 25, 0, 25), ContentFrame)
local SpeedNum = Instance.new("TextLabel")
SpeedNum.Size = UDim2.new(0, 50, 0, 25)
SpeedNum.Position = UDim2.new(0, 165, 0, 10)
SpeedNum.BackgroundTransparency = 1
SpeedNum.TextColor3 = Color3.new(1, 1, 1)
SpeedNum.Font = Enum.Font.SourceSansBold
SpeedNum.TextSize = 18
SpeedNum.Text = tostring(WalkSpeed)
SpeedNum.Parent = ContentFrame
local SpeedPlus = createButton("+", UDim2.new(0, 215, 0, 10), UDim2.new(0, 25, 0, 25), ContentFrame)

SpeedMinus.MouseButton1Click:Connect(function()
	WalkSpeed = WalkSpeed - 25
	if WalkSpeed < 0 then WalkSpeed = 0 end
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

local FollowEnabled = true
local FollowLabel = createButton("bay theo player 🟢", UDim2.new(0, 10, 0, 50), UDim2.new(0, 180, 0, 25), ContentFrame)
FollowLabel.MouseButton1Click:Connect(function()
	FollowEnabled = not FollowEnabled
	FollowLabel.Text = "bay theo player " .. (FollowEnabled and "🟢" or "🔴")
end)

local DropDown = createButton("chọn player ↓", UDim2.new(0, 10, 0, 90), UDim2.new(0, 180, 0, 25), ContentFrame)
local TextBox = createBox(UDim2.new(0, 200, 0, 90), UDim2.new(0, 190, 0, 25), ContentFrame)

local DropOpen = false
local DropFrame = Instance.new("Frame")
DropFrame.Size = UDim2.new(0, 180, 0, 150)
DropFrame.Position = UDim2.new(0, 10, 0, 115)
DropFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
DropFrame.Visible = false
DropFrame.Parent = ContentFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = DropFrame

DropDown.MouseButton1Click:Connect(function()
	DropOpen = not DropOpen
	DropFrame.Visible = DropOpen
end)

for _, player in pairs(Players:GetPlayers()) do
	if player ~= LocalPlayer then
		local btn = createButton("@" .. player.Name, UDim2.new(), UDim2.new(1, 0, 0, 25), DropFrame)
		btn.MouseButton1Click:Connect(function()
			TextBox.Text = "@" .. player.Name
			DropFrame.Visible = false
			DropOpen = false
		end)
	end
end

Players.PlayerAdded:Connect(function(player)
	local btn = createButton("@" .. player.Name, UDim2.new(), UDim2.new(1, 0, 0, 25), DropFrame)
	btn.MouseButton1Click:Connect(function()
		TextBox.Text = "@" .. player.Name
		DropFrame.Visible = false
		DropOpen = false
	end)
end)

RunService.RenderStepped:Connect(function()
	if FollowEnabled and TextBox.Text ~= "" then
		local name = TextBox.Text:gsub("@", "")
		local target = Players:FindFirstChild(name)
		if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			if root then
				root.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 2, 0)
			end
		end
	end
end)

ToggleButton.MouseButton1Click:Connect(function()
	if ContentFrame.Visible then
		ContentFrame.Visible = false
		DropFrame.Visible = false
		DropOpen = false
		MainFrame.Size = UDim2.new(0, 400, 0, 30)
	else
		ContentFrame.Visible = true
		MainFrame.Size = UDim2.new(0, 400, 0, 370)
	end
end)
