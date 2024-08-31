-- player fling gui with updated UI

local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlayerFling"
screenGui.Parent = game.CoreGui

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 220)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -110)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Parent = screenGui

-- Add rounded corners to mainFrame
local mainFrameCorner = Instance.new("UICorner")
mainFrameCorner.CornerRadius = UDim.new(0, 10)
mainFrameCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 10)
titleBarCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -50, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.Text = "Player Fling"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -33123123123123125, 0, 0)
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.BackgroundColor3 = Color3.fromRGB(230, 70, 70)
closeButton.BorderSizePixel = 0
closeButton.Font = Enum.Font.GothamBold
closeButton.TextScaled = true
closeButton.Parent = titleBar

local closeButtonCorner = Instance.new("UICorner")
closeButtonCorner.CornerRadius = UDim.new(0, 8)
closeButtonCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Username Input
local usernameInput = Instance.new("TextBox")
usernameInput.Size = UDim2.new(0, 360, 0, 35)
usernameInput.Position = UDim2.new(0, 30, 0, 50)
usernameInput.PlaceholderText = "Enter Username"
usernameInput.Text = ""
usernameInput.TextColor3 = Color3.fromRGB(255, 255, 255)
usernameInput.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
usernameInput.BorderSizePixel = 0
usernameInput.Font = Enum.Font.Gotham
usernameInput.TextSize = 16
usernameInput.Parent = mainFrame

local usernameInputCorner = Instance.new("UICorner")
usernameInputCorner.CornerRadius = UDim.new(0, 8)
usernameInputCorner.Parent = usernameInput

-- Suggested Text Label
local suggestedText = Instance.new("TextLabel")
suggestedText.Parent = mainFrame
suggestedText.BackgroundTransparency = 1
suggestedText.Position = usernameInput.Position
suggestedText.Size = usernameInput.Size
suggestedText.Font = Enum.Font.Gotham
suggestedText.Text = ""
suggestedText.TextColor3 = Color3.fromRGB(169, 169, 169) -- Gray text
suggestedText.TextSize = 16
suggestedText.TextXAlignment = Enum.TextXAlignment.Left

-- Fling Button
local flingButton = Instance.new("TextButton")
flingButton.Size = UDim2.new(0, 360, 0, 35)
flingButton.Position = UDim2.new(0, 30, 0, 95)
flingButton.Text = "FLING!"
flingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
flingButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
flingButton.BorderSizePixel = 0
flingButton.Font = Enum.Font.GothamBold
flingButton.TextSize = 16
flingButton.Parent = mainFrame

local flingButtonCorner = Instance.new("UICorner")
flingButtonCorner.CornerRadius = UDim.new(0, 8)
flingButtonCorner.Parent = flingButton

-- Function to get a matching player
local function GetPlayer(Name)
    Name = Name:lower()
    for _, x in next, Players:GetPlayers() do
        if x ~= Player then
            if x.Name:lower():match("^" .. Name) or x.DisplayName:lower():match("^" .. Name) then
                return x
            end
        end
    end
    return nil
end

local function AutoFillSuggestions(Name)
    local lowerName = Name:lower()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Name:lower():match("^" .. lowerName) then
            return plr.Name
        end
    end
    return ""
end

-- Function to show notifications
local function Message(_Title, _Text, Time)
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = _Title, Text = _Text, Duration = Time})
end

-- Function to perform the fling action
local function SkidFling(TargetPlayer)
    local Character = Player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart

    local TCharacter = TargetPlayer.Character
    local THumanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter and TCharacter:FindFirstChild("Head")
    local Accessory = TCharacter and TCharacter:FindFirstChildOfClass("Accessory")
    local Handle = Accessory and Accessory:FindFirstChild("Handle")

    if Character and Humanoid and RootPart then
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end
        if THumanoid and THumanoid.Sit then
            return Message("Error Occurred", "Target is sitting", 5)
        end
        if THead then
            workspace.CurrentCamera.CameraSubject = THead
        elseif Handle then
            workspace.CurrentCamera.CameraSubject = Handle
        else
            workspace.CurrentCamera.CameraSubject = THumanoid
        end
        if not TCharacter:FindFirstChildWhichIsA("BasePart") then
            return
        end
        
        local function FPos(BasePart, Pos, Ang)
            RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
            Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
            RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end
        
        local function SFBasePart(BasePart)
            local TimeToWait = 2
            local Time = tick()
            local Angle = 0

            repeat
                if RootPart and THumanoid then
                    if BasePart.Velocity.Magnitude < 50 then
                        Angle = Angle + 100

                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 0, 5) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                    end
                end
            until Time - tick() >= TimeToWait
        end

        for _, x in pairs(TCharacter:GetChildren()) do
            if x:IsA("BasePart") then
                coroutine.wrap(function()
                    SFBasePart(x)
                end)()
            end
        end
    end
end

flingButton.MouseButton1Click:Connect(function()
    local Target = GetPlayer(usernameInput.Text)
    if Target then
        SkidFling(Target)
    else
        Message("Player Not Found", "Make sure the username is correct", 5)
    end
end)

usernameInput:GetPropertyChangedSignal("Text"):Connect(function()
    suggestedText.Text = AutoFillSuggestions(usernameInput.Text)
end)

usernameInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local suggestion = AutoFillSuggestions(usernameInput.Text)
        if suggestion ~= "" then
            usernameInput.Text = suggestion
        end
    end
end)

-- Enable dragging for the main frame
local dragToggle = nil
local dragSpeed = 0.125
local dragInput = nil
local dragStart = nil
local startPos = nil

local function updateInput(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragToggle = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragToggle = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragToggle then
        updateInput(input)
    end
end)
