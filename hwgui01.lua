
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 120)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -60)
MainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
MainFrame.BorderColor3 = Color3.fromRGB(255,0,0)

-- nút kéo
local DragButton = Instance.new("TextButton", MainFrame)
DragButton.Size = UDim2.new(1,0,0,20)
DragButton.Text = "[ Kéo ]"
DragButton.BackgroundColor3 = Color3.fromRGB(30,30,30)

-- nút thu gọn
local CollapseButton = Instance.new("TextButton", MainFrame)
CollapseButton.Size = UDim2.new(1,0,0,20)
CollapseButton.Position = UDim2.new(0,0,0,20)
CollapseButton.Text = "[ Thu ]"
CollapseButton.BackgroundColor3 = Color3.fromRGB(30,30,30)

-- nút aura
local AuraButton = Instance.new("TextButton", MainFrame)
AuraButton.Size = UDim2.new(0.5,0,0,20)
AuraButton.Position = UDim2.new(0,0,0,40)
AuraButton.Text = "[ Aura ]"
AuraButton.BackgroundColor3 = Color3.fromRGB(50,50,50)

-- nút ESP
local ESPButton = Instance.new("TextButton", MainFrame)
ESPButton.Size = UDim2.new(0.5,0,0,20)
ESPButton.Position = UDim2.new(0.5,0,0,40)
ESPButton.Text = "[ ESP ]"
ESPButton.BackgroundColor3 = Color3.fromRGB(50,50,50)

-- kéo UI
local dragging, dragInput, dragStart, startPos
DragButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

DragButton.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- thu gọn UI
local collapsed = false
CollapseButton.MouseButton1Click:Connect(function()
	collapsed = not collapsed
	if collapsed then
		MainFrame.Size = UDim2.new(0,200,0,40)
	else
		MainFrame.Size = UDim2.new(0,200,0,120)
	end
end)

-- ESP
local espEnabled = false
local espStorage = {}

local function addESP(player)
	if player.Character and player.Character:FindFirstChild("Head") then
		local Billboard = Instance.new("BillboardGui", player.Character.Head)
		Billboard.Name = "ESP"
		Billboard.Size = UDim2.new(0,200,0,50)
		Billboard.AlwaysOnTop = true
		local TextLabel = Instance.new("TextLabel", Billboard)
		TextLabel.Size = UDim2.new(1,0,1,0)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Text = player.Name
		TextLabel.TextColor3 = Color3.new(1,1,1)
		TextLabel.TextStrokeTransparency = 0
		espStorage[player] = Billboard
	end
end

local function removeESP(player)
	if espStorage[player] then
		espStorage[player]:Destroy()
		espStorage[player] = nil
	end
end

ESPButton.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	if espEnabled then
		for _,plr in pairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				addESP(plr)
			end
		end
		Players.PlayerAdded:Connect(function(plr)
			if espEnabled then addESP(plr) end
		end)
		Players.PlayerRemoving:Connect(function(plr)
			removeESP(plr)
		end)
	else
		for plr,gui in pairs(espStorage) do
			gui:Destroy()
		end
		espStorage = {}
	end
end)

-- Aura
local auraEnabled = false
local auraStorage = {}

local function addAura(player)
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local highlight = Instance.new("Highlight", player.Character)
		highlight.FillColor = Color3.fromRGB(255, 255, 0) -- vàng
		highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
		highlight.FillTransparency = 0.5
		auraStorage[player] = highlight
	end
end

local function removeAura(player)
	if auraStorage[player] then
		auraStorage[player]:Destroy()
		auraStorage[player] = nil
	end
end

AuraButton.MouseButton1Click:Connect(function()
	auraEnabled = not auraEnabled
	if auraEnabled then
		for _,plr in pairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer then
				addAura(plr)
			end
		end
		Players.PlayerAdded:Connect(function(plr)
			if auraEnabled then addAura(plr) end
		end)
		Players.PlayerRemoving:Connect(function(plr)
			removeAura(plr)
		end)
	else
		for plr,h in pairs(auraStorage) do
			h:Destroy()
		end
		auraStorage = {}
	end
end)
