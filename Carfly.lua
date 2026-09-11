-- Universal Flying Car Script (No Seat Required)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local p = Players.LocalPlayer
local character = p.Character or p.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Create flying objects
local bv = Instance.new("BodyVelocity", humanoidRootPart)
bv.MaxForce = Vector3.new()
bv.Velocity = Vector3.new()

local bg = Instance.new("BodyGyro", humanoidRootPart)
bg.MaxTorque = Vector3.new(4e3, 4e3, 4e3)
bg.P = 3e3
bg.D = 500
bg.CFrame = humanoidRootPart.CFrame

local f = false
local h = 12
local c = 0
local L = {}

-- Create password check
local passwordCorrect = false
local correctPassword = "yourpass123"

local rp = RaycastParams.new()
rp.FilterDescendantsInstances = {character}
rp.FilterType = Enum.RaycastFilterType.Exclude

-- Flying loop
RunService.Heartbeat:Connect(function(dt)
	if not character or not humanoidRootPart or not humanoidRootPart.Parent then return end
	
	if f then
		h = math.clamp(h + c * 20 * dt, 4, 150)
		local cf = humanoidRootPart.CFrame
		local r = workspace:Raycast(cf.Position, Vector3.new(0, -200, 0), rp)
		local gY = r and r.Position.Y or cf.Position.Y - h
		bv.Velocity = cf.LookVector * 120 + Vector3.new(0, ((gY + h) - cf.Position.Y) * 8, 0)
		bg.CFrame = cf * CFrame.Angles(0, -0 * 3 * dt, 0)
	end
end)

-- Keyboard input for flying
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == Enum.KeyCode.Space and passwordCorrect then
		f = not f
		bv.MaxForce = f and Vector3.new(1e9, 1e9, 1e9) or Vector3.new()
		if not f then 
			h = 12
			bv.Velocity = Vector3.new()
		end
	end
	
	if input.KeyCode == Enum.KeyCode.W and f then
		c = 1
	end
	
	if input.KeyCode == Enum.KeyCode.S and f then
		c = -1
	end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
	if input.KeyCode == Enum.KeyCode.W or input.KeyCode == Enum.KeyCode.S then
		c = 0
	end
end)

-- Create Password GUI
local PlayerGui = p:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyPasswordGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 600, 0, 300)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 100)
mainFrame.BorderSizePixel = 3
mainFrame.BorderColor3 = Color3.fromRGB(0, 255, 255)
mainFrame.Parent = screenGui

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 80)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
titleLabel.BorderSizePixel = 0
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 32
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "UNIVERSAL FLY SCRIPT"
titleLabel.Parent = mainFrame

-- Password label
local passLabel = Instance.new("TextLabel")
passLabel.Name = "PassLabel"
passLabel.Size = UDim2.new(1, -20, 0, 30)
passLabel.Position = UDim2.new(0, 10, 0, 90)
passLabel.BackgroundTransparency = 1
passLabel.BorderSizePixel = 0
passLabel.Font = Enum.Font.GothamMedium
passLabel.TextSize = 16
passLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
passLabel.Text = "Enter Password:"
passLabel.Parent = mainFrame

-- Password textbox
local passBox = Instance.new("TextBox")
passBox.Name = "PasswordBox"
passBox.Size = UDim2.new(1, -20, 0, 50)
passBox.Position = UDim2.new(0, 10, 0, 130)
passBox.BackgroundColor3 = Color3.fromRGB(100, 100, 150)
passBox.BorderSizePixel = 2
passBox.BorderColor3 = Color3.fromRGB(0, 255, 255)
passBox.Font = Enum.Font.GothamMedium
passBox.TextSize = 20
passBox.TextColor3 = Color3.fromRGB(255, 255, 255)
passBox.PlaceholderText = "Type password..."
passBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 200)
passBox.Parent = mainFrame

-- Submit button
local submitButton = Instance.new("TextButton")
submitButton.Name = "SubmitButton"
submitButton.Size = UDim2.new(0, 200, 0, 50)
submitButton.Position = UDim2.new(0.5, -100, 0, 200)
submitButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
submitButton.BorderSizePixel = 2
submitButton.BorderColor3 = Color3.fromRGB(0, 255, 150)
submitButton.Font = Enum.Font.GothamBold
submitButton.TextSize = 20
submitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
submitButton.Text = "SUBMIT PASSWORD"
submitButton.Parent = mainFrame

-- Submit function
local function submitPass()
	if passBox.Text == correctPassword then
		passwordCorrect = true
		titleLabel.Text = "PASSWORD ACCEPTED - PRESS SPACE TO FLY"
		titleLabel.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
		passBox.Text = ""
		wait(2)
		screenGui:Destroy()
	else
		titleLabel.Text = "WRONG PASSWORD!"
		titleLabel.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		passBox.Text = ""
		wait(1)
		titleLabel.Text = "UNIVERSAL FLY SCRIPT"
		titleLabel.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
	end
end

-- Connect events
passBox.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		submitPass()
	end
end)

submitButton.MouseButton1Click:Connect(function()
	submitPass()
end)

-- Auto focus
wait(0.2)
passBox:CaptureFocus()

print("UNIVERSAL FLY SCRIPT LOADED!")
print("PASSWORD BOX VISIBLE IN CENTER OF SCREEN")
print("After entering correct password, press SPACE to fly")
print("W = Climb | S = Descend")