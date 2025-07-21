local p = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", p:WaitForChild("PlayerGui"))

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0,25,0,25)
btn.Position = UDim2.new(0,10,0,10)
btn.BackgroundColor3 = Color3.new(0,0,0)
btn.BorderColor3 = Color3.fromRGB(255,0,0)
btn.BorderSizePixel = 2
btn.Text = ""
btn.Active = true
btn.Draggable = true

local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0,250,0,110)
menu.Position = UDim2.new(0,40,0,50)
menu.BackgroundColor3 = Color3.fromRGB(0,0,0)
menu.BorderColor3 = Color3.fromRGB(255,0,0)
menu.BorderSizePixel = 2
menu.Visible = false
menu.Active = true
menu.Draggable = true

btn.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

local function dragResizeCorner(x, y)
	local corner = Instance.new("Frame", menu)
	corner.Size = UDim2.new(0, 10, 0, 10)
	corner.Position = UDim2.new(0, x, 0, y)
	corner.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
	corner.BorderSizePixel = 0
	corner.Draggable = true
end
dragResizeCorner(0, 0)
dragResizeCorner(0, menu.Size.Y.Offset - 10)
dragResizeCorner(menu.Size.X.Offset - 10, 0)
dragResizeCorner(menu.Size.X.Offset - 10, menu.Size.Y.Offset - 10)

local function makeText(txt, x, y)
	local t = Instance.new("TextLabel", menu)
	t.Size = UDim2.new(0, 50, 0, 20)
	t.Position = UDim2.new(0, x, 0, y)
	t.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	t.TextColor3 = Color3.new(1, 1, 1)
	t.BorderColor3 = Color3.fromRGB(255, 0, 0)
	t.BorderSizePixel = 2
	t.Text = txt
	t.TextScaled = true
	t.TextXAlignment = Enum.TextXAlignment.Center
	return t
end

local function makeButton(txt, x, y, callback)
	local b = Instance.new("TextButton", menu)
	b.Size = UDim2.new(0, 30, 0, 20)
	b.Position = UDim2.new(0, x, 0, y)
	b.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	b.TextColor3 = Color3.new(1, 1, 1)
	b.BorderColor3 = Color3.fromRGB(255, 0, 0)
	b.BorderSizePixel = 2
	b.Text = txt
	b.MouseButton1Click:Connect(callback)
	return b
end

local speed = 50
local flySpeed = 50
local speedOn, flyOn = false, false

local speedLabel = makeText("Speed", 10, 10)
local speedMinus = makeButton("-", 70, 10, function()
	speed = math.max(0, speed - 25)
end)
local speedPlus = makeButton("+", 100, 10, function()
	speed += 25
end)
speedLabel.MouseButton1Click:Connect(function()
	speedOn = not speedOn
end)

local flyLabel = makeText("Fly", 10, 40)
local flyMinus = makeButton("-", 70, 40, function()
	flySpeed = math.max(0, flySpeed - 25)
end)
local flyPlus = makeButton("+", 100, 40, function()
	flySpeed += 25
end)
flyLabel.MouseButton1Click:Connect(function()
	flyOn = not flyOn
end)

local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")

local moveDir = Vector3.zero
uis.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.W then moveDir += Vector3.new(0,0,-1) end
		if input.KeyCode == Enum.KeyCode.S then moveDir += Vector3.new(0,0,1) end
		if input.KeyCode == Enum.KeyCode.A then moveDir += Vector3.new(-1,0,0) end
		if input.KeyCode == Enum.KeyCode.D then moveDir += Vector3.new(1,0,0) end
		if input.KeyCode == Enum.KeyCode.Space then moveDir += Vector3.new(0,1,0) end
		if input.KeyCode == Enum.KeyCode.LeftShift then moveDir += Vector3.new(0,-1,0) end
	end
end)
uis.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.W then moveDir -= Vector3.new(0,0,-1) end
		if input.KeyCode == Enum.KeyCode.S then moveDir -= Vector3.new(0,0,1) end
		if input.KeyCode == Enum.KeyCode.A then moveDir -= Vector3.new(-1,0,0) end
		if input.KeyCode == Enum.KeyCode.D then moveDir -= Vector3.new(1,0,0) end
		if input.KeyCode == Enum.KeyCode.Space then moveDir -= Vector3.new(0,1,0) end
		if input.KeyCode == Enum.KeyCode.LeftShift then moveDir -= Vector3.new(0,-1,0) end
	end
end)

rs.RenderStepped:Connect(function()
	local h = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
	if h then
		if speedOn then
			h.WalkSpeed = speed
		else
			h.WalkSpeed = 16
		end
	end
	if flyOn and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
		p.Character.HumanoidRootPart.Velocity = (p.Character.HumanoidRootPart.CFrame:VectorToWorldSpace(moveDir.Unit)) * flySpeed
	end
end)

local killBtn = makeButton("KillAura", 140, 10, function()
	local tool = p.Character and p.Character:FindFirstChildOfClass("Tool")
	if not tool or not tool:FindFirstChild("Handle") then return end
	for _, v in pairs(game.Players:GetPlayers()) do
		if v ~= p and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
			for i = 1, 20 do
				firetouchinterest(tool.Handle, v.Character.HumanoidRootPart, 0)
				wait()
				firetouchinterest(tool.Handle, v.Character.HumanoidRootPart, 1)
			end
		end
	end
end)

local espBtn = makeButton("ESP", 180, 10, function()
	for _, v in pairs(game.Players:GetPlayers()) do
		if v ~= p and v.Character and v.Character:FindFirstChild("Head") then
			if not v.Character:FindFirstChild("ESP") then
				local bb = Instance.new("BillboardGui", v.Character)
				bb.Name = "ESP"
				bb.Size = UDim2.new(0,100,0,30)
				bb.StudsOffset = Vector3.new(0,3,0)
				bb.AlwaysOnTop = true
				bb.Adornee = v.Character.Head
				local tx = Instance.new("TextLabel", bb)
				tx.Size = UDim2.new(1,0,1,0)
				tx.BackgroundTransparency = 1
				tx.Text = v.Name
				tx.TextColor3 = Color3.fromRGB(255,0,0)
				tx.TextStrokeTransparency = 0.5
				tx.TextScaled = true
			end
		end
	end
end)
