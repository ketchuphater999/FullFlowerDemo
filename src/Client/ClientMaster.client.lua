local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local Client = Player:WaitForChild("PlayerScripts")
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Lib = ReplicatedStorage:WaitForChild("Lib")

local Network = require(Shared.Systems.Network)
Network.init()

local loadOrder = {
    -- Client.Systems.MapLoader,
    -- Client.Systems.MapView,
    -- Client.Systems.CameraControl,
    -- Client.Systems.Highlights,
    -- Client.Systems.Autocomplete,
    -- Client.Systems.MapController,
    -- Client.Systems.GameHandler,
}

local ui = {
    -- Client.Ui.StarterGuiHandler,
    -- Client.Ui.SearchBox,
    -- Client.Ui.Tooltips,
    -- Client.Ui.Menu,
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