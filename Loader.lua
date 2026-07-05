local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local VALID_KEYS = { "2123" }
local DISCORD_LINK = "https://discord.gg/DHeCNzTypH"
local KEY_SAVE_NAME = "NckLoader_Auth.txt"

local SCRIPTS = {
    { Name = "Pet Simulator 99", Icon = "🐱", URL = "https://raw.githubusercontent.com/Simulatorcom/Ps99/refs/heads/main/Source", GameId = 5063162797, PlaceIds = { 8737899170, 16498369165, 17462057395 } }
}

local currentScript = nil
for _, scriptData in ipairs(SCRIPTS) do
    if game.GameId == scriptData.GameId or game.PlaceId == scriptData.GameId then
        currentScript = scriptData
        break
    elseif scriptData.PlaceIds and table.find(scriptData.PlaceIds, game.PlaceId) then
        currentScript = scriptData
        break
    end
end

local IS_TARGET_GAME = (currentScript ~= nil)
local TARGET_URL = IS_TARGET_GAME and currentScript.URL or ""

local function saveKey(key)
    pcall(function()
        if writefile then writefile(KEY_SAVE_NAME, key) end
    end)
end

local function loadKey()
    local res = nil
    pcall(function()
        if isfile and readfile and isfile(KEY_SAVE_NAME) then
            res = readfile(KEY_SAVE_NAME)
        end
    end)
    return res
end

local function checkKey(key)
    if not key or key == "" then return false end
    key = key:gsub("^%s+", ""):gsub("%s+$", "")
    for _, v in ipairs(VALID_KEYS) do
        if key == v then return true end
    end
    return false
end

local saved = loadKey()
local hasValidKey = checkKey(saved)

if hasValidKey and IS_TARGET_GAME then
    pcall(function() loadstring(game:HttpGet(TARGET_URL))() end)
    return
end

if PlayerGui:FindFirstChild("NckUniversalLoader") then
    PlayerGui:FindFirstChild("NckUniversalLoader"):Destroy()
end

local Theme = {
    Main = Color3.fromRGB(12, 12, 16),
    Panel = Color3.fromRGB(18, 18, 24),
    Accent = Color3.fromRGB(0, 200, 255),
    AccentDim = Color3.fromRGB(0, 60, 80),
    Text = Color3.fromRGB(240, 243, 246),
    Muted = Color3.fromRGB(130, 140, 150),
    Border = Color3.fromRGB(32, 35, 45),
    Green = Color3.fromRGB(40, 220, 130),
    Red = Color3.fromRGB(250, 80, 100)
}

local function create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then pcall(function() obj[k] = v end) end
    end
    if props.Parent then obj.Parent = props.Parent end
    return obj
end

local function rounded(obj, r)
    return create("UICorner", { CornerRadius = UDim.new(0, r or 6), Parent = obj })
end

local function outline(obj, col, thickness)
    return create("UIStroke", { Color = col or Theme.Border, Thickness = thickness or 1, Parent = obj })
end

local function anim(obj, props, t)
    if not obj or not obj.Parent then return end
    TweenService:Create(obj, TweenInfo.new(t or 0.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), props):Play()
end

local function bindHover(btn, normal, hover, press)
    btn.MouseEnter:Connect(function() anim(btn, { BackgroundColor3 = hover }) end)
    btn.MouseLeave:Connect(function() anim(btn, { BackgroundColor3 = normal }) end)
    btn.MouseButton1Down:Connect(function() anim(btn, { BackgroundColor3 = press }) end)
    btn.MouseButton1Up:Connect(function() anim(btn, { BackgroundColor3 = hover }) end)
end

local UI = create("ScreenGui", { Name = "NckUniversalLoader", ResetOnSpawn = false, IgnoreGuiInset = true, Parent = PlayerGui })
local Blur = create("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 1, ZIndex = 1, Parent = UI })

local MainFrame = create("Frame", { Size = UDim2.new(0, 420, 0, 290), Position = UDim2.new(0.5, 0, 0.5, 0), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundColor3 = Theme.Main, BackgroundTransparency = 1, ClipsDescendants = true, ZIndex = 2, Parent = UI })
rounded(MainFrame, 12)
local mainStroke = outline(MainFrame, Theme.Border, 1.5)

local Header = create("Frame", { Size = UDim2.new(1, 0, 0, 45), BackgroundColor3 = Theme.Panel, ZIndex = 3, Parent = MainFrame })
create("Frame", { Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1), BackgroundColor3 = Theme.Border, BorderSizePixel = 0, ZIndex = 4, Parent = Header })

create("TextLabel", { Size = UDim2.new(0, 200, 1, 0), Position = UDim2.new(0, 16, 0, 0), BackgroundTransparency = 1, Text = "NCK // LOADER", TextColor3 = Theme.Text, TextSize = 13, Font = Enum.Font.Code, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = Header })

local Close = create("TextButton", { Size = UDim2.new(0, 30, 0, 30), Position = UDim2.new(1, -38, 0, 7), BackgroundColor3 = Color3.fromRGB(25, 25, 32), Text = "×", TextColor3 = Theme.Muted, TextSize = 16, Font = Enum.Font.GothamMedium, AutoButtonColor = false, ZIndex = 4, Parent = Header })
rounded(Close, 6)
outline(Close, Theme.Border, 1)

Close.MouseEnter:Connect(function() anim(Close, { TextColor3 = Theme.Red, BackgroundColor3 = Color3.fromRGB(40, 20, 25) }) end)
Close.MouseLeave:Connect(function() anim(Close, { TextColor3 = Theme.Muted, BackgroundColor3 = Color3.fromRGB(25, 25, 32) }) end)
Close.MouseButton1Click:Connect(function()
    anim(MainFrame, { Size = UDim2.new(0, 420, 0, 0), BackgroundTransparency = 1 }, 0.25)
    anim(mainStroke, { Transparency = 1 }, 0.2)
    anim(Blur, { BackgroundTransparency = 1 }, 0.25)
    task.wait(0.26)
    UI:Destroy()
end)

local Container = create("Frame", { Size = UDim2.new(1, -32, 1, -65), Position = UDim2.new(0, 16, 0, 55), BackgroundTransparency = 1, ZIndex = 3, Parent = MainFrame })

local KeyView = create("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = not hasValidKey, ZIndex = 4, Parent = Container })

local StatusBox = create("Frame", { Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Theme.Panel, ZIndex = 5, Parent = KeyView })
rounded(StatusBox, 8)
local statusStroke = outline(StatusBox, Theme.Border, 1)

local StatusIndicator = create("Frame", { Size = UDim2.new(0, 6, 0, 6), Position = UDim2.new(0, 12, 0.5, -3), BackgroundColor3 = IS_TARGET_GAME and Theme.Green or Theme.Red, ZIndex = 6, Parent = StatusBox })
rounded(StatusIndicator, 3)

local statusMsg = IS_TARGET_GAME and ("Target identified: " .. (currentScript.Icon or "") .. " " .. currentScript.Name) or "System idle: Game not supported"
local StatusText = create("TextLabel", { Size = UDim2.new(1, -30, 1, 0), Position = UDim2.new(0, 26, 0, 0), BackgroundTransparency = 1, Text = statusMsg, TextColor3 = Theme.Text, TextSize = 11, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 6, Parent = StatusBox })

local InputPanel = create("Frame", { Size = UDim2.new(1, 0, 0, 42), Position = UDim2.new(0, 0, 0, 54), BackgroundColor3 = Color3.fromRGB(8, 8, 12), ZIndex = 5, Parent = KeyView })
rounded(InputPanel, 8)
local inputStroke = outline(InputPanel, Theme.Border, 1.5)

local KeyBox = create("TextBox", { Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0), BackgroundTransparency = 1, Text = "", PlaceholderText = "Enter key...", PlaceholderColor3 = Theme.Muted, TextColor3 = Theme.Text, TextSize = 12, Font = Enum.Font.Code, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, ZIndex = 6, Parent = InputPanel })

KeyBox.Focused:Connect(function() anim(inputStroke, { Color = Theme.Accent }) end)
KeyBox.FocusLost:Connect(function() anim(inputStroke, { Color = Theme.Border }) end)

local MsgLabel = create("TextLabel", { Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, 105), BackgroundTransparency = 1, Text = "Keys can be found for free inside our Discord server.", TextColor3 = Theme.Muted, TextSize = 10, Font = Enum.Font.Gotham, ZIndex = 5, Parent = KeyView })

local Actions = create("Frame", { Size = UDim2.new(1, 0, 0, 40), Position = UDim2.new(0, 0, 1, -40), BackgroundTransparency = 1, ZIndex = 5, Parent = KeyView })

local DiscBtn = create("TextButton", { Size = UDim2.new(0, 110, 1, 0), BackgroundColor3 = Theme.Panel, Text = "Get Key", TextColor3 = Theme.Text, TextSize = 11, Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 6, Parent = Actions })
rounded(DiscBtn, 8)
outline(DiscBtn, Theme.Border, 1)
bindHover(DiscBtn, Theme.Panel, Color3.fromRGB(24, 24, 32), Color3.fromRGB(16, 16, 22))

local PasteBtn = create("TextButton", { Size = UDim2.new(0, 80, 1, 0), Position = UDim2.new(0, 120, 0, 0), BackgroundColor3 = Theme.Panel, Text = "Clipboard", TextColor3 = Theme.Text, TextSize = 11, Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 6, Parent = Actions })
rounded(PasteBtn, 8)
outline(PasteBtn, Theme.Border, 1)
bindHover(PasteBtn, Theme.Panel, Color3.fromRGB(24, 24, 32), Color3.fromRGB(16, 16, 22))

local AuthBtn = create("TextButton", { Size = UDim2.new(1, -210, 1, 0), Position = UDim2.new(0, 210, 0, 0), BackgroundColor3 = Theme.AccentDim, Text = "Authenticate", TextColor3 = Theme.Accent, TextSize = 11, Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 6, Parent = Actions })
rounded(AuthBtn, 8)
local authStroke = outline(AuthBtn, Theme.Accent, 1)
bindHover(AuthBtn, Theme.AccentDim, Color3.fromRGB(0, 80, 105), Color3.fromRGB(0, 45, 60))

local UnsupView = create("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = hasValidKey and not IS_TARGET_GAME, ZIndex = 4, Parent = Container })

create("TextLabel", { Size = UDim2.new(1, 0, 0, 30), Position = UDim2.new(0, 0, 0, 20), BackgroundTransparency = 1, Text = "Unsupported Game", TextColor3 = Theme.Text, TextSize = 16, Font = Enum.Font.GothamBold, ZIndex = 5, Parent = UnsupView })

create("TextLabel", { Size = UDim2.new(1, 0, 0, 40), Position = UDim2.new(0, 0, 0, 50), BackgroundTransparency = 1, Text = "Your key is valid, but Nck lacks a module for this specific environment. Join the discord for support.", TextColor3 = Theme.Muted, TextSize = 11, Font = Enum.Font.Gotham, TextWrapped = true, ZIndex = 5, Parent = UnsupView })

local JoinBtn = create("TextButton", { Size = UDim2.new(0, 160, 0, 38), Position = UDim2.new(0.5, -80, 1, -45), BackgroundColor3 = Theme.Panel, Text = "Copy Network Link", TextColor3 = Theme.Text, TextSize = 11, Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 6, Parent = UnsupView })
rounded(JoinBtn, 8)
outline(JoinBtn, Theme.Border, 1)
bindHover(JoinBtn, Theme.Panel, Color3.fromRGB(24, 24, 32), Color3.fromRGB(16, 16, 22))

local LoadView = create("Frame", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Visible = false, ZIndex = 4, Parent = Container })

local BarBg = create("Frame", { Size = UDim2.new(1, 0, 0, 6), Position = UDim2.new(0, 0, 0, 90), BackgroundColor3 = Theme.Panel, ZIndex = 5, Parent = LoadView })
rounded(BarBg, 3)
local BarFill = create("Frame", { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Theme.Accent, ZIndex = 6, Parent = BarBg })
rounded(BarFill, 3)

local LoadTitle = create("TextLabel", { Size = UDim2.new(1, 0, 0, 20), Position = UDim2.new(0, 0, 0, 60), BackgroundTransparency = 1, Text = "Injecting module...", TextColor3 = Theme.Text, TextSize = 13, Font = Enum.Font.Code, ZIndex = 5, Parent = LoadView })

MainFrame.Size = UDim2.new(0, 420, 0, 0)
task.wait(0.1)
anim(Blur, { BackgroundTransparency = 0.7 }, 0.4)
anim(MainFrame, { Size = UDim2.new(0, 420, 0, 290), BackgroundTransparency = 0 }, 0.4)
task.wait(0.4)

DiscBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(DISCORD_LINK) end
    MsgLabel.Text = "Link copied! Paste it into your browser."
    MsgLabel.TextColor3 = Theme.Accent
end)

PasteBtn.MouseButton1Click:Connect(function()
    if getclipboard then KeyBox.Text = getclipboard() end
end)

JoinBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(DISCORD_LINK) end
end)

local function triggerShake()
    local old = MainFrame.Position
    for i = 1, 5 do
        anim(MainFrame, { Position = old + UDim2.new(0, i % 2 == 0 and 4 or -4, 0, 0) }, 0.02)
        task.wait(0.02)
    end
    anim(MainFrame, { Position = old }, 0.02)
end

local processing = false
AuthBtn.MouseButton1Click:Connect(function()
    if processing then return end
    local txt = KeyBox.Text:gsub("^%s+", ""):gsub("%s+$", "")

    if txt == "" then
        MsgLabel.Text = "Authentication dynamic dropped: Field empty."
        MsgLabel.TextColor3 = Theme.Red
        triggerShake()
        return
    end

    if not checkKey(txt) then
        MsgLabel.Text = "Access denied: Key invalid."
        MsgLabel.TextColor3 = Theme.Red
        triggerShake()
        return
    end

    processing = true
    saveKey(txt)

    if not IS_TARGET_GAME then
        KeyView.Visible = false
        UnsupView.Visible = true
        processing = false
        return
    end

    KeyView.Visible = false
    LoadView.Visible = true
    
    anim(BarFill, { Size = UDim2.new(1, 0, 1, 0) }, 1.5)
    task.wait(1.6)

    anim(MainFrame, { Size = UDim2.new(0, 420, 0, 0), BackgroundTransparency = 1 }, 0.3)
    anim(mainStroke, { Transparency = 1 }, 0.25)
    anim(Blur, { BackgroundTransparency = 1 }, 0.3)
    task.wait(0.35)
    UI:Destroy()

    pcall(function() loadstring(game:HttpGet(TARGET_URL))() end)
end)
