local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Server = game:GetService("ServerScriptService")
local Shared = ReplicatedStorage:WaitForChild("Shared")

local Network = require(Shared.Systems.Network)

Network.init()

local loadOrder = {
    Server.Systems.TableManager,
    Server.Systems.NPCManager,
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

Network.start()