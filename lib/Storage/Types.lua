--!strict
local Signal = require(script.Parent.Parent:WaitForChild("Signal"))

export type StorageType = "Player" | "Base" | "Ordered"
export type Default = {[string]: any}
export type PageResult = Result<DataStoreKeyPages?>

type Result<a> = {
	success: boolean,
	message: string?,
	result: a,
	metadata: DataStoreKeyInfo?,
}

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


return {}