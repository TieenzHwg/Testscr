local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false

local MenuFrame = Instance.new("Frame", ScreenGui)
MenuFrame.BackgroundColor3 = Color3.new(0, 0, 0)
MenuFrame.BorderColor3 = Color3.new(1, 0, 0)
MenuFrame.Position = UDim2.new(0, 50, 0, 100)
MenuFrame.Size = UDim2.new(0, 400, 0, 370)

local UICorner = Instance.new("UICorner", MenuFrame)
UICorner.CornerRadius = UDim.new(0, 8)

local ToggleButton = Instance.new("TextButton", MenuFrame)
ToggleButton.Size = UDim2.new(1, 0, 0, 30)
ToggleButton.Text = "thu ^"
ToggleButton.BackgroundColor3 = Color3.new(0, 0, 0)
ToggleButton.BorderColor3 = Color3.new(1, 0, 0)
ToggleButton.TextColor3 = Color3.new(1, 1, 1)

local ContentFrame = Instance.new("Frame", MenuFrame)
ContentFrame.Position = UDim2.new(0, 0, 0, 30)
ContentFrame.Size = UDim2.new(1, 0, 1, -30)
ContentFrame.BackgroundTransparency = 1

local function createLabel(text, posY)
	local lbl = Instance.new("TextLabel", ContentFrame)
	lbl.Position = UDim2.new(0, 10, 0, posY)
	lbl.Size = UDim2.new(0, 180, 0, 25)
	lbl.Text = text
	lbl.TextColor3 = Color3.new(1, 1, 1)
	lbl.BackgroundTransparency = 1
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	return lbl
end

local function createButton(text, pos, size, parent)
	local btn = Instance.new("TextButton", parent)
	btn.Position = pos
	btn.Size = size
	btn.Text = text
	btn.BackgroundColor3 = Color3.new(0, 0, 0)
	btn.BorderColor3 = Color3.new(1, 0, 0)
	btn.TextColor3 = Color3.new(1, 1, 1)
	return btn
end

local WalkSpeed = 25
local SpeedLabel = createLabel("walk speed 🟢", 10)
local MinusSpeed = createButton("-", UDim2.new(0, 150, 0, 10), UDim2.new(0, 30, 0, 25), ContentFrame)
local SpeedAmount = Instance.new("TextLabel", ContentFrame)
SpeedAmount.Position = UDim2.new(0, 185, 0, 10)
SpeedAmount.Size = UDim2.new(0, 50, 0, 25)
SpeedAmount.Text = tostring(WalkSpeed)
SpeedAmount.TextColor3 = Color3.new(1,1,1)
SpeedAmount.BackgroundTransparency = 1

local PlusSpeed = createButton("+", UDim2.new(0, 240, 0, 10), UDim2.new(0, 30, 0, 25), ContentFrame)

MinusSpeed.MouseButton1Click:Connect(function()
	WalkSpeed = math.max(0, WalkSpeed - 25)
	SpeedAmount.Text = tostring(WalkSpeed)
end)

PlusSpeed.MouseButton1Click:Connect(function()
	WalkSpeed = WalkSpeed + 25
	SpeedAmount.Text = tostring(WalkSpeed)
end)

RunService.RenderStepped:Connect(function()
	pcall(function()
		LocalPlayer.Character.Humanoid.WalkSpeed = WalkSpeed
	end)
end)

local FollowEnabled = true
local FollowLabel = createLabel("bay theo player 🟢", 50)

local DropDown = Instance.new("TextButton", ContentFrame)
DropDown.Position = UDim2.new(0, 10, 0, 80)
DropDown.Size = UDim2.new(0, 180, 0, 25)
DropDown.Text = "chọn player ↓"
DropDown.BackgroundColor3 = Color3.new(0, 0, 0)
DropDown.BorderColor3 = Color3.new(1, 0, 0)
DropDown.TextColor3 = Color3.new(1, 1, 1)

local PlayerBox = Instance.new("TextBox", ContentFrame)
PlayerBox.Position = UDim2.new(0, 200, 0, 80)
PlayerBox.Size = UDim2.new(0, 180, 0, 25)
PlayerBox.PlaceholderText = "nhập tên"
PlayerBox.BackgroundColor3 = Color3.new(0, 0, 0)
PlayerBox.BorderColor3 = Color3.new(1, 0, 0)
PlayerBox.TextColor3 = Color3.new(1, 1, 1)

local PlayerList = Instance.new("Frame", DropDown)
PlayerList.Position = UDim2.new(0, 0, 1, 0)
PlayerList.Size = UDim2.new(1, 0, 0, 100)
PlayerList.BackgroundColor3 = Color3.new(0, 0, 0)
PlayerList.BorderColor3 = Color3.new(1, 0, 0)
PlayerList.Visible = false

local UIListLayout = Instance.new("UIListLayout", PlayerList)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

DropDown.MouseButton1Click:Connect(function()
	PlayerList.Visible = not PlayerList.Visible
	PlayerList:ClearAllChildren()
	UIListLayout.Parent = PlayerList
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			local btn = createButton("@"..plr.Name, UDim2.new(), UDim2.new(1, 0, 0, 20), PlayerList)
			btn.MouseButton1Click:Connect(function()
				PlayerBox.Text = plr.Name
				PlayerList.Visible = false
			end)
		end
	end
end)

RunService.RenderStepped:Connect(function()
	if FollowEnabled and PlayerBox.Text ~= "" then
		local target = Players:FindFirstChild(PlayerBox.Text)
		if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			LocalPlayer.Character:MoveTo(target.Character.HumanoidRootPart.Position + Vector3.new(2,0,2))
		end
	end
end)

local ESPFolder = Instance.new("Folder", game.CoreGui)
RunService.RenderStepped:Connect(function()
	for _, v in pairs(ESPFolder:GetChildren()) do v:Destroy() end
	for _, plr in pairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
			local billboard = Instance.new("BillboardGui", ESPFolder)
			billboard.Adornee = plr.Character.Head
			billboard.Size = UDim2.new(0, 100, 0, 20)
			billboard.AlwaysOnTop = true
			local text = Instance.new("TextLabel", billboard)
			text.Size = UDim2.new(1, 0, 1, 0)
			text.Text = plr.Name
			text.BackgroundTransparency = 1
			text.TextColor3 = Color3.new(1,1,1)
			text.TextSize = 6
		end
	end
end)

ToggleButton.MouseButton1Click:Connect(function()
	if ContentFrame.Visible then
		ContentFrame.Visible = false
		MenuFrame.Size = UDim2.new(0, 400, 0, 30)
		ToggleButton.Text = "mở v"
	else
		ContentFrame.Visible = true
		MenuFrame.Size = UDim2.new(0, 400, 0, 370)
		ToggleButton.Text = "thu ^"
	end
end)
