local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 260)
MainFrame.Position = UDim2.new(0, 10, 0, 400)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MainFrame.Active = true
MainFrame.Draggable = true

local Header = Instance.new("TextLabel", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 30)
Header.Position = UDim2.new(0, 0, 0, 0)
Header.Text = ""
Header.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Header.BorderSizePixel = 0

local CollapseButton = Instance.new("TextButton", MainFrame)
CollapseButton.Size = UDim2.new(0, 100, 0, 25)
CollapseButton.Position = UDim2.new(1, -105, 0, 2)
CollapseButton.Text = "thu ^"
CollapseButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
CollapseButton.TextColor3 = Color3.new(1, 1, 1)

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -10, 1, -40)
ContentFrame.Position = UDim2.new(0, 5, 0, 35)
ContentFrame.BackgroundTransparency = 1

local SpeedToggle = Instance.new("TextButton", ContentFrame)
SpeedToggle.Position = UDim2.new(0, 0, 0, 0)
SpeedToggle.Size = UDim2.new(0, 130, 0, 30)
SpeedToggle.Text = "walk speed 🟢"
SpeedToggle.TextColor3 = Color3.new(1, 1, 1)
SpeedToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local Minus = Instance.new("TextButton", ContentFrame)
Minus.Position = UDim2.new(0, 135, 0, 0)
Minus.Size = UDim2.new(0, 30, 0, 30)
Minus.Text = "-"
Minus.TextColor3 = Color3.new(1, 1, 1)
Minus.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local SpeedLabel = Instance.new("TextLabel", ContentFrame)
SpeedLabel.Position = UDim2.new(0, 170, 0, 0)
SpeedLabel.Size = UDim2.new(0, 40, 0, 30)
SpeedLabel.Text = "25"
SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
SpeedLabel.BackgroundTransparency = 1

local Plus = Instance.new("TextButton", ContentFrame)
Plus.Position = UDim2.new(0, 215, 0, 0)
Plus.Size = UDim2.new(0, 30, 0, 30)
Plus.Text = "+"
Plus.TextColor3 = Color3.new(1, 1, 1)
Plus.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local FollowToggle = Instance.new("TextButton", ContentFrame)
FollowToggle.Position = UDim2.new(0, 0, 0, 40)
FollowToggle.Size = UDim2.new(0, 160, 0, 30)
FollowToggle.Text = "bay theo player 🟢"
FollowToggle.TextColor3 = Color3.new(1, 1, 1)
FollowToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local PlayerDropdown = Instance.new("TextButton", ContentFrame)
PlayerDropdown.Position = UDim2.new(0, 0, 0, 80)
PlayerDropdown.Size = UDim2.new(0, 160, 0, 30)
PlayerDropdown.Text = "chọn player ↓"
PlayerDropdown.TextColor3 = Color3.new(1, 1, 1)
PlayerDropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

local PlayerBox = Instance.new("TextBox", ContentFrame)
PlayerBox.Position = UDim2.new(0, 170, 0, 80)
PlayerBox.Size = UDim2.new(0, 160, 0, 30)
PlayerBox.PlaceholderText = "nhập tên"
PlayerBox.TextColor3 = Color3.new(1, 1, 1)
PlayerBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local PlayerListFrame = Instance.new("Frame", ContentFrame)
PlayerListFrame.Position = UDim2.new(0, 0, 0, 115)
PlayerListFrame.Size = UDim2.new(0, 160, 0, 100)
PlayerListFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
PlayerListFrame.Visible = false

local UIListLayout = Instance.new("UIListLayout", PlayerListFrame)

local selectedPlayer = nil
local following = true
local speed = 25
local speedEnabled = true
local collapsed = false

SpeedToggle.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled
	SpeedToggle.Text = "walk speed " .. (speedEnabled and "🟢" or "🔴")
end)

Plus.MouseButton1Click:Connect(function()
	speed += 25
	SpeedLabel.Text = tostring(speed)
end)

Minus.MouseButton1Click:Connect(function()
	speed = math.max(0, speed - 25)
	SpeedLabel.Text = tostring(speed)
end)

FollowToggle.MouseButton1Click:Connect(function()
	following = not following
	FollowToggle.Text = "bay theo player " .. (following and "🟢" or "🔴")
end)

PlayerDropdown.MouseButton1Click:Connect(function()
	PlayerListFrame.Visible = not PlayerListFrame.Visible
end)

for _, p in pairs(Players:GetPlayers()) do
	if p ~= LocalPlayer then
		local btn = Instance.new("TextButton", PlayerListFrame)
		btn.Size = UDim2.new(1, 0, 0, 25)
		btn.Text = "@" .. p.Name
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

		btn.MouseButton1Click:Connect(function()
			selectedPlayer = p
			PlayerBox.Text = p.Name
			PlayerListFrame.Visible = false
		end)
	end
end

Players.PlayerAdded:Connect(function(p)
	local btn = Instance.new("TextButton", PlayerListFrame)
	btn.Size = UDim2.new(1, 0, 0, 25)
	btn.Text = "@" .. p.Name
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

	btn.MouseButton1Click:Connect(function()
		selectedPlayer = p
		PlayerBox.Text = p.Name
		PlayerListFrame.Visible = false
	end)
end)

CollapseButton.MouseButton1Click:Connect(function()
	collapsed = not collapsed
	if collapsed then
		ContentFrame.Visible = false
		MainFrame.Size = UDim2.new(0, 400, 0, 30)
		CollapseButton.Text = "mở ⌄"
	else
		MainFrame.Size = UDim2.new(0, 400, 0, 260)
		ContentFrame.Visible = true
		CollapseButton.Text = "thu ^"
	end
end)

game:GetService("RunService").RenderStepped:Connect(function()
	if speedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.WalkSpeed = speed
	end

	if following and selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
		if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			LocalPlayer.Character.HumanoidRootPart.CFrame = selectedPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
		end
	end
end)
