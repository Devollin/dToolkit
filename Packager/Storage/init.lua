--!strict
--[[======================================================================

Storage | Written by Devi (@Devollin) | 2022 | v1.0.0
	Description: A library to aid in Data-related functions.
	
========================================================================]]


local Types = require(script:WaitForChild("Types"))


export type OrderedDataStoreResult = Types.OrderedDataStoreResult
export type DataStoreResult = Types.DataStoreResult

export type OrderedStorageResult = Types.OrderedStorageResult
export type PlayerStorageResult = Types.PlayerStorageResult
export type BaseStorageResult = Types.BaseStorageResult
export type Storage = OrderedStorageResult | PlayerStorageResult | BaseStorageResult

type BaseResult = DataStoreResult | OrderedDataStoreResult
type BaseTypes = "Base" | "Ordered"
type StorageType = Types.StorageType
type Default = Types.Default

export type BaseStorage = Types.BaseStorage
export type PlayerStorage = Types.PlayerStorage
export type OrderedStorage = Types.OrderedStorage


local RunService = game:GetService("RunService")


if RunService:IsServer() then
	local PlayerDataStore = require(script.PlayerDataStore)
	local OrderedDataStore = require(script.OrderedDataStore)
	local DataStore = require(script.DataStore)
	
	local storages: {[string]: Storage} = {}
	
	local interface = {}
	
	
	--[[**
	Creates a new Storage object.
	
	@param [t:StorageType] type The type of DataStore; Player contains specific functionality used for players,
		Ordered creates a OrderedDataStore, and Base creates a general-purpose DataStore.
	@param [t:string] name The name of the DataStore.
	@param [t:string?] scope The scope of the DataStore.
	@param [t:Default] default Default data to be used for blank entries.
	@param [t:DataStoreOptions?] options Options to modify DataStores.
	
	@returns [t:Storage] A dictionary containing a success boolean, a message (if getting the DataStore fails), and a result
		(if getting the DataStore succeeds, this is the Storage object).
	**--]]
	function interface.new(type: StorageType, name: string, scope: string?, default: Default, options: DataStoreOptions?): Storage
		if type == "Player" then
			storages[name] = PlayerDataStore.new(name, scope, options, default)
		elseif type == "Ordered" then
			storages[name] = OrderedDataStore.new(name, scope, default)
		elseif type == "Base" then
			storages[name] = DataStore.new(name, scope, options, default)
		end
		
		return storages[name]
	end
	
	--[[**
	Returns an already-existing Storage object, given a name.
	
	@param [t:string] name The name of the DataStore.
	
	@returns [t:Storage?] The Storage object, if it exists.
	**--]]
	function interface:GetStorage(name: string): Storage?
		return storages[name]
	end
	
	--[[**
	Returns a DataStore or OrderedDataStore object.
	
	@param [t:BaseTypes] type The type of DataStore; "Base" or "Ordered".
	@param [t:string] name The name of the DataStore.
	@param [t:string?] scope The scope of the DataStore.
	@param [t:Options?] options Options to modify DataStores.
	
	@returns [t:BaseResult] A dictionary containing a success boolean, a message (if getting the DataStore fails), and a
		result (if getting the DataStore succeeds, this is the DataStore).
	**--]]
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