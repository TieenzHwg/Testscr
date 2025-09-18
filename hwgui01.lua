-- ESP Toggle GUI (2 ô: Toggle + Drag)
local ScreenGui = Instance.new("ScreenGui")
local ToggleFrame = Instance.new("Frame")
local DragFrame = Instance.new("Frame")
local ToggleButton = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui

-- Drag frame
DragFrame.Size = UDim2.new(0, 120, 0, 30)
DragFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
DragFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
DragFrame.Active = true
DragFrame.Draggable = true
DragFrame.Parent = ScreenGui

-- Toggle frame
ToggleFrame.Size = UDim2.new(0, 120, 0, 50)
ToggleFrame.Position = UDim2.new(0, 0, 1, 5)
ToggleFrame.AnchorPoint = Vector2.new(0, 1)
ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleFrame.Parent = DragFrame

-- Toggle button
ToggleButton.Size = UDim2.new(1, 0, 1, 0)
ToggleButton.Text = "ESP OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
ToggleButton.Parent = ToggleFrame

-- ESP logic
local espEnabled = false
local espObjects = {}

local function createESP(player)
    if player.Character and player.Character:FindFirstChild("Head") then
        local BillboardGui = Instance.new("BillboardGui")
        BillboardGui.Name = "ESP"
        BillboardGui.Adornee = player.Character.Head
        BillboardGui.Size = UDim2.new(0, 100, 0, 20)
        BillboardGui.AlwaysOnTop = true

        local TextLabel = Instance.new("TextLabel")
        TextLabel.Size = UDim2.new(1, 0, 1, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = player.Name
        TextLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        TextLabel.Parent = BillboardGui

        BillboardGui.Parent = player.Character.Head
        espObjects[player] = BillboardGui
    end
end

local function removeESP(player)
    if espObjects[player] then
        espObjects[player]:Destroy()
        espObjects[player] = nil
    end
end

ToggleButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        ToggleButton.Text = "ESP ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                createESP(player)
            end
        end
    else
        ToggleButton.Text = "ESP OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
        for _, player in pairs(espObjects) do
            player:Destroy()
        end
        espObjects = {}
    end
end)

game.Players.PlayerAdded:Connect(function(player)
    if espEnabled then
        player.CharacterAdded:Connect(function()
            wait(1)
            createESP(player)
        end)
    end
end)

game.Players.PlayerRemoving:Connect(function(player)
    removeESP(player)
end)
