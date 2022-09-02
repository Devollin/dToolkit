--!strict
--[[======================================================================

OrderedDataStore | Written by Devi (@Devollin) | 2022 | v1.0.0
	Description: A library to aid in OrderedDataStore-related functions.
	
========================================================================]]


local Types = require(script.Parent:WaitForChild("Types"))

type OrderedDataStoreResult = Types.OrderedDataStoreResult
type OrderedStorageResult = Types.OrderedStorageResult
type OrderedStorage = Types.OrderedStorage
type BaseStorage = Types.BaseStorage
type PageResult = Types.PageResult
type SaveResult = Types.SaveResult
type DataResult = Types.DataResult
type Default = Types.Default
type Data = Types.BaseData


local DataStoreService = game:GetService("DataStoreService")

local Signal = require(script.Parent.Parent:WaitForChild("Signal"))
local Util = require(script.Parent.Parent:WaitForChild("Util"))

local dataStores = {}

local callbacks = {
	GetOrderedDataStore = {
		Retry = function(message: string, name: string, scope: string?)
			if scope then
				warn("Failed to get OrderedDataStore of name \"" .. name ..
					"\" and scope \"" .. scope ..
					"\", retrying in 5 seconds...")
			else
				warn("Failed to get OrderedDataStore of name \"" .. name ..
					"\", retrying in 5 seconds...")
			end
		end,
		Failed = function(message: string, name: string, scope: string?)
			if scope then
				warn("Failed to get OrderedDataStore of name \"" .. name ..
					"\" and scope \"" .. scope ..
					"\"; exhausted retries.")
			else
				warn("Failed to get OrderedDataStore of name \"" .. name ..
					"\"; exhausted retries.")
			end
		end,
	}, SetAsync = {
		Retry = function(message: string, name: string, scope: string?, key: string)
			if scope then
				warn("Failed to set data for key \"" .. key ..
					"\" OrderedDataStore of name \"" .. name ..
					"\", and scope \"" .. scope ..
					"\", retrying in 5 seconds...")
			else
				warn("Failed to set data for key \"" .. key ..
					"\" OrderedDataStore of name \"" .. name ..
					"\", retrying in 5 seconds...")
			end
		end,
		Failed = function(message: string, name: string, scope: string?, key: string)
			if scope then
				warn("Failed to set data for key \"" .. key ..
					"\" OrderedDataStore of name \"" .. name ..
					"\", and scope \"" .. scope ..
					"\"; exhausted retries.")
			else
				warn("Failed to set data for key \"" .. key ..
					"\" OrderedDataStore of name \"" .. name ..
					"\"; exhausted retries.")
			end
		end,
	}, GetAsync = {
		Retry = function(message: string, name: string, scope: string?, key: string)
			if scope then
				warn("Failed to set data for key \"" .. key ..
					"\" OrderedDataStore of name \"" .. name ..
					"\", and scope \"" .. scope ..
					"\", retrying in 5 seconds...")
			else
				warn("Failed to set data for key \"" .. key ..
					"\" OrderedDataStore of name \"" .. name ..
					"\", retrying in 5 seconds...")
			end
		end,
		Failed = function(message: string, name: string, scope: string?, key: string)
			if scope then
				warn("Failed to set data for key \"" .. key ..
					"\" OrderedDataStore of name \"" .. name ..
					"\", and scope \"" .. scope ..
					"\"; exhausted retries.")
			else
				warn("Failed to set data for key \"" .. key ..
					"\" OrderedDataStore of name \"" .. name ..
					"\"; exhausted retries.")
			end
		end,
	}, GetSortedAsync = {
		Retry = function(message: string, name: string, scope: string?, key: string)
			if scope then
				warn("Failed to get page data for key \"" .. key ..
					"\" OrderedDataStore of name \"" .. name ..
					"\", and scope \"" .. scope ..
					"\", retrying in 5 seconds...")
			else
				warn("Failed to get page data for key \"" .. key ..
					"\" OrderedDataStore of name \"" .. name ..
					"\", retrying in 5 seconds...")
			end
		end,
		Failed = function(message: string, name: string, scope: string?, key: string)
			if scope then
				warn("Failed to get page data for key \"" .. key ..
					"\" OrderedDataStore of name \"" .. name ..
					"\", and scope \"" .. scope ..
					"\"; exhausted retries.")
			else
				warn("Failed to get page data for key \"" .. key ..
					"\" OrderedDataStore of name \"" .. name ..
					"\"; exhausted retries.")
			end
		end,
	},
}


--[[**
Returns a OrderedDataStore object, given a name and an optional scope parameter.

@param [t:string] name The name of the OrderedDataStore.
@param [t:string?] scope The scope of the OrderedDataStore.

@returns [t:OrderedDataStoreResult] A table containing data members for success, message, and result. The message data member
	is only used when success is false, and result is only used when success is true, and contains the OrderedDataStore.
**--]]
local function GetOrderedDataStore(name: string, scope: string?): OrderedDataStoreResult
	local success, result
	local iterations = 0
	
	repeat
		success, result = pcall(function()
			return DataStoreService:GetOrderedDataStore(name, scope)
		end)
		
		if not success then
			task.spawn(callbacks.GetOrderedDataStore.Retry, result, name, scope)
			
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
		task.spawn(callbacks.GetOrderedDataStore.Failed, result, name, scope)
		
		return {
			success = false,
			message = result,
		}
	end
end


local interface = {}


--[[**
Creates a new Storage object.

@param [t:string] name The name of the DataStore.
@param [t:string?] scope The scope of the DataStore.
@param [t:Options?] options Options to modify DataStores.
@param [t:table] default Default data to be used for blank entries.

@returns [t:OrderedStorageResult] A dictionary containing a success boolean, a message (if getting the DataStore fails), and
	a result (if getting the DataStore succeeds, this is the OrderedStorage object).
**--]]
function interface.new(name: string, scope: string?, default: Default): OrderedStorageResult
	local dataStore = GetOrderedDataStore(name, scope)
	
	if not dataStore.success then
		return {
			success = false,
			message = dataStore.message,
		}
	end
	
	local dataStore = dataStore.result :: OrderedDataStore
	
	local members: {[string]: Data} = {}
	local object = {
		LoadRetry = Signal.new() :: Signal.Signal<string, string, string?, string>,
		LoadFail = Signal.new() :: Signal.Signal<string, string, string?, string>,
		SaveStart = Signal.new() :: Signal.Signal<string>,
		SaveRetry = Signal.new() :: Signal.Signal<string, string, string?, string>,
		SaveFail = Signal.new() :: Signal.Signal<string, string, string?, string>,
		SaveSuccess = Signal.new() :: Signal.Signal<string>,
		FilledBlankStorage = Signal.new() :: Signal.Signal<string, string?, string>,
		GetSortedAsyncRetry = Signal.new() :: Signal.Signal<string, string, string?>,
		GetSortedAsyncFail = Signal.new() :: Signal.Signal<string, string, string?>,
	}
	
	--[[**
	Performs GetAsync if the data requested by the index does not exist, and returns the data.
	
	@param [t:string] index The key within the OrderedDataStore.
	
	@returns [t:DataResult] A dictionary containing a success boolean, a message (if getting the data fails), and a result
		(if getting the data succeeds, this is the data).
	**--]]
	function object:HardLoad(index: string): DataResult
		local data = members[index]
		
		if data then
			if data.loadStatus == "Ready" then
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
		else
			members[index] = {
				saveStatus = "NotReady",
				loadStatus = "Loading",
				canSave = false,
			}
			
			local success, result
			local iterations = 0
			
			repeat
				success, result = pcall(function()
					return dataStore:GetAsync(index)
				end)
				
				if not success then
					object.LoadRetry:Fire(result, name, scope, index)
					
					task.spawn(callbacks.GetAsync.Retry, result, name, scope)
					
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
				
				return {
					success = true,
					result = result,
				}
			else
				object.LoadFail:Fire(result, name, scope, index)
				
				members[index].loadStatus = "Failed"
				
				task.spawn(callbacks.GetAsync.Failed, result, name, scope)
				
				return {
					success = false,
					message = result,
				}
			end
		end
	end
	
	
	--[[**
	Returns data associated with the index, if it has been loaded already.
	
	@param [t:string] index The key within the OrderedDataStore.
	
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
	
	@param [t:string] index The key within the OrderedDataStore.
	
	@returns [t:SaveResult] A dictionary containing a success boolean, and a message (if saving the data fails).
	**--]]
	function object:HardSave(index: string, ids: {[number]: number}?, setOptions: DataStoreSetOptions?): SaveResult
		local data = members[index]
		
		if data and data.canSave then
			if (data.saveStatus == "Ready") or (data.saveStatus == "Saving") then
				return {
					success = true,
				}
			elseif data.saveStatus == "Ready" then
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
						
						task.spawn(callbacks.SetAsync.Retry, result, name, scope, setOptions)
						
						task.wait(5)
						
						iterations += 1
					end
				until success or (iterations >= 5)
				
				if success then
					object.SaveSuccess:Fire(index)
					data.saveStatus = "Ready"
					
					return {
						success = true,
					}
				else
					object.SaveFail:Fire(result, name, scope, index)
					
					data.saveStatus = "Failed"
					
					task.spawn(callbacks.SetAsync.Failed, result, name, scope, setOptions)
					
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
	
	@param [t:string] index The key within the OrderedDataStore.
	
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
	Returns a DataStoreKeyPages object.
	
	@param [t:boolean] ascending Whether the list is in descending order or ascending order.
	@param [t:number] pageSize The length of each page.
	@param [t:number] min The minimum value to be included in the pages.
	@param [t:number] max The maximum value to be included in the pages.
	
	@returns [t:PageResult] A dictionary containing a success boolean, a message (if saving the data fails), and a result (if
		getting the data succeeds, then this is the DataStoreKeyPages object).
	**--]]
	function object:GetPages(ascending: boolean, pageSize: number, min: number, max: number): PageResult
		local success, result
		local iterations = 0
		
		repeat
			success, result = pcall(function()
				return dataStore:GetSortedAsync(ascending, pageSize, min, max)
			end)
			
			if not success then
				object.GetSortedAsyncRetry:Fire(result :: any, name, scope)
				
				task.spawn(callbacks.GetSortedAsync.Retry, result, name, scope)
				
				task.wait(5)
				
				iterations += 1
			end
		until success or (iterations >= 5)
		
		if success then
			return {
				success = true,
				result = result :: DataStoreKeyPages,
			}
		else
			object.GetSortedAsyncFail:Fire(result :: any, name, scope)
			
			task.spawn(callbacks.GetSortedAsync.Failed, result, name, scope)
			
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
			if data.canSave then
				if data.saveStatus == "Ready" then
					object:HardSave(index)
					
					members[index] = nil
				end
			end
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
Returns a OrderedDataStore object, given a name and an optional scope parameter.

@param [t:string] name The name of the OrderedDataStore.
@param [t:string?] scope The scope of the OrderedDataStore.

@returns [t:OrderedDataStoreResult] A table containing data members for success, message, and result. The message data member
	is only used when success is false, and result is only used when success is true, and contains the OrderedDataStore.
**--]]
function interface:GetOrderedDataStore(name: string, scope: string?): OrderedDataStoreResult
	return GetOrderedDataStore(name, scope)
end



game:BindToClose(function()
	for name, dataStore in pairs(dataStores) do
		dataStore:Close()
	end
end)


return interface