local REs = {}
local RFs = {}

local REHooks = {}
local RFHooks = {}

local queue = {}

local ready = false

local Network = {}
local CHANNELS = 16
local curr_channel = 1

function Network.handleRE(player, hook, ...)
	if not ready then
		table.insert(queue, {player, hook, ...})
		return
	end

	local hooks = REHooks[hook]
	if hooks then
		for callback, _ in hooks do
			task.spawn(callback, player, ...)
		end
	end
end

function Network.handleRF(player, hook, ...)
	local hook = RFHooks[hook]
	if hook then
		return hook(player, ...)
	else
		return nil
	end
end

function Network.fireClient(player, hook, ...)
	curr_channel = (curr_channel%CHANNELS) + 1
	local RE = REs[curr_channel]
	RE:FireClient(player, hook, ...)
end

function Network.fireAllClients(hook, ...)
	for _, player in game.Players:GetPlayers() do
		Network.fireClient(player, hook, ...)
	end
end

function Network.hook(hook, callback)
	if not REHooks[hook] then
		REHooks[hook] = {}
	end

	REHooks[hook][callback] = true

	return {
		Disconnect = function()
			REHooks[hook][callback] = nil
		end
	}
end

function Network.hookFunction(hook, callback)
	if RFHooks[hook] then
		error(`Attempted to overload RF hook: {hook}`)
	end

	RFHooks[hook] = callback

	return {
		Disconnect = function()
			RFHooks[hook] = nil
		end
	}
end

function Network.init()
	local REFolder = Instance.new("Folder")
	REFolder.Name = "RemoteEvents"
	REFolder:SetAttribute("count", CHANNELS)

	local RFFolder = Instance.new("Folder")
	RFFolder.Name = "RemoteFunctions"
	RFFolder:SetAttribute("count", CHANNELS)

	for i=1,CHANNELS do
		local RE = Instance.new("RemoteEvent")
		RE.Name = `RemoteEvent{i}`
		RE.OnServerEvent:Connect(Network.handleRE)
		RE.Parent = REFolder

		local RF = Instance.new("RemoteFunction")
		RF.Name = `RemoteFunction{i}`
		RF.OnServerInvoke = Network.handleRF
		RF.Parent = RFFolder

		table.insert(REs, RE)
		table.insert(RFs, RF)
	end

	REFolder.Parent = script.Parent
	RFFolder.Parent = script.Parent
end

function Network.start()
	for _, player in game:GetService("Players"):GetPlayers() do
		Network.fireClient(player, "NetworkHandshake")
	end
	
	game:GetService("Players").PlayerAdded:Connect(function(player)
		Network.fireClient(player, "NetworkHandshake")
	end)

	Network.hook("NetworkHandshake", function(player)
		print("[Network] "..player.Name.." - handshake completed, network ready!")
	end)

	ready = true
	for _, payload in queue do
		Network.handleRE(unpack(payload))
	end
	queue = {}

	print("[Network] Loaded. Hello Server!")
end

return Network