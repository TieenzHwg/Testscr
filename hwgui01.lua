local Players = game:GetService("Players") local UIS = game:GetService("UserInputService") local RunService = game:GetService("RunService") local lp = Players.LocalPlayer local char = lp.Character or lp.CharacterAdded:Wait() local hum = char:WaitForChild("Humanoid") local hrp = char:WaitForChild("HumanoidRootPart")

local gui = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui")) gui.ResetOnSpawn = false

local dragBtn = Instance.new("TextButton", gui) dragBtn.Size = UDim2.new(0, 25, 0, 25) dragBtn.Position = UDim2.new(0, 10, 0, 10) dragBtn.BackgroundColor3 = Color3.new(0, 0, 0) dragBtn.BorderColor3 = Color3.fromRGB(255, 0, 0) dragBtn.BorderSizePixel = 2 dragBtn.Text = "" dragBtn.Active = true dragBtn.Draggable = true

local menu = Instance.new("Frame", gui) menu.Size = UDim2.new(0, 220, 0, 150) menu.Position = UDim2.new(0, 40, 0, 50) menu.BackgroundColor3 = Color3.fromRGB(20, 20, 20) menu.BorderColor3 = Color3.fromRGB(255, 0, 0) menu.BorderSizePixel = 2 menu.Visible = false menu.Active = true menu.Draggable = true

dragBtn.MouseButton1Click:Connect(function() menu.Visible = not menu.Visible end)

local function createControl(labelText, yPos, initValue, step, callback) local label = Instance.new("TextButton", menu) label.Position = UDim2.new(0, 10, 0, yPos) label.Size = UDim2.new(0, 60, 0, 25) label.BackgroundColor3 = Color3.fromRGB(0, 0, 0) label.BorderColor3 = Color3.fromRGB(255, 0, 0) label.BorderSizePixel = 2 label.Text = labelText label.TextColor3 = Color3.new(1, 1, 1)

local minus = Instance.new("TextButton", menu)
minus.Position = UDim2.new(0, 75, 0, yPos)
minus.Size = UDim2.new(0, 30, 0, 25)
minus.Text = "-"
minus.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
minus.BorderColor3 = Color3.fromRGB(255, 0, 0)
minus.BorderSizePixel = 2

local valueLabel = Instance.new("TextLabel", menu)
valueLabel.Position = UDim2.new(0, 110, 0, yPos)
valueLabel.Size = UDim2.new(0, 30, 0, 25)
valueLabel.Text = tostring(initValue)
valueLabel.TextColor3 = Color3.new(1, 1, 1)
valueLabel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
valueLabel.BorderColor3 = Color3.fromRGB(255, 0, 0)
valueLabel.BorderSizePixel = 2

local plus = minus:Clone()
plus.Text = "+"
plus.Position = UDim2.new(0, 145, 0, yPos)
plus.Parent = menu

local val = initValue
local enabled = false

local function update()
	valueLabel.Text = tostring(val)
	callback(val, enabled)
end

label.MouseButton1Click:Connect(function()
	enabled = not enabled
	label.BackgroundColor3 = enabled and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 0, 0)
	update()
end)

plus.MouseButton1Click:Connect(function()
	val += step
	update()
end)

minus.MouseButton1Click:Connect(function()
	val = math.max(0, val - step)
	update()
end)

update()
return function() return enabled, val end

end

local function killAura(_, enabled) if enabled then if not _G.killAuraCon then _G.killAuraCon = RunService.Heartbeat:Connect(function() for _, plr in pairs(Players:GetPlayers()) do if plr ~= lp and plr.Character and plr.Character:FindFirstChild("Humanoid") then local dist = (plr.Character.HumanoidRootPart.Position - hrp.Position).magnitude if dist < 15 then plr.Character.Humanoid:TakeDamage(50) end end end end) end else if _G.killAuraCon then _G.killAuraCon:Disconnect() _G.killAuraCon = nil end end end

local espList = {} local function toggleESP(_, enabled) for _, v in pairs(espList) do v:Destroy() end table.clear(espList) if enabled then for _, plr in pairs(Players:GetPlayers()) do if plr ~= lp and plr.Character and plr.Character:FindFirstChild("Head") then local bb = Instance.new("BillboardGui", plr.Character) bb.Name = "ESP" bb.Size = UDim2.new(0, 100, 0, 20) bb.StudsOffset = Vector3.new(0, 3, 0) bb.AlwaysOnTop = true bb.Adornee = plr.Character.Head local tx = Instance.new("TextLabel", bb) tx.Size = UDim2.new(1, 0, 1, 0) tx.BackgroundTransparency = 1 tx.Text = plr.Name tx.TextColor3 = Color3.fromRGB(255, 0, 0) tx.TextScaled = true tx.TextSize = 6 table.insert(espList, bb) end end end end

local walkSpeedControl = createControl("speed", 10, 16, 25, function(val, on) hum.WalkSpeed = on and val or 16 end)

local flyEnabled = false local flySpeed = 50 local bodyGyro, bodyVel

local function fly(val, on) if on and not flyEnabled then flyEnabled = true bodyGyro = Instance.new("BodyGyro", hrp) bodyGyro.P = 9e4 bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9) bodyGyro.CFrame = hrp.CFrame bodyVel = Instance.new("BodyVelocity", hrp) bodyVel.Velocity = Vector3.new() bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)

RunService.RenderStepped:Connect(function()
		if flyEnabled then
			local cam = workspace.CurrentCamera
			local dir = Vector3.new()
			if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += cam.CFrame.UpVector end
			if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= cam.CFrame.UpVector end
			bodyVel.Velocity = dir.Unit * val
			bodyGyro.CFrame = cam.CFrame
		end
	end)
elseif not on and flyEnabled then
	flyEnabled = false
	if bodyGyro then bodyGyro:Destroy() end
	if bodyVel then bodyVel:Destroy() end
end

end

local flyControl = createControl("fly", 40, 50, 25, fly) createControl("kill aura", 70, 0, 0, killAura) createControl("esp", 100, 0, 0, toggleESP)

