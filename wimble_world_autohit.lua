local is_executor_function = is_synapse_function or isexecutorclosure

local old
old = hookmetamethod(game, "__namecall", function(self, ...)
    if self.Name == "Court_ClientHitBall" and getnamecallmethod() == "InvokeServer" then
        old(self, Vector3.new(1, 1, 1) * 9e9, "Special")
        return
    end
    return old(self, ...)
end)

for i,v in pairs(getgc()) do
    if type(v) == "function" and islclosure(v) and not is_executor_function(v) then
        local getconsts = getconstants(v)
        
        if table.find(getconsts, "FilterType") and table.find(getconsts, "HitBox") and table.find(getconsts, "FilterDescendantsInstances") then
            hookfunction(v, function()
                return true
            end)
        end
    end
end
