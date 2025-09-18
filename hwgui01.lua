-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 200, 0, 50)
Frame.Position = UDim2.new(0.3, 0, 0.3, 0)
Frame.BackgroundColor3 = Color3.new(0,0,0)
Frame.BorderColor3 = Color3.new(1,0,0)
Frame.Active = true
Frame.Draggable = false

-- Nút ESP
local EspButton = Instance.new("TextButton", Frame)
EspButton.Size = UDim2.new(0.5, 0, 1, 0)
EspButton.Position = UDim2.new(0, 0, 0, 0)
EspButton.BackgroundColor3 = Color3.new(0,0,0)
EspButton.BorderColor3 = Color3.new(1,0,0)
EspButton.TextColor3 = Color3.new(1,1,1)
EspButton.Text = "ESP OFF"

-- Nút kéo (dấu chấm)
local DragButton = Instance.new("TextButton", Frame)
DragButton.Size = UDim2.new(0.5, 0, 1, 0)
DragButton.Position = UDim2.new(0.5, 0, 0, 0)
DragButton.BackgroundColor3 = Color3.new(0,0,0)
DragButton.BorderColor3 = Color3.new(1,0,0)
DragButton.TextColor3 = Color3.new(1,1,1)
DragButton.Text = "•"
DragButton.Active = true
DragButton.Draggable = true

-- ESP Logic
local espEnabled = false
local espObjects = {}

local function addESP(player)
    if player == LocalPlayer then return end
    player.CharacterAdded:Connect(function(char)
        if espEnabled then
            local highlight = Instance.new("Highlight")
            highlight.FillTransparency = 1
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.OutlineTransparency = 0
            highlight.Parent = char

            local billboard = Instance.new("BillboardGui")
            billboard.Size = UDim2.new(0,100,0,20)
            billboard.AlwaysOnTop = true
            billboard.Parent = char:WaitForChild("Head")

            local nameLabel = Instance.new("TextLabel", billboard)
            nameLabel.Size = UDim2.new(1,0,1,0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.TextColor3 = Color3.fromRGB(255,255,0)
            nameLabel.TextStrokeTransparency = 0
            nameLabel.TextScaled = true
            nameLabel.Text = player.Name

            espObjects[player] = {highlight, billboard}
        end
    end)
end

local function enableESP()
    espEnabled = true
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local highlight = Instance.new("Highlight")
            highlight.FillTransparency = 1
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.OutlineTransparency = 0
            highlight.Parent = player.Character

            local billboard = Instance.new("BillboardGui")
            billboard.Size = UDim2.new(0,100,0,20)
            billboard.AlwaysOnTop = true
            billboard.Parent = player.Character:FindFirstChild("Head")

            local nameLabel = Instance.new("TextLabel", billboard)
            nameLabel.Size = UDim2.new(1,0,1,0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.TextColor3 = Color3.fromRGB(255,255,0)
            nameLabel.TextStrokeTransparency = 0
            nameLabel.TextScaled = true
            nameLabel.Text = player.Name

            espObjects[player] = {highlight, billboard}
        end
        addESP(player)
    end
end

local function disableESP()
    espEnabled = false
    for player, objects in pairs(espObjects) do
        for _, obj in ipairs(objects) do
            if obj and obj.Parent then obj:Destroy() end
        end
    end
    espObjects = {}
end

EspButton.MouseButton1Click:Connect(function()
    if espEnabled then
        disableESP()
        EspButton.Text = "ESP OFF"
    else
        enableESP()
        EspButton.Text = "ESP ON"
    end
end)
