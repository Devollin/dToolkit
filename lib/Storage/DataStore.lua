--!strict
--[[================================================================================================

DataStore | Written by Devi (@Devollin) | 2022 | v1.0.0
	Description: A library to aid in general DataStore-related functions.
	
==================================================================================================]]

local DataStoreService = game:GetService("DataStoreService")

local Signal = require(script.Parent.Parent:WaitForChild("Signal"))
local Util = require(script.Parent.Parent:WaitForChild("Util"))

local Types = require(script.Parent:WaitForChild("Types"))


type BaseStorageResult = Types.BaseStorageResult
type DataStoreResult = Types.DataStoreResult
type SaveResult = Types.SaveResult
type DataResult = Types.DataResult
type Default = Types.Default
type Data = Types.BaseData


local dataStores = {}

local callbacks = {
	GetDataStore = {
		Retry = function(message: string, name: string, scope: string?)
			if scope then
				warn("Failed to get DataStore of name \"" .. name ..
					"\" and scope \"" .. scope ..
					"\", retrying in 5 seconds...")
			else
				warn("Failed to get DataStore of name \"" .. name ..
					"\", retrying in 5 seconds...")
			end
		end,
		Failed = function(message: string, name: string, scope: string?)
			if scope then
				warn("Failed to get DataStore of name \"" .. name ..
					"\" and scope \"" .. scope ..
					"\"; exhausted retries.")
			else
				warn("Failed to get DataStore of name \"" .. name ..
					"\"; exhausted retries.")
			end
		end,
	}, SetAsync = {
		Retry = function(message: string, name: string, scope: string?, key: string)
			if scope then
				warn("Failed to set data for key \"" .. key ..
					"\" DataStore of name \"" .. name ..
					"\", and scope \"" .. scope ..
					"\", retrying in 5 seconds...")
			else
				warn("Failed to set data for key \"" .. key ..
					"\" DataStore of name \"" .. name ..
					"\", retrying in 5 seconds...")
			end
		end,
		Failed = function(message: string, name: string, scope: string?, key: string)
			if scope then
				warn("Failed to set data for key \"" .. key ..
					"\" DataStore of name \"" .. name ..
					"\", and scope \"" .. scope ..
					"\"; exhausted retries.")
			else
				warn("Failed to set data for key \"" .. key ..
					"\" DataStore of name \"" .. name ..
					"\"; exhausted retries.")
			end
		end,
	}, GetAsync = {
		Retry = function(message: string, name: string, scope: string?, key: string)
			if scope then
				warn("Failed to set data for key \"" .. key ..
					"\" DataStore of name \"" .. name ..
					"\", and scope \"" .. scope ..
					"\", retrying in 5 seconds...")
			else
				warn("Failed to set data for key \"" .. key ..
					"\" DataStore of name \"" .. name ..
					"\", retrying in 5 seconds...")
			end
		end,
		Failed = function(message: string, name: string, scope: string?, key: string)
			if scope then
				warn("Failed to set data for key \"" .. key ..
					"\" DataStore of name \"" .. name ..
					"\", and scope \"" .. scope ..
					"\"; exhausted retries.")
			else
				warn("Failed to set data for key \"" .. key ..
					"\" DataStore of name \"" .. name ..
					"\"; exhausted retries.")
			end
		end,
	},
}

local interface = {}


--[=[
	@class BaseStorage
	A basic [GlobalDataStore] wrapper object.
	@server
]=]
--[=[
	@prop LoadRetry Signal<string, string, string?, string>
	Fired when Storage is going to retry loading the requested data, if it previously failed.
	The first param is the error message, the second param is the name of the Storage, the third param is the scope, and the
	last param is the key.
	
	@within BaseStorage
	@tag Event
]=]
--[=[
	@prop LoadFail Signal<string, string, string?, string>
	Fired when Storage failed to load the requested data after retrying several times.
	The first param is the error message, the second param is the name of the Storage, the third param is the scope, and the
	last param is the key.
	
	@within BaseStorage
	@tag Event
]=]
--[=[
	@prop SaveStart Signal<string>
	Fired when Storage is going to try to save to [GlobalDataStore].
	The only param passed is the index.
	
	@within BaseStorage
	@tag Event
]=]
--[=[
	@prop SaveRetry Signal<string, string, string?, string>
	Fired when Storage is going to retry saving the requested data, if it previously failed.
	The first param is the error message, the second param is the name of the Storage, the third param is the scope, and the
	last param is the key.
	
	@within BaseStorage
	@tag Event
]=]
--[=[
	@prop SaveFail Signal<string, string, string?, string>
	Fired when Storage failed to load the requested data after retrying several times.
	The first param is the error message, the second param is the name of the Storage, the third param is the scope, and the
	last param is the key.
	
	@within BaseStorage
	@tag Event
]=]
--[=[
	@prop SaveSuccess Signal<string>
	Fired when Storage successfully saved to the [GlobalDataStore].
	The only param passed is the index.
	
	@within BaseStorage
	@tag Event
]=]
--[=[
	@prop FilledBlankStorage Signal<string, string?, string>
	Fired when Storage fills in an empty key.
	The first param is the name of the Storage, the second param is the scope, and the last param is the index.
	
	@within BaseStorage
	@tag Event
]=]
--[=[
	@prop KeyUpdated Signal<string, string | number, any, any>
	Fired when a key in Storage is updated.
	The first param is the name of the Storage, the second param is the name of the key, the third param is the new data, and
	the last param is the old data.
	
	@within BaseStorage
	@tag Event
]=]
--[=[
	@prop DeepKeyUpdated Signal<string, any, any, {string | number}>
	Fired when a key deep in Storage is updated.
	The first param is the name of the index, the second param is the new data, the third param is the new old data, and the
	last param is an array of all the additional keys given.
	
	@within BaseStorage
	@tag Event
]=]

--[=[
	Returns a [DataStoreResult] object, given a name and optional scope and [DataStoreOptions] parameters.
	
	@param name -- The name of the [GlobalDataStore].
	@param scope -- The scope of the [GlobalDataStore].
	@param options -- The [DataStoreOptions] used when getting the [GlobalDataStore].
	
	@within BaseStorage
	@yields
]=]
function interface:GetDataStore(name: string, scope: string?, options: DataStoreOptions?): DataStoreResult
	local success, result
	local iterations = 0
	
	repeat
		success, result = pcall(function()
			return DataStoreService:GetDataStore(name, scope, options)
		end)
		
		if not success then
			task.spawn(callbacks.GetDataStore.Retry, result, name, scope)
			
			task.wait(5)
			
			iterations += 1
		end
	until success or (iterations >= 5)
	
	if success then
		return {
			success = true,
			result = result,
		}
	else
		task.spawn(callbacks.GetDataStore.Failed, result, name, scope)
		
		return {
			success = false,
			message = result,
		}
	end
end

--[=[
	Creates a new [BaseStorageResult] object.
	
	@param name -- The name of the [GlobalDataStore].
	@param scope -- The scope of the [GlobalDataStore].
	@param options -- Options to modify [GlobalDataStore]s.
	@param default -- Default data to be used for blank entries.
	
	@within BaseStorage
	@yields
]=]
function interface.new(name: string, scope: string?, options: DataStoreOptions?, default: Default): BaseStorageResult
	local dataStore = interface:GetDataStore(name, scope, options)
	
	if not dataStore.success then
		return {
			success = false,
			message = dataStore.message,
		}
	end
	
	local dataStore = dataStore.result :: GlobalDataStore
	
	local members: {[string]: Data} = {}
	local object = {
		LoadRetry = Signal.new() :: Signal.Signal<string, string, string?, string>,
		LoadFail = Signal.new() :: Signal.Signal<string, string, string?, string>,
		SaveStart = Signal.new() :: Signal.Signal<string>,
		SaveRetry = Signal.new() :: Signal.Signal<string, string, string?, string>,
		SaveFail = Signal.new() :: Signal.Signal<string, string, string?, string>,
		SaveSuccess = Signal.new() :: Signal.Signal<string>,
		FilledBlankStorage = Signal.new() :: Signal.Signal<string, string?, string>,
		KeyUpdated = Signal.new() :: Signal.Signal<string, string | number, any, any>,
		DeepKeyUpdated = Signal.new() :: Signal.Signal<string, any, any, {string | number}>,
	}
	
	
	--[=[
		Performs GetAsync if the data requested by the index does not exist, and returns the data.
		
		@param index -- The key within the [GlobalDataStore].
		
		@within BaseStorage
		@yields
	]=]
	function object:HardLoad(index: string): DataResult
		local data = members[index]
		
		if data then
			if (data.loadStatus == "Ready") then
				return {
					success = true,
					result = data.data,
				}
			elseif data.loadStatus == "Loading" then
				repeat
					task.wait()
				until (data.loadStatus ~= "Loading") or (members[index] == nil)
				
				if data.loadStatus == "Ready" then
					return {
						success = true,
						result = data.data
					}
				else
					return {
						success = false,
					}
				end
			end
			
			return {
				success = false,
			}
		else
			members[index] = {
				loadStatus = "Loading",
				saveStatus = "NotReady",
				canSave = false,
			}
			
			local success, result, metadata
			local iterations = 0
			
			repeat
				success, result, metadata = pcall(function()
					return dataStore:GetAsync(index)
				end)
				
				if not success then
					object.LoadRetry:Fire(result, name, scope, index)
					
					task.spawn(callbacks.GetAsync.Retry, result, name, scope, index)
					
					task.wait(5)
					
					iterations += 1
				end
			until success or (iterations >= 5)
			
			members[index].canSave = success
			
			if success then
				if result == nil then
					object.FilledBlankStorage:Fire(name, scope, index)
				end
				
				members[index].data = if result == nil then Util:DeepCloneTable(default) else result
				members[index].loadStatus = "Ready"
				members[index].saveStatus = "Ready"
				
				return {
					success = true,
					result = result,
					metadata = metadata,
				}
			else
				members[index].loadStatus = "Failed"
				
				object.LoadFail:Fire(result, name, scope, index)
				
				task.spawn(callbacks.GetAsync.Failed, result, name, scope, index)
				
				return {
					success = false,
					message = result,
				}
			end
		end
	end
	
	--[=[
		Returns data associated with the index, if it has been loaded already.
		
		@param index -- The key within the [GlobalDataStore].
		
		@within BaseStorage
	]=]
	function object:SoftLoad(index: string): DataResult
		local data = members[index]
		
		if data then
			if data.loadStatus == "Loading" then
				repeat
					task.wait()
				until (data.loadStatus ~= "Loading") or (members[index] == nil)
				
				if data.loadStatus == "Ready" then
					return {
						success = true,
						result = data.data,
					}
				else
					return {
						success = false,
					}
				end
			elseif data.loadStatus == "Ready" then
				return {
					success = true,
					result = data.data,
				}
			else
				return {
					success = false,
				}
			end
		else
			return {
				success = false,
			}
		end
	end
	
	--[=[
		Performs SetAsync with the data associated with the index, if it isn't already being saved.
		
		@param index -- The key within the [GlobalDataStore].
		@param ids -- An optional list of user IDs associated with the data.
		@param setOptions -- Options used to adjust SetAsync.
		
		@within BaseStorage
		@yields
	]=]
	function object:HardSave(index: string, ids: {number}?, setOptions: DataStoreSetOptions?): SaveResult
		local data = members[index]
		
		if data and data.canSave then
			if data.saveStatus == "Saving" then
				return {
					success = true,
				}
			elseif (data.saveStatus == "Ready") or (data.saveStatus == "Failed") then
				local success, result
				local iterations = 0
				
				data.saveStatus = "Saving"
				
				object.SaveStart:Fire(index)
				
				repeat
					success, result = pcall(function()
						return dataStore:SetAsync(index, data.data, ids, setOptions)
					end)
					
					if not success then
						object.SaveRetry:Fire(result, name, scope, index)
						
						task.spawn(callbacks.SetAsync.Retry, result, name, scope)
						
						task.wait(5)
						
						iterations += 1
					end
				until success or (iterations >= 5)
				
				if success then
					data.saveStatus = "Ready"
					
					object.SaveSuccess:Fire(index)
					
					return {
						success = true,
					}
				else
					data.saveStatus = "Failed"
					
					object.SaveFail:Fire(result, name, scope, index)
					
					task.spawn(callbacks.SetAsync.Failed, result, name, scope, options)
					
					return {
						success = false,
						message = result,
					}
				end
			else
				return {
					success = false,
				}
			end
		else
			return {
				success = true,
			}
		end
	end
	
	--[=[
		Replaces all the data associated with the index.
		
		@param index -- The key within the [GlobalDataStore].
		
		@within BaseStorage
	]=]
	function object:SoftSave(index: string, newData: any): SaveResult
		local data = members[index]
		
		if data then
			if data.saveStatus == "Ready" then
				data.data = newData
				
				return {
					success = true,
				}
			elseif (data.saveStatus == "Saving") or (data.saveStatus == "NotReady") then
				repeat
					task.wait()
				until (data.saveStatus ~= "Saving") or (members[index] == nil)
				
				if data.saveStatus == "Ready" then
					data.data = newData
					
					return {
						success = true,
					}
				else
					return {
						success = false,
					}
				end
			else
				return {
					success = false,
				}
			end
		else
			return {
				success = false,
			}
		end
	end
	
	--[=[
		Saves the data associated with the index, if it isn't already being saved.
		
		@param index -- The key within the [GlobalDataStore].
		@param key -- The key within the data.
		@param newData -- The data to replace the contents of the key.
		
		@within BaseStorage
	]=]
	function object:Update(index: string, key: (string | number), newData: any): SaveResult
		local data = members[index]
		
		if data and data.canSave then
			if data.saveStatus == "Ready" then
				object.KeyUpdated:Fire(index, key, newData, data.data[key])
				
				data.data[key] = newData
				
				return {
					success = true,
				}
			elseif (data.saveStatus == "Saving") or (data.saveStatus == "NotReady") then
				repeat
					task.wait()
				until (data.saveStatus ~= "Saving") or (members[index] == nil)
				
				if data.saveStatus == "Ready" then
					object.KeyUpdated:Fire(index, key, newData, data.data[key])
					
					data.data[key] = newData
					
					return {
						success = true,
					}
				else
					return {
						success = false,
					}
				end
			else
				return {
					success = false,
				}
			end
		else
			return {
				success = false,
			}
		end
	end
	
	--[=[
		Saves the data associated with the indexes, if it isn't already being saved.
		
		@param index -- The key within the [GlobalDataStore].
		@param newData -- The data to replace the contents of the key.
		@param key -- The key within the data.
		@param ... -- The key indexer(s) within the data.
		
		@within BaseStorage
	]=]
	function object:DeepUpdate(index: string, newData: any, key: (string | number), ...: (string | number)): SaveResult
		local data = members[index]
		
		if data and data.canSave then
			if data.saveStatus == "Ready" then
				local indexedData = data.data[key]
				local array = {...}
				local oldData
				
				for otherKey, newKey in ipairs(array) do
					if indexedData ~= nil then
						if otherKey == #array then
							oldData = indexedData[newKey]
							
							indexedData[newKey] = newData
						else
							indexedData = indexedData[newKey]
						end
					end
				end
				
				object.DeepKeyUpdated:Fire(index, newData, oldData, {...})
				
				return {
					success = true,
				}
			elseif (data.saveStatus == "Saving") or (data.saveStatus == "NotReady") then
				repeat
					task.wait()
				until (data.saveStatus ~= "Saving") or (members[index] == nil)
				
				if data.saveStatus == "Ready" then
					local indexedData = data.data[key]
					local array = {...}
					local oldData
					
					for otherKey, newKey in ipairs(array) do
						if indexedData ~= nil then
							if otherKey == #array then
								oldData = indexedData[newKey]
								
								indexedData[newKey] = newData
							else
								indexedData = indexedData[newKey]
							end
						end
					end
					
					object.DeepKeyUpdated:Fire(index, newData, oldData, {...})
					
					return {
						success = true,
					}
				else
					return {
						success = false,
					}
				end
			else
				return {
					success = false,
				}
			end
		else
			return {
				success = false,
			}
		end
	end
	
	--[=[
		Hard saves the data, then removes the data associated with the index.
		
		@param index -- The key within the [GlobalDataStore].
		
		@within BaseStorage
		@yields
	]=]
	function object:Clear(index: string)
		local data = members[index]
		
		if data then
			object:HardSave(index)
			
			members[index] = nil
		end
	end
	
	--[=[
		Saves all data, and clears it's own members.
		@within BaseStorage
		@yields
	]=]
	function object:Close()
		for key, data in pairs(members) do
			task.spawn(function()
				object:Clear(key)
			end)
		end
	end
	
	
	dataStores[name] = object
	
	
	return {
		success = true,
		result = object,
	}
end


game:BindToClose(function()
	for name, dataStore in pairs(dataStores) do
		dataStore:Close()
	end
end)


return interface