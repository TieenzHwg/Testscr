local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Tạo GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 400, 0, 300)
MainFrame.Position = UDim2.new(0, 100, 0, 100)
MainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MainFrame.Active = true
MainFrame.Draggable = true

-- Nút thu gọn
local ToggleButton = Instance.new("TextButton", MainFrame)
ToggleButton.Size = UDim2.new(0, 100, 0, 25)
ToggleButton.Position = UDim2.new(1, -105, 0, 5)
ToggleButton.Text = "Thu gọn"
ToggleButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
ToggleButton.TextColor3 = Color3.new(1, 1, 1)

-- Nội dung bên trong
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -10, 1, -40)
ContentFrame.Position = UDim2.new(0, 5, 0, 35)
ContentFrame.BackgroundTransparency = 1

-- SPEED CONTROLS
local Speed = 16
local SpeedToggle = Instance.new("TextButton", ContentFrame)
SpeedToggle.Position = UDim2.new(0, 0, 0, 0)
SpeedToggle.Size = UDim2.new(0, 120, 0, 30)
SpeedToggle.Text = "Walk Speed 🟢"
SpeedToggle.TextColor3 = Color3.new(1, 1, 1)
SpeedToggle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

local Minus = Instance.new("TextButton", ContentFrame)
Minus.Position = UDim2.new(0, 130, 0, 0)
Minus.Size = UDim2.new(0, 30, 0, 30)
Minus.Text = "-"
Minus.TextColor3 = Color3.new(1, 1, 1)
Minus.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local SpeedLabel = Instance.new("TextLabel", ContentFrame)
SpeedLabel.Position = UDim2.new(0, 165, 0, 0)
SpeedLabel.Size = UDim2.new(0, 50, 0, 30)
SpeedLabel.Text = tostring(Speed)
SpeedLabel.TextColor3 = Color3.new(1, 1, 1)
SpeedLabel.BackgroundTransparency = 1

local Plus = Instance.new("TextButton", ContentFrame)
Plus.Position = UDim2.new(0, 220, 0, 0)
Plus.Size = UDim2.new(0, 30, 0, 30)
Plus.Text = "+"
Plus.TextColor3 = Color3.new(1, 1, 1)
Plus.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

-- Bật tắt menu
local collapsed = false
ToggleButton.MouseButton1Click:Connect(function()
	collapsed = not collapsed
	ContentFrame.Visible = not collapsed
	ToggleButton.Text = collapsed and "Mở rộng" or "Thu gọn"
end)

-- Chỉnh tốc độ
local speedEnabled = true

SpeedToggle.MouseButton1Click:Connect(function()
	speedEnabled = not speedEnabled
	SpeedToggle.Text = "Walk Speed " .. (speedEnabled and "🟢" or "🔴")
end)

Plus.MouseButton1Click:Connect(function()
	Speed += 25
	SpeedLabel.Text = tostring(Speed)
end)

Minus.MouseButton1Click:Connect(function()
	Speed = math.max(0, Speed - 25)
	SpeedLabel.Text = tostring(Speed)
end)

game:GetService("RunService").RenderStepped:Connect(function()
	if speedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.WalkSpeed = Speed
	end
end)

-- ESP
function createESP(player)
	if player == LocalPlayer then return end
	local function onChar(char)
		if char:FindFirstChild("Head") and not char:FindFirstChild("ESP") then
			local esp = Instance.new("BillboardGui")
			esp.Name = "ESP"
			esp.Size = UDim2.new(0, 100, 0, 25)
			esp.StudsOffset = Vector3.new(0, 3, 0)
			esp.AlwaysOnTop = true
			esp.Adornee = char.Head
			esp.Parent = char

			local label = Instance.new("TextLabel", esp)
			label.Size = UDim2.new(1, 0, 1, 0)
			label.BackgroundTransparency = 1
			label.Text = player.Name
			label.TextColor3 = Color3.new(1, 0, 0)
			label.TextStrokeTransparency = 0.5
			label.TextScaled = true
		end
	end

	if player.Character then
		onChar(player.Character)
	end

	player.CharacterAdded:Connect(onChar)
end

for _, p in pairs(Players:GetPlayers()) do
	createESP(p)
end

Players.PlayerAdded:Connect(createESP)
