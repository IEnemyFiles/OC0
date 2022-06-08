--https://www.roblox.com/games/9561878567/CORRUPTION-Forest-Of-Beginnings-RPG#!/game-instances

local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local playerCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local playersSword

function setPlayersSword(player)
    playersSword = LocalPlayer.Character:FindFirstChildOfClass("Tool")
    
    if playersSword == nil then
        local lastDamage
        local bestSword
        
        for i,v in pairs(LocalPlayer.Backpack:GetChildren()) do
            if v:IsA("Tool") then
                local WeaponConfig = v:FindFirstChild("WeaponConfig")
                
                if WeaponConfig then
                    WeaponConfig = require(WeaponConfig)
                end
                
                if WeaponConfig then
                    if bestSword == nil then
                        bestSword = v
                        lastDamage = WeaponConfig.MaxDamage
                    elseif lastDamage < WeaponConfig.MaxDamage then
                        bestSword = v
                        lastDamage = WeaponConfig.MaxDamage
                    end
                end
            end
        end
        
        playerCharacter:FindFirstChildOfClass("Humanoid"):EquipTool(bestSword)
        playersSword = bestSword
    end
end

function dealDamage(Mob)
    local mobLimb = Mob:FindFirstChild("HumanoidRootPart")
    local mobHumanoid = Mob:FindFirstChild("Enemy")
    local sword = playersSword
    
    if mobLimb and mobHumanoid and sword then
        game:GetService("ReplicatedStorage").GameRemotes.DamageEvent:FireServer(mobLimb, mobHumanoid, sword)
    end
end

while LoopKillAll do
    for i,v in pairs(workspace.Mobs:GetChildren()) do
        setPlayersSword(LocalPlayer)
    
        dealDamage(v)
    end
    
    task.Wait(2)
end
