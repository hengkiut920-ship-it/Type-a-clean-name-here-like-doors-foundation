-- [[ DOORS MAXIMUM ENHANCED ALL-IN-ONE CLIENT FOR DELTA ]] --
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

if game:GetService("CoreGui"):FindFirstChild("DoorsMegaMenuGui") then
    game:GetService("CoreGui").DoorsMegaMenuGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DoorsMegaMenuGui"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = game:GetService("CoreGui") end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local Toggles = {
    Fullbright = false, NoShake = false, AntiScreech = false, AntiLagLights = false,
    PlayerESP = false, EntityESP = false, DoorESP = false, InteractableESP = false, 
    ElectricFinder = false, AutoElectricClick = false, SeekPathfinder = false
}

local function notify(title, text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title, Text = text, Duration = duration or 4
    })
end

local entityGuides = {
    ["rush"] = "💡 TIPS: Hide IMMEDIATELY when lights flicker and you hear a roar! Exit the closet as soon as he passes.",
    ["ambush"] = "🧠 HIGH IQ: Bounces 2 to 6 times! Stay near a closet, jump out between passes, and hide again.",
    ["seek"] = "🏃‍♂️ TUTORIAL: Follow the blue tracer lines! Crouch under obstacles automatically and aim for glowing doors.",
    ["figure"] = "🤫 TIPS: Complete the heartbeat minigame cleanly. Stay crouched! He cannot see you, but hears steps.",
    ["eyes"] = "👁️ HINT: Look directly at the floor! Looking at Eyes drains your health rapidly.",
    ["halt"] = "🔄 TUTORIAL: When the screen flashes 'TURN AROUND', press backward immediately.",
    ["screech"] = "🛡️ SYSTEM: Script auto-destroys Screech instantly."
}

local MainToggleButton = Instance.new("TextButton")
MainToggleButton.Size = UDim2.new(0, 60, 0, 60)
MainToggleButton.Position = UDim2.new(0, 15, 0, 15)
MainToggleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
MainToggleButton.Text = "👁️"
MainToggleButton.TextSize = 25
MainToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MainToggleButton.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 30)
MainCorner.Parent = MainToggleButton

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 420)
MainFrame.Position = UDim2.new(0.5, -130, 0.4, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 12)
FrameCorner.Parent = MainFrame

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, 0, 0, 45)
TitleLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
TitleLabel.Text = "Doors Foundation Menu"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleLabel

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, -50)
ScrollFrame.Position = UDim2.new(0, 0, 0, 50)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 460)
ScrollFrame.ScrollBarThickness = 5
ScrollFrame.Parent = MainFrame

MainToggleButton.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

local buttonCount = 0
local function createToggleBtn(name, labelText, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 34)
    btn.Position = UDim2.new(0.05, 0, 0, 10 + (buttonCount * 40))
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    btn.Text = labelText .. ": OFF"
    btn.TextColor3 = Color3.fromRGB(220, 70, 70)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 12
    btn.Parent = ScrollFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        Toggles[name] = not Toggles[name]
        if Toggles[name] then
            btn.Text = labelText .. ": ON"
            btn.TextColor3 = Color3.fromRGB(70, 220, 70)
            btn.BackgroundColor3 = Color3.fromRGB(50, 60, 50)
        else
            btn.Text = labelText .. ": OFF"
            btn.TextColor3 = Color3.fromRGB(220, 70, 70)
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        end
        callback(Toggles[name])
    end)
    buttonCount = buttonCount + 1
end

local function applyAdvancedESP(object, labelText, color, toggleCheckName, customSize)
    if object:FindFirstChild("CustomESPBox") then return end

    local box = Instance.new("BoxHandleAdornment")
    box.Name = "CustomESPBox"
    box.Size = customSize or (object:IsA("Model") and (object:GetExtentsSize() + Vector3.new(0.1, 0.1, 0.1)) or object.Size)
    box.Color3 = color
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Adornee = object
    box.Transparency = 0.5
    box.Parent = object

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "CustomESPTag"
    billboard.Size = UDim2.new(0, 160, 0, 40)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.Parent = object

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = color
    label.TextStrokeTransparency = 0
    label.TextSize = 13
    label.Font = Enum.Font.SourceSansBold
    label.Text = labelText
    label.Parent = billboard

    local line = Instance.new("LineHandleAdornment")
    line.Name = "CustomESPLine"
    line.Length = 0
    line.Thickness = 2
    line.Color3 = color
    line.AlwaysOnTop = true
    line.ZIndex = 4
    line.Adornee = workspace.CurrentCamera
    line.Parent = object

    task.spawn(function()
        while object and object.Parent and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") do
            if not Toggles[toggleCheckName] then break end
            local root = LocalPlayer.Character.HumanoidRootPart
            local targetPos = object:IsA("Model") and (object.PrimaryPart and object.PrimaryPart.Position or object:GetOutlineTargetWorldCFrame().Position) or object.Position
            local dist = math.floor((root.Position - targetPos).Magnitude)
            
            label.Text = string.format("%s [%dm]", labelText, dist)
            line.CFrame = CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, targetPos)
            line.Length = (workspace.CurrentCamera.CFrame.Position - targetPos).Magnitude
            task.wait(0.1)
        end
        billboard:Destroy()
        box:Destroy()
        line:Destroy()
    end)
end

local originalAmbient = Lighting.Ambient
local originalFog = Lighting.FogEnd
createToggleBtn("Fullbright", "Fullbright & No Fog", function(state)
    if state then Lighting.FogEnd = 999999 Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    else Lighting.FogEnd = originalFog Lighting.Ambient = originalAmbient end
end)

createToggleBtn("NoShake", "No Camera Shake", function() end)
RunService.RenderStepped:Connect(function()
    if Toggles.NoShake and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.CameraOffset = Vector3.new(0, 0, 0)
    end
end)

createToggleBtn("AntiScreech", "Anti-Screech Protection", function() end)
workspace.ChildAdded:Connect(function(child)
    if child.Name == "Screech" and Toggles.AntiScreech then
        task.wait() child:Destroy() notify("🛡️ Anti-Screech", entityGuides["screech"], 5)
    end
end)

createToggleBtn("AntiLagLights", "Anti-Lag Shattered Lights", function() end)
workspace.DescendantAdded:Connect(function(desc)
    if Toggles.AntiLagLights then
        if desc:IsA("ParticleEmitter") or desc:IsA("Sparkles") then
            if desc.Parent and (string.find(desc.Parent.Name:lower(), "light") or string.find(desc.Parent.Name:lower(), "lamp")) then
                task.wait() desc:Destroy()
            end
        elseif desc:IsA("GlassByPhysics") or (desc:IsA("BasePart") and desc.Name == "GlassShatter") then
            task.wait() desc:Destroy()
        end
    end
end)

createToggleBtn("DoorESP", "Door ESP (Line/Box)", function() end)
local function scanRoomDoors(room)
    if not Toggles.DoorESP then return end
    for _, desc in pairs(room:GetDescendants()) do
        if desc.Name == "Door" and desc:IsA("BasePart") then
            applyAdvancedESP(desc, "🚪 Next Door", Color3.fromRGB(0, 255, 255), "DoorESP", Vector3.new(4, 7, 1))
        end
    end
end

createToggleBtn("InteractableESP", "ESP: Keys & Loot Items", function() end)
local function scanRoomObjects(room)
    if not Toggles.InteractableESP then return end
    for _, desc in pairs(room:GetDescendants()) do
        if desc.Name == "Key" or desc:FindFirstChild("Key") then
            applyAdvancedESP(desc, "🔑 Key Asset", Color3.fromRGB(255, 255, 0), "InteractableESP")
        elseif desc:IsA("Model") and (desc.Name == "LiveHintBook" or desc.Name == "LiveBreakerPole") then
            applyAdvancedESP(desc, "📘 Book Objective", Color3.fromRGB(255, 100, 255), "InteractableESP")
        elseif desc:IsA("ClickDetector") and desc.Parent and desc.Parent:IsA("BasePart") then
            if string.find(desc.Parent.Name:lower(), "gold") or string.find(desc.Parent.Name:lower(), "coin") then
                applyAdvancedESP(desc.Parent, "💰 Gold Loot", Color3.fromRGB(255, 200, 50), "InteractableESP")
            end
        end
    end
end

workspace.CurrentRooms.ChildAdded:Connect(function(room)
    task.wait(1) scanRoomDoors(room) scanRoomObjects(room)
end)

createToggleBtn("ElectricFinder", "Find Shortage Electricity", function() end)
RunService.Heartbeat:Connect(function()
    if Toggles.ElectricFinder then
        for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
            for _, item in pairs(room:GetDescendants()) do
                if item.Name == "Fuse" or item.Name == "FuseBox" or item.Name == "BreakerBox" or item.Name == "ElevatorBreaker" then
                    applyAdvancedESP(item, "⚡ BREAKER ENGINE/FUSE", Color3.fromRGB(255, 130, 0), "ElectricFinder")
                end
            end
        end
    end
end)

createToggleBtn("AutoElectricClick", "Auto-Click Breakers", function() end)
task.spawn(function()
    while task.wait(0.2) do
        if Toggles.AutoElectricClick and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
                for _, item in pairs(room:GetDescendants()) do
                    if (item.Name == "Fuse" or item.Name == "BreakerBox" or item.Name == "Lever" or item.Name == "LiveBreakerPole") and item:IsA("BasePart") then
                        local dist = (LocalPlayer.Character.HumanoidRootPart.Position - item.Position).Magnitude
                        if dist < 12 and item:FindFirstChildOfClass("ClickDetector") then
                            fireclickdetector(item:FindFirstChildOfClass("ClickDetector"))
                        end
                    end
                end
            end
        end
    end
end)

createToggleBtn("SeekPathfinder", "Build Path: Seek Chase", function() end)
RunService.RenderStepped:Connect(function()
    if Toggles.SeekPathfinder and workspace:FindFirstChild("Seek") then
        for _, room in pairs(workspace.CurrentRooms:GetChildren()) do
            local structuralDoor = room:FindFirstChild("Door")
            if structuralDoor and structuralDoor:IsA("BasePart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local laser = room:FindFirstChild("SeekPathLaser") or Instance.new("LineHandleAdornment")
                if not room:FindFirstChild("SeekPathLaser") then
                    laser.Name = "SeekPathLaser"
                    laser.Thickness = 4
                    laser.Color3 = Color3.fromRGB(0, 120, 255)
                    laser.AlwaysOnTop = true
                    laser.Adornee = workspace.CurrentCamera
                    laser.Parent = room
                end
                laser.CFrame = CFrame.lookAt(LocalPlayer.Character.HumanoidRootPart.Position, structuralDoor.Position)
                laser.Length = (LocalPlayer.Character.HumanoidRootPart.Position - structuralDoor.Position).Magnitude
            end
        end
    end
end)

createToggleBtn("PlayerESP", "Player Wallhack Tracker", function() end)
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(char) 
        if Toggles.PlayerESP then task.wait(1) applyAdvancedESP(char, p.Name, Color3.fromRGB(100, 255, 100), "PlayerESP") end 
    end)
end)

createToggleBtn("EntityESP", "Threat Warnings & Guides", function() end)
local threats = {"Rush", "Ambush", "Seek", "Figure", "Eyes", "Halt", "Glitch", "A-60", "A-120"}
workspace.ChildAdded:Connect(function(child)
    for _, threatName in pairs(threats) do
        if string.find(child.Name:lower(), threatName:lower()) then
            if Toggles.EntityESP then
                local lowerName = threatName:lower()
                if entityGuides[lowerName] then notify("⚠️ THREAT ALERT: " .. child.Name:upper(), entityGuides[lowerName], 8)
                else notify("⚠️ SYSTEM WARNING!", child.Name:upper() .. " HAS CONVERGED!", 5) end
                applyAdvancedESP(child, "💀 HOSTILE: " .. child.Name, Color3.fromRGB(255, 0, 0), "EntityESP")
            end
        end
    end
end)

workspace.DescendantAdded:Connect(function(indicator)
    local indName = indicator.Name:lower()
    if string.find(indName, "guiding") or string.find(indName, "curious") then
        task.wait(0.1)
        if indicator:IsA("BasePart") or indicator:IsA("Model") then
            local box = Instance.new("BoxHandleAdornment")
            box.Size = indicator:IsA("Model") and indicator:GetExtentsSize() or indicator.Size
            box.Color3 = Color3.fromRGB(0, 160, 255)
            box.AlwaysOnTop = true
            box.ZIndex = 6
            box.Adornee = indicator
            box.Parent = indicator
            notify("✨ Pathway Detected", "Auxiliary glowing beacon locked to objective paths.", 4)
        end
    end
end)

notify("Setup Complete", "All systems running perfectly on Delta Client!")
