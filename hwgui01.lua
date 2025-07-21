local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Position = UDim2.new(0, 100, 0, 100)
Frame.Size = UDim2.new(0, 400, 0, 370)
Frame.BackgroundColor3 = Color3.new(0, 0, 0)
Frame.BorderSizePixel = 2
Frame.Active = true
Frame.Draggable = true

local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Text = "Y44I GU1 ☻"
ToggleButton.Size = UDim2.new(0, 100, 0, 30)
ToggleButton.Position = UDim2.new(0, 400, 0, 0)
ToggleButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
ToggleButton.TextColor3 = Color3.new(1, 1, 1)
ToggleButton.BorderSizePixel = 1

local visible = true
ToggleButton.MouseButton1Click:Connect(function()
    visible = not visible
    Frame.Visible = visible
end)

local UICorner = Instance.new("UICorner", Frame)
UICorner.CornerRadius = UDim.new(0, 8)

local function createLabel(parent, text, pos)
    local label = Instance.new("TextLabel", parent)
    label.Text = text
    label.Position = pos
    label.Size = UDim2.new(0, 200, 0, 30)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    return label
end

local function createButton(parent, text, pos, size)
    local button = Instance.new("TextButton", parent)
    button.Text = text
    button.Position = pos
    button.Size = size
    button.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.BorderSizePixel = 1
    return button
end

local wsLabel = createLabel(Frame, "walk speed 🟢", UDim2.new(0, 10, 0, 20))
local speedValue = 16

local minusBtn = createButton(Frame, "-", UDim2.new(0, 130, 0, 20), UDim2.new(0, 30, 0, 30))
local valueBox = Instance.new("TextBox", Frame)
valueBox.Text = tostring(speedValue)
valueBox.Position = UDim2.new(0, 160, 0, 20)
valueBox.Size = UDim2.new(0, 60, 0, 30)
valueBox.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
valueBox.TextColor3 = Color3.new(1, 1, 1)
valueBox.BorderSizePixel = 1
valueBox.ClearTextOnFocus = false

local plusBtn = createButton(Frame, "+", UDim2.new(0, 220, 0, 20), UDim2.new(0, 30, 0, 30))

minusBtn.MouseButton1Click:Connect(function()
    speedValue = speedValue - 25
    if speedValue < 0 then speedValue = 0 end
    valueBox.Text = tostring(speedValue)
    LocalPlayer.Character.Humanoid.WalkSpeed = speedValue
end)

plusBtn.MouseButton1Click:Connect(function()
    speedValue = speedValue + 25
    valueBox.Text = tostring(speedValue)
    LocalPlayer.Character.Humanoid.WalkSpeed = speedValue
end)

valueBox.FocusLost:Connect(function()
    local num = tonumber(valueBox.Text)
    if num then
        speedValue = num
        LocalPlayer.Character.Humanoid.WalkSpeed = speedValue
    end
end)

local function createESP(plr)
    if plr == LocalPlayer then return end
    local BillboardGui = Instance.new("BillboardGui")
    BillboardGui.Name = "ESP"
    BillboardGui.Adornee = plr.Character:WaitForChild("Head")
    BillboardGui.Size = UDim2.new(0, 100, 0, 40)
    BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
    BillboardGui.AlwaysOnTop = true

    local TextLabel = Instance.new("TextLabel", BillboardGui)
    TextLabel.Text = plr.Name
    TextLabel.TextSize = 6
    TextLabel.TextColor3 = Color3.new(1, 1, 1)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Size = UDim2.new(1, 0, 1, 0)

    BillboardGui.Parent = plr.Character
end

for _, player in pairs(Players:GetPlayers()) do
    player.CharacterAdded:Connect(function()
        wait(1)
        createESP(player)
    end)
    if player.Character then
        createESP(player)
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        wait(1)
        createESP(player)
    end)
end)
