local Players = game:GetService("Players") local LocalPlayer = Players.LocalPlayer local Mouse = LocalPlayer:GetMouse() local UIS = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui") ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") ScreenGui.Name = "Y44I_GUI"

local MainFrame = Instance.new("Frame") MainFrame.Size = UDim2.new(0, 400, 0, 370) MainFrame.Position = UDim2.new(0.5, -200, 0.5, -185) MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40) MainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255) MainFrame.BorderSizePixel = 2 MainFrame.Active = true MainFrame.Draggable = true MainFrame.Parent = ScreenGui

local ToggleButton = Instance.new("TextButton") ToggleButton.Size = UDim2.new(1, 0, 0, 30) ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30) ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255) ToggleButton.Text = "Y44I GU1 ☻" ToggleButton.Parent = MainFrame

local ContentFrame = Instance.new("Frame") ContentFrame.Size = UDim2.new(1, 0, 1, -30) ContentFrame.Position = UDim2.new(0, 0, 0, 30) ContentFrame.BackgroundTransparency = 1 ContentFrame.Parent = MainFrame

local function createButton(text, pos) local btn = Instance.new("TextButton") btn.Size = UDim2.new(0, 120, 0, 30) btn.Position = pos btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60) btn.BorderColor3 = Color3.fromRGB(255, 255, 255) btn.TextColor3 = Color3.fromRGB(255, 255, 255) btn.Text = text btn.Parent = ContentFrame return btn end

local function createLabel(text, pos) local lbl = Instance.new("TextLabel") lbl.Size = UDim2.new(0, 120, 0, 30) lbl.Position = pos lbl.BackgroundTransparency = 1 lbl.TextColor3 = Color3.fromRGB(255, 255, 255) lbl.Text = text lbl.Parent = ContentFrame return lbl end

local Speed = 100 local SpeedEnabled = true local FlyEnabled = false local FlySpeed = 100 local FollowEnabled = false local SelectedPlayer = nil

local SpeedLabel = createLabel("speed: 🟢", UDim2.new(0, 10, 0, 0)) local SpeedMinus = createButton("-", UDim2.new(0, 140, 0, 0)) local SpeedValue = createLabel(tostring(Speed), UDim2.new(0, 190, 0, 0)) local SpeedPlus = createButton("+", UDim2.new(0, 240, 0, 0))

local FlyLabel = createLabel("fly: 🔴", UDim2.new(0, 10, 0, 40)) local FlyMinus = createButton("-", UDim2.new(0, 140, 0, 40)) local FlyValue = createLabel(tostring(FlySpeed), UDim2.new(0, 190, 0, 40)) local FlyPlus = createButton("+", UDim2.new(0, 240, 0, 40))

local FollowToggle = createButton("bay theo player: 🔴", UDim2.new(0, 10, 0, 80))

local DropDown = Instance.new("TextButton") DropDown.Size = UDim2.new(0, 180, 0, 30) DropDown.Position = UDim2.new(0, 10, 0, 120) DropDown.Text = "chọn player ↓" DropDown.TextColor3 = Color3.fromRGB(255, 255, 255) DropDown.BackgroundColor3 = Color3.fromRGB(60, 60, 60) DropDown.BorderColor3 = Color3.fromRGB(255, 255, 255) DropDown.Parent = ContentFrame

local DropFrame = Instance.new("Frame") DropFrame.Size = UDim2.new(0, 180, 0, 150) DropFrame.Position = UDim2.new(0, 10, 0, 150) DropFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60) DropFrame.BorderColor3 = Color3.fromRGB(255, 255, 255) DropFrame.Visible = false DropFrame.ClipsDescendants = true DropFrame.ZIndex = 2 DropFrame.Parent = ContentFrame
-- Fly Feature
local FlyEnabled = true
local FlySpeed = 25

local FlyLabel = createButton("fly 🟢", UDim2.new(0,10,0,100), UDim2.new(0,150,0,30), ContentFrame)
local FlyMinus = createButton("-", UDim2.new(0,170,0,100), UDim2.new(0,30,0,30), ContentFrame)
local FlyNum = Instance.new("TextLabel", ContentFrame)
FlyNum.Size = UDim2.new(0,60,0,30)
FlyNum.Position = UDim2.new(0,205,0,100)
FlyNum.BackgroundTransparency = 1
FlyNum.TextColor3 = Color3.new(1,1,1)
FlyNum.Font = Enum.Font.SourceSansBold
FlyNum.TextSize = 18
FlyNum.Text = tostring(FlySpeed)
local FlyPlus = createButton("+", UDim2.new(0,270,0,100), UDim2.new(0,30,0,30), ContentFrame)

FlyLabel.MouseButton1Click:Connect(function()
    FlyEnabled = not FlyEnabled
    FlyLabel.Text = "fly " .. (FlyEnabled and "🟢" or "🔴")
end)

FlyMinus.MouseButton1Click:Connect(function()
    FlySpeed = math.max(0, FlySpeed - 25)
    FlyNum.Text = tostring(FlySpeed)
end)

FlyPlus.MouseButton1Click:Connect(function()
    FlySpeed = FlySpeed + 25
    FlyNum.Text = tostring(FlySpeed)
end)

-- Fly movement (noclip-style)
local flying = false
local function FlyLoop()
    local cam = workspace.CurrentCamera
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    flying = true
    while flying do
        local moveDir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir = moveDir + cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir = moveDir - cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir = moveDir - cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir = moveDir + cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir = moveDir + Vector3.new(0,1,0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            moveDir = moveDir - Vector3.new(0,1,0)
        end
        root.Velocity = moveDir.Unit * FlySpeed
        task.wait()
    end
end

RunService.RenderStepped:Connect(function()
    if FlyEnabled then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            if not flying then
                FlyLoop()
            end
        end
    else
        flying = false
    end
end)
