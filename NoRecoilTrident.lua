-- Trident Survival No Recoil Gun Script
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local p = Players.LocalPlayer
local character = p.Character or p.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera

-- Password setup
local passwordCorrect = false
local correctPassword = "qwertyuiopawsd"
local noRecoilActive = false

-- Create Password GUI
local PlayerGui = p:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "NoRecoilGui"
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
titleLabel.Text = "NO RECOIL SCRIPT"
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
		createControlPanel()
	else
		titleLabel.Text = "WRONG PASSWORD!"
		titleLabel.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		passBox.Text = ""
		wait(1)
		titleLabel.Text = "NO RECOIL SCRIPT"
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

-- Control Panel
function createControlPanel()
	local controlGui = Instance.new("ScreenGui")
	controlGui.Name = "ControlPanelGui"
	controlGui.ResetOnSpawn = false
	controlGui.Parent = PlayerGui
	
	-- Control Panel Frame
	local controlPanel = Instance.new("Frame")
	controlPanel.Name = "ControlPanel"
	controlPanel.Size = UDim2.new(0, 250, 0, 200)
	controlPanel.Position = UDim2.new(0, 20, 0, 20)
	controlPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
	controlPanel.BorderSizePixel = 2
	controlPanel.BorderColor3 = Color3.fromRGB(0, 255, 0)
	controlPanel.Parent = controlGui
	
	-- Title
	local panelTitle = Instance.new("TextLabel")
	panelTitle.Name = "Title"
	panelTitle.Size = UDim2.new(1, 0, 0, 40)
	panelTitle.Position = UDim2.new(0, 0, 0, 0)
	panelTitle.BackgroundColor3 = Color3.fromRGB(0, 200, 50)
	panelTitle.BorderSizePixel = 0
	panelTitle.Font = Enum.Font.GothamBold
	panelTitle.TextSize = 18
	panelTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	panelTitle.Text = "NO RECOIL CONTROL"
	panelTitle.Parent = controlPanel
	
	-- Toggle Button
	local toggleButton = Instance.new("TextButton")
	toggleButton.Name = "ToggleButton"
	toggleButton.Size = UDim2.new(1, -20, 0, 50)
	toggleButton.Position = UDim2.new(0, 10, 0, 50)
	toggleButton.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
	toggleButton.BorderSizePixel = 1
	toggleButton.BorderColor3 = Color3.fromRGB(255, 200, 100)
	toggleButton.Font = Enum.Font.GothamBold
	toggleButton.TextSize = 16
	toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggleButton.Text = "NO RECOIL: OFF"
	toggleButton.Parent = controlPanel
	
	-- Status Label
	local statusLabel = Instance.new("TextLabel")
	statusLabel.Name = "StatusLabel"
	statusLabel.Size = UDim2.new(1, -20, 0, 60)
	statusLabel.Position = UDim2.new(0, 10, 0, 110)
	statusLabel.BackgroundTransparency = 1
	statusLabel.BorderSizePixel = 0
	statusLabel.Font = Enum.Font.GothamMedium
	statusLabel.TextSize = 12
	statusLabel.TextColor3 = Color3.fromRGB(200, 255, 200)
	statusLabel.Text = "Press E to toggle\nNo Recoil is DISABLED"
	statusLabel.TextWrapped = true
	statusLabel.Parent = controlPanel
	
	-- Toggle function
	local function toggleNoRecoil()
		noRecoilActive = not noRecoilActive
		
		if noRecoilActive then
			toggleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
			toggleButton.Text = "NO RECOIL: ON"
			statusLabel.Text = "No Recoil is ENABLED\nAll guns have NO recoil"
		else
			toggleButton.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
			toggleButton.Text = "NO RECOIL: OFF"
			statusLabel.Text = "No Recoil is DISABLED\nNormal gun behavior"
		end
	end
	
	-- Button click
	toggleButton.MouseButton1Click:Connect(toggleNoRecoil)
	
	-- Keyboard toggle (E key)
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == Enum.KeyCode.E then
			toggleNoRecoil()
		end
	end)
	
	-- NO RECOIL MECHANICS
	local lastCameraPos = camera.CFrame
	local lastCameraCFrame = camera.CFrame
	
	RunService.RenderStepped:Connect(function()
		if not noRecoilActive then return end
		
		-- Store the camera's current position
		local currentCFrame = camera.CFrame
		
		-- Prevent any upward or rotational movement from recoil
		-- Keep camera locked to the direction the player is aiming
		if lastCameraCFrame then
			-- Calculate the difference in rotation
			local lastLookVector = lastCameraCFrame.LookVector
			local currentLookVector = currentCFrame.LookVector
			
			-- If there's any recoil (upward movement in camera), counteract it
			-- by keeping the camera at the same angle
			camera.CFrame = lastCameraCFrame + (currentCFrame.Position - lastCameraCFrame.Position)
		end
		
		lastCameraCFrame = camera.CFrame
	end)
	
	print("NO RECOIL SCRIPT ACTIVE!")
	print("Press E to toggle No Recoil")
	print("All guns will have ZERO recoil")
end

-- Auto focus
wait(0.2)
passBox:CaptureFocus()

print("NO RECOIL SCRIPT LOADED FOR TRIDENT SURVIVAL!")
print("PASSWORD BOX VISIBLE - Enter password to activate")