local ReplicatedStorage = game.ReplicatedStorage
local Shared = ReplicatedStorage.Shared
local Network = require(Shared.Systems.Network)

local NPC1 = {
	priceRange = {15,25},
	interactionData = {
		listenState = "FurnitureState",
		data = {
			Clean = {
				shouldOffer = true,
				strings = {
					"what a beautiful piece!"
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
					"ew! gross!",
					"come back when you have something nicer..."
				}
			},
			Empty = {
				strings = {
					"hello!~~ how are u doing?",
					"oh, me? I'm alright... some guy broke into my house and stole all my furniture :(",
					"but maybe I can find something new today!"
				}
			}
		}
	}
}

return NPC1