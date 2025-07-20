local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local SkyBtn = Instance.new("TextButton")
local FlyBtn = Instance.new("TextButton")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

Frame.Size = UDim2.new(0, 200, 0, 100)
Frame.Position = UDim2.new(0, 20, 0, 100)
Frame.BackgroundColor3 = Color3.new(0, 0, 0)
Frame.BorderColor3 = Color3.new(1, 1, 1)
Frame.Parent = ScreenGui
Frame.Active = true
Frame.Draggable = true

SkyBtn.Size = UDim2.new(1, 0, 0.5, 0)
SkyBtn.Position = UDim2.new(0, 0, 0, 0)
SkyBtn.Text = "Đổi trời"
SkyBtn.Parent = Frame

FlyBtn.Size = UDim2.new(1, 0, 0.5, 0)
FlyBtn.Position = UDim2.new(0, 0, 0.5, 0)
FlyBtn.Text = "Bay"
FlyBtn.Parent = Frame

-- Sky Button Script
SkyBtn.MouseButton1Click:Connect(function()
	local Lighting = game:GetService("Lighting")
	local oldSky = Lighting:FindFirstChildOfClass("Sky")
	if oldSky then oldSky:Destroy() end

	local sky = Instance.new("Sky")
	local id = "71624524466837"
	sky.SkyboxBk = "rbxassetid://"..id
	sky.SkyboxDn = "rbxassetid://"..id
	sky.SkyboxFt = "rbxassetid://"..id
	sky.SkyboxLf = "rbxassetid://"..id
	sky.SkyboxRt = "rbxassetid://"..id
	sky.SkyboxUp = "rbxassetid://"..id
	sky.Parent = Lighting
end)

-- Fly Button Script
FlyBtn.MouseButton1Click:Connect(function()
	loadstring(game:HttpGet("https://pastebin.com/raw/xvhaFjZz"))() -- ví dụ fly script
end)
