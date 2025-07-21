local p = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", p:WaitForChild("PlayerGui"))

-- Nút chính
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.new(0,25,0,25)
btn.Position = UDim2.new(0,10,0,10)
btn.BackgroundColor3 = Color3.new(0,0,0)
btn.BorderColor3 = Color3.fromRGB(255,0,0)
btn.BorderSizePixel = 2
btn.Text = ""
btn.Active = true
btn.Draggable = true

-- Menu
local menu = Instance.new("Frame", gui)
menu.Size = UDim2.new(0,220,0,160)
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

-- Helper tạo label
local function createLabel(text, y)
	local lbl = Instance.new("TextLabel", menu)
	lbl.Position = UDim2.new(0,10,0,y)
	lbl.Size = UDim2.new(0,200,0,20)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = Color3.new(1,1,1)
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	return lbl
end

-- Helper tạo nút
local function createButton(text, x, y, parent)
	local b = Instance.new("TextButton", parent or menu)
	b.Position = UDim2.new(0,x,0,y)
	b.Size = UDim2.new(0,40,0,30)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(30,30,30)
	b.BorderColor3 = Color3.fromRGB(255,0,0)
	b.BorderSizePixel = 2
	b.TextColor3 = Color3.new(1,1,1)
	return b
end

-- WalkSpeed section
createLabel("Tăng tốc độ", 0)
local minus = createButton("-50", 10, 20)
local plus = createButton("+50", 110, 20)
local disp = Instance.new("TextLabel", menu)
disp.Position = UDim2.new(0,60,0,20)
disp.Size = UDim2.new(0,40,0,30)
disp.Text = "16"
disp.BackgroundColor3 = Color3.fromRGB(30,30,30)
disp.BorderColor3 = Color3.fromRGB(255,0,0)
disp.BorderSizePixel = 2
disp.TextColor3 = Color3.new(1,1,1)

local speed = 16
local function update()
	local h = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
	if h then h.WalkSpeed = speed end
	disp.Text = tostring(speed)
end
plus.MouseButton1Click:Connect(function()
	speed += 50
	update()
end)
minus.MouseButton1Click:Connect(function()
	speed = math.max(0, speed - 50)
	update()
end)
update()

-- ESP section
createLabel("ESP", 0.45)
local espSize = 12
local function updateESPLabels()
	for _, plr in pairs(game.Players:GetPlayers()) do
		if plr ~= p and plr.Character then
			local bb = plr.Character:FindFirstChild("ESP")
			if bb and bb:IsA("BillboardGui") then
				local tx = bb:FindFirstChildOfClass("TextLabel")
				if tx then
					tx.TextSize = espSize
				end
			end
		end
	end
end

local espMinus = createButton("-12", 10, 50)
local espPlus = createButton("+12", 110, 50)
local espDisp = Instance.new("TextLabel", menu)
espDisp.Position = UDim2.new(0,60,0,50)
espDisp.Size = UDim2.new(0,40,0,30)
espDisp.Text = tostring(espSize)
espDisp.BackgroundColor3 = Color3.fromRGB(30,30,30)
espDisp.BorderColor3 = Color3.fromRGB(255,0,0)
espDisp.BorderSizePixel = 2
espDisp.TextColor3 = Color3.new(1,1,1)

espMinus.MouseButton1Click:Connect(function()
	espSize = math.max(6, espSize - 12)
	espDisp.Text = tostring(espSize)
	updateESPLabels()
end)
espPlus.MouseButton1Click:Connect(function()
	espSize = espSize + 12
	espDisp.Text = tostring(espSize)
	updateESPLabels()
end)

-- Nút bật/tắt ESP
local espOn = false
local espBtn = Instance.new("TextButton", menu)
espBtn.Position = UDim2.new(0,10,0,90)
espBtn.Size = UDim2.new(0,200,0,30)
espBtn.Text = "Bật ESP"
espBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
espBtn.BorderColor3 = Color3.fromRGB(255,0,0)
espBtn.BorderSizePixel = 2
espBtn.TextColor3 = Color3.new(1,1,1)

local Players = game:GetService("Players")
local function toggleESP()
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= p and plr.Character then
			local ex = plr.Character:FindFirstChild("ESP")
			if ex then ex:Destroy() end
			if espOn and plr.Character:FindFirstChild("Head") then
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
			end
		end
	end
end

espBtn.MouseButton1Click:Connect(function()
	espOn = not espOn
	espBtn.Text = espOn and "Tắt ESP" or "Bật ESP"
	toggleESP()
end)

Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		wait(1)
		if espOn then toggleESP() end
	end)
end)
