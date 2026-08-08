-- // BoatHelper - Premium Menu Script with ESP, WalkSpeed, JumpPower, AutoFarm, Fly, Teleport, NoClip & Visual Effects
-- // Поместите этот LocalScript в StarterGui или StarterPlayerScripts

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Camera = workspace.CurrentCamera

-- // Создание основного контейнера
local Menu = Instance.new("ScreenGui")
Menu.Name = "BoatHelper"
Menu.ResetOnSpawn = false
Menu.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Menu.Parent = PlayerGui

-- // Главная рамка
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 450)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = Menu

-- // Тень для главной рамки
local MainShadow = Instance.new("ImageLabel")
MainShadow.Name = "MainShadow"
MainShadow.Size = UDim2.new(1, 20, 1, 20)
MainShadow.Position = UDim2.new(0, -10, 0, -10)
MainShadow.BackgroundTransparency = 1
MainShadow.Image = "rbxassetid://6014261993"
MainShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
MainShadow.ImageTransparency = 0.6
MainShadow.ScaleType = Enum.ScaleType.Slice
MainShadow.SliceCenter = Rect.new(49, 49, 49, 49)
MainShadow.ZIndex = -1
MainShadow.Parent = MainFrame

-- // Верхняя панель для перетаскивания
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.Position = UDim2.new(0, 0, 0, 0)
TopBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

-- // Градиент на верхней панели
local TopGradient = Instance.new("UIGradient")
TopGradient.Name = "TopGradient"
TopGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
})
TopGradient.Rotation = 90
TopGradient.Parent = TopBar

-- // Акцентная линия на верхней панели
local AccentLine = Instance.new("Frame")
AccentLine.Name = "AccentLine"
AccentLine.Size = UDim2.new(1, 0, 0, 2)
AccentLine.Position = UDim2.new(0, 0, 1, -2)
AccentLine.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
AccentLine.BorderSizePixel = 0
AccentLine.Parent = TopBar

-- // Пульсация акцентной линии
local accentPulse = false
coroutine.wrap(function()
	while true do
		if accentPulse then
			for i = 0, 1, 0.02 do
				AccentLine.BackgroundColor3 = Color3.fromRGB(
					0 + math.sin(i * math.pi) * 30,
					170 + math.sin(i * math.pi) * 30,
					100 + math.sin(i * math.pi) * 30
				)
				task.wait(0.02)
			end
		else
			task.wait(0.1)
		end
	end
end)()

-- // Заголовок с эффектом свечения
local TitleGlow = Instance.new("TextLabel")
TitleGlow.Name = "TitleGlow"
TitleGlow.Size = UDim2.new(0, 180, 1, 0)
TitleGlow.Position = UDim2.new(0, 12, 0, 0)
TitleGlow.BackgroundTransparency = 1
TitleGlow.Font = Enum.Font.GothamBold
TitleGlow.Text = "BoatHelper"
TitleGlow.TextColor3 = Color3.fromRGB(0, 170, 100)
TitleGlow.TextSize = 14
TitleGlow.TextXAlignment = Enum.TextXAlignment.Left
TitleGlow.TextTransparency = 0.7
TitleGlow.Parent = TopBar

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 180, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "BoatHelper"
Title.TextColor3 = Color3.fromRGB(200, 200, 200)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- // Контейнер для кнопок (с прокруткой)
local ButtonContainer = Instance.new("ScrollingFrame")
ButtonContainer.Name = "ButtonContainer"
ButtonContainer.Size = UDim2.new(1, 0, 1, -30)
ButtonContainer.Position = UDim2.new(0, 0, 0, 30)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.BorderSizePixel = 0
ButtonContainer.ScrollBarThickness = 4
ButtonContainer.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 100)
ButtonContainer.ScrollingDirection = Enum.ScrollingDirection.Y
ButtonContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
ButtonContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ButtonContainer.Parent = MainFrame

-- // UIListLayout для автоматического позиционирования элементов
local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 8)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.SortOrder = Enum.SortOrder.LayoutOrder
Layout.Parent = ButtonContainer

-- Добавляем небольшой отступ сверху
local Padding = Instance.new("UIPadding")
Padding.PaddingTop = UDim.new(0, 10)
Padding.Parent = ButtonContainer

-- // ==================== ФУНКЦИЯ ПЕРЕТАСКИВАНИЯ ====================
local dragging = false
local dragStart, startPos

TopBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
		accentPulse = true
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
				accentPulse = false
				AccentLine.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- // ==================== ОТКРЫТИЕ/ЗАКРЫТИЕ НА INSERT ====================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.Insert then
		MainFrame.Visible = not MainFrame.Visible
	end
end)

-- // ==================== ФУНКЦИЯ СОЗДАНИЯ ПЕРЕКЛЮЧАТЕЛЯ ====================
local function CreateToggleButton(name, description, callback)
	local ToggleFrame = Instance.new("Frame")
	ToggleFrame.Name = name .. "_ToggleFrame"
	ToggleFrame.Size = UDim2.new(1, -20, 0, 50)
	ToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	ToggleFrame.BorderSizePixel = 0
	ToggleFrame.LayoutOrder = #ButtonContainer:GetChildren()

	-- Градиент фона
	local FrameGradient = Instance.new("UIGradient")
	FrameGradient.Name = "FrameGradient"
	FrameGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
	})
	FrameGradient.Rotation = 45
	FrameGradient.Parent = ToggleFrame

	-- Левая акцентная полоска
	local LeftAccent = Instance.new("Frame")
	LeftAccent.Name = "LeftAccent"
	LeftAccent.Size = UDim2.new(0, 2, 1, 0)
	LeftAccent.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
	LeftAccent.BorderSizePixel = 0
	LeftAccent.BackgroundTransparency = 1
	LeftAccent.Parent = ToggleFrame

	-- Информация слева
	local InfoFrame = Instance.new("Frame")
	InfoFrame.Size = UDim2.new(0, 180, 1, 0)
	InfoFrame.Position = UDim2.new(0, 12, 0, 0)
	InfoFrame.BackgroundTransparency = 1
	InfoFrame.Parent = ToggleFrame

	local FuncName = Instance.new("TextLabel")
	FuncName.Name = "FuncName"
	FuncName.Size = UDim2.new(1, 0, 0, 22)
	FuncName.Position = UDim2.new(0, 0, 0, 6)
	FuncName.BackgroundTransparency = 1
	FuncName.Font = Enum.Font.GothamBold
	FuncName.Text = name
	FuncName.TextColor3 = Color3.fromRGB(220, 220, 220)
	FuncName.TextSize = 14
	FuncName.TextXAlignment = Enum.TextXAlignment.Left
	FuncName.Parent = InfoFrame

	local Desc = Instance.new("TextLabel")
	Desc.Name = "Description"
	Desc.Size = UDim2.new(1, 0, 0, 16)
	Desc.Position = UDim2.new(0, 0, 0, 28)
	Desc.BackgroundTransparency = 1
	Desc.Font = Enum.Font.Gotham
	Desc.Text = description
	Desc.TextColor3 = Color3.fromRGB(140, 140, 140)
	Desc.TextSize = 11
	Desc.TextXAlignment = Enum.TextXAlignment.Left
	Desc.Parent = InfoFrame

	-- Сам переключатель
	local ToggleSwitch = Instance.new("Frame")
	ToggleSwitch.Name = "ToggleSwitch"
	ToggleSwitch.Size = UDim2.new(0, 44, 0, 24)
	ToggleSwitch.Position = UDim2.new(1, -56, 0.5, -12)
	ToggleSwitch.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	ToggleSwitch.BorderSizePixel = 0
	ToggleSwitch.Parent = ToggleFrame

	-- Градиент переключателя
	local SwitchGradient = Instance.new("UIGradient")
	SwitchGradient.Name = "SwitchGradient"
	SwitchGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 80)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
	})
	SwitchGradient.Rotation = 90
	SwitchGradient.Parent = ToggleSwitch

	local ToggleKnob = Instance.new("Frame")
	ToggleKnob.Name = "ToggleKnob"
	ToggleKnob.Size = UDim2.new(0, 20, 0, 20)
	ToggleKnob.Position = UDim2.new(0, 2, 0.5, -10)
	ToggleKnob.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
	ToggleKnob.BorderSizePixel = 0
	ToggleKnob.Parent = ToggleSwitch

	-- Градиент кноба
	local KnobGradient = Instance.new("UIGradient")
	KnobGradient.Name = "KnobGradient"
	KnobGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180))
	})
	KnobGradient.Rotation = 45
	KnobGradient.Parent = ToggleKnob

	-- Переменная состояния
	local toggled = false

	-- Функция обновления внешнего вида
	local function UpdateVisual()
		if toggled then
			ToggleSwitch.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
			SwitchGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 120)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 80))
			})
			ToggleKnob:TweenPosition(
				UDim2.new(1, -22, 0.5, -10),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Quad,
				0.15
			)
			LeftAccent.BackgroundTransparency = 0
		else
			ToggleSwitch.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			SwitchGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 80, 80)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
			})
			ToggleKnob:TweenPosition(
				UDim2.new(0, 2, 0.5, -10),
				Enum.EasingDirection.Out,
				Enum.EasingStyle.Quad,
				0.15
			)
			LeftAccent.BackgroundTransparency = 1
		end
	end

	-- Обработчик клика по переключателю
	ToggleSwitch.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			toggled = not toggled
			UpdateVisual()
			if callback then
				callback(toggled)
			end
		end
	end)

	-- Эффект при наведении
	ToggleFrame.MouseEnter:Connect(function()
		FrameGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 45)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
		})
	end)
	ToggleFrame.MouseLeave:Connect(function()
		FrameGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
		})
	end)

	ToggleFrame.Parent = ButtonContainer
	return ToggleFrame
end

-- // ==================== ФУНКЦИЯ СОЗДАНИЯ ОБЫЧНОЙ КНОПКИ ====================
local function CreateButton(name, callback)
	local ButtonFrame = Instance.new("Frame")
	ButtonFrame.Name = name .. "_ButtonFrame"
	ButtonFrame.Size = UDim2.new(1, -20, 0, 40)
	ButtonFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	ButtonFrame.BorderSizePixel = 0
	ButtonFrame.LayoutOrder = #ButtonContainer:GetChildren()

	-- Градиент фона
	local FrameGradient = Instance.new("UIGradient")
	FrameGradient.Name = "FrameGradient"
	FrameGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
	})
	FrameGradient.Rotation = 45
	FrameGradient.Parent = ButtonFrame

	local Button = Instance.new("TextButton")
	Button.Name = "Button"
	Button.Size = UDim2.new(1, 0, 1, 0)
	Button.BackgroundTransparency = 1
	Button.Font = Enum.Font.GothamBold
	Button.Text = name
	Button.TextColor3 = Color3.fromRGB(220, 220, 220)
	Button.TextSize = 14
	Button.Parent = ButtonFrame

	-- Эффект при наведении
	Button.MouseEnter:Connect(function()
		FrameGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 55, 55)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(45, 45, 45))
		})
	end)
	Button.MouseLeave:Connect(function()
		FrameGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
		})
	end)

	Button.MouseButton1Click:Connect(function()
		if callback then
			callback()
		end
	end)

	ButtonFrame.Parent = ButtonContainer
	return ButtonFrame
end

-- // ==================== ФУНКЦИЯ СОЗДАНИЯ СЛАЙДЕРА ====================
local function CreateSlider(name, description, minValue, maxValue, defaultValue, callback)
	local SliderFrame = Instance.new("Frame")
	SliderFrame.Name = name .. "_SliderFrame"
	SliderFrame.Size = UDim2.new(1, -20, 0, 75)
	SliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	SliderFrame.BorderSizePixel = 0
	SliderFrame.LayoutOrder = #ButtonContainer:GetChildren()

	-- Градиент фона
	local FrameGradient = Instance.new("UIGradient")
	FrameGradient.Name = "FrameGradient"
	FrameGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
	})
	FrameGradient.Rotation = 45
	FrameGradient.Parent = SliderFrame

	-- Заголовок и текущее значение
	local InfoFrame = Instance.new("Frame")
	InfoFrame.Size = UDim2.new(1, -24, 0, 20)
	InfoFrame.Position = UDim2.new(0, 12, 0, 8)
	InfoFrame.BackgroundTransparency = 1
	InfoFrame.Parent = SliderFrame

	local FuncName = Instance.new("TextLabel")
	FuncName.Name = "FuncName"
	FuncName.Size = UDim2.new(0, 140, 1, 0)
	FuncName.BackgroundTransparency = 1
	FuncName.Font = Enum.Font.GothamBold
	FuncName.Text = name
	FuncName.TextColor3 = Color3.fromRGB(220, 220, 220)
	FuncName.TextSize = 14
	FuncName.TextXAlignment = Enum.TextXAlignment.Left
	FuncName.Parent = InfoFrame

	local ValueLabel = Instance.new("TextLabel")
	ValueLabel.Name = "ValueLabel"
	ValueLabel.Size = UDim2.new(0, 80, 1, 0)
	ValueLabel.Position = UDim2.new(1, -80, 0, 0)
	ValueLabel.BackgroundTransparency = 1
	ValueLabel.Font = Enum.Font.GothamBold
	ValueLabel.Text = tostring(defaultValue)
	ValueLabel.TextColor3 = Color3.fromRGB(0, 170, 100)
	ValueLabel.TextSize = 14
	ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
	ValueLabel.Parent = InfoFrame

	-- Описание
	local Desc = Instance.new("TextLabel")
	Desc.Name = "Description"
	Desc.Size = UDim2.new(1, -24, 0, 14)
	Desc.Position = UDim2.new(0, 12, 0, 30)
	Desc.BackgroundTransparency = 1
	Desc.Font = Enum.Font.Gotham
	Desc.Text = description
	Desc.TextColor3 = Color3.fromRGB(140, 140, 140)
	Desc.TextSize = 10
	Desc.TextXAlignment = Enum.TextXAlignment.Left
	Desc.Parent = SliderFrame

	-- Ползунок (слайдер)
	local SliderBar = Instance.new("Frame")
	SliderBar.Name = "SliderBar"
	SliderBar.Size = UDim2.new(1, -24, 0, 6)
	SliderBar.Position = UDim2.new(0, 12, 0, 52)
	SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	SliderBar.BorderSizePixel = 0
	SliderBar.Parent = SliderFrame

	-- Градиент ползунка
	local BarGradient = Instance.new("UIGradient")
	BarGradient.Name = "BarGradient"
	BarGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 70, 70)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
	})
	BarGradient.Rotation = 90
	BarGradient.Parent = SliderBar

	local SliderFill = Instance.new("Frame")
	SliderFill.Name = "SliderFill"
	SliderFill.Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0)
	SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
	SliderFill.BorderSizePixel = 0
	SliderFill.Parent = SliderBar

	-- Градиент заполнения
	local FillGradient = Instance.new("UIGradient")
	FillGradient.Name = "FillGradient"
	FillGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 200, 120)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 140, 80))
	})
	FillGradient.Rotation = 90
	FillGradient.Parent = SliderFill

	local SliderKnob = Instance.new("Frame")
	SliderKnob.Name = "SliderKnob"
	SliderKnob.Size = UDim2.new(0, 14, 0, 14)
	SliderKnob.Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -7, 0.5, -7)
	SliderKnob.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
	SliderKnob.BorderSizePixel = 0
	SliderKnob.Parent = SliderBar

	-- Градиент кноба
	local KnobGradient = Instance.new("UIGradient")
	KnobGradient.Name = "KnobGradient"
	KnobGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
	})
	KnobGradient.Rotation = 45
	KnobGradient.Parent = SliderKnob

	-- Текущее значение
	local currentValue = defaultValue

	-- Функция обновления значения
	local function UpdateValue(input)
		local barSize = SliderBar.AbsoluteSize.X
		local relativePos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / barSize, 0, 1)

		currentValue = minValue + (maxValue - minValue) * relativePos
		currentValue = math.floor(currentValue * 100) / 100

		-- Обновление UI
		SliderFill.Size = UDim2.new(relativePos, 0, 1, 0)
		SliderKnob.Position = UDim2.new(relativePos, -7, 0.5, -7)
		ValueLabel.Text = tostring(currentValue)

		-- Вызов callback
		if callback then
			callback(currentValue)
		end
	end

	-- Перетаскивание ползунка
	local isSliding = false

	SliderKnob.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isSliding = true
		end
	end)

	SliderBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isSliding = true
			UpdateValue(input)
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			isSliding = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			UpdateValue(input)
		end
	end)

	SliderFrame.Parent = ButtonContainer
	return SliderFrame
end

-- // ==================== ФУНКЦИЯ СОЗДАНИЯ ВЫПАДАЮЩЕГО СПИСКА ====================
local function CreateDropdown(name, description, items, callback)
	local DropdownFrame = Instance.new("Frame")
	DropdownFrame.Name = name .. "_DropdownFrame"
	DropdownFrame.Size = UDim2.new(1, -20, 0, 50)
	DropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	DropdownFrame.BorderSizePixel = 0
	DropdownFrame.ClipsDescendants = false
	DropdownFrame.LayoutOrder = #ButtonContainer:GetChildren()

	-- Градиент фона
	local FrameGradient = Instance.new("UIGradient")
	FrameGradient.Name = "FrameGradient"
	FrameGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 40, 40)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 35, 35))
	})
	FrameGradient.Rotation = 45
	FrameGradient.Parent = DropdownFrame

	-- Заголовок
	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Name = "TitleLabel"
	TitleLabel.Size = UDim2.new(1, -24, 0, 22)
	TitleLabel.Position = UDim2.new(0, 12, 0, 6)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Font = Enum.Font.GothamBold
	TitleLabel.Text = name
	TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
	TitleLabel.TextSize = 14
	TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
	TitleLabel.Parent = DropdownFrame

	-- Описание
	local DescLabel = Instance.new("TextLabel")
	DescLabel.Name = "DescLabel"
	DescLabel.Size = UDim2.new(1, -24, 0, 14)
	DescLabel.Position = UDim2.new(0, 12, 0, 30)
	DescLabel.BackgroundTransparency = 1
	DescLabel.Font = Enum.Font.Gotham
	DescLabel.Text = description
	DescLabel.TextColor3 = Color3.fromRGB(140, 140, 140)
	DescLabel.TextSize = 10
	DescLabel.TextXAlignment = Enum.TextXAlignment.Left
	DescLabel.Parent = DropdownFrame

	-- Кнопка открытия списка
	local DropButton = Instance.new("TextButton")
	DropButton.Name = "DropButton"
	DropButton.Size = UDim2.new(1, -24, 0, 30)
	DropButton.Position = UDim2.new(0, 12, 0, 46)
	DropButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	DropButton.BorderSizePixel = 0
	DropButton.Font = Enum.Font.GothamBold
	DropButton.Text = "Выбрать игрока..."
	DropButton.TextColor3 = Color3.fromRGB(200, 200, 200)
	DropButton.TextSize = 13
	DropButton.Parent = DropdownFrame

	-- Градиент кнопки
	local ButtonGradient = Instance.new("UIGradient")
	ButtonGradient.Name = "ButtonGradient"
	ButtonGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 55, 55)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
	})
	ButtonGradient.Rotation = 90
	ButtonGradient.Parent = DropButton

	-- Стрелка
	local Arrow = Instance.new("TextLabel")
	Arrow.Name = "Arrow"
	Arrow.Size = UDim2.new(0, 20, 1, 0)
	Arrow.Position = UDim2.new(1, -20, 0, 0)
	Arrow.BackgroundTransparency = 1
	Arrow.Font = Enum.Font.GothamBold
	Arrow.Text = "▼"
	Arrow.TextColor3 = Color3.fromRGB(0, 170, 100)
	Arrow.TextSize = 12
	Arrow.Parent = DropButton

	-- Контейнер для списка игроков
	local ListContainer = Instance.new("Frame")
	ListContainer.Name = "ListContainer"
	ListContainer.Size = UDim2.new(1, -24, 0, 0)
	ListContainer.Position = UDim2.new(0, 12, 0, 76)
	ListContainer.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	ListContainer.BorderSizePixel = 0
	ListContainer.ClipsDescendants = true
	ListContainer.Visible = false
	ListContainer.ZIndex = 10
	ListContainer.Parent = DropdownFrame

	local ScrollingList = Instance.new("ScrollingFrame")
	ScrollingList.Name = "ScrollingList"
	ScrollingList.Size = UDim2.new(1, 0, 1, 0)
	ScrollingList.BackgroundTransparency = 1
	ScrollingList.BorderSizePixel = 0
	ScrollingList.ScrollBarThickness = 4
	ScrollingList.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 100)
	ScrollingList.CanvasSize = UDim2.new(0, 0, 0, 0)
	ScrollingList.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ScrollingList.Parent = ListContainer

	local ListLayout = Instance.new("UIListLayout")
	ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ListLayout.Parent = ScrollingList

	-- Переменные состояния
	local isOpen = false
	local selectedPlayer = nil
	local playerButtons = {}

	-- Функция обновления списка игроков
	local function UpdatePlayerList()
		-- Очищаем старые кнопки
		for _, btn in pairs(playerButtons) do
			btn:Destroy()
		end
		playerButtons = {}

		-- Добавляем всех игроков кроме себя
		local players = Players:GetPlayers()
		for _, plr in ipairs(players) do
			if plr ~= Player then
				local PlayerButton = Instance.new("TextButton")
				PlayerButton.Name = plr.Name
				PlayerButton.Size = UDim2.new(1, 0, 0, 28)
				PlayerButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
				PlayerButton.BorderSizePixel = 0
				PlayerButton.Font = Enum.Font.Gotham
				PlayerButton.Text = plr.DisplayName .. " (@" .. plr.Name .. ")"
				PlayerButton.TextColor3 = Color3.fromRGB(200, 200, 200)
				PlayerButton.TextSize = 12
				PlayerButton.Parent = ScrollingList

				PlayerButton.MouseEnter:Connect(function()
					PlayerButton.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
					PlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
				end)
				PlayerButton.MouseLeave:Connect(function()
					PlayerButton.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
					PlayerButton.TextColor3 = Color3.fromRGB(200, 200, 200)
				end)

				PlayerButton.MouseButton1Click:Connect(function()
					selectedPlayer = plr
					DropButton.Text = plr.DisplayName
					ListContainer.Visible = false
					isOpen = false
					Arrow.Text = "▼"
					DropdownFrame.Size = UDim2.new(1, -20, 0, 50)

					if callback then
						callback(plr)
					end
				end)

				table.insert(playerButtons, PlayerButton)
			end
		end

		-- Если нет других игроков
		if #players <= 1 then
			local NoPlayersLabel = Instance.new("TextLabel")
			NoPlayersLabel.Name = "NoPlayers"
			NoPlayersLabel.Size = UDim2.new(1, 0, 0, 28)
			NoPlayersLabel.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
			NoPlayersLabel.BorderSizePixel = 0
			NoPlayersLabel.Font = Enum.Font.Gotham
			NoPlayersLabel.Text = "Нет игроков"
			NoPlayersLabel.TextColor3 = Color3.fromRGB(140, 140, 140)
			NoPlayersLabel.TextSize = 12
			NoPlayersLabel.Parent = ScrollingList
			table.insert(playerButtons, NoPlayersLabel)
		end

		-- Обновляем размер контейнера
		local itemCount = math.max(#playerButtons, 1)
		local listHeight = math.min(itemCount * 28, 200)
		ListContainer.Size = UDim2.new(1, -24, 0, listHeight)
	end

	-- Обработчик открытия/закрытия списка
	DropButton.MouseButton1Click:Connect(function()
		isOpen = not isOpen
		if isOpen then
			UpdatePlayerList()
			ListContainer.Visible = true
			Arrow.Text = "▲"
			local itemCount = math.max(#playerButtons, 1)
			local listHeight = math.min(itemCount * 28, 200)
			DropdownFrame.Size = UDim2.new(1, -20, 0, 50 + listHeight + 4)
		else
			ListContainer.Visible = false
			Arrow.Text = "▼"
			DropdownFrame.Size = UDim2.new(1, -20, 0, 50)
		end
	end)

	-- Обновление списка при добавлении/удалении игроков
	Players.PlayerAdded:Connect(function()
		if isOpen then
			UpdatePlayerList()
		end
	end)

	Players.PlayerRemoving:Connect(function(plr)
		if plr == selectedPlayer then
			selectedPlayer = nil
			DropButton.Text = "Выбрать игрока..."
		end
		if isOpen then
			UpdatePlayerList()
		end
	end)

	DropdownFrame.Parent = ButtonContainer
	return DropdownFrame
end

-- // ==================== ESP СИСТЕМА ====================
local ESP_ENABLED = false
local espConnections = {}
local espHighlights = {}
local espBillboards = {}

-- Функция создания BillboardGui для игрока
local function CreateESPBillboard(player, character)
	if not character or not character:FindFirstChild("Head") then return end

	local head = character.Head

	-- Проверка, не создан ли уже Billboard для этого игрока
	if espBillboards[player] and espBillboards[player].Parent then
		return
	end

	-- Создаём Highlight (обводка) с эффектами
	local highlight = Instance.new("Highlight")
	highlight.Name = "ESP_Highlight"
	highlight.FillColor = Color3.fromRGB(255, 255, 255)
	highlight.FillTransparency = 1
	highlight.OutlineColor = Color3.fromRGB(0, 255, 100)
	highlight.OutlineTransparency = 0
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.Adornee = character
	highlight.Parent = character
	espHighlights[player] = highlight

	-- Создаём BillboardGui для отображения информации
	local billboard = Instance.new("BillboardGui")
	billboard.Name = "ESP_Billboard"
	billboard.Adornee = head
	billboard.Size = UDim2.new(0, 300, 0, 50)
	billboard.StudsOffset = Vector3.new(0, 2.5, 0)
	billboard.AlwaysOnTop = true
	billboard.MaxDistance = 5000
	billboard.Parent = head

	local infoLabel = Instance.new("TextLabel")
	infoLabel.Name = "InfoLabel"
	infoLabel.Size = UDim2.new(1, 0, 1, 0)
	infoLabel.BackgroundTransparency = 1
	infoLabel.Font = Enum.Font.GothamBold
	infoLabel.Text = ""
	infoLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
	infoLabel.TextSize = 14
	infoLabel.TextStrokeTransparency = 0.5
	infoLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	infoLabel.Parent = billboard

	espBillboards[player] = billboard

	-- Обновление информации в Billboard
	local function updateInfo()
		if not character or not character.Parent or not player.Parent then
			return
		end

		local humanoid = character:FindFirstChild("Humanoid")
		local health = humanoid and humanoid.Health or 0
		local maxHealth = humanoid and humanoid.MaxHealth or 100

		local localChar = Player.Character
		local distance = 0
		if localChar and localChar:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("HumanoidRootPart") then
			distance = (localChar.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude
		end

		infoLabel.Text = string.format("%s | %.0fstuds | %.0fHP", player.DisplayName, distance, health)
	end

	local connection = RunService.RenderStepped:Connect(function()
		if not ESP_ENABLED then return end
		updateInfo()
	end)

	table.insert(espConnections, connection)
end

-- Функция удаления ESP для конкретного игрока
local function RemoveESP(player)
	if espHighlights[player] then
		espHighlights[player]:Destroy()
		espHighlights[player] = nil
	end
	if espBillboards[player] then
		espBillboards[player]:Destroy()
		espBillboards[player] = nil
	end
end

-- Функция включения ESP
local function EnableESP()
	ESP_ENABLED = true

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= Player then
			local character = player.Character
			if character then
				CreateESPBillboard(player, character)
			end
		end
	end
end

-- Функция выключения ESP
local function DisableESP()
	ESP_ENABLED = false

	for _, connection in ipairs(espConnections) do
		connection:Disconnect()
	end
	espConnections = {}

	for player, _ in pairs(espHighlights) do
		RemoveESP(player)
	end
	for player, _ in pairs(espBillboards) do
		RemoveESP(player)
	end
end

-- Отслеживание появления новых игроков
Players.PlayerAdded:Connect(function(player)
	if not ESP_ENABLED then return end
	if player == Player then return end

	player.CharacterAdded:Connect(function(character)
		if not ESP_ENABLED then return end
		CreateESPBillboard(player, character)
	end)

	if player.Character then
		CreateESPBillboard(player, player.Character)
	end
end)

-- Отслеживание удаления игроков
Players.PlayerRemoving:Connect(function(player)
	RemoveESP(player)
end)

-- // ==================== WALKSPEED И JUMPPOWER СЛАЙДЕРЫ ====================
local defaultWalkSpeed = 16
local defaultJumpPower = 50

-- Применение WalkSpeed к персонажу
local function ApplyWalkSpeed(value)
	local character = Player.Character
	if character then
		local humanoid = character:FindFirstChild("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = value
		end
	end
end

-- Применение JumpPower к персонажу
local function ApplyJumpPower(value)
	local character = Player.Character
	if character then
		local humanoid = character:FindFirstChild("Humanoid")
		if humanoid then
			humanoid.JumpPower = value
		end
	end
end

-- // ==================== АВТОФАРМ СИСТЕМА ====================
local AUTOFARM_ENABLED = false
local autofarmCoroutine = nil
local autofarmConnection = nil

-- Путь к частям для фарма
local stageParts = {}

-- Функция для получения всех частей CaveStage1 - CaveStage10
local function GetFarmParts()
	stageParts = {}
	local stagesFolder = workspace:FindFirstChild("BoatStages")
	if not stagesFolder then
		print("BoatHelper: BoatStages не найдены в workspace")
		return false
	end

	local normalStages = stagesFolder:FindFirstChild("NormalStages")
	if not normalStages then
		print("BoatHelper: NormalStages не найдены в BoatStages")
		return false
	end

	for i = 1, 10 do
		local stageName = "CaveStage" .. i
		local stage = normalStages:FindFirstChild(stageName)
		if stage then
			local darknessPart = stage:FindFirstChild("DarknessPart")
			if darknessPart then
				table.insert(stageParts, darknessPart)
				print("BoatHelper: Найден " .. stageName .. ".DarknessPart")
			else
				print("BoatHelper: DarknessPart не найден в " .. stageName)
			end
		else
			print("BoatHelper: " .. stageName .. " не найден")
		end
	end

	return #stageParts > 0
end

-- Функция убийства персонажа
local function KillCharacter()
	local character = Player.Character
	if not character then return end

	local humanoid = character:FindFirstChild("Humanoid")
	if humanoid and humanoid.Health > 0 then
		-- Устанавливаем здоровье в 0 для убийства
		humanoid.Health = 0
		print("BoatHelper: Персонаж убит")
	end
end

-- Основная функция автофарма
local function AutoFarmCycle()
	if not AUTOFARM_ENABLED then return end

	-- Проверяем наличие частей
	if #stageParts == 0 then
		if not GetFarmParts() then
			print("BoatHelper: Не удалось найти части для фарма")
			return
		end
	end

	local character = Player.Character
	if not character then
		print("BoatHelper: Персонаж не существует, ожидание возрождения...")
		return
	end

	local humanoid = character:FindFirstChild("Humanoid")
	local rootPart = character:FindFirstChild("HumanoidRootPart")

	if not humanoid or not rootPart then
		print("BoatHelper: Humanoid или HumanoidRootPart не найдены")
		return
	end

	-- Включаем нулевую гравитацию
	workspace.Gravity = 0
	print("BoatHelper: Гравитация установлена на 0")

	-- Проходим по всем частям
	for i, part in ipairs(stageParts) do
		if not AUTOFARM_ENABLED then
			workspace.Gravity = 196.2
			print("BoatHelper: Автофарм остановлен, гравитация восстановлена")
			return
		end

		character = Player.Character
		if not character then
			workspace.Gravity = 196.2
			print("BoatHelper: Персонаж исчез во время фарма")
			return
		end

		rootPart = character:FindFirstChild("HumanoidRootPart")
		if not rootPart then
			workspace.Gravity = 196.2
			print("BoatHelper: HumanoidRootPart не найден")
			return
		end

		local targetPos = part.Position + Vector3.new(0, 3, 0)
		rootPart.CFrame = CFrame.new(targetPos)
		print(string.format("BoatHelper: Телепортация к CaveStage%d.DarknessPart", i))

		local waitTime = 0
		while waitTime < 2 and AUTOFARM_ENABLED do
			task.wait(0.1)
			waitTime = waitTime + 0.1
		end

		if not AUTOFARM_ENABLED then
			workspace.Gravity = 196.2
			print("BoatHelper: Автофарм остановлен во время ожидания")
			return
		end
	end

	if AUTOFARM_ENABLED then
		print("BoatHelper: Достигнут CaveStage10.DarknessPart, убиваем персонажа")
		KillCharacter()
		workspace.Gravity = 196.2
		print("BoatHelper: Ожидание возрождения для нового цикла...")
	end
end

-- Обработчик возрождения персонажа для автофарма
local function OnCharacterAdded(character)
	if not AUTOFARM_ENABLED then return end

	print("BoatHelper: Персонаж возрождён, запуск нового цикла фарма через 1 секунду...")
	task.wait(1)

	if AUTOFARM_ENABLED and Player.Character then
		autofarmCoroutine = coroutine.create(function()
			while AUTOFARM_ENABLED do
				AutoFarmCycle()
				if AUTOFARM_ENABLED then
					task.wait(0.5)
				end
			end
		end)
		coroutine.resume(autofarmCoroutine)
	end
end

-- Функция включения автофарма
local function EnableAutoFarm()
	if AUTOFARM_ENABLED then return end
	AUTOFARM_ENABLED = true

	if not GetFarmParts() then
		print("BoatHelper: Ошибка получения частей для фарма")
		AUTOFARM_ENABLED = false
		return
	end

	autofarmConnection = Player.CharacterAdded:Connect(OnCharacterAdded)

	if Player.Character then
		OnCharacterAdded(Player.Character)
	else
		print("BoatHelper: Ожидание появления персонажа...")
	end

	print("BoatHelper: Автофарм включён")
end

-- Функция выключения автофарма
local function DisableAutoFarm()
	AUTOFARM_ENABLED = false

	if autofarmConnection then
		autofarmConnection:Disconnect()
		autofarmConnection = nil
	end

	workspace.Gravity = 196.2
	print("BoatHelper: Автофарм выключен, гравитация восстановлена")
end

-- // ==================== FLY СИСТЕМА (РЕЖИМ ПОЛЁТА) ====================
local FLY_ENABLED = false
local flyConnection = nil
local flyBodyVelocity = nil
local flyBodyGyro = nil
local currentFlySpeed = 50

-- Управление полётом
local flyKeys = {
	W = false,
	A = false,
	S = false,
	D = false,
	Space = false,
	LeftControl = false
}

-- Отслеживание нажатий клавиш для полёта
local function SetupFlyControls()
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if not FLY_ENABLED then return end
		if gameProcessed then return end

		if input.KeyCode == Enum.KeyCode.W then
			flyKeys.W = true
		elseif input.KeyCode == Enum.KeyCode.A then
			flyKeys.A = true
		elseif input.KeyCode == Enum.KeyCode.S then
			flyKeys.S = true
		elseif input.KeyCode == Enum.KeyCode.D then
			flyKeys.D = true
		elseif input.KeyCode == Enum.KeyCode.Space then
			flyKeys.Space = true
		elseif input.KeyCode == Enum.KeyCode.LeftControl then
			flyKeys.LeftControl = true
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if not FLY_ENABLED then return end

		if input.KeyCode == Enum.KeyCode.W then
			flyKeys.W = false
		elseif input.KeyCode == Enum.KeyCode.A then
			flyKeys.A = false
		elseif input.KeyCode == Enum.KeyCode.S then
			flyKeys.S = false
		elseif input.KeyCode == Enum.KeyCode.D then
			flyKeys.D = false
		elseif input.KeyCode == Enum.KeyCode.Space then
			flyKeys.Space = false
		elseif input.KeyCode == Enum.KeyCode.LeftControl then
			flyKeys.LeftControl = false
		end
	end)
end

-- Инициализация управления полётом
SetupFlyControls()

-- Функция обновления полёта
local function UpdateFly()
	local character = Player.Character
	if not character or not FLY_ENABLED then return end

	local rootPart = character:FindFirstChild("HumanoidRootPart")
	local humanoid = character:FindFirstChild("Humanoid")

	if not rootPart or not humanoid then return end

	-- Создаём BodyVelocity если не существует
	if not flyBodyVelocity or not flyBodyVelocity.Parent then
		flyBodyVelocity = Instance.new("BodyVelocity")
		flyBodyVelocity.Name = "FlyVelocity"
		flyBodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
		flyBodyVelocity.Velocity = Vector3.zero
		flyBodyVelocity.Parent = rootPart
	end

	-- Создаём BodyGyro если не существует
	if not flyBodyGyro or not flyBodyGyro.Parent then
		flyBodyGyro = Instance.new("BodyGyro")
		flyBodyGyro.Name = "FlyGyro"
		flyBodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
		flyBodyGyro.CFrame = rootPart.CFrame
		flyBodyGyro.Parent = rootPart
	end

	-- Отключаем стандартное поведение
	humanoid.PlatformStand = true

	-- Вычисляем направление движения
	local camera = workspace.CurrentCamera
	local moveDirection = Vector3.zero

	-- Направление относительно камеры
	local cameraForward = camera.CFrame.LookVector
	local cameraRight = camera.CFrame.RightVector

	-- Убираем вертикальную составляющую для горизонтального движения
	cameraForward = Vector3.new(cameraForward.X, 0, cameraForward.Z).Unit
	cameraRight = Vector3.new(cameraRight.X, 0, cameraRight.Z).Unit

	if flyKeys.W then
		moveDirection = moveDirection + cameraForward
	end
	if flyKeys.S then
		moveDirection = moveDirection - cameraForward
	end
	if flyKeys.A then
		moveDirection = moveDirection - cameraRight
	end
	if flyKeys.D then
		moveDirection = moveDirection + cameraRight
	end

	-- Вертикальное движение
	if flyKeys.Space then
		moveDirection = moveDirection + Vector3.new(0, 1, 0)
	end
	if flyKeys.LeftControl then
		moveDirection = moveDirection + Vector3.new(0, -1, 0)
	end

	-- Нормализуем направление и применяем скорость
	if moveDirection.Magnitude > 0 then
		moveDirection = moveDirection.Unit
	end

	-- Устанавливаем скорость
	flyBodyVelocity.Velocity = moveDirection * currentFlySpeed

	-- Обновляем гироскоп для стабилизации
	flyBodyGyro.CFrame = CFrame.new(Vector3.zero, camera.CFrame.LookVector - Vector3.new(0, camera.CFrame.LookVector.Y, 0))
end

-- Функция применения скорости полёта
local function ApplyFlySpeed(speed)
	currentFlySpeed = speed
	print("BoatHelper: Скорость полёта изменена на " .. speed)
end

-- Функция запуска цикла полёта
local function EnableFlyLoop()
	if flyConnection then
		flyConnection:Disconnect()
	end

	flyConnection = RunService.RenderStepped:Connect(function()
		if FLY_ENABLED then
			UpdateFly()
		end
	end)
end

-- Функция включения полёта
local function EnableFly()
	if FLY_ENABLED then return end
	FLY_ENABLED = true

	local character = Player.Character
	if character then
		local rootPart = character:FindFirstChild("HumanoidRootPart")
		if rootPart then
			-- Создаём BodyVelocity
			if not flyBodyVelocity or not flyBodyVelocity.Parent then
				flyBodyVelocity = Instance.new("BodyVelocity")
				flyBodyVelocity.Name = "FlyVelocity"
				flyBodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
				flyBodyVelocity.Velocity = Vector3.zero
				flyBodyVelocity.Parent = rootPart
			end

			-- Создаём BodyGyro
			if not flyBodyGyro or not flyBodyGyro.Parent then
				flyBodyGyro = Instance.new("BodyGyro")
				flyBodyGyro.Name = "FlyGyro"
				flyBodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
				flyBodyGyro.CFrame = rootPart.CFrame
				flyBodyGyro.Parent = rootPart
			end

			EnableFlyLoop()
		end
	end

	print("BoatHelper: Режим полёта включён")
end

-- Функция выключения полёта
local function DisableFly()
	FLY_ENABLED = false

	if flyConnection then
		flyConnection:Disconnect()
		flyConnection = nil
	end

	if flyBodyVelocity then
		flyBodyVelocity:Destroy()
		flyBodyVelocity = nil
	end

	if flyBodyGyro then
		flyBodyGyro:Destroy()
		flyBodyGyro = nil
	end

	local character = Player.Character
	if character then
		local humanoid = character:FindFirstChild("Humanoid")
		if humanoid then
			humanoid.PlatformStand = false
		end
	end

	for key, _ in pairs(flyKeys) do
		flyKeys[key] = false
	end

	print("BoatHelper: Режим полёта выключен")
end

-- // ==================== NOCLIP СИСТЕМА (ПРОХОЖДЕНИЕ СКВОЗЬ СТЕНЫ) ====================
local NOCLIP_ENABLED = false
local noclipConnection = nil

-- Функция обновления NoClip
local function UpdateNoClip()
	if not NOCLIP_ENABLED then return end

	local character = Player.Character
	if not character then return end

	-- Проходим по всем частям персонажа и отключаем коллизию
	for _, part in ipairs(character:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
		end
	end
end

-- Функция включения NoClip
local function EnableNoClip()
	if NOCLIP_ENABLED then return end
	NOCLIP_ENABLED = true

	-- Запускаем цикл обновления
	noclipConnection = RunService.Stepped:Connect(function()
		UpdateNoClip()
	end)

	-- Применяем сразу
	UpdateNoClip()

	print("BoatHelper: NoClip включён")
end

-- Функция выключения NoClip
local function DisableNoClip()
	NOCLIP_ENABLED = false

	-- Останавливаем цикл обновления
	if noclipConnection then
		noclipConnection:Disconnect()
		noclipConnection = nil
	end

	-- Восстанавливаем коллизию
	local character = Player.Character
	if character then
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = true
			end
		end
	end

	print("BoatHelper: NoClip выключен")
end

-- // ==================== ТЕЛЕПОРТ К ИГРОКУ ====================
local function TeleportToPlayer(targetPlayer)
	if not targetPlayer then
		print("BoatHelper: Игрок не выбран")
		return
	end

	local localCharacter = Player.Character
	if not localCharacter then
		print("BoatHelper: Ваш персонаж не существует")
		return
	end

	local localRoot = localCharacter:FindFirstChild("HumanoidRootPart")
	if not localRoot then
		print("BoatHelper: HumanoidRootPart не найден")
		return
	end

	local targetCharacter = targetPlayer.Character
	if not targetCharacter then
		print("BoatHelper: Игрок " .. targetPlayer.DisplayName .. " не имеет персонажа")
		return
	end

	local targetRoot = targetCharacter:FindFirstChild("HumanoidRootPart")
	if not targetRoot then
		print("BoatHelper: HumanoidRootPart игрока " .. targetPlayer.DisplayName .. " не найден")
		return
	end

	-- Телепортация к игроку с небольшим смещением
	localRoot.CFrame = targetRoot.CFrame + Vector3.new(2, 0, 2)
	print("BoatHelper: Телепортация к игроку " .. targetPlayer.DisplayName)
end

-- // ==================== ВИЗУАЛЬНЫЕ ЭФФЕКТЫ ====================
-- Эффект частиц при включении функции
local function CreateActivationEffect()
	local character = Player.Character
	if not character then return end

	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end

	-- Создаём вспышку света
	local flash = Instance.new("PointLight")
	flash.Brightness = 5
	flash.Color = Color3.fromRGB(0, 255, 100)
	flash.Range = 20
	flash.Parent = rootPart

	-- Анимация затухания
	coroutine.wrap(function()
		for i = 1, 10 do
			flash.Brightness = 5 - (i * 0.5)
			task.wait(0.05)
		end
		flash:Destroy()
	end)()
end

-- Эффект круга на земле
local function CreateGroundCircle()
	local character = Player.Character
	if not character then return end

	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return end

	local circle = Instance.new("Part")
	circle.Shape = Enum.PartType.Cylinder
	circle.Size = Vector3.new(10, 0.1, 10)
	circle.Position = rootPart.Position - Vector3.new(0, 3, 0)
	circle.Anchored = true
	circle.CanCollide = false
	circle.Material = Enum.Material.Neon
	circle.Color = Color3.fromRGB(0, 255, 100)
	circle.Transparency = 0.5
	circle.Parent = workspace

	-- Анимация расширения и исчезновения
	coroutine.wrap(function()
		for i = 1, 20 do
			circle.Size = circle.Size + Vector3.new(0.5, 0, 0.5)
			circle.Transparency = 0.5 + (i * 0.025)
			task.wait(0.05)
		end
		circle:Destroy()
	end)()
end

-- // ==================== ТЕСТОВАЯ КНОПКА-ПЕРЕКЛЮЧАТЕЛЬ ====================
CreateToggleButton("Test Toggle", "Включить/выключить тестовую функцию", function(state)
	if state then
		print("BoatHelper: Test Toggle ON")
		CreateActivationEffect()
		CreateGroundCircle()
	else
		print("BoatHelper: Test Toggle OFF")
	end
end)

-- // ==================== ESP ПЕРЕКЛЮЧАТЕЛЬ ====================
CreateToggleButton("Player ESP", "Подсветка игроков через стены с инфо", function(state)
	if state then
		EnableESP()
		CreateActivationEffect()
		print("BoatHelper: ESP включён")
	else
		DisableESP()
		print("BoatHelper: ESP выключен")
	end
end)

-- // ==================== WALKSPEED СЛАЙДЕР ====================
CreateSlider("WalkSpeed", "Скорость бега (16 - стандарт)", 1, 200, defaultWalkSpeed, function(value)
	ApplyWalkSpeed(value)
	print("BoatHelper: WalkSpeed изменён на " .. value)
end)

-- // ==================== JUMPPOWER СЛАЙДЕР ====================
CreateSlider("JumpPower", "Сила прыжка (50 - стандарт)", 1, 300, defaultJumpPower, function(value)
	ApplyJumpPower(value)
	print("BoatHelper: JumpPower изменён на " .. value)
end)

-- // ==================== АВТОФАРМ ПЕРЕКЛЮЧАТЕЛЬ ====================
CreateToggleButton("AutoFarm", "Цикличный фарм CaveStage1-10", function(state)
	if state then
		EnableAutoFarm()
		CreateActivationEffect()
	else
		DisableAutoFarm()
	end
end)

-- // ==================== FLY ПЕРЕКЛЮЧАТЕЛЬ ====================
CreateToggleButton("Fly Mode", "Режим полёта (WASD/Space/Ctrl)", function(state)
	if state then
		EnableFly()
		CreateActivationEffect()
	else
		DisableFly()
	end
end)

-- // ==================== FLY SPEED СЛАЙДЕР ====================
CreateSlider("Fly Speed", "Скорость полёта (50 - стандарт)", 10, 500, 50, function(value)
	ApplyFlySpeed(value)
end)

-- // ==================== NOCLIP ПЕРЕКЛЮЧАТЕЛЬ ====================
CreateToggleButton("NoClip", "Прохождение сквозь стены", function(state)
	if state then
		EnableNoClip()
		CreateActivationEffect()
	else
		DisableNoClip()
	end
end)

-- // ==================== ТЕЛЕПОРТ К ИГРОКУ ====================
CreateDropdown("Teleport to Player", "Выберите игрока для телепортации", {}, function(selectedPlayer)
	CreateActivationEffect()
	CreateGroundCircle()
	TeleportToPlayer(selectedPlayer)
end)

-- // ==================== КНОПКА УНИЧТОЖЕНИЯ GUI ====================
CreateButton("Destroy GUI", function()
	-- Отключаем все системы
	DisableESP()
	DisableAutoFarm()
	DisableFly()
	DisableNoClip()

	-- Сбрасываем WalkSpeed и JumpPower до стандартных значений
	local character = Player.Character
	if character then
		local humanoid = character:FindFirstChild("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = 16
			humanoid.JumpPower = 50
		end
	end

	-- Восстанавливаем гравитацию
	workspace.Gravity = 196.2

	print("BoatHelper: GUI уничтожен, все функции остановлены.")

	-- Уничтожаем весь GUI
	if Menu then
		Menu:Destroy()
	end
end)

-- // ==================== ОБРАБОТКА ВОЗРОЖДЕНИЯ ЛОКАЛЬНОГО ИГРОКА ====================
Player.CharacterAdded:Connect(function(character)
	-- Если ESP был включён, пересоздаём ESP для других игроков
	if ESP_ENABLED then
		task.wait(0.5)
		DisableESP()
		EnableESP()
	end

	-- Если Fly был включён, перезапускаем полёт
	if FLY_ENABLED then
		task.wait(0.3)
		-- Очищаем старые компоненты
		if flyBodyVelocity then
			flyBodyVelocity:Destroy()
			flyBodyVelocity = nil
		end
		if flyBodyGyro then
			flyBodyGyro:Destroy()
			flyBodyGyro = nil
		end
		-- Перезапускаем полёт
		local rootPart = character:FindFirstChild("HumanoidRootPart")
		if rootPart then
			flyBodyVelocity = Instance.new("BodyVelocity")
			flyBodyVelocity.Name = "FlyVelocity"
			flyBodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
			flyBodyVelocity.Velocity = Vector3.zero
			flyBodyVelocity.Parent = rootPart

			flyBodyGyro = Instance.new("BodyGyro")
			flyBodyGyro.Name = "FlyGyro"
			flyBodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
			flyBodyGyro.CFrame = rootPart.CFrame
			flyBodyGyro.Parent = rootPart

			EnableFlyLoop()
		end
		print("BoatHelper: Режим полёта перезапущен для нового персонажа")
	end

	-- Если NoClip был включён, применяем к новому персонажу
	if NOCLIP_ENABLED then
		task.wait(0.2)
		UpdateNoClip()
		print("BoatHelper: NoClip применён к новому персонажу")
	end

	-- Применяем WalkSpeed и JumpPower к новому персонажу
	task.wait(0.1)
	local humanoid = character:WaitForChild("Humanoid")

	local walkSpeedSlider = ButtonContainer:FindFirstChild("WalkSpeed_SliderFrame")
	local jumpPowerSlider = ButtonContainer:FindFirstChild("JumpPower_SliderFrame")

	if walkSpeedSlider then
		local valueLabel = walkSpeedSlider:FindFirstChild("ValueLabel", true)
		if valueLabel then
			local currentValue = tonumber(valueLabel.Text) or defaultWalkSpeed
			humanoid.WalkSpeed = currentValue
		end
	end

	if jumpPowerSlider then
		local valueLabel = jumpPowerSlider:FindFirstChild("ValueLabel", true)
		if valueLabel then
			local currentValue = tonumber(valueLabel.Text) or defaultJumpPower
			humanoid.JumpPower = currentValue
		end
	end
end)

-- // ==================== ИНИЦИАЛИЗАЦИЯ ====================
print("BoatHelper успешно загружен.")
print("Нажмите Insert для показа/скрытия меню.")
print("Доступные функции: Test Toggle, Player ESP, WalkSpeed, JumpPower, AutoFarm, Fly Mode, Fly Speed, NoClip, Teleport to Player, Destroy GUI")
