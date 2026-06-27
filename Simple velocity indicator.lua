--@Author: phoenix_a
--@Game: Universal

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

local Flags = {}

local module = {}

local Maid: TypeMaid
local Gui = Instance.new("ScreenGui", gethui())
local Label = Instance.new("TextLabel", Gui)
Label.BackgroundTransparency = 1
Label.AnchorPoint = Vector2.new(0.5, 0.5)
Label.Size = UDim2.new()
Label.Position = UDim2.fromScale(0.5, 0.8)
Label.TextSize = 32
Label.TextStrokeTransparency = 0

local makeTrail = function()
    local Clone = Label:Clone()
    Clone.Parent = Gui
    Clone.ZIndex -= 1
    Clone.TextStrokeTransparency = 1

    local Tween = TweenService:Create(Clone, TweenInfo.new(1, Enum.EasingStyle.Sine), {
        TextTransparency = 1,
        Position = Clone.Position + UDim2.fromOffset(0, 24),
    })
    Tween.Completed:Connect(function()
        Clone:Destroy()
    end)
    Tween:Play()
end

local PreviousValue = 0
local update = function()
    local IsVisible = Flags.lua_velocity_ind
    Label.Visible = IsVisible
    if not IsVisible then return end
    local Character = LocalPlayer.Character
    if not Character then
        Label.Text = "0"
        return
    end
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid then
        Label.Text = "0"
        return
    end
    local RootPart = Humanoid.RootPart
    if not RootPart then
        Label.Text = "0"
        return
    end
    local CurrentTick = tick()
    Label.TextColor3 = Color3.fromHSV(CurrentTick % 1, 1, 1)
    local Sine, Cosine = math.sin(CurrentTick * 6), math.cos(CurrentTick * 6)
    Label.Position = UDim2.new(0.5, 0, 0.8, Sine * 10)
    Label.Rotation = Cosine * 5

    local Value = math.round(RootPart.AssemblyLinearVelocity.Magnitude)
    if PreviousValue ~= Value then
        makeTrail()
    end
    PreviousValue = Value

    Label.Text = Value
end
module.init = function(libraries: {[string]: any})
    local Maids = libraries.Maids
    local Library = libraries.Library
    Flags = Library.flags

    Maid = Maids.new()
    Maid:Give(RunService.RenderStepped:Connect(update))
    Maid:Give(Gui)
    Label.FontFace = Library.custom_font:Get("Axis")

    --// Options example
    local Section: TypeUILibrary = Library.sections["Visuals>General ESP"]
    Maid:Give(Section:toggle({name = "Velocity Indicator", flag = "lua_velocity_ind"}))
end

module.unload = function()
    if Maid then
        Maid:Clean()
    end
end

return module
