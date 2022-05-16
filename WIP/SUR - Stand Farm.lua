local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

repeat task.wait() until game:IsLoaded() and Players.LocalPlayer.Character and Players.LocalPlayer.LoadedIn.Value

local local_Player = Players.LocalPlayer
local pCash = local_Player.Data.Cash
local pBackpack = local_Player.Backpack
local Data = local_Player.Data
local Stand_Stat = Data.Stand

local Stand_Names_Folder = game:GetService("ReplicatedStorage").StandNameConvert

getgenv().Stand_Farm = {
    Enabled = true,
    Arrow = "Stand Arrow",
    List_Type = "Whitelist"
}

Item_Prices = {
    ["stand arrow"] = 20000,
    ["rokakaka"] = 13750,
    ["charged arrow"] = 225000,
}

getgenv().Blacklisted_Stands = {}
getgenv().Whitelisted_Stands = {}
getgenv().Whitelisted_Attributes = {"Strong", "Powerful", "Manic", "Tough", "Enrage", "Sloppy", "Lethargic", "Legendary", "Godly", "Daemon"}
getgenv().Blacklisted_Attributes = {}
getgenv().Webhook = "https://discord.com/api/webhooks/969508464764264539/5rSvwpr4ZcdrjUBTMCxBgjQ3gqT3zNRO6bbuImSzM2YXRZ-C_XY2Ek6qOqTW45wYkUdS"

local function Broke()
    WebhookFunc(
    [[
        @everyone 
        Your broke bro
    ]]
)
end

local function Buy_Item(Item_Name)
    Item_Name = string.lower(Item_Name)

    if Item_Name == "stand arrow" then
        if pCash.Value >= Item_Prices[Item_Name] then
            game:GetService("ReplicatedStorage").Events.BuyItem:FireServer("MerchantAU", "Option3")
        else
            Broke()
        end      
    elseif Item_Name == "rokakaka" then
        if pCash.Value >= Item_Prices[Item_Name] then
            game:GetService("ReplicatedStorage").Events.BuyItem:FireServer("MerchantAU", "Option1")
        else
            Broke()
        end
    elseif Item_Name == "charged arrow" then
        if pCash.Value >= Item_Prices[Item_Name] then
            game:GetService("ReplicatedStorage").Events.BuyItem:FireServer("Merchantlvl120", "Option1")
        else
            Broke()
        end
    end
end

local function Get_Equipped_Stand(Player : Player)
    if Player == nil then error(Player.."Doesn't exist") return end

    local Data_Folder = Player.Data
    local Equipped_Stand = Data_Folder.Stand.Value
    local Stand_Attribute = Data_Folder.Attri.Value

    return Equipped_Stand, Stand_Attribute
end
local function Use_Tool(tool : Tool)
    local pCharacter = local_Player.Character or local_Player.CharacterAdded:Wait()
    local pHumanoid : Humanoid = pCharacter:FindFirstChild("Humanoid")

    if tool:FindFirstChild("Use") then
        pHumanoid:EquipTool(tool)
        tool.Use:FireServer()
    end
end

local function Use_Arrow()
    local pCharacter = local_Player.Character or local_Player.CharacterAdded:Wait()
    local pHumanoid : Humanoid = pCharacter:FindFirstChild("Humanoid")

    if pHumanoid and pHumanoid.Health > 0 then
        local Stand_Arrow = pBackpack:FindFirstChild(Stand_Farm["Arrow"])

        if Stand_Arrow then
            Use_Tool(Stand_Arrow)
        else
            Buy_Item(Stand_Farm["Arrow"])
            task.wait(1)
            Use_Arrow(Stand_Arrow)
        end
    else
        error(local_Player.Name.." is dead :c")
    end
end

local function Use_Roka()
    local pCharacter = local_Player.Character or local_Player.CharacterAdded:Wait()
    local pHumanoid : Humanoid = pCharacter:FindFirstChild("Humanoid")
    local pBackpack : Backpack = local_Player.Backpack

    if pHumanoid and pHumanoid.Health > 0 then
        local Roka = pBackpack:FindFirstChild("Rokakaka")

        if Roka then
            Use_Tool(Roka)
        else
            Buy_Item("Rokakaka")
            task.wait(1)
            Use_Arrow(Roka)
        end
    else
        error(local_Player.Name.." is dead :c")
    end
end



local function Convert_Stand_Name(Stand_Name)
    if Stand_Names_Folder[Stand_Name] then
        return Stand_Names_Folder[Stand_Name].Value
    else
        return Stand_Name
    end
end

local function Obtained_Stand()
    local Current_Stand, Stand_Attribute = Get_Equipped_Stand(local_Player)
    local Unshortened_Stand_Name = Convert_Stand_Name(Current_Stand)

    WebhookFunc(string.format("You got %s with %s attribute", Unshortened_Stand_Name, Stand_Attribute))
end

local function Stand_Checker()
    local Current_Stand, Stand_Attribute = Get_Equipped_Stand(local_Player)
    local Unshortened_Stand_Name

    if Current_Stand ~= "None" then
        Unshortened_Stand_Name = Convert_Stand_Name(Current_Stand)
    else
        Unshortened_Stand_Name = "None"
    end

    print(Unshortened_Stand_Name)
    if ((Current_Stand ~= nil) or ((not Whitelisted_Stands[Current_Stand]) and (not Whitelisted_Stands[Unshortened_Stand_Name]))) and (not table.find(Whitelisted_Attributes, Stand_Attribute)) then
        return false
    elseif table.find(Whitelisted_Attributes, Stand_Attribute) or ((Whitelisted_Stands[Current_Stand]) or (Whitelisted_Stands[Unshortened_Stand_Name])) and ((table.find(Whitelisted_Stands[Unshortened_Stand_Name], "All"))  or table.find(Whitelisted_Stands[Unshortened_Stand_Name], Stand_Attribute)) then
        return true
    end
end

local function Stand_Roller()
    local Current_Stand, Stand_Attribute = Get_Equipped_Stand(local_Player)

    if Current_Stand == "None" then
        Use_Arrow()
    elseif Current_Stand ~= "None" and Stand_Checker() == false then
        Use_Roka()
    elseif Stand_Checker() == true then
        Obtained_Stand()
    end
end

pcall(function()
    while true do
        if (Stand_Farm["Enabled"] == false) or (Stand_Checker() == true) then break end

        Stand_Roller()
        task.wait(2)
    end
end)
