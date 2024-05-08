--!strict
--[[================================================================================================

Network | Written by Devi (@Devollin) | 2024 | v2.1.0
	Description: A library to handle networking more reliably.
	
==================================================================================================]]


local RunService: RunService = game:GetService("RunService")


type BaseMetadata<a> = {
	name: string,
	type: a,
}

type NormalMetadata = BaseMetadata<"Normal">
type RequestMetadata = BaseMetadata<"Request" | "RequestResult"> & {timestamp: number, id: number}
type Metadata = NormalMetadata | RequestMetadata

export type ClientEvent<a...> = {
	Wait: (self: ClientEvent<a...>) -> (a...),
	Fire: (self: ClientEvent<a...>, a...) -> (),
	Connect: (self: ClientEvent<a...>, (a...) -> ()) -> (() -> ()),
}

export type ServerEvent<a...> = {
	Wait: (self: ServerEvent<a...>) -> (Player, a...),
	Fire: (self: ServerEvent<a...>, player: Player, a...) -> (),
	FireAll: (self: ServerEvent<a...>, a...) -> (),
	FireSome: (self: ServerEvent<a...>, players: {Player}, a...) -> (),
	Connect: (self: ServerEvent<a...>, (player: Player, a...) -> ()) -> (() -> ()),
}

export type Event<a...> = {
	ClassName: "NetworkEvent",
	
	Client: ClientEvent<a...>,
	Server: ServerEvent<a...>,
}

export type ClientRequest<a..., b...> = {
	Invoke: (self: ClientRequest<a..., b...>, a...) -> (b...),
	OnInvoke: (self: ClientRequest<a..., b...>, newCallback: (a...) -> (b...)) -> (),
}

export type ServerRequest<a..., b...> = {
	Invoke: (self: ServerRequest<a..., b...>, player: Player, a...) -> (b...),
	OnInvoke: (self: ServerRequest<a..., b...>, newCallback: (player: Player, a...) -> (b...)) -> (),
}

export type Request<a..., b...> = {
	ClassName: "NetworkRequest",
	
	Client: ClientRequest<a..., b...>,
	Server: ServerRequest<a..., b...>,
}

-- manifest is used to keep track of connections to the network and ensure that there are connections for every network call.
local manifest: {[string]: number} = {}
local requestManifest: {[string]: boolean} = {}

local random = Random.new()
local remote: RemoteEvent
local unreliableRemote: UnreliableRemoteEvent

local interface = {}


-- This function is used to generate metadata for network requests. While a metadata of type "RequestResult" can be made, it
--  is not intended to be created through the use of this function.
local function GenerateMetadata(name: string, type: "Normal" | "Request" | "RequestResult"): Metadata
	if type == "Normal" then
		return {
			name = name,
			type = type,
		}
	else
		return {
			name = name,
			type = type,
			timestamp = tick(),
			id = random:NextNumber(1, 9999),
		}
	end
end


function interface:GetManifest()
	return table.clone(manifest)
end

--[=[
	@class NetworkEvent
	A [RemoteEvent] wrapper object.
	
	@server
]=]
--[=[
	Creates a new [NetworkEvent] object.
	
	:::caution
	Using the same name for multiple network connections will not break anything, but if each connection differs in their
	types, things could go wrong! Be careful!
	
	@within NetworkEvent
	@server
]=]
function interface.event<a...>(name: string, isUnreliable: true?): Event<a...>
	local metadata = GenerateMetadata(name, "Normal")
	
	-- RemoteEvents and UnreliableRemoteEvents share the same methods, so this is fine.
	local hostedRemote =
		if isUnreliable then (unreliableRemote :: any) :: RemoteEvent
		else remote
	
	local queuedPackets: {{any}} = {}
	local object = {
		ClassName = "NetworkEvent" :: "NetworkEvent",
		
		Client = {},
		Server = {},
	}
	
	
	--[=[
		Waits until the event is triggered, and returns the data passed through it, and the client that fired it.
		
		@within NetworkEvent
		@server
	]=]
	function object.Server.Wait(self: ServerEvent<a...>): (Player, a...)
		local results
		
		repeat
			results = {hostedRemote.OnServerEvent:Wait()}
			
			local newMetadata = (results[2] :: any) :: Metadata
		until newMetadata.type == "Normal"
		
		local player = table.remove(results, 1) -- Removes the player
		table.remove(results, 2) -- Removes the metadata
		
		return player :: Player, table.unpack(results :: any)
	end
	
	--[=[
		Fires a [RemoteEvent] to the given client.
		
		@param player -- The player you want to fire an event to.
		@param ... -- Any parameters you want to provide.
		
		@within NetworkEvent
		@server
	]=]
	function object.Server.Fire(self: ServerEvent<a...>, player: Player, ...: a...)
		hostedRemote:FireClient(player, metadata, ...)
	end
	
	--[=[
		Fires a [RemoteEvent] to all players.
		
		@param ... -- Any parameters you want to provide.
		
		@within NetworkEvent
		@server
	]=]
	function object.Server.FireAll(self: ServerEvent<a...>, ...: a...)
		hostedRemote:FireAllClients(metadata, ...)
	end
	
	--[=[
		Fires a [RemoteEvent] to all the given players.
		
		@param players -- An array of the players you want to fire an event to.
		@param ... -- Any parameters you want to provide.
		
		@within NetworkEvent
		@server
	]=]
	function object.Server.FireSome(self: ServerEvent<a...>, players: {Player}, ...: a...)
		for _, player in players do
			hostedRemote:FireClient(player, metadata, ...)
		end
	end
	
	--[=[
		Connects a callback to an [RemoteEvent].
		
		@param callback -- The callback that you want to connect to this event.
		
		@within NetworkEvent
		@server
	]=]
	function object.Server.Connect(self: ServerEvent<a...>, callback: (player: Player, a...) -> ()): (() -> ())
		local connection = hostedRemote.OnServerEvent:Connect(function(player, metadata: Metadata, ...)
			if metadata.name == name then
				callback(player, ...)
			end
		end)
		
		if #queuedPackets ~= 0 then
			local oldPackets = table.clone(queuedPackets)
			table.clear(queuedPackets)
			
			for index, value in oldPackets do
				task.defer(callback :: any, unpack(value))
			end
			
			warn(`Listener found for "{name}" on the server!`)
		end
		
		manifest[name] += 1
		
		return function()
			manifest[name] -= 1
			
			connection:Disconnect()
			connection = nil :: any
		end
	end
	
	--[=[
		Waits until the event is triggered, and returns the data passed through it.
		
		@within NetworkEvent
		@client
	]=]
	function object.Client.Wait(self: ClientEvent<a...>): (a...)
		local results
		
		repeat
			results = {hostedRemote.OnClientEvent:Wait()}
			
			local newMetadata = (results[1] :: any) :: Metadata
		until newMetadata.type == "Normal"
		
		table.remove(results, 1) -- Removes the metadata
		
		return table.unpack(results :: any)
	end
	
	--[=[
		Fires a [RemoteEvent] to the server.
		
		@param ... -- Any parameters you want to provide.
		
		@within NetworkEvent
		@client
	]=]
	function object.Client.Fire(self: ClientEvent<a...>, ...: a...)
		hostedRemote:FireServer(metadata, ...)
	end
	
	--[=[
		Connects a callback to an [RemoteEvent].
		
		@param callback -- The callback that you want to connect to this event.
		
		@within NetworkEvent
		@client
	]=]
	function object.Client.Connect(self: ClientEvent<a...>, callback: (a...) -> ()): (() -> ())
		local connection = hostedRemote.OnClientEvent:Connect(function(metadata: Metadata, ...)
			if metadata.name == name then
				callback(...)
			end
		end)
		
		if #queuedPackets ~= 0 then
			local oldPackets = table.clone(queuedPackets)
			queuedPackets = {}
			
			for index, value in oldPackets do
				task.defer(callback, unpack(value))
			end
			
			warn(`Listener found for "{name}" on the client!`)
		end
		
		manifest[name] += 1
		
		return function()
			manifest[name] -= 1
			
			connection:Disconnect()
			connection = nil :: any
		end
	end
	
	
	if manifest[name] then
		warn(`There is already a network connection under the name "{name}"! Unexpected behavior is to be expected.`)
	else
		manifest[name] = 0
		
		if RunService:IsClient() then
			hostedRemote.OnClientEvent:Connect(function(metadata: Metadata, ...: any)
				if name == metadata.name and metadata.type == "Normal" then
					if manifest[name] == 0 then
						table.insert(queuedPackets, {...})
						
						warn(`There are no listeners for "{name}" on the client! Waiting for a listener...`)
					end
				end
			end)
		else
			hostedRemote.OnServerEvent:Connect(function(player: Player, metadata: Metadata, ...: any)
				if name == metadata.name and metadata.type == "Normal" then
					if manifest[name] == 0 then
						table.insert(queuedPackets, {player, ...})
						
						warn(`There are no listeners for "{name}" on the server! Waiting for a listener...`)
					end
				end
			end)
		end
	end
	
	
	return object
end


--[=[
	@class NetworkRequest
	A [RemoteEvent] wrapper object intended to emulate a [RemoteFunction].
	
	@server
]=]
--[=[
	Creates a new [NetworkRequest] object.
	
	:::caution
	Using the same name for multiple NetworkRequest objects will not break or raise errors on creation, but will create
	multiple responses to any invokation. Data WILL be lost on the requesting end.
	
	@within NetworkRequest
	@server
]=]
function interface.request<a..., b...>(name: string, isUnreliable: true?): Request<a..., b...>
	-- RemoteEvents and UnreliableRemoteEvents share the same methods, so this is fine.
	local hostedRemote =
		if isUnreliable then (unreliableRemote :: any) :: RemoteEvent
		else remote
	
	local object = {
		ClassName = "NetworkRequest" :: "NetworkRequest",
		
		Client = {},
		Server = {},
	}
	
	-- The packets are structured like this: when the OnInvoke method is used, it goes through all the packets and uses the
	--  parameters originally given
	local queuedPackets: {{data: {any}, returnFunction: (...any) -> ()}} = {}
	local callback
	
	
	--[=[
		Fires a [RemoteEvent] to a player, and yields until the player responds.
		
		@param player -- The player you want to request from.
		@param ... -- Any parameters you want to provide.
		
		@within NetworkRequest
		@server
	]=]
	function object.Server.Invoke(self: ServerRequest<a..., b...>, player: Player, ...: a...): (b...)
		local metadata = GenerateMetadata(name, "Request") :: RequestMetadata
		
		hostedRemote:FireClient(player, metadata, ...)
		
		local results
		
		repeat
			results = {hostedRemote.OnServerEvent:Wait()}
			
			local newMetadata = (results[2] :: any) :: Metadata
		until
		((newMetadata.type == "RequestResult") and
			(newMetadata.timestamp == metadata.timestamp) and
			(newMetadata.id == metadata.id) and
			(player == results[1])) or (not (player and player.Parent))
		
		if player and player.Parent then -- We don't want random data being passed through here, so we check if the player exists.
			table.remove(results, 1) -- Removes the player
			table.remove(results, 1) -- Removes the metadata
			
			return table.unpack(results :: any)
		end
	end
	
	--[=[
		Sset a callback to a [RemoteEvent].
		
		@param callback -- The callback that you want to connect.
		
		@within NetworkRequest
		@server
	]=]
	function object.Server.OnInvoke(self: ServerRequest<a..., b...>, newCallback: (player: Player, a...) -> (b...))
		if callback then
			warn(`Request callback was already set for "{name}"; and has been replaced.`)
		end
		
		requestManifest[name] = newCallback ~= nil
		
		if #queuedPackets ~= 0 then
			local oldPackets = table.clone(queuedPackets)
			queuedPackets = {}
			
			for index, value in oldPackets do
				task.defer(function()
					value.returnFunction(newCallback(unpack(value.data)))
				end)
			end
			
			warn(`Listener found for "{name}" on the server!`)
		end
		
		callback = newCallback
	end
	
	--[=[
		Fires a [RemoteEvent] to the server, and yields until the server responds.
		
		@param ... -- Any parameters you want to provide.
		
		@within NetworkRequest
		@client
	]=]
	function object.Client.Invoke(self: ClientRequest<a..., b...>, ...: a...): (b...)
		local metadata = GenerateMetadata(name, "Request") :: RequestMetadata
		
		hostedRemote:FireServer(metadata, ...)
		
		local results
		
		repeat
			results = {hostedRemote.OnClientEvent:Wait()}
			
			local newMetadata = results[1] :: Metadata
		until
		(newMetadata.type == "RequestResult") and
			(newMetadata.timestamp == metadata.timestamp) and
			(newMetadata.id == metadata.id)
		
		table.remove(results, 1) -- Removes the metadata
		
		return table.unpack(results)
	end
	
	--[=[
		Sets a callback to a [RemoteEvent].
		
		@param callback -- The callback that you want to connect.
		
		@within NetworkRequest
		@client
	]=]
	function object.Client.OnInvoke(self: ClientRequest<a..., b...>, newCallback: (a...) -> (b...))
		if callback then
			warn(`Request callback was already set for "{name}"; and has been replaced.`)
		end
		
		requestManifest[name] = newCallback ~= nil
		
		if #queuedPackets ~= 0 then
			local oldPackets = table.clone(queuedPackets)
			queuedPackets = {}
			
			for index, value in oldPackets do
				task.defer(function()
					value.returnFunction(newCallback(unpack(value.data)))
				end)
			end
			
			warn(`Listener found for "{name}" on the client!`)
		end
		
		callback = newCallback :: any
	end
	
	
	if manifest[name] then
		warn(`There is already a network connection under the name "{name}"! Unexpected behavior is to be expected.`)
		
		manifest[name] += 1
	else
		manifest[name] = 1
	end
	
	requestManifest[name] = false
	
	
	if RunService:IsServer() then
		hostedRemote.OnServerEvent:Connect(function(player: Player, metadata: Metadata, ...)
			if metadata.name == name and metadata.type == "Request" then
				if not requestManifest[name] then
					table.insert(queuedPackets, {data = {...}, returnFunction = function(...)
						if player and player.Parent then
							hostedRemote:FireClient(player, metadata, callback(player, ...))
						end
					end})
					
					warn(`There are no listeners for "{name}" on the server! Waiting for a listener...`)
					
					return
				end
				
				metadata.type = "RequestResult"
				
				hostedRemote:FireClient(player, metadata, callback(player, ...))
			end
		end)
	else
		hostedRemote.OnClientEvent:Connect(function(metadata: Metadata, ...)
			if metadata.name == name and metadata.type == "Request" then
				if not requestManifest[name] then
					table.insert(queuedPackets, {data = {...}, returnFunction = function(...)
						hostedRemote:FireServer(metadata, callback(...))
					end})
					
					warn(`There are no listeners for "{name}" on the client! Waiting for a listener...`)
					
					return
				end
				
				metadata.type = "RequestResult"
				
				hostedRemote:FireServer(metadata, callback(...))
			end
		end)
	end
	
	
	return object
end


do -- This code block manages the remote event itself; this should be accessible by both the server and the client.
	if RunService:IsServer() then
		-- Create the remote event.
		remote = Instance.new("RemoteEvent")
		remote.Parent = script
		
		unreliableRemote = Instance.new("UnreliableRemoteEvent")
		unreliableRemote.Parent = script
		
		remote.OnServerEvent:Connect(function(player, metadata: Metadata)
			if manifest[metadata.name] then
				if manifest[metadata.name] == 0 then
					warn(`There are no listeners named "{metadata.name}"!`)
				end
			else
				warn(`There is no network connection named "{metadata.name}"!`)
			end
		end)
	else
		-- Find the remote event. If it isn't found in 5 seconds, we post a warning to the console that the developer may have
		--  forgotten to require Network on the server.
		remote = script:WaitForChild("RemoteEvent", 5) :: RemoteEvent
		unreliableRemote = script:WaitForChild("UnreliableRemoteEvent", 5) :: UnreliableRemoteEvent
		
		if not remote then
			warn("Failed to find remote event(s); did you forget to require Network on the server?")
			
			remote = script:WaitForChild("RemoteEvent") :: RemoteEvent
			unreliableRemote = script:WaitForChild("UnreliableRemoteEvent") :: UnreliableRemoteEvent
			
			warn("Remote(s) found!")
		end
		
		remote.OnClientEvent:Connect(function(metadata: Metadata)
			if manifest[metadata.name] then
				if manifest[metadata.name] == 0 then
					warn(`There are no listeners named "{metadata.name}"!`)
				end
			else
				warn(`There is no network connection named "{metadata.name}"!`)
			end
		end)
	end
end


return interface