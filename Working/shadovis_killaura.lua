--// game link: https://www.roblox.com/games/9585537847/SHADOVIS-RPG

local Run = game:GetService("RunService")
local plr = game.Players.LocalPlayer

local weaponData = require(game:GetService("ReplicatedStorage").WeaponData)
local combatData = game:GetService("ReplicatedStorage").CombatData

local WeaponName, WeaponType, WeaponM1Name

local function getM1Name(WeaponName, WeaponType)
    local weaponModule = require(combatData[WeaponType])
    
    local Data = {
        Character = game.Players.LocalPlayer.Character,
        Stats = {AS = 1},
        Tools = {WeaponName},
        Anim = require(game.ReplicatedStorage.AnimationService),
    }
    
    for i,v in next, weaponModule(Data) do
        if v.LMB then
            return v.LMB[1]
        end
    end
end

for i,v in next, plr.Character.Equipment:GetChildren() do
    if v:FindFirstChild("CharacterWeld") and v.CharacterWeld:FindFirstChild("SwordGrip") then
        WeaponName, WeaponType = v.Name, weaponData[v.Name].Type
        WeaponM1Name = getM1Name(WeaponName, WeaponType)
    end
end

plr.Character.Equipment.ChildAdded:Connect(function(v)
    if v:FindFirstChild("CharacterWeld") and v.CharacterWeld:FindFirstChild("SwordGrip") then
        WeaponName = v.Name
    end
end)

local function DamageMob(mob)
    plr.Character.Combat.RemoteEvent:FireServer("Input", WeaponName or "Broken Sword", math.random(), WeaponM1Name.."Event", mob.PrimaryPart)
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
