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
menu.Size = UDim2.new(0,240,0,130)
menu.Position = UDim2.new(0,40,0,50)
menu.BackgroundColor3 = Color3.fromRGB(0,0,0)
menu.BorderColor3 = Color3.fromRGB(255,0,0)
menu.BorderSizePixel = 2
menu.Active = true
menu.Draggable = true
menu.Visible = false

btn.MouseButton1Click:Connect(function()
	menu.Visible = not menu.Visible
end)

local function createButton(text, x, y, w, h)
	local b = Instance.new("TextButton", menu)
	b.Position = UDim2.new(0,x,0,y)
	b.Size = UDim2.new(0,w,0,h)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.BorderColor3 = Color3.fromRGB(255,0,0)
	b.BorderSizePixel = 2
	b.TextColor3 = Color3.new(1,1,1)
	return b
end

local function createDisplay(x, y, w, h, text)
	local d = Instance.new("TextLabel", menu)
	d.Position = UDim2.new(0,x,0,y)
	d.Size = UDim2.new(0,w,0,h)
	d.Text = text
	d.BackgroundColor3 = Color3.fromRGB(30,30,30)
	d.BorderColor3 = Color3.fromRGB(255,0,0)
	d.BorderSizePixel = 2
	d.TextColor3 = Color3.new(1,1,1)
	return d
end

local speed = 16
local speedEnabled = false
local fly = false
local flySpeed = 0

local speedBtn = createButton("speed", 10, 10, 60, 25)
local spMinus = createButton("-", 75, 10, 30, 25)
local spDisp = createDisplay(110, 10, 40, 25, tostring(speed))
local spPlus = createButton("+", 155, 10, 30, 25)
local spToggle = createButton("⛶", 190, 10, 40, 25)

local function applySpeed()
	local h = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
	if h and speedEnabled then h.WalkSpeed = speed else h.WalkSpeed = 16 end
end
spPlus.MouseButton1Click:Connect(function() speed += 25 spDisp.Text = tostring(speed) applySpeed() end)
spMinus.MouseButton1Click:Connect(function() speed = math.max(0, speed-25) spDisp.Text = tostring(speed) applySpeed() end)
spToggle.MouseButton1Click:Connect(function() speedEnabled = not speedEnabled applySpeed() end)

local flyBtn = createButton("fly", 10, 45, 60, 25)
local flyMinus = createButton("-", 75, 45, 30, 25)
local flyDisp = createDisplay(110, 45, 40, 25, tostring(flySpeed))
local flyPlus = createButton("+", 155, 45, 30, 25)
local flyToggle = createButton("⛶", 190, 45, 40, 25)

local bodyGyro, bodyVel

local function startFly()
	local char = p.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	bodyGyro = Instance.new("BodyGyro", root)
	bodyGyro.P = 9e4
	bodyGyro.MaxTorque = Vector3.new(9e9,9e9,9e9)
	bodyGyro.CFrame = root.CFrame

	bodyVel = Instance.new("BodyVelocity", root)
	bodyVel.Velocity = Vector3.new(0,0,0)
	bodyVel.MaxForce = Vector3.new(9e9,9e9,9e9)

	game:GetService("RunService").RenderStepped:Connect(function()
		if fly and bodyVel and root then
			local cam = workspace.CurrentCamera
			bodyGyro.CFrame = cam.CFrame
			bodyVel.Velocity = cam.CFrame.LookVector * flySpeed
		end
	end)
end

flyPlus.MouseButton1Click:Connect(function() flySpeed += 25 flyDisp.Text = tostring(flySpeed) end)
flyMinus.MouseButton1Click:Connect(function() flySpeed = math.max(0, flySpeed-25) flyDisp.Text = tostring(flySpeed) end)
flyToggle.MouseButton1Click:Connect(function()
	fly = not fly
	if fly then startFly() else
		if bodyGyro then bodyGyro:Destroy() end
		if bodyVel then bodyVel:Destroy() end
	end
end)

local espBtn = createButton("ESP", 10, 80, 100, 25)
local espList = {}

local function clearESP()
	for _,v in ipairs(espList) do if v and v.Parent then v:Destroy() end end
	espList = {}
end

local function createESP()
	clearESP()
	for _, plr in pairs(game.Players:GetPlayers()) do
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

game.Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		wait(1)
		createESP()
	end)
end)

createESP()

local killAuraBtn = createButton("Kill All", 120, 80, 110, 25)

killAuraBtn.MouseButton1Click:Connect(function()
	local char = p.Character
	if not char then return end
	local tool = char:FindFirstChildOfClass("Tool")
	if not tool or not tool:FindFirstChild("Handle") then return end

	for _, target in pairs(game.Players:GetPlayers()) do
		if target ~= p and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			for i = 1,10 do
				firetouchinterest(tool.Handle, target.Character.HumanoidRootPart, 0)
				wait()
				firetouchinterest(tool.Handle, target.Character.HumanoidRootPart, 1)
			end
		end
	end
end)
