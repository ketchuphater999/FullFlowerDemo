local Server = game.ServerScriptService
local NPCClass = require(Server.Classes.NPC)

local CollectionService = game:GetService("CollectionService")

local NPCManager = {}
NPCManager.NPCs = {}

function NPCManager.start()
	local npcs = CollectionService:GetTagged("NPC")
	for _, model in npcs do
		local newNPC = NPCClass.new(model)
		NPCManager.NPCs[model] = newNPC
	end
end

return NPCManager