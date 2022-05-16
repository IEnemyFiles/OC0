if game.PlaceId ~= 8540168650 then return end

local Players = game:GetService("Players")

repeat task.wait() until game:IsLoaded() and Players.LocalPlayer.Character and Players.LocalPlayer.LoadedIn.Value

local localPlayer = Players.LocalPlayer
local Data = localPlayer.Data

local fileName = 'StandStorage'..localPlayer.Name..'.txt'

local function updateFile()
    pcall(function()
        if (not isfile(fileName)) then
            writefile(fileName, '')
        else
            writefile(fileName, '')
        end
    end)

    local standStorageTable = {
        Equipped = {
            Stand = Data.Stand.Value,
            Attri = Data.Attri.Value
        }
    }

    for i,v in pairs(Data:GetChildren()) do
        if string.find(v.Name, "Slot2") or string.find(v.Name, "Slot1") then
            local slotNumber = string.sub(v.Name, 1, 5)
            local slotType = string.sub(v.Name, 6)
            
            if (not standStorageTable[slotNumber]) then
                standStorageTable[slotNumber] = {}
            end

            standStorageTable[slotNumber][slotType] = v.Value
        end
    end

    for i,v in pairs(standStorageTable) do
        appendfile(fileName, "\n"..i)
        for _i,_v in pairs(v) do
            appendfile(fileName, "\n".._i..' '.._v)
        end

        appendfile(fileName, "\n ")
    end
end

updateFile()

while task.wait(10) do
    updateFile()
end

Players.PlayerRemoving:Connect(function(Player : Player)
    if Player == localPlayer then
        updateFile()
    end 
end)
