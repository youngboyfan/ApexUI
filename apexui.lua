local ApexUI = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Utility = {}

function Utility:Create(instance, props)
    local obj = Instance.new(instance)
    for i, v in pairs(props or {}) do obj[i] = v end
    return obj
end

function Utility:Tween(obj, props, dur, ...)
    return TweenService:Create(obj, TweenInfo.new(dur or 0.2, ...), props)
end

function Utility:Round(obj, r)
    local c = self:Create("UICorner", {CornerRadius = UDim.new(0, r or 4)})
    c.Parent = obj
end

function Utility:Drag(frame, parent)
    parent = parent or frame
    local dragging, dragInput, mousePos, framePos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = parent.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            parent.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

-- Themes
local Themes = {
    Dark = { SchemeColor = Color3.fromRGB(64, 64, 64), Background = Color3.fromRGB(0, 0, 0), Header = Color3.fromRGB(0, 0, 0), TextColor = Color3.fromRGB(255,255,255), ElementColor = Color3.fromRGB(20, 20, 20) },
    Ocean = { SchemeColor = Color3.fromRGB(86, 76, 251), Background = Color3.fromRGB(26, 32, 58), Header = Color3.fromRGB(38, 45, 71), TextColor = Color3.fromRGB(200, 200, 200), ElementColor = Color3.fromRGB(38, 45, 71) },
    Blood = { SchemeColor = Color3.fromRGB(227, 27, 27), Background = Color3.fromRGB(10, 10, 10), Header = Color3.fromRGB(5, 5, 5), TextColor = Color3.fromRGB(255,255,255), ElementColor = Color3.fromRGB(20, 20, 20) },
    Grape = { SchemeColor = Color3.fromRGB(166, 71, 214), Background = Color3.fromRGB(64, 50, 71), Header = Color3.fromRGB(36, 28, 41), TextColor = Color3.fromRGB(255,255,255), ElementColor = Color3.fromRGB(74, 58, 84) },
    Midnight = { SchemeColor = Color3.fromRGB(26, 189, 158), Background = Color3.fromRGB(44, 62, 82), Header = Color3.fromRGB(57, 81, 105), TextColor = Color3.fromRGB(255, 255, 255), ElementColor = Color3.fromRGB(52, 74, 95) },
    Synapse = { SchemeColor = Color3.fromRGB(46, 48, 43), Background = Color3.fromRGB(13, 15, 12), Header = Color3.fromRGB(36, 38, 35), TextColor = Color3.fromRGB(152, 99, 53), ElementColor = Color3.fromRGB(24, 24, 24) },
}

ApexUI.CurrentTheme = Themes.Dark
ApexUI.ThemeList = Themes
ApexUI.Open = true

local LibName = "ApexUI_" .. tostring(math.random(10000, 99999))
local ScreenGui
local Main
local Pages = {}
local currentTab

-- Notifications
local NotificationHolder

function ApexUI:Notify(title, text, duration)
    title = title or "Notification"
    text = text or ""
    duration = duration or 5

    if not NotificationHolder then
        local gui = Utility:Create("ScreenGui", {Name = "ApexUI_Notifs", DisplayOrder = 100, IgnoreGuiInset = true, ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
        gui.Parent = (syn and syn.protect_gui and (function() syn.protect_gui(gui) return CoreGui end)() or gethui and gethui() or CoreGui)
        NotificationHolder = Utility:Create("Frame", {Size = UDim2.fromOffset(320, 0), Position = UDim2.new(1, -20, 1, -20), AnchorPoint = Vector2.new(1, 1), BackgroundTransparency = 1, AutomaticSize = Enum.AutomaticSize.Y, Parent = gui})
        local layout = Utility:Create("UIListLayout", {Padding = UDim.new(0, 6), HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Bottom, SortOrder = Enum.SortOrder.LayoutOrder, Parent = NotificationHolder})
    end

    local theme = ApexUI.CurrentTheme
    local notif = Utility:Create("Frame", {Size = UDim2.new(1, 0, 0, 0), BackgroundColor3 = theme.ElementColor, Parent = NotificationHolder, AutomaticSize = Enum.AutomaticSize.Y, ClipsDescendants = true})
    Utility:Round(notif, 6)

    local titleL = Utility:Create("TextLabel", {Size = UDim2.new(1, -20, 0, 18), Position = UDim2.fromOffset(10, 8), BackgroundTransparency = 1, Text = title, TextColor3 = theme.TextColor, TextSize = 14, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, Parent = notif})
    local textL = Utility:Create("TextLabel", {Size = UDim2.new(1, -20, 0, 0), Position = UDim2.fromOffset(10, 28), BackgroundTransparency = 1, Text = text, TextColor3 = Color3.fromRGB(200,200,200), TextSize = 13, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, Parent = notif, AutomaticSize = Enum.AutomaticSize.Y})

    notif.Position = UDim2.fromOffset(60, 0)
    local t1 = Utility:Tween(notif, {Position = UDim2.fromOffset(0, 0)}, 0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

    if duration > 0 then
        task.delay(duration, function()
            if notif and notif.Parent then
                local t2 = Utility:Tween(notif, {Position = UDim2.fromOffset(60, 0), BackgroundTransparency = 1}, 0.4):Play()
                t2.Completed:Wait()
                pcall(function() notif:Destroy() end)
            end
        end)
    end
end

-- Main window creation
function ApexUI:CreateLib(title, theme)
    if not theme then theme = Themes.Dark end
    if type(theme) == "string" then
        theme = Themes[theme] or Themes.Dark
    end
    ApexUI.CurrentTheme = theme
    currentTab = nil

    -- Cleanup old
    pcall(function()
        for _, v in pairs(CoreGui:GetChildren()) do
            if v.Name == LibName then v:Destroy() end
        end
    end)

    ScreenGui = Utility:Create("ScreenGui", {Name = LibName, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, ResetOnSpawn = false})
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end
    end)
    ScreenGui.Parent = (gethui and gethui() or CoreGui)

    local function UpdateColors()
        Main.BackgroundColor3 = theme.Background
        MainHeader.BackgroundColor3 = theme.Header
        MainSide.BackgroundColor3 = theme.Header
        titleLabel.TextColor3 = theme.TextColor
    end

    -- Main window
    Main = Utility:Create("Frame", {
        Name = "Main",
        Size = UDim2.fromOffset(620, 380),
        Position = UDim2.new(0.5, -310, 0.5, -190),
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = ScreenGui,
    })
    Utility:Round(Main, 6)

    -- Header
    local MainHeader = Utility:Create("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundColor3 = theme.Header,
        BorderSizePixel = 0,
        Parent = Main,
    })
    Utility:Round(MainHeader, 6)

    local coverup = Utility:Create("Frame", {
        Size = UDim2.new(1, 0, 0, 8),
        Position = UDim2.new(0, 0, 1, -8),
        BackgroundColor3 = theme.Header,
        BorderSizePixel = 0,
        Parent = MainHeader,
    })

    Utility:Drag(MainHeader, Main)

    -- Title
    local titleLabel = Utility:Create("TextLabel", {
        Size = UDim2.fromOffset(300, 20),
        Position = UDim2.fromOffset(12, 5),
        BackgroundTransparency = 1,
        Text = title or "ApexUI",
        TextColor3 = theme.TextColor,
        TextSize = 16,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = MainHeader,
    })

    -- Close button
    local closeBtn = Utility:Create("TextButton", {
        Size = UDim2.fromOffset(20, 20),
        Position = UDim2.new(1, -26, 0, 5),
        BackgroundTransparency = 1,
        Text = "X",
        TextColor3 = theme.TextColor,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        Parent = MainHeader,
    })
    closeBtn.MouseButton1Click:Connect(function()
        local t = Utility:Tween(Main, {Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1}, 0.2):Play()
        t.Completed:Wait()
        ScreenGui:Destroy()
    end)

    -- Sidebar
    local MainSide = Utility:Create("Frame", {
        Size = UDim2.fromOffset(145, 0),
        Position = UDim2.fromOffset(0, 30),
        BackgroundColor3 = theme.Header,
        BorderSizePixel = 0,
        Parent = Main,
    })
    Utility:Round(MainSide, 6)

    local sideCover = Utility:Create("Frame", {
        Size = UDim2.fromOffset(8, 1),
        Position = UDim2.new(1, -8, 0, 0),
        BackgroundColor3 = theme.Header,
        BorderSizePixel = 0,
        Parent = MainSide,
    })

    -- Tab buttons container
    local tabFrame = Utility:Create("Frame", {
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.fromOffset(5, 5),
        BackgroundTransparency = 1,
        Parent = MainSide,
    })
    local tabLayout = Utility:Create("UIListLayout", {
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tabFrame,
    })

    -- Content area
    local pageFrame = Utility:Create("Frame", {
        Size = UDim2.new(1, -145, 1, -30),
        Position = UDim2.fromOffset(145, 30),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = Main,
    })
    local PagesFolder = Utility:Create("Folder", {Parent = pageFrame})

    local first = true

    local Window = {}
    function Window:NewTab(name)
        -- Tab button
        local tabBtn = Utility:Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 28),
            BackgroundColor3 = theme.SchemeColor,
            Text = "",
            AutoButtonColor = false,
            Font = Enum.Font.Gotham,
            TextColor3 = theme.TextColor,
            TextSize = 14,
            Parent = tabFrame,
        })
        Utility:Round(tabBtn, 5)

        local tabLabel = Utility:Create("TextLabel", {
            Size = UDim2.new(1, -10, 1, 0),
            Position = UDim2.fromOffset(10, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = theme.TextColor,
            TextSize = 14,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabBtn,
        })

        -- Page
        local page = Utility:Create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 6,
            ScrollBarImageColor3 = Color3.fromRGB(
                math.max(theme.SchemeColor.R * 255 - 30, 0),
                math.max(theme.SchemeColor.G * 255 - 30, 0),
                math.max(theme.SchemeColor.B * 255 - 30, 0)
            ),
            CanvasSize = UDim2.fromOffset(0, 0),
            Parent = PagesFolder,
            Visible = false,
        })
        local pageLayout = Utility:Create("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = page})
        local pagePad = Utility:Create("UIPadding", {PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = page})

        local function UpdateSize()
            page.CanvasSize = UDim2.fromOffset(0, pageLayout.AbsoluteContentSize.Y + 20)
        end
        pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSize)

        if first then
            first = false
            page.Visible = true
            tabBtn.BackgroundTransparency = 0
        else
            tabBtn.BackgroundTransparency = 0.85
        end

        tabBtn.MouseButton1Click:Connect(function()
            for _, v in pairs(PagesFolder:GetChildren()) do v.Visible = false end
            page.Visible = true
            for _, v in pairs(tabFrame:GetChildren()) do
                if v:IsA("TextButton") then
                    v.BackgroundTransparency = 0.85
                end
            end
            tabBtn.BackgroundTransparency = 0
            UpdateSize()
        end)

        table.insert(Pages, page)

        local Tab = {}
        function Tab:NewSection(secName)
            local sectionFrame = Utility:Create("Frame", {
                BackgroundColor3 = theme.Background,
                BorderSizePixel = 0,
                Parent = page,
                Size = UDim2.new(1, 0, 0, 32),
            })
            Utility:Round(sectionFrame, 5)

            -- Section header
            local sectionHead = Utility:Create("Frame", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = theme.SchemeColor,
                BorderSizePixel = 0,
                Parent = sectionFrame,
            })
            Utility:Round(sectionHead, 5)

            local headCover = Utility:Create("Frame", {
                Size = UDim2.new(1, 0, 0, 6),
                Position = UDim2.new(0, 0, 1, -6),
                BackgroundColor3 = theme.SchemeColor,
                BorderSizePixel = 0,
                Parent = sectionHead,
            })

            local secTitle = Utility:Create("TextLabel", {
                Size = UDim2.new(1, -16, 1, 0),
                Position = UDim2.fromOffset(10, 0),
                BackgroundTransparency = 1,
                Text = secName,
                TextColor3 = theme.TextColor,
                TextSize = 14,
                Font = Enum.Font.GothamSemibold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = sectionHead,
            })

            -- Inner container for elements
            local sectionInner = Utility:Create("Frame", {
                Size = UDim2.new(1, -12, 0, 0),
                Position = UDim2.fromOffset(6, 36),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Parent = sectionFrame,
                AutomaticSize = Enum.AutomaticSize.Y,
            })
            local innerLayout = Utility:Create("UIListLayout", {Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder, Parent = sectionInner})

            innerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                local h = innerLayout.AbsoluteContentSize.Y + 44
                if h > 44 then
                    sectionFrame.Size = UDim2.new(1, 0, 0, h)
                end
                UpdateSize()
            end)

            local Section = {}

            function Section:NewButton(text, info, cb)
                info = info or ""
                cb = cb or function() end

                local btnFrame = Utility:Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = theme.ElementColor,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = sectionInner,
                    ClipsDescendants = true,
                })
                Utility:Round(btnFrame, 5)

                local txt = Utility:Create("TextLabel", {
                    Size = UDim2.new(1, -20, 1, 0),
                    Position = UDim2.fromOffset(10, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = theme.TextColor,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = btnFrame,
                })

                -- Info icon
                if info ~= "" then
                    local infoLbl = Utility:Create("TextLabel", {
                        Size = UDim2.fromOffset(20, 20),
                        Position = UDim2.new(1, -24, 0, 6),
                        BackgroundTransparency = 1,
                        Text = "?",
                        TextColor3 = theme.SchemeColor,
                        TextSize = 14,
                        Font = Enum.Font.GothamBold,
                        Parent = btnFrame,
                    })
                end

                btnFrame.MouseEnter:Connect(function()
                    local r, g, b = theme.ElementColor.R * 255 + 8, theme.ElementColor.G * 255 + 8, theme.ElementColor.B * 255 + 8
                    Utility:Tween(btnFrame, {BackgroundColor3 = Color3.fromRGB(r, g, b)}, 0.1):Play()
                end)
                btnFrame.MouseLeave:Connect(function()
                    Utility:Tween(btnFrame, {BackgroundColor3 = theme.ElementColor}, 0.1):Play()
                end)
                btnFrame.MouseButton1Click:Connect(function()
                    local s, e = pcall(cb)
                    if not s then warn("ApexUI Error:", e) end
                end)

                local obj = {}
                function obj:UpdateButton(newText)
                    txt.Text = newText
                end
                return obj
            end

            function Section:NewToggle(text, info, cb)
                info = info or ""
                cb = cb or function() end
                local toggled = false

                local togFrame = Utility:Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = theme.ElementColor,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = sectionInner,
                    ClipsDescendants = true,
                })
                Utility:Round(togFrame, 5)

                local txt = Utility:Create("TextLabel", {
                    Size = UDim2.new(1, -56, 1, 0),
                    Position = UDim2.fromOffset(10, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = theme.TextColor,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = togFrame,
                })

                local check = Utility:Create("TextLabel", {
                    Size = UDim2.fromOffset(20, 20),
                    Position = UDim2.new(1, -46, 0, 6),
                    BackgroundTransparency = 1,
                    Text = "□",
                    TextColor3 = theme.TextColor,
                    TextSize = 18,
                    Font = Enum.Font.Gotham,
                    Parent = togFrame,
                })

                if info ~= "" then
                    local infoLbl = Utility:Create("TextLabel", {
                        Size = UDim2.fromOffset(20, 20),
                        Position = UDim2.new(1, -24, 0, 6),
                        BackgroundTransparency = 1,
                        Text = "?",
                        TextColor3 = theme.SchemeColor,
                        TextSize = 14,
                        Font = Enum.Font.GothamBold,
                        Parent = togFrame,
                    })
                end

                togFrame.MouseEnter:Connect(function()
                    local r, g, b = theme.ElementColor.R * 255 + 8, theme.ElementColor.G * 255 + 8, theme.ElementColor.B * 255 + 8
                    Utility:Tween(togFrame, {BackgroundColor3 = Color3.fromRGB(r, g, b)}, 0.1):Play()
                end)
                togFrame.MouseLeave:Connect(function()
                    Utility:Tween(togFrame, {BackgroundColor3 = theme.ElementColor}, 0.1):Play()
                end)

                togFrame.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    check.Text = toggled and "☑" or "□"
                    check.TextColor3 = toggled and theme.SchemeColor or theme.TextColor
                    local s, e = pcall(cb, toggled)
                    if not s then warn("ApexUI Error:", e) end
                end)

                local obj = {}
                function obj:UpdateToggle(newText)
                    txt.Text = newText
                end
                return obj
            end

            function Section:NewSlider(text, info, max, min, cb)
                info = info or ""
                max = max or 100
                min = min or 0
                cb = cb or function() end
                local value = min

                local sliderFrame = Utility:Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 40),
                    BackgroundColor3 = theme.ElementColor,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = sectionInner,
                    ClipsDescendants = true,
                })
                Utility:Round(sliderFrame, 5)

                local txt = Utility:Create("TextLabel", {
                    Size = UDim2.new(1, -56, 0, 18),
                    Position = UDim2.fromOffset(10, 2),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = theme.TextColor,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = sliderFrame,
                })

                local valLabel = Utility:Create("TextLabel", {
                    Size = UDim2.fromOffset(50, 18),
                    Position = UDim2.new(1, -56, 0, 2),
                    BackgroundTransparency = 1,
                    Text = tostring(value),
                    TextColor3 = theme.SchemeColor,
                    TextSize = 14,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = sliderFrame,
                })

                local barBg = Utility:Create("Frame", {
                    Size = UDim2.new(1, -20, 0, 6),
                    Position = UDim2.fromOffset(10, 26),
                    BackgroundColor3 = Color3.fromRGB(
                        theme.ElementColor.R * 255 + 10,
                        theme.ElementColor.G * 255 + 10,
                        theme.ElementColor.B * 255 + 10
                    ),
                    BorderSizePixel = 0,
                    Parent = sliderFrame,
                    ClipsDescendants = true,
                })
                Utility:Round(barBg, 3)

                local barFill = Utility:Create("Frame", {
                    Size = UDim2.fromOffset(0, 6),
                    BackgroundColor3 = theme.SchemeColor,
                    BorderSizePixel = 0,
                    Parent = barBg,
                })
                Utility:Round(barFill, 3)

                local dragging = false

                barBg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local percent = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
                        value = math.floor(min + (max - min) * percent)
                        valLabel.Text = tostring(value)
                        barFill.Size = UDim2.fromOffset(barBg.AbsoluteSize.X * percent, 6)
                        local s, e = pcall(cb, value)
                        if not s then warn("ApexUI Error:", e) end
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = false
                    end
                end)

                -- Init
                task.wait()
                if barBg.AbsoluteSize.X > 0 then
                    local pct = (value - min) / (max - min)
                    barFill.Size = UDim2.fromOffset(barBg.AbsoluteSize.X * pct, 6)
                end

                local obj = {}
                function obj:UpdateSlider(newText)
                    txt.Text = newText
                end
                return obj
            end

            function Section:NewDropdown(text, info, options, cb)
                info = info or ""
                options = options or {}
                cb = cb or function() end
                local selected = options[1] or "None"
                local open = false

                local ddFrame = Utility:Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = theme.ElementColor,
                    Parent = sectionInner,
                    ClipsDescendants = true,
                })
                Utility:Round(ddFrame, 5)

                local topBtn = Utility:Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = theme.ElementColor,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = ddFrame,
                })
                Utility:Round(topBtn, 5)

                local txt = Utility:Create("TextLabel", {
                    Size = UDim2.new(1, -80, 1, 0),
                    Position = UDim2.fromOffset(10, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = theme.TextColor,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = topBtn,
                })

                local selLabel = Utility:Create("TextLabel", {
                    Size = UDim2.fromOffset(60, 20),
                    Position = UDim2.new(1, -70, 0, 6),
                    BackgroundTransparency = 1,
                    Text = selected,
                    TextColor3 = theme.SchemeColor,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = topBtn,
                })

                local arrow = Utility:Create("TextLabel", {
                    Size = UDim2.fromOffset(16, 20),
                    Position = UDim2.new(1, -20, 0, 6),
                    BackgroundTransparency = 1,
                    Text = "▼",
                    TextColor3 = theme.TextColor,
                    TextSize = 10,
                    Font = Enum.Font.Gotham,
                    Parent = topBtn,
                })

                local listFrame = Utility:Create("Frame", {
                    Size = UDim2.new(1, -12, 0, 0),
                    Position = UDim2.fromOffset(6, 34),
                    BackgroundTransparency = 1,
                    Parent = ddFrame,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Visible = false,
                })
                local listLayout = Utility:Create("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder, Parent = listFrame})

                local function populate()
                    for _, c in pairs(listFrame:GetChildren()) do
                        if c:IsA("TextButton") then c:Destroy() end
                    end
                    for _, opt in ipairs(options) do
                        local optStr = tostring(opt)
                        local optBtn = Utility:Create("TextButton", {
                            Size = UDim2.new(1, 0, 0, 28),
                            BackgroundColor3 = theme.Background,
                            Text = "",
                            AutoButtonColor = false,
                            Parent = listFrame,
                        })
                        Utility:Round(optBtn, 5)

                        local optLabel = Utility:Create("TextLabel", {
                            Size = UDim2.new(1, -16, 1, 0),
                            Position = UDim2.fromOffset(10, 0),
                            BackgroundTransparency = 1,
                            Text = optStr,
                            TextColor3 = theme.TextColor,
                            TextSize = 13,
                            Font = Enum.Font.Gotham,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            Parent = optBtn,
                        })

                        optBtn.MouseButton1Click:Connect(function()
                            selected = optStr
                            selLabel.Text = selected
                            selLabel.TextColor3 = theme.SchemeColor
                            open = false
                            listFrame.Visible = false
                            arrow.Text = "▼"
                            local s, e = pcall(cb, opt)
                            if not s then warn("ApexUI Error:", e) end
                        end)
                        optBtn.MouseEnter:Connect(function()
                            local r, g, b = theme.ElementColor.R * 255, theme.ElementColor.G * 255, theme.ElementColor.B * 255
                            Utility:Tween(optBtn, {BackgroundColor3 = Color3.fromRGB(r, g, b)}, 0.1):Play()
                        end)
                        optBtn.MouseLeave:Connect(function()
                            Utility:Tween(optBtn, {BackgroundColor3 = theme.Background}, 0.1):Play()
                        end)
                    end
                end

                topBtn.MouseButton1Click:Connect(function()
                    open = not open
                    listFrame.Visible = open
                    arrow.Text = open and "▲" or "▼"
                    if open then populate() end
                end)

                UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 and open then
                        local mPos = UserInputService:GetMouseLocation()
                        local aPos = listFrame.AbsolutePosition
                        local aSize = listFrame.AbsoluteSize
                        if mPos.X < aPos.X or mPos.X > aPos.X + aSize.X or mPos.Y < aPos.Y or mPos.Y > aPos.Y + aSize.Y then
                            open = false
                            listFrame.Visible = false
                            arrow.Text = "▼"
                        end
                    end
                end)

                topBtn.MouseEnter:Connect(function()
                    local r, g, b = theme.ElementColor.R * 255 + 8, theme.ElementColor.G * 255 + 8, theme.ElementColor.B * 255 + 8
                    Utility:Tween(topBtn, {BackgroundColor3 = Color3.fromRGB(r, g, b)}, 0.1):Play()
                end)
                topBtn.MouseLeave:Connect(function()
                    Utility:Tween(topBtn, {BackgroundColor3 = theme.ElementColor}, 0.1):Play()
                end)

                local obj = {}
                function obj:Refresh(newOpts)
                    options = newOpts
                    if open then populate() end
                end
                return obj
            end

            function Section:NewTextBox(text, info, cb)
                info = info or ""
                cb = cb or function() end

                local tbFrame = Utility:Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = theme.ElementColor,
                    Parent = sectionInner,
                })
                Utility:Round(tbFrame, 5)

                local txt = Utility:Create("TextLabel", {
                    Size = UDim2.new(1, -140, 1, 0),
                    Position = UDim2.fromOffset(10, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = theme.TextColor,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = tbFrame,
                })

                local inputFrame = Utility:Create("Frame", {
                    Size = UDim2.fromOffset(120, 22),
                    Position = UDim2.new(1, -128, 0, 5),
                    BackgroundColor3 = Color3.fromRGB(
                        theme.ElementColor.R * 255 - 6,
                        theme.ElementColor.G * 255 - 6,
                        theme.ElementColor.B * 255 - 6
                    ),
                    BorderSizePixel = 0,
                    Parent = tbFrame,
                })
                Utility:Round(inputFrame, 5)

                local input = Utility:Create("TextBox", {
                    Size = UDim2.new(1, -8, 1, 0),
                    Position = UDim2.fromOffset(4, 0),
                    BackgroundTransparency = 1,
                    PlaceholderText = "Input",
                    PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
                    Text = "",
                    TextColor3 = theme.TextColor,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    ClearTextOnFocus = false,
                    Parent = inputFrame,
                })

                input.FocusLost:Connect(function(enter)
                    if enter then
                        local s, e = pcall(cb, input.Text)
                        if not s then warn("ApexUI Error:", e) end
                    end
                end)
            end

            function Section:NewKeybind(text, info, key, cb)
                info = info or ""
                key = key or Enum.KeyCode.Unknown
                cb = cb or function() end

                local function keyName(k)
                    local n = tostring(k):gsub("Enum.KeyCode.", "")
                    if n == "Unknown" then return "None" end
                    return n
                end

                local kbFrame = Utility:Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = theme.ElementColor,
                    Parent = sectionInner,
                })
                Utility:Round(kbFrame, 5)

                local txt = Utility:Create("TextLabel", {
                    Size = UDim2.new(1, -80, 1, 0),
                    Position = UDim2.fromOffset(10, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = theme.TextColor,
                    TextSize = 14,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = kbFrame,
                })

                local btnFrame = Utility:Create("Frame", {
                    Size = UDim2.fromOffset(70, 22),
                    Position = UDim2.new(1, -78, 0, 5),
                    BackgroundColor3 = Color3.fromRGB(
                        theme.ElementColor.R * 255 + 5,
                        theme.ElementColor.G * 255 + 5,
                        theme.ElementColor.B * 255 + 5
                    ),
                    BorderSizePixel = 0,
                    Parent = kbFrame,
                })
                Utility:Round(btnFrame, 5)

                local keyLabel = Utility:Create("TextLabel", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = keyName(key),
                    TextColor3 = theme.TextColor,
                    TextSize = 12,
                    Font = Enum.Font.GothamBold,
                    Parent = btnFrame,
                })

                local currentKey = key
                local binding = false
                local clickBtn = Utility:Create("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = btnFrame,
                })

                clickBtn.MouseButton1Click:Connect(function()
                    binding = true
                    keyLabel.Text = "..."
                end)

                UserInputService.InputBegan:Connect(function(input, gpe)
                    if gpe then return end
                    if binding then
                        binding = false
                        local newKey = input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode or
                                       input.UserInputType ~= Enum.UserInputType.Keyboard and input.UserInputType
                        if newKey and newKey ~= Enum.KeyCode.Unknown then
                            currentKey = newKey
                            keyLabel.Text = keyName(newKey)
                        else
                            keyLabel.Text = keyName(currentKey)
                        end
                        return
                    end
                    if currentKey ~= Enum.KeyCode.Unknown and (input.KeyCode == currentKey or input.UserInputType == currentKey) then
                        local s, e = pcall(cb)
                        if not s then warn("ApexUI Error:", e) end
                    end
                end)
            end

            function Section:NewLabel(text)
                local lblFrame = Utility:Create("Frame", {
                    Size = UDim2.new(1, 0, 0, 24),
                    BackgroundTransparency = 1,
                    Parent = sectionInner,
                })

                local lbl = Utility:Create("TextLabel", {
                    Size = UDim2.new(1, -16, 1, 0),
                    Position = UDim2.fromOffset(10, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = Color3.fromRGB(200, 200, 200),
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = lblFrame,
                })

                local obj = {}
                function obj:UpdateLabel(newText)
                    lbl.Text = newText
                end
                return obj
            end

            return Section
        end

        return Tab
    end

    function Window:ToggleUI()
        ApexUI.Open = not ApexUI.Open
        Main.Visible = ApexUI.Open
    end

    return Window
end

return ApexUI
