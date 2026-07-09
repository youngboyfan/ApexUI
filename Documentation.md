# ApexUI Documentation

**Version:** 1.0.0  
**Category:** Roblox UI Library  
**Design:** Fluent Design / Material You Hybrid  

---

## Table of Contents

1. [Getting Started](#getting-started)
2. [Window Configuration](#window-configuration)
3. [Theme System](#theme-system)
4. [Tab Management](#tab-management)
5. [Section Management](#section-management)
6. [UI Elements](#ui-elements)
   - [Button](#button)
   - [Toggle](#toggle)
   - [Slider](#slider)
   - [Dropdown](#dropdown)
   - [TextBox](#textbox)
   - [Keybind](#keybind)
   - [Label](#label)
   - [Paragraph](#paragraph)
   - [ColorPicker](#colorpicker)
   - [MultiSelect](#multiselect)
   - [InputList](#inputlist)
7. [Notification System](#notification-system)
8. [Utility Functions](#utility-functions)
9. [Element Return Values](#element-return-values)
10. [Full Example](#full-example)

---

## Getting Started

### Loading the Library

```lua
-- Load from GitHub
local ApexUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/your-repo/ApexUI/main/apexui.lua"
))()
```

### Creating Your First Window

```lua
local Window = ApexUI:CreateWindow({
    Name = "My Hub",
    Theme = "Dark Matter",
})
```

### Basic Structure

The hierarchy follows this pattern:

```
ApexUI (Library)
  └── Window (main container)
        ├── TitleBar (drag handle + buttons)
        ├── SearchBar (optional, filters across all tabs)
        ├── TabBar (horizontal tab buttons)
        └── ContentArea
              ├── Tab Page 1
              │     ├── Section 1
              │     │     ├── Button
              │     │     ├── Toggle
              │     │     └── Slider
              │     └── Section 2
              ├── Tab Page 2
              └── Tab Page 3
```

---

## Window Configuration

### `ApexUI:CreateWindow(config)`

Creates a new ApexUI window. Returns a window object with methods for tab management.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `Name` | string | `"ApexUI"` | Title displayed in the window header |
| `Icon` | string | `""` | Image asset ID for the window icon |
| `Theme` | string | `"Dark Matter"` | Initial theme to apply |
| `Size` | UDim2 | `(680, 500)` | Window dimensions |
| `Position` | UDim2 | Centered | Initial window position |
| `MinSize` | Vector2 | `(480, 350)` | Minimum window dimensions |
| `ToggleKey` | Enum.KeyCode | `RightControl` | Key to toggle UI visibility |
| `ShowNotifications` | bool | `true` | Enable notification system |
| `ShowSearch` | bool | `true` | Show search bar in header |
| `TitlebarGradient` | bool | `false` | Apply gradient to titlebar |
| `AnimationStyle` | string | `"Slide"` | Intro animation style (`Slide`, `Fade`, `Scale`) |
| `Resizable` | bool | `true` | Allow window resizing |
| `Draggable` | bool | `true` | Allow window dragging |
| `Transparency` | number | `0` | Window background transparency (0-0.3) |
| `AccentColor` | Color3 | `nil` | Override theme accent color |
| `Intro` | bool | `true` | Show intro animation |
| `IntroText` | string | `"ApexUI"` | Text displayed during intro |
| `OnClose` | function | `nil` | Callback when window is closed |

#### Example

```lua
local Window = ApexUI:CreateWindow({
    Name = "Ultimate Hub",
    Theme = "Arctic Frost",
    Size = UDim2.fromOffset(800, 600),
    ToggleKey = Enum.KeyCode.RightControl,
    ShowSearch = true,
    Draggable = true,
    Intro = true,
    IntroText = "Welcome to ApexUI",
    OnClose = function()
        print("Window closed")
    end,
})
```

### Window Methods

| Method | Description |
|--------|-------------|
| `Window:AddTab(name, icon)` | Adds a new tab, returns tab object |
| `Window:SelectTab(name)` | Programmatically select a tab |
| `Window:Toggle()` | Toggle window visibility |
| `Window:SetVisible(bool)` | Show or hide the window |
| `Window:Destroy()` | Remove the window and clean up |
| `Window:UpdateTheme()` | Refresh all theme colors |

---

## Theme System

### Built-in Themes

| Theme Name | Type | Description |
|------------|------|-------------|
| `"Dark Matter"` | Dark | Deep navy/purple with blue accents |
| `"Arctic Frost"` | Dark | Cool blue, icy tones |
| `"Neon Genesis"` | Dark | Purple neon, vibrant |
| `"Minimalist"` | Light | Clean white, subtle grays |

### Theme Methods

#### `ApexUI:GetThemes()`
Returns a list of all available theme names.

```lua
local themes = ApexUI:GetThemes()
-- { "Dark Matter", "Arctic Frost", "Neon Genesis", "Minimalist" }
```

#### `ApexUI:SetTheme(themeName)`
Switch to a different theme. Updates all active windows.

```lua
ApexUI:SetTheme("Neon Genesis")
```

#### `ApexUI:GetCurrentTheme()`
Returns the current theme color table.

```lua
local theme = ApexUI:GetCurrentTheme()
print(theme.Accent) -- Color3
```

#### `ApexUI:CreateCustomTheme(name, colors)`
Create a new custom theme. Missing colors default to Dark Matter values.

```lua
ApexUI:CreateCustomTheme("My Theme", {
    IsDark = true,
    WindowBackground = Color3.fromRGB(30, 20, 40),
    WindowBorder = Color3.fromRGB(60, 40, 80),
    Accent = Color3.fromRGB(100, 200, 255),
    ButtonBackground = Color3.fromRGB(100, 200, 255),
    -- ... any color property from the theme table
})
```

### Theme Color Properties

| Property | Type | Description |
|----------|------|-------------|
| `Name` | string | Theme display name |
| `IsDark` | bool | Whether it's a dark theme |
| `WindowBackground` | Color3 | Main window background |
| `WindowBorder` | Color3 | Window outline |
| `WindowTitleBackground` | Color3 | Title bar background |
| `WindowTitleText` | Color3 | Title text color |
| `WindowShadow` | Color3 | Drop shadow color |
| `TabBackground` | Color3 | Tab bar background |
| `TabSelectedBackground` | Color3 | Active tab background |
| `TabSelectedText` | Color3 | Active tab text |
| `TabUnselectedText` | Color3 | Inactive tab text |
| `TabHoverBackground` | Color3 | Tab hover state |
| `SectionBackground` | Color3 | Section container |
| `SectionBorder` | Color3 | Section outline |
| `SectionTitle` | Color3 | Section header text |
| `ButtonBackground` | Color3 | Default button fill |
| `ButtonBackgroundHover` | Color3 | Button hover state |
| `ButtonText` | Color3 | Button text |
| `ToggleEnabled` | Color3 | Toggle ON state |
| `ToggleDisabled` | Color3 | Toggle OFF state |
| `ToggleKnob` | Color3 | Toggle handle ON |
| `ToggleKnobDisabled` | Color3 | Toggle handle OFF |
| `SliderBackground` | Color3 | Slider track |
| `SliderFill` | Color3 | Slider fill |
| `SliderScrub` | Color3 | Slider handle |
| `DropdownBackground` | Color3 | Dropdown container |
| `DropdownItemHover` | Color3 | Dropdown item hover |
| `DropdownText` | Color3 | Dropdown text |
| `TextBoxBackground` | Color3 | Input background |
| `TextBoxText` | Color3 | Input text |
| `TextBoxPlaceholder` | Color3 | Placeholder text |
| `LabelText` | Color3 | Label color |
| `ParagraphText` | Color3 | Paragraph body text |
| `KeybindBackground` | Color3 | Keybind button |
| `KeybindText` | Color3 | Keybind text |
| `ColorPickerBackground` | Color3 | Picker panel |
| `ColorPickerBorder` | Color3 | Picker outline |
| `NotificationBackground` | Color3 | Notification box |
| `NotificationBorder` | Color3 | Notification outline |
| `NotificationTitle` | Color3 | Notification title |
| `NotificationDesc` | Color3 | Notification body |
| `SearchBackground` | Color3 | Search bar |
| `SearchText` | Color3 | Search text |
| `SearchPlaceholder` | Color3 | Search placeholder |
| `ScrollbarBackground` | Color3 | Scrollbar track |
| `ScrollbarThumb` | Color3 | Scrollbar handle |
| `Accent` | Color3 | Primary accent |
| `Error` | Color3 | Error/negative state |
| `Success` | Color3 | Success/positive state |
| `Warning` | Color3 | Warning state |

---

## Tab Management

### `Window:AddTab(name, icon)`

Creates a new tab. Returns a tab object for adding sections.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `name` | string | required | Tab display name |
| `icon` | string | `""` | Unicode emoji or text icon |

#### Example

```lua
local CombatTab = Window:AddTab("Combat", "⚔")
local VisualsTab = Window:AddTab("Visuals", "👁")
local SettingsTab = Window:AddTab("Settings", "⚙")
```

### `Window:SelectTab(name)`

Programmatically switch to a specific tab.

```lua
Window:SelectTab("Combat")
```

---

## Section Management

### `tab:AddSection(sectionName)`

Creates a collapsible section within a tab. Returns a section object for adding elements.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `sectionName` | string | required | Section header text |

#### Example

```lua
local mainSection = CombatTab:AddSection("Main")
local weaponsSection = CombatTab:AddSection("Weapons")
```

Sections are collapsible — click the header to expand/collapse.

---

## UI Elements

### Button

Creates a clickable button with hover animations and ripple effect.

```
section:AddButton(config)
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `Name` | string | `"Button"` | Button display text |
| `Description` | string | `""` | Small hint text on the right |
| `Callback` | function | `function() end` | Function called on click |

#### Example

```lua
mainSection:AddButton({
    Name = "Execute",
    Description = "Run the script",
    Callback = function()
        print("Button clicked!")
    end,
})
```

#### Return Value

```lua
local btn = section:AddButton({...})
-- btn is the Frame containing the button
```

---

### Toggle

Creates an on/off toggle switch with smooth sliding animation.

```
section:AddToggle(config)
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `Name` | string | `"Toggle"` | Toggle display name |
| `Description` | string | `""` | Small description text |
| `Default` | bool | `false` | Initial state |
| `Callback` | function(value) | `function() end` | Called on state change |

#### Example

```lua
mainSection:AddToggle({
    Name = "Auto Farm",
    Description = "Enable auto-farming",
    Default = false,
    Callback = function(state)
        if state then
            print("Auto Farm ON")
        else
            print("Auto Farm OFF")
        end
    end,
})
```

#### Return Methods

```lua
local toggle = section:AddToggle({...})

-- Set state programmatically
toggle:SetState(true)

-- Get current state
local isOn = toggle:GetState()
```

---

### Slider

Creates a draggable slider for numeric values.

```
section:AddSlider(config)
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `Name` | string | `"Slider"` | Slider display name |
| `Description` | string | `""` | Small description |
| `Min` | number | `0` | Minimum value |
| `Max` | number | `100` | Maximum value |
| `Default` | number | `Min` | Starting value |
| `Suffix` | string | `""` | Text appended to value (e.g., `"x"`, `"%"`) |
| `Decimals` | number | `0` | Decimal places to round to |
| `Callback` | function(value) | `function() end` | Called as value changes |

#### Example

```lua
mainSection:AddSlider({
    Name = "Walk Speed",
    Min = 1,
    Max = 200,
    Default = 16,
    Suffix = " studs/s",
    Decimals = 0,
    Callback = function(value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end,
})
```

#### Return Methods

```lua
local slider = section:AddSlider({...})

-- Set value
slider:SetValue(50)

-- Get current value
local val = slider:GetValue()
```

---

### Dropdown

Creates a dropdown selection menu.

```
section:AddDropdown(config)
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `Name` | string | `"Dropdown"` | Dropdown display name |
| `Description` | string | `""` | Small description |
| `Options` | table | `{}` | List of options (strings or numbers) |
| `Default` | any | `nil` | Initially selected option |
| `Callback` | function(value) | `function() end` | Called when an option is selected |

#### Example

```lua
mainSection:AddDropdown({
    Name = "Weapon",
    Options = {"Sword", "Gun", "Bow", "Staff"},
    Default = "Sword",
    Callback = function(value)
        print("Selected:", value)
    end,
})
```

#### Return Methods

```lua
local dropdown = section:AddDropdown({...})

-- Set selected value
dropdown:SetValue("Gun")

-- Get current value
local val = dropdown:GetValue()

-- Refresh options
dropdown:Refresh({"New1", "New2", "New3"})
```

---

### TextBox

Creates a text input field.

```
section:AddTextbox(config)
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `Name` | string | `"Text Input"` | Input field label |
| `Description` | string | `""` | Small description |
| `Placeholder` | string | `"Type here..."` | Placeholder hint text |
| `Default` | string | `""` | Initial text value |
| `Numeric` | bool | `false` | If true, validates numeric input |
| `Callback` | function(value) | `function() end` | Called when focus is lost or Enter pressed |

#### Example

```lua
mainSection:AddTextbox({
    Name = "Username",
    Placeholder = "Enter username...",
    Default = "Player",
    Callback = function(value)
        print("Username:", value)
    end,
})
```

#### Return Methods

```lua
local textbox = section:AddTextbox({...})

-- Set text
textbox:SetValue("New Text")

-- Get current text
local text = textbox:GetValue()
```

---

### Keybind

Creates a click-to-rebind keybind button.

```
section:AddKeybind(config)
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `Name` | string | `"Keybind"` | Keybind display name |
| `Description` | string | `""` | Small description |
| `Default` | Enum.KeyCode | `Unknown` | Default key |
| `Callback` | function | `function() end` | Called when bound key is pressed |
| `ChangeCallback` | function(newKey) | `function() end` | Called when key is rebound |
| `IgnoreMouse` | bool | `false` | If true, allows mouse buttons as keys |

#### Example

```lua
mainSection:AddKeybind({
    Name = "Toggle GUI",
    Default = Enum.KeyCode.RightControl,
    Callback = function()
        Window:Toggle()
    end,
    ChangeCallback = function(newKey)
        print("Key changed to:", newKey)
    end,
})
```

#### Return Methods

```lua
local keybind = section:AddKeybind({...})

-- Set key programmatically
keybind:SetKey(Enum.KeyCode.F)

-- Get current key
local key = keybind:GetKey()
```

---

### Label

Creates a static or dynamic text label.

```
section:AddLabel(config)
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `Text` | string | `"Label"` | Label content |
| `Color` | Color3 | theme color | Optional text color override |

#### Example

```lua
-- Static label
section:AddLabel({
    Text = "Version 1.0.0",
})

-- Dynamic label (updatable)
local label = section:AddLabel({
    Text = "Players: 0",
})

-- Update later
label:SetText("Players: 10")
```

#### Return Methods

```lua
label:SetText("New Text")
```

---

### Paragraph

Creates a multi-line text block with a title.

```
section:AddParagraph(config)
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `Title` | string | `"Information"` | Paragraph header |
| `Content` | string | `""` | Multi-line text content |

#### Example

```lua
section:AddParagraph({
    Title = "About",
    Content = "This is a multi-line paragraph.\nIt supports line breaks.\n\nGreat for documentation!",
})
```

#### Return Methods

```lua
local para = section:AddParagraph({...})
para:SetContent("New content here")
```

---

### ColorPicker

Creates an expandable color picker with HSV and Hex input.

```
section:AddColorPicker(config)
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `Name` | string | `"Color Picker"` | Picker display name |
| `Default` | Color3 | white | Initial color |
| `Callback` | function(color) | `function() end` | Called when color changes |

#### Example

```lua
section:AddColorPicker({
    Name = "ESP Color",
    Default = Color3.fromRGB(255, 50, 50),
    Callback = function(color)
        print("Selected color:", color.R, color.G, color.B)
    end,
})
```

#### Return Methods

```lua
local picker = section:AddColorPicker({...})

-- Set color
picker:SetColor(Color3.fromRGB(0, 255, 0))

-- Get current color
local color = picker:GetColor()
```

---

### MultiSelect

Creates a multi-select dropdown (checkboxes).

```
section:AddMultiSelect(config)
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `Name` | string | `"Multi Select"` | Display name |
| `Options` | table | `{}` | List of options |
| `Default` | table | `{}` | Pre-selected options |
| `MaxDisplay` | number | `3` | Max items shown before "+N" |
| `Callback` | function(selected) | `function() end` | Called with array of selected values |

#### Example

```lua
section:AddMultiSelect({
    Name = "Features",
    Options = {"Aimbot", "ESP", "Wallhack", "Speed"},
    Default = {"ESP", "Speed"},
    MaxDisplay = 3,
    Callback = function(selected)
        print("Selected:", table.concat(selected, ", "))
    end,
})
```

#### Return Methods

```lua
local ms = section:AddMultiSelect({...})

-- Get selected items
local selected = ms:GetSelected()

-- Refresh options
ms:Refresh({"New1", "New2"})
```

---

### InputList

Creates a dynamic list manager with add/remove functionality.

```
section:AddInputList(config)
```

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `Name` | string | `"Input List"` | Display name |
| `Placeholder` | string | `"Add item..."` | Input placeholder |
| `Default` | table | `{}` | Initial items |
| `Callback` | function(items) | `function() end` | Called when list changes |

#### Example

```lua
section:AddInputList({
    Name = "Whitelist",
    Placeholder = "Enter username...",
    Default = {"Player1", "Player2"},
    Callback = function(items)
        print("Whitelist items:", #items)
    end,
})
```

#### Return Methods

```lua
local list = section:AddInputList({...})

-- Get all items
local items = list:GetItems()

-- Set items (replaces all)
list:SetItems({"New1", "New2", "New3"})

-- Add a single item
list:AddItem("NewItem")
```

---

## Notification System

### `ApexUI:Notify(config)`

Creates a slide-in notification at the top-right of the screen.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `Title` | string | `"Notification"` | Header text |
| `Content` | string | `""` | Body text (supports \n) |
| `Duration` | number | `4` | Auto-close time in seconds (0 = manual) |
| `Icon` | string | `"ℹ"` | Unicode emoji icon |

#### Example

```lua
ApexUI:Notify({
    Title = "Script Loaded",
    Content = "All features are ready to use!",
    Duration = 5,
    Icon = "✅",
})
```

### `ApexUI:Toast(text, duration, icon)`

Creates a small toast notification at the bottom-center of the screen.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `text` | string | required | Short message |
| `duration` | number | `2.5` | Display duration in seconds |
| `icon` | string | `"✓"` | Unicode icon |

#### Example

```lua
ApexUI:Toast("Action completed!", 2, "✓")
```

---

## Utility Functions

### `ApexUI:GetThemes()`
Returns a table of all theme names.
```lua
local themes = ApexUI:GetThemes()
```

### `ApexUI:SetTheme(themeName)`
Switches the active theme for all windows.
```lua
ApexUI:SetTheme("Arctic Frost")
```

### `ApexUI:CreateCustomTheme(name, colors)`
Creates a user-defined theme.
```lua
ApexUI:CreateCustomTheme("MyTheme", {
    Accent = Color3.fromRGB(255, 100, 50),
    WindowBackground = Color3.fromRGB(20, 20, 30),
})
```

### `ApexUI:GetCurrentTheme()`
Returns the active theme's color table.
```lua
local theme = ApexUI:GetCurrentTheme()
print(theme.Accent)
```

---

## Element Return Values

Each element creation method returns an object with control methods:

| Element | Returned Methods |
|---------|-----------------|
| **Button** | Raw Frame (no methods needed) |
| **Toggle** | `:SetState(bool)`, `:GetState() → bool` |
| **Slider** | `:SetValue(num)`, `:GetValue() → num` |
| **Dropdown** | `:SetValue(val)`, `:GetValue() → val`, `:Refresh(newOpts)` |
| **TextBox** | `:SetValue(str)`, `:GetValue() → str` |
| **Keybind** | `:SetKey(keyCode)`, `:GetKey() → keyCode` |
| **Label** | `:SetText(str)` |
| **Paragraph** | `:SetContent(str)` |
| **ColorPicker** | `:SetColor(color3)`, `:GetColor() → color3` |
| **MultiSelect** | `:GetSelected() → table`, `:Refresh(newOpts)` |
| **InputList** | `:GetItems() → table`, `:SetItems(table)`, `:AddItem(val)` |

---

## Full Example

```lua
-- Load ApexUI
local ApexUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/your-repo/ApexUI/main/apexui.lua"
))()

-- Create window
local Window = ApexUI:CreateWindow({
    Name = "My Ultimate Hub",
    Theme = "Dark Matter",
    ToggleKey = Enum.KeyCode.RightControl,
    ShowSearch = true,
})

-- Add tabs
local MainTab = Window:AddTab("Main", "🏠")
local SettingsTab = Window:AddTab("Settings", "⚙")

-- Main tab sections
local mainSection = MainTab:AddSection("Controls")
local infoSection = MainTab:AddSection("Info")

-- Add elements
mainSection:AddButton({
    Name = "Click Me",
    Description = "Demonstration button",
    Callback = function()
        ApexUI:Toast("Button clicked!", 1.5, "✓")
    end,
})

mainSection:AddToggle({
    Name = "Enable Feature",
    Default = true,
    Callback = function(state)
        print("Feature:", state)
    end,
})

mainSection:AddSlider({
    Name = "Speed",
    Min = 0,
    Max = 100,
    Default = 50,
    Suffix = "%",
    Callback = function(value)
        print("Speed:", value)
    end,
})

mainSection:AddDropdown({
    Name = "Mode",
    Options = {"Normal", "Advanced", "Expert"},
    Default = "Normal",
    Callback = function(value)
        print("Mode:", value)
    end,
})

-- Info
local playerLabel = infoSection:AddLabel({
    Text = "Player: " .. game.Players.LocalPlayer.Name,
})

-- Settings tab
local uiSection = SettingsTab:AddSection("UI Settings")

uiSection:AddDropdown({
    Name = "Theme",
    Options = ApexUI:GetThemes(),
    Default = ApexUI.CurrentTheme,
    Callback = function(name)
        ApexUI:SetTheme(name)
    end,
})

uiSection:AddKeybind({
    Name = "Toggle UI",
    Default = Enum.KeyCode.RightControl,
    Callback = function()
        Window:Toggle()
    end,
})
```

---

## Performance Tips

1. **Lazy Loading**: Elements are created on demand — only visible tabs render
2. **Scrolling**: The scrolling frame only renders visible elements
3. **Cleanup**: Always call `Window:Destroy()` when done to free memory
4. **Tweens**: Animation durations are optimized for 60fps
5. **Automatic Size**: Use `AutomaticSize` where possible to avoid manual calculations

---

## Best Practices

1. Always use `pcall()` around callbacks to prevent errors from breaking the UI
2. Use `task.spawn()` for heavy operations inside callbacks to keep UI responsive
3. Store element return values for programmatic control
4. Group related settings in the same section
5. Use the search bar for large scripts with many settings

---

## Changelog

### v1.0.0
- Initial release
- Window creation with drag, minimize, close
- 4 premium themes: Dark Matter, Arctic Frost, Neon Genesis, Minimalist
- All basic elements: Button, Toggle, Slider, Dropdown, TextBox, Keybind, Label, Paragraph
- Advanced elements: ColorPicker, MultiSelect, InputList
- Notification and Toast system
- Search bar for filtering settings
- Collapsible sections
- Smooth animations with TweenService
- Custom theming API
- Comprehensive example script
