local Module = loadstring(game:HttpGet("https://raw.githubusercontent.com/rhuda21/Main/refs/heads/main/Library/Legacy/Module.lua"))()
local Library = Module.Library
local SaveManager = Module.SaveManager
local Window = Module.Window
SaveManager:SetLibrary(Library)
SaveManager:SetFolder("UBHub/ToH")
_G.currentVersion = "Version : 2.0.1"

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "layout-grid" }),
    Player = Window:AddTab({ Title = "Player", Icon = "user" })
}

local MainSection = Tabs.Main:AddSection("Main")
local PlayerSection = Tabs.Player:AddSection("Player")
local exec_name = identifyexecutor()

local HttpService = game:GetService("HttpService")
local success, err = pcall(function()
    assert(hookfunction, "Your exploit does not support hookfunction.")
end)
if not success then
    local LocalPlayer = game:GetService("Players").LocalPlayer
    LocalPlayer:Kick("Unsupported exploit. Please use Swift (FREE).")
    return
end

if exec_name:lower() == "xeno" then
    local LocalPlayer = game:GetService("Players").LocalPlayer
    LocalPlayer:Kick("Xeno is not supported. Please use a different executor.")
    return
end

local OldNameCall
local ACBypassEnabled = true

local function EnableACBypass()
    local OldNameCall
    OldNameCall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" and self == game:GetService("Players").LocalPlayer then
            warn("[AC BYPASS] Kick attempt blocked")
            return nil
        end
        return OldNameCall(self, ...)
    end)
    task.spawn(function()
        while true do
            local player = game:GetService("Players").LocalPlayer
            if player then
                local ps = player:FindFirstChild("PlayerScripts")
                if ps then
                    for _, v in pairs(ps:GetChildren()) do
                        if v:IsA("LocalScript") and (v.Name == "LocalScript2" or v.Name:find("AntiCheat")) then
                            v:Destroy()
                            warn("[AC BYPASS] Removed suspicious script: "..v.Name)
                        end
                    end
                end
            end
            task.wait(5)
        end
    end)
end

PlayerSection:AddToggle("GodMode", {
    Title = "GodMode",
    Description = "Be invincible",
    Default = false,
    Callback = function(state)
        if state then
            local godLoop
            godLoop = game:GetService("RunService").Heartbeat:Connect(function()
                local character = game.Players.LocalPlayer.Character
                if character then
                    for _, script in pairs(character:GetDescendants()) do
                        if script.Name == "KillScript" or script:IsA("Script") and script.Name:find("Kill") then
                            script:Destroy()
                        end
                    end
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.Health = humanoid.MaxHealth
                    end
                    if character:FindFirstChild("FallDamageScript") then
                        character.FallDamageScript:Destroy()
                    end
                end
            end)
            _G.GodModeConnection = godLoop
        else
            if _G.GodModeConnection then
                _G.GodModeConnection:Disconnect()
                _G.GodModeConnection = nil
            end
        end
    end
})

PlayerSection:AddSlider("WalkSpeed", {
    Title = "WalkSpeed",
    Description = "Adjust speed",
    Min = 0,
    Max = 500,
    Default = 16,
    Rounding = 0,
    Callback = function(s)
        local character = game.Players.LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = s
            end
        end
    end
})

PlayerSection:AddSlider("JumpPower", {
    Title = "JumpPower",
    Description = "Adjust jump",
    Min = 0,
    Max = 500,
    Default = 50,
    Rounding = 0,
    Callback = function(s)
        local character = game.Players.LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.JumpPower = s
            end
        end
    end
})

MainSection:AddButton({
    Title = "Instant Win",
    Description = "Instantly finish the game",
    Callback = function()
        local finish = game.workspace.tower.sections.finish.exit.ParticleBrick
        if not finish then
            for _, part in pairs(workspace:GetDescendants()) do
                if part.Name:find("Finish") or part.Name:find("Exit") then
                    finish = part
                    break
                end
            end
        end
        if finish then
            local character = game.Players.LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = finish.CFrame
            end
        else
            warn("[WIN] Could not find finish location")
        end
    end
})

MainSection:AddToggle("AntiKick", {
    Title = "AntiKick",
    Description = "Toggle Anti-Kick protection",
    Default = true,
    Callback = function(state)
        getgenv().AntiKickEnabled = state
        if state then
            print("[ANTI-KICK] AntiKick is now enabled.")
        else
            print("[ANTI-KICK] AntiKick is now disabled.")
        end
    end
})

MainSection:AddToggle("ACBypass", {
    Title = "Anti-Cheat Bypass",
    Description = "Bypass game's anti-cheat systems",
    Default = true,
    Callback = function(state)
        ACBypassEnabled = state
        if state then
            EnableACBypass()
            print("[AC BYPASS] Anti-Cheat Bypass enabled")
        else
            print("[AC BYPASS] Anti-Cheat Bypass disabled")
        end
    end
})
EnableACBypass()