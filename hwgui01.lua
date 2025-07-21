local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- Main GUI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame", ScreenGui)
frame.Position = UDim2.new(0, 100, 0, 100)
frame.Size = UDim2.new(0, 400, 0, 370)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
frame.BorderSizePixel = 2
frame.Active = true
frame.Draggable = true

-- Walk Speed
local walkspeed = 16
local walkspeedEnabled = true

local speedLabel = Instance.new("TextButton", frame)
speedLabel.Text = "Walk Speed 🟢"
speedLabel.Size = UDim2.new(0, 380, 0, 30)
speedLabel.Position = UDim2.new(0, 10, 0, 10)
speedLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.BorderSizePixel = 0
speedLabel.MouseButton1Click:Connect(function()
	walkspeedEnabled = not walkspeedEnabled
	speedLabel.Text = "Walk Speed " .. (walkspeedEnabled and "🟢" or "🔴")
	LocalPlayer.Character.Humanoid.WalkSpeed = walkspeedEnabled and walkspeed or 16
end)

local minus = Instance.new("TextButton", frame)
minus.Text = "-"
minus.Size = UDim2.new(0, 30, 0, 30)
minus.Position = UDim2.new(0, 10, 0, 50)
minus.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
minus.TextColor3 = Color3.new(1, 1, 1)
minus.MouseButton1Click:Connect(function()
	walkspeed = math.max(0, walkspeed - 25)
	if walkspeedEnabled then
		LocalPlayer.Character.Humanoid.WalkSpeed = walkspeed
	end
end)

local value = Instance.new("TextLabel", frame)
value.Text = tostring(walkspeed)
value.Size = UDim2.new(0, 50, 0, 30)
value.Position = UDim2.new(0, 45, 0, 50)
value.BackgroundTransparency = 1
value.TextColor3 = Color3.new(1, 1, 1)

local plus = Instance.new("TextButton", frame)
plus.Text = "+"
plus.Size = UDim2.new(0, 30, 0, 30)
plus.Position = UDim2.new(0, 100, 0, 50)
plus.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
plus.TextColor3 = Color3.new(1, 1, 1)
plus.MouseButton1Click:Connect(function()
	walkspeed = walkspeed + 25
	if walkspeedEnabled then
		LocalPlayer.Character.Humanoid.WalkSpeed = walkspeed
	end
end)

-- Update speed value
game:GetService("RunService").RenderStepped:Connect(function()
	value.Text = tostring(walkspeed)
end)

-- Teleport player
local tpEnabled = true

local tpLabel = Instance.new("TextButton", frame)
tpLabel.Text = "Teleport Player 🟢"
tpLabel.Size = UDim2.new(0, 380, 0, 30)
tpLabel.Position = UDim2.new(0, 10, 0, 100)
tpLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
tpLabel.TextColor3 = Color3.new(1, 1, 1)
tpLabel.BorderSizePixel = 0
tpLabel.MouseButton1Click:Connect(function()
	tpEnabled = not tpEnabled
	tpLabel.Text = "Teleport Player " .. (tpEnabled and "🟢" or "🔴")
end)

local textbox = Instance.new("TextBox", frame)
textbox.PlaceholderText = "@username"
textbox.Size = UDim2.new(0, 200, 0, 30)
textbox.Position = UDim2.new(0, 10, 0, 140)
textbox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
textbox.TextColor3 = Color3.new(1, 1, 1)

local selector = Instance.new("TextButton", frame)
selector.Text = "Select Player"
selector.Size = UDim2.new(0, 160, 0, 30)
selector.Position = UDim2.new(0, 220, 0, 140)
selector.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
selector.TextColor3 = Color3.new(1, 1, 1)
selector.MouseButton1Click:Connect(function()
	local list = {}
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			table.insert(list, p.Name)
		end
	end
	if #list > 0 then
		textbox.Text = "@" .. list[math.random(1, #list)]
	end
end)

local tpButton = Instance.new("TextButton", frame)
tpButton.Text = "Teleport"
tpButton.Size = UDim2.new(0, 380, 0, 30)
tpButton.Position = UDim2.new(0, 10, 0, 180)
tpButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
tpButton.TextColor3 = Color3.new(1, 1, 1)
tpButton.MouseButton1Click:Connect(function()
	if not tpEnabled then return end
	local name = textbox.Text:gsub("@", "")
	local target = Players:FindFirstChild(name)
	if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character:MoveTo(target.Character.HumanoidRootPart.Position + Vector3.new(0, 3, 0))
	end
end)
