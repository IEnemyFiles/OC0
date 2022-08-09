local RP = game:GetService("ReplicatedStorage")

task.spawn(require(RP.Modules.ActionModules.GameplayMechanics.FaucetHandler).open)

local module = require(RP.Modules.ActionModules.GameplayMechanics.BreadHandler)
local BakedColor = Color3.new(0.74, 0.61, 0.37)

local bakeBread

repeat
    for i,v in pairs(getgc()) do
        if type(v) == "function" and not is_synapse_function(v) and islclosure(v) and getfenv(v).script == RP.Modules.ActionModules.GameplayMechanics.OvenHandler then
            bakeBread = v 
        end
    end
    task.wait(0.25)
until bakeBread ~= nil

local function ColorsAreEqual(x, y)
    return x.R >= y.R and x.G >= y.G and x.B >= y.B or false
end

for i,v in ipairs(workspace.GrabbableAssets.Dough:GetChildren()) do
    if v:IsA("Part") then
        v.CFrame = workspace.TriggerZones.DoughTriggerZones.DoughTriggerZone.CFrame
    end
end

workspace.GrabbableAssets.Dough.ChildAdded:Connect(function(child)
    if child:IsA("Part") then
        child.CFrame = workspace.TriggerZones.DoughTriggerZones.DoughTriggerZone.CFrame
    end
end)

for i,v in ipairs(workspace.GrabbableAssets.Bread:GetChildren()) do
    if v:IsA("MeshPart") then
        task.delay(1, function()
            task.spawn(function()
                bakeBread(v)
            end)
        end)    
        
        if ColorsAreEqual(BakedColor, v.Color) then
            module.sell_bread(module.query_bread(v))
        end
        
        v:GetPropertyChangedSignal("Color"):Connect(function()
            if ColorsAreEqual(BakedColor, v.Color) then
                module.sell_bread(module.query_bread(v))
            end
        end)
    end
end

workspace.GrabbableAssets.Bread.ChildAdded:Connect(function(v)
    if v:IsA("MeshPart") then
        task.delay(1, function()
            task.spawn(function()
                bakeBread(v)
            end)
        end)
        
        if ColorsAreEqual(BakedColor, v.Color) then
            module.sell_bread(module.query_bread(v))
        end
        
        v:GetPropertyChangedSignal("Color"):Connect(function()
            if ColorsAreEqual(BakedColor, v.Color) then
                module.sell_bread(module.query_bread(v))
            end
        end)
    end
end)
