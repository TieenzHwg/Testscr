local players = game:GetService("Players")
local lp = players.LocalPlayer
local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
gui.Name = "Y44IGUI"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 400, 0, 370)
main.Position = UDim2.new(0.5, -200, 0.5, -185)
main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
main.BorderColor3 = Color3.fromRGB(255, 0, 0)
main.Active = true
main.Draggable = true

local collapsed = false
local collapseBtn = Instance.new("TextButton", main)
collapseBtn.Size = UDim2.new(1, 0, 0, 30)
collapseBtn.Text = "Y44I GU1 ☻"
collapseBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
collapseBtn.TextColor3 = Color3.new(1, 1, 1)
collapseBtn.BorderColor3 = Color3.fromRGB(255, 0, 0)
collapseBtn.MouseButton1Click:Connect(function()
	collapsed = not collapsed
	main.Size = collapsed and UDim2.new(0, 400, 0, 30) or UDim2.new(0, 400, 0, 370)
end)

local function redBtn(parent, text, pos, size)
	local btn = Instance.new("TextButton", parent)
	btn.Text = text
	btn.Size = size
	btn.Position = pos
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.BorderColor3 = Color3.fromRGB(255, 0, 0)
	btn.TextColor3 = Color3.new(1, 1, 1)
	return btn
end

local flyBtn = redBtn(main, "fly 🟢", UDim2.new(0, 10, 0, 40), UDim2.new(0, 80, 0, 30))
flyBtn.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet("https://gist.githubusercontent.com/meozoneYT/bf037dff9f0a70017304ddd67fdcd370/raw/e14e74f425b060df523343cf30b787074eb3c5d2/arceus%2520x%2520fly%2520obflucator"))()
end)

local speed = 25
local speedToggle = true
local speedLbl = redBtn(main, "speed 🟢", UDim2.new(0, 100, 0, 40), UDim2.new(0, 80, 0, 30))

local minusBtn = redBtn(main, "-", UDim2.new(0, 190, 0, 40), UDim2.new(0, 30, 0, 30))
local plusBtn = redBtn(main, "+", UDim2.new(0, 230, 0, 40), UDim2.new(0, 30, 0, 30))

minusBtn.MouseButton1Click:Connect(function()
	speed = math.max(0, speed - 25)
	lp.Character.Humanoid.WalkSpeed = speed
end)

plusBtn.MouseButton1Click:Connect(function()
	speed = speed + 25
	lp.Character.Humanoid.WalkSpeed = speed
end)

speedLbl.MouseButton1Click:Connect(function()
	speedToggle = not speedToggle
	speedLbl.Text = "speed " .. (speedToggle and "🟢" or "🔴")
	lp.Character.Humanoid.WalkSpeed = speedToggle and speed or 16
end)

local scroll = Instance.new("ScrollingFrame", main)
scroll.Size = UDim2.new(0, 380, 0, 200)
scroll.Position = UDim2.new(0, 10, 0, 80)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
scroll.BorderColor3 = Color3.fromRGB(255, 0, 0)
scroll.ScrollBarThickness = 4

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 2)

local function updatePlayerList()
	scroll:ClearAllChildren()
	layout.Parent = scroll
	for _, plr in pairs(players:GetPlayers()) do
		local nameBtn = redBtn(scroll, "@ " .. plr.Name .. " ||", UDim2.new(), UDim2.new(1, -10, 0, 30))
		nameBtn.TextXAlignment = Enum.TextXAlignment.Left
	end
	scroll.CanvasSize = UDim2.new(0, 0, 0, #players:GetPlayers() * 32)
end

updatePlayerList()
players.PlayerAdded:Connect(updatePlayerList)
players.PlayerRemoving:Connect(updatePlayerList)
