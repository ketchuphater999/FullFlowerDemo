local RunService = game:GetService("RunService")
local ReplicatedStorage = game.ReplicatedStorage
local Shared = ReplicatedStorage:WaitForChild("Shared")

local Network = require(Shared:WaitForChild("Systems"):WaitForChild("Network"))

local LocalPlayer = game.Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local DialogueGui = PlayerGui:WaitForChild("DialogueGui")
local ClickFrame = DialogueGui:WaitForChild("ClickFrame")
local DialogueFrame = DialogueGui:WaitForChild("Frame")
local TextBox = DialogueFrame:WaitForChild("TextBox")

local SkipEvent = ReplicatedStorage:WaitForChild("DialogueSkip")

DialogueGui.Enabled = false

local DialogueBox = {}

local DISPLAY_RATE = 35
local finishedAnimating = true
local optionsShown = false
local currentData = {}
local displayConn = nil
local connections = {}


function DialogueBox.showOptions()
	ClickFrame.Visible = false
	optionsShown = true
	for i, option in currentData.options do
		local button = Instance.new("TextButton")
		button.TextScaled = true
		button.BackgroundColor3 = option.color
		button.Text = option.title
		button.Size = UDim2.fromScale(0.2, 1)
		button.Activated:Connect(function()
			warn("SKIP: ", option.name)
			SkipEvent:Fire(option.name)
			Network.fireServer("DialogueOptionSelected", option.name)
		end)
		button.LayoutOrder = i*-1
		button.Parent = DialogueFrame.OptionsFrame
	end
end

function DialogueBox.displayNextString(dialogueData: {})
	optionsShown = false
	for _, instance in DialogueFrame.OptionsFrame:GetChildren() do
		if instance:IsA("TextButton") then
			instance:Destroy()
		end
	end

	DialogueGui.Enabled = true
	ClickFrame.Visible = true

	if displayConn then
		displayConn:Disconnect()
	end
	for _, conn in connections do
		conn:Disconnect()
	end
	connections = {}
	displayConn = nil

	optionsShown = false
	finishedAnimating = false
	currentData = dialogueData or currentData
	TextBox.Text = ""
	local elapsed = 0
	displayConn = RunService.RenderStepped:Connect(function(dt)
		elapsed += dt
		local numCharsToDisplay = math.min(math.round(elapsed*DISPLAY_RATE), string.len(currentData.strings[1]))
		local stringSegment = string.sub(currentData.strings[1], 0, numCharsToDisplay)
		TextBox.Text = stringSegment

		if numCharsToDisplay == string.len(currentData.strings[1]) then
			displayConn:Disconnect()
			finishedAnimating = true
			table.remove(currentData.strings, 1)
			if #currentData.strings < 1 and currentData.options then
				DialogueBox.showOptions()
			end
		end
	end)
end

function DialogueBox.cancel()
	if displayConn then
		displayConn:Disconnect()
	end
	for _, conn in connections do
		conn:Disconnect()
	end
	connections = {}
	displayConn = nil

	optionsShown = false
	finishedAnimating = false
	DialogueGui.Enabled = false
end

function DialogueBox.start()
	game.ReplicatedStorage:WaitForChild("Value").Changed:Connect(function(value)
		local strings = string.split(value, ",")
		DialogueBox.displayNextString({
			options = {
				{
					name = "accept",
					title = "Accept",
					color = Color3.new(0,1,0)
				},
				{
					name = "refuse",
					title = "Refuse",
					color = Color3.new(1,0,0)
				}
			},
			strings = strings
		})
	end)

	Network.hook("DisplayDialogue", DialogueBox.displayNextString)

	ClickFrame.MouseButton1Down:Connect(function()
		if finishedAnimating then
			if #currentData.strings > 0 then
				DialogueBox.displayNextString()
			elseif (not currentData.options) or (#currentData.options < 1) then
				SkipEvent:Fire()
				Network.fireServer("FinishedDialogue")
				DialogueGui.Enabled = false
				warn("SKIP DIALOGUE")
			elseif not optionsShown then
				DialogueBox.showOptions()
			end
		else
			if displayConn then
				displayConn:Disconnect()
				TextBox.Text = currentData.strings[1]
				table.remove(currentData.strings, 1)
				finishedAnimating = true

				if (not optionsShown) and currentData.options and #currentData.options >= 1 and #currentData.strings < 1 then
					DialogueBox.showOptions()
				end
			end
		end
	end)
end

return DialogueBox