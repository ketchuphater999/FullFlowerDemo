local LocalPlayer = game.Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local MoneyScreen = PlayerGui:WaitForChild("MoneyGui")
local Frame = MoneyScreen:WaitForChild("Frame")
local Text = Frame:WaitForChild("TextLabel")

local MoneyGui = {}

function MoneyGui.start()
	Text.Text = `{LocalPlayer:GetAttribute("Cash") or 0}`
	LocalPlayer:GetAttributeChangedSignal("Cash"):Connect(function()
		Text.Text = `{LocalPlayer:GetAttribute("Cash") or 0}`
	end)
end

return MoneyGui