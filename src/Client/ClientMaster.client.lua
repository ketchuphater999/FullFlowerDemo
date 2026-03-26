local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Client = Player:WaitForChild("PlayerScripts")
local Shared = ReplicatedStorage:WaitForChild("Shared")

local Network = require(Shared.Systems.Network)
Network.init()

local loadOrder = {
    
}

local ui = {
    Client.Ui.DialogueBox,
    Client.Ui.MoneyGui
}

for _, module in ipairs(loadOrder) do
    local success, moduleState = pcall(function()
        return require(module)
    end)
    if success then
        moduleState.start()
    else
        warn("Module load fail: ", module.Name)
    end
end

Player:WaitForChild("PlayerGui")

for _, ui in ipairs(ui) do
    local success, moduleState = pcall(function()
        return require(ui)
    end)
    if success then
        moduleState.start()
    else
        warn("Module load fail: ", ui.Name)
    end
end

Network.start()