--// UI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local EspButton = Instance.new("TextButton")
local AuraButton = Instance.new("TextButton")
local DragButton = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
Frame.Size = UDim2.new(0, 300, 0, 40)
Frame.Position = UDim2.new(0.3, 0, 0.1, 0)

EspButton.Parent = Frame
EspButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
EspButton.BorderColor3 = Color3.fromRGB(255, 0, 0)
EspButton.Size = UDim2.new(0.33, 0, 1, 0)
EspButton.Position = UDim2.new(0, 0, 0, 0)
EspButton.Text = "[ESP: OFF]"
EspButton.TextColor3 = Color3.fromRGB(255, 255, 255)

AuraButton.Parent = Frame
AuraButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
AuraButton.BorderColor3 = Color3.fromRGB(255, 0, 0)
AuraButton.Size = UDim2.new(0.33, 0, 1, 0)
AuraButton.Position = UDim2.new(0.33, 0, 0, 0)
AuraButton.Text = "[Aura: OFF]"
AuraButton.TextColor3 = Color3.fromRGB(255, 255, 255)

DragButton.Parent = Frame
DragButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DragButton.BorderColor3 = Color3.fromRGB(255, 0, 0)
DragButton.Size = UDim2.new(0.34, 0, 1, 0)
DragButton.Position = UDim2.new(0.66, 0, 0, 0)
DragButton.Text = "[•]"
DragButton.TextColor3 = Color3.fromRGB(255, 255, 255)

--// Drag
local dragging, dragStart, startPos
local function updateDrag(input)
	local delta = input.Position - dragStart
	Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
DragButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
DragButton.InputChanged:Connect(function(input)
	if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragging then
		updateDrag(input)
	end
end)

--// ESP + Aura
local players = game:GetService("Players")
local espEnabled, auraEnabled = false, false

local function setESP(player, state)
	if player == players.LocalPlayer then return end
	local char = player.Character
	if not char or not char:FindFirstChild("Head") then return end
	if state then
		if not char:FindFirstChild("ESP") then
			local billboard = Instance.new("BillboardGui")
			billboard.Name = "ESP"
			billboard.Adornee = char.Head
			billboard.Size = UDim2.new(0,100,0,50)
			billboard.AlwaysOnTop = true
			billboard.Parent = char

			local label = Instance.new("TextLabel")
			label.Size = UDim2.new(1,0,1,0)
			label.BackgroundTransparency = 1
			label.Text = player.Name
			label.TextColor3 = Color3.fromRGB(255,255,255)
			label.TextStrokeTransparency = 0.5
			label.Parent = billboard
		end
	else
		if char:FindFirstChild("ESP") then char.ESP:Destroy() end
	end
end

local function setAura(player, state)
	if player == players.LocalPlayer then return end
	local char = player.Character
	if not char then return end
	if state then
		if not char:FindFirstChild("ESP_Highlight") then
			local hl = Instance.new("Highlight")
			hl.Name = "ESP_Highlight"
			hl.Adornee = char
			hl.FillColor = Color3.fromRGB(255, 255, 0)
			hl.OutlineColor = Color3.fromRGB(255, 255, 0)
			hl.Parent = char
		end
	else
		if char:FindFirstChild("ESP_Highlight") then char.ESP_Highlight:Destroy() end
	end
end

EspButton.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	EspButton.Text = espEnabled and "[ESP: ON]" or "[ESP: OFF]"
	for _,p in pairs(players:GetPlayers()) do setESP(p, espEnabled) end
end)

AuraButton.MouseButton1Click:Connect(function()
	auraEnabled = not auraEnabled
	AuraButton.Text = auraEnabled and "[Aura: ON]" or "[Aura: OFF]"
	for _,p in pairs(players:GetPlayers()) do setAura(p, auraEnabled) end
end)

players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function()
		task.wait(1)
		if espEnabled then setESP(p, true) end
		if auraEnabled then setAura(p, true) end
	end)
end)
