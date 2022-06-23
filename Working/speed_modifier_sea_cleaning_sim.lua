repeat task.wait() until game:IsLoaded()

local SlowdownValue = game:GetService("Players").LocalPlayer.PlayerScripts.Client.Controllers.Boat.SlowdownPercent

SlowdownValue.Value = 100
SlowdownValue.Changed:Connect(function()
    SlowdownValue.Value = 100
end)


local RP = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Knit = require(RP.Packages.Knit)

local BoatController = Knit.GetController("BoatController")
local ControlModule = BoatController.ControlModule
local CurrentBoat = BoatController.CurrentBoat

local Velocity = Vector3.new(0, 0, -10)

RunService.RenderStepped:Connect(function()
    if CurrentBoat then
        if ControlModule:GetMoveVector().Z <= -0.1 then
            local BoatVelocity = CurrentBoat.CFrame:VectorToWorldSpace(Velocity) * Vector3.new(1, 0, 1)
            BoatController.BodyVelocity.Velocity = BoatVelocity * 10
        elseif 0.1 <= ControlModule:GetMoveVector().Z then
            local BoatVelocity = CurrentBoat.CFrame:VectorToWorldSpace(-Velocity) * Vector3.new(1, 0, 1)
            BoatController.BodyVelocity.Velocity = BoatVelocity * 10
        end
    end
end)