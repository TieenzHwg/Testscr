local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- UI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 60)
MainFrame.Position = UDim2.new(0.5, -100, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
MainFrame.BorderSizePixel = 4 -- viền dày để kéo
MainFrame.BorderColor3 = Color3.fromRGB(255,0,0)

-- Aura button
local AuraButton = Instance.new("TextButton", MainFrame)
AuraButton.Size = UDim2.new(0.5, -2, 1, -2)
AuraButton.Position = UDim2.new(0,1,0,1)
AuraButton.Text = "[ Aura ]"
AuraButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
AuraButton.TextColor3 = Color3.new(1,1,1)

-- ESP button
local ESPButton = Instance.new("TextButton", MainFrame)
ESPButton.Size = UDim2.new(0.5, -2, 1, -2)
ESPButton.Position = UDim2.new(0.5,1,0,1)
ESPButton.Text = "[ Tên ]"
ESPButton.BackgroundColor3 = Color3.fromRGB(50,50,50)
ESPButton.TextColor3 = Color3.new(1,1,1)

-- Kéo UI bằng viền đỏ
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
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

MainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
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

-- ESP
local espEnabled = false
local espStorage = {}
local function addESP(player)
	if player.Character and player.Character:FindFirstChild("Head") and not espStorage[player] then
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
			if plr ~= LocalPlayer then addESP(plr) end
		end
		Players.PlayerAdded:Connect(function(plr)
			if espEnabled then addESP(plr) end
		end)
		Players.PlayerRemoving:Connect(removeESP)
	else
		for plr,gui in pairs(espStorage) do gui:Destroy() end
		espStorage = {}
	end
end)

-- Aura
local auraEnabled = false
local auraStorage = {}
local function addAura(player)
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and not auraStorage[player] then
		local highlight = Instance.new("Highlight", player.Character)
		highlight.FillColor = Color3.fromRGB(255, 255, 0)
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
			if plr ~= LocalPlayer then addAura(plr) end
		end
		Players.PlayerAdded:Connect(function(plr)
			if auraEnabled then addAura(plr) end
		end)
		Players.PlayerRemoving:Connect(removeAura)
	else
		for plr,h in pairs(auraStorage) do h:Destroy() end
		auraStorage = {}
	end
end)
