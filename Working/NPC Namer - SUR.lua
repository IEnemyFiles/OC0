for i,v in pairs(game:GetService("Workspace").Ichangedthenameagainratio:GetDescendants()) do
    if v.Name == "Main" and v:IsA("BillboardGui") then
        if v.Parent.Parent.Name == "ratio" then
            v.Parent.Name = v.Text.Text
        elseif v.Parent.Parent.Parent.Name == "ratio" then
            v.Parent.Parent.Parent.Name = v.Text.Text
        end
    end
end

game:GetService("Workspace").Ichangedthenameagainratio.Name = "Fartinglloll"