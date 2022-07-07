_G.Settings = {
    ["AutoPushups"] = false,
    ["AutoMeditation"] = false,
}

local LocalPlayer = game.Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

function AutoPushups()
    while task.wait(1) do
        if _G.Settings.AutoPushups == false then break end
        
        if not LocalPlayer.PlayerGui:FindFirstChild("PushupsGui") then
            Character.Character.input:FireServer("J", false)
        end
        
        LocalPlayer.PlayerGui:WaitForChild("PushupsGui", 10)
        
        repeat
            pcall(function()
                LocalPlayer.PlayerGui.PushupsGui.Pushups.RemoteEvent:FireServer()
                task.wait()
            end)
        until _G.Settings.AutoPushups == false or not LocalPlayer.PlayerGui:FindFirstChild("PushupsGui")
    end
end

function AutoMeditation()
    for i = 1, 100 do
        Character.Character.input:FireServer("M", false)
    end
end

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/miroeramaa/TurtleLib/main/TurtleUiLib.lua"))()

local win = library:Window("Main")

win:Toggle("Auto Pushups", false, function(state)
    _G.Settings.AutoPushups = state
    
    if state then
        AutoPushups() 
    end
end)

win:Button("Mass Meditate", function()
    pcall(AutoMeditation) 
end)



