--// game link: https://www.roblox.com/games/9585537847/SHADOVIS-RPG

getgenv().MaxRange = 25
getgenv().MaxThreads = 9e9
getgenv().CurrentThreadCount = 0

local Run = game:GetService("RunService")
local plr = game.Players.LocalPlayer

local WeaponData = require(game:GetService("ReplicatedStorage").WeaponData)

local WeaponName

for i,v in next, plr.Character.Equipment:GetChildren() do
    if WeaponData[v.Name] then
        WeaponName = v.Name
    end
end

plr.Character.Equipment.ChildAdded:Connect(function(v)
    if WeaponData[v.Name] then
        WeaponName = v.Name
    end
end)

local function DamageMob(mob)
    plr.Character.Combat.RemoteEvent:FireServer("Input", WeaponName or "Broken Sword", math.random(), "SlashEvent", mob.PrimaryPart)
end

Run.Heartbeat:Connect(function()
    if getgenv().Enabled == nil or getgenv().Enabled == false then return end
    
    for i,v in next, workspace.NPCs:GetChildren() do
        local dist = (plr.Character.PrimaryPart.Position - v.PrimaryPart.Position).Magnitude
        
        if dist < MaxRange then
            DamageMob(v)
        end
    end
end)
