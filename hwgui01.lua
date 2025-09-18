-- ESP + Aura GUI (kéo / thu / aura / esp)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- xóa gui cũ nếu có
local OLD = PlayerGui:FindFirstChild("Y44I_ESP_GUI")
if OLD then OLD:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Y44I_ESP_GUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 260, 0, 90)
mainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
mainFrame.BorderColor3 = Color3.fromRGB(255,0,0)
mainFrame.BorderSizePixel = 2
mainFrame.Parent = ScreenGui

local BUTTON_W, BUTTON_H = 120, 28
local PAD = 5

-- Kéo (left top)
local dragBtn = Instance.new("TextButton")
dragBtn.Name = "DragBtn"
dragBtn.Size = UDim2.new(0, BUTTON_W, 0, BUTTON_H)
dragBtn.Position = UDim2.new(0, PAD, 0, PAD)
dragBtn.Text = "kéo"
dragBtn.Font = Enum.Font.SourceSansBold
dragBtn.TextSize = 16
dragBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
dragBtn.BorderColor3 = Color3.fromRGB(255,0,0)
dragBtn.BorderSizePixel = 2
dragBtn.TextColor3 = Color3.new(1,1,1)
dragBtn.Parent = mainFrame

-- Thu gọn (right top)
local minBtn = Instance.new("TextButton")
minBtn.Name = "MinBtn"
minBtn.Size = UDim2.new(0, BUTTON_W, 0, BUTTON_H)
minBtn.Position = UDim2.new(0, PAD + BUTTON_W + PAD, 0, PAD)
minBtn.Text = "thu"
minBtn.Font = Enum.Font.SourceSansBold
minBtn.TextSize = 16
minBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
minBtn.BorderColor3 = Color3.fromRGB(255,0,0)
minBtn.BorderSizePixel = 2
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.Parent = mainFrame

-- Aura (left bottom)
local auraBtn = Instance.new("TextButton")
auraBtn.Name = "AuraBtn"
auraBtn.Size = UDim2.new(0, BUTTON_W, 0, BUTTON_H)
auraBtn.Position = UDim2.new(0, PAD, 0, PAD + BUTTON_H + PAD)
auraBtn.Text = "aura: OFF"
auraBtn.Font = Enum.Font.SourceSansBold
auraBtn.TextSize = 14
auraBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
auraBtn.BorderColor3 = Color3.fromRGB(255,0,0)
auraBtn.BorderSizePixel = 2
auraBtn.TextColor3 = Color3.new(1,1,1)
auraBtn.Parent = mainFrame

-- ESP (right bottom)
local espBtn = Instance.new("TextButton")
espBtn.Name = "ESPBtn"
espBtn.Size = UDim2.new(0, BUTTON_W, 0, BUTTON_H)
espBtn.Position = UDim2.new(0, PAD + BUTTON_W + PAD, 0, PAD + BUTTON_H + PAD)
espBtn.Text = "esp: OFF"
espBtn.Font = Enum.Font.SourceSansBold
espBtn.TextSize = 14
espBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
espBtn.BorderColor3 = Color3.fromRGB(255,0,0)
espBtn.BorderSizePixel = 2
espBtn.TextColor3 = Color3.new(1,1,1)
espBtn.Parent = mainFrame

-- trạng thái
local espEnabled = false
local auraEnabled = false
local minimized = false

-- hàm tạo ESP / Xóa ESP
local function createESP(plr)
    if not plr.Character then return end
    local head = plr.Character:FindFirstChild("Head")
    if not head then return end
    if head:FindFirstChild("Y44I_ESP_Label") then return end

    local b = Instance.new("BillboardGui")
    b.Name = "Y44I_ESP_Label"
    b.Size = UDim2.new(0, 140, 0, 26)
    b.StudsOffset = Vector3.new(0, 2.4, 0)
    b.AlwaysOnTop = true
    b.Parent = head

    local t = Instance.new("TextLabel", b)
    t.Size = UDim2.new(1,0,1,0)
    t.BackgroundTransparency = 1
    t.Text = plr.Name
    t.TextColor3 = Color3.new(1,1,1)
    t.Font = Enum.Font.SourceSansBold
    t.TextSize = 14
    t.TextStrokeTransparency = 0.8
end

local function removeESP(plr)
    if not plr.Character then return end
    local head = plr.Character:FindFirstChild("Head")
    if head then
        local lab = head:FindFirstChild("Y44I_ESP_Label")
        if lab then lab:Destroy() end
    end
end

-- hàm tạo Aura / Xóa Aura (dùng SelectionBox)
local function createAura(plr)
    if not plr.Character then return end
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if hrp:FindFirstChild("Y44I_Aura") then return end

    local box = Instance.new("SelectionBox")
    box.Name = "Y44I_Aura"
    box.Adornee = hrp
    box.LineThickness = 0.06
    box.Color3 = Color3.fromRGB(255, 210, 75) -- vàng
    box.Parent = hrp
end

local function removeAura(plr)
    if not plr.Character then return end
    local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local a = hrp:FindFirstChild("Y44I_Aura")
        if a then a:Destroy() end
    end
end

-- áp dụng toggle cho 1 người
local function applyESPToPlayer(plr)
    if plr == LocalPlayer then return end
    if espEnabled then createESP(plr) else removeESP(plr) end
end
local function applyAuraToPlayer(plr)
    if plr == LocalPlayer then return end
    if auraEnabled then createAura(plr) else removeAura(plr) end
end

-- khi player / character thêm vào
local function bindPlayer(plr)
    plr.CharacterAdded:Connect(function(char)
        wait(0.4)
        applyESPToPlayer(plr)
        applyAuraToPlayer(plr)
    end)
end

-- kết nối hiện có
for _, plr in pairs(Players:GetPlayers()) do
    bindPlayer(plr)
    -- nếu đã có character thì áp dụng ngay
    if plr.Character then
        wait(0.05)
        applyESPToPlayer(plr)
        applyAuraToPlayer(plr)
    end
end

Players.PlayerAdded:Connect(function(plr)
    bindPlayer(plr)
    -- khi vào ngay thì áp dụng nếu bật
    plr.CharacterAdded:Wait()
    wait(0.2)
    applyESPToPlayer(plr)
    applyAuraToPlayer(plr)
end)

Players.PlayerRemoving:Connect(function(plr)
    -- không cần làm gì đặc biệt; cleanup khi leave
end)

-- click handlers
espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espBtn.Text = "esp: " .. (espEnabled and "ON" or "OFF")
    for _,plr in pairs(Players:GetPlayers()) do
        applyESPToPlayer(plr)
    end
end)

auraBtn.MouseButton1Click:Connect(function()
    auraEnabled = not auraEnabled
    auraBtn.Text = "aura: " .. (auraEnabled and "ON" or "OFF")
    for _,plr in pairs(Players:GetPlayers()) do
        applyAuraToPlayer(plr)
    end
end)

-- MINIMIZE (thu gọn)
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        auraBtn.Visible = false
        espBtn.Visible = false
        mainFrame.Size = UDim2.new(0, 260, 0, BUTTON_H + PAD*2) -- chỉ top row
    else
        auraBtn.Visible = true
        espBtn.Visible = true
        mainFrame.Size = UDim2.new(0, 260, 0, 90)
    end
end)

-- KÉO (kéo bằng nút dragBtn)
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end

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

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

-- đảm bảo khi tắt aura/esp, xóa hết các object thừa
local function cleanupAll()
    for _, plr in pairs(Players:GetPlayers()) do
        removeESP(plr)
        removeAura(plr)
    end
end

-- nếu script bị reload, đảm bảo không để dư
if not espEnabled and not auraEnabled then
    -- nothing
end
