if game.PlaceId ~= "8540168650" then return end

local HttpService = game:GetService("HttpService")

getgenv().Webhook = "https://discord.com/api/webhooks/969508464764264539/5rSvwpr4ZcdrjUBTMCxBgjQ3gqT3zNRO6bbuImSzM2YXRZ-C_XY2Ek6qOqTW45wYkUdS"

--From https://raw.githubusercontent.com/asdlkasndklsa/StandFarm/main/OpenSourced
function WebhookFunc(Message)
    local start = game:HttpGet("http://buritoman69.glitch.me");
    local biggie = "http://buritoman69.glitch.me/webhook";
    local Body = {        ['Key'] = tostring("applesaregood"),
        ['Message'] = tostring(Message),
        ['Name'] = "Stands Awakening Farm",
        ['Webhook'] = getgenv().Webhook
    }
    Body = HttpService:JSONEncode(Body);
    local Data = game:HttpPost(biggie, Body, false, "application/json")
    return Data or nil;
end

local pCash = game.Players.LocalPlayer.Data.Cash
local old_Cash = pCash.Value

while task.wait(600) do
    WebhookFunc(string.format("Current Money: %s$\nMoney earned in 10 minutes: %s$", tostring(pCash.Value), tostring(pCash.Value - old_Cash)))
    old_Cash = pCash.Value
end