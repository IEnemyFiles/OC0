--// www.roblox.com/games/8540168650/

local SpawnedItemsFolder = game:GetService("Workspace").Items

local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()

ESP:AddObjectListener(SpawnedItemsFolder, {
    Color = Color3.new(1, 1, 0),
    Type = "Tool",
    PrimaryPart = function(obj)
        local basePart = obj:FindFirstChildWhichIsA("BasePart")
        print(basePart)
        return basePart
    end,
    IsEnabled = "Items",
})

ESP.Items = true
ESP.Tracers = true
ESP.Boxes = false
ESP:Toggle(true)
ESP.Players = false