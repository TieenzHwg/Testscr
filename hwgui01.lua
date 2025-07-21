local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid")
local runService = game:GetService("RunService")

-- UI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 160, 0, 50)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BorderColor3 = Color3.new(1, 0, 0)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true

local label = Instance.new("TextLabel", frame)
label.Text = "Speed"
label.Size = UDim2.new(0, 60, 0, 25)
label.Position = UDim2.new(0, 5, 0, 10)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.new(1, 1, 1)
label.TextXAlignment = Enum.TextXAlignment.Left

local minus = Instance.new("TextButton", frame)
minus.Text = "-"
minus.Size = UDim2.new(0, 30, 0, 25)
minus.Position = UDim2.new(0, 65, 0, 10)
minus.BackgroundColor3 = Color3.new(0, 0, 0)
minus.BorderColor3 = Color3.new(1, 0, 0)
minus.TextColor3 = Color3.new(1, 1, 1)

local plus = Instance.new("TextButton", frame)
plus.Text = "+"
plus.Size = UDim2.new(0, 30, 0, 25)
plus.Position = UDim2.new(0, 105, 0, 10)
plus.BackgroundColor3 = Color3.new(0, 0, 0)
plus.BorderColor3 = Color3.new(1, 0, 0)
plus.TextColor3 = Color3.new(1, 1, 1)

local walkSpeed = 16

local function updateSpeed()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeed
	end
end

minus.MouseButton1Click:Connect(function()
	walkSpeed = math.max(0, walkSpeed - 25)
	updateSpeed()
end)

plus.MouseButton1Click:Connect(function()
	walkSpeed = walkSpeed + 25
	updateSpeed()
end)

LocalPlayer.CharacterAdded:Connect(function(char)
	char:WaitForChild("Humanoid").WalkSpeed = walkSpeed
end)

updateSpeed()

-- ESP
local function createESP(player)
	if player == LocalPlayer then return end
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "ESP"
	billboard.Size = UDim2.new(0, 100, 0, 20)
	billboard.AlwaysOnTop = true

	local nameLabel = Instance.new("TextLabel", billboard)
	nameLabel.Size = UDim2.new(1, 0, 1, 0)
	nameLabel.Text = player.Name
	nameLabel.BackgroundTransparency = 1
	nameLabel.TextColor3 = Color3.new(1, 0, 0)
	nameLabel.TextScaled = true
	nameLabel.Font = Enum.Font.SourceSansBold

	local function attachESP()
		if player.Character and player.Character:FindFirstChild("Head") then
			billboard.Parent = player.Character.Head
		end
	end

	player.CharacterAdded:Connect(function()
		repeat task.wait() until player.Character and player.Character:FindFirstChild("Head")
		attachESP()
	end)

	attachESP()
end

for _, player in pairs(Players:GetPlayers()) do
	createESP(player)
end

Players.PlayerAdded:Connect(function(player)
	createESP(player)
end)
