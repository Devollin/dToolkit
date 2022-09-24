--!strict
local Signal = require(script.Parent.Parent:WaitForChild("Signal"))


--[=[
	@type StorageType "Player" | "Base"
	The type of DataStore; Player contains specific functionality used for players, and Base creates a general-purpose
		DataStore.
	
	@within Storage
]=]
--[=[
	@type Default {[string | number]: any}
	Default data to be used for blank entries.
	
	@within Storage
]=]
--[=[
	@type Result <a>{success: boolean, message: string?, result: a, metadata: DataStoreKeyInfo?}
	@within Storage
]=]
--[=[
	@type SaveResult Result<boolean?>
	A dictionary containing a success boolean, and a message (if saving the data fails).
	
	@within Storage
]=]
--[=[
	@type PageResult Result<DataStoreKeyPages?>
	A dictionary containing a success boolean, a message (if saving the data fails), and a result (if getting the data
		succeeds, then this is the DataStoreKeyPages object).
	
	@within OrderedStorage
]=]
--[=[
	@type OrderedDataStoreResult Result<OrderedDataStore?>
	A table containing data members for success, message, and result. The message data member is only used when success is
		false, and result is only used when success is true, and contains the OrderedDataStore.
	
	@within OrderedStorage
]=]
--[=[
	@type DataStoreResult Result<GlobalDataStore?>
	A table containing data members for success, message, and result. The message data member is only used when success is
		false, and result is only used when success is true, and contains the DataStore.
	
	@within Storage
]=]
--[=[
	@type SaveStatus "Saving" | "Failed" | "Ready" | "NotReady"
	@within Storage
	@ignore
]=]
--[=[
	@type LoadStatus "Loading" | "Failed" | "Ready"
	@within Storage
	@ignore
]=]
--[=[
	@type BaseData {saveStatus: SaveStatus, loadStatus: LoadStatus, canSave: boolean, data: any}
	@within Storage
]=]
--[=[
	@type DataResult Result<any>
	A dictionary containing a success boolean, a message (if getting the data fails), and a result (if getting the data
		succeeds, this is the data).
	
	@within Storage
]=]
--[=[
	@type BaseResult Result<(GlobalDataStore | OrderedDataStore)?>
	A dictionary containing a success boolean, a message (if getting the DataStore fails), and a result (if getting the
		DataStore succeeds, this is the DataStore).
	
	@within Storage
]=]
--[=[
	@type BaseStorageResult Result<BaseStorage?>
	A dictionary containing a success boolean, a message (if getting the DataStore fails), and a result (if getting the
		DataStore succeeds, this is the BaseStorage object).
	
	@within BaseStorage
]=]
--[=[
	@type PlayerStorageResult Result<PlayerStorage?>
	A dictionary containing a success boolean, a message (if getting the DataStore fails), and a result (if getting the
		DataStore succeeds, this is the PlayerStorage object).
	
	@within PlayerStorage
]=]
--[=[
	@type OrderedStorageResult Result<OrderedStorage?>
	A dictionary containing a success boolean, a message (if getting the DataStore fails), and a result (if getting the
		DataStore succeeds, this is the OrderedStorage object).
	
	@within OrderedStorage
]=]
--[=[
	@type StorageResult Result<(PlayerStorage | BaseStorage)?>
	A dictionary containing a success boolean, a message (if getting the DataStore fails), and a result (if getting the
		DataStore succeeds, this is the Storage object).
	
	@within Storage
]=]


export type StorageType = "Player" | "Base"
export type Default = {[string | number]: any}

type Result<a> = {
	success: boolean,
	message: string?,
	result: a,
	metadata: DataStoreKeyInfo?,
}

export type PageResult = Result<DataStoreKeyPages?>
export type DataStoreResult = Result<GlobalDataStore?>
export type OrderedDataStoreResult = Result<OrderedDataStore?>
export type SaveResult = Result<boolean?>

export type BaseData = {
	saveStatus: "Saving" | "Failed" | "Ready" | "NotReady",
	loadStatus: "Loading" | "Failed" | "Ready",
	canSave: boolean,
	data: any,
}
export type DataResult = Result<any>

export type BaseStorage = {
	LoadRetry: Signal.Signal<string, string, string?, string>,
	LoadFail: Signal.Signal<string, string, string?, string>,
	SaveStart: Signal.Signal<string>,
	SaveRetry: Signal.Signal<string, string, string?, string>,
	SaveFail: Signal.Signal<string, string, string?, string>,
	SaveSuccess: Signal.Signal<string>,
	FilledBlankStorage: Signal.Signal<string, string?, string>,
	KeyUpdated: Signal.Signal<string, string | number, any, any>,
	DeepKeyUpdated: Signal.Signal<string, any, any, {string | number}>,
	
	HardLoad: <a>(self: a, index: string) -> (DataResult),
	SoftLoad: <a>(self: a, index: string) -> (DataResult),
	HardSave: <a>(self: a, index: string, ids: {[number]: number}?, setOptions: DataStoreSetOptions?) -> (SaveResult),
	SoftSave: <a>(self: a, index: string, newData: any) -> (SaveResult),
	Update: <a>(self: a, index: string, key: (string | number), newData: any) -> (SaveResult),
	DeepUpdate: <a>(self: a, index: string, newData: any, key: (string | number), ...(string | number)) -> (SaveResult),
	Clear: <a>(self: a, index: string) -> (),
	Close: <a>(self: a) -> (),
}
export type BaseStorageResult = Result<BaseStorage?>

export type PlayerStorage = {
	LoadRetry: Signal.Signal<string, string, string?, string>,
	LoadFail: Signal.Signal<string, string, string?, string>,
	SaveStart: Signal.Signal<string>,
	SaveRetry: Signal.Signal<string, string, string?, string>,
	SaveFail: Signal.Signal<string, string, string?, string>,
	SaveSuccess: Signal.Signal<string>,
	FilledBlankStorage: Signal.Signal<string, string?, string>,
	KeyUpdated: Signal.Signal<string, string | number, any, any>,
	DeepKeyUpdated: Signal.Signal<string, any, any, {string | number}>,
	
	HardLoad: <a>(self: a, index: number) -> (DataResult),
	SoftLoad: <a>(self: a, index: number) -> (DataResult),
	HardSave: <a>(self: a, index: number, setOptions: DataStoreSetOptions?) -> (SaveResult),
	SoftSave: <a>(self: a, index: number, newData: any) -> (SaveResult),
	Update: <a>(self: a, index: number, key: (string | number), newData: any) -> (SaveResult),
	DeepUpdate: <a>(self: a, index: string, newData: any, key: (string | number), ...(string | number)) -> (SaveResult),
	Clear: <a>(self: a, index: number) -> (),
	Close: <a>(self: a) -> (),
}
export type PlayerStorageResult = Result<PlayerStorage?>

export type OrderedStorage = {
	LoadRetry: Signal.Signal<string, string, string?, string>,
	LoadFail: Signal.Signal<string, string, string?, string>,
	SaveStart: Signal.Signal<string>,
	SaveRetry: Signal.Signal<string, string, string?, string>,
	SaveFail: Signal.Signal<string, string, string?, string>,
	SaveSuccess: Signal.Signal<string>,
	FilledBlankStorage: Signal.Signal<string, string?, string>,
	GetSortedAsyncRetry: Signal.Signal<string, string, string?>,
	GetSortedAsyncFail: Signal.Signal<string, string, string?>,
	
	HardLoad: <a>(self: a, index: string) -> (DataResult),
	SoftLoad: <a>(self: a, index: string) -> (DataResult),
	HardSave: <a>(self: a, index: string, ids: {[number]: number}?, setOptions: DataStoreSetOptions?) -> (SaveResult),
	SoftSave: <a>(self: a, index: string, newData: any) -> (SaveResult),
	GetPages: <a>(self: a, ascending: boolean, pageSize: number, min: number, max: number) -> (PageResult),
	Clear: <a>(self: a, index: string) -> (),
	Close: <a>(self: a) -> (),
}
export type OrderedStorageResult = Result<OrderedStorage?>
export type StorageResult = Result<((PlayerStorage | BaseStorage)?)>
export type BaseResult = Result<((GlobalDataStore | OrderedDataStore)?)>


return {}
