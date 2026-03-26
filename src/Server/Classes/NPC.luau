local ReplicatedStorage = game.ReplicatedStorage
local Shared = ReplicatedStorage.Shared
local Network = require(Shared.Systems.Network)

local NPCData = Shared.Data.NPCData

local r = Random.new()

local NPC = {}
NPC.__index = NPC

function deepCopy(t)
    local copy = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            copy[k] = deepCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

function NPC:doSale(player)
	-- update player cash and inform them of the sale
	local cash = player:GetAttribute("Cash") or 0
	player:SetAttribute("Cash", cash + self.currentPrice)
	Network.fireClient(player, "DisplayDialogue", {
		strings = {
			"awesome!!!",
			`here's your {self.currentPrice} dollars - you now have {cash + self.currentPrice} in the bank!`
		}
	})

	-- take their furniture
	player.Character.Humanoid:UnequipTools()
	player.Backpack:ClearAllChildren()
end

function NPC:refuseSale(player)
	Network.fireClient(player, "DisplayDialogue", {
		strings = {
			"awe, okay:("
		}
	})
end

function NPC:startDialogue(player)
	self.state = "talking"
	self.currentPlayer = player

	local state = player:GetAttribute(self.data.interactionData.listenState)
	local dialogueOption = self.data.interactionData.data[state] or {strings = {"i have no idea what to say :("}}
	dialogueOption = deepCopy(dialogueOption)
	if dialogueOption.shouldOffer then
		self.currentPrice = r:NextInteger(table.unpack(self.data.priceRange))
		local offerString = `would you take {self.currentPrice} for it?`
		table.insert(dialogueOption.strings, offerString)
	end
	Network.fireClient(player, "DisplayDialogue", dialogueOption)
end

function NPC.new(model: Model)
	local self = setmetatable({}, NPC)
	self.model = model
	self.state = "idle"
	self.lastTransaction = nil

	local dataType = self.model:GetAttribute("NPCData")
	warn("GETTING: ", dataType)
	self.data = require(NPCData:FindFirstChild(self.model:GetAttribute("NPCData")))

	self.proximityPrompt = self.model.PromptPart.ProximityPrompt
	self.proximityPrompt.Triggered:Connect(function(player)
		if self.state ~= "idle" then
			return
		end
		self:startDialogue(player)
	end)

	Network.hook("FinishedDialogue", function(player)
		-- reset state
		if player and player == self.currentPlayer then
			self.currentPlayer = nil
			self.state = "idle"
		end
	end)
	Network.hook("DialogueOptionSelected", function(player, option)
		-- handle player's selection
		if player and player == self.currentPlayer then
			if option == "AcceptSale" then
				self:doSale(player)
			elseif option == "RefuseSale" then
				self:refuseSale(player)
			end
		end
	end)
	return self
end

return NPC