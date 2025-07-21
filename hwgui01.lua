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
menu.Size = UDim2.new(0,220,0,120)
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

local function createButton(x, y, w, t)
	local b = Instance.new("TextButton", menu)
	b.Position = UDim2.new(0,x,0,y)
	b.Size = UDim2.new(0,w,0,20)
	b.Text = t
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.BorderColor3 = Color3.fromRGB(255,0,0)
	b.BorderSizePixel = 2
	b.TextColor3 = Color3.new(1,1,1)
	return b
end

local function createDisplay(x, y, txt)
	local d = Instance.new("TextLabel", menu)
	d.Position = UDim2.new(0,x,0,y)
	d.Size = UDim2.new(0,60,0,20)
	d.Text = txt
	d.BackgroundColor3 = Color3.fromRGB(30,30,30)
	d.BorderColor3 = Color3.fromRGB(255,0,0)
	d.BorderSizePixel = 2
	d.TextColor3 = Color3.new(1,1,1)
	return d
end

local Players = game:GetService("Players")

local speed = 50
local flySpeed = 50
local flying = false
local flyConn

local speedBtn = createButton(10, 10, 60, "speed")
local speedMinus = createButton(70, 10, 30, "-")
local speedPlus = createButton(160, 10, 30, "+")
local speedDisp = createDisplay(100, 10, tostring(speed))
local flyBtn = createButton(10, 35, 60, "fly")
local flyMinus = createButton(70, 35, 30, "-")
local flyPlus = createButton(160, 35, 30, "+")
local flyDisp = createDisplay(100, 35, tostring(flySpeed))
local killAuraBtn = createButton(10, 60, 100, "kill aura")
local espBtn = createButton(120, 60, 90, "esp")

local function updateSpeed()
	local h = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
	if h and speedToggle then h.WalkSpeed = speed end
	speedDisp.Text = tostring(speed)
end

local function updateFly()
	flyDisp.Text = tostring(flySpeed)
end

local function startFly()
	local hrp = p.Character:WaitForChild("HumanoidRootPart")
	local bv = Instance.new("BodyVelocity", hrp)
	bv.Name = "FlyVelocity"
	bv.MaxForce = Vector3.new(1,1,1)*1e9
	bv.Velocity = Vector3.zero
	local uis = game:GetService("UserInputService")
	flyConn = game:GetService("RunService").Heartbeat:Connect(function()
		local move = Vector3.zero
		if uis:IsKeyDown(Enum.KeyCode.W) then move += workspace.CurrentCamera.CFrame.LookVector end
		if uis:IsKeyDown(Enum.KeyCode.S) then move -= workspace.CurrentCamera.CFrame.LookVector end
		if uis:IsKeyDown(Enum.KeyCode.A) then move -= workspace.CurrentCamera.CFrame.RightVector end
		if uis:IsKeyDown(Enum.KeyCode.D) then move += workspace.CurrentCamera.CFrame.RightVector end
		if uis:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
		if uis:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0,1,0) end
		bv.Velocity = move.Unit * flySpeed
		if move == Vector3.zero then bv.Velocity = Vector3.zero end
	end)
end

local function stopFly()
	local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		local bv = hrp:FindFirstChild("FlyVelocity")
		if bv then bv:Destroy() end
	end
	if flyConn then flyConn:Disconnect() flyConn = nil end
end

local speedToggle = true
speedBtn.MouseButton1Click:Connect(function()
	speedToggle = not speedToggle
	updateSpeed()
end)
speedMinus.MouseButton1Click:Connect(function()
	speed = math.max(0, speed - 25)
	updateSpeed()
end)
speedPlus.MouseButton1Click:Connect(function()
	speed += 25
	updateSpeed()
end)
updateSpeed()

local flyToggle = false
flyBtn.MouseButton1Click:Connect(function()
	flyToggle = not flyToggle
	if flyToggle then startFly() else stopFly() end
end)
flyMinus.MouseButton1Click:Connect(function()
	flySpeed = math.max(0, flySpeed - 25)
	updateFly()
end)
flyPlus.MouseButton1Click:Connect(function()
	flySpeed += 25
	updateFly()
end)
updateFly()

killAuraBtn.MouseButton1Click:Connect(function()
	local char = p.Character
	if not char then return end
	local tool = char:FindFirstChildOfClass("Tool")
	if not tool or not tool:FindFirstChild("Handle") then return end
	for _, target in pairs(Players:GetPlayers()) do
		if target ~= p and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			for i = 1, 50 do
				firetouchinterest(tool.Handle, target.Character.HumanoidRootPart, 0)
				firetouchinterest(tool.Handle, target.Character.HumanoidRootPart, 1)
			end
		end
	end
end)

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
			bb.Size = UDim2.new(0,100,0,40)
			bb.StudsOffset = Vector3.new(0,3,0)
			bb.AlwaysOnTop = true
			bb.Adornee = plr.Character.Head
			local tx = Instance.new("TextLabel", bb)
			tx.Size = UDim2.new(1,0,1,0)
			tx.BackgroundTransparency = 1
			tx.Text = plr.Name
			tx.TextColor3 = Color3.fromRGB(255,0,0)
			tx.TextStrokeTransparency = 0.5
			tx.TextScaled = false
			tx.TextSize = 6
			table.insert(espList, bb)
		end
	end
end

espBtn.MouseButton1Click:Connect(function()
	createESP()
end)

Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		wait(1)
		createESP()
	end)
end)
createESP()
