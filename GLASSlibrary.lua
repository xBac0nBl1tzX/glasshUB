local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local Glass = {}
local Window = {}
local Tab = {}

Tab.__index = Tab

--////////////////////////////////////////////////////

function Glass:CreateWindow(title)

	pcall(function()
		local old = CoreGui:FindFirstChild("GlassUI")
		if old then old:Destroy() end
	end)

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "GlassUI"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = CoreGui

	local Main = Instance.new("Frame")
	Main.Parent = ScreenGui
	Main.AnchorPoint = Vector2.new(0.5,0.5)
	Main.Position = UDim2.new(0.5,0,0.5,0)
	Main.Size = UDim2.new(0,520,0,330)
	Main.BackgroundColor3 = Color3.fromRGB(60,60,60)
	Main.BackgroundTransparency = 0.4
	Main.Active = true

	Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

	local Stroke = Instance.new("UIStroke", Main)
	Stroke.Color = Color3.fromRGB(255,255,255)
	Stroke.Transparency = 0.8

	local TopBar = Instance.new("Frame", Main)
	TopBar.Size = UDim2.new(1,0,0,40)
	TopBar.BackgroundTransparency = 1

	local Title = Instance.new("TextLabel", TopBar)
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0,12,0,0)
	Title.Size = UDim2.new(1,-90,1,0)
	Title.Font = Enum.Font.GothamBold
	Title.Text = title or "Glass Hub"
	Title.TextSize = 18
	Title.TextColor3 = Color3.new(1,1,1)
	Title.TextXAlignment = Enum.TextXAlignment.Left

	local Minimize = Instance.new("TextButton", TopBar)
	Minimize.Size = UDim2.new(0,30,0,30)
	Minimize.Position = UDim2.new(1,-70,0,5)
	Minimize.Text = "-"
	Minimize.BackgroundTransparency = 1
	Minimize.Font = Enum.Font.GothamBold
	Minimize.TextSize = 20
	Minimize.TextColor3 = Color3.new(1,1,1)

	local Close = Instance.new("TextButton", TopBar)
	Close.Size = UDim2.new(0,30,0,30)
	Close.Position = UDim2.new(1,-35,0,5)
	Close.Text = "X"
	Close.BackgroundTransparency = 1
	Close.Font = Enum.Font.GothamBold
	Close.TextSize = 18
	Close.TextColor3 = Color3.fromRGB(255,90,90)

	local Body = Instance.new("Frame", Main)
	Body.Position = UDim2.new(0,0,0,40)
	Body.Size = UDim2.new(1,0,1,-40)
	Body.BackgroundTransparency = 1

	-- drag
	local dragging = false
	local dragStart, startPos

	TopBar.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = i.Position
			startPos = Main.Position
		end
	end)

	UserInputService.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local delta = i.Position - dragStart
			Main.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)

	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	-- sidebar/pages
	local Sidebar = Instance.new("ScrollingFrame", Body)
	Sidebar.Size = UDim2.new(0,130,1,0)
	Sidebar.BackgroundColor3 = Color3.fromRGB(55,55,55)
	Sidebar.BackgroundTransparency = 0.35
	Sidebar.ScrollBarThickness = 4

	Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0,10)

	local Layout = Instance.new("UIListLayout", Sidebar)
	Layout.Padding = UDim.new(0,6)

	local Pages = Instance.new("Frame", Body)
	Pages.Position = UDim2.new(0,140,0,0)
	Pages.Size = UDim2.new(1,-145,1,0)
	Pages.BackgroundTransparency = 1

	-- minimize fix
	local minimized = false
	local fullSize = Body.Size

	Minimize.MouseButton1Click:Connect(function()
		minimized = not minimized
		Minimize.Text = minimized and "+" or "-"

		TweenService:Create(Body,
			TweenInfo.new(0.25),
			{Size = minimized and UDim2.new(1,0,0,0) or fullSize}
		):Play()
	end)

	Close.MouseButton1Click:Connect(function()
		ScreenGui:Destroy()
	end)

	Window = {
		ScreenGui = ScreenGui,
		Main = Main,
		Body = Body,
		Sidebar = Sidebar,
		Pages = Pages,
		Tabs = {}
	}

	-- IMPORTANT FIX 👇
	return Window
end

--////////////////////////////////////////////////////

function Window:CreateTab(name)

	local Button = Instance.new("TextButton")
	Button.Parent = self.Sidebar
	Button.Size = UDim2.new(1,-10,0,36)
	Button.BackgroundColor3 = Color3.fromRGB(70,70,70)
	Button.Text = name
	Button.TextColor3 = Color3.new(1,1,1)

	Instance.new("UICorner", Button).CornerRadius = UDim.new(0,8)

	local Page = Instance.new("ScrollingFrame")
	Page.Parent = self.Pages
	Page.Size = UDim2.new(1,0,1,0)
	Page.Visible = false
	Page.BackgroundTransparency = 1

	local layout = Instance.new("UIListLayout", Page)
	layout.Padding = UDim.new(0,6)

	local NewTab = setmetatable({}, Tab)
	NewTab.Button = Button
	NewTab.Page = Page

	table.insert(self.Tabs, NewTab)

	if #self.Tabs == 1 then
		Page.Visible = true
	end

	Button.MouseButton1Click:Connect(function()
		for _, v in ipairs(self.Tabs) do
			v.Page.Visible = false
		end
		Page.Visible = true
	end)

	return NewTab
end

--////////////////////////////////////////////////////

function Tab:CreateButton(text, callback)
	local b = Instance.new("TextButton")
	b.Parent = self.Page
	b.Size = UDim2.new(1,-10,0,38)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(70,70,70)
	b.TextColor3 = Color3.new(1,1,1)

	Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)

	b.MouseButton1Click:Connect(function()
		print("clicked")
		if callback then callback() end
	end)

	return b
end

function Tab:CreateToggle(text, callback)
	local state = false

	local holder = Instance.new("TextButton")
	holder.Parent = self.Page
	holder.Size = UDim2.new(1,-10,0,40)
	holder.Text = text

	holder.MouseButton1Click:Connect(function()
		state = not state
		print("toggle:", state)
		if callback then callback(state) end
	end)

	return holder
end

function Tab:CreateSlider(text, min, max, default, callback)
	local val = default or min

	local holder = Instance.new("TextButton")
	holder.Parent = self.Page
	holder.Size = UDim2.new(1,-10,0,40)
	holder.Text = text .. " : " .. val

	holder.MouseButton1Click:Connect(function()
		val = math.clamp(val + 5, min, max)
		holder.Text = text .. " : " .. val
		print("slider:", val)
		if callback then callback(val) end
	end)

	return holder
end

function Tab:CreateTextbox(placeholder, callback)
	local box = Instance.new("TextBox")
	box.Parent = self.Page
	box.Size = UDim2.new(1,-10,0,40)
	box.PlaceholderText = placeholder

	box.FocusLost:Connect(function()
		print("textbox:", box.Text)
		if callback then callback(box.Text) end
	end)

	return box
end

--////////////////////////////////////////////////////

function Glass:Notify(title, text)
	print("notify:", title, text)
end

return Glass
