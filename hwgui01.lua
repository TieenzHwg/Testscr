local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 250, 0, 120)
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
Frame.BorderSizePixel = 2
Frame.Active = true
Frame.Draggable = true

local function createButton(txt, pos, callback)
	local btn = Instance.new("TextButton", Frame)
	btn.Size = UDim2.new(0, 60, 0, 30)
	btn.Position = pos
	btn.Text = txt
	btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.BorderColor3 = Color3.fromRGB(255, 0, 0)
	btn.BorderSizePixel = 2
	btn.MouseButton1Click:Connect(callback)
	return btn
end

local speed = 16
local flySpeed = 100
local flying = false
local flyDir = Vector3.new()
local killAuraEnabled = false

-- SPEED CONTROLS
createButton("Speed -", UDim2.new(0, 10, 0, 10), function()
	speed = math.max(0, speed - 25)
	if Character:FindFirstChildOfClass("Humanoid") then
		Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speed
	end
end)

createButton("Speed +", UDim2.new(0, 80, 0, 10), function()
	speed = speed + 25
	if Character:FindFirstChildOfClass("Humanoid") then
		Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speed
	end
end)

local speedToggle = createButton("Speed OFF", UDim2.new(0, 150, 0, 10), function()
	if Character:FindFirstChildOfClass("Humanoid") then
		if speedToggle.Text == "Speed OFF" then
			speedToggle.Text = "Speed ON"
			Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speed
		else
			speedToggle.Text = "Speed OFF"
			Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
		end
	end
end)

-- FLY CONTROLS
createButton("Fly -", UDim2.new(0, 10, 0, 50), function()
	flySpeed = math.max(0, flySpeed - 25)
end)

createButton("Fly +", UDim2.new(0, 80, 0, 50), function()
	flySpeed = flySpeed + 25
end)

local flyToggle = createButton("Fly OFF", UDim2.new(0, 150, 0, 50), function()
	flying = not flying
	flyToggle.Text = flying and "Fly ON" or "Fly OFF"
end)

-- KILL AURA & ESP
createButton("Kill Aura", UDim2.new(0, 10, 0, 90), function()
	killAuraEnabled = not killAuraEnabled
end)

-- ESP
RunService.RenderStepped:Connect(function()
	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
			if not player.Character.Head:FindFirstChild("BillboardGui") then
				local bb = Instance.new("BillboardGui", player.Character.Head)
				bb.Size = UDim2.new(0, 100, 0, 20)
				bb.Adornee = player.Character.Head
				bb.AlwaysOnTop = true

				local nameLabel = Instance.new("TextLabel", bb)
				nameLabel.Size = UDim2.new(1, 0, 1, 0)
				nameLabel.Text = player.Name
				nameLabel.TextSize = 6
				nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
				nameLabel.BackgroundTransparency = 1
			end
		end
	end
end)

-- FLY MOVEMENT
local function updateFly()
	if flying then
		local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			local cam = workspace.CurrentCamera
			local moveDir = Vector3.new()
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + cam.CFrame.UpVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - cam.CFrame.UpVector end
			hrp.Velocity = moveDir.Unit * flySpeed
		end
	end
end

RunService.RenderStepped:Connect(updateFly)

-- KILL AURA
RunService.RenderStepped:Connect(function()
	if killAuraEnabled then
		for _, player in pairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
				local dist = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
				if dist < 25 then
					player.Character.Humanoid.Health = 0
				end
			end
		end
	end
end)
