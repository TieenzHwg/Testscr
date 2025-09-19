--// UI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local ESPButton = Instance.new("TextButton")
local AuraButton = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui

-- MainFrame (cả cái này đều kéo đc)
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 85)
MainFrame.Active = true
MainFrame.Draggable = true -- chỗ nào cũng kéo được

-- ESP button
ESPButton.Parent = MainFrame
ESPButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ESPButton.BorderColor3 = Color3.fromRGB(255, 0, 0)
ESPButton.Size = UDim2.new(0.5, 0, 0.5, 0)
ESPButton.Font = Enum.Font.SourceSans
ESPButton.Text = "ESP OFF"
ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ESPButton.TextSize = 18

-- Aura button
AuraButton.Parent = MainFrame
AuraButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
AuraButton.BorderColor3 = Color3.fromRGB(255, 0, 0)
AuraButton.Position = UDim2.new(0.5, 0, 0, 0)
AuraButton.Size = UDim2.new(0.5, 0, 0.5, 0)
AuraButton.Font = Enum.Font.SourceSans
AuraButton.Text = "AURA OFF"
AuraButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AuraButton.TextSize = 18

--// ESP
local espEnabled = false
function toggleESP()
	espEnabled = not espEnabled
	ESPButton.Text = espEnabled and "ESP ON" or "ESP OFF"
	for _,plr in pairs(game.Players:GetPlayers()) do
		if plr ~= game.Players.LocalPlayer then
			if espEnabled and plr.Character and plr.Character:FindFirstChild("Head") then
				if not plr.Character.Head:FindFirstChild("ESPTag") then
					local Billboard = Instance.new("BillboardGui")
					Billboard.Name = "ESPTag"
					Billboard.Adornee = plr.Character.Head
					Billboard.Size = UDim2.new(0,200,0,50)
					Billboard.AlwaysOnTop = true
					Billboard.Parent = plr.Character.Head

					local Text = Instance.new("TextLabel", Billboard)
					Text.Size = UDim2.new(1,0,1,0)
					Text.BackgroundTransparency = 1
					Text.Text = plr.Name
					Text.TextColor3 = Color3.fromRGB(255,255,255)
					Text.TextStrokeTransparency = 0
				end
			else
				if plr.Character and plr.Character:FindFirstChild("Head") then
					local tag = plr.Character.Head:FindFirstChild("ESPTag")
					if tag then tag:Destroy() end
				end
			end
		end
	end
end

ESPButton.MouseButton1Click:Connect(toggleESP)

--// Aura
local auraEnabled = false
function toggleAura()
	auraEnabled = not auraEnabled
	AuraButton.Text = auraEnabled and "AURA ON" or "AURA OFF"
	for _,plr in pairs(game.Players:GetPlayers()) do
		if plr ~= game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
			if auraEnabled then
				if not plr.Character:FindFirstChild("AuraHighlight") then
					local Highlight = Instance.new("Highlight")
					Highlight.Name = "AuraHighlight"
					Highlight.FillColor = Color3.fromRGB(255, 255, 0)
					Highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
					Highlight.Parent = plr.Character
				end
			else
				local h = plr.Character:FindFirstChild("AuraHighlight")
				if h then h:Destroy() end
			end
		end
	end
end

AuraButton.MouseButton1Click:Connect(toggleAura)

-- auto update
game.Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(char)
		if espEnabled then
			task.wait(1)
			if char:FindFirstChild("Head") then
				local Billboard = Instance.new("BillboardGui")
				Billboard.Name = "ESPTag"
				Billboard.Adornee = char.Head
				Billboard.Size = UDim2.new(0,200,0,50)
				Billboard.AlwaysOnTop = true
				Billboard.Parent = char.Head

				local Text = Instance.new("TextLabel", Billboard)
				Text.Size = UDim2.new(1,0,1,0)
				Text.BackgroundTransparency = 1
				Text.Text = plr.Name
				Text.TextColor3 = Color3.fromRGB(255,255,255)
				Text.TextStrokeTransparency = 0
			end
		end
		if auraEnabled then
			task.wait(1)
			if char:FindFirstChild("HumanoidRootPart") then
				local Highlight = Instance.new("Highlight")
				Highlight.Name = "AuraHighlight"
				Highlight.FillColor = Color3.fromRGB(255, 255, 0)
				Highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
				Highlight.Parent = char
			end
		end
	end)
end)
