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
	
	local g = Instance.new("ScreenGui")
	g.Name = "FlyGui"
	g.ResetOnSpawn = false
	g.IgnoreGuiInset = false
	g.Parent = PlayerGui
	
	local function mk(cl, pa, pr)
		local o = Instance.new(cl, pa)
		for k, v in pairs(pr) do
			o[k] = v
		end
		return o
	end
	
	local function co(o, r)
		Instance.new("UICorner", o).CornerRadius = UDim.new(0, r or 12)
	end
	
	local function st(o, c)
		local x = Instance.new("UIStroke", o)
		x.Color = c or Color3.new(1, 1, 1)
		x.Thickness = 2
		x.Transparency = 0
	end
	
	if not U.TouchEnabled then
		-- Desktop: Large Visible Password Input
		local titleLabel = mk("TextLabel", g, {
			Name = "TitleLabel",
			Size = UDim2.new(0, 400, 0, 40),
			Position = UDim2.new(0.5, -200, 0.3, 0),
			BackgroundColor3 = Color3.fromRGB(20, 20, 30),
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Font = Enum.Font.GothamBold,
			TextSize = 24,
			TextColor3 = Color3.fromRGB(255, 200, 100),
			Text = "ENTER FLY PASSWORD"
		})
		co(titleLabel, 10)
		st(titleLabel, Color3.fromRGB(255, 200, 100))
		
		-- Password Input Box
		local pn = mk("Frame", g, {
			Name = "PasswordPanel",
			Size = UDim2.new(0, 400, 0, 100),
			Position = UDim2.new(0.5, -200, 0.35, 0),
			BackgroundColor3 = Color3.fromRGB(40, 40, 60),
			BackgroundTransparency = 0,
			BorderSizePixel = 0
		})
		co(pn, 10)
		st(pn, Color3.fromRGB(0, 150, 255))
		
		local bx = mk("TextBox", pn, {
			Name = "PassInput",
			Size = UDim2.new(1, -20, 0, 50),
			Position = UDim2.new(0, 10, 0, 15),
			BackgroundColor3 = Color3.fromRGB(60, 60, 90),
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Font = Enum.Font.GothamMedium,
			TextSize = 22,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			PlaceholderText = "Type password here...",
			PlaceholderColor3 = Color3.fromRGB(200, 200, 200),
			Text = "",
			ClearTextOnFocus = false
		})
		co(bx, 8)
		st(bx, Color3.fromRGB(100, 200, 255))
		
		local submitBtn = mk("TextButton", pn, {
			Name = "SubmitBtn",
			Size = UDim2.new(0, 150, 0, 40),
			Position = UDim2.new(0.5, -75, 0, 55),
			BackgroundColor3 = Color3.fromRGB(0, 150, 255),
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Font = Enum.Font.GothamBold,
			TextSize = 18,
			TextColor3 = Color3.new(1, 1, 1),
			Text = "SUBMIT"
		})
		co(submitBtn, 8)
		st(submitBtn, Color3.new(1, 1, 1))
		
		local function submitPassword()
			if bx.Text ~= "" then
				tR:FireServer(bx.Text)
				bx.Text = ""
				pn:Destroy()
				titleLabel:Destroy()
			end
		end
		
		bx.FocusLost:Connect(function(enterPressed)
			if enterPressed and bx.Text ~= "" then
				submitPassword()
			end
		end)
		
		submitBtn.MouseButton1Click:Connect(function()
			submitPassword()
		end)
		
		-- Auto-focus the textbox
		bx:CaptureFocus()
	else
		-- Mobile: Buttons
		local fb = mk("TextButton", g, {
			Size = UDim2.new(0, 92, 0, 92),
			Position = UDim2.new(1, -112, 1, -112),
			Text = "Fly",
			Font = Enum.Font.GothamBold,
			TextSize = 28,
			TextColor3 = Color3.new(1, 1, 1),
			BackgroundColor3 = Color3.fromRGB(255, 90, 90),
			AutoButtonColor = false,
			BorderSizePixel = 0
		})
		co(fb, 46)
		st(fb, Color3.new(1, 1, 1))
		
		fb.MouseButton1Click:Connect(function()
			tR:FireServer("yourpass123")
		end)
		
		-- Up Button
		local ub = mk("TextButton", g, {
			Size = UDim2.new(0, 92, 0, 92),
			Position = UDim2.new(1, -112, 1, -220),
			Text = "↑",
			Font = Enum.Font.GothamBold,
			TextSize = 32,
			TextColor3 = Color3.new(1, 1, 1),
			BackgroundColor3 = Color3.fromRGB(90, 160, 255),
			AutoButtonColor = false,
			BorderSizePixel = 0
		})
		co(ub, 46)
		st(ub)
		
		ub.MouseButton1Down:Connect(function()
			cR:FireServer(1)
		end)
		ub.MouseButton1Up:Connect(function()
			cR:FireServer(0)
		end)
		
		-- Down Button
		local db = mk("TextButton", g, {
			Size = UDim2.new(0, 92, 0, 92),
			Position = UDim2.new(1, -112, 1, -16),
			Text = "↓",
			Font = Enum.Font.GothamBold,
			TextSize = 32,
			TextColor3 = Color3.new(1, 1, 1),
			BackgroundColor3 = Color3.fromRGB(90, 160, 255),
			AutoButtonColor = false,
			BorderSizePixel = 0
		})
		co(db, 46)
		st(db)
		
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