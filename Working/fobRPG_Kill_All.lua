local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local playerCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local playersSword

function setPlayersSword()
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
    local sword = playersSword or setPlayersSword()
    
    if mobLimb and mobHumanoid and sword then
        game:GetService("ReplicatedStorage").GameRemotes.DamageEvent:FireServer(mobLimb, mobHumanoid, sword)
    end
end

LocalPlayer.Backpack.ChildAdded:Connect(setPlayersSword)

setPlayersSword()

while LoopKillAll do
    for i,v in pairs(workspace.Mobs:GetChildren()) do
        dealDamage(v)
    end
    
    task.wait(2)
end
