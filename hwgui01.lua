local p = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", p:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false
local uis = game:GetService("UserInputService")
local run = game:GetService("RunService")
local Players = game:GetService("Players")
local speedEnabled, flyEnabled = false, false
local speed = 25
local flySpeed = 25
local flyConn

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0,25,0,25)
btn.Position = UDim2.new(0,10,0,10)
btn.BackgroundColor3 = Color3.new(0,0,0)
btn.BorderColor3 = Color3.fromRGB(255,0,0)
btn.BorderSizePixel = 2
btn.Text = ""
btn.TextColor3 = Color3.new(1,1,1)
btn.Active = true
btn.Draggable = true

local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0,240,0,130)
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

for _, corner in pairs({"TopLeft", "TopRight", "BottomLeft", "BottomRight"}) do
	local res = Instance.new("Frame", menu)
	res.Size = UDim2.new(0,10,0,10)
	res.BackgroundColor3 = Color3.fromRGB(50,50,50)
	res.BorderColor3 = Color3.fromRGB(255,0,0)
	res.BorderSizePixel = 2
	res.Name = corner
	if corner == "TopLeft" then
		res.Position = UDim2.new(0, -5, 0, -5)
	elseif corner == "TopRight" then
		res.Position = UDim2.new(1, -5, 0, -5)
	elseif corner == "BottomLeft" then
		res.Position = UDim2.new(0, -5, 1, -5)
	elseif corner == "BottomRight" then
		res.Position = UDim2.new(1, -5, 1, -5)
	end
	res.ZIndex = 10
	res.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local startSize = menu.Size
			local startPos = menu.Position
			local startMouse = uis:GetMouseLocation()
			local conn = uis.InputChanged:Connect(function(inp)
				if inp.UserInputType == Enum.UserInputType.MouseMovement then
					local delta = uis:GetMouseLocation() - startMouse
					menu.Size = UDim2.fromOffset(
						math.clamp(startSize.X.Offset + delta.X * (corner:find("Right") and 1 or -1), 150, 400),
						math.clamp(startSize.Y.Offset + delta.Y * (corner:find("Bottom") and 1 or -1), 100, 300)
					)
				end
			end)
			uis.InputEnded:Wait()
			conn:Disconnect()
		end
	end)
end

local function createButton(text, x, y, w, cb)
	local b = Instance.new("TextButton", menu)
	b.Position = UDim2.new(0,x,0,y)
	b.Size = UDim2.new(0,w,0,25)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.BorderColor3 = Color3.fromRGB(255,0,0)
	b.BorderSizePixel = 2
	b.TextColor3 = Color3.new(1,1,1)
	if cb then b.MouseButton1Click:Connect(cb) end
	return b
end

local speedText = createButton("speed", 10, 10, 60, function()
	speedEnabled = not speedEnabled
	local h = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
	if h then h.WalkSpeed = speedEnabled and speed or 16 end
end)
local speedMinus = createButton("-", 80, 10, 25, function()
	speed = math.max(0, speed - 25)
	local h = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
	if h and speedEnabled then h.WalkSpeed = speed end
	speedDisplay.Text = tostring(speed)
end)
local speedDisplay = createButton(tostring(speed), 110, 10, 40)
speedDisplay.Active = false
local speedPlus = createButton("+", 155, 10, 25, function()
	speed += 25
	local h = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
	if h and speedEnabled then h.WalkSpeed = speed end
	speedDisplay.Text = tostring(speed)
end)

local function startFly()
	local char = p.Character
	if not char then return end
	local root = char:WaitForChild("HumanoidRootPart")
	local h = char:FindFirstChildOfClass("Humanoid")
	if h then h.PlatformStand = true end
	local bv = Instance.new("BodyVelocity", root)
	bv.MaxForce = Vector3.new(1e5,1e5,1e5)
	bv.Velocity = Vector3.zero
	flyConn = run.RenderStepped:Connect(function()
		local dir = Vector3.zero
		if uis:IsKeyDown(Enum.KeyCode.W) then dir += workspace.CurrentCamera.CFrame.LookVector end
		if uis:IsKeyDown(Enum.KeyCode.S) then dir -= workspace.CurrentCamera.CFrame.LookVector end
		if uis:IsKeyDown(Enum.KeyCode.A) then dir -= workspace.CurrentCamera.CFrame.RightVector end
		if uis:IsKeyDown(Enum.KeyCode.D) then dir += workspace.CurrentCamera.CFrame.RightVector end
		if uis:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
		if uis:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0,1,0) end
		bv.Velocity = dir.Unit * flySpeed
	end)
end

local function stopFly()
	local char = p.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	local h = char:FindFirstChildOfClass("Humanoid")
	if h then h.PlatformStand = false end
	if root then
		for _, v in pairs(root:GetChildren()) do
			if v:IsA("BodyVelocity") then v:Destroy() end
		end
	end
	if flyConn then flyConn:Disconnect() end
end

local flyText = createButton("fly", 10, 40, 60, function()
	flyEnabled = not flyEnabled
	if flyEnabled then startFly() else stopFly() end
end)
local flyMinus = createButton("-", 80, 40, 25, function()
	flySpeed = math.max(0, flySpeed - 25)
	flyDisplay.Text = tostring(flySpeed)
end)
local flyDisplay = createButton(tostring(flySpeed), 110, 40, 40)
flyDisplay.Active = false
local flyPlus = createButton("+", 155, 40, 25, function()
	flySpeed += 25
	flyDisplay.Text = tostring(flySpeed)
end)

local killAura = createButton("kill aura", 10, 75, 100, function()
	local char = p.Character
	if not char then return end
	local tool = char:FindFirstChildOfClass("Tool")
	if not tool or not tool:FindFirstChild("Handle") then return end
	for _, target in pairs(Players:GetPlayers()) do
		if target ~= p and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			for i = 1, 10 do
				firetouchinterest(tool.Handle, target.Character.HumanoidRootPart, 0)
				wait()
				firetouchinterest(tool.Handle, target.Character.HumanoidRootPart, 1)
			end
		end
	end
end)

local espBtn = createButton("esp", 120, 75, 60)
local espList = {}

local function clearESP()
	for _, v in ipairs(espList) do
		if v and v.Parent then v:Destroy() end
	end
	espList = {}
end

local function createESP()
	clearESP()
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= p and plr.Character and plr.Character:FindFirstChild("Head") then
			local bb = Instance.new("BillboardGui", plr.Character)
			bb.Name = "ESP"
			bb.Size = UDim2.new(0,100,0,30)
			bb.StudsOffset = Vector3.new(0,3,0)
			bb.AlwaysOnTop = true
			bb.Adornee = plr.Character.Head
			local tx = Instance.new("TextLabel", bb)
			tx.Size = UDim2.new(1,0,1,0)
			tx.BackgroundTransparency = 1
			tx.Text = plr.Name
			tx.TextColor3 = Color3.fromRGB(255,0,0)
			tx.TextScaled = true
			table.insert(espList, bb)
		end
	end
end

espBtn.MouseButton1Click:Connect(createESP)
Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		wait(1)
		createESP()
	end)
end)
createESP()

p.CharacterAdded:Connect(function(char)
	char:WaitForChild("HumanoidRootPart")
	wait(1)
	if speedEnabled then
		local h = char:FindFirstChildOfClass("Humanoid")
		if h then h.WalkSpeed = speed end
	end
	if flyEnabled then startFly() end
	wait(1)
	createESP()
end)
