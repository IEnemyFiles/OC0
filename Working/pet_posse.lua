repeat task.wait() until game:IsLoaded() 

getgenv().Settings = {
    CollectCoins = false,
    Area = "SpawnWorld",
    Zone = "Starter Camp Zone",
    AutoHatch = {
        Toggle = false,
        Egg = "Meadow Egg",
    },
    AutoEquipBest = {
        Toggle = false,
    }
}

getgenv().IrisAd = true

local RunService = game:GetService"RunService"
local RP = game:GetService("ReplicatedStorage")
local Plrs = game:GetService("Players")

local LocalPlayer = Plrs.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local uiImgs = require(RP:WaitForChild("Framework").Modules.Client.uiImgs)

local coinFolder = workspace["__THINGS"].Coins.SpawnWorld
local Notification = loadstring(game:HttpGet("https://api.irisapp.ca/Scripts/IrisBetterNotifications.lua"))()

function CollectCoins()
    repeat
        for i,v in pairs(coinFolder:GetChildren()) do
            local zone = Settings.Zone
            
            if not getgenv().Settings.CollectCoins then
                return
            end
            
            if v:FindFirstChild("Coin") and v.Zone.Value == zone then
                fireclickdetector(v.Coin.ClickDetector)
                repeat
                    workspace.__THINGS.__REMOTES.clickedButton:FireServer(v.Coin, v)
                    RunService.Heartbeat:Wait()
                until v == nil or v:FindFirstChild"Coin" == nil or not Settings.CollectCoins or Settings.Zone ~= zone
            end
        end
    until not Settings.CollectCoins
end

function OpenEgg(eggName)
    local yes = workspace.__THINGS.__REMOTES.buyEgg:InvokeServer(eggName)
    if yes then
        yes = yes[1]
        
        if typeof(yes) == "table" then
            Notification.Notify("Pet Hatched:", string.format("%s %s", yes[2], yes[1]), uiImgs["petIcons"][yes[1]], {Duration = 1.5})
        elseif typeof(yes) == "string" then
            Notification.Notify("Error:", string.format("You need %s more coins for %s", yes, Settings.AutoHatch.Egg), {Duration = 1.5})
        end
    end
end

function AutoEquipBest()
    while task.wait(0.5) and getgenv().Settings.AutoEquipBest.Toggle do
        workspace.__THINGS.__REMOTES.equipAll:FireServer("Equip All")
    end
end 

local lastHatch = nil

function AutoHatch()
    while task.wait(0.5) and getgenv().Settings.AutoHatch.Toggle == true do
        if Settings.AutoHatch.Toggle == false then break end
        
        task.spawn(function()
            lastHatch = OpenEgg(Settings.AutoHatch.Egg)
        end)
    end
end

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stebulous/solaris-ui-lib/main/source.lua"))()

local win = lib:New({Name = "Pet Posse", FolderToSave = "PetPosse"})

local tab = win:Tab("Main")

local toggleSection = tab:Section("Eggs")
local settingsSection = tab:Section("Coins")

settingsSection:Toggle("Auto Collect Coins", false, "CollectCoin", function(state)
    getgenv().Settings.CollectCoins = state
    if state then
        task.spawn(CollectCoins)
    end
end)

toggleSection:Toggle("Auto Open Egg", false, "OpenEgg", function(state)
    getgenv().Settings.AutoHatch.Toggle = state
    if state then
        task.spawn(AutoHatch)
    end
end)

local yes = {}

for i,v in pairs(uiImgs["eggIcons"]) do
    table.insert(yes, i)
end

toggleSection:Dropdown("Selected Egg", yes, "Starter Camp Egg", "SelEgg", function(state)
    getgenv().Settings.AutoHatch.Egg = state
end)

function RefreshAreas()
    local areas = {}
    
    for i,v in pairs(workspace["__MAP"].Areas:GetChildren()) do
        table.insert(areas, v.Name)
    end
    
    return areas
end

function RefreshZones()
    local zones = {}
    
    for i,v in pairs(workspace["__THINGS"].Coins[Settings.Area]:GetChildren()) do
        if not v:FindFirstChild"Zone" then continue end
        
        if not table.find(zones, v.Zone.Value) then
            table.insert(zones, v.Zone.Value)
        end
    end
    
    return zones
end

local areaDropdown = settingsSection:Dropdown("Area", RefreshAreas(), Settings.Area, "area", function(state)
    getgenv().Settings.Area = state
end)

settingsSection:Button("Refresh Areas", function()
    areaDropdown:Refresh(RefreshAreas(), true)
end)

local zoneDropdown = settingsSection:Dropdown("Zone", RefreshZones(), Settings.Zone, "zone", function(state)
    getgenv().Settings.Zone = state
end)

settingsSection:Button("Refresh Zones", function()
    areaDropdown:Refresh(RefreshZones(), true)
end)

local miscTab = win:Tab("Misc")
local miscSection1 = miscTab:Section("Local Player")
local miscSection2 = miscTab:Section("Pets")

miscSection1:Slider("WalkSpeed", 15, 100, 16, 1, "WalkSpeed", function(State)
    pcall(function()
        Character.Humanoid.WalkSpeed = State
    end)
end)

miscSection2:Toggle("Auto Equip Best", false, "EquipBest", function(State)
    getgenv().Settings.AutoEquipBest.Toggle = State
    if State then
        task.spawn(AutoEquipBest)
    end
end)
