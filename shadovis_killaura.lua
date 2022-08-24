--// game link: https://www.roblox.com/games/9585537847/SHADOVIS-RPG

getgenv().MaxRange = 25
getgenv().MaxThreads = 1
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
    for i,v in next, workspace.NPCs:GetChildren() do
        local dist = (plr.Character.PrimaryPart.Position - v.PrimaryPart.Position).Magnitude
        
        if dist < getgenv().MaxRange and CurrentThreadCount < MaxThreads then
            CurrentThreadCount += 1
            task.spawn(function()
                repeat
                    DamageMob(v)
                    Run.Heartbeat:Wait()
                until v == nil or v:FindFirstChildOfClass("Humanoid") == nil or v.Humanoid.Health <= 0 or (plr.Character.PrimaryPart.Position - v.PrimaryPart.Position).Magnitude >= MaxRange
                CurrentThreadCount -= 1
            end)
        end
    end
end)
