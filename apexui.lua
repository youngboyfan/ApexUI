--[[
╔══════════════════════════════════════════════════════════════════════╗
║                        APEX UI LIBRARY v1.0                        ║
║              The Ultimate Roblox UI Framework                       ║
║                                                                    ║
║  Design Philosophy:                                                ║
║    • Fluent Design + Material You hybrid                           ║
║    • Glass-morphism with depth & layering                          ║
║    • Butter-smooth animations & transitions                        ║
║    • Maximum performance through lazy loading                      ║
║    • Fully customizable theming system                             ║
║                                                                    ║
║  Inspired by: Kavo, Orion, LinoriaLib, Mercury, Rayfield           ║
║  and the collective genius of the Roblox exploiting community      ║
╚══════════════════════════════════════════════════════════════════════╝
--]]

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Robust parent selection (works in all executors)
local function GetParent()
    local syn = syn and syn.protected_gui or nil
    local success, parent = pcall(function()
        return cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
    end)
    if success and parent then
        return parent
    end
    success, parent = pcall(function()
        return game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end)
    if success and parent then
        return parent
    end
    return gethui and gethui() or CoreGui
end

-- ============================================================================
-- THEME SYSTEM
-- ============================================================================

local Themes = {
    ["Dark Matter"] = {
        Name = "Dark Matter",
        IsDark = true,
        -- Window
        WindowBackground = Color3.fromRGB(18, 18, 22),
        WindowBorder = Color3.fromRGB(40, 40, 50),
        WindowTitleBackground = Color3.fromRGB(25, 25, 32),
        WindowTitleText = Color3.fromRGB(220, 220, 240),
        WindowShadow = Color3.fromRGB(0, 0, 0),
        -- Tab Bar
        TabBackground = Color3.fromRGB(22, 22, 28),
        TabSelectedBackground = Color3.fromRGB(40, 100, 255),
        TabSelectedText = Color3.fromRGB(255, 255, 255),
        TabUnselectedText = Color3.fromRGB(140, 140, 160),
        TabHoverBackground = Color3.fromRGB(35, 35, 45),
        -- Section
        SectionBackground = Color3.fromRGB(24, 24, 30),
        SectionBorder = Color3.fromRGB(35, 35, 45),
        SectionTitle = Color3.fromRGB(180, 180, 200),
        -- Elements
        ButtonBackground = Color3.fromRGB(40, 100, 255),
        ButtonBackgroundHover = Color3.fromRGB(60, 120, 255),
        ButtonText = Color3.fromRGB(255, 255, 255),
        ToggleEnabled = Color3.fromRGB(40, 100, 255),
        ToggleDisabled = Color3.fromRGB(50, 50, 60),
        ToggleKnob = Color3.fromRGB(255, 255, 255),
        ToggleKnobDisabled = Color3.fromRGB(120, 120, 130),
        SliderBackground = Color3.fromRGB(40, 40, 50),
        SliderFill = Color3.fromRGB(40, 100, 255),
        SliderScrub = Color3.fromRGB(255, 255, 255),
        DropdownBackground = Color3.fromRGB(30, 30, 38),
        DropdownItemHover = Color3.fromRGB(40, 40, 50),
        DropdownText = Color3.fromRGB(200, 200, 220),
        TextBoxBackground = Color3.fromRGB(30, 30, 38),
        TextBoxText = Color3.fromRGB(220, 220, 240),
        TextBoxPlaceholder = Color3.fromRGB(100, 100, 120),
        LabelText = Color3.fromRGB(180, 180, 200),
        ParagraphText = Color3.fromRGB(160, 160, 180),
        KeybindBackground = Color3.fromRGB(35, 35, 45),
        KeybindText = Color3.fromRGB(200, 200, 220),
        ColorPickerBackground = Color3.fromRGB(30, 30, 38),
        ColorPickerBorder = Color3.fromRGB(50, 50, 60),
        -- Notification
        NotificationBackground = Color3.fromRGB(24, 24, 30),
        NotificationBorder = Color3.fromRGB(40, 40, 50),
        NotificationTitle = Color3.fromRGB(220, 220, 240),
        NotificationDesc = Color3.fromRGB(180, 180, 200),
        -- Search
        SearchBackground = Color3.fromRGB(25, 25, 32),
        SearchText = Color3.fromRGB(200, 200, 220),
        SearchPlaceholder = Color3.fromRGB(100, 100, 120),
        -- Scrollbar
        ScrollbarBackground = Color3.fromRGB(30, 30, 40),
        ScrollbarThumb = Color3.fromRGB(50, 50, 65),
        -- Accent / Misc
        Accent = Color3.fromRGB(40, 100, 255),
        Error = Color3.fromRGB(255, 60, 60),
        Success = Color3.fromRGB(50, 200, 100),
        Warning = Color3.fromRGB(255, 180, 40),
    },
    ["Arctic Frost"] = {
        Name = "Arctic Frost",
        IsDark = true,
        WindowBackground = Color3.fromRGB(10, 14, 23),
        WindowBorder = Color3.fromRGB(30, 50, 80),
        WindowTitleBackground = Color3.fromRGB(15, 20, 32),
        WindowTitleText = Color3.fromRGB(180, 220, 255),
        WindowShadow = Color3.fromRGB(0, 0, 0),
        TabBackground = Color3.fromRGB(13, 18, 30),
        TabSelectedBackground = Color3.fromRGB(30, 150, 220),
        TabSelectedText = Color3.fromRGB(255, 255, 255),
        TabUnselectedText = Color3.fromRGB(120, 160, 200),
        TabHoverBackground = Color3.fromRGB(25, 40, 60),
        SectionBackground = Color3.fromRGB(16, 22, 36),
        SectionBorder = Color3.fromRGB(30, 50, 75),
        SectionTitle = Color3.fromRGB(140, 190, 230),
        ButtonBackground = Color3.fromRGB(30, 150, 220),
        ButtonBackgroundHover = Color3.fromRGB(50, 170, 240),
        ButtonText = Color3.fromRGB(255, 255, 255),
        ToggleEnabled = Color3.fromRGB(30, 150, 220),
        ToggleDisabled = Color3.fromRGB(38, 48, 65),
        ToggleKnob = Color3.fromRGB(200, 230, 255),
        ToggleKnobDisabled = Color3.fromRGB(90, 110, 140),
        SliderBackground = Color3.fromRGB(30, 40, 55),
        SliderFill = Color3.fromRGB(30, 150, 220),
        SliderScrub = Color3.fromRGB(200, 230, 255),
        DropdownBackground = Color3.fromRGB(20, 30, 45),
        DropdownItemHover = Color3.fromRGB(30, 45, 65),
        DropdownText = Color3.fromRGB(180, 210, 240),
        TextBoxBackground = Color3.fromRGB(20, 30, 45),
        TextBoxText = Color3.fromRGB(200, 225, 250),
        TextBoxPlaceholder = Color3.fromRGB(80, 110, 140),
        LabelText = Color3.fromRGB(160, 200, 230),
        ParagraphText = Color3.fromRGB(140, 170, 200),
        KeybindBackground = Color3.fromRGB(25, 38, 55),
        KeybindText = Color3.fromRGB(180, 210, 240),
        ColorPickerBackground = Color3.fromRGB(22, 32, 48),
        ColorPickerBorder = Color3.fromRGB(40, 60, 85),
        NotificationBackground = Color3.fromRGB(18, 25, 40),
        NotificationBorder = Color3.fromRGB(35, 55, 80),
        NotificationTitle = Color3.fromRGB(200, 225, 250),
        NotificationDesc = Color3.fromRGB(150, 180, 210),
        SearchBackground = Color3.fromRGB(16, 22, 36),
        SearchText = Color3.fromRGB(180, 210, 240),
        SearchPlaceholder = Color3.fromRGB(80, 110, 140),
        ScrollbarBackground = Color3.fromRGB(22, 30, 48),
        ScrollbarThumb = Color3.fromRGB(40, 60, 90),
        Accent = Color3.fromRGB(30, 150, 220),
        Error = Color3.fromRGB(255, 70, 70),
        Success = Color3.fromRGB(40, 200, 120),
        Warning = Color3.fromRGB(255, 200, 50),
    },
    ["Neon Genesis"] = {
        Name = "Neon Genesis",
        IsDark = true,
        WindowBackground = Color3.fromRGB(10, 8, 18),
        WindowBorder = Color3.fromRGB(50, 20, 100),
        WindowTitleBackground = Color3.fromRGB(16, 12, 28),
        WindowTitleText = Color3.fromRGB(200, 160, 255),
        WindowShadow = Color3.fromRGB(0, 0, 0),
        TabBackground = Color3.fromRGB(13, 10, 24),
        TabSelectedBackground = Color3.fromRGB(140, 40, 255),
        TabSelectedText = Color3.fromRGB(255, 255, 255),
        TabUnselectedText = Color3.fromRGB(130, 100, 180),
        TabHoverBackground = Color3.fromRGB(30, 20, 50),
        SectionBackground = Color3.fromRGB(16, 12, 30),
        SectionBorder = Color3.fromRGB(45, 25, 80),
        SectionTitle = Color3.fromRGB(170, 140, 220),
        ButtonBackground = Color3.fromRGB(140, 40, 255),
        ButtonBackgroundHover = Color3.fromRGB(160, 70, 255),
        ButtonText = Color3.fromRGB(255, 255, 255),
        ToggleEnabled = Color3.fromRGB(140, 40, 255),
        ToggleDisabled = Color3.fromRGB(40, 30, 55),
        ToggleKnob = Color3.fromRGB(220, 190, 255),
        ToggleKnobDisabled = Color3.fromRGB(100, 80, 130),
        SliderBackground = Color3.fromRGB(35, 25, 50),
        SliderFill = Color3.fromRGB(140, 40, 255),
        SliderScrub = Color3.fromRGB(220, 190, 255),
        DropdownBackground = Color3.fromRGB(22, 16, 38),
        DropdownItemHover = Color3.fromRGB(35, 25, 55),
        DropdownText = Color3.fromRGB(190, 170, 230),
        TextBoxBackground = Color3.fromRGB(22, 16, 38),
        TextBoxText = Color3.fromRGB(210, 190, 250),
        TextBoxPlaceholder = Color3.fromRGB(90, 70, 130),
        LabelText = Color3.fromRGB(180, 160, 220),
        ParagraphText = Color3.fromRGB(150, 130, 190),
        KeybindBackground = Color3.fromRGB(28, 20, 48),
        KeybindText = Color3.fromRGB(190, 170, 230),
        ColorPickerBackground = Color3.fromRGB(24, 18, 40),
        ColorPickerBorder = Color3.fromRGB(55, 30, 90),
        NotificationBackground = Color3.fromRGB(18, 14, 34),
        NotificationBorder = Color3.fromRGB(50, 25, 90),
        NotificationTitle = Color3.fromRGB(210, 190, 250),
        NotificationDesc = Color3.fromRGB(160, 140, 200),
        SearchBackground = Color3.fromRGB(16, 12, 30),
        SearchText = Color3.fromRGB(190, 170, 230),
        SearchPlaceholder = Color3.fromRGB(90, 70, 130),
        ScrollbarBackground = Color3.fromRGB(20, 16, 36),
        ScrollbarThumb = Color3.fromRGB(50, 30, 80),
        Accent = Color3.fromRGB(140, 40, 255),
        Error = Color3.fromRGB(255, 50, 80),
        Success = Color3.fromRGB(60, 200, 140),
        Warning = Color3.fromRGB(255, 200, 40),
    },
    ["Minimalist"] = {
        Name = "Minimalist",
        IsDark = false,
        WindowBackground = Color3.fromRGB(245, 245, 250),
        WindowBorder = Color3.fromRGB(220, 220, 230),
        WindowTitleBackground = Color3.fromRGB(235, 235, 242),
        WindowTitleText = Color3.fromRGB(40, 40, 50),
        WindowShadow = Color3.fromRGB(160, 160, 180),
        TabBackground = Color3.fromRGB(238, 238, 245),
        TabSelectedBackground = Color3.fromRGB(60, 60, 70),
        TabSelectedText = Color3.fromRGB(255, 255, 255),
        TabUnselectedText = Color3.fromRGB(120, 120, 140),
        TabHoverBackground = Color3.fromRGB(228, 228, 238),
        SectionBackground = Color3.fromRGB(250, 250, 255),
        SectionBorder = Color3.fromRGB(228, 228, 238),
        SectionTitle = Color3.fromRGB(80, 80, 100),
        ButtonBackground = Color3.fromRGB(60, 60, 70),
        ButtonBackgroundHover = Color3.fromRGB(80, 80, 95),
        ButtonText = Color3.fromRGB(255, 255, 255),
        ToggleEnabled = Color3.fromRGB(60, 60, 70),
        ToggleDisabled = Color3.fromRGB(200, 200, 210),
        ToggleKnob = Color3.fromRGB(255, 255, 255),
        ToggleKnobDisabled = Color3.fromRGB(160, 160, 175),
        SliderBackground = Color3.fromRGB(220, 220, 230),
        SliderFill = Color3.fromRGB(60, 60, 70),
        SliderScrub = Color3.fromRGB(255, 255, 255),
        DropdownBackground = Color3.fromRGB(240, 240, 248),
        DropdownItemHover = Color3.fromRGB(230, 230, 240),
        DropdownText = Color3.fromRGB(60, 60, 80),
        TextBoxBackground = Color3.fromRGB(240, 240, 248),
        TextBoxText = Color3.fromRGB(40, 40, 55),
        TextBoxPlaceholder = Color3.fromRGB(160, 160, 175),
        LabelText = Color3.fromRGB(80, 80, 100),
        ParagraphText = Color3.fromRGB(120, 120, 140),
        KeybindBackground = Color3.fromRGB(235, 235, 242),
        KeybindText = Color3.fromRGB(60, 60, 80),
        ColorPickerBackground = Color3.fromRGB(240, 240, 248),
        ColorPickerBorder = Color3.fromRGB(220, 220, 230),
        NotificationBackground = Color3.fromRGB(250, 250, 255),
        NotificationBorder = Color3.fromRGB(228, 228, 238),
        NotificationTitle = Color3.fromRGB(40, 40, 55),
        NotificationDesc = Color3.fromRGB(100, 100, 120),
        SearchBackground = Color3.fromRGB(240, 240, 248),
        SearchText = Color3.fromRGB(60, 60, 80),
        SearchPlaceholder = Color3.fromRGB(160, 160, 175),
        ScrollbarBackground = Color3.fromRGB(230, 230, 238),
        ScrollbarThumb = Color3.fromRGB(200, 200, 215),
        Accent = Color3.fromRGB(60, 60, 70),
        Error = Color3.fromRGB(200, 50, 50),
        Success = Color3.fromRGB(50, 170, 90),
        Warning = Color3.fromRGB(200, 170, 30),
    },
}

-- ============================================================================
-- UTILITY FUNCTIONS
-- ============================================================================

local Utility = {}

-- Create a UI object with common properties
function Utility:Create(className, properties)
    local obj = Instance.new(className)
    for prop, val in pairs(properties or {}) do
        obj[prop] = val
    end
    return obj
end

-- Apply rounded corners
function Utility:Round(obj, radius)
    local c = self:Create("UICorner", {CornerRadius = UDim.new(0, radius)})
    c.Parent = obj
    return c
end

-- Apply stroke/border
function Utility:Stroke(obj, color, thickness)
    local s = self:Create("UIStroke", {
        Color = color or Color3.fromRGB(40, 40, 50),
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    })
    s.Parent = obj
    return s
end

-- Apply gradient
function Utility:Gradient(obj, color1, color2, rotation)
    local g = self:Create("UIGradient", {
        Color = ColorSequence.new(color1 or Color3.new(1, 1, 1), color2 or Color3.new(0, 0, 0)),
        Rotation = rotation or 45,
    })
    g.Parent = obj
    return g
end

-- Create padding
function Utility:Pad(obj, pad)
    local p = self:Create("UIPadding", {
        PaddingTop = UDim.new(0, pad or 4),
        PaddingBottom = UDim.new(0, pad or 4),
        PaddingLeft = UDim.new(0, pad or 4),
        PaddingRight = UDim.new(0, pad or 4),
    })
    p.Parent = obj
    return p
end

-- Create a list layout
function Utility:ListLayout(obj, padding)
    local l = self:Create("UIListLayout", {
        Padding = UDim.new(0, padding or 6),
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    l.Parent = obj
    return l
end

-- Tween an object
function Utility:Tween(obj, info, props)
    local tInfo = TweenInfo.new(
        info.Time or 0.25,
        info.EasingStyle or Enum.EasingStyle.Quart,
        info.EasingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(obj, tInfo, props)
    tween:Play()
    return tween
end

-- Create a shadow (multiple frames with decreasing opacity)
function Utility:Shadow(parent, size, color, transparency, layers)
    layers = layers or 4
    local shadows = {}
    for i = 1, layers do
        local shadow = self:Create("Frame", {
            Size = size,
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = color or Color3.new(0, 0, 0),
            BackgroundTransparency = (transparency or 0.6) + (i * 0.08),
            BorderSizePixel = 0,
            ZIndex = parent.ZIndex - layers + i - 1,
        })
        self:Round(shadow, 8)
        shadow.Parent = parent
        table.insert(shadows, shadow)
    end
    return shadows
end

-- Creates a glass-morphism effect frame
function Utility:GlassFrame(parent, size, position, color, transparency)
    local frame = self:Create("Frame", {
        Size = size or UDim2.fromScale(1, 1),
        Position = position or UDim2.fromOffset(0, 0),
        BackgroundColor3 = color or Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = transparency or 0.85,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    })
    frame.Parent = parent

    -- Add a subtle gradient overlay for depth
    local overlay = self:Create("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.95,
        BorderSizePixel = 0,
    })
    self:Gradient(overlay, Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 255, 255), 0)
    overlay.Parent = frame

    return frame
end

-- ============================================================================
-- APEX UI LIBRARY
-- ============================================================================

local ApexUI = {
    Version = "1.0.0",
    Themes = Themes,
    ActiveWindows = {},
    OpenWindows = {},
    CurrentTheme = "Dark Matter",
    CustomThemes = {},
    NotificationsEnabled = true,
    MaxNotifications = 5,
    Notifications = {},
    ToastsEnabled = true,
}

-- ============================================================================
-- NOTIFICATION SYSTEM
-- ============================================================================

function ApexUI:Notify(config)
    config = config or {}
    if not self.NotificationsEnabled then return end

    local parent = self._notificationHolder
    if not parent then
        -- Create notification holder
        parent = Utility:Create("ScreenGui", {
            Name = "ApexUINotifications",
            DisplayOrder = 100,
            IgnoreGuiInset = true,
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        })
        parent.Parent = GetParent()

        local holder = Utility:Create("Frame", {
            Name = "NotificationHolder",
            Size = UDim2.fromOffset(360, 0),
            Position = UDim2.fromScale(1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(1, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
        })
        holder.Parent = parent

        Utility:Pad(holder, 8)
        local layout = Utility:ListLayout(holder, 8)
        layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Right

        pcall(function()
            local saf = Instance.new("Folder")
            saf.Name = "SafeFrame"
            saf.Parent = parent
        end)

        self._notificationHolder = holder
        parent.DisplayOrder = 2000
        parent.ResetOnSpawn = false

        -- Enable click-through for the holder
        holder.Active = false
        holder.Selectable = false

        parent = holder
    end

    local theme = self:GetCurrentTheme()
    local duration = config.Duration or 4
    local title = config.Title or "Notification"
    local content = config.Content or ""
    local icon = config.Icon or "ℹ"

    -- Create notification frame
    local notif = Utility:Create("Frame", {
        Name = "Notification",
        Size = UDim2.fromOffset(344, 0),
        BackgroundColor3 = theme.NotificationBackground,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = -1,
    })
    Utility:Round(notif, 10)
    Utility:Stroke(notif, theme.NotificationBorder, 1)
    notif.Parent = parent

    -- Inner content frame for glass effect
    local inner = Utility:GlassFrame(notif, UDim2.fromScale(1, 1), UDim2.fromOffset(0, 0),
        theme.NotificationBackground, 0.05)
    inner.BackgroundTransparency = 0.05

    -- Icon
    local iconLabel = Utility:Create("TextLabel", {
        Name = "Icon",
        Size = UDim2.fromOffset(28, 28),
        Position = UDim2.fromOffset(12, 12),
        BackgroundTransparency = 1,
        Text = icon,
        TextColor3 = theme.Accent,
        TextSize = 18,
        Font = Enum.Font.GothamBold,
        RichText = true,
    })
    iconLabel.Parent = notif

    -- Title
    local titleLabel = Utility:Create("TextLabel", {
        Name = "Title",
        Size = UDim2.fromOffset(280, 20),
        Position = UDim2.fromOffset(48, 12),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = theme.NotificationTitle,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        RichText = true,
    })
    titleLabel.Parent = notif

    -- Close button
    local closeBtn = Utility:Create("TextButton", {
        Name = "CloseButton",
        Size = UDim2.fromOffset(20, 20),
        Position = UDim2.fromOffset(320, 12),
        BackgroundTransparency = 1,
        Text = "✕",
        TextColor3 = theme.LabelText,
        TextSize = 14,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
    })
    closeBtn.Parent = notif

    -- Description
    local desc = Utility:Create("TextLabel", {
        Name = "Description",
        Size = UDim2.fromOffset(304, 0),
        Position = UDim2.fromOffset(12, 38),
        BackgroundTransparency = 1,
        Text = content,
        TextColor3 = theme.NotificationDesc,
        TextSize = 13,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        RichText = true,
        AutomaticSize = Enum.AutomaticSize.Y,
        TextWrapped = true,
    })
    desc.Parent = notif

    -- Calculate total height
    local descHeight = math.max(20, desc.TextBounds.Y)
    local totalHeight = 38 + descHeight + 12
    desc.Size = UDim2.fromOffset(304, descHeight)

    -- Animate in
    notif.Size = UDim2.fromOffset(344, totalHeight)
    notif.BackgroundTransparency = 1

    Utility:Tween(notif, {Time = 0.3}, {
        BackgroundTransparency = 0,
    })

    -- Slide in animation
    notif.Position = UDim2.fromOffset(400, 0)
    local slideTween = Utility:Tween(notif, {Time = 0.4, EasingStyle = Enum.EasingStyle.Quint}, {
        Position = UDim2.fromOffset(0, 0),
    })

    -- Close button callback
    closeBtn.MouseButton1Click:Connect(function()
        closeNotif(notif)
    end)

    -- Auto-close timer
    local closeNotif = function(target)
        target = target or notif
        local tween = Utility:Tween(target, {Time = 0.3, EasingStyle = Enum.EasingStyle.Quint}, {
            BackgroundTransparency = 1,
        })
        Utility:Tween(target, {Time = 0.25}, {
            Position = UDim2.fromOffset(400, 0),
        })
        tween.Completed:Wait()
        target:Destroy()
    end

    if duration > 0 then
        task.delay(duration, function()
            if notif and notif.Parent then
                closeNotif(notif)
            end
        end)
    end

    return notif, closeNotif
end

-- Toast notification (smaller, bottom-right)
function ApexUI:Toast(text, duration, icon)
    duration = duration or 2.5
    icon = icon or "✓"

    local parent = self._toastHolder
    if not parent then
        local gui = Utility:Create("ScreenGui", {
            Name = "ApexUIToasts",
            DisplayOrder = 200,
            IgnoreGuiInset = true,
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        })
        gui.Parent = GetParent()

        parent = Utility:Create("Frame", {
            Name = "ToastHolder",
            Size = UDim2.fromOffset(300, 0),
            Position = UDim2.new(0.5, 0, 1, -20),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            AnchorPoint = Vector2.new(0.5, 1),
            AutomaticSize = Enum.AutomaticSize.Y,
        })
        parent.Parent = gui

        local layout = Utility:ListLayout(parent, 6)
        layout.VerticalAlignment = Enum.VerticalAlignment.Bottom

        self._toastHolder = parent
    end

    local theme = self:GetCurrentTheme()

    local toast = Utility:Create("Frame", {
        Name = "Toast",
        Size = UDim2.fromOffset(0, 32),
        BackgroundColor3 = theme.NotificationBackground,
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        AutomaticSize = Enum.AutomaticSize.X,
    })
    Utility:Round(toast, 8)
    Utility:Stroke(toast, theme.NotificationBorder, 1)
    toast.Parent = parent

    local minSize = 120

    -- Icon
    if icon then
        local iconLbl = Utility:Create("TextLabel", {
            Size = UDim2.fromOffset(20, 20),
            Position = UDim2.fromOffset(8, 6),
            BackgroundTransparency = 1,
            Text = icon,
            TextColor3 = theme.Success,
            TextSize = 13,
            Font = Enum.Font.GothamBold,
        })
        iconLbl.Parent = toast

        local textLbl = Utility:Create("TextLabel", {
            Size = UDim2.fromOffset(0, 20),
            Position = UDim2.fromOffset(32, 6),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = theme.NotificationTitle,
            TextSize = 13,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutomaticSize = Enum.AutomaticSize.X,
        })
        textLbl.Parent = toast
        minSize = 32 + textLbl.TextBounds.X + 16
    else
        local textLbl = Utility:Create("TextLabel", {
            Size = UDim2.fromOffset(0, 20),
            Position = UDim2.fromOffset(12, 6),
            BackgroundTransparency = 1,
            Text = text,
            TextColor3 = theme.NotificationTitle,
            TextSize = 13,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutomaticSize = Enum.AutomaticSize.X,
        })
        textLbl.Parent = toast
        minSize = 12 + textLbl.TextBounds.X + 12
    end

    toast.Size = UDim2.fromOffset(math.max(minSize, 120), 32)

    -- Animate in
    toast.Size = UDim2.fromOffset(math.max(minSize, 120), 0)
    toast.BackgroundTransparency = 1
    local tween = Utility:Tween(toast, {Time = 0.25}, {
        Size = UDim2.fromOffset(math.max(minSize, 120), 32),
        BackgroundTransparency = 0.15,
    })

    task.delay(duration, function()
        if toast and toast.Parent then
            local t = Utility:Tween(toast, {Time = 0.2}, {
                Size = UDim2.fromOffset(math.max(minSize, 120), 0),
                BackgroundTransparency = 1,
            })
            t.Completed:Wait()
            pcall(function() toast:Destroy() end)
        end
    end)
end

-- ============================================================================
-- THEME MANAGEMENT
-- ============================================================================

function ApexUI:GetCurrentTheme()
    local theme = self.Themes[self.CurrentTheme]
    if not theme then
        -- Fallback
        for _, t in pairs(self.Themes) do
            theme = t
            break
        end
    end
    return theme or self.Themes["Dark Matter"]
end

function ApexUI:SetTheme(themeName)
    if self.Themes[themeName] then
        self.CurrentTheme = themeName
        -- Update all active windows
        for _, windowData in pairs(self.ActiveWindows) do
            if windowData.UpdateTheme then
                windowData:UpdateTheme()
            end
        end
        return true
    end
    return false
end

function ApexUI:CreateCustomTheme(name, colors)
    if not name or type(name) ~= "string" then return false end
    colors = colors or {}
    colors.Name = name
    colors.IsDark = colors.IsDark ~= false
    self.Themes[name] = colors
    self.CustomThemes[name] = true
    return true
end

function ApexUI:GetThemes()
    local list = {}
    for name in pairs(self.Themes) do
        table.insert(list, name)
    end
    return list
end

-- ============================================================================
-- MAIN WINDOW CREATION
-- ============================================================================

function ApexUI:CreateWindow(config)
    config = config or {}

    -- Default config
    local windowConfig = {
        Name = config.Name or "ApexUI",
        Icon = config.Icon or "rbxassetid://0",
        Theme = config.Theme or self.CurrentTheme,
        Size = config.Size or UDim2.fromOffset(680, 500),
        Position = config.Position or UDim2.new(0.5, -340, 0.5, -250),
        MinSize = config.MinSize or Vector2.new(480, 350),
        ToggleKey = config.ToggleKey or Enum.KeyCode.RightControl,
        ShowNotifications = config.ShowNotifications ~= false,
        ShowSearch = config.ShowSearch ~= false,
        Transparency = config.Transparency or 0,
        TitlebarGradient = config.TitlebarGradient or false,
        AnimationStyle = config.AnimationStyle or "Slide", -- Slide, Fade, Scale
        AccentColor = config.AccentColor or nil, -- Override accent
        Resizable = config.Resizable ~= false,
        Draggable = config.Draggable ~= false,
        OnClose = config.OnClose or nil,
    }

    if config.Theme then
        self.CurrentTheme = config.Theme
    end

    local theme = self:GetCurrentTheme()

    -- ========================================================================
    -- CREATE MAIN SCREEN GUI
    -- ========================================================================

    local gui = Utility:Create("ScreenGui", {
        Name = "ApexUI_" .. config.Name:gsub("%s+", "_"),
        DisplayOrder = 10,
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    gui.Parent = GetParent()

    -- Try to protect GUI
    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(gui)
        end
        if gethui then
            gui.Parent = gethui()
        end
    end)

    -- ========================================================================
    -- CREATE MAIN WINDOW FRAME
    -- ========================================================================

    local window = Utility:Create("Frame", {
        Name = "Window",
        Size = windowConfig.Size,
        Position = windowConfig.Position,
        BackgroundColor3 = theme.WindowBackground,
        BackgroundTransparency = windowConfig.Transparency,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    })
    Utility:Round(window, 10)
    Utility:Stroke(window, theme.WindowBorder, 1.5)
    window.Parent = gui

    -- Shadow system
    local shadowFrame = Utility:Create("Frame", {
        Name = "Shadow",
        Size = UDim2.new(1, 20, 1, 20),
        Position = UDim2.fromOffset(-10, -10),
        BackgroundColor3 = theme.WindowShadow,
        BackgroundTransparency = 0.75,
        BorderSizePixel = 0,
        ZIndex = 0,
    })
    Utility:Round(shadowFrame, 14)
    shadowFrame.Parent = window
    shadowFrame.ZIndex = -1

    -- Glass overlay
    local glassOverlay = Utility:GlassFrame(window, UDim2.fromScale(1, 1), UDim2.fromOffset(0, 0),
        theme.WindowBackground, 0.92 + (windowConfig.Transparency / 10))
    glassOverlay.ZIndex = 1

    -- ========================================================================
    -- TITLE BAR
    -- ========================================================================

    local titleBar = Utility:Create("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 42),
        Position = UDim2.fromOffset(0, 0),
        BackgroundColor3 = theme.WindowTitleBackground,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        ZIndex = 2,
    })
    Utility:Round(titleBar, 10)
    -- Only round top corners
    local titleCorner = Utility:Create("UICorner", {CornerRadius = UDim.new(0, 10)})
    titleCorner.Parent = titleBar

    -- Gradient on titlebar
    if windowConfig.TitlebarGradient then
        local titleGrad = Utility:Gradient(titleBar, theme.WindowTitleBackground, theme.Accent, 0)
    end

    titleBar.Parent = window

    -- Title bar drag detection
    local dragging = false
    local dragStart = Vector2.new(0, 0)
    local windowStartPos = UDim2.new(0, 0, 0, 0)

    if windowConfig.Draggable then
        titleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or
               input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = UserInputService:GetMouseLocation()
                windowStartPos = window.Position
            end
        end)
    end

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or
                         input.UserInputType == Enum.UserInputType.Touch) then
            local delta = UserInputService:GetMouseLocation() - dragStart
            local newPos = UDim2.fromOffset(windowStartPos.X.Offset + delta.X, windowStartPos.Y.Offset + delta.Y)
            window.Position = newPos
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- Window Icon
    local icon = Utility:Create("ImageLabel", {
        Name = "Icon",
        Size = UDim2.fromOffset(20, 20),
        Position = UDim2.fromOffset(14, 11),
        BackgroundTransparency = 1,
        Image = windowConfig.Icon,
        ImageColor3 = theme.Accent,
        ZIndex = 3,
        ScaleType = Enum.ScaleType.Fit,
    })
    icon.Parent = titleBar

    -- Window Title
    local titleLabel = Utility:Create("TextLabel", {
        Name = "Title",
        Size = UDim2.fromOffset(0, 20),
        Position = UDim2.fromOffset(42, 11),
        BackgroundTransparency = 1,
        Text = "  " .. config.Name,
        TextColor3 = theme.WindowTitleText,
        TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 3,
        RichText = true,
    })
    titleLabel.Parent = titleBar
    titleLabel.Size = UDim2.fromOffset(math.min(titleLabel.TextBounds.X + 8, 300), 20)

    -- Window buttons (minimize, close)
    local btnSize = 18
    local btnY = 12

    -- Close button
    local closeBtn = Utility:Create("TextButton", {
        Name = "CloseButton",
        Size = UDim2.fromOffset(btnSize, btnSize),
        Position = UDim2.new(1, -(btnSize + 10), 0, btnY),
        BackgroundColor3 = Color3.fromRGB(255, 70, 70),
        BackgroundTransparency = 0,
        Text = "✕",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        ZIndex = 4,
    })
    Utility:Round(closeBtn, btnSize / 2)
    closeBtn.Parent = titleBar

    -- Minimize button
    local minBtn = Utility:Create("TextButton", {
        Name = "MinimizeButton",
        Size = UDim2.fromOffset(btnSize, btnSize),
        Position = UDim2.new(1, -(btnSize * 2 + 16), 0, btnY),
        BackgroundColor3 = Color3.fromRGB(255, 180, 40),
        BackgroundTransparency = 0,
        Text = "─",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 10,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        ZIndex = 4,
    })
    Utility:Round(minBtn, btnSize / 2)
    minBtn.Parent = titleBar

    -- ========================================================================
    -- SEARCH BAR (under title bar)
    -- ========================================================================

    local searchBar = nil
    local searchFrame = nil

    if windowConfig.ShowSearch then
        searchFrame = Utility:Create("Frame", {
            Name = "SearchFrame",
            Size = UDim2.new(1, -24, 0, 32),
            Position = UDim2.fromOffset(12, 48),
            BackgroundColor3 = theme.SearchBackground,
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            ZIndex = 2,
        })
        Utility:Round(searchFrame, 8)
        Utility:Stroke(searchFrame, theme.SectionBorder, 1)
        searchFrame.Parent = window

        local searchIcon = Utility:Create("TextLabel", {
            Size = UDim2.fromOffset(16, 16),
            Position = UDim2.fromOffset(10, 8),
            BackgroundTransparency = 1,
            Text = "⌕",
            TextColor3 = theme.SearchPlaceholder,
            TextSize = 16,
            Font = Enum.Font.GothamBold,
            ZIndex = 3,
        })
        searchIcon.Parent = searchFrame

        searchBar = Utility:Create("TextBox", {
            Name = "SearchBar",
            Size = UDim2.new(1, -36, 1, 0),
            Position = UDim2.fromOffset(30, 0),
            BackgroundTransparency = 1,
            PlaceholderText = "Search settings across all tabs...",
            PlaceholderColor3 = theme.SearchPlaceholder,
            Text = "",
            TextColor3 = theme.SearchText,
            TextSize = 13,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 3,
            ClearTextOnFocus = false,
        })
        searchBar.Parent = searchFrame
    end

    -- ========================================================================
    -- TAB BAR
    -- ========================================================================

    local tabBarY = windowConfig.ShowSearch and 88 or 50

    local tabBar = Utility:Create("Frame", {
        Name = "TabBar",
        Size = UDim2.new(1, 0, 0, 32),
        Position = UDim2.fromOffset(0, tabBarY - 4),
        BackgroundColor3 = theme.TabBackground,
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        ZIndex = 2,
    })
    tabBar.Parent = window

    -- Tab bar bottom line
    local tabLine = Utility:Create("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = theme.TabBackground,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        ZIndex = 2,
    })
    tabLine.Parent = tabBar

    -- Tab container
    local tabContainer = Utility:Create("Frame", {
        Name = "TabContainer",
        Size = UDim2.new(1, -16, 1, 0),
        Position = UDim2.fromOffset(8, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 3,
        ClipsDescendants = true,
    })
    tabContainer.Parent = tabBar

    -- Tab layout
    local tabLayout = Utility:Create("UIListLayout", {
        Padding = UDim.new(0, 4),
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    tabLayout.Parent = tabContainer

    -- ========================================================================
    -- MAIN CONTENT AREA
    -- ========================================================================

    local contentArea = Utility:Create("Frame", {
        Name = "ContentArea",
        Size = UDim2.new(1, -16, 1, -(tabBarY + 30)),
        Position = UDim2.fromOffset(8, tabBarY + 28),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 2,
        ClipsDescendants = true,
    })
    contentArea.Parent = window

    -- Content container (with scrolling)
    local scrollingContainer = Utility:Create("ScrollingFrame", {
        Name = "ScrollingContainer",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 6,
        ScrollBarBackgroundColor3 = theme.ScrollbarBackground,
        ScrollBarImageColor3 = theme.ScrollbarThumb,
        CanvasSize = UDim2.fromOffset(0, 0),
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ZIndex = 3,
        BottomImage = "rbxasset://textures/ui/Scroll/scroll-bottom.png",
        MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
        TopImage = "rbxasset://textures/ui/Scroll/scroll-top.png",
        ScrollBarImageTransparency = 0.4,
        ElasticBehavior = Enum.ElasticBehavior.Always,
    })
    scrollingContainer.Parent = contentArea

    -- Scrolling container padding
    Utility:Pad(scrollingContainer, 10)

    -- ========================================================================
    -- WINDOW DATA / METHODS
    -- ========================================================================

    local windowData = {
        GUI = gui,
        Window = window,
        TitleBar = titleBar,
        SearchBar = searchBar,
        SearchFrame = searchFrame,
        TabBar = tabBar,
        TabContainer = tabContainer,
        ContentArea = contentArea,
        ScrollingContainer = scrollingContainer,
        Config = windowConfig,
        Tabs = {},
        ActiveTab = nil,
        IsOpen = true,
        Minimized = false,
        PreviousSize = window.Size,
        PreviousPosition = window.Position,
    }

    -- Tab methods
    function windowData:AddTab(name, icon)
        icon = icon or ""

        -- Create tab button
        local tabBtn = Utility:Create("TextButton", {
            Name = "Tab_" .. name:gsub("%s+", "_"),
            Size = UDim2.fromOffset(0, 24),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 4,
            LayoutOrder = #self.Tabs + 1,
            ClipsDescendants = true,
        })
        tabBtn.Parent = self.TabContainer

        -- Tab icon
        local tabIcon = nil
        if icon ~= "" then
            tabIcon = Utility:Create("TextLabel", {
                Size = UDim2.fromOffset(16, 16),
                Position = UDim2.fromOffset(10, 4),
                BackgroundTransparency = 1,
                Text = icon,
                TextColor3 = theme.TabUnselectedText,
                TextSize = 14,
                Font = Enum.Font.GothamBold,
                ZIndex = 5,
            })
            tabIcon.Parent = tabBtn
        end

        local iconOffset = icon ~= "" and 28 or 8

        -- Tab label
        local tabLabel = Utility:Create("TextLabel", {
            Size = UDim2.fromOffset(0, 20),
            Position = UDim2.fromOffset(iconOffset, 2),
            BackgroundTransparency = 1,
            Text = "  " .. name .. "  ",
            TextColor3 = theme.TabUnselectedText,
            TextSize = 13,
            Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 5,
            AutomaticSize = Enum.AutomaticSize.X,
        })
        tabLabel.Parent = tabBtn

        tabBtn.Size = UDim2.fromOffset(tabLabel.TextBounds.X + iconOffset + 8, 24)

        -- Create tab content page (stored in scrolling container)
        local tabPage = Utility:Create("Frame", {
            Name = name .. "_Page",
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 3,
            Visible = false,
        })
        tabPage.Parent = self.ScrollingContainer

        -- Tab page layout
        local pageLayout = Utility:Create("UIListLayout", {
            Padding = UDim.new(0, 10),
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Top,
            SortOrder = Enum.SortOrder.LayoutOrder,
        })
        pageLayout.Parent = tabPage

        -- Page padding
        Utility:Pad(tabPage, 4)

        -- Section storage
        local tabInfo = {
            Name = name,
            Icon = icon,
            Button = tabBtn,
            Label = tabLabel,
            IconLabel = tabIcon,
            Page = tabPage,
            Layout = pageLayout,
            Sections = {},
            SectionCount = 0,
        }

        -- Tab selection
        tabBtn.MouseButton1Click:Connect(function()
            self:SelectTab(name)
        end)

        -- Hover effects
        tabBtn.MouseEnter:Connect(function()
            if self.ActiveTab ~= name then
                Utility:Tween(tabLabel, {Time = 0.15}, {TextColor3 = theme.WindowTitleText})
                if tabIcon then
                    Utility:Tween(tabIcon, {Time = 0.15}, {TextColor3 = theme.WindowTitleText})
                end
            end
        end)

        tabBtn.MouseLeave:Connect(function()
            if self.ActiveTab ~= name then
                Utility:Tween(tabLabel, {Time = 0.2}, {TextColor3 = theme.TabUnselectedText})
                if tabIcon then
                    Utility:Tween(tabIcon, {Time = 0.2}, {TextColor3 = theme.TabUnselectedText})
                end
            end
        end)

        -- Add to storage
        table.insert(self.Tabs, tabInfo)

        -- Helper: Add a section/groupbox to this tab
        function tabInfo:AddSection(sectionName, side)
            side = side or "Left"
            local isLeft = side == "Left"

            -- Create section container
            local section = Utility:Create("Frame", {
                Name = sectionName .. "_Section",
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = theme.SectionBackground,
                BackgroundTransparency = 0,
                BorderSizePixel = 0,
                ZIndex = 3,
                LayoutOrder = tabInfo.SectionCount,
                ClipsDescendants = true,
            })
            Utility:Round(section, 10)
            Utility:Stroke(section, theme.SectionBorder, 1)
            section.Parent = tabInfo.Page

            -- Section title bar
            local sectionHeader = Utility:Create("Frame", {
                Name = "SectionHeader",
                Size = UDim2.new(1, 0, 0, 32),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BackgroundTransparency = 0.97,
                BorderSizePixel = 0,
                ZIndex = 4,
            })
            Utility:Round(sectionHeader, 10)
            sectionHeader.Parent = section

            -- Only round top corners of header
            local headerCorner = Utility:Create("UICorner", {CornerRadius = UDim.new(0, 10)})
            headerCorner.Parent = sectionHeader

            -- Section title label
            local sectionTitle = Utility:Create("TextLabel", {
                Size = UDim2.fromOffset(0, 20),
                Position = UDim2.fromOffset(14, 6),
                BackgroundTransparency = 1,
                Text = "  " .. sectionName,
                TextColor3 = theme.SectionTitle,
                TextSize = 13,
                Font = Enum.Font.GothamBold,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 5,
                RichText = true,
                AutomaticSize = Enum.AutomaticSize.X,
            })
            sectionTitle.Parent = sectionHeader

            -- Section content container
            local sectionContent = Utility:Create("Frame", {
                Name = "SectionContent",
                Size = UDim2.new(1, -20, 0, 0),
                Position = UDim2.fromOffset(10, 36),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ZIndex = 4,
                AutomaticSize = Enum.AutomaticSize.Y,
            })
            sectionContent.Parent = section

            -- Content layout
            local contentLayout = Utility:Create("UIListLayout", {
                Padding = UDim.new(0, 6),
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Top,
                SortOrder = Enum.SortOrder.LayoutOrder,
            })
            contentLayout.Parent = sectionContent

            -- Section data
            local sectionData = {
                Name = sectionName,
                Side = side,
                Frame = section,
                Header = sectionHeader,
                Title = sectionTitle,
                Content = sectionContent,
                Layout = contentLayout,
                Elements = {},
                IsCollapsed = false,
            }

            -- Make header clickable for collapse
            sectionHeader.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    sectionData.IsCollapsed = not sectionData.IsCollapsed
                    if sectionData.IsCollapsed then
                        sectionContent.Visible = false
                        section.Size = UDim2.new(1, 0, 0, 36)
                    else
                        sectionContent.Visible = true
                        section.Size = UDim2.new(1, 0, 0, sectionContent.AbsoluteSize.Y + 44)
                    end
                end
            end)

            -- Add to storage
            table.insert(tabInfo.Sections, sectionData)
            tabInfo.SectionCount = tabInfo.SectionCount + 1

            -- Update canvas size
            local function updateCanvas()
                local totalH = 0
                for _, child in ipairs(tabInfo.Page:GetChildren()) do
                    if child:IsA("Frame") then
                        totalH = totalH + child.AbsoluteSize.Y + 10
                    end
                end
                self.ScrollingContainer.CanvasSize = UDim2.fromOffset(0, totalH + 20)
            end

            -- Update on content change
            local conn = contentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                local newH = contentLayout.AbsoluteContentSize.Y + 44
                if newH > 40 then
                    Utility:Tween(section, {Time = 0.15}, {Size = UDim2.new(1, 0, 0, newH)})
                end
                updateCanvas()
            end)

            -- ================================================================
            -- SECTION ELEMENT CREATION METHODS
            -- ================================================================

            -- BUTTON
            function sectionData:AddButton(elementConfig)
                elementConfig = elementConfig or {}
                local btnName = elementConfig.Name or "Button"
                local desc = elementConfig.Description or ""
                local callback = elementConfig.Callback or function() end

                local btnFrame = Utility:Create("Frame", {
                    Name = btnName .. "_Btn",
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = theme.ButtonBackground,
                    BackgroundTransparency = 0,
                    BorderSizePixel = 0,
                    ZIndex = 4,
                    LayoutOrder = #sectionData.Elements + 1,
                })
                Utility:Round(btnFrame, 8)
                btnFrame.Parent = sectionContent

                local btnInner = Utility:Create("TextButton", {
                    Size = UDim2.fromScale(1, 1),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false,
                    ZIndex = 5,
                })
                btnInner.Parent = btnFrame

                -- Button text
                local btnText = Utility:Create("TextLabel", {
                    Size = UDim2.fromOffset(0, 20),
                    Position = UDim2.fromOffset(12, 7),
                    BackgroundTransparency = 1,
                    Text = "  " .. btnName,
                    TextColor3 = theme.ButtonText,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 6,
                    AutomaticSize = Enum.AutomaticSize.X,
                })
                btnText.Parent = btnFrame

                -- Description tooltip (small text on right)
                if desc ~= "" then
                    local descText = Utility:Create("TextLabel", {
                        Size = UDim2.fromOffset(0, 16),
                        Position = UDim2.new(1, -12, 0, 9),
                        AnchorPoint = Vector2.new(1, 0),
                        BackgroundTransparency = 1,
                        Text = desc,
                        TextColor3 = theme.LabelText,
                        TextSize = 11,
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Right,
                        ZIndex = 6,
                        AutomaticSize = Enum.AutomaticSize.X,
                        TextTruncate = Enum.TextTruncate.AtEnd,
                        MaxVisibleWidth = 200,
                    })
                    descText.Parent = btnFrame
                end

                -- Hover effects
                btnInner.MouseEnter:Connect(function()
                    Utility:Tween(btnFrame, {Time = 0.15}, {
                        BackgroundColor3 = theme.ButtonBackgroundHover,
                    })
                end)

                btnInner.MouseLeave:Connect(function()
                    Utility:Tween(btnFrame, {Time = 0.2}, {
                        BackgroundColor3 = theme.ButtonBackground,
                    })
                end)

                -- Click effect
                btnInner.MouseButton1Click:Connect(function()
                    -- Ripple effect
                    local ripple = Utility:Create("Frame", {
                        Size = UDim2.fromOffset(0, 0),
                        Position = UDim2.fromScale(0.5, 0.5),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BackgroundTransparency = 0.7,
                        BorderSizePixel = 0,
                        ZIndex = 7,
                    })
                    Utility:Round(ripple, 30)
                    ripple.Parent = btnFrame
                    Utility:Tween(ripple, {Time = 0.3}, {
                        Size = UDim2.fromOffset(200, 200),
                        BackgroundTransparency = 1,
                    })
                    task.delay(0.35, function()
                        pcall(function() ripple:Destroy() end)
                    end)

                    local s, e = pcall(callback)
                    if not s then
                        warn("[ApexUI] Button callback error:", e)
                    end
                end)

                table.insert(sectionData.Elements, {
                    Type = "Button",
                    Name = btnName,
                    Frame = btnFrame,
                })

                return btnFrame
            end

            -- TOGGLE
            function sectionData:AddToggle(elementConfig)
                elementConfig = elementConfig or {}
                local toggleName = elementConfig.Name or "Toggle"
                local desc = elementConfig.Description or ""
                local defaultState = elementConfig.Default or false
                local callback = elementConfig.Callback or function() end

                local toggleFrame = Utility:Create("Frame", {
                    Name = toggleName .. "_Toggle",
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = theme.SectionBackground,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ZIndex = 4,
                    LayoutOrder = #sectionData.Elements + 1,
                })
                toggleFrame.Parent = sectionContent

                -- Toggle label
                local toggleLabel = Utility:Create("TextLabel", {
                    Size = UDim2.fromOffset(0, 20),
                    Position = UDim2.fromOffset(4, 7),
                    BackgroundTransparency = 1,
                    Text = "  " .. toggleName,
                    TextColor3 = theme.LabelText,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 5,
                    RichText = true,
                    AutomaticSize = Enum.AutomaticSize.X,
                })
                toggleLabel.Parent = toggleFrame

                -- Description
                if desc ~= "" then
                    local descLbl = Utility:Create("TextLabel", {
                        Size = UDim2.fromOffset(0, 14),
                        Position = UDim2.fromOffset(6, 2),
                        BackgroundTransparency = 1,
                        Text = desc,
                        TextColor3 = theme.ParagraphText,
                        TextSize = 10,
                        Font = Enum.Font.Gotham,
                        TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 5,
                        RichText = true,
                    })
                    descLbl.Parent = toggleLabel
                end

                -- Toggle background
                local toggleBg = Utility:Create("Frame", {
                    Name = "ToggleBg",
                    Size = UDim2.fromOffset(42, 22),
                    Position = UDim2.new(1, -4, 0, 6),
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundColor3 = defaultState and theme.ToggleEnabled or theme.ToggleDisabled,
                    BackgroundTransparency = 0,
                    BorderSizePixel = 0,
                    ZIndex = 5,
                })
                Utility:Round(toggleBg, 11)
                toggleBg.Parent = toggleFrame

                -- Toggle knob
                local toggleKnob = Utility:Create("Frame", {
                    Name = "ToggleKnob",
                    Size = UDim2.fromOffset(18, 18),
                    Position = UDim2.fromOffset(defaultState and 22 or 2, 2),
                    BackgroundColor3 = defaultState and theme.ToggleKnob or theme.ToggleKnobDisabled,
                    BackgroundTransparency = 0,
                    BorderSizePixel = 0,
                    ZIndex = 6,
                })
                Utility:Round(toggleKnob, 9)
                toggleKnob.Parent = toggleBg

                -- Click detector
                local clickBtn = Utility:Create("TextButton", {
                    Size = UDim2.fromScale(1, 1),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false,
                    ZIndex = 7,
                })
                clickBtn.Parent = toggleFrame

                -- State
                local toggled = defaultState

                local function setState(newState)
                    toggled = newState
                    if toggled then
                        Utility:Tween(toggleBg, {Time = 0.2, EasingStyle = Enum.EasingStyle.Back}, {
                            BackgroundColor3 = theme.ToggleEnabled,
                        })
                        Utility:Tween(toggleKnob, {Time = 0.2, EasingStyle = Enum.EasingStyle.Back}, {
                            Position = UDim2.fromOffset(22, 2),
                            BackgroundColor3 = theme.ToggleKnob,
                        })
                    else
                        Utility:Tween(toggleBg, {Time = 0.2, EasingStyle = Enum.EasingStyle.Back}, {
                            BackgroundColor3 = theme.ToggleDisabled,
                        })
                        Utility:Tween(toggleKnob, {Time = 0.2, EasingStyle = Enum.EasingStyle.Back}, {
                            Position = UDim2.fromOffset(2, 2),
                            BackgroundColor3 = theme.ToggleKnobDisabled,
                        })
                    end
                    local s, e = pcall(callback, toggled)
                    if not s then warn("[ApexUI] Toggle callback error:", e) end
                end

                clickBtn.MouseButton1Click:Connect(function()
                    setState(not toggled)
                end)

                table.insert(sectionData.Elements, {
                    Type = "Toggle",
                    Name = toggleName,
                    Frame = toggleFrame,
                    SetState = setState,
                    GetState = function() return toggled end,
                })

                return {
                    Frame = toggleFrame,
                    SetState = setState,
                    GetState = function() return toggled end,
                }
            end

            -- SLIDER
            function sectionData:AddSlider(elementConfig)
                elementConfig = elementConfig or {}
                local sliderName = elementConfig.Name or "Slider"
                local desc = elementConfig.Description or ""
                local minVal = elementConfig.Min or 0
                local maxVal = elementConfig.Max or 100
                local defaultVal = elementConfig.Default or minVal
                local suffix = elementConfig.Suffix or ""
                local decimals = elementConfig.Decimals or 0
                local callback = elementConfig.Callback or function() end

                local sliderFrame = Utility:Create("Frame", {
                    Name = sliderName .. "_Slider",
                    Size = UDim2.new(1, 0, 0, 44),
                    BackgroundColor3 = theme.SectionBackground,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ZIndex = 4,
                    LayoutOrder = #sectionData.Elements + 1,
                })
                sliderFrame.Parent = sectionContent

                -- Label
                local sliderLabel = Utility:Create("TextLabel", {
                    Size = UDim2.fromOffset(0, 18),
                    Position = UDim2.fromOffset(4, 2),
                    BackgroundTransparency = 1,
                    Text = "  " .. sliderName,
                    TextColor3 = theme.LabelText,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 5,
                    RichText = true,
                    AutomaticSize = Enum.AutomaticSize.X,
                })
                sliderLabel.Parent = sliderFrame

                -- Value display
                local valDisplay = Utility:Create("TextLabel", {
                    Size = UDim2.fromOffset(60, 18),
                    Position = UDim2.new(1, -4, 0, 2),
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Text = tostring(defaultVal) .. suffix,
                    TextColor3 = theme.Accent,
                    TextSize = 13,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    ZIndex = 5,
                    RichText = true,
                })
                valDisplay.Parent = sliderFrame

                -- Slider background
                local sliderBg = Utility:Create("Frame", {
                    Name = "SliderBg",
                    Size = UDim2.new(1, -16, 0, 6),
                    Position = UDim2.fromOffset(8, 28),
                    BackgroundColor3 = theme.SliderBackground,
                    BackgroundTransparency = 0,
                    BorderSizePixel = 0,
                    ZIndex = 5,
                    ClipsDescendants = true,
                })
                Utility:Round(sliderBg, 3)
                sliderBg.Parent = sliderFrame

                -- Slider fill
                local sliderFill = Utility:Create("Frame", {
                    Name = "SliderFill",
                    Size = UDim2.fromOffset(0, 6),
                    BackgroundColor3 = theme.SliderFill,
                    BackgroundTransparency = 0,
                    BorderSizePixel = 0,
                    ZIndex = 6,
                })
                Utility:Round(sliderFill, 3)
                sliderFill.Parent = sliderBg

                -- Slider scrub (knob)
                local sliderScrub = Utility:Create("Frame", {
                    Name = "SliderScrub",
                    Size = UDim2.fromOffset(14, 14),
                    Position = UDim2.fromOffset(0, 0),
                    BackgroundColor3 = theme.SliderScrub,
                    BackgroundTransparency = 0,
                    BorderSizePixel = 0,
                    ZIndex = 7,
                })
                Utility:Round(sliderScrub, 7)
                sliderScrub.Parent = sliderBg

                -- Dragging state
                local sliding = false
                local currentVal = defaultVal

                local function updateSlider(inputPos)
                    local bgPos = sliderBg.AbsolutePosition.X
                    local bgSize = sliderBg.AbsoluteSize.X
                    local mouseX = inputPos - bgPos
                    local percent = math.clamp(mouseX / bgSize, 0, 1)
                    local rawVal = minVal + (maxVal - minVal) * percent
                    local factor = 10 ^ decimals
                    currentVal = math.round(rawVal * factor) / factor
                    currentVal = math.clamp(currentVal, minVal, maxVal)

                    local fillWidth = bgSize * percent
                    sliderFill.Size = UDim2.fromOffset(fillWidth, 6)
                    sliderScrub.Position = UDim2.fromOffset(fillWidth - 7, -4)
                    valDisplay.Text = tostring(currentVal) .. suffix

                    local s, e = pcall(callback, currentVal)
                    if not s then warn("[ApexUI] Slider callback error:", e) end
                end

                local function startSlide(input)
                    sliding = true
                    updateSlider(input.Position.X)
                end

                sliderBg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        startSlide(input)
                    end
                end)

                sliderScrub.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = true
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if sliding and input.UserInputType == Enum.UserInputType.MouseMovement then
                        updateSlider(input.Position.X)
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        sliding = false
                    end
                end)

                -- Initialize position
                task.wait()
                if sliderBg.AbsoluteSize.X > 0 then
                    local initPercent = (defaultVal - minVal) / (maxVal - minVal)
                    local fillW = sliderBg.AbsoluteSize.X * initPercent
                    sliderFill.Size = UDim2.fromOffset(fillW, 6)
                    sliderScrub.Position = UDim2.fromOffset(fillW - 7, -4)
                end

                table.insert(sectionData.Elements, {
                    Type = "Slider",
                    Name = sliderName,
                    Frame = sliderFrame,
                    SetValue = function(val)
                        val = math.clamp(val, minVal, maxVal)
                        currentVal = val
                        valDisplay.Text = tostring(val) .. suffix
                        if sliderBg.AbsoluteSize.X > 0 then
                            local pct = (val - minVal) / (maxVal - minVal)
                            local fw = sliderBg.AbsoluteSize.X * pct
                            sliderFill.Size = UDim2.fromOffset(fw, 6)
                            sliderScrub.Position = UDim2.fromOffset(fw - 7, -4)
                        end
                        local s, e = pcall(callback, val)
                        if not s then warn("[ApexUI] Slider setter error:", e) end
                    end,
                    GetValue = function() return currentVal end,
                })

                return {
                    Frame = sliderFrame,
                    SetValue = function(val)
                        val = math.clamp(val, minVal, maxVal)
                        currentVal = val
                        valDisplay.Text = tostring(val) .. suffix
                        if sliderBg.AbsoluteSize.X > 0 then
                            local pct = (val - minVal) / (maxVal - minVal)
                            local fw = sliderBg.AbsoluteSize.X * pct
                            sliderFill.Size = UDim2.fromOffset(fw, 6)
                            sliderScrub.Position = UDim2.fromOffset(fw - 7, -4)
                        end
                        local s, e = pcall(callback, val)
                        if not s then warn("[ApexUI] Slider setter error:", e) end
                    end,
                    GetValue = function() return currentVal end,
                }
            end

            -- DROPDOWN
            function sectionData:AddDropdown(elementConfig)
                elementConfig = elementConfig or {}
                local dropdownName = elementConfig.Name or "Dropdown"
                local desc = elementConfig.Description or ""
                local options = elementConfig.Options or {}
                local defaultVal = elementConfig.Default or nil
                local callback = elementConfig.Callback or function() end

                local ddFrame = Utility:Create("Frame", {
                    Name = dropdownName .. "_DD",
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundColor3 = theme.SectionBackground,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ZIndex = 4,
                    LayoutOrder = #sectionData.Elements + 1,
                    AutomaticSize = Enum.AutomaticSize.Y,
                })
                ddFrame.Parent = sectionContent

                -- Label
                local ddLabel = Utility:Create("TextLabel", {
                    Size = UDim2.fromOffset(0, 18),
                    Position = UDim2.fromOffset(4, 2),
                    BackgroundTransparency = 1,
                    Text = "  " .. dropdownName,
                    TextColor3 = theme.LabelText,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 5,
                    RichText = true,
                    AutomaticSize = Enum.AutomaticSize.X,
                })
                ddLabel.Parent = ddFrame

                -- Dropdown button
                local ddBtn = Utility:Create("Frame", {
                    Name = "DDBtn",
                    Size = UDim2.new(1, -16, 0, 32),
                    Position = UDim2.fromOffset(8, 24),
                    BackgroundColor3 = theme.DropdownBackground,
                    BackgroundTransparency = 0,
                    BorderSizePixel = 0,
                    ZIndex = 5,
                })
                Utility:Round(ddBtn, 8)
                Utility:Stroke(ddBtn, theme.SectionBorder, 1)
                ddBtn.Parent = ddFrame

                -- Selected text
                local selectedText = Utility:Create("TextLabel", {
                    Size = UDim2.new(1, -32, 1, 0),
                    Position = UDim2.fromOffset(10, 0),
                    BackgroundTransparency = 1,
                    Text = defaultVal or "Select option...",
                    TextColor3 = theme.DropdownText,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 6,
                    RichText = true,
                })
                selectedText.Parent = ddBtn

                -- Arrow
                local arrow = Utility:Create("TextLabel", {
                    Size = UDim2.fromOffset(16, 16),
                    Position = UDim2.new(1, -24, 0, 8),
                    BackgroundTransparency = 1,
                    Text = "▼",
                    TextColor3 = theme.DropdownText,
                    TextSize = 10,
                    Font = Enum.Font.Gotham,
                    ZIndex = 6,
                })
                arrow.Parent = ddBtn

                -- Click button
                local clickBtn = Utility:Create("TextButton", {
                    Size = UDim2.fromScale(1, 1),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false,
                    ZIndex = 7,
                })
                clickBtn.Parent = ddBtn

                -- Dropdown list
                local ddList = Utility:Create("Frame", {
                    Name = "DDList",
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.fromOffset(0, 0),
                    BackgroundColor3 = theme.DropdownBackground,
                    BackgroundTransparency = 0,
                    BorderSizePixel = 0,
                    ZIndex = 10,
                    Visible = false,
                    ClipsDescendants = true,
                })
                Utility:Round(ddList, 8)
                Utility:Stroke(ddList, theme.SectionBorder, 1)
                ddList.Parent = ddFrame

                -- List layout
                local listLayout = Utility:Create("UIListLayout", {
                    Padding = UDim.new(0, 2),
                    FillDirection = Enum.FillDirection.Vertical,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                })
                listLayout.Parent = ddList

                -- Populate list
                local currentSel = defaultVal
                local listOpen = false

                local function populateList()
                    -- Clear existing
                    for _, child in pairs(ddList:GetChildren()) do
                        if child:IsA("TextButton") or child:IsA("Frame") then
                            child:Destroy()
                        end
                    end

                    for _, opt in ipairs(options) do
                        local optStr = tostring(opt)
                        local optBtn = Utility:Create("TextButton", {
                            Size = UDim2.new(1, -8, 0, 28),
                            Position = UDim2.fromOffset(4, 0),
                            BackgroundTransparency = 0.95,
                            Text = "",
                            AutoButtonColor = false,
                            ZIndex = 12,
                            LayoutOrder = #options,
                        })
                            Utility:Round(optBtn, 6)
                        optBtn.Parent = ddList

                        local optLabel = Utility:Create("TextLabel", {
                            Size = UDim2.new(1, -16, 1, 0),
                            Position = UDim2.fromOffset(8, 0),
                            BackgroundTransparency = 1,
                            Text = "  " .. optStr,
                            TextColor3 = optStr == currentSel and theme.Accent or theme.DropdownText,
                            TextSize = 13,
                            Font = Enum.Font.Gotham,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            ZIndex = 13,
                        })
                        optLabel.Parent = optBtn

                        optBtn.MouseButton1Click:Connect(function()
                            currentSel = optStr
                            selectedText.Text = optStr
                            selectedText.TextColor3 = theme.Accent
                            closeList()
                            local s, e = pcall(callback, opt)
                            if not s then warn("[ApexUI] Dropdown callback error:", e) end
                        end)

                        optBtn.MouseEnter:Connect(function()
                            Utility:Tween(optBtn, {Time = 0.1}, {
                                BackgroundTransparency = 0.7,
                            })
                            optBtn.BackgroundColor3 = theme.DropdownItemHover
                        end)

                        optBtn.MouseLeave:Connect(function()
                            Utility:Tween(optBtn, {Time = 0.15}, {
                                BackgroundTransparency = 0.95,
                            })
                        end)
                    end

                    ddList.Size = UDim2.new(1, 0, 0, math.min(#options * 30 + 8, 150))
                end

                local function openList()
                    if listOpen then return end
                    listOpen = true
                    ddList.Visible = true
                    ddList.Size = UDim2.new(1, 0, 0, 0)
                    populateList()
                    Utility:Tween(ddList, {Time = 0.2}, {
                        Size = UDim2.new(1, 0, 0, math.min(#options * 30 + 8, 150)),
                    })
                    arrow.Text = "▲"
                end

                local function closeList()
                    if not listOpen then return end
                    listOpen = false
                    Utility:Tween(ddList, {Time = 0.15}, {
                        Size = UDim2.new(1, 0, 0, 0),
                    })
                    task.delay(0.16, function()
                        ddList.Visible = false
                        arrow.Text = "▼"
                    end)
                end

                clickBtn.MouseButton1Click:Connect(function()
                    if listOpen then closeList() else openList() end
                end)

                -- Close on click outside
                UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 and listOpen then
                        local mousePos = UserInputService:GetMouseLocation()
                        local absPos = ddList.AbsolutePosition
                        local absSize = ddList.AbsoluteSize
                        if mousePos.X < absPos.X or mousePos.X > absPos.X + absSize.X or
                           mousePos.Y < absPos.Y or mousePos.Y > absPos.Y + absSize.Y then
                            closeList()
                        end
                    end
                end)

                table.insert(sectionData.Elements, {
                    Type = "Dropdown",
                    Name = dropdownName,
                    Frame = ddFrame,
                    SetValue = function(val)
                        currentSel = tostring(val)
                        selectedText.Text = currentSel
                        selectedText.TextColor3 = theme.Accent
                        local s, e = pcall(callback, val)
                        if not s then warn("[ApexUI] Dropdown setter error:", e) end
                    end,
                    GetValue = function() return currentSel end,
                    Refresh = function(newOpts)
                        options = newOpts
                        if listOpen then
                            populateList()
                        end
                    end,
                })

                return {
                    Frame = ddFrame,
                    SetValue = function(val)
                        currentSel = tostring(val)
                        selectedText.Text = currentSel
                        selectedText.TextColor3 = theme.Accent
                    end,
                    GetValue = function() return currentSel end,
                    Refresh = function(newOpts)
                        options = newOpts
                        if listOpen then populateList() end
                    end,
                }
            end

            -- TEXTBOX
            function sectionData:AddTextbox(elementConfig)
                elementConfig = elementConfig or {}
                local tbName = elementConfig.Name or "Text Input"
                local desc = elementConfig.Description or ""
                local placeholder = elementConfig.Placeholder or "Type here..."
                local defaultText = elementConfig.Default or ""
                local numeric = elementConfig.Numeric or false
                local callback = elementConfig.Callback or function() end

                local tbFrame = Utility:Create("Frame", {
                    Name = tbName .. "_TB",
                    Size = UDim2.new(1, 0, 0, 52),
                    BackgroundColor3 = theme.SectionBackground,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ZIndex = 4,
                    LayoutOrder = #sectionData.Elements + 1,
                })
                tbFrame.Parent = sectionContent

                -- Label
                local tbLabel = Utility:Create("TextLabel", {
                    Size = UDim2.fromOffset(0, 18),
                    Position = UDim2.fromOffset(4, 2),
                    BackgroundTransparency = 1,
                    Text = "  " .. tbName,
                    TextColor3 = theme.LabelText,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 5,
                    RichText = true,
                    AutomaticSize = Enum.AutomaticSize.X,
                })
                tbLabel.Parent = tbFrame

                -- Text box
                local textBox = Utility:Create("TextBox", {
                    Size = UDim2.new(1, -16, 0, 28),
                    Position = UDim2.fromOffset(8, 22),
                    BackgroundColor3 = theme.TextBoxBackground,
                    BackgroundTransparency = 0,
                    BorderSizePixel = 0,
                    PlaceholderText = placeholder,
                    PlaceholderColor3 = theme.TextBoxPlaceholder,
                    Text = defaultText,
                    TextColor3 = theme.TextBoxText,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 5,
                    ClearTextOnFocus = false,
                })
                Utility:Round(textBox, 8)
                Utility:Stroke(textBox, theme.SectionBorder, 1)
                textBox.Parent = tbFrame

                -- Focus effects
                textBox.Focused:Connect(function()
                    Utility:Tween(textBox, {Time = 0.15}, {
                        BackgroundColor3 = theme.TextBoxBackground,
                    })
                    local currentColor = theme.Accent
                    -- Restroke with accent on focus
                    for _, child in pairs(textBox:GetChildren()) do
                        if child:IsA("UIStroke") then
                            Utility:Tween(child, {Time = 0.15}, {Color = currentColor})
                        end
                    end
                end)

                textBox.FocusLost:Connect(function(enterPressed)
                    local currentText = textBox.Text
                    if numeric then
                        local num = tonumber(currentText)
                        if num then
                            textBox.Text = tostring(num)
                            local s, e = pcall(callback, num)
                            if not s then warn("[ApexUI] TextBox callback error:", e) end
                        else
                            textBox.Text = defaultText
                        end
                    else
                        local s, e = pcall(callback, currentText)
                        if not s then warn("[ApexUI] TextBox callback error:", e) end
                    end

                    -- Remove accent stroke
                    for _, child in pairs(textBox:GetChildren()) do
                        if child:IsA("UIStroke") then
                            Utility:Tween(child, {Time = 0.2}, {Color = theme.SectionBorder})
                        end
                    end
                end)

                table.insert(sectionData.Elements, {
                    Type = "TextBox",
                    Name = tbName,
                    Frame = tbFrame,
                    SetValue = function(text)
                        textBox.Text = tostring(text)
                    end,
                    GetValue = function() return textBox.Text end,
                })

                return {
                    Frame = tbFrame,
                    SetValue = function(text) textBox.Text = tostring(text) end,
                    GetValue = function() return textBox.Text end,
                }
            end

            -- KEYBIND
            function sectionData:AddKeybind(elementConfig)
                elementConfig = elementConfig or {}
                local kbName = elementConfig.Name or "Keybind"
                local desc = elementConfig.Description or ""
                local defaultKey = elementConfig.Default or Enum.KeyCode.Unknown
                local callback = elementConfig.Callback or function() end
                local changeCallback = elementConfig.ChangeCallback or function() end
                local ignoreMouse = elementConfig.IgnoreMouse or false

                local kbFrame = Utility:Create("Frame", {
                    Name = kbName .. "_KB",
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = theme.SectionBackground,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ZIndex = 4,
                    LayoutOrder = #sectionData.Elements + 1,
                })
                kbFrame.Parent = sectionContent

                -- Label
                local kbLabel = Utility:Create("TextLabel", {
                    Size = UDim2.fromOffset(0, 20),
                    Position = UDim2.fromOffset(4, 7),
                    BackgroundTransparency = 1,
                    Text = "  " .. kbName,
                    TextColor3 = theme.LabelText,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 5,
                    RichText = true,
                    AutomaticSize = Enum.AutomaticSize.X,
                })
                kbLabel.Parent = kbFrame

                -- Keybind display
                local function getKeyName(key)
                    local name = tostring(key)
                    name = name:gsub("Enum.KeyCode.", "")
                    name = name:gsub("Enum.UserInputType.", "")
                    if name == "Unknown" then return "None" end
                    -- Nicely format
                    name = name:gsub("(%l)(%u)", "%1 %2")
                    name = name:gsub("(%u)(%u%l)", "%1 %2")
                    return name
                end

                local keyBtn = Utility:Create("Frame", {
                    Name = "KeyBtn",
                    Size = UDim2.fromOffset(90, 24),
                    Position = UDim2.new(1, -4, 0, 5),
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundColor3 = theme.KeybindBackground,
                    BackgroundTransparency = 0,
                    BorderSizePixel = 0,
                    ZIndex = 5,
                })
                Utility:Round(keyBtn, 6)
                Utility:Stroke(keyBtn, theme.SectionBorder, 1)
                keyBtn.Parent = kbFrame

                local keyText = Utility:Create("TextLabel", {
                    Size = UDim2.fromScale(1, 1),
                    BackgroundTransparency = 1,
                    Text = getKeyName(defaultKey),
                    TextColor3 = theme.KeybindText,
                    TextSize = 12,
                    Font = Enum.Font.GothamBold,
                    ZIndex = 6,
                })
                keyText.Parent = keyBtn

                -- Click to rebind
                local clickBtn = Utility:Create("TextButton", {
                    Size = UDim2.fromScale(1, 1),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false,
                    ZIndex = 7,
                })
                clickBtn.Parent = keyBtn

                local currentKey = defaultKey
                local binding = false

                clickBtn.MouseButton1Click:Connect(function()
                    binding = true
                    keyText.Text = "..."
                    keyText.TextColor3 = theme.Accent
                end)

                -- Handle key input
                local inputConn
                inputConn = UserInputService.InputBegan:Connect(function(input, gpe)
                    if gpe and not ignoreMouse then return end

                    if binding then
                        binding = false
                        local newKey = input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode or
                                       input.UserInputType ~= Enum.UserInputType.Keyboard and input.UserInputType or
                                       Enum.KeyCode.Unknown

                        if newKey ~= Enum.KeyCode.Unknown then
                            currentKey = newKey
                            keyText.Text = getKeyName(newKey)
                            keyText.TextColor3 = theme.KeybindText
                            local s, e = pcall(changeCallback, newKey)
                            if not s then warn("[ApexUI] Keybind change callback error:", e) end
                        else
                            keyText.Text = getKeyName(currentKey)
                            keyText.TextColor3 = theme.KeybindText
                        end
                        return
                    end

                    -- Check for keypress callback
                    if currentKey ~= Enum.KeyCode.Unknown then
                        local triggered = false
                        if input.KeyCode ~= Enum.KeyCode.Unknown and input.KeyCode == currentKey then
                            triggered = true
                        elseif input.UserInputType ~= Enum.UserInputType.Keyboard and input.UserInputType == currentKey then
                            triggered = true
                        end
                        if triggered then
                            local s, e = pcall(callback)
                            if not s then warn("[ApexUI] Keybind callback error:", e) end
                        end
                    end
                end)

                table.insert(sectionData.Elements, {
                    Type = "Keybind",
                    Name = kbName,
                    Frame = kbFrame,
                    Key = currentKey,
                    SetKey = function(newKey)
                        currentKey = newKey
                        keyText.Text = getKeyName(newKey)
                    end,
                    GetKey = function() return currentKey end,
                })

                return {
                    Frame = kbFrame,
                    SetKey = function(newKey)
                        currentKey = newKey
                        keyText.Text = getKeyName(newKey)
                    end,
                    GetKey = function() return currentKey end,
                }
            end

            -- LABEL
            function sectionData:AddLabel(elementConfig)
                elementConfig = elementConfig or {}
                local labelText = elementConfig.Text or "Label"
                local textColor = elementConfig.Color or nil

                local labelFrame = Utility:Create("Frame", {
                    Name = "Label",
                    Size = UDim2.new(1, 0, 0, 24),
                    BackgroundColor3 = theme.SectionBackground,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ZIndex = 4,
                    LayoutOrder = #sectionData.Elements + 1,
                })
                labelFrame.Parent = sectionContent

                local label = Utility:Create("TextLabel", {
                    Size = UDim2.new(1, -20, 1, 0),
                    Position = UDim2.fromOffset(10, 0),
                    BackgroundTransparency = 1,
                    Text = "  " .. labelText,
                    TextColor3 = textColor or theme.LabelText,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 5,
                    RichText = true,
                })
                label.Parent = labelFrame

                table.insert(sectionData.Elements, {
                    Type = "Label",
                    Frame = labelFrame,
                    SetText = function(text)
                        label.Text = "  " .. text
                    end,
                })

                return {
                    Frame = labelFrame,
                    SetText = function(text) label.Text = "  " .. text end,
                }
            end

            -- PARAGRAPH
            function sectionData:AddParagraph(elementConfig)
                elementConfig = elementConfig or {}
                local title = elementConfig.Title or "Information"
                local content = elementConfig.Content or ""

                local paraFrame = Utility:Create("Frame", {
                    Name = "Paragraph",
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundColor3 = theme.SectionBackground,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ZIndex = 4,
                    LayoutOrder = #sectionData.Elements + 1,
                    AutomaticSize = Enum.AutomaticSize.Y,
                })
                paraFrame.Parent = sectionContent

                local paraTitle = Utility:Create("TextLabel", {
                    Size = UDim2.fromOffset(0, 20),
                    Position = UDim2.fromOffset(10, 4),
                    BackgroundTransparency = 1,
                    Text = "  " .. title,
                    TextColor3 = theme.SectionTitle,
                    TextSize = 13,
                    Font = Enum.Font.GothamBold,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 5,
                    RichText = true,
                    AutomaticSize = Enum.AutomaticSize.X,
                })
                paraTitle.Parent = paraFrame

                local paraContent = Utility:Create("TextLabel", {
                    Size = UDim2.new(1, -24, 0, 0),
                    Position = UDim2.fromOffset(12, 26),
                    BackgroundTransparency = 1,
                    Text = content,
                    TextColor3 = theme.ParagraphText,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top,
                    ZIndex = 5,
                    RichText = true,
                    TextWrapped = true,
                    AutomaticSize = Enum.AutomaticSize.Y,
                })
                paraContent.Parent = paraFrame

                -- Adjust frame size
                local conn = paraContent:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                    local h = paraContent.AbsoluteSize.Y + 32
                    paraFrame.Size = UDim2.new(1, 0, 0, h)
                end)

                table.insert(sectionData.Elements, {
                    Type = "Paragraph",
                    Frame = paraFrame,
                    SetContent = function(text)
                        paraContent.Text = text
                    end,
                })

                return {
                    Frame = paraFrame,
                    SetContent = function(text) paraContent.Text = text end,
                }
            end

            -- COLOR PICKER
            function sectionData:AddColorPicker(elementConfig)
                elementConfig = elementConfig or {}
                local pickerName = elementConfig.Name or "Color Picker"
                local defaultColor = elementConfig.Default or Color3.fromRGB(255, 255, 255)
                local callback = elementConfig.Callback or function() end

                local cpFrame = Utility:Create("Frame", {
                    Name = pickerName .. "_CP",
                    Size = UDim2.new(1, 0, 0, 34),
                    BackgroundColor3 = theme.SectionBackground,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ZIndex = 4,
                    LayoutOrder = #sectionData.Elements + 1,
                })
                cpFrame.Parent = sectionContent

                -- Label
                local cpLabel = Utility:Create("TextLabel", {
                    Size = UDim2.fromOffset(0, 20),
                    Position = UDim2.fromOffset(4, 7),
                    BackgroundTransparency = 1,
                    Text = "  " .. pickerName,
                    TextColor3 = theme.LabelText,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 5,
                    RichText = true,
                    AutomaticSize = Enum.AutomaticSize.X,
                })
                cpLabel.Parent = cpFrame

                -- Color preview
                local colorPreview = Utility:Create("Frame", {
                    Name = "ColorPreview",
                    Size = UDim2.fromOffset(24, 24),
                    Position = UDim2.new(1, -28, 0, 5),
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundColor3 = defaultColor,
                    BackgroundTransparency = 0,
                    BorderSizePixel = 0,
                    ZIndex = 5,
                })
                Utility:Round(colorPreview, 6)
                Utility:Stroke(colorPreview, theme.ColorPickerBorder, 1)
                colorPreview.Parent = cpFrame

                -- Click to expand
                local clickBtn = Utility:Create("TextButton", {
                    Size = UDim2.fromScale(1, 1),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false,
                    ZIndex = 7,
                })
                clickBtn.Parent = cpFrame

                -- Expanded picker panel
                local pickerPanel = Utility:Create("Frame", {
                    Name = "PickerPanel",
                    Size = UDim2.new(1, -16, 0, 160),
                    Position = UDim2.fromOffset(8, 38),
                    BackgroundColor3 = theme.ColorPickerBackground,
                    BackgroundTransparency = 0,
                    BorderSizePixel = 0,
                    ZIndex = 10,
                    Visible = false,
                    ClipsDescendants = true,
                })
                Utility:Round(pickerPanel, 10)
                Utility:Stroke(pickerPanel, theme.ColorPickerBorder, 1)
                pickerPanel.Parent = cpFrame

                -- Hue bar
                local hueBar = Utility:Create("Frame", {
                    Name = "HueBar",
                    Size = UDim2.new(1, -24, 0, 12),
                    Position = UDim2.fromOffset(12, 8),
                    BackgroundColor3 = Color3.fromRGB(255, 0, 0),
                    BorderSizePixel = 0,
                    ZIndex = 11,
                    ClipsDescendants = true,
                })
                Utility:Round(hueBar, 6)
                hueBar.Parent = pickerPanel

                local hueGradient = Utility:Create("UIGradient", {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
                    }),
                    Rotation = 0,
                })
                hueGradient.Parent = hueBar

                -- Saturation/Value grid
                local svGrid = Utility:Create("Frame", {
                    Name = "SVGrid",
                    Size = UDim2.new(1, -24, 0, 100),
                    Position = UDim2.fromOffset(12, 26),
                    BackgroundColor3 = Color3.fromRGB(255, 0, 0),
                    BorderSizePixel = 0,
                    ZIndex = 11,
                    ClipsDescendants = true,
                })
                Utility:Round(svGrid, 6)
                svGrid.Parent = pickerPanel

                -- White gradient (saturation)
                local satGrad = Utility:Create("UIGradient", {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
                    }),
                    Rotation = 0,
                })
                satGrad.Parent = svGrid

                -- Black gradient (value)
                local valGrad = Utility:Create("UIGradient", {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255)),
                    }),
                    Rotation = 90,
                })
                valGrad.Parent = svGrid

                -- Hex input
                local hexBox = Utility:Create("TextBox", {
                    Size = UDim2.fromOffset(100, 22),
                    Position = UDim2.fromOffset(12, 132),
                    BackgroundColor3 = theme.TextBoxBackground,
                    BackgroundTransparency = 0,
                    BorderSizePixel = 0,
                    PlaceholderText = "#FFFFFF",
                    PlaceholderColor3 = theme.TextBoxPlaceholder,
                    Text = "#FFFFFF",
                    TextColor3 = theme.TextBoxText,
                    TextSize = 12,
                    Font = Enum.Font.Gotham,
                    ZIndex = 12,
                    ClearTextOnFocus = false,
                })
                Utility:Round(hexBox, 6)
                Utility:Stroke(hexBox, theme.SectionBorder, 1)
                hexBox.Parent = pickerPanel

                -- Current hue/sat/val state
                local currentColor = defaultColor
                local h, s, v = currentColor:ToHSV()

                local function updatePickerDisplay()
                    -- Update preview
                    colorPreview.BackgroundColor3 = currentColor
                    -- Update hex
                    hexBox.Text = "#" .. string.format("%02X%02X%02X",
                        math.floor(currentColor.R * 255),
                        math.floor(currentColor.G * 255),
                        math.floor(currentColor.B * 255))
                    -- Update SV grid base
                    svGrid.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    -- Callback
                    local s_, e_ = pcall(callback, currentColor)
                    if not s_ then warn("[ApexUI] ColorPicker callback error:", e_) end
                end

                local function hsvToRgbFromPicker()
                    currentColor = Color3.fromHSV(h, s, v)
                    updatePickerDisplay()
                end

                -- Hue bar interaction
                local hueDrag = false
                local hueBtn = Utility:Create("TextButton", {
                    Size = UDim2.fromScale(1, 1),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false,
                    ZIndex = 13,
                })
                hueBtn.Parent = hueBar

                hueBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        hueDrag = true
                        local pos = UserInputService:GetMouseLocation()
                        local relX = math.clamp((pos.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
                        h = relX
                        hsvToRgbFromPicker()
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if hueDrag and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local pos = UserInputService:GetMouseLocation()
                        local relX = math.clamp((pos.X - hueBar.AbsolutePosition.X) / hueBar.AbsoluteSize.X, 0, 1)
                        h = relX
                        hsvToRgbFromPicker()
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        hueDrag = false
                    end
                end)

                -- SV grid interaction
                local svDrag = false
                local svBtn = Utility:Create("TextButton", {
                    Size = UDim2.fromScale(1, 1),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false,
                    ZIndex = 13,
                })
                svBtn.Parent = svGrid

                svBtn.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        svDrag = true
                        local pos = UserInputService:GetMouseLocation()
                        local relX = math.clamp((pos.X - svGrid.AbsolutePosition.X) / svGrid.AbsoluteSize.X, 0, 1)
                        local relY = math.clamp((pos.Y - svGrid.AbsolutePosition.Y) / svGrid.AbsoluteSize.Y, 0, 1)
                        s = relX
                        v = 1 - relY
                        hsvToRgbFromPicker()
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if svDrag and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local pos = UserInputService:GetMouseLocation()
                        local relX = math.clamp((pos.X - svGrid.AbsolutePosition.X) / svGrid.AbsoluteSize.X, 0, 1)
                        local relY = math.clamp((pos.Y - svGrid.AbsolutePosition.Y) / svGrid.AbsoluteSize.Y, 0, 1)
                        s = relX
                        v = 1 - relY
                        hsvToRgbFromPicker()
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        svDrag = false
                    end
                end)

                -- Hex input
                hexBox.FocusLost:Connect(function(enterPressed)
                    if enterPressed then
                        local hex = hexBox.Text:gsub("#", "")
                        if #hex == 6 then
                            local r = tonumber(hex:sub(1, 2), 16) or 255
                            local g = tonumber(hex:sub(3, 4), 16) or 255
                            local b = tonumber(hex:sub(5, 6), 16) or 255
                            currentColor = Color3.fromRGB(r, g, b)
                            h, s, v = currentColor:ToHSV()
                            updatePickerDisplay()
                        end
                    end
                end)

                -- Toggle picker
                local pickerOpen = false
                clickBtn.MouseButton1Click:Connect(function()
                    pickerOpen = not pickerOpen
                    if pickerOpen then
                        pickerPanel.Visible = true
                        pickerPanel.Size = UDim2.new(1, -16, 0, 0)
                        Utility:Tween(pickerPanel, {Time = 0.2}, {
                            Size = UDim2.new(1, -16, 0, 160),
                        })
                        h, s, v = currentColor:ToHSV()
                        updatePickerDisplay()
                    else
                        Utility:Tween(pickerPanel, {Time = 0.15}, {
                            Size = UDim2.new(1, -16, 0, 0),
                        })
                        task.delay(0.16, function()
                            pickerPanel.Visible = false
                        end)
                    end
                end)

                -- Initialize display
                updatePickerDisplay()

                table.insert(sectionData.Elements, {
                    Type = "ColorPicker",
                    Name = pickerName,
                    Frame = cpFrame,
                    SetColor = function(color)
                        currentColor = color
                        h, s, v = color:ToHSV()
                        updatePickerDisplay()
                    end,
                    GetColor = function() return currentColor end,
                })

                return {
                    Frame = cpFrame,
                    SetColor = function(color)
                        currentColor = color
                        h, s, v = color:ToHSV()
                        updatePickerDisplay()
                    end,
                    GetColor = function() return currentColor end,
                }
            end

            -- MULTI-SELECT DROPDOWN
            function sectionData:AddMultiSelect(elementConfig)
                elementConfig = elementConfig or {}
                local msName = elementConfig.Name or "Multi Select"
                local options = elementConfig.Options or {}
                local defaultSel = elementConfig.Default or {}
                local callback = elementConfig.Callback or function() end
                local maxDisplay = elementConfig.MaxDisplay or 3

                local msFrame = Utility:Create("Frame", {
                    Name = msName .. "_MS",
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundColor3 = theme.SectionBackground,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ZIndex = 4,
                    LayoutOrder = #sectionData.Elements + 1,
                    AutomaticSize = Enum.AutomaticSize.Y,
                })
                msFrame.Parent = sectionContent

                -- Label
                local msLabel = Utility:Create("TextLabel", {
                    Size = UDim2.fromOffset(0, 18),
                    Position = UDim2.fromOffset(4, 2),
                    BackgroundTransparency = 1,
                    Text = "  " .. msName,
                    TextColor3 = theme.LabelText,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 5,
                    RichText = true,
                    AutomaticSize = Enum.AutomaticSize.X,
                })
                msLabel.Parent = msFrame

                -- Display frame
                local msBtn = Utility:Create("Frame", {
                    Name = "MSBtn",
                    Size = UDim2.new(1, -16, 0, 32),
                    Position = UDim2.fromOffset(8, 24),
                    BackgroundColor3 = theme.DropdownBackground,
                    BackgroundTransparency = 0,
                    BorderSizePixel = 0,
                    ZIndex = 5,
                    ClipsDescendants = true,
                })
                Utility:Round(msBtn, 8)
                Utility:Stroke(msBtn, theme.SectionBorder, 1)
                msBtn.Parent = msFrame

                local displayText = Utility:Create("TextLabel", {
                    Size = UDim2.new(1, -32, 1, 0),
                    Position = UDim2.fromOffset(10, 0),
                    BackgroundTransparency = 1,
                    Text = "Select options...",
                    TextColor3 = theme.DropdownText,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 6,
                    RichText = true,
                })
                displayText.Parent = msBtn

                local arrow = Utility:Create("TextLabel", {
                    Size = UDim2.fromOffset(16, 16),
                    Position = UDim2.new(1, -24, 0, 8),
                    BackgroundTransparency = 1,
                    Text = "▼",
                    TextColor3 = theme.DropdownText,
                    TextSize = 10,
                    Font = Enum.Font.Gotham,
                    ZIndex = 6,
                })
                arrow.Parent = msBtn

                local clickBtn = Utility:Create("TextButton", {
                    Size = UDim2.fromScale(1, 1),
                    BackgroundTransparency = 1,
                    Text = "",
                    AutoButtonColor = false,
                    ZIndex = 7,
                })
                clickBtn.Parent = msBtn

                -- Dropdown list
                local msList = Utility:Create("Frame", {
                    Name = "MSList",
                    Size = UDim2.new(1, 0, 0, 0),
                    Position = UDim2.fromOffset(0, 0),
                    BackgroundColor3 = theme.DropdownBackground,
                    BackgroundTransparency = 0,
                    BorderSizePixel = 0,
                    ZIndex = 10,
                    Visible = false,
                    ClipsDescendants = true,
                })
                Utility:Round(msList, 8)
                Utility:Stroke(msList, theme.SectionBorder, 1)
                msList.Parent = msFrame

                local listLayout = Utility:Create("UIListLayout", {
                    Padding = UDim.new(0, 2),
                    FillDirection = Enum.FillDirection.Vertical,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                })
                listLayout.Parent = msList

                local selected = {}
                -- Initialize defaults
                for _, opt in ipairs(defaultSel) do
                    selected[tostring(opt)] = true
                end

                local listOpen = false

                local function updateDisplay()
                    local selNames = {}
                    for _, opt in ipairs(options) do
                        local optStr = tostring(opt)
                        if selected[optStr] then
                            table.insert(selNames, optStr)
                        end
                    end
                    if #selNames == 0 then
                        displayText.Text = "Select options..."
                        displayText.TextColor3 = theme.DropdownText
                    else
                        local display = ""
                        for i = 1, math.min(#selNames, maxDisplay) do
                            if i > 1 then display = display .. ", " end
                            display = display .. selNames[i]
                        end
                        if #selNames > maxDisplay then
                            display = display .. " (+" .. (#selNames - maxDisplay) .. ")"
                        end
                        displayText.Text = display
                        displayText.TextColor3 = theme.Accent
                    end
                    local s, e = pcall(callback, selNames)
                    if not s then warn("[ApexUI] MultiSelect callback error:", e) end
                end

                local function populateMSList()
                    for _, child in pairs(msList:GetChildren()) do
                        if child:IsA("TextButton") or child:IsA("Frame") then
                            child:Destroy()
                        end
                    end

                    for _, opt in ipairs(options) do
                        local optStr = tostring(opt)
                        local optBtn = Utility:Create("TextButton", {
                            Size = UDim2.new(1, -8, 0, 28),
                            Position = UDim2.fromOffset(4, 0),
                            BackgroundTransparency = selected[optStr] and 0.8 or 0.95,
                            Text = "",
                            AutoButtonColor = false,
                            ZIndex = 12,
                        })
                        Utility:Round(optBtn, 6)
                        optBtn.Parent = msList

                        local checkMark = Utility:Create("TextLabel", {
                            Size = UDim2.fromOffset(16, 16),
                            Position = UDim2.fromOffset(6, 6),
                            BackgroundTransparency = 1,
                            Text = selected[optStr] and "✓" or "○",
                            TextColor3 = selected[optStr] and theme.Accent or theme.DropdownText,
                            TextSize = 12,
                            Font = Enum.Font.GothamBold,
                            ZIndex = 13,
                        })
                        checkMark.Parent = optBtn

                        local optLabel = Utility:Create("TextLabel", {
                            Size = UDim2.new(1, -30, 1, 0),
                            Position = UDim2.fromOffset(26, 0),
                            BackgroundTransparency = 1,
                            Text = "  " .. optStr,
                            TextColor3 = selected[optStr] and theme.Accent or theme.DropdownText,
                            TextSize = 13,
                            Font = Enum.Font.Gotham,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            ZIndex = 13,
                        })
                        optLabel.Parent = optBtn

                        optBtn.MouseButton1Click:Connect(function()
                            selected[optStr] = not selected[optStr]
                            checkMark.Text = selected[optStr] and "✓" or "○"
                            checkMark.TextColor3 = selected[optStr] and theme.Accent or theme.DropdownText
                            optLabel.TextColor3 = selected[optStr] and theme.Accent or theme.DropdownText
                            optBtn.BackgroundTransparency = selected[optStr] and 0.8 or 0.95
                            updateDisplay()
                        end)

                        optBtn.MouseEnter:Connect(function()
                            Utility:Tween(optBtn, {Time = 0.1}, {
                                BackgroundTransparency = 0.7,
                            })
                            optBtn.BackgroundColor3 = theme.DropdownItemHover
                        end)

                        optBtn.MouseLeave:Connect(function()
                            Utility:Tween(optBtn, {Time = 0.15}, {
                                BackgroundTransparency = selected[optStr] and 0.8 or 0.95,
                            })
                        end)
                    end

                    local listHeight = math.min(#options * 30 + 8, 150)
                    msList.Size = UDim2.new(1, 0, 0, listHeight)
                end

                local function openMSList()
                    if listOpen then return end
                    listOpen = true
                    msList.Visible = true
                    msList.Size = UDim2.new(1, 0, 0, 0)
                    populateMSList()
                    Utility:Tween(msList, {Time = 0.2}, {
                        Size = UDim2.new(1, 0, 0, math.min(#options * 30 + 8, 150)),
                    })
                    arrow.Text = "▲"
                end

                local function closeMSList()
                    if not listOpen then return end
                    listOpen = false
                    Utility:Tween(msList, {Time = 0.15}, {
                        Size = UDim2.new(1, 0, 0, 0),
                    })
                    task.delay(0.16, function()
                        msList.Visible = false
                        arrow.Text = "▼"
                    end)
                end

                clickBtn.MouseButton1Click:Connect(function()
                    if listOpen then closeMSList() else openMSList() end
                end)

                -- Close on click outside
                UserInputService.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 and listOpen then
                        local mousePos = UserInputService:GetMouseLocation()
                        local absPos = msList.AbsolutePosition
                        local absSize = msList.AbsoluteSize
                        if mousePos.X < absPos.X or mousePos.X > absPos.X + absSize.X or
                           mousePos.Y < absPos.Y or mousePos.Y > absPos.Y + absSize.Y then
                            closeMSList()
                        end
                    end
                end)

                updateDisplay()

                table.insert(sectionData.Elements, {
                    Type = "MultiSelect",
                    Name = msName,
                    Frame = msFrame,
                    GetSelected = function()
                        local sel = {}
                        for _, opt in ipairs(options) do
                            if selected[tostring(opt)] then
                                table.insert(sel, opt)
                            end
                        end
                        return sel
                    end,
                    Refresh = function(newOpts)
                        options = newOpts
                        if listOpen then populateMSList() end
                    end,
                })

                return {
                    Frame = msFrame,
                    GetSelected = function()
                        local sel = {}
                        for _, opt in ipairs(options) do
                            if selected[tostring(opt)] then
                                table.insert(sel, opt)
                            end
                        end
                        return sel
                    end,
                    Refresh = function(newOpts)
                        options = newOpts
                        if listOpen then populateMSList() end
                    end,
                }
            end

            -- INPUT LIST (for managing lists of values like whitelists)
            function sectionData:AddInputList(elementConfig)
                elementConfig = elementConfig or {}
                local ilName = elementConfig.Name or "Input List"
                local placeholder = elementConfig.Placeholder or "Add item..."
                local defaultItems = elementConfig.Default or {}
                local callback = elementConfig.Callback or function() end

                local ilFrame = Utility:Create("Frame", {
                    Name = ilName .. "_IL",
                    Size = UDim2.new(1, 0, 0, 0),
                    BackgroundColor3 = theme.SectionBackground,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ZIndex = 4,
                    LayoutOrder = #sectionData.Elements + 1,
                    AutomaticSize = Enum.AutomaticSize.Y,
                })
                ilFrame.Parent = sectionContent

                -- Label
                local ilLabel = Utility:Create("TextLabel", {
                    Size = UDim2.fromOffset(0, 18),
                    Position = UDim2.fromOffset(4, 2),
                    BackgroundTransparency = 1,
                    Text = "  " .. ilName,
                    TextColor3 = theme.LabelText,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 5,
                    RichText = true,
                    AutomaticSize = Enum.AutomaticSize.X,
                })
                ilLabel.Parent = ilFrame

                -- Input + Add button
                local inputRow = Utility:Create("Frame", {
                    Name = "InputRow",
                    Size = UDim2.new(1, -16, 0, 30),
                    Position = UDim2.fromOffset(8, 22),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ZIndex = 5,
                })
                inputRow.Parent = ilFrame

                local inputBox = Utility:Create("TextBox", {
                    Size = UDim2.new(1, -42, 1, 0),
                    BackgroundColor3 = theme.TextBoxBackground,
                    BackgroundTransparency = 0,
                    BorderSizePixel = 0,
                    PlaceholderText = placeholder,
                    PlaceholderColor3 = theme.TextBoxPlaceholder,
                    Text = "",
                    TextColor3 = theme.TextBoxText,
                    TextSize = 13,
                    Font = Enum.Font.Gotham,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 6,
                    ClearTextOnFocus = false,
                })
                Utility:Round(inputBox, 8)
                Utility:Stroke(inputBox, theme.SectionBorder, 1)
                inputBox.Parent = inputRow

                local addBtn = Utility:Create("TextButton", {
                    Size = UDim2.fromOffset(36, 30),
                    Position = UDim2.new(1, -36, 0, 0),
                    BackgroundColor3 = theme.Accent,
                    BackgroundTransparency = 0,
                    Text = "+",
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    TextSize = 18,
                    Font = Enum.Font.GothamBold,
                    AutoButtonColor = false,
                    ZIndex = 6,
                })
                Utility:Round(addBtn, 8)
                addBtn.Parent = inputRow

                -- Item list
                local itemList = Utility:Create("Frame", {
                    Name = "ItemList",
                    Size = UDim2.new(1, -16, 0, 0),
                    Position = UDim2.fromOffset(8, 56),
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    ZIndex = 5,
                    AutomaticSize = Enum.AutomaticSize.Y,
                })
                itemList.Parent = ilFrame

                local itemLayout = Utility:Create("UIListLayout", {
                    Padding = UDim.new(0, 4),
                    FillDirection = Enum.FillDirection.Vertical,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                })
                itemLayout.Parent = itemList

                local items = {}
                for _, item in ipairs(defaultItems) do
                    table.insert(items, tostring(item))
                end

                local function renderItems()
                    for _, child in pairs(itemList:GetChildren()) do
                        if child:IsA("Frame") then
                            child:Destroy()
                        end
                    end

                    for idx, itemText in ipairs(items) do
                        local itemFrame = Utility:Create("Frame", {
                            Name = "Item_" .. idx,
                            Size = UDim2.new(1, 0, 0, 28),
                            BackgroundColor3 = theme.DropdownBackground,
                            BackgroundTransparency = 0,
                            BorderSizePixel = 0,
                            ZIndex = 6,
                        })
                        Utility:Round(itemFrame, 6)
                        itemFrame.Parent = itemList

                        local itemLabel = Utility:Create("TextLabel", {
                            Size = UDim2.new(1, -36, 1, 0),
                            Position = UDim2.fromOffset(10, 0),
                            BackgroundTransparency = 1,
                            Text = "  " .. itemText,
                            TextColor3 = theme.DropdownText,
                            TextSize = 13,
                            Font = Enum.Font.Gotham,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            ZIndex = 7,
                        })
                        itemLabel.Parent = itemFrame

                        local removeBtn = Utility:Create("TextButton", {
                            Size = UDim2.fromOffset(20, 20),
                            Position = UDim2.new(1, -24, 0, 4),
                            BackgroundTransparency = 1,
                            Text = "✕",
                            TextColor3 = theme.Error,
                            TextSize = 12,
                            Font = Enum.Font.GothamBold,
                            AutoButtonColor = false,
                            ZIndex = 7,
                        })
                        removeBtn.Parent = itemFrame

                        removeBtn.MouseButton1Click:Connect(function()
                            table.remove(items, idx)
                            renderItems()
                            local s, e = pcall(callback, items)
                            if not s then warn("[ApexUI] InputList callback error:", e) end
                        end)
                    end
                end

                addBtn.MouseButton1Click:Connect(function()
                    local text = inputBox.Text
                    if text and text ~= "" then
                        table.insert(items, text)
                        inputBox.Text = ""
                        renderItems()
                        local s, e = pcall(callback, items)
                        if not s then warn("[ApexUI] InputList callback error:", e) end
                    end
                end)

                inputBox.FocusLost:Connect(function(enterPressed)
                    if enterPressed then
                        local text = inputBox.Text
                        if text and text ~= "" then
                            table.insert(items, text)
                            inputBox.Text = ""
                            renderItems()
                            local s, e = pcall(callback, items)
                            if not s then warn("[ApexUI] InputList callback error:", e) end
                        end
                    end
                end)

                renderItems()

                table.insert(sectionData.Elements, {
                    Type = "InputList",
                    Name = ilName,
                    Frame = ilFrame,
                    GetItems = function() return items end,
                    SetItems = function(newItems)
                        items = {}
                        for _, item in ipairs(newItems) do
                            table.insert(items, tostring(item))
                        end
                        renderItems()
                    end,
                    AddItem = function(item)
                        table.insert(items, tostring(item))
                        renderItems()
                        local s, e = pcall(callback, items)
                        if not s then warn("[ApexUI] InputList callback error:", e) end
                    end,
                })

                return {
                    Frame = ilFrame,
                    GetItems = function() return items end,
                    SetItems = function(newItems)
                        items = {}
                        for _, item in ipairs(newItems) do
                            table.insert(items, tostring(item))
                        end
                        renderItems()
                    end,
                    AddItem = function(item)
                        table.insert(items, tostring(item))
                        renderItems()
                    end,
                }
            end

            return sectionData
        end

        -- Auto-select first tab
        if #self.Tabs == 1 then
            self:SelectTab(name)
        end

        return tabInfo
    end

    -- Tab selection
    function windowData:SelectTab(name)
        for _, tab in ipairs(self.Tabs) do
            if tab.Name == name then
                tab.Page.Visible = true
                tab.Button.BackgroundTransparency = 0
                tab.Button.BackgroundColor3 = theme.TabSelectedBackground
                tab.Label.TextColor3 = theme.TabSelectedText
                if tab.IconLabel then
                    tab.IconLabel.TextColor3 = theme.TabSelectedText
                end
                Utility:Round(tab.Button, 6)
                self.ActiveTab = name
            else
                tab.Page.Visible = false
                tab.Button.BackgroundTransparency = 1
                tab.Label.TextColor3 = theme.TabUnselectedText
                if tab.IconLabel then
                    tab.IconLabel.TextColor3 = theme.TabUnselectedText
                end
            end
        end

        -- Update canvas size for active tab
        task.wait()
        local totalH = 0
        for _, child in ipairs(self.ScrollingContainer:GetChildren()) do
            if child:IsA("Frame") and child.Visible then
                totalH = totalH + child.AbsoluteSize.Y + 10
            end
        end
        self.ScrollingContainer.CanvasSize = UDim2.fromOffset(0, totalH + 40)
    end

    -- Search functionality
    if windowConfig.ShowSearch and searchBar then
        searchBar:GetPropertyChangedSignal("Text"):Connect(function()
            local query = searchBar.Text:lower()
            for _, tab in ipairs(windowData.Tabs) do
                local hasVisible = false
                -- Check section titles and element names
                for _, section in ipairs(tab.Sections) do
                    local sectionVisible = false
                    if query == "" then
                        sectionVisible = true
                    elseif section.Name:lower():find(query, 1, true) then
                        sectionVisible = true
                    else
                        for _, elem in ipairs(section.Elements) do
                            if elem.Name and elem.Name:lower():find(query, 1, true) then
                                sectionVisible = true
                                break
                            end
                        end
                    end
                    section.Frame.Visible = sectionVisible
                    if sectionVisible then
                        hasVisible = true
                    end
                end
                tab.Button.Visible = query == "" or hasVisible or tab.Name:lower():find(query, 1, true)
            end
        end)
    end

    -- Minimize/Maximize
    minBtn.MouseButton1Click:Connect(function()
        if not windowData.Minimized then
            windowData.Minimized = true
            windowData.PreviousSize = window.Size
            windowData.PreviousPosition = window.Position
            Utility:Tween(window, {Time = 0.3, EasingStyle = Enum.EasingStyle.Quint}, {
                Size = UDim2.new(0, window.AbsoluteSize.X, 0, 44),
                Position = UDim2.new(0, window.AbsolutePosition.X, 0, window.AbsolutePosition.Y),
            })
            task.delay(0.15, function()
                contentArea.Visible = false
                tabBar.Visible = false
                if searchFrame then searchFrame.Visible = false end
            end)
        else
            windowData.Minimized = false
            contentArea.Visible = true
            tabBar.Visible = true
            if searchFrame then searchFrame.Visible = true end
            Utility:Tween(window, {Time = 0.3, EasingStyle = Enum.EasingStyle.Quint}, {
                Size = windowData.PreviousSize,
                Position = windowData.PreviousPosition,
            })
        end
    end)

    -- Close
    closeBtn.MouseButton1Click:Connect(function()
        local fadeOut = Utility:Tween(window, {Time = 0.2}, {
            BackgroundTransparency = 1,
        })
        for _, child in pairs(window:GetDescendants()) do
            if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("ImageLabel") then
                pcall(function()
                    Utility:Tween(child, {Time = 0.1}, {TextTransparency = 1})
                end)
            end
        end
        fadeOut.Completed:Wait()
        gui:Destroy()
        if windowConfig.OnClose then
            windowConfig.OnClose()
        end
    end)

    -- Toggle visibility with keybind
    local toggleConn
    if windowConfig.ToggleKey ~= Enum.KeyCode.Unknown then
        toggleConn = UserInputService.InputBegan:Connect(function(input, gpe)
            if gpe then return end
            if input.KeyCode == windowConfig.ToggleKey then
                windowData.IsOpen = not windowData.IsOpen
                if windowData.IsOpen then
                    window.Visible = true
                    Utility:Tween(window, {Time = 0.2}, {
                        BackgroundTransparency = windowConfig.Transparency,
                    })
                else
                    Utility:Tween(window, {Time = 0.15}, {
                        BackgroundTransparency = 1,
                    })
                    task.delay(0.16, function()
                        window.Visible = false
                    end)
                end
            end
        end)
    end

    -- Update theme method
    function windowData:UpdateTheme()
        local newTheme = ApexUI:GetCurrentTheme()
        -- Update every themed element
        window.BackgroundColor3 = newTheme.WindowBackground
        for _, stroke in pairs(window:GetChildren()) do
            if stroke:IsA("UIStroke") then
                stroke.Color = newTheme.WindowBorder
            end
        end
        -- Title bar
        titleBar.BackgroundColor3 = newTheme.WindowTitleBackground
        titleLabel.TextColor3 = newTheme.WindowTitleText
        -- Tab bar
        tabBar.BackgroundColor3 = newTheme.TabBackground
        -- This is complex - for full theme updates, recommend Destroy + Recreate
        -- For now, update what's easily accessible
        ApexUI:Toast("Theme updated to " .. newTheme.Name, 2, "🎨")
    end

    -- Toggle window
    function windowData:Toggle()
        windowData.IsOpen = not windowData.IsOpen
        window.Visible = windowData.IsOpen
    end

    -- Set window visibility
    function windowData:SetVisible(visible)
        windowData.IsOpen = visible
        window.Visible = visible
    end

    -- Destroy window
    function windowData:Destroy()
        gui:Destroy()
    end

    -- Register window
    table.insert(self.ActiveWindows, windowData)
    table.insert(self.OpenWindows, windowData)

    -- Intro animation
    if config.Intro ~= false then
        local introText = config.IntroText or "ApexUI"
        window.Position = windowConfig.Position + UDim2.fromOffset(0, -30)
        window.BackgroundTransparency = 1

        Utility:Tween(window, {Time = 0.4, EasingStyle = Enum.EasingStyle.Quint}, {
            BackgroundTransparency = 0,
            Position = windowConfig.Position,
        })
    end

    -- Toast notification
    ApexUI:Toast("ApexUI v" .. ApexUI.Version .. " loaded", 2, "🚀")

    return windowData
end

-- ============================================================================
-- LIBRARY RETURN
-- ============================================================================

return ApexUI
