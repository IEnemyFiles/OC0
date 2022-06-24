local RP = game:GetService("ReplicatedStorage"); RP:WaitForChild("Packages"); RP:WaitForChild("Packages"):WaitForChild("Promise")
local Promise = require(RP.Packages.Promise)
local Knit = require(RP.Packages.Knit)

repeat task.wait() until game:IsLoaded() and Knit.OnStart()._status == "Resolved"

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local BoatController = Knit.GetController("BoatController")
local CollectController = Knit.GetController("CollectController")
local ControlModule = BoatController.ControlModule

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

getgenv().BoatSpeed = Vector3.new(0, 0, -10)
getgenv().ModifyBoatSpeed = false
getgenv().NoSlowdown = false
getgenv().AutoSell = false
getgenv().LayerId = 1

local SlowdownValue = LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("Client"):WaitForChild("Controllers"):WaitForChild("Boat"):WaitForChild("SlowdownPercent")

SlowdownValue.Value = 100
RunService.RenderStepped:Connect(function()
    if NoSlowdown or ModifyBoatSpeed then
        SlowdownValue.Value = 100
    end
end)

function GetClosestPartInFolder(Folder)
    local closestPart, distance

    for index, value in ipairs(Folder:GetChildren()) do
        if value:IsA("Part") then
            local partDistance = (Character.HumanoidRootPart.Position - value.Position).Magnitude

            if closestPart == nil then
                closestPart, distance = value, partDistance
            elseif closestPart ~= nil and distance > partDistance then
                closestPart, distance = value, partDistance
            end
        end
    end

    return closestPart, distance
end

function CollectTrash()
    if BoatController.CurrentBoat then
        for i,v in pairs(game:GetService("Workspace").ActiveTrash.Zone1["Layer"..LayerId]:GetChildren()) do
            BoatController.CurrentBoat.CFrame = CFrame.new(v.Position)
            RunService.Heartbeat:Wait()
            CollectController:AddCollection(v)
        end
    end
end

function SellTrash()
    local CurrentBoat = BoatController.CurrentBoat

    if CurrentBoat then
        local ClosestSellPart = GetClosestPartInFolder(game:GetService("Workspace").SellParts)

        if ClosestSellPart then
            CurrentBoat.CFrame = CFrame.new(ClosestSellPart.Position)
        end
    end
end

function UpgradeBoat()
    game:GetService("ReplicatedStorage").Packages.Knit.Services.BoatService.RF.Upgrade:InvokeServer()
end

local TrashValue = LocalPlayer.PlayerScripts.Client.Controllers:WaitForChild("Trash"):WaitForChild("Trash")
TrashValue.Changed:Connect(function(newValue)
    if AutoSell == false then return end

    if newValue >= LocalPlayer:GetAttribute("MaxTrash") then
        SellTrash()
    end
end)

task.spawn(function()
    while true do
        if AutoCollect then
            if TrashValue.Value >= LocalPlayer:GetAttribute("MaxTrash") then
                SellTrash()
            else
                CollectTrash()
                SellTrash()
                task.wait(1)
            end
        end

        task.wait(1)
    end
end)

RunService.RenderStepped:Connect(function()
    if ModifyBoatSpeed == false then return end

    if BoatController.CurrentBoat then
        local BodyVelocity = BoatController.BodyVelocity
        
        if BodyVelocity then
            if ControlModule:GetMoveVector().Z <= -0.1 then
                local BoatVelocity = BoatController.CurrentBoat.CFrame:VectorToWorldSpace(BoatSpeed) * Vector3.new(1, 0, 1)
                BodyVelocity.Velocity = BoatVelocity * 10
            elseif 0.1 <= ControlModule:GetMoveVector().Z then
                local BoatVelocity = BoatController.CurrentBoat.CFrame:VectorToWorldSpace(-BoatSpeed) * Vector3.new(1, 0, 1)
                BodyVelocity.Velocity = BoatVelocity * 10
            end
        end
    end
end)



local Config = {
    WindowName = "Sea Cleaning Simulator",
	Color = Color3.fromRGB(64, 89, 148),
	Keybind = Enum.KeyCode.RightBracket
}

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AlexR32/Roblox/main/BracketV3.lua"))()
local Window = Library:CreateWindow(Config, game:GetService("CoreGui"))

local Tab1 = Window:CreateTab("Main")
local Tab2 = Window:CreateTab("UI Settings")

local Section1 = Tab1:CreateSection("Boat Tinkering")
local Section2 = Tab1:CreateSection("Trash Related")
local Section3 = Tab2:CreateSection("Menu")
local Section4 = Tab2:CreateSection("Background")

Section1:CreateToggle("No slowdown effect", nil, function(State)
    NoSlowdown = State
end)

Section1:CreateSlider("Boat Speed", 0,25,10,false, function(Value)
	BoatSpeed = Vector3.new(0, 0, -Value)
end)

Section1:CreateToggle("Modify Boat Speed", nil, function(State)
    ModifyBoatSpeed = State
end)

Section1:CreateButton("Upgrade Boat", UpgradeBoat)

Section2:CreateToggle("Auto Sell Trash", false, function(State)
    if TrashValue.Value >= LocalPlayer:GetAttribute("MaxTrash") then
        SellTrash()
    end

    AutoSell = State
end)

Section2:CreateToggle("Auto Collect Trash", false, function(State)
    if TrashValue.Value >= LocalPlayer:GetAttribute("MaxTrash") then
        SellTrash()
    end

    AutoCollect = State
end)

Section2:CreateButton("Sell Trash", SellTrash)

Section2:CreateButton("Collect Trash", CollectTrash)

local Toggle3 = Section3:CreateToggle("UI Toggle", true, function(State)
	Window:Toggle(State)
end)
Toggle3:CreateKeybind(tostring(Config.Keybind):gsub("Enum.KeyCode.", ""), function(Key)
	Config.Keybind = Enum.KeyCode[Key]
end)

local Colorpicker3 = Section3:CreateColorpicker("UI Color", function(Color)
	Window:ChangeColor(Color)
end)
Colorpicker3:UpdateColor(Config.Color)

local Dropdown3 = Section4:CreateDropdown("Image", {"Default","Hearts","Abstract","Hexagon","Circles","Lace With Flowers","Floral"}, function(Name)
	if Name == "Default" then
		Window:SetBackground("2151741365")
	elseif Name == "Hearts" then
		Window:SetBackground("6073763717")
	elseif Name == "Abstract" then
		Window:SetBackground("6073743871")
	elseif Name == "Hexagon" then
		Window:SetBackground("6073628839")
	elseif Name == "Circles" then
		Window:SetBackground("6071579801")
	elseif Name == "Lace With Flowers" then
		Window:SetBackground("6071575925")
	elseif Name == "Floral" then
		Window:SetBackground("5553946656")
	end
end)
Dropdown3:SetOption("Default")

local Colorpicker4 = Section4:CreateColorpicker("Color", function(Color)
	Window:SetBackgroundColor(Color)
end)
Colorpicker4:UpdateColor(Color3.new(1,1,1))

local Slider3 = Section4:CreateSlider("Transparency",0,1,nil,false, function(Value)
	Window:SetBackgroundTransparency(Value)
end)
Slider3:SetValue(0)

local Slider4 = Section4:CreateSlider("Tile Scale",0,1,nil,false, function(Value)
	Window:SetTileScale(Value)
end)
Slider4:SetValue(0.5)
