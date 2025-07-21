local players = game:GetService("Players")
local player = players.LocalPlayer
local mouse = player:GetMouse()

local espEnabled = false
local walkSpeed = 25
local targetPlayer = nil

local espTab = Instance.new("Frame")
espTab.Size = UDim2.new(0, 300, 0, 150)
espTab.Position = UDim2.new(0, 0, 0, 100)
espTab.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
espTab.BackgroundTransparency = 0.5
espTab.Parent = player.PlayerGui

local walkSpeedLabel = Instance.new("TextLabel")
walkSpeedLabel.Size = UDim2.new(0, 200, 0, 50)
walkSpeedLabel.Position = UDim2.new(0, 50, 0, 20)
walkSpeedLabel.Text = "Walk Speed: " .. walkSpeed
walkSpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
walkSpeedLabel.BackgroundTransparency = 1
walkSpeedLabel.Parent = espTab

local walkSpeedMinus = Instance.new("TextButton")
walkSpeedMinus.Size = UDim2.new(0, 50, 0, 50)
walkSpeedMinus.Position = UDim2.new(0, 0, 0, 20)
walkSpeedMinus.Text = "-"
walkSpeedMinus.TextColor3 = Color3.fromRGB(255, 255, 255)
walkSpeedMinus.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
walkSpeedMinus.Parent = espTab

local walkSpeedPlus = Instance.new("TextButton")
walkSpeedPlus.Size = UDim2.new(0, 50, 0, 50)
walkSpeedPlus.Position = UDim2.new(0, 250, 0, 20)
walkSpeedPlus.Text = "+"
walkSpeedPlus.TextColor3 = Color3.fromRGB(255, 255, 255)
walkSpeedPlus.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
walkSpeedPlus.Parent = espTab

local teleportTab = Instance.new("Frame")
teleportTab.Size = UDim2.new(0, 300, 0, 150)
teleportTab.Position = UDim2.new(0, 0, 0, 270)
teleportTab.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
teleportTab.BackgroundTransparency = 0.5
teleportTab.Parent = player.PlayerGui

local teleportLabel = Instance.new("TextLabel")
teleportLabel.Size = UDim2.new(0, 200, 0, 50)
teleportLabel.Position = UDim2.new(0, 50, 0, 20)
teleportLabel.Text = "Teleport Player"
teleportLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportLabel.BackgroundTransparency = 1
teleportLabel.Parent = teleportTab

local usernameTextbox = Instance.new("TextBox")
usernameTextbox.Size = UDim2.new(0, 200, 0, 50)
usernameTextbox.Position = UDim2.new(0, 50, 0, 80)
usernameTextbox.Text = ""
usernameTextbox.PlaceholderText = "Enter Username"
usernameTextbox.TextColor3 = Color3.fromRGB(255, 255, 255)
usernameTextbox.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
usernameTextbox.Parent = teleportTab

local playerListDropdown = Instance.new("TextButton")
playerListDropdown.Size = UDim2.new(0, 100, 0, 50)
playerListDropdown.Position = UDim2.new(0, 250, 0, 80)
playerListDropdown.Text = "↓"
playerListDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
playerListDropdown.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
playerListDropdown.Parent = teleportTab

local playerListFrame = Instance.new("ScrollingFrame")
playerListFrame.Size = UDim2.new(0, 200, 0, 150)
playerListFrame.Position = UDim2.new(0, 50, 0, 150)
playerListFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
playerListFrame.BackgroundTransparency = 0.5
playerListFrame.Visible = false
playerListFrame.Parent = teleportTab

local function updatePlayerList()
    for _, child in pairs(playerListFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for _, otherPlayer in pairs(players:GetPlayers()) do
        if otherPlayer ~= player then
            local playerButton = Instance.new("TextButton")
            playerButton.Size = UDim2.new(0, 200, 0, 50)
            playerButton.Text = "@" .. otherPlayer.Name
            playerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            playerButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            playerButton.Parent = playerListFrame
            playerButton.MouseButton1Click:Connect(function()
                usernameTextbox.Text = otherPlayer.Name
                playerListFrame.Visible = false
            end)
        end
    end
end

playerListDropdown.MouseButton1Click:Connect(function()
    playerListFrame.Visible = not playerListFrame.Visible
    if playerListFrame.Visible then
        updatePlayerList()
    end
end)

walkSpeedMinus.MouseButton1Click:Connect(function()
    walkSpeed = walkSpeed - 25
    walkSpeedLabel.Text = "Walk Speed: " .. walkSpeed
    player.Character.Humanoid.WalkSpeed = walkSpeed
end)

walkSpeedPlus.MouseButton1Click:Connect(function()
    walkSpeed = walkSpeed + 25
    walkSpeedLabel.Text = "Walk Speed: " .. walkSpeed
    player.Character.Humanoid.WalkSpeed = walkSpeed
end)

usernameTextbox.FocusLost:Connect(function()
    local target = players:FindFirstChild(usernameTextbox.Text)
    if target then
        targetPlayer = target
    end
end)
