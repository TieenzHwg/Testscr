local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "HwGui1x1"

local button = Instance.new("TextButton", gui)
button.Size = UDim2.new(0, 30, 0, 30)
button.Position = UDim2.new(0, 100, 0, 100)
button.BackgroundColor3 = Color3.new(0, 0, 0)
button.BorderColor3 = Color3.new(1, 1, 1)
button.BorderSizePixel = 2
button.Text = ""

local dragging, dragInput, dragStart, startPos

button.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = button.Position
	end
end)

button.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

button.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

button.MouseButton1Click:Connect(function()
	local Lighting = game:GetService("Lighting")
	local oldSky = Lighting:FindFirstChildOfClass("Sky")
	if oldSky then oldSky:Destroy() end
	local sky = Instance.new("Sky")
	local id = "71624524466837"
	sky.SkyboxBk = "rbxassetid://"..id
	sky.SkyboxDn = "rbxassetid://"..id
	sky.SkyboxFt = "rbxassetid://"..id
	sky.SkyboxLf = "rbxassetid://"..id
	sky.SkyboxRt = "rbxassetid://"..id
	sky.SkyboxUp = "rbxassetid://"..id
	sky.Parent = Lighting
	Lighting.Ambient = Color3.new(0.15, 0.15, 0.15)
	Lighting.OutdoorAmbient = Color3.new(0.1, 0.1, 0.1)
	Lighting.Brightness = 2
end)
