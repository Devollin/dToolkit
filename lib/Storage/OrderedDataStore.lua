--!strict
--[[================================================================================================

OrderedDataStore | Written by Devi (@Devollin) | 2022 | v1.0.2
	Description: A library to aid in OrderedDataStore-related functions.
	
==================================================================================================]]


local DataStoreService: DataStoreService = game:GetService("DataStoreService")

local Signal = require(script.Parent.Parent:WaitForChild("Signal"))
local Util = require(script.Parent.Parent:WaitForChild("Util"))

local Types = require(script.Parent:WaitForChild("Types"))


type Signal<a...> = Signal.Signal<a...>

type OrderedDataStoreResult = Types.OrderedDataStoreResult
type OrderedStorageResult = Types.OrderedStorageResult
type OrderedStorage = Types.OrderedStorage
type BaseStorage = Types.BaseStorage
type PageResult = Types.PageResult
type SaveResult = Types.SaveResult
type DataResult = Types.DataResult
type Data = Types.BaseData


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

local interface = {}


--[=[
	@class OrderedStorage
	A basic [OrderedDataStore] wrapper object.
	@server
]=]
--[=[
	@prop LoadRetry Signal<string, string, string?, string>
	Fired when Storage is going to retry loading the requested data, if it previously failed.
	The first param is the error message, the second param is the name of the Storage, the third param is the scope, and the
	last param is the key.
	
	@within OrderedStorage
	@tag Event
]=]
--[=[
	@prop LoadFail Signal<string, string, string?, string>
	Fired when Storage failed to load the requested data after retrying several times.
	The first param is the error message, the second param is the name of the Storage, the third param is the scope, and the
	last param is the key.
	
	@within OrderedStorage
	@tag Event
]=]
--[=[
	@prop SaveStart Signal<string>
	Fired when Storage is going to try to save to [OrderedDataStore].
	The only param passed is the index.
	
	@within OrderedStorage
	@tag Event
]=]
--[=[
	@prop SaveRetry Signal<string, string, string?, string>
	Fired when Storage is going to retry saving the requested data, if it previously failed.
	The first param is the error message, the second param is the name of the Storage, the third param is the scope, and the
	last param is the key.
	
	@within OrderedStorage
	@tag Event
]=]
--[=[
	@prop SaveFail Signal<string, string, string?, string>
	Fired when Storage failed to load the requested data after retrying several times.
	The first param is the error message, the second param is the name of the Storage, the third param is the scope, and the
	last param is the key.
	
	@within OrderedStorage
	@tag Event
]=]
--[=[
	@prop SaveSuccess Signal<string>
	Fired when Storage successfully saved to the [OrderedDataStore].
	The only param passed is the index.
	
	@within OrderedStorage
	@tag Event
]=]
--[=[
	@prop FilledBlankStorage Signal<string, string?, string>
	Fired when Storage fills in an empty key.
	The first param is the name of the Storage, the second param is the scope, and the last param is the index.
	
	@within OrderedStorage
	@tag Event
]=]
--[=[
	@prop GetSortedAsyncRetry Signal<string, string, string?>
	Fired when Storage is going to retry getting the requested page data, if it previously failed.
	The first param is the error message, the second param is the name of the Storage, and the last param is the scope.
	
	@within OrderedStorage
	@tag Event
]=]
--[=[
	@prop GetSortedAsyncFail Signal<string, string, string?>
	Fired when Storage failed to load the requested page data after retrying several times.
	The first param is the error message, the second param is the name of the Storage, and the last param is the scope.
	
	@within OrderedStorage
	@tag Event
]=]

--[=[
	Returns a [OrderedDataStore] object, given a name and an optional scope parameter.
	
	@param name -- The name of the [OrderedDataStore].
	@param scope -- The scope of the [OrderedDataStore].
	
	@within OrderedStorage
	@yields
]=]
function interface:GetOrderedDataStore(name: string, scope: string?): OrderedDataStoreResult
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
			message = result :: any,
		}
	end
end

--[=[
	Creates a new [OrderedStorageResult] object.
	
	@param name --The name of the [OrderedDataStore].
	@param scope -- The scope of the [OrderedDataStore].
	@param default -- Default data to be used for blank entries.
	
	@within OrderedStorage
	@yields
]=]
function interface.new(name: string, scope: string?, default: number): OrderedStorageResult
	local dataStore = interface:GetOrderedDataStore(name, scope)
	
	if not dataStore.success then
		return {
			success = false,
			message = dataStore.message,
		}
	end
	
	local dataStore = dataStore.result :: OrderedDataStore
	
	local members: {[string]: Data} = {}
	local object = {
		LoadSuccess = Signal.new() :: Signal<string>,
		LoadRetry = Signal.new() :: Signal<string, string, string?, string>,
		LoadFail = Signal.new() :: Signal<string, string, string?, string>,
		SaveStart = Signal.new() :: Signal<string>,
		SaveRetry = Signal.new() :: Signal<string, string, string?, string>,
		SaveFail = Signal.new() :: Signal<string, string, string?, string>,
		SaveSuccess = Signal.new() :: Signal<string>,
		FilledBlankStorage = Signal.new() :: Signal<string, string?, string>,
		GetSortedAsyncRetry = Signal.new() :: Signal<string, string, string?>,
		GetSortedAsyncFail = Signal.new() :: Signal<string, string, string?>,
	}
	
	--[=[
		Performs GetAsync if the data requested by the index does not exist, and returns the data.
		
		@param index -- The key within the [OrderedDataStore].
		
		@within OrderedStorage
		@yields
	]=]
	function object.HardLoad(self: OrderedStorage, index: string): DataResult
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
				
				if data.loadStatus :: string == "Ready" then
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
					self.LoadRetry:Fire(result, name, scope, index)
					
					task.spawn(callbacks.GetAsync.Retry, result, name, scope)
					
					task.wait(5)
					
					iterations += 1
				end
			until success or (iterations >= 5)
			
			
			members[index].canSave = success
			
			if success then
				self.LoadSuccess:Fire(index)
				
				if result == nil then
					self.FilledBlankStorage:Fire(name, scope, index)
				end
				
				result =
					if result == nil then default
					else result
				
				members[index].data = result
				members[index].saveStatus = "Ready"
				members[index].loadStatus = "Ready"
				
				return {
					success = true,
					result = result,
				}
			else
				self.LoadFail:Fire(result, name, scope, index)
				
				members[index].loadStatus = "Failed"
				
				task.spawn(callbacks.GetAsync.Failed, result, name, scope)
				
				return {
					success = false,
					message = result,
				}
			end
		end
	end
	
	--[=[
		Returns data associated with the index, if it has been loaded already.
		
		@param index -- The key within the [OrderedDataStore].
		
		@within OrderedStorage
	]=]
	function object.SoftLoad(self: OrderedStorage, index: string): DataResult
		local data = members[index]
		
		if data then
			if data.loadStatus == "Loading" then
				repeat
					task.wait()
				until (data.loadStatus ~= "Loading") or (members[index] == nil)
				
				if data.loadStatus :: string == "Ready" then
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
		
		@param index -- The key within the [OrderedDataStore].
		
		@within OrderedStorage
		@yields
	]=]
	function object.HardSave(self: OrderedStorage, index: string, ids: {number}?, setOptions: DataStoreSetOptions?): SaveResult
		local data = members[index]
		
		if data and data.canSave then
			if (data.saveStatus == "Ready") or (data.saveStatus == "Saving") then
				return {
					success = true,
				}
			elseif data.saveStatus :: string == "Ready" then
				local success, result
				local iterations = 0
				
				data.saveStatus = "Saving"
				
				self.SaveStart:Fire(index)
				
				repeat
					success, result = pcall(function()
						return dataStore:SetAsync(index, data.data, ids, setOptions)
					end)
					
					if not success then
						self.SaveRetry:Fire(result, name, scope, index)
						
						task.spawn(callbacks.SetAsync.Retry, result, name, scope, setOptions)
						
						task.wait(5)
						
						iterations += 1
					end
				until success or (iterations >= 5)
				
				if success then
					self.SaveSuccess:Fire(index)
					data.saveStatus = "Ready"
					
					return {
						success = true,
					}
				else
					self.SaveFail:Fire(result, name, scope, index)
					
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
	
	--[=[
		Replaces all the data associated with the index.
		
		@param index -- The key within the [OrderedDataStore].
		
		@within OrderedStorage
	]=]
	function object.SoftSave(self: OrderedStorage, index: string, newData: any): SaveResult
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
				
				if data.saveStatus :: string == "Ready" then
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
		Returns a [PageResult] object.
		
		@param ascending -- Whether the list is in descending order or ascending order.
		@param pageSize -- The length of each page.
		@param min -- The minimum value to be included in the pages.
		@param max -- The maximum value to be included in the pages.
		
		@within OrderedStorage
		@yields
	]=]
	function object.GetPages(self: OrderedStorage, ascending: boolean, pageSize: number, min: number, max: number): PageResult
		local success, result
		local iterations = 0
		
		repeat
			success, result = pcall(function()
				return dataStore:GetSortedAsync(ascending, pageSize, min, max)
			end)
			
			if not success then
				self.GetSortedAsyncRetry:Fire(result :: any, name, scope)
				
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
			self.GetSortedAsyncFail:Fire(result :: any, name, scope)
			
			task.spawn(callbacks.GetSortedAsync.Failed, result, name, scope)
			
			return {
				success = false,
			}
		end
	end
	
	--[=[
		Hard saves the data, then removes the data associated with the index.
		
		@param index -- The key within the [OrderedDataStore].
		
		@within OrderedStorage
		@yields
	]=]
	function object.Clear(self: OrderedStorage, index: string)
		local data = members[index]
		
		if data then
			if data.canSave then
				if data.saveStatus == "Ready" then
					self:HardSave(index)
					
					members[index] = nil
				end
			end
		end
	end
	
	--[=[
		Saves all data, and clears it's own members.
		@within OrderedStorage
		@yields
	]=]
	function object.Close(self: OrderedStorage)
		for key, data in pairs(members) do
			task.spawn(function()
				self:Clear(key)
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