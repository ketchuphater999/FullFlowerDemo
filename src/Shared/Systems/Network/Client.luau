local REs = {}
local RFs = {}

local REHooks = {}
local queue = {}
local ready = false

local curr_channel = 1

local Network = {}

function Network.handleRE(hook, ...)
	if not ready then
		table.insert(queue, {hook, ...})
		return
	end

	local hooks = REHooks[hook]
	if hooks then
		for callback, _ in hooks do
			task.spawn(callback, ...)
		end
	end
end

function Network.fireServer(hook, ...)
	curr_channel = (curr_channel%#REs)+1
	local RE = REs[curr_channel]
	RE:FireServer(hook, ...)
end

function Network.invokeServer(hook, ...)
	curr_channel = (curr_channel%#RFs)+1
	local RF = RFs[curr_channel]
	return RF:InvokeServer(hook, ...)
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

function Network.init()
	local REFolder = script.Parent:WaitForChild("RemoteEvents")
	local RFFolder = script.Parent:WaitForChild("RemoteFunctions")

	REs = REFolder:GetChildren()
	RFs = RFFolder:GetChildren()

	for _, RE in REs do
		RE.OnClientEvent:Connect(Network.handleRE)
	end
end

function Network.start()
	Network.hook("NetworkHandshake", function()
		print("[Network] handshake request received...")
		Network.fireServer("NetworkHandshake")
	end)
	
	ready = true
	for _, payload in queue do
		Network.handleRE(unpack(payload))
	end
	queue = {}
end

return Network