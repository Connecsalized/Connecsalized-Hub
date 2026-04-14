--// method1 (test)
local function getService(name)
    local service = game:GetService(name)
    return (cloneref and cloneref(service)) or service
end

local RS = getService("ReplicatedStorage")
local Players = getService("Players")
local Workspace = getService("Workspace")
local Player = Players.LocalPlayer
local GetConnections = getconnections or get_signal_cons
local CheckCaller = checkcaller
local getnamecalls = getnamecallmethod

local TryFindAc
local RemotesFolder = RS:WaitForChild("Remotes", 5)

local function FindACRemote()
    if not RemotesFolder then return nil end
    for _, remote in ipairs(RemotesFolder:GetChildren()) do
        if remote:IsA("RemoteEvent") and remote:GetAttribute("Tags") ~= nil then
            return remote
        end
    end
end
TryFindAc = FindACRemote()

local function Silence(signal)
    if not signal then return end
    local success, connections = pcall(GetConnections, signal)
    if success then
        for i = 1, #connections do
            connections[i]:Disconnect()
        end
    end
end

local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecalls()

    if CheckCaller() then 
        return OldNamecall(self, ...) 
    end

    if method == "FireServer" and self == TryFindAc then
        return nil
    end
    
    return OldNamecall(self, ...)
end)

local function Init()
    local Char = Player.Character or Player.CharacterAdded:Wait()
    local Hum = Char:WaitForChild("Humanoid", 5)
    
    if Hum then
        Silence(Hum.Changed)
    end
    
    for _, Part in ipairs(Char:GetChildren()) do
        if Part:IsA("BasePart") then
            Silence(Part:GetPropertyChangedSignal("Size"))
        end
    end

    Silence(Player.PlayerGui.ChildAdded)

    Silence(RS.Remotes.ChildRemoved)

    local Ball = Workspace:WaitForChild("ball", 10)
    if Ball then
        Silence(Ball:GetPropertyChangedSignal("Size"))
        Silence(Ball.ChildAdded)
    end
end

task.spawn(Init)

Player.CharacterAdded:Connect(function()
    task.wait(2)
    Init()
end)

warn("Method 1 Loaded")
