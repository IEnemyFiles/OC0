repeat task.wait() until game:IsLoaded() 

getgenv().IrisAd = true

local MarketplaceService = game:GetService("MarketplaceService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local RP = game:GetService("ReplicatedStorage")
local RefreshInventory = RP.Events.RefreshEquipsAndStorage
local LocalPlayer = Players.LocalPlayer
local Consts, EggData, Inventory, Sortable, PlayersClass = require(RP.Utils.ConstUtil), require(RP.Data.EggData), require(RP.Classes.PetSlot.InventorySlot), require(RP.Classes.Sortable), require(RP.Classes.Player).players[LocalPlayer]


getgenv().Settings = {}
Settings.AutoClick = false
Settings.AutoHatch = {
	Enabled = false,
	Name = "Starter",
	Amount = 1,
}
Settings.AutoRebirth = {
	Enabled = false,
	Amount = 1,
}

local Notification = loadstring(game:HttpGet("https://api.irisapp.ca/Scripts/IrisBetterNotifications.lua"))()

local EggList = {}
for i,v in pairs(EggData) do
	table.insert(EggList, i)
end

function GetPetImage(PetName)
	for index, value in ipairs(RP.Assets.UI.PetImages:GetChildren()) do
		if value.Name == PetName then
			return value.Image
		end
	end
end

function HatchEgg(EggName, Amount)
	local hatchCallback = game:GetService("ReplicatedStorage").Events.HatchEgg:InvokeServer({}, EggName, Amount)

	return hatchCallback
end

function Click()
    game:GetService("ReplicatedStorage").Events.Tap:InvokeServer()
end

function Rebirth(Amount)
	game:GetService("ReplicatedStorage").Events.Rebirth:FireServer(Amount)
end

function GetRebirthButtons()
	local buttons = {}

	for index, value in ipairs(LocalPlayer.PlayerGui.UI.Rebirth.ScrollingContainer.ScrollingFrame:GetChildren()) do
		if value:IsA("TextButton") and value.Name ~= "Infinite" then
			table.insert(buttons, value)
		end
	end

	return buttons
end

function GetRebirthButtonRebirthAmount(button)
	return tonumber(string.split(button.Rebirth.Text, " ")[1])
end

function GetMaxRebirthAmount(Coins)
	local rebirthOptions = {}
	local maxRebirthAmount

	for index, value in ipairs(GetRebirthButtons()) do
		if maxRebirthAmount == nil then
			if Coins >= tonumber(value.Name) then
				maxRebirthAmount = GetRebirthButtonRebirthAmount(value)
			end
		else
			if tonumber(value.Name) > maxRebirthAmount then
				if Coins >= tonumber(value.Name) then
					maxRebirthAmount = GetRebirthButtonRebirthAmount(value)
				end
			end
		end
	end

    return maxRebirthAmount
end


coroutine.wrap(function()
	while RunService.Heartbeat:Wait() do
		if Settings.AutoRebirth.Enabled then
			Rebirth(GetMaxRebirthAmount(PlayersClass.data.taps))
		end
	end
end)()

coroutine.wrap(function()
	while RunService.Heartbeat:Wait() do
		if Settings.AutoClick then
			Click()
		end
	end
end)()

coroutine.wrap(function()
	while task.wait(0.1) do
		if Settings.AutoHatch.Enabled then
			local hatchedPet = HatchEgg(Settings.AutoHatch.Name, Settings.AutoHatch.Amount)

			if typeof(hatchedPet) == "table" then
				for index, value in ipairs(hatchedPet) do
					Notification.Notify("Pet Hatched:", value, GetPetImage(value), {Duration = 3})
				end
			end
		end
	end
end)()

local Config = {
    WindowName = "Tapping Simulator",
	Color = Color3.fromRGB(255,128,64),
	Keybind = Enum.KeyCode.RightBracket
}

local Library = loadstring(game:GetObjects("rbxassetid://7657867786")[1].Source)()
local Window = Library:CreateWindow({
	Name = Config.WindowName,
})

local Tab1 = Window:CreateTab({
	Name = "General"
})

local Section1 = Tab1:CreateSection({
	Name = "Automation",
})

local Section2 = Tab1:CreateSection({
	Name = "Automation Settings",
})

Section1:AddToggle({
	Name = "Auto Click",
	Callback = function(State)
		Settings.AutoClick = State
	end,
})

Section1:AddToggle({
	Name = "Auto Hatch",
	Callback = function(State)
		Settings.AutoHatch.Enabled = State
	end,
})

Section1:AddToggle({
	Name = "Auto Rebirth",
	Callback = function(State)
		Settings.AutoRebirth.Enabled = State
	end,
})

local ModeDropdown

function SetHatchMode(State)
	if State == "Normal Hatch" then
		Settings.AutoHatch.Amount = 1
	else
		if PlayersClass:ownsGamePass(Consts.GAME_PASS_IDS.TRIPLE_PETS) then
			Settings.AutoHatch.Amount = 3
		else
			Notification.Notify("Error", "You don't own the triple eggs gamepass", {Duration = 3})
			ModeDropdown:Set("Normal Hatch")
		end
	end
end

ModeDropdown = Section2:AddDropdown({
		Callback = SetHatchMode,
		Name = "Hatch Mode",
		List = {"Normal Hatch", "Multi Hatch"}
	})
ModeDropdown:Set("Normal Hatch")

local RebirthAmounts = GetRebirthButtons()
local newRebirthAmounts = {}
for index, value in ipairs(RebirthAmounts) do
	table.insert(newRebirthAmounts, GetRebirthButtonRebirthAmount(value))
end

local RebirthAmountDropdown
RebirthAmountDropdown = Section2:CreateDropdown({
	Name = "Rebirth Amount",
	List = newRebirthAmounts, 
	Callback = function(State)
		Settings.AutoRebirth.Amount = State
	end
})

RebirthAmountDropdown:Set("1")

Section2:CreateButton({
	Name = "Refresh Rebirth Amounts", 
	Callback = function()
		local RebirthAmounts = GetRebirthButtons()
		local newRebirthAmounts = {}
		for index, value in pairs(RebirthAmounts) do
			table.insert(newRebirthAmounts, GetRebirthButtonRebirthAmount(value))
		end

		RebirthAmountDropdown.List = newRebirthAmounts
		RebirthAmountDropdown:Set(1)
	end
})

local EggSelectDropdown = Section2:CreateDropdown({
	Name = "Egg to open", 
	List = EggList, 
	Callback = function(State)
		Settings.AutoHatch.Name = State
	end
})
EggSelectDropdown:Set("Starter")
