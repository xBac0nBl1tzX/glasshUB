local CoreGui = game:GetService("CoreGui")

local Glass = {}

local Window = {}
local Tab = {}

function Glass:CreateWindow(title)

	-- Remove old GUI
	pcall(function()
		local old = CoreGui:FindFirstChild("GlassUI")
		if old then
			old:Destroy()
		end
	end)

	-- ScreenGui
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "GlassUI"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = CoreGui

	-- Main Window
	local Main = Instance.new("Frame")
	Main.Parent = ScreenGui
	Main.Name = "Main"
	Main.AnchorPoint = Vector2.new(0.5,0.5)
	Main.Position = UDim2.new(0.5,0,0.5,0)
	Main.Size = UDim2.new(0,520,0,330)
	Main.BackgroundColor3 = Color3.fromRGB(60,60,60)
	Main.BackgroundTransparency = 0.4
	Main.Active = true

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0,12)
	Corner.Parent = Main

	local Stroke = Instance.new("UIStroke")
	Stroke.Parent = Main
	Stroke.Color = Color3.fromRGB(255,255,255)
	Stroke.Transparency = 0.8
	Stroke.Thickness = 1

	-- Top Bar
	local TopBar = Instance.new("Frame")
	TopBar.Parent = Main
	TopBar.Name = "TopBar"
	TopBar.Size = UDim2.new(1,0,0,40)
	TopBar.BackgroundTransparency = 1

	-- Title
	local Title = Instance.new("TextLabel")
	Title.Parent = TopBar
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0,12,0,0)
	Title.Size = UDim2.new(1,-90,1,0)
	Title.Font = Enum.Font.GothamBold
	Title.Text = title or "Glass Hub"
	Title.TextSize = 18
	Title.TextColor3 = Color3.new(1,1,1)
	Title.TextXAlignment = Enum.TextXAlignment.Left

	-- Minimize
	local Minimize = Instance.new("TextButton")
	Minimize.Parent = TopBar
	Minimize.Size = UDim2.new(0,30,0,30)
	Minimize.Position = UDim2.new(1,-70,0,5)
	Minimize.BackgroundTransparency = 1
	Minimize.Text = "-"
	Minimize.Font = Enum.Font.GothamBold
	Minimize.TextSize = 20
	Minimize.TextColor3 = Color3.new(1,1,1)

	-- Close
	local Close = Instance.new("TextButton")
	Close.Parent = TopBar
	Close.Size = UDim2.new(0,30,0,30)
	Close.Position = UDim2.new(1,-35,0,5)
	Close.BackgroundTransparency = 1
	Close.Text = "X"
	Close.Font = Enum.Font.GothamBold
	Close.TextSize = 18
	Close.TextColor3 = Color3.fromRGB(255,90,90)

	-- Body (this is what we'll tween when minimizing)
	local Body = Instance.new("Frame")
	Body.Parent = Main
	Body.Name = "Body"
	Body.Position = UDim2.new(0,0,0,40)
	Body.Size = UDim2.new(1,0,1,-40)
	Body.BackgroundTransparency = 1

local TweenService = game:GetService("TweenService")

local Minimized = false
local FullSize = Body.Size

Minimize.MouseButton1Click:Connect(function()

	Minimized = not Minimized

	if Minimized then

		Minimize.Text = "+"

		TweenService:Create(
			Body,
			TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{
				Size = UDim2.new(1,0,0,0)
			}
		):Play()

	else

		Minimize.Text = "-"

		TweenService:Create(
			Body,
			TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{
				Size = FullSize
			}
		):Play()

	end

end)

Close.MouseButton1Click:Connect(function()
	ScreenGui:Destroy()
end)

local Dragging = false
local DragStart
local StartPosition

TopBar.InputBegan:Connect(function(input)

	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then

		Dragging = true
		DragStart = input.Position
		StartPosition = Main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				Dragging = false
			end
		end)

	end

end)

UserInputService.InputChanged:Connect(function(input)

	if Dragging and (
		input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch
	) then

		local Delta = input.Position - DragStart

		Main.Position = UDim2.new(
			StartPosition.X.Scale,
			StartPosition.X.Offset + Delta.X,
			StartPosition.Y.Scale,
			StartPosition.Y.Offset + Delta.Y
		)

	end

end)

	-- Sidebar
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Parent = Body
Sidebar.Size = UDim2.new(0,130,1,0)
Sidebar.BackgroundColor3 = Color3.fromRGB(55,55,55)
Sidebar.BackgroundTransparency = 0.35
Sidebar.BorderSizePixel = 0
Sidebar.ScrollBarThickness = 4

local SideCorner = Instance.new("UICorner")
SideCorner.CornerRadius = UDim.new(0,10)
SideCorner.Parent = Sidebar

local SideLayout = Instance.new("UIListLayout")
SideLayout.Parent = Sidebar
SideLayout.Padding = UDim.new(0,6)

SideLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	Sidebar.CanvasSize = UDim2.new(0,0,0,SideLayout.AbsoluteContentSize.Y + 10)
end)

-- Pages
local Pages = Instance.new("Frame")
Pages.Parent = Body
Pages.Position = UDim2.new(0,140,0,0)
Pages.Size = UDim2.new(1,-145,1,0)
Pages.BackgroundTransparency = 1

-- Create the Window object

Window.ScreenGui = ScreenGui
Window.Main = Main
Window.Body = Body
Window.Sidebar = Sidebar
Window.Pages = Pages
Window.Minimize = Minimize
Window.Close = Close
Window.Tabs = {}

function Window:CreateTab(name)

	self.Tabs = self.Tabs or {}

	-- Create sidebar button
	local Button = Instance.new("TextButton")
	Button.Parent = self.Sidebar
	Button.Name = name
	Button.Size = UDim2.new(1, -10, 0, 36)
	Button.BackgroundColor3 = Color3.fromRGB(70,70,70)
	Button.BackgroundTransparency = 0.35
	Button.Text = name
	Button.TextColor3 = Color3.fromRGB(255,255,255)
	Button.Font = Enum.Font.Gotham
	Button.TextSize = 14
	Button.AutoButtonColor = false

	local ButtonCorner = Instance.new("UICorner")
	ButtonCorner.CornerRadius = UDim.new(0,8)
	ButtonCorner.Parent = Button

	-- Create page
	local Page = Instance.new("ScrollingFrame")
	Page.Parent = self.Pages
	Page.Name = name
	Page.Size = UDim2.new(1,0,1,0)
	Page.BackgroundTransparency = 1
	Page.BorderSizePixel = 0
	Page.ScrollBarThickness = 4
	Page.CanvasSize = UDim2.new(0,0,0,0)
	Page.Visible = false

	local PageLayout = Instance.new("UIListLayout")
	PageLayout.Parent = Page
	PageLayout.Padding = UDim.new(0,6)
	PageLayout.SortOrder = Enum.SortOrder.LayoutOrder

	PageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		Page.CanvasSize = UDim2.new(0,0,0,PageLayout.AbsoluteContentSize.Y + 10)
	end)

	-- First tab is visible
	if #self.Tabs == 0 then
		Page.Visible = true
	end

	local NewTab = setmetatable({}, {__index = Tab})

NewTab.Button = Button
NewTab.Page = Page

table.insert(self.Tabs, NewTab)


	-- Tab switching
	Button.MouseButton1Click:Connect(function()

		for _, v in ipairs(self.Tabs) do
			v.Page.Visible = false
		end

		Page.Visible = true

	end)

	return Tab
end

return Window

function Tab:CreateButton(text, callback)

	local Button = Instance.new("TextButton")
	Button.Parent = self.Page
	Button.Size = UDim2.new(1, -10, 0, 38)
	Button.BackgroundColor3 = Color3.fromRGB(70,70,70)
	Button.BackgroundTransparency = 0.35
	Button.BorderSizePixel = 0
	Button.Text = text or "Button"
	Button.TextColor3 = Color3.fromRGB(255,255,255)
	Button.Font = Enum.Font.Gotham
	Button.TextSize = 14
	Button.AutoButtonColor = false

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0,8)
	Corner.Parent = Button

	local Stroke = Instance.new("UIStroke")
	Stroke.Parent = Button
	Stroke.Color = Color3.fromRGB(255,255,255)
	Stroke.Transparency = 0.85
	Stroke.Thickness = 1

	Button.MouseButton1Click:Connect(function()
		if callback then
			task.spawn(callback)
		end
	end)

	return Button
end

function Tab:CreateToggle(text, callback)

	local Enabled = false

	-- Container
	local Holder = Instance.new("Frame")
	Holder.Parent = self.Page
	Holder.Size = UDim2.new(1,-10,0,40)
	Holder.BackgroundColor3 = Color3.fromRGB(70,70,70)
	Holder.BackgroundTransparency = 0.35
	Holder.BorderSizePixel = 0

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0,8)
	Corner.Parent = Holder

	local Stroke = Instance.new("UIStroke")
	Stroke.Parent = Holder
	Stroke.Color = Color3.fromRGB(255,255,255)
	Stroke.Transparency = 0.85

	-- Text
	local Label = Instance.new("TextLabel")
	Label.Parent = Holder
	Label.BackgroundTransparency = 1
	Label.Position = UDim2.new(0,12,0,0)
	Label.Size = UDim2.new(1,-70,1,0)
	Label.Font = Enum.Font.Gotham
	Label.Text = text
	Label.TextColor3 = Color3.fromRGB(255,255,255)
	Label.TextSize = 14
	Label.TextXAlignment = Enum.TextXAlignment.Left

	-- Toggle Bar
	local Bar = Instance.new("Frame")
	Bar.Parent = Holder
	Bar.AnchorPoint = Vector2.new(1,0.5)
	Bar.Position = UDim2.new(1,-12,0.5,0)
	Bar.Size = UDim2.new(0,40,0,18)
	Bar.BackgroundColor3 = Color3.fromRGB(110,110,110)
	Bar.BorderSizePixel = 0

	local BarCorner = Instance.new("UICorner")
	BarCorner.CornerRadius = UDim.new(1,0)
	BarCorner.Parent = Bar

	-- Toggle Circle
	local Circle = Instance.new("Frame")
	Circle.Parent = Bar
	Circle.Size = UDim2.new(0,14,0,14)
	Circle.Position = UDim2.new(0,2,0.5,-7)
	Circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Circle.BorderSizePixel = 0

	local CircleCorner = Instance.new("UICorner")
	CircleCorner.CornerRadius = UDim.new(1,0)
	CircleCorner.Parent = Circle

	-- Click
	Holder.InputBegan:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

			Enabled = not Enabled

			if Enabled then

				game:GetService("TweenService"):Create(
					Circle,
					TweenInfo.new(0.2),
					{Position = UDim2.new(1,-16,0.5,-7)}
				):Play()

				game:GetService("TweenService"):Create(
					Bar,
					TweenInfo.new(0.2),
					{BackgroundColor3 = Color3.fromRGB(210,210,210)}
				):Play()

			else

				game:GetService("TweenService"):Create(
					Circle,
					TweenInfo.new(0.2),
					{Position = UDim2.new(0,2,0.5,-7)}
				):Play()

				game:GetService("TweenService"):Create(
					Bar,
					TweenInfo.new(0.2),
					{BackgroundColor3 = Color3.fromRGB(110,110,110)}
				):Play()

			end

			if callback then
				task.spawn(callback, Enabled)
			end

		end

	end)

	return Holder

end

function Tab:CreateSlider(text, min, max, default, callback)

	local Value = math.clamp(default or min, min, max)

	-- Holder
	local Holder = Instance.new("Frame")
	Holder.Parent = self.Page
	Holder.Size = UDim2.new(1,-10,0,55)
	Holder.BackgroundColor3 = Color3.fromRGB(70,70,70)
	Holder.BackgroundTransparency = 0.35
	Holder.BorderSizePixel = 0

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0,8)
	Corner.Parent = Holder

	local Stroke = Instance.new("UIStroke")
	Stroke.Parent = Holder
	Stroke.Color = Color3.fromRGB(255,255,255)
	Stroke.Transparency = 0.85

	-- Name
	local Label = Instance.new("TextLabel")
	Label.Parent = Holder
	Label.BackgroundTransparency = 1
	Label.Position = UDim2.new(0,12,0,5)
	Label.Size = UDim2.new(0.7,0,0,18)
	Label.Text = text
	Label.Font = Enum.Font.Gotham
	Label.TextSize = 14
	Label.TextColor3 = Color3.new(1,1,1)
	Label.TextXAlignment = Enum.TextXAlignment.Left

	-- Value
	local ValueLabel = Instance.new("TextLabel")
	ValueLabel.Parent = Holder
	ValueLabel.BackgroundTransparency = 1
	ValueLabel.Position = UDim2.new(1,-60,0,5)
	ValueLabel.Size = UDim2.new(0,50,0,18)
	ValueLabel.Text = tostring(Value)
	ValueLabel.Font = Enum.Font.GothamBold
	ValueLabel.TextSize = 14
	ValueLabel.TextColor3 = Color3.new(1,1,1)

	-- Slider Bar
	local Bar = Instance.new("Frame")
	Bar.Parent = Holder
	Bar.Position = UDim2.new(0,12,0,34)
	Bar.Size = UDim2.new(1,-24,0,6)
	Bar.BackgroundColor3 = Color3.fromRGB(110,110,110)
	Bar.BorderSizePixel = 0

	local BarCorner = Instance.new("UICorner")
	BarCorner.CornerRadius = UDim.new(1,0)
	BarCorner.Parent = Bar

	-- Fill
	local Fill = Instance.new("Frame")
	Fill.Parent = Bar
	Fill.Size = UDim2.new((Value-min)/(max-min),0,1,0)
	Fill.BackgroundColor3 = Color3.fromRGB(235,235,235)
	Fill.BorderSizePixel = 0

	local FillCorner = Instance.new("UICorner")
	FillCorner.CornerRadius = UDim.new(1,0)
	FillCorner.Parent = Fill

	-- BIG Mobile Thumb
	local Thumb = Instance.new("Frame")
	Thumb.Parent = Bar
	Thumb.Size = UDim2.new(0,20,0,20)
	Thumb.AnchorPoint = Vector2.new(0.5,0.5)
	Thumb.Position = UDim2.new((Value-min)/(max-min),0,0.5,0)
	Thumb.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Thumb.BorderSizePixel = 0

	local ThumbCorner = Instance.new("UICorner")
	ThumbCorner.CornerRadius = UDim.new(1,0)
	ThumbCorner.Parent = Thumb

	local UIS = game:GetService("UserInputService")
	local Dragging = false

	local function Update(InputX)

		local Percent = math.clamp(
			(InputX-Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X,
			0,
			1
		)

		Value = math.floor(min + ((max-min)*Percent) + 0.5)

		Fill.Size = UDim2.new(Percent,0,1,0)
		Thumb.Position = UDim2.new(Percent,0,0.5,0)
		ValueLabel.Text = tostring(Value)

		if callback then
			callback(Value)
		end
	end

	Bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

			Dragging = true
			Update(input.Position.X)

		end
	end)

	UIS.InputChanged:Connect(function(input)
		if Dragging and (
			input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch
		) then
			Update(input.Position.X)
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

			Dragging = false

		end
	end)

	return Holder

end

function Tab:CreateTextbox(placeholder, callback)

	local Holder = Instance.new("Frame")
	Holder.Parent = self.Page
	Holder.Size = UDim2.new(1,-10,0,40)
	Holder.BackgroundColor3 = Color3.fromRGB(70,70,70)
	Holder.BackgroundTransparency = 0.35
	Holder.BorderSizePixel = 0

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0,8)
	Corner.Parent = Holder

	local Stroke = Instance.new("UIStroke")
	Stroke.Parent = Holder
	Stroke.Color = Color3.fromRGB(255,255,255)
	Stroke.Transparency = 0.85

	local Box = Instance.new("TextBox")
	Box.Parent = Holder
	Box.BackgroundTransparency = 1
	Box.Position = UDim2.new(0,12,0,0)
	Box.Size = UDim2.new(1,-24,1,0)
	Box.ClearTextOnFocus = false
	Box.PlaceholderText = placeholder or "Enter text..."
	Box.PlaceholderColor3 = Color3.fromRGB(180,180,180)
	Box.Text = ""
	Box.TextColor3 = Color3.fromRGB(255,255,255)
	Box.Font = Enum.Font.Gotham
	Box.TextSize = 14
	Box.TextXAlignment = Enum.TextXAlignment.Left

	Box.FocusLost:Connect(function(enterPressed)
		if callback then
			task.spawn(callback, Box.Text, enterPressed)
		end
	end)

	return Box

end

function Tab:CreateDropdown(text, options, callback)

	local Open = false
	local Selected = text

	local Holder = Instance.new("Frame")
	Holder.Parent = self.Page
	Holder.Size = UDim2.new(1,-10,0,40)
	Holder.BackgroundColor3 = Color3.fromRGB(70,70,70)
	Holder.BackgroundTransparency = 0.35
	Holder.BorderSizePixel = 0
	Holder.ClipsDescendants = true

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0,8)
	Corner.Parent = Holder

	local Stroke = Instance.new("UIStroke")
	Stroke.Parent = Holder
	Stroke.Color = Color3.fromRGB(255,255,255)
	Stroke.Transparency = 0.85

	local MainButton = Instance.new("TextButton")
	MainButton.Parent = Holder
	MainButton.Size = UDim2.new(1,0,0,40)
	MainButton.BackgroundTransparency = 1
	MainButton.Text = ""

	local Label = Instance.new("TextLabel")
	Label.Parent = MainButton
	Label.BackgroundTransparency = 1
	Label.Position = UDim2.new(0,12,0,0)
	Label.Size = UDim2.new(1,-40,1,0)
	Label.Text = Selected
	Label.Font = Enum.Font.Gotham
	Label.TextSize = 14
	Label.TextColor3 = Color3.new(1,1,1)
	Label.TextXAlignment = Enum.TextXAlignment.Left

	local Arrow = Instance.new("TextLabel")
	Arrow.Parent = MainButton
	Arrow.BackgroundTransparency = 1
	Arrow.Position = UDim2.new(1,-28,0,0)
	Arrow.Size = UDim2.new(0,20,1,0)
	Arrow.Text = "▼"
	Arrow.Font = Enum.Font.GothamBold
	Arrow.TextColor3 = Color3.new(1,1,1)
	Arrow.TextSize = 16

	local Layout = Instance.new("UIListLayout")
	Layout.Parent = Holder
	Layout.Padding = UDim.new(0,2)
	Layout.SortOrder = Enum.SortOrder.LayoutOrder

	MainButton.LayoutOrder = 1

	local TweenService = game:GetService("TweenService")

	for i, Option in ipairs(options) do

		local OptionButton = Instance.new("TextButton")
		OptionButton.Parent = Holder
		OptionButton.LayoutOrder = i + 1
		OptionButton.Size = UDim2.new(1,-8,0,34)
		OptionButton.Position = UDim2.new(0,4,0,0)
		OptionButton.BackgroundColor3 = Color3.fromRGB(85,85,85)
		OptionButton.BackgroundTransparency = 0.3
		OptionButton.Visible = false
		OptionButton.Text = Option
		OptionButton.Font = Enum.Font.Gotham
		OptionButton.TextSize = 13
		OptionButton.TextColor3 = Color3.new(1,1,1)

		local C = Instance.new("UICorner")
		C.CornerRadius = UDim.new(0,6)
		C.Parent = OptionButton

		OptionButton.MouseButton1Click:Connect(function()

			Label.Text = Option
			Open = false
			Arrow.Text = "▼"

			for _, v in ipairs(Holder:GetChildren()) do
				if v:IsA("TextButton") and v ~= MainButton then
					v.Visible = false
				end
			end

			TweenService:Create(
				Holder,
				TweenInfo.new(0.2),
				{Size = UDim2.new(1,-10,0,40)}
			):Play()

			if callback then
				task.spawn(callback, Option)
			end

		end)

	end

	MainButton.MouseButton1Click:Connect(function()

		Open = not Open

		if Open then

			Arrow.Text = "▲"

			for _, v in ipairs(Holder:GetChildren()) do
				if v:IsA("TextButton") and v ~= MainButton then
					v.Visible = true
				end
			end

			TweenService:Create(
				Holder,
				TweenInfo.new(0.2),
				{Size = UDim2.new(1,-10,0,40 + (#options * 36))}
			):Play()

		else

			Arrow.Text = "▼"

			for _, v in ipairs(Holder:GetChildren()) do
				if v:IsA("TextButton") and v ~= MainButton then
					v.Visible = false
				end
			end

			TweenService:Create(
				Holder,
				TweenInfo.new(0.2),
				{Size = UDim2.new(1,-10,0,40)}
			):Play()

		end

	end)

	return Holder

end

function Glass:Notify(title, text, duration)

	duration = duration or 3

	local TweenService = game:GetService("TweenService")
	local CoreGui = game:GetService("CoreGui")

	local Gui = CoreGui:FindFirstChild("GlassNotifications")

	if not Gui then

		Gui = Instance.new("ScreenGui")
		Gui.Name = "GlassNotifications"
		Gui.ResetOnSpawn = false
		Gui.Parent = CoreGui

		local Holder = Instance.new("Frame")
		Holder.Name = "Holder"
		Holder.Parent = Gui
		Holder.BackgroundTransparency = 1
		Holder.AnchorPoint = Vector2.new(1,0)
		Holder.Position = UDim2.new(1,-15,0,15)
		Holder.Size = UDim2.new(0,320,1,-30)

		local Layout = Instance.new("UIListLayout")
		Layout.Parent = Holder
		Layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
		Layout.VerticalAlignment = Enum.VerticalAlignment.Top
		Layout.Padding = UDim.new(0,8)

	end

	local Holder = Gui.Holder

	local Notification = Instance.new("Frame")
	Notification.Parent = Holder
	Notification.Size = UDim2.new(1,0,0,72)
	Notification.Position = UDim2.new(1.2,0,0,0)
	Notification.BackgroundColor3 = Color3.fromRGB(70,70,70)
	Notification.BackgroundTransparency = 0.35
	Notification.BorderSizePixel = 0

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0,10)
	Corner.Parent = Notification

	local Stroke = Instance.new("UIStroke")
	Stroke.Parent = Notification
	Stroke.Color = Color3.fromRGB(255,255,255)
	Stroke.Transparency = 0.85

	local Title = Instance.new("TextLabel")
	Title.Parent = Notification
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0,12,0,8)
	Title.Size = UDim2.new(1,-24,0,18)
	Title.Font = Enum.Font.GothamBold
	Title.Text = title
	Title.TextColor3 = Color3.new(1,1,1)
	Title.TextSize = 15
	Title.TextXAlignment = Enum.TextXAlignment.Left

	local Description = Instance.new("TextLabel")
	Description.Parent = Notification
	Description.BackgroundTransparency = 1
	Description.Position = UDim2.new(0,12,0,30)
	Description.Size = UDim2.new(1,-24,1,-34)
	Description.Font = Enum.Font.Gotham
	Description.Text = text
	Description.TextWrapped = true
	Description.TextColor3 = Color3.fromRGB(230,230,230)
	Description.TextSize = 13
	Description.TextXAlignment = Enum.TextXAlignment.Left
	Description.TextYAlignment = Enum.TextYAlignment.Top

	TweenService:Create(
		Notification,
		TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{
			Position = UDim2.new(0,0,0,0)
		}
	):Play()

	task.delay(duration,function()

		local Out = TweenService:Create(
			Notification,
			TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
			{
				Position = UDim2.new(1.2,0,0,0)
			}
		)

		Out:Play()
		Out.Completed:Wait()

		Notification:Destroy()

	end)

end

return Glass
