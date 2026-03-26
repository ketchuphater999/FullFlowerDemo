local ReplicatedStorage = game.ReplicatedStorage
local Shared = ReplicatedStorage.Shared
local Network = require(Shared.Systems.Network)

local NPC1 = {
	priceRange = {1,5},
	interactionData = {
		listenState = "FurnitureState",
		data = {
			Clean = {
				shouldOffer = true,
				strings = {
					"ugh.... fiiiiiine..."
					-- offer text inserted at runtime
				},
				options = {
					{
						name = "AcceptSale",
						title = "Accept",
						color = Color3.new(0,1,0),
						-- callback = function(self, player)
						-- 	player.Backpack:ClearAllChildren()
						-- 	local cash = player:GetAttribute("Cash") or 0
						-- 	player:SetAttribute("Cash", cash + self.salePrice)
						-- 	self:informPlayer(player)
						-- end
					},
					{
						name = "RefuseSale",
						title = "Refuse",
						color = Color3.new(1,0,0),
						-- callback = function(self, player)
						-- 	self:endDialogue(player)
						-- end
					}
				}
			},
			Dirty = {
				strings = {
					"omg naaaaasty are you gonna clean that?",
					"i sure hope so... yikes!"
				}
			},
			Empty = {
				strings = {
					"HI!!!!!111!! soooo nice to meet you :)",
					"I'm just taking a stroll down the street this morning... i sure hope no one tries to sell me anything",
				}
			}
		}
	}
}

return NPC1