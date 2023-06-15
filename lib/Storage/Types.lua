--!strict
local SimpleFunction = require(script.Parent.Parent:WaitForChild("SimpleFunction"))
local Signal = require(script.Parent.Parent:WaitForChild("Signal"))


type SimpleFunction<a..., b...> = SimpleFunction.SimpleFunction<a..., b...>
type Signal<a...> = Signal.Signal<a...>


--[=[
	@type StorageType "Player" | "Base" | "Ordered"
	The type of DataStore; Player contains specific functionality used for players, Ordered creates a OrderedDataStore,
		and Base creates a general-purpose DataStore.
	
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
	@type StorageResult Result<(OrderedStorage | PlayerStorage | BaseStorage)?>
	A dictionary containing a success boolean, a message (if getting the DataStore fails), and a result (if getting the
		DataStore succeeds, this is the Storage object).
	
	@within Storage
]=]

export type DataStoreErrorCode =
	"D101" | -- Key cannot be empty.
	"D102" | -- Key name exceeds the 50 character limit.
	"D103" | -- Type is not allowed in DataStore.
	"D104" | -- Type is not allowed in DataStore.
	"D105" | -- Serialized value converted byte size exceeds max size 64*1024 bytes.
	"D301" | -- GetAsync queue is full, a request has been dropped.
	"D302" | -- SetAsync queue is full, a request has been dropped.
	"D303" | -- IncrementAsync queue is full, a request has been dropped.
	"D304" | -- UpdateAsync queue is full, a request has been dropped.
	"D306" | -- RemoveAsync queue is full, a request has been dropped.
	"D401" | -- Datamodel is not accessible because the game is being shut down.
	"D402" | -- LuaWebService is not accessible because the game is being shut down.
	"D403" | -- Cannot write to DataStore from Studio if API access is not enabled.
	"D501" | -- Can't parse response, data may be corrupted.
	"D502" | -- API Services rejected request.
	"D503" | -- DataStore Request successful, but key not found.
	"D504" | -- Datastore Request successful, but the response was not formatted correctly.
	"D511" | -- Metadata attribute size exceeds 300 bytes limit.
	"D512" | -- UserID size exceeds limit of 4.
	"D513"   -- Attribute userId or metadata format is invalid.

export type LoadingErrorCode =
	"L101" | -- Data failed to load (loadStatus was Failed)
	"L102"   -- No data has been loaded for this index yet.

export type SavingErrorCode =
	"S101" | -- Data could not be saved (saveStatus was NotReady)
	"S102" | -- Data could not be saved (saveStatus was Failed)
	"S103" | -- No data has been loaded for this index yet, or canSave was false.
	"S104"   -- Data is already being saved

export type ErrorCode = DataStoreErrorCode | LoadingErrorCode | SavingErrorCode


type StringOrNumber = string | number
export type StorageType = "Player" | "Base" | "Ordered"
export type Default = {[StringOrNumber]: any}

type Result<a> = {
	success: boolean,
	message: string?,
	result: a,
	code: ErrorCode?,
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
	LoadSuccess: Signal<string>,
	LoadRetry: Signal<string, string, string?, string>,
	LoadFail: Signal<string, string, string?, string>,
	SaveStart: Signal<string>,
	SaveRetry: Signal<string, string, string?, string>,
	SaveFail: Signal<string, string, string?, string>,
	SaveSuccess: Signal<string>,
	FilledBlankStorage: Signal<string, string?, string>,
	KeyUpdated: Signal<string, StringOrNumber, any, any>,
	DeepKeyUpdated: Signal<string, any, any, {StringOrNumber}>,
	MiscMessage: Signal<ErrorCode, string, string>,
	VerifyData: SimpleFunction<(string, Default, Default, string), (Default?)>,
	
	HardLoad: (self: BaseStorage, index: string) -> (DataResult),
	SoftLoad: (self: BaseStorage, index: string) -> (DataResult),
	HardSave: (self: BaseStorage, index: string, ids: {number}?, setOptions: DataStoreSetOptions?, context: string) -> (SaveResult),
	SoftSave: (self: BaseStorage, index: string, newData: any) -> (SaveResult),
	Update: (self: BaseStorage, index: string, key: StringOrNumber, newData: any) -> (SaveResult),
	DeepUpdate: (self: BaseStorage, index: string, newData: any, key: StringOrNumber, ...StringOrNumber) -> (SaveResult),
	Clear: (self: BaseStorage, index: string, context: string) -> (),
	Close: (self: BaseStorage) -> (),
}
export type BaseStorageResult = Result<BaseStorage?>

export type PlayerStorage = {
	LoadSuccess: Signal<string>,
	LoadRetry: Signal<string, string, string?, string>,
	LoadFail: Signal<string, string, string?, string>,
	SaveStart: Signal<string>,
	SaveRetry: Signal<string, string, string?, string>,
	SaveFail: Signal<string, string, string?, string>,
	SaveSuccess: Signal<string>,
	FilledBlankStorage: Signal<string, string?, string>,
	KeyUpdated: Signal<string, StringOrNumber, any, any>,
	DeepKeyUpdated: Signal<string, any, any, {StringOrNumber}>,
	MiscMessage: Signal<ErrorCode, string, string>,
	VerifyData: SimpleFunction<(string, Default, Default, string), (Default?)>,
	
	HardLoad: (self: PlayerStorage, index: number) -> (DataResult),
	SoftLoad: (self: PlayerStorage, index: number) -> (DataResult),
	HardSave: (self: PlayerStorage, index: number, setOptions: DataStoreSetOptions?, context: string) -> (SaveResult),
	SoftSave: (self: PlayerStorage, index: number, newData: any) -> (SaveResult),
	Update: (self: PlayerStorage, index: number, key: StringOrNumber, newData: any) -> (SaveResult),
	DeepUpdate: (self: PlayerStorage, index: string, newData: any, key: StringOrNumber, ...StringOrNumber) -> (SaveResult),
	Clear: (self: PlayerStorage, index: number, context: string) -> (),
	Close: (self: PlayerStorage) -> (),
}
export type PlayerStorageResult = Result<PlayerStorage?>

export type OrderedStorage = {
	LoadSuccess: Signal<string>,
	LoadRetry: Signal<string, string, string?, string>,
	LoadFail: Signal<string, string, string?, string>,
	SaveStart: Signal<string>,
	SaveRetry: Signal<string, string, string?, string>,
	SaveFail: Signal<string, string, string?, string>,
	SaveSuccess: Signal<string>,
	FilledBlankStorage: Signal<string, string?, string>,
	GetSortedAsyncRetry: Signal<string, string, string?>,
	GetSortedAsyncFail: Signal<string, string, string?>,
	
	HardLoad: (self: OrderedStorage, index: string) -> (DataResult),
	SoftLoad: (self: OrderedStorage, index: string) -> (DataResult),
	HardSave: (self: OrderedStorage, index: string, ids: {number}?, setOptions: DataStoreSetOptions?) -> (SaveResult),
	SoftSave: (self: OrderedStorage, index: string, newData: any) -> (SaveResult),
	GetPages: (self: OrderedStorage, ascending: boolean, pageSize: number, min: number, max: number) -> (PageResult),
	Clear: (self: OrderedStorage, index: string) -> (),
	Close: (self: OrderedStorage) -> (),
}
export type OrderedStorageResult = Result<OrderedStorage?>
export type StorageResult = Result<((OrderedStorage | PlayerStorage | BaseStorage)?)>
export type BaseResult = Result<((GlobalDataStore | OrderedDataStore)?)>


return {}