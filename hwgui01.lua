local p = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", p:WaitForChild("PlayerGui"))

-- Nút mở menu
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0,25,0,25)
btn.Position = UDim2.new(0,10,0,10)
btn.BackgroundColor3 = Color3.new(0,0,0)
btn.BorderColor3 = Color3.fromRGB(255,0,0)
btn.BorderSizePixel = 2
btn.Text = ""
btn.Active = true
btn.Draggable = true

-- Menu chính
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0,220,0,100)
menu.Position = UDim2.new(0,40,0,50)
menu.BackgroundColor3 = Color3.fromRGB(0,0,0)
menu.BorderColor3 = Color3.fromRGB(255,0,0)
menu.BorderSizePixel = 2
menu.Visible = false
menu.Active = true
menu.Draggable = true

-- Resize bằng viền
local uis = game:GetService("UserInputService")
local resizing = false
local startPos, startSize

menu.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local mPos = uis:GetMouseLocation()
		local frameAbsPos = menu.AbsolutePosition
		local frameAbsSize = menu.AbsoluteSize
		local edgeSize = 10
		if mPos.X >= frameAbsPos.X + frameAbsSize.X - edgeSize and mPos.Y >= frameAbsPos.Y + frameAbsSize.Y - edgeSize then
			resizing = true
			startPos = mPos
			startSize = menu.Size
		end
	end
end)

uis.InputChanged:Connect(function(input)
	if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = uis:GetMouseLocation() - startPos
		local newX = math.clamp(startSize.X.Offset + delta.X, 220, 400)
		local newY = math.clamp(startSize.Y.Offset + delta.Y, 100, 400)
		menu.Size = UDim2.fromOffset(newX, newY)
	end
end)

uis.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		resizing = false
	end
end)

btn.MouseButton1Click:Connect(function()
	menu.Visible = not menu.Visible
end)

local function createButton(text, x, y)
	local b = Instance.new("TextButton", menu)
	b.Position = UDim2.new(0,x,0,y)
	b.Size = UDim2.new(0,30,0,20)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.BorderColor3 = Color3.fromRGB(255,0,0)
	b.BorderSizePixel = 2
	b.TextColor3 = Color3.new(1,1,1)
	return b
end

local function createDisplay(x, y, text)
	local d = Instance.new("TextLabel", menu)
	d.Position = UDim2.new(0,x,0,y)
	d.Size = UDim2.new(0,60,0,20)
	d.Text = text
	d.BackgroundColor3 = Color3.fromRGB(30,30,30)
	d.BorderColor3 = Color3.fromRGB(255,0,0)
	d.BorderSizePixel = 2
	d.TextColor3 = Color3.new(1,1,1)
	return d
end

local speed = 50
local speedMinus = createButton("-", 10, 10)
local speedDisp = createDisplay(40, 10, tostring(speed))
local speedPlus = createButton("+", 100, 10)

local function updateSpeed()
	local h = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
	if h then h.WalkSpeed = speed end
	speedDisp.Text = tostring(speed)
end
speedPlus.MouseButton1Click:Connect(function()
	speed += 50; updateSpeed()
end)
speedMinus.MouseButton1Click:Connect(function()
	speed = math.max(0, speed - 50); updateSpeed()
end)
updateSpeed()

local espSize = 6
local espMinus = createButton("-", 10, 40)
local espDisp = createDisplay(40, 40, tostring(espSize))
local espPlus = createButton("+", 100, 40)
local espList = {}

local function clearESP()
	for _, v in ipairs(espList) do
		if v and v.Parent then v:Destroy() end
	end
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
			tx.TextSize = espSize
			table.insert(espList, bb)
		end
	end
end

espPlus.MouseButton1Click:Connect(function()
	espSize += 1
	espDisp.Text = tostring(espSize)
	createESP()
end)
espMinus.MouseButton1Click:Connect(function()
	espSize = math.max(1, espSize - 1)
	espDisp.Text = tostring(espSize)
	createESP()
end)

game.Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		wait(1)
		createESP()
	end)
end)
createESP()

local killBtn = Instance.new("TextButton", menu)
killBtn.Size = UDim2.new(0, 200, 0, 25)
killBtn.Position = UDim2.new(0, 10, 0, 70)
killBtn.Text = "Kill All"
killBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
killBtn.BorderColor3 = Color3.fromRGB(255,0,0)
killBtn.BorderSizePixel = 2
killBtn.TextColor3 = Color3.new(1,1,1)

killBtn.MouseButton1Click:Connect(function()
	local char = p.Character
	if not char then return end
	local tool = char:FindFirstChildOfClass("Tool")
	if not tool or not tool:FindFirstChild("Handle") then return end
	for _, target in pairs(game.Players:GetPlayers()) do
		if target ~= p and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
			firetouchinterest(tool.Handle, target.Character.HumanoidRootPart, 0)
			wait()
			firetouchinterest(tool.Handle, target.Character.HumanoidRootPart, 1)
		end
	end
end)
