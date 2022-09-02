--!strict
--[[======================================================================

DataStore | Written by Devi (@Devollin) | 2022 | v1.0.0
	Description: A library to aid in general DataStore-related functions.
	
========================================================================]]

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


--[[**
Returns a DataStore object, given a name and optional scope and DataStoreOptions parameters.

@param [t:string] name The name of the DataStore.
@param [t:string?] scope The scope of the DataStore.
@param [t:DataStoreOptions?] options The DataStoreOptions used when getting the DataStore.

@returns [t:DataStoreResult] A table containing data members for success, message, and result. The message data member is
	only used when success is false, and result is only used when success is true, and contains the DataStore.
**--]]
local function GetDataStore(name: string, scope: string?, options: DataStoreOptions?): DataStoreResult
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


local interface = {}


--[[**
Creates a new BaseStorage object.

@param [t:string] name The name of the DataStore.
@param [t:string?] scope The scope of the DataStore.
@param [t:DataStoreOptions?] options Options to modify DataStores.
@param [t:table] default Default data to be used for blank entries.

@returns [t:BaseStorageResult] A dictionary containing a success boolean, a message (if getting the DataStore fails), and a
	result (if getting the DataStore succeeds, this is the BaseStorage object).
**--]]
function interface.new(name: string, scope: string?, options: DataStoreOptions?, default: Default): BaseStorageResult
	local dataStore = GetDataStore(name, scope, options)
	
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
	
	--[[**
	Performs GetAsync if the data requested by the index does not exist, and returns the data.
	
	@param [t:string] index The key within the DataStore.
	
	@returns [t:DataResult] A dictionary containing a success boolean, a message (if getting the data fails), and a result
		(if getting the data succeeds, this is the data).
	**--]]
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
	
	
	--[[**
	Returns data associated with the index, if it has been loaded already.
	
	@param [t:string] index The key within the DataStore.
	
	@returns [t:DataResult] A dictionary containing a success boolean, a message (if getting the data fails), and a result
		(if getting the data succeeds, this is the data).
	**--]]
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
	
	--[[**
	Performs SetAsync with the data associated with the index, if it isn't already being saved.
	
	@param [t:string] index The key within the DataStore.
	@param [t:{number}?] ids An optional list of user IDs associated with the data.
	@param [t:DataStoreSetOptions?] setOptions Options used to adjust SetAsync.
	
	@returns [t:SaveResult] A dictionary containing a success boolean, and a message (if saving the data fails).
	**--]]
	function object:HardSave(index: string, ids: {[number]: number}?, setOptions: DataStoreSetOptions?): SaveResult
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
	
	--[[**
	Replaces all the data associated with the index.
	
	@param [t:string] index The key within the DataStore.
	
	@returns [t:SaveResult] A dictionary containing a success boolean, and a message (if saving the data fails).
	**--]]
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
	
	--[[**
	Saves the data associated with the index, if it isn't already being saved.
	
	@param [t:string] index The key within the DataStore.
	@param [t:string|number] key The key within the data.
	@param [t:any] newData The data to replace the contents of the key.
	
	@returns [t:SaveResult] A dictionary containing a success boolean, and a message (if saving the data fails).
	**--]]
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
	
	--[[**
	Saves the data associated with the indexes, if it isn't already being saved.
	
	@param [t:string] index The key within the DataStore.
	@param [t:any] newData The data to replace the contents of the key.
	@param [t:string|number] key The key within the data.
	@param [t:string|number] ... The key indexer(s) within the data.
	
	@returns [t:SaveResult] A dictionary containing a success boolean, and a message (if saving the data fails).
	**--]]
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
	
	--[[**
	Hard saves the data, then removes the data associated with the index.
	
	@param [t:string] index The key within the DataStore.
	**--]]
	function object:Clear(index: string)
		local data = members[index]
		
		if data then
			object:HardSave(index)
			
			members[index] = nil
		end
	end
	
	--[[**
	Saves all data, and clears it's own members.
	**--]]
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

--[[**
Returns a DataStore object, given a name and optional scope and DataStoreOptions parameters.

@param [t:string] name The name of the DataStore.
@param [t:string?] scope The scope of the DataStore.
@param [t:DataStoreOptions?] options The DataStoreOptions used when getting the DataStore.

@returns [t:DataStoreResult] A table containing data members for success, message, and result. The message data member is
	only used when success is false, and result is only used when success is true, and contains the DataStore.
**--]]
function interface:GetDataStore(name: string, scope: string?, options: DataStoreOptions?): DataStoreResult
	return GetDataStore(name, scope, options)
end


game:BindToClose(function()
	for name, dataStore in pairs(dataStores) do
		dataStore:Close()
	end
end)


return interface