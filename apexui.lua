--[[
    ApexUI.lua
    The Ultimate Roblox UI Library

    Inspired by: Kavo, Orion, Venyx, LinoriaLib, Mercury-lib & others
    Built with patterns from the community

    Structure: Library → Window → Tab → Section → Elements
    Layout: Left sidebar (tabs) | Right content area (sections)
]]

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local function GetParent()
    if syn and syn.protect_gui then
        local g = Instance.new("ScreenGui")
        syn.protect_gui(g)
        return g
    end
    return gethui and gethui() or CoreGui
end

-- ─────────────────────────────────────────────────────────────────────────────
-- UTILITY
-- ─────────────────────────────────────────────────────────────────────────────

local Util = {}

function Util:New(Class, Props)
    local obj = Instance.new(Class)
    for k, v in pairs(Props or {}) do
        obj[k] = v
    end
    return obj
end

function Util:Round(obj, radius)
    local c = self:New("UICorner", {CornerRadius = UDim.new(0, radius or 6)})
    c.Parent = obj
    return c
end

function Util:Stroke(obj, color, thick)
    local s = self:New("UIStroke", {
        Color = color or Color3.fromRGB(60, 60, 60),
        Thickness = thick or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    })
    s.Parent = obj
    return s
end

function Util:Tween(obj, props, duration, ...)
    local ti = TweenInfo.new(duration or 0.2, ...)
    local t = TweenService:Create(obj, ti, props)
    t:Play()
    return t
end

function Util:MakeDraggable(drag, target)
    local dragging, dragInput, mousePos, framePos
    drag.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    drag.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            target.Position = UDim2.new(
                framePos.X.Scale, framePos.X.Offset + delta.X,
                framePos.Y.Scale, framePos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ─────────────────────────────────────────────────────────────────────────────
-- THEMES
-- ─────────────────────────────────────────────────────────────────────────────

local Themes = {
    Dark = {
        Main = Color3.fromRGB(25, 25, 25),
        Second = Color3.fromRGB(32, 32, 32),
        Stroke = Color3.fromRGB(55, 55, 55),
        Divider = Color3.fromRGB(40, 40, 40),
        Text = Color3.fromRGB(240, 240, 240),
        TextDark = Color3.fromRGB(160, 160, 160),
        Accent = Color3.fromRGB(9, 99, 195),
        Danger = Color3.fromRGB(195, 50, 50),
        Success = Color3.fromRGB(50, 180, 80),
    },
    Ocean = {
        Main = Color3.fromRGB(18, 25, 40),
        Second = Color3.fromRGB(25, 34, 52),
        Stroke = Color3.fromRGB(45, 60, 85),
        Divider = Color3.fromRGB(35, 48, 68),
        Text = Color3.fromRGB(210, 225, 245),
        TextDark = Color3.fromRGB(140, 160, 185),
        Accent = Color3.fromRGB(30, 140, 210),
        Danger = Color3.fromRGB(210, 60, 60),
        Success = Color3.fromRGB(40, 190, 100),
    },
    Neon = {
        Main = Color3.fromRGB(14, 10, 24),
        Second = Color3.fromRGB(22, 16, 36),
        Stroke = Color3.fromRGB(50, 30, 85),
        Divider = Color3.fromRGB(35, 22, 55),
        Text = Color3.fromRGB(220, 200, 250),
        TextDark = Color3.fromRGB(140, 120, 175),
        Accent = Color3.fromRGB(140, 40, 255),
        Danger = Color3.fromRGB(255, 50, 80),
        Success = Color3.fromRGB(60, 200, 130),
    },
    Light = {
        Main = Color3.fromRGB(240, 240, 245),
        Second = Color3.fromRGB(230, 230, 238),
        Stroke = Color3.fromRGB(200, 200, 212),
        Divider = Color3.fromRGB(215, 215, 225),
        Text = Color3.fromRGB(35, 35, 45),
        TextDark = Color3.fromRGB(120, 120, 140),
        Accent = Color3.fromRGB(50, 50, 65),
        Danger = Color3.fromRGB(190, 40, 40),
        Success = Color3.fromRGB(40, 160, 75),
    },
}

-- ─────────────────────────────────────────────────────────────────────────────
── LIBRARY
-- ─────────────────────────────────────────────────────────────────────────────

local ApexUI = {
    Version = "1.0.0",
    CurrentTheme = "Dark",
    Themes = Themes,
    ThemeObjects = {},
    Flags = {},
    Connections = {},
    Elements = {},
}

-- ─────────────────────────────────────────────────────────────────────────────
-- THEME ENGINE
-- ─────────────────────────────────────────────────────────────────────────────

local function GetThemeProperty(obj)
    if obj:IsA("Frame") or obj:IsA("TextButton") or obj:IsA("ScrollingFrame") then
        return "BackgroundColor3"
    elseif obj:IsA("TextLabel") or obj:IsA("TextBox") then
        return "TextColor3"
    elseif obj:IsA("UIStroke") then
        return "Color"
    elseif obj:IsA("ImageLabel") or obj:IsA("ImageButton") then
        return "ImageColor3"
    end
    return "BackgroundColor3"
end

function ApexUI:RegisterThemeObject(obj, key)
    if not self.ThemeObjects[key] then self.ThemeObjects[key] = {} end
    table.insert(self.ThemeObjects[key], obj)
    local theme = self:GetCurrentTheme()
    local prop = GetThemeProperty(obj)
    if theme[key] then
        obj[prop] = theme[key]
    end
end

function ApexUI:GetCurrentTheme()
    return self.Themes[self.CurrentTheme] or self.Themes.Dark
end

function ApexUI:SetTheme(name)
    if not self.Themes[name] then return end
    self.CurrentTheme = name
    local theme = self.Themes[name]
    for key, objects in pairs(self.ThemeObjects) do
        local color = theme[key]
        if color then
            for _, obj in pairs(objects) do
                local prop = GetThemeProperty(obj)
                obj[prop] = color
            end
        end
    end
end

function ApexUI:GetThemeList()
    local t = {}
    for k in pairs(self.Themes) do table.insert(t, k) end
    return t
end

function ApexUI:AddTheme(name, colors)
    if not name or type(name) ~= "string" then return false end
    colors.Name = name
    self.Themes[name] = colors
    return true
end

-- ─────────────────────────────────────────────────────────────────────────────
── NOTIFICATIONS
-- ─────────────────────────────────────────────────────────────────────────────

local NotificationHolder

function ApexUI:Notify(config)
    config = config or {}
    config.Title = config.Title or "Notification"
    config.Content = config.Content or ""
    config.Duration = config.Duration or 5
    config.Icon = config.Icon or "rbxassetid://4384403532"

    if not NotificationHolder then
        local gui = Instance.new("ScreenGui")
        gui.Name = "ApexUI_Notifications"
        gui.DisplayOrder = 100
        gui.IgnoreGuiInset = true
        gui.ResetOnSpawn = false
        gui.Parent = GetParent()

        NotificationHolder = Util:New("Frame", {
            Size = UDim2.fromOffset(320, 0),
            Position = UDim2.new(1, -20, 1, -20),
            AnchorPoint = Vector2.new(1, 1),
            BackgroundTransparency = 1,
            Parent = gui,
            AutomaticSize = Enum.AutomaticSize.Y,
        })
        local layout = Util:New("UIListLayout", {
            Padding = UDim.new(0, 6),
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = NotificationHolder,
        })
    end

    local theme = self:GetCurrentTheme()

    local notif = Util:New("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = theme.Main,
        BackgroundTransparency = 0.1,
        Parent = NotificationHolder,
        AutomaticSize = Enum.AutomaticSize.Y,
    })
    Util:Round(notif, 8)
    Util:Stroke(notif, theme.Stroke, 1.2)

    local pad = Util:New("UIPadding", {
        PaddingTop = UDim.new(0, 10),
        PaddingBottom = UDim.new(0, 10),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        Parent = notif,
    })

    local icon = Util:New("ImageLabel", {
        Size = UDim2.fromOffset(20, 20),
        Position = UDim2.fromOffset(0, 0),
        BackgroundTransparency = 1,
        Image = config.Icon,
        ImageColor3 = theme.Accent,
        Parent = notif,
    })

    local title = Util:New("TextLabel", {
        Size = UDim2.new(1, -30, 0, 20),
        Position = UDim2.fromOffset(30, 0),
        BackgroundTransparency = 1,
        Text = config.Title,
        TextColor3 = theme.Text,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = notif,
    })

    local content = Util:New("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.fromOffset(0, 24),
        BackgroundTransparency = 1,
        Text = config.Content,
        TextColor3 = theme.TextDark,
        TextSize = 13,
        Font = Enum.Font.GothamSemibold,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = notif,
        AutomaticSize = Enum.AutomaticSize.Y,
    })

    notif.Position = UDim2.fromOffset(60, 0)
    Util:Tween(notif, {Position = UDim2.fromOffset(0, 0)}, 0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    if config.Duration > 0 then
        task.delay(config.Duration, function()
            if notif and notif.Parent then
                Util:Tween(notif, {Position = UDim2.fromOffset(60, 0), BackgroundTransparency = 1}, 0.4)
                task.delay(0.45, function() pcall(function() notif:Destroy() end) end)
            end
        end)
    end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- ELEMENT FACTORIES
-- ─────────────────────────────────────────────────────────────────────────────

local function CreateCorner(radius)
    return Util:New("UICorner", {CornerRadius = UDim.new(0, radius or 8)})
end
local function CreateStroke(color, thick)
    return Util:New("UIStroke", {Color = color or Color3.fromRGB(60,60,60), Thickness = thick or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
end
local function CreateList(padding)
    return Util:New("UIListLayout", {Padding = UDim.new(0, padding or 4), SortOrder = Enum.SortOrder.LayoutOrder, FillDirection = Enum.FillDirection.Vertical, HorizontalAlignment = Enum.HorizontalAlignment.Center})
end

-- ─────────────────────────────────────────────────────────────────────────────
-- MAIN WINDOW
-- ─────────────────────────────────────────────────────────────────────────────

function ApexUI:CreateWindow(config)
    config = config or {}
    config.Name = config.Name or "ApexUI"
    config.ToggleKey = config.ToggleKey or Enum.KeyCode.RightControl

    local theme = self:GetCurrentTheme()
    local firstTab = true
    local minimized = false
    local hidden = false

    -- ── ScreenGui ──
    local gui = Util:New("ScreenGui", {
        Name = "ApexUI_" .. config.Name:gsub("%s+", "_"),
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 10,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        Parent = GetParent(),
    })
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(gui) end
    end)

    -- ── Main Frame ──
    local main = Util:New("Frame", {
        Name = "Main",
        Size = UDim2.fromOffset(615, 400),
        Position = UDim2.new(0.5, -307, 0.5, -200),
        BackgroundColor3 = theme.Main,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Parent = gui,
    })
    Util:Round(main, 8)
    self:RegisterThemeObject(main, "Main")

    -- ── TopBar ──
    local topBar = Util:New("Frame", {
        Name = "TopBar",
        Size = UDim2.new(1, 0, 0, 46),
        BackgroundColor3 = theme.Second,
        BorderSizePixel = 0,
        Parent = main,
    })
    Util:Round(topBar, 8)
    self:RegisterThemeObject(topBar, "Second")
    Util:MakeDraggable(topBar, main)

    -- Line under topbar
    local topLine = Util:New("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = theme.Stroke,
        BorderSizePixel = 0,
        Parent = topBar,
    })
    self:RegisterThemeObject(topLine, "Stroke")

    -- Title
    local title = Util:New("TextLabel", {
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.fromOffset(16, 0),
        BackgroundTransparency = 1,
        Text = config.Name,
        TextColor3 = theme.Text,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = topBar,
    })
    self:RegisterThemeObject(title, "Text")

    -- Minimize/Close buttons
    local btnFrame = Util:New("Frame", {
        Size = UDim2.fromOffset(72, 28),
        Position = UDim2.new(1, -84, 0, 9),
        BackgroundColor3 = theme.Main,
        BorderSizePixel = 0,
        Parent = topBar,
    })
    Util:Round(btnFrame, 6)
    self:RegisterThemeObject(btnFrame, "Main")
    Util:Stroke(btnFrame, theme.Stroke, 1)

    local sep = Util:New("Frame", {
        Size = UDim2.fromOffset(1, 20),
        Position = UDim2.new(0.5, 0, 0, 4),
        BackgroundColor3 = theme.Stroke,
        BorderSizePixel = 0,
        Parent = btnFrame,
    })
    self:RegisterThemeObject(sep, "Stroke")

    local minBtn = Util:New("TextButton", {
        Size = UDim2.fromScale(0.5, 1),
        BackgroundTransparency = 1,
        Text = "─",
        TextColor3 = theme.Text,
        TextSize = 16,
        Font = Enum.Font.Gotham,
        AutoButtonColor = false,
        Parent = btnFrame,
    })
    self:RegisterThemeObject(minBtn, "Text")

    local closeBtn = Util:New("TextButton", {
        Size = UDim2.fromScale(0.5, 1),
        Position = UDim2.fromScale(0.5, 0),
        BackgroundTransparency = 1,
        Text = "✕",
        TextColor3 = theme.Text,
        TextSize = 16,
        Font = Enum.Font.Gotham,
        AutoButtonColor = false,
        Parent = btnFrame,
    })
    self:RegisterThemeObject(closeBtn, "Text")

    -- ── Sidebar (Tab List) ──
    local sidebar = Util:New("Frame", {
        Name = "Sidebar",
        Size = UDim2.fromOffset(150, 0),
        Position = UDim2.fromOffset(0, 46),
        BackgroundColor3 = theme.Second,
        BorderSizePixel = 0,
        Parent = main,
        ClipsDescendants = true,
    })
    Util:Round(sidebar, 8)
    self:RegisterThemeObject(sidebar, "Second")

    -- Sidebar right line
    local sideLine = Util:New("Frame", {
        Size = UDim2.fromOffset(1, 1),
        Position = UDim2.new(1, -1, 0, 0),
        BackgroundColor3 = theme.Stroke,
        BorderSizePixel = 0,
        Parent = sidebar,
    })
    self:RegisterThemeObject(sideLine, "Stroke")

    -- Tab container (scrolling)
    local tabContainer = Util:New("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 0,
        CanvasSize = UDim2.fromOffset(0, 0),
        Parent = sidebar,
    })
    local tabList = CreateList(4)
    tabList.Parent = tabContainer
    tabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabContainer.CanvasSize = UDim2.fromOffset(0, tabList.AbsoluteContentSize.Y + 10)
    end)
    local tabPad = Util:New("UIPadding", {
        PaddingTop = UDim.new(0, 8),
        PaddingBottom = UDim.new(0, 8),
        Parent = tabContainer,
    })

    -- ── Content Area ──
    local content = Util:New("Frame", {
        Name = "Content",
        Size = UDim2.new(1, -150, 1, -46),
        Position = UDim2.fromOffset(150, 46),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Parent = main,
        ClipsDescendants = true,
    })

    -- ── Window Methods ──
    local windowObj = {
        GUI = gui,
        Main = main,
        TopBar = topBar,
        Sidebar = sidebar,
        TabContainer = tabContainer,
        Content = content,
        Tabs = {},
        ActiveTab = nil,
        Config = config,
        Theme = theme,
    }

    -- Close
    closeBtn.MouseButton1Click:Connect(function()
        Util:Tween(main, {Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1}, 0.3)
        task.delay(0.35, function() gui:Destroy() end)
        if config.OnClose then config.OnClose() end
    end)

    -- Minimize
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            Util:Tween(main, {Size = UDim2.fromOffset(main.AbsoluteSize.X, 46)}, 0.3)
            sidebar.Visible = false
            content.Visible = false
        else
            sidebar.Visible = true
            content.Visible = true
            Util:Tween(main, {Size = UDim2.fromOffset(615, 400)}, 0.3)
        end
    end)

    -- Toggle keybind
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == config.ToggleKey then
            hidden = not hidden
            main.Visible = not hidden
        end
    end)

    -- ── Tab Creation ──
    function windowObj:AddTab(name, icon)
        icon = icon or "rbxassetid://0"

        -- Tab button
        local tabBtn = Util:New("TextButton", {
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            Parent = tabContainer,
        })
        Util:Round(tabBtn, 6)

        local tabIcon = Util:New("ImageLabel", {
            Size = UDim2.fromOffset(18, 18),
            Position = UDim2.fromOffset(10, 7),
            BackgroundTransparency = 1,
            Image = icon,
            ImageColor3 = theme.TextDark,
            Parent = tabBtn,
        })
        self:RegisterThemeObject(tabIcon, "TextDark")

        local tabLabel = Util:New("TextLabel", {
            Size = UDim2.new(1, -36, 1, 0),
            Position = UDim2.fromOffset(34, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = theme.TextDark,
            TextSize = 14,
            Font = Enum.Font.GothamSemibold,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = tabBtn,
        })
        self:RegisterThemeObject(tabLabel, "TextDark")

        -- Page frame (scrolling)
        local page = Util:New("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 5,
            ScrollBarImageColor3 = theme.Divider,
            CanvasSize = UDim2.fromOffset(0, 0),
            Parent = content,
            Visible = false,
        })
        self:RegisterThemeObject(page, "Divider")

        local pageList = CreateList(6)
        pageList.Parent = page
        pageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.fromOffset(0, pageList.AbsoluteContentSize.Y + 30)
        end)
        local pagePad = Util:New("UIPadding", {
            PaddingTop = UDim.new(0, 12),
            PaddingBottom = UDim.new(0, 12),
            PaddingLeft = UDim.new(0, 12),
            PaddingRight = UDim.new(0, 12),
            Parent = page,
        })

        local tabInfo = {
            Name = name,
            Button = tabBtn,
            Label = tabLabel,
            Icon = tabIcon,
            Page = page,
            Sections = {},
        }

        -- Tab selection
        tabBtn.MouseButton1Click:Connect(function()
            windowObj:SelectTab(name)
        end)

        tabBtn.MouseEnter:Connect(function()
            if windowObj.ActiveTab ~= name then
                Util:Tween(tabLabel, {TextColor3 = theme.Text}, 0.15)
                Util:Tween(tabIcon, {ImageColor3 = theme.Text}, 0.15)
            end
        end)
        tabBtn.MouseLeave:Connect(function()
            if windowObj.ActiveTab ~= name then
                Util:Tween(tabLabel, {TextColor3 = theme.TextDark}, 0.15)
                Util:Tween(tabIcon, {ImageColor3 = theme.TextDark}, 0.15)
            end
        end)

        -- First tab auto-select
        if firstTab then
            firstTab = false
            windowObj:SelectTab(name)
        end

        table.insert(self.Tabs, tabInfo)

        -- ── Section Creation ──
        function tabInfo:AddSection(secName)
            -- Section container
            local secFrame = Util:New("Frame", {
                Size = UDim2.new(1, 0, 0, 34),
                BackgroundColor3 = theme.Second,
                BorderSizePixel = 0,
                Parent = page,
            })
            Util:Round(secFrame, 8)
            self:RegisterThemeObject(secFrame, "Second")
            Util:Stroke(secFrame, theme.Stroke, 1)

            -- Header
            local header = Util:New("Frame", {
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundColor3 = theme.Accent,
                BorderSizePixel = 0,
                Parent = secFrame,
                ClipsDescendants = true,
            })
            Util:Round(header, 8)
            self:RegisterThemeObject(header, "Accent")

            -- Cover up bottom corners of header
            local cover = Util:New("Frame", {
                Size = UDim2.new(1, 0, 0, 6),
                Position = UDim2.new(0, 0, 1, -6),
                BackgroundColor3 = theme.Accent,
                BorderSizePixel = 0,
                Parent = header,
            })
            self:RegisterThemeObject(cover, "Accent")

            local secTitle = Util:New("TextLabel", {
                Size = UDim2.new(1, -16, 1, 0),
                Position = UDim2.fromOffset(12, 0),
                BackgroundTransparency = 1,
                Text = secName,
                TextColor3 = theme.Text,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = header,
            })
            self:RegisterThemeObject(secTitle, "Text")

            -- Inner content
            local inner = Util:New("Frame", {
                Size = UDim2.new(1, -16, 0, 0),
                Position = UDim2.fromOffset(8, 36),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Parent = secFrame,
                AutomaticSize = Enum.AutomaticSize.Y,
                ClipsDescendants = true,
            })
            local innerList = CreateList(4)
            innerList.Parent = inner

            local secData = {
                Name = secName,
                Frame = secFrame,
                Header = header,
                Inner = inner,
                Layout = innerList,
                Elements = {},
            }

            -- Auto-resize section
            innerList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                local h = innerList.AbsoluteContentSize.Y + 44
                if h > 44 then
                    secFrame.Size = UDim2.new(1, 0, 0, h)
                end
            end)

            table.insert(self.Sections, secData)

            -- ════════════════════════════════════════════════════════════════
            -- ELEMENT CREATORS
            -- ════════════════════════════════════════════════════════════════

            -- ── BUTTON ──
            function secData:AddButton(cfg)
                cfg = cfg or {}
                local btnName = cfg.Name or "Button"
                local cb = cfg.Callback or function() end

                local frame = Util:New("Frame", {
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = theme.Main,
                    BorderSizePixel = 0,
                    Parent = inner,
                })
                Util:Round(frame, 6)
                self:RegisterThemeObject(frame, "Main")
                Util:Stroke(frame, theme.Stroke, 1)

                local btn = Util:New("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = frame,
                })

                local label = Util:New("TextLabel", {
                    Size = UDim2.new(1, -16, 1, 0),
                    Position = UDim2.fromOffset(12, 0),
                    BackgroundTransparency = 1,
                    Text = btnName,
                    TextColor3 = theme.Text,
                    TextSize = 14,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = frame,
                })
                self:RegisterThemeObject(label, "Text")

                btn.MouseEnter:Connect(function()
                    Util:Tween(frame, {BackgroundColor3 = Color3.fromRGB(
                        theme.Main.R * 255 + 5, theme.Main.G * 255 + 5, theme.Main.B * 255 + 5
                    )}, 0.15)
                end)
                btn.MouseLeave:Connect(function()
                    Util:Tween(frame, {BackgroundColor3 = theme.Main}, 0.15)
                end)
                btn.MouseButton1Click:Connect(function()
                    local s, e = pcall(cb)
                    if not s then warn("ApexUI Button Error:", e) end
                end)

                table.insert(self.Elements, {Type="Button", Name=btnName, Frame=frame})
                return frame
            end

            -- ── TOGGLE ──
            function secData:AddToggle(cfg)
                cfg = cfg or {}
                local togName = cfg.Name or "Toggle"
                local def = cfg.Default or false
                local cb = cfg.Callback or function() end

                local state = def

                local frame = Util:New("Frame", {
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = theme.Main,
                    BorderSizePixel = 0,
                    Parent = inner,
                })
                Util:Round(frame, 6)
                self:RegisterThemeObject(frame, "Main")
                Util:Stroke(frame, theme.Stroke, 1)

                local label = Util:New("TextLabel", {
                    Size = UDim2.new(1, -56, 1, 0),
                    Position = UDim2.fromOffset(12, 0),
                    BackgroundTransparency = 1,
                    Text = togName,
                    TextColor3 = theme.Text,
                    TextSize = 14,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = frame,
                })
                self:RegisterThemeObject(label, "Text")

                local togFrame = Util:New("Frame", {
                    Size = UDim2.fromOffset(40, 22),
                    Position = UDim2.new(1, -48, 0, 6),
                    BackgroundColor3 = def and theme.Accent or theme.Divider,
                    BorderSizePixel = 0,
                    Parent = frame,
                })
                Util:Round(togFrame, 11)
                self:RegisterThemeObject(togFrame, "Divider")

                local knob = Util:New("Frame", {
                    Size = UDim2.fromOffset(18, 18),
                    Position = UDim2.fromOffset(def and 20 or 2, 2),
                    BackgroundColor3 = theme.Text,
                    BorderSizePixel = 0,
                    Parent = togFrame,
                })
                Util:Round(knob, 9)
                self:RegisterThemeObject(knob, "Text")

                local click = Util:New("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = frame,
                })

                local function setState(new)
                    state = new
                    if state then
                        Util:Tween(togFrame, {BackgroundColor3 = theme.Accent}, 0.2)
                        Util:Tween(knob, {Position = UDim2.fromOffset(20, 2)}, 0.2)
                    else
                        Util:Tween(togFrame, {BackgroundColor3 = theme.Divider}, 0.2)
                        Util:Tween(knob, {Position = UDim2.fromOffset(2, 2)}, 0.2)
                    end
                    local s, e = pcall(cb, state)
                    if not s then warn("ApexUI Toggle Error:", e) end
                end

                click.MouseButton1Click:Connect(function()
                    setState(not state)
                end)

                table.insert(self.Elements, {Type="Toggle", Name=togName, Frame=frame})

                return {
                    SetState = setState,
                    GetState = function() return state end,
                }
            end

            -- ── SLIDER ──
            function secData:AddSlider(cfg)
                cfg = cfg or {}
                local sName = cfg.Name or "Slider"
                local min = cfg.Min or 0
                local max = cfg.Max or 100
                local def = cfg.Default or min
                local suffix = cfg.Suffix or ""
                local prec = cfg.Decimals or 0
                local cb = cfg.Callback or function() end

                local value = def

                local frame = Util:New("Frame", {
                    Size = UDim2.new(1, 0, 0, 50),
                    BackgroundColor3 = theme.Main,
                    BorderSizePixel = 0,
                    Parent = inner,
                })
                Util:Round(frame, 6)
                self:RegisterThemeObject(frame, "Main")
                Util:Stroke(frame, theme.Stroke, 1)

                local label = Util:New("TextLabel", {
                    Size = UDim2.new(1, -16, 0, 18),
                    Position = UDim2.fromOffset(12, 4),
                    BackgroundTransparency = 1,
                    Text = sName,
                    TextColor3 = theme.Text,
                    TextSize = 14,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = frame,
                })
                self:RegisterThemeObject(label, "Text")

                local valLabel = Util:New("TextLabel", {
                    Size = UDim2.fromOffset(60, 18),
                    Position = UDim2.new(1, -12, 0, 4),
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Text = tostring(def) .. suffix,
                    TextColor3 = theme.Accent,
                    TextSize = 14,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = frame,
                })
                self:RegisterThemeObject(valLabel, "Accent")

                local barBg = Util:New("Frame", {
                    Size = UDim2.new(1, -24, 0, 6),
                    Position = UDim2.fromOffset(12, 30),
                    BackgroundColor3 = theme.Divider,
                    BorderSizePixel = 0,
                    Parent = frame,
                    ClipsDescendants = true,
                })
                Util:Round(barBg, 3)
                self:RegisterThemeObject(barBg, "Divider")

                local barFill = Util:New("Frame", {
                    Size = UDim2.fromOffset(0, 6),
                    BackgroundColor3 = theme.Accent,
                    BorderSizePixel = 0,
                    Parent = barBg,
                })
                Util:Round(barFill, 3)
                self:RegisterThemeObject(barFill, "Accent")

                local scrub = Util:New("Frame", {
                    Size = UDim2.fromOffset(12, 12),
                    Position = UDim2.fromOffset(-6, -3),
                    BackgroundColor3 = theme.Text,
                    BorderSizePixel = 0,
                    Parent = barBg,
                })
                Util:Round(scrub, 6)
                self:RegisterThemeObject(scrub, "Text")

                local dragging = false

                local function update(posX)
                    local rel = math.clamp((posX - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
                    local raw = min + (max - min) * rel
                    local f = 10 ^ prec
                    value = math.round(raw * f) / f
                    value = math.clamp(value, min, max)
                    local w = barBg.AbsoluteSize.X * rel
                    barFill.Size = UDim2.fromOffset(w, 6)
                    scrub.Position = UDim2.fromOffset(w - 6, -3)
                    valLabel.Text = tostring(value) .. suffix
                    local s, e = pcall(cb, value)
                    if not s then warn("ApexUI Slider Error:", e) end
                end

                barBg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        dragging = true
                        update(input.Position.X)
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        update(input.Position.X)
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
                    local pct = (def - min) / (max - min)
                    local w = barBg.AbsoluteSize.X * pct
                    barFill.Size = UDim2.fromOffset(w, 6)
                    scrub.Position = UDim2.fromOffset(w - 6, -3)
                end

                table.insert(self.Elements, {Type="Slider", Name=sName, Frame=frame})

                return {
                    SetValue = function(v)
                        v = math.clamp(v, min, max)
                        value = v
                        valLabel.Text = tostring(v) .. suffix
                        if barBg.AbsoluteSize.X > 0 then
                            local pct = (v - min) / (max - min)
                            local w = barBg.AbsoluteSize.X * pct
                            barFill.Size = UDim2.fromOffset(w, 6)
                            scrub.Position = UDim2.fromOffset(w - 6, -3)
                        end
                    end,
                    GetValue = function() return value end,
                }
            end

            -- ── DROPDOWN ──
            function secData:AddDropdown(cfg)
                cfg = cfg or {}
                local ddName = cfg.Name or "Dropdown"
                local opts = cfg.Options or {}
                local def = cfg.Default
                local cb = cfg.Callback or function() end

                local selected = def or (opts[1] or "Select...")
                local open = false

                local frame = Util:New("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundColor3 = theme.Main,
                    BorderSizePixel = 0,
                    Parent = inner,
                    ClipsDescendants = true,
                    AutomaticSize = Enum.AutomaticSize.Y,
                })
                Util:Round(frame, 6)
                self:RegisterThemeObject(frame, "Main")
                Util:Stroke(frame, theme.Stroke, 1)

                -- Top bar (label + selected + arrow)
                local top = Util:New("Frame", {
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundTransparency = 1,
                    Parent = frame,
                })

                local label = Util:New("TextLabel", {
                    Size = UDim2.new(1, -80, 1, 0),
                    Position = UDim2.fromOffset(12, 0),
                    BackgroundTransparency = 1,
                    Text = ddName,
                    TextColor3 = theme.Text,
                    TextSize = 14,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = top,
                })
                self:RegisterThemeObject(label, "Text")

                local selLabel = Util:New("TextLabel", {
                    Size = UDim2.fromOffset(80, 20),
                    Position = UDim2.new(1, -84, 0, 7),
                    BackgroundTransparency = 1,
                    Text = selected,
                    TextColor3 = theme.TextDark,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = top,
                })
                self:RegisterThemeObject(selLabel, "TextDark")

                local arrow = Util:New("TextLabel", {
                    Size = UDim2.fromOffset(16, 20),
                    Position = UDim2.new(1, -20, 0, 7),
                    BackgroundTransparency = 1,
                    Text = "▼",
                    TextColor3 = theme.TextDark,
                    TextSize = 10,
                    Font = Enum.Font.Gotham,
                    Parent = top,
                })
                self:RegisterThemeObject(arrow, "TextDark")

                local click = Util:New("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = top,
                })

                -- Dropdown list
                local listFrame = Util:New("Frame", {
                    Size = UDim2.new(1, -12, 0, 0),
                    Position = UDim2.fromOffset(6, 36),
                    BackgroundTransparency = 1,
                    Parent = frame,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    Visible = false,
                })
                local listLayout = CreateList(2)
                listLayout.Parent = listFrame

                local function populate()
                    for _, child in pairs(listFrame:GetChildren()) do
                        if child:IsA("TextButton") then child:Destroy() end
                    end
                    for _, opt in ipairs(opts) do
                        local optStr = tostring(opt)
                        local optBtn = Util:New("TextButton", {
                            Size = UDim2.new(1, 0, 0, 28),
                            BackgroundColor3 = theme.Main,
                            Text = "",
                            AutoButtonColor = false,
                            Parent = listFrame,
                        })
                        Util:Round(optBtn, 6)
                        self:RegisterThemeObject(optBtn, "Main")

                        local optLabel = Util:New("TextLabel", {
                            Size = UDim2.new(1, -16, 1, 0),
                            Position = UDim2.fromOffset(10, 0),
                            BackgroundTransparency = 1,
                            Text = optStr,
                            TextColor3 = optStr == selected and theme.Accent or theme.Text,
                            TextSize = 13,
                            Font = Enum.Font.Gotham,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            Parent = optBtn,
                        })
                        if optStr == selected then
                            self:RegisterThemeObject(optLabel, "Accent")
                        else
                            self:RegisterThemeObject(optLabel, "Text")
                        end

                        optBtn.MouseButton1Click:Connect(function()
                            selected = optStr
                            selLabel.Text = selected
                            selLabel.TextColor3 = theme.Accent
                            closeList()
                            local s, e = pcall(cb, opt)
                            if not s then warn("ApexUI Dropdown Error:", e) end
                        end)
                        optBtn.MouseEnter:Connect(function()
                            Util:Tween(optBtn, {BackgroundColor3 = theme.Second}, 0.1)
                        end)
                        optBtn.MouseLeave:Connect(function()
                            Util:Tween(optBtn, {BackgroundColor3 = theme.Main}, 0.1)
                        end)
                    end
                end

                local function openList()
                    if open then return end
                    open = true
                    listFrame.Visible = true
                    arrow.Text = "▲"
                    populate()
                end

                local function closeList()
                    if not open then return end
                    open = false
                    listFrame.Visible = false
                    arrow.Text = "▼"
                end

                click.MouseButton1Click:Connect(function()
                    if open then closeList() else openList() end
                end)

                UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 and open then
                        local mPos = UserInputService:GetMouseLocation()
                        local aPos = listFrame.AbsolutePosition
                        local aSize = listFrame.AbsoluteSize
                        if mPos.X < aPos.X or mPos.X > aPos.X + aSize.X or
                           mPos.Y < aPos.Y or mPos.Y > aPos.Y + aSize.Y then
                            closeList()
                        end
                    end
                end)

                table.insert(self.Elements, {Type="Dropdown", Name=ddName, Frame=frame})

                return {
                    SetValue = function(v)
                        selected = tostring(v)
                        selLabel.Text = selected
                    end,
                    GetValue = function() return selected end,
                    Refresh = function(newOpts)
                        opts = newOpts
                        if open then populate() end
                    end,
                }
            end

            -- ── TEXTBOX ──
            function secData:AddTextbox(cfg)
                cfg = cfg or {}
                local tbName = cfg.Name or "Textbox"
                local placeholder = cfg.Placeholder or "Input"
                local def = cfg.Default or ""
                local numeric = cfg.Numeric or false
                local cb = cfg.Callback or function() end

                local frame = Util:New("Frame", {
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = theme.Main,
                    BorderSizePixel = 0,
                    Parent = inner,
                })
                Util:Round(frame, 6)
                self:RegisterThemeObject(frame, "Main")
                Util:Stroke(frame, theme.Stroke, 1)

                local label = Util:New("TextLabel", {
                    Size = UDim2.new(1, -140, 1, 0),
                    Position = UDim2.fromOffset(12, 0),
                    BackgroundTransparency = 1,
                    Text = tbName,
                    TextColor3 = theme.Text,
                    TextSize = 14,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = frame,
                })
                self:RegisterThemeObject(label, "Text")

                local boxFrame = Util:New("Frame", {
                    Size = UDim2.fromOffset(120, 22),
                    Position = UDim2.new(1, -128, 0, 6),
                    BackgroundColor3 = theme.Divider,
                    BorderSizePixel = 0,
                    Parent = frame,
                })
                Util:Round(boxFrame, 6)
                self:RegisterThemeObject(boxFrame, "Divider")

                local box = Util:New("TextBox", {
                    Size = UDim2.new(1, -8, 1, 0),
                    Position = UDim2.fromOffset(4, 0),
                    BackgroundTransparency = 1,
                    PlaceholderText = placeholder,
                    PlaceholderColor3 = theme.TextDark,
                    Text = def,
                    TextColor3 = theme.Text,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    ClearTextOnFocus = false,
                    Parent = boxFrame,
                })
                self:RegisterThemeObject(box, "Text")
                self:RegisterThemeObject(box, "TextDark")

                box.FocusLost:Connect(function(enter)
                    if enter then
                        local val = box.Text
                        if numeric then
                            local n = tonumber(val)
                            if n then
                                box.Text = tostring(n)
                                local s, e = pcall(cb, n)
                                if not s then warn("ApexUI TextBox Error:", e) end
                            else
                                box.Text = def
                            end
                        else
                            local s, e = pcall(cb, val)
                            if not s then warn("ApexUI TextBox Error:", e) end
                        end
                    end
                end)

                table.insert(self.Elements, {Type="Textbox", Name=tbName, Frame=frame})

                return {
                    SetValue = function(v) box.Text = tostring(v) end,
                    GetValue = function() return box.Text end,
                }
            end

            -- ── KEYBIND ──
            function secData:AddKeybind(cfg)
                cfg = cfg or {}
                local kbName = cfg.Name or "Keybind"
                local def = cfg.Default or Enum.KeyCode.Unknown
                local cb = cfg.Callback or function() end
                local changeCb = cfg.ChangeCallback or function() end

                local currentKey = def
                local binding = false

                local function keyName(key)
                    local n = tostring(key):gsub("Enum.KeyCode.", ""):gsub("Enum.UserInputType.", "")
                    if n == "Unknown" then return "None" end
                    return n
                end

                local frame = Util:New("Frame", {
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = theme.Main,
                    BorderSizePixel = 0,
                    Parent = inner,
                })
                Util:Round(frame, 6)
                self:RegisterThemeObject(frame, "Main")
                Util:Stroke(frame, theme.Stroke, 1)

                local label = Util:New("TextLabel", {
                    Size = UDim2.new(1, -90, 1, 0),
                    Position = UDim2.fromOffset(12, 0),
                    BackgroundTransparency = 1,
                    Text = kbName,
                    TextColor3 = theme.Text,
                    TextSize = 14,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = frame,
                })
                self:RegisterThemeObject(label, "Text")

                local keyFrame = Util:New("Frame", {
                    Size = UDim2.fromOffset(80, 22),
                    Position = UDim2.new(1, -88, 0, 6),
                    BackgroundColor3 = theme.Divider,
                    BorderSizePixel = 0,
                    Parent = frame,
                })
                Util:Round(keyFrame, 6)
                self:RegisterThemeObject(keyFrame, "Divider")

                local keyLabel = Util:New("TextLabel", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = keyName(def),
                    TextColor3 = theme.Text,
                    TextSize = 13,
                    Font = Enum.Font.GothamBold,
                    Parent = keyFrame,
                })
                self:RegisterThemeObject(keyLabel, "Text")

                local click = Util:New("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = keyFrame,
                })

                click.MouseButton1Click:Connect(function()
                    binding = true
                    keyLabel.Text = "..."
                    keyLabel.TextColor3 = theme.Accent
                end)

                UserInputService.InputBegan:Connect(function(input, gpe)
                    if gpe then return end
                    if binding then
                        binding = false
                        local newKey = input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode or
                                       input.UserInputType ~= Enum.UserInputType.Keyboard and input.UserInputType or
                                       Enum.KeyCode.Unknown
                        if newKey ~= Enum.KeyCode.Unknown then
                            currentKey = newKey
                            keyLabel.Text = keyName(newKey)
                            keyLabel.TextColor3 = theme.Text
                            local s, e = pcall(changeCb, newKey)
                            if not s then warn("ApexUI Keybind Error:", e) end
                        else
                            keyLabel.Text = keyName(currentKey)
                            keyLabel.TextColor3 = theme.Text
                        end
                        return
                    end
                    if currentKey ~= Enum.KeyCode.Unknown then
                        local match = (input.KeyCode == currentKey) or
                                      (input.UserInputType == currentKey)
                        if match then
                            local s, e = pcall(cb)
                            if not s then warn("ApexUI Keybind Error:", e) end
                        end
                    end
                end)

                table.insert(self.Elements, {Type="Keybind", Name=kbName, Frame=frame})

                return {
                    SetKey = function(k)
                        currentKey = k
                        keyLabel.Text = keyName(k)
                    end,
                    GetKey = function() return currentKey end,
                }
            end

            -- ── LABEL ──
            function secData:AddLabel(cfg)
                cfg = cfg or {}
                local text = cfg.Text or "Label"
                local color = cfg.Color or nil

                local frame = Util:New("Frame", {
                    Size = UDim2.new(1, 0, 0, 26),
                    BackgroundTransparency = 1,
                    Parent = inner,
                })

                local label = Util:New("TextLabel", {
                    Size = UDim2.new(1, -16, 1, 0),
                    Position = UDim2.fromOffset(12, 0),
                    BackgroundTransparency = 1,
                    Text = text,
                    TextColor3 = color or theme.TextDark,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = frame,
                })
                if not color then
                    self:RegisterThemeObject(label, "TextDark")
                end

                return {
                    SetText = function(t) label.Text = t end,
                }
            end

            -- ── PARAGRAPH ──
            function secData:AddParagraph(cfg)
                cfg = cfg or {}
                local title = cfg.Title or "Information"
                local content = cfg.Content or ""

                local frame = Util:New("Frame", {
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundTransparency = 1,
                    Parent = inner,
                    AutomaticSize = Enum.AutomaticSize.Y,
                })

                local titleLabel = Util:New("TextLabel", {
                    Size = UDim2.new(1, -16, 0, 20),
                    Position = UDim2.fromOffset(12, 4),
                    BackgroundTransparency = 1,
                    Text = title,
                    TextColor3 = theme.Text,
                    TextSize = 14,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = frame,
                })
                self:RegisterThemeObject(titleLabel, "Text")

                local contentLabel = Util:New("TextLabel", {
                    Size = UDim2.new(1, -24, 0, 0),
                    Position = UDim2.fromOffset(12, 26),
                    BackgroundTransparency = 1,
                    Text = content,
                    TextColor3 = theme.TextDark,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextWrapped = true,
                    Parent = frame,
                    AutomaticSize = Enum.AutomaticSize.Y,
                })
                self:RegisterThemeObject(contentLabel, "TextDark")

                return {
                    SetContent = function(t) contentLabel.Text = t end,
                }
            end

            -- ── COLOR PICKER ──
            function secData:AddColorPicker(cfg)
                cfg = cfg or {}
                local cpName = cfg.Name or "Colorpicker"
                local def = cfg.Default or Color3.fromRGB(255, 255, 255)
                local cb = cfg.Callback or function() end

                local currentColor = def
                local h, s, v = Color3.toHSV(def)
                local toggled = false

                local frame = Util:New("Frame", {
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = theme.Main,
                    BorderSizePixel = 0,
                    Parent = inner,
                    ClipsDescendants = true,
                })
                Util:Round(frame, 6)
                self:RegisterThemeObject(frame, "Main")
                Util:Stroke(frame, theme.Stroke, 1)

                local label = Util:New("TextLabel", {
                    Size = UDim2.new(1, -56, 1, 0),
                    Position = UDim2.fromOffset(12, 0),
                    BackgroundTransparency = 1,
                    Text = cpName,
                    TextColor3 = theme.Text,
                    TextSize = 14,
                    Font = Enum.Font.GothamSemibold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = frame,
                })
                self:RegisterThemeObject(label, "Text")

                local preview = Util:New("Frame", {
                    Size = UDim2.fromOffset(22, 22),
                    Position = UDim2.new(1, -48, 0, 6),
                    BackgroundColor3 = def,
                    BorderSizePixel = 0,
                    Parent = frame,
                })
                Util:Round(preview, 6)
                Util:Stroke(preview, theme.Stroke, 1)

                local click = Util:New("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = frame,
                })

                -- Picker panel
                local panel = Util:New("Frame", {
                    Size = UDim2.new(1, -16, 0, 130),
                    Position = UDim2.fromOffset(8, 36),
                    BackgroundColor3 = theme.Main,
                    BorderSizePixel = 0,
                    Parent = frame,
                    Visible = false,
                })
                Util:Round(panel, 8)
                Util:Stroke(panel, theme.Stroke, 1)

                -- Saturation/Value grid
                local svGrid = Util:New("Frame", {
                    Size = UDim2.fromOffset(152, 90),
                    Position = UDim2.fromOffset(10, 8),
                    BackgroundColor3 = Color3.fromHSV(h, 1, 1),
                    BorderSizePixel = 0,
                    Parent = panel,
                    ClipsDescendants = true,
                })
                Util:Round(svGrid, 6)

                local whiteGrad = Util:New("UIGradient", {
                    Color = ColorSequence.new(Color3.fromRGB(255,255,255), Color3.fromRGB(255,0,0)),
                    Parent = svGrid,
                })
                local blackGrad = Util:New("UIGradient", {
                    Color = ColorSequence.new(Color3.fromRGB(0,0,0), Color3.fromRGB(0,0,0), Color3.fromRGB(255,255,255)),
                    Rotation = 90,
                    Parent = svGrid,
                })

                -- Hue bar
                local hueBar = Util:New("Frame", {
                    Size = UDim2.fromOffset(20, 90),
                    Position = UDim2.fromOffset(170, 8),
                    BackgroundColor3 = Color3.fromRGB(255,0,0),
                    BorderSizePixel = 0,
                    Parent = panel,
                    ClipsDescendants = true,
                })
                Util:Round(hueBar, 6)
                local hueGrad = Util:New("UIGradient", {
                    Rotation = 270,
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
                        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255,255,0)),
                        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0,255,0)),
                        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0,255,255)),
                        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0,0,255)),
                        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255,0,255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,0)),
                    }),
                    Parent = hueBar,
                })

                -- Hex input
                local hexBox = Util:New("TextBox", {
                    Size = UDim2.fromOffset(90, 22),
                    Position = UDim2.fromOffset(10, 104),
                    BackgroundColor3 = theme.Divider,
                    BorderSizePixel = 0,
                    PlaceholderText = "#FFFFFF",
                    PlaceholderColor3 = theme.TextDark,
                    Text = "#FFFFFF",
                    TextColor3 = theme.Text,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    ClearTextOnFocus = false,
                    Parent = panel,
                })
                Util:Round(hexBox, 6)

                local function updateColor()
                    currentColor = Color3.fromHSV(h, s, v)
                    preview.BackgroundColor3 = currentColor
                    svGrid.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    hexBox.Text = string.format("#%02X%02X%02X",
                        math.floor(currentColor.R * 255),
                        math.floor(currentColor.G * 255),
                        math.floor(currentColor.B * 255))
                    local s_, e_ = pcall(cb, currentColor)
                    if not s_ then warn("ApexUI ColorPicker Error:", e_) end
                end

                local hueDrag, svDrag = false, false

                -- Hue drag
                local hueBtn = Util:New("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = hueBar,
                })
                hueBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        hueDrag = true
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if hueDrag and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local relY = math.clamp((input.Position.Y - hueBar.AbsolutePosition.Y) / hueBar.AbsoluteSize.Y, 0, 1)
                        h = 1 - relY
                        updateColor()
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then hueDrag = false end
                end)

                -- SV drag
                local svBtn = Util:New("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = svGrid,
                })
                svBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        svDrag = true
                    end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if svDrag and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local relX = math.clamp((input.Position.X - svGrid.AbsolutePosition.X) / svGrid.AbsoluteSize.X, 0, 1)
                        local relY = math.clamp((input.Position.Y - svGrid.AbsolutePosition.Y) / svGrid.AbsoluteSize.Y, 0, 1)
                        s = relX
                        v = 1 - relY
                        updateColor()
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then svDrag = false end
                end)

                -- Hex input
                hexBox.FocusLost:Connect(function(enter)
                    if enter then
                        local hex = hexBox.Text:gsub("#", "")
                        if #hex == 6 then
                            local r = tonumber(hex:sub(1,2), 16) or 255
                            local g = tonumber(hex:sub(3,4), 16) or 255
                            local b = tonumber(hex:sub(5,6), 16) or 255
                            currentColor = Color3.fromRGB(r, g, b)
                            h, s, v = Color3.toHSV(currentColor)
                            updateColor()
                        end
                    end
                end)

                -- Toggle
                click.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    panel.Visible = toggled
                    frame.Size = toggled and UDim2.new(1, 0, 0, 174) or UDim2.new(1, 0, 0, 34)
                    if toggled then
                        h, s, v = Color3.toHSV(currentColor)
                        updateColor()
                    end
                end)

                updateColor()

                table.insert(self.Elements, {Type="ColorPicker", Name=cpName, Frame=frame})

                return {
                    SetColor = function(c)
                        currentColor = c
                        h, s, v = Color3.toHSV(c)
                        updateColor()
                    end,
                    GetColor = function() return currentColor end,
                }
            end

            return secData
        end

        return tabInfo
    end

    -- Tab selection
    function windowObj:SelectTab(name)
        for _, tab in ipairs(self.Tabs) do
            if tab.Name == name then
                tab.Page.Visible = true
                tab.Button.BackgroundColor3 = theme.Accent
                tab.Button.BackgroundTransparency = 0
                tab.Label.TextColor3 = theme.Text
                tab.Icon.ImageColor3 = theme.Text
                self:RegisterThemeObject(tab.Button, "Accent")
                self.ActiveTab = name
            else
                tab.Page.Visible = false
                tab.Button.BackgroundTransparency = 1
                tab.Label.TextColor3 = theme.TextDark
                tab.Icon.ImageColor3 = theme.TextDark
            end
        end
    end

    function windowObj:Toggle()
        main.Visible = not main.Visible
    end

    function windowObj:SetVisible(v)
        main.Visible = v
    end

    function windowObj:Destroy()
        gui:Destroy()
    end

    table.insert(self.ActiveWindows or {}, windowObj)

    -- Intro animation
    if config.Intro ~= false then
        main.Position = UDim2.new(0.5, -307, 0.5, -300)
        Util:Tween(main, {Position = UDim2.new(0.5, -307, 0.5, -200)}, 0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    end

    return windowObj
end

return ApexUI
