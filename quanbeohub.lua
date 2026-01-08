local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "QUÂN BÉO HUB 🧊",
    SubTitle = "Rimuru Ultimate Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, 
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- BIẾN HỆ THỐNG
_G.AutoFarm = false
_G.AutoFindLevi = false
_G.AutoKitsune = false
_G.AutoDragonDojo = false
_G.TweenSpeed = 325

local LP = game.Players.LocalPlayer
local Remotes = game:GetService("ReplicatedStorage").Remotes.CommF_

-- HÀM DI CHUYỂN (QUAN TRỌNG - PHẢI CÓ)
local function To(CFrame)
    pcall(function()
        local Root = LP.Character.HumanoidRootPart
        local Distance = (CFrame.p - Root.Position).Magnitude
        if Distance < 150 then
            Root.CFrame = CFrame
        else
            local Tween = game:GetService("TweenService"):Create(Root, TweenInfo.new(Distance / _G.TweenSpeed, Enum.EasingStyle.Linear), {CFrame = CFrame})
            Tween:Play()
        end
    end)
end

-- TABS
local Tabs = {
    Main = Window:AddTab({ Title = "Trang chính", Icon = "home" }),
    Sea = Window:AddTab({ Title = "Săn Biển", Icon = "waves" }),
    Boss = Window:AddTab({ Title = "Săn Boss & Hop", Icon = "refresh-cw" }),
    Lag = Window:AddTab({ Title = "Giảm Lag", Icon = "zap" })
}

-- CHỨC NĂNG TOGLE
Tabs.Main:AddToggle("AFarm", {Title = "Auto Farm Level", Default = false}):OnChanged(function(v) _G.AutoFarm = v end)
Tabs.Sea:AddToggle("ALevi", {Title = "Auto Tìm Leviathan", Default = false}):OnChanged(function(v) _G.AutoFindLevi = v end)
Tabs.Sea:AddToggle("AKitsune", {Title = "Auto Tìm Đảo Kitsune", Default = false}):OnChanged(function(v) _G.AutoKitsune = v end)
Tabs.Sea:AddToggle("ADojo", {Title = "Auto Dragon Dojo", Default = false}):OnChanged(function(v) _G.AutoDragonDojo = v end)

-- SERVER HOP
Tabs.Boss:AddButton({Name = "Server Hop (Tìm Boss)", Callback = function()
    local Http = game:GetService("HttpService")
    local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
    local Success, Result = pcall(function() return Http:JSONDecode(game:HttpGet(Api)) end)
    if Success then
        for _, s in pairs(Result.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id)
                break
            end
        end
    end
end})

-- GIẢM LAG
Tabs.Lag:AddButton({Name = "Bật Siêu Giảm Lag", Callback = function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") then 
            v.Material = Enum.Material.Plastic 
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then 
            v:Destroy() 
        end
    end
end})

-- VÒNG LẶP HỆ THỐNG
task.spawn(function()
    while task.wait() do
        pcall(function()
            -- Logic Farm (Ví dụ tìm quái gần nhất)
            if _G.AutoFarm then
                local Enemy = game.Workspace.Enemies:FindFirstChildOfClass("Model")
                if Enemy and Enemy:FindFirstChild("HumanoidRootPart") then
                    To(Enemy.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)) -- Bay trên đầu quái
                end
            end

            -- Fast Attack
            if _G.AutoFarm or _G.AutoFindLevi or _G.AutoDragonDojo then
                local Combat = require(LP.PlayerScripts.CombatFramework)
                if Combat.activeController then
                    Combat.activeController.hitboxMagnitude = 60
                    Combat.activeController:attack()
                end
            end
        end)
    end
end)

Fluent:Notify({Title = "Quân Béo Hub", Content = "Khởi tạo thành công! Chúc bạn chơi game vui vẻ.", Duration = 5})
Window:SelectTab(1)
