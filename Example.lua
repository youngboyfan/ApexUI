--[[
╔══════════════════════════════════════════════════════════════════════╗
║                  APEX UI — COMPREHENSIVE EXAMPLE                    ║
║                                                                     ║
║  This script demonstrates every feature of the ApexUI library.      ║
║  It creates a fully-functional, visually stunning UI with all       ║
║  available element types and configurations.                        ║
╚══════════════════════════════════════════════════════════════════════╝
--]]

-- ============================================================================
-- LOAD THE LIBRARY
-- ============================================================================

-- Option 1: Local file (for development)
local ApexUI = loadstring(game:HttpGetAsync and game:HttpGetAsync("https://raw.githubusercontent.com/your-repo/ApexUI/main/apexui.lua") or
                         readfile and readfile("apexui.lua") or
                         loadfile("apexui.lua"))()

-- Option 2: Load from GitHub (for production)
-- local ApexUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/your-repo/ApexUI/main/apexui.lua"))()

-- Fallback: if using the repo directly
if not ApexUI then
    ApexUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
    warn("ApexUI not found, demonstrating with fallback - This is just for safety!")
end

-- ============================================================================
-- PLAYER REFERENCE
-- ============================================================================

local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ============================================================================
-- CREATE THE MAIN WINDOW
-- ============================================================================

local Window = ApexUI:CreateWindow({
    Name = "ApexUI Dashboard",              -- Window title
    -- Icon = "rbxassetid://1234567890",     -- Optional: icon image
    Theme = "Dark Matter",                   -- Theme: Dark Matter, Arctic Frost, Neon Genesis, Minimalist
    Size = UDim2.fromOffset(720, 540),       -- Window size
    MinSize = Vector2.new(480, 360),         -- Minimum window size
    ToggleKey = Enum.KeyCode.RightControl,   -- Key to toggle UI visibility
    ShowNotifications = true,                -- Enable notification system
    ShowSearch = true,                       -- Show search bar
    TitlebarGradient = false,                -- Gradient on titlebar
    AnimationStyle = "Slide",                -- Intro animation style
    Resizable = true,                        -- Allow resizing
    Draggable = true,                        -- Allow dragging
    Transparency = 0,                        -- Window transparency (0-0.3)
    AccentColor = nil,                       -- Optional: override accent color
    Intro = true,                            -- Show intro animation
    IntroText = "ApexUI v1.0",              -- Intro text
    OnClose = function()                     -- Called when window is closed
        print("ApexUI window closed")
    end,
})

-- ============================================================================
-- DEMO STATE VARIABLES
-- ============================================================================

local State = {
    AutoFarm = false,
    WalkSpeed = 16,
    JumpPower = 50,
    ESP = false,
    Aimbot = false,
    SelectedWeapon = "Sword",
    SpeedMultiplier = 1,
    TargetPart = "Head",
    SelectedPlayers = {},
    Whitelist = {},
    ThemeColor = Color3.fromRGB(40, 100, 255),
    NotificationCount = 0,
}

-- ============================================================================
-- TAB 1: COMBAT
-- ============================================================================

local CombatTab = Window:AddTab("Combat", "⚔")

-- Combat → Main Section
local mainSection = CombatTab:AddSection("Main")

-- Toggle: Aimbot
local aimbotToggle = mainSection:AddToggle({
    Name = "Aimbot",
    Description = "Automatically aims at the nearest target",
    Default = false,
    Callback = function(state)
        State.Aimbot = state
        ApexUI:Toast("Aimbot " .. (state and "enabled" or "disabled"), 1.5, state and "🎯" or "🚫")
        print("Aimbot:", state)
    end,
})

-- Dropdown: Target Part
mainSection:AddDropdown({
    Name = "Target Part",
    Description = "Which body part to aim at",
    Options = {"Head", "Torso", "HumanoidRootPart", "Left Leg", "Right Leg"},
    Default = "Head",
    Callback = function(value)
        State.TargetPart = value
        print("Target part changed to:", value)
    end,
})

-- Slider: Aimbot Smoothness
mainSection:AddSlider({
    Name = "Aimbot Smoothness",
    Description = "How smooth the aim transition is",
    Min = 1,
    Max = 100,
    Default = 50,
    Suffix = "%",
    Decimals = 0,
    Callback = function(value)
        print("Aimbot smoothness set to:", value)
    end,
})

-- Button: Trigger Bot
mainSection:AddButton({
    Name = "Trigger Bot",
    Description = "Automatically shoots when瞄准目标",
    Callback = function()
        ApexUI:Notify({
            Title = "Trigger Bot",
            Content = "Trigger bot activated! Auto-firing on sight.",
            Duration = 3,
            Icon = "🔫",
        })
        print("Trigger bot activated")
    end,
})

-- Combat → Weapons Section
local weaponsSection = CombatTab:AddSection("Weapons")

-- Dropdown: Weapon Selection
mainSection:AddDropdown({
    Name = "Select Weapon",
    Description = "Choose your weapon type",
    Options = {"Sword", "Gun", "Bow", "Staff", "Dagger"},
    Default = "Sword",
    Callback = function(value)
        State.SelectedWeapon = value
        print("Weapon selected:", value)
    end,
})

-- Slider: Damage Multiplier
weaponsSection:AddSlider({
    Name = "Damage Multiplier",
    Min = 1,
    Max = 50,
    Default = 1,
    Suffix = "x",
    Decimals = 1,
    Callback = function(value)
        print("Damage multiplier set to:", value)
    end,
})

-- Toggle: Instant Kill
weaponsSection:AddToggle({
    Name = "Instant Kill",
    Description = "One-hit kill enemies",
    Default = false,
    Callback = function(state)
        print("Instant kill:", state)
    end,
})

-- Button: Reset Weapon
weaponsSection:AddButton({
    Name = "Reset Weapon Stats",
    Description = "Reset all weapon modifications",
    Callback = function()
        ApexUI:Toast("Weapon stats reset", 1.5, "🔄")
        print("Weapon stats reset")
    end,
})

-- ============================================================================
-- TAB 2: MOVEMENT
-- ============================================================================

local MovementTab = Window:AddTab("Movement", "🏃")

-- Movement → Character Section
local charSection = MovementTab:AddSection("Character")

-- Slider: Walk Speed
charSection:AddSlider({
    Name = "Walk Speed",
    Description = "Player movement speed",
    Min = 1,
    Max = 200,
    Default = 16,
    Suffix = " studs/s",
    Decimals = 0,
    Callback = function(value)
        State.WalkSpeed = value
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = value
        end
    end,
})

-- Slider: Jump Power
charSection:AddSlider({
    Name = "Jump Power",
    Description = "Player jump height",
    Min = 10,
    Max = 500,
    Default = 50,
    Suffix = "",
    Decimals = 0,
    Callback = function(value)
        State.JumpPower = value
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.JumpPower = value
        end
    end,
})

-- Toggle: No Clip
charSection:AddToggle({
    Name = "No Clip",
    Description = "Walk through walls",
    Default = false,
    Callback = function(state)
        print("No Clip:", state)
        ApexUI:Toast("No Clip " .. (state and "enabled" or "disabled"), 1.5)
    end,
})

-- Toggle: Infinite Jump
charSection:AddToggle({
    Name = "Infinite Jump",
    Description = "Jump infinitely in the air",
    Default = false,
    Callback = function(state)
        print("Infinite Jump:", state)
        if state then
            ApexUI:Notify({
                Title = "Infinite Jump",
                Content = "Press Space repeatedly to fly!",
                Duration = 3,
                Icon = "🦘",
            })
        end
    end,
})

-- Movement → Flight Section
local flightSection = MovementTab:AddSection("Flight")

-- Toggle: Fly
flightSection:AddToggle({
    Name = "Fly",
    Description = "Enable flight mode",
    Default = false,
    Callback = function(state)
        print("Fly:", state)
        ApexUI:Notify({
            Title = "Flight",
            Content = state and "Flight enabled! Use WASD to move." or "Flight disabled.",
            Duration = 2,
            Icon = "✈",
        })
    end,
})

-- Slider: Fly Speed
flightSection:AddSlider({
    Name = "Fly Speed",
    Min = 1,
    Max = 100,
    Default = 16,
    Suffix = "",
    Decimals = 0,
    Callback = function(value)
        print("Fly speed set to:", value)
    end,
})

-- ============================================================================
-- TAB 3: VISUALS
-- ============================================================================

local VisualsTab = Window:AddTab("Visuals", "👁")

-- Visuals → ESP Section
local espSection = VisualsTab:AddSection("ESP")

-- Toggle: Player ESP
espSection:AddToggle({
    Name = "Player ESP",
    Description = "See players through walls",
    Default = false,
    Callback = function(state)
        State.ESP = state
        print("Player ESP:", state)
    end,
})

-- Toggle: Tracers
espSection:AddToggle({
    Name = "Tracers",
    Description = "Draw lines to players",
    Default = false,
    Callback = function(state)
        print("Tracers:", state)
    end,
})

-- Toggle: Box ESP
espSection:AddToggle({
    Name = "Box ESP",
    Description = "Draw boxes around players",
    Default = true,
    Callback = function(state)
        print("Box ESP:", state)
    end,
})

-- Dropdown: ESP Color
espSection:AddDropdown({
    Name = "ESP Color",
    Options = {"Red", "Green", "Blue", "Yellow", "Purple", "White"},
    Default = "Red",
    Callback = function(value)
        print("ESP color changed to:", value)
    end,
})

-- Visuals → World Section
local worldSection = VisualsTab:AddSection("World")

-- Toggle: Full Bright
worldSection:AddToggle({
    Name = "Full Bright",
    Description = "Maximum brightness level",
    Default = false,
    Callback = function(state)
        print("Full Bright:", state)
        if state then
            game:GetService("Lighting").Brightness = 2
            game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
        else
            game:GetService("Lighting").Brightness = 1
            game:GetService("Lighting").Ambient = Color3.fromRGB(128, 128, 128)
        end
    end,
})

-- Slider: Field of View
worldSection:AddSlider({
    Name = "Field of View",
    Min = 60,
    Max = 120,
    Default = 70,
    Suffix = "°",
    Decimals = 0,
    Callback = function(value)
        workspace.CurrentCamera.FieldOfView = value
    end,
})

-- Toggle: Reduce Fog
worldSection:AddToggle({
    Name = "Reduce Fog",
    Description = "Remove fog for better visibility",
    Default = false,
    Callback = function(state)
        print("Fog reduced:", state)
        if state then
            game:GetService("Lighting").FogEnd = 100000
        end
    end,
})

-- ============================================================================
-- TAB 4: SETTINGS
-- ============================================================================

local SettingsTab = Window:AddTab("Settings", "⚙")

-- Settings → UI Section
local uiSection = SettingsTab:AddSection("UI Settings")

-- Dropdown: Theme Selector
uiSection:AddDropdown({
    Name = "Theme",
    Description = "Choose the UI color theme",
    Options = ApexUI:GetThemes(),
    Default = "Dark Matter",
    Callback = function(themeName)
        ApexUI:SetTheme(themeName)
        ApexUI:Notify({
            Title = "Theme Changed",
            Content = "Switched to: " .. themeName,
            Duration = 2,
            Icon = "🎨",
        })
    end,
})

-- Button: Cycle Theme
uiSection:AddButton({
    Name = "Cycle Theme",
    Description = "Rotate through all available themes",
    Callback = function()
        local themes = ApexUI:GetThemes()
        local currentIdx = 1
        for i, t in ipairs(themes) do
            if t == ApexUI.CurrentTheme then
                currentIdx = i
                break
            end
        end
        local nextIdx = currentIdx % #themes + 1
        ApexUI:SetTheme(themes[nextIdx])
        ApexUI:Notify({
            Title = "Theme: " .. themes[nextIdx],
            Content = "Cycled to the next theme!",
            Duration = 2,
            Icon = "🎨",
        })
    end,
})

-- Color Picker: Accent Color
uiSection:AddColorPicker({
    Name = "Accent Color",
    Description = "Change the primary accent color",
    Default = Color3.fromRGB(40, 100, 255),
    Callback = function(color)
        State.ThemeColor = color
        print("Accent color changed:", color)
    end,
})

-- Settings → Notifications Section
local notifSection = SettingsTab:AddSection("Notifications")

-- Button: Test Notification
notifSection:AddButton({
    Name = "Send Test Notification",
    Description = "Display a demo notification",
    Callback = function()
        State.NotificationCount = State.NotificationCount + 1
        ApexUI:Notify({
            Title = "Test #" .. State.NotificationCount,
            Content = "This is a test notification from ApexUI!\nNotifications support multiple lines of text.",
            Duration = 5,
            Icon = "📬",
        })
    end,
})

-- Button: Toast Test
notifSection:AddButton({
    Name = "Send Test Toast",
    Description = "Display a small bottom-right toast",
    Callback = function()
        ApexUI:Toast("Quick action completed!", 2, "✓")
    end,
})

-- Button: Error Notification
notifSection:AddButton({
    Name = "Send Error Notification",
    Description = "Simulate an error notification",
    Callback = function()
        ApexUI:Notify({
            Title = "Error Occurred",
            Content = "Something went wrong, but don't worry — this is just a test!",
            Duration = 4,
            Icon = "⚠",
        })
    end,
})

-- Multi-Select: Notification Types
notifSection:AddMultiSelect({
    Name = "Notification Types",
    Options = {"Info", "Warning", "Error", "Success", "Debug"},
    Default = {"Info", "Success"},
    MaxDisplay = 3,
    Callback = function(selected)
        print("Enabled notifications:", table.concat(selected, ", "))
    end,
})

-- Settings → Configuration Section
local configSection = SettingsTab:AddSection("Configuration")

-- TextBox: Config Name
configSection:AddTextbox({
    Name = "Configuration Name",
    Placeholder = "Enter config name...",
    Default = "My Config",
    Callback = function(value)
        print("Config name set to:", value)
    end,
})

-- TextBox: Numeric Input
configSection:AddTextbox({
    Name = "Numeric Value",
    Placeholder = "Enter a number...",
    Default = "42",
    Numeric = true,
    Callback = function(value)
        print("Numeric value:", value)
    end,
})

-- InputList: Whitelist
configSection:AddInputList({
    Name = "Whitelist",
    Placeholder = "Enter username or ID...",
    Default = {"Player1", "Player2"},
    Callback = function(items)
        State.Whitelist = items
        print("Whitelist updated:", #items, "items")
    end,
})

-- Keybind: Toggle UI
configSection:AddKeybind({
    Name = "Toggle UI",
    Description = "Key to show/hide the UI",
    Default = Enum.KeyCode.RightControl,
    ChangeCallback = function(newKey)
        ApexUI:Toast("Toggle key changed", 1.5, "🔑")
    end,
    Callback = function()
        Window:Toggle()
    end,
})

-- Keybind: Panic Key
configSection:AddKeybind({
    Name = "Panic Button",
    Description = "Quickly hide everything",
    Default = Enum.KeyCode.F5,
    ChangeCallback = function(newKey)
        print("Panic key set to:", newKey)
    end,
    Callback = function()
        -- Hide GUI in panic
        ApexUI:Notify({
            Title = "⚠ PANIC MODE",
            Content = "Hiding all UI elements!",
            Duration = 2,
            Icon = "🚨",
        })
        Window:SetVisible(false)
        task.wait(5)
        Window:SetVisible(true)
    end,
})

-- Settings → Custom Theme Section
local customThemeSection = SettingsTab:AddSection("Custom Theme Creator")

-- Dropdown: Base Theme
customThemeSection:AddDropdown({
    Name = "Base Theme",
    Options = {"Dark Matter", "Arctic Frost", "Neon Genesis", "Minimalist"},
    Default = "Dark Matter",
})

-- Button: Create Custom Theme
customThemeSection:AddButton({
    Name = "Create Custom Theme",
    Description = "Create a new theme from current settings",
    Callback = function()
        local success = ApexUI:CreateCustomTheme("My Theme", {
            WindowBackground = Color3.fromRGB(30, 20, 40),
            WindowBorder = Color3.fromRGB(60, 40, 80),
            Accent = State.ThemeColor,
            ButtonBackground = State.ThemeColor,
            -- ... other colors will use defaults
        })
        if success then
            ApexUI:Notify({
                Title = "Theme Created",
                Content = "Custom theme 'My Theme' has been added!",
                Duration = 3,
                Icon = "✨",
            })
        end
    end,
})

-- ============================================================================
-- TAB 5: MULTI-SELECT & ADVANCED ELEMENTS
-- ============================================================================

local AdvancedTab = Window:AddTab("Advanced", "🔧")

-- Advanced → Multi-Select Demo
local msDemoSection = AdvancedTab:AddSection("Multi-Select Dropdown")

-- Multi-Select: Game Features
msDemoSection:AddMultiSelect({
    Name = "Active Features",
    Options = {"Aimbot", "ESP", "Wallhack", "Speed", "Flight", "NoClip", "God Mode"},
    Default = {"ESP", "Speed"},
    MaxDisplay = 4,
    Callback = function(selected)
        print("Active features:", table.concat(selected, ", "))
    end,
})

-- Multi-Select: Target Filter
msDemoSection:AddMultiSelect({
    Name = "Target Filter",
    Options = {"Friends", "Enemies", "Neutral", "Team", "All"},
    Default = {"All"},
    MaxDisplay = 3,
    Callback = function(selected)
        print("Target filter:", table.concat(selected, ", "))
    end,
})

-- Advanced → Input List Demo
local ilSection = AdvancedTab:AddSection("Input List / Manager")

-- Input List: Banned Users
ilSection:AddInputList({
    Name = "Banned Users",
    Placeholder = "Add username...",
    Default = {"User123", "Hacker42", "Bot_001"},
    Callback = function(items)
        print("Banned users:", #items)
    end,
})

-- Input List: Hotkeys
ilSection:AddInputList({
    Name = "Favorite Teleports",
    Placeholder = "Coordinate x,y,z...",
    Default = {"100, 50, 200", "0, 100, 0"},
    Callback = function(items)
        print("Teleport locations:", #items)
    end,
})

-- Advanced → Color Picker Demo
local cpSection = AdvancedTab:AddSection("Color Picker")

-- Color Picker: Crosshair Color
cpSection:AddColorPicker({
    Name = "Crosshair Color",
    Default = Color3.fromRGB(255, 50, 50),
    Callback = function(color)
        print("Crosshair color set to RGB:", color.R, color.G, color.B)
    end,
})

-- Color Picker: Watermark Color
cpSection:AddColorPicker({
    Name = "Watermark Color",
    Default = Color3.fromRGB(50, 255, 150),
    Callback = function(color)
        print("Watermark color changed:", color)
    end,
})

-- Advanced → Labels & Info
local infoSection = AdvancedTab:AddSection("Information")

-- Label: Static Info
infoSection:AddLabel({
    Text = "ApexUI v1.0.0 | Ultimate Roblox UI",
    Color = Color3.fromRGB(40, 100, 255),
})

-- Label: Dynamic (updatable)
local playerCountLabel = infoSection:AddLabel({
    Text = "Players: " .. #game:GetService("Players"):GetPlayers(),
})

-- Paragraph: Documentation
infoSection:AddParagraph({
    Title = "About This Demo",
    Content = "This example showcases all features of the ApexUI library. " ..
              "Every UI element is fully functional and interactive.\n\n" ..
              "Features demonstrated:\n" ..
              "• Buttons with ripple effects\n" ..
              "• Toggles with smooth animations\n" ..
              "• Sliders with real-time feedback\n" ..
              "• Dropdown menus with search\n" ..
              "• Multi-select dropdowns\n" ..
              "• Text inputs with validation\n" ..
              "• Keybinds with rebinding\n" ..
              "• Color picker with HSV/Hex\n" ..
              "• Input lists for item management\n" ..
              "• Notification & toast system\n\n" ..
              "Theme: " .. ApexUI.CurrentTheme,
})

-- ============================================================================
-- TAB 6: THEME PREVIEW
-- ============================================================================

local ThemeTab = Window:AddTab("Themes", "🎨")

-- Theme → Preview Section
local previewSection = ThemeTab:AddSection("Theme Previews")

-- Labels showing each theme
for _, themeName in ipairs(ApexUI:GetThemes()) do
    previewSection:AddButton({
        Name = "  " .. themeName,
        Description = "Apply this theme",
        Callback = function()
            ApexUI:SetTheme(themeName)
            ApexUI:Notify({
                Title = "Theme: " .. themeName,
                Content = "Switched to " .. themeName .. " theme!",
                Duration = 2,
                Icon = "🎨",
            })
        end,
    })
end

-- Theme → Preview All Elements
local allElementsSection = ThemeTab:AddSection("Element Showcase")

-- Showcase of all elements for theme testing
allElementsSection:AddButton({
    Name = "Demo Button",
    Description = "Click to test",
    Callback = function()
        ApexUI:Toast("Button clicked!", 1, "✓")
    end,
})

allElementsSection:AddToggle({
    Name = "Demo Toggle",
    Default = true,
    Callback = function() end,
})

allElementsSection:AddSlider({
    Name = "Demo Slider",
    Min = 0,
    Max = 100,
    Default = 50,
    Suffix = "%",
})

allElementsSection:AddDropdown({
    Name = "Demo Dropdown",
    Options = {"Option A", "Option B", "Option C", "Option D"},
    Default = "Option A",
})

allElementsSection:AddTextbox({
    Name = "Demo TextBox",
    Placeholder = "Type something...",
})

allElementsSection:AddKeybind({
    Name = "Demo Keybind",
    Default = Enum.KeyCode.F,
})

allElementsSection:AddColorPicker({
    Name = "Demo Color",
    Default = Color3.fromRGB(255, 100, 50),
})

-- ============================================================================
-- TESTING NOTIFICATIONS SYSTEM
-- ============================================================================

-- Spawn a welcome notification after a short delay
task.spawn(function()
    task.wait(1)
    ApexUI:Notify({
        Title = "Welcome to ApexUI",
        Content = "This is the comprehensive example script.\n" ..
                  "Explore all tabs to see every feature in action!\n\n" ..
                  "💡 Tip: Use the search bar to find settings quickly.",
        Duration = 6,
        Icon = "👋",
    })
end)

-- ============================================================================
-- BACKGROUND UPDATES (optional)
-- ============================================================================

-- Update player count periodically
task.spawn(function()
    while task.wait(5) do
        local count = #game:GetService("Players"):GetPlayers()
        if playerCountLabel and playerCountLabel.SetText then
            playerCountLabel:SetText("Players: " .. count)
        end
    end
end)

-- ============================================================================
-- PRINT COMPLETION
-- ============================================================================

print("=" .. string.rep("=", 60) .. "=")
print("  ApexUI Example loaded successfully!")
print("  Version: " .. ApexUI.Version)
print("  Theme: " .. ApexUI.CurrentTheme)
print("  Press RightControl to toggle the UI")
print("=" .. string.rep("=", 60) .. "=")

-- Return the window for external control
return Window
