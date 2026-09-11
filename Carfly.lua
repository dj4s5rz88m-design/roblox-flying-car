-- Delta Executor Compatible Flying Car Script
local s = script.Parent
if not s then return end

local bv = Instance.new("BodyVelocity", s)
bv.MaxForce = Vector3.new()

local bg = Instance.new("BodyGyro", s)
bg.MaxTorque = Vector3.new(4e3, 4e3, 4e3)
bg.P, bg.D = 3e3, 500

local f, h, c = false, 12, 0
local tR = Instance.new("RemoteEvent", s)
tR.Name = "FlyToggle"

local cR = Instance.new("RemoteEvent", s)
cR.Name = "FlyClimb"

local L = {}
local rp = RaycastParams.new()
rp.FilterDescendantsInstances = {s.Parent}
rp.FilterType = Enum.RaycastFilterType.Exclude

tR.OnServerEvent:Connect(function(p, k)
	local t = os.clock()
	if L[p.UserId] and t - L[p.UserId] < 1.5 then return end
	if k ~= "yourpass123" then return end
	local o = s.Occupant
	if not o or game.Players:GetPlayerFromCharacter(o.Parent) ~= p then return end
	L[p.UserId] = t
	f = not f
	bv.MaxForce = f and Vector3.new(1e9, 1e9, 1e9) or Vector3.new()
	if not f then h = 12 end
end)

cR.OnServerEvent:Connect(function(p, d)
	local o = s.Occupant
	if not f or not o or game.Players:GetPlayerFromCharacter(o.Parent) ~= p then return end
	c = (d == 1 or d == -1) and d or 0
end)

game.Players.PlayerRemoving:Connect(function(p)
	L[p.UserId] = nil
end)

game:GetService("RunService").Heartbeat:Connect(function(dt)
	local o = s.Occupant
	if not o then
		bv.MaxForce = Vector3.new()
		f, c = false, 0
		return
	end
	if f then
		h = math.clamp(h + c * 20 * dt, 4, 150)
		local cf = s.CFrame
		local r = workspace:Raycast(cf.Position, Vector3.new(0, -200, 0), rp)
		local gY = r and r.Position.Y or cf.Position.Y - h
		bv.Velocity = cf.LookVector * s.Throttle * 120 + Vector3.new(0, ((gY + h) - cf.Position.Y) * 8, 0)
		bg.CFrame = cf * CFrame.Angles(0, -s.Steer * 3 * dt, 0)
	end
end)

-- Local Script (Client-side) - SIMPLIFIED FOR DELTA
local ls = Instance.new("LocalScript")
ls.Source = [[
local p = game.Players.LocalPlayer
local U = game:GetService("UserInputService")
local s = script.Parent.Parent
local tR, cR

repeat
	tR = s:FindFirstChild("FlyToggle")
	cR = s:FindFirstChild("FlyClimb")
	wait(0.2)
until tR and cR

wait(1)

local PlayerGui = p:WaitForChild("PlayerGui")

-- Create Screen GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyPasswordGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = PlayerGui

-- Create main frame (centered, large, VISIBLE)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 600, 0, 300)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 100)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(0, 255, 255)
mainFrame.Parent = screenGui
mainFrame.Visible = true

-- Create title
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 80)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
titleLabel.BorderSizePixel = 0
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 32
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Text = "FLYING CAR PASSWORD"
titleLabel.Parent = mainFrame

-- Create password label
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

-- Create password textbox
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
passBox.Visible = true

-- Create submit button
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
	if passBox.Text ~= "" then
		tR:FireServer(passBox.Text)
		passBox.Text = ""
		wait(0.5)
		screenGui:Destroy()
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

-- Focus the textbox
passBox:CaptureFocus()

print("PASSWORD GUI LOADED - YOU SHOULD SEE A CYAN BORDERED BOX IN CENTER OF SCREEN")
]]

ls.Parent = s