--!strict
--[[================================================================================================

DataStore | Written by Devi (@Devollin) | 2022 | v1.1.0
	Description: A library to aid in general DataStore-related functions.
	
==================================================================================================]]


local DataStoreService: DataStoreService = game:GetService("DataStoreService")

local SimpleFunction = require(script.Parent.Parent:WaitForChild("SimpleFunction"))
local Signal = require(script.Parent.Parent:WaitForChild("Signal"))
local Util = require(script.Parent.Parent:WaitForChild("Util"))

local Types = require(script.Parent:WaitForChild("Types"))


type SimpleFunction<a..., b...> = SimpleFunction.SimpleFunction<a..., b...>
type Signal<a...> = Signal.Signal<a...>

type BaseStorageResult = Types.BaseStorageResult
type DataStoreResult = Types.DataStoreResult
type BaseStorage = Types.BaseStorage
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
	@prop LoadSuccess Signal<string>
	Fired when Storage succeeds in loading from the [GlobalDataStore].
	The only param passed is the index.
	
	@within BaseStorage
	@tag Event
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
	@prop MiscMessage Signal<ErrorCode, string, string>
	Fired when an error or warning code has been propagated by Storage.
	The first param is the code, the second param is the trackback, and the last param is the name of the key.
	
	@within BaseStorage
	@tag Event
]=]
--[=[
	@prop VerifyData SimpleFunction<(string, Default, Default, string), (Default?)>
	Invoked when the callback is filled and Storage is requesting to save data. Use this to prevent overwriting new data.
	The first parameter passed is the name of the key, the second parameter old data, the third is the new data, and the last
	is the context it was called from (this is useful for debugging).
	
	@within BaseStorage
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
			task.spawn(callbacks.GetDataStore.Retry, result :: any, name, scope)
			
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
		task.spawn(callbacks.GetDataStore.Failed, result :: any, name, scope)
		
		return {
			success = false,
			message = result :: any,
			code = ("D" .. ((result :: any) :: string):sub(1, 3)) :: Types.ErrorCode,
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
			code = dataStore.code,
		}
	end
	
	local dataStore = dataStore.result :: GlobalDataStore
	
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
		KeyUpdated = Signal.new() :: Signal<string, string | number, any, any>,
		DeepKeyUpdated = Signal.new() :: Signal<string, any, any, {string | number}>,
		MiscMessage = Signal.new() :: Signal<Types.ErrorCode, string, string>,
		VerifyData = SimpleFunction.new() :: SimpleFunction<(string, Default, Default, string), (Default?)>,
	}
	
	
	--[=[
		Performs GetAsync if the data requested by the index does not exist, and returns the data.
		
		@param index -- The key within the [GlobalDataStore].
		
		@within BaseStorage
		@yields
	]=]
	function object.HardLoad(self: BaseStorage, index: string): DataResult
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
				
				if data.loadStatus :: string == "Ready" then
					return {
						success = true,
						result = data.data
					}
				else
					object.MiscMessage:Fire("L101", debug.traceback(), index)
					
					return {
						success = false,
						code = "L101",
						message = debug.traceback(),
					}
				end
			end
			
			object.MiscMessage:Fire("L101", debug.traceback(), index)
			
			return {
				success = false,
				code = "L101",
				message = debug.traceback(),
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
					self.LoadRetry:Fire(result, name, scope, index)
					
					task.spawn(callbacks.GetAsync.Retry, result, name, scope, index)
					
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
					if result == nil then Util:DeepCloneTable(default)
					else result
				
				members[index].data = result
				members[index].loadStatus = "Ready"
				members[index].saveStatus = "Ready"
				
				return {
					success = true,
					result = result,
					metadata = metadata,
				}
			else
				members[index].loadStatus = "Failed"
				
				self.LoadFail:Fire(result, name, scope, index)
				
				task.spawn(callbacks.GetAsync.Failed, result, name, scope, index)
				
				object.MiscMessage:Fire(("D" .. ((result :: any) :: string):sub(1, 3)) :: Types.ErrorCode, debug.traceback(), index)
				
				return {
					success = false,
					code = ("D" .. ((result :: any) :: string):sub(1, 3)) :: Types.ErrorCode,
					message = debug.traceback(),
				}
			end
		end
	end
	
	--[=[
		Returns data associated with the index, if it has been loaded already.
		
		@param index -- The key within the [GlobalDataStore].
		
		@within BaseStorage
	]=]
	function object.SoftLoad(self: BaseStorage, index: string): DataResult
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
					object.MiscMessage:Fire("L101", debug.traceback(), index)
					
					return {
						success = false,
						code = "L101",
						message = debug.traceback(),
					}
				end
			elseif data.loadStatus == "Ready" then
				return {
					success = true,
					result = data.data,
				}
			else
				object.MiscMessage:Fire("L101", debug.traceback(), index)
				
				return {
					success = false,
					code = "L101",
					message = debug.traceback(),
				}
			end
		else
			object.MiscMessage:Fire("L102", debug.traceback(), index)
			
			return {
				success = false,
				code = "L102",
				message = debug.traceback(),
			}
		end
	end
	
	--[=[
		Performs SetAsync with the data associated with the index, if it isn't already being saved.
		
		@param index -- The key within the [GlobalDataStore].
		@param ids -- An optional list of user IDs associated with the data.
		@param setOptions -- Options used to adjust SetAsync.
		@param context -- The context from which this function was called. Useful for debugging.
		
		@within BaseStorage
		@yields
	]=]
	function object.HardSave(self: BaseStorage, index: string, ids: {number}?, setOptions: DataStoreSetOptions?, context: string): SaveResult
		local data = members[index]
		
		if data and data.canSave then
			if data.saveStatus == "Saving" then
				object.MiscMessage:Fire("S104", debug.traceback(), index)
				
				return {
					success = true,
					code = "S104",
					message = debug.traceback(),
				}
			elseif (data.saveStatus == "Ready") or (data.saveStatus == "Failed") then
				local success, result
				local iterations = 0
				
				data.saveStatus = "Saving"
				
				self.SaveStart:Fire(index)
				
				repeat
					success, result = pcall(function()
						if object.VerifyData:IsCallbackSet() then
							return dataStore:UpdateAsync(index, function(previousData: Default)
								if previousData == nil then
									return data.data
								end
								
								return object.VerifyData:Invoke(index, previousData, data.data, context)
							end)
						else
							return dataStore:SetAsync(index, data.data, ids, setOptions)
						end
					end)
					
					if not success then
						self.SaveRetry:Fire(result, name, scope, index)
						
						task.spawn(callbacks.SetAsync.Retry, result, name, scope, index)
						
						task.wait(5)
						
						iterations += 1
					end
				until success or (iterations >= 5)
				
				if success then
					data.saveStatus = "Ready"
					
					self.SaveSuccess:Fire(index)
					
					return {
						success = true,
					}
				else
					data.saveStatus = "Failed"
					
					self.SaveFail:Fire(result, name, scope, index)
					
					task.spawn(callbacks.SetAsync.Failed, result, name, scope, index)
					
					object.MiscMessage:Fire(("D" .. (result :: any):sub(1, 3)) :: Types.ErrorCode, debug.traceback(), index)
					
					return {
						success = false,
						code = ("D" .. ((result :: any) :: string):sub(1, 3)) :: Types.ErrorCode,
						message = debug.traceback(),
					}
				end
			else
				object.MiscMessage:Fire("S101", debug.traceback(), index)
				
				return {
					success = false,
					code = "S101",
					message = debug.traceback(),
				}
			end
		else
			object.MiscMessage:Fire("S103", debug.traceback(), index)
			
			return {
				success = true,
				code = "S103",
				message = debug.traceback(),
			}
		end
	end
	
	--[=[
		Replaces all the data associated with the index.
		
		@param index -- The key within the [GlobalDataStore].
		
		@within BaseStorage
	]=]
	function object.SoftSave(self: BaseStorage, index: string, newData: any): SaveResult
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
					object.MiscMessage:Fire("S102", debug.traceback(), index)
					
					return {
						success = false,
						code = "S102",
						message = debug.traceback(),
					}
				end
			else
				object.MiscMessage:Fire("S102", debug.traceback(), index)
				
				return {
					success = false,
					code = "S102",
					message = debug.traceback(),
				}
			end
		else
			object.MiscMessage:Fire("S103", debug.traceback(), index)
			
			return {
				success = false,
				code = "S103",
				message = debug.traceback(),
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
	function object.Update(self: BaseStorage, index: string, key: (string | number), newData: any): SaveResult
		local data = members[index]
		
		if data and data.canSave then
			if data.saveStatus == "Ready" then
				self.KeyUpdated:Fire(index, key, newData, data.data[key])
				
				data.data[key] = newData
				
				return {
					success = true,
				}
			elseif (data.saveStatus == "Saving") or (data.saveStatus == "NotReady") then
				repeat
					task.wait()
				until (data.saveStatus ~= "Saving") or (members[index] == nil)
				
				if data.saveStatus :: string == "Ready" then
					self.KeyUpdated:Fire(index, key, newData, data.data[key])
					
					data.data[key] = newData
					
					return {
						success = true,
					}
				else
					object.MiscMessage:Fire("S102", debug.traceback(), index)
					
					return {
						success = false,
						code = "S102",
						message = debug.traceback(),
					}
				end
			else
				object.MiscMessage:Fire("S102", debug.traceback(), index)
				
				return {
					success = false,
					code = "S102",
					message = debug.traceback(),
				}
			end
		else
			object.MiscMessage:Fire("S103", debug.traceback(), index)
			
			return {
				success = false,
				code = "S103",
				message = debug.traceback(),
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
	function object.DeepUpdate(self: BaseStorage, index: string, newData: any, key: (string | number), ...: (string | number)): SaveResult
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
				
				self.DeepKeyUpdated:Fire(index, newData, oldData, {...})
				
				return {
					success = true,
				}
			elseif (data.saveStatus == "Saving") or (data.saveStatus == "NotReady") then
				repeat
					task.wait()
				until (data.saveStatus ~= "Saving") or (members[index] == nil)
				
				if data.saveStatus :: string == "Ready" then
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
					
					self.DeepKeyUpdated:Fire(index, newData, oldData, {...})
					
					return {
						success = true,
					}
				else
					object.MiscMessage:Fire("S102", debug.traceback(), index)
					
					return {
						success = false,
						code = "S102",
						message = debug.traceback(),
					}
				end
			else
				object.MiscMessage:Fire("S102", debug.traceback(), index)
				
				return {
					success = false,
					code = "S102",
					message = debug.traceback(),
				}
			end
		else
			object.MiscMessage:Fire("S103", debug.traceback(), index)
			
			return {
				success = false,
				code = "S103",
				message = debug.traceback(),
			}
		end
	end
	
	--[=[
		Hard saves the data, then removes the data associated with the index.
		
		@param index -- The key within the [GlobalDataStore].
		@param context -- The context from which this function was called. Useful for debugging.
		
		@within BaseStorage
		@yields
	]=]
	function object.Clear(self: BaseStorage, index: string, context: string)
		local data = members[index]
		
		if data then
			self:HardSave(index, nil, nil, context)
			
			members[index] = nil
		end
	end
	
	--[=[
		Saves all data, and clears it's own members.
		@within BaseStorage
		@yields
	]=]
	function object.Close(self: BaseStorage)
		local total = Util:GetDictionaryLength(members)
		local finished = 0
		
		for key, data in pairs(members) do
			task.spawn(function()
				self:Clear(key, "CLOSE")
				
				finished += 1
			end)
		end
		
		repeat
			task.wait()
		until total == finished
	end
	
	
	dataStores[name] = object
	
	
	return {
		success = true,
		result = object,
	}
end


game:BindToClose(function()
	local total = Util:GetDictionaryLength(dataStores)
	local finished = 0
	
	for name, dataStore in pairs(dataStores) do
		task.defer(function()
			dataStore:Close()
			
			finished += 1
		end)
	end
	
	repeat
		task.wait()
	until total == finished
end)


return interface