-- Gui ESP + Aura + Toggle/Drag
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Tạo ScreenGui
local screenGui = Instance.new("ScreenGui", game.CoreGui)

-- Khung chính
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 200, 0, 120)
mainFrame.Position = UDim2.new(0.4, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
mainFrame.BorderColor3 = Color3.fromRGB(255,0,0)
mainFrame.Parent = screenGui

-- Nút kéo/thu gọn
local dragBtn = Instance.new("TextButton")
dragBtn.Size = UDim2.new(0, 200, 0, 25)
dragBtn.Position = UDim2.new(0, 0, 0, 0)
dragBtn.Text = "[•]"
dragBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
dragBtn.BorderColor3 = Color3.fromRGB(255,0,0)
dragBtn.TextColor3 = Color3.fromRGB(255,255,255)
dragBtn.Parent = mainFrame

-- Nút ESP
local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(0, 200, 0, 30)
espBtn.Position = UDim2.new(0, 0, 0, 30)
espBtn.Text = "[ESP: OFF]"
espBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
espBtn.BorderColor3 = Color3.fromRGB(255,0,0)
espBtn.TextColor3 = Color3.fromRGB(255,255,255)
espBtn.Parent = mainFrame

-- Nút Aura
local auraBtn = Instance.new("TextButton")
auraBtn.Size = UDim2.new(0, 200, 0, 30)
auraBtn.Position = UDim2.new(0, 0, 0, 65)
auraBtn.Text = "[AURA: OFF]"
auraBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
auraBtn.BorderColor3 = Color3.fromRGB(255,0,0)
auraBtn.TextColor3 = Color3.fromRGB(255,255,255)
auraBtn.Parent = mainFrame

-- Biến trạng thái
local espEnabled = false
local auraEnabled = false
local minimized = false

-- Hàm ESP
local function toggleESP()
    espEnabled = not espEnabled
    espBtn.Text = "[ESP: " .. (espEnabled and "ON" or "OFF") .. "]"

    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            if espEnabled then
                if not plr.Character then continue end
                if plr.Character:FindFirstChild("Head") and not plr.Character.Head:FindFirstChild("NameTag") then
                    local billboard = Instance.new("BillboardGui", plr.Character.Head)
                    billboard.Name = "NameTag"
                    billboard.Size = UDim2.new(0,100,0,30)
                    billboard.AlwaysOnTop = true
                    local label = Instance.new("TextLabel", billboard)
                    label.Size = UDim2.new(1,0,1,0)
                    label.BackgroundTransparency = 1
                    label.Text = plr.Name
                    label.TextColor3 = Color3.fromRGB(255,255,255)
                end
            else
                if plr.Character and plr.Character:FindFirstChild("Head") then
                    if plr.Character.Head:FindFirstChild("NameTag") then
                        plr.Character.Head.NameTag:Destroy()
                    end
                end
            end
        end
    end
end

-- Hàm Aura
local function toggleAura()
    auraEnabled = not auraEnabled
    auraBtn.Text = "[AURA: " .. (auraEnabled and "ON" or "OFF") .. "]"

    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if auraEnabled then
                if not plr.Character.HumanoidRootPart:FindFirstChild("Aura") then
                    local aura = Instance.new("SelectionCircle", plr.Character.HumanoidRootPart)
                    aura.Name = "Aura"
                    aura.Color3 = Color3.fromRGB(255, 255, 0)
                    aura.Adornee = plr.Character.HumanoidRootPart
                end
            else
                if plr.Character.HumanoidRootPart:FindFirstChild("Aura") then
                    plr.Character.HumanoidRootPart.Aura:Destroy()
                end
            end
        end
    end
end

-- Nút thu gọn/kéo
local dragging, dragInput, dragStart, startPos
dragBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    mainFrame.Size = minimized and UDim2.new(0,200,0,25) or UDim2.new(0,200,0,120)
end)

dragBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

dragBtn.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Kết nối nút
espBtn.MouseButton1Click:Connect(toggleESP)
auraBtn.MouseButton1Click:Connect(toggleAura)
