--!strict
--[[================================================================================================

Network | Written by Devi (@Devollin) | 2022 | v1.0.3
	Description: A library to handle networking easily.
	
Additional credits to:
	Mia (@iGottic) - Cleanup & various modifications
	
==================================================================================================]]


type Metadata = {
	name: string,
	type: string,
	timestamp: number?,
	id: number?,
}


local RunService: RunService = game:GetService("RunService")

local Signal = require(script.Parent.Parent:WaitForChild("Signal"))

local remote = script.Parent:WaitForChild("RemoteEvent", 5) :: RemoteEvent

if RunService:IsClient() then
	if not remote then
		warn("Failed to find remote event; did you forget to require Network on the server?")
		
		remote = script.Parent:WaitForChild("RemoteEvent") :: RemoteEvent
	end
end


local connections = {}
local requests: {[string]: Signal.Connection<...any>} = {}
local random = Random.new()

local interface = {}


local function GenerateMetadata(name: string, type: string): Metadata
	if type == "Normal" then
		return {
			name = name,
			type = type,
		}
	elseif type == "Request" or type == "RequestResult" then
		return {
			name = name,
			type = type,
			timestamp = tick(),
			id = random:NextNumber(1, 9999),
		}
	else
		return {
			name = name,
			type = type,
		}
	end
end

--[=[
	Connects a callback to an [RemoteEvent].
	
	@param name -- The name of the stream you want to connect to.
	@param callback -- The callback that you want to connect to this stream.
	
	@within Network
	@client
]=]
function interface:Connect(name: string, callback: (...any) -> ()): Signal.Connection<...any>
	if not connections[name] then
		connections[name] = Signal.new()
	end
	
	return connections[name]:Connect(function(metadata: Metadata, ...: any)
		if metadata.type == "Normal" then
			callback(...)
		end
	end)
end

--[=[
	Disconnects an entire stream.
	
	@param name -- The name of the stream you want to destroy.
	
	@within Network
	@client
]=]
function interface:Disconnect(name: string)
	if connections[name] then
		connections[name]:Destroy()
		connections[name] = nil
	end
end

--[=[
	Waits until an event with the given name is triggered.
	
	@param name -- The name of the stream.
	
	@within Network
	@client
]=]
function interface:Wait(name: string): (...any)
	if not connections[name] then
		connections[name] = Signal.new()
	end
	
	local results
	
	repeat
		results = {connections[name]:Wait()}
	until results[1].type == "Normal"
	
	table.remove(results, 1)
	
	return table.unpack(results)
end

--[=[
	Fires a [RemoteEvent] to the server within the given data stream.
	
	@param name -- The name of the stream.
	@param ... -- Any additional parameters you want to provide.
	
	@within Network
	@client
]=]
function interface:Fire(name: string, ...: any)
	remote:FireServer(GenerateMetadata(name, "Normal"), ...)
end

--[=[
	Fires a [RemoteEvent] to the server within the given data stream, and yields until the server responds.
	
	@param name -- The name of the stream.
	@param ... -- Any additional parameters you want to provide.
	
	@within Network
	@client
]=]
function interface:Request(name: string, ...: any): (...any)
	if not connections[name] then
		connections[name] = Signal.new()
	end
	
	local metadata = GenerateMetadata(name, "Request")
	
	remote:FireServer(metadata, ...)
	
	local results
	
	repeat
		results = {connections[name]:Wait()}
	until
		(results[1].type == "RequestResult") and
		(results[1].timestamp == metadata.timestamp) and
		(results[1].id == metadata.id)
	
	table.remove(results, 1)
	
	return table.unpack(results)
end

--[=[
	Connects a callback to a given data stream.
	
	@param name -- The name of the stream.
	@param callback -- The callback that you want to connect to this stream.
	
	@within Network
	@client
]=]
function interface:OnRequest(name: string, callback: (...any) -> (...any)): Signal.Connection<...any>
	local request = requests[name]
	
	if request then
		warn("Request callback was already set for \"" .. name .. "\"; and has been replaced.")
		
		request:Disconnect()
		requests[name] = nil
	end
	
	if not connections[name] then
		connections[name] = Signal.new()
	end
	
	requests[name] = connections[name]:Connect(function(metadata: Metadata, ...: any)
		if metadata.type == "Request" then
			metadata.type = "RequestResult"
			
			remote:FireServer(metadata, callback(...))
		end
	end)
	
	return requests[name]
end


if RunService:IsClient() then
	remote.OnClientEvent:Connect(function(metadata: Metadata, ...: any)
		local connection = connections[metadata.name]
		
		if connection then
			connection:Fire(metadata, ...)
		else
			local connection = connections[metadata.name]
			
			warn("\"" .. metadata.name .. "\" does not have any listeners on the client; now yielding!")
			
			repeat
				connection = connections[metadata.name]
				
				if not connection then
					task.wait()
				end
			until connection
			
			warn("Found listener for \"" .. metadata.name .. "\"!")
			
			connection:Fire(metadata, ...)
		end
	end)
end


return interface