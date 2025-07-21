local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local followTarget = nil

-- ESP
local function createESP(player)
	if player == LocalPlayer then return end
	if player.Character and player.Character:FindFirstChild("Head") and not player.Character:FindFirstChild("ESP") then
		local bb = Instance.new("BillboardGui")
		bb.Name = "ESP"
		bb.Size = UDim2.new(0, 100, 0, 20)
		bb.StudsOffset = Vector3.new(0, 3, 0)
		bb.Adornee = player.Character.Head
		bb.AlwaysOnTop = true
		bb.Parent = player.Character

		local name = Instance.new("TextLabel", bb)
		name.Size = UDim2.new(1, 0, 1, 0)
		name.BackgroundTransparency = 1
		name.Text = player.Name
		name.TextColor3 = Color3.new(1, 0, 0)
		name.TextScaled = true
	end
end

for _, p in pairs(Players:GetPlayers()) do
	createESP(p)
end

Players.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function()
		wait(1)
		createESP(p)
	end)
end)

-- UI follow
local gui = Instance.new("ScreenGui", game.CoreGui)
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 50)
frame.Position = UDim2.new(0, 100, 0, 100)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BorderColor3 = Color3.new(1, 0, 0)
frame.BorderSizePixel = 2

local input = Instance.new("TextBox", frame)
input.Size = UDim2.new(1, -20, 1, -10)
input.Position = UDim2.new(0, 10, 0, 5)
input.PlaceholderText = "@username | follow"
input.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
input.TextColor3 = Color3.new(1, 1, 1)
input.BorderColor3 = Color3.new(1, 0, 0)

input.FocusLost:Connect(function()
	local txt = input.Text
	if string.find(txt, "|") then
		local username, cmd = txt:match("@(.-)%s*|%s*(.+)")
		if username and cmd and cmd:lower() == "follow" then
			local target = Players:FindFirstChild(username)
			if target then
				followTarget = target
			end
		end
	end
end)

-- Bay dính theo target
RunService.RenderStepped:Connect(function()
	if followTarget and followTarget.Character and followTarget.Character:FindFirstChild("HumanoidRootPart") then
		local root = followTarget.Character.HumanoidRootPart
		local char = LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = root.CFrame * CFrame.new(0, 2, 0)
		end
	end
end)
