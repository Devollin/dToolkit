--!strict
--[[================================================================================================

PlayerDataStore | Written by Devi (@Devollin) | 2022 | v1.0.1
	Description: A library to aid in DataStore-related functions.
	
==================================================================================================]]


local Types = require(script.Parent:WaitForChild("Types"))


type PlayerStorageResult = Types.PlayerStorageResult
type PlayerStorage = Types.PlayerStorage
type BaseStorage = Types.BaseStorage
type SaveResult = Types.SaveResult
type DataResult = Types.DataResult
type Default = Types.Default


local Players: Players = game:GetService("Players")

local Timer = require(script.Parent.Parent:WaitForChild("Timer"))
local Util = require(script.Parent.Parent:WaitForChild("Util"))

local DataStore = require(script.Parent:WaitForChild("DataStore"))

local dataStores = {}

local interface = {}


--[=[
	@class PlayerStorage
	A player-focused [GlobalDataStore] wrapper object.
	@server
]=]
--[=[
	@prop LoadRetry Signal<string, string, string?, string>
	Fired when Storage is going to retry loading the requested data, if it previously failed.
	The first param is the error message, the second param is the name of the Storage, the third param is the scope, and the
	last param is the key.
	
	@within PlayerStorage
	@tag Event
]=]
--[=[
	@prop LoadFail Signal<string, string, string?, string>
	Fired when Storage failed to load the requested data after retrying several times.
	The first param is the error message, the second param is the name of the Storage, the third param is the scope, and the
	last param is the key.
	
	@within PlayerStorage
	@tag Event
]=]
--[=[
	@prop SaveStart Signal<string>
	Fired when Storage is going to try to save to [GlobalDataStore].
	The only param passed is the index.
	
	@within PlayerStorage
	@tag Event
]=]
--[=[
	@prop SaveRetry Signal<string, string, string?, string>
	Fired when Storage is going to retry saving the requested data, if it previously failed.
	The first param is the error message, the second param is the name of the Storage, the third param is the scope, and the
	last param is the key.
	
	@within PlayerStorage
	@tag Event
]=]
--[=[
	@prop SaveFail Signal<string, string, string?, string>
	Fired when Storage failed to load the requested data after retrying several times.
	The first param is the error message, the second param is the name of the Storage, the third param is the scope, and the
	last param is the key.
	
	@within PlayerStorage
	@tag Event
]=]
--[=[
	@prop SaveSuccess Signal<string>
	Fired when Storage successfully saved to the [GlobalDataStore].
	The only param passed is the index.
	
	@within PlayerStorage
	@tag Event
]=]
--[=[
	@prop FilledBlankStorage Signal<string, string?, string>
	Fired when Storage fills in an empty key.
	The first param is the name of the Storage, the second param is the scope, and the last param is the index.
	
	@within PlayerStorage
	@tag Event
]=]
--[=[
	@prop KeyUpdated Signal<string, string | number, any, any>
	Fired when a key in Storage is updated.
	The first param is the name of the Storage, the second param is the name of the key, the third param is the new data, and
	the last param is the old data.
	
	@within PlayerStorage
	@tag Event
]=]
--[=[
	@prop DeepKeyUpdated Signal<string, any, any, {string | number}>
	Fired when a key deep in Storage is updated.
	The first param is the name of the index, the second param is the new data, the third param is the new old data, and the
	last param is an array of all the additional keys given.
	
	@within PlayerStorage
	@tag Event
]=]

--[=[
	Creates a new [PlayerStorageResult] object.
	
	@param name -- The name of the [GlobalDataStore].
	@param scope -- The scope of the [GlobalDataStore].
	@param options -- Options to modify DataStores.
	@param default -- Default data to be used for blank entries.
	
	@within PlayerStorage
	@yields
]=]
function interface.new(name: string, scope: string?, options: DataStoreOptions?, default: Default): PlayerStorageResult
	local dataStore = DataStore.new(name, scope, options, default)
	
	if not dataStore.success then
		return {
			success = false,
			message = dataStore.message,
		}
	end
	
	local dataStore = dataStore.result :: BaseStorage
	
	local autosaveTimers: {[number]: Timer.Timer} = {}
	local object = {
		LoadRetry = dataStore.LoadRetry,
		LoadFail = dataStore.LoadFail,
		SaveStart = dataStore.SaveStart,
		SaveRetry = dataStore.SaveRetry,
		SaveFail = dataStore.SaveFail,
		FilledBlankStorage = dataStore.FilledBlankStorage,
		KeyUpdated = dataStore.KeyUpdated,
		SaveSuccess = dataStore.SaveSuccess,
		DeepKeyUpdated = dataStore.DeepKeyUpdated,
	}
	
	
	--[=[
		Performs GetAsync if the data requested by the index does not exist, and returns the data. Additionally, it creates
			an autosave timer for the player's data.
		
		@param index -- The key within the [GlobalDataStore]
		
		@within PlayerStorage
		@yields
	]=]
	function object.HardLoad(self: PlayerStorage, index: number): DataResult
		local timer = Timer.new()
		timer:SetDuration(120)
		
		timer.Finished:Connect(function()
			self:HardSave(index)
			
			timer:Start()
		end)
		
		timer:Start()
		
		autosaveTimers[index] = timer
		
		return dataStore:HardLoad(tostring(index))
	end
	
	--[=[
		Returns data associated with the index, if it has been loaded already.
		
		@param index -- The key within the [GlobalDataStore].
		
		@within PlayerStorage
	]=]
	function object.SoftLoad(self: PlayerStorage, index: number): DataResult
		return dataStore:SoftLoad(tostring(index))
	end
	
	--[=[
		Performs SetAsync with the data associated with the index, if it isn't already being saved.
		
		@param index -- The key within the [GlobalDataStore].
		@param setOptions -- Options used to adjust SetAsync.
		
		@within PlayerStorage
		@yields
	]=]
	function object.HardSave(self: PlayerStorage, index: number, setOptions: DataStoreSetOptions?): SaveResult
		return dataStore:HardSave(tostring(index), {index}, setOptions)
	end
	
	--[=[
		Replaces all the data associated with the id.
		
		@param index -- The key within the [GlobalDataStore].
		
		@within PlayerStorage
	]=]
	function object.SoftSave(self: PlayerStorage, index: number, newData: any): SaveResult
		return dataStore:SoftSave(tostring(index), newData)
	end
	
	--[=[
		Saves the data associated with the id, if it isn't already being saved.
		
		@param index -- The key within the [GlobalDataStore].
		@param key -- The key within the data.
		@param newData -- The data to replace the contents of the key.
		
		@within PlayerStorage
	]=]
	function object.Update(self: PlayerStorage, index: number, key: (string | number), newData: any): SaveResult
		return dataStore:Update(tostring(index), key, newData)
	end
	
	--[=[
		Saves the data associated with the indexes, if it isn't already being saved.
		
		@param index -- The key within the [GlobalDataStore].
		@param newData -- The data to replace the contents of the key.
		@param key -- The key within the data.
		@param ... -- The key indexer(s) within the data.
		
		@within PlayerStorage
	]=]
	function object.DeepUpdate(self: PlayerStorage, index: string, newData: any, key: (string | number), ...: (string | number)): SaveResult
		return dataStore:DeepUpdate(index, newData, key, ...)
	end
	
	--[=[
		Hard saves the player's data, then removes the data associated with the id. Additionally, it stops and destroys the
			autosave timer.
		
		@param index -- The key within the [GlobalDataStore].
		
		@within PlayerStorage
		@yields
	]=]
	function object.Clear(self: PlayerStorage, index: number)
		dataStore:Clear(tostring(index))
		
		autosaveTimers[index]:Stop()
		autosaveTimers[index]:Destroy()
		autosaveTimers[index] = nil
	end
	
	--[=[
		Saves all data, and clears it's own members.
		@within PlayerStorage
		@yields
	]=]
	function object.Close(self: PlayerStorage)
		dataStore:Close()
	end
	
	
	for _, player in pairs(Players:GetPlayers()) do
		task.spawn(function()
			object:HardLoad(player.UserId)
		end)
	end
	
	
	dataStores[name] = object
	
	
	return {
		success = true,
		result = object,
	}
end


Players.PlayerAdded:Connect(function(player)
	local id = player.UserId
	
	for name, dataStore in pairs(dataStores) do
		task.spawn(dataStore.HardLoad, dataStore, id)
	end
end)

Players.PlayerRemoving:Connect(function(player)
	local id = player.UserId
	
	task.wait(0.5)
	
	if Util:GetDictionaryLength(Players:GetPlayers()) > 0 then
		for name, dataStore in pairs(dataStores) do
			task.spawn(dataStore.HardSave, dataStore, id)
		end
	end
end)


return interface