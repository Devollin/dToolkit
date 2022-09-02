--!strict
--[[======================================================================

PlayerDataStore | Written by Devi (@Devollin) | 2022 | v1.0.0
	Description: A library to aid in DataStore-related functions.
	
========================================================================]]


local Types = require(script.Parent:WaitForChild("Types"))


type PlayerStorageResult = Types.PlayerStorageResult
type PlayerStorage = Types.PlayerStorage
type BaseStorage = Types.BaseStorage
type SaveResult = Types.SaveResult
type DataResult = Types.DataResult
type Default = Types.Default
type Data = Types.BaseData


local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")

local Signal = require(script.Parent.Parent:WaitForChild("Signal"))
local Timer = require(script.Parent.Parent:WaitForChild("Timer"))
local Util = require(script.Parent.Parent:WaitForChild("Util"))

local DataStore = require(script.Parent:WaitForChild("DataStore"))

local dataStores = {}

local interface = {}


--[[**
Creates a new PlayerStorage object.

@param [t:string] name The name of the DataStore.
@param [t:string?] scope The scope of the DataStore.
@param [t:DataStoreOptions?] options Options to modify DataStores.
@param [t:table] default Default data to be used for blank entries.

@returns [t:PlayerStorageResult] A dictionary containing a success boolean, a message (if getting the DataStore fails), and a
	result (if getting the DataStore succeeds, this is the PlayerStorage object).
**--]]
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
	
	
	--[[**
	Performs GetAsync if the data requested by the index does not exist, and returns the data. Additionally, it creates an
		autosave timer for the player's data.
	
	@param [t:number] index The key within the DataStore.
	
	@returns [t:DataResult] A dictionary containing a success boolean, a message (if getting the data fails), and a result
		(if getting the data succeeds, this is the data).
	**--]]
	function object:HardLoad(index: number): DataResult
		local timer = Timer.new()
		timer:SetDuration(120)
		
		timer.Finished:Connect(function()
			object:HardSave(index)
			
			timer:Start()
		end)
		
		timer:Start()
		
		autosaveTimers[index] = timer
		
		return dataStore:HardLoad(tostring(index))
	end
	
	--[[**
	Returns data associated with the index, if it has been loaded already.
	
	@param [t:number] index The key within the DataStore.
	
	@returns [t:DataResult] A dictionary containing a success boolean, a message (if getting the data fails), and a result
		(if getting the data succeeds, this is the data).
	**--]]
	function object:SoftLoad(index: number): DataResult
		return dataStore:SoftLoad(tostring(index))
	end
	
	--[[**
	Performs SetAsync with the data associated with the index, if it isn't already being saved.
	
	@param [t:number] index The key within the DataStore.
	@param [t:DataStoreSetOptions?] setOptions Options used to adjust SetAsync.
	
	@returns [t:SaveResult] A dictionary containing a success boolean, and a message (if saving the data fails).
	**--]]
	function object:HardSave(index: number, setOptions: DataStoreSetOptions?): SaveResult
		return dataStore:HardSave(tostring(index), {index}, setOptions)
	end
	
	--[[**
	Replaces all the data associated with the id.
	
	@param [t:number] index The key within the DataStore.
	
	@returns [t:SaveResult] A dictionary containing a success boolean, and a message (if saving the data fails).
	**--]]
	function object:SoftSave(index: number, newData: any): SaveResult
		return dataStore:SoftSave(tostring(index), newData)
	end
	
	--[[**
	Saves the data associated with the id, if it isn't already being saved.
	
	@param [t:number] index The key within the DataStore.
	@param [t:string|number)] key The key within the data.
	@param [t:any] newData The data to replace the contents of the key.
	
	@returns [t:SaveResult] A dictionary containing a success boolean, and a message (if saving the data fails).
	**--]]
	function object:Update(index: number, key: (string | number), newData: any): SaveResult
		return dataStore:Update(tostring(index), key, newData)
	end
	
	--[[**
	Saves the data associated with the indexes, if it isn't already being saved.
	
	@param [t:string] index The key within the DataStore.
	@param [t:any] newData The data to replace the contents of the key.
	@param [t:string|number] key The key within the data.
	@param [t:string|number] ... The key indexer(s) within the data.
	
	@returns [t:SaveResult] A dictionary containing a success boolean, and a message (if saving the data fails).
	**--]]
	function object:DeepUpdate(index: string, newData: any, key: (string | number), ...: (string | number)): SaveResult
		return dataStore:DeepUpdate(index, newData, key, ...)
	end
	
	--[[**
	Hard saves the player's data, then removes the data associated with the id. Additionally, it stops and destroys the
		autosave timer.
	
	@param [t:number] index The key within the DataStore.
	**--]]
	function object:Clear(index: number)
		dataStore:Clear(tostring(index))
		
		autosaveTimers[index]:Stop()
		autosaveTimers[index]:Destroy()
		autosaveTimers[index] = nil
	end
	
	--[[**
	Saves all data, and clears it's own members.
	**--]]
	function object:Close()
		dataStore:Close()
	end
	
	
	for _, player: Player in pairs(Players:GetPlayers()) do
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


Players.PlayerAdded:Connect(function(player: Player)
	local id = player.UserId
	
	for name, dataStore in pairs(dataStores) do
		task.spawn(dataStore.HardLoad, dataStore, id)
	end
end)

Players.PlayerRemoving:Connect(function(player: Player)
	local id = player.UserId
	
	task.wait(0.5)
	
	if Util:GetDictionaryLength(Players:GetPlayers()) > 0 then
		for name, dataStore in pairs(dataStores) do
			task.spawn(dataStore.HardSave, dataStore, id)
		end
	end
end)


return interface