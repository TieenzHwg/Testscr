--// UI tạo ESP và Aura + nút kéo
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 100)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 3
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)

-- nút kéo
local DragButton = Instance.new("TextButton", MainFrame)
DragButton.Size = UDim2.new(1, 0, 0, 20)
DragButton.Position = UDim2.new(0, 0, 0, 0)
DragButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
DragButton.Text = "[Kéo]"
DragButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- nút ESP
local ESPButton = Instance.new("TextButton", MainFrame)
ESPButton.Size = UDim2.new(0.5, -5, 0, 40)
ESPButton.Position = UDim2.new(0, 5, 0, 30)
ESPButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ESPButton.Text = "[ESP]"
ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- nút Aura
local AuraButton = Instance.new("TextButton", MainFrame)
AuraButton.Size = UDim2.new(0.5, -5, 0, 40)
AuraButton.Position = UDim2.new(0.5, 0, 0, 30)
AuraButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
AuraButton.Text = "[Aura]"
AuraButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- code kéo
local UIS = game:GetService("UserInputService")
local dragging, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

DragButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

DragButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        if dragging then
            update(input)
        end
    end
end)

-- ESP Code
local espEnabled = false
local espObjects = {}

local function createESP(plr)
    if plr == LocalPlayer then return end
    local Billboard = Instance.new("BillboardGui")
    Billboard.Adornee = plr.Character:WaitForChild("Head")
    Billboard.Size = UDim2.new(0,100,0,50)
    Billboard.AlwaysOnTop = true
    Billboard.Name = "ESP"

    local TextLabel = Instance.new("TextLabel", Billboard)
    TextLabel.Size = UDim2.new(1,0,1,0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = plr.Name
    TextLabel.TextColor3 = Color3.fromRGB(0,255,0)
    TextLabel.TextScaled = true

    Billboard.Parent = plr.Character
    espObjects[plr] = Billboard
end

local function removeESP(plr)
    if espObjects[plr] then
        espObjects[plr]:Destroy()
        espObjects[plr] = nil
    end
end

ESPButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        ESPButton.Text = "[ESP ✅]"
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                createESP(plr)
            end
        end
        Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function()
                if espEnabled then
                    createESP(plr)
                end
            end)
        end)
    else
        ESPButton.Text = "[ESP ❌]"
        for plr, gui in pairs(espObjects) do
            gui:Destroy()
        end
        espObjects = {}
    end
end)

-- Aura Code
local auraEnabled = false
local auraObjects = {}

local function createAura(plr)
    if plr == LocalPlayer then return end
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255,255,0) -- vàng
    highlight.OutlineColor = Color3.fromRGB(255,255,0)
    highlight.Parent = plr.Character
    auraObjects[plr] = highlight
end

local function removeAura(plr)
    if auraObjects[plr] then
        auraObjects[plr]:Destroy()
        auraObjects[plr] = nil
    end
end

AuraButton.MouseButton1Click:Connect(function()
    auraEnabled = not auraEnabled
    if auraEnabled then
        AuraButton.Text = "[Aura ✅]"
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                createAura(plr)
            end
        end
        Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function()
                if auraEnabled then
                    createAura(plr)
                end
            end)
        end)
    else
        AuraButton.Text = "[Aura ❌]"
        for plr, aura in pairs(auraObjects) do
            aura:Destroy()
        end
        auraObjects = {}
    end
end)
