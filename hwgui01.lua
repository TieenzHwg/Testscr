local players = game:GetService("Players")
local player = players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))

-- MAIN MENU
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 400, 0, 300)
main.Position = UDim2.new(0, 50, 0, 50)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
main.BackgroundTransparency = 0.3
main.BorderColor3 = Color3.fromRGB(255, 0, 0)

-- WALK SPEED SECTION
local walkLabel = Instance.new("TextLabel", main)
walkLabel.Text = "Walk Speed"
walkLabel.Size = UDim2.new(0, 100, 0, 30)
walkLabel.Position = UDim2.new(0, 10, 0, 10)
walkLabel.TextColor3 = Color3.new(1, 1, 1)
walkLabel.BackgroundTransparency = 1

local speed = 25

local minus = Instance.new("TextButton", main)
minus.Text = "-"
minus.Size = UDim2.new(0, 30, 0, 30)
minus.Position = UDim2.new(0, 120, 0, 10)
minus.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
minus.TextColor3 = Color3.new(1, 1, 1)

local number = Instance.new("TextLabel", main)
number.Text = tostring(speed)
number.Size = UDim2.new(0, 50, 0, 30)
number.Position = UDim2.new(0, 160, 0, 10)
number.BackgroundTransparency = 1
number.TextColor3 = Color3.new(1, 1, 1)

local plus = Instance.new("TextButton", main)
plus.Text = "+"
plus.Size = UDim2.new(0, 30, 0, 30)
plus.Position = UDim2.new(0, 220, 0, 10)
plus.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
plus.TextColor3 = Color3.new(1, 1, 1)

local toggleSpeed = Instance.new("TextButton", main)
toggleSpeed.Text = "🟢"
toggleSpeed.Size = UDim2.new(0, 30, 0, 30)
toggleSpeed.Position = UDim2.new(0, 270, 0, 10)
toggleSpeed.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleSpeed.TextColor3 = Color3.new(0, 1, 0)

local speedOn = true

plus.MouseButton1Click:Connect(function()
	speed += 25
	number.Text = tostring(speed)
	if speedOn and player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.WalkSpeed = speed
	end
end)

minus.MouseButton1Click:Connect(function()
	speed -= 25
	number.Text = tostring(speed)
	if speedOn and player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.WalkSpeed = speed
	end
end)

toggleSpeed.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	toggleSpeed.TextColor3 = speedOn and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
	if speedOn and player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.WalkSpeed = speed
	else
		player.Character.Humanoid.WalkSpeed = 16
	end
end)

-- TELEPORT SECTION
local tpLabel = Instance.new("TextLabel", main)
tpLabel.Text = "Teleport Player"
tpLabel.Size = UDim2.new(0, 150, 0, 30)
tpLabel.Position = UDim2.new(0, 10, 0, 60)
tpLabel.TextColor3 = Color3.new(1, 1, 1)
tpLabel.BackgroundTransparency = 1

local usernameBox = Instance.new("TextBox", main)
usernameBox.PlaceholderText = "Enter @username"
usernameBox.Size = UDim2.new(0, 200, 0, 30)
usernameBox.Position = UDim2.new(0, 10, 0, 100)
usernameBox.TextColor3 = Color3.new(1, 1, 1)
usernameBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local tpToggle = Instance.new("TextButton", main)
tpToggle.Text = "🟢"
tpToggle.Size = UDim2.new(0, 30, 0, 30)
tpToggle.Position = UDim2.new(0, 220, 0, 100)
tpToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
tpToggle.TextColor3 = Color3.new(0, 1, 0)

local tpOn = true

tpToggle.MouseButton1Click:Connect(function()
	tpOn = not tpOn
	tpToggle.TextColor3 = tpOn and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
end)

game:GetService("RunService").RenderStepped:Connect(function()
	if tpOn and usernameBox.Text ~= "" then
		local name = usernameBox.Text:gsub("@", "")
		local target = players:FindFirstChild(name)
		if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
				player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
			end
		end
	end
end)

-- ESP
local function addESP(plr)
	local box = Instance.new("BillboardGui", plr.Character)
	box.Name = "esp_box"
	box.Size = UDim2.new(0, 100, 0, 40)
	box.Adornee = plr.Character:WaitForChild("Head")
	box.AlwaysOnTop = true

	local label = Instance.new("TextLabel", box)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = "@" .. plr.Name
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextScaled = true
end

for _, p in pairs(players:GetPlayers()) do
	if p ~= player then
		p.CharacterAdded:Connect(function()
			wait(1)
			addESP(p)
		end)
		if p.Character then
			addESP(p)
		end
	end
end

players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function()
		wait(1)
		addESP(p)
	end)
end)
