local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
local MainButton = Instance.new("TextButton")
local MenuFrame = Instance.new("Frame")

MainButton.Text = ""
MainButton.Size = UDim2.new(0, 25, 0, 25)
MainButton.Position = UDim2.new(0, 10, 0, 10)
MainButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainButton.BorderColor3 = Color3.fromRGB(255, 0, 0)
MainButton.BorderSizePixel = 2
MainButton.Parent = ScreenGui
MainButton.Draggable = true
MainButton.Active = true

MenuFrame.Size = UDim2.new(0, 220, 0, 100)
MenuFrame.Position = UDim2.new(0, 40, 0, 50)
MenuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MenuFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MenuFrame.BorderSizePixel = 2
MenuFrame.Visible = false
MenuFrame.Parent = ScreenGui

local SpeedLabel = Instance.new("TextLabel", MenuFrame)
SpeedLabel.Size = UDim2.new(0, 200, 0, 20)
SpeedLabel.Position = UDim2.new(0, 10, 0, 10)
SpeedLabel.Text = "Tăng tốc độ"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.BackgroundTransparency = 1

local MinusButton = Instance.new("TextButton", MenuFrame)
MinusButton.Size = UDim2.new(0, 40, 0, 30)
MinusButton.Position = UDim2.new(0, 10, 0, 35)
MinusButton.Text = "-"
MinusButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MinusButton.BorderColor3 = Color3.fromRGB(255, 0, 0)
MinusButton.BorderSizePixel = 2

local SpeedDisplay = Instance.new("TextLabel", MenuFrame)
SpeedDisplay.Size = UDim2.new(0, 40, 0, 30)
SpeedDisplay.Position = UDim2.new(0, 60, 0, 35)
SpeedDisplay.Text = "16"
SpeedDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedDisplay.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
SpeedDisplay.BorderColor3 = Color3.fromRGB(255, 0, 0)
SpeedDisplay.BorderSizePixel = 2

local PlusButton = Instance.new("TextButton", MenuFrame)
PlusButton.Size = UDim2.new(0, 40, 0, 30)
PlusButton.Position = UDim2.new(0, 110, 0, 35)
PlusButton.Text = "+"
PlusButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
PlusButton.BorderColor3 = Color3.fromRGB(255, 0, 0)
PlusButton.BorderSizePixel = 2

local speed = 16
local function updateSpeed()
	local human = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if human then
		human.WalkSpeed
