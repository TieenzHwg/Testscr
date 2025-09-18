--// UI
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local EspButton = Instance.new("TextButton")
local DragButton = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
Frame.Size = UDim2.new(0, 200, 0, 50)
Frame.Position = UDim2.new(0.4, 0, 0.1, 0)
Frame.Active = true
Frame.Draggable = true

EspButton.Parent = Frame
EspButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
EspButton.BorderColor3 = Color3.fromRGB(255, 0, 0)
EspButton.Size = UDim2.new(0.5, 0, 1, 0)
EspButton.Text = "[ESP: OFF]"
EspButton.TextColor3 = Color3.fromRGB(255, 255, 255)

DragButton.Parent = Frame
DragButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DragButton.BorderColor3 = Color3.fromRGB(255, 0, 0)
DragButton.Size = UDim2.new(0.5, 0, 1, 0)
DragButton.Position = UDim2.new(0.5, 0, 0, 0)
DragButton.Text = "[•]"
DragButton.TextColor3 = Color3.fromRGB(255, 255, 255)

--// ESP + Aura
local espEnabled = false
local players = game:GetService("Players")

local function createESP(player)
	if player == players.LocalPlayer then return end
	local char = player.Character
	if not char or not char:FindFirstChild("Head") then return end

	-- Name ESP
	if not char:FindFirstChild("ESP") then
		local billboard = Instance.new("BillboardGui")
		billboard.Name = "ESP"
		billboard.Adornee = char:FindFirstChild("Head")
		billboard.Size = UDim2.new(0, 100, 0, 50)
		billboard.AlwaysOnTop = true
		billboard.Parent = char

		local textLabel = Instance.new("TextLabel")
		textLabel.Parent = billboard
		textLabel.Size = UDim2.new(1, 0, 1, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = player.Name
		textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel.TextStrokeTransparency = 0.5
	end

	-- Aura Highlight
	if not char:FindFirstChild("ESP_Highlight") then
		local hl = Instance.new("Highlight")
		hl.Name = "ESP_Highlight"
		hl.Adornee = char
		hl.FillColor = Color3.fromRGB(255, 255, 0)
		hl.OutlineColor = Color3.fromRGB(255, 255, 0)
		hl.Parent = char
	end
end

local function removeESP(player)
	if player.Character then
		if player.Character:FindFirstChild("ESP") then
			player.Character.ESP:Destroy()
		end
		if player.Character:FindFirstChild("ESP_Highlight") then
			player.Character.ESP_Highlight:Destroy()
		end
	end
end

EspButton.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	if espEnabled then
		EspButton.Text = "[ESP: ON]"
		for _, p in pairs(players:GetPlayers()) do
			createESP(p)
		end
	else
		EspButton.Text = "[ESP: OFF]"
		for _, p in pairs(players:GetPlayers()) do
			removeESP(p)
		end
	end
end)

players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function()
		wait(1)
		if espEnabled then
			createESP(p)
		end
	end)
end)
