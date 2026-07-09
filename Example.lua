--[[
    ApexUI — Example Script
    Demonstrates all features of the ApexUI library
]]

local ApexUI = loadstring(game:HttpGetAsync and game:HttpGetAsync("https://raw.githubusercontent.com/youngboyfan/ApexUI/main/apexui.lua") or
                         readfile and readfile("apexui.lua") or
                         loadfile("apexui.lua"))()

local Player = game:GetService("Players").LocalPlayer
local Mouse = Player:GetMouse()
local RunService = game:GetService("RunService")

-- ── Window ──
local Window = ApexUI:CreateWindow({
    Name = "ApexUI",
    ToggleKey = Enum.KeyCode.RightControl,
})

-- ── Combat Tab ──
local CombatTab = Window:AddTab("Combat", "rbxassetid://4384403532")
local MainSection = CombatTab:AddSection("Main")
local WeaponsSection = CombatTab:AddSection("Weapons")

local aimbotEnabled = false
MainSection:AddToggle({
    Name = "Aimbot",
    Default = false,
    Callback = function(state)
        aimbotEnabled = state
        ApexUI:Notify({Title = "Aimbot", Content = state and "Enabled" or "Disabled", Duration = 2, Icon = "rbxassetid://4384403532"})
    end,
})

MainSection:AddDropdown({
    Name = "Target Part",
    Options = {"Head", "Torso", "HumanoidRootPart", "Left Leg", "Right Leg"},
    Default = "Head",
    Callback = function(v) print("Target:", v) end,
})

MainSection:AddSlider({
    Name = "Smoothness",
    Min = 1,
    Max = 100,
    Default = 50,
    Suffix = "%",
    Callback = function(v) print("Smoothness:", v) end,
})

MainSection:AddButton({
    Name = "Trigger Bot",
    Callback = function()
        ApexUI:Notify({Title = "Trigger Bot", Content = "Activated", Duration = 3, Icon = "rbxassetid://4384403532"})
    end,
})

WeaponsSection:AddDropdown({
    Name = "Weapon",
    Options = {"Sword", "Gun", "Bow", "Staff"},
    Default = "Sword",
    Callback = function(v) print("Weapon:", v) end,
})

WeaponsSection:AddSlider({
    Name = "Damage",
    Min = 1,
    Max = 50,
    Default = 1,
    Suffix = "x",
    Decimals = 1,
    Callback = function(v) print("Damage:", v) end,
})

WeaponsSection:AddToggle({
    Name = "Instant Kill",
    Default = false,
    Callback = function(s) print("Instant Kill:", s) end,
})

-- ── Movement Tab ──
local MoveTab = Window:AddTab("Movement", "rbxassetid://4384403532")
local CharSection = MoveTab:AddSection("Character")
local FlySection = MoveTab:AddSection("Flight")

CharSection:AddSlider({
    Name = "Walk Speed",
    Min = 1, Max = 200, Default = 16, Suffix = "",
    Callback = function(v)
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.WalkSpeed = v
        end
    end,
})

CharSection:AddSlider({
    Name = "Jump Power",
    Min = 10, Max = 500, Default = 50,
    Callback = function(v)
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then
            Player.Character.Humanoid.JumpPower = v
        end
    end,
})

CharSection:AddToggle({
    Name = "No Clip",
    Default = false,
    Callback = function(s) print("NoClip:", s) end,
})

CharSection:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(s) print("InfJump:", s) end,
})

FlySection:AddToggle({
    Name = "Fly",
    Default = false,
    Callback = function(s)
        ApexUI:Notify({Title = "Flight", Content = s and "Enabled" or "Disabled", Duration = 2})
    end,
})

FlySection:AddSlider({
    Name = "Fly Speed",
    Min = 1, Max = 100, Default = 16,
    Callback = function(v) print("FlySpeed:", v) end,
})

-- ── Visuals Tab ──
local VisTab = Window:AddTab("Visuals", "rbxassetid://4384403532")
local ESPSection = VisTab:AddSection("ESP")
local WorldSection = VisTab:AddSection("World")

ESPSection:AddToggle({Name = "Player ESP", Default = false, Callback = function(s) print("ESP:", s) end})
ESPSection:AddToggle({Name = "Tracers", Default = false, Callback = function(s) print("Tracers:", s) end})
ESPSection:AddToggle({Name = "Box ESP", Default = true, Callback = function(s) print("Box:", s) end})
ESPSection:AddDropdown({Name = "ESP Color", Options = {"Red","Green","Blue","Yellow","Purple","White"}, Default = "Red", Callback = function(v) print("ESP Color:", v) end})

WorldSection:AddToggle({Name = "Full Bright", Default = false, Callback = function(s)
    game:GetService("Lighting").Brightness = s and 2 or 1
    game:GetService("Lighting").Ambient = s and Color3.fromRGB(255,255,255) or Color3.fromRGB(128,128,128)
end})
WorldSection:AddSlider({Name = "Field of View", Min = 60, Max = 120, Default = 70, Suffix = "°",
    Callback = function(v) workspace.CurrentCamera.FieldOfView = v end})
WorldSection:AddToggle({Name = "Reduce Fog", Default = false, Callback = function(s)
    game:GetService("Lighting").FogEnd = s and 100000 or 50000
end})

-- ── Settings Tab ──
local SetTab = Window:AddTab("Settings", "rbxassetid://4384403532")
local UISection = SetTab:AddSection("UI Settings")
local NotifSection = SetTab:AddSection("Notifications")
local ConfigSection = SetTab:AddSection("Configuration")
local TestSection = SetTab:AddSection("Element Showcase")

UISection:AddDropdown({
    Name = "Theme",
    Options = ApexUI:GetThemeList(),
    Default = ApexUI.CurrentTheme,
    Callback = function(name)
        ApexUI:SetTheme(name)
        ApexUI:Notify({Title = "Theme", Content = "Switched to " .. name, Duration = 2})
    end,
})

UISection:AddColorPicker({
    Name = "Accent Color",
    Default = Color3.fromRGB(40, 100, 255),
    Callback = function(c) print("Accent:", c) end,
})

UISection:AddKeybind({
    Name = "Toggle UI",
    Default = Enum.KeyCode.RightControl,
    Callback = function() Window:Toggle() end,
    ChangeCallback = function(k) print("New toggle key:", k) end,
})

UISection:AddKeybind({
    Name = "Panic Button",
    Default = Enum.KeyCode.F5,
    Callback = function()
        Window:SetVisible(false)
        task.wait(5)
        Window:SetVisible(true)
    end,
})

NotifSection:AddButton({
    Name = "Test Notification",
    Callback = function()
        ApexUI:Notify({Title = "Test", Content = "This is a test notification!", Duration = 4, Icon = "rbxassetid://4384403532"})
    end,
})

NotifSection:AddButton({
    Name = "Send Toast",
    Callback = function()
        ApexUI:Notify({Title = "Toast", Content = "Quick action!", Duration = 2})
    end,
})

ConfigSection:AddTextbox({
    Name = "Config Name",
    Placeholder = "Enter name...",
    Default = "My Config",
    Callback = function(v) print("Config name:", v) end,
})

ConfigSection:AddTextbox({
    Name = "Numeric Value",
    Placeholder = "0-100",
    Default = "50",
    Numeric = true,
    Callback = function(v) print("Numeric:", v) end,
})

ConfigSection:AddLabel({Text = "ApexUI v1.0.0 | Ultimate Roblox UI Library"})
ConfigSection:AddLabel({Text = "Player: " .. Player.Name, Color = Color3.fromRGB(100, 200, 255)})

ConfigSection:AddParagraph({
    Title = "About",
    Content = "ApexUI is a feature-rich UI library for Roblox.\n\nCreated with patterns from Kavo, Orion, Venyx, LinoriaLib, and more.\n\n" ..
              "Features:\n• Buttons with hover effects\n• Toggles with smooth animation\n• Sliders with real-time feedback\n" ..
              "• Dropdown menus\n• Text inputs with validation\n• Keybinds with rebinding\n• Color picker with HSV/Hex\n" ..
              "• Notification system\n\nTheme: " .. ApexUI.CurrentTheme,
})

-- Element showcase
TestSection:AddButton({Name = "Button Test", Callback = function() ApexUI:Notify({Title="Button", Content="Clicked!", Duration=1}) end})
TestSection:AddToggle({Name = "Toggle Test", Default = true, Callback = function() end})
TestSection:AddSlider({Name = "Slider Test", Min = 0, Max = 100, Default = 50, Suffix = "%"})
TestSection:AddDropdown({Name = "Dropdown Test", Options = {"A", "B", "C", "D"}, Default = "A"})
TestSection:AddTextbox({Name = "Textbox Test", Placeholder = "Type..."})
TestSection:AddKeybind({Name = "Keybind Test", Default = Enum.KeyCode.F})
TestSection:AddColorPicker({Name = "Color Test", Default = Color3.fromRGB(255, 100, 50)})

-- Welcome
task.spawn(function()
    task.wait(1)
    ApexUI:Notify({Title = "Welcome", Content = "ApexUI loaded! Press RightControl to toggle.", Duration = 4, Icon = "rbxassetid://4384403532"})
end)

print("=== ApexUI Example Loaded ===")
print("Theme:", ApexUI.CurrentTheme)
print("Press RightControl to toggle")

return Window
