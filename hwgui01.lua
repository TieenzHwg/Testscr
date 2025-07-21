--// Variables local Players = game:GetService("Players") local LocalPlayer = Players.LocalPlayer local UIS = game:GetService("UserInputService")

--// UI Creation local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui")) screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui) frame.Size = UDim2.new(0, 400, 0, 370) frame.Position = UDim2.new(0, 100, 0, 100) frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) frame.BorderSizePixel = 2 frame.Active = true frame.Draggable = true

local uiStroke = Instance.new("UIStroke", frame) uiStroke.Color = Color3.fromRGB(255, 0, 0) uiStroke.Thickness = 1.5

local layout = Instance.new("UIListLayout", frame) layout.SortOrder = Enum.SortOrder.LayoutOrder layout.Padding = UDim.new(0, 10)

local padding = Instance.new("UIPadding", frame) padding.PaddingTop = UDim.new(0, 10) padding.PaddingLeft = UDim.new(0, 10) padding.PaddingRight = UDim.new(0, 10)

-- Toggle Buttons local function createToggle(labelText, defaultState) local toggleBtn = Instance.new("TextButton") toggleBtn.Size = UDim2.new(1, 0, 0, 30) toggleBtn.BackgroundColor3 = defaultState and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(50, 50, 50) toggleBtn.TextColor3 = Color3.new(1, 1, 1) toggleBtn.Text = labelText .. (defaultState and " 🟢" or " 🔴")

local state = defaultState
toggleBtn.MouseButton1Click:Connect(function()
	state = not state
	toggleBtn.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(50, 50, 50)
	toggleBtn.Text = labelText .. (state and " 🟢" or " 🔴")
end)

return toggleBtn

end

-- Walk Speed Section local wsLabel = Instance.new("TextLabel", frame) wsLabel.Text = "Walk Speed" wsLabel.Size = UDim2.new(1, 0, 0, 20) wsLabel.BackgroundTransparency = 1 wsLabel.TextColor3 = Color3.new(1, 1, 1)

local wsFrame = Instance.new("Frame", frame) wsFrame.Size = UDim2.new(1, 0, 0, 30) wsFrame.BackgroundTransparency = 1

local wsMinus = Instance.new("TextButton", wsFrame) wsMinus.Size = UDim2.new(0, 30, 1, 0) wsMinus.Text = "-" wsMinus.BackgroundColor3 = Color3.fromRGB(40, 40, 40) wsMinus.TextColor3 = Color3.new(1, 1, 1)

local wsValue = Instance.new("TextLabel", wsFrame) wsValue.Size = UDim2.new(0, 50, 1, 0) wsValue.Position = UDim2.new(0, 35, 0, 0) wsValue.Text = "25" wsValue.BackgroundColor3 = Color3.fromRGB(30, 30, 30) wsValue.TextColor3 = Color3.new(1, 1, 1)

local wsPlus = Instance.new("TextButton", wsFrame) wsPlus.Size = UDim2.new(0, 30, 1, 0) wsPlus.Position = UDim2.new(0, 90, 0, 0) wsPlus.Text = "+" wsPlus.BackgroundColor3 = Color3.fromRGB(40, 40, 40) wsPlus.TextColor3 = Color3.new(1, 1, 1)

local walkSpeedToggle = createToggle("Walk Speed", true) walkSpeedToggle.Parent = frame

local speed = 25

wsMinus.MouseButton1Click:Connect(function() speed = speed - 25 wsValue.Text = tostring(speed) LocalPlayer.Character.Humanoid.WalkSpeed = speed end)

wsPlus.MouseButton1Click:Connect(function() speed = speed + 25 wsValue.Text = tostring(speed) LocalPlayer.Character.Humanoid.WalkSpeed = speed end)

-- Teleport Section local tpLabel = Instance.new("TextLabel", frame) tpLabel.Text = "Teleport Player" tpLabel.Size = UDim2.new(1, 0, 0, 20) tpLabel.BackgroundTransparency = 1 tpLabel.TextColor3 = Color3.new(1, 1, 1)

local tpToggle = createToggle("Teleport Player", true) tpToggle.Parent = frame

local textbox = Instance.new("TextBox", frame) textbox.Size = UDim2.new(1, -40, 0, 30) textbox.Text = "@username" textbox.TextColor3 = Color3.new(1, 1, 1) textbox.BackgroundColor3 = Color3.fromRGB(30, 30, 30) textbox.ClearTextOnFocus = false

local dropdown = Instance.new("TextButton", frame) dropdown.Text = "↓" dropdown.Size = UDim2.new(0, 30, 0, 30) dropdown.Position = UDim2.new(0, 360, 0, textbox.Position.Y.Offset) dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50) dropdown.TextColor3 = Color3.new(1, 1, 1)

dropdown.LayoutOrder = textbox.LayoutOrder + 1

dropdown.MouseButton1Click:Connect(function() playerListFrame.Visible = not playerListFrame.Visible end)

local playerListFrame = Instance.new("Frame", frame) playerListFrame.Size = UDim2.new(1, 0, 0, 100) playerListFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20) playerListFrame.Visible = false

local scrollLayout = Instance.new("UIListLayout", playerListFrame) scrollLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function refreshPlayerList() playerListFrame:ClearAllChildren() for _, p in ipairs(Players:GetPlayers()) do if p ~= LocalPlayer then local nameBtn = Instance.new("TextButton", playerListFrame) nameBtn.Text = "@" .. p.Name nameBtn.Size = UDim2.new(1, -10, 0, 25) nameBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30) nameBtn.TextColor3 = Color3.new(1, 1, 1) nameBtn.BorderSizePixel = 0

nameBtn.MouseButton1Click:Connect(function()
			textbox.Text = "@" .. p.Name
			playerListFrame.Visible = false
		end)
	end
end

end

refreshPlayerList()

local teleportBtn = Instance.new("TextButton", frame) teleportBtn.Text = "Teleport" teleportBtn.Size = UDim2.new(1, 0, 0, 30) teleportBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50) teleportBtn.TextColor3 = Color3.new(1, 1, 1)

teleportBtn.MouseButton1Click:Connect(function() local targetName = textbox.Text:gsub("@", "") local target = Players:FindFirstChild(targetName) if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(2, 0, 2) end end)"}

