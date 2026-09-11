-- Universal Flying Car Script (No Seat Required) - Mobile & Desktop
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

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

-- Password setup
local passwordCorrect = false
local correctPassword = "qwertyuiopawsd"

-- Keyboard input for flying (Desktop)
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
		titleLabel.Text = "PASSWORD ACCEPTED!"
		titleLabel.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
		passBox.Text = ""
		wait(2)
		screenGui:Destroy()
		createMobileControls()
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

-- Mobile Controls Function
function createMobileControls()
	local isTouchEnabled = UserInputService.TouchEnabled
	
	if not isTouchEnabled then
		print("DESKTOP MODE - Press SPACE to fly, W/S to climb/descend")
		return
	end
	
	local mobileGui = Instance.new("ScreenGui")
	mobileGui.Name = "MobileControlsGui"
	mobileGui.ResetOnSpawn = false
	mobileGui.Parent = PlayerGui
	
	-- FLY TOGGLE BUTTON (Large, Red, Bottom Right)
	local flyButton = Instance.new("TextButton")
	flyButton.Name = "FlyButton"
	flyButton.Size = UDim2.new(0, 100, 0, 100)
	flyButton.Position = UDim2.new(1, -120, 1, -120)
	flyButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
	flyButton.BorderSizePixel = 2
	flyButton.BorderColor3 = Color3.fromRGB(255, 200, 200)
	flyButton.Font = Enum.Font.GothamBold
	flyButton.TextSize = 24
	flyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	flyButton.Text = "FLY"
	flyButton.Parent = mobileGui
	
	flyButton.MouseButton1Click:Connect(function()
		f = not f
		bv.MaxForce = f and Vector3.new(1e9, 1e9, 1e9) or Vector3.new()
		if not f then 
			h = 12
			bv.Velocity = Vector3.new()
			flyButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
			flyButton.Text = "FLY"
		else
			flyButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
			flyButton.Text = "FLYING"
		end
	end)
	
	-- UP BUTTON (Blue, Above Fly Button)
	local upButton = Instance.new("TextButton")
	upButton.Name = "UpButton"
	upButton.Size = UDim2.new(0, 100, 0, 100)
	upButton.Position = UDim2.new(1, -120, 1, -230)
	upButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
	upButton.BorderSizePixel = 2
	upButton.BorderColor3 = Color3.fromRGB(150, 200, 255)
	upButton.Font = Enum.Font.GothamBold
	upButton.TextSize = 36
	upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	upButton.Text = "↑"
	upButton.Parent = mobileGui
	
	upButton.MouseButton1Down:Connect(function()
		if f then c = 1 end
	end)
	
	upButton.MouseButton1Up:Connect(function()
		c = 0
	end)
	
	upButton.TouchBegan:Connect(function()
		if f then c = 1 end
	end)
	
	upButton.TouchEnded:Connect(function()
		c = 0
	end)
	
	-- DOWN BUTTON (Blue, Below Fly Button)
	local downButton = Instance.new("TextButton")
	downButton.Name = "DownButton"
	downButton.Size = UDim2.new(0, 100, 0, 100)
	downButton.Position = UDim2.new(1, -120, 1, -10)
	downButton.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
	downButton.BorderSizePixel = 2
	downButton.BorderColor3 = Color3.fromRGB(150, 200, 255)
	downButton.Font = Enum.Font.GothamBold
	downButton.TextSize = 36
	downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	downButton.Text = "↓"
	downButton.Parent = mobileGui
	
	downButton.MouseButton1Down:Connect(function()
		if f then c = -1 end
	end)
	
	downButton.MouseButton1Up:Connect(function()
		c = 0
	end)
	
	downButton.TouchBegan:Connect(function()
		if f then c = -1 end
	end)
	
	downButton.TouchEnded:Connect(function()
		c = 0
	end)
	
	-- STATUS LABEL
	local statusLabel = Instance.new("TextLabel")
	statusLabel.Name = "StatusLabel"
	statusLabel.Size = UDim2.new(0, 300, 0, 50)
	statusLabel.Position = UDim2.new(0, 10, 1, -60)
	statusLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 100)
	statusLabel.BorderSizePixel = 2
	statusLabel.BorderColor3 = Color3.fromRGB(0, 255, 255)
	statusLabel.Font = Enum.Font.GothamBold
	statusLabel.TextSize = 14
	statusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	statusLabel.Text = "Status: Ready"
	statusLabel.Parent = mobileGui
	
	-- Update status label
	RunService.Heartbeat:Connect(function()
		if f then
			statusLabel.Text = "Status: FLYING (Height: " .. math.floor(h) .. ")"
		else
			statusLabel.Text = "Status: Ready | Click FLY to start"
		end
	end)
	
	print("MOBILE CONTROLS CREATED")
end

-- Auto focus
wait(0.2)
passBox:CaptureFocus()

print("UNIVERSAL FLY SCRIPT LOADED!")
print("PASSWORD BOX VISIBLE IN CENTER OF SCREEN")
print("DESKTOP: Press SPACE to fly, W/S to climb/descend")
print("MOBILE: Use on-screen buttons")