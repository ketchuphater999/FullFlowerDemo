--!nonstrict

local Players = game:GetService("Players")
local ReplicatedStorage = game.ReplicatedStorage
local CleanTool = ReplicatedStorage.CleanTable
local DirtyTool = ReplicatedStorage.DirtyTable

local GetDirtyToolPrompt: ProximityPrompt = workspace.GetDirty.ProximityPrompt
local GetCleanToolPrompt: ProximityPrompt = workspace.GetClean.ProximityPrompt
local TrashPrompt: ProximityPrompt = workspace.Trash.ProximityPrompt
local WashPrompt: ProximityPrompt = workspace.Bathtub.PromptPart.ProximityPrompt

local TableManager = {}

function TableManager.start()
	-- provide the player with the selected tools
	GetDirtyToolPrompt.Triggered:Connect(function(player: Player)
		player.Character.Humanoid:UnequipTools()
		player.Backpack:ClearAllChildren()
		local newTool = DirtyTool:Clone()
		newTool.Parent = player.Backpack
		
		player.Character.Humanoid:EquipTool(newTool)

		player:SetAttribute("FurnitureState", "Dirty")
	end)

	GetCleanToolPrompt.Triggered:Connect(function(player: Player)
		player.Character.Humanoid:UnequipTools()
		player.Backpack:ClearAllChildren()
		local newTool = CleanTool:Clone()
		newTool.Parent = player.Backpack
		
		player.Character.Humanoid:EquipTool(newTool)

		player:SetAttribute("FurnitureState", "Clean")
	end)

	TrashPrompt.Triggered:Connect(function(player: Player)
		player.Character.Humanoid:UnequipTools()
		player.Backpack:ClearAllChildren()
		player:SetAttribute("FurnitureState", "Empty")
	end)

	WashPrompt.Triggered:Connect(function(player: Player)
		if player:GetAttribute("FurnitureState") == "Dirty" then
			player.Character.Humanoid:UnequipTools()
			player.Backpack:ClearAllChildren()

			local newTool = CleanTool:Clone()
			newTool.Parent = player.Backpack
			player.Character.Humanoid:EquipTool(newTool)

			player:SetAttribute("FurnitureState", "Clean")
		end
	end)

	-- initialize the player to empty state
	Players.PlayerAdded:Connect(function(player)
		player:SetAttribute("FurnitureState", "Empty")
	end)

	for _, player in Players:GetPlayers() do
		player:SetAttribute("FurnitureState", "Empty")
	end
end

return TableManager