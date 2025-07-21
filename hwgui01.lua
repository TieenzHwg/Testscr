local Players = game:GetService("Players")
local lp = Players.LocalPlayer

local function startScript()
	local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
	gui.ResetOnSpawn = false

	local main = Instance.new("Frame", gui)
	main.Position = UDim2.new(0, 50, 0, 100)
	main.Size = UDim2.new(0, 240, 0, 140)
	main.BackgroundColor3 = Color3.new(0, 0, 0)
	main.BorderColor3 = Color3.fromRGB(255, 0, 0)
	main.BorderSizePixel = 2
	main.Active = true
	main.Draggable = true

	local speedEnabled, flyEnabled = false, false
	local walkspeed, flyspeed = 16, 0

	local function makeLine(y, label, value, callback)
		local txt = Instance.new("TextButton", main)
		txt.Size = UDim2.new(0, 80, 0, 30)
		txt.Position = UDim2.new(0, 10, 0, y)
		txt.Text = label
		txt.TextColor3 = Color3.new(1,1,1)
		txt.BackgroundColor3 = Color3.new(0,0,0)
		txt.BorderColor3 = Color3.fromRGB(255,0,0)
		txt.BorderSizePixel = 1
		txt.MouseButton1Click:Connect(callback)

		local minus = Instance.new("TextButton", main)
		minus.Size = UDim2.new(0, 30, 0, 30)
		minus.Position = UDim2.new(0, 100, 0, y)
		minus.Text = "-"
		minus.TextColor3 = Color3.new(1,1,1)
		minus.BackgroundColor3 = Color3.new(0,0,0)
		minus.BorderColor3 = Color3.fromRGB(255,0,0)
		minus.BorderSizePixel = 1

		local valueLabel = Instance.new("TextLabel", main)
		valueLabel.Size = UDim2.new(0, 40, 0, 30)
		valueLabel.Position = UDim2.new(0, 135, 0, y)
		valueLabel.Text = tostring(value())
		valueLabel.TextColor3 = Color3.new(1,1,1)
		valueLabel.BackgroundTransparency = 1
		valueLabel.TextScaled = true

		local plus = Instance.new("TextButton", main)
		plus.Size = UDim2.new(0, 30, 0, 30)
		plus.Position = UDim2.new(0, 180, 0, y)
		plus.Text = "+"
		plus.TextColor3 = Color3.new(1,1,1)
		plus.BackgroundColor3 = Color3.new(0,0,0)
		plus.BorderColor3 = Color3.fromRGB(255,0,0)
		plus.BorderSizePixel = 1

		minus.MouseButton1Click:Connect(function()
			callback(-25)
			valueLabel.Text = tostring(value())
		end)

		plus.MouseButton1Click:Connect(function()
			callback(25)
			valueLabel.Text = tostring(value())
		end)
	end

	makeLine(10, "Speed", function() return walkspeed end, function(change)
		if type(change) == "number" then
			walkspeed = math.clamp(walkspeed + change, 0, 500)
			if speedEnabled then
				local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
				if hum then hum.WalkSpeed = walkspeed end
			end
		else
			speedEnabled = not speedEnabled
			local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
			if hum then hum.WalkSpeed = speedEnabled and walkspeed or 16 end
		end
	end)

	makeLine(45, "Fly", function() return flyspeed end, function(change)
		if type(change) == "number" then
			flyspeed = math.clamp(flyspeed + change, 0, 500)
		else
			flyEnabled = not flyEnabled
		end
	end)

	local auraEspRow = Instance.new("Frame", main)
	auraEspRow.Size = UDim2.new(1, -20, 0, 30)
	auraEspRow.Position = UDim2.new(0, 10, 0, 80)
	auraEspRow.BackgroundTransparency = 1

	local auraBtn = Instance.new("TextButton", auraEspRow)
	auraBtn.Size = UDim2.new(0.5, -5, 1, 0)
	auraBtn.Position = UDim2.new(0, 0, 0, 0)
	auraBtn.Text = "Kill Aura"
	auraBtn.TextColor3 = Color3.new(1,1,1)
	auraBtn.BackgroundColor3 = Color3.new(0,0,0)
	auraBtn.BorderColor3 = Color3.fromRGB(255,0,0)
	auraBtn.BorderSizePixel = 1
	auraBtn.MouseButton1Click:Connect(function()
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= lp and p.Character and p.Character:FindFirstChild("Humanoid") then
				p.Character.Humanoid:TakeDamage(99999)
			end
		end
	end)

	local espBtn = Instance.new("TextButton", auraEspRow)
	espBtn.Size = UDim2.new(0.5, -5, 1, 0)
	espBtn.Position = UDim2.new(0.5, 5, 0, 0)
	espBtn.Text = "ESP"
	espBtn.TextColor3 = Color3.new(1,1,1)
	espBtn.BackgroundColor3 = Color3.new(0,0,0)
	espBtn.BorderColor3 = Color3.fromRGB(255,0,0)
	espBtn.BorderSizePixel = 1

	local function createESP(plr)
		if plr == lp then return end
		plr.CharacterAdded:Connect(function(char)
			wait(1)
			local head = char:WaitForChild("Head", 3)
			if head then
				local esp = Instance.new("BillboardGui", head)
				esp.Name = "ESP"
				esp.Adornee = head
				esp.AlwaysOnTop = true
				esp.Size = UDim2.new(0, 100, 0, 20)
				local label = Instance.new("TextLabel", esp)
				label.Size = UDim2.new(1, 0, 1, 0)
				label.BackgroundTransparency = 1
				label.Text = plr.Name
				label.TextColor3 = Color3.fromRGB(255, 0, 0)
				label.TextScaled = true
				label.TextSize = 6
			end
		end)
	end

	for _, p in pairs(Players:GetPlayers()) do createESP(p) end
	Players.PlayerAdded:Connect(createESP)

	-- Fly loop
	local uis = game:GetService("UserInputService")
	local rs = game:GetService("RunService")
	local flying = Vector3.new()

	uis.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode == Enum.KeyCode.W then flying = Vector3.new(0, 0, -1)
			elseif input.KeyCode == Enum.KeyCode.S then flying = Vector3.new(0, 0, 1)
			elseif input.KeyCode == Enum.KeyCode.A then flying = Vector3.new(-1, 0, 0)
			elseif input.KeyCode == Enum.KeyCode.D then flying = Vector3.new(1, 0, 0)
			elseif input.KeyCode == Enum.KeyCode.Space then flying = Vector3.new(0, 1, 0)
			elseif input.KeyCode == Enum.KeyCode.LeftShift then flying = Vector3.new(0, -1, 0)
			end
		end
	end)

	uis.InputEnded:Connect(function(input)
		flying = Vector3.new()
	end)

	rs.RenderStepped:Connect(function()
		if flyEnabled then
			local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
			if root and flying.Magnitude > 0 then
				local dir = workspace.CurrentCamera.CFrame:VectorToWorldSpace(flying)
				root.Velocity = dir.Unit * flyspeed
			end
		end
	end)
end

lp.CharacterAdded:Connect(function()
	repeat wait() until lp.Character:FindFirstChild("Humanoid")
	wait(0.5)
	startScript()
end)

if lp.Character and lp.Character:FindFirstChild("Humanoid") then
	wait(0.5)
	startScript()
end
