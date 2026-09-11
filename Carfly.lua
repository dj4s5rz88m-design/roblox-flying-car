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

-- Local Script (Client-side)
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

pcall(function()
	local PlayerGui = p:WaitForChild("PlayerGui", 5)
	
	-- Create main screen gui
	local g = Instance.new("ScreenGui")
	g.Name = "FlyGui"
	g.ResetOnSpawn = false
	g.IgnoreGuiInset = true
	g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	g.Parent = PlayerGui
	
	if not U.TouchEnabled then
		-- DARK BACKGROUND OVERLAY
		local bg = Instance.new("Frame", g)
		bg.Name = "Background"
		bg.Size = UDim2.new(1, 0, 1, 0)
		bg.Position = UDim2.new(0, 0, 0, 0)
		bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		bg.BackgroundTransparency = 0.4
		bg.BorderSizePixel = 0
		bg.ZIndex = 1
		
		-- MAIN CONTAINER - CENTERED
		local container = Instance.new("Frame", g)
		container.Name = "Container"
		container.Size = UDim2.new(0, 500, 0, 280)
		container.Position = UDim2.new(0.5, -250, 0.5, -140)
		container.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
		container.BackgroundTransparency = 0
		container.BorderSizePixel = 0
		container.ZIndex = 2
		
		local corner = Instance.new("UICorner", container)
		corner.CornerRadius = UDim.new(0, 15)
		
		local stroke = Instance.new("UIStroke", container)
		stroke.Color = Color3.fromRGB(0, 200, 255)
		stroke.Thickness = 3
		stroke.Transparency = 0
		
		-- TITLE
		local title = Instance.new("TextLabel", container)
		title.Name = "Title"
		title.Size = UDim2.new(1, 0, 0, 60)
		title.Position = UDim2.new(0, 0, 0, 0)
		title.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
		title.BackgroundTransparency = 0
		title.BorderSizePixel = 0
		title.Font = Enum.Font.GothamBold
		title.TextSize = 32
		title.TextColor3 = Color3.fromRGB(255, 255, 255)
		title.Text = "🚗 FLY MODE 🚗"
		title.ZIndex = 3
		
		local titleCorner = Instance.new("UICorner", title)
		titleCorner.CornerRadius = UDim.new(0, 15)
		
		-- SUBTITLE
		local subtitle = Instance.new("TextLabel", container)
		subtitle.Name = "Subtitle"
		subtitle.Size = UDim2.new(1, -20, 0, 35)
		subtitle.Position = UDim2.new(0, 10, 0, 70)
		subtitle.BackgroundTransparency = 1
		subtitle.BorderSizePixel = 0
		subtitle.Font = Enum.Font.GothamMedium
		subtitle.TextSize = 16
		subtitle.TextColor3 = Color3.fromRGB(200, 200, 255)
		subtitle.Text = "Enter your password to activate flying:"
		subtitle.ZIndex = 3
		
		-- PASSWORD INPUT BOX
		local inputBox = Instance.new("TextBox", container)
		inputBox.Name = "PasswordInput"
		inputBox.Size = UDim2.new(1, -40, 0, 50)
		inputBox.Position = UDim2.new(0, 20, 0, 110)
		inputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 80)
		inputBox.BackgroundTransparency = 0
		inputBox.BorderSizePixel = 0
		inputBox.Font = Enum.Font.GothamMedium
		inputBox.TextSize = 24
		inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		inputBox.PlaceholderText = "Type password here..."
		inputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
		inputBox.Text = ""
		inputBox.ClearTextOnFocus = false
		inputBox.MultiLine = false
		inputBox.ZIndex = 3
		
		local inputCorner = Instance.new("UICorner", inputBox)
		inputCorner.CornerRadius = UDim.new(0, 8)
		
		local inputStroke = Instance.new("UIStroke", inputBox)
		inputStroke.Color = Color3.fromRGB(100, 200, 255)
		inputStroke.Thickness = 2
		inputStroke.Transparency = 0
		
		-- SUBMIT BUTTON
		local submitBtn = Instance.new("TextButton", container)
		submitBtn.Name = "SubmitButton"
		submitBtn.Size = UDim2.new(0, 180, 0, 45)
		submitBtn.Position = UDim2.new(0.5, -90, 0, 220)
		submitBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
		submitBtn.BackgroundTransparency = 0
		submitBtn.BorderSizePixel = 0
		submitBtn.Font = Enum.Font.GothamBold
		submitBtn.TextSize = 18
		submitBtn.TextColor3 = Color3.new(1, 1, 1)
		submitBtn.Text = "✓ SUBMIT"
		submitBtn.AutoButtonColor = false
		submitBtn.ZIndex = 3
		
		local btnCorner = Instance.new("UICorner", submitBtn)
		btnCorner.CornerRadius = UDim.new(0, 8)
		
		local btnStroke = Instance.new("UIStroke", submitBtn)
		btnStroke.Color = Color3.fromRGB(200, 255, 200)
		btnStroke.Thickness = 2
		btnStroke.Transparency = 0
		
		-- BUTTON HOVER EFFECT
		submitBtn.MouseEnter:Connect(function()
			submitBtn.BackgroundColor3 = Color3.fromRGB(0, 230, 130)
		end)
		
		submitBtn.MouseLeave:Connect(function()
			submitBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
		end)
		
		-- SUBMIT FUNCTION
		local function submitPassword()
			if inputBox.Text ~= "" then
				tR:FireServer(inputBox.Text)
				inputBox.Text = ""
				wait(0.5)
				g:Destroy()
			end
		end
		
		-- ENTER KEY
		inputBox.FocusLost:Connect(function(enterPressed)
			if enterPressed then
				submitPassword()
			end
		end)
		
		-- BUTTON CLICK
		submitBtn.MouseButton1Click:Connect(function()
			submitPassword()
		end)
		
		-- AUTO FOCUS INPUT
		wait(0.1)
		inputBox:CaptureFocus()
	else
		-- MOBILE: Buttons
		local fb = Instance.new("TextButton", g)
		fb.Size = UDim2.new(0, 100, 0, 100)
		fb.Position = UDim2.new(1, -120, 1, -120)
		fb.Text = "FLY"
		fb.Font = Enum.Font.GothamBold
		fb.TextSize = 24
		fb.TextColor3 = Color3.new(1, 1, 1)
		fb.BackgroundColor3 = Color3.fromRGB(255, 90, 90)
		fb.AutoButtonColor = false
		fb.BorderSizePixel = 0
		
		local fbCorner = Instance.new("UICorner", fb)
		fbCorner.CornerRadius = UDim.new(0, 50)
		
		fb.MouseButton1Click:Connect(function()
			tR:FireServer("yourpass123")
		end)
		
		-- UP BUTTON
		local ub = Instance.new("TextButton", g)
		ub.Size = UDim2.new(0, 100, 0, 100)
		ub.Position = UDim2.new(1, -120, 1, -230)
		ub.Text = "↑"
		ub.Font = Enum.Font.GothamBold
		ub.TextSize = 32
		ub.TextColor3 = Color3.new(1, 1, 1)
		ub.BackgroundColor3 = Color3.fromRGB(90, 160, 255)
		ub.AutoButtonColor = false
		ub.BorderSizePixel = 0
		
		local ubCorner = Instance.new("UICorner", ub)
		ubCorner.CornerRadius = UDim.new(0, 50)
		
		ub.MouseButton1Down:Connect(function()
			cR:FireServer(1)
		end)
		ub.MouseButton1Up:Connect(function()
			cR:FireServer(0)
		end)
		
		-- DOWN BUTTON
		local db = Instance.new("TextButton", g)
		db.Size = UDim2.new(0, 100, 0, 100)
		db.Position = UDim2.new(1, -120, 1, -10)
		db.Text = "↓"
		db.Font = Enum.Font.GothamBold
		db.TextSize = 32
		db.TextColor3 = Color3.new(1, 1, 1)
		db.BackgroundColor3 = Color3.fromRGB(90, 160, 255)
		db.AutoButtonColor = false
		db.BorderSizePixel = 0
		
		local dbCorner = Instance.new("UICorner", db)
		dbCorner.CornerRadius = UDim.new(0, 50)
		
		db.MouseButton1Down:Connect(function()
			cR:FireServer(-1)
		end)
		db.MouseButton1Up:Connect(function()
			cR:FireServer(0)
		end)
	end
end)
]]

ls.Parent = s