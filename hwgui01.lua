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
menu.Size = UDim2.new(0,220,0,160)
menu.Position = UDim2.new(0,40,0,50)
menu.BackgroundColor3 = Color3.fromRGB(0,0,0)
menu.BorderColor3 = Color3.fromRGB(255,0,0)
menu.BorderSizePixel = 2
menu.Visible = false
menu.Active = true
menu.Draggable = true

-- Kéo 4 góc resize
local resize = Instance.new("UISizeConstraint", menu)
resize.MaxSize = Vector2.new(400, 400)
resize.MinSize = Vector2.new(220, 160)
local resizer = Instance.new("TextButton", menu)
resizer.Size = UDim2.new(0, 20, 0, 20)
resizer.Position = UDim2.new(1, -20, 1, -20)
resizer.AnchorPoint = Vector2.new(1,1)
resizer.Text = "↘"
resizer.BackgroundColor3 = Color3.fromRGB(40,40,40)
resizer.BorderColor3 = Color3.fromRGB(255,0,0)
resizer.BorderSizePixel = 2
resizer.MouseButton1Down:Connect(function()
	local uis = game:GetService("UserInputService")
	local con
	local startPos = uis:GetMouseLocation()
	local startSize = menu.Size
	con = uis.InputChanged:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = uis:GetMouseLocation() - startPos
			menu.Size = UDim2.new(0, math.clamp(startSize.X.Offset + delta.X, 220, 400),
				0, math.clamp(startSize.Y.Offset + delta.Y, 160, 400))
		end
	end)
	uis.InputEnded:Wait()
	con:Disconnect()
end)

btn.MouseButton1Click:Connect(function()
	menu.Visible = not menu.Visible
end)

local function createLabel(txt, y)
	local l = Instance.new("TextLabel", menu)
	l.Position = UDim2.new(0,10,0,y)
	l.Size = UDim2.new(0,200,0,20)
	l.BackgroundTransparency = 1
	l.Text = txt
	l.TextColor3 = Color3.new(1,1,1)
	l.TextXAlignment = Enum.TextXAlignment.Left
	return l
end

-- Tốc độ
createLabel("Speed", 5)
local minus = Instance.new("TextButton", menu)
minus.Position = UDim2.new(0,65,0,5)
minus.Size = UDim2.new(0,30,0,20)
minus.Text = "-"
minus.BackgroundColor3 = Color3.fromRGB(40,40,40)
minus.BorderColor3 = Color3.fromRGB(255,0,0)
minus.BorderSizePixel = 2

local disp = Instance.new("TextLabel", menu)
disp.Position = UDim2.new(0,95,0,5)
disp.Size = UDim2.new(0,40,0,20)
disp.Text = "50"
disp.BackgroundColor3 = Color3.fromRGB(30,30,30)
disp.BorderColor3 = Color3.fromRGB(255,0,0)
disp.BorderSizePixel = 2
disp.TextColor3 = Color3.new(1,1,1)

local plus = minus:Clone()
plus.Position = UDim2.new(0,135,0,5)
plus.Text = "+"
plus.Parent = menu

local speed = 50
local function updateSpeed()
	local h = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
	if h then h.WalkSpeed = speed end
	disp.Text = tostring(speed)
end
plus.MouseButton1Click:Connect(function()
	speed += 50
	updateSpeed()
end)
minus.MouseButton1Click:Connect(function()
	speed = math.max(0, speed - 50)
	updateSpeed()
end)
updateSpeed()

-- ESP
createLabel("ESP", 35)
local espMinus = Instance.new("TextButton", menu)
espMinus.Position = UDim2.new(0,65,0,35)
espMinus.Size = UDim2.new(0,30,0,20)
espMinus.Text = "-"
espMinus.BackgroundColor3 = Color3.fromRGB(40,40,40)
espMinus.BorderColor3 = Color3.fromRGB(255,0,0)
espMinus.BorderSizePixel = 2

local espSizeDisp = Instance.new("TextLabel", menu)
espSizeDisp.Position = UDim2.new(0,95,0,35)
espSizeDisp.Size = UDim2.new(0,40,0,20)
espSizeDisp.Text = "12"
espSizeDisp.BackgroundColor3 = Color3.fromRGB(30,30,30)
espSizeDisp.BorderColor3 = Color3.fromRGB(255,0,0)
espSizeDisp.BorderSizePixel = 2
espSizeDisp.TextColor3 = Color3.new(1,1,1)

local espPlus = espMinus:Clone()
espPlus.Position = UDim2.new(0,135,0,35)
espPlus.Text = "+"
espPlus.Parent = menu

local espSize = 12
local espOn = true
local espList = {}
local Players = game:GetService("Players")

local function clearESP()
	for _, v in pairs(espList) do
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
			tx.TextScaled = true
			tx.TextSize = espSize

			table.insert(espList, bb)
		end
	end
end

espPlus.MouseButton1Click:Connect(function()
	espSize += 12
	createESP()
	espSizeDisp.Text = tostring(espSize)
end)

espMinus.MouseButton1Click:Connect(function()
	espSize = math.max(1, espSize - 12)
	createESP()
	espSizeDisp.Text = tostring(espSize)
end)

Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		wait(1)
		if espOn then createESP() end
	end)
end)

createESP()
