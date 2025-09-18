-- Simple Player ESP with single toggle button and draggable GUI
-- Paste this into a LocalScript (e.g. StarterPlayerScripts / PlayerGui)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- remove any previous GUI with same name to avoid duplicates
local old = PlayerGui:FindFirstChild("SimpleESPGui")
if old then old:Destroy() end

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SimpleESPGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 160, 0, 40)
MainFrame.Position = UDim2.new(0, 100, 0, 100)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MainFrame.BorderSizePixel = 2
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleESP"
ToggleBtn.Size = UDim2.new(1, -8, 1, -8)
ToggleBtn.Position = UDim2.new(0, 4, 0, 4)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.TextSize = 18
ToggleBtn.Text = "ESP 🔴" -- red = off
ToggleBtn.Parent = MainFrame

-- ESP management
local ESP_NAME = "SimpleESP"
local enabled = false

local function createESPForCharacter(char, player)
	if not char then return end
	local head = char:FindFirstChild("Head")
	if not head then return end
	if head:FindFirstChild(ESP_NAME) then return end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = ESP_NAME
	billboard.Adornee = head
	billboard.Size = UDim2.new(0, 140, 0, 24)
	billboard.StudsOffset = Vector3.new(0, 2.5, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = head

	local label = Instance.new("TextLabel", billboard)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = player.Name
	label.Font = Enum.Font.SourceSansBold
	label.TextSize = 16
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextStrokeTransparency = 0.6
end

local function removeESPFromCharacter(char)
	if not char then return end
	local head = char:FindFirstChild("Head")
	if not head then return end
	local existing = head:FindFirstChild(ESP_NAME)
	if existing then existing:Destroy() end
end

local function addPlayerESP(player)
	-- create if character exists
	if player == LocalPlayer then return end
	local char = player.Character
	if char then
		createESPForCharacter(char, player)
	end
	-- watch for character spawns
	player.CharacterAdded:Connect(function(c)
		-- slight delay to ensure Head exists
		c:WaitForChild("Head", 2)
		if enabled then
			createESPForCharacter(c, player)
		end
	end)
end

local function removePlayerESP(player)
	-- destroy any esp attached to player's head (if present)
	if player.Character then
		removeESPFromCharacter(player.Character)
	end
end

-- toggle function
local function setEnabled(state)
	enabled = state
	if enabled then
		ToggleBtn.Text = "ESP 🟢"
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer then
				if p.Character then createESPForCharacter(p.Character, p) end
			end
		end
	else
		ToggleBtn.Text = "ESP 🔴"
		for _, p in ipairs(Players:GetPlayers()) do
			if p.Character then removeESPFromCharacter(p.Character) end
		end
	end
end

-- Button click
ToggleBtn.MouseButton1Click:Connect(function()
	setEnabled(not enabled)
end)

-- Add existing players and connect events
for _, p in ipairs(Players:GetPlayers()) do
	if p ~= LocalPlayer then
		addPlayerESP(p)
	end
end

Players.PlayerAdded:Connect(function(p)
	if p ~= LocalPlayer then
		addPlayerESP(p)
	end
end)

Players.PlayerRemoving:Connect(function(p)
	removePlayerESP(p)
end)

-- also clean up ESP when character is removed (for players)
Players.PlayerAdded:Connect(function(p)
	-- nothing here; CharacterAdded connections created inside addPlayerESP handle re-creation
end)

-- Safety: ensure ESP removed on script disable / when toggling off handled above
-- End of script
