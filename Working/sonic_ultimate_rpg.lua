getgenv().NoDrain = false
getgenv().LoopCollectRings = false

local ringsCount = game:GetService("Players").Uselimit.PlayerGui.HUD.Rings.Counter

game:GetService("Players").Uselimit.PlayerScripts.RingsController.RingHitSound.Volume = 0

function CollectRing(Ring)
    if Ring:IsA("Part") and Ring.Transparency == 0  then
        firetouchinterest(Ring, game.Players.LocalPlayer.Character.HumanoidRootPart, 0)
        
        return true
    end
    
    return false
end

local Rings = workspace.Rings:GetDescendants()

for i,v in pairs(Rings) do
    if not v:IsA("BasePart") then continue end
    
    v:GetPropertyChangedSignal("Transparency"):Connect(function()
        if v.Transparency == 0 and LoopCollectRings then
            CollectRing(v)
        end
    end)
end

function CollectAllRings()
    for i,v in pairs(Rings) do
        if tonumber(ringsCount.Text) >= 999 then return end
        
        CollectRing(v)
    end
end

for i,v in pairs(getgc()) do
    if type(v) == "function" and islclosure(v) and not is_synapse_function(v) then
        local consts = getconstants(v)
        if table.find(consts, "math") and table.find(consts, "clamp") and table.find(consts, "Text") and table.find(consts, "None") then
            local old
            old = hookfunction(v, function(...)
                if NoDrain then
                    return
                elseif NoDrain == false then
                    old(...)
                end
            end)
        end
    end
end

function CollectEmeralds()
    for i,v in pairs(game:GetService("Workspace").ChaosEmeralds:GetChildren()) do
        if v:IsA("MeshPart") then
            print(v)
            firetouchinterest(v, game.Players.LocalPlayer.Character.HumanoidRootPart, 0)
        end
    end
end

local Config = {
    WindowName = "Sonic Ultimate RPG",
	Color = Color3.fromRGB(255,128,64),
	Keybind = Enum.KeyCode.RightBracket
}

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/AlexR32/Roblox/main/BracketV3.lua"))()
local Window = Library:CreateWindow(Config, game:GetService("CoreGui"))

local Tab1 = Window:CreateTab("Main")
local Tab2 = Window:CreateTab("UI Settings")

local Section1 = Tab1:CreateSection(" ")
local Section3 = Tab2:CreateSection("Menu")
local Section4 = Tab2:CreateSection("Background")

Section1:CreateButton("Collect All Chaos Emeralds", CollectEmeralds)

Section1:CreateToggle("No ring drain", nil, function(State)
    NoDrain = State
end)

Section1:CreateToggle("Loop Collect All Rings", nil, function(State)
    LoopCollectRings = State
    
    if State == true then
        CollectAllRings()
    end
end)

local Toggle3 = Section3:CreateToggle("UI Toggle", nil, function(State)
	Window:Toggle(State)
end)
Toggle3:CreateKeybind(tostring(Config.Keybind):gsub("Enum.KeyCode.", ""), function(Key)
	Config.Keybind = Enum.KeyCode[Key]
end)
Toggle3:SetState(true)

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
