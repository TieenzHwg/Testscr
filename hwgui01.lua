local p = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local char, hum, hrp

local gui = Instance.new("ScreenGui", p:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

-- Toggle button
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 25, 0, 25)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.BackgroundColor3 = Color3.new(0, 0, 0)
toggleBtn.BorderColor3 = Color3.fromRGB(255, 0, 0)
toggleBtn.BorderSizePixel = 2
toggleBtn.Text = ""
toggleBtn.Active = true
toggleBtn.Draggable = true

-- Main menu
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0, 250, 0, 110)
menu.Position = UDim2.new(0, 40, 0, 50)
menu.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
menu.BorderColor3 = Color3.fromRGB(255, 0, 0)
menu.BorderSizePixel = 2
menu.Visible = false

toggleBtn.MouseButton1Click:Connect(function()
	menu.Visible = not menu.Visible
end)

-- Create line function
local function createLine(title, startVal, onMinus, onPlus, onClick)
	local y = #menu:GetChildren() * 25
	local label = Instance.new("TextButton", menu)
	label.Size = UDim2.new(0, 80, 0, 25)
	label.Position = UDim2.new(0, 10, 0, y)
	label.Text = title
	label.BackgroundColor3 = Color3.new(0, 0, 0)
	label.BorderColor3 = Color3.fromRGB(255, 0, 0)
	label.TextColor3 = Color3.new(1, 1, 1)
	label.BorderSizePixel = 2

	if onClick then
		label.MouseButton1Click:Connect(onClick)
	end

	local minus = Instance.new("TextButton", menu)
	minus.Size = UDim2.new(0, 30, 0, 25)
	minus.Position = UDim2.new(0, 100, 0, y)
	minus.Text = "-"
	minus.BackgroundColor3 = Color3.new(0, 0, 0)
	minus.BorderColor3 = Color3.fromRGB(255, 0, 0)
	minus.TextColor3 = Color3.new(1, 1, 1)
	minus.BorderSizePixel = 2
	minus.MouseButton1Click:Connect(onMinus)

	local plus = minus:Clone()
	plus.Text = "+"
	plus.Position = UDim2.new(0, 190, 0, y)
	plus.Parent = menu
	plus.MouseButton1Click:Connect(onPlus)

	local display = Instance.new("TextLabel", menu)
	display.Size = UDim2.new(0, 50, 0, 25)
	display.Position = UDim2.new(0, 135, 0, y)
	display.Text = tostring(startVal)
	display.BackgroundColor3 = Color3.new(0, 0, 0)
	display.BorderColor3 = Color3.fromRGB(255, 0, 0)
	display.TextColor3 = Color3.new(1, 1, 1)
	display.BorderSizePixel = 2

	return display
end

-- WalkSpeed
local ws = 16
local wsToggle = false
local wsDisplay = createLine("speed", ws,
	function() ws = math.max(0, ws - 25) end,
	function() ws = ws + 25 end,
	function() wsToggle = not wsToggle end
)

-- Fly
local flySpeed = 0
local flyToggle = false
local flyDisplay = createLine("fly", flySpeed,
	function() flySpeed = math.max(0, flySpeed - 25) end,
	function() flySpeed = flySpeed + 25 end,
	function() flyToggle = not flyToggle end
)

-- ESP
local function createESP(plr)
	if plr.Character and not plr.Character:FindFirstChild("ESP") and plr ~= p then
		local bb = Instance.new("BillboardGui", plr.Character)
		bb.Name = "ESP"
		bb.Size = UDim2.new(0, 100, 0, 20)
		bb.StudsOffset = Vector3.new(0, 3, 0)
		bb.AlwaysOnTop = true
		bb.Adornee = plr.Character:FindFirstChild("Head")

		local tx = Instance.new("TextLabel", bb)
		tx.Size = UDim2.new(1, 0, 1, 0)
		tx.BackgroundTransparency = 1
		tx.Text = plr.Name
		tx.TextColor3 = Color3.new(1, 0, 0)
		tx.TextScaled = false
		tx.TextSize = 6
	end
end

for _, pl in pairs(game.Players:GetPlayers()) do createESP(pl) end
game.Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		wait(1)
		createESP(plr)
	end)
end)

-- Kill Aura
local function killAura()
	if not p.Character then return end
	local root = p.Character:FindFirstChild("HumanoidRootPart")
	for _, pl in pairs(game.Players:GetPlayers()) do
		if pl ~= p and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart") then
			local hrp2 = pl.Character.HumanoidRootPart
			if (hrp2.Position - root.Position).Magnitude < 20 then
				local hum = pl.Character:FindFirstChildOfClass("Humanoid")
				if hum and hum.Health > 0 then
					hum:TakeDamage(100)
				end
			end
		end
	end
end

local killBtn = Instance.new("TextButton", menu)
killBtn.Size = UDim2.new(0, 110, 0, 25)
killBtn.Position = UDim2.new(0, 10, 0, 80)
killBtn.Text = "kill aura"
killBtn.BackgroundColor3 = Color3.new(0, 0, 0)
killBtn.BorderColor3 = Color3.fromRGB(255, 0, 0)
killBtn.TextColor3 = Color3.new(1, 1, 1)
killBtn.BorderSizePixel = 2
killBtn.MouseButton1Click:Connect(killAura)

-- Movement handler
local direction = Vector3.zero
UIS.InputBegan:Connect(function(i, g)
	if g then return end
	if i.KeyCode == Enum.KeyCode.W then direction = direction + Vector3.new(0,0,-1) end
	if i.KeyCode == Enum.KeyCode.S then direction = direction + Vector3.new(0,0,1) end
	if i.KeyCode == Enum.KeyCode.A then direction = direction + Vector3.new(-1,0,0) end
	if i.KeyCode == Enum.KeyCode.D then direction = direction + Vector3.new(1,0,0) end
	if i.KeyCode == Enum.KeyCode.Space then direction = direction + Vector3.new(0,1,0) end
	if i.KeyCode == Enum.KeyCode.LeftShift then direction = direction + Vector3.new(0,-1,0) end
end)
UIS.InputEnded:Connect(function(i)
	if i.KeyCode == Enum.KeyCode.W then direction = direction - Vector3.new(0,0,-1) end
	if i.KeyCode == Enum.KeyCode.S then direction = direction - Vector3.new(0,0,1) end
	if i.KeyCode == Enum.KeyCode.A then direction = direction - Vector3.new(-1,0,0) end
	if i.KeyCode == Enum.KeyCode.D then direction = direction - Vector3.new(1,0,0) end
	if i.KeyCode == Enum.KeyCode.Space then direction = direction - Vector3.new(0,1,0) end
	if i.KeyCode == Enum.KeyCode.LeftShift then direction = direction - Vector3.new(0,-1,0) end
end)

RS.RenderStepped:Connect(function()
	char = p.Character
	if not char then return end
	hum = char:FindFirstChildOfClass("Humanoid")
	hrp = char:FindFirstChild("HumanoidRootPart")

	if hum and wsToggle then hum.WalkSpeed = ws else hum.WalkSpeed = 16 end

	if flyToggle and hrp then
		local cam = workspace.CurrentCamera
		hrp.Velocity = (cam.CFrame:VectorToWorldSpace(direction)) * flySpeed
	elseif hrp then
		hrp.Velocity = Vector3.zero
	end
end)
