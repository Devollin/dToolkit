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

local remote = Instance.new("RemoteEvent")

if RunService:IsServer() then
	remote.Parent = script.Parent
else
	remote:Destroy()
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
	@server
]=]
function interface:Connect(name: string, callback: (player: Player, ...any) -> ()): Signal.Connection<...any>
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
	@server
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
	@server
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
	Fires a [RemoteEvent] to the given player within the given data stream.
	
	@param name -- The name of the stream.
	@param player -- The player you want to fire an event to.
	@param ... -- Any additional parameters you want to provide.
	
	@within Network
	@server
]=]
function interface:Fire(name: string, player: Player, ...: any)
	remote:FireClient(player, GenerateMetadata(name, "Normal"), ...)
end

--[=[
	Fires a [RemoteEvent] to all the given players within the given data stream.
	
	@param name -- The name of the stream.
	@param players -- An array of the players you want to fire an event to.
	@param ... -- Any additional parameters you want to provide.
	
	@within Network
	@server
]=]
function interface:FirePlayers(name: string, players: {Player}, ...: any)
	for _, player in players do
		remote:FireClient(player, GenerateMetadata(name, "Normal"), ...)
	end
end

--[=[
	Fires a [RemoteEvent] to all players within the given data stream.
	
	@param name -- The name of the stream.
	@param ... -- Any additional parameters you want to provide.
	
	@within Network
	@server
]=]
function interface:FireAllPlayers(name: string, ...: any)
	remote:FireAllClients(GenerateMetadata(name, "Normal"), ...)
end

--[=[
	Fires a [RemoteEvent] to a player within the given data stream, and yields until the player responds.
	
	@param name -- The name of the stream.
	@param player -- The player you want to request from.
	@param ... -- Any additional parameters you want to provide.
	
	@within Network
	@server
]=]
function interface:Request(name: string, player: Player, ...: any): (...any)
	if not connections[name] then
		connections[name] = Signal.new()
	end
	
	local metadata = GenerateMetadata(name, "Request")
	
	if player then
		remote:FireClient(player, metadata, ...)
		
		local results
		
		repeat
			results = {connections[name]:Wait()}
		until
			((results[1].type == "RequestResult") and
			(results[1].timestamp == metadata.timestamp) and
			(results[1].id == metadata.id) and
			(player == (results[2] :: any) :: Player)) or (not player)
		
		if player then
			table.remove(results, 1)
			table.remove(results, 1)
			
			return table.unpack(results)
		end
	end
end

--[=[
	Connects a callback to a given data stream.
	
	@param name -- The name of the stream.
	@param callback -- The callback that you want to connect to this stream.
	
	@within Network
	@server
]=]
function interface:OnRequest(name: string, callback: (player: Player, ...any) -> (...any)): Signal.Connection<...any>
	local request = requests[name]
	
	if request then
		warn("Request callback was already set for \"" .. name .. "\"; and has been replaced.")
		
		request:Disconnect()
		requests[name] = nil
	end
	
	if not connections[name] then
		connections[name] = Signal.new()
	end
	
	requests[name] = connections[name]:Connect(function(metadata: Metadata, player: Player, ...: any)
		if metadata.type == "Request" then
			metadata.type = "RequestResult"
			
			if player then
				remote:FireClient(player, metadata, callback(player, ...))
			end
		end
	end)
	
	return requests[name]
end


if RunService:IsServer() then
	remote.OnServerEvent:Connect(function(player: Player, metadata: Metadata, ...: any)
		local connection = connections[metadata.name]
		
		if connection then
			connection:Fire(metadata, player, ...)
		else
			local connection = connections[metadata.name]
			
			warn("\"" .. metadata.name .. "\" does not have any listeners on the server; now yielding!")
			
			repeat
				connection = connections[metadata.name]
				
				if not connection then
					task.wait()
				end
			until connection
			
			warn("Found listener for \"" .. metadata.name .. "\"!")
			
			connection:Fire(metadata, player, ...)
		end
	end)
end


return interface