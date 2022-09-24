--!strict
--[[================================================================================================

Storage | Written by Devi (@Devollin) | 2022 | v1.0.0
	Description: A library to aid in Data-related functions.
	
==================================================================================================]]


local RunService = game:GetService("RunService")

local Types = require(script:WaitForChild("Types"))


export type OrderedStorage = Types.OrderedStorage
export type PlayerStorage = Types.PlayerStorage
export type BaseStorage = Types.BaseStorage
export type StorageResult = Types.StorageResult

type BaseResult = Types.BaseResult
type BaseTypes = "Base" | "Ordered"
type StorageType = Types.StorageType
type OrderedStorageResult = Types.OrderedStorageResult
type Default = Types.Default


if RunService:IsServer() then
	local PlayerDataStore = require(script.PlayerDataStore)
	local OrderedDataStore = require(script.OrderedDataStore)
	local DataStore = require(script.DataStore)
	
	local storages: {[string]: StorageResult} = {}
	
	local interface = {}
	
	
	--[=[
		@class Storage
		A DataStore wrapper service.
		@server
	]=]
	
	--[=[
		Returns a [StorageResult] object.
		
		```lua
		local storageResult = Storage.new("Base", "TEST", nil, {
			foo = 5,
			bar = 10,
			qux = {
				foo = 10,
				bar = 5
				boot = "doot",
				
				secret = {
					REALLYSECRET = {
						key = "oof!",
					}
				},
			},
		})

		if storageResult.success then
			local storage = storageResult.result
			
			storage.DeepKeyUpdated:Connect(function(index, oldData, newData, indexers)
				print(index, indexers, table.unpack(indexers), oldData, newData)
			end)
			
			storage.KeyUpdate:Connect(function(index, key, newData, oldData)
				print(index, key, newData, oldData)
			end)
			
			do
				local data = storage:HardLoad("qux")
				
				if data.success then
					storage:DeepUpdate("qux", "doh!", "secret", "REALLYSECRET")
				end
			end
			
			do
				local data = storage:HardLoad("foo")
				
				if data.success then
					storage:Update("foo", 10)
				end
			end
		end
		```
		
		@param name -- The name of the [Storage].
		@param scope -- The scope of the [Storage].
		@param options -- Options to modify DataStores.
		
		@within Storage
		@yields
	]=]
	function interface.new(type: StorageType, name: string, scope: string?, default: Default, options: DataStoreOptions?): StorageResult
		if type == "Player" then
			storages[name] = PlayerDataStore.new(name, scope, options, default)
		elseif type == "Base" then
			storages[name] = DataStore.new(name, scope, options, default)
		end
		
		return storages[name]
	end
	
	--[=[
		Returns a [OrderedStorageResult] object.
		
		@param name -- The name of the [OrderedStorage].
		@param scope -- The scope of the [OrderedStorage].
		@param options -- Options to modify DataStores.
		
		@within Storage
		@yields
	]=]
	function interface.newOrdered(name: string, scope: string?, default: number): StorageResult
		storages[name] = OrderedDataStore.new(name, scope, default)
		
		return storages[name]
	end
	
	--[=[
		Returns an already-existing [StorageResult] object, given a name.
		
		```lua
		local storageResult = Storage:GetStorage("TEST")
		```
		
		@param name -- The name of the [Storage].
		
		@within Storage
	]=]
	function interface:GetStorage(name: string): StorageResult?
		return storages[name]
	end
	
	--[=[
		Returns a [BaseResult] object.
		
		```lua
		local baseResult = Storage:GetBaseStorage("Base", "TEST2")
		```
		
		@param type -- The type of [Storage]; "Base" or "Ordered".
		@param name -- The name of the [Storage].
		@param scope -- The scope of the [Storage].
		@param options -- Options to modify DataStores.
		
		@within Storage
	]=]
	function interface:GetBaseStorage(type: BaseTypes, name: string, scope: string?, options: DataStoreOptions?): BaseResult
		if type == "Ordered" then
			return OrderedDataStore:GetOrderedDataStore(name, scope)
		elseif type == "Base" then
			return DataStore:GetDataStore(name, scope, options)
		end
		
		return {
			success = false,
		}
	end
	
	
	return interface
else
	return {} :: any
end