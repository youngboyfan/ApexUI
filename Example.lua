local ApexUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/youngboyfan/ApexUI/main/apexui.lua"))()

local Window = ApexUI:CreateLib("ApexUI", "Dark")

-- Combat
local CombatTab = Window:NewTab("Combat")
local MainSection = CombatTab:NewSection("Main")
local WeaponsSection = CombatTab:NewSection("Weapons")

MainSection:NewToggle("Aimbot", "Auto-aim at enemies", function(state)
    print("Aimbot:", state)
end)

MainSection:NewDropdown("Target Part", "Body part to aim at", {"Head", "Torso", "HumanoidRootPart"}, function(v)
    print("Target:", v)
end)

MainSection:NewSlider("Smoothness", "Aim transition smoothness", 100, 1, function(v)
    print("Smoothness:", v)
end)

MainSection:NewButton("Trigger Bot", "Auto-shoot when瞄准", function()
    ApexUI:Notify("Trigger Bot", "Activated!")
end)

WeaponsSection:NewDropdown("Weapon", "Select weapon", {"Sword", "Gun", "Bow", "Staff"}, function(v)
    print("Weapon:", v)
end)

WeaponsSection:NewSlider("Damage", "Damage multiplier", 50, 1, function(v)
    print("Damage:", v)
end)

WeaponsSection:NewToggle("Instant Kill", "One-hit kill", function(s)
    print("Instant Kill:", s)
end)

-- Movement
local MoveTab = Window:NewTab("Movement")
local CharSection = MoveTab:NewSection("Character")
local FlySection = MoveTab:NewSection("Flight")

CharSection:NewSlider("Walk Speed", "Movement speed", 200, 16, function(v)
    local p = game.Players.LocalPlayer
    if p.Character and p.Character:FindFirstChild("Humanoid") then
        p.Character.Humanoid.WalkSpeed = v
    end
end)

CharSection:NewSlider("Jump Power", "Jump height", 500, 50, function(v)
    local p = game.Players.LocalPlayer
    if p.Character and p.Character:FindFirstChild("Humanoid") then
        p.Character.Humanoid.JumpPower = v
    end
end)

CharSection:NewToggle("No Clip", "Walk through walls", function(s) print("NoClip:", s) end)
CharSection:NewToggle("Infinite Jump", "Jump in mid-air", function(s) print("InfJump:", s) end)

FlySection:NewToggle("Fly", "Enable flight", function(s)
    ApexUI:Notify("Flight", s and "Enabled" or "Disabled")
end)

FlySection:NewSlider("Fly Speed", "Flight speed", 100, 16, function(v) print("FlySpeed:", v) end)

-- Visuals
local VisTab = Window:NewTab("Visuals")
local ESPSection = VisTab:NewSection("ESP")
local WorldSection = VisTab:NewSection("World")

ESPSection:NewToggle("Player ESP", "See players through walls", function(s) print("ESP:", s) end)
ESPSection:NewToggle("Tracers", "Draw lines to players", function(s) print("Tracers:", s) end)
ESPSection:NewToggle("Box ESP", "Draw boxes around players", function(s) print("Box:", s) end)
ESPSection:NewDropdown("ESP Color", "Choose color", {"Red","Green","Blue","Yellow","Purple","White"}, function(v) print("ESP Color:", v) end)

WorldSection:NewToggle("Full Bright", "Max brightness", function(s)
    game:GetService("Lighting").Brightness = s and 2 or 1
    game:GetService("Lighting").Ambient = s and Color3.fromRGB(255,255,255) or Color3.fromRGB(128,128,128)
end)
WorldSection:NewSlider("Field of View", "Camera FOV", 120, 70, function(v)
    workspace.CurrentCamera.FieldOfView = v
end)
WorldSection:NewToggle("Reduce Fog", "Remove fog", function(s)
    game:GetService("Lighting").FogEnd = s and 100000 or 50000
end)

-- Settings
local SetTab = Window:NewTab("Settings")
local UISection = SetTab:NewSection("UI Settings")
local NotifSection = SetTab:NewSection("Notifications")
local ConfigSection = SetTab:NewSection("Configuration")
local InfoSection = SetTab:NewSection("Information")

UISection:NewDropdown("Theme", "Change UI theme", {"Dark", "Ocean", "Blood", "Grape", "Midnight", "Synapse"}, function(name)
    local themes = {Dark = "Dark", Ocean = "Ocean", Blood = "Blood", Grape = "Grape", Midnight = "Midnight", Synapse = "Synapse"}
    -- Note: Full theme switching requires recreating the window
    ApexUI:Notify("Theme", "Selected: " .. name)
end)

UISection:NewKeybind("Toggle UI", "Show/hide the UI", Enum.KeyCode.RightControl, function()
    Window:ToggleUI()
end)

UISection:NewKeybind("Panic Button", "Emergency hide", Enum.KeyCode.F5, function()
    Window:ToggleUI()
    task.wait(5)
    Window:ToggleUI()
end)

NotifSection:NewButton("Test Notification", "Send a test", function()
    ApexUI:Notify("Test", "This is a test notification!")
end)

ConfigSection:NewTextBox("Config Name", "Name your config", function(v)
    print("Config:", v)
end)

ConfigSection:NewTextBox("Numeric Value", "Enter a number", function(v)
    local n = tonumber(v)
    if n then
        print("Number:", n)
    end
end)

InfoSection:NewLabel("ApexUI v1.0.0 | Ultimate Roblox UI")
InfoSection:NewLabel("Player: " .. game.Players.LocalPlayer.Name)
InfoSection:NewLabel("Theme: Dark")

ApexUI:Notify("Welcome", "ApexUI loaded! Press RightControl to toggle.", 4)
print("=== ApexUI Loaded ===")
