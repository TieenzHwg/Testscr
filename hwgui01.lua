local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local TeleportTarget = nil
local walkspeed = 16

local screen = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screen.ResetOnSpawn = false

local frame = Instance.new("Frame", screen)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.Size = UDim2.new(0, 300, 0, 180)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderColor3 = Color3.fromRGB(255, 0, 0)

local uilist = Instance.new("UIListLayout", frame)
uilist.SortOrder = Enum.SortOrder.LayoutOrder
uilist.Padding = UDim.new(0, 6)

local function createLabel(text)
	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1, 0, 0, 30)
	label.Text = text
	label.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextScaled = true
	label.LayoutOrder = 0
end

local speedControl = Instance.new("Frame", frame)
speedControl.Size = UDim2.new(1, 0, 0, 30)
speedControl.BackgroundTransparency = 1
speedControl.LayoutOrder = 1

local minus = Instance.new("TextButton", speedControl)
minus.Text = "-"
minus.Size = UDim2.new(0, 50, 1, 0)
minus.Position = UDim2.new(0, 0, 0, 0)
minus.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minus.TextColor3 = Color3.new(1, 1, 1)

local speedValue = Instance.new("TextLabel", speedControl)
speedValue.Text = tostring(walkspeed)
speedValue.Size = UDim2.new(0, 100, 1, 0)
speedValue.Position = UDim2.new(0, 70, 0, 0)
speedValue.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
speedValue.TextColor3 = Color3.new(1, 1, 1)
speedValue.TextScaled = true

local plus = Instance.new("TextButton", speedControl)
plus.Text = "+"
plus.Size = UDim2.new(0, 50, 1, 0)
plus.Position = UDim2.new(0, 180, 0, 0)
plus.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
plus.TextColor3 = Color3.new(1, 1, 1)

minus.MouseButton1Click:Connect(function()
	walkspeed = math.max(16, walkspeed - 25)
	speedValue.Text = tostring(walkspeed)
end)

plus.MouseButton1Click:Connect(function()
	walkspeed = walkspeed + 25
	speedValue.Text = tostring(walkspeed)
end)

local teleportLabel = Instance.new("TextLabel", frame)
teleportLabel.Size = UDim2.new(1, 0, 0, 30)
teleportLabel.Text = "teleport player🟢"
teleportLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
teleportLabel.TextColor3 = Color3.new(1, 1, 1)
teleportLabel.TextScaled = true
teleportLabel.LayoutOrder = 2

local inputBox = Instance.new("TextBox", frame)
inputBox.PlaceholderText = "@username"
inputBox.Size = UDim2.new(1, 0, 0, 30)
inputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
inputBox.TextColor3 = Color3.new(1, 1, 1)
inputBox.TextScaled = true
inputBox.LayoutOrder = 3

inputBox.FocusLost:Connect(function()
	local text = inputBox.Text
	if text ~= "" and text:sub(1,1) == "@" then
		local name = text:sub(2)
		local plr = Players:FindFirstChild(name)
		if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			LocalPlayer.Character:MoveTo(plr.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
		end
	end
end)

local playerDropdown = Instance.new("TextButton", frame)
playerDropdown.Text = "select player in server"
playerDropdown.Size = UDim2.new(1, 0, 0, 30)
playerDropdown.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
playerDropdown.TextColor3 = Color3.new(1, 1, 1)
playerDropdown.TextScaled = true
playerDropdown.LayoutOrder = 4

local playerList = Instance.new("Frame", frame)
playerList.Size = UDim2.new(1, 0, 0, 100)
playerList.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
playerList.Visible = false
playerList.LayoutOrder = 5

local listLayout = Instance.new("UIListLayout", playerList)
listLayout.SortOrder = Enum.SortOrder.LayoutOrder

playerDropdown.MouseButton1Click:Connect(function()
	playerList.Visible = not playerList.Visible
end)

local function refreshList()
	for _, child in ipairs(playerList:GetChildren()) do
		if child:IsA("TextButton") then child:Destroy() end
	end
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local btn = Instance.new("TextButton", playerList)
			btn.Size = UDim2.new(1, 0, 0, 25)
			btn.Text = player.Name
			btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.MouseButton1Click:Connect(function()
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					LocalPlayer.Character:MoveTo(player.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
				end
			end)
		end
	end
end

Players.PlayerAdded:Connect(refreshList)
Players.PlayerRemoving:Connect(refreshList)
refreshList()

game:GetService("RunService").RenderStepped:Connect(function()
	if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
		LocalPlayer.Character.Humanoid.WalkSpeed = walkspeed
	end
end)
