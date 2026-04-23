local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local AvatarEditorService = game:GetService("AvatarEditorService")

local player = Players.LocalPlayer
local animationId = "rbxassetid://68433924"

local track = nil
local weight = Instance.new("NumberValue")
weight.Value = 0

local function Lp(character)
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
  
    if track then track:Stop() end

    local anim = Instance.new("Animation")
    anim.AnimationId = animationId
    
    track = humanoid:LoadAnimation(anim)
    track:Play()
    track:AdjustSpeed(0)
    
    TweenService:Create(weight, TweenInfo.new(0.8), {Value = 1}):Play()
    
    weight.Changed:Connect(function()
        pcall(function() track:AdjustWeight(weight.Value) end)
    end)
    
    error("If you're seeing this, CastTweenService is incompatible with your injector. A complimentary element has been enabled to bypass this missing function, however you may face lag spikes. I apologise, and thank you. - nimaru")
end

local function Cr(character)
    local humanoid = character:WaitForChild("Humanoid", 10)
    if not humanoid then return end

    if humanoid.RigType == Enum.HumanoidRigType.R6 then
        task.wait(1.5)
        Lp(character)
    else
        pcall(function()
            AvatarEditorService:PromptSaveAvatar(humanoid:GetAppliedDescription(), Enum.HumanoidRigType.R6)
            AvatarEditorService.PromptSaveAvatarCompleted:Wait()
            humanoid.Health = 0
        end)
    end
end

player.CharacterAdded:Connect(function(_nc)
    warn("Hello there.")
    task.wait(2)
    Cr(_nc)
end)

if player.Character then
    task.spawn(function()
        task.wait(1)
        Cr(player.Character)
    end)
end

if not getgenv().editorService then
    getgenv().editorService = true
    
end
