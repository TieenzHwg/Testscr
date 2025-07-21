local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local speed = 16
local flySpeed = 0
local flyEnabled = false
local speedEnabled = false
local auraEnabled = false

local scr = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
scr.ResetOnSpawn = false

local frame = Instance.new("Frame", scr)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BorderColor3 = Color3.new(1, 0, 0)
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0, 100, 0, 100)
frame.Active = true
frame.Draggable = true

local corners = {}
for _, p in pairs({Vector2.new(0,0), Vector2.new(1,0), Vector2.new(0,1), Vector2.new(1,1),
                   Vector2.new(0.5,0), Vector2.new(0.5,1), Vector2.new(0,0.5), Vector2.new(1,0.5)}) do
	local dot = Instance.new("Frame", frame)
	dot.BackgroundColor3 = Color3.new(1,0,0)
	dot.Size = UDim2.new(0,6,0,6)
	dot.Position = UDim2.new(p.X, -3, p.Y, -3)
	dot.AnchorPoint = p
	dot.BorderSizePixel = 0
	dot.Name = "Resizer"
	table.insert(corners, dot)
end

local draggingCorner, dragStart, startSize, startPos
for _, dot in pairs(corners) do
	dot.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingCorner = dot
			dragStart = input.Position
			startSize = frame.Size
			startPos = frame.Position
		end
	end)
end

UIS.InputChanged:Connect(function(input)
	if draggingCorner and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		local anchor = draggingCorner.AnchorPoint
		local newSize = UDim2.new(0, startSize.X.Offset + delta.X * (anchor.X == 0 and 1 or -1),
		                          0, startSize.Y.Offset + delta.Y * (anchor.Y == 0 and 1 or -1))
		local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + (anchor.X == 1 and delta.X or 0),
		                         startPos.Y.Scale, startPos.Y.Offset + (anchor.Y == 1 and delta.Y or 0))
		frame.Size = newSize
		frame.Position = newPos
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingCorner = nil
	end
end)

function makeButton(text, y, toggleFn, incFn, decFn)
	local lbl = Instance.new("TextButton", frame)
	lbl.Size = UDim2.new(1, -10, 0, 25)
	lbl.Position = UDim2.new(0, 5, 0, y)
	lbl.BackgroundColor3 = Color3.new(0, 0, 0)
	lbl.BorderColor3 = Color3.new(1, 0, 0)
	lbl.TextColor3 = Color3.new(1,1,1)
	lbl.Text = text
	lbl.TextScaled = true
	lbl.MouseButton1Click:Connect(toggleFn)

	if incFn and decFn then
		local minus = Instance.new("TextButton", lbl)
		minus.Text = "-"
		minus.Size = UDim2.new(0, 25, 1, 0)
		minus.Position = UDim2.new(1, -75, 0, 0)
		minus.TextColor3 = Color3.new(1,1,1)
		minus.BackgroundColor3 = Color3.new(0,0,0)
		minus.BorderColor3 = Color3.new(1,0,0)
		minus.MouseButton1Click:Connect(decFn)

		local plus = Instance.new("TextButton", lbl)
		plus.Text = "+"
		plus.Size = UDim2.new(0, 25, 1, 0)
		plus.Position = UDim2.new(1, -25, 0, 0)
		plus.TextColor3 = Color3.new(1,1,1)
		plus.BackgroundColor3 = Color3.new(0,0,0)
		plus.BorderColor3 = Color3.new(1,0,0)
		plus.MouseButton1Click:Connect(incFn)

		local val = Instance.new("TextLabel", lbl)
		val.Text = "0"
		val.Size = UDim2.new(0, 25, 1, 0)
		val.Position = UDim2.new(1, -50, 0, 0)
		val.TextColor3 = Color3.new(1,1,1)
		val.BackgroundTransparency = 1
		val.Name = "Value"
	end

	return lbl
end

local spdBtn = makeButton("speed", 10,
	function() speedEnabled = not speedEnabled end,
	function() speed += 25 spdBtn.Value.Text = tostring(speed) end,
	function() speed -= 25 spdBtn.Value.Text = tostring(speed) end
)
spdBtn.Value.Text = tostring(speed)

local flyBtn = makeButton("fly", 40,
	function() flyEnabled = not flyEnabled end,
	function() flySpeed += 25 flyBtn.Value.Text = tostring(flySpeed) end,
	function() flySpeed -= 25 flyBtn.Value.Text = tostring(flySpeed) end
)
flyBtn.Value.Text = tostring(flySpeed)

makeButton("kill aura", 70, function()
	auraEnabled = not auraEnabled
end)

function createESP(player)
	if player == lp then return end
	player.CharacterAdded:Connect(function()
		wait(1)
		local head = player.Character:FindFirstChild("Head")
		if head and not head:FindFirstChild("ESP") then
			local bill = Instance.new("BillboardGui", head)
			bill.Name = "ESP"
			bill.Size = UDim2.new(0,100,0,6)
			bill.Adornee = head
			bill.AlwaysOnTop = true

			local lbl = Instance.new("TextLabel", bill)
			lbl.Text = player.Name
			lbl.Size = UDim2.new(1,0,1,0)
			lbl.BackgroundTransparency = 1
			lbl.TextColor3 = Color3.new(1,0,0)
			lbl.TextScaled = true
		end
	end)
end

for _, p in pairs(Players:GetPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(createESP)

RunService.RenderStepped:Connect(function()
	if auraEnabled then
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= lp and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character:FindFirstChild("HumanoidRootPart") then
				p.Character.Humanoid:TakeDamage(50)
			end
		end
	end
end)

RunService.RenderStepped:Connect(function()
	local char = lp.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.WalkSpeed = speedEnabled and speed or 16
		end
	end

	if flyEnabled and char and char:FindFirstChild("HumanoidRootPart") then
		if not char.HumanoidRootPart:FindFirstChild("FlyForce") then
			local bv = Instance.new("BodyVelocity")
			bv.Name = "FlyForce"
			bv.MaxForce = Vector3.new(1e5,1e5,1e5)
			bv.Velocity = Vector3.zero
			bv.Parent = char.HumanoidRootPart
		end

		local cam = workspace.CurrentCamera
		local move = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
		if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0,1,0) end

		char.HumanoidRootPart.FlyForce.Velocity = move.Unit * flySpeed
	else
		if char and char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart:FindFirstChild("FlyForce") then
			char.HumanoidRootPart.FlyForce:Destroy()
		end
	end
end)
