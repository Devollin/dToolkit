--!strict
--[[================================================================================================

Storage | Written by Devi (@Devollin) | 2022 | v1.0.0
	Description: A library to aid in Data-related functions.
	
==================================================================================================]]


local RunService = game:GetService("RunService")

local Types = require(script:WaitForChild("Types"))


export type StorageResult = Types.StorageResult

type BaseResult = Types.BaseResult
type BaseTypes = "Base" | "Ordered"
type StorageType = Types.StorageType
type Default = Types.Default


if RunService:IsServer() then
	local PlayerDataStore = require(script.PlayerDataStore)
	local OrderedDataStore = require(script.OrderedDataStore)
	local DataStore = require(script.DataStore)
	
	local storages: {[string]: StorageResult} = {}
	
	local interface = {}
	
	
	--[=[
		@class Storage
		A DataStore wrapper object.
		@server
	]=]
	
	--[=[
		Creates a new Storage object.
		
		@param name -- The name of the DataStore.
		@param scope -- The scope of the DataStore.
		@param options -- Options to modify DataStores.
		
		@within Storage
	]=]
	function interface.new(type: StorageType, name: string, scope: string?, default: Default, options: DataStoreOptions?): StorageResult
		if type == "Player" then
			storages[name] = PlayerDataStore.new(name, scope, options, default)
		elseif type == "Ordered" then
			storages[name] = OrderedDataStore.new(name, scope, default)
		elseif type == "Base" then
			storages[name] = DataStore.new(name, scope, options, default)
		end
		
		return storages[name]
	end
	
	--[=[
		Returns an already-existing Storage object, given a name.
		
		@param name -- The name of the DataStore.
		
		@within Storage
	]=]
	function interface:GetStorage(name: string): StorageResult?
		return storages[name]
	end
	
	--[=[
		Returns a DataStore or OrderedDataStore object.
		
		@param type -- The type of DataStore; "Base" or "Ordered".
		@param name -- The name of the DataStore.
		@param scope -- The scope of the DataStore.
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