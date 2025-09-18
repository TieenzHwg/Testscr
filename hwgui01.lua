local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 50)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -25)
MainFrame.BackgroundColor3 = Color3.new(0,0,0)
MainFrame.BorderColor3 = Color3.new(1,0,0)
MainFrame.BorderSizePixel = 3

-- ESP toggle button
local ESPButton = Instance.new("TextButton", MainFrame)
ESPButton.Size = UDim2.new(0.7, 0, 1, 0)
ESPButton.Position = UDim2.new(0,0,0,0)
ESPButton.Text = "ESP [OFF]"
ESPButton.Font = Enum.Font.Code
ESPButton.TextSize = 18
ESPButton.TextColor3 = Color3.new(1,1,1)
ESPButton.BackgroundColor3 = Color3.new(0,0,0)
ESPButton.BorderColor3 = Color3.new(1,0,0)

local espEnabled = false
ESPButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    ESPButton.Text = "ESP " .. (espEnabled and "[ON]" or "[OFF]")
    print("ESP:", espEnabled)
end)

-- Dot drag handle
local DragDot = Instance.new("TextButton", MainFrame)
DragDot.Size = UDim2.new(0.3, 0, 1, 0)
DragDot.Position = UDim2.new(0.7,0,0,0)
DragDot.Text = "•"
DragDot.Font = Enum.Font.Code
DragDot.TextSize = 20
DragDot.TextColor3 = Color3.new(1,0,0)
DragDot.BackgroundColor3 = Color3.new(0,0,0)
DragDot.BorderColor3 = Color3.new(1,0,0)

-- Dragging
local UserInputService = game:GetService("UserInputService")
local dragging, dragStart, startPos

DragDot.MouseButton1Down:Connect(function(input)
    dragging = true
    dragStart = input.Position
    startPos = MainFrame.Position
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)
