local ScreenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
local MainButton = Instance.new("TextButton")
local MenuFrame = Instance.new("Frame")

MainButton.Text = "Menu"
MainButton.Size = UDim2.new(0, 100, 0, 40)
MainButton.Position = UDim2.new(0, 50, 0, 50)
MainButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainButton.BorderColor3 = Color3.fromRGB(255, 0, 0)
MainButton.BorderSizePixel = 3
MainButton.Parent = ScreenGui
MainButton.Draggable = true
MainButton.Active = true

MenuFrame.Size = UDim2.new(0, 200, 0, 150)
MenuFrame.Position = UDim2.new(0, 50, 0, 100)
MenuFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MenuFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MenuFrame.BorderSizePixel = 2
MenuFrame.Visible = false
MenuFrame.Parent = ScreenGui

local Feature1 = Instance.new("TextButton", MenuFrame)
Feature1.Size = UDim2.new(0, 180, 0, 30)
Feature1.Position = UDim2.new(0, 10, 0, 10)
Feature1.Text = "Tăng tốc độ"
Feature1.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

Feature1.MouseButton1Click:Connect(function()
	local human = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if human then
		human.WalkSpeed = 100
	end
end)

MainButton.MouseButton1Click:Connect(function()
	MenuFrame.Visible = not MenuFrame.Visible
end)
